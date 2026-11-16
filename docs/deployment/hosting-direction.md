# Public-site hosting and releases

Use the [shared Hetzner deployment agreement](../SHARED_HOST_DEPLOYMENT.md) and
[current public-site deployment guide](../DEPLOYMENT.md) for operator commands.
Historical preparation and release records describe their recorded revision;
they do not establish the current production state.

The public app owns Kamal service `legion_post_165_wi_public`, image
`ghcr.io/andrerobitaille/legion-post-165-wi-public`, and hosts `wipost165.org` and
`www.wipost165.org`. Members and Two Rivers are separate services on the same VPS.
Preserve their containers, proxy routes, credentials and data.

There is no database, persistent upload volume or queue. Publication records,
images and their backups belong to LegionPostTools. This site's process-local
memory cache can be refetched; the Docker entrypoint runs without migrations.
Use only this app's Rails credentials and the Post-owned read-only website token.
V1 checks events and up to ten event details; V2 also checks people and portraits.

## Release path

Run required local checks, then an authorized push and exact-revision CI review.
Build and smoke-test the production image in GitHub Actions, publish the verified
artifact with `bin/publish-image`, and record its registry manifest digest. This
path needs no local Docker daemon and never builds on the shared VPS. Kamal's
pre-build hook refuses builds; no production remote builder is configured.

Open one `bin/release session` for the authorized production operation. Its
preflight uses the owned tunnel and generated Kamal configuration. Keep this shell
through deployment, final verification and diagnosis. Normal deployment is
`release_deploy`, with `RELEASE_IMAGE_DIGEST` and `--skip-push`. Use `release_ssh`
for host inspection and `release_kamal` for additional authorized Kamal commands;
the latter verifies the existing tunnel and selects its configuration. Do not
use bare SSH/Kamal or override the session configuration. Exit once when finished.

## Verification and recovery

Record the actual live revision/image, protected containers and proxy routes
before replacement. Review host capacity and coordinate one deployment at a time.
`release_verify` checks the public container name, both public hostnames, members
health/sign-in, Two Rivers' homepage and unchanged protected IDs/names. Complete
the additional image, proxy, TLS, DNS, content and changed-workflow checks in the
deployment guide. `/up` remains healthy during publisher outages so static pages
and honest unavailable states can still work; it does not prove feed readiness.

Rollback uses a clean reviewed checkout, successful exact-head checks and its
matching verified digest through the same guarded release path. Keep an existing
operation's tunnel; do not create another merely to select rollback source.
Prepare compatible recovery tooling before production work. Arbitrary Kamal
rollback versions are refused when they differ from reviewed HEAD. Follow the
current deployment guide rather than the superseded September rollback recipe.

No production checks or rollback rehearsal are implied by these instructions.
Record actual evidence and limits for each authorized operation.
