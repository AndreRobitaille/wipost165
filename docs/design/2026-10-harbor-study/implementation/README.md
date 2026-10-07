# Harbor direction implemented in V1

October 7, 2026. Local implementation of the owner's accepted harbor study,
corrected to National's brand guidance. This is the Rails application, not the
static study. Development preview: `http://localhost:3001/`, with live public
events and development noindex metadata. No commit, push, publishing mutation,
production inspection, or deployment occurred.

## Latest refinement: invitation and simpler Contact

The owner found the light footer and uniform blue information band too flat,
and Contact busy. The footer is dark again. Home’s next occasion now uses one
white invitation surface with a red calendar date and modest depth, with the
recurring meeting unboxed alongside it. The redundant contact strip stays removed.
Contact now has a short introduction and one grouped email/phone/mailing surface;
its large blue banner, repeated action labels/arrows and separate meeting strip
are removed. A direct meeting-location link remains with the mailing address.
The footer sits at the bottom of short pages rather than leaving a light gap below.

`bin/ci` passed (76 tests / 738 assertions). Home and Contact passed 1440, 1024,
814, 390 and 320px checks. Reviewed desktop/phone captures; verified native contact
links, the meeting link, keyboard order/focus, missing channels, and empty/outage
home states. V2 files and the event dialog controller are unchanged. Removed
unused Contact styles in the simplify review. [Current captures and checks](contact-and-invitation/).
No new tests for this presentation-only change; existing behavior tests pass.

## Earlier refinement: quieter home (superseded)

The owner found the contact prompt redundant and the event/meeting band too busy.
Removed Home’s “Have a question?” strip; Contact remains in the main menu. The
footer now uses the light brand neutral with blue links. The event and meeting
sections share one blue ground, with a subtle divider instead of a red edge and
second dark panel. Only the event title and meeting day use prominent white type;
supporting details use a readable blue tint. Shortened the date stamp and meeting
summary while retaining the full event date/time, venue, recurrence and links.

`bin/ci` passed again (76 tests / 738 assertions). Home passed 1440, 1024, 814,
390 and 320px with no overflow; Contact also checked at 320px. Desktop and phone
compositions visually inspected. [Updated captures and checks](quieter-home/).
No new behavior or tests were added for this presentation-only adjustment.

## What changed

- Home: credited Two Rivers illustration beside the welcome, explicit “Veterans
  serving Two Rivers” introduction, live next occasion, regular meeting details,
  first-visit invitation and contact route. No fabricated program claims or people.
- Events: month-grouped open rows, prominent dates, clean hover treatment. Existing
  fresh-detail dialog behavior and ordinary event URLs are preserved.
- First visit: five open answers with a distinct meeting summary; no accordion.
- Contact: prominent email/phone rows and clearly separate mailing information.
- The same typography, spacing, and colors also style the shared About, Membership,
  Veteran help, direct event, and missing/unavailable pages within V1.

[National reference review](../national-references/README.md): the owner subsequently
questioned whether scenery conveys veteran service. The strongest reference lesson
is recognizable veterans sharing work and fellowship, with local geography as
setting. An optional question about allowing anonymous illustrated people has
not been answered; the implemented artwork therefore remains people-free. Do not
mistake the accepted harbor direction for approval of new synthetic people.

## Brand and artwork

[Brand evidence](../../../brand/README.md) records visually inspected guide pages,
live source checks, exact blue/red/neutral values, bundled Noto Sans font metadata,
and the unchanged official white brandmark's matching SHA-256. The study's gold
accent was removed. Dark surfaces and rules are blue tonal mixes. Measured
text/background contrast: blue on Light Blue 9.02:1; white on Poppy Red 6.85:1;
muted text on Light Blue 7.21:1; body text on Light Blue 14.92:1.

The app's `two-rivers-harbor-illustration.webp` is the same compressed artwork as
[the accepted asset](../assets/two-rivers-harbor-illustration.webp). The adaptation
is CC BY-SA 4.0, based on Chris Rand's 2015 harbor photo. It changes season,
light and style and simplifies details; it does not represent a current photograph
or the Post's venue. The page labels it an illustration and links the photographer's
source and license. The official logo is separate HTML artwork and was not sent
to image generation.

## Verification

The subsequent [First visit meeting-panel refinement](visit-meetings/README.md)
replaces the solid red sidebar with a light schedule/location note and directions
link. Its five-width captures supersede this directory's earlier Visit screenshots.

- `bin/ci`: **76 tests, 738 assertions, zero failures/errors**, plus Ruby style,
  dependency/JS audits, Brakeman, autoloading and production assets. [Log](ci.log).
  Production V1 assets include the harbor and exclude preview people artwork.
- Home, Events, First visit and Contact at **1440, 1024, 814, 390 and 320px**:
  loaded images, one main heading and no horizontal overflow. About, Membership
  and Veteran help also checked at 320px. [Results](browser-checks.json).
- Visually inspected desktop/phone Home, desktop Events, desktop Visit, phone
  Contact, intermediate-width Home, and the 320px modal.
- Modal: fresh live details, focus entry, Tab/Shift-Tab containment, Escape/focus
  return, no page navigation, scrolling, close control, and clean event hover.
- Temporary synthetic local server: long and cancelled events, withdrawn/unavailable
  responses, malformed frame, induced network failure and successful retry;
  calendar empty/outage and absent email/phone. [State results](state-browser-checks.json).
  No publisher writes or local database use. Synthetic server stopped afterward.
- Empty/outage home at 320px retained meeting guidance without overflow.
  [Final state and brand-style checks](final-checks.json).
- JavaScript disabled: calendar links opened full event pages; all five visit
  answers remained visible. Skip link and reduced-motion checks passed.
- No unexpected browser script errors. The deliberately aborted network request
  produced Turbo's expected failed-fetch error while showing a usable retry state.
- Simplify review: page-only rendering changes, scoped CSS, no new controller or
  JavaScript abstraction. V2 templates/styles, shared support templates, and the
  existing event-dialog controller match their before-edit hashes. The earlier
  dirty worktree and private credentials were preserved.

Screenshots are dated review evidence; event titles/times come from the publisher
and may change. This verifies local behavior, not production or publisher-editor
lifecycle requirements. Remaining launch gates are in [ROADMAP](../../../ROADMAP.md).
