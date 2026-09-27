# Public-site release handoff

This branch prepares the authorized September 27, 2026 coming-soon release.
See [DEPLOYMENT.md](DEPLOYMENT.md) for transport, credentials, DNS/TLS, and rollback.
The actual launch result is recorded separately after verification.

The Rails app has no database. Production uses PUBLIC_SITE_COMING_SOON=1 and
never contacts the unfinished publishing feed. Development can still exercise
the public consumer; its tests and contract are retained for later work.

The original development checkout contains unrelated design/research work that
was deliberately left outside this release. See [RELEASE_SCOPE.md](RELEASE_SCOPE.md).
