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

## Remaining evidence handback

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
