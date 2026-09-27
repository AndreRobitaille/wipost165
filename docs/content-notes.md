# Content lessons and facts to verify

These notes were distilled from the retired implementation's content and setup
documents on 2026-09-07. They are inputs to a new design, not a schema, route map,
editor workflow, or feature commitment.

## Useful content questions

Visitors wanted event dates and locations, an explanation of the post's work,
ways to participate, and a reachable person. The old navigation grouped these
under Home, Events, Membership, About, and Contact. That grouping can change.
Public events, post meetings, and honor guard observances had different audiences;
clear written audience labels helped visitors decide what applied to them.

The last homepage invited people to help before presenting dues and eligibility.
Those details were reserved for membership content, and member counts were
optional. This was an editorial experiment, not a restriction on future placement.
Support was contact-oriented; payments and private resources were deferred in the
old v1. Those scope labels are retired. The new public site's relationship to
member services and any payment workflow remains to be designed.

## Maintenance lessons

- Meeting and contact facts were duplicated across several surfaces and could
  contradict each other. A reliable source and clear editing ownership matter.
- A standing meeting rule and per-occurrence changes addressed recurring dates,
  cancellations, rescheduling, and venue changes. Manually entered copies could
  create duplicate listings. A future calendar need not reuse this mechanism.
- Date calculations needed local time (`America/Chicago`), month/year rollover,
  daylight-saving transitions, and before/after-start checks.
- Empty calendars, missing contacts, and absent or low-resolution photographs
  were realistic states. Sparse content should still help the visitor.
- The earlier seasonal fallback assumed quiet public-event months from October
  through March. Confirm the current calendar rather than hard-coding that claim.
- Stored live content and uploads were not fully represented in Git. Removal of
  code does not export, migrate, or delete that content. Any future migration
  needs a current inventory and an explicit source of truth.

## Historical candidate facts — not verified for publication

The old setup checklist listed the following. Retaining them avoids losing leads;
it does not establish that they are accurate today:

| Item | Previously recorded value |
| --- | --- |
| Formal name | Robert E. Burns American Legion Post 165 |
| Mailing address | PO Box 11, Two Rivers, WI 54241 |
| Meeting venue | Manitowoc Rifle & Pistol Club |
| Meeting address | 7227 Sandy Hill Ln, Two Rivers, WI 54241 |
| Standing meeting time | First Tuesday of each month, 6:30 pm |
| Phone | (920) 860-7478 |
| Email | wipost165@gmail.com |
| Facebook group | https://www.facebook.com/groups/amlegionpost165wi |

The post's charter year and Robert E. Burns biography were unresolved. The
national organization's 1919 founding year does not establish this post's charter
year. Historical event notes described the brat fry and car show as confirmed at
the time; other proposed annual milestones were provisional. Current dates,
frequency, volunteer time commitments, dues, eligibility, counts, contact consent,
photo descriptions/permissions, and local history need confirmation before use.
The former custom seal was a placeholder, not the official Legion emblem.
