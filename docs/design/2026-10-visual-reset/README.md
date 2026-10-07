# V1 visual reassessment — October 7, 2026

Status: **rejected by the owner** as still looking the same. This study is
historical evidence, not an implementation target. The next step was
[research of ten outside designs](../2026-10-outside-references/README.md).
It did not replace the running Rails application.
The owner rejected the broad V1 appearance after the card-based interior pass,
then clarified: “I think what we're saying is great. I think how it looks is the
issue.” Preserve the messaging while reassessing the presentation.

The earlier functional work remains useful evidence. Passing those checks did not
establish that the composition was good. The current application should not be
called visually accepted on the basis of its tests or the September V2 approval.

## Diagnosis

The page lost its hierarchy as each refinement added a similar enclosed panel.
The welcome, an event, a meeting schedule, FAQ answers, and contact methods acquired
comparable weight. Condensed display type appeared at too many levels. A saturated
blue ground made each light rectangle compete for attention. At intermediate
widths, the large headline and curved first-visit panel exposed unused space and
awkward proportions. Adding further borders or colors would preserve that structure.

The content has different jobs. An invitation deserves emphasis; a location needs
to be readable; a FAQ needs a clear relationship between question and answer.
The composition should express those differences without requiring more copy.

## Historical proposal: open invitation

Visitor task: recognize the Post, find an occasion, and understand the next step.
Emotional aim: a confident, approachable local institution. The graphic idea is
an open, poster-like welcome with a single prominent invitation. Its character
comes from type, scale, color, and placement, without depending on photographs.

- **Ground:** one continuous cool, light reading field. Text and spacing group
  ordinary information. The largest blue surface belongs to the next occasion.
- **Type:** retain the licensed fonts, but change their jobs. Company Display
  carries the main welcome and dates. Company Sans carries secondary headings,
  questions, event names, and practical details. “In good company” is the dominant
  line; “Still serving” provides a quieter lead-in.
- **Color:** Legion blue identifies the Post and actions; red marks dates, the
  selected navigation item, and a few small emphases. Supporting text uses ink
  and muted blue-gray. A dark appearance adapts the reading ground and text.
- **Shape:** one curved corner belongs to the featured invitation. Ordinary
  content does not inherit a container, shadow, or rounded rectangle.
- **Rhythm:** content controls its height. At phone widths, headings reflow,
  questions sit immediately above their answers, and secondary information follows
  in reading order. The intermediate width is reviewed as a composition of its own.

| Page | Composition |
| --- | --- |
| Home | A broad typographic welcome; mission and first-visit introduction beneath it; one dominant next occasion; quiet meeting/contact information. |
| Events | A connected list with large dates, readable titles and logistics, and a quieter visit/meeting aside. Whole rows remain easy to activate without underlining every line. |
| Event details | A focused modal that uses the same type and color hierarchy. The application implementation must retain its real event URLs and no-JavaScript fallback. |
| First visit | Five expanded answers in a continuous guide. Questions and answers align across the page; meeting time receives typographic emphasis within its answer. |
| Contact | The actual email address and phone number are the prominent actions. Mailing information is quieter and explicitly separate from the meeting location. |
| About, membership, help | The same page heading and open reading field, with direct existing destinations and no extra feature panels. |

The study keeps the established copy and public facts. The calendar is a fixed
snapshot of the four events already used in the local review; it is not a live
calendar. No people, photographs, testimonials, venue illustrations, or attendance
promises have been added. The official mark and font files are unchanged.

## Review the whole direction

The interactive study contains all seven pages, local page navigation, working
event dialogs, and the real email/phone link targets. Launching an external site,
email application, or phone application depends on the review host. Its optional design controls
allow the calendar to be changed to an empty or temporarily unavailable state and
the heading scale to be adjusted. Those controls belong to the review environment,
not the proposed public website.

Representative captures:

- [Home, 1024px](previews/home-1024.png) · [Home, 390px](previews/home-390.png)
- [Events, 1024px](previews/events-1024.png) · [Events, 390px](previews/events-390.png)
- [First visit, 1024px](previews/visit-1024.png) · [First visit, 390px](previews/visit-390.png)
- [Contact, 1024px](previews/contact-1024.png) · [Contact, 390px](previews/contact-390.png)
- [Event details](previews/event-modal-1024.png) · [320px event details](previews/event-modal-320.png)

The important design decision is whether this hierarchy and visual character suit
the Post. More decorative detail should only be added where it contributes to that
character or helps someone use the page. A tidy light page is not, by itself, proof
that the owner will find the direction distinctive enough.

## Implementation boundary and next work

The study changes no Rails routes, publishing client, edition selection, or V2
assets. It is an isolated way to judge the whole composition before translating
the direction into the application. The preserved V2 remains available; its eventual
people experience should be reviewed alongside whichever V1 direction is adopted,
rather than assuming that photographs can simply be inserted into this study.

If carrying this direction into Rails, replace the V1 layout and surface system
coherently across all pages. Reuse the existing calendar consumer, fresh modal
responses, fallback URLs, expanded answers, and verified facts. Review long event
names, cancellation, empty/unavailable feeds, missing contact channels, keyboard,
zoom, and no-JavaScript behavior in that implementation. Do not transfer prototype
state or static event snapshots into production.

No commit, push, publisher edit, production inspection, or deployment was performed.

## Verification of the study

- Captured the four main pages at desktop, intermediate, and phone sizes, with
  target widths of 1440, 1024, 800, 390, and 320px. Inspected the overall desktop
  compositions, the narrower home layout, and phone Home/Events/First visit.
  All five FAQ answers remain visible. The captures include the preview wrapper.
- Checked all seven navigation destinations and opening event details from the
  Events list. Escape closes the dialog, focus returns to the event link, Enter
  reopens it, and the Close control works. The embedded preview's dialog is
  anchored near the visible start of the page so it remains reachable on a phone.
- Reviewed empty and temporarily unavailable calendar states on Home and Events
  at desktop and narrow-phone sizes. Each keeps the relevant meeting/visit path.
- Reviewed light and dark appearances. Calculated text contrast for the main
  palette pairs; the lowest checked ratio is 5.62:1. This is not a complete
  accessibility audit of the eventual Rails implementation.
- Browser runs reported no script errors. The fragment passes JavaScript syntax,
  size, embedded-asset, and document-shape checks. It makes no API calls.
- Full-page capture through the native browser tool intermittently returned
  blank iframe images despite visible page content. Final page captures use
  normal screenshots with the preview height fitted to its content. All saved
  captures were checked for this blank-image failure.

Evidence: [interaction checks](browser-checks.json), [capture checks](capture-checks.json),
[empty/unavailable states](state-checks.json), and [final modal checks](modal-checks.json).
The editable [study fragment](study-fragment.html) embeds the existing licensed
fonts and unchanged official brandmark so it can be reviewed without remote
assets; font licensing remains in `app/assets/fonts/FONT-LICENSE.txt`. It is an
isolated review source, not an application page or production asset.

No Rails suite or production build was rerun: this pass changes the design study
and project guidance, with no application-code changes. Prior application checks
remain historical evidence rather than validation of a future implementation.
