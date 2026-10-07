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

The root page defaults to the practical V1 launch first pass. The original full
“In good company” people experience is preserved as V2. To compare locally:

```sh
PUBLIC_SITE_EDITION=v1 bin/rails server -b 127.0.0.1 -p 3001
PUBLIC_SITE_EDITION=v2 bin/rails server -b 127.0.0.1 -p 3002
```

Edition is selected at startup, never by URL/query input. V1 uses only events,
does not load featured people or recognition context, and returns 404 on direct
story/portrait routes without contacting the publisher. Its production asset
build excludes local sample artwork in `app/assets/preview`. V2 retains the
original layout, people routes, and consent/withdrawal requirements.

Development
uses the real publishing client by default. Set `PUBLIC_SITE_PREVIEW=1` only to
use the offline labelled sample introductions/events. Production always disables preview even
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
For ordinary local startup, store the same read-only website token under that
key in development credentials with
`VISUAL=nvim EDITOR=nvim bin/rails credentials:edit --environment development`.
Development reads `config/credentials/development.yml.enc`; its matching
`development.key` and encrypted development file stay local and ignored.
It does not load production credentials.
Restart the dev server after changing credentials or preview configuration.
`PUBLIC_CONTACT_EMAIL` and `PUBLIC_CONTACT_PHONE` default to the public channels
from the [owner-supplied source](launch-content-readiness.md). Environment values
override them; an explicit blank hides that channel. With both blank, the contact
page keeps the mailing address and explains that email/phone are unavailable.
It does not pretend to send messages. Dates use the feed's timezone; interval requests use this Post's
America/Chicago calendar date.

## Content and caching

The people/portrait details below describe V2. V1 shares the authenticated event
client and practical pages, without invoking people/story/portrait reads.

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
V1 calendar cards open fresh details in a native dialog using the `event-details`
Turbo frame. Success, 404, 503, and render-time expiry all return that frame for
modal requests. Direct URLs and JavaScript-disabled links still render full event
pages. Hover prefetch is disabled on these cards so a full-page response cannot
be substituted for the modal fragment. Closing clears the frame; reopening reads
through the same authenticated client and freshness checks.
If content expires while other request work is running, the page is replaced with
an unavailable state rather than returning expired dynamic content.

## Verification

### Indexing and sharing during development

Development always uses neutral Post metadata and `noindex, nofollow, nosnippet,
noimageindex`, including when consuming the live publisher with preview off.
`PUBLIC_SITE_LAUNCH_READY=1` takes effect only in production. The deployment
configuration keeps it at `0`; coming-soon and static preview also override it.
This setting does not change which feed is read or hide the local page body.

After the selected edition's final content review, the authorized release sets
`PUBLIC_SITE_COMING_SOON=0` and `PUBLIC_SITE_LAUNCH_READY=1`. Successful pages then
emit page-specific titles/descriptions and text sharing metadata. Canonical and
Open Graph URLs use `https://wipost165.org` on both public hostnames and omit query
parameters, including optional V2 recognition context. Missing/unavailable pages and
portrait errors remain noindex. Valid empty collections can be indexed at launch.
No member portrait is placed in social-image metadata.

Robots directives are crawler instructions, not access controls or guarantees
about third-party previews. Keep coming-soon enabled publicly until the selected
edition's content and exposed routes are reviewed. V1 keeps people routes
unavailable regardless of what story records the publisher holds; V2 requires
fictional story/portrait withdrawal before public exposure. `robots.txt` allows
crawling so crawlers can read per-response noindex rules. See the
[metadata verification note](verification/2026-09-27-launch-metadata.md) for checks
and platform limitations. Tests simulate launch readiness locally without a
production feed or personal API token.

### Commands

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
