# WordPress Setup

## Hosting assumptions

The site is hosted on NixiHost shared WordPress hosting with FTP, HTTPS, and MySQL access.

## Theme

Upload or deploy `wp-content/themes/post165/` to the WordPress site's `wp-content/themes/` directory, then activate **Post 165** in wp-admin.

## Required plugin

Install **The Events Calendar** for event management.

Create these event categories:

- Public Events
- Post Meetings
- Honor Guard

## Pages

Create these pages:

- Home
- Membership
- About
- Contact

Set **Home** as the static front page in Settings → Reading.

The homepage content comes from `wp-content/themes/post165/templates/front-page.html` and starter patterns, not from page body content.

Routine editors: update events, contact facts, and page body text on Membership/About/Contact. Do not edit the Front Page template.

Site/theme editor: if assigned, use Appearance → Editor → Templates → Front Page for small copy or order adjustments, then Preview and Save.

Structural changes or default pattern copy changes: edit the Git theme pattern/template files and redeploy.

If unsure, do not save Front Page template changes; ask the theme maintainer.

To inspect available Post 165 patterns, go to Appearance → Editor → Patterns → Post 165, if the installed WordPress version supports pattern browsing.

The Events item in the header Navigation block should link to The Events Calendar archive/landing URL, commonly `/events/` and adjusted if plugin settings differ, not to a normal page created by editors.

The Events section should use The Events Calendar events archive/landing page. Do not create a normal Events page unless later plugin configuration requires one.

For Membership, About, and Contact, insert the matching Post 165 starter pattern from the `Post 165` pattern category and edit the text as needed.

## Menu

Update the header Navigation block in the Site Editor with:

- Home
- Events
- Membership
- About
- Contact

The shipped theme seeds these five v1 navigation links by default. Editors can adjust the Events URL in the Navigation block if The Events Calendar uses a different archive URL or a staging/subdirectory path.

## Verify contact facts before launch

Confirm these details before publishing:

- formal name: Robert E. Burns American Legion Post 165;
- mailing address: PO Box 11, Two Rivers, WI 54241;
- meeting location: Manitowoc Rifle & Pistol Club, 7227 Sandy Hill Ln, Two Rivers, WI 54241;
- meeting time: first Tuesday of each month at 6:30 pm;
- phone: (920) 860-7478;
- email: wipost165@gmail.com;
- Facebook group: https://www.facebook.com/groups/amlegionpost165wi.

## Editor guidance

- Use events for dated activities.
- Use posts only for occasional updates that should remain visible as articles.
- Do not rebuild the homepage by typing content into the Home page body; edit homepage copy through the theme/Site Editor workflow or by updating theme pattern files in Git and redeploying when needed in v1.
- Do not add online donations until payment processing and treasurer workflow are approved.
- Do not add member-only resources until v2.

## Design assets and content to complete

- Fonts (Fraunces and Public Sans) are bundled with the theme at `wp-content/themes/post165/assets/fonts/` and load automatically through `theme.json`. Do not install a fonts plugin (e.g. a Google Fonts plugin) — it is unnecessary and would duplicate what the theme already self-hosts.
- The header/hero mark at `wp-content/themes/post165/assets/images/seal.svg` is a custom placeholder mark, not the official American Legion emblem. It may be replaced with the official emblem only where American Legion usage guidelines permit. The preferred way to swap it is Appearance → Customize → site logo (custom-logo theme support is enabled), rather than editing the SVG file directly.
- The About page's "Our Namesake" and "Our History" sections currently use placeholder text and need the real Robert E. Burns biography, the Post's charter year, and 1–2 real milestones before launch.
