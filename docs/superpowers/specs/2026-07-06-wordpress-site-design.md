# Robert E. Burns American Legion Post 165 WordPress Site Design

## Purpose

Build a WordPress-based public website for Robert E. Burns American Legion Post 165 in Two Rivers, Wisconsin. The site should present the post as a trustworthy local civic institution, welcome veterans and their families, make events and contact information easy to find, and remain practical for volunteers to maintain.

The site will be hosted on NixiHost shared WordPress hosting with FTP, HTTPS, and MySQL access. WordPress will be the content management system. This repository will own the custom theme, setup documentation, and deployment workflow, not live content edited in wp-admin.

## Audiences and Priorities

Primary audiences:

1. Eligible veterans and prospective members who need to feel welcome before being asked to join.
2. Veterans' families who need to understand how they can be connected to the post and Legion Family.

Secondary audiences:

1. Two Rivers community members looking for a reliable civic organization, events, contact information, or ways to support local service.
2. Existing members looking for meetings, events, announcements, and contact details.

Priority order for the site:

1. Present Post 165 as a local civic and community institution.
2. Make practical information easy to find.
3. Encourage membership and involvement.
4. Support existing members without making v1 a private member portal.

## Recommended Approach

Use a custom WordPress block theme with simple editor workflows.

The theme should be custom enough to feel specific to Post 165, but editing should remain WordPress-native. Avoid heavy page builders, complex purchased templates, and layouts that require volunteers to make design decisions inside wp-admin.

The block theme should provide:

- site-wide design tokens and templates;
- block patterns for common sections;
- page templates for the homepage and key pages;
- simple, reusable content structures;
- compatibility with a WordPress event/calendar plugin;
- documentation for editors and deployers.

## Ownership Boundaries

The repository owns:

- the custom WordPress theme;
- theme source assets and build tooling if needed;
- reusable patterns/templates committed with the theme;
- setup documentation;
- deployment instructions and GitHub Actions FTP workflow;
- initial content drafts and content model documentation.

WordPress owns:

- live pages edited in wp-admin;
- events;
- posts/news;
- uploaded media;
- menus;
- plugin settings unless a reliable export/import path is available.

Git is the source of truth for code and documented structure. WordPress is the source of truth for live content. Changes made through wp-admin are not expected to sync back to Git.

## Version Scope

### V1

V1 is a public site. It includes:

- custom block theme;
- homepage;
- Events archive/landing page backed by an event/calendar plugin;
- Membership page;
- About page;
- Contact page;
- support messaging routed through contact or specific events;
- news/posts available but not central to the homepage;
- editor and deployment documentation.

V1 does not include:

- member-only login;
- private documents;
- online donations/payments;
- Sons of The American Legion functionality;
- a top-level Programs page unless enough real content is available;
- homepage latest-news feed that requires frequent publishing.

### V2 Candidates

V2 can add:

- member login and member resources;
- private documents and announcements;
- online donations/payments;
- richer program pages;
- more structured officer/contact management if needed.

## Navigation and Content Structure

Primary navigation for v1:

- Home
- Events
- Membership
- About
- Contact

Avoid these as top-level v1 navigation items unless the content becomes substantial:

- Programs
- Four Pillars
- News
- Support
- Member Resources

### Home

The homepage should answer common visitor questions quickly: who the post is, who is welcome, what is happening, how the post serves, and how to take the next step.

### Events

Events should be CMS-managed through a WordPress event/calendar plugin. The event model should distinguish:

- public/community events;
- member/post events;
- honor guard and ceremonial events.

The homepage should show both public events and member/post events, but keep them visually separated. Honor guard and ceremonial items can be highlighted when relevant.

### Membership

Membership should speak first to eligible veterans. It should lead with welcome, belonging, service, family connection, and flexible involvement before explaining eligibility mechanics.

The primary call to action for prospective members should be to come to an event. Contact and eligibility information should still be available, but joining should not feel like the first demand.

The page should acknowledge family connection through the Legion Family, Auxiliary, and event participation. It should be honest that Post 165 does not currently have a Sons of The American Legion squadron.

### About

About should explain Post 165, the Legion mission, local service, and the Four Pillars in plain language. It should avoid internal Legion politics, unnecessary governance detail, and jargon.

The meeting location, Manitowoc Rifle & Pistol Club, should be presented simply as the location where the post meets. The relationship is not a major identity point.

### Contact

Contact should provide practical information:

- meeting time;
- meeting location;
- mailing address;
- phone;
- email;
- Facebook group link;
- any verification notes for content that may change.

Known facts from the old site should be verified before launch:

- formal name: Robert E. Burns American Legion Post 165;
- mailing address: PO Box 11, Two Rivers, WI 54241;
- meeting location: Manitowoc Rifle & Pistol Club, 7227 Sandy Hill Ln, Two Rivers, WI 54241;
- meeting time: first Tuesday of each month at 6:30 pm;
- phone: (920) 860-7478;
- email: wipost165@gmail.com;
- Facebook group: https://www.facebook.com/groups/amlegionpost165wi.

## Homepage Structure

The homepage should not depend on frequent news updates or strong photography.

Recommended flow:

1. Hero
   - Formal name: Robert E. Burns American Legion Post 165.
   - Plain mission statement for veterans, families, and Two Rivers.
   - Primary CTA: Learn About Membership.
   - Secondary CTA: View Events.

2. Upcoming at Post 165
   - Public/community events.
   - Post meetings/member business.
   - Honor guard/ceremonial events when relevant.

3. A Place for Veterans and Families
   - Welcome-focused membership teaser.
   - Eligible veterans are the primary membership audience.
   - Families can connect through the Legion Family, Auxiliary, events, and service.

4. How We Serve
   - Evergreen examples tied loosely to the Four Pillars:
     - veterans;
     - youth;
     - ceremonies and remembrance;
     - community service.

5. Support Post 165
   - Low-pressure section about helping the post serve.
   - Route visitors to Contact or specific events.
   - Do not include online payment in v1.

6. Contact and Meeting Info
   - Meeting time and location.
   - Email and phone.
   - Facebook group.
   - Mailing address.

## Visual Direction

The design should feel mission-driven, supportive, warm, local, and dignified.

Use restrained patriotic design:

- navy, cream, and gold as the base;
- red as a controlled accent;
- official American Legion brand mark where appropriate for public-facing identity;
- official emblem only in formal/official contexts, not as decorative wallpaper;
- subtle flag, stripe, service, or ceremonial references where they support meaning.

Avoid:

- generic patriotic clip art;
- excessive eagles;
- tactical or military cosplay aesthetics;
- political-campaign styling;
- glossy corporate marketing layouts;
- photography-dependent design.

Photography should be optional. V1 should work with typography, spacing, color, layout, official assets, and simple graphic treatments. Honor guard photos may be used selectively if dignified. Posed community photos should not be central to the design.

## Editorial Voice

Write in a voice that is:

- direct;
- respectful;
- practical;
- friendly without being casual;
- patriotic without being performative;
- service-focused instead of self-promotional;
- plainspoken rather than corporate.

The site should show service through examples rather than tell visitors the post is important. It should avoid unexplained military or Legion jargon and should emphasize visible action, local trust, and steady service.

## Events and Freshness Model

Events are the primary freshness mechanism. News/posts should exist for occasional updates, but the homepage should not rely on a latest-news feed because infrequent posting would make the site look stale.

The site should tolerate quiet seasons. During months with few public events, the homepage should still feel current through evergreen service examples, meeting information, and clear contact paths.

## Support Model

Use the label "Support Post 165" for support messaging.

In v1, support should be contact-oriented rather than payment-oriented. The site can describe ways to help:

- attend public events;
- volunteer at an event;
- support a specific fundraiser or event;
- offer goods or services when needed;
- connect the post with a local need or partnership.

Online payments and donations should wait until the post has chosen a processor and clarified treasurer workflow, receipts, restricted funds, accountability, and reporting.

## Editing and Maintenance

The editing experience should be simple enough for one or two reasonably technical post members.

Principles:

- Events are managed through the event plugin.
- News/posts are available but not required for homepage freshness.
- Ordinary pages can use the block editor.
- Homepage and key sections should use templates or patterns so editors edit content without rebuilding layouts.
- Volunteers should not need to make design decisions to update content.
- Avoid complex page-builder layouts.
- Avoid excessive plugin dependence.

Documentation should explain:

- how to edit events;
- how to edit homepage sections;
- how to edit contact details;
- how to create ordinary pages or posts;
- what not to edit casually;
- how GitHub-to-FTP deployment works;
- what lives in Git versus WordPress.

## Risks and Constraints

- Shared hosting limits deployment and server-side control.
- Live WordPress content changes will not sync back to Git.
- Plugin settings may be difficult to version.
- The WordPress editor can become slow or cumbersome if the theme relies on complex page structures.
- Current photo assets are limited and should not drive the design.
- Public events are seasonal, so homepage freshness cannot depend only on public event volume.
- Member resources and online payments require governance/process decisions and should not be bundled into v1.

## Success Criteria

The v1 site is successful if:

- prospective members feel welcome before being asked to join;
- families understand there is a place for them to be connected;
- community visitors can quickly find events and contact information;
- existing members can find meetings and post events;
- the site presents Post 165 as active, trustworthy, and locally rooted;
- editors can update events and ordinary content without fighting the editor;
- the homepage does not look abandoned during quiet seasons;
- Git and WordPress ownership boundaries are documented clearly.
