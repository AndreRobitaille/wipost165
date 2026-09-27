# Authenticated publisher release — September 27, 2026

The owner authorized commit, push, and deployment of the current public website
work. Application revision `5d1533248e604de4b8690b7974be7103f1b3d7c7` was committed
and pushed to `origin/main`, then deployed to the public service. The configured
coming-soon page remains enabled; the full website has not been opened to visitors.

## Delivered

- Existing accepted visitor-page refinements, contact/visit content, and their
  review evidence are committed with the new integration.
- The client reads `legion_post_tools.website_token` from production encrypted
  credentials and authenticates JSON, images, and conditional requests.
- Portraits are served through the public application's constrained image route;
  no token is sent to visitors. Images and HTML use no-store browser responses.
- Private server caches are separated by credential and origin, retain the
  publisher's remaining five-minute budget, and clear access on 401.
- Kamal supplies this application's encryption key as a secret. The key remains
  ignored locally and is not present in the deployed image's filesystem.
- [The companion content prompt](../publisher-content-prompt.md) is ready for the
  owner to give the other session. No message was sent on the owner's behalf.

## Verification

`bin/ci` passed: 46 tests, 293 assertions, no failures/errors/skips; 41 Ruby files
linted; gem and JavaScript dependency audits clean; Brakeman had zero warnings or
errors; autoloading and production asset compilation passed. A test cleanup bug
in the new coming-soon portrait check was fixed before this passing run.

The actual client successfully read the live authenticated featured and upcoming
event collections locally and from inside the deployed container. Both collections
were empty. This verifies credentials, HTTPS transport, JSON shape, and private
cache compatibility; real story/portrait delivery remains unverified until content
exists. Unit/integration tests cover portrait authentication, bytes, private cache
expiry, browser no-store, restricted routes, credential isolation, and denial.

Local 1440px and 390px browser checks against that live feed showed the honest
empty home/calendar states, working navigation, and no phone horizontal overflow.
The temporary local server and browser were stopped afterward.

## Production operation

One `bin/release session` owned the outer SSH connection through inspection,
remote build, deployment, and final verification. No reconnect or direct SSH
fallback occurred. The session exited once after final checks.

Before release, the public container was `b1f32010efbf` at
`2828f88c4df71ac5e289b28b3055c1c408de5a10`. That revision is an ancestor of the
release and remains the rollback target. The new public container is
`c1fa7bbc7935` at `5d1533248e604de4b8690b7974be7103f1b3d7c7`.

Protected containers were identical before and after:

- Members: `1a32f8bbe5c5`, revision `1fce9bd9cc438b504faf7e9e09efaf0655dad74b`.
- Two Rivers: `085c9aab95a5`, revision `48cf3bbde3d5282666b9c1024d6b3855e824902b`.

The public apex and www proxy routes point to the new container with TLS.
Both HTTPS homepages and `/up` returned 200; ordinary DNS reads showed the
coming-soon heading and no-store; HTTP redirected to HTTPS. Members `/up` and
`/session/new` and the Two Rivers homepage returned 200. No companion deployment,
database write, mail change, DNS change, or token issuance occurred.

## Remaining work

The live publisher has no featured introductions or upcoming events. The three
fictional introductions created earlier remain in the local synthetic database;
they were not copied into production. The other session needs editorial authority
to create/publish them in the real workspace. A website read token cannot do that.

Opening the full public website requires changing `PUBLIC_SITE_COMING_SOON` and
releasing that configuration. Until then, publishing content in LegionPostTools
will not change the coming-soon page.
