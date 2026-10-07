# Final visitor-path and link review — September 27, 2026

SITE-05 browser/link review completed against local `main` at `c7b716e` plus the
uncommitted consumer and metadata changes. No application defect was found in this
pass, and no runtime code was changed. This does not close the container or
companion-evidence gates in the [release preparation](../2026-09-27-release-preparation.md).

## Environments and results

Three temporary loopback-only Rails servers were used, leaving the owner's server
untouched:

- Port 3101: explicit static design preview, with labelled fictional samples.
- Port 3102: preview off, reading the production publisher with the existing
  read-only website token. Avery, Morgan, and Sam remained explicitly fictional;
  no content was edited or published. Their three large portraits loaded through
  the local site's own image routes. No private/editorial API was used.
- Port 3103: preview off, a synthetic token and deliberately unreachable loopback
  publisher, to exercise outage presentation without disrupting any service.

Chromium via the agent-browser skill checked **42 page/width combinations** at
1440, 390, and 320 CSS pixels. Each had one primary heading, loaded images where
present, no horizontal document overflow, and noindex metadata. Static sample
paths covered welcome, introduction, events/list/detail, visit, contact, about,
membership, and veteran help. Live-feed checks covered welcome, all three story
pages, and the valid empty event list; outage checks covered home/events/visit/contact.

[Browser measurements and local link results](browser-results.json) record the
actual paths, dimensions, image sources, and robots directives. Key desktop/phone
captures were visually inspected. The accepted shared-table layout, long fictional
names, and readable interior paths remain intact; no redesign was needed.

The click-through journey preserved Frank's optional recognition context from
introduction through event and visit to the contact mailto subject, without sending
email. Browser Back/reload retained that context. Keyboard Tab reached the visible
skip link; Enter focused the main content. The visit disclosure opened with Enter
and had a visible focus outline. Reduced-motion emulation disabled the content
animation. Requesting a deliberately missing local portrait URL displayed the existing neutral
fallback without breaking the page. See [journey results](journey-results.json).
Existing [no-JavaScript and sparse-content evidence](../../design/2026-09-visitor-paths/README.md#verification)
was reused where the layout/behavior had not changed.

A first click automation attempt stalled on an offscreen CTA: agent-browser reported
success without scrolling or navigating. Explicit `scrollintoview` corrected the
harness; keyboard activation also worked. A subsequent harness-only selector quoting
error was corrected. The portrait-failure exercise used a distinct missing URL
to avoid reusing an already cached asset. These harness corrections required no
application change.

## Links

All **58 gathered local link targets**, including query-context variants and the
main-content fragment, returned 200 with existing fragment targets. HTTP GETs did
not submit forms, send mail, or invoke phone links.

[External checks](external-links.json):

- County veterans services: 200.
- American Legion membership FAQ: 200.
- Members-site link: redirects to `/session/new`, then 200.
- Three Pexels credits in static preview only: 403 to the automated fetch. This is
  inconclusive for human access; it is not evidence of a missing page. These credit
  links are absent when preview is off, including the live-feed full-site view.

Mailto/tel destinations were inspected as links only. No messages or calls were made.

## Review captures

| Check | Capture |
| --- | --- |
| Live fictional feed, desktop | [1440px welcome](live-home-1440.png) |
| Live fictional feed, phones | [390px](live-home-390.png), [320px](live-home-320.png) |
| Live introductions | [Avery](live-person-0-390.png), [Morgan](live-person-1-390.png), [Sam](live-person-2-390.png) |
| Honest empty calendar | [320px](live-empty-events-320.png) |
| Unavailable calendar | [320px](outage-events-320.png) |
| First visit and keyboard disclosure | [320px](sample-visit-320.png), [keyboard](keyboard-visit-320.png) |
| Actual click journey | [390px visit after Back/reload](journey-visit-390.png) |
| Missing portrait fallback | [390px](portrait-fallback-390.png) |

## Verification boundary and cleanup

The previous full CI remains applicable: 63 tests / 567 assertions, style/security,
autoloading, and production assets passed. It was not repeated for this browser
and documentation-only task. `bin/release check` passed locally, entrypoint syntax
passed, and the prepared release command blocks passed `bash -n`.

The temporary QA servers and task-owned browser sessions were stopped after review.
No production SSH session, deployment, DNS/mail change, live editorial mutation,
commit, or push occurred. Authenticated live publisher reads and ordinary read-only
external-link requests are the only remote application interactions in this pass.

**Next:** complete the pending local container smoke test once Docker access is
available and obtain the companion evidence handback. Technical readiness is not
complete until those material gaps are resolved. Then add approved real people/photos
last, verify the final content, and perform a separately authorized release using
the [prepared procedure](../2026-09-27-release-preparation.md).
