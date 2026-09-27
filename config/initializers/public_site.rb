# Production never substitutes sample content for an empty/unavailable feed.
Rails.application.config.x.public_site_preview = !Rails.env.production? && ENV.fetch("PUBLIC_SITE_PREVIEW", Rails.env.development? ? "1" : "0") == "1"
Rails.application.config.x.public_contact_email = ENV["PUBLIC_CONTACT_EMAIL"].presence
Rails.application.config.x.public_contact_phone = ENV["PUBLIC_CONTACT_PHONE"].presence
Rails.application.config.x.publisher_origin = ENV.fetch("PUBLISHER_ORIGIN", "https://members.wipost165.org")

Rails.application.config.x.public_site_coming_soon = ENV["PUBLIC_SITE_COMING_SOON"] == "1"
