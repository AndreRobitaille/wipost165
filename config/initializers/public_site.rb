# Production never substitutes sample content for an empty/unavailable feed.
Rails.application.config.x.public_site_preview = !Rails.env.production? && ENV["PUBLIC_SITE_PREVIEW"] == "1"
# V1 is the practical public launch; V2 preserves the people experience for review.
edition = ENV.fetch("PUBLIC_SITE_EDITION", "v1")
raise ArgumentError, "PUBLIC_SITE_EDITION must be v1 or v2" unless %w[v1 v2].include?(edition)
Rails.application.config.x.public_site_edition = edition
# Owner-supplied public source and review date: docs/launch-content-readiness.md.
# An explicit blank override hides that channel until a replacement is ready.
Rails.application.config.x.public_contact_email = ENV.fetch("PUBLIC_CONTACT_EMAIL", "wipost165@gmail.com").presence
Rails.application.config.x.public_contact_phone = ENV.fetch("PUBLIC_CONTACT_PHONE", "(920) 860-7478").presence
Rails.application.config.x.publisher_origin = ENV.fetch("PUBLISHER_ORIGIN", "https://members.wipost165.org")

Rails.application.config.x.public_site_coming_soon = ENV["PUBLIC_SITE_COMING_SOON"] == "1"
# Enable only after content and accessible routes for the selected edition are reviewed.
Rails.application.config.x.public_site_launch_ready = Rails.env.production? && ENV["PUBLIC_SITE_LAUNCH_READY"] == "1"
