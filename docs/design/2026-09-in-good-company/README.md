# In good company — working experience prototype

September 7, 2026. The owner authorized this prototype after selecting the strength
of three recognizable regulars: we do not need to know visitors' motives to welcome
them, and recognizing someone at an event provides an opening for conversation.

## Design plan

- **Signature:** three people around one shared table; its center changes from
  welcome to introduction, event, and first visit. The visitor remembers a person
  as they make plans. A table rendering with text below would repeat the rejected
  mockups; the table must remain the working interface.
- **Color:** official Emblem Blue `#00467F`, Poppy Red `#B5121B`, Light Blue
  `#F5F8FA`, white `#FFFFFF`, supporting dark blue `#002E55` and ink `#173E5C`.
- **Type:** existing condensed Noto for brief display statements; Noto Sans for
  readable introductions, utility labels and actions. Official mark unchanged.
- **Layout:** people at the far and side edges; readable content at the center;
  People / Events / First visit on the near edge. Phones retain all three faces
  as a shallow arc above the same working surface.
- **Motion:** selecting a person emphasizes their portrait and brings the next
  content into the table. No autoplay, audio, forced tour or drag-only navigation.

```
                       Ron
          Frank                     Jo
                / shared table \
               | introduction   |
               | occasion       |  same surface, changing view
               | first visit    |
                People Events Visit
                       you
```

## Review and use

The owner subsequently requested hosting **just this mockup** on ChatGPT Sites.
On September 7, 2026, version 1 was privately published for the owner at
[the hosted mockup](https://post165-in-good-company.andretr.chatgpt.site).
The Sites deployment reported `succeeded`. Its source and static archive were
verified byte-for-byte against the reviewed mockup. This does not change the
production direction of Rails on Hetzner or deploy the Rails/member applications.

The owner subsequently requested sharing without ChatGPT sign-in. Access was
changed to **public (anyone with the URL)** on September 7, 2026. Readback confirmed
the public policy, and an anonymous HTTP request returned the mockup with status
200 without cookies, authorization headers or a sign-in redirect. The URL and
deployed version are unchanged.

The isolated Sites checkout is
`/home/andre/.codex/visualizations/2026/09/07/01a07c77-b100-73a3-9e31-2723d0789fc0/post165-mockup-site`.
Reuse its `.openai/hosting.json` project ID for future updates; do not create another
Site or add a Sites manifest to the Rails project root. Source commit:
`d5583cc3a2624368fa23067708297d26adf26435`. Deployment:
`appgdep_6a9f248723bc81919afa4c842af3d1a4`. No credentials were saved in either repo.

Open [the prototype](index.html) using a local static server. Review the
[phone opening](previews/phone.png), [introduction](previews/phone-person.png),
[event](previews/phone-event.png), [first visit](previews/phone-visit.png),
[desktop opening](previews/desktop.png), or the
[12-second phone walkthrough](previews/phone-walkthrough.mp4).
This is an experience test under
docs, not a production Rails page or public deployment.

The three portraits are stock models, not Post members. Frank, Ron and Jo are
fictional demonstration names. Introductions, interests and recurring attendance
are sample content. A conspicuous preview banner and individual sample labels
identify this throughout. No model's veteran status, occupation, personal story,
or relationship to the Legion is asserted. Replace all three with consenting
regulars, approved short introductions, and recognizable current photographs.

The event has no invented date. The owner's gun-club meeting location is retained;
address, welcome arrangements, eligibility, guest attendance and child attendance
need confirmation. Selecting a profile never promises that person's attendance.

`?state=quiet#events` and `?state=unavailable#events` exercise alternative calendar
states. The contact form previews text locally; it never sends or stores a message.
The members link leads to the separate members site. No private data/API is used.
Hash routes and browser back work in this static prototype; Rails should use normal
server-rendered pages and URLs when implementing the selected design.

## Portrait and asset provenance

Downloaded September 7, 2026 from Pexels; unchanged source images are displayed
with CSS object fitting. Sources are also credited in the prototype footer.

- `assets/sample-frank.jpg`: [Alena Darmel, 7322315](https://www.pexels.com/photo/elderly-man-in-gray-long-sleeves-smiling-7322315/).
- `assets/sample-ron.jpg`: [Picas Joe, 11346735](https://www.pexels.com/photo/a-close-up-shot-of-an-elderly-man-smiling-11346735/).
- `assets/sample-jo.jpg`: [Alimi Sandrine, 29405854](https://www.pexels.com/photo/professional-portrait-of-smiling-middle-aged-woman-29405854/).

Official white brandmark copied byte-for-byte from `docs/brand`; fonts and their
license originate in the previous concept assets. Fonts were subset to Latin,
punctuation and interface symbols with FontTools to keep the self-contained preview
small. No new AI artwork was generated.

`python build-preview.py /absolute/output/path.html` bundles the same HTML, CSS,
JavaScript, fonts and portraits as a conversation preview fragment. The reviewed
fragment is approximately 346 KB and makes no asset or API requests. In the opaque
conversation frame, navigation updates locally; standalone hash history remains
available in the ordinary prototype. The build script accepts an explicit output
path and does not publish anything.

## Verification

- Browser layout checks passed at 320, 390, 736, 1024 and 1440 pixels across all
  main views, plus invalid route fallbacks. No horizontal document overflow or
  content-region clipping was found.
- Desktop and phone screenshots were visually inspected. The initial phone pass
  led to larger controls/captions and matching portrait crops. The table grows
  with longer content rather than trapping it in a fixed-height panel.
- Keyboard profile activation and first-visit disclosures passed. Browser back
  restores the previous view. The selected person's introduction carries into
  event and first-visit views without asserting attendance.
- Contact preview displays input as plain text, including markup-like input;
  no message is submitted or stored. Quiet and unavailable calendar states passed.
- Images loaded, reduced-motion styles applied, and browser error collection
  reported no page errors in the standalone prototype.
- The conversation renderer was visually checked at phone and desktop widths.
  A real pointer interaction inside its sandboxed frame successfully opened an
  introduction after adapting navigation for that frame's history restrictions.
- The approximately 12-second recording was checked as a 390 × 1000 phone video
  and converted to H.264 MP4 for easier playback. An initial recorder-context
  viewport mismatch was corrected before retaining the final recording.
- JavaScript syntax, local assets, brandmark identity, contrast token pairs and
  whitespace checks passed. No Rails code changed, so Rails CI/container checks
  were not rerun. Initial prototype work did not commit, push or publish. The later
  separately authorized Sites publication is recorded above; its commit and source
  push were confined to the isolated mockup checkout.

This tests the visual experience and prototype interactions, not real member
recognition, actual welcome practices, public API behavior or production features.
