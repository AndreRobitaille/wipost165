# LegionPostTools companion review — 2026-09-07

## Scope and evidence

The first Rails scaffold used only a narrow inspection of the companion repository.
This follow-up inventories its Markdown, operational scripts, Rake tasks, and Kamal
hook samples, including ignored historical plans and the local database-sync script.
[The inventory](companion-review-inventory.md) identifies every file and review depth.
All Markdown was indexed by purpose and headings; relevant deployment, architecture,
calendar, and audience sections were read more deeply. This is not a claim to have
read every historical code listing line by line or audited the whole application.

Source: `~/Development/LegionPostTools`, HEAD
`3c57d7dcd8b2f7436e7fab899d1cebdec439f3fa`, with existing tracked and untracked changes.
Observations describe that working checkout, not a verified production revision.
No companion files, services, credentials, or live records were changed. No operational
script, AI evaluation, sync, or release command was executed.

## Deployment: reuse the established approach

The companion already documents a shared Hetzner host serving LegionPostTools and
TwoRiversReporter through Kamal. Its `config/deploy.yml` names a distinct application
service, image, PostgreSQL accessory, databases, and storage. A separate application
container/service for this public site fits the existing model; there is no reason
at this point to invent a second deployment system or merge the apps.

The important operational entry point is
[`bin/release`](../../LegionPostTools/bin/release), interpreted with current
[`AGENTS.md`](../../LegionPostTools/AGENTS.md) and
[`docs/DEPLOYMENT.md`](../../LegionPostTools/docs/DEPLOYMENT.md):

- `check` verifies SSH/Kamal transport; it is not a full image build or deployment.
- `push` verifies the exact remote branch SHA after pushing.
- `deploy` rejects dirty/untracked work and requires the exact local SHA on origin.
- `push-deploy` combines those release steps.
- The wrapper uses a persistent OpenSSH control master and a temporary Kamal
  `proxy_command`, because Net::SSH does not automatically reuse that master.
- It explicitly selects a remote Docker builder (`builder.local = false`). Local
  Docker socket permissions therefore do not establish a deployment blocker.
  Remote image building still needs an appropriately authorized implementation
  and verification; it has not been attempted for this site.
- After deployment it checks the service's running revision and HTTP endpoints,
  including the co-hosted site, then removes temporary configuration and closes SSH.

**Adapt, do not run or copy unchanged.** This script is hard-coded to deploy the
member application. It includes that app's service, URL, SSH configuration path,
co-host check, and sign-in endpoint. A public-site wrapper needs its own identity,
public-page checks, and checks for both existing applications. Its connection
cleanup also closes a reused SSH master; an adaptation should own its connection
or avoid disrupting another active operation. The wrapper does not run the Rails
test suite or prove GitHub CI succeeded; application validation remains separate.

The old first-install and verification lists still mention direct `bin/kamal deploy`.
Current root guidance and the wrapper take precedence for repeat releases.
`setup` is initial provisioning, not a repeat-release step. Sample hooks ending in
`.sample` are examples, not active safety gates. In particular the sample pre-build
hook looks up tags when checking a branch; the real wrapper checks branch heads.

## Infrastructure decisions for this application

Use the existing Kamal approach as the starting direction, with a separate service,
image, database credentials, persistence, and public hostname. Confirm current host
capacity, names, proxy configuration, and routing before provisioning. Existing
member-app configuration exposes its PostgreSQL accessory on loopback port 5433;
a new accessory must not copy that binding. No public database port is implied.
The public app currently needs only its primary database. Do not copy cache/queue
databases, workers, AI secrets, Loops settings, or WebAuthn settings without a feature
that needs them. The companion's Chromium dependency serves PDF generation; it is
not required by this site's current foundation.

The Docker entrypoint runs `db:prepare`; a wrong database URL would be consequential.
Keep backup/restore and upload persistence specific to this app, and verify them
before launch. The companion's deployment notes call for restore rehearsals;
a documented expectation is not evidence that this new app has a working backup.

The earlier local Docker build failure remains a verification limitation only.
The future public hostname, DNS cutover, resource names, secrets, first provisioning,
and rollback/restore procedure still need concrete configuration. None was inferred
from access to the companion's repository.

## Calendar: a useful existing publication boundary

[`CALENDAR.md`](../../LegionPostTools/docs/CALENDAR.md) and
[`CALENDAR_API.md`](../../LegionPostTools/docs/CALENDAR_API.md) already anticipate
this public website. The current model's `public_calendar_attributes` emits only:

`id`, `title`, `description`, `location`, `starts_at`, `ends_at`, `all_day`,
`cancelled`, `updated_at`, and the derived `category`.

The method returns nothing for a private event. Monthly public previews select
only explicitly public CalendarEvents. The API still inherits authentication;
`view=public` or `preview=public` does not make an endpoint anonymous. There is no
activated public feed, background website sync, or public cache in these sources.

The natural integration is an explicit, read-only publication contract using that
projection, keeping event editing in the operations app. Transport and credentials
remain to be chosen. Do not give a browser a member's bearer token, expose a raw
member calendar, share the private database, or assume a personal delegated token
is a durable service credential.

A future consumer needs bounded date queries, pagination where applicable, short
cache lifetimes/conditional requests, and correct withdrawal handling. An event
made private or deleted must disappear; a cancelled event may need a visible notice.
Define behavior for failed refreshes so stale data is not silently presented as
current. No synchronization has been implemented here.

Meetings remain separate member records, excluded from the current public preview.
Publishing a public meeting schedule needs an explicit content decision; the old
website's computed recurrence should not be recreated automatically. Date-only
entries are not proof of an all-day activity. Use the supplied timezone and do not
invent a start time, turn a project deadline into an event, or infer a volunteer
invitation from an Honor Guard category.

## Other companion information worth retaining

- Mission and audience documents emphasize accurate Legion terminology, limited
  volunteer time, older/infrequent users, and approachable workflows. The member
  app's reusable multi-installation requirements do not require this public site
  to become a multi-tenant product.
- The people, roster, roles, and sign-in docs describe private operational access.
  A member directory is not a public contact list; publication consent and source
  ownership need an explicit design if officer contacts are later displayed.
- Endeavors provide continuity for internal Post work. Their histories, meeting
  sources, AI output, tasks, and deadlines are not public content simply because
  one linked CalendarEvent is public.
- Current minutes lifecycle/approval docs distinguish drafts, attestation, and
  membership approval. A member-visible PDF is not automatically approved for
  anonymous publication. These workflows belong to the companion app.
- The 1919 visual system and calendar refinements contain useful readability and
  responsive lessons. They are companion context, not a required palette, typeface,
  layout, or public-site feature list.
- `bin/sync_prod_db` replaces local development with a private production dump and
  removes selected authentication data. It is not a public-content export and
  does not make the remaining roster/meeting data safe to import here.
- The evaluation script and history backfill task can invoke paid generation.
  They are unrelated to scaffold verification and were not run.

## Next work informed by this review

Shape the public experience and content ownership with the existing public-event
projection in mind. Prepare this app's separate Kamal configuration and release
wrapper from the working companion pattern when proceeding with deployment work.
Any change needed inside LegionPostTools needs authorization covering that repo;
reading it does not grant permission to activate a feed or change production.

Maintain this concise reference rather than copying all of the companion's documents
and historical workflows into the public-site repository. Recheck the source files
when implementing; the companion checkout is actively changing.
