# Public website development roadmap

Updated October 7, 2026. This is the working backlog for future sessions.
It records outcomes and dependencies, not a fixed visual specification. Improve
the design as we learn; preserve the public/private boundary and coordinate any
change to the reviewed API contract.

## Current priority — staged launch

The current design is now shareable at the owner's authorized public
[V1 Sites preview](https://post165-v1-launch-preview.andretr.chatgpt.site), generated
from Rails with the live public events feed and server-only website credentials.
The initial sample-only export was rejected and replaced. The people-based Site remains available
for V2. [Refresh instructions and evidence](design/2026-10-harbor-study/sites-preview/README.md).
This is independent of the actual Rails production service and its launch gates.

The owner's October 7 direction supersedes the former single full-site launch:
launch V1 with public events, visit/meeting guidance, contact, membership/help,
and Post identity; introduce people/photos/stories with V2 roughly a month or two
later. A local [V1 first pass and launch sequence](design/2026-10-v1-launch/README.md)
is active for review. The original full experience is preserved in the app as V2.

SITE-04/05 now gate **V1** on its consumer/event-publisher evidence, scoped real
content, browser/metadata review, container/release verification, and an authorized
release. Story/portrait/consent evidence and real introductions become **V2** work.
Do not demand V2 content to launch V1 while those public routes are disabled.
No publisher contract change is needed. The detailed September sections below
retain prior evidence and procedures; their people-before-first-launch sequencing
applies to V2. The owner subsequently rejected the broad V1 appearance while confirming the
messaging. The subsequent light-ground study was also rejected as looking the
same. [Ten outside design references](design/2026-10-outside-references/README.md)
now inform the reassessment. The owner subsequently found them too far out;
[Take the Con is the closer calibration](design/2026-10-outside-references/take-the-con/README.md)
for distinctive art direction with familiar behavior. The owner clarified that a
binder is not required. A [civic pennant study](design/2026-10-pennant-study/README.md)
now makes one direction concrete across four pages and phone layouts. The owner
disliked the banner image; the [harbor illustration revision](design/2026-10-harbor-study/README.md)
uses AI artwork based on an inspected local photograph. The owner accepted this
direction and authorized implementation with National’s branding. The
[implemented V1](design/2026-10-harbor-study/implementation/README.md) now uses it
across the live public pages. The owner subsequently requested
[national imagery research](design/2026-10-harbor-study/national-references/README.md)
to strengthen the veteran-service subject. The people-free harbor remains in use
while the distinction between anonymous illustrated people and V2 member profiles
is under discussion. Next: settle that image treatment and remaining V1 gates.

## Start here each session

Current content follow-up: the owner supplied local facts for
[About #7](https://github.com/AndreRobitaille/wipost165/issues/7),
[Membership #8](https://github.com/AndreRobitaille/wipost165/issues/8), and
[Veteran help #9](https://github.com/AndreRobitaille/wipost165/issues/9).
The shared pages are rewritten on `codex/public-page-content`, with the
[source record](public-page-facts.md) and [current layout verification](design/2026-10-footer-content/design-revision/README.md).
The owner requested that these pages match the current V1 design and omit the
dues amount. The revision retains a substantive About page and leads Membership
with visiting and participation.
Next: owner reviews and merges PR #10 into `main`. The latest instruction
also authorizes pushing and refreshing the existing public V1 Sites preview.
The Commander confirmed the first Tuesday of every month at 6:30 p.m. at the
Manitowoc Rifle & Pistol Club. Membership now matches Home and First visit;
the skipped-summer follow-up is superseded. Calendar integration is outside this PR.

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

These are recorded results, not a new production inspection.

| Area | Evidence and state |
| --- | --- |
| Hosting | Revision `5d15332` deployed with apex/www HTTPS and coming-soon enabled; see [release evidence](deployment/2026-09-27-authenticated-publisher-release.md). |
| Public experience | September V2 baseline was [owner approved](design/2026-09-visitor-paths/README.md#owner-review). The later harbor direction was accepted and [implemented locally](design/2026-10-harbor-study/implementation/README.md); service imagery is under discussion. |
| Public consumer | Database-free authenticated client, private credential-scoped caches, server-served portraits, and failure states exist. Latest local CI: 63 tests / 567 assertions; [consumer coverage](verification/2026-09-27-consumer-coverage.md) and [metadata verification](verification/2026-09-27-launch-metadata.md). |
| Publisher | Available. JSON, portraits, and conditional requests require the Post-owned read-only website token; no anonymous API access. A personal API token with the appropriate role is required for editorial API changes. This session has no such token. |
| Integration | Three fictional production stories and six portraits passed live reads and local desktop/phone rendering. The checked 90-day interval contained zero events. [Evidence and limits](deployment/2026-09-27-authenticated-publisher-release.md#populated-feed-follow-up). |
| Content | Contact, meeting/arrival facts, resource links, and content ownership are recorded in the [worksheet](launch-content-readiness.md). Real introductions/photos belong in the final prelaunch content step. |
| Source continuity | Accepted design/content and authenticated integration were committed and deployed. The subsequent development-startup correction has local changes; inspect Git before work and preserve them. |

## Work order

Status vocabulary: **ready**, **active**, **blocked** (name the dependency),
**done** (link evidence), **later** (not a launch requirement).
IDs remain stable for historical links; the scopes below supersede earlier entries.

| ID | Outcome | Status | Depends on |
| --- | --- | --- | --- |
| SITE-01 | One understood development/release baseline | done — consolidated on `main`; see handoff | Local source inspection |
| SITE-02 | Distinctive, intuitive public experience refined | active — accepted harbor direction implemented and brand-checked; [service imagery](design/2026-10-harbor-study/national-references/README.md) under review | Keep the current copy and practical interaction requirements |
| SITE-03 | Verified static facts and content ownership | done — [contact/visit facts, links, and ownership recorded](launch-content-readiness.md) | Unknown optional facts remain omitted; real people/photos moved to SITE-05 |
| SITE-04 | Consumer verified within available access; publisher evidence accounted for | active — [consumer review/fix complete](verification/2026-09-27-consumer-coverage.md); companion evidence pending | Editorial cases require evidence from an authorized companion session, not a personal token in this app |
| SITE-05 | Technical launch preparation, final real content, then release | active — metadata and [browser/link review](verification/2026-09-27-final-paths/README.md) complete; local container check blocked by Docker access | SITE-04 evidence review and resolved material launch risks |
| SITE-06 | Improvements based on use | later | Evidence of an actual visitor or editor need |

**Next work:** resolve local Docker access and run the pending container smoke
check in the [prepared release/rollback procedure](verification/2026-09-27-release-preparation.md).
The [final browser/link review](verification/2026-09-27-final-paths/README.md) passed;
metadata/indexing is prepared. Publisher-owned evidence still needs the companion
handback. These are the remaining technical gates; real people/photos stay last,
followed by focused content verification and an authorized release.

September 27 development follow-up: live publishing is now the default for a
normal dev-server start; static samples require `PUBLIC_SITE_PREVIEW=1`.
The read-only website token is configured in encrypted development credentials.
The running local server on port 3000 returned all three production profiles and
their portraits after restart. Focused page/portrait/coming-soon tests passed:
21 tests, 195 assertions; initializer lint and `git diff --check` passed.
Production configuration and deployment are unchanged.

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

### SITE-03 — Verified static facts and content ownership (complete)

The [content worksheet](launch-content-readiness.md) records confirmed contact,
mailing/meeting details, arrival/access facts, resource links, and responsibility
for corrections. Unknown optional details remain omitted. Preserve this evidence
and recheck facts when they change. Initial real introductions/photos are now
SITE-05's final content step; they do not block technical development.

### SITE-04 — Verify within the actual access boundary

Follow [contract revision 3 with the authenticated-access amendment](public-publishing-api-v1.md)
and the [companion queue](companion-work-queue.md). The website token reads only;
it cannot edit, publish, withdraw, replace portraits, change consent, or manage
credentials. This session has no role-authorized personal editorial API token.
Keep editorial credentials out of the public application and its configuration.

| Evidence layer | Work and available method | What it establishes / limits |
| --- | --- | --- |
| Consumer tests here | Use synthetic fixtures, injected HTTP responses, and a controlled clock for changes, 404/401, 304/ETag, cache expiry/outages, portrait revision changes, complete event interval replacement, and calendar boundaries. Review existing coverage before adding tests. | Proves how this app responds to publisher output; does not prove the publisher performs editorial transitions correctly. |
| Live read-only checks here | Use the website token for collections, details, portrait bytes, response headers, and rendered desktop/phone paths with preview off. Missing/invalid-token rejection can be checked without revoking a real token. | Proves observable deployed read behavior. Empty events are valid but do not verify populated event delivery. Passing `bin/publisher-check` does not prove permission or withdrawal behavior. |
| Publisher-owned evidence | Request companion tests/results for role enforcement, draft/publish behavior, rotation, consent/withdrawal, portrait replacement, event edits/cancellation/restriction/deletion, private-field exclusion, and concurrent restrictions. Use synthetic records in its authorized local/test environment. | Requires the companion's access and implementation knowledge; record its revision, environment, results, and unverified cases. Consumer simulations cannot substitute for this evidence. |
| Optional coordinated exercise | If a material gap remains, an authorized owner/companion operator changes a specifically approved synthetic record; this app observes with the website token. Prefer an isolated test environment. | Not a mandatory production checklist. A live mutation or real-token revocation needs separate authorization in the session performing it. |

Start with existing [consumer tests](../test/services/publishing_client_test.rb)
and [release/follow-up evidence](deployment/2026-09-27-authenticated-publisher-release.md).
Tests already cover several cache, authentication, withdrawal-response, and date
boundary cases; do not describe them as absent or rerun everything merely to plan.
For each remaining requirement record: evidence link, tested revision/environment,
owner, and whether it is satisfied, needs a local fix, or awaits companion evidence.
Use a focused test for a new fix, then required checks for the resulting change.

Done when consumer coverage and authenticated read/render evidence are sufficient,
and publisher-owned requirements have supporting companion evidence or an explicit
unresolved-risk decision before launch. Identify any material unverified behavior
as a launch dependency; do not silently mark it passed or demand production
mutation to prove it. Local/test publisher evidence is acceptable when its scope
and deployment applicability are recorded. Real people/photos are not required.

### SITE-05 — Prepare technically, add real content last, then release

Complete in this order:

1. **Technical readiness with fictional content.** Resolve consumer gaps; review
   phone/desktop and keyboard visitor paths, empty/unavailable states, page titles,
   search/share metadata, canonical hostname behavior, indexing, and broken links.
   Prepare the coming-soon configuration change, rollback target, and release
   notes. Verify the intended revision with `bin/ci` and appropriate production
   asset/container checks. Keep public coming-soon enabled during development.
   Existing evidence can be reused where the implementation has not changed.
2. **Final content step after technical readiness.** Obtain approved real public
   names, introductions, stories, portraits, and alt text. An authorized publisher
   enters/approves them through LegionPostTools using its editorial workflow;
   consent, image rights, and personal credentials stay there. Remove/withdraw
   fictional records that would be reachable through the public site, including
   direct detail/portrait URLs; merely taking them off the homepage is insufficient.
   Verify the resulting website-token output and affected pages/crops read-only.
   Aim for three willing regulars, but fewer or an owner-chosen honest empty state
   can launch. Zero events is valid. Confirm an operator can maintain the content.
3. **Authorized launch and verification.** After content readback and outstanding
   evidence/risk review, deploy the prepared change turning off
   `PUBLIC_SITE_COMING_SOON` and enabling `PUBLIC_SITE_LAUNCH_READY` using [DEPLOYMENT](DEPLOYMENT.md) and one persistent
   release session. Check both HTTPS domains and protected services, confirm only
   approved content or honest empty states are exposed, and record rollback and
   verification evidence. Do not expose synthetic profiles in search/shared previews.

Real introductions/photos are the last development input, followed only by their
focused verification and the release operation. Reopen technical work only if that
verification reveals a defect. Collection timing does not block preceding work.
Deploy only within explicit authorization; this plan authorizes no companion writes,
live content changes, commit, push, or deployment.

Done when the full experience serves both domains with approved content or honest
empty states, material launch dependencies are resolved, and operational evidence
is recorded. DNS/TLS success alone does not close this milestone.

### SITE-06 — Discover the next useful features

Candidates include public officer introductions, an approved photo collection,
calendar subscriptions, or improved ways to participate. These are possibilities,
not promised scope or launch blockers. Start with the visitor/editor need. Add an
API request only when the data actually belongs in the companion; establish field
ownership, publication consent, withdrawal, and maintenance before implementation.

## Session record

- **2026-10-07 — Contact and invitation refinement:** owner found the quieted
  layout flat and Contact busy. Restored a dark footer, gave the next occasion a
  red calendar date and one distinct invitation surface, and simplified Contact
  into one grouped set of details without its banner or repeated instructions.
  Preserved menu Contact, first-visit link, missing-channel behavior and all event
  data. CI: 76 tests / 738 assertions; Home/Contact at five widths, keyboard and
  empty/unavailable states checked. [Evidence](design/2026-10-harbor-study/implementation/contact-and-invitation/).
  No commit or release.

- **2026-10-07 — Quieter home:** removed the redundant “Have a question?” strip,
  changed the V1 footer to a light neutral, and simplified the event/meeting band
  using one blue surface, shorter labels, and a clearer text hierarchy.
  CI passed 76 tests / 738 assertions; five home viewport checks and mobile
  Contact passed. [Evidence](design/2026-10-harbor-study/implementation/quieter-home/).
  Local only; no release.

- **2026-10-07 — Harbor implementation and national identity:** implemented the
  accepted harbor direction across V1 with National’s primary colors, recommended
  Noto Sans fonts and unchanged official white brandmark. Added credited artwork,
  month-grouped calendar rows, expanded visit answers, and direct contact rows;
  preserved live publisher behavior and V2. Inspected Legion.org and MyLegion
  imagery after the owner raised a service-identity concern. The harbor stays
  people-free pending an answer about anonymous illustrations.
  [Implementation evidence](design/2026-10-harbor-study/implementation/README.md).
  No commit, push, publisher mutation, or deployment.

Keep entries short: date; task ID; changed/evidence; remaining blocker; next action.
Move lengthy histories to dated notes and link them instead of growing this file
into another transcript.

- **2026-10-07 — V1 interior pages and event modal:** added Home before Events;
  rebuilt Events as date cards, opened fresh details in a keyboard-accessible
  modal, replaced the card's blanket hover underlines, displayed all five visit
  answers, and grouped contact methods into separate surfaces. CI: 76 tests /
  735 assertions and all checks. Desktop/phone, modal/error/retry, keyboard,
  and JavaScript-disabled navigation were reviewed locally.
  [Review and captures](design/2026-10-v1-launch/README.md#interior-pages-and-event-modal).
  V2 and production release settings remain preserved.

- **2026-10-07 — V1 responsive composition:** owner screenshots exposed an
  awkward early stack and sparse laptop spacing. Kept the welcome/visit pair
  together above 740px, made the headline reflow below that, simplified the stacked
  visit card, and tightened type/gaps/padding. CI: 70 tests / 661 assertions and
  all checks; fourteen viewport/state combinations plus keyboard navigation passed.
  [Current review](design/2026-10-v1-launch/README.md#responsive-composition-follow-up).
  Content, V2, and release settings are preserved.

- **2026-10-07 — V1 first-visit placement:** moved first-visit guidance into the
  white card beside “Still serving,” and placed the next occasion in a dark card
  beside meeting/contact details below. Phone reading order follows the same
  sequence. CI: 70 tests / 661 assertions and all checks; ten responsive/state
  combinations, keyboard navigation, placement, and contrast passed.
  [Current review](design/2026-10-v1-launch/README.md#first-visit-card-moved-into-the-welcome).
  Public facts and V2 are preserved; no release action.

- **2026-10-07 — V1 cards and color:** owner clarified that the white surfaces
  needed borders/cards/color rather than more typographic emphasis. Split the
  practical section into three framed cards, boxed event/contact details, and
  added a red calendar date. CI: 70 tests / 661 assertions; final responsive CSS
  compiled afterward. Ten viewport/state captures, keyboard navigation, and new
  contrast pairs passed. [Review and captures](design/2026-10-v1-launch/README.md#cards-and-color-follow-up).
  V1 remains local for review; V2 and public facts are preserved.

- **2026-10-07 — V1 typography refinement:** owner liked the first pass and asked
  for more character in the white surfaces. Strengthened date/schedule typography,
  practical headings, and labeled event/contact details. CI: 70 tests / 661
  assertions; desktop/phone/sparse/long-title captures and keyboard focus passed.
  [Updated review](design/2026-10-v1-launch/README.md#owner-review-and-white-surface-typography-refinement).
  No public facts, V2 behavior, commit, or deployment changed.

- **2026-10-07 — staged V1/V2 first pass:** implemented a photo-free launch layout
  and welcome using recorded Post facts and the live event consumer. V1 disables
  people reads/context, stories, and portraits; V2 source is preserved. Review and
  verification: [design note](design/2026-10-v1-launch/README.md). Existing local
  changes are preserved; no commit, push, publisher mutation, or deployment.

- **2026-09-27 — SITE-05 final paths and release preparation:** Chromium passed 42
  page/width combinations, keyboard/reduced-motion, live fictional portraits,
  click-through/context, fallback, and empty/outage checks. All 58 local link
  targets and three launch external destinations passed; preview-only photo credits
  returned inconclusive 403s. [Evidence](verification/2026-09-27-final-paths/README.md).
  Local release/shell checks passed. [Container and rollback procedure](verification/2026-09-27-release-preparation.md)
  prepared, but Docker socket access is denied and noninteractive sudo requires a
  password. No container build or remote fallback. Next: local Docker access and
  companion evidence, then real content last. No application edits or deployment.

- **2026-09-27 — SITE-05 metadata/indexing:** added production-only launch readiness,
  neutral preparation metadata/noindex, page-specific release metadata, and apex
  canonical URLs without query context. Ten integration cases cover launch/preview,
  errors, expiry, escaping, cancellation, and portrait headers. CI passed: 63 tests /
  567 assertions. [Evidence and limitations](verification/2026-09-27-launch-metadata.md).
  No production requests or deployment; next: final visitor-path/link review and
  container/release preparation. Real people/photos remain last.

- **2026-09-27 — SITE-04 consumer evidence review:** mapped existing tests and
  recorded live reads; added seven validator/lifecycle tests and fixed acceptance
  of mismatched/missing 304 ETags. CI passed: 53 tests / 333 assertions; single-worker
  test rerun passed without parallel Bundler cleanup errors. [Evidence and limits](verification/2026-09-27-consumer-coverage.md).
  Companion permission/editorial/event evidence remains pending; no production
  reads or mutations performed. Next: SITE-05 metadata/indexing and technical launch
  preparation. Real content stays last; no commit, push, or deployment.

- **2026-09-27 — Owner-directed plan correction:** split verification into local
  consumer tests, live website-token reads, and companion-owned editorial evidence.
  No personal editorial token is available here. SITE-03 static content is complete;
  real people/photos move to the final SITE-05 content step after technical readiness.
  Updated current handoff/queue and stale API handoff transport facts. Documentation
  checks only; no runtime checks, production reads, or editorial mutations performed.
  Next: focused SITE-04 coverage/evidence review, then technical launch preparation.

- **2026-09-27 — Authenticated website connection:** implemented the owner's
  Post-owned read-only bearer contract for JSON, conditional requests, and portraits.
  Images now pass through the website server; caches are private, credential-scoped,
  and cleared on authentication denial. Live featured/events reads succeeded with
  empty collections. CI passed (46 tests, 293 assertions), security/style/autoload
  and production assets passed. Commit/push/deploy authorized. Live placeholder
  creation is delegated through the [content-session prompt](publisher-content-prompt.md)
  and requires separate editorial authentication. Existing design/content work is
  included in this release; no companion application code is changed. Deployed
  `5d15332` through one persistent session; both public domains healthy and still
  showing coming soon. Container feed check passed; members/Two Rivers unchanged.
  [Release evidence](deployment/2026-09-27-authenticated-publisher-release.md).

- **2026-09-27 — Synthetic API placeholders:** generated three fictional portraits
  and created authored drafts through the companion's local editorial API
  (ids 5, 6, 7). [Assets, content, and API evidence](design/2026-09-api-placeholders/README.md)
  record both crop sizes and API readback. The owner subsequently explicitly
  authorized synthetic-only consent, publication, and homepage placement: all three
  are published and featured in Avery/Morgan/Sam order. Verified audit history,
  anonymous collection/details, and all six public portrait responses/browser
  decodes. No production or consumer configuration change. Next: SITE-04 HTTPS
  consumer integration using the available synthetic content.

- **2026-09-27 — Companion output handoff:** prepared [the API request](publisher-api-request.md) against the current consumer and synthetic fixtures. Reframed the companion queue as delivery outcomes without adding internal/admin requirements. The owner clarified that the earlier contract was coauthored by the companion agent; corrected an overly broad disclaimer so the handoff does not revoke jointly reviewed decisions. No runtime or companion changes. Documentation/fixture compatibility checks only; next: owner runs the task in LegionPostTools and returns interface, access, examples, and verification evidence.

- **2026-09-27 — SITE-03 owner intake:** sourced contact, postal address, and regular meeting details from the owner's supplied page. Added the owner's meeting attendance and gravel/no-steps details; recorded the owner as content contact and shared enquiry monitoring with the service officer. [Local implementation and browser evidence](design/2026-09-content-intake/README.md): CI passed (36 tests, 234 assertions), contact/visit at 320/1440px, keyboard disclosures, link targets, and blank overrides. Existing design/work preserved. Next: approved introductions/photos collected at the next PEC and possibly member meeting; grants/publication remain separate. No companion, commit, push, or deployment action.

- **2026-09-27 — Roadmap created:** compared current local source, release notes,
  and companion checkout; no runtime or production changes. Next: SITE-01, then
  SITE-02; companion publisher work is separately scoped in CP-01 through CP-04.
- **2026-09-27 — Purpose and design handoff:** added the purpose and UI/UX guides,
  preserving owner feedback, visual/interaction direction, audience scenarios,
  content constraints, and review criteria. Linked agent and session entry points;
  documentation checks only. SITE-01 and rendered SITE-02 work remain open.

- **2026-09-27 — SITE-01 complete:** consolidated the full-site files, design/history documents, and original release commits onto local `main`. Runtime files match the release baseline. CI passed (33 tests, 206 assertions); live revision `2828f88` confirmed through one read-only release session. No push or deployment. Next: SITE-02 and SITE-03.
- **2026-09-27 — SITE-02/03 local preparation:** refined phone navigation, table/detail layouts, portrait and sparse-content states, event timing/cancellations, and first-visit/contact paths. [Review captures and verification](design/2026-09-visitor-paths/README.md): CI passed (36 tests, 234 assertions), browser checks at 320/390/1440px, keyboard, reduced motion, and no-JavaScript navigation. [Content readiness](launch-content-readiness.md) records verified National/county links and outstanding local facts. Next: owner visual review and public contact/arrival confirmation; companion integration remains blocked separately. No commit, push, or deployment.
- **2026-09-27 — SITE-02 accepted:** owner reviewed the desktop capture and liked the current design without requesting changes. Recorded approval of the visual direction; the agent's optional spacing critique is not requested work. SITE-02 is complete for this local refinement. Next: SITE-03 public contact/arrival facts and content ownership; SITE-04/05 dependencies remain. Documentation-only update; no release authorization implied.
- **2026-09-27 — Session handoff requested:** added an explicit [resume checklist](HANDOFF.md#resume-next-session), preserving the accepted design, uncommitted work, verification evidence, stopped preview processes, and next content questions. Updated baseline links to the current screenshots. Documentation checks only; no runtime or release action.

- **2026-10-07 — V1 visual reassessment:** owner rejected the blue field and
  repeated white panels, while confirming the messaging. Prepared an isolated
  interactive direction across Home, Events, First visit, Contact, and supporting
  pages; [design rationale and captures](design/2026-10-visual-reset/README.md).
  Reopened SITE-02 and corrected current guidance so prior card refinements are
  not treated as approved design. Application/V2 files and production are unchanged.

### October 7 — outside design research after the second rejection

Researched ten non-Legion/veterans websites and captured representative views,
including practical interiors and selected interactions. Recorded concrete lessons,
limits, unavailable candidates, and the need for original art direction in the
[reference review](design/2026-10-outside-references/README.md). Both earlier V1
studies remain rejected. SITE-02 stays active; no application code, release state,
or preserved V2 implementation changed.

### October 7 — footer content briefs and First visit meeting panel

Created the three owner-requested content issues above for Grok enrichment. The
owner approved the previous Home/Contact refinement and asked to improve the
solid red meeting panel. Replaced it with a light schedule/location note and a
directions link, keeping the expanded answers and verified meeting details.
[Review evidence](design/2026-10-harbor-study/implementation/visit-meetings/README.md):
five widths through 320px, keyboard focus, contrast, and CI (76 tests / 738 assertions).
Local implementation only; no content rewrite, commit, push, or deployment.

### October 7 — source commit/push and separate public Sites preview

Owner authorized the current source handoff and a public, no-sign-in V1 preview.
Rendered eight current Rails pages into a separate Sites project with sample-only
calendar content and working event modal. Preserved the existing people-based Site
for V2. [Published URL, identities, refresh procedure, and checks](design/2026-10-harbor-study/sites-preview/README.md).
All 24 page/width combinations and modal keyboard checks pass; CI passes 76 tests /
738 assertions and local release checks pass. Added `main` to GitHub push checks
alongside `master`; retained local-only development credentials. Production unchanged.

### October 7 — correct the working Sites deployment

Replaced the rejected static/sample calendar export with Rails-generated page
templates and a Sites Worker using the authenticated live public events feed.
The read-only website token is stored only as a server-side Sites secret. The same
public V1 URL now serves real dates and event dialogs; the V2 concept and Hetzner
production are unchanged. CI passes Rails 76/738 plus nine adapter tests. Eight
routes match Rails at 1440/390/320px; hosted calendar and asset checks pass.
[Deployment identity and refresh instructions](design/2026-10-harbor-study/sites-preview/README.md).

### October 7 — About, Membership and Veteran help content pass

Added the owner's complete fact sheets verbatim and updated the readiness
worksheet's stale dues/joining rows. Reworked the three shared pages into an
editorial local-service narrative, visible membership questions, and a crisis-first
help guide. Retained role-based contacts and graceful hidden-contact states.
[Review notes](design/2026-10-footer-content/design-revision/README.md) record source differences,
omissions and desktop/phone screenshots for both editions. CI passes 78 Rails
tests / 902 assertions plus nine Sites adapter tests; browser checks cover all
three pages at 1440/390/320px, keyboard focus, enlarged text and hidden channels.
Prepared on a new branch from `main` for one owner-reviewed PR targeting `main`.
No merge, Sites refresh, production deployment or companion change.

### October 7 — align the footer pages with the current V1 design

Owner feedback identified that the three pages still used the narrow article
wrapper. Removed that wrapper for these routes and reused the current V1 heading,
type, colors and open layouts. About keeps the sourced service examples and 1928
memorial history; Membership replaces the price callout with a visit invitation
and moves optional participation first; Veteran help has a wide crisis panel and
two clear local routes. The dues amount is removed from public copy and metadata,
while the supplied fact sheet is unchanged. Both editions and hidden contact
states are verified; CI passes 78/902 plus nine adapter tests.
[Current screenshots and decisions](design/2026-10-footer-content/design-revision/README.md).
This updates PR #10 for owner review, with no merge or deployment.

### October 7 — final PR #10 review corrections

Applied the Commander’s monthly meeting and dues-publication decisions, corrected
About’s pillar/grouping and title, and refined transfer and unavailable-contact
copy. Consolidated still-valid source notes, including the renewal-date conflict,
into the design revision and removed the superseded first-pass evidence set.
The owner requested code/PR updates, push and a V1 Sites refresh without new
screenshots. No merge, preserved V2 Site update or Hetzner deployment.

CI passed 78 Rails tests / 902 assertions and nine adapter tests plus all other
checks. Pushed the fixes to PR #10 and published Sites version 3 successfully at
the existing public V1 URL, preserving the runtime secret.
[Deployment record](design/2026-10-harbor-study/sites-preview/README.md).

### October 7 — qualify the Guard homecoming example

Changed About’s habitual wording to completed participation after the Commander
clarified this was a recent activity. Recorded the distinction in the source and
review notes, retaining draft-minutes provenance. CI passed 78/902 plus nine
adapter tests. Pushed to PR #10 and published Sites version 4 successfully with
the existing secret unchanged.
