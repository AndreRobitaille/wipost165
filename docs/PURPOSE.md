# Purpose of the public Post 165 website

September 27, 2026. This guide distills the owner's discussions and design feedback
into product intent. Read it before making substantial feature, content, or design
decisions. [UI/UX and visual guidance](UI_UX_GUIDE.md) translates that intent into
an experience; [ROADMAP](ROADMAP.md) records the work. Neither document proves
visitor behavior or freezes a layout.

## The job

Help someone picture themselves in good company at Robert E. Burns American Legion
Post 165, then make the next real step easy: find an occasion, understand a first
visit, contact someone, or learn how to participate.

The underlying idea is **“Service doesn't end with a uniform.”** Fellowship,
mutual helpfulness, and service belong together. A person may be looking for
companionship, something worthwhile to do, a familiar connection to military
service, or an activity to share with a household. We do not need to discover or
label that motive to welcome them.

The owner's reason for favoring **“In good company”** was practical as well as
emotional: introduce a few regular attendees so a visitor might recognize someone
at an event and have an opening for conversation. The desired result is a smaller
social hurdle between looking at a website and walking into a gathering.

## Who we are designing for

These are scenarios from the discussion, not demographic research or categories
visitors must select. One person may fit several, or none.

| Person and circumstance | Question the experience should help answer |
| --- | --- |
| Veteran arriving alone, perhaps retired, divorced, or an empty nester | “Will I know who to talk to? What happens when I walk in?” |
| Veteran with a busy civilian life | “Is there something here I'd enjoy or find worthwhile without taking on another job?” |
| Spouse or partner exploring an outing together | “What would we actually do, and would our household be comfortable there?” |
| Woman veteran, including one who is also a parent or partner | “Will I be recognized as a veteran in my own right?” |
| Longtime member | “Does this still feel like our Post and respect what we do?” |
| Neighbor or returning visitor looking up an event | “When, where, who can come, and has anything changed?” |

Do not diagnose loneliness, assume combat experience, or make someone disclose
personal circumstances to browse. Do not split the audience into male veterans
and female spouses. A partner should be able to share a useful invitation; the
site should not pressure one adult to manage another adult's social life.

## Continuity and renewal

The owner described a real tension: the Post needs future participation while
existing members understand it as a fraternal organization. Respect that identity.
Show the fellowship people value and make it easier for others to join in.

Family welcome should appear through accurate event details, considerate arrival
information, and real people. Avoid announcing a repositioning as a family club,
portraying older members as an obstacle, or using organizational decline as a
recruitment pitch. Guests, children, and membership eligibility are separate
questions; answer them specifically rather than promising every activity suits
everyone. Neither dues nor a volunteer commitment should be the first thing a
visitor must confront to understand the Post.

Patriotism has substance here: service, remembrance, community contribution, and
mutual care. Use the Legion identity confidently. The broader patriotic/national
design research was about visual imagination, not a change in the Post's mission
or permission to import another campaign's political message.

## What success looks like

A useful visitor review can establish whether someone can:

- Recognize this as a local American Legion Post and understand its character.
- Recall a real person they might speak with, without being promised attendance.
- Find a relevant public occasion and its current practical details directly.
- Understand the next step toward a first visit, including what is still unknown.
- Reach an actual public contact or find a verified help/membership route.
- Share a specific page with a partner or friend without requiring an account.

These are evaluation goals, not measured conversion claims. Ask actual visitors
and officers what was unclear when opportunities arise. Page views and polished
screenshots alone cannot demonstrate a successful welcome. No analytics system
or collection of visitor motives is implied by this guide.

## Public website and private member application

`wipost165.org` and `www.wipost165.org` serve the public. The separate
`members.wipost165.org` application supports private member operations. Their
audiences, tasks, and interfaces differ even though they share a host and brand.

The reviewed architecture keeps content administration in LegionPostTools using
existing accounts. This Rails site consumes explicitly published material and
has no member database, editor, upload flow, or second authentication system.
Public events and featured introductions are the first integration. Officers,
photos, and other future needs are possibilities to develop when useful, not
automatically public projections of existing private records.

Follow the [publishing contract](public-publishing-api-v1.md) for behavior and the
[companion work queue](companion-work-queue.md) for coordination. A shared host
does not imply shared data access. A recognizable member's face is an approved
introduction, not a directory entry or a live attendance signal.

## Content and volunteer realities

The owner described limited usable imagery: an old scrapbook requiring work to
search, a modest meeting venue, and the possibility of taking new iPhone photos.
The design must work without a picturesque clubhouse, a large archive, professional
photography, or a steady stream of new posts. Those are inputs, not defects to hide
with an invented setting or invented activities.

Represent actual people with dignity. Age, body type, service era, and photographic
polish are not tests of whether someone deserves to appear. Choose consenting
regulars who can genuinely become familiar faces. Good framing and readable
introductions can do more than staged lifestyle imagery.

Keep recurring maintenance small. Officers should be able to publish, withdraw,
and rotate people without redesigning the site. The calendar should use approved
source information rather than require a second schedule. Quiet periods and fewer
than three published people must still feel cared for. Never invent events,
quotes, historical facts, welcome hosts, or contact arrangements to fill space.

## How to decide what to build

For a proposed change, state whose question it answers, what useful next step it
makes possible, and who will keep its content true. Then assess whether it:

1. Strengthens fellowship, service, or practical access to the Post.
2. Makes sense to an unfamiliar visitor without internal terminology.
3. Preserves existing members' dignity and the private/public boundary.
4. Works with realistic content, sparse activity, and volunteer time.
5. Gives this particular Post a more memorable and usable public presence.

A new feature need not satisfy every point equally, but decoration without a
purpose and maintenance without an owner are reasons to rethink it.

## Intent, evidence, and creative freedom

The welcome, audience nuance, desire for originality, and recognizable-regulars
idea come directly from the owner's discussion. The scenarios and review methods
in these guides are design tools, not user-study findings. Exact copy, composition,
fonts, navigation, animation, and feature scope can improve without approval merely
because an older document chose something else. Explain the improvement in terms
of the visitor's experience; do not silently discard the problem the concept solves.

For deeper grounding, read [Legion mission](LEGION.md), [member context](POST_MEMBERS.md),
and [community context](COMMUNITY.md). Verify specific factual claims before
publication. [Content notes](content-notes.md) contain leads awaiting confirmation.
Old specs and [design observations](DESIGN_NOTES.md) preserve evidence, not a
hidden backlog. Current implementation and deployment status belong in
[HANDOFF](HANDOFF.md), not this purpose guide.
