# Local development

For what to build, use [ROADMAP](ROADMAP.md). Read [PURPOSE](PURPOSE.md) and
[UI/UX and visual guidance](UI_UX_GUIDE.md) before shaping public features; this
document covers runtime, data consumption, and verification commands.

Ruby 4.0.6, Rails 8.1, Propshaft, Hotwire/importmap. This is a database-free public
consumer of the reviewed [publishing contract](public-publishing-api-v1.md).
There is no public-site editor, login system, upload endpoint, database connection,
or background worker. The earlier development databases were not dropped; the
application no longer opens them and `bin/setup` does not run migrations.

```sh
bundle install
bin/setup --skip-server
bin/rails server -b 0.0.0.0 -p 3001
```

The root page is the working “In good company” public experience. Development
uses labelled synthetic introductions/events by default. Set `PUBLIC_SITE_PREVIEW=0`
to exercise the real publishing client. Production always disables preview even
if that variable is accidentally set to 1. A visitor cannot enable preview through
a query parameter. Missing published content never falls back to the sample people.

`PUBLISHER_ORIGIN` defaults to `https://members.wipost165.org`; it must be an HTTPS
origin without credentials, path, query, or fragment. `.env.example` documents
settings but Rails does not load it automatically. Export them before starting.
The publisher requires a Post-owned, read-only website token. Store it under
`legion_post_tools.website_token` in encrypted Rails credentials; production uses
`config/credentials/production.yml.enc` with its matching key supplied through
`RAILS_MASTER_KEY`. `PUBLISHER_TOKEN` is an optional operator environment override
for development. No personal editorial token belongs in this consumer.
`PUBLIC_CONTACT_EMAIL` and `PUBLIC_CONTACT_PHONE` default to the public channels
from the [owner-supplied source](launch-content-readiness.md). Environment values
override them; an explicit blank hides that channel. With both blank, the contact
page keeps the mailing address and explains that email/phone are unavailable.
It does not pretend to send messages. Dates use the feed's timezone; interval requests use this Post's
America/Chicago calendar date.

## Content and caching

`Publishing::Transport` makes bounded, non-redirecting HTTPS requests. The client
sends the website bearer token on JSON, image, and conditional requests, and never
passes it to browsers. Cache entries are separated by origin and credential;
401 clears that credential's cached access and fails closed. The client
validates v1 JSON, interval completeness and overlap, identities, dates, and portrait
URLs before use. Portraits must match the publisher's controlled, revisioned route.
Raw HTML from stories/events is escaped. Optional conversation context survives
links between an introduction, events, the first-visit page, and contact.

Each Puma process has a bounded memory cache. Cached responses retain their
original corrected HTTP age; expiry requires publisher validation. A restart simply
refetches. There is no durable content store to migrate or back up here. A brief
10-second failure backoff reduces repeated requests during outages; it never
permits expired content to be served. Cached validators can be retained for a day
without treating their stale bodies as displayable. Known detail withdrawals clear
cached collections too. Dynamic HTML is no-store and Turbo page snapshots are
disabled. Portraits load through this site's constrained
`/people/:id/portrait/:revision/:size.webp` route. Its server fetches WebP with the
website token and the same bounded private cache; browser responses are no-store.
Images have a neutral failure state; this implementation does not perform the
optional story retry on image error.

The complete upcoming-events window is 90 days. A valid empty feed and an unavailable
feed have different messages. Unknown/withdrawn details are 404; unavailable details
are 503. Static visit/contact information remains accessible during feed outages.
If content expires while other request work is running, the page is replaced with
an unavailable state rather than returning expired dynamic content.

## Verification

```sh
bin/ci
bin/publisher-check
```

`bin/ci` runs style, gem/JS advisories, Brakeman, database-free application tests,
autoload checks, and production assets. Tests use synthetic contract fixtures and
injected HTTP responses, not the private app or its data. `bin/publisher-check` is
a separate read-only check of the configured live feed using production credentials
by default. It checks featured stories and both portraits, the upcoming collection,
and up to ten event details. It fails on missing/revoked authentication and does
not publish content. A successful empty feed verifies connectivity, not real content
readiness or portrait delivery.

After asset changes, `bin/rails assets:clobber` removes generated production assets
if a previous CI build masks development assets; restart a running development
server afterward. Do not remove another process's PID file or stop another app.

See [hosting and releases](deployment/hosting-direction.md) for Kamal setup and
[implementation preview notes](design/2026-09-rails-implementation/README.md) for
browser evidence and current launch limits.
