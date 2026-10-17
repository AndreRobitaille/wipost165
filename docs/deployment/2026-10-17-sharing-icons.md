# October 17, 2026 — sharing cards and site icons

The owner approved the horizontal sharing card and explicitly authorized deploying
the sharing/icon updates. Release completed at approximately 11:19 a.m. Central.
Both https://wipost165.org and https://www.wipost165.org serve the new revision.

## Release identity

- Source: `76f4f5cba5c7785a192ad7d3e22bf6ac448af7d9`, pushed on
  `codex/sharing-icons`. The release branch is not merged into `master`.
- Actual previous live source: `16f143c9f315880f4af2cbcbaa7f65b82bcfb72a`, matching
  the new commit's base. The older October 12 handoff revision was superseded by
  other releases; it was not used as the production baseline.
- Public container: `af3f044a1621d1fba2128a887f579465b39b3267def60f4f5f2e0652367ac193`,
  started `2026-10-17T16:18:56.218586179Z`, zero restarts at final inspection,
  running as `1000:1000`.
- Image: `ghcr.io/andrerobitaille/legion-post-165-wi-public`, digest
  `sha256:8b4dfc2c37e0b5bd4cbd3add201ac4b775156d55d158b70b790ce8065aae5f6a`.
- Prior public container `6ce107cd901d4399f06fa9c9f7b0b9d3b59a3ce5426b7967ea49b71f19808ada`
  remains stopped at `16f143c9` for rollback through the guarded release workflow.
- Public flags remain `v1/0/1/0` for edition/coming-soon/launch-ready/preview.
  Public GA4 ID remains `G-KVBQMTBJYB`. Existing credentials were retained.

## Scope and checks

The release adds server-rendered page-specific Open Graph and X card metadata,
homepage site-name JSON-LD, the approved 1200×630 horizontal JPEG, square favicon,
ICO, Apple touch icon, and a correctly typed browser-mode web manifest. The Sites
adapter exports/routes these files locally, but no Sites preview was published.
The approved card keeps the complete Legion logo left, Post 165 / Two Rivers
right, with 40px center gaps and 132/94px local text. The emblem favicon is the
same artwork reviewed and retained by the owner.

- Final local `PARALLEL_WORKERS=1 bin/ci` passed after asset clobber: 93 application
  tests / 2,068 assertions, 10 adapter tests, Ruby style, gem/JS audits, Brakeman
  (zero warnings), autoloading, and production assets. `bin/release check` passed.
  No GitHub workflow run appeared for this branch; this is local CI evidence.
- `bin/release push` verified the exact pushed SHA, then `release_deploy` built
  and deployed through the existing remote builder. Kamal reported success in
  34 seconds. No separate local-container smoke check was performed.
- The wrapper's authenticated read-only V1 publisher check verified six events
  in the next 90 days and their details before deployment.
- Live HTTPS checks pinned both hostnames to `178.156.250.235` without bypassing
  certificate validation. All eight static page URLs on both hosts returned 200,
  expected metadata, query-free apex canonical/OG URLs, matching OG/X descriptions,
  the current image/alt text, correct icon/manifest links, and `Cache-Control:
  no-store`. Homepage JSON-LD identifies the correct site and URL.
- All seven public sharing/icon/manifest files returned 200 on both hosts and
  matched repository bytes by SHA-256. JPEG dimensions are 1200×630; PNG dimensions
  are 96/180/192/512; the ICO contains 16/32/48 frames. Image and manifest content
  types are correct; manifest HEAD also returned its JSON MIME type.
- Approved JPEG SHA-256:
  `20b2a4856916d8b9dbb231362bb44422f88ab5f27878a054c967bd26656aa20e`.
  Approved 96px favicon SHA-256:
  `5fec2721b00f757d26ae64c4cb5a944c0353ba2ad52f4f12bfc57f283701070c`.
- Live missing-event and V1 people URLs returned 404/noindex without social card
  metadata on both hosts. One actual published event on each host had the correct
  direct-page sharing metadata; its Turbo-frame response remained a fragment
  without document metadata or analytics. Failure/expiry behavior beyond these
  live checks is covered by local synthetic tests, not induced production faults.
- `/up` and root on both public hosts, members `/up` and `/session/new`, and the
  Two Rivers homepage returned 200. HTTP on both public hosts redirects with 301
  to the matching HTTPS hostname. DNS resolves both to `178.156.250.235`; hostname
  validation passed and the existing certificates expire December 26, 2026.

The live check kept response bodies in memory and did not save production page
or feed bodies. No production database/content export or data mutation occurred.
The approved image was rendered and reviewed locally at 320/240px before release;
live byte matching verifies delivery of that exact image. No new live browser
workflow session or third-party social debugger was used. Google icon selection,
external cached previews, and GA4 dashboard ingestion remain unverified.

## Protected services and connection discipline

The following IDs/revisions were unchanged before and after deployment:

| Service | Container | Revision |
| --- | --- | --- |
| Members | `8779249b9832` | `607e995f7654fb220a7996d5fe10caa131acee25` |
| Two Rivers Matters | `326c06aaf63a` | `37383fc06613731e6fed7b6ec9039c1eef3325cc` |

The shared proxy retained ID `6077fc6bb87e`, its June 30 start time, zero restarts,
and all three service routes. No companion deployment, DNS/mail edit, global
proxy replacement, or Sites publication occurred.

Exactly one `bin/release session` outer SSH master (PID `144962`) persisted from
the first inspection through build, deployment, and final verification. SSH,
Kamal/Net::SSH, and Docker/buildx all used its localhost:22222 forward. The original
master was checked alive at the end, then the session exited once. No reconnect,
parallel outer connection, or direct SSH fallback was used. Local cleanup was
checked after exit. Subsequent release-documentation commits do not change the
running runtime revision recorded above.
