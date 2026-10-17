# Sharing and site icons — October 17, 2026

Deployed October 17 after owner approval at `76f4f5c` on both public hostnames.
The [release record](../../deployment/2026-10-17-sharing-icons.md) documents live
metadata, exact asset-byte/type checks, unchanged protected services, and the
single SSH session. The design-stage history below predates that release.

## Coverage

- Open Graph title, description, canonical URL, website type, site name, locale,
  and image URL/type/dimensions/alt text. X/Twitter large-image cards use the same
  page copy and image. These are server-rendered tags, with no JavaScript or
  publisher authentication needed to retrieve the artwork.
- One 1200×630 JPEG (under 90 KB) with lasting Post identity. Plain Post text uses
  the site's bundled Noto fonts, Emblem Blue `#00467F`, white,
  and a Poppy Red `#B5121B` edge. The horizontal composition uses the full image
  width. No event date, personal image, or private data
  is baked into an independently cached social image.
- Square PNG favicon at `/favicon-96x96.png`, plus `/favicon.ico` containing
  16/32/48 sizes. An opaque white ground makes the emblem visible in light and
  dark browser chrome. Google can crawl the stable root URLs through the existing
  robots rules; its previous 128×35 linked favicon was not square.
- Apple touch icon at 180×180, and a web manifest with 192×192 and 512×512 PNGs.
  The manifest keeps ordinary browser navigation (`display: browser`). It makes
  no offline or installed-app promise. Rack is explicitly taught the
  `application/manifest+json` MIME type for `.webmanifest`.
- Homepage-only `WebSite` JSON-LD supplies a preferred Google site name and
  alternate names. Existing titles, descriptions, canonicals, robots, sitemap,
  language, viewport, and theme color remain the discovery foundation.

Sharing metadata and site-name JSON-LD use the existing indexability gate. They
are absent on development/preview/coming-soon, error and unavailable responses,
expired content, and modal fragments. A valid empty calendar is still eligible.
Titles/descriptions follow each destination, including cancellation/error rules;
tracking and recognition parameters never enter canonical or sharing URLs.
No social account handle or Facebook app ID has been invented.

## Artwork and regeneration

The official white secondary brandmark in the card is the unchanged
`app/assets/images/legion-white.png`. Icons proportionately fit the complete
`app/assets/images/legion-emblem.png` on a white square. Neither official mark is
cropped, redrawn, recolored, or generated. Each artifact uses one official mark.
See [brand sources](../../brand/README.md) for provenance and National guidance.
The current card puts the complete Legion logo on the left and Post 165 / Two
Rivers on the right, separated by a thin vertical line.

### Horizontal card — current owner direction

The owner rejected the separate headline/footer composition and explicitly asked
for a tight horizontal treatment inspired by National's left-logo/right-label
examples, with small margins and spacing taking precedence over the guide's
prescribed measurements. Do not restore the rejected footer design to enforce
the earlier interpretation. This owner-directed card is not presented as a
National-approved sub-brand treatment.

The 1200×630 image uses a 540px-wide complete official white brandmark at left,
a 2px vertical rule with 40px gaps, and 132px Post 165 / 94px Two Rivers text at
right. The owner requested more room in the center and slightly smaller right-side
text after reviewing the first horizontal version. Outer horizontal padding is
32px. The logo remains proportionate, unchanged
artwork on Emblem Blue; the Post text uses the bundled Noto faces.

Fresh browser rendering confirmed fonts and artwork loaded and both text lines
fit inside the canvas. Visual review covered the full export and actual
[320px](card-320.jpg) / [240px](card-240.jpg) thumbnails. The wide composition does
not preserve the complete identity in a centered square crop; the old square
review artifact was removed. The 1200×630 file remains the metadata target, and
its alt text describes the side-by-side arrangement. Focused metadata checks
passed 28 tests / 1,339 assertions. SHA-256 checks confirm all five icon files
are unchanged. No publication or deployment occurred during that design stage;
the later authorized production release is recorded above.

### Prior brand review and correction rationale

The owner chose to retain the emblem favicon and make Post 165 / Two Rivers the
OG card's main identity, then paused implementation to check National's logo
guidance. No artwork changed during that audit. The separate-headline correction
was implemented and then rejected; the horizontal direction above supersedes it.

Rechecked National's [current branding page](https://www.legion.org/about/media-toolkits/brand-marks-guidelines)
and its linked [September 14, 2026 main guide](https://isu.pub/lKKNTyo), plus the
separate [Sub-branding Guidelines download](https://legion-dam.eos.woodwing.cloud/app/#/s/rJtFagkoVQ).
The latter PDF is dated September 16, 2022, has 21 pages, and remains the file
linked from National's current page. Pages 3–5 were rendered and visually read.
Its older color palette must not be mistaken for the September 2026 palette.

- **Artwork/background:** `legion-white.png` is byte-identical to the official
  white secondary file (SHA-256 `4b900bb15c46f4ce659bfb3b1c768b5d0814d98837ac25b15e879740bc7b10ee`).
  The main guide's page 12 permits this one-color version when a white/light-gray
  background is unavailable. It has not been recolored or redrawn.
- **Confirmed clear-space defect:** pages 11–12 require an L-width around the
  mark. The L spans approximately 196px of the 1500px original; at 600px wide,
  this is about 79px. The previous card's top margin was only 60px. Its centered
  square crop leaves even less side clearance. Prior crop checks established
  that artwork/text survived, not that the required clear space survived.
- **Post identification must not become an invented lockup:** the sub-brand
  guide specifies Futura PT Light (Avenir Next fallback), divider lines, and
  measured proportions. The vertical treatment on page 5 limits label width to
  the brandmark width and letter height to 2/3 of an L-width. The draft's bold
  condensed Post text stacked under the mark was not assembled to those rules.
  Calling it ordinary text was insufficient grounds to present it as compliant.

The initial correction separated the local headline and official mark with the
measured clear space. The owner's subsequent horizontal treatment deliberately
uses tighter spacing. The favicon remains retained as directed; this review
makes no new claim that its fine detail is readable.

### Earlier thumbnail revision and online references

The owner rejected the initial card because its supporting text was too small.
The formal name and domain were 25px and 23px on the export, becoming roughly
6–7px at a 320px display width; the 34px location became about 9px. Reviewing the
1200px export and crop alone missed this problem.

Fresh visual inspection covered [OGimage.gallery](https://www.ogimage.gallery/)
and these real homepage `og:image` assets, discovered from each site's current
HTML and opened in a browser:

- [Linear](https://linear.app/api/og/main?title=Linear&v=4): one centered, high
  contrast brand identity without supporting text.
- [Stripe](https://b.stripecdn.com/mkt-ssr-statics/assets/_next/static/media/stripe.37119086.jpg):
  one large wordmark on a distinctive colorful ground, without fine print.
- [charity: water](https://cdn.builder.io/api/v1/image/assets%2F2fe4147bb8c843bb8ebba475c8973899%2Fc13d7304d64d4615bb6d7e74922ad9cb):
  a single photograph with a clear human/action subject and no text overlay.

These are composition references, not evidence of conversion or a rule that all
cards must look alike. The earlier approach used the Post's existing identity
and fewer elements: the complete Legion brandmark, Post 165, and Two Rivers, WI.
The formal name and URL remain in page metadata and are omitted from the image.
The mark grew from 280 to 600px wide; location type grew from 34 to 80px.
At 320px wide, Post/location nominal text sizes are about 44/21px; at 240px,
33/16px. The complete identity also fits a centered square crop.

That earlier revision was rendered at 1200×630 with bundled fonts loaded and
reviewed at 320px/240px widths and as a square crop. The linked preview files now
show the current correction above. These checks do not establish validation in
a particular social application. Metadata tests passed again:
28 tests / 1,339 assertions. No runtime logic or favicon artwork changed in this
revision, and the earlier CI evidence below is from the initial implementation.

The [favicon size sheet](favicon-sizes.png) shows the actual ICO frames at
16/32/48px and the 96px PNG on light and dark backgrounds. At 16px the detailed
emblem reads as a small gold/blue circle; its lettering cannot be read. The opaque
white square is also visible on dark chrome. Google size/format eligibility and
small-icon legibility are separate properties; the emblem has not been simplified
or redrawn to pretend otherwise.

[Sharing image](../../../public/sharing/post-165-v1.jpg) ·
[editable HTML source](share-card.html) ·
[96px favicon](../../../public/favicon-96x96.png)

Regenerate icons with `ruby script/build_site_icons.rb` (ImageMagick 7 required
only for this development command). To regenerate the card, open `share-card.html`
in a browser with local-file access and bundled fonts loaded, set the viewport to
exactly 1200×630 at 1×, capture the viewport to a PNG, then run:

```sh
magick /tmp/post165-share-card.png -strip -sampling-factor 4:4:4 -quality 92 public/sharing/post-165-v1.jpg
```

Render and inspect the output at thumbnail sizes before replacing it. Give a
materially changed, previously published sharing card a new filename and update `SHARING_IMAGE_URL`, because platforms
cache images independently. Keep favicon URLs stable. Root static files inherit
the existing production public-file cache policy; allow for browser caches when
changing their contents. The Sites export also copies these public files and
routes requests to its static asset binding; it retains its noindex preview gate.

## Sources checked October 17

- [Google favicon guidelines](https://developers.google.com/search/docs/appearance/favicon-in-search):
  square, at least 8×8, with a recommendation to exceed 48×48; supported raster
  formats include PNG/ICO. Stable URL and crawlable homepage/image required.
  Meeting these guidelines does not guarantee Google will display the icon.
- [Open Graph protocol](https://ogp.me/): core properties, locale/site name, and
  structured image type, dimensions, and alternative text.
- [Google site names](https://developers.google.com/search/docs/appearance/site-names):
  `WebSite` JSON-LD on the homepage with name, URL, and alternate name.
- [Apple web application configuration](https://developer.apple.com/library/archive/documentation/AppleApplications/Reference/SafariWebContent/ConfiguringWebApplications/ConfiguringWebApplications.html):
  explicit `apple-touch-icon` link and PNG artwork.

## Verification and release follow-up

`PARALLEL_WORKERS=1 bin/ci` passed: 93 application tests / 2,068 assertions,
10 adapter tests, Ruby style, gem/JavaScript audits, Brakeman (zero warnings),
autoloading, and production asset compilation. The serial run avoids Bundler's
temporary-home cleanup race under the filesystem sandbox. As documented in
development, compiled production assets must be clobbered before a subsequent
test run that uses local V2 preview artwork. An initial manifest assertion used
Rails' generic parsed body; it was corrected to parse the custom JSON MIME type
explicitly before the final green CI run.

Application tests cover both editions, escaped authored copy, query/host
independence, cancelled events, empty/outage/withdrawal/expiry states, homepage
schema, coming-soon icons, and public manifest GET/HEAD with PNG dimension checks.
The adapter check compares exported bytes and routes all seven public assets
without accessing the publisher. Local HTTP checks read actual files and verify
sizes, MIME types, ICO frames, and JSON. Browser review covers the rendered card,
square crop, and unchanged Visit page at desktop/phone widths; all images load
and no horizontal overflow is introduced. Data is synthetic throughout.

External platform behavior is not established by local checks. After an authorized
release, fetch the public HTML/image/icon URLs without credentials, inspect a link
with [Facebook Sharing Debugger](https://developers.facebook.com/tools/debug/) and
[LinkedIn Post Inspector](https://www.linkedin.com/post-inspector/), and try the
actual Messages/WhatsApp destinations in use. These services choose their own
layout and cache duration. Request a homepage recrawl in Search Console and allow
time for Google to refresh; its choice of icon and site name is not guaranteed.
Robots instructions and omitted tags cannot erase previews already cached by a
third party. This implementation does not access those accounts or publish links.
