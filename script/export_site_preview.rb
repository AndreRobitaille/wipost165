# PUBLIC_SITE_EDITION=v1 PUBLIC_SITE_PREVIEW=0 bin/rails runner
# script/export_site_preview.rb /absolute/path/to/sites-checkout
# Export the real Rails views as templates, never a snapshot of publisher data.
require "fileutils"
require "nokogiri"

settings = Rails.configuration.x
unless Rails.env.development? && settings.public_site_edition == "v1" && !settings.public_site_preview && !settings.public_site_coming_soon
  abort "Export requires development, V1, live-content mode, and coming-soon disabled."
end

destination = Pathname.new(ARGV.fetch(0))
manifest = destination.join(".openai/hosting.json")
abort "Choose the existing Sites checkout with its hosting manifest." unless destination.absolute? && manifest.file?
assets = Rails.root.join("public/assets")
abort "Compile production V1 assets before exporting." unless assets.join(".manifest.json").file?
abort "Preview people must not be in the compiled assets." if assets.glob("**/*").any? { |path| path.basename.to_s.start_with?("sample-") }

# These sentinels only create reusable markup. No event or credential is exported.
module SitesTemplateContent
  class << self
    attr_accessor :state, :event
  end
  self.state = :event

  def events
    @events_unavailable = SitesTemplateContent.state == :unavailable
    SitesTemplateContent.state == :event ? [ SitesTemplateContent.event ] : []
  end

  def find_event!(_id)
    raise Publishing::NotFound if SitesTemplateContent.state == :not_found
    raise Publishing::Unavailable if SitesTemplateContent.state == :unavailable
    SitesTemplateContent.event
  end

  def expired? = false
end
PublicContent.prepend(SitesTemplateContent)
PublicSiteHelper.prepend(Module.new do
  def event_time(_event) = "__SITES_when__"
end)

def template_event(state: :active, timing: :timed)
  event = PublicOccasion.new({
    "id" => "__SITES_id__", "title" => "__SITES_title__",
    "description" => "__SITES_description__", "location" => "__SITES_location__",
    "cancelled" => state == :cancelled, "all_day" => timing == :all_day,
    "starts_at" => ("2030-02-03T12:00:00-06:00" unless timing == :all_day),
    "ends_at" => ("2030-02-03T14:00:00-06:00" if timing == :with_end),
    "starts_on" => ("2030-02-03" if timing == :all_day)
  }, timezone: "America/Chicago")
  event.define_singleton_method(:upcoming?) { state == :active }
  event.define_singleton_method(:past?) { state == :past }
  event
end

session = ActionDispatch::Integration::Session.new(Rails.application)
session.host! "localhost"
render_page = lambda do |route, modal: false, status: 200|
  session.get(route, headers: modal ? { "Turbo-Frame" => "event-details" } : {})
  abort "Could not render #{route}: #{session.response.status}" unless session.response.status == status
  doc = modal ? Nokogiri::HTML5.fragment(session.response.body) : Nokogiri::HTML5(session.response.body)
  abort "Unexpected sample or people content." if doc.css('.preview-note, a[href^="/people"], img[src*="sample-"]').any?
  doc.css('meta[name="csrf-token"], meta[name="csrf-param"]').remove
  doc
end

SitesTemplateContent.event = template_event
pages = %w[/visit /contact /about /membership /veteran-help].to_h { |route| [ route, render_page.call(route).to_html ] }
templates = { "pages" => pages, "home" => {}, "calendar" => {}, "details" => {}, "errors" => {} }

home = render_page.call("/")
invitation = home.at_css(".launch-invitation")
invitation.at_css(".launch-date span").content = "__SITES_short_month__"
invitation.at_css(".launch-date strong").content = "__SITES_day__"
templates["home"]["invitation"] = invitation.to_html
invitation.replace("__SITES_invitation__")
templates["home"]["shell"] = home.to_html

calendar = render_page.call("/events")
month = calendar.at_css(".launch-month")
month["aria-labelledby"] = "month-__SITES_index__"
month.at_css("h2")["id"] = "month-__SITES_index__"
month.at_css("h2").inner_html = "__SITES_month__<span>__SITES_year__</span>"
card = month.at_css(".launch-event-card")
card.at_css(".launch-date strong").content = "__SITES_day__"
card.at_css(".launch-date small").content = "__SITES_weekday__"
templates["calendar"]["card"] = card.to_html
month.at_css(".launch-event-list").inner_html = "__SITES_cards__"
templates["calendar"]["month"] = month.to_html
templates["calendar"]["note"] = calendar.at_css(".launch-calendar-note").to_html
calendar.at_css(".launch-calendar").inner_html = "__SITES_calendar__"
templates["calendar"]["shell"] = calendar.to_html
SitesTemplateContent.event = template_event(state: :cancelled)
cancelled_card = render_page.call("/events").at_css(".launch-event-card")
cancelled_card.at_css(".launch-date strong").content = "__SITES_day__"
cancelled_card.at_css(".launch-date small").content = "__SITES_weekday__"
templates["calendar"]["cancelled_card"] = cancelled_card.to_html

%w[empty unavailable].each do |state|
  SitesTemplateContent.state = state.to_sym
  templates["home"][state] = render_page.call("/").at_css(".launch-invitation").to_html
  templates["calendar"][state] = render_page.call("/events").at_css(".launch-calendar").inner_html
end

SitesTemplateContent.state = :event
%w[active past cancelled].product(%w[all_day timed with_end], [ false, true ]).each do |state, timing, modal|
  SitesTemplateContent.event = template_event(state: state.to_sym, timing: timing.to_sym)
  page = render_page.call("/events/__SITES_id__", modal: modal)
  details = page.at_css(".launch-event-detail")
  details.at_css("time")["datetime"] = "__SITES_starts_at__" if details.at_css("time")
  details.at_css("dd small").content = "Until __SITES_until__" if details.at_css("dd small")
  details.at_css(".body-copy").inner_html = "__SITES_description_html__"
  templates["details"][[ state, timing, modal ? "modal" : "page" ].join("_")] = details.to_html
  if state == "active" && timing == "timed"
    details.replace("__SITES_details__")
    templates["details"][modal ? "modal_shell" : "page_shell"] = page.to_html
  end
end

{ not_found: 404, unavailable: 503 }.each do |state, status|
  SitesTemplateContent.state = state
  [ false, true ].each do |modal|
    templates["errors"]["#{status}_#{modal ? 'modal' : 'page'}"] = render_page.call("/events/missing", modal: modal, status: status).to_html
  end
end

# Replace only this checkout's generated build; retain its Git and Site identity.
dist = destination.join("dist")
FileUtils.rm_rf(dist)
FileUtils.mkdir_p(dist.join("client/assets"))
assets.children.reject { |path| path.basename.to_s.start_with?(".") }.each { |path| FileUtils.cp_r(path, dist.join("client/assets")) }
dist.join("client/robots.txt").write("User-agent: *\nDisallow:\n")
FileUtils.mkdir_p(destination.join("worker"))
destination.join("worker/templates.json").write(JSON.pretty_generate(templates) + "\n")
FileUtils.cp(Rails.root.join("sites/worker.mjs"), destination.join("worker/worker.mjs"))
FileUtils.cp(Rails.root.join("sites/build.mjs"), destination.join("build.mjs"))
FileUtils.cp(Rails.root.join("sites/package.json"), destination.join("package.json"))
FileUtils.cp(Rails.root.join("sites/README.md"), destination.join("README.md"))
hosting = JSON.parse(manifest.read)
hosting.delete("static")
manifest.write(JSON.pretty_generate(hosting) + "\n")
puts "Exported V1 Rails templates and public assets; calendar data loads at runtime. No publisher requests made."
