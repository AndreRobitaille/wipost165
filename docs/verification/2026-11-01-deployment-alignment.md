# November 1, 2026 — local shared-host deployment alignment

This is local implementation evidence, not deployment authorization or a current
production-state claim. Work began on clean `master` at
`b36bea320d98844d17ee3d7406253c0e90899336`. Checks below were run against
uncommitted alignment changes before their authorized commit and push.

## Changes

- Copied the reconciled [shared deployment agreement](../SHARED_HOST_DEPLOYMENT.md)
  unchanged from TwoRiversReporter; linked it from AGENTS.md and DEPLOYMENT.md.
- Added the session-scoped `release_kamal` helper. It verifies the existing owned
  master, requires the generated session configuration, refuses configuration
  overrides and clears the signing-agent environment for its subprocess. Internal
  Kamal calls now use it. Routine deployment remains `release_deploy`; its Kamal
  call uses `--skip-push`, with the existing digest checks and publisher check.
- Added an executable pre-build refusal hook and removed production remote-builder
  selection from both the checked-in and generated Kamal configurations.
- Made image verification refuse a `KAMAL_VERSION` different from reviewed HEAD,
  so an arbitrary rollback version cannot pass by inspecting the candidate image.
- Updated current hosting/recovery guidance and retired the September arbitrary
  Kamal rollback snippet. Rollback needs reviewed clean source, compatible guarded
  tooling, exact-revision checks and a matching verified digest while retaining
  the operation's existing tunnel.

The public publisher client, V1/V2 behavior, credentials, Dockerfile, publication
script and database-free application behavior were not changed.

## Verification

`bundle install --jobs 1` installed the missing locked gems into the existing
ignored `vendor/bundle` path. Gemfile and Gemfile.lock were unchanged. Bundler
used temporary home directories because the sandbox cannot write the host home;
mise reshim/cache warnings did not block installation or the normal runner.

- `bin/rails test test/release_session_test.rb test/publish_image_test.rb` passed:
  15 tests, 125 assertions, no failures/errors/skips. These use the actual scripts
  and offline fake SSH/Kamal/registry commands, not production services.
- New cases cover generated tunnel configuration without a remote builder,
  signing-agent isolation, explicit configuration override refusal, lost-master
  refusal without reconnecting, offline executable pre-build refusal, and rollback
  revision mismatch before image inspection or boot. Existing cases retain
  pull-only deployment, final-pull image-change detection and one-master cleanup.
- `RUBOCOP_CACHE_ROOT=tmp/rubocop PARALLEL_WORKERS=1 bin/ci` passed: 55 Ruby files
  without offenses; gem/JS advisories and Brakeman clean; 112 Rails tests / 2,300
  assertions with no failures/errors/skips; autoload and production assets passed;
  10 Sites adapter tests passed. Two pre-existing publisher-check tests emitted
  missing-assertion notices without failing.
- `bin/release check` passed without SSH. `git diff --check` passed.
- All 13 relative links across the five changed operator/guidance documents
  resolved. The shared document matched the reconciled TwoRiversReporter copy.

Shared agreement SHA-256:
`aab8c3077ba38ff0cfd947c404e040c2e06cc93e6211fe52faf52f0d2728c95f`.

## Coordinator follow-up

`release_kamal` now changes to `APP_ROOT` in its subprocess before invoking
Kamal, preserving the application's hook/configuration context even after an
operator changes directory. The helper regression now calls it from `/` and
asserts the actual working directory observed by the fake Kamal process.

The release shell starts without inherited `SHELLOPTS`/`BASHOPTS`, disables
`errexit`, unsets `PROMPT_COMMAND` and directs `HISTFILE` to `/dev/null`. An offline
test injects exit-on-error, a prompt command that would terminate the shell and
an operator history file. A failed command retains the same session, the prompt
command does not run, the original history file is unchanged and one owned
master closes once on exit.

After this follow-up, the normal focused test command passed 16 tests / 134
assertions, with no failures/errors/skips. Focused RuboCop, `bin/release check`
and `git diff --check` passed. The full CI result above predates these bounded
Bash/test changes and was not repeated. The shared agreement hash is unchanged.

## Limits and deferred gaps

No production SSH, Docker/registry operation, CI dispatch, live publisher read,
publication, commit, push, merge or deployment occurred. No host permissions or
production data were changed. No live rollback or same-session checkout recovery
was rehearsed; compatible rollback tooling/configuration still requires review
before an authorized operation.

Exact-head normal CI, clean publication checkout, cross-app serialization,
capacity assessment, rollback readiness and richer live image/proxy/content/TLS
checks remain operator duties. This pass adds no global deployment lock or
capacity thresholds and does not change publication checks or isolated-build
Docker-context handling. The application still has no database or worker;
publisher data and backup/restore remain with LegionPostTools.
