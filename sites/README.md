# Post 165 working V1 preview on Sites

The design, copy, markup, fonts, assets and browser interactions come from the
Rails application in `AndreRobitaille/wipost165`, via `script/export_site_preview.rb`.
The export generates templates, not sample events or a frozen calendar.
Do not hand-edit generated templates or redesign this separate checkout.

Sites runs a Cloudflare Worker, so `worker/worker.mjs` supplies the database-free
public calendar adapter. It reads only the published events API, server-side,
using the read-only website token stored as the Sites secret `PUBLISHER_TOKEN`.
No AI API key is needed. No credentials, private member data, people or portraits
are included in source or public assets. Requests fail closed; there is no stale
or sample fallback. HTML is no-store and noindex. Static informational pages
remain usable during calendar outages.

Build: `node build.mjs`. Output: `dist/server/index.js` and `dist/client/`.
Regenerate this checkout from Rails after changing views or assets; use the Sites
workflow to save and deploy the existing project. The old V2 Site and Hetzner
production site are separate and are not updated by this build.
