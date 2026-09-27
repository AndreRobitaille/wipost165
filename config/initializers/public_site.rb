# Production never substitutes sample content for an empty/unavailable feed.
Rails.application.config.x.public_site_preview = !Rails.env.production? && ENV.fetch("PUBLIC_SITE_PREVIEW", Rails.env.development? ? "1" : "0") == "1"
# Owner-supplied public source and review date: docs/launch-content-readiness.md.
# An explicit blank override hides that channel until a replacement is ready.
Rails.application.config.x.public_contact_email = ENV.fetch("PUBLIC_CONTACT_EMAIL", "wipost165@gmail.com").presence
Rails.application.config.x.public_contact_phone = ENV.fetch("PUBLIC_CONTACT_PHONE", "(920) 860-7478").presence
Rails.application.config.x.publisher_origin = ENV.fetch("PUBLISHER_ORIGIN", "https://members.wipost165.org")

Rails.application.config.x.public_site_coming_soon = ENV["PUBLIC_SITE_COMING_SOON"] == "1"
