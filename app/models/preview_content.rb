# Entirely synthetic, explicit development preview. Never a live-feed fallback.
module PreviewContent
  def self.people
    [
      [ "frank", "Frank", "The sort of person who remembers your name the second time around.", "How did you first get involved here?" ],
      [ "ron", "Ron", "Always happy to hear where you’ve been. Usually has a story of his own.", "What keeps you coming back?" ],
      [ "jo", "Jo", "Likes getting people together. Especially when someone new comes along.", "What’s a good first event to come to?" ]
    ].map do |id, name, introduction, starter|
      PublicPerson.new({ "id" => id, "display_name" => name, "introduction" => introduction,
        "story" => "This is a placeholder for a member’s own story. Three introductions can rotate here as people share what being part of the Post means to them.",
        "conversation_starter" => starter, "portrait" => "people/sample-#{id}.jpg" }, sample: true)
    end
  end

  def self.events
    [ PublicOccasion.new({ "id" => "example-gathering", "title" => "A Post gathering",
      "description" => "A chance to meet a few people and get to know the Post. This is an example, not a scheduled event.",
      "location" => nil }, timezone: "America/Chicago") ]
  end
end
