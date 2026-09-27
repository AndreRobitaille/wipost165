# Public website: a place to begin

Design exploration, September 7, 2026. These are proposals, not an approved visual
specification. [Open the comparison](index.html). The prototypes are standalone
files under docs, excluded from the production Docker context; they do not change
the Rails homepage or expose member information.

## Owner feedback — September 7, 2026

The owner selected the concept behind “Service doesn’t end with a uniform.”
This selects the service-led direction, not the prototype's exact palette, artwork,
type, or layout. The next pass must better reflect the official American Legion
identity; see [brand sources](../../brand/README.md).

The owner clarified that current members strongly identify with a fraternal
organization. Lead with fellowship among veterans, shared service, and continuity
across generations. Existing members should recognize their Post in the result.
Do not frame the public site as replacing that identity with a family organization,
or use decline, demographic deadlines, or criticism of older members as public copy.

Make the welcome to younger veterans and their families evident through truthful
details of actual activities, modest invitations, and approved photographs. Spouses
and partners may discover or share an event; they should be able to understand it
without a prominent campaign about recruiting through families. Treat the owner's
observation about wives encouraging husbands as an audience hypothesis, not a
universal claim about men or a restriction on who belongs. Subtlety means considerate
emphasis, not disguising an event's purpose or promising a culture that does not exist.

Design toward a clear first visit: who can attend, whether children are welcome,
what happens, how long it takes, and who will greet newcomers. Publish those details
only when confirmed for the activity. Avoid promising childcare, family programming,
or an existing social schedule without evidence. Offer a useful, shareable invitation
before making membership enrollment the primary ask. Show actual companionship and
shared activity through approved photos and specific stories when available.

## The public's job

Someone arrives from a shared link, a conversation, or a search. They should quickly
understand that this is their local American Legion, find a reason to attend or
participate, and know how to reach a person. A veteran seeking connection, a family
member exploring participation, and a neighbor looking for an event have different
questions. The public site welcomes all three without requiring a login.

The visual opportunity is to show service as a living, local activity. Give the site
an identifiable graphic idea, useful information early, and a tone that invites
participation without asking people to perform patriotism or navigate Legion jargon.

## Proposed navigation

| Destination | Question it answers | Initial content |
| --- | --- | --- |
| Home / Post identity | What is this, and is it for me? | Identity, selected public events, service, invitation |
| Events | What is happening, when, and where? | Upcoming list, optional month view, event details and cancellation notices |
| Our work | What does the Post contribute? | Verified local examples connected to the Legion mission; post story/history |
| Get involved | How can I participate? | Separate routes for membership, family participation, and community help |
| Contact | Who can answer my question? | Approved public email/phone and, when available, named contacts |
| Member website (secondary) | Where is the private member site? | Clearly labeled external link |

The prototypes use page anchors to compare the homepage flow. These are not final
Rails routes. Our work currently combines About and service; split it only if real
content makes the distinction useful. Events should default to a readable list on
phones; an elaborate calendar is not necessary to learn the date of one event.
An event shared directly should open its complete details, not require a homepage tour.

## Content and publication ownership

| Content | Proposed owner | What the public website needs |
| --- | --- | --- |
| Events | LegionPostTools | New read-only API using explicitly public, allowlisted fields; no private parent records |
| Public narrative, navigation, landing pages | This site | Simple editorial ownership, factual review, chosen Rails editing workflow |
| Photos | Likely the companion, decision pending | Explicit publication permission, image rights, alt text/captions, suitable variants, withdrawal handling |
| Officer contacts | Likely the companion, decision pending | A deliberate public projection and publication consent, not the member directory |
| Membership/service guidance | Approved Post sources | Current information, clear point of contact, no guessed eligibility or dues |

The API does not exist yet. These concepts use no API calls, real member records,
private photos, or credentials. The two sample event dates are fictional and labeled
as such. They are not recommendations for populating the production calendar.

## Three coherent directions

### Where rivers meet

**Thesis:** people with different paths find a shared purpose in one local place.

- Palette: deep lake `#153F4C`, clear water `#C8E7ED`, spruce `#286B65`, light ground
  `#F7FAF7`, sun `#F4BD48`, brick `#B84C2A`.
- Type: Noto Serif Display SemiBold for a few substantial headings; Noto Sans for
  copy and controls; a restrained condensed face for the Post number and dates.
- Composition: an asymmetrical landscape and introduction, then a slightly inset
  event panel that connects identity to an actual reason to visit.
- Signature: an original, stylized confluence illustration. It is not a navigable
  map, a survey of Two Rivers, or an image of a specific Post-owned place.
- Risk: it could read like a tourism site. Keep American Legion identity, veteran
  service, and practical ways to participate explicit.

```text
Post identity                         Events / Our work / Get involved / Contact
Introduction + two clear actions      Illustrated confluence
         Upcoming public events + direct details
Service examples                      Ways to get involved
Contact a person                      Secondary member-site link
```

### Made of service — recommended starting point

**Thesis:** military service can become local service; participation is tangible.

- Palette: civic blue `#193D81`, poster yellow `#EED45D`, warm white `#F9F8F2`,
  coral `#E88C67`, work red `#AA3928`, pale blue-gray `#E8EAF0`.
- Type: Noto Sans ExtraCondensed Black for the poster statement and a few section
  titles, balanced by ordinary Noto Sans body copy and controls.
- Composition: a strong graphic opening with a high-visibility event strip directly
  attached, followed by quieter service and participation sections.
- Signature: a civic-poster illustration of the ordinary objects around people
  gathering and helping: a folding chair, work glove, and cup. It is intentionally
  illustrative, not a fabricated record of a Post event.
- Risk: boldness can become shouting. Limit condensed capitals to display moments;
  body copy stays calm and direct. The artwork should evolve toward verified
  Post-specific service examples once we know which activities to feature.

```text
Post identity                         Events / Our work / Get involved / Contact
Bold service statement                Illustrated civic poster
Bright event strip: date + title + details, no carousel
Quiet evidence of local service
Choose your way in                    Direct human contact
```

### A place for you

**Thesis:** make the first approach feel comfortable, especially for newcomers.

- Palette: plum `#522C5D`, soft lilac `#E6DDED`, near-white `#FCF9FC`, sage
  `#99B9A7`, peach `#E49C77`, warm gold `#F3CB57`.
- Type: Noto Serif Display SemiBold in the invitation and main headings, Noto Sans
  in practical content, condensed numerals for the Post mark and event dates.
- Composition: illustration first visually on desktop, an invitation beside it,
  rounded gathering/event surfaces, and visible participation choices.
- Signature: an open place at a round table with different chairs and one “You”
  place card. It is a metaphor, not a claim that Post 165 operates a clubhouse.
- Risk: the softness could obscure the veteran-service identity. Keep the Legion
  name and purpose clear; do not turn the experience into an identity quiz.

```text
Post identity                         Events / Our work / Get involved / Contact
Illustrated open place                Personal invitation + events link
Upcoming gatherings
Service + I’m a veteran / neighbor / family
Contact a person
```

## Interaction: useful, not theatrical

The prototype demonstrates a compact mobile menu, event detail dialogs, three
participation choices, and contact presentation. The choices update one short
invitation in place; they do not hide navigation, collect personal data, or gate
content. In production they should also have ordinary link destinations.

Production event details should have permanent, shareable URLs. The prototype's
dialogs make the interaction testable, but do not dictate the routing architecture.
A real event page could offer an add-to-calendar file, accessible directions, and
specific attendance information only when those data are verified.

There is no autoplay carousel, scroll hijacking, pointer-following graphic,
mandatory animation, or horizontal card rail. Any later motion should clarify a
state change. Static illustrations already carry the identity. This is a decision
for these concepts, not a permanent ban on future interaction ideas.

## Empty, unavailable, and image-free experiences

The comparison includes separate states for no upcoming events and a calendar
source that cannot currently be confirmed. Neither invents activity. Both preserve
useful contact and participation paths. An eventual cached API integration needs
an explicit withdrawal and failure policy; these prototypes do not implement it.

These concepts deliberately work without documentary photography. Once approved
photos exist, use a small edited set with genuine captions and deliberate crops:
one image of a real activity can replace or accompany a supporting illustration.
A future photo API should not automatically fill a carousel with the newest uploads.
Missing images should leave a complete composition, and descriptive alt text should
travel with the published asset.

## Critique and recommendation

The first design temptation was three ordinary hero/card layouts with different
colors. The concepts instead spend their visual emphasis differently: a place,
a civic poster, or a human invitation. They share content and navigation deliberately,
so the comparison is about expression and approachability rather than different
feature promises. Lower-page structure is still shared scaffolding; a selected
concept needs a deeper page-by-page design pass.

Start with **Made of service**. It has the clearest departure from the old brochure
and a natural connection to this community's preference for practical contribution.
Keep its strong graphic identity, test the headline with the owner, and borrow the
clear participation choices from A place for you. A smaller local illustration
could later add a recognizably Two Rivers detail. Combining all three palettes,
shapes, and type treatments would weaken the result.

The next design pass should use actual approved public event information and a few
verified stories of Post service, then include event detail, Get involved, and
Contact. Agree on a visual direction before implementing those pages in Rails.

## Assets and implementation limits

Illustrations are original editable SVG artwork created for this exploration.
The number 165 is a concept wordmark, not the official American Legion emblem.
The self-hosted fonts are Noto fonts from this workstation, converted to WOFF;
their license is included in `assets/FONT-LICENSE.txt`. No external font, image,
analytics, or API requests are required. No raster images or mock documentary
photographs were generated.

To preview locally from the repository root:

```sh
python3 -m http.server 31066 --bind 127.0.0.1 --directory docs/design/2026-09-public-concepts
```

Then open `http://127.0.0.1:31066/`. The comparison can also be opened as a local
HTML file. This is a standalone design prototype; Rails and GitHub CI have not
been changed by this exploration, and nothing is deployed.

## Verification performed

Browser review covered all three concepts at 1440px, 390px, and 320px. The pages
loaded their fonts and illustrations without broken images or horizontal overflow.
Phone checks exercised menu opening/closing, event dialogs, Escape dismissal and
focus return, audience-choice updates, and the contact preview. Both empty and
unavailable calendar states were checked for every concept. The comparison's
concept, width, and calendar-state controls were also exercised.

The core text/background pairs exceed AA contrast (the lowest tested pair was
5.42:1). JavaScript syntax, SVG XML, local asset links, and diff whitespace passed.
The final composition pass reduced the bold mobile heading and illustration height
so the event section starts at about 726px in a 390px preview. Reduced-motion CSS
removes transitions. This is browser QA of static concepts, not Rails/API testing,
a full accessibility audit, or production verification.

Screenshots are in `previews/`. The server is bound to loopback only. Nothing was
committed, pushed, or deployed, and the companion repository was not modified.
