# October 28, 2026 — Service Officer phone label

Andre approved PR #24, "Label Veteran help phone as Service Officer", to go live.
It was squash-merged as `c257c1a1d3ba641792c7e0c2234e85a53ef4a998`. Release
completed at approximately 12:19 p.m. Central. Both https://wipost165.org and
https://www.wipost165.org serve that revision.

## Release identity

- Source: `c257c1a1d3ba641792c7e0c2234e85a53ef4a998` on `master`.
- Previous live source: `ba801ff6f54512a8546cbf4f5f391f0ab544e4e4`, container
  `687ed964af74`, running as
  `legion_post_165_wi_public-web-ba801ff6f54512a8546cbf4f5f391f0ab544e4e4`
  before this deploy. Kamal stopped that container during replacement.
- Public container: `895a2df36958`, running as
  `legion_post_165_wi_public-web-c257c1a1d3ba641792c7e0c2234e85a53ef4a998`.
- Image: `ghcr.io/andrerobitaille/legion-post-165-wi-public:c257c1a1d3ba641792c7e0c2234e85a53ef4a998`.
- Public flags remained `v1/0/1/0` for edition/coming-soon/launch-ready/preview.
  Public GA4 ID remained `G-KVBQMTBJYB`. Existing credentials were retained.

## Scope and checks

The release changes the Veteran help phone link for `(920) 860-7478` to "Call
our Service Officer". It does not change the post phone, the 988 line, the
membership email, or the absence of a phone link on Membership and Contact.

- `bin/release check` passed with no SSH connection. `bin/release push` reported
  the branch already up to date and verified GitHub at the same SHA. A local
  `gh auth git-credential store` helper printed a missing-binary path and did
  not change the verified result.
- The authenticated read-only V1 publisher check verified 4 events in the next
  90 days before deployment.
- Kamal built on the existing remote builder and reported success in 30.6
  seconds. The public proxy target changed from `687ed964af74:80` to
  `895a2df36958:80`.
- `release_verify` returned 200 for `/up` and `/` on both public hostnames,
  members `/up` and `/session/new`, and the Two Rivers homepage.
- Outside the tunnel, public DNS for both hostnames is `178.156.250.235`.
  Pinned and ordinary HTTPS reads of the three pages below returned 200 and
  differed only by the per-response CSRF token.
- https://wipost165.org/veteran-help contains one
  `href="tel:9208607478"` link whose text is "Call our Service Officer" and
  "(920) 860-7478". It does not contain "Call the Post". `tel:9206834055` and
  `tel:988` are still present.
- https://wipost165.org/membership contains `mailto:wipost165@gmail.com`, no
  `860-7478`, and no `href="tel:`.
- https://wipost165.org/contact contains no `860-7478`.

## Protected services and connection discipline

These containers were unchanged before and after deployment:

| Service | Container | Revision |
| --- | --- | --- |
| Members | `6230f0ec6627` | `524ec571739a61c1cb78e17ee620e554f2f186b2` |
| Two Rivers Matters | `0023473a77b6` | `d3f26a00abbd45ed682e90d14ff8a5d46595e4ce` |

Their proxy routes stayed on those same targets. This operation did not restart
or redeploy those services, replace kamal-proxy, or change DNS.

One `bin/release session` outer SSH master (PID `1061647`) persisted from the
first inspection through build, deployment, and `release_verify`. SSH,
Kamal/Net::SSH, and Docker/buildx used its localhost:22222 forward. The session
exited once. After exit, that PID was gone, port 22222 was not listening, and
the release control socket and temporary directory were removed. No second
outer connection was opened. The merged branch
`cursor/veteran-help-service-officer-label-dad0` was deleted after verification.
This record does not change the running revision above.
