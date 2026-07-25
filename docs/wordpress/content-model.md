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

### Homepage facts

Dues, member count, charter year, meeting rule, venue, and the contact person
are **owned by WordPress**, stored in the `post165_facts` option and edited at
Settings → Post 165. They are not in Git and a deploy will not overwrite them.

The twelve-month year map is **owned by Git**, in
`inc/pure/year-map.php`, because it is editorial content that changes at most
once a year.

## Navigation

Block theme navigation:

- Home
- Events
- Membership
- About
- Contact

Populate the header Navigation block in the Site Editor with these links.

The Events item should point to The Events Calendar archive/landing URL, commonly `/events/` and adjusted if plugin settings differ, not to a normal page created by editors.

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

Events is plugin-owned: use The Events Calendar events archive/landing page, commonly `/events/` and adjusted if plugin settings differ; do not create a normal Events page unless later plugin configuration requires one.

## Editing rules

- Edit event details in the event plugin.
- Edit ordinary page text in the block editor.
- Routine editors: update events, contact facts, and page body text on Membership/About/Contact. Do not edit the Front Page template.
- Site/theme editor: if assigned, use Appearance → Editor → Templates → Front Page for small copy or order adjustments, then Preview and Save.
- Structural changes or default pattern copy changes: edit the Git theme pattern/template files and redeploy.
- If unsure, do not save Front Page template changes; ask the theme maintainer.
- Homepage sections come from the theme template and patterns in `wp-content/themes/post165/templates/front-page.html`.
- Do not type homepage content into the Home page body.
- To inspect or edit the homepage template, use Appearance → Editor → Templates → Front Page.
- To inspect available Post 165 patterns, use Appearance → Editor → Patterns → Post 165, if supported by the installed WordPress version.
- Use Post 165 patterns instead of manually rebuilding homepage sections.
- Keep support messaging contact-oriented until donation processing is approved.
- Keep member-only resources out of v1.
