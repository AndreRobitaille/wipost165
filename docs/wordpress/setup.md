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

The homepage content comes from the theme's `front-page.html` template and starter patterns, not from page body content.

The Events section should use The Events Calendar events archive/landing page. Do not create a normal Events page unless later plugin configuration requires one.

For Membership, About, and Contact, insert the matching Post 165 starter pattern from the `Post 165` pattern category and edit the text as needed.

## Menu

Update the header Navigation block in the Site Editor with:

- Home
- Events
- Membership
- About
- Contact

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
- Do not rebuild the homepage by typing content into the Home page body; edit homepage copy through the theme/Site Editor workflow when needed in v1.
- Do not add online donations until payment processing and treasurer workflow are approved.
- Do not add member-only resources until v2.
