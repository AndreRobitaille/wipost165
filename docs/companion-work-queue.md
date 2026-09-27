# LegionPostTools companion work queue

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

The latest September 27 companion handoff and live reads supersede the earlier
`9d278b7` inspection: the publishing service is available, with a Post-owned
read-only website bearer token required on JSON and portraits, private caching,
and unchanged v1 payload shapes. The local public consumer now supports that
contract. Live featured and upcoming-event collections were valid and empty.
The [content-session prompt](publisher-content-prompt.md) covers live placeholder
entry with separate editorial authority. Production full-site exposure remains a
public-site deployment setting; an empty collection is not a connectivity failure.

## Delivery outcomes

The IDs below track dependencies for the public site, not an implementation order
or instructions for the companion's architecture, permissions, or screens.
Its session chooses how to deliver them after checking its current code.

| ID | Output needed | Recorded status |
| --- | --- | --- |
| CP-01 | Only approved public content is exposed; unpublished/private/restricted content stays out, including under concurrent changes | Awaiting companion handback; current code not rechecked here |
| CP-02 | Featured introductions, story details, and approved portrait bytes with rotation/replacement/withdrawal behavior | Awaiting companion handback |
| CP-03 | Complete public event intervals and details, with the agreed dates, cancellation, and removal behavior | Awaiting companion handback |
| CP-04 | A usable integration environment, sanitized response examples, interface differences, and verification evidence | Awaiting companion handback |

See the [API request](publisher-api-request.md) for exact accepted payloads,
external behavior, and what to return. Internal design, publication authority
management, consent mechanisms, editing/upload workflows, and operational choices
belong to LegionPostTools. This queue does not dictate them.

Record the returned revision or working-tree state, environment, test evidence,
and gaps. A local implementation is not a deployed endpoint, and a successful
collection check alone does not prove details, images, or withdrawal behavior.

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

> Work in `/home/andre/Development/LegionPostTools`. Read your repository guidance,
> then `/home/andre/Development/wipost165/docs/publisher-api-request.md`.
> Provide the public API output and behavior described there, using your own
> judgment about implementation and how your site/admin should work. Inspect what
> already exists first. The existing public consumer is a compatibility reference;
> return any proposed interface differences so it can be adapted. Return the
> test access details, sanitized examples, and verification evidence requested in
> the file. Keep the work local; commits, pushes, deployment, and live grants or
> publication need separate authorization.
