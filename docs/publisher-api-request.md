# What the public website needs from LegionPostTools

September 27, 2026. This is the handoff for work in the companion repository.
It describes the public output and behavior needed by `wipost165`. How
LegionPostTools produces that output, manages content, or presents its own site
and administration is for that repository to decide.

## Task

Read your repository's guidance and inspect what already exists. Provide a
read-only publishing API that the separate Post 165 public website can consume.
Use the existing implementation where it meets the need. Return the interface,
examples, and verification evidence described below so the public-site work can
resume against real output.

The public site needs two kinds of content: approved introductions with portraits,
and approved public events. It has no member login, private credentials, database
connection, editor, or upload flow. Public contact and general first-visit details
are already maintained locally; no endpoint for those is requested.

This request does not choose your data model, permission names, roles, editing
screens, navigation, publication controls, upload tooling, or internal architecture.
Use your own guidance and judgment for those decisions. The
[revision 3 contract](public-publishing-api-v1.md) was jointly developed with the
companion agent; its internal design and policy decisions were not imposed solely
by the public-site agent. This output-focused brief adds no internal/admin
requirements and does not revoke that agreement. Assess the earlier decisions
against your current repository context and identify any proposed departures.

## Interface the current consumer accepts

These are compatibility facts about the code already in `wipost165`, not a demand
to reshape the companion's internals. If another external interface makes more
sense, return the proposed difference and equivalent behavior. The public consumer
can be adapted in a subsequent public-repo task; an uncoordinated difference will
not work with the current client.

The current transport uses one configurable HTTPS origin, initially
`https://members.wipost165.org`, without authentication or redirect following.
The public server requests JSON; visitors' browsers load portrait URLs directly.
No browser-side JSON requests or CORS setup is needed by this consumer.

| GET/HEAD route | Successful result |
| --- | --- |
| `/public/v1/featured_members` | `{"schema_version":1,"complete":true,"members":[...]}`; zero to three full story objects, in display order |
| `/public/v1/member_stories/:id` | `{"schema_version":1,"member":{...}}`; one full story, including when it is no longer featured |
| `/public/v1/events?from=YYYY-MM-DD&to=YYYY-MM-DD` | `{"schema_version":1,"complete":true,"timezone":"America/Chicago","from":"...","to":"...","events":[...]}`; complete matching interval |
| `/public/v1/events/:id` | `{"schema_version":1,"timezone":"America/Chicago","event":{...}}` |
| `/public/v1/member_stories/:id/portrait/:revision/:size.webp` | Approved portrait bytes; variants described below |

Successful JSON uses `Content-Type: application/json`. IDs are stable opaque
public strings, unique within each collection; they do not expose private record
identifiers. Text is plain text. The consumer escapes it and ignores additional
fields. `updated_at` describes the last public change in RFC 3339 UTC format.

### Introductions and portraits

All story keys below are present; only `conversation_starter` may be null.

| Field | Value |
| --- | --- |
| `id` | Nonempty public ID, also used in the story URL |
| `display_name` | Approved public name |
| `introduction` | Short introduction |
| `story` | Longer account in plain text |
| `conversation_starter` | Nonempty text, or null |
| `updated_at` | Timestamp of the public version |
| `portrait` | Object with nonempty `revision`, nonempty `alt`, and `variants` |

The current validator expects exactly two portrait variants, each with `size`,
`width`, `height`, `content_type`, and absolute `url`:

- `small`: 320 × 400, `image/webp`.
- `large`: 640 × 800, `image/webp`.

Each URL matches the configured origin and portrait route above, using the story
ID, portrait revision, and variant size. Original files, embedded private metadata,
and storage credentials are not public output. A portrait URL must stop serving
an obsolete or withdrawn revision, including on a conditional request; a redirect
to a permanently accessible original would not meet that result.

Concrete synthetic JSON:
[featured/story example](../test/fixtures/publishing/featured.json).
For detail, the same story object appears under `member`.

### Events

Every event has these keys, including keys whose value is null:

| Field | Value |
| --- | --- |
| `id`, `title` | Nonempty public ID and title |
| `description`, `location` | Nonempty plain text or null |
| `all_day`, `cancelled` | Booleans |
| `starts_at`, `ends_at` | Timed event: RFC 3339 with an explicit offset; end may be null. All-day event: both null. |
| `starts_on`, `ends_on_exclusive` | All-day event: local `YYYY-MM-DD`; end may be null. Timed event: both null. |
| `category` | The current consumer accepts `public_event`; this is a public presentation value, not a required internal category. |
| `updated_at` | Timestamp of the public version |

Concrete synthetic JSON: [event examples](../test/fixtures/publishing/events.json).
For detail, the event object appears under `event`, with `schema_version` and
`timezone` in the envelope.

The consumer requests a 90-day window; the interface supports 1–93 calendar days.
`from` is inclusive and `to` exclusive, in the returned IANA timezone. Results
include all overlapping published events, including cancellations and past events
within that interval. No silent truncation or pagination is expected.

For nonzero timed spans, an event ending exactly at `from` does not overlap.
Null or equal timed ends mean a point at the start. All-day end dates are exclusive;
a null end occupies the start date only. Local date boundaries honor DST. Results
are ordered by start instant (local midnight for all-day), then public ID.
The consumer rejects mismatched query bounds, duplicate IDs, invalid fields,
out-of-interval records, and incomplete collections.

## Public behavior needed

- Only intentionally approved public content appears. A private roster entry,
  account, or calendar visibility flag does not by itself authorize publication.
  Internal activities and private related records must not leak into the feed.
- Public introductions use approved text and portraits with consent. Removing a
  story from featured selection preserves its published detail URL; withdrawing
  it or revoking consent removes it and its portraits from public responses.
- Unpublished edits do not change the public representation. The consumer shows
  the approved version, including schedule/location, until an approved update
  replaces it. It needs no draft content or pending-change metadata.
- Cancellation becomes visible promptly. Withdrawal, deletion, or restriction
  removes affected public output. An older publication/update must not resurrect
  content after a newer restriction, even when actions happen concurrently.
  Restoring public content requires renewed publication approval.
- A successful empty collection means there is no published content in that
  selection/interval. An outage is an error, never an invented empty success.
  An event omitted from one interval may simply have moved; omission alone does
  not establish global withdrawal.
- Unknown, unpublished, or withdrawn details and obsolete portraits return 404
  without revealing which private state caused it. Errors reveal no private data.

These are observable output requirements. The mechanisms for deciding approval,
maintaining consent, applying restrictions, and managing staff work are yours.
The Post owner has confirmed that visitors can attend regular member meetings;
that static visit guidance does not request that internal meetings be exported
as public calendar events.

## Freshness and errors

The current interface uses ETag, Date, and
`Cache-Control: public, max-age=300, must-revalidate` on successful JSON and
portraits. Return accurate Age when applicable. Conditional requests use
`If-None-Match`; 304 is valid only while the corresponding public representation
is still allowed and unchanged. A 304 includes current validation metadata.
Removal, cancellation, ordering, or other public changes invalidate affected
ETags, including when a collection becomes empty.

The five-minute maximum is one total age allowance across caches. No stale-on-error
extension or new five minutes at each hop. Withdrawal must be honored by the
publisher on subsequent requests; already cached copies may last for their
remaining allowed lifetime. This does not claim recall from an already open page.

Expected errors: 400 for invalid intervals, 404 for unavailable public identities,
405 for unsupported methods, 429 for throttling, and 503 for temporary failure.
Error responses use `Cache-Control: no-store`. The existing envelope is
`{"schema_version":1,"error":{"code":"not_found","message":"Not found"}}`;
the client primarily uses HTTP status. Include `Retry-After` when appropriate.
The transport currently allows 2 MiB per JSON response, a 1-second connection
timeout, a 2-second read timeout, and a 4-second overall timeout. Report a real
compatibility issue rather than silently truncating data to fit those limits.

## What to return to the public-site task

Provide a concise handoff containing:

1. The implemented interface and any differences from this request.
2. The publisher origin and reproducible access instructions for a test
   environment, including any proposed local transport accommodation.
3. Sanitized example JSON and response headers for collections, details, errors,
   and conditional responses, plus fetchable synthetic portrait examples.
4. Evidence for empty content, edits, rotation, withdrawal, portrait replacement,
   consent revocation, event moves/cancellation/removal, interval boundaries, and
   freshness during an outage. Explain any unverified behavior.
5. The source revision or working-tree state tested, commands/results, and whether
   the result is local, reachable in a test environment, or deployed. Identify
   remaining dependencies without including credentials or private records.

Real introductions/photos are still being collected. Synthetic content is enough
for implementation and verification; this request does not require live grants,
real content publication, or deployment. Follow the authorization given in your
own session for those actions.

For comparison, the public consumer lives in
[`Publishing::Contract`](../app/services/publishing/contract.rb),
[`Publishing::Client`](../app/services/publishing/client.rb), and
[`Publishing::Transport`](../app/services/publishing/transport.rb).
[`bin/publisher-check`](../bin/publisher-check) checks the two collection endpoints;
passing it alone does not establish detail, image, or withdrawal correctness.
