# Footer pages in the current V1 design — October 7

The owner found About too empty, the three footer pages inconsistent with the
current site design, and the dues callout too prominent. Keep About with its
sourced local work and memorial history; bring all three pages into the current
V1 composition; remove the dues amount from public copy and metadata.

## Direction and implementation

Reuse the current V1 design: Emblem Blue `#00467f`, Poppy Red `#b5121b`, paper
`#f5f8fa`, white, ink `#222`, and the existing dark-blue shade. Noto Sans carries
headings and body copy; Noto Condensed carries the Post number and the 1928 date.
No new palette, imagery, card grid or interaction pattern is introduced.

- **About:** full-width blue heading, open editorial rows with local examples,
  and a light memorial note anchored by 1928. Keep Buddy Checks, the Service
  Officer, Honor Guard, youth programs, gatherings and the sourced memorial elms.
- **Membership:** a visit invitation beside visible questions, with participation
  first. No price callout or dues amount in the page or description. The source
  record retains the confirmed amount and the Commander’s October 7 instruction
  to omit it from public pages.
- **Veteran help:** a shorter page heading, a wide crisis contact panel first,
  then distinct Service Officer and county columns that stack on a phone.

The V1 layout now lets these routes use the same full width as Events and First
visit. One shared template per page still supports V2's preserved table layout.
The shared helper-driven contact links independently omit hidden channels.

## Sources checked and decisions

The source record is owner-supplied evidence, including some draft meeting
summaries; this pass does not claim direct verification of private minutes. Public
references checked October 7: [National FAQ](https://www.legion.org/faq),
[Legion mission](https://www.legion.org/about),
[renewal destination](https://www.legion.org/renew),
[Historical Society memorial-tree account](https://www.manitowoccountyhistory.org/stories/american-legion-memorial-trees),
[Veterans Crisis Line](https://www.veteranscrisisline.net/) and its chat entry,
and [county veterans services](https://manitowoccountywi.gov/departments/veteran-s-services/).

- **Meeting schedule and calendar:** the Commander confirmed on October 7 that
  the public pages should say the first Tuesday of every month at 6:30 p.m. at
  the Manitowoc Rifle & Pistol Club. Membership now matches Home and First visit;
  the earlier skipped-summer follow-up is superseded. The public publishing
  contract excludes regular member meetings, so the events calendar remains a
  route to public occasions. No calendar integration or API policy change.
- **Dues:** retain $45 only in the editorial source record, with the Commander's
  October 7 direction not to print the amount on public pages or in descriptions.
- **Renewal timing:** the fact sheet says renewals open in fall; National's current
  FAQ says it accepts next-year dues starting July 1. Neither opening date nor
  delinquency milestones are necessary for this page, so they are omitted. The
  source record retains its fall wording and October 20 milestone from the
  Officer Guide, with this discrepancy recorded here.
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

The browser measurements and screenshots below document the preceding design
revision. They predate the final copy corrections; no new screenshots were
requested for that pass.

- `bin/ci`: 78 tests / 902 assertions; nine Sites adapter tests; style, security,
  autoload and production assets pass.
- Both editions, all three pages at 1440/814/390/320px: no horizontal overflow,
  one H1, readable source order, six visible membership answers, crisis first.
  V1 has the current full-width heading and no fallback article wrapper.
- Browser checks confirm no dues amount in the rendered Membership HTML,
  including metadata. Keyboard reaches the crisis call action with visible focus;
  200% root text size fits desktop width in both editions.
- Hidden-contact phone checks retain the visit action, crisis contacts and county
  help. Existing application tests cover each channel independently in both editions.
- Desktop and phone screenshots were visually reviewed. Source claims are the
  already checked facts from the [source review above](#sources-checked-and-decisions);
  no new local facts or services are asserted.
- Simplify pass retained shared templates and scoped edition styles; no new
  controller, JavaScript, dependencies, API access or publishing behavior.

[Browser measurements](browser-checks.json) · [Hidden-contact checks](hidden-contact-checks.json)

| Page | V1 desktop / phone | V2 desktop / phone |
| --- | --- | --- |
| About | [1440px](v1-about-1440.png) / [390px](v1-about-390.png) | [1440px](v2-about-1440.png) / [390px](v2-about-390.png) |
| Membership | [1440px](v1-membership-1440.png) / [390px](v1-membership-390.png) | [1440px](v2-membership-1440.png) / [390px](v2-membership-390.png) |
| Veteran help | [1440px](v1-veteran-help-1440.png) / [390px](v1-veteran-help-390.png) | [1440px](v2-veteran-help-1440.png) / [390px](v2-veteran-help-390.png) |

## Final review corrections

About now labels Honor Guard work as Americanism and separates Community
activities from Children & Youth. Membership states the confirmed monthly
schedule, keeps the First visit address link, and offers transfer contact only
when a public channel is configured. Veteran help describes unavailable Post
contact details without assuming an outage is temporary. The About browser
title matches “Service, close to home”.

The owner authorized pushing these corrections to PR #10 and refreshing the
existing public V1 Sites preview. Merge remains for the owner; the preserved V2
Site and Hetzner production service are outside this update. Deployment evidence
is recorded in the [Sites handoff](../../2026-10-harbor-study/sites-preview/README.md).
