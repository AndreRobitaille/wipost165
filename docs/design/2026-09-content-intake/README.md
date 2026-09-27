# Contact and first-visit content — September 27, 2026

SITE-03 local content update. The accepted SITE-02 layout and styles are unchanged.
The [readiness worksheet](../../launch-content-readiness.md) records the
owner-supplied source, follow-up answers, content responsibility, and remaining
introduction/photo collection. Nothing was deployed or changed in the companion.

## Changes

- Public email and phone now default to the sourced values. Environment overrides
  still work; an explicit blank hides that channel.
- Contact shows the postal address separately from the meeting location.
- Visit suggests a public event as a starting point, gives the regular meeting
  venue/time, and says no advance arrangement is needed to attend a meeting.
- Club access is described only as gravel parking and no steps. Guest/child
  arrangements and other event locations remain occasion-specific.
- Responsibility for enquiries stays out of public copy. Approved introductions
  and portraits are still to be collected; synthetic preview people remain labelled.

## Verification

- `bin/ci` passed after the final application changes: 36 tests, 234 assertions,
  39 Ruby files linted, gem/JavaScript audits, Brakeman, autoloading, and production
  asset compilation. The existing missing-contact assertion follows the revised
  fallback wording; no new test suite was added for static copy.
- A separate Rails test-environment check with both contact overrides blank
  confirmed no `mailto:` or `tel:` link and a retained postal address.
- Chromium through agent-browser: contact and visit inspected at 320px and 1440px;
  narrow views had no horizontal document overflow. Full-page captures below
  were visually inspected. The contact link targets were checked as
  `mailto:wipost165@gmail.com?subject=First%20visit%20to%20Post%20165` and
  `tel:9208607478`; no email or call was made.
- Keyboard Enter opened the meeting and parking disclosures; focus remained on
  the summary with a visible outline. No page JavaScript errors were reported.
- These checks used local labelled preview mode, not the live publisher. Earlier
  [SITE-02 checks](../2026-09-visitor-paths/README.md#verification) cover the broader
  visitor paths and failure states. No new container or production check was made.

| Page | Desktop | Narrow phone |
| --- | --- | --- |
| Contact | [Capture](previews/contact-desktop.png) | [Capture](previews/contact-phone.png) |
| Visit, meeting/access disclosures open | [Capture](previews/visit-desktop.png) | [Capture](previews/visit-phone.png) |

The temporary preview server and isolated browser session were stopped after
verification. Generated production assets were clobbered before the preview.
