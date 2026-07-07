# CLAUDE.md

This repository contains the custom WordPress theme, validation scripts, documentation, and deployment workflow for the Robert E. Burns American Legion Post 165 website.

## Read these documents first

Before making architecture, design, content, UX, communications, or implementation decisions, read the relevant files under `docs/`:

- `docs/LEGION.md` — American Legion mission, Four Pillars, tradition, modernization, volunteer constraints, and organizational context.
- `docs/POST_MEMBERS.md` — current Post 165 member culture, communication style, volunteer expectations, and internal dynamics.
- `docs/COMMUNITY.md` — Two Rivers community identity, values, visitor needs, and editorial voice.
- `docs/superpowers/specs/2026-07-06-wordpress-site-design.md` — approved site design/specification.
- `docs/superpowers/plans/2026-07-06-wordpress-site-v1.md` — implementation plan and task history.
- `docs/wordpress/content-model.md` — what Git owns, what WordPress owns, event categories, pages, and editor rules.
- `docs/wordpress/setup.md` — WordPress setup checklist and editor workflow.
- `docs/deployment/ftp-github-actions.md` — manual FTP deployment guidance and safety notes.
- `docs/HANDOFF.md` — current project state for developers/designers joining the work.

## Repository boundaries

- Git owns the `post165` theme, validation scripts, documentation, and deployment workflow.
- WordPress owns live wp-admin content, events, posts, media, menus, plugin settings, and uploaded files unless explicitly exported.
- Do not assume wp-admin edits will sync back to Git.
- Do not deploy to FTP unless explicitly requested.

## Commands

- Install: no dependency install is required yet; use Node.js 20+.
- Dev: `npm run dev` currently runs static validation only; no local WordPress dev server is configured.
- Build: `npm run build`.
- Lint: `npm run lint`.
- Typecheck: `npm run typecheck`.
- Test: `npm test`.

## WordPress/theme notes

- Theme path: `wp-content/themes/post165/`.
- This is a custom WordPress block theme using `theme.json`, block templates, template parts, and PHP block patterns.
- Homepage sections are driven by `wp-content/themes/post165/templates/front-page.html` and Post 165 patterns, not by body content typed into the Home page.
- Events are intended to use The Events Calendar archive/landing URL, commonly `/events/`, not a normal editor-created Events page unless plugin configuration later requires one.
