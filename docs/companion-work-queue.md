# LegionPostTools companion work queue

October 7 staged-launch scope: CP-01's event eligibility/private-field exclusion,
CP-03 event lifecycle, and their CP-04 provenance remain V1 launch dependencies.
CP-02's story/portrait/consent evidence moves to V2 while V1 disables those routes.
Existing publisher functionality is preserved; this scope change requests no
companion mutation or API change. See the [V1/V2 plan](design/2026-10-v1-launch/README.md).

Updated September 27, 2026. This is the public site's dependency handoff, linked
from [ROADMAP](ROADMAP.md). It is not permission to edit or deploy LegionPostTools.
Its own agent/session owns implementation there and must read its current guidance.
No message has been sent and no issue has been opened by creating this file.

Start the companion handoff with [what the public site needs](publisher-api-request.md).
The owner clarified that this repository should specify public output, not how
LegionPostTools builds its internals or operates its site/admin. Revision 3 remains
the jointly developed baseline, including the companion agent's contributions.
This output-focused queue adds no internal/admin requirements and does not revoke
that agreement. The companion evaluates implementation choices in its own context;
coordinate interface differences rather than silently changing either side.

## Ownership and current state

| Owner | Responsibility |
| --- | --- |
| LegionPostTools | Producing approved public content and API output; all internal implementation, content administration, and operating decisions |
| Public site | Visitor experience, readonly API client, validation, bounded caching, accessible empty/error states, its own deployment |
| Owner/designated Post publishers | Approve public content and consent, confirm Post facts, and authorize publication under the companion's own access model |

## Current access and evidence

The publisher is delivered and requires a Post-owned read-only website bearer
token on JSON, portraits, and conditional requests. There is no anonymous API
access. The public consumer supports private credential-scoped caching and serves
portraits through its own origin. The [populated-feed follow-up](deployment/2026-09-27-authenticated-publisher-release.md#populated-feed-follow-up)
records three fictional stories, six portraits, and local desktop/phone rendering;
the checked 90-day event interval was empty. This is recorded evidence, not a new
production read.

Editorial API changes require a personal API token with the appropriate role.
The public-site session has only the website read token, and must not put editorial
credentials in this application. An authorized companion session owns any editorial
exercise. Production mutations are not required when scoped local/test publisher
evidence can establish the behavior. See the [roadmap verification matrix](ROADMAP.md#site-04--verify-within-the-actual-access-boundary).

## November 1, 2026 — publisher evidence handback

SITE-04 / [public-site issue #4](https://github.com/AndreRobitaille/wipost165/issues/4)
now has independently executed synthetic publisher evidence. The owner of the
publisher behavior remains LegionPostTools; this session changed no companion
source, permissions, tokens, or live records.

Tested companion revision:
[`879e2e8b11b0c7c8e227ca8402a4a511743f7883`](https://github.com/AndreRobitaille/LegionPostTools/commit/879e2e8b11b0c7c8e227ca8402a4a511743f7883).
An isolated copy used Ruby 4.0.7, PostgreSQL, `RAILS_ENV=test`, and a new database
named `legion_post_tools_publisher_audit_20261101_test`, loaded from the checked-in
schema and synthetic fixtures. Development/production data and credentials were
not read or copied. Commands ran serially with `PARALLEL_WORKERS=1`.

| Requirement / companion owner | Evidence at the tested revision | Result and limits |
| --- | --- | --- |
| CP-01 / [LegionPostTools #60](https://github.com/AndreRobitaille/LegionPostTools/issues/60): eligibility, role enforcement, private fields, atomic restrictions | `website_publication_test.rb`, `website_publication_concurrency_test.rb`, `website_access_authentication_test.rb`, `website_publishing_admin_test.rb`, `api/website_publications_api_test.rb` | Passed model, HTML and bearer API authority/eligibility checks; private/internal restrictions, tenant isolation, revoked authority, and both real transaction orders. Website read credentials cannot obtain editorial/private authority. |
| CP-02 / [LegionPostTools #61](https://github.com/AndreRobitaille/LegionPostTools/issues/61): story lifecycle, consent, portraits | `public_publishing_test.rb`, `website_publication_test.rb`, `website_publication_concurrency_test.rb`, `api/website_publications_api_test.rb` | Passed later-request readback after draft changes, publication, selection rotation, portrait replacement, withdrawal and consent revocation, including old conditional validators and concurrent publication. Uses generated color-field portraits and fictional introductions. |
| CP-03 / [LegionPostTools #62](https://github.com/AndreRobitaille/LegionPostTools/issues/62): event lifecycle and intervals | `public_publishing_test.rb`, model/controller `website_calendar_test.rb`, `website_publication_concurrency_test.rb` | Passed complete 93-day intervals, inclusive/exclusive boundaries, all-day and point events, spring/fall DST, moves, cancellation, restrictions, deletion, automatic calendar activation, and private-parent exclusion. |
| CP-04 / public site: provenance and applicability | Commands/results below; the reviewed publisher paths and eight test files have no changes between this revision and `524ec571739a61c1cb78e17ee620e554f2f186b2`, the members revision in the [October 28 release record](deployment/2026-10-28-service-officer-label.md) | Satisfies the local/test evidence handback. The recorded deployment makes the tested paths applicable to that release; it does not establish the current live revision or exercise production permissions. |

Commands in the isolated companion copy (the test database URL was explicitly set
for schema loading and every test command):

```sh
RAILS_ENV=test DATABASE_URL=postgresql:///legion_post_tools_publisher_audit_20261101_test bin/rails db:schema:load
RAILS_ENV=test DATABASE_URL=postgresql:///legion_post_tools_publisher_audit_20261101_test PARALLEL_WORKERS=1 bin/rails test \
  test/controllers/public_publishing_test.rb \
  test/controllers/website_access_authentication_test.rb \
  test/models/website_publication_test.rb \
  test/models/website_publication_concurrency_test.rb \
  test/models/website_calendar_test.rb \
  test/controllers/website_calendar_test.rb
RAILS_ENV=test DATABASE_URL=postgresql:///legion_post_tools_publisher_audit_20261101_test PARALLEL_WORKERS=1 bin/rails test \
  test/controllers/website_publishing_admin_test.rb \
  test/controllers/api/website_publications_api_test.rb
```

The first group passed **41 tests / 934 assertions** (seed 46150); the second
passed **18 tests / 278 assertions** (seed 59980), with no failures/errors/skips.
The initial isolated run needed `bin/rails tailwindcss:build` before one HTML
workspace test could render; the clean rerun above includes that test.
Source links: [publisher/controller tests](https://github.com/AndreRobitaille/LegionPostTools/tree/879e2e8b11b0c7c8e227ca8402a4a511743f7883/test/controllers),
[publisher/model tests](https://github.com/AndreRobitaille/LegionPostTools/tree/879e2e8b11b0c7c8e227ca8402a4a511743f7883/test/models),
and [synthetic setup](https://github.com/AndreRobitaille/LegionPostTools/blob/879e2e8b11b0c7c8e227ca8402a4a511743f7883/test/support/website_publishing_support.rb).

No browser system tests, production editorial transitions, real grants/consent,
or live token revocation were exercised here. V2 still requires approved content,
withdrawal of reachable fictional content, and an authorized release. The three
companion issues remain under their owner's control; their open state alone does
not negate the evidence above or require rebuilding the publisher.

## September 27 evidence requests (historical)

The [public consumer coverage review](verification/2026-09-27-consumer-coverage.md)
is complete: conditional validator handling was repaired and simulated lifecycle
coverage added; local CI passed 53 tests / 333 assertions. CP-01/02/03 below remain
publisher evidence requests. This consumer result does not close them.

These IDs track evidence dependencies, not a request to rebuild the delivered
publisher or prescribe its internal administration. Inspect existing results first.

| ID | Output needed | Recorded status / next evidence |
| --- | --- | --- |
| CP-01 | Publication eligibility, role enforcement, private-field exclusion, and atomic restrictions | Public reads alone cannot prove these; request companion test evidence, tested revision/environment, and deployment applicability. |
| CP-02 | Story edits/publication/rotation/withdrawal, consent revocation, and portrait replacement | Steady-state reads of three stories and six portraits passed. Request synthetic lifecycle evidence from companion tests; private consent/audit results were reported by the other agent, not independently verified here. |
| CP-03 | Complete event intervals, rescheduling/cancellation/restriction/deletion, and date boundaries | Empty live interval passed. Consumer fixture tests exist; populated publisher/event lifecycle evidence remains to be supplied. |
| CP-04 | Environment, interface, access boundary, and evidence provenance | Token transport and populated story/portrait compatibility delivered. Remaining handback: revisions, commands/results, sanitized headers/examples, and explicit unverified cases for CP-01/02/03. |

For each requirement, return existing automated test or controlled synthetic
exercise evidence first. Specify revision, environment, commands/results, and
what remains unverified; omit credentials and private records. If a material gap
needs a coordinated exercise, propose the smallest synthetic scenario in an
isolated environment. Live changes require authorization for that particular
operation in the session performing it. Do not revoke the working website token
or mutate real records merely to test the public consumer.

The public session can continue consumer tests and technical release preparation
while this evidence is pending. Material unresolved publisher behavior needs an
explicit launch decision; lack of a personal token here does not make it verified.
Real introductions/photos are the final SITE-05 content step after technical
readiness, not a prerequisite for this handback.

## New needs discovered during development

Add a small request here when a concrete public feature needs companion data or
editing. Do not design future officer/photo APIs merely because they are possible.
Use this format, assigning the next CP number:

```text
CP-05 — Short outcome
Status / date:
Public task and visitor/editor need:
Why companion-owned data is needed:
Minimum public fields and behavior (no private examples):
Publication/consent/withdrawal and freshness implications:
What public work is blocked; what can continue:
Open question or requested companion decision:
Contract change, compatibility, and rollout order (if needed):
Companion response: revision, tests, environment, remaining work:
Public verification and closure:
```

Keep questions here until resolved, then update the authoritative contract and
both sides' fixtures/tests if behavior changes. Link any companion issue/PR instead
of copying its implementation checklist. Do not infer acceptance from silence.

## Brief to give a companion session

> Work in `/home/andre/Development/LegionPostTools` and read your repository guidance.
> The public website already consumes the authenticated publisher using its read-only
> website token. It has no personal editorial token. Review existing evidence for
> CP-01 through CP-04 above and return test results for the remaining publisher-owned
> behavior, including tested revision/environment, deployment applicability, and
> unverified cases. Prefer existing tests and synthetic local/test records. Read
> `docs/publisher-api-request.md` in the public repo for current output compatibility.
> Do not send personal credentials or private evidence to the public repository.
> Propose any missing coordinated scenario before live mutations; this handoff does
> not authorize production content changes, grants, token revocation, or deployment.
> Real people/photos will be added after technical readiness, as the final content step.
