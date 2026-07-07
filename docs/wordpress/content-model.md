# WordPress Content Model

## Ownership

Git owns:

- the custom `post165` theme;
- theme templates and patterns;
- validation scripts;
- setup and deployment documentation.

WordPress owns:

- live page content edited in wp-admin;
- events;
- posts/news;
- media uploads;
- menus;
- plugin settings unless a reliable export/import path is documented.

## Navigation

Block theme navigation:

- Home
- Events
- Membership
- About
- Contact

Populate the header Navigation block in the Site Editor with these links.

The Events item should link to The Events Calendar archive/landing URL (commonly `/events/`, adjusted if plugin settings differ), not to a normal page created by editors.

Do not add Programs, Four Pillars, News, Support, or Member Resources to the top-level navigation until there is enough real content to justify the page.

## Event categories

Event categories:

- Public Events: open community events, youth activities, fundraisers, banquets, and public gatherings.
- Post Meetings: regular meetings and member business.
- Honor Guard: ceremonies and observances where the community attends respectfully.

Use The Events Calendar for event entry and its events archive/landing page unless the post later chooses a different event plugin.

## Posts and news

Posts are allowed for occasional updates. The homepage must not depend on a recent-news feed because irregular posting can make the site look stale.

## Pages

Create these WordPress pages:

- Home: assign as the static front page only.
- Membership: use the `Membership page starter` pattern.
- About: use the `About page starter` pattern.
- Contact: use the `Contact page starter` pattern.

Events is plugin-owned: use The Events Calendar events archive/landing page; do not create a normal Events page unless later plugin configuration requires one.

## Editing rules

- Edit event details in the event plugin.
- Edit ordinary page text in the block editor.
- Homepage sections come from the theme template and patterns in `wp-content/themes/post165/templates/front-page.html`.
- Do not type homepage content into the Home page body.
- To inspect or edit the homepage template, use Appearance → Editor → Templates → Front Page.
- To inspect available Post 165 patterns, use Appearance → Editor → Patterns → Post 165, if supported by the installed WordPress version.
- Routine content editors should avoid changing the Front Page template unless assigned to theme/site editing.
- In v1, homepage sections are theme/pattern-driven; routine editors should update events, contact, and page content instead of rebuilding homepage sections.
- If homepage copy or section order must change structurally, update the theme pattern files in Git and redeploy.
- Use Post 165 patterns instead of manually rebuilding homepage sections.
- Keep support messaging contact-oriented until donation processing is approved.
- Keep member-only resources out of v1.
