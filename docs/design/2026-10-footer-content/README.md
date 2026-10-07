# October 7 — About, Membership and Veteran help

Scope: one review PR from `main` for issues #7, #8 and #9. No deployment to Sites
or Hetzner, no merge, no companion changes. Both editions use these shared views.

## Editorial and visual direction

The owner supplied the complete [public page fact sheets](../../public-page-facts.md),
including confirmed local membership and Service Officer answers. The file is
assembled verbatim from the three supplied sections, with blank lines at their
boundaries. The [readiness worksheet](../../launch-content-readiness.md) now links
the record and marks dues/joining information confirmed.

Keep Legion blue `#00467f`, poppy red `#b5121b`, light paper `#f5f8fa`, the existing
edition's dark blue, and Noto-derived body/display faces. Each page has a distinct
reading task within its existing layout: local service stories and a 1928 history
note for About; visible questions with a clear $45/meeting action for Membership;
a compact guide with crisis contact first for Veteran help. Shared scoped styles
retain V1's normal page and V2's table framing, without another grid of cards.
No new artwork, portraits, animation or accordion interaction is needed.

## Sources checked and decisions

The source record is owner-supplied evidence, including some draft meeting
summaries; this pass does not claim direct verification of private minutes. Public
references checked October 7: [National FAQ](https://www.legion.org/faq),
[Legion mission](https://www.legion.org/about),
[renewal destination](https://www.legion.org/renew),
[Historical Society memorial-tree account](https://www.manitowoccountyhistory.org/stories/american-legion-memorial-trees),
[Veterans Crisis Line](https://www.veteranscrisisline.net/) and its chat entry,
and [county veterans services](https://manitowoccountywi.gov/departments/veteran-s-services/).

- **Meeting/calendar mismatch:** the requested “check the events calendar for the
  next meeting” would be misleading. The public publishing contract excludes
  regular member meetings. Membership instead links the calendar for public
  occasions, notes possible skipped summer months, and directs date confirmation
  to the Post when a contact channel is available. No API policy was changed.
  Home and First visit retain their existing full recurring-meeting wording;
  aligning those pages with summer exceptions is outside this three-page pass.
- **Renewal timing:** the fact sheet says renewals open in fall; National's current
  FAQ says it accepts next-year dues starting July 1. Neither opening date nor
  delinquency milestones are necessary for this page, so they are omitted. The
  supplied fact sheet is preserved unchanged, with the discrepancy recorded here.
- **History:** use “hundreds of elms” and 1928, without an exact tree count. Omit
  the unconfirmed charter date, namesake biography, awards and optional 2021 plaque
  passage. The linked Historical Society article supports the printed history.
- **Service boundaries:** crisis help is first; Post phone/email are never labelled
  emergency or direct Service Officer lines. The page promises only the confirmed
  first-contact/referral role. County hours and specialized legal/accreditation
  claims stay off the page. No individual assistance cases or officer names appear.
- **Contact absence:** both pages use the existing helpers and omit hidden channels.
  Membership still leads to an in-person visit; Veteran help retains crisis and
  county routes and explains when Post contact details are unavailable.

## Verification

- `bin/ci` passes: 78 Rails tests / 902 assertions, nine Sites adapter tests,
  Ruby style and security checks, autoload validation and production assets.
- Both editions were inspected in a real browser at 1440, 390 and 320px: all
  three pages fit without horizontal scrolling. Desktop and phone screenshots
  were visually reviewed. V2 used its explicitly labelled sample preview mode.
- Membership's six answers remain visible; crisis support is the first service
  route. Keyboard navigation reaches the crisis call action with visible focus.
  Doubling the root text size at desktop width causes no horizontal overflow.
- Application tests cover email and phone independently present/absent in both
  editions. Additional phone-browser checks with both Post channels hidden retain
  the meeting-visit action, crisis contacts and county help, with a clear fallback.
- The supplied fact-sheet sections match the saved source record verbatim,
  apart from joining the section boundaries with blank lines.

[Browser measurements](browser-checks.json) and
[hidden-contact checks](hidden-contact-checks.json) record the local results.
No Sites or Hetzner deployment, production inspection, call, text or contact
submission was performed.

| Page | V1 desktop / phone | V2 desktop / phone |
| --- | --- | --- |
| About | [1440px](v1-about-1440.png) / [390px](v1-about-390.png) | [1440px](v2-about-1440.png) / [390px](v2-about-390.png) |
| Membership | [1440px](v1-membership-1440.png) / [390px](v1-membership-390.png) | [1440px](v2-membership-1440.png) / [390px](v2-membership-390.png) |
| Veteran help | [1440px](v1-veteran-help-1440.png) / [390px](v1-veteran-help-390.png) | [1440px](v2-veteran-help-1440.png) / [390px](v2-veteran-help-390.png) |
| Hidden contacts: Membership | [390px](v1-membership-hidden-390.png) | [390px](v2-membership-hidden-390.png) |
| Hidden contacts: Veteran help | [390px](v1-veteran-help-hidden-390.png) | [390px](v2-veteran-help-hidden-390.png) |
