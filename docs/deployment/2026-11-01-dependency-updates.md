# November 1, 2026 — dependency updates

Andre authorized reviewing and fixing the five remaining dependency PRs, merging
after CI passes, deployment and live checks. All five are merged and deployed.
This follows the earlier [off-server/contact release](2026-11-01-off-server-contact-release.md).

## Source and image

- Running source on apex/www: `71010d990acab468b18cd948860652c0f17e879d`.
- New public container: `368c0c24b339`.
- Previous public source/container: `9d4095c0ecfbee76773097600750738e0a238540` /
  `40090524ff17`.
- Image: `ghcr.io/andrerobitaille/legion-post-165-wi-public`.
- Digest: `sha256:782c4eea781a4a1e8cd8d08d3299a783bc3650618267e21bca7f1cccf2a2c49b`.
  Running image digest and revision labels matched the published artifact.
- [Final master CI](https://github.com/AndreRobitaille/wipost165/actions/runs/41346479362)
  and [off-server production image build](https://github.com/AndreRobitaille/wipost165/actions/runs/41346479353)
  passed. The source tree matches the combined local CI run: 108 Rails tests /
  2,274 assertions and 10 adapter tests, with no security warnings or known
  dependency vulnerabilities reported by the checks.
- BuildKit peaked at 652,550,144 bytes (about 622 MiB), with zero OOM events.
  CI smoke-tested the real production entrypoint/Thruster and compiled assets.
- Both digest checks passed; Kamal's pull-only deployment took 12.6 seconds.
  No build ran on the VPS. Its existing builder memory/swap limits remain
  1,610,612,736 bytes each. Available memory was 1,361 MiB before deployment and
  1,301 MiB at the post-deployment snapshot, with zero current pressure averages.

## Reviewed changes

| PR | Result |
| --- | --- |
| [#13](https://github.com/AndreRobitaille/wipost165/pull/13) | setup-node v7; Node 22 remains selected for adapter tests. |
| [#14](https://github.com/AndreRobitaille/wipost165/pull/14) | checkout v7 in application CI and the newer production-image workflow; image checkout retains `persist-credentials: false`. |
| [#16](https://github.com/AndreRobitaille/wipost165/pull/16) | Brakeman 8.1.0; scanner passed without warnings. |
| [#17](https://github.com/AndreRobitaille/wipost165/pull/17) | net-http 0.10.0 and URI 1.1.2, plus the response-framing compatibility repair below. |
| [#18](https://github.com/AndreRobitaille/wipost165/pull/18) | Thruster 0.1.27, verified through actual image startup and live requests. |

Each PR was updated against the successive master base and merged only after its
fresh required application/image checks passed. The two action-only/updated
workflow cases were checked on GitHub's actual runners, not simulated locally.
Upstream review used the maintainers' [setup-node](https://github.com/actions/setup-node/releases/tag/v7.0.0),
[checkout](https://github.com/actions/checkout/releases/tag/v7.0.0),
[Brakeman](https://github.com/presidentbeef/brakeman/releases/tag/v8.1.0),
[net-http](https://github.com/ruby/net-http/releases/tag/v0.10.0) and
[Thruster](https://github.com/basecamp/thruster/blob/v0.1.27/CHANGELOG.md) notes.

The stricter HTTP parser raises `Net::HTTPHeaderSyntaxError` for invalid
Content-Length fields. The transport previously let that exception escape.
A real loopback response with conflicting lengths reproduced the uncaught error.
PR #17 adds that specific exception to the existing unavailability conversion.
Socket tests cover valid authenticated responses and conflicting, invalid and
empty lengths. Invalid framing now follows the existing publishing-unavailable
path; malformed content is never accepted as a successful response.

## Production verification

- The authenticated read-only publisher preflight, using the new HTTP client,
  verified four upcoming events and their details.
- The running container reports net-http 0.10.0, URI 1.1.2 and Thruster 0.1.27.
  Rack 3.2.8, Bootsnap 1.26.1 and msgpack 1.8.7 remain installed.
- An isolated copy of the deployed image, with network disabled, a dummy Rails
  secret and a 512 MiB limit, passed 12 V1/V2 email-enabled/disabled contact cases,
  health, compiled CSS and the V1 people guard. A synthetic loopback response
  also confirmed malformed framing becomes `Publishing::Unavailable` in that
  exact image. No production credentials or private data were supplied.
- Both hostnames passed eight-page HTTP/title/description/canonical/share checks,
  health, robots/sitemap and V1 people 404/noindex guards. Ordinary DNS and HTTPS
  reached `178.156.250.235`, certificate validation passed, and HTTP redirected
  to HTTPS.
- Headless Chromium on `andreG7linux` checked Membership, Contact and Veteran help
  at 320, 390 and 1440 pixels. No horizontal overflow or browser errors occurred.
  Screenshots were inspected. Visible keyboard focus, the meeting-visit link and
  real event dialog loading/closing/focus restoration passed.

## Protected services and connection

These containers, revisions and proxy targets were unchanged across this release:

| Service | Container | Revision |
| --- | --- | --- |
| Members | `f4bd97b99fc3` | `846cacfb77bc7590766274c46a7fbbe12ccfc096` |
| Two Rivers | `5b1e2d144429` | `0435ac891b3a281b5d9776a4f74e26382e9014ba` |

Members health/sign-in and the Two Rivers homepage returned 200. The shared proxy
remained `6077fc6bb87e`, `basecamp/kamal-proxy:v0.9.2`. No adjacent service,
database, DNS/mail or Sites preview was changed by this operation.

One outer SSH master, PID `879514`, retained port `22222` from first inspection
through final verification. The session exited once. The owned process, local
forward, control socket and `/tmp/post165-public-release.YmlMlA` directory are
gone. No reconnect or direct fallback was used.

Logs, snapshots and screenshots are retained in
`tmp/dependency-release-20261101/` in the main development checkout. This
documentation update does not change the running revision or require redeployment.
