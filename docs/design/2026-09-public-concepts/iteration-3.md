# Common ground — iteration 3

The owner likes the messaging but finds the design too close to stacked CMS panels.
This is a composition change, not a new message or a platform change.

## Plan before implementation

An open white canvas, headline as expressive typography, and a large human scene
with organic edges. Remove the solid hero rectangle and alternating section bands.
Let picture, headline and invitation share a composition. Events are readable
invitations with prominent dates, not another grid of feature cards. Use deliberate
asymmetry on desktop and a compact interleaving of words and image on phones.

Palette: official Emblem Blue #00467F, Poppy Red #B5121B, white #FFFFFF,
Light Blue #F5F8FA, Light Gray #F5F5F5. Backgrounds stay predominantly white.
Noto Sans ExtraCondensed Black for the hero statement and large dates; Noto Sans
for restrained headings, body and controls. Preserve the complete official brandmark
with its clear space. Do not include official marks in generated illustration.

Signature: an editorial illustration of fictional veterans sharing coffee, loosely
painted in blue and red, with irregular edges blending into the page. This is a
composition study, not a photograph or a claim about Post members or facilities.
The long-term photographic direction is real Post people doing things together,
with approved image use and accurate captions. Source images are still needed.

Desktop sketch:

    official mark                         concise navigation
    Post identity / Two Rivers
    Service                  human illustration, crossing the grid
    doesn't end with         picture edges dissolve into white
    a uniform.               shared experience / invitation
    Upcoming events    large dates and ordinary direct links
    Good company.              fellowship / tradition / service
    Common ground.             concise, no feature cards
    First visit                practical expandable questions
    personal invitation                         contact

Mobile retains the reading order and navigation. All important information remains
available without animation or hover. No scroll hijacking, carousel or concealed
navigation. A fold is not a hard target at the expense of legibility.

Critique: merely removing backgrounds would leave the same stacked brochure.
Change the hero proportions and illustration emphasis, reduce repeated paragraphs,
and remove the three feature-card structure. Avoid invented testimonials, history,
program claims or faux documentary pictures as shortcuts to apparent authenticity.

## Result and verification

Implemented in `common-ground.html` and `common-ground.css`. Previous proposals
remain available. The generated illustration is stored in
`assets/common-ground-illustration.png`; its exact prompt and built-in tool
provenance are in the adjacent Markdown file. One image generation was performed.
It was inspected for subject, obvious anatomy problems, and absence of marks/text.

Browser checks passed at 1440, 768, 390 and 320px: no horizontal overflow, all images
loaded, menu open/close, both sample event dialogs, Escape/focus return, contact
preview, keyboard activation and visible focus on first-visit questions, and both
quiet and unavailable calendar states. The mobile headline was subsequently resized
to prevent an orphaned “A”; 390/320px overflow and typography checks were repeated.
Final desktop and mobile opening screenshots and full pages are in `previews/`.

Local asset references, JavaScript syntax and diff whitespace passed. The official
brandmark still matches the reference file byte-for-byte. Blue, red and white text
combinations use the previously checked brand pairs (minimum 6.85:1); no text is
placed over the illustration. The image is separate from the mark and its clear
space. Hover movement is minor, optional, and disabled under reduced motion.

This remains a static design exploration with fictional events and illustration.
It is not a claim of Post activity, a production homepage, or a complete
accessibility audit. Real photo selection and permissions remain unresolved.
No Rails behavior, companion app, deployment or Git staging was changed.
