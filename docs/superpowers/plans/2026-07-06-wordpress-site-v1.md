# WordPress Site V1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the v1 public WordPress site foundation for Robert E. Burns American Legion Post 165 as a custom block theme with simple editor workflows, event-plugin guidance, content patterns, deployment documentation, and static validation.

**Architecture:** The repository owns a custom block theme under `wp-content/themes/post165/`, static validation scripts, editor/setup documentation, and optional GitHub Actions FTP deployment. WordPress owns live pages, events, posts, media, menus, and plugin settings. The theme uses block templates, template parts, theme.json design tokens, and registered patterns instead of a page builder.

**Tech Stack:** WordPress block theme, PHP theme support file, block-template HTML, theme.json, plain CSS, Node.js static validation script, GitHub Actions FTP deployment using repository secrets.

---

## File Structure

Create or modify these files:

- `package.json` — first repo toolchain; defines static validation commands.
- `scripts/validate-theme.mjs` — Node.js validation for required theme files, block-theme JSON, required copy, and docs coverage.
- `AGENTS.md` — update with exact install, lint, typecheck, test, build, and dev command status.
- `wp-content/themes/post165/style.css` — WordPress theme header and global CSS.
- `wp-content/themes/post165/functions.php` — theme setup, editor style, and pattern categories.
- `wp-content/themes/post165/theme.json` — color palette, typography, spacing, layout, and block defaults.
- `wp-content/themes/post165/templates/index.html` — fallback template.
- `wp-content/themes/post165/templates/front-page.html` — homepage template.
- `wp-content/themes/post165/templates/page.html` — ordinary page template.
- `wp-content/themes/post165/templates/single.html` — post template.
- `wp-content/themes/post165/templates/archive.html` — archive template.
- `wp-content/themes/post165/templates/404.html` — not-found template.
- `wp-content/themes/post165/parts/header.html` — site header and navigation.
- `wp-content/themes/post165/parts/footer.html` — footer with contact and mission links.
- `wp-content/themes/post165/patterns/home-hero.php` — homepage hero pattern.
- `wp-content/themes/post165/patterns/home-events.php` — separated event visibility pattern.
- `wp-content/themes/post165/patterns/home-membership.php` — membership teaser pattern.
- `wp-content/themes/post165/patterns/how-we-serve.php` — evergreen service examples.
- `wp-content/themes/post165/patterns/support-post-165.php` — contact-oriented support section.
- `wp-content/themes/post165/patterns/contact-card.php` — reusable contact/meeting details section.
- `wp-content/themes/post165/patterns/membership-page.php` — full membership starter content.
- `wp-content/themes/post165/patterns/about-page.php` — about page starter content.
- `wp-content/themes/post165/patterns/contact-page.php` — contact page starter content.
- `docs/wordpress/content-model.md` — content ownership, navigation, event categories, and editor rules.
- `docs/wordpress/setup.md` — WordPress setup checklist, required plugin guidance, and page creation steps.
- `docs/deployment/ftp-github-actions.md` — FTP deployment setup and secret names.
- `.github/workflows/deploy-theme.yml` — deploys only the custom theme to shared hosting over FTP.

## Task 1: Add Static Validation Toolchain

**Files:**
- Create: `package.json`
- Create: `scripts/validate-theme.mjs`
- Modify: `AGENTS.md`

- [ ] **Step 1: Create the failing validation script**

Create `scripts/validate-theme.mjs` with this content:

```js
import { existsSync, readFileSync } from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const themeDir = path.join(root, 'wp-content/themes/post165');

const requiredFiles = [
  'wp-content/themes/post165/style.css',
  'wp-content/themes/post165/functions.php',
  'wp-content/themes/post165/theme.json',
  'wp-content/themes/post165/templates/index.html',
  'wp-content/themes/post165/templates/front-page.html',
  'wp-content/themes/post165/templates/page.html',
  'wp-content/themes/post165/parts/header.html',
  'wp-content/themes/post165/parts/footer.html',
  'wp-content/themes/post165/patterns/home-hero.php',
  'wp-content/themes/post165/patterns/home-events.php',
  'wp-content/themes/post165/patterns/home-membership.php',
  'wp-content/themes/post165/patterns/how-we-serve.php',
  'wp-content/themes/post165/patterns/support-post-165.php',
  'wp-content/themes/post165/patterns/contact-card.php',
  'docs/wordpress/content-model.md',
  'docs/wordpress/setup.md',
  'docs/deployment/ftp-github-actions.md',
  '.github/workflows/deploy-theme.yml'
];

const requiredText = new Map([
  ['wp-content/themes/post165/style.css', ['Theme Name: Post 165', 'Text Domain: post165', 'Requires at least: 6.5']],
  ['wp-content/themes/post165/functions.php', ['post165_setup', 'post165_register_pattern_categories', 'add_theme_support']],
  ['wp-content/themes/post165/templates/front-page.html', ['wp:pattern {"slug":"post165/home-hero"', 'wp:pattern {"slug":"post165/home-events"']],
  ['wp-content/themes/post165/parts/header.html', ['wp:navigation', 'Robert E. Burns American Legion Post 165']],
  ['wp-content/themes/post165/parts/footer.html', ['wipost165@gmail.com', 'PO Box 11', 'First Tuesday']],
  ['wp-content/themes/post165/patterns/home-hero.php', ['Learn About Membership', 'View Events']],
  ['wp-content/themes/post165/patterns/home-events.php', ['Public Events', 'Post Meetings', 'Honor Guard']],
  ['wp-content/themes/post165/patterns/home-membership.php', ['veterans', 'families']],
  ['wp-content/themes/post165/patterns/how-we-serve.php', ['Veterans', 'Youth', 'Remembrance', 'Community']],
  ['wp-content/themes/post165/patterns/support-post-165.php', ['Support Post 165']],
  ['docs/wordpress/content-model.md', ['Git owns', 'WordPress owns', 'Event categories']],
  ['docs/wordpress/setup.md', ['The Events Calendar', 'Home', 'Events', 'Membership', 'About', 'Contact']],
  ['docs/deployment/ftp-github-actions.md', ['FTP_SERVER', 'FTP_USERNAME', 'FTP_PASSWORD']]
]);

const failures = [];

for (const relativePath of requiredFiles) {
  const absolutePath = path.join(root, relativePath);
  if (!existsSync(absolutePath)) {
    failures.push(`Missing required file: ${relativePath}`);
  }
}

for (const [relativePath, snippets] of requiredText.entries()) {
  const absolutePath = path.join(root, relativePath);
  if (!existsSync(absolutePath)) {
    continue;
  }

  const content = readFileSync(absolutePath, 'utf8');
  for (const snippet of snippets) {
    if (!content.includes(snippet)) {
      failures.push(`${relativePath} must include: ${snippet}`);
    }
  }
}

const themeJsonPath = path.join(themeDir, 'theme.json');
if (existsSync(themeJsonPath)) {
  try {
    const themeJson = JSON.parse(readFileSync(themeJsonPath, 'utf8'));
    const palette = themeJson?.settings?.color?.palette ?? [];
    const paletteSlugs = palette.map((color) => color.slug);
    for (const slug of ['navy', 'cream', 'gold', 'red']) {
      if (!paletteSlugs.includes(slug)) {
        failures.push(`theme.json color palette must include slug: ${slug}`);
      }
    }
  } catch (error) {
    failures.push(`theme.json must be valid JSON: ${error.message}`);
  }
}

if (failures.length > 0) {
  console.error('Theme validation failed:');
  for (const failure of failures) {
    console.error(`- ${failure}`);
  }
  process.exit(1);
}

console.log('Theme validation passed.');
```

- [ ] **Step 2: Add package.json with validation commands**

Create `package.json` with this content:

```json
{
  "name": "wipost165",
  "version": "0.1.0",
  "private": true,
  "description": "Custom WordPress theme and documentation for Robert E. Burns American Legion Post 165.",
  "type": "module",
  "scripts": {
    "test": "node scripts/validate-theme.mjs",
    "lint": "node scripts/validate-theme.mjs",
    "typecheck": "node scripts/validate-theme.mjs",
    "build": "node scripts/validate-theme.mjs",
    "dev": "node scripts/validate-theme.mjs --watch-not-supported"
  },
  "engines": {
    "node": ">=20"
  }
}
```

- [ ] **Step 3: Run validation and confirm it fails because theme files are not present yet**

Run:

```bash
npm test
```

Expected: FAIL with messages beginning `Missing required file: wp-content/themes/post165/style.css`.

- [ ] **Step 4: Update AGENTS.md with exact commands**

Replace `AGENTS.md` with this content:

```markdown
# AGENTS.md

- This is an early-stage repo for a WordPress-based website for American Legion Post 165 in Two Rivers, WI.
- Project context documents live under `docs/` and should be read before major architecture, design, content, or communication decisions.
- Superpowers design specs and implementation plans live under `docs/superpowers/`.
- The repository owns the custom WordPress theme, validation scripts, documentation, and deployment workflow. WordPress owns live wp-admin content, events, posts, media, menus, and plugin settings unless explicitly exported.
- Install command: no dependency install is required yet; use Node.js 20+.
- Dev command: `npm run dev` currently runs static validation only; no local WordPress dev server is configured yet.
- Build command: `npm run build`.
- Lint command: `npm run lint`.
- Typecheck command: `npm run typecheck`.
- Test command: `npm test`.
- Do not deploy to FTP unless explicitly requested.
```

- [ ] **Step 5: Commit Task 1**

Run:

```bash
git add package.json scripts/validate-theme.mjs AGENTS.md
git commit -m "chore: add theme validation toolchain"
```

## Task 2: Create Block Theme Skeleton

**Files:**
- Create: `wp-content/themes/post165/style.css`
- Create: `wp-content/themes/post165/functions.php`
- Create: `wp-content/themes/post165/theme.json`
- Create: `wp-content/themes/post165/templates/index.html`
- Create: `wp-content/themes/post165/templates/page.html`
- Create: `wp-content/themes/post165/templates/single.html`
- Create: `wp-content/themes/post165/templates/archive.html`
- Create: `wp-content/themes/post165/templates/404.html`
- Create: `wp-content/themes/post165/parts/header.html`
- Create: `wp-content/themes/post165/parts/footer.html`

- [ ] **Step 1: Create style.css**

Create `wp-content/themes/post165/style.css` with this content:

```css
/*
Theme Name: Post 165
Theme URI: https://wipost165.org
Author: Robert E. Burns American Legion Post 165
Description: Custom block theme for Robert E. Burns American Legion Post 165 in Two Rivers, Wisconsin.
Version: 0.1.0
Requires at least: 6.5
Requires PHP: 8.0
Tested up to: 6.6
License: GNU General Public License v2 or later
License URI: https://www.gnu.org/licenses/gpl-2.0.html
Text Domain: post165
Tags: block-patterns, full-site-editing, accessibility-ready
*/

html {
  scroll-behavior: smooth;
}

body {
  background: var(--wp--preset--color--cream);
  color: var(--wp--preset--color--ink);
}

a {
  text-underline-offset: 0.18em;
}

.wp-site-blocks {
  min-height: 100vh;
}

.post165-top-rule {
  border-top: 0.35rem solid var(--wp--preset--color--red);
}

.post165-card {
  border: 1px solid color-mix(in srgb, var(--wp--preset--color--navy) 18%, transparent);
  border-radius: 0.75rem;
  box-shadow: 0 0.75rem 2rem color-mix(in srgb, var(--wp--preset--color--navy) 10%, transparent);
}

.post165-eyebrow {
  color: var(--wp--preset--color--red);
  font-size: var(--wp--preset--font-size--small);
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.post165-section-divider {
  border-top: 1px solid color-mix(in srgb, var(--wp--preset--color--navy) 18%, transparent);
}
```

- [ ] **Step 2: Create functions.php**

Create `wp-content/themes/post165/functions.php` with this content:

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
    add_editor_style( 'style.css' );
}
add_action( 'after_setup_theme', 'post165_setup' );

function post165_register_pattern_categories(): void {
    register_block_pattern_category(
        'post165',
        array( 'label' => __( 'Post 165', 'post165' ) )
    );
}
add_action( 'init', 'post165_register_pattern_categories' );
```

- [ ] **Step 3: Create theme.json**

Create `wp-content/themes/post165/theme.json` with this content:

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
    "color": {
      "defaultDuotone": false,
      "defaultGradients": false,
      "defaultPalette": false,
      "palette": [
        { "slug": "navy", "name": "Navy", "color": "#10264a" },
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
      "fontFamilies": [
        {
          "slug": "serif",
          "name": "Serif",
          "fontFamily": "Georgia, 'Times New Roman', serif"
        },
        {
          "slug": "sans",
          "name": "Sans",
          "fontFamily": "Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif"
        }
      ],
      "fontSizes": [
        { "slug": "small", "name": "Small", "size": "0.9rem" },
        { "slug": "medium", "name": "Medium", "size": "1.05rem" },
        { "slug": "large", "name": "Large", "size": "1.35rem" },
        { "slug": "x-large", "name": "Extra Large", "size": "2rem" },
        { "slug": "hero", "name": "Hero", "size": "clamp(2.6rem, 7vw, 5.25rem)" }
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
        "spacing": { "padding": { "top": "0.75rem", "right": "1.25rem", "bottom": "0.75rem", "left": "1.25rem" } }
      },
      "heading": {
        "color": { "text": "var(--wp--preset--color--navy)" },
        "typography": { "fontFamily": "var(--wp--preset--font-family--serif)", "lineHeight": "1.12" }
      },
      "link": {
        "color": { "text": "var(--wp--preset--color--red)" }
      }
    },
    "blocks": {
      "core/navigation": {
        "typography": { "fontSize": "var(--wp--preset--font-size--small)", "fontWeight": "700" }
      }
    }
  },
  "templateParts": [
    { "name": "header", "title": "Header", "area": "header" },
    { "name": "footer", "title": "Footer", "area": "footer" }
  ],
  "customTemplates": [
    { "name": "page", "title": "Default Page" }
  ]
}
```

- [ ] **Step 4: Create header and footer parts**

Create `wp-content/themes/post165/parts/header.html` with this content:

```html
<!-- wp:group {"className":"post165-top-rule","style":{"spacing":{"padding":{"top":"1rem","bottom":"1rem","left":"1rem","right":"1rem"}}},"backgroundColor":"cream","layout":{"type":"constrained","wideSize":"1160px"}} -->
<div class="wp-block-group post165-top-rule has-cream-background-color has-background" style="padding-top:1rem;padding-right:1rem;padding-bottom:1rem;padding-left:1rem"><!-- wp:group {"align":"wide","layout":{"type":"flex","flexWrap":"wrap","justifyContent":"space-between","verticalAlignment":"center"}} -->
<div class="wp-block-group alignwide"><!-- wp:site-title {"level":0,"style":{"typography":{"fontStyle":"normal","fontWeight":"700","textDecoration":"none"}},"fontFamily":"serif"} /-->

<!-- wp:navigation {"overlayMenu":"mobile","layout":{"type":"flex","justifyContent":"right"}} -->
<!-- wp:navigation-link {"label":"Home","url":"/"} /-->
<!-- wp:navigation-link {"label":"Events","url":"/events/"} /-->
<!-- wp:navigation-link {"label":"Membership","url":"/membership/"} /-->
<!-- wp:navigation-link {"label":"About","url":"/about/"} /-->
<!-- wp:navigation-link {"label":"Contact","url":"/contact/"} /-->
<!-- /wp:navigation --></div>
<!-- /wp:group -->

<!-- wp:paragraph {"align":"center","style":{"typography":{"fontSize":"0.85rem","letterSpacing":"0.06em","textTransform":"uppercase"},"spacing":{"margin":{"top":"0.5rem"}}},"textColor":"navy"} -->
<p class="has-text-align-center has-navy-color has-text-color" style="margin-top:0.5rem;font-size:0.85rem;letter-spacing:0.06em;text-transform:uppercase">Robert E. Burns American Legion Post 165 · Two Rivers, Wisconsin</p>
<!-- /wp:paragraph --></div>
<!-- /wp:group -->
```

Create `wp-content/themes/post165/parts/footer.html` with this content:

```html
<!-- wp:group {"style":{"spacing":{"padding":{"top":"3rem","right":"1rem","bottom":"2rem","left":"1rem"}}},"backgroundColor":"navy","textColor":"white","layout":{"type":"constrained","wideSize":"1160px"}} -->
<div class="wp-block-group has-white-color has-navy-background-color has-text-color has-background" style="padding-top:3rem;padding-right:1rem;padding-bottom:2rem;padding-left:1rem"><!-- wp:columns {"align":"wide"} -->
<div class="wp-block-columns alignwide"><!-- wp:column -->
<div class="wp-block-column"><!-- wp:heading {"level":2,"textColor":"white","fontSize":"large"} -->
<h2 class="wp-block-heading has-white-color has-text-color has-large-font-size">Robert E. Burns American Legion Post 165</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>Veterans, families, and neighbors serving Two Rivers through fellowship, remembrance, youth support, and community service.</p>
<!-- /wp:paragraph --></div>
<!-- /wp:column -->

<!-- wp:column -->
<div class="wp-block-column"><!-- wp:heading {"level":3,"textColor":"white","fontSize":"medium"} -->
<h3 class="wp-block-heading has-white-color has-text-color has-medium-font-size">Meeting and Contact</h3>
<!-- /wp:heading -->

<!-- wp:list -->
<ul><!-- wp:list-item --><li>First Tuesday of each month at 6:30 pm</li><!-- /wp:list-item --><!-- wp:list-item --><li>Manitowoc Rifle &amp; Pistol Club, 7227 Sandy Hill Ln</li><!-- /wp:list-item --><!-- wp:list-item --><li>PO Box 11, Two Rivers, WI 54241</li><!-- /wp:list-item --><!-- wp:list-item --><li><a href="mailto:wipost165@gmail.com">wipost165@gmail.com</a></li><!-- /wp:list-item --></ul>
<!-- /wp:list --></div>
<!-- /wp:column --></div>
<!-- /wp:columns -->

<!-- wp:paragraph {"align":"center","fontSize":"small"} -->
<p class="has-text-align-center has-small-font-size">© Robert E. Burns American Legion Post 165</p>
<!-- /wp:paragraph --></div>
<!-- /wp:group -->
```

- [ ] **Step 5: Create base templates**

Create `wp-content/themes/post165/templates/index.html` with this content:

```html
<!-- wp:template-part {"slug":"header","tagName":"header"} /-->
<!-- wp:group {"tagName":"main","style":{"spacing":{"padding":{"top":"3rem","right":"1rem","bottom":"4rem","left":"1rem"}}},"layout":{"type":"constrained"}} -->
<main class="wp-block-group" style="padding-top:3rem;padding-right:1rem;padding-bottom:4rem;padding-left:1rem"><!-- wp:query {"query":{"perPage":10,"pages":0,"offset":0,"postType":"post","order":"desc","orderBy":"date","author":"","search":"","exclude":[],"sticky":"","inherit":true}} -->
<div class="wp-block-query"><!-- wp:post-template --><!-- wp:post-title {"isLink":true} /--><!-- wp:post-excerpt /--><!-- /wp:post-template --></div>
<!-- /wp:query --></main>
<!-- /wp:group -->
<!-- wp:template-part {"slug":"footer","tagName":"footer"} /-->
```

Create `wp-content/themes/post165/templates/page.html` with this content:

```html
<!-- wp:template-part {"slug":"header","tagName":"header"} /-->
<!-- wp:group {"tagName":"main","style":{"spacing":{"padding":{"top":"3rem","right":"1rem","bottom":"4rem","left":"1rem"}}},"layout":{"type":"constrained"}} -->
<main class="wp-block-group" style="padding-top:3rem;padding-right:1rem;padding-bottom:4rem;padding-left:1rem"><!-- wp:post-title {"level":1,"fontSize":"x-large"} /--><!-- wp:post-content {"layout":{"type":"constrained"}} /--></main>
<!-- /wp:group -->
<!-- wp:template-part {"slug":"footer","tagName":"footer"} /-->
```

Create `wp-content/themes/post165/templates/single.html` with this content:

```html
<!-- wp:template-part {"slug":"header","tagName":"header"} /-->
<!-- wp:group {"tagName":"main","style":{"spacing":{"padding":{"top":"3rem","right":"1rem","bottom":"4rem","left":"1rem"}}},"layout":{"type":"constrained"}} -->
<main class="wp-block-group" style="padding-top:3rem;padding-right:1rem;padding-bottom:4rem;padding-left:1rem"><!-- wp:post-title {"level":1,"fontSize":"x-large"} /--><!-- wp:post-date /--><!-- wp:post-content {"layout":{"type":"constrained"}} /--></main>
<!-- /wp:group -->
<!-- wp:template-part {"slug":"footer","tagName":"footer"} /-->
```

Create `wp-content/themes/post165/templates/archive.html` with this content:

```html
<!-- wp:template-part {"slug":"header","tagName":"header"} /-->
<!-- wp:group {"tagName":"main","style":{"spacing":{"padding":{"top":"3rem","right":"1rem","bottom":"4rem","left":"1rem"}}},"layout":{"type":"constrained"}} -->
<main class="wp-block-group" style="padding-top:3rem;padding-right:1rem;padding-bottom:4rem;padding-left:1rem"><!-- wp:query-title {"type":"archive","fontSize":"x-large"} /--><!-- wp:query {"query":{"perPage":10,"postType":"post","inherit":true}} --><div class="wp-block-query"><!-- wp:post-template --><!-- wp:post-title {"isLink":true} /--><!-- wp:post-excerpt /--><!-- /wp:post-template --></div><!-- /wp:query --></main>
<!-- /wp:group -->
<!-- wp:template-part {"slug":"footer","tagName":"footer"} /-->
```

Create `wp-content/themes/post165/templates/404.html` with this content:

```html
<!-- wp:template-part {"slug":"header","tagName":"header"} /-->
<!-- wp:group {"tagName":"main","style":{"spacing":{"padding":{"top":"4rem","right":"1rem","bottom":"5rem","left":"1rem"}}},"layout":{"type":"constrained"}} -->
<main class="wp-block-group" style="padding-top:4rem;padding-right:1rem;padding-bottom:5rem;padding-left:1rem"><!-- wp:heading {"level":1,"fontSize":"x-large"} --><h1 class="wp-block-heading has-x-large-font-size">Page not found</h1><!-- /wp:heading --><!-- wp:paragraph --><p>The page may have moved. Use the navigation above or contact the post if you need help finding information.</p><!-- /wp:paragraph --><!-- wp:buttons --><div class="wp-block-buttons"><!-- wp:button --><div class="wp-block-button"><a class="wp-block-button__link wp-element-button" href="/contact/">Contact Post 165</a></div><!-- /wp:button --></div><!-- /wp:buttons --></main>
<!-- /wp:group -->
<!-- wp:template-part {"slug":"footer","tagName":"footer"} /-->
```

- [ ] **Step 6: Run validation and confirm remaining failures are for homepage/pattern/docs files**

Run:

```bash
npm test
```

Expected: FAIL only for missing `front-page.html`, files under `patterns/`, docs files, and deployment workflow.

- [ ] **Step 7: Commit Task 2**

Run:

```bash
git add wp-content/themes/post165
git commit -m "feat: add post165 block theme skeleton"
```

## Task 3: Add Homepage Template and Patterns

**Files:**
- Create: `wp-content/themes/post165/templates/front-page.html`
- Create: `wp-content/themes/post165/patterns/home-hero.php`
- Create: `wp-content/themes/post165/patterns/home-events.php`
- Create: `wp-content/themes/post165/patterns/home-membership.php`
- Create: `wp-content/themes/post165/patterns/how-we-serve.php`
- Create: `wp-content/themes/post165/patterns/support-post-165.php`
- Create: `wp-content/themes/post165/patterns/contact-card.php`

- [ ] **Step 1: Create front-page.html**

Create `wp-content/themes/post165/templates/front-page.html` with this content:

```html
<!-- wp:template-part {"slug":"header","tagName":"header"} /-->
<!-- wp:group {"tagName":"main","layout":{"type":"default"}} -->
<main class="wp-block-group"><!-- wp:pattern {"slug":"post165/home-hero"} /--><!-- wp:pattern {"slug":"post165/home-events"} /--><!-- wp:pattern {"slug":"post165/home-membership"} /--><!-- wp:pattern {"slug":"post165/how-we-serve"} /--><!-- wp:pattern {"slug":"post165/support-post-165"} /--><!-- wp:pattern {"slug":"post165/contact-card"} /--></main>
<!-- /wp:group -->
<!-- wp:template-part {"slug":"footer","tagName":"footer"} /-->
```

- [ ] **Step 2: Create homepage hero pattern**

Create `wp-content/themes/post165/patterns/home-hero.php` with this content:

```php
<?php
/**
 * Title: Home hero
 * Slug: post165/home-hero
 * Categories: post165
 */
?>
<!-- wp:group {"style":{"spacing":{"padding":{"top":"5rem","right":"1rem","bottom":"5rem","left":"1rem"}}},"backgroundColor":"navy","textColor":"white","layout":{"type":"constrained","wideSize":"1160px"}} -->
<div class="wp-block-group has-white-color has-navy-background-color has-text-color has-background" style="padding-top:5rem;padding-right:1rem;padding-bottom:5rem;padding-left:1rem"><!-- wp:group {"align":"wide","layout":{"type":"constrained","contentSize":"820px","justifyContent":"left"}} -->
<div class="wp-block-group alignwide"><!-- wp:paragraph {"className":"post165-eyebrow","style":{"color":{"text":"#d9b45b"}}} -->
<p class="post165-eyebrow has-text-color" style="color:#d9b45b">Two Rivers, Wisconsin</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":1,"textColor":"white","fontSize":"hero"} -->
<h1 class="wp-block-heading has-white-color has-text-color has-hero-font-size">Robert E. Burns American Legion Post 165</h1>
<!-- /wp:heading -->

<!-- wp:paragraph {"fontSize":"large"} -->
<p class="has-large-font-size">Veterans, families, and neighbors serving Two Rivers through fellowship, remembrance, youth support, and community service.</p>
<!-- /wp:paragraph -->

<!-- wp:buttons {"style":{"spacing":{"margin":{"top":"2rem"}}}} -->
<div class="wp-block-buttons" style="margin-top:2rem"><!-- wp:button {"backgroundColor":"red","textColor":"white"} -->
<div class="wp-block-button"><a class="wp-block-button__link has-white-color has-red-background-color has-text-color has-background wp-element-button" href="/membership/">Learn About Membership</a></div>
<!-- /wp:button -->

<!-- wp:button {"backgroundColor":"cream","textColor":"navy","className":"is-style-fill"} -->
<div class="wp-block-button is-style-fill"><a class="wp-block-button__link has-navy-color has-cream-background-color has-text-color has-background wp-element-button" href="/events/">View Events</a></div>
<!-- /wp:button --></div>
<!-- /wp:buttons --></div>
<!-- /wp:group --></div>
<!-- /wp:group -->
```

- [ ] **Step 3: Create events pattern**

Create `wp-content/themes/post165/patterns/home-events.php` with this content:

```php
<?php
/**
 * Title: Home events overview
 * Slug: post165/home-events
 * Categories: post165
 */
?>
<!-- wp:group {"style":{"spacing":{"padding":{"top":"4rem","right":"1rem","bottom":"4rem","left":"1rem"}}},"backgroundColor":"cream","layout":{"type":"constrained","wideSize":"1160px"}} -->
<div class="wp-block-group has-cream-background-color has-background" style="padding-top:4rem;padding-right:1rem;padding-bottom:4rem;padding-left:1rem"><!-- wp:heading {"textAlign":"center"} -->
<h2 class="wp-block-heading has-text-align-center">Upcoming at Post 165</h2>
<!-- /wp:heading -->

<!-- wp:paragraph {"align":"center"} -->
<p class="has-text-align-center">Public events, post meetings, and ceremonial service each have a different purpose. We keep them separated so visitors can quickly find what applies to them.</p>
<!-- /wp:paragraph -->

<!-- wp:columns {"align":"wide","style":{"spacing":{"margin":{"top":"2rem"}}}} -->
<div class="wp-block-columns alignwide" style="margin-top:2rem"><!-- wp:column {"className":"post165-card","style":{"spacing":{"padding":{"top":"1.5rem","right":"1.5rem","bottom":"1.5rem","left":"1.5rem"}}},"backgroundColor":"white"} -->
<div class="wp-block-column post165-card has-white-background-color has-background" style="padding-top:1.5rem;padding-right:1.5rem;padding-bottom:1.5rem;padding-left:1.5rem"><!-- wp:heading {"level":3} --><h3 class="wp-block-heading">Public Events</h3><!-- /wp:heading --><!-- wp:paragraph --><p>Community events, youth activities, fundraisers, banquets, and other gatherings open to neighbors and friends of the post.</p><!-- /wp:paragraph --></div>
<!-- /wp:column -->

<!-- wp:column {"className":"post165-card","style":{"spacing":{"padding":{"top":"1.5rem","right":"1.5rem","bottom":"1.5rem","left":"1.5rem"}}},"backgroundColor":"white"} -->
<div class="wp-block-column post165-card has-white-background-color has-background" style="padding-top:1.5rem;padding-right:1.5rem;padding-bottom:1.5rem;padding-left:1.5rem"><!-- wp:heading {"level":3} --><h3 class="wp-block-heading">Post Meetings</h3><!-- /wp:heading --><!-- wp:paragraph --><p>Post meetings and member business. Regular meetings are held the first Tuesday of each month at 6:30 pm.</p><!-- /wp:paragraph --></div>
<!-- /wp:column -->

<!-- wp:column {"className":"post165-card","style":{"spacing":{"padding":{"top":"1.5rem","right":"1.5rem","bottom":"1.5rem","left":"1.5rem"}}},"backgroundColor":"white"} -->
<div class="wp-block-column post165-card has-white-background-color has-background" style="padding-top:1.5rem;padding-right:1.5rem;padding-bottom:1.5rem;padding-left:1.5rem"><!-- wp:heading {"level":3} --><h3 class="wp-block-heading">Honor Guard</h3><!-- /wp:heading --><!-- wp:paragraph --><p>Ceremonies and observances where the community gathers to honor service, sacrifice, and remembrance.</p><!-- /wp:paragraph --></div>
<!-- /wp:column --></div>
<!-- /wp:columns -->

<!-- wp:buttons {"layout":{"type":"flex","justifyContent":"center"}} -->
<div class="wp-block-buttons"><!-- wp:button {"backgroundColor":"red","textColor":"white"} --><div class="wp-block-button"><a class="wp-block-button__link has-white-color has-red-background-color has-text-color has-background wp-element-button" href="/events/">View Events</a></div><!-- /wp:button --></div>
<!-- /wp:buttons --></div>
<!-- /wp:group -->
```

- [ ] **Step 4: Create membership, service, support, and contact patterns**

Create `wp-content/themes/post165/patterns/home-membership.php` with this content:

```php
<?php
/**
 * Title: Home membership welcome
 * Slug: post165/home-membership
 * Categories: post165
 */
?>
<!-- wp:group {"style":{"spacing":{"padding":{"top":"4rem","right":"1rem","bottom":"4rem","left":"1rem"}}},"backgroundColor":"white","layout":{"type":"constrained","wideSize":"960px"}} -->
<div class="wp-block-group has-white-background-color has-background" style="padding-top:4rem;padding-right:1rem;padding-bottom:4rem;padding-left:1rem"><!-- wp:heading {"textAlign":"center"} -->
<h2 class="wp-block-heading has-text-align-center">A Place for Veterans and Families</h2>
<!-- /wp:heading -->

<!-- wp:paragraph {"align":"center","fontSize":"large"} -->
<p class="has-text-align-center has-large-font-size">Post 165 welcomes eligible veterans who want fellowship, purpose, and a practical way to keep serving. Families are part of that life too, through events, service, and the wider Legion Family.</p>
<!-- /wp:paragraph -->

<!-- wp:buttons {"layout":{"type":"flex","justifyContent":"center"}} -->
<div class="wp-block-buttons"><!-- wp:button {"backgroundColor":"red","textColor":"white"} --><div class="wp-block-button"><a class="wp-block-button__link has-white-color has-red-background-color has-text-color has-background wp-element-button" href="/membership/">Learn About Membership</a></div><!-- /wp:button --></div>
<!-- /wp:buttons --></div>
<!-- /wp:group -->
```

Create `wp-content/themes/post165/patterns/how-we-serve.php` with this content:

```php
<?php
/**
 * Title: How we serve
 * Slug: post165/how-we-serve
 * Categories: post165
 */
?>
<!-- wp:group {"style":{"spacing":{"padding":{"top":"4rem","right":"1rem","bottom":"4rem","left":"1rem"}}},"backgroundColor":"cream","layout":{"type":"constrained","wideSize":"1160px"}} -->
<div class="wp-block-group has-cream-background-color has-background" style="padding-top:4rem;padding-right:1rem;padding-bottom:4rem;padding-left:1rem"><!-- wp:heading {"textAlign":"center"} --><h2 class="wp-block-heading has-text-align-center">How We Serve</h2><!-- /wp:heading -->
<!-- wp:columns {"align":"wide"} --><div class="wp-block-columns alignwide"><!-- wp:column --><div class="wp-block-column"><!-- wp:heading {"level":3} --><h3 class="wp-block-heading">Veterans</h3><!-- /wp:heading --><!-- wp:paragraph --><p>We help veterans stay connected, informed, and supported by people who understand service.</p><!-- /wp:paragraph --></div><!-- /wp:column --><!-- wp:column --><div class="wp-block-column"><!-- wp:heading {"level":3} --><h3 class="wp-block-heading">Youth</h3><!-- /wp:heading --><!-- wp:paragraph --><p>We support citizenship, leadership, and opportunities for young people in our community.</p><!-- /wp:paragraph --></div><!-- /wp:column --><!-- wp:column --><div class="wp-block-column"><!-- wp:heading {"level":3} --><h3 class="wp-block-heading">Remembrance</h3><!-- /wp:heading --><!-- wp:paragraph --><p>We help Two Rivers honor service through ceremonies, observances, and respect for the flag.</p><!-- /wp:paragraph --></div><!-- /wp:column --><!-- wp:column --><div class="wp-block-column"><!-- wp:heading {"level":3} --><h3 class="wp-block-heading">Community</h3><!-- /wp:heading --><!-- wp:paragraph --><p>We serve alongside neighbors, schools, organizations, and families when local needs arise.</p><!-- /wp:paragraph --></div><!-- /wp:column --></div><!-- /wp:columns --></div>
<!-- /wp:group -->
```

Create `wp-content/themes/post165/patterns/support-post-165.php` with this content:

```php
<?php
/**
 * Title: Support Post 165
 * Slug: post165/support-post-165
 * Categories: post165
 */
?>
<!-- wp:group {"style":{"spacing":{"padding":{"top":"4rem","right":"1rem","bottom":"4rem","left":"1rem"}}},"backgroundColor":"white","layout":{"type":"constrained","contentSize":"820px"}} -->
<div class="wp-block-group has-white-background-color has-background" style="padding-top:4rem;padding-right:1rem;padding-bottom:4rem;padding-left:1rem"><!-- wp:heading {"textAlign":"center"} --><h2 class="wp-block-heading has-text-align-center">Support Post 165</h2><!-- /wp:heading --><!-- wp:paragraph {"align":"center"} --><p class="has-text-align-center">Support can mean attending an event, lending a hand, helping with a fundraiser, or connecting us with a local need. If you want to help the post serve Two Rivers, start with a conversation.</p><!-- /wp:paragraph --><!-- wp:buttons {"layout":{"type":"flex","justifyContent":"center"}} --><div class="wp-block-buttons"><!-- wp:button {"backgroundColor":"red","textColor":"white"} --><div class="wp-block-button"><a class="wp-block-button__link has-white-color has-red-background-color has-text-color has-background wp-element-button" href="/contact/">Contact the Post</a></div><!-- /wp:button --></div><!-- /wp:buttons --></div>
<!-- /wp:group -->
```

Create `wp-content/themes/post165/patterns/contact-card.php` with this content:

```php
<?php
/**
 * Title: Contact card
 * Slug: post165/contact-card
 * Categories: post165
 */
?>
<!-- wp:group {"style":{"spacing":{"padding":{"top":"4rem","right":"1rem","bottom":"4rem","left":"1rem"}}},"backgroundColor":"navy","textColor":"white","layout":{"type":"constrained","contentSize":"900px"}} -->
<div class="wp-block-group has-white-color has-navy-background-color has-text-color has-background" style="padding-top:4rem;padding-right:1rem;padding-bottom:4rem;padding-left:1rem"><!-- wp:heading {"textAlign":"center","textColor":"white"} --><h2 class="wp-block-heading has-text-align-center has-white-color has-text-color">Contact and Meeting Info</h2><!-- /wp:heading --><!-- wp:list --><ul><!-- wp:list-item --><li>Meetings: first Tuesday of each month at 6:30 pm</li><!-- /wp:list-item --><!-- wp:list-item --><li>Meeting location: Manitowoc Rifle &amp; Pistol Club, 7227 Sandy Hill Ln, Two Rivers, WI 54241</li><!-- /wp:list-item --><!-- wp:list-item --><li>Mailing address: PO Box 11, Two Rivers, WI 54241</li><!-- /wp:list-item --><!-- wp:list-item --><li>Email: <a href="mailto:wipost165@gmail.com">wipost165@gmail.com</a></li><!-- /wp:list-item --><!-- wp:list-item --><li>Facebook: <a href="https://www.facebook.com/groups/amlegionpost165wi">facebook.com/groups/amlegionpost165wi</a></li><!-- /wp:list-item --></ul><!-- /wp:list --></div>
<!-- /wp:group -->
```

- [ ] **Step 5: Run validation and confirm remaining failures are docs/deployment and optional page starter patterns**

Run:

```bash
npm test
```

Expected: FAIL only for missing docs/deployment files and page starter patterns not required by the current validator.

- [ ] **Step 6: Commit Task 3**

Run:

```bash
git add wp-content/themes/post165/templates/front-page.html wp-content/themes/post165/patterns
git commit -m "feat: add homepage patterns"
```

## Task 4: Add Starter Page Patterns

**Files:**
- Create: `wp-content/themes/post165/patterns/membership-page.php`
- Create: `wp-content/themes/post165/patterns/about-page.php`
- Create: `wp-content/themes/post165/patterns/contact-page.php`

- [ ] **Step 1: Create membership page starter pattern**

Create `wp-content/themes/post165/patterns/membership-page.php` with this content:

```php
<?php
/**
 * Title: Membership page starter
 * Slug: post165/membership-page
 * Categories: post165
 */
?>
<!-- wp:heading {"level":1} --><h1 class="wp-block-heading">Membership</h1><!-- /wp:heading -->
<!-- wp:paragraph {"fontSize":"large"} --><p class="has-large-font-size">If you are an eligible veteran looking for fellowship, purpose, and a practical way to keep serving, Post 165 is a place to start.</p><!-- /wp:paragraph -->
<!-- wp:heading {"level":2} --><h2 class="wp-block-heading">Come to an Event</h2><!-- /wp:heading -->
<!-- wp:paragraph --><p>The easiest first step is to come to a public event, meet people, and see how the post serves Two Rivers. You do not need to have everything figured out before you reach out.</p><!-- /wp:paragraph -->
<!-- wp:heading {"level":2} --><h2 class="wp-block-heading">Veterans and Families</h2><!-- /wp:heading -->
<!-- wp:paragraph --><p>Membership begins with eligible veterans, but families are part of the life of the post through events, service, and the wider Legion Family. Post 165 does not currently have a Sons of The American Legion squadron.</p><!-- /wp:paragraph -->
<!-- wp:heading {"level":2} --><h2 class="wp-block-heading">Ask a Question</h2><!-- /wp:heading -->
<!-- wp:paragraph --><p>If you want to learn more about eligibility or what involvement can look like, contact the post and someone will follow up.</p><!-- /wp:paragraph -->
```

- [ ] **Step 2: Create about page starter pattern**

Create `wp-content/themes/post165/patterns/about-page.php` with this content:

```php
<?php
/**
 * Title: About page starter
 * Slug: post165/about-page
 * Categories: post165
 */
?>
<!-- wp:heading {"level":1} --><h1 class="wp-block-heading">About Post 165</h1><!-- /wp:heading -->
<!-- wp:paragraph {"fontSize":"large"} --><p class="has-large-font-size">Robert E. Burns American Legion Post 165 is a local veterans organization serving Two Rivers, Wisconsin.</p><!-- /wp:paragraph -->
<!-- wp:heading {"level":2} --><h2 class="wp-block-heading">What the Legion Does</h2><!-- /wp:heading -->
<!-- wp:paragraph --><p>The American Legion continues service after military life by supporting veterans, families, youth, responsible citizenship, remembrance, and community service.</p><!-- /wp:paragraph -->
<!-- wp:heading {"level":2} --><h2 class="wp-block-heading">The Four Pillars</h2><!-- /wp:heading -->
<!-- wp:list --><ul><!-- wp:list-item --><li>Veterans Affairs and Rehabilitation</li><!-- /wp:list-item --><!-- wp:list-item --><li>National Security</li><!-- /wp:list-item --><!-- wp:list-item --><li>Americanism</li><!-- /wp:list-item --><!-- wp:list-item --><li>Children and Youth</li><!-- /wp:list-item --></ul><!-- /wp:list -->
<!-- wp:heading {"level":2} --><h2 class="wp-block-heading">Where We Meet</h2><!-- /wp:heading -->
<!-- wp:paragraph --><p>Post 165 meets at Manitowoc Rifle &amp; Pistol Club. It is our meeting location, not the center of the post's identity.</p><!-- /wp:paragraph -->
```

- [ ] **Step 3: Create contact page starter pattern**

Create `wp-content/themes/post165/patterns/contact-page.php` with this content:

```php
<?php
/**
 * Title: Contact page starter
 * Slug: post165/contact-page
 * Categories: post165
 */
?>
<!-- wp:heading {"level":1} --><h1 class="wp-block-heading">Contact Post 165</h1><!-- /wp:heading -->
<!-- wp:paragraph {"fontSize":"large"} --><p class="has-large-font-size">Use this information to ask about events, membership, support, or post business.</p><!-- /wp:paragraph -->
<!-- wp:pattern {"slug":"post165/contact-card"} /-->
<!-- wp:paragraph --><p>Before launch, verify all phone numbers, officer contacts, and meeting details against current post records.</p><!-- /wp:paragraph -->
```

- [ ] **Step 4: Run validation**

Run:

```bash
npm test
```

Expected: FAIL only for missing docs/deployment files.

- [ ] **Step 5: Commit Task 4**

Run:

```bash
git add wp-content/themes/post165/patterns/membership-page.php wp-content/themes/post165/patterns/about-page.php wp-content/themes/post165/patterns/contact-page.php
git commit -m "feat: add starter page patterns"
```

## Task 5: Add WordPress Setup and Content Documentation

**Files:**
- Create: `docs/wordpress/content-model.md`
- Create: `docs/wordpress/setup.md`

- [ ] **Step 1: Create content model documentation**

Create `docs/wordpress/content-model.md` with this content:

```markdown
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

V1 navigation:

- Home
- Events
- Membership
- About
- Contact

Do not add Programs, Four Pillars, News, Support, or Member Resources to the top-level navigation until there is enough real content to justify the page.

## Event categories

Event categories:

- Public Events: open community events, youth activities, fundraisers, banquets, and public gatherings.
- Post Meetings: regular meetings and member business.
- Honor Guard: ceremonies and observances where the community attends respectfully.

Use The Events Calendar for event entry unless the post later chooses a different event plugin.

## Posts and news

Posts are allowed for occasional updates. The homepage must not depend on a recent-news feed because irregular posting can make the site look stale.

## Pages

Create these WordPress pages:

- Home: assign as the static front page.
- Membership: use the `Membership page starter` pattern.
- About: use the `About page starter` pattern.
- Contact: use the `Contact page starter` pattern.

Events is plugin-owned: use The Events Calendar archive/landing URL, commonly `/events/` and adjusted if plugin settings differ. Do not create a normal Events page for v1 unless later plugin configuration requires one.

## Editing rules

- Edit event details in the event plugin.
- Edit ordinary page text on Membership, About, and Contact in the block editor.
- Routine editors should not edit the Home page body or rebuild homepage sections.
- Homepage sections come from `wp-content/themes/post165/templates/front-page.html` and Post 165 theme patterns.
- Assigned site/theme editors can inspect the homepage through Appearance → Editor → Templates → Front Page, Preview changes, and Save only when they are intentionally changing the front page template.
- Structural homepage changes or default pattern copy changes should be made in Git theme files and redeployed.
- If unsure, do not save Front Page template changes; ask the theme maintainer.
- Keep support messaging contact-oriented until donation processing is approved.
- Keep member-only resources out of v1.
```

- [ ] **Step 2: Create setup documentation**

Create `docs/wordpress/setup.md` with this content:

```markdown
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

Create these WordPress pages:

- Home
- Membership
- About
- Contact

Set **Home** as the static front page in Settings → Reading.

The Events section is plugin-owned: use The Events Calendar archive/landing URL, commonly `/events/` and adjusted if plugin settings differ. Do not create a normal Events page for v1 unless later plugin configuration requires one.

For Membership, About, and Contact, insert the matching starter pattern from the **Post 165** pattern category and edit the text as needed.

The Home page only needs to be assigned as the static front page. Do not rebuild homepage sections by typing content into the Home page body. The homepage comes from `wp-content/themes/post165/templates/front-page.html` and Post 165 theme patterns.

Routine editors should update events, contact facts, and page body text on Membership, About, and Contact. Assigned site/theme editors can inspect or edit the homepage through Appearance → Editor → Templates → Front Page, then Preview and Save only if they intentionally mean to change the front page template. Structural homepage changes or default pattern copy changes should be made in Git theme files and redeployed. If unsure, do not save Front Page template changes; ask the theme maintainer.

## Menu

In Appearance → Editor, populate the header Navigation block with:

- Home
- Events
- Membership
- About
- Contact

The Events navigation item should point to The Events Calendar archive/landing URL, commonly `/events/` and adjusted if plugin settings differ.

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
- Do not add online donations until payment processing and treasurer workflow are approved.
- Do not add member-only resources until v2.
```

- [ ] **Step 3: Run validation**

Run:

```bash
npm test
```

Expected: FAIL only for missing deployment files.

- [ ] **Step 4: Commit Task 5**

Run:

```bash
git add docs/wordpress/content-model.md docs/wordpress/setup.md
git commit -m "docs: add wordpress setup guide"
```

## Task 6: Add FTP Deployment Documentation and Workflow

**Files:**
- Create: `docs/deployment/ftp-github-actions.md`
- Create: `.github/workflows/deploy-theme.yml`

- [ ] **Step 1: Create FTP deployment documentation**

Create `docs/deployment/ftp-github-actions.md` with this content:

```markdown
# FTP Deployment with GitHub Actions

This project deploys only the custom WordPress theme to shared hosting. It does not deploy WordPress core, uploads, database content, plugin settings, events, posts, or pages edited in wp-admin.

## Required GitHub secrets

Configure these repository secrets:

- `FTP_SERVER`: FTP host name.
- `FTP_USERNAME`: FTP user name.
- `FTP_PASSWORD`: FTP password.
- `FTP_SERVER_DIR`: remote directory for the theme, ending with `/wp-content/themes/post165/`.

## Deployment behavior

The workflow runs static validation, then uploads `wp-content/themes/post165/` to `FTP_SERVER_DIR`.

The workflow uses FTPS by default. Verify NixiHost/your host secure FTP mode before the first deployment.

The workflow is manual by default through `workflow_dispatch`. Automatic deployment on every push can be added later after the first successful manual deployment.

Use `ftps-legacy` only if the host requires it.

The third-party deploy action is pinned to an immutable commit for safety.

## Safety notes

- Confirm `FTP_SERVER_DIR` points to the theme directory before running deployment.
- Do not point `FTP_SERVER_DIR` at the WordPress root.
- Do not store FTP credentials in files.
- Do not expect wp-admin content changes to appear in Git after deployment.
```

- [ ] **Step 2: Create GitHub Actions workflow**

Create `.github/workflows/deploy-theme.yml` with this content:

```yaml
name: Deploy WordPress Theme

permissions:
  contents: read

on:
  workflow_dispatch:

jobs:
  deploy-theme:
    runs-on: ubuntu-latest
    steps:
      - name: Check out repository
        uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Validate theme
        run: npm test

      - name: Deploy theme over FTP
        # v4.3.5 tag target
        uses: SamKirkland/FTP-Deploy-Action@8e83cea8672e3fbcbb9fdafff34debf6ae4c5f65
        with:
          server: ${{ secrets.FTP_SERVER }}
          username: ${{ secrets.FTP_USERNAME }}
          password: ${{ secrets.FTP_PASSWORD }}
          protocol: ftps
          local-dir: ./wp-content/themes/post165/
          server-dir: ${{ secrets.FTP_SERVER_DIR }}
```

- [ ] **Step 3: Run validation and confirm it passes**

Run:

```bash
npm test
```

Expected: PASS with `Theme validation passed.`

- [ ] **Step 4: Commit Task 6**

Run:

```bash
git add docs/deployment/ftp-github-actions.md .github/workflows/deploy-theme.yml
git commit -m "ci: add manual ftp theme deployment"
```

## Task 7: Final Verification

**Files:**
- Verify all files from Tasks 1-6.

- [ ] **Step 1: Run static validation**

Run:

```bash
npm test
```

Expected: PASS with `Theme validation passed.`

- [ ] **Step 2: Check repository state**

Run:

```bash
git status --short
```

Expected: no output.

- [ ] **Step 3: Review recent commits**

Run:

```bash
git log --oneline -10
```

Expected: recent commits include:

- `ci: add manual ftp theme deployment`
- `docs: add wordpress setup guide`
- `feat: add starter page patterns`
- `feat: add homepage patterns`
- `feat: add post165 block theme skeleton`
- `chore: add theme validation toolchain`

## Self-Review Notes

- Spec coverage: the plan creates a custom block theme, homepage, navigation model, event category guidance, membership/about/contact starter content, support messaging, editor docs, deployment docs, and static validation.
- Exclusions preserved: no member login, private resources, online donations, heavy page builder, or homepage latest-news dependency are included.
- Ownership boundary preserved: Git owns theme/docs/deployment; WordPress owns live content/events/media/menus/plugin settings.
