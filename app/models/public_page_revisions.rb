# Calendar dates when each page's visible copy last changed.
# Update a date on purpose when that page's wording changes.
# Layout and markup edits do not move these dates.
class PublicPageRevisions
  DATES = {
    "v1" => {
      "/" => "2026-10-08",
      "/why-the-legion" => "2026-10-08",
      "/events" => "2026-10-07",
      "/visit" => "2026-10-07",
      "/about" => "2026-10-07",
      "/contact" => "2026-11-13",
      "/membership" => "2026-10-28",
      "/veteran-help" => "2026-10-28"
    }.freeze,
    "v2" => {
      "/" => "2026-09-27",
      "/why-the-legion" => "2026-10-08",
      "/events" => "2026-09-27",
      "/visit" => "2026-09-27",
      "/about" => "2026-10-07",
      "/contact" => "2026-11-13",
      "/membership" => "2026-10-28",
      "/veteran-help" => "2026-10-28"
    }.freeze
  }.freeze
  COMING_SOON = "2026-09-27"

  def self.at(edition, path = nil)
    text = path ? DATES.fetch(edition).fetch(path) : COMING_SOON
    Date.iso8601(text)
  end
end
