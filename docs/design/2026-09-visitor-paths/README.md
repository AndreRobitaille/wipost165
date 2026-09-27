# Visitor paths — September 27, 2026

SITE-02 implementation and local review. This changes the Rails app; it does not
update the separately hosted Sites mockup or the live coming-soon page. All people,
portraits, and event examples in these captures are explicitly synthetic.

## Direction and findings

The visitor task is to recognize someone, find an occasion, and understand a first
visit without needing to identify a personal motive. Keep the shared table as the
signature and make its interior a readable place for practical information.

The existing palette remains Legion blue `#00467F`, deep blue `#002E55`, poppy red
`#B5121B`, light table `#F5F8FA`, ink `#173E5C`, and supporting text `#506A7C`.
Company Display carries short headings; Company Sans carries stories, practical
details, and controls. Official artwork is unchanged. No new illustration or
photo production was needed.

Before the change, the phone hid quick links, every detail page repeated all three
portraits above its content, and long names depended on fixed portrait positions.
A person not currently featured could have a story page without their portrait.
Calendar rows omitted time, and preview labels hid cancellation labels.

The resulting composition is:

```text
Welcome                         Interior
Post identity + quick links     Post identity + quick links
   faces at the far edge          a quieter table edge
     welcome on the table         back link / selected portrait
     introductions + events       story, event, or visit details
      People · Events · Visit      People · Events · Visit
```

- The full gathering belongs to the welcome. Interior pages retain the table with
  the destination near the top; a story shows its own portrait, even off rotation.
- Portraits participate in normal layout, allowing zero through three people.
  At phone widths, any display name longer than 20 characters switches the group
  to portrait-and-name rows. This threshold changes presentation only, not names.
- Quick event/contact links remain visible on phones. Navigation and key actions
  use 16px text and at least 44px targets. Stories and practical copy stay readable.
- A remembered introduction links back to its story without implying attendance.
  Event details link back to the list and forward to first-visit guidance.
- Event rows show date/time and cancellation independently of the preview label.
  Cancelled details remove the invitation action and clearly state cancellation.
- Empty and unavailable calendars differ. Without a configured public contact,
  visit/calendar pages omit enquiry actions that cannot be fulfilled. Contact
  remains reachable with its honest pending state.
- Membership and veteran-help pages have current authoritative external routes;
  sources and local facts still needed are in [content readiness](../../launch-content-readiness.md).
- Consolidated the prototype and Rails override styles in `company.css`; removed
  the redundant `rails_pages.css` and factored the portrait markup into a partial.

## Review images

| Visitor path/state | Capture |
| --- | --- |
| Welcome | [Desktop](previews/welcome-desktop.png), [phone](previews/welcome-phone.png) |
| Introduction | [Phone](previews/introduction-phone.png) |
| Direct event visit | [Phone](previews/event-phone.png) |
| First visit | [Phone](previews/visit-phone.png), [keyboard disclosure](previews/keyboard-visit-phone.png) |
| Fewer introductions | [One](previews/1-people-phone.png), [two](previews/2-people-phone.png), [zero](previews/empty-people-phone.png) |
| Long names | [320px phone](previews/long-names-320.png) |
| No upcoming events | [Empty calendar](previews/empty-calendar-phone.png) |
| Feed outage | [Unavailable calendar](previews/unavailable-calendar-phone.png) |
| Cancellation | [Cancelled event](previews/cancelled-phone.png) |
| Image failure | [Neutral portrait fallback](previews/portrait-unavailable-phone.png) |
| JavaScript disabled | [Native first-visit disclosure](previews/visit-no-javascript.png) |

## Verification

- `bin/ci` passed: **36 tests, 234 assertions**, 39 Ruby files linted, gem and
  JavaScript advisory checks, Brakeman, autoloading, and production assets.
- Integration coverage includes the introduction → event → visit → contact
  context, configured email output, missing-contact behavior, independent profile
  portrait, cancellation labels, and existing withdrawal/cache/escaping checks.
- Chromium through agent-browser: **69 page/width combinations** at 320, 390,
  and 1440 CSS pixels. Checked horizontal document overflow and bounds of main
  navigation/action links. Inspected saved captures of the important states.
- The regular preview covered welcome, person, event list/detail, visit, contact,
  membership, help, about, and missing person routes at each width.
- A temporary local-only Rack fixture on loopback exercised one/two/zero people,
  empty versus unavailable calendars, timed and multi-day all-day events,
  cancellations, long names/titles, and a 12-paragraph synthetic story. It did not
  contact the publisher or add public scenario/query controls to the application.
- Tab → skip link → Enter focuses the content. Native FAQ summaries open with
  Enter; focus remains visible. With page JavaScript disabled, keyboard navigation
  from an introduction to first visit and opening a disclosure still work.
- Reduced-motion emulation reports `prefers-reduced-motion: reduce` and computed
  animation `none`. Forcing a portrait URL to return 404 hides the image and shows
  the neutral fallback while retaining the introduction.
- A 200% CSS-zoom rendering of first visit at 1440px kept content/actions within
  the viewport; this is an enlargement check, not a native browser-zoom audit.
- Measured palette contrast: ink/table 10.47:1, supporting text/table 5.33:1,
  white/red action 6.85:1, white/blue 9.62:1, cancellation text/background 7.74:1.
  This is not a screen-reader or full accessibility certification.
- No page JavaScript errors were reported in the checked session. The intentional
  missing-image request produces an expected resource failure.

Review captures place the entire document inside the viewport. The no-JavaScript
journey used native keyboard navigation and disclosure controls.

## Owner review

September 27, 2026: after viewing the desktop capture, the owner said, “Looks good.
No real feedback on it other than I like it.” The current visual direction is
accepted. The agent's suggestion to tighten desktop vertical spacing was optional
critique, not an owner-requested change or outstanding task. Preserve the current
composition unless later evidence or feedback gives a reason to change it.

This records approval of the desktop design presented; it does not claim the owner
personally reviewed every mobile/edge-state capture or authorized a release.

## Remaining boundary

Scenarios are design/QA
exercises, not interviews or proof of visitor outcomes. Real portraits, introductions,
public contact, arrival/access/guest facts, and content ownership still need local
confirmation. No Post-specific facts were inferred from historical candidate values.

The publishing API, live grants and withdrawal behavior, and full-site deployment
remain SITE-04/05. This session made no companion, production, DNS, or mail changes,
and did not commit, push, or deploy. The checklist prioritizes the next owner input;
it does not authorize publication.
