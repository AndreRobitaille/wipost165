# Run with PUBLIC_SITE_EDITION=v1 PUBLIC_SITE_PREVIEW=1 bin/rails runner
# script/export_site_preview.rb /absolute/path/to/an/empty/static-directory
require "fileutils"
require "nokogiri"

settings = Rails.configuration.x
unless Rails.env.development? && settings.public_site_edition == "v1" && settings.public_site_preview && !settings.public_site_coming_soon
  abort "Export requires development, V1, explicit sample preview, and coming-soon disabled."
end

destination = Pathname.new(ARGV.fetch(0))
abort "Choose an absolute, empty output directory." unless destination.absolute? && (!destination.exist? || destination.children.empty?)
assets = Rails.root.join("public/assets")
abort "Compile production V1 assets before exporting." unless assets.join(".manifest.json").file?
abort "Preview people must not be in the compiled assets." if assets.glob("**/*").any? { |path| path.basename.to_s.start_with?("sample-") }

# One dated, explicitly fictional invitation demonstrates the calendar and modal.
# This override is confined to the export process; the running app is unchanged.
date = Date.current.next_occurring(:saturday) + 14
starts_at = Time.find_zone!("America/Chicago").local(date.year, date.month, date.day, 12)
sample_event = PublicOccasion.new({
  "id" => "example-gathering",
  "title" => "A Post gathering",
  "description" => "A chance to meet a few people and get to know the Post. This invitation and its date are examples, not a scheduled event.",
  "starts_at" => starts_at.iso8601,
  "ends_at" => (starts_at + 2.hours).iso8601
}, timezone: "America/Chicago")
PreviewContent.define_singleton_method(:events) { [ sample_event ] }

session = ActionDispatch::Integration::Session.new(Rails.application)
session.host! "localhost"
routes = %w[/ /events /visit /contact /about /membership /veteran-help] + [ "/events/#{sample_event.slug}" ]
FileUtils.mkdir_p(destination)

routes.each do |route|
  session.get(route)
  abort "Could not render #{route}: #{session.response.status}" unless session.response.status == 200

  document = Nokogiri::HTML5(session.response.body)
  abort "Sample label missing from #{route}." unless document.at_css(".preview-note")
  abort "Unexpected people route in #{route}." if document.css('a[href^="/people"], img[src*="sample-"]').any?
  document.css('meta[name="csrf-token"], meta[name="csrf-param"]').remove

  # Static hosts return the same document for a normal link and a Turbo request.
  # Include the frame in full event pages so the existing dialog can extract it.
  if route.start_with?("/events/")
    details = document.at_css(".launch-event-detail")
    frame = Nokogiri::XML::Node.new("turbo-frame", document)
    frame["id"] = "event-details"
    details.add_previous_sibling(frame)
    frame.add_child(details.unlink)
    heading = details.at_css("h1")
    heading["tabindex"] = "-1"
    heading["data-event-dialog-target"] = "heading"
  end

  # Explicit .html URLs work on any static host and preserve no-JavaScript links.
  document.css("a[href]").each do |link|
    path = link["href"]
    link["href"] = "#{path}.html" if routes.include?(path) && path != "/"
  end

  filename = route == "/" ? "index.html" : "#{route.delete_prefix('/')}.html"
  output = destination.join(filename)
  FileUtils.mkdir_p(output.dirname)
  output.write(document.to_html)
end

FileUtils.mkdir_p(destination.join("assets"))
assets.children.reject { |path| path.basename.to_s.start_with?(".") }.each do |path|
  FileUtils.cp_r(path, destination.join("assets"))
end
destination.join("robots.txt").write("User-agent: *\nDisallow:\n")
puts "Exported #{routes.length} V1 pages and public assets with sample-only calendar data."
