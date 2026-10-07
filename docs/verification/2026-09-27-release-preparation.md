# Full-site release preparation — September 27, 2026

This is a prepared procedure, not release authorization or a production-state
claim. Current local code is `c7b716e` plus uncommitted changes. The last recorded
public deployment is `5d1533248e604de4b8690b7974be7103f1b3d7c7` in coming-soon mode;
inspect the live revision before selecting the next release base or rollback target.

## Local status and remaining gates

- Latest application CI: 63 tests / 567 assertions, style/security checks,
  autoloading, and production assets passed in the metadata task.
- `bin/release check` and entrypoint shell syntax passed in this task. The local
  release check opened no SSH connection.
- Dockerfile uses Ruby 4.0.6, production asset compilation, an unprivileged runtime
  user, and a database-free entrypoint. `.dockerignore` excludes environment files,
  Rails keys, local bundles, logs, generated assets, and documentation. This is
  static inspection, not image-build evidence.
- **Container verification blocked by local access:** the explicit local socket
  `unix:///var/run/docker.sock` returned permission denied, including after a
  sandbox escalation request. `sudo -n` requires a password. No permissions were
  changed, no daemon was started, and no remote builder was used. These are OS
  access failures, not a Dockerfile or application failure. Enable local Docker
  access or have an authorized local operator perform the checks below.
- SITE-04 publisher permission, consent, publication, and event-transition evidence
  still needs the companion handback. Consumer fixtures are not that evidence.
- Real people/photos and withdrawal of fictional records remain the final content
  step, after technical readiness. The current full site is not launch-approved.

## Pending local container check

Run from a reviewed local checkout with access to the **local** Docker daemon.
The following commands have not been executed successfully here. They do not
push, use Kamal, contact the production host, or provide actual credentials.
Build uses the Dockerfile's normal package downloads; the smoke container has
no external network. Use a unique task-owned image/container name and preserve
all unrelated containers/images. Do not prune Docker.

```sh
docker --host unix:///var/run/docker.sock build --builder default --load -t post165-local-check:review .
docker --host unix:///var/run/docker.sock run --detach --network none \
  --name post165-local-check-review \
  -e SECRET_KEY_BASE_DUMMY=1 -e PUBLIC_SITE_COMING_SOON=1 \
  -e PUBLIC_SITE_LAUNCH_READY=0 post165-local-check:review
```

Wait for readiness with a bounded retry of the following local-container request:

```sh
docker --host unix:///var/run/docker.sock exec post165-local-check-review \
  curl --fail --silent --show-error -H 'Host: wipost165.org' http://127.0.0.1/up
docker --host unix:///var/run/docker.sock exec post165-local-check-review \
  curl --fail --silent --show-error -i -H 'Host: www.wipost165.org' http://127.0.0.1/
```

Confirm 200, the coming-soon heading, no-store, and noindex, with no feed access.
Check `/people/example` also shows only coming-soon and the portrait route returns
404. Inspect only file existence/permissions: Rails UID is 1000, no `.env*` or
`config/master.key` or `config/credentials/*.key` was copied, and production assets
are present/readable. Do not print encrypted credential contents or host secrets.

Then remove only that task-owned container and run the same image with
`PUBLIC_SITE_COMING_SOON=0`, `PUBLIC_SITE_LAUNCH_READY=1`,
`PUBLISHER_ORIGIN=https://127.0.0.1:1`, and
`PUBLISHER_TOKEN=container-verification-only`, still with `--network none` and a
dummy secret. This deliberately unavailable local publisher requires no real token.
Check `/up`, static visit/contact pages and their assets return 200, with correct
apex canonical URLs on both Host values. The calendar must show unavailable rather
than empty; unknown person/event details and portraits should be unavailable (503),
not fabricated records. Confirm no-store and error noindex headers. Record image
ID, architecture, commands/results, and limitations before marking this gate done.

Clean up only the task-owned container and tag:

```sh
docker --host unix:///var/run/docker.sock rm -f post165-local-check-review
docker --host unix:///var/run/docker.sock image rm post165-local-check:review
```

## Final content and release candidate

After technical checks and companion evidence are resolved:

1. The authorized companion publisher enters/approves real content or the owner
   chooses an honest empty state. Withdraw fictional records, including direct
   story/portrait availability; removing featured placement alone is insufficient.
2. Verify the final feed read-only, then recheck affected page copy/crops. This is
   the final content step, not a reason to restart unrelated design work.
3. Prepare the reviewed release candidate with coming-soon `0` and launch-ready
   `1`, preserving preview `0`. Run required checks for that candidate and obtain
   authorization covering commit, push, and deployment. Do not bulk-stage the
   current dirty checkout or infer deployment permission from this document.
4. Follow [DEPLOYMENT](../DEPLOYMENT.md). After authorized commit/push, open exactly
   one `bin/release session` and retain it through inspection, deploy, and final
   verification. Record the running public revision/container and protected
   services; confirm the rollback container/image are retained before deploying.
   Run `release_deploy` and the content/header checks below in that same session.

## Verification within the one release session

`release_verify` checks the new container against local HEAD, health of both
public domains, and unchanged members/Two Rivers containers. In addition, check:

- Both HTTPS domains serve the full site and approved content or honest empty
  states; there are no fictional pages or portraits remaining by direct URL.
- Static/profile/event titles and descriptions, apex canonicals, and query-free
  sharing URLs are correct. Successful ready pages have no noindex directive;
  missing/unavailable pages do. Dynamic pages/images retain no-store.
- `bin/publisher-check` succeeds for the configured feed; distinguish its returned
  content checks from the still-required companion permission/lifecycle evidence.
- TLS, HTTP-to-HTTPS behavior, public DNS, and protected members/Two Rivers health
  match the deployment guide. No mail or DNS changes are part of this release.

## Prepared rollback procedure — do not run without release authorization

Record the pre-release public revision from live inspection; do not substitute
`main`, an old note, or the historical `5d15332` without checking. Rollback requires
that version's container/image to remain available. The installed Kamal 2.12 code
checks for the old container before rollback, then boots its image using the
supplied configuration. Therefore prepare a holding-mode copy of the **session's
generated configuration**, preserving its tunnel settings:

```sh
# Inside the same still-open bin/release session; set this from its live inspection.
rollback_version='<verified-pre-release-public-revision>'
rollback_config="$release_temp_dir/rollback.yml"
ruby -ryaml -e '
  config = YAML.safe_load_file(ARGV[0], aliases: true)
  config.fetch("env").fetch("clear")["PUBLIC_SITE_COMING_SOON"] = "1"
  config.fetch("env").fetch("clear")["PUBLIC_SITE_LAUNCH_READY"] = "0"
  File.write(ARGV[1], YAML.dump(config))
' "$release_temp_config" "$rollback_config"
bin/kamal rollback "$rollback_version" -c "$rollback_config"
```

This affects only the public service and retains the operation's outer tunnel.
If that candidate is absent, stop and diagnose in the same session; do not pick
another image, reconnect, or use a direct transport automatically. The rollback
command is prepared from installed Kamal source, not production-tested here.

After rollback, manually verify the public container name/revision equals the
selected rollback version, both domains show coming-soon, `/up` responds, and the
members/Two Rivers container IDs and health match the session's before snapshot.
Do not use `release_verify` as proof of rollback: it deliberately expects local
HEAD, which differs from an older rollback version. Record the actual restored
revision and close the owned tunnel once after all checks finish.
