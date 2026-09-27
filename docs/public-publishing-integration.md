# Public publishing integration — review and implementation baseline

**Current handoff:** [Public API output request](publisher-api-request.md).
The contract and review below include contributions from both agents. The new
handoff adds no requirements for how the companion builds or operates its own
site/admin, and does not discard those jointly reviewed decisions. Its session
owns implementation and evaluates proposed changes against its current context;
consumer interface changes still require coordination.

Reviewed September 27, 2026. This records a read-only inspection and the reviewed
revision 3 contract for coordination between the two repositories. It is not an implemented
API, an approved deployment, or a request for the companion agent to start coding.

## Direction

Keep the public Rails experience in `wipost165`, serving `wipost165.org` and
`www.wipost165.org`. Keep content administration in LegionPostTools at
`members.wipost165.org`, using existing accounts and explicitly granted authority.
The public application consumes approved content through a small read-only feed;
it has no member credentials or private database connection.

The standalone editor started before this discussion has now been removed from
the public checkout. The public views use a database-free v1 API consumer. This
does not implement the companion publisher or activate a production integration.

## Verified companion findings

Inspected `/home/andre/Development/LegionPostTools` at
`9d278b7ce449ea54d60b151b32f6e23cac97eacf`; its worktree was clean at inspection.
This is source evidence, not verification of the live deployment. No companion
files, databases, services, credentials, or production state were changed.

- [CalendarEvent](../../LegionPostTools/app/models/calendar_event.rb) already has
  `visibility`, cancellation, organization ownership, optimistic locking, and an
  allowlist of public event fields. It does not enforce internal-category
  exclusions when visibility is public.
- [CalendarCategories](../../LegionPostTools/app/models/calendar_categories.rb)
  distinguishes officer/member/planning meetings and Honor Guard. Some categories
  derive from titles; an explicit `other` override bypasses title classification.
  Classification is useful input, not an infallible publication permission.
- [CalendarMonth](../../LegionPostTools/app/models/calendar_month.rb) excludes
  separate Meeting and deadline records from its public preview. Publicly marked
  CalendarEvents can still be classified as internal activities. The
  [API tests](../../LegionPostTools/test/controllers/api/calendar_activities_api_test.rb)
  explicitly expect an Honor Guard event in the authenticated public preview.
  Do not silently change that established private API contract to build the feed.
- [Api::BaseController](../../LegionPostTools/app/controllers/api/base_controller.rb)
  authenticates the existing API. Its directory serializer includes email and
  phone; reusing it for anonymous officer or member stories would expose fields
  beyond this website's agreed content.
- [User](../../LegionPostTools/app/models/user.rb) authorizes calendar editing
  through `can_manage_calendar?`. There is no public-content publishing capability
  yet. Having an officer account is not itself permission to publish.
- [Storage policy](../../LegionPostTools/docs/STORAGE_UPLOAD_SECURITY.md) permits
  controlled transcript/roster uploads; general direct uploads intentionally
  return 404. Member portraits and public-story records are not implemented.
  Active Storage, image_processing, and libvips are already available. Add an
  authorized, constrained portrait-upload flow without reopening generic uploads.
- [Deployment configuration](../../LegionPostTools/config/deploy.yml) uses a
  dedicated Kamal service, member hostname, database accessory, and persistent
  storage. A separate public service must use its own resource names. Follow the
  [existing release guidance](../../LegionPostTools/docs/DEPLOYMENT.md) when adapting
  deployment; do not run the companion's release script for this application.

## Proposed division of work

**LegionPostTools:** public story records, uploads, consent and draft/publication
state, ordered selection of up to three featured stories, explicit publishing
permission, public event eligibility, and read-only publishing endpoints.

**wipost165:** public presentation, API client, validation of the response shape,
bounded caching, event and story detail URLs, and honest empty/unavailable states.
Continue using clearly labelled synthetic content until the feed exists.

No database schema or controller code needs to be shared between the applications.
The companion should remain configurable for other Legion installations.

## Revised contract after companion review

The companion agent reviewed this proposal against the same checkout. Its six
corrections are incorporated in [Publishing API v1 — reviewed contract](public-publishing-api-v1.md):

1. Published stories and photos are snapshots; edits remain drafts until Publish.
2. A dedicated publishing capability controls publication. Event edits remain
   drafts too, with immediate restrictive actions for cancellation and withdrawal.
3. Website eligibility is a separate reviewed designation, independent of display
   categories. No existing public-visibility record is automatically published.
4. Endpoint schemas, example JSON, date intervals, nulls, ordering, errors, and
   completeness now have explicit proposed definitions.
5. Five minutes is one end-to-end freshness budget, not a new allowance per cache.
6. Portrait delivery has a publication-aware, revisioned route and cache policy.

Revision 3 also incorporates the final four clarifications and two implementation
notes: event publications require a source CalendarEvent; schedules/location come
from the reviewed source while public title/description can be authored; publishing
and restrictions share atomic version checks through HTML and private API paths;
and explicit internal designations/stored categories replace the ambiguous idea
of internal links. Source deletion retains a withdrawn publication tombstone.
The feed's end-exclusive overlap rule leaves private calendar behavior unchanged,
and portrait replacement has an explicit temporary-unavailability fallback.

The final relayed review reports no further blocking contract changes. The reviewed
defaults are:
technical administrators do not implicitly inherit publishing authority; routine
event changes require republishing; calendar managers can immediately cancel or
restrict an already-published event. Initial publishing grants remain to be selected
before enabling publication. These are implementation requirements, not claims
about existing application behavior.

The companion agent can own the publisher/editor; this session can own the public
consumer and design once implementation is authorized. This document does not authorize
parallel agents, companion changes, deployment, or changes to private API behavior.
Neither side should assume the proposed API is already available.

## Verification boundary

The companion inspection was read-only and ran no production commands. The later
public consumer implementation replaces the superseded roster editor and database
tests. See development and implementation-preview notes for current checks; local
consumer tests do not verify a live companion publisher or a production deployment.
