# Working V1 site on Sites

The owner requested the working V1 site, public without sign-in, while preserving
the people-based V2 concept. The initial static/sample-only deployment was an
incorrect interpretation; the current build replaces it with live calendar reads.

- V1: https://post165-v1-launch-preview.andretr.chatgpt.site
- Preserved V2 concept: https://post165-in-good-company.andretr.chatgpt.site
- V1 project: `appgprj_6ac6808b104481919e5be6d86d23188e`
- Corrected saved version: `appgprj_6ac6808b104481919e5be6d86d23188e~appgver_aa1b84f34a1481919c6da4a178b98949`
- Sites source commit: `cb581dd3a7e00a00d11d7d308521815d61435568`
- Successful corrected deployment: `appgdep_6ac68430e21c819193c5d8558e2d133b`, runtime secret revision 1.
- Local Site checkout: `tmp/sites-v1-preview` (ignored by the Rails repository).
- Original sample-only deployment: version 1, `appgdep_6ac6813c3d4881918d15652c6d8b5176` (superseded).

## What is shared

The actual Rails V1 design, copy, assets, navigation and browser interactions,
including the harbor illustration, current visit/meeting panel, contact design,
three footer pages and event modal. Sites runs Cloudflare Workers, so a small
server adapter supplies the public calendar while generated Rails views supply
all HTML. The Rails app remains the source of truth for design and content.

The calendar reads the same live, authenticated, published events feed. It does
not embed a calendar snapshot or invent dates. On October 7 the feed contained
five events, beginning with the October 24 Old Glory Honor Flight fundraiser.
Dates are formatted in the feed's timezone, including the November DST change.
Normal URLs and direct event pages work without JavaScript; with JavaScript,
event cards open a fresh Turbo frame in the existing native dialog.

`PUBLISHER_TOKEN` is configured as a **secret** through Sites runtime settings.
It is the Post-owned read-only website credential, not a personal editorial token.
It is sent only from the server to the fixed public publishing endpoint. No AI
API key is needed. No credentials, source member records, portraits, or private
fields are exported. Each event request is bounded, schema-validated and checked
against the publisher's remaining freshness budget. No responses are retained in
a shared/server calendar cache; HTML is no-store and noindex. Upstream failure
shows unavailable copy, never fictional events. Static visit/contact information
remains accessible.

## Refresh procedure

Open the existing V1 checkout through the Sites workflow before editing; restore
it from its Sites source repository if absent. Preserve the project ID above.
From the Rails repository:

```sh
PUBLIC_SITE_EDITION=v1 RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
PUBLIC_SITE_EDITION=v1 PUBLIC_SITE_PREVIEW=0 PUBLIC_SITE_COMING_SOON=0 bin/rails runner script/export_site_preview.rb /absolute/path/to/sites-checkout
node /absolute/path/to/sites-checkout/build.mjs
```

The exporter refuses sample mode and compiled sample portraits. It makes no
publisher requests: sentinel records generate reusable fragments from the actual
Rails views, including cancellation/past/empty/error states. It replaces only the
selected checkout's generated `dist` and adapter files, preserving its identity.
Never copy Rails credentials, keys or the full Rails checkout into the Site.

Run the Sites workflow to push source and package the Worker (`dist/server/index.js`)
and assets (`dist/client`). Save that exact commit/archive and deploy it to this
same public Site. Preserve its server-side secret. A new deployment applies any
runtime-secret changes. Calendar publications update on the next request; Rails
copy/design changes need a new export and deployment. No automation is necessary.

Run `bin/rails assets:clobber` afterward if compiled assets mask development/V2
assets, as described in development guidance.

## Verification

- Full `bin/ci` passed: Rails 76 tests / 738 assertions, nine Sites adapter tests,
  Ruby style, security checks, autoloading and production assets.

- Nine adapter tests cover authentication isolation, fixed-origin/path access,
  private-field exclusion, escaped event text, real route/modal semantics,
  cancellation, past/all-day/DST dates, empty versus unavailable, malformed and
  stale responses, bounded bodies, expiry during response reading, and withdrawal.
- Browser comparison checks eight routes at 1440, 390 and 320px against the live
  Rails app: identical text, navigation, CSS asset URLs and headline typography;
  no horizontal overflow, missing images or sample labels. Calendar dialog opens
  without navigation, focuses its heading, closes with Escape and restores focus.
  Current captures/results are in [working-site](working-site/).
- Hosted regression check: `/`, `/events`, `/visit` and `/contact` return 200;
  all five real event titles and the October 24 date are present, with no sample
  banner. Stylesheets/logo match local artifact hashes; the event detail endpoint
  returns the requested modal frame. Dynamic HTML remains no-store.
- Earlier captures in this directory's root document the rejected sample export.
  They are historical, not evidence for the working deployment.

The V2 Site and actual Hetzner production service are unchanged. No SSH, Kamal,
private-data copy, publisher writes or companion-app changes are part of this work.
