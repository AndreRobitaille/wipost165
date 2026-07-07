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

- `home-hero.php`
- `home-events.php`
- `home-membership.php`
- `how-we-serve.php`
- `support-post-165.php`
- `contact-card.php`
- `membership-page.php`
- `about-page.php`
- `contact-page.php`

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
- **Motif intensity dial:** rather than one fixed decorative frame, the ceremonial red/cream/gold stripe "spine" motif is applied at different intensities depending on context:
  - **Full dress** — the homepage hero (and similarly prominent moments) use the full stripe spine treatment.
  - **Quiet** — interior pages (About, Membership, Contact) and most homepage sections drop the loud motif elements in favor of content-first, understated layouts.
  - The dial is implemented as a motif system in `wp-content/themes/post165/style.css`.
- **Typography:** the theme now self-hosts **Fraunces** (display/headlines) and **Public Sans** (UI/nav/labels/body, the USWDS federal typeface) as woff2 files under `wp-content/themes/post165/assets/fonts/`, loaded via `theme.json`. No fonts plugin is required or should be added — see the new "Design assets and content to complete" section in `docs/wordpress/setup.md`.
- **Local visual checks:** `scripts/preview.mjs` renders static HTML previews of the theme's templates/patterns for quick visual review without a running WordPress install. This is separate from the WordPress Playground investigation described below, which remains unresolved.
- Implementation plan and task-by-task history: `docs/superpowers/plans/2026-07-07-visual-design-implementation.md`.

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
