# Publishing API v1 — reviewed implementation contract

Revision 3, September 27, 2026. Incorporates both rounds of companion review,
including source ownership, publication races, and concrete eligibility rules.
Review is complete with no blocking contract changes, as confirmed in the owner's
relayed review. Revision 3 is the shared implementation baseline once implementation
is authorized. The public consumer is now implemented against it; the companion
publisher remains separate work. This contract does not itself authorize
changes to LegionPostTools. Initial publishing grants must be selected before
publication is enabled. See the [source review and ownership
split](public-publishing-integration.md). All examples below are synthetic.

## 1. Editorial lifecycle and authority

Use dedicated website-publication records. A story's private Person link is
optional. An event publication requires a CalendarEvent in the same organization
at creation and whenever it is published; it cannot represent a standalone event.
Public IDs are opaque strings identifying publication records, never private
Person IDs. IDs survive edits, withdrawal, republishing, and rotation; do not
reuse them for different subjects or relink an event publication to another event.

When an authorized source deletion succeeds, withdraw its publication in the same
transaction. Retain the publication ID, snapshots, historical source identity, and
audit history as a withdrawn tombstone. Its live foreign key may be cleared after
physical deletion, but the tombstone cannot be republished without its original
source. Do not cascade-delete the publication or weaken existing source-deletion
protections. Public requests for the tombstone return the ordinary 404.

Keep a working draft and the current published snapshot. Saving a draft does not
change the feed. Publish validates the draft and atomically replaces the public
snapshot, including its photo. No two-person approval or official-minutes workflow
is involved. Publishing must reject a stale reviewed draft or source rather than
quietly including another editor's changes; see the atomicity rules below.

| Operation | Authority | Public effect |
| --- | --- | --- |
| Edit story draft or upload replacement portrait | `publish_public_content` | None until Publish. |
| Publish/republish story or event | `publish_public_content` | Atomically replace the public snapshot. |
| Choose/reorder up to three published stories | `publish_public_content` | Immediately change homepage selection only. |
| Withdraw story or event | `publish_public_content` | Immediately suppress it at publisher and change affected validators. |
| Edit source calendar event | Existing `can_manage_calendar?` | Public-field edits become pending changes; previous approved snapshot remains public. |
| Cancel a source event | Existing `can_manage_calendar?` | Immediately mark an existing public snapshot cancelled without copying pending text/date changes. |
| Make source event private, designate it internal, or delete it | Existing applicable calendar authority | Immediately withdraw any publication. |

Add `publish_public_content` to the existing explicit grant and
office-derived grant mechanisms, but **not** to `IMPLIED_BY_MANAGE_SETTINGS`.
Technical admins can assign permissions through existing administration, but
holding `manage_settings` alone is not publication authority. This is an editorial
role distinction, not protection against an administrator who can change grants.
No grants are silently added to existing users/offices by this proposal. The
installation owner must choose the initial grants before enabling publishing.

The publisher may publish an event snapshot without general calendar-editing
authority; this does not permit changing the source calendar. Calendar editing
does not grant publishing authority. Both interfaces show the last published
version, pending changes (especially changed dates/locations), and who can publish.
Do not describe Save as updating the public website when it only saves a draft.

### Event field ownership

Publishers may author public-facing title and description without calendar-editing
authority. The first draft may copy source text for review; subsequent source text
edits never overwrite authored public copy silently. Dates, times, all-day status,
and location must come from the exact reviewed CalendarEvent version. The public
editor displays these fields read-only; it cannot override them. Cancellation
comes from the source, with the sticky restrictive behavior below. Category is
derived by the publishing policy, not independently authored. Store the reviewed
source version with the snapshot as internal provenance.

**Product choice: pending schedule or location changes leave the old approved
schedule/location public until explicit republishing.** The calendar editor must
make that discrepancy visible and provide a route to review/publish for authorized
users. A publisher reviewing only title/description still reviews the current
source schedule; republishing takes all source-owned fields from that reviewed
version. This avoids a second calendar while retaining explicit publication.

Cancellation is sticky in the publication: clearing the source cancellation alone
does not announce reinstatement; explicit republishing is required. Returning
visibility to public or designation to eligible also requires republishing after
withdrawal. These restrictions prevent ordinary source edits from undoing a
withdrawal. Never publish a cancelled source as active.

Stories require recorded consent covering the published text and photo. Editing
is not renewed consent; the publisher confirms the approved revision is covered.
Consent revocation is an explicit immediate withdrawal operation, not an ordinary
draft edit. Withdrawal also removes featured placement. Rotating off the homepage
does not withdraw a story: its detail URL remains available while published.

Record publish, withdrawal, consent changes, cancellation, eligibility changes,
and featured-order changes with actor, time, publication ID, and affected revision.
These internal audit details never appear in public JSON. Record the source actor
for automatic restriction triggered by a calendar action. Do not silently restore
featured placement after republishing a previously withdrawn story.

### Atomic publication and restrictions

The review submitted for Publish identifies the expected draft version, source
`lock_version` for events, and publication/restriction version. Include the reviewed
consent version for stories. Restrictive actions advance the publication/restriction
version even if a later action restores the same field values, so a prior review
cannot become valid again merely because values happen to match.

In one transaction, serialize against changes to the source, publication, draft,
eligibility, and consent records as applicable, using consistent lock ordering or
equivalent conflict protection. Recheck all expected versions, current publishing
authority, source existence/organization, visibility, eligibility, cancellation,
withdrawal state, and current consent coverage before replacing the snapshot.
On conflict, leave it unchanged and require a fresh review; do not automatically
retry a stale Publish against newer data. An explicitly reviewed republish after
withdrawal is allowed only when the current restrictions have been resolved.

Source cancellation, making it private/internal, or deletion must update the
publication restriction and audit history in the same transaction as the source
change. Consent revocation and explicit withdrawal use the same concurrency
boundary. If Publish commits first, a subsequent restriction suppresses/cancels
its result. If the restriction commits first, the earlier Publish attempt fails
its version check. Neither ordering may leave active content after a committed
restriction. A newer cancellation cannot be overwritten by an older publication.

Enforce this in shared application/domain behavior reached by **both HTML and
private API mutations**, not HTML controller callbacks alone. Existing authorized
mutation/import paths must obey the same rule; ordinary source field updates
cannot bypass it. This preserves the private API's response/authentication contract
while adding the required publication effects. Publisher responses and 304 checks
must consult committed restriction state rather than a stale background copy.

## 2. Event eligibility

Require all of: explicit website approval, current source `visibility: public`,
and a reviewed activity designation of `public_eligible`. Default existing/new
events to `unreviewed` for website eligibility. Existing public visibility alone
does not publish anything on feed launch.

Store the reviewed designation independently of presentation category, with values
`unreviewed`, `internal`, and `public_eligible`. Use these concrete triggers:

- An authorized calendar manager or publisher explicitly marking an activity
  internal sets `internal` and immediately withdraws any publication.
- Assigning a stored `calendar_category` of `member_meeting`, `officer_meeting`,
  `planning_meeting`, or `honor_guard` also sets `internal` and withdraws in the
  same transaction, through either HTML or private API. These four values are
  the internal category set for v1. While one remains assigned, publication and
  reversal to `public_eligible` are prohibited.
- Clearing that category or assigning `other` does not clear the internal
  designation, restore eligibility, or republish anything. The restriction is
  persistent and audited independently of the display category.
- Separate Meeting and deadline records have no publishing route. A
  CalendarEvent's optional Endeavor link is not an internal-activity trigger.

For existing events, initialize stored internal-category records as `internal`
and all others as `unreviewed`; create no live publications or automatic approvals.
Apply the same category rule when new CalendarEvents are created. Title-derived
categories (for example a PEC title with a null stored category) are review aids,
not proof of public eligibility or a substitute for explicit designation. The
review UI must flag these signals and require a recorded disposition: mark the
actual internal activity internal, or explain a false-positive classification.
Unresolved review flags block eligibility approval. An `other` override alone
does not count as resolving a title flag.

Only a publisher may reverse `internal` or `unreviewed` to `public_eligible`, after
reviewing the current event and recording why it is an activity for the public
or why the prior designation was mistaken. Block reversal if the source is
missing/private, any stored internal category remains, any review flag is
unresolved, or the reviewed versions are stale. The publisher cannot clear source
categories without calendar-editing authority. Approval never itself republishes
a withdrawn snapshot: Publish is a separate explicit action. Cancellation does
not prohibit eligibility, but a cancelled source may only publish as cancelled.

There is no assumed CalendarEvent-to-Meeting relationship or other invented
"internal link" in these rules. A real internal event must be marked internal
during review even if its title and category fail to identify it automatically.

An eligible public event may belong to a private Endeavor. That relationship does
not itself disqualify the event, but no parent fields, IDs, links, histories, or
private notes appear in the snapshot. Preserve the current private API and public
preview behavior; implement a separate website publishing policy.

## 3. Transport, identities, and routes

Anonymous HTTPS GET/HEAD only, under the configured publisher origin. This is a
separate publication surface; private API authentication is unchanged. Server-side
consumption needs neither a member token nor browser CORS access. All JSON is UTF-8
with `Content-Type: application/json`; text fields are plain text, never trusted
HTML. Consumers escape them and tolerate additive unknown fields.

| Route | Successful body |
| --- | --- |
| `/public/v1/featured_members` | `{schema_version: 1, complete: true, members: [...]}` |
| `/public/v1/member_stories/:id` | `{schema_version: 1, member: {...}}` |
| `/public/v1/events?from=YYYY-MM-DD&to=YYYY-MM-DD` | Event collection shown below. |
| `/public/v1/events/:id` | `{schema_version: 1, timezone: "America/Chicago", event: {...}}` |
| `/public/v1/member_stories/:id/portrait/:revision/:size.webp` | Image bytes; see section 5. |

JSON schema version is integer `1`. IDs and revisions are opaque nonempty strings;
clients do not parse them. Story/event update timestamps are RFC 3339 UTC strings
for the last *public* change, not draft saves. Collections contain full objects,
so the homepage needs one request for its three stories. Unknown/withdrawn/draft
IDs all produce the same 404, including for an anonymous conditional request.

## 4. JSON objects and calendar semantics

Example featured response with one approved fictional story:

```json
{
  "schema_version": 1,
  "complete": true,
  "members": [{
    "id": "story_example_avery",
    "display_name": "Avery",
    "introduction": "A fictional introduction for contract testing.",
    "story": "A fictional longer story. No real member is represented.",
    "conversation_starter": null,
    "updated_at": "2026-09-27T14:00:00Z",
    "portrait": {
      "revision": "portrait_example_2",
      "alt": "Example portrait of Avery",
      "variants": [
        {"size": "small", "width": 320, "height": 400, "content_type": "image/webp", "url": "https://members.wipost165.org/public/v1/member_stories/story_example_avery/portrait/portrait_example_2/small.webp"},
        {"size": "large", "width": 640, "height": 800, "content_type": "image/webp", "url": "https://members.wipost165.org/public/v1/member_stories/story_example_avery/portrait/portrait_example_2/large.webp"}
      ]
    }
  }]
}
```

All story fields are required. Only `conversation_starter` is nullable; if supplied
it is a nonempty string. Name, introduction, story, and alt are nonempty strings.
A published story requires a portrait with both variants ready. `members` has zero
to three distinct stories in manually chosen order. Empty means no featured
stories, not an error. Consumers do not substitute unpublished or sample content.
Story detail uses exactly the same object under `member`, without `complete`.

Example interval response with a timed and an all-day event:

```json
{
  "schema_version": 1,
  "complete": true,
  "timezone": "America/Chicago",
  "from": "2026-10-01",
  "to": "2026-11-01",
  "events": [
    {
      "id": "event_example_1",
      "title": "Example public gathering",
      "description": "Synthetic event for contract testing.",
      "location": null,
      "all_day": false,
      "starts_at": "2026-10-03T18:00:00-05:00",
      "ends_at": null,
      "starts_on": null,
      "ends_on_exclusive": null,
      "cancelled": false,
      "category": "public_event",
      "updated_at": "2026-09-27T14:00:00Z"
    },
    {
      "id": "event_example_2",
      "title": "Example all-day activity",
      "description": null,
      "location": "Example location — not a real event",
      "all_day": true,
      "starts_at": null,
      "ends_at": null,
      "starts_on": "2026-10-10",
      "ends_on_exclusive": "2026-10-12",
      "cancelled": true,
      "category": "public_event",
      "updated_at": "2026-09-27T14:05:00Z"
    }
  ]
}
```

All shown event keys are required. `title` is a nonempty string; `description` and
`location` are nullable strings (blank normalizes to null). `all_day` and
`cancelled` are booleans. `category` is the published presentation value;
initially `public_event` for eligible v1 events, never an eligibility credential.
No extra guest/arrival information is fabricated from missing fields.

Timed events: `starts_at` is required RFC 3339 with explicit offset; `ends_at` is
the same type or null. Both date-only fields are null. A non-null end is not before
start. A null end means unknown, not ongoing indefinitely; use start as a point
for interval selection, without displaying an invented ending time. Equal start
and end also count as a point event.

All-day events: timestamps are null, `starts_on` is required local YYYY-MM-DD,
`ends_on_exclusive` is a later local date or null. A null end means unknown and
occupies only its start date for calendar layout/querying. Explicit end dates
are exclusive: the example occupies October 10 and 11. Convert existing inclusive
end-of-day source timestamps to the following local date, using the organization's
IANA timezone. Never require the consumer to infer all-day dates from UTC times.

Both query dates are required, strictly validated YYYY-MM-DD. `from` is inclusive,
`to` exclusive, with `from < to` and at most 93 calendar days per request. Interpret
local midnight bounds in the returned organization IANA timezone, including DST;
do not add fixed 24-hour durations to calculate local date boundaries.

Return events overlapping the interval: nonzero timed ranges use end-exclusive
overlap; point events match when start is in the interval; all-day events use their
date span. Order by start instant (local midnight for all-day), then public ID
lexicographically. Include cancelled and past events if they overlap the query.
Detail URLs remain available for past events while publication remains active.

Implement these overlap rules specifically against publishing snapshots. The
current `CalendarEvent.overlapping` scope includes events ending exactly at the
query start (`>=`); v1 excludes that boundary for nonzero ranges (`>`). Do not
change that existing scope or private calendar semantics to implement this feed.

V1 interval responses are complete and unpaginated: never silently truncate.
An empty `events` array with `complete: true` is authoritative for that exact
interval. Replace that interval cache, not all events. Omission may mean an event
moved outside the interval; it does not prove global withdrawal. Detail entries
have their own validation lifetime. Cross-interval displays deduplicate by public
ID. Invalid/missing `complete`, bounds, timezone, required fields, or version makes
a response unusable; do not partially replace an authoritative collection.

Errors use a fixed envelope, for example HTTP 400:

```json
{"schema_version": 1, "error": {"code": "invalid_interval", "message": "Supply from and to as dates spanning 1 to 93 days."}}
```

| Status | Code / behavior |
| --- | --- |
| 400 | `invalid_interval` for missing, malformed, reversed, or too-wide dates. |
| 404 | `not_found` for unknown, withdrawn, ineligible, or unpublished records and obsolete/unsupported portraits. |
| 405 | `method_not_allowed`, with `Allow: GET, HEAD`, for mutations on publishing routes. |
| 429 | `rate_limited`, with `Retry-After` when throttled. |
| 503 | `unavailable`, with `Retry-After` when the publisher can estimate recovery. |

Error responses use `Cache-Control: no-store` and expose no private identifiers,
stack traces, drafts, or internal policy reasons. Unexpected upstream 5xx, invalid
JSON, or timeouts are failures, not empty successful collections. A detail 404
evicts that detail and any cached references to its ID; portrait 404 evicts that
image revision without assuming the entire story was withdrawn.

## 5. Portrait delivery

Return the two fixed 4:5 WebP variants shown above: `small` 320×400 and `large`
640×800. Publisher-side crop preview is part of editing, not a transformation
chosen by the consumer. Reject unsupported/unusable images before publication;
validate decoded dimensions, upload limits, and file content; strip metadata from
public outputs. Keep original uploads private and generic direct uploads disabled.

URLs identify a public story, approved photo revision, and fixed variant. A draft
replacement leaves the existing portrait available. On photo publication, new
revision URLs become active and old revision URLs return 404 at the publisher.
A text-only publication may retain the existing photo revision. Withdrawal or
consent revocation disables every variant immediately at the publisher.

Cached story JSON may temporarily refer to an old revision that now returns 404.
The consumer must preserve layout and show a neutral portrait-unavailable state
(never an invented replacement person) while retaining still-valid story text.
It may revalidate the story once per failed revision during the request/render
cycle, then try a newly returned portrait URL once. If the story is now 404, remove
it; if the revision is unchanged or refresh/image loading fails, keep the fallback
without a retry loop or extending freshness. Browser image failures need the same
visual fallback even if the server has not observed a portrait 404.

For every request reaching the publisher, check current story publication,
consent, and photo revision *before* serving bytes or evaluating conditional
headers. Old ETags cannot elicit a 304 for a disabled image. Stream/proxy the
approved transformed bytes through this controlled route; do not redirect to a
permanent blob URL that bypasses the publication check. HEAD uses the same checks.

Successful responses have `Content-Type: image/webp`, ETag, Date, and
`Cache-Control: public, max-age=300, must-revalidate`. Revisioned URLs are not
`immutable`. No stale-on-error extension. Browser/CDN copies can remain usable for
their remaining lifetime, up to five minutes; an already downloaded/displayed
image cannot be recalled. URLs do not contain expiring storage credentials.

## 6. One freshness budget

The proposed bound is **300 seconds since authoritative publisher validation for
each representation**, across server, page, browser, and image caches. It applies
to subsequent requests and cache reuse, not text/images already displayed in an
open tab. Live removal from an open tab would require additional client behavior.

Successful publisher JSON responses use ETag, Date, and
`Cache-Control: public, max-age=300, must-revalidate`. Publisher caches must check
current publication/consent/revision state before originating a new success or
304. Downstream cache hits do not reset age. Consumers account for Date, Age,
network delay, and resident time when calculating freshness; a local cache read
is not origin validation. Send `Cache-Control: no-cache` on conditional refresh
when authoritative revalidation is needed. Accept a 304 only for the corresponding
stored representation and validator; merge its metadata using HTTP cache rules.

ETags cover the complete public representation, including ordered membership,
query bounds/timezone, cancellation and removal. Draft saves do not affect them.
Deleting the last item must change a collection ETag; maximum remaining
`updated_at` alone is insufficient. Check withdrawal before conditional matching.
Do not include a changing request-time timestamp in the JSON body just to express
freshness; use HTTP metadata instead.

Example: a consumer uses API data whose corrected age is 240 seconds. Any newly
rendered HTML cache may have **at most 60 seconds** remaining, less render time,
not another 300. When combining representations, use the shortest remaining
lifetime. The simplest initial implementation is `Cache-Control: no-store` for
dynamic HTML and a correctly aged server-side API cache. If page caching is added,
carry remaining lifetime explicitly through its headers and subsequent cache hops.
Images are separately validated representations with the same maximum age; an
HTML cache hit never renews image freshness.

Once the budget expires, refresh or hide the affected dynamic section with an
unavailable message. Keep static welcome/visit information available. Do not serve
stale stories/events indefinitely or label an upstream failure as no events.
Do not add stale-while-revalidate, stale-if-error, or an offline/service-worker
cache that extends the bound. Application fragment caching must respect the same
expiry even when HTTP cache headers are bypassed internally.

These mechanics follow [RFC 9111 freshness and age](https://www.rfc-editor.org/rfc/rfc9111.html#section-4.2)
and [validation](https://www.rfc-editor.org/rfc/rfc9111.html#section-4.3).
The 300-second bound and fail-closed presentation are this proposal's policy,
not a guarantee supplied by HTTP alone.

## 7. Verification and implementation readiness

Publisher verification: draft edits leave published snapshots unchanged; explicit
publish replaces text/photo atomically; no implicit admin grant; calendar changes
cannot broaden publication; cancellation/restriction takes immediate effect;
category overrides cannot bypass internal designation; no launch-time publication
of legacy public events; consent revocation and obsolete portraits return 404 even
with matching ETags; rotation preserves published detail; parent data stays private.

Add real concurrency coverage for Publish racing with source edits, cancellation,
visibility restriction, internal designation/category assignment, source deletion,
explicit withdrawal, and consent revocation. Exercise both commit orderings and
both HTML/private API restriction paths. Include changes that return a field to
its previous value after a restriction; the stale review must still fail. Verify
deletion retains publication ID/audit history and no controller-only enforcement
can be bypassed by a supported domain mutation path.

Contract/consumer verification: zero through three stories; complete empty interval;
event moved to a different interval; null/equal ends; multi-day and null-end all-day
events; DST and exact interval boundaries; stable ordering/IDs; cancellation; 304
metadata; 404 eviction; malformed/error responses; different ages of multiple
dependencies; 240-second source age yielding no more than 60 seconds downstream;
expiry during outage; old image revisions; browser/page caches respecting the bound.
Include portrait replacement while old story JSON is still fresh, bounded one-time
story revalidation, fallback without broken layout, and the different publishing
versus private-calendar result for an event ending exactly at the query start.

Contract review is complete. Publisher and consumer implementation can use revision
3 once authorized; no further blocking contract questions remain. Initial users
or offices receiving publishing grants still need to be selected before enabling
publication. This document does not itself authorize app implementation or
deployment. Later contract changes should be coordinated between both sides.
