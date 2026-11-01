# November 1, 2026 — off-server build and contact release

Andre authorized off-server builds, commit, push, merge, deployment, live checks,
and closure of #8 if successful. The release completed around 10:20 a.m. Central;
final verification passed and #8 closed as completed at 10:22 a.m.

## Identity and build evidence

- Running source: `9d4095c0ecfbee76773097600750738e0a238540`, on both
  https://wipost165.org and https://www.wipost165.org.
- Public container: `40090524ff17`, replacing `895a2df36958` at
  `c257c1a1d3ba641792c7e0c2234e85a53ef4a998`.
- Repository: `ghcr.io/andrerobitaille/legion-post-165-wi-public`.
- Registry digest: `sha256:8db566ab2f538acf5f47528488897902c1a38797b7b84987b8fafadcca044479`.
  Running image identity and revision labels match the published Actions artifact.
- [PR #29](https://github.com/AndreRobitaille/wipost165/pull/29) adds the isolated
  production build and guarded deployment. [PR #30](https://github.com/AndreRobitaille/wipost165/pull/30)
  decompresses the verified archive for crane, validated against a real artifact.
- [Exact master CI](https://github.com/AndreRobitaille/wipost165/actions/runs/41325495070)
  and [production image build/startup checks](https://github.com/AndreRobitaille/wipost165/actions/runs/41325495073)
  passed. Full local CI passed 106 Rails tests / 2,263 assertions and 10 adapter tests.
- The isolated GitHub Actions BuildKit cgroup peaked at 652,988,416 bytes
  (about 623 MiB), with zero OOM or OOM-kill events, under a 1,536 MiB cap.
  CI exercised both contact editions, compiled assets, health and real
  entrypoint/Thruster startup with no network or production credentials.
- The VPS only pulled the image. Both digest checks passed and Kamal deployed
  with `--skip-push` in 12.8 seconds. No on-server build or cap change occurred.
  The existing builder retains memory/swap limits of 1,610,612,736 bytes each.
  Before replacement the VPS had 1,602 MiB available and zero current memory
  pressure averages; afterward it had 1,607 MiB available.

The release includes PR #26's dependency repair and PR #27's Membership/Contact
email-disabled fallback. The running container reports Rack 3.2.8, Bootsnap 1.26.1
and msgpack 1.8.7. PR #28's single-job Bundler install remains in the Dockerfile.

## Behavior checked

- The authenticated read-only V1 publisher preflight verified four upcoming
  events and their details. No production content or private data was copied.
- On both hostnames, eight public pages returned 200, with titles/descriptions,
  indexable metadata and query-free apex canonical/sharing URLs. Health,
  robots/sitemap and the V1 people-route 404/noindex guard passed.
- Ordinary public DNS and HTTPS reached `178.156.250.235` for both names;
  certificate validation passed and HTTP redirected to HTTPS with 301 responses.
- Chromium on the execution host checked Membership, Contact and Veteran help
  at 320, 390 and 1440 pixels: readable layouts, no horizontal overflow, working
  email actions and no Service Officer phone on Membership/Contact. Mobile and
  desktop screenshots were inspected. Keyboard focus had a visible outline;
  the meeting-visit action and event dialog load/close/focus restoration passed.
  No browser errors were recorded.
- An isolated instance of the deployed image on the VPS, with network disabled,
  a dummy Rails secret and a 512 MiB limit, passed all 12 synthetic V1/V2 contact
  cases. Email-disabled Membership has no empty enquiry section, Contact uses
  postal fallback, and Veteran help retains the Service Officer phone. Health,
  compiled stylesheet delivery and the V1 people guard passed too.
- [Issue #8](https://github.com/AndreRobitaille/wipost165/issues/8) is closed as
  completed. The joining guide and fallback repair are live; the owner's dues
  omission remains. #5 and #6 retain later improvements and V2 work respectively.

## Protected services and transport

These containers, revisions and proxy targets were unchanged across the public
deployment and final checks:

| Service | Container | Revision |
| --- | --- | --- |
| Members | `f4bd97b99fc3` | `846cacfb77bc7590766274c46a7fbbe12ccfc096` |
| Two Rivers | `9486d1778b4e` | `6eff977218a25f9ebe3937bc15daab0cdaaa1cd6` |

Members `/up` and `/session/new`, and the Two Rivers homepage returned 200.
The shared proxy stayed `6077fc6bb87e`, `basecamp/kamal-proxy:v0.9.2`.
Before this public deployment, an independent members release changed the earlier
observed `fd5d21894cf1` / `879e2e8` baseline while this operation was waiting on
build work. Both observations were retained, and the fresh baseline above was
recorded before replacement. This operation did not change the adjacent services,
databases, DNS/mail or Sites previews.

One outer release connection, SSH master PID `371553` on localhost port `22224`,
persisted from first inspection through final verification. The already-open shell
loaded the tested image functions without replacing the tunnel. It exited once;
the owned master, forward, control socket and temporary release directory are gone.
An unrelated PID `368120` / port `22222` had been present initially and was absent
at final inspection; no control or cleanup command targeted that connection.

Operational evidence, logs and screenshots are retained locally in
`/tmp/wipost165-release-20261101/`; build evidence is also in the linked Actions run.
The original dirty development checkout was preserved. This documentation update
does not redeploy or change the running revision above.
