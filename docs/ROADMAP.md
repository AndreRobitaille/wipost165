# Public website development roadmap

Updated September 27, 2026. This is the working backlog for future sessions.
It records outcomes and dependencies, not a fixed visual specification. Improve
the design as we learn; preserve the public/private boundary and coordinate any
change to the reviewed API contract.

## Start here each session

1. Read `AGENTS.md`, the current section of [HANDOFF](HANDOFF.md), and this roadmap.
   Inspect the checkout and preserve existing work before editing.
2. Pick one ready item below, or follow the owner's explicit priority. Check its
   dependencies against current evidence. Read only the relevant linked documents.
   For product/design work, read [PURPOSE](PURPOSE.md) and [UI/UX guidance](UI_UX_GUIDE.md);
   for implementation commands, use [development](development.md).
3. Mark the item active with the session date and scope. Implement and verify a
   useful slice; a milestone may take several sessions.
4. Before ending, update its status, evidence, remaining work, and next action.
   Add a short entry to the session record below. “Implemented locally” and
   “verified in production” are different results.

If a dependency is missing, record exactly what is needed in the
[companion work queue](companion-work-queue.md) and continue a ready public-site
task. Do not invent a substitute API, private database connection, or second editor.
Do not mark a task complete just because a document or mockup exists.

GitHub issues are optional discussion/review links attached to these IDs. This
file owns public-site priority and status; the companion queue owns dependency
status. Avoid maintaining a second competing backlog. Creating this roadmap does
not authorize commits, pushes, companion edits, publishing grants, or deployment.

## Current baseline

| Area | Evidence and state |
| --- | --- |
| Hosting | Coming-soon page deployed with apex/www HTTPS; see [release evidence](deployment/2026-09-27-coming-soon-status.md). Do not redo DNS or provisioning as website development. |
| Public experience | Rails “In good company” pages, event/story details, visit/contact paths, and synthetic preview exist. [Local verification and screenshots](design/2026-09-rails-implementation/README.md) are evidence of that slice, not full-site launch approval. |
| Public consumer | Database-free v1 client, validation, bounded caching, and failure states exist. See [development](development.md). Cross-application verification remains open. |
| Publisher | Contract revision 3 reviewed. Local companion checkout at `9d278b7` was clean on September 27; no v1 publisher implementation was found. Recheck before assigning work. This is not a new live-server check. |
| Content | Real introductions/portraits, publishing grants, contact details, and first-visit facts still need preparation/confirmation. Preview people are fictional. |
| Source continuity | Full-site work and coming-soon release history through `0ea76e1` are consolidated on local `main` in `/home/andre/Development/wipost165`. Live revision `2828f88` was rechecked without deployment. See [handoff](HANDOFF.md#source-consolidation--september-27-2026). |

## Work order

Status vocabulary: **ready**, **active**, **blocked** (name the dependency),
**done** (link evidence), **later** (not a launch requirement).

| ID | Outcome | Status | Depends on |
| --- | --- | --- | --- |
| SITE-01 | One understood development/release baseline | done — consolidated on local `main`; see handoff | Local source inspection |
| SITE-02 | Distinctive, intuitive public experience refined | ready | Can review now; use SITE-01 baseline for implementation |
| SITE-03 | Truthful, maintainable launch content | ready — fact gathering can start now | Owner/officer input; publisher needed only for entry/publication |
| SITE-04 | Public site and real publisher verified together | blocked | Companion CP-01 through CP-04; SITE-01 |
| SITE-05 | Full website launched and verified | blocked | SITE-02/03/04; explicit release authorization |
| SITE-06 | Improvements based on use | later | Evidence of an actual visitor or editor need |

The companion can build its publisher while SITE-02 and SITE-03 progress here.
That work belongs in its own authorized session, following the companion queue.

### SITE-01 — Establish the next development baseline

Compare the development checkout with the clean coming-soon release checkout and
its later operator fixes. Identify which full-site changes exist only locally and
which release safeguards must be retained. Do not reset, stash, or bulk-stage the
dirty checkout. Temporary checkout paths are historical pointers; verify they exist.

Done when the next implementation location and base revision are documented,
the intended changes are accounted for without losing unrelated work, and current
local checks have evidence. Prepare any necessary reconciliation locally; commit
and push only within authorization. Update HANDOFF so another session can find
the right code without reconstructing this conversation.

### SITE-02 — Refine the welcome and visitor paths

Use [PURPOSE](PURPOSE.md) and [UI/UX guidance](UI_UX_GUIDE.md) as the current brief.

Continue “In good company”: recognizable regulars give a visitor an opening for
conversation without assuming why they came. Fellowship and service are central;
family welcome should be apparent in useful details without recasting the Post.
Use [audience context](POST_MEMBERS.md), [community context](COMMUNITY.md),
[mission](LEGION.md), and [brand sources](brand/README.md).

Evaluate the actual Rails experience as someone arriving alone, a household
planning a first visit, and a visitor who simply needs event information. Carry
each through introductions, event details, what to expect, and a reachable contact.
Keep the shared-table idea useful across those paths; avoid replacing it with a
generic stack of text panels. Layout, navigation, graphics, and copy can evolve.

Done when the paths work on desktop and a narrow phone, including keyboard use,
reduced motion, zero/fewer than three introductions, long text, missing portraits,
no upcoming events, cancellations, and feed outages. Record rendered screenshots
and findings for owner review without requiring localhost access. No new hosting
or mockup publication is implied. Keep fictional content clearly labelled.

### SITE-03 — Prepare launch content and its ownership

Use [content notes](content-notes.md) as leads, not verified facts. Record which
facts were confirmed, by whom/what source, and when; keep private contacts and
consent evidence out of this public repository.

- Obtain approved public names, short introductions, stories, and usable portraits
  for willing regulars. Aim for three; the implementation must support fewer.
- Confirm public contact, venue/address, arrival instructions, accessibility and
  family participation details where known. Do not make promises from assumptions.
- Review membership/help links and any eligibility or benefits claims against
  current authoritative sources before publishing them.
- Identify who keeps static public facts current and who will manage published
  stories/events. Record the owner's choice of initial publishing authority in
  the companion's appropriate private workflow, not as a grant made by this roadmap.

Done when launch copy is verified, a usable public contact path exists, missing
facts are omitted honestly, and real content has an owner. Enter/approve content
through the companion once available. Zero public events can be legitimate; do
not fabricate listings or require three people to exist before the UI can work.

### SITE-04 — Verify the publishing connection

Follow [contract revision 3](public-publishing-api-v1.md) and the
[companion queue](companion-work-queue.md). Use synthetic test content for lifecycle
exercises; do not cancel real events or withdraw real stories just to test behavior.

Verify story publication/edit/rotation/withdrawal, consent and portrait replacement,
event rescheduling/cancellation/restriction/deletion, and calendar boundary cases
across both applications. Check 304/ETag handling, complete interval replacement,
the five-minute total freshness budget, and failure after cache expiry. Confirm
private fields and internal activities cannot reach anonymous responses.

Done when publisher tests, consumer tests, and cross-application evidence agree;
the target deployment's `bin/publisher-check` passes; and rendered pages/portraits
work against that publisher with preview off. The script checks collections only:
it does not prove detail, portrait, permission, or revocation behavior by itself.
Record revisions/environment and any remaining limitations. Do not silently alter
the contract to accommodate an implementation mismatch.

### SITE-05 — Release the full site

Before release, verify the intended full-site revision with `bin/ci`, production
asset/container checks, and final phone/desktop visitor paths. Review page titles,
search/share metadata, canonical hostname handling, indexing behavior, and broken
links; do not expose synthetic profiles in search or shared previews. Confirm an
operator can update content and understand pending schedule/location changes.

Prepare the concrete change turning off `PUBLIC_SITE_COMING_SOON`, the rollback
target, and release notes. Deploy only with authorization using [DEPLOYMENT](DEPLOYMENT.md)
and its one persistent release session. Preserve members, Two Rivers, and mail.

Done when the intended revision serves the full experience on both HTTPS domains,
real approved content or honest empty states appear, failure handling is verified,
protected services remain unchanged, and deployment/rollback evidence is recorded.
DNS/TLS success alone does not close this milestone.

### SITE-06 — Discover the next useful features

Candidates include public officer introductions, an approved photo collection,
calendar subscriptions, or improved ways to participate. These are possibilities,
not promised scope or launch blockers. Start with the visitor/editor need. Add an
API request only when the data actually belongs in the companion; establish field
ownership, publication consent, withdrawal, and maintenance before implementation.

## Session record

Keep entries short: date; task ID; changed/evidence; remaining blocker; next action.
Move lengthy histories to dated notes and link them instead of growing this file
into another transcript.

- **2026-09-27 — Roadmap created:** compared current local source, release notes,
  and companion checkout; no runtime or production changes. Next: SITE-01, then
  SITE-02; companion publisher work is separately scoped in CP-01 through CP-04.
- **2026-09-27 — Purpose and design handoff:** added the purpose and UI/UX guides,
  preserving owner feedback, visual/interaction direction, audience scenarios,
  content constraints, and review criteria. Linked agent and session entry points;
  documentation checks only. SITE-01 and rendered SITE-02 work remain open.

- **2026-09-27 — SITE-01 complete:** consolidated the full-site files, design/history documents, and original release commits onto local `main`. Runtime files match the release baseline. CI passed (33 tests, 206 assertions); live revision `2828f88` confirmed through one read-only release session. No push or deployment. Next: SITE-02 and SITE-03.
