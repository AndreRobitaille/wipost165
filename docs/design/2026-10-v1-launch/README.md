# V1 launch first pass — October 7, 2026

The owner requested a practical first launch without people, portraits/photos,
or personal stories, with the current richer experience becoming V2 in roughly
one or two months. This is a local first pass for review; no launch, commit, push,
publisher edit, or deployment has occurred.

**Current status: visual direction reopened.** The owner rejected the overall
appearance after the interior pass and confirmed that the messaging is good.
See the [whole-site reassessment and replacement study](../2026-10-visual-reset/README.md).
The dated passes below preserve earlier decisions and functional verification;
they are not evidence of approval of the current V1 appearance.

## Direction and content

Visitor task: identify the local Post, find an occasion, understand a first visit,
and reach an actual contact. Emotional aim: fellowship, service, and an easy first
hello. The signature is a large typographic welcome alongside an open curved
invitation surface, carrying some of the shared-table language into V1.

The original idea of simply using the zero-people table state was rejected for this
pass: it leaves the homepage organized around material intentionally deferred.
V1 instead gives public occasions and the visitor's next step their own composition.
There is one dominant invitation; practical information stays quiet and grouped.

| Role | Treatment |
| --- | --- |
| Identity | Legion blue `#00467F`, deep blue `#002E55`, unchanged official white brandmark |
| Reading | Light surface `#F5F8FA`, ink `#173E5C`, supporting text `#506A7C` |
| Action | Poppy red `#B5121B`, used for the primary event link |
| Display | Existing licensed Company Display condensed face |
| Body/utility | Existing licensed Company Sans, 16–18px body and navigation |

```text
brand / Post identity                        Events · First visit · Contact

Still serving.                               next published public occasion
In good company.                             date / time / place / details
brief welcome + event / visit actions         curved invitation surface

first-visit guidance          regular meeting details          contact

service statement                            About · Membership · Help · Members
```

V1 uses only the already recorded Post/contact/meeting facts and approved publisher
event output. It adds no invented programs, local history, testimonials, greeters,
guest policies, or broader accessibility promises. The regular meeting venue is
clearly distinct from each event's location and from the mailing address.

## Preserving V2 and defining V1

- `PUBLIC_SITE_EDITION=v1` is the default; `v2` selects the preserved full layout
  and homepage. Edition is an operator setting, never a visitor query parameter.
- The original application layout, people homepage, portrait partial, recognition
  partial, and shared-table stylesheet remain intact. Sample artwork is preserved
  under `app/assets/preview/people`, retaining its logical asset names.
- V1 has its own layout/homepage/stylesheet, distinct events/visit/contact views,
  and shares the
  authenticated event consumer. It does not read featured people or remembered
  person context. Story and portrait routes return 404 without a publisher request.
- Production V1 asset compilation excludes the preview artwork directory. The
  production setting still keeps coming-soon on and launch readiness off.
- Before editing, 339 tracked/untracked source files were copied to
  `/tmp/wipost165-v2-before-v1-20261007`; ignored files and secret keys were excluded.
  This temporary copy supplements the preserved V2 source, not a Git checkpoint.
  No existing changes were staged, reset, or discarded.

This first pass uses one shared app to make both editions easy to review without
committing the existing dirty checkout. After design review, checkpoint the intended
source with authorization and keep V2 current with the live V1 fixes. Preserve
existing practical URLs when V2 launches.

## Launch sequence and dependencies

1. Review the V1 composition and content emphasis; refine the affected paths.
2. Complete V1 event-publisher evidence, factual content readback, release/container
   verification, and a rollback target. Consent/story/portrait evidence belongs to
   V2 while those public routes are disabled; event eligibility/private-field
   exclusion and calendar lifecycle evidence remain V1 requirements.
3. With release authorization, commit/push the reviewed candidate and deploy using
   one persistent `bin/release session`. Verify the released edition, both domains,
   blocked people routes, indexing, assets, and protected companion services.
4. Collect and approve real introductions/photos/stories privately over the next
   month or two. Verify publisher consent, replacement, and withdrawal behavior.
5. Review and launch V2 with current V1 fixes, approved content, and fictional
   stories/portraits withdrawn from public availability. November–December is a
   target window, not an automatic content or launch deadline.

## Verification

- `PARALLEL_WORKERS=1 bin/ci` passed: **70 tests / 661 assertions**, Ruby style,
  gem/JavaScript/Rails security checks, autoloading, and production asset compilation.
  The V1 asset manifest contains no `people/` preview portraits. A final 320px-only
  type-size adjustment was checked visually and compiled afterward.
- Browser review passed **27 page/width combinations** at 1440, 390, and 320px:
  home, events, a live event detail, visit, contact, about, membership, veteran help,
  and a blocked story URL. One H1/main landmark, loaded official artwork, no
  horizontal overflow, and no story links/person context were checked.
- Actual keyboard skip navigation, native visit disclosures, visit-to-contact
  clicks, browser Back, and reduced motion passed. A separate Chrome profile with
  JavaScript disabled passed page reading, navigation, and native disclosures.
- Empty, unavailable, and long-title invitations passed phone review using a
  temporary local synthetic harness. Empty and unavailable calendars remain
  distinct; both retain practical visit/meeting/contact information. The long-title
  example is visibly labelled and was never entered in the publisher.
- Live website-token events rendered locally, including the October 24 Old Glory
  Honor Flight fundraiser. This proves consumer reads/rendering, not all companion
  lifecycle/permission requirements. No people reads were needed for V1.
- Palette contrast checks ranged from **5.33:1 to 10.47:1** for body/supporting
  text, primary actions, and headings against their backgrounds.
- V2's original layout, homepage, portrait/recognition partials, stylesheet, and
  relocated sample image bytes match the pre-edit copy exactly. A fresh V2 offline
  preview rendered all three portraits, with its sample-content banner.
- Local review servers are available on `http://127.0.0.1:3001` (V1, live events)
  and `http://127.0.0.1:3002` (V2, labelled offline samples). Temporary state-review
  servers and browser automation sessions are stopped after capture.

| Capture | Purpose |
| --- | --- |
| [V1 desktop](previews/home-desktop.png) | Actual published event, welcome, practical details |
| [V1 phone](previews/home-phone.png) | 390px composition |
| [Narrow phone](previews/home-320.png) | 320px layout and readable headline |
| [Events](previews/events-phone.png) / [event detail](previews/event-phone.png) | Direct calendar journey |
| [First visit](previews/visit-phone.png) / [JavaScript disabled](previews/visit-no-javascript-phone.png) | Native guidance and navigation |
| [Empty](previews/home-empty-phone.png) / [unavailable](previews/home-outage-phone.png) | Distinct sparse/error invitations |
| [Long title](previews/home-long-phone.png) | Labelled synthetic stress case |
| [Preserved V2](previews/v2-preserved-desktop.png) | Original people composition, offline samples |

Machine-readable local observations: [visitor paths](browser-checks.json) and
[synthetic/no-JavaScript states](state-browser-checks.json). The first-pass review
does not establish owner approval, container verification, full publisher lifecycle
coverage, or deployed-site readiness. Those remain the scoped release gates.

## Owner review and white-surface typography refinement

October 7: the owner liked the V1 first pass and requested more character in the
text inside the white surfaces. Refined the event date, used the existing condensed
face for practical headings and the meeting schedule, emphasized the meeting time
in Legion red, and grouped event/contact details with semantic labels. Split the
first-visit copy into a lead and supporting sentence. Public facts, destinations,
the outer composition, and V2 are preserved.

Updated captures: [desktop](previews/home-refined-1440.png),
[phone](previews/home-refined-390.png), [320px](previews/home-refined-320.png),
[empty](previews/home-refined-empty.png), [unavailable](previews/home-refined-outage.png),
and [long title](previews/home-refined-long.png).

Verification: CI passed again with 70 tests / 661 assertions and all checks.
The six captured page/state combinations fit their viewports; empty/outage copy
and synthetic labels remained correct. The email link was reached with Tab and
retains a visible focus outline and 44px target. The first automation attempt's
direct focus locator failed; actual keyboard navigation passed. No new tests were
added for typography. Generated production assets were clobbered after validation;
the live-event V1 preview remains available locally. No commit or deployment.

## Cards and color follow-up

October 7: the owner clarified that borders, cards, and a splash of color were the
intended refinement; the larger type still felt like a wall of text. The visitor
task remains finding the next occasion, understanding a first visit, and reaching
the Post. This pass changes grouping and surfaces rather than adding copy.

The practical section is now three separate framed cards. First-visit guidance
sits on deep Legion blue with white text; the meeting card has a red top edge and
a boxed schedule; the contact card uses soft blue `#E7F0F6` with separate white
email/phone boxes. Event time/location are framed rows, and the event date is a
calendar tile with a red month strip. Borders use `#BDCED9`. The existing curved
invitation remains the main graphic form; public facts, links, and V2 are unchanged.

Desktop retains the welcome/invitation pair. At 900px and below they stack, after
visual review caught cramped event-title wrapping at tablet width. Practical cards
reflow from three columns to two, then one on phones. No new imagery or animation.

Updated captures:
[desktop](previews/home-cards-desktop.png),
[small desktop](previews/home-cards-small-desktop.png),
[900px](previews/home-cards-tablet-breakpoint.png),
[tablet](previews/home-cards-tablet.png),
[701px](previews/home-cards-above-phone-breakpoint.png),
[phone](previews/home-cards-phone.png),
[narrow phone](previews/home-cards-narrow-phone.png),
[empty](previews/home-cards-empty.png),
[unavailable](previews/home-cards-outage.png), and
[long title](previews/home-cards-long-title.png).

CI passed with **70 tests / 661 assertions** and all checks. The final CSS
breakpoint adjustment was checked in the browser and compiled in production mode
afterward. The ten viewport/state combinations have one main/H1, loaded artwork,
three practical cards, no people links, and no horizontal overflow. New text/color
pairs range from **4.93:1 to 13.80:1**. Actual Tab navigation reached the first-visit
and email links with visible 3px outlines and 44px targets; Enter opened the visit
and event-detail pages, and browser Back worked. The CLI's initial pointer locator
returned without navigating; keyboard activation passed on the final run. These
are local browser/application checks, not new deployed-site evidence.

Results: [card browser checks](card-browser-checks.json). Synthetic state-review
and automation processes are stopped. Generated assets were clobbered and the V1
live-event preview restarted at port 3001. No commit, push, or deployment.

## First-visit card moved into the welcome

October 7: the owner preferred first-visit guidance in a white box higher in the
right column beside “Still serving,” and the next-public-occasion block as the
darker card. Moved the existing first-visit content into the curved white welcome
surface. The occasion is now a wider deep-blue card in the lower row, beside the
meeting and contact cards. Its title, links, and logistics remain readable in
white/light blue. The existing date tile and framed details remain.

Phone source/reading order is welcome, first visit, next occasion, meeting, then
contact. First-visit guidance appears once; its links and public facts are unchanged.
The independent meeting/contact card headings are now H2s. No new content or
imagery, publisher behavior, or V2 change.

Current captures:
[desktop](previews/home-visit-first-desktop.png),
[small desktop](previews/home-visit-first-small-desktop.png),
[900px](previews/home-visit-first-tablet-breakpoint.png),
[tablet](previews/home-visit-first-tablet.png),
[701px](previews/home-visit-first-above-phone-breakpoint.png),
[phone](previews/home-visit-first-phone.png),
[320px](previews/home-visit-first-narrow-phone.png),
[empty](previews/home-visit-first-empty.png),
[unavailable](previews/home-visit-first-outage.png), and
[long title](previews/home-visit-first-long-title.png).

CI passed on the final source: **70 tests / 661 assertions**, style/security,
autoloading, and production assets. Ten viewport/state combinations passed:
correct white/dark surfaces, first visit beside the headline on desktop and before
the event in source/phone order, one main/H1, loaded artwork, three lower cards,
no people links, and no horizontal overflow. Keyboard focus, Enter navigation to
visit/event details, and browser Back passed. New dark-card text/background pairs
range from **7.60:1 to 13.80:1**; the white visit card retains its verified contrast.

Results: [placement browser checks](visit-placement-browser-checks.json). Synthetic
state-review and browser processes are stopped; generated assets were clobbered,
and the live-event V1 server remains on port 3001. No commit, push, or deployment.

## Responsive composition follow-up

October 7: the owner's laptop/narrow-window screenshots showed that the wide
composition felt sparse and the narrower version looked odd. The previous 900px
stacking threshold left a tall, left-aligned headline with empty space beside it,
then stretched the curved visit card across the page. Passing overflow assertions
did not establish that this composition worked.

The welcome and visit card now remain side by side above 740px, using fluid type,
closer column proportions, and smaller gaps/padding. The wide layout is also
tighter so the lower cards appear sooner. Below 740px the explicit break inside
“In good company” is hidden, letting that phrase occupy one line when it fits.
The stacked visit card has simple rounded corners and less padding, avoiding a
large stretched arc. True phones still wrap naturally. Reading order, content,
colors, navigation, and V2 are unchanged.

Current captures:
[wide desktop](previews/home-responsive-wide-desktop.png),
[laptop](previews/home-responsive-laptop.png),
[small laptop](previews/home-responsive-small-laptop.png),
[900px](previews/home-responsive-medium.png),
[narrow-window comparison](previews/home-responsive-owner-narrow.png)
([viewport only](previews/home-responsive-owner-narrow-viewport.png)),
[tablet](previews/home-responsive-tablet.png),
[741px](previews/home-responsive-two-column-edge.png),
[740px](previews/home-responsive-stacked-edge.png),
[small tablet](previews/home-responsive-small-tablet.png),
[phone](previews/home-responsive-phone.png),
[320px](previews/home-responsive-narrow-phone.png),
[empty](previews/home-responsive-empty.png),
[unavailable](previews/home-responsive-outage.png), and
[long title](previews/home-responsive-long-title.png).

CI passed on the final source: **70 tests / 661 assertions** plus style/security,
autoloading, and production assets. Fourteen viewport/state combinations passed,
including both sides of the new layout threshold. Placement, source order,
white/dark surfaces, loaded artwork, main/H1 counts, and horizontal overflow were
checked. The stacked visit card shares the content width; the secondary headline
break is hidden there. Actual keyboard focus, Enter navigation to visit/event
details, and browser Back passed. No new color pairs or application behavior.

Results: [responsive browser checks](responsive-browser-checks.json). Synthetic
state-review and automation processes are stopped; generated assets were clobbered,
and the V1 live-event preview remains at port 3001. No commit, push, or deployment.

## Interior pages and event modal

October 7: the owner requested Home before Events, a less flat Events and Contact
page, calendar details in a modal, cleaner event hovers, and fully expanded
first-visit questions. This pass carries the homepage's Legion blue field, framed
light surfaces, red calendar tiles, and existing Company typefaces into those
visitor paths.

- **Navigation:** Home precedes Events, with a visible current-page treatment.
  Four links fit at 320px; the menu gets its own row at smaller laptop widths.
- **Events:** each occasion has a bordered card with a red month strip, large day,
  title, and labelled date/time/location. Hover changes the surface and details
  marker instead of underlining the whole card. Small phones give logistics the
  full card width. First-visit and regular-meeting guidance have distinct surfaces.
- **Details:** calendar cards open a native modal and fetch the selected event
  through the existing authenticated client. Cancelled, withdrawn, unavailable,
  and expired responses retain their existing semantics. Frame failures offer a
  retry. Close, Escape, and backdrop clicks restore focus and release scrolling;
  Tab/Shift-Tab wrap through the modal's controls, including a single Close button.
  Long content scrolls beneath a pinned close bar. Hover prefetch is disabled to
  keep a full-page response from being reused as a modal fragment. Closing clears
  the frame; reopening goes through the publisher's freshness rules again.
- **First visit:** all five answers are visible in separate cards. Meeting time
  and address have a larger structured panel. The existing bounded facts and
  visitor guidance are retained.
- **Contact:** email, phone, and mailing address have separate white, pale-blue,
  and dark-blue cards. Email/phone remain actual links. Explicitly blank channels
  are omitted, with the mailing address and visit navigation still available.

Direct event URLs and JavaScript-disabled calendar links still have a complete
page fallback. V2's original layout, homepage, portrait/recognition partials,
stylesheet, and three relocated portrait assets remain byte-identical to the
pre-V1 source copy. No publisher records or production settings were changed.

Verification on the final application source: **76 tests / 735 assertions**,
Ruby style, security checks, autoloading, and production asset compilation passed.
Six added integration tests cover lazy detail fetching, escaped modal fragments,
cancellation, 404/503 errors, expiry during rendering, expanded answers, and absent
contact channels. Generated V1 assets omit preview portraits. Clear generated
assets before repeating CI: its production manifest otherwise masks source preview
artwork used by V2 tests. Assets were clobbered afterward and the owned V1 review
server restarted.

Browser review checked Events, First visit, and Contact at 1440, 814, 390, and
320px, plus the updated homepage menu. Live event details stayed on `/events` at
1440/390px. Synthetic, explicitly labelled review states covered a long description,
cancellation, withdrawal, unavailable details, a missing frame, an aborted request
and successful retry, empty/unavailable calendars, and absent contact channels.
Keyboard focus, close/backdrop behavior, modal-to-visit navigation, no-JavaScript
fallback, and the preserved V2 preview were checked. Automation interactions with
controls below the viewport required explicit scrolling before clicking.
The installed Turbo library reports a fetch exception for the deliberately
aborted request; the visible error state and subsequent successful retry were
verified. Ordinary page loads and modal states had no unexpected browser errors.

| Current capture | Purpose |
| --- | --- |
| [Events desktop](interiors-events-1440.png) / [phone](interiors-events-390.png) | Date cards and practical sidebar |
| [Hover](interiors-events-hover.png) | Whole-card treatment without blanket underlines |
| [Event modal desktop](interiors-event-modal-1440.png) / [phone](interiors-event-modal-390.png) | Actual published event details |
| [First visit desktop](interiors-visit-1440.png) / [phone](interiors-visit-390.png) | Five visible answers and meeting panel |
| [Contact desktop](interiors-contact-1440.png) / [phone](interiors-contact-390.png) | Distinct contact channels |
| [Long modal](interiors-modal-long-320.png) / [cancelled](interiors-modal-cancelled-320.png) | Labelled synthetic stress cases |
| [Withdrawn](interiors-modal-withdrawn-320.png) / [unavailable](interiors-modal-unavailable-320.png) | Errors remain in the modal |
| [No JavaScript event](interiors-event-no-javascript-390.png) / [visit](interiors-visit-no-javascript-390.png) | Complete fallback reading/navigation |

Local observations: [page composition and live modal](interiors-browser-checks.json),
[synthetic states and keyboard paths](interiors-state-browser-checks.json), and
[final modal/V2/no-JavaScript review](interiors-final-browser-checks.json).
The live-event V1 review remains on port 3001; V2 remains on port 3002 with labelled
samples. Temporary harness/browser sessions are stopped after review. These are
local changes and checks, with no commit, push, release, or production inspection.
