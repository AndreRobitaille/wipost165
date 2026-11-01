# Public Post 165 deployment

This application owns `legion_post_165_wi_public` on `178.156.250.235`, using
`ghcr.io/andrerobitaille/legion-post-165-wi-public`. It serves `wipost165.org` and
`www.wipost165.org`. It has no database, uploads, or worker. Never deploy it under
the members application's service name or reuse its Rails key or database secrets.

## Current launch scope

Latest release: [`9d4095c`, off-server builds and contact fallback](deployment/2026-11-01-off-server-contact-release.md).
Its actual previous live revision was `c257c1a`; inspect live state again before
the next operation rather than treating older handoff entries as current.
The approved V1 design first launched on October 12, 2026 at revision `e2a88f2`.
See [production evidence and rollback identity](deployment/2026-10-12-v1-launch.md).
`config/deploy.yml` now selects V1, disables coming-soon/sample mode, and enables
indexing after content approval:

```yaml
PUBLIC_SITE_EDITION: "v1"
PUBLIC_SITE_COMING_SOON: "0"
PUBLIC_SITE_LAUNCH_READY: "1"
PUBLIC_SITE_PREVIEW: "0"
```

This launch contains public events, first-visit guidance, contact, About,
Membership, Veteran help, and Why the Legion. People, stories, and portraits
remain unavailable in V1. The V2 source and separately published Sites concept
are retained. `bin/publisher-check` verifies events and up to ten details for V1;
it requests people and portraits only for V2. Production uses the existing
read-only website credential, never an editorial or AI API key.

The prior recorded release was [`5d15332`, authenticated publisher integration](deployment/2026-09-27-authenticated-publisher-release.md),
in coming-soon mode. Inspect the actual running revision at the start of the
single release session and retain it as the rollback target. Deployment evidence
belongs in `docs/deployment/`; configuration alone does not prove launch success.

Verify the V1 content, live event dates, page titles/descriptions, apex canonical
URLs on both hosts, query-free sharing URLs, and noindex on 404/503 responses.
Rollback to holding mode uses coming-soon `1` / launch-ready `0`; noindex alone
does not hide content. No DNS or global proxy change is needed for this launch.

The [earlier release preparation](verification/2026-09-27-release-preparation.md)
records the local Docker permission limit and rollback commands. A candidate
container can be checked through the same release tunnel before app replacement;
never open another outer connection for that check. Use only a task-owned smoke
container with no network and dummy credentials; preserve shared services.

## Shared host and authorization

Read the current `~/Development/LegionPostTools/docs/DEPLOYMENT.md` before changing
transport conventions. Also read this repository's AGENTS.md. Commit, push, deploy,
and DNS changes require authorization. Preserve unrelated work and use a clean
isolated release checkout when the development checkout contains other work.

The existing services are `legion_post_165_wi_tools` (members.wipost165.org) and
`two_rivers_reporter` (tworiversmatters.com). Record their revisions and proxy
routes before and after a release. Do not restart or redeploy those services,
replace the shared proxy, prune shared images/builders, or modify databases.

## Required persistent SSH transport

Production images are built and smoke-tested on isolated GitHub Actions runners.
This VPS only pulls a verified image and replaces the public container.
`release_setup` and `release_deploy` require `RELEASE_IMAGE_DIGEST` and always use
Kamal's `--skip-push`; a missing digest cannot fall back to an on-server build.
The shared builder's normal 1,536 MiB limit is unchanged and unused by this path.

**One operation uses one outer connection from first inspection to final
verification.** Finish local checks and push first. Run `bin/release session`
once. It opens and verifies the persistent tunnel and leaves an interactive
`post165-release>` shell. Run `release_setup` for first provisioning or
`release_deploy` for later releases. Run `release_verify` and `release_ssh` for
follow-up checks in that same shell. Exit once, only after the operation is done.

`bin/release check` now performs local validation only. Standalone setup/deploy
commands are disabled to prevent preflight/disconnect/reconnect sequences.
Failed build or deployment commands return to the existing shell with the tunnel
still open. Do not start another session to diagnose them. If the tunnel itself
fails, stop dependent work, wait at least five minutes, and make at most one
explicit replacement attempt. Never loop retries or fall back to direct SSH.
Do not start parallel outer connections, even for read-only inspection.

Run with host access outside Codex's restricted sandbox; synthetic system-file
ownership can make OpenSSH reject valid host configuration. Never chown system
SSH files to fix it. Tunnel startup has a 45-second overall limit. The owned
master has no idle expiry and stays open until the session exits.

The wrapper reads `${RELEASE_SSH_CONFIG:-$HOME/.ssh/config}`, using the existing
host stanza for `178.156.250.235`, root, and its configured identity file. Keep
`IdentityAgent none` and `IdentitiesOnly yes` configured for this server.

It creates an owned temporary SSH master, verifies it, opens a localhost-only forward on port 22222 to remote localhost:22, and routes
Kamal Net::SSH and Docker/buildx OpenSSH through `socat - TCP:127.0.0.1:22222`.
An occupied local port is preserved; choose RELEASE_TUNNEL_PORT explicitly if needed. Kamal does not build during release. The wrapper unsets SSH_AUTH_SOCK before
Kamal so Net::SSH uses the configured file key instead of the desktop signing
agent, which otherwise failed with FrozenError in this environment. The proxy command fails closed when the forward disappears; there is no direct
connection fallback. Stop
if the tunnel fails. Cleanup closes only this release's master and removes its
temporary configuration; do not close another application's active connection.

Use `-o ControlMaster=yes -Nf`, not `-o ControlMaster=yes -MNf`: adding `-M` to
an already enabled master switches OpenSSH to interactive `ask` mode, causing
noninteractive channel and termination requests to fail.

## Secrets and release

The **Build production image** workflow runs for production changes in pull
requests and every `master` push, and can be dispatched manually at an exact ref.
It builds linux/amd64 on an isolated runner, smoke-tests both editions with
synthetic contacts and no network/production credentials, starts the actual
entrypoint/Thruster, and saves build-memory and startup evidence. Successful
`master`/manual runs export `production-image-<full SHA>` for three days. PR runs
check the image but do not export a release artifact. No registry credentials,
production Rails keys, website token, or SSH key are supplied to CI.

From a clean checkout of the tested release revision:

```sh
# Find the successful Build production image run for this exact HEAD.
CRANE=/path/to/crane bin/publish-image ACTIONS_RUN_ID
# Copy its printed digest; this is not a Git SHA or archive checksum.
export RELEASE_IMAGE_DIGEST=sha256:THE_PRINTED_REGISTRY_DIGEST
```

`bin/publish-image` uses GitHub CLI and crane (no Docker daemon). It verifies the
workflow, successful run, exact revision and artifact checksums, publishes only
that SHA tag to the existing registry, and checks revision/service/architecture
labels. Registry authentication stays in a temporary local directory that is
removed on exit; the maintainer's token is never sent to CI. A missing/expired
artifact requires another workflow run at the same reviewed ref.

Finish the normal local checks and `bin/release push`, then open one
`bin/release session` and call `release_deploy`. Export the digest before opening
the session or inside its existing shell. Image identity is checked after the
initial pull and again by the pre-deploy hook after Kamal's final pull, before
container replacement. A wrong digest, revision, service or architecture stops
deployment. There is no on-server-build fallback.

When this release-wrapper update is installed while a release shell is already
open, run `source "$APP_ROOT/lib/release_image.sh"` in that shell to load its
tested image functions. Keep the original tunnel; do not start a new session.
Before replacement, record a fresh protected-service baseline if another
authorized deployment changed an adjacent service while CI was building, retaining
both observations in the release evidence. Image extraction and the brief overlap
of old/new public containers still need application headroom.

Generate a unique `POST165_PUBLIC_SECRET_KEY_BASE` once. Store it outside Git in
a mode-0600 operator file, such as `.env.production.local` in the development
checkout. Export it into the release shell. Use an authenticated GHCR-capable
GitHub CLI token for `KAMAL_REGISTRY_PASSWORD`; do not print or commit it.
`.kamal/secrets` maps these environment variables and reads this application's
`config/credentials/production.key` into `RAILS_MASTER_KEY`. Its encrypted
`production.yml.enc` stores `legion_post_tools.website_token`, the Post-owned
read-only credential for published website content. Keep the key ignored and
mode 0600; include only the encrypted file in Git. Never source Rails keys or
database secrets from the members app. Check that Git ignores local secret files.

Run `bin/ci`, review the intended changes, commit and push the clean release
branch with `bin/release push`, then run `bin/release session` once and
`release_setup` within it. Setup requires a clean checkout and exact pushed SHA.
The shared proxy already exists; Kamal should add only the public application's
route. Do not run proxy reboot/upgrade or change global proxy settings.

## DNS and certificates

NixiHost AutoSSL does not configure Hetzner. The apex A must resolve to
178.156.250.235; www remains a CNAME to wipost165.org. Check both for conflicting
AAAA records and check authoritative DNS and CAA before certificate issuance.
Kamal's application-specific `proxy.hosts` includes both names and `ssl: true`
requests Let's Encrypt certificates through the existing proxy. Port 443 must
reach Hetzner for issuance. A failed certificate request requires diagnosis;
waiting alone does not create a missing route or application.

Preserve NixiHost mail: mail/ftp and cPanel service A records stay at
104.225.208.23; MX remains priority 0 to mail.wipost165.org; SPF remains
`v=spf1 mx ip4:104.225.208.23 ~all`. Preserve SES/Loops, DKIM, DMARC, validation
records, Local Mail Exchanger routing, and all unrelated services. Never reset
the zone or change nameservers. No test emails without explicit authorization.

For a future cutover, verify mail/service separation first, then wait at least
four hours (original TTL 14400) before moving the apex. Lowering TTL does not
clear caches. On September 27 the owner reported cutover already complete and
public DNS confirmed the new apex; this session cannot certify when preparation
was saved or that all previous caches had expired. Do not change DNS again as
part of deploying the coming-soon page.

## Verification and rollback

Verify the exact running public container revision, both proxy hostname routes,
and TLS for both names. Use `curl --resolve NAME:443:178.156.250.235 https://NAME/`
without disabling certificate validation so cached old-host answers cannot
produce false success. Confirm the approved V1 homepage, navigation, live events, and static pages, both
`/up` responses, HTTP-to-HTTPS redirects, certificate names/expiry, and ordinary
public DNS results. Recheck members `/up` and `/session/new`, and the Two Rivers
homepage. Record that protected container IDs/revisions remain unchanged.

Keep DNS success, HTTPS success, application health, and full-site readiness
separate. The coming-soon release does not finish the publishing integration.
Keep NixiHost hosting available until the migration is accepted. Roll back only
the public service to its recorded previous image using the same guarded release
workflow. Earlier images may predate the required revision metadata; do not assume
they satisfy the new image guard. Prepare reviewed rollback source through the
current build/check/publish procedure when necessary. Restoring an old apex is a
separate explicitly authorized DNS action with cache delay. Never remove the shared
proxy as a rollback.
