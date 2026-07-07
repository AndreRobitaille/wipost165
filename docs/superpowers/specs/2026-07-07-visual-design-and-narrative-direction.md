# Post 165 — Visual Design & Narrative Direction

Date: 2026-07-07
Status: Approved (design direction)

## Purpose

The first pass at the `post165` theme (see the audit below) is structurally
sound but visually generic: correct patriotic palette, no craft applied. This
document defines the **narrative spine** and **visual system** that give the site
a specific, dignified identity for Robert E. Burns American Legion Post 165.

It complements — does not replace — the approved
[site design spec](2026-07-06-wordpress-site-design.md). That spec owns scope,
audiences, navigation, content model, and v1/v2 boundaries. This spec owns
*story and look*. Where the earlier spec said "restrained patriotic; navy, cream,
gold; dignified," this one says exactly how.

## Problem: why the current pass reads as uninspired

A theme audit found the palette is right but execution is a wireframe:

- The declared body font (`Inter`) is named in `theme.json` but **never
  enqueued** — every page silently falls back to the OS UI font, which reads as
  half-built.
- **Gold is defined but effectively unused;** the one gold accent hardcodes a
  different value (`#d9b45b`) instead of the palette token.
- Every section is **centered text on a flat, full-width color band**
  (navy / cream / white alternating) — no rule lines, texture, iconography,
  dividers, or depth. A stack of colored rectangles.
- The hero is **text on a plain navy rectangle** — no emblem, mark, or graphic
  to anchor identity.
- **No logo support and no bundled assets** of any kind.
- A `.post165-section-divider` style is defined but never used; patterns
  hardcode padding (`4rem`/`5rem`) instead of using the spacing presets.

## Narrative Spine

**"Still here. Still serving."** — continuity through service, expressed in three
tenses, each *earned* a different way. "Here" always means both **Two Rivers and
the country**: the post is where a national, century-old commitment becomes
something the community can see on its own streets.

### The three tenses

- **Then → trust.** Part of a national organization serving since 1919, and part
  of Two Rivers through a *named* local legacy (Robert E. Burns). Stated as plain
  fact, not nostalgia. In a town that "values continuity, civic institutions, and
  local traditions," history *is* credibility.
- **Now → proof.** The site demonstrates presence through current events,
  ceremonies, and youth work — action, never assertion. This is why events are
  the freshness engine, not a news feed.
- **Next → invitation.** The future is built by veterans joining, families
  connecting, and youth invested in (the Children & Youth pillar is literally
  investment in the future). Every forward-looking moment is a door, not a
  declaration.

### Why "Next" is an invitation, not a promise

Both the members and the Two Rivers community are described as skeptical of
promises and self-promotion — they "judge organizations by what they consistently
accomplish rather than what they promise" and value "patriotism expressed through
action rather than symbolism alone." A stated "we'll be here in the future" is a
boast in the one register this audience distrusts. The site therefore never makes
a forward *claim*; it extends a forward *invitation* ("help us be here").

### The namesake as the primary "Then" anchor

A post named Robert E. Burns almost certainly honors a specific local man. Leading
the site's history with a real name and a real Two Rivers story is un-fakeable and
matches the community's preference for action over symbolism. His story anchors
the About page and informs the hero framing.

## Visual System

The approved direction is a hybrid: the graphic energy of a flag motif on durable,
ceremonial bones. Its defining idea is an **intensity dial, not a fixed frame** —
the motif appears loud only where it earns attention.

### Palette (corrected)

| Token | Hex | Role |
|-------|-----|------|
| navy  | `#0e2340` | Foundation: hero, footer, headers, headings |
| cream | `#f7f1e3` | Page canvas |
| gold  | `#c49a3a` | **Structural** accent: ribbon rules, eyebrows, small-caps labels, seal linework |
| red   | `#9f1d2e` | Controlled accent: primary CTAs, key emphasis |
| ink   | `#1f2933` | Body text |
| white | `#ffffff` | Cards, quiet-page content surfaces |

One consistent gold everywhere. The stray hardcoded `#d9b45b` is eliminated (a
single lighter gold tint may exist as a *derived* on-navy variable, but not as a
competing brand value).

### The motif intensity dial

- **Full dress (homepage / hero only):** a thin red/cream/gold **stripe "spine"**
  down the leading edge, a faint emblem **watermark**, expressive red, gold
  ribbon rule under the headline, meeting-info strip beneath the hero.
- **Quiet (all interior pages, most sections):** the loud elements disappear. A
  small **star eyebrow** and a single **gold "ribbon" rule** carry the identity;
  content breathes. This repeats effortlessly across About / Membership / Contact
  without fatigue.

The recurring connective thread across the whole site is the **gold ribbon rule**
(a short gradient gold line, optionally led by a star) used as eyebrow underline
and section marker — replacing the currently-unused divider style.

### Typography (self-hosted — this also fixes the load bug)

Fonts are **bundled in the theme and enqueued**, never CDN-dependent (shared
hosting; must not silently fall back).

- **Display / headlines:** **Fraunces** — a warm old-style serif with age and
  gravitas; reads dignified, not trendy, when used at restrained weights/optical
  sizes. Approved fallback if it feels too characterful in practice: **Newsreader**.
- **UI / nav / labels / body:** **Public Sans** — the U.S. federal government's
  typeface (USWDS); a quiet civic signal, freely licensed and self-hostable.
- System fallbacks are declared for both so the site degrades gracefully.

Both are SIL Open Font License, so bundling and self-hosting is permitted.

### Emblem, wordmark, photography

- **Official Legion emblem:** used sparingly and formally — a small seal in the
  header and a faint watermark in the hero. Never decorative wallpaper; official
  usage guidelines respected.
- **Wordmark:** an optional typographic "Post 165" lockup (namesake + org in
  small caps above "Post 165"). Low stakes — keep or drop without disturbing the
  system.
- **Photography:** optional and selective; dignified honor-guard / ceremony
  images carry "Now." The design must stand fully on type, color, and layout
  alone so quiet seasons never look empty. No posed/stock-flag imagery.

## Homepage, section by section

Each section maps to a tense in the spine. Order and content responsibilities
follow the earlier site-design spec.

1. **Hero — Then + Now.** Namesake/century framing plus a present-day welcome;
   CTAs *Learn About Membership* (primary/red) and *View Events*; meeting-info
   strip beneath. Full-dress motif.
2. **Upcoming at Post 165 — Now.** Public/community events, post meetings, and
   honor guard visually separated. The freshness engine (calendar plugin).
3. **A Place for Veterans & Families — Next.** Welcome-first membership teaser;
   the invitation, family connection acknowledged.
4. **How We Serve — Now / ongoing.** Four Pillars shown through concrete *local*
   examples, not definitions.
5. **Support Post 165 — Next.** Low-pressure, contact-routed. No online payments
   in v1.
6. **Contact & Meeting Info — the constant.** Always-present practical facts.

## Interior pages

About, Membership, and Contact use the **quiet** treatment: content-first, one
gold ribbon thread, generous space. **About** is where the Robert E. Burns story,
charter year, and local milestones live — the fullest expression of "Then."

## Maintainability requirements (non-negotiable)

Protecting volunteer time is a design constraint, not an afterthought.

- Homepage sections stay **pattern/template-driven** so editors change *content,
  not layout*.
- Events run through the calendar plugin; the site never depends on a manual news
  feed for freshness.
- Fonts are **bundled in the theme** (no external requests).
- No fragile page-builder structures; block editor for ordinary pages.
- Add `custom-logo` theme support so a future emblem/wordmark image is editable.

## Content to collect before launch

- Robert E. Burns' story (who he was, his service, the local connection).
- Post charter year and 1–2 notable milestones.
- Any dignified honor-guard / ceremony / community photos.
- Verification of the practical facts already listed in the site-design spec
  (address, meeting time, phone, email, Facebook).

These get **marked content slots**; nothing ships as visible placeholder text.

## Out of scope

Unchanged from the site-design spec: member login, private documents, online
payments, SAL functionality, a Programs top-level page, and a homepage
latest-news feed. This spec adds no new scope — it defines the look and story of
the already-approved v1.

## Success criteria

The redesign succeeds if:

- The site reads as *this specific post* in Two Rivers, not a template in
  patriotic colors.
- The continuity story is felt without any boastful or performative claim.
- The homepage feels current during quiet seasons on typography and structure
  alone.
- Gold, the emblem, and the motif each do real work and are used with restraint.
- Fonts load reliably from the theme; no OS-fallback regression.
- Editors can update every section's content without touching layout or making
  design decisions.
