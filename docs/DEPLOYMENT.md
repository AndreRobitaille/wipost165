# Public Post 165 deployment

This application owns `legion_post_165_wi_public` on `178.156.250.235`, using
`ghcr.io/andrerobitaille/legion-post-165-wi-public`. It serves `wipost165.org` and
`www.wipost165.org`. It has no database, uploads, or worker. Never deploy it under
the members application's service name or reuse its Rails key or database secrets.

## Current launch scope

The first release is a simple coming-soon page with the Post name, Two Rivers
location, and a members-site link. White background, Legion blue, large readable
type, no animation or sample content. `PUBLIC_SITE_COMING_SOON: "1"` in
`config/deploy.yml` makes every existing public page bypass the publishing client.
`/up` remains a separate health endpoint. Desktop and narrow-width checks are
required. The publisher check is skipped only when that committed deployment
configuration enables coming-soon mode. Turning it off requires a working
publishing feed, approved content, full-page QA, and a separate authorized release.

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

Use `bin/release check`, then `bin/release push` and `bin/release setup` for the
first provisioning. Later releases use `bin/release push-deploy`. Do not run raw
Kamal deployment commands or repeated direct SSH sessions. Run with host access
outside Codex's restricted sandbox; synthetic system-file ownership can make
OpenSSH reject valid host configuration. Never chown system SSH files to fix it.

The wrapper reads `${RELEASE_SSH_CONFIG:-$HOME/.ssh/config}`, using the existing
host stanza for `178.156.250.235`, root, and its configured identity file. Keep
`IdentityAgent none` and `IdentitiesOnly yes` configured for this server.

It creates an owned temporary SSH master, verifies it, opens a localhost-only forward on port 22222 to remote localhost:22, and routes
Kamal Net::SSH and Docker/buildx OpenSSH through `socat - TCP:127.0.0.1:22222`.
An occupied local port is preserved; choose RELEASE_TUNNEL_PORT explicitly if needed. The builder is remote, not local. The wrapper unsets SSH_AUTH_SOCK before
Kamal so Net::SSH uses the configured file key instead of the desktop signing
agent, which otherwise failed with FrozenError in this environment. The proxy command fails closed when the forward disappears; there is no direct
connection fallback. Stop
if the tunnel fails. Cleanup closes only this release's master and removes its
temporary configuration; do not close another application's active connection.

Use `-o ControlMaster=yes -Nf`, not `-o ControlMaster=yes -MNf`: adding `-M` to
an already enabled master switches OpenSSH to interactive `ask` mode, causing
noninteractive channel and termination requests to fail.

## Secrets and release

Generate a unique `POST165_PUBLIC_SECRET_KEY_BASE` once. Store it outside Git in
a mode-0600 operator file, such as `.env.production.local` in the development
checkout. Export it into the release shell. Use an authenticated GHCR-capable
GitHub CLI token for `KAMAL_REGISTRY_PASSWORD`; do not print or commit it.
`.kamal/secrets` only maps these environment variables. Never source secrets from
the members app. Check that Git ignores local secret files before saving them.

Run `bin/ci`, review the intended changes, commit and push the clean release
branch with `bin/release push`, then run `bin/release check` and `bin/release setup`
for this first install. `setup` requires a clean checkout and exact pushed SHA.
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
produce false success. Confirm the coming-soon heading and members link, both
`/up` responses, HTTP-to-HTTPS redirects, certificate names/expiry, and ordinary
public DNS results. Recheck members `/up` and `/session/new`, and the Two Rivers
homepage. Record that protected container IDs/revisions remain unchanged.

Keep DNS success, HTTPS success, application health, and full-site readiness
separate. The coming-soon release does not finish the publishing integration.
Keep NixiHost hosting available until the migration is accepted. Roll back only
the public service to its recorded previous image using the same guarded release
workflow. Before this first install there is no public Hetzner image to restore;
restoring the old apex is a separate explicitly authorized DNS recovery action,
with cache delay. Never remove the shared proxy as a rollback.
