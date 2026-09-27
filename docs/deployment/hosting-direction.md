# Current operator guide

See [DEPLOYMENT.md](../DEPLOYMENT.md) for the coming-soon launch, persistent SSH
transport, certificate issuance, and verification. The full publishing launch
requirements below remain applicable when coming-soon mode is disabled.

# Public-site hosting and releases

The public app has its own Kamal service `legion_post_165_wi_public` and GHCR image
`andrerobitaille/legion-post-165-wi-public`. Its configured hosts are `wipost165.org`
and `www.wipost165.org`, alongside the existing members app on the shared Hetzner
server from the companion's configuration. This configuration is prepared locally;
no server capacity, live revision, DNS, certificate, image build, or cutover has
been verified in this implementation session.

There is **no database accessory, shared database, persistent upload volume, or
queue**. Publication records, images, and their backups belong to LegionPostTools.
The public app has a 32 MB memory cache per process; losing it costs a refetch, not
content loss. The Docker entrypoint runs the requested command without migrations.

## Before the first release

- The companion must implement the reviewed v1 publisher, grant initial publishing
  authority, and publish approved content. `bin/publisher-check` verifies the two
  collection responses from this checkout without requiring member credentials.
- Confirm public contact details and actual content. Sample photos and stories are
  development-only; production cannot enable preview. Confirm the API images and
  failure states in a real end-to-end staging check.
- Inspect current live revisions, host capacity, proxy version, DNS, and ownership
  of the apex/www domains. Preserve the current public website until cutover is
  explicitly authorized. Two hostnames are configured through Kamal's `hosts`
  setting; both need valid DNS/TLS routing. See [Kamal proxy documentation](https://kamal-deploy.org/docs/configuration/proxy/).
- Supply a unique `POST165_PUBLIC_SECRET_KEY_BASE` and a GHCR-capable
  `KAMAL_REGISTRY_PASSWORD` through the operator's environment. `.kamal/secrets`
  only maps those variables; it contains no credential. Do not reuse a member-app
  Rails key, database password, or personal API token.
- Add verified `PUBLIC_CONTACT_EMAIL` / `PUBLIC_CONTACT_PHONE` to this app's
  deployment environment before launch. They are public configuration, not guessed
  values. Confirm the target host/resource names in `config/deploy.yml` and
  `bin/release` together if they change.
- Complete CI, a container boot check, review, an authorized commit/push, and an
  authorized first provisioning/DNS cutover. Implementation permission alone is
  not deployment authorization.

## Repository release entry point

Adapted from the companion's `bin/release`, with an owned SSH control socket so it
cannot close a connection another release is using. The wrapper routes Net::SSH
through the socket and also places an OpenSSH wrapper on PATH for Docker's remote
builder. Once established, a missing socket causes failure rather than a fresh
connection fallback. It never copies or runs the member app's deployment identity.

| Command | Effect |
| --- | --- |
| `bin/release check` | Local-only validation; opens no SSH connection. |
| `bin/release push` | Push current branch and verify the exact remote SHA. |
| `bin/release session` then `release_setup` | First provisioning inside one persistent session. |
| `release_deploy` inside the existing session | Repeat deployment without reconnecting. |
| `release_verify` inside the existing session | Final checks before closing the tunnel once. |

Commands require authorization appropriate to their effects. None has been run
against Hetzner during this implementation. The wrapper uses the configured
identity in `${RELEASE_SSH_CONFIG:-$HOME/.ssh/config}`; system SSH may need host
access outside the Codex sandbox as described by the companion's AGENTS.md.

The remote Docker builder is explicitly selected. After release the wrapper checks
the public service's running container revision, both public hostnames and `/up`,
the member application's `/up` and sign-in endpoint, and TwoRiversReporter's homepage.
HTTP 200 alone does not prove published content is correct; inspect events,
introductions, images, cancellations, and mobile presentation after cutover.

`/up` is process health, not publisher readiness. It deliberately stays healthy
when the member publisher is unavailable so the public app can serve static pages
and honest unavailable states. Publisher readiness is checked separately.

## Rollback and verification limits

Record the currently running public revision before release and retain its image.
For a repeat-release rollback, use a reviewed checkout of that known good revision,
make it available on a named origin branch, and run the same guarded deployment
workflow after authorization. There are no local application data migrations to
reverse. For first cutover, retain the old site's hosting/content and DNS values
until acceptance so routing can be restored if needed.

Kamal configuration is parsed locally with dummy secrets; shell syntax is checked.
Actual SSH transport, remote build, container execution, DNS/TLS, host capacity,
and rollback rehearsal remain deployment-stage verification. The existing
WordPress cleanup did not retire the old live website or migrate stored uploads.
