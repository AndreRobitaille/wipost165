# Homepage Density Redesign — "The Board"

**Date:** 2026-07-24
**Status:** Approved design, ready for implementation planning
**Supersedes:** the homepage section of `2026-07-07-visual-design-and-narrative-direction.md` (that spec's palette, type, and motif system stand unchanged; only the homepage composition changes)

---

## 1. Problem

The homepage measures **3,085px tall — 3.7 viewports — to deliver 426 words.** Roughly 115 words per screen.

Six patterns (`home-hero`, `home-events`, `home-membership`, `how-we-serve`, `support-post-165`, `contact-card`) share an identical anatomy: centered star eyebrow → left-aligned serif h2 → one paragraph → one button. When every section is shaped the same, nothing reads as important, and the only thing producing visual interest is vertical padding. That is air, not content.

The copy is also *meta* rather than substantive. The events section reads:

> "Public events, post meetings, and ceremonial service each have a different purpose. We keep them separated so visitors can quickly find what applies to them."

That is a sentence describing the site's own information architecture. The three cards beneath it announce that categories exist without naming a single real event. **The page contains no date, no photograph, no person's name, and no number other than "1919."**

This conflicts with the documented audience. `docs/COMMUNITY.md` states residents value "patriotism expressed through action rather than symbolism alone" and "appreciate authenticity over polished marketing." The current homepage is almost entirely symbolism — star, seal, ribbon, stripe spine — wrapped around adjectives.

## 2. Audience and job

The site is **not a browsing destination.** Social media and local press carry day-to-day awareness. Visitors arrive deliberately, from a link or word of mouth, holding one specific question:

1. **"When is that thing?"** — brat fry, car show, or (for members and curious veterans) the next meeting.
2. **"What is this post, and should I join?"** — asked by a veteran who is *already curious*. The site does not need to persuade the incurious; it needs to answer the curious without making them work.

Therefore the homepage is an **answer page**, not a brochure. Every screen of scroll between arrival and answer is a defect. The remedy is compression plus specificity, not more sections.

Post 165 has no bar or restaurant, so it is not a hangout venue. Events are episodic and seasonal.

## 3. Constraints

| Constraint | Consequence for the design |
|---|---|
| **No public events October–March** | A naive "next event" hero reads as *nothing is happening here* for half the year — the opposite of the site's narrative. The design must stay alive with zero public events. |
| **The Events Calendar, kept mostly current** | Real events come from TEC when present. The page must degrade gracefully, never showing an empty void. |
| **Free TEC has no recurring events** | The monthly post meeting is almost certainly not in the calendar. It must come from somewhere else. |
| **Volunteer-run** | Anything requiring a human to remember a seasonal switch will fail. Upkeep must approach zero. |
| **Facts go stale** (dues, member count, contact person) | These must be editable in wp-admin by an officer, not by a developer via commit. |
| **Audience prefers plain competence to charisma** | No marketing voice. State facts; do not sell. |

## 4. Design

### 4.1 Anatomy

```
┌─ header (unchanged) ───────────────────────────────────────┐
├─ STRAP  navy, ~130px ──────────────────────────────────────┤
│  Still here. Still serving.                    1919        │
│  one plain sentence                            CHARTERED   │
├─ BOARD  two columns ───────────────────┬───────────────────┤
│  WHAT'S NEXT                           │  THINKING ABOUT   │
│   • dated entries (computed + TEC)     │  JOINING          │
│   • quiet-season note (conditional)    │   Who / Dues /    │
│  OUR YEAR                              │   We meet / Size  │
│   • 12-month rhythm strip              │   [How to join]   │
│                                        │   named contact   │
└────────────────────────────────────────┴───────────────────┘
        ▲ fold — everything above answers both questions
┌─ PROOF  photo band ────────────────────────────────────────┐
├─ WHAT WE DO  condensed single row ─────────────────────────┤
├─ footer ───────────────────────────────────────────────────┤
```

Target: **≤2 viewports total**, carrying materially more information than today's 3.7.

### 4.2 The strap (replaces the hero)

The 656px hero becomes a ~130px navy band with a 3px gold bottom rule.

- Left: `Still here. Still serving.` (Fraunces, ~25px) plus one plain sentence of description.
- Right: charter year as a large gold numeral above a small uppercase `CHARTERED` label.
- **No buttons.** The join call-to-action lives in the join panel, which is visible simultaneously. Duplicating it here wastes the most valuable band on the page.

Rationale: the strap's job is identification, not persuasion. It says who this is and how long they have been at it, then yields the screen to content.

### 4.3 The event spine — computed meetings + TEC

**The core decision: the monthly meeting is computed in PHP, never entered.**

Because free TEC cannot express recurrence, and because a volunteer will eventually forget, meeting dates are derived from a rule (default: *first Tuesday of each month, 6:30 pm*) using the site timezone via `wp_timezone()`. This yields a correct, dated, year-round entry at zero editorial cost. It is the reason the January mockup still shows three real entries.

Assembly:

1. Generate the next **6** monthly meetings from the rule.
2. **Apply per-meeting overrides** (§4.3.1) — an individual meeting may be moved, retimed, relocated, or cancelled.
3. If `function_exists('tribe_get_events')`, fetch upcoming published TEC events from now forward.
4. Merge, sort ascending by start time, render the first **5**.
4. Meetings render with a `Members` pill; TEC events render with a `Public` pill. The next chronological entry is highlighted.
5. Dates use `<time datetime="…">` with a machine-readable value.

**Quiet-season fallback (automatic).** If no TEC event falls within the next 60 days, render a short bordered note stating that public events run in the warm months, that meetings continue monthly and visitors are welcome, and naming the **next annual milestone** resolved from the year map (§4.4). No human toggles this seasonally.

**Failure modes are explicit:** TEC absent or empty → meetings still render, page still valid. Meeting rule misconfigured → falls back to rendering TEC events only rather than fataling.

#### 4.3.1 Changing the pattern, and changing one meeting

Two distinct needs, deliberately handled by two different mechanisms.

**The standing rule changes** (the post moves off first-Tuesday-1830, or changes its regular venue). Edit the rule fields in `Settings → Post 165`: ordinal, weekday, time, venue name, street address. All future computed meetings follow the new rule immediately. This is a rare, sitewide change.

**One meeting changes** (November's meeting moves a week for a holiday; December's is cancelled; one meeting is held elsewhere). This uses an **override table keyed by calendar month** (`YYYY-MM`), because the rule produces exactly one meeting per month, making the month an unambiguous key. No fragile matching on computed dates.

Each override row carries: target month, plus optional replacement date, replacement time, replacement venue, and a **Cancelled** checkbox. Any field left blank inherits from the standing rule, so relocating a single meeting does not require restating its date and time.

- A cancelled month is **omitted from the list entirely** rather than displayed struck through. A visitor scanning for the next meeting should not have to parse a negation.
- The table holds **6 rows**, matching the 6 months generated — the override window and the generation window are deliberately the same, so an override can never silently apply to a meeting that is never computed.
- Rows whose month is in the past are ignored at render and may be safely reused or cleared.

If both an override and a TEC event exist for the same slot, the override applies to the computed meeting and the TEC event remains a separate entry; they are not merged. Duplicate-looking output is the editor's signal that the meeting was entered in TEC by hand and the override is redundant.

### 4.4 The year strip ("Our year")

A twelve-cell map of the post's annual rhythm, current month highlighted (`aria-current="date"`). Months with a recurring event show its short label; empty months render muted.

This is **hand-authored editorial content, not calendar data** — which is exactly why it remains true in February when TEC is empty. It answers "when's the car show?" *before* a date exists, and it demonstrates a century of showing up using specifics rather than the word "proud."

Stored as a PHP array in the theme, exposed through a `post165_year_map` filter. It changes at most yearly, so it does not warrant a settings UI.

A single line beneath states that meetings run monthly, year round.

> **Values to confirm before launch.** The mockup used Memorial Day (May), Flag Day (Jun), parade (Jul), brat fry (Aug), car show (Sep), Veterans Day (Nov). Only the brat fry and car show were confirmed by the post. The full twelve-month map must be verified by an officer; nothing here is authoritative.

### 4.5 The join panel

A narrower right-hand column (~340px desktop) on white to separate it from the cream board.

- Heading: **"You served. That doesn't have to be past tense."**
- Subhead: **"Straight answers, no pitch."** — then it must actually deliver that. No adjectives.
- A definition list: **Who** (eligibility), **Dues**, **We meet** (time, venue, street address), **Size** (member count, displayed per §4.5.1).

#### 4.5.1 Member count is rounded, not exact

An officer enters the true roster number; the page **rounds down to the nearest 5 and appends a plus** — `183 → "180+"`, `200 → "200+"`.

This is deliberate on two counts. It stays true as the roster drifts, so the figure does not quietly become a lie between updates; and rounding down means the post is never overstating itself, which suits an audience that prefers understatement to marketing.

Edge case: a value below 5 would round to `"0+"`, which is absurd. Counts under 5 render the exact integer with no plus. A count of 0 or an empty field omits the Size row entirely (§4.6).
- A single primary button: *How to join*.
- **A named human**: first name, role, email, phone.

The named contact is the highest-value element on the page. `docs/COMMUNITY.md` records that trust is earned slowly and word of mouth is the most influential channel; a person's name outperforms a contact form with this audience.

### 4.6 Editable facts — `Settings → Post 165`

Dues, member count, and the contact person go stale, and stale facts are worse than absent ones. A small admin screen (capability `manage_options`) exposes:

| Field | Sanitizer |
|---|---|
| Eligibility text | `sanitize_text_field` |
| Dues text | `sanitize_text_field` |
| Member count (true figure; displayed rounded per §4.5.1) | `absint` |
| Charter year | `absint` |
| Meeting rule — ordinal, weekday | whitelist |
| Meeting rule — time | `sanitize_text_field`, parsed to 24h |
| Venue name, street address | `sanitize_text_field` |
| Meeting overrides ×6 — month (`YYYY-MM`), date, time, venue, cancelled | `sanitize_text_field` / date validation / `absint` bool |
| Contact name, role | `sanitize_text_field` |
| Contact email | `sanitize_email`, output through `antispambot()` |
| Contact phone | `sanitize_text_field` |

All output escaped at render (`esc_html`, `esc_url`, `esc_attr`).

**Empty values must gracefully omit their row rather than printing an empty definition or a placeholder.** A missing member count renders no "Size" row at all.

### 4.7 Proof band (below the fold)

Two or three real photographs of members doing the work — honor guard, brat fry, flag placement — each with a plain caption naming what and when. This is the most direct available expression of "action rather than symbolism."

Captions are factual, not promotional. **Requires the post to supply images**; the band is omitted cleanly if none are set, and the layout must not depend on it.

### 4.8 What is deleted

- `home-hero` full-screen treatment → strap.
- The three category cards ("Public Events / Post Meetings / Honor Guard") → deleted. They announced taxonomy instead of content.
- The meta paragraph about keeping event types separated → deleted.
- `home-membership` and `how-we-serve` → merged into the join panel plus one condensed "what we do" row.
- `support-post-165` → folded into the condensed "what we do" row as a single line with a link. It does not remain a standalone band.
- `contact-card` → reduced to a single line in the condensed row; the join panel already carries the named contact.

The six homepage patterns are replaced by **three**: `home-board` (strap + board), `home-proof` (photo band), `home-what-we-do` (condensed row). `templates/front-page.html` references exactly these three.

## 5. Technical approach

Rendering uses **server-side dynamic blocks**, not raw PHP in pattern files. Theme pattern files are evaluated at registration and their output can be cached, which would freeze dates; a `render_callback` guarantees per-request evaluation.

```
inc/settings.php   register options, Settings → Post 165 screen, post165_get_fact() helper
inc/events.php     meeting-rule computation, TEC merge, quiet-season resolution, year map + filter
inc/blocks.php     register_block_type() for the dynamic blocks below
```

`functions.php` requires all three.

| Block | Renders |
|---|---|
| `post165/upcoming` | dated list + conditional quiet-season note |
| `post165/year-strip` | twelve-month rhythm |
| `post165/join-panel` | facts, button, named contact |

These are placed in `patterns/home-board.php`, referenced from `templates/front-page.html`.

Blocks register server-side with `api_version` 3 and a `render_callback`; no JS build step is introduced.

### CSS class contract

`.post165-strap`, `.post165-board`, `.post165-next`, `.post165-ev`, `.post165-ev--next`, `.post165-pill`, `.post165-quiet`, `.post165-year`, `.post165-join`, `.post165-fact`, `.post165-proof`.

Existing motif classes (`.post165-eyebrow`, `.post165-ribbon`, `.post165-seal`, page/404 templates) are unchanged.

## 6. Accessibility

- Two-column board collapses to one column at ~840px. **On mobile the event list comes first**, join panel second — the "when is it?" question is the more common mobile arrival.
- `Public` / `Members` distinction carries a text label; color is never the sole channel.
- Month abbreviations in the year strip expose full month names to assistive tech; current month marked `aria-current="date"`.
- Dates wrapped in `<time datetime>`.
- Contrast holds the AA rules established in the prior spec: gold-deep `#7a5a12` for gold-toned text on light surfaces, gold-light `#d9b45b` for links on navy. New pills verified: red `#9f1d2e` on white ≈ 8.6:1; `#3d4652` on `#dfe4ea` ≈ 7:1.
- The event list is a real list element; the facts panel is a `<dl>`.

## 7. Validation

`scripts/validate-theme.mjs` gains assertions for:

- `functions.php` requires `inc/settings.php`, `inc/events.php`, `inc/blocks.php`.
- Registration of all three block names.
- `style.css` contains `.post165-board`, `.post165-strap`, `.post165-year`, `.post165-join`.
- `front-page.html` references `post165/home-board`, `post165/home-proof`, and `post165/home-what-we-do`, and no longer references `home-hero`, `home-events`, `home-membership`, `how-we-serve`, `support-post-165`, or `contact-card`.

The validator remains a static string/palette checker; it does not execute WordPress. **Date logic and TEC merging are not covered by it** and require manual verification against a real install — see §9.

## 8. Non-goals

- No JS build step, framework, or client-side rendering.
- No redesign of interior pages, header, footer, palette, or typography.
- No custom post types; TEC remains the event source.
- No membership application form — the button links to the existing membership page.
- No carousel, parallax, or animation.

## 9. Open items before launch

These are **required from the post**; none may be invented in code:

1. Real dues amount and eligibility wording.
2. Current member count and confirmed charter year.
3. Contact person's name, role, email, phone.
4. Meeting venue name **and street address** — plus confirmation that "Manitowoc Rifle & Pistol Club" is still correct, given the post has no building of its own.
5. The verified twelve-month year map.
6. Photographs with factual captions, or an explicit decision to ship without the proof band.

Until supplied, fields render omitted rather than filled with plausible-looking placeholders.

**Manual verification required** (outside the validator), since none of this is reachable by static string checking:

- Correct meeting dates across a month boundary, and on the meeting day itself before and after the start time.
- Behaviour with TEC absent, and with TEC present but empty.
- The October–March quiet season, including that the note names the correct next milestone.
- Changing the standing rule (ordinal, weekday, time, venue) propagates to all future meetings.
- Each override kind in isolation: moved date, changed time, changed venue, cancelled.
- A cancelled month disappears cleanly and the list still renders five entries.
- A past-month override row is ignored rather than resurrecting an old meeting.
- Member count rounding at boundary values: 0, 3, 5, 183, 200.
