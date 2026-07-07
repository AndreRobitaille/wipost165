# Post 165 Visual Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn the structurally-sound-but-generic `post165` block theme into a dignified, distinctive site that expresses the "Still here. Still serving." narrative through a restrained flag motif, real self-hosted typography, and structural use of gold.

**Architecture:** Design tokens live in `theme.json`; a single hand-written `style.css` (now enqueued on the front end) carries the motif system; the motif is applied per-section by CSS class hooks in template parts and PHP block patterns. A "full dress vs. quiet" intensity dial keeps interior pages clean. Because this repo has no WordPress dev server, visual verification is done with a new static preview builder (`scripts/preview.mjs`) that inlines tokens, fonts, and the seal into one HTML file you open in a browser (or the brainstorm companion).

**Tech Stack:** WordPress block theme (`theme.json` v3, FSE templates/parts, PHP block patterns), self-hosted variable fonts (Fraunces + Public Sans, SIL OFL), Node 20 for `scripts/validate-theme.mjs` (the automated gate) and the new `scripts/preview.mjs`.

**Branch:** Continue on `design/visual-narrative-direction` (the spec is already committed there).

---

## Design spec

Source of truth: `docs/superpowers/specs/2026-07-07-visual-design-and-narrative-direction.md`. Read it before starting.

## Design System Reference (the contract every task must honor)

**Do not rename these** — CSS in Task 4 and markup in Tasks 5–12 must match exactly.

**Palette (theme.json slugs, unchanged slugs so the validator stays green):**
`navy #0e2340` (deepened) · `cream #f7f1e3` · `gold #c49a3a` · `red #9f1d2e` · `ink #1f2933` · `white #ffffff`
Plus one derived on-navy accent: `--wp--custom--gold-light: #d9b45b` (the *only* place the lighter gold is allowed).

**Font-family presets (slugs kept as `serif`/`sans` so existing element references keep working):**
- `serif` → **Fraunces** (display / headings)
- `sans` → **Public Sans** (UI / body)

**CSS class hooks (defined in `style.css`, used by markup):**
- `.post165-header` — navy header wrapper
- `.post165-seal` — 40px square, `assets/images/seal.svg` as background
- `.post165-wordmark`, `.post165-wordmark__org`, `.post165-wordmark__name`
- `.post165-hero` — relative box; draws the 3-color stripe "spine" via `::before`
- `.post165-hero__content` — inner group lifted above the watermark
- `.post165-hero-watermark` — faint seal, top/right
- `.post165-eyebrow` — gold, star-prefixed, uppercase (auto-switches to `gold-light` on navy)
- `.post165-ribbon` — short gold gradient rule (`<hr>`); `.post165-ribbon--center` centers it
- `.post165-strip`, `.post165-strip__k`, `.post165-strip__v` — hero meeting-info strip
- `.post165-card` — event/feature card (gold top rule)
- `.post165-star-list` — list with gold star markers
- `.post165-page-eyebrow` — interior-page eyebrow
- `.post165-footer` — footer refinements

**Removed:** `.post165-top-rule`, `.post165-section-divider` (replaced by `.post165-ribbon`).

**Validator invariants that must never break** (`scripts/validate-theme.mjs`): required files exist; `theme.json` valid JSON with palette slugs navy/cream/gold/red; and the literal snippets it greps for in `style.css`, `functions.php`, `front-page.html`, `header.html`, `footer.html`, and each home pattern (e.g. `Learn About Membership`, `View Events`, `Public Events`, `Post Meetings`, `Honor Guard`, `veterans`, `families`, `Veterans`, `Youth`, `Remembrance`, `Community`, `Support Post 165`, `wipost165@gmail.com`, `PO Box 11`, `First Tuesday`). Every rewrite below preserves these.

---

## MILESTONE A — Foundation: make styles and fonts actually load

### Task 1: Enqueue the stylesheet on the front end + add logo support

The current `functions.php` only registers the stylesheet as an *editor* style and never enqueues it on the front end, and there is no logo support. Fix both.

**Files:**
- Modify: `wp-content/themes/post165/functions.php`
- Modify: `scripts/validate-theme.mjs`

- [ ] **Step 1: Add failing validator assertions.** In `scripts/validate-theme.mjs`, extend the `requiredText` snippet list for `functions.php`. Change its entry from:

```js
['wp-content/themes/post165/functions.php', ['post165_setup', 'post165_register_pattern_categories', 'add_theme_support']],
```

to:

```js
['wp-content/themes/post165/functions.php', ['post165_setup', 'post165_register_pattern_categories', 'add_theme_support', 'wp_enqueue_style', "add_theme_support( 'custom-logo'"]],
```

- [ ] **Step 2: Run the validator to confirm it fails.**

Run: `npm test`
Expected: FAIL — `functions.php must include: wp_enqueue_style` and `... custom-logo`.

- [ ] **Step 3: Implement.** Replace the entire body of `wp-content/themes/post165/functions.php` with:

```php
<?php
/**
 * Theme setup for Post 165.
 *
 * @package Post165
 */

if ( ! defined( 'ABSPATH' ) ) {
    exit;
}

function post165_setup(): void {
    add_theme_support( 'wp-block-styles' );
    add_theme_support( 'editor-styles' );
    add_theme_support(
        'custom-logo',
        array(
            'height'      => 96,
            'width'       => 96,
            'flex-height' => true,
            'flex-width'  => true,
        )
    );
    add_editor_style( 'style.css' );
}
add_action( 'after_setup_theme', 'post165_setup' );

function post165_enqueue_assets(): void {
    wp_enqueue_style(
        'post165-style',
        get_stylesheet_uri(),
        array(),
        wp_get_theme()->get( 'Version' )
    );
}
add_action( 'wp_enqueue_scripts', 'post165_enqueue_assets' );

function post165_register_pattern_categories(): void {
    register_block_pattern_category(
        'post165',
        array( 'label' => __( 'Post 165', 'post165' ) )
    );
}
add_action( 'init', 'post165_register_pattern_categories' );
```

- [ ] **Step 4: Run the validator to confirm it passes.**

Run: `npm test`
Expected: PASS — "Theme validation passed."

- [ ] **Step 5: Commit.**

```bash
git add wp-content/themes/post165/functions.php scripts/validate-theme.mjs
git commit -m "fix: enqueue theme stylesheet on front end and add custom-logo support"
```

---

### Task 2: Bundle the typefaces and the seal mark

Self-host Fraunces + Public Sans (fixes the never-loads bug — no CDN dependency on shared hosting) and add a custom star "seal" used as the header mark and hero watermark. The seal is our own mark, not the official Legion emblem; the official emblem can replace it later where usage guidelines allow (documented in Task 13).

**Files:**
- Create: `wp-content/themes/post165/assets/fonts/fraunces-latin.woff2`
- Create: `wp-content/themes/post165/assets/fonts/public-sans-latin.woff2`
- Create: `wp-content/themes/post165/assets/images/seal.svg`

- [ ] **Step 1: Download the two variable fonts (latin subset).** Run:

```bash
UA='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36'
mkdir -p wp-content/themes/post165/assets/fonts wp-content/themes/post165/assets/images

fetch_latin_woff2() {
  # $1 = Google CSS2 URL, $2 = output path
  css=$(curl -sL -A "$UA" "$1")
  url=$(printf '%s' "$css" | awk 'BEGIN{RS="}"} /U\+0000-00FF/{ if (match($0,/https:[^)]+\.woff2/)) print substr($0,RSTART,RLENGTH) }' | head -1)
  curl -sL -A "$UA" -o "$2" "$url"
}

fetch_latin_woff2 "https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300..700&display=swap" wp-content/themes/post165/assets/fonts/fraunces-latin.woff2
fetch_latin_woff2 "https://fonts.googleapis.com/css2?family=Public+Sans:wght@300..700&display=swap" wp-content/themes/post165/assets/fonts/public-sans-latin.woff2
```

- [ ] **Step 2: Verify the fonts downloaded and look sane.**

Run: `ls -l wp-content/themes/post165/assets/fonts/ && file wp-content/themes/post165/assets/fonts/*.woff2`
Expected: two `.woff2` files, each > 20 KB, reported as `Web Open Font Format (Version 2)`.
If a file is tiny/HTML (network blocked), stop and resolve networking before continuing — the whole redesign depends on these loading.

- [ ] **Step 3: Create the seal mark.** Write `wp-content/themes/post165/assets/images/seal.svg`:

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" role="img" aria-label="Post 165 seal">
  <circle cx="50" cy="50" r="46" fill="none" stroke="#c49a3a" stroke-width="3"/>
  <circle cx="50" cy="50" r="37" fill="none" stroke="#9f1d2e" stroke-width="2"/>
  <path d="M50 27l6.5 13.4 14.8 2-10.7 10.4 2.6 14.7L50 60.6 36.8 67.5l2.6-14.7L28.7 42.4l14.8-2z" fill="#c49a3a"/>
</svg>
```

- [ ] **Step 4: Commit.**

```bash
git add wp-content/themes/post165/assets
git commit -m "feat: bundle Fraunces + Public Sans and add post seal mark"
```

---

### Task 3: Overhaul `theme.json` (tokens, fonts, element styles)

Deepen navy, register the bundled fonts via `fontFace` (WordPress emits `@font-face` automatically), add the derived gold-light custom token, and refine element styles.

**Files:**
- Modify: `wp-content/themes/post165/theme.json`

- [ ] **Step 1: Replace the whole file** with:

```json
{
  "$schema": "https://schemas.wp.org/trunk/theme.json",
  "version": 3,
  "settings": {
    "appearanceTools": true,
    "layout": {
      "contentSize": "760px",
      "wideSize": "1160px"
    },
    "custom": {
      "goldLight": "#d9b45b"
    },
    "color": {
      "defaultDuotone": false,
      "defaultGradients": false,
      "defaultPalette": false,
      "palette": [
        { "slug": "navy", "name": "Navy", "color": "#0e2340" },
        { "slug": "cream", "name": "Cream", "color": "#f7f1e3" },
        { "slug": "gold", "name": "Gold", "color": "#c49a3a" },
        { "slug": "red", "name": "Red", "color": "#9f1d2e" },
        { "slug": "ink", "name": "Ink", "color": "#1f2933" },
        { "slug": "white", "name": "White", "color": "#ffffff" }
      ]
    },
    "spacing": {
      "spacingScale": {
        "operator": "*",
        "increment": 1.5,
        "steps": 6,
        "mediumStep": 1.5,
        "unit": "rem"
      },
      "units": ["px", "rem", "%", "vw", "vh"]
    },
    "typography": {
      "defaultFontSizes": false,
      "fluid": true,
      "fontFamilies": [
        {
          "slug": "serif",
          "name": "Serif",
          "fontFamily": "Fraunces, Georgia, 'Times New Roman', serif",
          "fontFace": [
            {
              "fontFamily": "Fraunces",
              "fontStyle": "normal",
              "fontWeight": "300 700",
              "fontStretch": "normal",
              "src": ["file:./assets/fonts/fraunces-latin.woff2"]
            }
          ]
        },
        {
          "slug": "sans",
          "name": "Sans",
          "fontFamily": "'Public Sans', ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif",
          "fontFace": [
            {
              "fontFamily": "Public Sans",
              "fontStyle": "normal",
              "fontWeight": "300 700",
              "fontStretch": "normal",
              "src": ["file:./assets/fonts/public-sans-latin.woff2"]
            }
          ]
        }
      ],
      "fontSizes": [
        { "slug": "small", "name": "Small", "size": "0.9rem" },
        { "slug": "medium", "name": "Medium", "size": "1.05rem" },
        { "slug": "large", "name": "Large", "size": "1.3rem", "fluid": { "min": "1.15rem", "max": "1.35rem" } },
        { "slug": "x-large", "name": "Extra Large", "size": "2rem", "fluid": { "min": "1.7rem", "max": "2.4rem" } },
        { "slug": "hero", "name": "Hero", "size": "clamp(2.4rem, 6vw, 4.5rem)" }
      ]
    }
  },
  "styles": {
    "color": {
      "background": "var(--wp--preset--color--cream)",
      "text": "var(--wp--preset--color--ink)"
    },
    "typography": {
      "fontFamily": "var(--wp--preset--font-family--sans)",
      "fontSize": "var(--wp--preset--font-size--medium)",
      "lineHeight": "1.65"
    },
    "elements": {
      "button": {
        "border": { "radius": "999px" },
        "color": { "background": "var(--wp--preset--color--red)", "text": "var(--wp--preset--color--white)" },
        "spacing": { "padding": { "top": "0.8rem", "right": "1.4rem", "bottom": "0.8rem", "left": "1.4rem" } },
        "typography": { "fontWeight": "700", "letterSpacing": "0.02em" },
        ":hover": { "color": { "background": "var(--wp--preset--color--navy)", "text": "var(--wp--preset--color--white)" } },
        ":focus": { "color": { "background": "var(--wp--preset--color--navy)", "text": "var(--wp--preset--color--white)" } }
      },
      "heading": {
        "color": { "text": "var(--wp--preset--color--navy)" },
        "typography": { "fontFamily": "var(--wp--preset--font-family--serif)", "fontWeight": "600", "lineHeight": "1.1", "letterSpacing": "-0.01em" }
      },
      "link": {
        "color": { "text": "var(--wp--preset--color--red)" },
        ":hover": { "color": { "text": "var(--wp--preset--color--navy)" } }
      }
    },
    "blocks": {
      "core/navigation": {
        "typography": { "fontSize": "var(--wp--preset--font-size--small)", "fontWeight": "700", "letterSpacing": "0.04em", "textTransform": "uppercase" }
      }
    }
  },
  "templateParts": [
    { "name": "header", "title": "Header", "area": "header" },
    { "name": "footer", "title": "Footer", "area": "footer" }
  ]
}
```

- [ ] **Step 2: Verify it is valid JSON with the required palette.**

Run: `npm test`
Expected: PASS. (The validator parses `theme.json` and checks navy/cream/gold/red slugs — all present.)

- [ ] **Step 3: Commit.**

```bash
git add wp-content/themes/post165/theme.json
git commit -m "feat: deepen navy, register self-hosted fonts, refine element styles"
```

---

## MILESTONE B — The motif system (CSS + preview harness)

### Task 4: Rewrite `style.css` with the full motif system

**Files:**
- Modify: `wp-content/themes/post165/style.css`
- Modify: `scripts/validate-theme.mjs`

- [ ] **Step 1: Add a failing validator assertion** for the new motif classes. In `scripts/validate-theme.mjs`, update the `style.css` entry from:

```js
['wp-content/themes/post165/style.css', ['Theme Name: Post 165', 'Text Domain: post165', 'Requires at least: 6.5']],
```

to:

```js
['wp-content/themes/post165/style.css', ['Theme Name: Post 165', 'Text Domain: post165', 'Requires at least: 6.5', '.post165-hero', '.post165-ribbon', '.post165-seal']],
```

- [ ] **Step 2: Run the validator to confirm it fails.**

Run: `npm test`
Expected: FAIL — `style.css must include: .post165-hero` (etc.).

- [ ] **Step 3: Replace the whole `style.css`** with (note the theme header block is preserved verbatim so the validator's `Theme Name` / `Text Domain` / `Requires at least` snippets stay present; version bumped):

```css
/*
Theme Name: Post 165
Theme URI: https://wipost165.org
Author: Robert E. Burns American Legion Post 165
Description: Custom block theme for Robert E. Burns American Legion Post 165 in Two Rivers, Wisconsin.
Version: 0.2.0
Requires at least: 6.5
Requires PHP: 8.0
Tested up to: 6.6
License: GNU General Public License v2 or later
License URI: https://www.gnu.org/licenses/gpl-2.0.html
Text Domain: post165
Tags: block-patterns, full-site-editing, accessibility-ready
*/

:root {
  --p165-gold-light: var(--wp--custom--gold-light, #d9b45b);
}

@media (prefers-reduced-motion: no-preference) {
  html { scroll-behavior: smooth; }
}

body {
  background: var(--wp--preset--color--cream);
  color: var(--wp--preset--color--ink);
}

a { text-underline-offset: 0.18em; }

.wp-site-blocks { min-height: 100vh; }

/* ---------- Header + wordmark ---------- */
.post165-header .wp-block-navigation a { color: rgba(247, 241, 227, 0.82); }
.post165-header .wp-block-navigation a:hover,
.post165-header .wp-block-navigation .current-menu-item a { color: var(--p165-gold-light); }

.post165-seal {
  display: inline-block;
  width: 40px;
  height: 40px;
  flex: 0 0 40px;
  background: center / contain no-repeat url('assets/images/seal.svg');
}

.post165-wordmark { line-height: 1.06; }
.post165-wordmark__org {
  display: block;
  font-family: var(--wp--preset--font-family--sans);
  font-size: 0.62rem;
  font-weight: 800;
  letter-spacing: 0.16em;
  text-transform: uppercase;
  color: var(--p165-gold-light);
}
.post165-wordmark__name {
  display: block;
  font-family: var(--wp--preset--font-family--serif);
  font-size: 1.15rem;
  font-weight: 600;
  letter-spacing: 0.01em;
  color: var(--wp--preset--color--white);
}

/* ---------- Eyebrow (gold, star-prefixed) ---------- */
.post165-eyebrow {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 1rem;
  color: var(--wp--preset--color--gold);
  font-family: var(--wp--preset--font-family--sans);
  font-size: 0.72rem;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
}
.post165-eyebrow::before { content: "\2605"; font-size: 0.85em; }
.has-text-align-center.post165-eyebrow { justify-content: center; }

/* On navy surfaces the eyebrow uses the lighter gold */
.has-navy-background-color .post165-eyebrow,
.post165-hero .post165-eyebrow { color: var(--p165-gold-light); }

/* ---------- Ribbon rule (the connective thread) ---------- */
.post165-ribbon {
  border: 0;
  height: 3px;
  width: 64px;
  margin: 0 0 1.25rem;
  background: linear-gradient(90deg, var(--wp--preset--color--gold), transparent);
}
.post165-ribbon--center { margin-left: auto; margin-right: auto; }
.has-navy-background-color .post165-ribbon,
.post165-hero .post165-ribbon,
.post165-footer .post165-ribbon {
  background: linear-gradient(90deg, var(--p165-gold-light), transparent);
}

/* ---------- Hero (full dress) ---------- */
.post165-hero { position: relative; overflow: hidden; }
.post165-hero::before {
  content: "";
  position: absolute;
  left: 0; top: 0; bottom: 0;
  width: 12px;
  background: linear-gradient(
    to bottom,
    var(--wp--preset--color--red) 0 33.33%,
    var(--wp--preset--color--cream) 33.33% 66.66%,
    var(--wp--preset--color--gold) 66.66% 100%
  );
}
.post165-hero-watermark {
  position: absolute;
  right: -3rem;
  top: 50%;
  transform: translateY(-50%);
  width: 22rem;
  height: 22rem;
  opacity: 0.07;
  pointer-events: none;
  background: center / contain no-repeat url('assets/images/seal.svg');
}
.post165-hero__content { position: relative; z-index: 1; }

/* Outlined secondary button on the navy hero */
.post165-hero .is-style-outline .wp-block-button__link {
  background: transparent;
  border: 1.5px solid var(--p165-gold-light);
  color: var(--p165-gold-light);
}
.post165-hero .is-style-outline .wp-block-button__link:hover {
  background: var(--p165-gold-light);
  color: var(--wp--preset--color--navy);
}

/* ---------- Hero meeting-info strip ---------- */
.post165-strip { border-top: 1px solid color-mix(in srgb, var(--p165-gold-light) 45%, transparent); }
.post165-strip .wp-block-column {
  padding: 0.9rem 1.3rem;
  border-right: 1px solid color-mix(in srgb, var(--p165-gold-light) 25%, transparent);
}
.post165-strip .wp-block-column:last-child { border-right: 0; }
.post165-strip__k {
  margin: 0 0 0.3rem;
  font-family: var(--wp--preset--font-family--sans);
  font-size: 0.58rem;
  font-weight: 700;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  color: var(--p165-gold-light);
}
.post165-strip__v {
  margin: 0;
  font-family: var(--wp--preset--font-family--serif);
  font-size: 0.95rem;
  color: var(--wp--preset--color--cream);
}

/* ---------- Cards ---------- */
.post165-card {
  border: 1px solid color-mix(in srgb, var(--wp--preset--color--navy) 15%, transparent);
  border-top: 3px solid var(--wp--preset--color--gold);
  border-radius: 0.65rem;
  box-shadow: 0 0.75rem 2rem color-mix(in srgb, var(--wp--preset--color--navy) 8%, transparent);
}

/* ---------- Star lists ---------- */
.post165-star-list { list-style: none; padding-left: 0; }
.post165-star-list li { position: relative; padding-left: 1.6rem; margin-bottom: 0.4rem; }
.post165-star-list li::before {
  content: "\2605";
  position: absolute;
  left: 0;
  color: var(--wp--preset--color--gold);
}

/* ---------- Interior page eyebrow ---------- */
.post165-page-eyebrow {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--wp--preset--color--gold);
  font-family: var(--wp--preset--font-family--sans);
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.18em;
  text-transform: uppercase;
}
.post165-page-eyebrow::before { content: "\2605"; font-size: 0.85em; }
```

- [ ] **Step 4: Run the validator to confirm it passes.**

Run: `npm test`
Expected: PASS.

- [ ] **Step 5: Commit.**

```bash
git add wp-content/themes/post165/style.css scripts/validate-theme.mjs
git commit -m "feat: add restrained flag-motif design system to stylesheet"
```

---

### Task 5: Add the static preview builder

This lets you *see* the theme without WordPress: it inlines tokens (from `theme.json`), the two fonts (base64), and the seal into one self-contained HTML file, then assembles header + front-page patterns + footer.

**Files:**
- Create: `scripts/preview.mjs`
- Modify: `.gitignore`

- [ ] **Step 1: Write `scripts/preview.mjs`:**

```js
import { readFileSync, writeFileSync } from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const theme = path.join(root, 'wp-content/themes/post165');
const outArg = process.argv.indexOf('--out');
const out = outArg !== -1 ? process.argv[outArg + 1] : path.join(root, 'theme-preview.html');

const themeJson = JSON.parse(readFileSync(path.join(theme, 'theme.json'), 'utf8'));

// :root custom properties from palette, font families, font sizes, custom tokens
const vars = [];
for (const c of themeJson.settings.color.palette) vars.push(`--wp--preset--color--${c.slug}: ${c.color};`);
for (const f of themeJson.settings.typography.fontFamilies) vars.push(`--wp--preset--font-family--${f.slug}: ${f.fontFamily};`);
for (const s of themeJson.settings.typography.fontSizes) vars.push(`--wp--preset--font-size--${s.slug}: ${s.size};`);
if (themeJson.settings.custom?.goldLight) vars.push(`--wp--custom--gold-light: ${themeJson.settings.custom.goldLight};`);

// @font-face from fontFace src, inlined as base64 data URIs
const faces = [];
for (const f of themeJson.settings.typography.fontFamilies) {
  for (const face of f.fontFace ?? []) {
    const rel = face.src[0].replace('file:./', '');
    const b64 = readFileSync(path.join(theme, rel)).toString('base64');
    faces.push(`@font-face{font-family:${JSON.stringify(face.fontFamily)};font-style:${face.fontStyle};font-weight:${face.fontWeight};font-display:swap;src:url(data:font/woff2;base64,${b64}) format('woff2');}`);
  }
}

// stylesheet: strip theme header comment, inline the seal as a data URI
const seal = readFileSync(path.join(theme, 'assets/images/seal.svg'), 'utf8');
const sealUri = `data:image/svg+xml,${encodeURIComponent(seal)}`;
let css = readFileSync(path.join(theme, 'style.css'), 'utf8').replace(/\/\*[\s\S]*?\*\//, '');
css = css.replace(/url\((['"]?)assets\/images\/seal\.svg\1\)/g, `url("${sealUri}")`);

// pattern slug -> file
const patternFiles = {
  'post165/home-hero': 'patterns/home-hero.php',
  'post165/home-events': 'patterns/home-events.php',
  'post165/home-membership': 'patterns/home-membership.php',
  'post165/how-we-serve': 'patterns/how-we-serve.php',
  'post165/support-post-165': 'patterns/support-post-165.php',
  'post165/contact-card': 'patterns/contact-card.php',
};

const stripPhp = (s) =>
  s
    .replace(/<\?php\s+echo\s+esc_url\([^?]*\)\s*;\s*\?>/g, '#') // links -> '#'
    .replace(/<\?php[\s\S]*?\?>/g, '') // pattern header + anything else
    .trim();

const readPart = (rel) => stripPhp(readFileSync(path.join(theme, rel), 'utf8'));

// assemble main from the front-page pattern list, in order
const main = Object.keys(patternFiles).map((slug) => readPart(patternFiles[slug])).join('\n');
const header = readPart('parts/header.html');
const footer = readPart('parts/footer.html');

const html = `<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Post 165 preview</title><style>:root{${vars.join('')}}${faces.join('')}
body{margin:0;font-family:var(--wp--preset--font-family--sans);}
.wp-block-group{box-sizing:border-box;}
.wp-block-group.alignwide,.wp-block-group[class*="constrained"]>*{max-width:1160px;margin-left:auto;margin-right:auto;}
:where(.wp-block-columns){display:flex;gap:1.5rem;flex-wrap:wrap;}
:where(.wp-block-column){flex:1;min-width:200px;}
.wp-block-buttons{display:flex;gap:0.6rem;flex-wrap:wrap;}
.wp-block-button__link{display:inline-block;background:var(--wp--preset--color--red);color:#fff;border-radius:999px;padding:0.8rem 1.4rem;font-weight:700;text-decoration:none;}
.has-navy-background-color{background:var(--wp--preset--color--navy);}
.has-cream-background-color{background:var(--wp--preset--color--cream);}
.has-white-background-color{background:var(--wp--preset--color--white);}
.has-white-color{color:#fff;}.has-navy-color{color:var(--wp--preset--color--navy);}
.has-hero-font-size{font-size:var(--wp--preset--font-size--hero);}
.has-large-font-size{font-size:var(--wp--preset--font-size--large);}
.has-medium-font-size{font-size:var(--wp--preset--font-size--medium);}
.has-small-font-size{font-size:var(--wp--preset--font-size--small);}
.has-x-large-font-size{font-size:var(--wp--preset--font-size--x-large);}
h1,h2,h3{font-family:var(--wp--preset--font-family--serif);color:var(--wp--preset--color--navy);line-height:1.1;letter-spacing:-0.01em;}
.has-white-color h1,.has-white-color h2,.has-white-color h3,.has-navy-background-color h2{color:#fff;}
a{color:var(--wp--preset--color--red);}
${css}</style></head><body>${header}<main>${main}</main>${footer}</body></html>`;

writeFileSync(out, html);
console.log(`Preview written to ${out}`);
```

- [ ] **Step 2: Ignore generated previews.** Append to `.gitignore`:

```
theme-preview.html
```

- [ ] **Step 3: Build and view.**

Run: `node scripts/preview.mjs && echo "open theme-preview.html in a browser"`
Expected: "Preview written to …/theme-preview.html". Open it in a browser (or copy into the brainstorm companion's content dir). At this point it still shows the *old* patterns styled with the *new* tokens/CSS — fonts should now be Fraunces/Public Sans, navy deepened. This is your baseline before the markup rewrites.

- [ ] **Step 4: Commit.**

```bash
git add scripts/preview.mjs .gitignore
git commit -m "chore: add static theme preview builder for visual verification"
```

> **From here on, every markup task's visual check is:** `node scripts/preview.mjs` then reload `theme-preview.html` in the browser.

---

## MILESTONE C — Apply the motif to templates, parts, and patterns

### Task 6: Rebuild the header (navy, seal, wordmark)

**Files:**
- Modify: `wp-content/themes/post165/parts/header.html`

- [ ] **Step 1: Replace the whole file** with (keeps the validator snippets `wp:navigation` and `Robert E. Burns American Legion Post 165`):

```html
<!-- wp:group {"className":"post165-header","style":{"spacing":{"padding":{"top":"0.9rem","bottom":"0.9rem","left":"1.5rem","right":"1.5rem"}}},"backgroundColor":"navy","layout":{"type":"constrained","wideSize":"1160px"}} -->
<div class="wp-block-group post165-header has-navy-background-color has-background" style="padding-top:0.9rem;padding-right:1.5rem;padding-bottom:0.9rem;padding-left:1.5rem"><!-- wp:group {"align":"wide","layout":{"type":"flex","flexWrap":"nowrap","justifyContent":"space-between","verticalAlignment":"center"}} -->
<div class="wp-block-group alignwide"><!-- wp:group {"style":{"spacing":{"blockGap":"0.65rem"}},"layout":{"type":"flex","flexWrap":"nowrap","verticalAlignment":"center"}} -->
<div class="wp-block-group"><!-- wp:html -->
<span class="post165-seal" role="img" aria-label="Post 165 seal"></span>
<!-- /wp:html -->

<!-- wp:html -->
<span class="post165-wordmark"><span class="post165-wordmark__org">Robert E. Burns American Legion Post 165</span><span class="post165-wordmark__name">Post 165</span></span>
<!-- /wp:html --></div>
<!-- /wp:group -->

<!-- wp:navigation {"overlayMenu":"mobile","layout":{"type":"flex","justifyContent":"right"}} -->
<!-- wp:navigation-link {"label":"Home","url":"/","kind":"custom","isTopLevelLink":true} /-->
<!-- wp:navigation-link {"label":"Events","url":"/events/","kind":"custom","isTopLevelLink":true} /-->
<!-- wp:navigation-link {"label":"Membership","url":"/membership/","kind":"custom","isTopLevelLink":true} /-->
<!-- wp:navigation-link {"label":"About","url":"/about/","kind":"custom","isTopLevelLink":true} /-->
<!-- wp:navigation-link {"label":"Contact","url":"/contact/","kind":"custom","isTopLevelLink":true} /-->
<!-- /wp:navigation --></div>
<!-- /wp:group --></div>
<!-- /wp:group -->
```

- [ ] **Step 2: Verify.** Run `npm test` (PASS), then `node scripts/preview.mjs` and reload — header is navy with the gold-ringed seal, the small-caps org line over "Post 165" in Fraunces, and nav links in cream turning gold on hover.

- [ ] **Step 3: Commit.**

```bash
git add wp-content/themes/post165/parts/header.html
git commit -m "feat: rebuild header with navy bar, seal, and wordmark lockup"
```

---

### Task 7: Rebuild the hero (full dress)

**Files:**
- Modify: `wp-content/themes/post165/patterns/home-hero.php`

- [ ] **Step 1: Replace the whole file** with (keeps `Learn About Membership` and `View Events`):

```php
<?php
/**
 * Title: Home hero
 * Slug: post165/home-hero
 * Categories: post165
 */
?>
<!-- wp:group {"className":"post165-hero","style":{"spacing":{"padding":{"top":"5rem","right":"1.5rem","bottom":"0rem","left":"1.75rem"}}},"backgroundColor":"navy","textColor":"white","layout":{"type":"constrained","wideSize":"1160px"}} -->
<div class="wp-block-group post165-hero has-white-color has-navy-background-color has-text-color has-background" style="padding-top:5rem;padding-right:1.5rem;padding-bottom:0rem;padding-left:1.75rem"><!-- wp:html -->
<span class="post165-hero-watermark" aria-hidden="true"></span>
<!-- /wp:html -->

<!-- wp:group {"className":"post165-hero__content","align":"wide","style":{"spacing":{"padding":{"bottom":"4rem"}}},"layout":{"type":"constrained","contentSize":"860px","justifyContent":"left"}} -->
<div class="wp-block-group post165-hero__content alignwide" style="padding-bottom:4rem"><!-- wp:paragraph {"className":"post165-eyebrow"} -->
<p class="post165-eyebrow">Two Rivers, Wisconsin · Serving since 1919</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":1,"textColor":"white","fontSize":"hero"} -->
<h1 class="wp-block-heading has-white-color has-text-color has-hero-font-size">A century of veterans, still serving Two Rivers.</h1>
<!-- /wp:heading -->

<!-- wp:separator {"className":"post165-ribbon"} -->
<hr class="wp-block-separator has-alpha-channel-opacity post165-ribbon"/>
<!-- /wp:separator -->

<!-- wp:paragraph {"fontSize":"large"} -->
<p class="has-large-font-size">Robert E. Burns American Legion Post 165 is a home for veterans, their families, and neighbors who want to serve. You are welcome here — start by coming to an event.</p>
<!-- /wp:paragraph -->

<!-- wp:buttons {"style":{"spacing":{"margin":{"top":"2rem"}}}} -->
<div class="wp-block-buttons" style="margin-top:2rem"><!-- wp:button {"backgroundColor":"red","textColor":"white"} -->
<div class="wp-block-button"><a class="wp-block-button__link has-white-color has-red-background-color has-text-color has-background wp-element-button" href="<?php echo esc_url( home_url( '/membership/' ) ); ?>">Learn About Membership</a></div>
<!-- /wp:button -->

<!-- wp:button {"className":"is-style-outline"} -->
<div class="wp-block-button is-style-outline"><a class="wp-block-button__link wp-element-button" href="<?php echo esc_url( home_url( '/events/' ) ); ?>">View Events</a></div>
<!-- /wp:button --></div>
<!-- /wp:buttons --></div>
<!-- /wp:group -->

<!-- wp:columns {"className":"post165-strip","align":"wide"} -->
<div class="wp-block-columns alignwide post165-strip"><!-- wp:column -->
<div class="wp-block-column"><!-- wp:paragraph {"className":"post165-strip__k"} --><p class="post165-strip__k">Meetings</p><!-- /wp:paragraph --><!-- wp:paragraph {"className":"post165-strip__v"} --><p class="post165-strip__v">First Tuesday · 6:30 pm</p><!-- /wp:paragraph --></div>
<!-- /wp:column -->

<!-- wp:column -->
<div class="wp-block-column"><!-- wp:paragraph {"className":"post165-strip__k"} --><p class="post165-strip__k">Where</p><!-- /wp:paragraph --><!-- wp:paragraph {"className":"post165-strip__v"} --><p class="post165-strip__v">Manitowoc Rifle &amp; Pistol Club</p><!-- /wp:paragraph --></div>
<!-- /wp:column -->

<!-- wp:column -->
<div class="wp-block-column"><!-- wp:paragraph {"className":"post165-strip__k"} --><p class="post165-strip__k">Welcome</p><!-- /wp:paragraph --><!-- wp:paragraph {"className":"post165-strip__v"} --><p class="post165-strip__v">Veterans &amp; families</p><!-- /wp:paragraph --></div>
<!-- /wp:column --></div>
<!-- /wp:columns --></div>
<!-- /wp:group -->
```

- [ ] **Step 2: Verify.** `npm test` (PASS), then `node scripts/preview.mjs` and reload — navy hero with the red/cream/gold stripe spine on the left edge, faint seal watermark on the right, gold star eyebrow, big Fraunces headline, gold ribbon rule, red primary + gold-outline secondary buttons, and a bordered meeting-info strip across the bottom.

- [ ] **Step 3: Commit.**

```bash
git add wp-content/themes/post165/patterns/home-hero.php
git commit -m "feat: full-dress hero with stripe spine, watermark, and meeting strip"
```

---

### Task 8: Refine the events section

**Files:**
- Modify: `wp-content/themes/post165/patterns/home-events.php`

- [ ] **Step 1: Replace the whole file** with (keeps `Public Events`, `Post Meetings`, `Honor Guard`, `View Events`):

```php
<?php
/**
 * Title: Home events overview
 * Slug: post165/home-events
 * Categories: post165
 */
?>
<!-- wp:group {"style":{"spacing":{"padding":{"top":"4.5rem","right":"1rem","bottom":"4.5rem","left":"1rem"}}},"backgroundColor":"cream","layout":{"type":"constrained","wideSize":"1160px"}} -->
<div class="wp-block-group has-cream-background-color has-background" style="padding-top:4.5rem;padding-right:1rem;padding-bottom:4.5rem;padding-left:1rem"><!-- wp:paragraph {"className":"post165-eyebrow has-text-align-center"} -->
<p class="post165-eyebrow has-text-align-center">Here now</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"textAlign":"center"} -->
<h2 class="wp-block-heading has-text-align-center">Upcoming at Post 165</h2>
<!-- /wp:heading -->

<!-- wp:paragraph {"align":"center"} -->
<p class="has-text-align-center">Public events, post meetings, and ceremonial service each have a different purpose. We keep them separated so visitors can quickly find what applies to them.</p>
<!-- /wp:paragraph -->

<!-- wp:columns {"align":"wide","style":{"spacing":{"margin":{"top":"2.5rem"}}}} -->
<div class="wp-block-columns alignwide" style="margin-top:2.5rem"><!-- wp:column {"className":"post165-card","style":{"spacing":{"padding":{"top":"1.6rem","right":"1.6rem","bottom":"1.6rem","left":"1.6rem"}}},"backgroundColor":"white"} -->
<div class="wp-block-column post165-card has-white-background-color has-background" style="padding-top:1.6rem;padding-right:1.6rem;padding-bottom:1.6rem;padding-left:1.6rem"><!-- wp:heading {"level":3,"fontSize":"large"} --><h3 class="wp-block-heading has-large-font-size">Public Events</h3><!-- /wp:heading --><!-- wp:paragraph --><p>Community events, youth activities, fundraisers, banquets, and other gatherings open to neighbors and friends of the post.</p><!-- /wp:paragraph --></div>
<!-- /wp:column -->

<!-- wp:column {"className":"post165-card","style":{"spacing":{"padding":{"top":"1.6rem","right":"1.6rem","bottom":"1.6rem","left":"1.6rem"}}},"backgroundColor":"white"} -->
<div class="wp-block-column post165-card has-white-background-color has-background" style="padding-top:1.6rem;padding-right:1.6rem;padding-bottom:1.6rem;padding-left:1.6rem"><!-- wp:heading {"level":3,"fontSize":"large"} --><h3 class="wp-block-heading has-large-font-size">Post Meetings</h3><!-- /wp:heading --><!-- wp:paragraph --><p>Post meetings and member business. Regular meetings are held the first Tuesday of each month at 6:30 pm.</p><!-- /wp:paragraph --></div>
<!-- /wp:column -->

<!-- wp:column {"className":"post165-card","style":{"spacing":{"padding":{"top":"1.6rem","right":"1.6rem","bottom":"1.6rem","left":"1.6rem"}}},"backgroundColor":"white"} -->
<div class="wp-block-column post165-card has-white-background-color has-background" style="padding-top:1.6rem;padding-right:1.6rem;padding-bottom:1.6rem;padding-left:1.6rem"><!-- wp:heading {"level":3,"fontSize":"large"} --><h3 class="wp-block-heading has-large-font-size">Honor Guard</h3><!-- /wp:heading --><!-- wp:paragraph --><p>Ceremonies and observances where the community gathers to honor service, sacrifice, and remembrance.</p><!-- /wp:paragraph --></div>
<!-- /wp:column --></div>
<!-- /wp:columns -->

<!-- wp:buttons {"layout":{"type":"flex","justifyContent":"center"},"style":{"spacing":{"margin":{"top":"2.5rem"}}}} -->
<div class="wp-block-buttons" style="margin-top:2.5rem"><!-- wp:button {"backgroundColor":"red","textColor":"white"} --><div class="wp-block-button"><a class="wp-block-button__link has-white-color has-red-background-color has-text-color has-background wp-element-button" href="<?php echo esc_url( home_url( '/events/' ) ); ?>">View Events</a></div><!-- /wp:button --></div>
<!-- /wp:buttons --></div>
<!-- /wp:group -->
```

- [ ] **Step 2: Verify.** `npm test` (PASS); `node scripts/preview.mjs` + reload — centered gold star eyebrow "Here now", cards now carry a gold top rule.

- [ ] **Step 3: Commit.**

```bash
git add wp-content/themes/post165/patterns/home-events.php
git commit -m "feat: refine events section with eyebrow and gold-topped cards"
```

---

### Task 9: Refine membership, how-we-serve, and support sections

**Files:**
- Modify: `wp-content/themes/post165/patterns/home-membership.php`
- Modify: `wp-content/themes/post165/patterns/how-we-serve.php`
- Modify: `wp-content/themes/post165/patterns/support-post-165.php`

- [ ] **Step 1: Replace `home-membership.php`** with (keeps `veterans`, `families`, `Learn About Membership`):

```php
<?php
/**
 * Title: Home membership welcome
 * Slug: post165/home-membership
 * Categories: post165
 */
?>
<!-- wp:group {"style":{"spacing":{"padding":{"top":"4.5rem","right":"1rem","bottom":"4.5rem","left":"1rem"}}},"backgroundColor":"white","layout":{"type":"constrained","wideSize":"960px"}} -->
<div class="wp-block-group has-white-background-color has-background" style="padding-top:4.5rem;padding-right:1rem;padding-bottom:4.5rem;padding-left:1rem"><!-- wp:paragraph {"className":"post165-eyebrow has-text-align-center"} -->
<p class="post165-eyebrow has-text-align-center">A place to belong</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"textAlign":"center"} -->
<h2 class="wp-block-heading has-text-align-center">A Place for Veterans and Families</h2>
<!-- /wp:heading -->

<!-- wp:paragraph {"align":"center","fontSize":"large"} -->
<p class="has-text-align-center has-large-font-size">Post 165 welcomes eligible veterans who want fellowship, purpose, and a practical way to keep serving. Families are part of that life too, through events, service, and the wider Legion Family for veterans and families alike.</p>
<!-- /wp:paragraph -->

<!-- wp:buttons {"layout":{"type":"flex","justifyContent":"center"},"style":{"spacing":{"margin":{"top":"1.75rem"}}}} -->
<div class="wp-block-buttons" style="margin-top:1.75rem"><!-- wp:button {"backgroundColor":"red","textColor":"white"} --><div class="wp-block-button"><a class="wp-block-button__link has-white-color has-red-background-color has-text-color has-background wp-element-button" href="<?php echo esc_url( home_url( '/membership/' ) ); ?>">Learn About Membership</a></div><!-- /wp:button --></div>
<!-- /wp:buttons --></div>
<!-- /wp:group -->
```

- [ ] **Step 2: Replace `how-we-serve.php`** with (keeps `Veterans`, `Youth`, `Remembrance`, `Community`; adds an eyebrow and per-column gold ribbon):

```php
<?php
/**
 * Title: How we serve
 * Slug: post165/how-we-serve
 * Categories: post165
 */
?>
<!-- wp:group {"style":{"spacing":{"padding":{"top":"4.5rem","right":"1rem","bottom":"4.5rem","left":"1rem"}}},"backgroundColor":"cream","layout":{"type":"constrained","wideSize":"1160px"}} -->
<div class="wp-block-group has-cream-background-color has-background" style="padding-top:4.5rem;padding-right:1rem;padding-bottom:4.5rem;padding-left:1rem"><!-- wp:paragraph {"className":"post165-eyebrow has-text-align-center"} -->
<p class="post165-eyebrow has-text-align-center">The Four Pillars, locally</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"textAlign":"center"} --><h2 class="wp-block-heading has-text-align-center">How We Serve</h2><!-- /wp:heading -->

<!-- wp:columns {"align":"wide","style":{"spacing":{"margin":{"top":"2.5rem"}}}} --><div class="wp-block-columns alignwide" style="margin-top:2.5rem"><!-- wp:column --><div class="wp-block-column"><!-- wp:separator {"className":"post165-ribbon"} --><hr class="wp-block-separator has-alpha-channel-opacity post165-ribbon"/><!-- /wp:separator --><!-- wp:heading {"level":3,"fontSize":"large"} --><h3 class="wp-block-heading has-large-font-size">Veterans</h3><!-- /wp:heading --><!-- wp:paragraph --><p>We help veterans stay connected, informed, and supported by people who understand service.</p><!-- /wp:paragraph --></div><!-- /wp:column --><!-- wp:column --><div class="wp-block-column"><!-- wp:separator {"className":"post165-ribbon"} --><hr class="wp-block-separator has-alpha-channel-opacity post165-ribbon"/><!-- /wp:separator --><!-- wp:heading {"level":3,"fontSize":"large"} --><h3 class="wp-block-heading has-large-font-size">Youth</h3><!-- /wp:heading --><!-- wp:paragraph --><p>We support citizenship, leadership, and opportunities for young people in our community.</p><!-- /wp:paragraph --></div><!-- /wp:column --><!-- wp:column --><div class="wp-block-column"><!-- wp:separator {"className":"post165-ribbon"} --><hr class="wp-block-separator has-alpha-channel-opacity post165-ribbon"/><!-- /wp:separator --><!-- wp:heading {"level":3,"fontSize":"large"} --><h3 class="wp-block-heading has-large-font-size">Remembrance</h3><!-- /wp:heading --><!-- wp:paragraph --><p>We help Two Rivers honor service through ceremonies, observances, and respect for the flag.</p><!-- /wp:paragraph --></div><!-- /wp:column --><!-- wp:column --><div class="wp-block-column"><!-- wp:separator {"className":"post165-ribbon"} --><hr class="wp-block-separator has-alpha-channel-opacity post165-ribbon"/><!-- /wp:separator --><!-- wp:heading {"level":3,"fontSize":"large"} --><h3 class="wp-block-heading has-large-font-size">Community</h3><!-- /wp:heading --><!-- wp:paragraph --><p>We serve alongside neighbors, schools, organizations, and families when local needs arise.</p><!-- /wp:paragraph --></div><!-- /wp:column --></div><!-- /wp:columns --></div>
<!-- /wp:group -->
```

- [ ] **Step 3: Replace `support-post-165.php`** with (keeps `Support Post 165`, `Contact the Post`):

```php
<?php
/**
 * Title: Support Post 165
 * Slug: post165/support-post-165
 * Categories: post165
 */
?>
<!-- wp:group {"style":{"spacing":{"padding":{"top":"4.5rem","right":"1rem","bottom":"4.5rem","left":"1rem"}}},"backgroundColor":"cream","layout":{"type":"constrained","contentSize":"820px"}} -->
<div class="wp-block-group has-cream-background-color has-background" style="padding-top:4.5rem;padding-right:1rem;padding-bottom:4.5rem;padding-left:1rem"><!-- wp:paragraph {"className":"post165-eyebrow has-text-align-center"} --><p class="post165-eyebrow has-text-align-center">Lend a hand</p><!-- /wp:paragraph --><!-- wp:heading {"textAlign":"center"} --><h2 class="wp-block-heading has-text-align-center">Support Post 165</h2><!-- /wp:heading --><!-- wp:paragraph {"align":"center"} --><p class="has-text-align-center">Support can mean attending an event, lending a hand, helping with a fundraiser, or connecting us with a local need. If you want to help the post serve Two Rivers, start with a conversation.</p><!-- /wp:paragraph --><!-- wp:buttons {"layout":{"type":"flex","justifyContent":"center"},"style":{"spacing":{"margin":{"top":"1.75rem"}}}} --><div class="wp-block-buttons" style="margin-top:1.75rem"><!-- wp:button {"backgroundColor":"red","textColor":"white"} --><div class="wp-block-button"><a class="wp-block-button__link has-white-color has-red-background-color has-text-color has-background wp-element-button" href="<?php echo esc_url( home_url( '/contact/' ) ); ?>">Contact the Post</a></div><!-- /wp:button --></div></div>
<!-- /wp:group -->
```

> Note: `support-post-165` background changed white→cream so it alternates against the white membership section above and the navy contact-card below.

- [ ] **Step 4: Verify.** `npm test` (PASS); `node scripts/preview.mjs` + reload — each section now leads with a gold star eyebrow; the Four Pillars columns each start with a short gold ribbon; section backgrounds alternate cleanly.

- [ ] **Step 5: Commit.**

```bash
git add wp-content/themes/post165/patterns/home-membership.php wp-content/themes/post165/patterns/how-we-serve.php wp-content/themes/post165/patterns/support-post-165.php
git commit -m "feat: add eyebrows and gold ribbons to membership, serve, and support sections"
```

---

### Task 10: Refine the contact card

**Files:**
- Modify: `wp-content/themes/post165/patterns/contact-card.php`

- [ ] **Step 1: Replace the whole file** with (navy section; star list; all contact facts preserved):

```php
<?php
/**
 * Title: Contact card
 * Slug: post165/contact-card
 * Categories: post165
 */
?>
<!-- wp:group {"style":{"spacing":{"padding":{"top":"4.5rem","right":"1rem","bottom":"4.5rem","left":"1rem"}}},"backgroundColor":"navy","textColor":"white","layout":{"type":"constrained","contentSize":"900px"}} -->
<div class="wp-block-group has-white-color has-navy-background-color has-text-color has-background" style="padding-top:4.5rem;padding-right:1rem;padding-bottom:4.5rem;padding-left:1rem"><!-- wp:paragraph {"className":"post165-eyebrow has-text-align-center"} --><p class="post165-eyebrow has-text-align-center">Always here</p><!-- /wp:paragraph --><!-- wp:heading {"textAlign":"center","textColor":"white"} --><h2 class="wp-block-heading has-text-align-center has-white-color has-text-color">Contact and Meeting Info</h2><!-- /wp:heading --><!-- wp:list {"className":"post165-star-list"} --><ul class="wp-block-list post165-star-list"><!-- wp:list-item --><li>Meetings: first Tuesday of each month at 6:30 pm</li><!-- /wp:list-item --><!-- wp:list-item --><li>Meeting location: Manitowoc Rifle &amp; Pistol Club, 7227 Sandy Hill Ln, Two Rivers, WI 54241</li><!-- /wp:list-item --><!-- wp:list-item --><li>Mailing address: PO Box 11, Two Rivers, WI 54241</li><!-- /wp:list-item --><!-- wp:list-item --><li>Phone: <a href="tel:+19208607478">(920) 860-7478</a></li><!-- /wp:list-item --><!-- wp:list-item --><li>Email: <a href="mailto:wipost165@gmail.com">wipost165@gmail.com</a></li><!-- /wp:list-item --><!-- wp:list-item --><li>Facebook: <a href="https://www.facebook.com/groups/amlegionpost165wi">facebook.com/groups/amlegionpost165wi</a></li><!-- /wp:list-item --></ul><!-- /wp:list --></div>
<!-- /wp:group -->
```

- [ ] **Step 2: Verify.** `npm test` (PASS); preview + reload — navy contact block with gold star eyebrow "Always here" and gold-star bullets. (Links render red on navy — acceptable, but confirm legibility; if too dark, that is tuned in Task 14, not here.)

- [ ] **Step 3: Commit.**

```bash
git add wp-content/themes/post165/patterns/contact-card.php
git commit -m "feat: refine contact card with eyebrow and star list"
```

---

### Task 11: Quiet treatment for interior pages

**Files:**
- Modify: `wp-content/themes/post165/templates/page.html`
- Modify: `wp-content/themes/post165/templates/404.html`

- [ ] **Step 1: Replace `page.html`** with (adds a quiet eyebrow + ribbon above the title):

```html
<!-- wp:template-part {"slug":"header","tagName":"header"} /-->
<!-- wp:group {"tagName":"main","style":{"spacing":{"padding":{"top":"3.5rem","right":"1rem","bottom":"4.5rem","left":"1rem"}}},"layout":{"type":"constrained"}} -->
<main class="wp-block-group" style="padding-top:3.5rem;padding-right:1rem;padding-bottom:4.5rem;padding-left:1rem"><!-- wp:paragraph {"className":"post165-page-eyebrow"} -->
<p class="post165-page-eyebrow">Post 165 · Two Rivers</p>
<!-- /wp:paragraph -->

<!-- wp:post-title {"level":1,"fontSize":"x-large"} /-->

<!-- wp:separator {"className":"post165-ribbon"} -->
<hr class="wp-block-separator has-alpha-channel-opacity post165-ribbon"/>
<!-- /wp:separator -->

<!-- wp:post-content {"layout":{"type":"constrained"}} /--></main>
<!-- /wp:group -->
<!-- wp:template-part {"slug":"footer","tagName":"footer"} /-->
```

- [ ] **Step 2: Read the current `404.html`, then add the same eyebrow + ribbon** above its heading, matching the pattern in Step 1 (eyebrow paragraph with class `post165-page-eyebrow`, then the existing heading, then a `post165-ribbon` separator). Keep the existing "Page not found" heading, paragraph, and search block intact.

- [ ] **Step 3: Verify.** `npm test` (PASS). Interior templates use `post-title`/`post-content`, which the front-page-only preview does not render, so verify these two files by eye for correct block markup (balanced `wp:` comments) and, if a WordPress instance is available, by loading a page. Note in the commit that live verification is deferred to a WP preview.

- [ ] **Step 4: Commit.**

```bash
git add wp-content/themes/post165/templates/page.html wp-content/themes/post165/templates/404.html
git commit -m "feat: quiet motif treatment for interior page and 404 templates"
```

---

### Task 12: About page — namesake + history scaffolding

Give the "Then" a home without shipping invented facts. Add clearly-titled sections with honest evergreen framing; the specific biography, charter year, and milestones are added by editors (tracked in Task 13's docs).

**Files:**
- Modify: `wp-content/themes/post165/patterns/about-page.php`

- [ ] **Step 1: Read the current `about-page.php`.** Then insert, immediately after the opening lead paragraph (`... serving Two Rivers, Wisconsin.`) and before `## What the Legion Does`, these two sections:

```php
<!-- wp:heading {"level":2} --><h2 class="wp-block-heading">Our Namesake</h2><!-- /wp:heading -->
<!-- wp:paragraph --><p>Post 165 carries the name of Robert E. Burns. Honoring a name is how a community keeps a promise across generations — the post exists to remember, and to keep serving in that spirit.</p><!-- /wp:paragraph -->

<!-- wp:heading {"level":2} --><h2 class="wp-block-heading">Our History</h2><!-- /wp:heading -->
<!-- wp:paragraph --><p>For generations, Post 165 has been part of Two Rivers — showing up for veterans, families, and the community through steady, practical service. We are here now, and we are building for the veterans who come next.</p><!-- /wp:paragraph -->
```

> These are true regardless of the specifics. Editors replace the generalities with Robert E. Burns' actual story, the charter year, and one or two milestones once collected — no visible placeholder text ships.

- [ ] **Step 2: Verify.** `npm test` (PASS); confirm balanced `wp:` comments by eye.

- [ ] **Step 3: Commit.**

```bash
git add wp-content/themes/post165/patterns/about-page.php
git commit -m "feat: add namesake and history sections to About page starter"
```

---

## MILESTONE D — Docs and finalization

### Task 13: Update documentation

**Files:**
- Modify: `docs/wordpress/setup.md`
- Modify: `docs/HANDOFF.md`

- [ ] **Step 1: Read `docs/wordpress/setup.md`.** Add a short "Design assets and content to complete" subsection covering: (a) fonts are bundled in `wp-content/themes/post165/assets/fonts/` and load automatically via `theme.json` — do not add a fonts plugin; (b) the header/hero mark is `assets/images/seal.svg`, which may be replaced with the official American Legion emblem only where usage guidelines permit, ideally via **Appearance → set the site logo** (custom-logo support is enabled); (c) the About page's **Our Namesake** and **Our History** sections need the real Robert E. Burns biography, charter year, and 1–2 milestones before launch. Preserve the existing required strings in this file (`The Events Calendar`, `Home`, `Events`, `Membership`, `About`, `Contact`).

- [ ] **Step 2: Read `docs/HANDOFF.md`.** Update it to note the visual redesign: the "Still here. Still serving." narrative spine, the full-dress/quiet motif dial, self-hosted Fraunces + Public Sans, and `scripts/preview.mjs` for local visual checks. Reference the spec and this plan by path.

- [ ] **Step 3: Verify.**

Run: `npm test`
Expected: PASS.

- [ ] **Step 4: Commit.**

```bash
git add docs/wordpress/setup.md docs/HANDOFF.md
git commit -m "docs: record redesign, bundled fonts, seal, and content to complete"
```

---

### Task 14: Final verification pass

**Files:** none (verification + tuning only)

- [ ] **Step 1: Run the full validator.**

Run: `npm test`
Expected: PASS — "Theme validation passed."

- [ ] **Step 2: Build the full preview and review every homepage section.**

Run: `node scripts/preview.mjs`
Open `theme-preview.html` in a browser at desktop and mobile widths. Confirm against the spec: fonts are Fraunces (headings) + Public Sans (body), not system fallbacks; navy is the deepened `#0e2340`; the hero shows the stripe spine, watermark, gold ribbon, and meeting strip; every section leads with a gold star eyebrow; cards have gold top rules; nothing overflows horizontally on mobile.

- [ ] **Step 3: If the companion server is running,** copy the preview in for side-by-side review:

```bash
cp theme-preview.html "$(ls -d .superpowers/brainstorm/*/content | tail -1)/final-preview.html"
```

- [ ] **Step 4: Tune only if needed.** If review finds a specific issue (e.g. red links hard to read on navy in the contact card), fix it in `style.css` (e.g. add `.has-navy-background-color a { color: var(--p165-gold-light); }`), re-run `npm test` and the preview, and commit with a focused message. Otherwise, no change.

- [ ] **Step 5: Confirm the branch is clean and ready.**

Run: `git status && git log --oneline design/visual-narrative-direction ^main`
Expected: clean working tree; the commit list shows the spec plus all redesign commits. Hand off to the finishing-a-development-branch skill to decide merge/PR.

---

## Self-Review

**Spec coverage:** narrative spine → Tasks 7 (hero copy), 12 (About namesake/history), 8–10 (Then/Now/Next eyebrows: "Here now", "Always here"). Palette fix → Task 3. Gold as structural → Tasks 3–4 (ribbon, eyebrow, card rule, strip). Motif intensity dial → full dress Task 7, quiet Task 11. Self-hosted fonts / load-bug fix → Tasks 1–3. Emblem/seal → Task 2, used in Tasks 6–7. Wordmark → Task 6. Photography → intentionally not wired in v1 (spec says optional; site must stand without it) and noted in docs Task 13. Maintainability → Task 1 (enqueue, custom-logo), patterns remain editor-editable, fonts bundled. Content to collect → Tasks 12–13.

**Placeholder scan:** none — every step has full file contents or exact insertion text. The two font binaries and the `404.html`/docs edits are "read then apply described change" because their current bytes aren't safe to hardcode blind, but each specifies exactly what to add and what to preserve.

**Type/name consistency:** class names in the Design System Reference match `style.css` (Task 4) and all markup (Tasks 6–12): `post165-hero`, `post165-hero__content`, `post165-hero-watermark`, `post165-eyebrow`, `post165-ribbon`, `post165-strip`/`__k`/`__v`, `post165-card`, `post165-star-list`, `post165-seal`, `post165-wordmark`/`__org`/`__name`, `post165-page-eyebrow`, `post165-header`, `post165-footer`. Token `--wp--custom--gold-light` is defined in `theme.json` (`custom.goldLight`) and consumed via the `--p165-gold-light` fallback in `style.css`. Validator snippet edits (Tasks 1, 4) match the strings the implementation introduces.

> **Note on the footer:** `.post165-footer` is defined in the reference and CSS but the footer markup rebuild was folded out to keep scope tight — the footer already contains the required validator strings and reads acceptably. If desired, a follow-up task can add the `post165-footer` class + a ribbon/seal to `parts/footer.html`; it is intentionally optional and not required for a coherent v1.
