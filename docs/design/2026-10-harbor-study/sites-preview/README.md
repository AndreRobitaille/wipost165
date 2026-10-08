# Working V1 site on Sites

The owner requested the working V1 site, public without sign-in, while preserving
the people-based V2 concept. The initial static/sample-only deployment was an
incorrect interpretation; the current build replaces it with live calendar reads.

- V1: https://post165-v1-launch-preview.andretr.chatgpt.site
- Preserved V2 concept: https://post165-in-good-company.andretr.chatgpt.site
- V1 project: `appgprj_6ac6808b104481919e5be6d86d23188e`
- Current saved version (5): `appgprj_6ac6808b104481919e5be6d86d23188e~appgver_e3379b54dc7c81919dc7e00688cc830d`
- Sites source commit: `bfee8debef737f29d24ac45c1118c108591db535`
- Successful Why the Legion deployment: `appgdep_6ac7870dee9881919ee817b588398edb`, October 8, 2026; runtime secret revision 1 (unchanged).
- Rails content commit: `99f2aa8` on `codex/public-page-content` / PR #10.
- Earlier live-calendar correction: version 2, `appgdep_6ac68430e21c819193c5d8558e2d133b` (superseded by the content refresh).
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

## October 8 — Why the Legion first pass

The new [Why the Legion? page](https://post165-v1-launch-preview.andretr.chatgpt.site/why-the-legion)
explains the value of belonging before asking for a meeting visit. V1 navigation
and the homepage now link to it. The shared page also renders in V2, whose
separate published concept remains unchanged. Rails route/metadata and Sites
export/adapter tests cover the new route. The live calendar adapter and existing
server-side secret settings are unchanged.

CI passed 78 Rails tests / 934 assertions and nine adapter tests, plus style,
security, autoloading and production assets. Local browser checks passed 15
page/width combinations: the new page in both editions and V1 Home at
1440/900/700/390/320px. No overflow or missing images; keyboard focus and activation
and 200% root-text reflow passed. No new screenshots. The generated page and
homepage links were checked before packaging. Sites version 5 reported successful
publication at 12:05 UTC on October 8, with runtime secret revision 1 unchanged.

## October 7 — clarify the homecoming example (version 4)

The Commander clarified that the Guard welcome-home activity happened recently
and is not routine. About now says “Members have also turned out with flags to
welcome National Guard troops home.” The source notes preserve the original
October 6 draft-minutes provenance and the Commander’s October 7 clarification.
CI passed 78 Rails tests / 902 assertions and nine adapter tests, plus all other
checks. The exported About template contains the correction. Sites version 4
reported success at 19:10 UTC with runtime secret revision 1 unchanged. No new
screenshots or hosted browser checks were needed for this one-line correction.

## October 7 — footer content refresh (version 3)

The owner authorized pushing the final PR #10 corrections and publishing them to
this existing public V1 Site before merge, without new screenshots. Rails views
were re-exported with live-calendar mode and the previously compiled V1 assets;
the Worker source and runtime settings did not change. Sites reported the version
3 deployment succeeded at 18:45 UTC, with the same public URL and secret revision.

`bin/ci` passed 78 Rails tests / 902 assertions, nine Sites adapter tests, style,
security, autoloading and production asset compilation. The first local run hit
the documented compiled-asset masking of V2 sample assets; clearing generated
assets and rerunning CI passed. Export checks confirmed the monthly meeting copy,
conditional transfer contact in the configured-contact build, distinct Community
group, visible visit link/answers, and no dues amount in Membership.
No new screenshots or hosted browser checks were taken for this copy refresh.
The prior browser evidence below describes version 2; see the
[consolidated content review](../../2026-10-footer-content/design-revision/README.md)
for the page changes and editorial provenance.

## Earlier live-calendar verification (version 2)

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
