# LegionPostTools companion work queue

Updated September 27, 2026. This is the public site's dependency handoff, linked
from [ROADMAP](ROADMAP.md). It is not permission to edit or deploy LegionPostTools.
Its own agent/session owns implementation there and must read its current guidance.
No message has been sent and no issue has been opened by creating this file.

The initial API is already designed: [revision 3](public-publishing-api-v1.md)
is the shared implementation baseline. This queue records delivery and new needs;
it must not become a second, subtly different API specification.

## Ownership and current state

| Owner | Responsibility |
| --- | --- |
| LegionPostTools | Existing-account editor, publication grants, consent, draft/published snapshots, event eligibility, controlled portraits, anonymous publishing endpoints, audit history |
| Public site | Visitor experience, readonly API client, validation, bounded caching, accessible empty/error states, its own deployment |
| Owner/designated Post publishers | Select initial grants, approve public content and consent, confirm Post facts; technical administration alone does not imply publishing authority |

On September 27 the local companion was clean at `9d278b7`; the v1 publishing
routes/capability were not found. Recheck before starting; another session may
have advanced it. Public consumer code and synthetic contract fixtures exist.
The public production service is in coming-soon mode and does not call the feed.

## Initial delivery slices

Status vocabulary: **needs companion session**, **active**, **ready for integration**,
**verified together**. Add source revision, test evidence, and environment as each
slice progresses. A local implementation is not a deployed endpoint.

| ID | Deliverable | Status | Dependency |
| --- | --- | --- | --- |
| CP-01 | Publication authority and lifecycle foundation | needs companion session | Reviewed v1 contract |
| CP-02 | Member stories, featured selection, controlled portraits | needs companion session | CP-01 |
| CP-03 | Explicitly approved public events | needs companion session | CP-01 |
| CP-04 | Publisher integration environment and operating handoff | needs companion session | CP-02 and CP-03 |

### CP-01 — Publication foundation

Implement explicit `publish_public_content` authority, separate drafts/published
snapshots, stable publication identities, audit records, and atomic publication
and restriction checks. Do not silently grant existing users publication rights.
Keep the existing private API behavior and generic-upload restrictions intact.

Return the implementation revision and permission/lifecycle/concurrency test
evidence. Show how initial grants will be selected before enabling publication;
no real grants or public content are prerequisites for synthetic development tests.
Follow the contract for exact locking/version requirements, including restrictions
made through HTML and the private API.

### CP-02 — Introductions and portraits

Deliver the existing-account workflow for authored public profiles, consent,
portrait upload/review, explicit publication/withdrawal, and manually ordered
selection of zero to three featured people. A private Person link is optional;
private roster fields are never automatically public. Rotating a published story
off the homepage must preserve its detail URL.

Implement the contract's featured collection, story detail, and revisioned portrait
routes. Return synthetic examples and tests for draft isolation, rotation,
withdrawal, consent revocation, old portrait URLs, and conditional requests.
The public app already has neutral portrait fallback; do not serve an old image
indefinitely to disguise a withdrawn or replaced portrait.

### CP-03 — Public events

Deliver publication records requiring a source CalendarEvent, reviewed eligibility,
and authored public title/description. Schedules/location come from the reviewed
source. Pending changes leave the old approved schedule public until republished;
cancellation and restrictions act immediately at the publisher.

Implement collection/detail routes and the v1 calendar semantics without changing
the private calendar's existing overlap behavior. Existing `visibility: public`
events must not automatically launch. Internal designations/categories cannot be
bypassed with presentation overrides; optional Endeavor linkage never leaks parent
content. Source deletion withdraws while retaining publication identity/history.

Return synthetic fixtures and evidence for interval boundaries, all-day/unknown-end
events, rescheduling across intervals, cancellation, deletion, persistent
restrictions, and publish/restriction races. See contract section 7 for coverage.

### CP-04 — Integration and operation

Provide a reachable test publisher or reproducible local setup, configuration
requirements, implementation/contract revisions, and sanitized sample responses.
Specify what is local, deployed, or still pending. Do not include private exports,
credentials, real consent records, or private member identifiers in this repo.

Demonstrate the one five-minute freshness budget across JSON/portrait delivery,
including 304 behavior and unavailable responses. Provide officer instructions
for publish/withdraw/rotate and identifying pending calendar changes, plus the
publisher's release/rollback and upload persistence/backup arrangements.

Coordinate synthetic end-to-end scenarios with SITE-04. Production publishing
grants/content and companion deployment need their own authorization. Mark
**verified together** only with evidence from both applications, not a successful
health endpoint or collection check alone.

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

> The public Post 165 site has a Rails consumer implemented against
> `~/Development/wipost165/docs/public-publishing-api-v1.md` revision 3. Production
> currently serves coming-soon content. Read that contract and
> `~/Development/wipost165/docs/companion-work-queue.md`, then check current
> LegionPostTools code before selecting CP-01 through CP-04. Public administration
> stays in LegionPostTools; this site has no editor, member accounts, or database.
> Return implementation revisions, tests, environment readiness, and any concrete
> contract questions. Initial publishing grants remain an owner decision. This
> brief describes scope; the user's session instruction supplies authorization.
