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

Create these pages in WordPress:

- Home: assign as the static front page only.
- Events: use The Events Calendar events archive/landing page; do not create a normal Events page unless later plugin configuration requires one.
- Membership: use the `Membership page starter` pattern.
- About: use the `About page starter` pattern.
- Contact: use the `Contact page starter` pattern.

## Editing rules

- Edit event details in the event plugin.
- Edit ordinary page text in the block editor.
- Homepage sections come from the theme template and patterns in `front-page.html`.
- Do not type homepage content into the Home page body.
- If homepage copy needs editing in v1, handle it through the theme/Site Editor workflow, not ad hoc page body edits.
- Use Post 165 patterns instead of manually rebuilding homepage sections.
- Keep support messaging contact-oriented until donation processing is approved.
- Keep member-only resources out of v1.
