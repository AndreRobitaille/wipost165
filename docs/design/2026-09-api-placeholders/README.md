# Fictional API placeholder introductions

September 27, 2026. The owner requested three generated images and placeholder
content through the editorial API while website development continues.

## Saved content

- [Avery portrait](avery.png)
- [Morgan portrait](morgan.png)
- [Sam portrait](sam.png)
- [Authored plain-text fields](content.json)
- [Exact image prompts](prompts.json), generated with the built-in imagegen tool

Each profile explicitly says it is fictional, and each portrait alternative names
its AI-generated origin. No actual member, service history, office, event, or
attendance commitment is represented. Real introductions must use new publication
identities and their own consent; do not repurpose these fictional identities.

## API state

Environment: existing dedicated LegionPostTools synthetic preview at
`http://localhost:3105`, installation `Synthetic publisher demonstration`.
Authenticated as the synthetic editor using its documented magic-link flow.
Read the current permission-filtered `GET /api` before writes. No bearer token
was created and no production request was made.

| Profile | Internal id | Public id | State at readback |
| --- | --- | --- | --- |
| Avery | 5 | `0030ee4e049913776108f83c8f08b206` | published, version 5, featured 1 |
| Morgan | 6 | `fdd83065d07dcb526b0a17db1e135a57` | published, version 5, featured 2 |
| Sam | 7 | `fa1b6423be23499f057072708d06bb01` | published, version 5, featured 3 |

All content was saved using `POST /api/website_publications`, `PATCH /:id`, and
`POST /:id/portrait` with session CSRF and the last returned publication version.
Existing demonstration stories and events were preserved. Homepage placement now
selects these three instead of the earlier blue-card demonstration story; that
earlier story remains published at its own URL.

## Verification and next action

Read back all three drafts and their audit histories. Each has creation and two
draft-save entries. Inspected both returned portrait renditions for all three:
320×400 and 640×800 WebP, successful decoding, intact faces and framing, and
`Cache-Control: no-store`. See [crop review](crop-review.png).

The owner explicitly approved synthetic-only consent, local publication, and
homepage placement after the initial automatic approval review required that
authorization. Re-read the current `/api` handbook and unchanged drafts/versions,
recorded synthetic-only consent, re-read coverage, published each snapshot, then
obtained the complete featured versions and replaced the order with Avery, Morgan,
and Sam. No real person's consent is asserted by this demonstration record.

Verified all three final records have exact-draft consent, published status, and
positions 1–3. Each audit contains `consent_confirmed`, `published`, and
`featured_order`. Anonymous featured collection and all three details return 200
with matching content; the feed advertises `max-age=300, public, must-revalidate`.
All six anonymous portrait URLs return 200 WebP with the correct dimensions and
300-second cache directive, and all six decode successfully in the browser.
The running publisher advertises `http://192.168.37.41:3105` portrait URLs.

The temporary browser session was closed; no credential is stored here. Production
and the public-site consumer configuration were not changed. Actual consumer/browser
HTTPS integration remains separate SITE-04 work; the HTTP synthetic feed alone is
not a configured HTTPS source for this site's production-strength client.
