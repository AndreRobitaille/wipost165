# Project handoff

## Session entry point — September 27, 2026

Follow [ROADMAP](ROADMAP.md) for current work and record session progress there.
Read [PURPOSE](PURPOSE.md) for why the public site exists and
[UI/UX and visual guidance](UI_UX_GUIDE.md) for the owner's design intent,
rejected approaches, and review criteria. [Development](development.md) covers
the runtime and verification. These entry points avoid needing the old conversation.
The recommended next task is **SITE-01**, reconciling the local full-site work
with the coming-soon release/operator baseline without losing either. UI review
and content preparation can proceed while the companion implements its publisher.
The [companion work queue](companion-work-queue.md) tracks that separate delivery;
[contract revision 3](public-publishing-api-v1.md) remains its specification.

Current architecture: separate Rails public service, no database or public editor,
content administration in LegionPostTools, and a readonly publishing API. The
coming-soon site is live; the full consumer exists locally; end-to-end publishing
integration and full-site launch remain open. Older entries below preserve how
we arrived here, not alternative current setup instructions.

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
