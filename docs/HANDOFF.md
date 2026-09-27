# Public-site release handoff

## Coming-soon deployment — September 27, 2026

The coming-soon page is live on apex and www at Hetzner, with valid HTTPS on both.
Production revision: `2828f88c4df71ac5e289b28b3055c1c408de5a10` on
`codex/public-coming-soon`. Members, Two Rivers, and NixiHost mail were preserved.
See [release results](deployment/2026-09-27-coming-soon-status.md) and
[DEPLOYMENT.md](DEPLOYMENT.md). Use one persistent `bin/release session` for the
entire next release. The full publishing website remains future work.

This branch prepares the authorized September 27, 2026 coming-soon release.
See [DEPLOYMENT.md](DEPLOYMENT.md) for transport, credentials, DNS/TLS, and rollback.
The actual launch result is recorded separately after verification.

The Rails app has no database. Production uses PUBLIC_SITE_COMING_SOON=1 and
never contacts the unfinished publishing feed. Development can still exercise
the public consumer; its tests and contract are retained for later work.

The original development checkout contains unrelated design/research work that
was deliberately left outside this release. See [RELEASE_SCOPE.md](RELEASE_SCOPE.md).
