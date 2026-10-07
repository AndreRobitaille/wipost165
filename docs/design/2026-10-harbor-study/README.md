# Two Rivers harbor illustration — October 7, 2026

Status: the owner accepted this direction and authorized implementation using
National’s brand guide. See [the running V1 and checks](implementation/README.md).
A subsequent [national imagery review](national-references/README.md) addresses
the owner’s concern about making veteran service visually recognizable; the
people-free image remains in use while that distinction is discussed.

The owner was not a fan of the pennant/banner image and requested AI imagery, then clarified
that real Two Rivers photos should inform the image. This supersedes a generic
shoreline illustration that was already generating when that clarification arrived.

The reference search considered the harbor, Neshotah Beach, and Rogers Street
Fishing Village. Two photographs were downloaded and visually inspected as
potential generation inputs. Only the harbor aerial was selected for generation;
combining distinct viewpoints would risk inventing a waterfront scene.

## Selected reference

[Two Rivers Harbor](https://commons.wikimedia.org/wiki/File:Two_Rivers_Harbor.jpg)
by Chris Rand, January 31, 2015, [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
The original is saved as `references/two-rivers-harbor.jpg`. It is an older reference
photograph, not evidence of the current condition of every waterfront building.

The generated adaptation is offered under CC BY-SA 4.0. The photo's viewpoint and
harbor arrangement guide the composition; the requested changes are a painted
editorial style, a Legion-inspired palette, warm light, and a deliberate change
from winter to late summer. It must be labelled an illustration and credited to
the reference photographer. It does not depict the Post's meeting venue.

## Other inspected reference

[Rogers Street Historic Fishing Village](https://commons.wikimedia.org/wiki/File:Rogers_Street_Historic_Fishing_Village_and_Great_Lakes_Coast_Guard_Museum;_Two_Rivers,_WI;_June_3,_2012.JPG)
by Stephen Matthew Milligan, June 3, 2012,
[CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/).
Saved unmodified as `references/rogers-street-fishing-village.jpg`. It was inspected
as an alternative subject, not used as a generation input.

See `references/sources.json` for original image URLs and provenance. No third-party
reference photograph is presented as our own image. The derivative's attribution
and licence apply to that image; the source fonts and official Legion wordmark
retain their separate rights.

## Generated artwork and page study

Created with the built-in image-generation tool, using the selected harbor photo
as the only image input. The exact [generation prompt](image-prompt.txt) records
the style, geographic constraints, deliberate season change, and exclusions.
The [original generated PNG](assets/two-rivers-harbor-illustration.png) is preserved;
the [WebP copy](assets/two-rivers-harbor-illustration.webp) is a format-compressed
version for the review, with no subsequent creative image edits.

The [updated study](study-fragment.html) replaces the Home pennant with the
illustration and a visible reference/licence credit. Desktop uses the image beside
the welcome; tablet/phone layouts show it above the welcome, preserving its wide
composition on phones. Decorative pennants in interior headings become plain Post
numbers, and the meeting information loses its pointed banner shape. Existing
messaging, four page destinations, and event dialog behavior carry forward.

The image is an AI interpretation, not a contemporary documentary photograph or
an exact architectural rendering. Some small details are simplified. It is labelled
as an illustration, based on the cited 2015 reference; the warm season and palette
are artistic choices. The fixed calendar snapshot remains labelled October 7,
2026. The initial study changed no Rails code. The later V1 implementation uses
live publisher reads; V2 assets, publisher data, and production remain unchanged.

## Verification

Checked the updated Home at 320, 390, 800, 1024, and 1440px. The embedded artwork
loads at every size with no horizontal page overflow. Inspected wide, intermediate,
and narrow captures, including the full landscape image at phone widths. The
reference credit remains readable and linked. Interior navigation and the Events
modal were exercised in the preview; browser runs reported no script errors.
The generated image was inspected against its source before inclusion. The study
passes JavaScript syntax/fragment checks and remains below the 1 MB inline limit.
See `browser-checks.json` and `previews/` for evidence. No Rails tests were rerun:
this pass changes only the isolated design study, its images, and project notes.
