# September 27, 2026 coming-soon release status

## Outcome

Prepared and pushed on `codex/public-coming-soon`; **not deployed**. Runtime and
transport revision: `1f5af582c9b23b076ba3bd8a2e9649dc904c80b5`. The final subsequent
commit records this status and operator guidance only.

`bin/release check` passed using the owned SSH master, localhost port 22222,
socat routing, configured file key, and remote Kamal hostname probe. Net::SSH
initially contacted the unavailable desktop agent despite keys_only; unsetting
SSH_AUTH_SOCK fixed that. The duplicate ControlMaster option was also fixed.

The first setup attempt stalled while establishing the outer SSH master. It was
stopped before build/provisioning. After a cooldown, one controlled retry failed:
`ssh: connect to host 178.156.250.235 port 22: Connection timed out`.
No application deployment, proxy-route change, certificate issuance, database
operation, DNS edit, or email test was performed. No SSH tunnel remains open.

## Verified

- Exact isolated release checkout: CI passed; 32 tests, 194 assertions, zero
  failures/errors/skips; 38 Ruby files linted; gem/JS audits and Brakeman clean;
  autoload validation and production assets passed.
- Coming-soon page inspected at 1365x900 and 390x844; no horizontal overflow;
  keyboard focus reaches the members link. No publishing requests in this mode.
- Before release: public container/route absent; kamal-proxy v0.9.2 served only
  members.wipost165.org and tworiversmatters.com with TLS.
- Protected live revisions observed: members
  `9d278b7ce449ea54d60b151b32f6e23cac97eacf`; Two Rivers
  `48cf3bbde3d5282666b9c1024d6b3855e824902b`.
- Final direct-to-Hetzner HTTPS checks at approximately 10:29 CDT: members `/up`
  and `/session/new` both 200, certificate expires December 9, 2026; Two Rivers
  root 200, certificate expires November 4, 2026. Public apex and www still fail
  TLS negotiation. Final container revisions could not be re-read after SSH
  stopped responding, but no deployment action reached the server.
- Google and Cloudflare DNS returned apex 178.156.250.235; www is the existing
  apex CNAME. No AAAA or CAA conflicts were returned. Direct local DNS queries
  still returned the old address; authoritative queries attempted from Hetzner
  timed out. Do not claim all caches or authoritative views were reconciled.
- Public MX is `0 mail.wipost165.org`; mail, ftp, cpcontacts, cpcalendars, cpanel,
  and webmail A records point to 104.225.208.23. SPF is
  `v=spf1 mx ip4:104.225.208.23 ~all`; the four SRV targets show the requested
  cpcontacts/cpcalendars separation. No zone records were changed in this session.
  Local Mail Exchanger and a complete cPanel zone inventory were not re-inspected.

## Resume

The clean release checkout is `/tmp/wipost165-coming-soon`; it is also pushed to
origin. Preserve the original development checkout's unrelated work. The unique
public-app key is in ignored, mode-0600
`/home/andre/Development/wipost165/.env.production.local`. Do not display it.

After SSH access recovers, read `docs/DEPLOYMENT.md`, export that file's key and a
GHCR-capable registry token, and run `bin/release session` from the clean release branch. Run `release_setup`
inside that shell and retain it through all verification and any diagnosis.
Standalone setup/deploy commands are now disabled.
On this workstation, use
`BUNDLE_PATH=/home/andre/Development/wipost165/vendor/bundle` for the isolated
checkout's already-installed gems. Use host access outside the sandbox.

Complete the remote build/container boot, apex and www routes, Let's Encrypt
issuance, direct hostname-preserving HTTPS and browser checks, unchanged protected
service revisions, public DNS checks, and tunnel cleanup. Do not change DNS or
NixiHost mail as a workaround for SSH. Deployment authorization remains given;
no additional permission ceremony is required to resume the agreed coming-soon
release. Unsigned release commits were explicitly authorized for this task only.
