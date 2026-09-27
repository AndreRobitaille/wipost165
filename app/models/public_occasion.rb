class PublicOccasion
  attr_reader :slug, :title, :description, :location_name, :starts_at, :ends_at, :starts_on, :ends_on_exclusive, :timezone

  def initialize(data, timezone:)
    @slug = data.fetch("id")
    @title = data.fetch("title")
    @description = data["description"]
    @location_name = data["location"]
    @timezone = timezone
    @all_day = data["all_day"]
    @cancelled = data["cancelled"]
    @starts_at = Time.iso8601(data["starts_at"]).in_time_zone(timezone) if data["starts_at"]
    @ends_at = Time.iso8601(data["ends_at"]).in_time_zone(timezone) if data["ends_at"]
    @starts_on = Date.iso8601(data["starts_on"]) if data["starts_on"]
    @ends_on_exclusive = Date.iso8601(data["ends_on_exclusive"]) if data["ends_on_exclusive"]
  end

  def to_param = slug
  def cancelled? = @cancelled == true
  def all_day? = @all_day == true
  def date = starts_on || starts_at&.to_date

  def past?
    today = Time.current.in_time_zone(timezone).to_date
    if all_day?
      (ends_on_exclusive || starts_on + 1) <= today
    else
      starts_at.present? && (ends_at || starts_at).to_date < today
    end
  end
end
