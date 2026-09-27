# Post 165 public website

The Rails public website for Robert E. Burns American Legion Post 165 in Two
Rivers, Wisconsin. “In good company” introduces three regulars around a shared
table, with public events and a welcoming first-visit path.

Content is managed in the separate LegionPostTools app. This application consumes
its approved publishing API, with bounded caching and no database, member accounts,
or second editor. The consumer and separate Kamal configuration are implemented
locally. A coming-soon page is live at Hetzner with HTTPS on apex and www; the
companion publisher, end-to-end integration, and full-site launch remain open.

Start with the [development roadmap](docs/ROADMAP.md) and [handoff](docs/HANDOFF.md).
Read [purpose and audience](docs/PURPOSE.md) and the
[UI/UX and visual guide](docs/UI_UX_GUIDE.md) before shaping the public experience.
See [setup and verification](docs/development.md), the
[companion work queue](docs/companion-work-queue.md), and the
[shared publishing contract](docs/public-publishing-api-v1.md). Development
uses labelled placeholders; production never substitutes them for missing content.

The former WordPress theme/tooling are removed. [Design notes](docs/DESIGN_NOTES.md)
and [history](docs/history/README.md) retain research without locking future design
work to old choices. The public service runs separately alongside the members site.
