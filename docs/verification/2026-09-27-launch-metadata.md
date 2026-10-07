# SITE-05 launch metadata — September 27, 2026

Implemented and verified locally on `main` at `c7b716e` plus existing uncommitted
development, planning, and consumer-validation changes. No production request,
publishing mutation, companion edit, commit, push, or deployment was performed.

## Behavior prepared

- Added `PUBLIC_SITE_LAUNCH_READY`, default off and honored only in production.
  The deployment file explicitly keeps it at `0` with coming-soon at `1`.
  Development and static preview stay noindex even if this variable is set to `1`.
- Before launch, head metadata contains neutral Post text instead of fictional
  names, introductions, dates, or portrait URLs. HTML uses matching robots meta
  and `X-Robots-Tag` noindex/nofollow/nosnippet/noimageindex instructions; portrait
  responses use noindex/noimageindex. Existing no-store behavior remains.
- Once launch readiness is enabled and coming-soon is disabled, successful pages
  get individual titles/descriptions and Open Graph/Twitter text metadata.
  Introduction descriptions use bounded approved introduction text. Event
  metadata includes its public date/location, with cancellation stated first.
  Authored text remains escaped in HTML attributes.
- Both hostnames identify `https://wipost165.org` as canonical. Canonical and
  sharing URLs omit tracking parameters and remembered-person context, and do
  not derive their host from the request. This keeps both existing proxy routes;
  it introduces no www redirect or infrastructure change.
- 404 and 503 pages get accurate neutral error metadata without a canonical URL.
  Home/calendar feed outages also remain noindex even where static content returns
  200. A valid empty calendar remains eligible for indexing after launch.
- Content expiring during page assembly loses its detail metadata along with
  its rendered content. Coming-soon headers are set before its early render;
  ordinary after-action callbacks are skipped by that render.

No member portrait is promoted as a social image. This is text metadata, not a
completed branded image-card design. Platforms may use their own fallback images,
cache previews, or disregard robots instructions. No claim is made that a local
noindex page is private or that every sharing service will honor these tags.
The public coming-soon page remains the barrier to exposing fictional content;
real editorial material and removal of fictional details/portraits come last.

## Verification

Added ten [metadata integration tests](../../test/integration/public_metadata_test.rb)
for live-feed preparation, preview/coming-soon overrides, apex/www canonical URLs,
query/host independence, text escaping and length, cancelled events, missing and
unavailable details, valid empty versus unavailable calendars, render-time expiry,
and portrait indexing through GET/HEAD and 404. Tests inject synthetic publisher
responses; launch state is simulated without editorial access or network calls.

The initial focused run caught the coming-soon early-render header issue and an
incomplete response queue in a new test; both were corrected. The focused page,
portrait, coming-soon, and metadata run then passed 30 tests / 414 assertions.
The additional empty/outage calendar case was included in the full CI run.

`PARALLEL_WORKERS=1 bin/ci` passed:

- 63 tests / 567 assertions, zero failures/errors/skips.
- 43 Ruby files linted with no offenses.
- Gem/JavaScript audits clean; Brakeman zero warnings/errors.
- Autoloading and production asset compilation passed.

Separate local Rails boot checks confirmed development ignores a launch-ready
override while production accepts the explicit setting. No feed was fetched by
these checks. Generated assets were clobbered afterward to avoid masking local
development assets; no running server was restarted. Simplify review retained
one metadata partial and one shared release predicate without adding a separate
metadata framework. Documentation links and `git diff --check` passed.

This is application-rendering/configuration verification, not a fresh browser,
container, production hostname/TLS, search-engine, or social-platform preview check.
No visible page layout was changed. The local server needs a restart to load the
new initializer; any existing server was left running for the owner.

## Launch and remaining work

The [deployment guide](../DEPLOYMENT.md#current-launch-scope) records the paired
release settings and holding-mode rollback. Enabling launch readiness is part
of the final authorized release, after content review; it must not be used to
make development samples indexable. Publishing real people/photos is still the
last content step.

Next independent work: final desktop/phone/keyboard visitor paths and broken-link
review, then local container and concrete release/rollback preparation. Reuse
existing evidence where applicable. SITE-04 companion permission/editorial/event
evidence remains pending and the full site remains unlaunched.

## Technical references checked

- [Google noindex guidance](https://developers.google.com/search/docs/crawling-indexing/block-indexing): crawlers must be allowed to retrieve a response to see its noindex rule; robots directives do not provide access control.
- [Google canonical URL guidance](https://developers.google.com/search/docs/crawling-indexing/consolidate-duplicate-urls): absolute canonical URLs identify the preferred version of equivalent pages.
- [Open Graph protocol](https://ogp.me/): page title, URL, type, and description metadata. Image-card completeness and third-party rendering are outside this text-metadata verification.
