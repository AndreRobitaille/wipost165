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
    @portrait = if sample
      data.fetch("portrait")
    else
      Rails.application.routes.url_helpers.published_portrait_path(id: slug, revision: data.fetch("portrait").fetch("revision"), size: "large")
    end
    @portrait_alt = sample ? "Placeholder portrait for #{name}, not a Post member" : data.fetch("portrait").fetch("alt")
  end

  def to_param = slug
  def sample? = @sample
end
