# American Legion brand references

Reviewed September 7, 2026. This folder preserves source material, not a new
visual specification. Official Legion guidance should inform the next design pass.

## Companion asset

`al-emblem.png` is an unchanged copy of
`~/Development/LegionPostTools/app/assets/images/al-emblem.png`.
The copy was verified byte-for-byte. Its original download provenance was not
established in this review; compare it with current official artwork before use.
The emblem remains American Legion artwork, not original project artwork.

The companion checkout contains this emblem and old brainstorming PNG copies.
Filename searches including hidden/ignored files and relevant documentation/content
searches did not locate a dedicated Legion brand guide or modern brandmark package.
The member app's visual system is application design, not national brand guidance.

## Official sources

- [Branding and guidelines](https://www.legion.org/about/media-toolkits/brand-marks-guidelines):
  current starting point for full guidelines, artwork, and sub-branding guidance.
- [Updated guidelines announcement, September 2025](https://www.legion.org/information-center/news/dispatch/2025/september/download-the-updated-legion-brandmark-guidelines):
  describes guidance on mark selection, fonts, digital/print colors, and correct use.
- [Artwork downloads](https://www.legion.org/about/organization/the-emblem/emblem-and-brand-mark-download/emblem-and-brand-mark-download):
  official source for downloadable marks; keep artwork unaltered.

## Verified for iteration 2

National's linked guide is [the August 11, 2026 edition](https://issuu.com/theath1296/docs/american_legion_emblem_branding_guidelines).
All 27 publicly served page images were read with OCR; pages 11, 24 and 25
were also visually checked. Copies of those three reference pages are in `guide/`.
Their original URLs follow this pattern:
`https://image.isu.pub/260811162330-0e61fbb3d4fb2db3beffec533851d57d/jpg/page_11.jpg`.

Relevant guidance: use the brandmark for public outreach/websites, the emblem for
internal or ceremonial contexts. Do not combine both in one layout. Keep official
artwork intact, proportionate, and clear of surrounding elements by the width of
its L. Do not recreate marks with AI. The primary mark belongs on a light background.
Emblem Blue is `#00467F`, Poppy Red `#B5121B`, Light Blue `#F5F8FA`, and Light Gray
`#F5F5F5`. Noto Sans is a suggested web font. Rexton is reserved for the official
marks; Futura PT or Avenir Next is specified for sub-branding/display.

The revised prototype uses Noto Sans as its web type, with the condensed Noto face
for the main headline. It does not construct a custom Post sub-brand lockup.

## Official artwork provenance

Downloaded September 7, 2026 from National's
[brandmark package](https://www.legion.org/getmedia/9d6b6dca-70c8-47c1-ad1f-52d46977b9e7/American-Legion-Brand-Mark.zip).
The PNGs below are unchanged digital-use files from that ZIP. The prototype's
`assets/TAL-brand-primary-RGB.png` is byte-identical to the reference copy.
Copyright remains with The American Legion National Headquarters.

- `TAL-brand-primary-RGB.png` — SHA-256 `5949c30a833fff1a5c846a0a9952d2a7f530f2d60e4c2f72ecd11515c85447ff`
- `TAL-brand-secondary-1C-white.png` — SHA-256 `4b900bb15c46f4ce659bfb3b1c768b5d0814d98837ac25b15e879740bc7b10ee`

## October 7 harbor implementation check

Rechecked National's current branding entry point and inspected guide pages 11,
24 and 25 visually. Fresh reads of all three official page-image URLs match the
saved references byte-for-byte. `fc-scan` identifies the bundled web fonts as
Noto Sans Regular, Noto Sans Bold, and Noto Sans ExtraCondensed Black. V1 uses
Regular/Bold for the website and the condensed face only for dates and the
plain Post number; it does not recreate a logo in a typeface.

`launch.css` uses the exact primary colors Emblem Blue `#00467F` and Poppy Red
`#B5121B`, neutral Light Blue `#F5F8FA` and Light Gray `#F5F5F5`, plus black/white.
Dark surfaces and separator rules are tonal mixes of Emblem Blue for the web UI,
not additional official brand colors. The study's gold accent was removed; family
colors and the vendor-only emblem gold/bronze are not borrowed for the Post UI.

`app/assets/images/legion-white.png` remains byte-identical to National's white
secondary brandmark above. It is displayed proportionately on a dark ground with
at least an L-width of clear space. The Post identification is ordinary site text,
separate from the original image; no custom graphical sub-brand was constructed.

National's [AI guidance](https://www.legion.org/information-center/news/dispatch/2026/july/follow-these-guidelines-on-ai-use-of-legion-emblem-and-brandmark)
prohibits generation, recreation, upscaling, or styling of the official symbols.
The harbor illustration contains no official mark. The unchanged official PNG is
placed separately in HTML and was never supplied to image generation.

## October 8 — emblem in the national-purpose panel

At the owner's specific request, the Why page places the emblem to the right of
its heading inside the blue “Part of something bigger” introduction. The
masthead's existing brandmark is unchanged. This is a departure from National's
instruction to choose one mark per layout, recorded here and in PR #10 for review;
it is not a claim that National approved this combination.

Rechecked the [current guide](https://issuu.com/theath1296/docs/american_legion_emblem_branding_guidelines),
now dated September 14, 2026. Pages 7–8 favor the brandmark for public websites;
page 18 discourages combining the two marks. The earlier August record above is
historical. Neither mark has been generated, redrawn, recolored, or cropped.

Downloaded the current emblem package through National's
[artwork downloads page](https://www.legion.org/about/organization/the-emblem/emblem-and-brand-mark-download/emblem-and-brand-mark-download),
which links to its [public asset library](https://legion-dam.eos.woodwing.cloud/?w=p4uGIiZwUz).
`app/assets/images/legion-emblem.png` is the unchanged `TAL-emblem-full-detail-RGB.png`
from that package: 911 × 948 RGBA, SHA-256
`4d8dbb5e2b10fa3d4568d78eca85da3226f4991e7715cf1d3e274d87ca0faa60`.
It includes the supplied white perimeter and is displayed proportionately with
clear space. The older companion copy at `docs/brand/al-emblem.png` is not used.
