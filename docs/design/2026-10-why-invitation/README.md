# Pull up a chair — October 8, 2026

The owner rejected the first Why the Legion page: the columns looked like a
newspaper, and the copy exposed the internal audience brief while appealing only
to reason. This revision treats the page as one invitation, not a case for joining.

## Direction

- A close, painterly shared table and an open chair make “Pull up a chair” tangible.
- The hero connects shared service to the possibility of easy conversation.
- The owner then requested more substance beneath the opening: three connected
  panels for camaraderie, community and fellow veterans replace the centered
  “A few more people” passage. Events and First visit provide the next step.
- The opening has no jump link or premature action. Visitors can simply scroll.
- The three resident categories stay in internal guidance. No diagnostic pitch,
  testimonials, invented members, guaranteed friendships or new recurring events.
- Home's short introduction loses the resident-category wording as well.

Palette: National Emblem Blue #00467f, Emblem Red #b5121b, deep blue #002e55,
light blue #e7eff5, white #ffffff. Existing National Noto condensed display and
Noto Sans body faces; the existing Legion mark is unchanged. The illustration's
wood and daylight supply warmth. The three-panel strip uses light blue, white and deep blue. At the owner’s
request, fine blue borders and 16px gaps now distinguish the cards; the left
card uses a stronger blue tint than the invitation below. No new JavaScript.

Desktop composes large live type against the scene; phones place the invitation
above a cropped painting. The image is a symbolic invitation, not the actual
meeting venue, a missing-man table, or evidence of a recurring coffee gathering.

## Asset

Built-in imagegen tool, no API key. New image, no image reference. Original output:
`/home/andre/.codex/generated_images/01a1166f-bde3-7702-9b3b-f0813d4488fd/exec-c8e21d3a-9df1-4b7c-9e09-d1684cb97088.png`.

Repository asset: [pull-up-a-chair.webp](../../../app/assets/images/pull-up-a-chair.webp),
1536 × 1024, about 153 KiB. Converted from the generated PNG at WebP quality 86;
the illustration was not composited with member photographs or generated logos.

Exact generation prompt:

> Create one accomplished, emotionally inviting gouache / oil editorial illustration for an American Legion Post 165 website invitation page. This is a PEOPLE-FREE symbolic still life, not a picture of a real place. Wide landscape 3:2 composition. A comfortably ordinary rounded wooden shared table occupies the RIGHT TWO THIRDS of the image, seen from a slightly elevated three-quarter angle. Three everyday ceramic coffee mugs (two pale, one restrained deep red) are placed informally around the table; simple mid-century blue chairs are angled toward each other; the near-right chair is pulled out invitingly, large enough to be the memorable focus. The table edge and near chair are cropped by the lower/right edge, so the scene feels close and approachable. Cheerful quiet daylight rakes across wood and simple seat backs, tactile confident brushwork, human warmth without any people. The leftmost third is open deep Legion-blue #00467f negative space, softly painted with no objects, flowing into blue shadows behind the table. Blue and off-white dominate; restrained warm wood, tiny deep-red #b5121b accents. No room, no windows, no architectural setting: objects emerge from a blue painterly field. This is a vivid welcoming magazine-quality illustration, not a flat vector, clipart, photograph, corporate stock art, sepia vintage scene, or solemn memorial. Crucially not a single-place missing-man table: show several chairs and several ordinary mugs, no formal table setting or lone ceremonial objects. No cap, no dog tags, no uniform, no flag, no flowers, no candle, no alcohol, no readable text, no emblems or logos, no people or hands. Leave the entire left third visually simple so live white website text can overlap it. The scene should make the viewer feel like drawing up a chair for easy conversation, with rich blue contrast, clear bold shapes and warm light.

The community panel draws on Americanism and Children & Youth through honoring
service, Badger Boys State and the local scholarship. The veteran panel draws
on Veterans Affairs & Rehabilitation through Buddy Checks and Service Officer
referrals. Camaraderie expresses the Legion's fraternal purpose. These are three
visitor motivations inspired by the pillars, not a renamed or complete list of
all four. Specific local claims use the existing public fact record. Veteran
assistance is explicitly available to nonmembers; participation remains optional.

## Initial revision verification

Local Chromium checks passed Why in both editions and V1 Home at 1440, 900, 700,
390 and 320px. No horizontal overflow, missing images, or extra H1s. Main navigation,
keyboard focus/activation, the in-page invitation jump and onward Events focus,
and 200% root-text reflow passed. No screenshots were taken. These are functional
and computed-layout checks; the new composition still needs the owner's visual
judgment. The V2 background under copy was additionally darkened for contrast.

`bin/ci` passed after the contrast refinement: 78 Rails tests / 934 assertions,
nine Sites adapter tests, style/security, autoload and production assets.

## Three-panel refinement verification

`bin/ci` passed: 78 Rails tests / 934 assertions and nine Sites adapter tests,
plus style/security, autoload and production assets. Local Chromium checked the
page in both editions at 1440, 900, 700, 390 and 320px. Three panels render side
by side on wide V1 and stack on narrow V1/V2; the opening contains no links.
No overflow or missing images; keyboard navigation and 200% root-text reflow
passed. No screenshots were taken.

## National-purpose detail strip

The owner liked the three-card refinement and requested a further strip with
more detail, including local work and the four pillars. Added “Part of something
bigger” between the three reasons and the final visit invitation. A blue
introduction links to Post 165's About page; the adjoining white reading area
presents all four official pillars in a two-column list and links to National's
mission. Each summary is short. National program descriptions remain distinct
from the local activities on About. Sources are recorded in the public facts.

The strip uses the existing National palette and fonts. It becomes a single
column at intermediate widths and within V2's table; the pillar list becomes
one column on phones. All copy is visible with normal reading/keyboard order.
No new image, dependency or JavaScript is added; the liked cards and hero stay.

Verification: `bin/ci` passed 78 Rails tests / 934 assertions and nine adapter
tests, plus style/security, autoload and production assets. Both editions passed
browser checks at five widths: all four headings and the section order, local
About navigation, National-link keyboard focus, responsive columns, no overflow,
image loading and 200% root-text reflow. No screenshots.

## Emblem refinement

The owner approved the strip and requested the Legion emblem inside the blue
introduction, to the right of “Part of something bigger.” An unchanged official
RGB PNG now sits beside that heading; the paragraph and local link retain the
full width beneath. The emblem stacks under the heading only when the container
is too narrow for both, including enlarged text. The adjoining pillars stay put.
See [artwork provenance and brand-use caveat](../../brand/README.md#october-8--emblem-in-the-national-purpose-panel).

Verification: `bin/ci` passed 78 Rails tests / 934 assertions and nine adapter
tests. Both editions passed 14 total page/width checks (1440, 1100, 1001, 900,
700, 390 and 320px), with the emblem contained in the blue panel, intact aspect
ratio, no clipped heading or missing images, and correct narrow stacking.
Keyboard navigation and 200% root-text reflow passed. No screenshots.
