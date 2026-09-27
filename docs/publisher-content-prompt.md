# Prompt for the LegionPostTools content session

Work on the real LegionPostTools site at https://members.wipost165.org. I want
three fictional introductions with generated portraits so we can finish the
public website, then replace them with real member introductions later.

This is authorized live content work: create the three story records, save their
text and portraits, record synthetic-only consent, publish them, and feature them
in Avery, Morgan, Sam order. Do this in the real Public website workspace, not a
local test database. Use the editorial API. Start by reading the authenticated
GET /api handbook and checking existing publications so we do not create duplicates.

Use editorial credentials with publish_public_content permission. The separate
Post-owned website token only reads approved content through /public/v1; it
cannot write or access /api. Do not change grants, mint credentials through
undocumented routes, or bypass the API with direct database edits. If editorial
authentication is unavailable, identify that exact missing input.

The prepared content and portraits are in the public-site repository under
docs/design/2026-09-api-placeholders/: content.json, avery.png, morgan.png, sam.png,
and prompts.json. Reuse those assets if available. Otherwise create three natural,
approachable fictional portraits: Avery, an older man with silver hair and glasses
in a blue shirt; Morgan, a middle-aged woman with brown hair in a green shirt; and
Sam, a middle-aged Black man with salt-and-pepper hair in a burgundy shirt. Use
soft daylight, quiet neutral backgrounds, and centered 4:5 framing with room
around the head and shoulders. No uniforms, medals, logos, or invented Post venue.

Write brief, welcoming introductions around ordinary interests: fixing old radios,
gardening and cooking, and music. Include a natural conversation starter and useful
portrait alt text. Clearly label the names and stories as fictional placeholders
and the portraits as AI-generated. Do not invent actual members, military records,
offices, quotes, attendance promises, or events. No event records are requested.

Upload through the documented portrait API and inspect both WebP crops. Record
that I authorized these fictional text/image placeholders for website development;
do not claim a real member supplied consent. Use current versions for every write,
distinct idempotency keys for bearer actions, and the complete fresh featured
versions map when replacing homepage order. Stop and review conflicts rather than
forcing newer versions through.

Read back the live records and audit history, verify the authenticated /public/v1
stories and both portrait sizes, and report their live URLs and final order.
Verify the public website display if its full experience is enabled; a coming-soon
page is a separate public-site deployment setting, not a content failure. Keep
tokens and private responses out of chat, logs, and public files. When real people
are ready, create new identities and withdraw these placeholders instead of
reusing their records for different people.
