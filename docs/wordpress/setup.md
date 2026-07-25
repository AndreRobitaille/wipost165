# WordPress Setup

## Hosting assumptions

The site is hosted on NixiHost shared WordPress hosting with FTP, HTTPS, and MySQL access.

## Theme

Upload or deploy `wp-content/themes/post165/` to the WordPress site's `wp-content/themes/` directory, then activate **Post 165** in wp-admin.

## Required plugin

Install **The Events Calendar** for event management.

Create these event categories:

- Public Events
- Post Meetings
- Honor Guard

## Pages

Create these pages:

- Home
- Membership
- About
- Contact

Set **Home** as the static front page in Settings → Reading.

The homepage content comes from `wp-content/themes/post165/templates/front-page.html` and starter patterns, not from page body content.

Routine editors: update events, contact facts, and page body text on Membership/About/Contact. Do not edit the Front Page template.

Site/theme editor: if assigned, use Appearance → Editor → Templates → Front Page for small copy or order adjustments, then Preview and Save.

Structural changes or default pattern copy changes: edit the Git theme pattern/template files and redeploy.

If unsure, do not save Front Page template changes; ask the theme maintainer.

To inspect available Post 165 patterns, go to Appearance → Editor → Patterns → Post 165, if the installed WordPress version supports pattern browsing.

The Events item in the header Navigation block should link to The Events Calendar archive/landing URL, commonly `/events/` and adjusted if plugin settings differ, not to a normal page created by editors.

The Events section should use The Events Calendar events archive/landing page. Do not create a normal Events page unless later plugin configuration requires one.

For Membership, About, and Contact, insert the matching Post 165 starter pattern from the `Post 165` pattern category and edit the text as needed.

## Menu

Update the header Navigation block in the Site Editor with:

- Home
- Events
- Membership
- About
- Contact

The shipped theme seeds these five v1 navigation links by default. Editors can adjust the Events URL in the Navigation block if The Events Calendar uses a different archive URL or a staging/subdirectory path.

## Settings → Post 165

The homepage reads its facts from **Settings → Post 165** in wp-admin. Any
user with `manage_options` can update them; no developer or deploy is needed.

| Field | Notes |
| --- | --- |
| Who can join, Dues | Free text. **Not shown on the homepage** as of the 2026-07-25 "ask" redesign — kept here for the future Membership page. See "Why dues and eligibility left the homepage" below before putting them back. |
| Member count | Enter the **true** number if you want it on file. **Not shown on the homepage** either, for the same reason. The nearest-5 rounding formatter (`post165_format_member_count()` in `inc/pure/format.php`) still exists and is unit tested, ready for the Membership page to call. |
| Charter year | Shown in the strap ("1919 · Chartered"). Blank hides it. |
| Meeting rule | Which week, which day, start time (24-hour), venue, address. **Meeting dates are calculated from this rule** — they are never entered by hand and never go stale, but see the warning below: this rule only drives the homepage. |
| Individual meeting changes | Six rows, each keyed by month (`2026-11`). Fill only what differs; blanks inherit from the rule. Ticking **Cancelled** leaves that month off the homepage entirely. |
| Contact | Name, role, email, phone. The email is obfuscated against scrapers on output. Shown on the homepage ask panel when at least one of these is filled in. |
| Photographs | Up to four, each chosen from the Media Library with the **Choose** button, plus a short description. The attachment ID field is the value that actually gets saved — the Choose button is a convenience that fills the ID in for you. If JavaScript fails to load, the row still works: type or paste the attachment ID by hand (visible in the Media Library's URL or the image's "Attachment Details" panel) and fill in the description. **There is no visible caption on the homepage: the description you enter is used as the image's `alt` text instead, so write what is actually happening in the photograph, for someone using a screen reader** — "Honor guard folding a flag at a cemetery," not just "Honor guard." The photographs render in the navy strap at the very top of the homepage, between the tagline and the charter year — **not** as a full-width row lower on the page. The strip renders nothing at all — no boxes, no placeholders — until images are set. |

**Anything left blank is left off the page.** The site never invents a
placeholder value.

**Photographs display deliberately small on the homepage.** The post's
available photographs are amateur snapshots and sometimes low resolution;
shown small, that reads as authentic — a post that actually shows up and
takes pictures. Enlarged, the same photos read as careless. Do not "fix"
the image size upward without re-checking this against real source photos
first.

**Photographs disappear below 68rem (about 1088px) wide**, on tablets and
phones, and on any browser window narrower than that. This is deliberate:
the strap needs roughly that much width to hold the tagline, four images,
and the charter year on a single line without wrapping, and a wrapped strap
looks broken. Below 68rem the strip is hidden entirely with `display: none`
rather than shrunk — there is no small-screen fallback, and none is needed,
since the photographs were never the point of the page on a phone.

**Alt text is the description field, not a separate field.** There is no
visible caption anywhere on the homepage any more, so the description
entered in Settings → Post 165 is passed straight through as the image's
`alt` attribute (`post165_render_work_photos()` in `inc/blocks.php`). Write
what is actually happening in the photograph — "Honor guard folding a flag
at a cemetery," not just "Honor guard" — because for a screen reader user
that description is the only text the photograph has at all. Leaving it
blank is legal but means the image announces nothing.

### Why dues and eligibility left the homepage

The 2026-07-25 redesign rewrote the second homepage column from a facts
table into an invitation to help — see `post165_render_join_panel()` in
`inc/blocks.php`. The homepage now asks people to volunteer for a morning,
not to join as a member. A dues figure or an eligibility rule shown before
anyone has been given a reason to care is just an exit: people leave on the
first hurdle rather than reading further. Those facts still belong on the
Membership page, where someone has already decided they are interested and
a hurdle is no longer the first thing they see. Please do not add the Dues
or Who can join fields back onto the homepage.

**The meeting rule only updates the homepage.** Two other places state the
meeting day, time, and location in plain text and will not change when you
edit the rule above:

- **The site footer**, shown on every page, hard-codes the meeting day, time,
  venue, and address. It is part of the theme (`parts/footer.html`), so
  changing it needs a developer to edit the file and redeploy.
- **The Contact page**, if it was created from the Contact starter pattern,
  hard-codes the same details as ordinary page content. Once the pattern is
  inserted into a page, that text lives in the database like any other page
  content — updating the rule in Settings → Post 165 will not touch it. Edit
  the Contact page directly in wp-admin instead.

If an officer ever changes the standing meeting rule (a different weekday,
week, or time), check the footer and the Contact page and update both by
hand so the site does not contradict itself.

## Pages you must create

None of these pages exist yet. The homepage links to the first three, so
until they are created those links return 404. Create each as a WordPress
page with **exactly** the slug shown — the links are hardcoded to these paths.

| Page | Slug | Starter pattern | Linked from |
| --- | --- | --- | --- |
| Membership | `membership` | `post165/membership-page` | Join panel button |
| Support | `support` | none yet | "What we do" row |
| Contact | `contact` | `post165/contact-page` | "What we do" row |
| About | `about` | `post165/about-page` | Header navigation |
| Events | `events` | none — The Events Calendar owns this URL | Header navigation |

To apply a starter pattern: create the page, then in the editor insert the
named pattern and edit its content. The patterns are starting points owned by
Git; once inserted, the page content belongs to WordPress.

There is no `support` pattern. Either write that page from scratch or drop the
link from `patterns/home-what-we-do.php`.

### Events

Public events come from The Events Calendar. The **monthly post meeting does
not need a calendar entry** — it is computed. If you also enter the meeting in
The Events Calendar it will appear twice; that duplicate is the signal to
delete the manual entry.

Between October and March, when no public event falls within 60 days, the
homepage automatically shows a short "quiet season" note pointing at the next
annual milestone. Nobody needs to switch this on or off.

### The year strip

The twelve-month rhythm is theme content, not calendar data, so it stays
correct when the calendar is empty. It lives in
`wp-content/themes/post165/inc/pure/year-map.php` and changing it needs a
developer. **Only the brat fry and car show are confirmed; the other months
are provisional and must be verified by an officer.**

## Verify contact facts before launch

Confirm these details before publishing:

- formal name: Robert E. Burns American Legion Post 165;
- mailing address: PO Box 11, Two Rivers, WI 54241;
- meeting location: Manitowoc Rifle & Pistol Club, 7227 Sandy Hill Ln, Two Rivers, WI 54241;
- meeting time: first Tuesday of each month at 6:30 pm;
- phone: (920) 860-7478;
- email: wipost165@gmail.com;
- Facebook group: https://www.facebook.com/groups/amlegionpost165wi.

## Editor guidance

- Use events for dated activities.
- Use posts only for occasional updates that should remain visible as articles.
- Do not rebuild the homepage by typing content into the Home page body; edit homepage copy through the theme/Site Editor workflow or by updating theme pattern files in Git and redeploying when needed in v1.
- Do not add online donations until payment processing and treasurer workflow are approved.
- Do not add member-only resources until v2.

## Design assets and content to complete

- Fonts (Fraunces and Public Sans) are bundled with the theme at `wp-content/themes/post165/assets/fonts/` and load automatically through `theme.json`. Do not install a fonts plugin (e.g. a Google Fonts plugin) — it is unnecessary and would duplicate what the theme already self-hosts.
- The header/hero mark at `wp-content/themes/post165/assets/images/seal.svg` is a custom placeholder mark, not the official American Legion emblem. It may be replaced with the official emblem only where American Legion usage guidelines permit. The preferred way to swap it is Appearance → Customize → site logo (custom-logo theme support is enabled), rather than editing the SVG file directly.
- The About page's "Our Namesake" and "Our History" sections currently use placeholder text and need the real Robert E. Burns biography, the Post's charter year, and 1–2 real milestones before launch.
