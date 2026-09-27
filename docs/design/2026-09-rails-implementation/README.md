# Rails public consumer — September 27, 2026

The “In good company” experience now runs as ordinary Rails pages. Its distinctive
surface is the shared table and three recognizable introductions; navigation,
event details, member stories, and first-visit guidance stay within that setting.
Official Legion brand artwork and the established navy/red/white design are retained.
Portraits/names shown in preview are explicitly fictional examples, not members.

## Screenshots

- [Desktop welcome](previews/desktop.png)
- [Phone welcome](previews/mobile.png)
- [Phone story](previews/story-mobile.png)
- [Unavailable feed](previews/unavailable.png)
- [Unavailable portrait](previews/portrait-unavailable.png)

These are screenshots of the Rails implementation, not a new Sites deployment.
The previously shared Sites mockup remains unchanged.

## Verified

- Full `bin/ci`: 30 tests, 137 assertions, zero failures/errors; Ruby style,
  gem/JavaScript advisory checks, Brakeman, autoloading, and production assets pass.
- Browser inspection at 1440px desktop and 390px phone; 320px overflow check passes.
  Story, first-visit, and feed-unavailable pages render. Skip-link keyboard activation
  focuses the main content; native FAQ controls open with Enter. Reduced motion is
  honored. A forced image failure displays a neutral fallback without broken layout.
  No browser JavaScript errors were reported in the final checked flows.
- The application tests cover zero through three introductions, detail withdrawal,
  cache age/304/error handling, interval boundaries/DST, all-day events, cancellation,
  expired content during a request, and returning visitors with session cookies.
- Production-mode Puma smoke: `/up`, `/`, `/events`, `/visit`, and a returning `/`
  request succeed without a database; HTML is no-store. Preview stays disabled
  despite setting `PUBLIC_SITE_PREVIEW=1`. An intentionally unreachable publisher
  shows the calendar-unavailable state. A bogus DATABASE_URL is never opened.
- ShellCheck and shell parsing pass for the release/entrypoint scripts. Kamal
  parses this app's configuration with dummy credentials; no remote command ran.

Browser QA found Rails 8.1 passing positional options to JSON decoding while
JSON 3 requires keywords. JSON is pinned to the compatible 2.21 series, at least
2.21.2. The regression test uses a real CSRF/session cookie on a returning request;
all final advisory checks pass with the pinned dependency.

## Remaining boundaries

The public consumer is ready for companion integration. A read-only
`bin/publisher-check` against members.wipost165.org returned HTTP 404: the v1 feed
is not available yet. The companion repo was left unchanged at `9d278b7`.
Publishing grants, real consented profiles/photos/events, and verified public
contact details remain launch requirements. The site intentionally has no public
editor, database, upload endpoint, or member authentication.

Docker image build/boot could not be checked because access to the local Docker
socket was denied, including outside the sandbox. Production Rails boot is verified;
that is not container verification. Hetzner transport, DNS/TLS, actual remote image
build, live content and portrait revocation, and cutover/rollback still need their
own deployment-stage checks. Nothing was committed, pushed, or deployed.
