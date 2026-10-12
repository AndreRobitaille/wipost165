# October 12, 2026 — PR #11 analytics and search release

PR #11 merged into `main` as `f218331c0269aad64aed5d2f9281cbb45dcfb2d8`.
Because `main` still predates the launched information pages and holds coming-soon
mode, that merge was integrated into the current release branch rather than
replacing production with the old main layout. PR #10 remains open for owner merge.

Production now runs `77f510219065cfc4fd5030ded7f21eaff546bdc9` from
`codex/public-page-content`, container `eea0bb0f6982`, started
`2026-10-12T16:30:16.637219678Z` (11:30 a.m. Central), with zero restarts at the
final check. Image digest:
`sha256:8b63494b631ef44208cf3226390d0145d1f8456a692aa361bfa60ebb1059fc63`.
The previous live revision `e2a88f2` and container `5b83e05396b5` remain stopped
and available for rollback. The V1/coming-soon/launch-ready/preview flags remain
`v1/0/1/0`; `GA4_MEASUREMENT_ID=G-KVBQMTBJYB` is a public configuration value.
No runtime secret was changed.

Integration kept Why the Legion's title and description, and added its URL to
the static sitemap. PR #11 supplies the other metadata, canonical URLs, GA4 tag,
robots and sitemap behavior. Open Graph/Twitter tags are removed as requested in
that PR. The approved site design and content remain in place.

## Evidence

- Integrated `bin/ci`: 91 Rails tests / 1,443 assertions and nine adapter tests
  passed, along with style/security, autoload and production assets. GitHub CI
  passed for the integration commit; `bin/release check` passed locally.
- Live publisher preflight verified six events and their details using V1's
  existing read-only website token.
- Live checks covered eight public pages on both apex and www: correct titles,
  descriptions and query-free apex canonicals; no social or verification meta
  tags; one asynchronous, low-priority Google loader and correct GA4 config.
- Both hosts' sitemap XML includes all eight static pages, including Why the
  Legion. Robots permits crawling and references the apex sitemap. `/up` and
  event-dialog fragments contain no analytics tag. V1 people paths remain 404.
- Browser verification found one initial GA4 config, one queued page view per
  Turbo navigation, and no extra page view/tag from opening an event dialog.
  Desktop and 390px layouts had no overflow; keyboard open/Escape close passed.
  The external analytics loader was blocked during this controlled check to avoid
  artificial analytics hits. GA4 Realtime ingestion was not inspected; tag and
  client queue behavior, not dashboard receipt, are the verified claims.
  No screenshots were taken.
- Public `/up` and root on both hosts, members `/up` and `/session/new`, and
  Two Rivers Matters root all returned 200.

Members container `b7afb4b84ad8`, revision
`baef0beec98566d199e1cc437c36eff162b93dd3`, and Two Rivers container `326c06aaf63a`,
revision `37383fc06613731e6fed7b6ec9039c1eef3325cc`, matched the pre-release
baseline. The proxy kept its June 30 start time and zero restarts. No DNS, mail,
companion database, other service deployment, or Sites preview was changed.

One outer SSH master (PID `826602`) persisted through preflight, build, deployment,
HTTP/browser checks and final server verification. SSH, Kamal and Docker all used
its localhost:22222 forward. The original master was confirmed alive at the end,
then the session exited once. Local process/port cleanup was verified afterward.
Subsequent documentation-only commits do not change the runtime revision above.
