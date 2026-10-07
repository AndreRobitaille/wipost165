# UI, UX, and visual direction

September 27, 2026. Read [PURPOSE](PURPOSE.md) first. This is the current design
brief distilled from the owner's feedback, with practical implementation and
critique guidance. It is not a claim that every existing screen meets the brief.
Layout and treatments can evolve; preserve the reasons behind the design.

October 7 update: the people-centered shared-table experience below is preserved
for V2. The first launch is a deliberate photo-free composition around a welcome,
public occasions, and practical first-visit/contact information. See the
[V1 direction, previews, and review](design/2026-10-v1-launch/README.md).
Do not assess V1 as an accidentally empty version of V2 or require portraits for
its release. Accessibility, truthfulness, sparse calendars, and direct visitor
paths continue to apply to both editions.

October 7 visual reset: the owner rejected the broad V1 appearance after the
card-based refinements and clarified that the messaging is good; the visual
presentation is the issue. Earlier requests for more borders, cards, and color
were local attempts to solve the problem, not a lasting instruction to enclose
every content group. That card-based V1 was not visually approved. See the
[earlier whole-site reassessment](design/2026-10-visual-reset/README.md).
The owner also rejected that light-ground study as looking the same. The latest
[ten outside references](design/2026-10-outside-references/README.md) investigate
coherent environments, expressive identity, illustration, material, and useful
interaction. Develop a visual idea before rearranging the existing components;
Legion branding informs identity without making Legion sites the design benchmark.

October 7 reference calibration: the owner found the ten outside examples too far
out and again named their own [Take the Con](https://takethecon.org/) as a closer
benchmark. Aim for distinctive material, composition, layering, and thoughtful
details with familiar website behavior. Its binder and navigation demonstrate a
coherent setting; they do not mandate a literal binder or space theme for the Post.
See the [fresh reference inspection](design/2026-10-outside-references/take-the-con/README.md).

The owner then explicitly clarified that the Post does not need a binder. The
[civic pennant study](design/2026-10-pennant-study/README.md) tries a Post-specific
graphic identity with familiar navigation, a month-grouped calendar, expanded
visit answers, and direct contact channels. It is an isolated proposal awaiting
feedback, not an approved replacement for the running V1.

The owner subsequently disliked the pennant/banner image and requested AI imagery
grounded in real Two Rivers photographs. The [harbor revision](design/2026-10-harbor-study/README.md)
uses a credited aerial harbor photograph as its sole generation reference. The owner accepted its painted direction and authorized implementation, with
colors, fonts and logos following National’s guide. Real local geography guides
the setting rather than an invented generic waterfront.

Reassess composition, type hierarchy, density, and the role of color across all
pages. Preserve the useful interaction requirements: Home before Events, calendar
details in a modal with normal URL/no-JavaScript fallbacks, clean event hovers,
five fully expanded visit answers, and direct contact actions. Review the narrow
and intermediate compositions as carefully as desktop. The accepted harbor study
is now implemented in V1; see [implementation checks](design/2026-10-harbor-study/implementation/README.md).
V2’s preserved implementation is unchanged.

The owner then questioned whether a harbor alone communicates the Legion’s
service identity and asked us to study National’s imagery. The
[national reference review](design/2026-10-harbor-study/national-references/README.md)
finds recognizable service cues and shared activity are the important lessons.
Keep local pride as the setting, with Legion identity and service as the subject.
The running version remains people-free pending the owner’s answer about anonymous
illustrated veterans. Do not invent local members, programs, or official marks.
V1 now uses National’s Emblem Blue/Poppy Red and recommended Noto Sans web fonts;
the earlier study’s gold accent is superseded. See [brand evidence](brand/README.md).

## The experience we are trying to create

**“I can picture myself here, and I know how to take the next step.”**

Aim for welcome, recognition, fellowship, quiet pride, and curiosity. Combine a
memorable visual idea with immediately understandable actions. “Original” should
describe the relationship between subject, composition, and interaction, not the
amount of decoration or the difficulty of learning the controls.

The owner supplied Take the Con and a console-portfolio video because each felt
like a coherent place with its own logic. The lesson is to carry a concept through
navigation and detail views. Copying a binder, game console, or skeuomorphic room
is not the assignment. The [reference review](design/2026-09-experience-concepts.md)
records what was inspected; broader [civic/national references](design/2026-09-wide-references/README.md)
show expressive composition and identity beyond veteran or museum websites.
Reference images are study material, not production assets.

## What previous attempts taught us

| Feedback from the discussion | Design implication |
| --- | --- |
| Large colored sections of copy still felt like a WordPress template. | Give content a meaningful visual relationship and hierarchy; repeated full-width bands are not a concept. |
| Removing the colored sections left an equally dull text page. | Minimalism alone does not answer the request. Invest in composition, people, image treatment, and useful interaction. |
| Large AI illustrations, including a car and grill, felt unrelated. | Do not use an illustration to manufacture local activity or cover for conventional structure. |
| A different hero did not make a different experience. | Carry the organizing idea into stories, events, and first-visit details. |
| “In good company” worked without knowing a visitor's motive. | Offer recognition and a welcome; avoid quizzes, audience sorting, or messaging that diagnoses a need. |
| Three frequent attendees could provide a conversational opening. | Make people recognizable and introductions memorable, with honest routes toward meeting others. |

This is not a ban on panels, text, illustration, or ordinary navigation. Use them
where they clarify a real task. The failure was using surface styling as the
whole idea. Likewise, a table silhouette containing slogans would repeat it.

## Signature: a shared table with room for the visitor

The current direction uses one oversized, graphic table surface. A few real
people gather around its far/side edges; the near edge belongs to the visitor.
Readable central content connects introductions, public occasions, and first visits.
The table is a social organizing device, not a photorealistic venue or a promise
about where the Post meets.

```text
                    a recognizable regular
          a regular                         a regular
                  /                     \
                 | readable working area |
                 | welcome / story       |
                 | event / visit details |
                  \                     /
                   People · Events · Visit
                        the visitor
```

This is a relationship sketch, not a fixed grid or required control labels.
The composition should make the connection between people and participation
apparent. One strong visual gesture can carry the identity; ordinary content
needs room to be read. Interior pages may quiet the framing or let the surface
grow vertically. Never clip a long story to preserve a decorative curve.

Useful current references: [prototype intent](design/2026-09-in-good-company/README.md),
[Rails desktop](design/2026-09-rails-implementation/previews/desktop.png),
[Rails phone](design/2026-09-rails-implementation/previews/mobile.png), and
[phone story](design/2026-09-rails-implementation/previews/story-mobile.png).
These are starting points, not pixel-perfect targets. Sample people are fictional.

The owner approved the [September 27 Rails desktop refinement](design/2026-09-visitor-paths/README.md#owner-review)
without requesting changes. Use that implementation as the accepted visual
baseline; tightening its vertical spacing was an agent suggestion, not a pending
owner request. This approval does not freeze future improvements or authorize launch.

## Visitor paths and interaction

| Surface | What it must accomplish | Interaction guidance |
| --- | --- | --- |
| Welcome | Establish Post/place, recognizable people, and useful next steps | Events and contact must be reachable without first selecting a person. Avoid an introductory tour. |
| Introduction | Make one real person memorable through an approved name, photo, and brief account | Show civilian interests and a natural conversation opening when authored. Let the visitor continue to events or visit guidance. |
| Events | Answer what, when, where, and whether this occasion fits the visitor | Use a readable list when it serves better than a calendar grid. Put changes/cancellation next to the relevant date. |
| Event detail | Make planning and sharing possible | Give it a direct URL. Show verified location, timing, and public description; avoid implying unknown costs, accessibility, or guest policies. |
| First visit | Resolve social uncertainty as well as logistics | Explain real arrival practice and any confirmed introduction/contact arrangement. Avoid generic “everyone is welcome” as the only answer. |
| Contact, membership, help | Provide a clear next action without losing the setting | Use direct labels and verified destinations. Never imitate a working form or offer an unverified service. |

Normal links, browser Back, refresh, bookmarks, and direct entry must work. Keep
the current view understandable when arriving from search or a shared event URL.
If controls switch views, show selected state and handle focus predictably. Basic
reading and navigation should work without JavaScript. Do not require dragging,
orbiting, hovering, scrolling through a story, or interacting with every portrait.

Remembering a selected introduction can give continuity to a visit path, but never
imply that person will attend an event, greet the visitor, or has received a message
unless that is explicitly supported. The initial API does not establish attendance
or guest arrangements. Record a new content need in the companion queue rather
than inferring it from roster data or adding undocumented fields.

## Visual language and brand

Use confident Legion blue, generous light reading surfaces, and restrained red
accents. Hierarchy comes from scale, silhouette, placement, and relationships,
with one dominant moment rather than several competing effects. Avoid turning
every paragraph into a badge, every action into a large red button, or every page
into a flag background. Warmth can come from people and language without a sepia
scrapbook treatment.

The following roles reflect the current implementation and the locally recorded
brand review. They are a useful starting palette, not an exhaustive national
standard or proof that every contrast pair is accessible.

| Role | Starting value | Use |
| --- | --- | --- |
| Legion blue | `#00467F` | Primary identity and surrounding field |
| Poppy red | `#B5121B` | Selected emphasis and actions; distinguish alerts with words/icons too |
| Light blue | `#F5F8FA` | Readable table/content surface |
| White | `#FFFFFF` | Reverse mark/text and clear surfaces |
| Supporting deep blue | `#002E55` | Depth and separation without heavy texture |
| Supporting ink | `#173E5C` | Body text on light surfaces |

[Brand sources](brand/README.md) record the reviewed August 2026 guidance and
unchanged official artwork. Use its source guidance for mark choice, clear space,
background, and proportion. The recorded direction uses the brandmark for public
outreach and the emblem for internal/ceremonial contexts, without combining both
in one layout. Do not synthesize or redraw official marks with AI, construct an
unreviewed Post lockup, or stretch/crop artwork. Recheck official guidance when
changing brand use; the private app's visual system is not national brand policy.

### Type and composition

The current files use Noto-derived body and condensed display faces under CSS
aliases `Company Sans` and `Company Display`. Use condensed display for brief,
characterful statements; a highly readable body face carries stories, logistics,
and controls. Preserve font licensing. Do not turn the official wordmark's type
into a general-purpose decorative alphabet.

As working targets for the next design pass, start body text at 16–18px, primary
controls at 16px, and secondary logistics at 14–16px. Reserve smaller text for
truly incidental material; dates, consent/status notices, and navigation are not
incidental. A face, name, date, and action should remain legible at phone size.
These are design targets, not claims about current CSS or formal accessibility
thresholds. Review current small labels rather than inheriting them blindly.

Keep prose roughly 45–70 characters wide when space permits. Allow headings to
wrap naturally and long public names to fit. Use a consistent spacing rhythm;
group a date with its event and an introduction with its person. Deliberate space
should establish relationships, not leave unexplained voids. Avoid equal visual
weight for every section, oversized decorative gaps, and heavy repeated dividers.

### Photography and artwork

Three good, modest portraits can carry the idea. Consistent daylight, camera
height, framing, and crop matter more than professional equipment. A simple
iPhone portrait or a candid from a real activity can be enough with consent and
usable resolution. Favor faces visitors can recognize; preserve honest appearance.
Do not retouch people younger/thinner or substitute stock models for actual members.

The venue does not need to be the hero. The owner's limited archive and ordinary
meeting setting make a photograph-dependent design fragile. Use graphic form,
typography, and restrained authentic detail when photography is scarce. Scraps of
history can become meaningful content when researched, not obligatory texture.
Abstract/generated artwork may be explored deliberately, but must not impersonate
a real member, event, facility, or historical record. Stock portraits are labelled
prototype material only. No cars, grills, drinks, or military props merely to
signal an imagined veteran lifestyle.

### Motion

Use short, purposeful transitions to preserve orientation when a person or view
changes. Keep controls immediately usable and the page understandable in a still
frame. No autoplay, compulsory animation, ambient loops, scroll hijacking, or
theatrical interaction before essential information. Respect reduced motion;
turning animation off must not remove content or selected-state information.

## Phone, keyboard, and accessibility

Recompose for the phone; do not shrink a desktop overhead scene. A shallow arc
or grouped introductions can sit above the readable surface, with visible labelled
navigation nearby. Let long content scroll normally. If portrait framing pushes
every practical action far below the opening, rebalance it. A direct event visitor
should not traverse the welcome scene before seeing the event.

Check 320px and roughly 390px widths, a wide desktop, enlarged text/zoom, and real
content length. Aim for at least 44px comfortable touch areas. Avoid hover-only
information, clipped focus rings, and sticky elements that cover text or controls.
Maintain logical source order, landmarks/headings, a useful skip link, visible
focus, text alternatives, and AA contrast. Colour and position cannot be the only
ways of identifying state. Use semantic links/buttons/details before custom widgets.

## Design the awkward states as part of the concept

| State | Required response |
| --- | --- |
| Zero, one, or two featured people | Rebalance the composition. Keep a useful welcome and next steps; never fabricate a third seat's occupant. |
| Missing/replaced portrait | Retain the approved name and introduction with a neutral fallback, not a stock replacement or broken-image icon. |
| No upcoming published events | Say what the calendar actually covers, and offer verified visit/contact information. Do not conclude the Post is inactive. |
| Publisher unavailable | Distinguish failure from an empty calendar. Keep static information reachable and technical API/cache language out of visitor copy. |
| Cancelled event | Make cancellation unmistakable before travel details or a participation action. Do not imply it is merely sold out. |
| Withdrawn story/event | Show an honest unavailable/not-found destination and useful navigation. Do not revive it from preview data. |
| Missing contact or unverified arrival detail | Omit unsupported specifics or explain the gap plainly. A nonfunctional contact form is not a fallback. |

Follow the contract's freshness and withdrawal behavior; visual continuity never
justifies serving withdrawn information beyond its permitted lifetime. During
development, label synthetic content clearly and keep it out of production.

## Voice and small decisions

Use friendly, concrete language with a low-pressure next step. “Meet a few of us,”
“See upcoming events,” and “Plan your first visit” are illustrative labels, not
mandatory copy. Names and actual details do more than repeated assertions of
belonging. Short statements should still sound like someone from the Post.

Avoid recruitment funnels, “find your tribe,” sentimental hero language, assumed
trauma, fabricated testimonials, and “bring the whole family” without event-level
confirmation. Keep help visible without diagnosing the visitor. Do not narrate
site architecture (“we separate categories for you”) or expose editorial/cache
mechanics in public UI. Retain direct membership information for people seeking it.

## How a future session should use this guide

Before a substantial design change, write a brief direction naming the visitor
task, emotional aim, signature, layout, type/color roles, and the awkward state it
must survive. Sketch if useful. Compare it with the rejected approaches above.
This should focus implementation, not become an approval ceremony for routine work.

Inspect the rendered result and walk through these fictional scenarios:

| Scenario | A useful critique question |
| --- | --- |
| Retired veteran arriving alone | Can I recognize someone and understand what to do on arrival, without being told I am lonely? |
| Busy or divorced veteran with a civilian life | Can I explore at my own pace without a membership form or service commitment first? |
| Partner planning for a household | Can I find the date, practical details, and confirmed guest/child information, then share the page? |
| Woman veteran | Am I addressed as a potential member in my own right? |
| Longtime member | Does the site respect our fellowship, service, identity, and actual people? |
| Returning event visitor | Can I get directly to the current time/location and see a cancellation? |

Roleplay exposes assumptions; it does not establish that real visitors agree.
Review distinctiveness separately from usability: could the layout belong to any
organization after changing its name? Does the central idea survive an interior
page? Can someone ignore the creative framing and still accomplish a basic task?
Both a generic usable site and an original unusable site miss the brief.

For meaningful UI work, retain desktop/phone captures, the tested states and paths,
keyboard/zoom observations, and any unresolved issue in a dated design note linked
from the roadmap. Share reviewable images because the owner may be mobile without
localhost access. Do not claim new browser verification from old screenshots.
Document what changed and why; update this guide when new owner feedback changes
the direction. A green test suite alone is not a visual review.
