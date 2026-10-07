# Public V1 preview on Sites

Published October 7, 2026 at the owner's request, with public access and no sign-in.

- New V1 preview: https://post165-v1-launch-preview.andretr.chatgpt.site
- Preserved people-based V2 concept: https://post165-in-good-company.andretr.chatgpt.site
- New project: `appgprj_6ac6808b104481919e5be6d86d23188e`
- Saved version: `appgprj_6ac6808b104481919e5be6d86d23188e~appgver_a272dd485b588191bcd4871c3c2d4058`
- Sites source commit: `b3efce0ea0a458dd2f39b20ca311a67e31184425`
- Successful deployment: `appgdep_6ac6813c3d4881918d15652c6d8b5176`
- Local Site checkout: `tmp/sites-v1-preview` (ignored by the Rails repository).

## What is shared

A static export of the actual Rails V1 pages, with the current harbor artwork,
Home/Events/First visit/Contact design, all three footer pages, and working event
modal and direct event page. It is a design preview with a labelled fictional
calendar entry. It does not read the live publisher, contain credentials, include
member portraits/stories, or change the actual production service. The older
people-based Site remains version 1 at its original URL and audience.

This snapshot will not update automatically when Rails content changes. After
Grok enriches the footer pages, re-export and publish a new version of this same
V1 Site. Preserve the existing people-based Site for V2.

## Refresh procedure

Use the Sites hosting workflow to open the existing V1 checkout before editing;
restore it from its Sites source repository if the ignored local copy is absent.
Keep the project ID above. Compile V1 production assets, then render to a fresh,
empty directory with:

```sh
PUBLIC_SITE_EDITION=v1 RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
PUBLIC_SITE_EDITION=v1 PUBLIC_SITE_PREVIEW=1 PUBLIC_SITE_COMING_SOON=0 bin/rails runner script/export_site_preview.rb /absolute/path/to/empty/output
bin/rails assets:clobber
```

Replace the Site checkout's `dist` with that verified export, preserving
`.openai/hosting.json` and its identity. The Site workflow commits/pushes that
checkout, packages the static files, and supplies the exact commit/archive for
save and deploy. Do not copy the Rails checkout or its credentials into Sites.

The exporter only accepts explicit development V1 sample mode. It refuses live
mode and nonempty output directories. It uses compiled V1 assets without sample
portraits, removes CSRF metadata, retains noindex and image licensing, and rewrites
internal links to static HTML. Event pages include a Turbo frame so the same page
serves both the working modal and a direct/no-JavaScript visit.

## Verification

- 8 exported pages at 1440, 390, and 320px: images loaded, no horizontal overflow,
  one main heading, visible sample labels, and noindex. [Results](browser-checks.json).
- Calendar modal opens without navigation, focuses its heading, closes with Escape,
  and restores focus to its event. Direct event HTML remains available.
- All local links and referenced assets resolve in the export; no people routes,
  member images, CSRF metadata, or publisher credentials are present.
- Exporter rejects live-feed mode before rendering or creating output.
- Current [CI log](ci.txt): 76 tests, 738 assertions, zero failures/errors, plus
  style/security/autoload/production assets. Local release checks pass. An initial
  rerun saw leftover V1 compiled assets mask the V2 test fixtures; clobbering those
  generated assets as documented restored a clean passing run.
- Native Sites publish returned `succeeded` with the new public URL. This is hosting
  confirmation; no separate browser navigation to the deployed URL was performed.
- The GitHub workflow now checks pushes to `main` as well as the repository's
  default `master`. The current local work is on `main`; default-branch settings
  were not changed.

No Kamal, production SSH, production-data copy, or change to the older Site occurred.
