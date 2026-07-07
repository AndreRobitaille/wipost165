# AGENTS.md

- This is an early-stage repo for a WordPress-based website for American Legion Post 165 in Two Rivers, WI.
- Project context documents live under `docs/` and should be read before major architecture, design, content, or communication decisions.
- Superpowers design specs and implementation plans live under `docs/superpowers/`.
- The repository owns the custom WordPress theme, validation scripts, documentation, and deployment workflow. WordPress owns live wp-admin content, events, posts, media, menus, and plugin settings unless explicitly exported.
- Install command: no dependency install is required yet; use Node.js 20+.
- Dev command: `npm run dev` currently runs static validation only; no local WordPress dev server is configured yet.
- Build command: `npm run build`.
- Lint command: `npm run lint`.
- Typecheck command: `npm run typecheck`.
- Test command: `npm test`.
- Do not deploy to FTP unless explicitly requested.
