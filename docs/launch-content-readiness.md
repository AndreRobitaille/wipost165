# Launch content readiness

Owner intake resumed September 27, 2026 for SITE-03. This is the fact/ownership worksheet;
[ROADMAP](ROADMAP.md) remains the backlog. The owner supplied the
[existing public contact page](https://wiamericanlegionpost165.org/contact-us)
as the source for contact and meeting details. Those facts were read live and
added locally. Other historical candidates in [content notes](content-notes.md)
remain unverified. The owner also confirmed meeting attendance and basic parking/
access details below; dues, introductions, and publishing authority are still open.

## Owner intake — September 27, 2026

The owner answered the first batch by directing us to the existing public contact
page. The browser confirmed the displayed email and phone, postal address, and
regular meeting location/time on September 27, 2026. This owner direction covers
reuse of those public facts. In follow-up, the owner confirmed that visitors may
simply attend a meeting, recommended events as the more enjoyable first visit,
and described the club as having a gravel parking lot and no steps. The owner
and service officer monitor enquiries. The owner is the current content contact;
those responsibilities do not need public labels. A specific entrance/greeter
and broader accessibility details remain unknown and are omitted.
Collect only known details and leave unknowns open. Follow up on gaps in small
batches rather than asking the owner to complete this entire worksheet at once.

The owner plans to collect introductions/photos at the next PEC meeting and
possibly the next member meeting; no dates, names, or assets were supplied.
A suggested person is not yet
an approved public introduction. No account access or publishing grant follows
from naming a content owner here.

### Confirmed public facts

Source for the following rows: the owner-supplied
[Post contact page](https://wiamericanlegionpost165.org/contact-us), checked
September 27, 2026. The email was read in the browser because the text fetch
obscured it. No form was submitted and no email or call was sent.

| Fact | Approved public wording | Confirmed date and source/approving role | Content owner | Recheck trigger |
| --- | --- | --- | --- | --- |
| Public email | wipost165@gmail.com | September 27, 2026; owner-designated public source | Owner | Channel or responder changes |
| Public phone | (920) 860-7478 | September 27, 2026; owner-designated public source | Owner | Channel or responder changes |
| Mailing address | American Legion Post 165, PO Box 11, Two Rivers, WI 54241 | September 27, 2026; owner-designated public source | Owner | Postal address changes |
| Regular meeting venue | Manitowoc Rifle & Pistol Club, 7227 Sandy Hill Ln, Two Rivers, WI 54241 | September 27, 2026; owner-designated public source | Owner | Venue changes or a meeting-specific exception |
| Regular meeting time | First Tuesday of each month at 6:30 p.m. | September 27, 2026; owner-designated public source | Owner | Schedule changes or a meeting-specific exception |
| First visit | Start with a public event; visitors can also come to a regular Post meeting without arranging it first. | September 27, 2026; owner reply | Owner | Visitor attendance practice changes |
| Club parking/access | The club has a gravel parking lot and no steps. | September 27, 2026; owner reply | Owner | Site/access changes or reported difficulty |

The mailing address is not the visit destination. The regular meeting information
does not make meetings public events or authorize generated calendar listings.
The visit page recommends a public event and explains that no prior arrangement
is needed for a regular meeting. The access wording is limited to the owner's
description; it does not claim wheelchair suitability, accessible restrooms,
paved parking, or a designated greeter. Guest/child details stay event-specific.

Record future content owners explicitly rather than inferring responsibility
from an officer title. Keep private contact details and consent evidence
out of this table. Confirmation for local preparation does not authorize deployment.

## Completed without local confirmation

| Item | Source checked September 27, 2026 | Public use |
| --- | --- | --- |
| National membership questions | [The American Legion FAQ](https://www.legion.org/faq), membership eligibility and general membership sections | Link from `/membership`; the site does not copy changing eligibility rules, quote dues, or imply national signup enrolls someone in Post 165. |
| Local veterans resource | [Manitowoc County Veteran Services Office](https://manitowoccountywi.gov/departments/veteran-s-services/) | Link from `/veteran-help` for benefits questions; office contact/hours stay on the county's maintained page. |
| Incomplete content behavior | [Visitor-path review](design/2026-09-visitor-paths/README.md) | Real names can be long, fewer than three people work, contact can be absent, and calendars distinguish empty from unavailable. |

These external organizations maintain their own information. Include outbound
destinations in the owner's content checks and review them after reported problems.

## Local decisions still needed

| Priority | What must be established | What can be published after confirmation | Current behavior |
| --- | --- | --- | --- |
| As known | Specific entrance/greeter and any further access details | Meeting attendance, gravel parking, and no steps are confirmed; other specifics remain omitted | `/visit` suggests an event first and also permits an unarranged meeting visit; other locations remain event-specific. |
| Before publishing | Individual publishing grants in the companion | Owner is the current content contact; formal grants remain a separate private action | No permissions assigned here. General enquiries/corrections can use the monitored public channels. |
| After collection | Willing regulars and their approved introductions/photos | Public display name, introduction, story, optional conversation starter, approved portrait and alt text | Owner will collect at the next PEC and possibly member meeting. Labelled fictional people remain development-only; production needs approved content or an honest empty state. |
| Per occasion | Guest/child participation, costs, timing/location changes, and cancellations | Accurate event-specific details in the publisher's supported fields/description | No blanket promise that every event suits every household. |
| Before local membership copy | Current Post dues and the local joining/contact process | Verified Post-specific instructions | National FAQ link; no invented local dues or eligibility decisions. |

For each confirmed fact, record the public wording, verification date, source or
approving role, content owner, and the trigger for rechecking. Store personal
contact information, consent records, and evidence of permission privately in the
companion's appropriate workflow. Do not put private evidence in this repository.

## Content ownership

Confirmed September 27, 2026: the owner handles the public channels and is the
current website content contact; the service officer also monitors enquiries.
This establishes a reachable person without adding staff names or responsibilities
to the public pages. General corrections can arrive through those channels.

Review content when contacts, venue/access, or event arrangements change, or when
someone requests a correction/withdrawal. Include the National/county links in
routine content checks. No fixed review cadence was requested. Individual
publishing grants and private consent/withdrawal evidence remain in the companion's
separately authorized workflow; monitoring enquiries does not grant publishing access.

## Where confirmed content goes

| Content | Existing destination | Implementation boundary |
| --- | --- | --- |
| Public email and phone | `PUBLIC_CONTACT_EMAIL` / `PUBLIC_CONTACT_PHONE`; rendered by `/contact` | Sourced public values are application defaults. Environment overrides can replace them; explicit blanks hide channels. Deployment still needs separate authorization. |
| Postal address | Static `/contact` copy | Clearly labelled mailing address; links to `/visit` for the meeting location. |
| General arrival and access facts | Static `/visit` copy in this repository | Update after confirmation, preserving the accepted layout. Scope each fact to its actual venue/occasion; do not turn a usual meeting place into every event's location. |
| Event location, guests, costs, arrival variations | Publisher event `location` and plain-text `description` | Prepare accurate text; enter and approve it through the companion when available. Do not add undocumented API fields or infer public eligibility. |
| Introductions and portraits | Publisher story and portrait workflow | Prepare the approved material; consent, image rights, publication, and withdrawal stay in the companion. Do not replace development samples with real people as a substitute for publication. |

After a local content change, verify the affected contact/visit journey and
phone/desktop rendering. This intake alone does not invalidate the completed
[SITE-02 verification](design/2026-09-visitor-paths/README.md#verification).

## Introduction preparation

A willing regular can supply these in their own words. These are collection prompts,
not mandatory public questions or a new editor:

- The public name they want used and a short introduction.
- What they enjoy about the Post or doing together in the community.
- A natural subject someone could ask them about.
- A usable, consented portrait and a plain description for its alt text.

Start with whether anyone is willing and whether approved text/photos already
exist. Then prepare one introduction at a time. The collection maps directly to
the [reviewed contract](public-publishing-api-v1.md#4-json-objects-and-calendar-semantics):
public display name, short introduction, longer story, optional conversation
starter, and portrait alt text. The publisher produces the portrait variants.
A published v1 story requires its approved portrait; the UI's image-failure
fallback does not make an unpublished or missing portrait publication-ready.
Keep the original photo available privately for the authorized publishing workflow.

Aim for three consenting regulars, but do not delay all progress to fill three
slots. Do not promise their attendance or publish private service history. Keep
consent, withdrawal, image rights, and publishing grants in LegionPostTools; enter
and approve the content there once its publisher is available.

## Next handoff

Public contact and regular meeting facts are now recorded and implemented locally.
Meeting attendance, basic club parking/access, and content responsibility have
also been confirmed by the owner. Next input: introductions/photos collected at
the next PEC and possibly member meeting. Prepare one person's approved material
at a time using the prompts above; do not repeatedly ask for contact facts already
resolved. Further arrival details can be added when known. This can progress alongside
companion work. SITE-04 still requires its separately authorized publisher delivery;
this worksheet neither authorizes companion changes nor clears SITE-05 for launch.
