# Project handoff

## October 8 — national purpose beneath the local invitation

Added “Part of something bigger” after the liked three cards and before the
final first-visit actions. The blue introduction links to Post 165's About page;
the adjoining area explains all four official pillars and links to National.
National wording was checked against its current primary sources and recorded
in the public facts. No new local services or program promises are introduced.
CI passed 78/934 plus nine adapter tests; both editions passed five-width,
keyboard, link, reading-order and enlarged-text checks. No screenshots.
Published as Sites version 9 with runtime secret revision 1 unchanged; PR #10
contains the change for owner review. The V2 Site and Hetzner remain unchanged.

October 8 card refinement: added fine blue borders and 16px gaps to the three
Why cards, and strengthened the left card's blue tint so it differs from the
section below. CI passed 78/934 plus nine adapter tests; both-edition responsive
and keyboard checks passed. Published as Sites version 8; secret revision 1
unchanged. The three-panel content and hero remain as reviewed below.

## October 8 — three reasons beneath the invitation

Kept “Pull up a chair” and its illustration. At the owner's request, replaced
“A few more people” with a connected three-panel strip: Share a laugh
(camaraderie), Lend a hand (community/youth/remembrance), and Have each other's
backs (Buddy Checks and Service Officer referrals). The opening jump link and
its unused anchor/focus styling are removed; the invitation to visit remains at
the bottom. Panels stack at narrow widths and within V2's narrower table.
The [design record](design/2026-10-why-invitation/README.md) explains the pillar
inspiration and preserves the illustration's prompt. No new assets or scripts.
CI passed 78/934 and nine adapter tests; ten browser page/width checks plus
keyboard navigation and enlarged text passed, with no screenshots.
Committed as `98d0063` on PR #10 and published as Sites version 7 at the existing
public V1 URL. Runtime secret revision 1 remains unchanged.

## October 8 — invitation revision

The owner rejected the first Why the Legion page as a newspaper-like collection
of rational arguments that exposed internal audience knowledge. Replaced it with
“Pull up a chair”: one people-free painted invitation, a short passage about good
company and actual Buddy Checks, and a direct path to events/First visit. Membership
stays secondary. Home no longer recites the resident categories either.

The new illustration is a symbolic shared table, not the meeting venue or evidence
of a regular coffee gathering. No members, testimonials or attendance promises
are invented. National colors, Noto typography and the existing logo remain.
See the [design and asset record](design/2026-10-why-invitation/README.md).
CI passes 78 tests / 934 assertions and nine Sites adapter tests, with all style,
security, autoload and asset checks. Local browser checks passed 15 page/width
combinations, keyboard navigation and enlarged text; no screenshots. The prior
first pass below records history, not an approved design.

Published the revision as Sites version 6 at the existing public V1 URL, with
runtime secret revision 1 unchanged. Source commit `ca2cb2a` is pushed to PR #10.
The V2 Site and Hetzner production service are unchanged. Owner review is next.

## October 8 — Why the Legion first pass

The owner identified a gap before the first-visit path: the site needs to explain
why someone might want the Legion in their life at all. They described three
veteran audiences: people born here who returned after service, residents who
chose Two Rivers years ago, and recent movers. [The audience brief](AUDIENCE.md)
records that framing and possible motivations, hesitations and content needs.
Purpose and Community now foreground fellowship and optional service rather than
assuming visitors already want to attend or volunteer.

Implemented `/why-the-legion` as a shared page, with a V1 main-menu link and a
homepage introduction that leads with the reason to belong. The page moves from
shared experience and local connection to mutual helpfulness, a clear statement
that company is enough, and optional local involvement and national advocacy.
It offers events and First visit before practical membership answers. The five
V1 navigation links wrap at phone widths, without a new menu interaction.
V2 can render the page and links it in the footer; its people-based homepage and
separate published concept are preserved.

The new page uses the existing Noto faces and Legion palette, open columns,
and one dark statement band. No new pictures, cards, testimonials, recurring
activities or member-only assistance benefits are invented. Local claims come
from the existing fact record; National advocacy was checked against its public
site on October 8. CI passes 78 tests / 934 assertions and nine Sites adapter
tests, plus style/security, autoload and production assets. Browser checks passed
15 page/width combinations: Why the Legion? in both editions and V1 Home at
1440/900/700/390/320px, with no horizontal overflow or missing images. Keyboard
navigation and 200% root-text reflow passed. No screenshots were taken. Sites
version 5 successfully published the page and updated homepage at the existing
public V1 URL; see the [deployment record](design/2026-10-harbor-study/sites-preview/README.md). Next: owner reviews the
wording and balance of the invitation against the audience brief.

## October 7 — footer content ready for owner review

The owner supplied the complete [public page fact sheets](public-page-facts.md)
for issues #7, #8 and #9. Branch `codex/public-page-content`, created from `main`,
implements About's local service/history narrative, Membership's meeting-based
joining guide, and Veteran help's crisis-first Service Officer and county routes.
The owner then requested the current V1 design for these pages and removal of the
dues amount. The [revised layouts](design/2026-10-footer-content/design-revision/README.md)
now use V1's full-width headings and page compositions, preserving V2's table and
independently configured contact channels. Membership leads with visiting and
optional participation; the dues amount remains only in the supplied source record.
The [readiness worksheet](launch-content-readiness.md) records these decisions.

[Consolidated source and review notes](design/2026-10-footer-content/design-revision/README.md)
retain the National renewal-date discrepancy and the public calendar boundary:
regular member meetings are excluded from that feed. The Commander confirmed
that pages should state the first Tuesday of every month at 6:30 p.m. at the
Manitowoc Rifle & Pistol Club. Membership now matches Home and First visit;
there is no remaining skipped-summer follow-up or calendar integration in this PR.
The source record retains $45 with an explicit instruction not to print the amount.
Final review also separates About’s Community and youth work, corrects the
Americanism label and About title, and refines hidden-contact and transfer copy.

The owner authorized pushing the updates to
[PR #10](https://github.com/AndreRobitaille/wipost165/pull/10) and refreshing the
existing public V1 Sites preview, without new screenshots. Owner review and merge
remain next. CI passed 78 Rails tests / 902 assertions and nine Sites adapter
tests plus style/security, autoload and production assets. The existing
[V1 preview](https://post165-v1-launch-preview.andretr.chatgpt.site) now serves the
reviewed pages: Sites version 4 reported a successful deployment with the existing
server-side secret revision unchanged. [Deployment record](design/2026-10-harbor-study/sites-preview/README.md).
The preserved V2 Site and Hetzner production service are unchanged.

Latest copy clarification: the Guard homecoming line describes completed
participation (“Members have also turned out…”), not a recurring commitment.
The source record retains the October 6 draft-minutes status and the Commander’s
October 7 confirmation that this was a recent activity. CI passed again, and the
correction is included in PR #10 and the V1 Sites preview.

## October 7 — shareable V1 preview and source handoff

The owner authorized committing/pushing the current work and publishing a separate
public Sites preview. [The new V1 preview](https://post165-v1-launch-preview.andretr.chatgpt.site)
is public without sign-in. The initial deployment incorrectly replaced the live
calendar with sample content. The owner requested the working site, with attention
to API keys. The corrected build uses Rails-generated templates and assets with
a Sites Worker that reads the same live public events feed; the read-only website
token is a server-side Sites secret. No AI API key is needed. The [older people-based Site](https://post165-in-good-company.andretr.chatgpt.site)
remains unchanged for V2. [Identity, refresh procedure, and verification](design/2026-10-harbor-study/sites-preview/README.md)
record the successful Sites deployment. This does not deploy the Rails production
service. The owner subsequently authorized refreshing this same V1 Site with the footer
content pass above before merge.

The incoming `main` deploy-hold guidance was fast-forwarded from GitHub. The current
work was on `main`; GitHub's default branch remains `master`. CI now covers pushes
to both. Local development credentials and keys stay ignored. Local CI passes
76 tests / 738 assertions, and `bin/release check` passes without server access.

## Current work — October 7, 2026: staged V1/V2 launch

The owner requested a first launch without people/photos/stories, preserving the
full current experience for V2 in roughly one or two months, and authorized a
local first pass. See the [V1 design and launch plan](design/2026-10-v1-launch/README.md).
V1 now has a dedicated welcome/layout and the existing practical pages, with
people reads/context and direct story/portrait access disabled. V2's original
layout, homepage, and shared-table styles remain available with
`PUBLIC_SITE_EDITION=v2`. Default development now shows V1; publisher reads remain
live by default and preview remains explicit. Sample artwork has moved to
`app/assets/preview/people` and is excluded from production V1 builds.
The owner rejected both the broad V1 card treatment and the subsequent
[light-ground study](design/2026-10-visual-reset/README.md), which still looked the
same to them. The copy remains good. The latest task researched
[ten sites outside the Legion/veterans space](design/2026-10-outside-references/README.md)
with browser captures and specific transfer lessons. Legion marks/colors remain
identity references; ordinary Legion websites are not the aesthetic benchmark.
The owner found those references too far out and identified their own Take the
Con as a closer benchmark. The [latest calibration](design/2026-10-outside-references/take-the-con/README.md)
favors distinctive, tactile art direction with straightforward website behavior.
The owner clarified that Take the Con does not imply a literal binder. A new
[civic pennant study](design/2026-10-pennant-study/README.md) now explores one
direction across Home, Events, First visit, and Contact, including phone layouts.
The owner disliked its banner image and suggested AI imagery based on real local
photos. The latest [harbor illustration revision](design/2026-10-harbor-study/README.md)
uses an inspected, credited photograph of Two Rivers as the generation reference
and replaces the banner in the four-page study. The owner accepted the direction
and authorized implementation using National’s brand guide. V1 now implements
that composition across Home, Events, First visit, and Contact, with live calendar
data, expanded answers, direct contact channels, and the existing event modal.
See [implementation and checks](design/2026-10-harbor-study/implementation/README.md).
National’s exact blue/red, recommended Noto Sans, and unchanged white brandmark
replace the study’s approximate palette. Artwork retains source/license credit.

The owner also raised a service-identity concern and requested National imagery
research. [Both sites were inspected](design/2026-10-harbor-study/national-references/README.md):
recognizable veteran life and shared activities carry their imagery. The harbor
currently remains a people-free setting with “Veterans serving Two Rivers” and
the next published occasion foregrounding purpose. An optional question about
anonymous illustrated people remains unanswered.

Next: settle that imagery distinction with the owner, then address the remaining
V1 release evidence. Local implementation is ready for review, not deployed.
Real people/photos and story/portrait lifecycle evidence move to V2; event
eligibility, private-field exclusion, event lifecycle, and operational checks still
apply to V1. The existing deployment settings remain coming-soon `1` / launch-ready
`0`. No commit, push, publisher mutation, or deployment is authorized by this pass.
The September entry below preserves earlier technical evidence and pending work;
its requirement to collect real people before the first launch is superseded.

Latest refinement: the owner found the light-footer version flat and Contact
busy. Restored the dark footer; the next occasion now has one raised invitation
surface and a red calendar date, with the regular meeting beside it. Contact
uses a short introduction and one grouped email/phone/mail surface, with a direct
meeting-location link. Removed its large heading banner and duplicate instructions.
The removed Home contact strip stays removed. [Current review](design/2026-10-harbor-study/implementation/contact-and-invitation/)
covers desktop through 320px and missing-contact/empty/outage states; CI passes
76 tests / 738 assertions. Earlier light-footer screenshots are superseded.

Latest harbor implementation: CI passed 76 tests / 738 assertions, all four main
pages passed five viewport sizes, and modal/error/no-JavaScript checks passed.
See [the current evidence](design/2026-10-harbor-study/implementation/README.md).

The owner approved the Home/Contact refinement above, then requested a better
meeting panel on First visit. The red block is now a light meeting note with a
restrained red accent, grouped schedule, separated venue, and a directions link.
[Review evidence](design/2026-10-harbor-study/implementation/visit-meetings/README.md)
covers five widths, keyboard focus, contrast, and passing CI (76 tests / 738 assertions).
The requested footer content briefs are now GitHub issues for owner-directed Grok
work: [About #7](https://github.com/AndreRobitaille/wipost165/issues/7),
[Membership #8](https://github.com/AndreRobitaille/wipost165/issues/8), and
[Veteran help #9](https://github.com/AndreRobitaille/wipost165/issues/9).
Their supplied local facts have now been incorporated in the review branch
described at the top of this handoff.

Earlier V1 verification: CI passed 76 tests / 735 assertions plus style/security,
autoloading, and production assets. Browser checks passed 27 page/width combinations
and empty/outage/long-title states, keyboard, reduced motion, and JavaScript-disabled
navigation. [Captures and limits](design/2026-10-v1-launch/README.md#verification).
The latest interior review adds desktop/phone composition checks and modal
keyboard, cancellation, unavailable/missing response, and retry coverage. Direct
event links and the five expanded visit answers also work with JavaScript off.
V1 is previewable on port 3001 with live events; V2 on port 3002 with labelled
offline samples. No production inspection or deployment occurred.

## Session entry point — September 27, 2026

**Latest integration update:** the owner's revised publisher now requires a
Post-owned read-only website token, including portraits. The local consumer sends
that token server-side, serves portraits through its own route, and keeps caches
private and separated by credential. Production encrypted credentials are prepared;
the key stays ignored. Live authenticated checks returned valid empty featured and
event collections. CI passed with 46 tests / 293 assertions. Revision `5d15332`
was committed, pushed to `origin/main`, and deployed; both public domains remain
in coming-soon mode. The deployed container's authenticated feed check passed and
protected services were unchanged. See [release results](deployment/2026-09-27-authenticated-publisher-release.md).
The owner subsequently reported that Grok published the three fictional
introductions in production. A fresh authenticated check verified Avery, Morgan,
and Sam in that order, all three story details, and both portraits for each.
Local desktop/phone rendering against the live feed passed; production still
serves coming-soon. See the [populated-feed follow-up](deployment/2026-09-27-authenticated-publisher-release.md#populated-feed-follow-up).
Older anonymous-feed and pending-authorization notes below are historical.

**Development startup correction:** ordinary `bin/rails server` now uses the live
publisher by default. Encrypted development credentials contain the read-only
website token; the development key stays ignored. Static sample content requires
an explicit `PUBLIC_SITE_PREVIEW=1`. The owner's running server on port 3000 was
restarted and verified with all three published profiles and portraits.

Follow [ROADMAP](ROADMAP.md) for current work and record session progress there.
Read [PURPOSE](PURPOSE.md) for why the public site exists and
[UI/UX and visual guidance](UI_UX_GUIDE.md) for the owner's design intent,
rejected approaches, and review criteria. [Development](development.md) covers
the runtime and verification. These entry points avoid needing the old conversation.
The development and release histories are consolidated on `main` in
`/home/andre/Development/wipost165`. SITE-01/02 and SITE-03 static facts/ownership
are complete. **Next: resolve local Docker access for the pending container smoke
check and obtain the remaining companion evidence.** [Final browser/link review](verification/2026-09-27-final-paths/README.md)
is complete, and the [release/rollback procedure](verification/2026-09-27-release-preparation.md)
is prepared. Real people/photos remain the last content step after technical
readiness; no launch is authorized or complete.

Current architecture: separate Rails public service, no database or public editor,
content administration in LegionPostTools, and a token-authenticated read-only
publishing API. No anonymous publisher API access exists. Editorial API mutations
require a personal API token with the right role; this session has no such token.
The public consumer must not acquire editorial credentials to make testing possible.
The full consumer and authenticated reads work; production's last recorded state
remains coming-soon. See the [verification split](ROADMAP.md#site-04--verify-within-the-actual-access-boundary)
and [companion evidence queue](companion-work-queue.md).

## Resume next session

- **Next technical task:** complete the local container smoke check once Docker
  access is available. The socket denied access even after sandbox escalation;
  `sudo -n` needs a password. No daemon/socket permissions were changed. Use the
  [prepared procedure](verification/2026-09-27-release-preparation.md), with no remote
  builder fallback. Companion editorial/permission/event evidence remains pending.
- **Completed local readiness:** metadata/indexing and [final visitor/link QA](verification/2026-09-27-final-paths/README.md)
  passed. There is no new design request. Current local release settings remain
  coming-soon `1` / launch-ready `0`. Add real content only after remaining technical
  gates, then verify it and perform a separately authorized release.
- **Accepted design:** the owner approved the shared-table composition.
  [Approval and screenshots](design/2026-09-visitor-paths/README.md#owner-review).
  The agent's optional spacing critique is not unfinished work.
- **Preserve local work:** inspect Git before editing. Accepted design/content and
  integration were committed/deployed; development-startup changes remain local,
  including encrypted development credentials. Preserve ignored keys and unrelated
  changes. Older counts of uncommitted design work and branch divergence are historical.
- **Settled content:** [contact/visit facts and responsibility](launch-content-readiness.md)
  are recorded. Do not repeat resolved questions. Unknown optional facts stay omitted.
  Consent, real-person material, and publishing authority belong in the private
  companion workflow at the final content step.
- **Latest application verification:** metadata changes passed single-worker CI with
  63 tests / 567 assertions, style/security checks, autoloading, and production
  assets. Local boot checks verified the production-only launch switch. Generated
  assets were clobbered afterward; no server was restarted. Application changes,
  tests, and deployment-setting preparation remain uncommitted and undeployed.
- **Latest browser/release review:** 42 page/width combinations and 58 local link
  targets passed; actual click context, keyboard, fallback, and reduced motion
  worked. Launch external destinations returned 200; preview-only photo credits
  returned 403. Local release and shell syntax checks passed. QA servers/browser
  sessions were stopped; no application code changed or full CI repeat was needed.
- **Existing evidence:** full CI passed with 46 tests / 293 assertions for the
  authenticated release. The development-startup correction passed 21 focused tests /
  195 assertions. Three live fictional stories and six portraits rendered on desktop
  and phone. See [release/follow-up evidence](deployment/2026-09-27-authenticated-publisher-release.md).
  Repeat checks for changes or unresolved gaps, not just to resume planning.
- **Development:** ordinary `bin/rails server` uses the live publisher with encrypted
  development credentials. `PUBLIC_SITE_PREVIEW=1` explicitly selects static samples.
  Follow [development](development.md); recheck running processes before restarting.
- **Release boundary:** production remains coming-soon in the latest recorded check.
  Plan edits do not authorize companion changes, live publication, commit, push, or
  deployment. No production inspection was performed for this plan correction.

## Historical session records

The entries below preserve prior work and authorization boundaries. Their next-step
instructions are superseded by the current roadmap and resume checklist above.

## Companion handoff scope — September 27, 2026

The owner will run publisher work in the other repository. This public-site
session prepared [the requested output handoff](publisher-api-request.md), checked
against the current consumer and synthetic fixtures. It specifies JSON, portraits,
public lifecycle/freshness behavior, and evidence/access details to return.
It leaves companion architecture, permissions design, and site/admin operation
to that repository and adds no internal/admin requirements. The owner clarified
that the earlier contract was coauthored by the companion agent: the new handoff
does not unilaterally revoke those jointly reviewed decisions. Proposed departures
should be identified, with external-interface changes coordinated with the consumer.
No companion inspection, edit, or deployment was performed for this handoff.
Documentation and fixture compatibility checks only; runtime code is unchanged.

## SITE-03 owner intake — September 27, 2026

Resumed content preparation with focused contact and first-visit questions.
The [worksheet](launch-content-readiness.md) now provides a public fact/provenance
record, ownership/correction follow-up, and a mapping to existing configuration,
static visit copy, and publisher fields. Published introductions require an
approved portrait under v1; missing-image fallback is a display behavior.

The owner supplied the existing public contact page, then confirmed that visitors
may attend a regular meeting without arranging it, while an event is the preferred
first experience. Gravel parking and no steps are the known club access details.
Contact defaults, mailing address, and meeting/visit copy are implemented locally.
The owner is the current content contact and monitors enquiries along with the
service officer; those responsibilities are not added to public copy.

Introductions/photos await collection at the next PEC and possibly member meeting.
SITE-03 remains active for that material and the separately authorized publishing
workflow. CI passed (36 tests, 234 assertions); [focused browser evidence](design/2026-09-content-intake/README.md)
covers contact/visit content. Prior changes and screenshots were preserved; no
layout redesign, companion change, commit, push, or deployment occurred.

## Visitor-path refinement — September 27, 2026

SITE-02 is complete for the local refinement: implementation and QA passed, and
the owner approved the desktop visual direction without requesting changes.
See [rendered phone/desktop paths and states](design/2026-09-visitor-paths/README.md).
Interior pages now lead with their destination; the welcome supports sparse/long
introductions, phone quick navigation stays visible, and calendar/contact states
remain useful without invented facts. CI passed (36 tests, 234 assertions), with
browser, keyboard, reduced-motion, and no-JavaScript evidence in the review note.

SITE-03 has [verified resource links and a local fact checklist](launch-content-readiness.md).
Next inputs: a monitored public contact and actual first-visit
arrival/access information. Approved introductions and content ownership remain
open. Companion publishing/integration is still separate. No commit, push,
deployment, or companion changes were made in this refinement session.

## Source consolidation — September 27, 2026

`main` includes the full Rails site, design research, current project guides, and
all coming-soon release commits through `0ea76e1`. The application and operator
files already matched the release checkout; reconciliation preserved the newer
local documentation and historical cleanup. Local secret files remain ignored.
Use this checkout and branch for future development and authorized releases.

`bin/ci` passed: 33 tests, 206 assertions, 39 Ruby files linted, security checks,
autoloading, and production assets. No runtime behavior changed in consolidation;
existing browser evidence remains applicable. A read-only check through one
`bin/release session` confirmed the running revision remains `2828f88` and the
public container remains `b1f32010efbf`. The owned tunnel was closed afterward.
No deployment or push was performed. Local commits are unsigned because the
configured SSH signing agent failed; Git signing settings were not changed.

## Coming-soon deployment — September 27, 2026

The coming-soon page is live on apex and www at Hetzner, with valid HTTPS on both.
Production revision: `2828f88c4df71ac5e289b28b3055c1c408de5a10` on
`codex/public-coming-soon`. Members, Two Rivers, and NixiHost mail were preserved.
See [release results](deployment/2026-09-27-coming-soon-status.md) and
[DEPLOYMENT.md](DEPLOYMENT.md). Use one persistent `bin/release session` for the
entire next release. The full publishing website remains future work.

## Public consumer implementation — 2026-09-27

This section records the earlier local implementation, before the coming-soon
release above. Its no-deployment statement applies to that earlier session only.

The working Rails public UI now consumes the reviewed v1 publishing contract.
The standalone editor and database dependency have been removed. Content editing,
publication grants, consent, and uploads belong in LegionPostTools; its repository
was inspected but not changed. No database was dropped or member data imported.

See [development](development.md) for previews, cache behavior, and tests, and
[hosting/releases](deployment/hosting-direction.md) for the separate Kamal service.
The public app can run with labelled synthetic content while the publisher is being
implemented. A missing feed is handled honestly in live mode. Public contact details
remain unconfirmed. No commit, push, live deployment, or DNS change has been made.

[Revision 3](public-publishing-api-v1.md) remains the shared API baseline; the
[companion review](public-publishing-integration.md) records source findings.
Earlier foundation-only status below describes the September 7 milestone.

## Historical foundation and exploration — 2026-09-07

The rest of this handoff is historical. In particular, PostgreSQL, undecided
integration, and untested deployment statements below have been superseded by
the September 27 status and current development/deployment guides.

The user has pivoted this project from a WordPress theme to a Ruby on Rails
public website hosted at Hetzner. It will complement the separate application at
`~/Development/LegionPostTools`. The companion review supports a separate Kamal application service/container;
its production configuration has not yet been implemented. Sharing a host does not imply sharing a
container, database, credentials, or private data.

The repository now has a Rails foundation: Ruby 4.0.6, Rails 8.1, PostgreSQL,
Hotwire/importmap, Propshaft, a Dockerfile, and local/GitHub CI checks. The app has
its own namespace and database names. `/up` is the boot health endpoint; public
pages, domain models, editing, authentication, and integration are not built yet.
See [development setup](development.md) for commands and current limits.

The old theme and tooling remain removed. No live site, hosting account, running
container, remote secret, or companion repository was changed. There is no
host-specific deployment configuration; removing files does not retire a live site.

## Where to start

- [Shared guidance](../AGENTS.md): execution, authorization, and quality expectations.
- [Legion context](LEGION.md), [post members](POST_MEMBERS.md), and
  [community context](COMMUNITY.md): mission, audience, and volunteer realities.
- [Design notes](DESIGN_NOTES.md): observations from earlier iterations, open to revision.
- [Content notes](content-notes.md): content lessons and facts awaiting confirmation.
- [Hosting direction](deployment/hosting-direction.md): intent and unresolved choices.
- [Companion review](companion-review.md): release, integration, and source-coverage
  findings from LegionPostTools; consult before designing deployment or shared data.
- [History](history/README.md): condensed records of the earlier work.
- [Agent environment audit](agent-environment.md): an earlier machine-specific
  audit, not current setup instructions.

## Freedom for the next implementation

Rails and Hetzner are the new direction. Page structure, design language,
headline, typefaces, color palette, homepage composition, editing workflow,
features, and the relationship to the companion application can be reconsidered.
Earlier v1/v2 labels and approvals do not constrain the new site. There is no
requirement to recreate the board, reproduce the old navigation, or translate
PHP into Ruby. Use the learned problems as input and develop a fresh solution.

The first foundation pins Ruby and Rails and uses PostgreSQL and standard Rails
assets. These choices support starting work; they do not freeze product or visual
decisions. Authentication, content ownership, and deployment tooling remain open.

## What was retained

The mission and audience documents are unchanged. Existing design observations
have been retained with historical claims and fixed-layout language qualified.
Earlier specs and plans are now short historical summaries under `history/`;
platform setup recipes, code listings, task checklists, and prescribed workflows
have been removed. Content and hosting lessons replace the obsolete platform
manuals. Git history retains committed implementation detail; pre-existing local
document edits were also backed up outside the repository before this cleanup.
Ignored local mockups and agent session artifacts were left alone as existing work.

## Practical next decisions

Define the public experience and its content ownership. Establish how any public
events or facts supplied by LegionPostTools would be published, if integration
is useful. Use the companion review and recheck its source before implementing co-hosting. Confirm source content and any migration needs before planning
cutover; the old repository did not contain all live content or uploads.

The foundation has a health integration test and automated checks described in
`development.md`. A green foundation suite is not feature coverage or browser QA.
The Dockerfile is a container starting point, not evidence of a Hetzner deployment.

## Foundation verification — 2026-09-07

`bin/ci` passed: style, gem/JavaScript audits, Brakeman, the health integration
test (1 test, 2 assertions), autoloading, and production assets. Local database
setup succeeded, and a running Puma server returned HTTP 200 at `/up`. These
checks cover the foundation, not a finished public experience.

The local Docker image build was not verified: the Docker socket denied access and
noninteractive sudo required a password. No image was built or deployed. The companion review subsequently identified its
remote Docker builder as the relevant release approach; that route remains untested
for this app. GitHub
CI has been authored but has not run remotely. Public-page browser QA is pending
implementation of the public pages.

## Public-site design exploration — 2026-09-07

[The design brief](design/2026-09-public-concepts/brief.md) proposes public tasks,
navigation, content ownership, and three distinct visual concepts. The standalone
[comparison](design/2026-09-public-concepts/index.html) includes desktop/phone widths,
sample/empty/unavailable calendars, event details, and participation choices.
The owner selected the service-led concept behind “Service doesn’t end with a
uniform,” grounded in the Post's fraternal identity and veteran fellowship. Family
welcome should emerge subtly through actual event details and imagery; avoid a
headline repositioning as a family organization. Exact visuals remain open;
review [brand sources](brand/README.md) before the next design pass.

These files live under docs and do not change Rails routes. All dates are clearly
marked samples; artwork is illustrative, not documentary. Future API content is
still limited to explicitly approved public information from the separate member
application. Read the brief's validation and limitations before building a selected
direction into Rails.

The next [service and fellowship iteration](design/2026-09-public-concepts/fellowship.html)
uses official brand artwork and a quieter first-visit invitation. See its
[iteration notes](design/2026-09-public-concepts/iteration-2.md) for brand review and QA.

The owner approved the messaging but challenged the stacked colored panels.
[Common ground](design/2026-09-public-concepts/common-ground.html) explores an open
composition with a clearly fictional editorial illustration and fewer repeated
content structures. This is a proposal, not an approved visual direction; see
[iteration 3](design/2026-09-public-concepts/iteration-3.md).

The owner then requested broader visual research, finding iteration 3 too literal.
[Veteran and patriotic references](design/2026-09-reference-research/README.md)
collect designer case studies and attributed images. The scrapbook and event/club
directions are discussion candidates; do not treat the previous mockups as selected.

The subsequent [wider national/civic research](design/2026-09-wide-references/README.md)
looks beyond veteran organizations and museums. After discussion of limited usable
photography, the owner requested [two illustrated mockups](design/2026-09-illustrated-concepts/README.md).
These explore an event-poster direction and a quieter paper-relief direction with
the same public tasks. They do not depend on new photos or scrapbook research.
Phone screenshots support review away from localhost. The owner rejected both as
conventional layouts with large AI illustrations; neither is an approved direction.
The accepted service/fellowship messaging and separation from the member site remain.

[Experience concepts and audience roleplay](design/2026-09-experience-concepts.md)
record the subsequent correction, direct inspection of the owner's Take the Con
site and supplied console-portfolio video, and three new proposals. The owner wants
the central idea to shape the entire experience and speak to prospective veterans
and households. These proposals and fictional visitor reactions are exploratory,
not selected designs or user-research findings.

The owner then favored **In good company** because welcoming visitors does not
require knowing their motives. Three regular attendees can become recognizable
faces and provide an opening for conversation at an event. The owner authorized
the [working table prototype](design/2026-09-in-good-company/README.md), which
keeps those introductions connected to event and first-visit views. Phone captures,
a short interaction recording and a self-contained conversation preview support
review away from localhost. Its stock portraits, names and introductions are
explicitly fictional placeholders; obtain real photos and approved introductions
from three consenting regulars before publishing. The prototype has been browser
checked; the visual implementation itself is awaiting owner review.

At the owner's subsequent request, **only the mockup** was published privately on
ChatGPT Sites: https://post165-in-good-company.andretr.chatgpt.site . Deployment
succeeded September 7, 2026. See the prototype README for the isolated Sites checkout
and update instructions. The Rails repository was not committed or pushed for this
publication, and the production hosting direction remains Hetzner.

The owner then requested sharing the mockup without ChatGPT sign-in. Its Sites
access is now **public (anyone with the URL)**. Policy readback and an anonymous
HTTP 200 response verified access on September 7, 2026. The URL is unchanged.
