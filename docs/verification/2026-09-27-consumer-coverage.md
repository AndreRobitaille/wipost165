# SITE-04 consumer coverage review — September 27, 2026

Consumer evidence review complete; overall SITE-04 remains open for companion
evidence. Reviewed local `main` at `c7b716e` plus the existing development-startup
and planning changes. The fix and tests below are uncommitted working-tree changes.
Ruby 4.0.6 / Rails 8.1.3.1, database-free test environment. No production request,
editorial mutation, companion checkout change, commit, push, or deployment was
performed. Existing authenticated live-read and browser evidence was reused.

## Finding and local repair

The client accepted a `304 Not Modified` with a different ETag from the validator
it sent. It merged that new validator with the old cached body and extended its
freshness. A missing ETag was also accepted. The contract requires revalidation of
the corresponding stored representation and validator.

The [client](../../app/services/publishing/client.rb) now rejects a missing or
mismatched 304 ETag as unavailable, preserving the expired cache without renewing
it. Weak/strong forms of the same validator compare successfully. A later valid
200 response can replace the old body. This uses the existing failure/backoff path.
No authentication, publication, freshness-budget, or browser behavior was broadened.

The regression failed before the fix with “Publishing::Unavailable expected but
nothing was raised,” and passed afterward. Seven tests were added: two validator
cases and five consumer lifecycle scenarios. The old interval test covered separate
query caches, but did not prove replacement of the same populated interval; the
new move scenario closes that gap.

## Evidence matrix

“Covered locally” means simulated publisher output and consumer assertions, not
proof that the publisher produces that output after an editorial action.

| Requirement | Evidence | Status / owner / limit |
| --- | --- | --- |
| Server-side token on JSON, images, and conditional requests; isolation between credentials; missing/malformed token and 401 handling | [Client tests](../../test/services/publishing_client_test.rb), [portrait integration](../../test/integration/portraits_test.rb), [page integration](../../test/integration/public_site_test.rb) | Covered locally, public app. Publisher rejection of missing/invalid/revoked credentials and role enforcement still need companion evidence. |
| Private cache policy, Date/Age/network/resident time, total 300-second ceiling, no stale-on-error extension | Client tests: fresh cache, Age, network delay, invalid metadata, portrait expiry; page integration: expiry during another section's fetch | Covered locally, public app. Publisher's own age accounting remains its responsibility. |
| 304 matching, date and age metadata, stale-body replacement | Client tests including new missing/different ETag rejection, recovery by 200, and weak validator match | Gap repaired locally. No new live conditional-request evidence claimed. |
| Story rotation preserves published detail | [Lifecycle tests](../../test/services/publishing_lifecycle_test.rb); page integration renders unfeatured profiles | Covered locally. Publisher rotation/publication semantics await CP-02. |
| Updated story/portrait after obsolete image response; collection and detail eviction | Lifecycle replacement test; client obsolete-portrait and withdrawal tests; portrait integration 404/no-store | Covered locally. Browser image failure uses the existing neutral fallback; automatic one-time story retry remains optional and unimplemented. Real consent/replacement enforcement awaits CP-02. |
| Event moves replace a previously populated interval; omission does not globally withdraw detail | Lifecycle move test replaces October with empty output, accepts the same ID in November, and still reads its detail | Newly covered locally. Actual publisher rescheduling and populated event output await CP-03. |
| Cancellation replaces active detail; subsequent 404 evicts a still-fresh interval | Lifecycle cancellation/withdrawal test; page integration displays cancelled all-day dates and removes the visit action | Newly covered locally. Source-event actions and publication restrictions await CP-03. |
| Point events, null/equal ends, all-day dates, exclusive ends, DST and interval boundaries, ordering/duplicate IDs | Client date/ordering tests, new equal-end lower/upper boundary test, page integration all-day display | Covered locally for these cases; not exhaustive calendar fuzzing. Publisher query semantics await CP-03. |
| Malformed/incomplete data, redirects, errors, identity mismatches; honest empty/unavailable presentation | Client validation/error tests and page integration empty/outage tests | Covered locally. Transport socket timeout/body-size limits were read, not newly exercised at the network layer. |
| Zero to three stories; escaped authored text; static routes during outages; no browser token or publisher image URL; no-store/Turbo cache behavior | Page and portrait integration suites; [existing visitor-path QA](../design/2026-09-visitor-paths/README.md#verification) | Covered locally with prior browser evidence; no layout changed or browser rerun in this task. |
| Coming-soon prevents content/portrait reads; static preview cannot be enabled by query parameter | [Coming-soon tests](../../test/integration/coming_soon_test.rb), portrait and page integration | Covered locally. Full-site indexing/sharing preparation remains SITE-05. |
| Real authenticated collections, story details, image bytes, desktop/phone rendering | [Populated-feed follow-up](../deployment/2026-09-27-authenticated-publisher-release.md#populated-feed-follow-up) | Recorded production-publisher reads from public checkout `c7b716e`: three fictional stories, six portraits, zero events in 90 days. No fresh production check in this task; publisher revision was not independently captured in that follow-up. |
| Editorial permissions, published snapshots, private-field exclusion, consent, restrictions, concurrent publication and cancellation | [Companion queue CP-01/02/03](../companion-work-queue.md#remaining-evidence-handback) | Awaiting companion evidence. Consumer tests and website-token reads cannot establish these properties. |

## Verification results

- Before fix: focused suite, 30 tests / 117 assertions, one failure reproducing
  acceptance of a mismatched 304 validator.
- After fix: `bin/rails test test/services/publishing_client_test.rb test/services/publishing_lifecycle_test.rb`
  passed: 30 tests / 124 assertions.
- `bin/ci` passed: 42 Ruby files linted, dependency audits clean, Brakeman zero
  warnings/errors, 53 tests / 333 assertions, autoloading and production assets.
  The parallel test run emitted Bundler temporary-home cleanup errors because
  forked processes shared its sandbox fallback directory. Tests reported no failures.
- `PARALLEL_WORKERS=1 bin/rails test` passed cleanly: 53 tests / 333 assertions,
  zero failures/errors/skips. No app or test-runner configuration was changed to
  accommodate this environment issue.
- `bin/rails assets:clobber` removed generated build assets afterward so they do
  not mask the owner's development assets. No server was stopped or restarted.
- Simplify review kept the focused validator check and scenario tests; no additional
  abstraction was needed. Documentation file links and `git diff --check` passed.

## Remaining handback and next independent task

The [companion brief](../companion-work-queue.md#brief-to-give-a-companion-session)
requests existing local/test results for permission/eligibility restrictions,
story/portrait transitions, and event lifecycle behavior, with tested revision,
environment, deployment applicability, and unverified cases. No personal token
needs to be supplied to this app, and no production mutation exercise is required.
No message was sent. These remain launch evidence dependencies, not reasons to
stop independent technical work or mark SITE-04 fully complete.

Next: SITE-05 metadata/indexing readiness using fictional content. Static inspection
found that the layout supplies a generic description but no canonical or social
sharing metadata, and noindex is tied to static preview mode. Review how to keep
live-feed fictional content out of indexing and shared previews during development,
while preparing correct full-site titles, canonical hostname, and sharing behavior.
This task did not implement or verify those changes. Continue phone/desktop/link
and container/release preparation afterward; real people/photos remain the final
content step before release.
