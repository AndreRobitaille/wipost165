# Facts already published on the public pages. Machine-readable files are built
# from these values and from the event feed, not from a separate static copy.
class PublicPost
  NAME = "Robert E. Burns American Legion Post 165"
  LOCALITY = "Two Rivers, WI"
  # The Post's previous public site. Requests to that domain forward here.
  PREVIOUS_DOMAIN = "wiamericanlegionpost165.org"
  FACEBOOK_URL = "https://www.facebook.com/wiPost165"
  PARENT_NAME = "The American Legion"
  PARENT_URL = "https://www.legion.org/"
  # Guests and children line shown on every event page.
  ATTENDANCE_NOTE = "Please check with the Post before making plans."
  PUBLIC_EVENT_CATEGORY = "public_event"
  MEETING_SCHEDULE = "First Tuesday of each month at 6:30 p.m."
  MEETING_NAME = "Manitowoc Rifle & Pistol Club"
  MEETING_STREET = "7227 Sandy Hill Ln"
  MEETING_LOCALITY = "Two Rivers"
  MEETING_REGION = "WI"
  MEETING_POSTAL = "54241"
  MAILING_STREET = "PO Box 11"
  MAILING_LOCALITY = "Two Rivers"
  MAILING_REGION = "WI"
  MAILING_POSTAL = "54241"

  def self.email
    value = Rails.configuration.x.public_contact_email.to_s
    value if value.match?(URI::MailTo::EMAIL_REGEXP) && !value.match?(/[\r\n]/)
  end

  def self.meeting_summary
    "#{MEETING_SCHEDULE} at the #{MEETING_NAME}, #{MEETING_STREET}, #{MEETING_LOCALITY}, #{MEETING_REGION} #{MEETING_POSTAL}"
  end

  def self.mailing_summary
    "#{MAILING_STREET}, #{MAILING_LOCALITY}, #{MAILING_REGION} #{MAILING_POSTAL}"
  end

  def self.mailing_address
    postal_address(MAILING_STREET, MAILING_LOCALITY, MAILING_REGION, MAILING_POSTAL)
  end

  def self.meeting_place
    {
      "@type" => "Place",
      "name" => MEETING_NAME,
      "address" => postal_address(MEETING_STREET, MEETING_LOCALITY, MEETING_REGION, MEETING_POSTAL)
    }
  end

  # Honor funerals and other non-public categories never appear on the calendar
  # or in machine-readable files. A funeral title is withheld even when the
  # feed labels the record as a public event.
  def self.withheld_event?(record)
    category = record.is_a?(PublicOccasion) ? record.category.to_s : record["category"].to_s
    title = record.is_a?(PublicOccasion) ? record.title.to_s : record["title"].to_s
    Publishing::Contract::WITHHELD_EVENT_CATEGORIES.include?(category) || title.match?(/\bfunerals?\b/i)
  end

  def self.postal_address(street, locality, region, postal)
    {
      "@type" => "PostalAddress",
      "streetAddress" => street,
      "addressLocality" => locality,
      "addressRegion" => region,
      "postalCode" => postal,
      "addressCountry" => "US"
    }
  end
end
