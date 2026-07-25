# Project Handoff

This document summarizes the current state of the Robert E. Burns American Legion Post 165 website project so another developer, designer, or content contributor can join the work quickly.

## Current status

- The repository now contains a v1 custom WordPress block theme foundation at `wp-content/themes/post165/`.
- Static validation is wired through `npm test`, `npm run lint`, `npm run typecheck`, `npm run build`, and `npm run dev`.
- The v1 design spec and implementation plan are committed under `docs/superpowers/`.
- WordPress setup, content ownership, and deployment docs are committed under `docs/wordpress/` and `docs/deployment/`.
- A manual GitHub Actions FTP deployment workflow exists, but deployment should not be run unless explicitly requested.
- No local WordPress development server is configured in the repo yet.
- WordPress Playground was suggested for no-install visual testing, but the CLI experience is not yet documented or proven for this repo.
- A visual redesign layer ("Still here. Still serving.") has been implemented on top of the v1 foundation — see "Visual redesign: narrative and typography" below.

## Important documents to read

Read these before making decisions:

- `docs/LEGION.md` — American Legion mission, Four Pillars, traditions, volunteer time, modernization, and long-term organizational questions.
- `docs/POST_MEMBERS.md` — Post 165 member culture, communication style, technology comfort, and volunteer dynamics.
- `docs/COMMUNITY.md` — Two Rivers context, community values, visitor behavior, and editorial voice.
- `docs/superpowers/specs/2026-07-06-wordpress-site-design.md` — approved site architecture, content, visual direction, editor model, exclusions, and success criteria.
- `docs/superpowers/plans/2026-07-06-wordpress-site-v1.md` — implementation plan and task-level history.
- `docs/superpowers/specs/2026-07-07-visual-design-and-narrative-direction.md` — approved visual redesign spec: narrative spine, motif intensity dial, and typography direction.
- `docs/superpowers/plans/2026-07-07-visual-design-implementation.md` — implementation plan and task-level history for the visual redesign.
- `docs/wordpress/content-model.md` — Git/WordPress ownership boundary, navigation, events, pages, and editing rules.
- `docs/wordpress/setup.md` — WordPress setup and editor workflow.
- `docs/deployment/ftp-github-actions.md` — manual FTP deployment process and safety notes.

## Repository ownership model

Git owns:

- `wp-content/themes/post165/` custom theme files;
- validation scripts;
- setup, content, deployment, and project documentation;
- GitHub Actions workflow.

WordPress owns:

- pages edited in wp-admin;
- events;
- posts/news;
- uploaded media;
- menus/navigation changes after launch;
- plugin settings unless a reliable export/import process is later documented.

Do not assume live wp-admin changes will be represented in Git.

## Theme structure

Theme root: `wp-content/themes/post165/`

Key files:

- `style.css` — WordPress theme header and base CSS helpers.
- `functions.php` — theme support and Post 165 pattern category registration.
- `theme.json` — palette, typography, spacing, layout, and block defaults.
- `parts/header.html` — header with seeded v1 navigation links.
- `parts/footer.html` — footer mission/contact block.
- `templates/front-page.html` — homepage template assembled from patterns.
- `templates/page.html` — ordinary page template; renders the page title as H1.
- `templates/index.html`, `single.html`, `archive.html`, `404.html` — fallback/post/archive/not-found templates.
- `patterns/*.php` — homepage and starter page block patterns.

Current pattern set:

- `home-board.php`
- `home-proof.php`
- `home-what-we-do.php`
- `membership-page.php`
- `about-page.php`
- `contact-page.php`

The six original homepage patterns (`home-hero.php`, `home-events.php`,
`home-membership.php`, `how-we-serve.php`, `support-post-165.php`,
`contact-card.php`) were deleted in the 2026-07-24 homepage redesign. See
"Homepage: 'The Board'" below. `contact-card.php`'s markup was inlined into
`contact-page.php` rather than deleted outright.

## V1 navigation and content model

Primary navigation:

- Home
- Events
- Membership
- About
- Contact

Do not add top-level Programs, Four Pillars, News, Support, or Member Resources in v1 unless content becomes substantial enough to justify them.

Events should be handled by The Events Calendar archive/landing URL, commonly `/events/`, not by creating a normal WordPress Events page unless plugin configuration later requires one.

Create normal WordPress pages for:

- Home — assign as static front page only.
- Membership — use the `Membership page starter` pattern.
- About — use the `About page starter` pattern.
- Contact — use the `Contact page starter` pattern.

## Editor workflow

Routine editors should:

- update event details in The Events Calendar;
- update contact facts when verified;
- edit body text on Membership, About, and Contact;
- avoid editing the Front Page template;
- avoid typing homepage content into the Home page body.

Assigned site/theme editors can inspect or edit the homepage through:

`Appearance → Editor → Templates → Front Page`

They should Preview and Save only if they intentionally mean to change the front page template. Structural homepage changes or default pattern copy changes should be made in Git theme files and redeployed.

## Design and voice constraints

The site should feel:

- mission-driven and supportive;
- warm and local;
- dignified patriotic, not flashy patriotic;
- practical and plainspoken.

Avoid:

- generic patriotic clip art;
- excessive eagles;
- tactical/military cosplay aesthetics;
- political-campaign styling;
- glossy corporate marketing language;
- photography-dependent layouts;
- homepage latest-news feeds that will go stale.

Use the American Legion brand mark where appropriate for public identity. Treat the emblem as formal/official, not decorative wallpaper.

## Visual redesign: narrative and typography

A visual redesign has been implemented on top of the v1 theme foundation described above. Full detail lives in the spec and plan; this section summarizes what changed for anyone picking up the work.

- **Narrative spine:** the site's visual and content direction is organized around the line **"Still here. Still serving."** — continuity through service, expressed across the homepage and interior pages. See `docs/superpowers/specs/2026-07-07-visual-design-and-narrative-direction.md` for the full narrative rationale.
- **Motif intensity dial:** rather than one fixed decorative frame, the ceremonial red/cream/gold stripe "spine" motif was applied at different intensities depending on context:
  - **Full dress** — the homepage hero (and similarly prominent moments) used the full stripe spine treatment.
  - **Quiet** — interior pages (About, Membership, Contact) and most homepage sections dropped the loud motif elements in favor of content-first, understated layouts.
  - The full-screen homepage hero and its stripe-spine CSS were removed in the 2026-07-24 homepage redesign (see "Homepage: 'The Board'" below), so the "Full dress" tier no longer has anywhere to apply. The "Still here. Still serving." line survives as the strap headline in `patterns/home-board.php`. The "Quiet" treatment on interior pages is unaffected.
- **Typography:** the theme now self-hosts **Fraunces** (display/headlines) and **Public Sans** (UI/nav/labels/body, the USWDS federal typeface) as woff2 files under `wp-content/themes/post165/assets/fonts/`, loaded via `theme.json`. No fonts plugin is required or should be added — see the new "Design assets and content to complete" section in `docs/wordpress/setup.md`.
- **Local visual checks:** `scripts/preview.mjs` renders static HTML previews of the theme's templates/patterns for quick visual review without a running WordPress install. This is separate from the WordPress Playground investigation described below, which remains unresolved.
- Implementation plan and task-by-task history: `docs/superpowers/plans/2026-07-07-visual-design-implementation.md`.

## Homepage: "The Board" (2026-07-24)

The homepage was rebuilt from six brochure bands into a two-column answer
board. See `docs/superpowers/specs/2026-07-24-homepage-density-design.md`.

- Pure, WordPress-free logic lives in `wp-content/themes/post165/inc/pure/`
  and is unit tested by `scripts/php-tests.php`.
- Run those tests with `npm run test:php`. There is no PHP on the dev machine;
  the runner falls back to the `php:8.3-cli` Docker image automatically.
- `npm test` runs the static validator **and** the PHP tests.

### What the automated tests do not cover

The validator is a static string checker and the PHP tests boot no WordPress.
Neither can verify:

- Rendering inside a real WordPress install.
- The Events Calendar integration (`post165_public_event_entries`).
- That `scripts/preview.mjs` shows the board — **it does not**. The preview
  strips PHP and cannot execute dynamic blocks, so the board renders empty
  there. Use a real install to review the homepage.

Check manually against a live site: meeting dates across a month boundary and
either side of the start time; TEC absent and TEC present-but-empty; the
October–March quiet season; each override kind; and member-count rounding at
0, 3, 5, 183, 200.

### Homepage v2: "The Ask" (2026-07-25)

The homepage's second column was rewritten from a membership facts table into
an invitation to volunteer, and a third homepage block (a small row of work
photographs) was added. See
`docs/superpowers/plans/2026-07-25-homepage-v2-the-ask.md` for the task-level
history. In outline:

- `post165_render_join_panel()` in `inc/blocks.php` no longer shows dues,
  eligibility, or member count. It shows a short list of what volunteers
  actually do (honor guard, brat fry, flags on graves, youth programs) and,
  if a contact person is set in Settings → Post 165, their name/role and a
  way to reach them. Dues, eligibility, and member count remain in
  Settings → Post 165 for the future Membership page; see
  `docs/wordpress/setup.md` ("Why dues and eligibility left the homepage")
  for the reasoning — do not reintroduce them on the homepage.
- `post165_render_work_photos()` in `inc/blocks.php` renders up to three
  photographs chosen in Settings → Post 165, deliberately small (the
  available photographs are amateur/low-resolution; small reads as
  authentic, enlarged reads as careless), and renders nothing at all until
  photographs are configured. See `docs/wordpress/setup.md` for the editor
  workflow, including alt text guidance.

#### Photographs left the board entirely; the remaining source order is events → ask → year

`patterns/home-board.php` now renders three `.post165-board__*` wrapper
`<div>`s, in this order in the markup: **events, then ask, then year**.
Desktop's two-column layout is achieved entirely with `grid-template-areas`
in `style.css` (`.post165-board`, around the block starting
`display: grid;`); the mobile layout re-declares the same areas as a single
column in the same order, rather than removing them, specifically so DOM
order and visual order always match.

The year strip sits right after events, not after the ask, because it's
calendar content — a year-at-a-glance view that pairs with the dated event
list ("when is this happening" / "what does the year look like"). This
grouping was moved into place at the post owner's explicit request (see
`f125a5b`); events→ask→year is the current reality, not an incidental
snapshot.

**Photographs used to be a fourth board block, always last, on the
constraint that a phone user must reach the dated events and the ask before
any photograph.** As of the homepage "v3" strap redesign, that constraint
is satisfied structurally rather than by ordering: `post165/work-photos`
was moved out of `.post165-board` entirely and now renders inside
`.post165-strap` at the very top of the page (between the tagline and the
charter year — see `patterns/home-board.php`). There is no photograph
anywhere in the board any more, on any viewport, so there is nothing left
that could be reordered to precede the events list. Below 68rem the strap
photo strip is hidden outright (`display: none` on `.post165-strap__shots`)
rather than stacked into the board, so this remains true at every width.

The old prohibition on reordering the board still applies to the three
blocks that remain — it was never really about photographs specifically,
it was about DOM order and visual order silently diverging:

**Do not**, even for a seemingly harmless visual tweak:

- add a CSS `order` property to any `.post165-board__*` rule;
- switch to `flex-direction: row-reverse` or similar on `.post165-board`;
- achieve a desktop-only rearrangement by leaving DOM order alone and only
  editing `grid-template-areas` (or vice versa) — DOM order must remain
  mobile order, so any reordering has to move the actual
  `<!-- wp:group -->` blocks in `patterns/home-board.php` and update both
  `grid-template-areas` declarations (desktop and the 52.5rem mobile
  breakpoint) together.

Any of these would silently break the mobile guarantee that events and the
ask reach the visitor in a predictable order, while potentially leaving the
desktop layout looking unchanged. It is the kind of regression that only
shows up if someone actually checks a phone.

### Homepage v3: photographs move into the strap (2026-07-25)

The full-width photo row below the board (`.post165-work`,
`.post165-board__photos`) was removed outright. `post165/work-photos`
still exists as a block and still reads the same `photos` setting, but its
render callback now produces a bare `.post165-strap__shots` wrapper of
plain `<img class="post165-strap__shot">` elements — no `<figure>`, no
visible caption — placed as a third sibling inside `.post165-strap`,
between the tagline `wp:html` block and the charter-year `wp:html` block.
The Photographs setting on Settings → Post 165 now holds four rows instead
of three (`POST165_PHOTO_ROWS` in `inc/settings.php`), and the field
previously labeled "Caption" is relabeled "Description (used as alt text)"
in the admin UI — the stored option key is still `caption`, so no data
migration was needed.

Because the strap has no visible caption, the description is now passed to
`wp_get_attachment_image()` as `alt` on purpose
(`post165_render_work_photos()` in `inc/blocks.php`). This is the reverse
of the row it replaced, where a visible `figcaption` already carried the
text and an empty `alt` was correct to avoid a screen reader announcing the
same words twice. Do not "restore" the old empty-alt behavior here — with
no caption on the page, the description is the photograph's only text
alternative.

**Grid-gap fix.** With the photo row gone, `.post165-board__ask` still
spans both grid rows (it must, to look right next to the shorter
`.post165-board__year`), and CSS Grid's default track sizing distributes
any surplus height across *all* spanned rows evenly. Before this fix, that
inflated the `events` row to match whichever of `events`/`ask` was taller,
pushing the "Our year" heading down and leaving a large empty band under
the last event row on desktop — exactly the gap the post owner complained
about. The fix is `grid-template-rows: min-content 1fr;` on `.post165-board`
plus `align-self: start;` on `.post165-board__year`: the first row is
pinned to the height its own content actually needs, and all surplus height
is pushed into the second (`1fr`) row, where `align-self: start` keeps the
year content pinned to the top of that now-taller track instead of being
stretched or centered into it. **Do not simplify this back to a bare
`display: grid` with implicit row sizing** — that reintroduces the exact
band this fix closes.

Also removed: the heavy navy `border-top` under `.post165-year` (the
eyebrow already announces the section, so the rule was a redundant
separator), and the `.post165-board__photos` / `.post165-work*` CSS rules,
since nothing emits that markup any more.

**Breakpoints are intentionally two different numbers.** Photographs are
hidden below **68rem** (`.post165-strap__shots { display: none; }`)
because the strap needs roughly 1090px to hold the tagline, four images,
and the charter year on one line without wrapping — a wrapped strap looks
broken. The board's own single-column breakpoint stays at **52.5rem**. Do
not merge these into one breakpoint: between 52.5rem and 68rem the board is
already single-column while the strap still has the width to stay on one
line without the photos, so collapsing them to the lower value would leave
the strap wrapping and stacking across that whole middle range.

### Local WordPress via Docker (works, not committed)

A local, LAN-reachable WordPress environment was assembled to test homepage
v2 against a real WordPress install (referenced above as the "live test
site" in the v2 task ledger). It is **deliberately not committed** to the
repo — no `docker-compose.yml` lives in Git — since it is a personal testing
convenience rather than a supported dev environment, and is recorded here
only so the recipe is not lost.

Recipe:

- `docker compose` with three services: `wordpress:php8.3-apache`,
  `mariadb:11`, and `wordpress:cli-php8.3` (WP-CLI, for seeding
  content/events from the command line).
- Bind-mount the theme directory into the WordPress container at
  `/var/www/html/wp-content/themes/post165` so edits made in the repo show
  up immediately, with no redeploy step.

Three settings are essential — get any of them wrong and the environment
misbehaves in a way that is easy to misdiagnose as a theme bug:

- **`WP_HOME` / `WP_SITEURL` must be set to the LAN address** (e.g.
  `http://192.168.x.x:8080`), not `localhost`. Left as `localhost`,
  WordPress redirects every request there, and the site becomes unreachable
  from any other machine on the network — including whatever device you
  meant to test mobile layout on.
- **Site timezone must be `America/Chicago`.** The meeting-date logic is
  timezone-sensitive; testing under UTC or another timezone produces
  meeting dates that look plausible in wp-admin but land on the wrong day
  on the front end.
- **Permalinks must be `/%postname%/`.** The theme assumes pretty
  permalinks; WordPress's default query-string permalinks break links the
  theme generates.

Events created via WP-CLI need `_EventTimezone`, `_EventStartDateUTC`, and
`_EventEndDateUTC` post meta set explicitly. Without them, The Events
Calendar rejects the event from its own custom tables at save time, and
`tribe_get_events()` silently returns nothing for it — the post exists in
`wp_posts`, but never surfaces as an event anywhere, including the
homepage's upcoming list. This is the single most common cause of "I added
an event and the homepage still shows the old one."

### Known issue: the stylesheet version is static

`functions.php` enqueues `style.css` with `wp_get_theme()->get( 'Version' )`
as its `?ver=` query string — the `Version:` header at the top of
`style.css` (currently `0.2.0`). A CSS-only FTP deploy that does not bump
that header leaves the same `?ver=0.2.0` URL in place, so a browser that
already cached the old stylesheet keeps serving it to a returning visitor
until the cache expires on its own — the deploy can finish cleanly and
still not visually change anything for anyone who has been to the site
before.

Current workaround: **bump the `Version:` line in
`wp-content/themes/post165/style.css` on every deploy that touches CSS**,
even for a one-line change. A more robust fix (e.g. `filemtime()`-based
versioning so this can't be forgotten) has been discussed but not
implemented.

## Deployment state

Workflow: `.github/workflows/deploy-theme.yml`

- Manual trigger only: `workflow_dispatch`.
- Deploys only `wp-content/themes/post165/`.
- Runs `npm test` before deployment.
- Uses FTPS by default.
- Uses repository secrets: `FTP_SERVER`, `FTP_USERNAME`, `FTP_PASSWORD`, `FTP_SERVER_DIR`.
- Third-party FTP deploy action is pinned to an immutable commit.

Do not deploy unless explicitly requested.

## Verification

Current verification command:

```bash
npm test
```

Expected output:

```text
Theme validation passed.
```

The validation is static. It verifies required theme files, key snippets, `theme.json`, documentation, and deployment workflow. It does not render WordPress.

## Local visual testing status

No confirmed local visual testing workflow exists yet.

Suggested next investigation:

- Try WordPress Playground CLI from the repo root or theme directory.
- If Playground remains unreliable, document a reproducible Docker-based WordPress test environment or use a staging WordPress install on NixiHost.

Known issue from the current session:

- `@wp-playground/cli server` rejected `--host` as an unknown argument.
- A browser reached Playground but displayed `WordPress is not ready yet`.
- Further investigation should capture the exact CLI command, terminal output, and browser URL before changing repo scripts.

## Recommended next work

1. Establish and document a reliable local/staging preview workflow.
2. Visually review the block theme in WordPress.
3. Refine theme styling after seeing it render in a real editor/front end.
4. Install The Events Calendar in the target/staging WordPress site and confirm archive URL behavior.
5. Create initial WordPress pages and apply starter patterns.
6. Verify contact facts before publishing.
7. Only after staging verification, configure FTP secrets and run the manual deployment workflow if requested.

## Recent implementation summary

Implemented so far:

- static validation toolchain;
- custom WordPress block theme skeleton;
- homepage template and patterns;
- starter page patterns;
- WordPress content/setup documentation;
- manual hardened FTPS deployment workflow;
- seeded v1 primary navigation links;
- documentation consistency fixes around Events archive ownership and homepage editing.

Explicitly not implemented in v1:

- member login;
- private member resources;
- online donations/payments;
- top-level Programs page;
- top-level Support page;
- homepage latest-news feed;
- local WordPress development server.
