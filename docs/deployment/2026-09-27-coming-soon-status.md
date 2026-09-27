# September 27, 2026 coming-soon release

## Final outcome: deployed and verified

The public app runs revision `2828f88c4df71ac5e289b28b3055c1c408de5a10` from
`codex/public-coming-soon`. Subsequent operator-documentation and release-wrapper-only commits record the
result and cleanup safeguards; they do not change the running web application.

Both https://wipost165.org and https://www.wipost165.org serve the simple
coming-soon page and members-site link with HTTP 200. Direct requests to
178.156.250.235 preserved each hostname and validated TLS normally. Both public
certificates expire December 26, 2026. HTTP redirects to the matching HTTPS
hostname with 301. Both `/up` endpoints return 200.

The public service is `legion_post_165_wi_public-web`, container `b1f32010efbf`,
with both hostnames on the existing kamal-proxy v0.9.2. The public container is
running with zero restarts. The shared proxy was not restarted: its start time
remains June 30, 2026, with zero restarts.

## Protected services and DNS

Container IDs and revisions matched the pre-deployment baseline exactly:

- Members: `ad61ba0e20c7`, revision
  `9d278b7ce449ea54d60b151b32f6e23cac97eacf`. HTTPS `/up` and `/session/new` both
  return 200; its certificate still expires December 9, 2026.
- Two Rivers: `085c9aab95a5`, revision
  `48cf3bbde3d5282666b9c1024d6b3855e824902b`. HTTPS homepage returns 200;
  certificate still expires November 4, 2026.

No DNS or mail settings were changed by this session. Before/after Google DNS
snapshots showed no record-value changes across the 20 queried record sets.
Google and Cloudflare returned apex 178.156.250.235; www remains its CNAME.
There were no AAAA or CAA conflicts in those responses. Local direct DNS queries
previously returned the old address, so this does not claim every cache expired.

MX is priority 0 to mail.wipost165.org; mail, ftp, cpcontacts, cpcalendars, cpanel,
and webmail A records remain 104.225.208.23. SPF remains
`v=spf1 mx ip4:104.225.208.23 ~all`. The four SRV records retain the requested
cpcontacts/cpcalendars targets. Full zone inventory, private cPanel Email Routing,
and unqueried SES/DKIM records were not re-inspected; all were left untouched.
No test emails were sent.

## Validation and connection discipline

- Application CI passed: 32 tests, 194 assertions, no failures/errors/skips;
  38 Ruby files linted; gem and JavaScript audits and Brakeman clean; autoload
  validation and production assets passed.
- Added offline release-lifecycle regression: 1 test, 12 assertions passed.
  It covers local-only checks, blocked standalone commands, nested-session
  rejection, and a failed setup followed by deployment using one tunnel.
- Production image built and uploaded with the existing remote Docker builder.
- Live desktop 1365x900 and mobile 390x844 browser checks passed. Keyboard focus
  and no horizontal overflow were also verified on the same page locally.
- After the user's requested five-minute cooldown (15:33:20–15:38:20 UTC), one
  successful outer SSH master was retained through preflight, a baseline-query
  repair, image build, deployment, certificate issuance, and all server checks.
  Build/deploy did not open replacement outer SSH connections.
- Final cleanup confirmed the owned master process and localhost port 22222 were
  gone. Editing the wrapper during the open session exposed a local parser error
  on exit; cleanup still succeeded. Explicit session termination and an offline
  regression now cover wrapper edits while a release shell remains open.

Earlier attempts had failed before deployment because of SSH connection churn
and a failed desktop signing agent. These are historical failures, not current
launch blockers. The release script now requires `bin/release session`; failed
commands return to its open shell. Local checks never open SSH and standalone
setup/deploy commands are disabled. `SSH_AUTH_SOCK` is unset for Kamal so it uses
the configured file key. Git signing was bypassed only for the commits expressly
authorized by the owner, without changing global settings.

## Remaining work

The complete public website and publishing feed are not launched. Production
intentionally uses `PUBLIC_SITE_COMING_SOON=1`; the unfinished feed is not called.
Disable that mode only in a separately reviewed full-site release.

The release branch and operator guide are pushed. The clean release checkout is
`/tmp/wipost165-coming-soon`; the original development checkout retains unrelated
work. The unique public-app Rails key is in ignored, mode-0600
`/home/andre/Development/wipost165/.env.production.local`; never print it.
Future releases use `docs/DEPLOYMENT.md` and one `bin/release session` from first
server inspection through final verification.
