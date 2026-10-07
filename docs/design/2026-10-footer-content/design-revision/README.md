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
  first. No price callout or dues amount in the page or description. The unchanged
  source record retains the confirmed amount for editorial reference.
- **Veteran help:** a shorter page heading, a wide crisis contact panel first,
  then distinct Service Officer and county columns that stack on a phone.

The V1 layout now lets these routes use the same full width as Events and First
visit. One shared template per page still supports V2's preserved table layout.
The shared helper-driven contact links independently omit hidden channels.

## Verification

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
  already checked facts from the [original source review](../README.md#sources-checked-and-decisions);
  no new local facts or services are asserted.
- Simplify pass retained shared templates and scoped edition styles; no new
  controller, JavaScript, dependencies, API access or publishing behavior.

[Browser measurements](browser-checks.json) · [Hidden-contact checks](hidden-contact-checks.json)

| Page | V1 desktop / phone | V2 desktop / phone |
| --- | --- | --- |
| About | [1440px](v1-about-1440.png) / [390px](v1-about-390.png) | [1440px](v2-about-1440.png) / [390px](v2-about-390.png) |
| Membership | [1440px](v1-membership-1440.png) / [390px](v1-membership-390.png) | [1440px](v2-membership-1440.png) / [390px](v2-membership-390.png) |
| Veteran help | [1440px](v1-veteran-help-1440.png) / [390px](v1-veteran-help-390.png) | [1440px](v2-veteran-help-1440.png) / [390px](v2-veteran-help-390.png) |

This updates PR #10. No merge, Sites publish or production deployment. The public
Sites preview continues to serve its previously published version.
