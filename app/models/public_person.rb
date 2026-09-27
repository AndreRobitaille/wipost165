# Public presentation value, never a private roster record.
class PublicPerson
  attr_reader :slug, :name, :introduction, :story, :conversation_starter, :portrait, :portrait_alt

  def initialize(data, sample: false)
    @slug = data.fetch("id")
    @name = data.fetch("display_name")
    @introduction = data.fetch("introduction")
    @story = data.fetch("story")
    @conversation_starter = data["conversation_starter"]
    @sample = sample
    @portrait = sample ? data.fetch("portrait") : data.fetch("portrait").fetch("variants").find { |variant| variant["size"] == "large" }.fetch("url")
    @portrait_alt = sample ? "Placeholder portrait for #{name}, not a Post member" : data.fetch("portrait").fetch("alt")
  end

  def to_param = slug
  def sample? = @sample
end
