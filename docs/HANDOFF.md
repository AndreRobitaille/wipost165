# Project handoff

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
The three fictional introductions currently exist only in the synthetic companion
database. The [content-session prompt](publisher-content-prompt.md) authorizes and
describes creating/publishing them in the real workspace with editorial access.
Older anonymous-feed and pending-authorization notes below are historical.

Follow [ROADMAP](ROADMAP.md) for current work and record session progress there.
Read [PURPOSE](PURPOSE.md) for why the public site exists and
[UI/UX and visual guidance](UI_UX_GUIDE.md) for the owner's design intent,
rejected approaches, and review criteria. [Development](development.md) covers
the runtime and verification. These entry points avoid needing the old conversation.
The development and release histories are consolidated on `main` in
`/home/andre/Development/wipost165`; SITE-01 and the local SITE-02 refinement are
complete. Continue with **SITE-03** (content preparation). Companion publisher
delivery is tracked separately; recheck its status before integration work.
The [companion work queue](companion-work-queue.md) tracks that separate delivery.
Use the [API output request](publisher-api-request.md) for the companion session;
revision 3 remains the external-interface baseline, with implementation and
site/admin choices left to LegionPostTools under the owner's clarified scope.

Current architecture: separate Rails public service, no database or public editor,
content administration in LegionPostTools, and a readonly publishing API. The
coming-soon site is live; the full consumer exists locally; end-to-end publishing
integration and full-site launch remain open. Older entries below preserve how
we arrived here, not alternative current setup instructions.

## Resume next session

- **Accepted design:** the owner reviewed the desktop capture and said, “Looks
  good. No real feedback on it other than I like it.” Keep the current shared-table
  composition. The agent's optional spacing critique is not unfinished work.
  [Approval and screenshots](design/2026-09-visitor-paths/README.md#owner-review).
- **Preserve the local work:** this session's application, tests, documentation,
  and screenshots remain uncommitted on `main`. At handoff, Git reports `main`
  ahead of the locally known `origin/main` by 90 commits; no remote refresh was
  performed. Inspect the worktree before editing. Do not discard the new portrait
  partial, visitor-path review directory, or content-readiness worksheet as debris.
- **Next conversation:** use [launch content readiness](launch-content-readiness.md).
  Public email/phone, postal address, meeting venue/time, unarranged meeting
  attendance, gravel parking/no steps, and content responsibility are now recorded.
  The owner supplied the current public source and answered the arrival questions.
  Next: approved introductions/photos, which the owner plans to collect at the
  next PEC and possibly member meeting. Do not repeat resolved contact questions.
  Remaining unknowns stay omitted. Keep private evidence and publishing grants
  in the companion's appropriate private workflow.
- **Verification already completed:** `bin/ci` passed with 36 tests and 234
  assertions; the [review note](design/2026-09-visitor-paths/README.md#verification)
  records desktop/phone, sparse-content, keyboard, reduced-motion, and
  no-JavaScript checks. Repeat checks for new changes or unresolved risks, not
  merely to reopen the session. SITE-03 reran CI with the same passing counts;
  [contact/visit evidence](design/2026-09-content-intake/README.md) adds desktop,
  320px, keyboard disclosure, link-target, and blank-contact-override checks.
- **Local preview:** the temporary QA servers/browser sessions were stopped and
  generated production assets were clobbered after verification. To preview again,
  follow [development](development.md), explicitly using `PUBLIC_SITE_PREVIEW=1`
  and `PUBLIC_SITE_COMING_SOON=0`. Screenshots remain reviewable without a server.
- **Remaining delivery:** SITE-04 awaits the companion publisher; SITE-05 awaits
  verified real content, integration evidence, and release authorization. No
  commit, push, deployment, companion edit, or live-data change was authorized by
  the design approval. Production was not inspected or changed in this session;
  the coming-soon revision below is prior recorded evidence.

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
