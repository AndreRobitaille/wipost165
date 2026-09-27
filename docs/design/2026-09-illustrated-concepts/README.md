# Two illustrated Post 165 mockups

**Review outcome:** The owner rejected these visual directions as conventional
website layouts with large AI illustrations. The car and grill had no established
connection to the Post. Preserve these as experiments, not approved designs. See
[the subsequent experience concepts](../2026-09-experience-concepts.md).

September 7, 2026. Requested after discussion of limited photography, a difficult
meeting venue to photograph, and an old scrapbook that would take time to research.
Neither direction requires documentary photographs or an archival collection.
These are alternatives for review, not a selected design or a production feature
specification. Rails and the future companion API are unchanged.

## Review

- [Comparison](index.html)
- [A: Saturday at the Post](saturday.html)
- [B: Still serving, together](together.html)
- Each prototype accepts `?state=quiet` and `?state=unavailable`.
- Phone, desktop, first-visit and event-invitation captures are under `previews/`.

The local files are self-contained. A static server is sufficient for interactive
review. The owner is mobile, so screenshots are the primary review deliverable;
localhost access is not assumed.

## Design choices

Both use the accepted service/fellowship message, official Legion artwork, a
public-event route, Post introduction, first-visit questions, contact preview,
veteran-support preview, and clearly separate member-site link. The identity and
artwork do not suggest a Post-owned clubhouse or invented real members.

Palette: Emblem Blue `#00467F`, Poppy Red `#B5121B`, white `#FFFFFF`, Light Blue
`#F5F8FA`, dark text `#163247`, separator `#C5D5E1`.
Type: Noto Sans for body and utility text; the existing condensed Noto face for
A's display headings and dates. B uses ordinary Noto Sans for display, with a
quieter scale. Font files and their license are copied from the previous concepts.

A uses a lively screenprint-style scene of a classic car, grill, cups and glove.
The white canvas, condensed lettering and perforated invitation details extend
the character of event-poster artwork. B uses a dimensional paper composition
of hands, coffee, gloves and ribbon with a soft background and event stationery.
The intended distinction is sociable event energy versus quieter shared service.
Neither adopts the earlier research organizations' marks or imagery.

Desktop composition:

```
A: Legion identity / familiar navigation
   service statement       illustrated event scene
   two public-event invitations
   Post introduction       fellowship and service
   first-visit invitation  practical questions
   contact                 member-site link

B: Legion identity / familiar navigation
   paper-relief artwork    service statement
   public-event stationery
   Post introduction       fellowship and service
   first-visit invitation  practical questions
   contact                 member-site link
```

Both recompose vertically on phones, retain normal reading order, and keep a direct
event link near the introduction. The initial phone headline was too tall; it was
reduced so the first event is reached sooner. The paper artwork's edges were softened
in CSS to integrate its background. This does not alter the source illustration.

## Boundaries and content

The sample September 19 car/bike show and October 3 brat fry dates are fictional.
Every page and invitation identifies them as preview content. Time, location,
guest/child attendance, cost, and registration are explicitly unconfirmed. No
calendar download, registration, or message submission is implemented. Event
dialogs illustrate detail presentation; real events still need permanent URLs.
The user's statement that meetings take place at the gun club appears in the FAQ;
the exact venue, address and schedule await confirmation.

Contact and veteran-support controls open honest preview states. No invented
person, phone number, eligibility rule, dues amount, assistance service, or API
record is published. No member data or companion credentials are accessed.

## Artwork

Original illustrations are `assets/saturday.png` and `assets/together.png`.
The built-in image generation tool produced each once; no paid API/CLI fallback
was used. Exact prompts and provenance: [artwork-prompts.md](artwork-prompts.md).
Both illustrations are fictional. The official brandmark is placed separately in
HTML, unchanged, with clear space. See [brand sources](../../brand/README.md).

## Verification

See the final verification notes below. Browser checks cover static prototypes,
not Rails pages or a deployed container. Docs are excluded from the Docker build.
No application code, production data, deployment configuration, commit or remote
publication was changed by this mockup work.

Completed checks: both pages at 1440px and 390px, plus horizontal-overflow checks
at 320px; all image and font assets loaded. Mobile menu, event invitation opening,
Escape dismissal, keyboard activation of the first FAQ and contact preview, visible
skip-link focus, and quiet/unavailable calendar states passed. Full-page screenshots
were visually reviewed. JS syntax, local asset/anchor checks, brandmark byte identity,
and `git diff --check` passed. Rails CI was not rerun for these docs-only prototypes.
The browser runner required atomic batches to retain page state and explicit focus
or scrolling for offscreen elements; early captures were replaced after correcting
the test setup. Generated raster artwork remains at source resolution; production
image optimization is deferred until a direction is chosen.
