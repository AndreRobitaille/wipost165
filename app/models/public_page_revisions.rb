require "open3"

# Last change of each public page, taken from the commit that last edited its
# templates. Production images do not include git history, so they use the
# recorded commit times below. Those times are checked against git in test.
class PublicPageRevisions
  LAYOUTS = {
    "v1" => "app/views/layouts/public_site_v1.html.erb",
    "v2" => "app/views/layouts/application.html.erb"
  }.freeze
  PAGES = {
    "v1" => {
      "/" => %w[app/views/public_site/home_v1.html.erb],
      "/why-the-legion" => %w[app/views/public_site/why_legion.html.erb],
      "/events" => %w[app/views/public_site/events_v1.html.erb],
      "/visit" => %w[app/views/public_site/visit_v1.html.erb],
      "/about" => %w[app/views/public_site/about.html.erb],
      "/contact" => %w[app/views/public_site/contact_v1.html.erb],
      "/membership" => %w[app/views/public_site/membership.html.erb app/views/public_site/_public_contact_links.html.erb],
      "/veteran-help" => %w[app/views/public_site/help.html.erb app/views/public_site/_public_contact_links.html.erb]
    }.freeze,
    "v2" => {
      "/" => %w[app/views/public_site/home.html.erb],
      "/why-the-legion" => %w[app/views/public_site/why_legion.html.erb],
      "/events" => %w[app/views/public_site/events.html.erb],
      "/visit" => %w[app/views/public_site/visit.html.erb],
      "/about" => %w[app/views/public_site/about.html.erb],
      "/contact" => %w[app/views/public_site/contact.html.erb],
      "/membership" => %w[app/views/public_site/membership.html.erb app/views/public_site/_public_contact_links.html.erb],
      "/veteran-help" => %w[app/views/public_site/help.html.erb app/views/public_site/_public_contact_links.html.erb]
    }.freeze
  }.freeze
  COMING_SOON_FILES = %w[app/views/public_site/coming_soon.html.erb].freeze
  SNAPSHOT = {
    "v1" => {
      "/" => "2026-11-13T14:48:46Z",
      "/why-the-legion" => "2026-11-13T14:48:46Z",
      "/events" => "2026-11-13T14:48:46Z",
      "/visit" => "2026-11-13T14:48:46Z",
      "/about" => "2026-11-13T14:48:46Z",
      "/contact" => "2026-11-13T14:48:46Z",
      "/membership" => "2026-11-13T14:48:46Z",
      "/veteran-help" => "2026-11-13T14:48:46Z"
    }.freeze,
    "v2" => {
      "/" => "2026-11-13T14:48:46Z",
      "/why-the-legion" => "2026-11-13T14:48:46Z",
      "/events" => "2026-11-13T14:48:46Z",
      "/visit" => "2026-11-13T14:48:46Z",
      "/about" => "2026-11-13T14:48:46Z",
      "/contact" => "2026-11-13T14:48:46Z",
      "/membership" => "2026-11-13T14:48:46Z",
      "/veteran-help" => "2026-11-13T14:48:46Z"
    }.freeze,
    "coming_soon" => "2026-10-07T17:30:11Z"
  }.freeze

  def self.at(edition, path = nil)
    recorded = path ? SNAPSHOT.fetch(edition).fetch(path) : SNAPSHOT.fetch(edition)
    git_time(files_for(edition, path)) || Time.iso8601(recorded)
  end

  def self.files_for(edition, path = nil)
    return COMING_SOON_FILES if edition == "coming_soon"

    PAGES.fetch(edition).fetch(path) + [ LAYOUTS.fetch(edition) ]
  end

  def self.git_repository?
    return @git_repository if defined?(@git_repository)

    _output, status = Open3.capture2("git", "-C", Rails.root.to_s, "rev-parse", "--is-inside-work-tree")
    @git_repository = status.success?
  end

  def self.git_time(files)
    return unless git_repository?

    @git_times ||= {}
    @git_times[files.join("\0")] ||= files.filter_map { |file| commit_time(file) }.max
  end

  def self.commit_time(file)
    output, status = Open3.capture2("git", "-C", Rails.root.to_s, "log", "-1", "--format=%cI", "--", file)
    return unless status.success?

    text = output.strip
    Time.iso8601(text) if text.present?
  end
  private_class_method :commit_time
end
