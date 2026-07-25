# Homepage v2 — "The Ask" Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the homepage's membership facts table with an invitation to *contribute* rather than to *join*, fix the unreadable date block, and add work photography positioned so it never outranks the data on a narrow screen.

**Architecture:** Extends the existing board. The three dynamic blocks stay; `post165/join-panel` is rewritten as the ask, a fourth block renders the photo row from editor-chosen attachments, and the board becomes a CSS grid whose DOM order equals mobile order.

**Tech Stack:** WordPress block theme, PHP 8.1+, no JS build step (one small inline admin script using core's `wp.media` is permitted).

## Why this changes

The v1 board answered both audiences with the same tool: facts, fast. That is right for "when is the brat fry" and wrong for a veteran deciding whether these are his people. `docs/POST_MEMBERS.md` and the post's own account describe the real barrier: veterans in their 30s and 40s with jobs and families, who don't want to "hang out with a bunch of old guys", feel too busy, and — where it matters most — some are hurting and withdraw in a kind of shame.

A facts table (eligibility, dues, size) reads as an application form. It asks someone to want *belonging*, which is a large and slightly embarrassing thing to ask for, and it puts the price before any reason to want in.

Being **needed** asks nothing to be confessed. "We need hands for a morning" can be accepted without admitting anything. The post's events are almost all annual — roughly five or six a year besides brat fries — which turns a apparent limitation into the strongest argument available: *we are not asking for your Tuesdays.*

## Global Constraints

- **Invent no facts.** No dues figure, member count, person's name, phone number, address, or event hour count may be asserted. Values come from settings or are omitted.
- No hour-count claims in copy ("two hours", "one morning") unless supplied by the post. Frequency language must stay qualitative until confirmed.
- **Dues and eligibility must not appear on the homepage.** They remain in settings for the membership page; the homepage links to it.
- **Source order is data order.** DOM must be: events → ask → photos → year strip. Desktop repositions with `grid-template-areas` only. Photos must never precede the ask or the event list in the markup.
- No JS build step. A single inline admin script for the media picker is allowed; it must degrade to manual ID entry if JS fails.
- All output escaped (`esc_html`, `esc_attr`, `esc_url`).
- WCAG AA: gold-deep `#7a5a12` on light surfaces, gold-light `#d9b45b` on navy. Body text on cream must clear 4.5:1 — `#5b6572` is the approved muted tone; `#8d93a0` and `#6b7280` are NOT (they failed and were fixed).
- `npm test` must pass at the end of every task.
- Verify every task against the live Docker WordPress if it is running (see Appendix), not only the validator.

---

### Task 1: Readable date block

**Files:**
- Modify: `wp-content/themes/post165/inc/blocks.php` (`post165_render_upcoming()`)
- Modify: `wp-content/themes/post165/style.css`
- Modify: `scripts/validate-theme.mjs`

**Interfaces:**
- Consumes: entry arrays with `start` (DateTimeImmutable).
- Produces: date markup with three spans — `.post165-ev__mo`, `.post165-ev__dy`, `.post165-ev__wd` — inside the existing `<time>`.

The current block renders `<b>4</b><span>Aug</span>`: the month sits near 10px in muted gold, and "4 / Aug" inverts how the date is spoken. Replace with month-first, a larger numeral, and the weekday — whether an event falls on a Saturday largely decides whether someone can attend.

- [ ] **Step 1: Add validator assertions**

Extend the `inc/blocks.php` `requiredText` entry with `'post165-ev__mo'` and `'post165-ev__wd'`. Extend the `style.css` entry with `'.post165-ev__dy'`.

- [ ] **Step 2: Run `npm test`, confirm it FAILS**

- [ ] **Step 3: Change the markup**

In `post165_render_upcoming()`, replace the `<time>` body:

```php
		$out .= '<time class="post165-ev__date" datetime="' . esc_attr( $start->format( 'c' ) ) . '">';
		$out .= '<span class="post165-ev__mo">' . esc_html( wp_date( 'M', $start->getTimestamp() ) ) . '</span>';
		$out .= '<span class="post165-ev__dy">' . esc_html( wp_date( 'j', $start->getTimestamp() ) ) . '</span>';
		$out .= '<span class="post165-ev__wd">' . esc_html( wp_date( 'D', $start->getTimestamp() ) ) . '</span>';
		$out .= '</time>';
```

Note `wp_date()` rather than `$start->format()` so month and weekday names localise.

- [ ] **Step 4: Replace the date styles**

In `style.css`, replace the `.post165-ev__date b` and `.post165-ev__date span` rules with:

```css
.post165-ev__date {
	text-align: center;
	display: block;
}

.post165-ev__mo {
	display: block;
	font-family: var(--wp--preset--font-family--sans);
	font-size: 0.68rem;
	letter-spacing: 0.1em;
	text-transform: uppercase;
	font-weight: 700;
	color: var(--wp--preset--color--navy);
	line-height: 1;
}

.post165-ev__dy {
	display: block;
	font-family: var(--wp--preset--font-family--serif);
	font-size: 2rem;
	font-weight: 600;
	line-height: 1.05;
	color: var(--wp--preset--color--navy);
}

.post165-ev__wd {
	display: block;
	font-size: 0.66rem;
	letter-spacing: 0.09em;
	text-transform: uppercase;
	font-weight: 600;
	color: #5b6572;
	line-height: 1;
}
```

And widen the row's first column: `.post165-ev { grid-template-columns: 4.3rem 1fr; }`.

- [ ] **Step 5: `npm test` passes; `php -l` clean; commit**

---

### Task 2: The ask replaces the facts table

**Files:**
- Modify: `wp-content/themes/post165/inc/blocks.php` (`post165_render_join_panel()`)
- Modify: `wp-content/themes/post165/style.css`
- Modify: `scripts/validate-theme.mjs`

**Interfaces:**
- Consumes: `post165_fact()` for the contact person only.
- Produces: `.post165-ask`, `.post165-ask__head`, `.post165-ask__list`, `.post165-ask__foot`, `.post165-ask__fine`. `post165_fact_row()` is retained — the membership page will use it — but the homepage panel no longer calls it.

- [ ] **Step 1: Add validator assertions**

Extend `inc/blocks.php` `requiredText` with `'post165-ask'` and `'Where you'` (the eyebrow). Extend `style.css` with `'.post165-ask'`.

- [ ] **Step 2: Run `npm test`, confirm it FAILS**

- [ ] **Step 3: Rewrite the panel**

Replace the body of `post165_render_join_panel()`. Keep the function name and block registration unchanged.

```php
/**
 * Render the invitation to help.
 *
 * Deliberately asks for contribution rather than membership. The audience is
 * veterans in their 30s and 40s with jobs and families; some are struggling
 * and withdraw rather than ask. "We need hands for a morning" can be accepted
 * without admitting anything, where "come and belong" cannot. Dues and
 * eligibility live on the membership page: they are hurdles, and a hurdle
 * shown before a reason is just an exit.
 */
function post165_render_join_panel(): string {
	$work = array(
		array( __( 'Honor guard', 'post165' ), __( 'Parades and civic ceremonies', 'post165' ) ),
		array( __( 'Brat fry', 'post165' ), __( "The post's main fundraiser", 'post165' ) ),
		array( __( 'Flags on graves', 'post165' ), __( 'Before Memorial Day', 'post165' ) ),
		array( __( 'Youth programs', 'post165' ), __( 'Baseball, Boys State, scholarships', 'post165' ) ),
	);

	$out  = '<div class="post165-ask">';
	$out .= '<p class="post165-eyebrow">' . esc_html__( "Where you'd help", 'post165' ) . '</p>';
	$out .= '<p class="post165-ask__head">' . esc_html__( "A handful of mornings a year. That's the whole ask.", 'post165' ) . '</p>';
	$out .= '<p class="post165-ask__lede">' . esc_html__( 'Most of what this post does gets done by a dozen people showing up once.', 'post165' ) . '</p>';

	$out .= '<ul class="post165-ask__list">';
	foreach ( $work as $item ) {
		$out .= '<li><b>' . esc_html( $item[0] ) . '</b><span>' . esc_html( $item[1] ) . '</span></li>';
	}
	$out .= '</ul>';

	$out .= '<p class="post165-ask__foot">' . esc_html__( "Come to one. If it isn't for you, nobody will chase you.", 'post165' ) . '</p>';
	$out .= '<p class="post165-ask__cta"><a class="wp-block-button__link wp-element-button" href="'
		. esc_url( home_url( '/contact/' ) ) . '">' . esc_html__( 'Get in touch', 'post165' ) . '</a></p>';

	// A name beats a form with this audience: trust here is earned slowly and
	// travels by word of mouth.
	$name  = trim( (string) post165_fact( 'contact_name', '' ) );
	$role  = trim( (string) post165_fact( 'contact_role', '' ) );
	$email = trim( (string) post165_fact( 'contact_email', '' ) );
	$phone = trim( (string) post165_fact( 'contact_phone', '' ) );

	if ( '' !== $name || '' !== $email || '' !== $phone ) {
		$out .= '<div class="post165-ask__who"><p>' . esc_html__( 'Ask a person, not a form.', 'post165' ) . '</p>';

		if ( '' !== $name ) {
			$out .= '<p class="post165-ask__name">' . esc_html( '' !== $role ? $name . ', ' . $role : $name ) . '</p>';
		}

		$bits = array();
		if ( '' !== $email ) {
			$safe   = antispambot( $email );
			$bits[] = '<a href="mailto:' . esc_attr( $safe ) . '">' . esc_html( $safe ) . '</a>';
		}
		if ( '' !== $phone ) {
			$bits[] = '<a href="tel:' . esc_attr( preg_replace( '/[^0-9+]/', '', $phone ) ) . '">' . esc_html( $phone ) . '</a>';
		}
		if ( $bits ) {
			$out .= '<p class="post165-ask__contact">' . implode( ' &middot; ', $bits ) . '</p>';
		}

		$out .= '</div>';
	}

	$out .= '<p class="post165-ask__fine"><a href="' . esc_url( home_url( '/membership/' ) ) . '">'
		. esc_html__( 'What membership involves', 'post165' ) . ' &rarr;</a></p>';
	$out .= '</div>';

	return $out;
}
```

**Copy is load-bearing here — do not paraphrase.** "A handful of mornings a year" is deliberately qualitative because no hour counts have been supplied. "Nobody will chase you" answers a real fear of being recruited. Neither may be replaced with warmer marketing language; this audience distrusts it.

- [ ] **Step 4: Styles**

Add to `style.css` (replacing the `.post165-join__*` block, which is now unused — verify with grep before deleting):

```css
.post165-ask__head {
	font-family: var(--wp--preset--font-family--serif);
	font-size: 1.45rem;
	font-weight: 600;
	color: var(--wp--preset--color--navy);
	line-height: 1.15;
	margin: 0 0 0.4rem;
}

.post165-ask__lede {
	font-size: 0.88rem;
	color: #5b6572;
	margin: 0 0 1rem;
}

.post165-ask__list {
	list-style: none;
	margin: 0;
	padding: 0;
}

.post165-ask__list li {
	padding: 0.55rem 0;
	border-top: 1px solid #eae3d2;
	font-size: 0.87rem;
}

.post165-ask__list b {
	display: block;
	font-family: var(--wp--preset--font-family--serif);
	font-size: 1rem;
	font-weight: 600;
	color: var(--wp--preset--color--navy);
}

.post165-ask__list span {
	color: #5b6572;
	font-size: 0.8rem;
}

.post165-ask__foot {
	margin: 1rem 0 0;
	font-size: 0.85rem;
	color: #5b6572;
}

.post165-ask__cta {
	margin: 1rem 0 0;
}

.post165-ask__cta a {
	display: block;
	text-align: center;
}

.post165-ask__who {
	margin-top: 0.9rem;
	padding-top: 0.85rem;
	border-top: 1px solid #eae3d2;
	font-size: 0.8rem;
	color: #5b6572;
}

.post165-ask__who p {
	margin: 0;
}

.post165-ask__name {
	font-family: var(--wp--preset--font-family--serif);
	font-size: 1rem;
	font-weight: 600;
	color: var(--wp--preset--color--navy);
	margin-top: 0.15rem !important;
}

.post165-ask__contact a {
	color: var(--wp--preset--color--red);
}

.post165-ask__fine {
	margin-top: 0.8rem;
	font-size: 0.76rem;
}

.post165-ask__fine a {
	color: var(--wp--preset--color--red);
}
```

- [ ] **Step 5: `npm test` passes; `php -l` clean; commit**

---

### Task 3: Photo settings with a media picker

**Files:**
- Modify: `wp-content/themes/post165/inc/settings.php`
- Modify: `scripts/validate-theme.mjs`

**Interfaces:**
- Produces: `post165_photos(): array` returning up to 3 rows of `array( 'id' => int, 'caption' => string )`, skipping rows with no attachment. Stored under the existing `post165_facts` option key `photos`.

- [ ] **Step 1: Validator assertions** — extend `inc/settings.php` `requiredText` with `'post165_photos'` and `'wp_enqueue_media'`.

- [ ] **Step 2: `npm test` FAILS**

- [ ] **Step 3: Extend defaults and sanitiser**

Add `'photos' => array()` to `post165_default_facts()`.

In `post165_sanitize_facts()`, before `return $out;`:

```php
	$photos     = array();
	$raw_photos = is_array( $input['photos'] ?? null ) ? $input['photos'] : array();

	foreach ( array_slice( $raw_photos, 0, 3 ) as $row ) {
		if ( ! is_array( $row ) ) {
			continue;
		}
		$id = absint( $row['id'] ?? 0 );
		if ( ! $id ) {
			continue;
		}
		$photos[] = array(
			'id'      => $id,
			'caption' => sanitize_text_field( (string) ( $row['caption'] ?? '' ) ),
		);
	}

	$out['photos'] = $photos;
```

Add the accessor:

```php
/**
 * Photographs chosen for the homepage, newest selection order preserved.
 *
 * @return array<int, array{id:int, caption:string}>
 */
function post165_photos(): array {
	$rows = post165_fact( 'photos', array() );

	return is_array( $rows ) ? $rows : array();
}
```

- [ ] **Step 4: Add the fields and the picker**

Add a "Photographs" section to `post165_render_settings_page()` with three rows, each an attachment-ID number input, a caption text input, a "Choose" button, and a thumbnail preview when set. Render the ID input as `type="number"` so the screen still works with JavaScript disabled.

Enqueue the media modal on this screen only:

```php
function post165_settings_assets( $hook ): void {
	if ( 'settings_page_post165-settings' !== $hook ) {
		return;
	}

	wp_enqueue_media();
	wp_add_inline_script( 'jquery-core', "
jQuery(function($){
  $('.post165-pick').on('click', function(e){
    e.preventDefault();
    var row = $(this).closest('tr');
    var frame = wp.media({ title: 'Choose a photograph', multiple: false });
    frame.on('select', function(){
      var a = frame.state().get('selection').first().toJSON();
      row.find('.post165-pick-id').val(a.id);
      row.find('.post165-pick-preview').attr('src', (a.sizes && a.sizes.thumbnail ? a.sizes.thumbnail.url : a.url)).show();
    });
    frame.open();
  });
});
" );
}
add_action( 'admin_enqueue_scripts', 'post165_settings_assets' );
```

The picker is a convenience; the number input remains the source of truth so the screen degrades gracefully.

- [ ] **Step 5: `npm test` passes; `php -l` clean; commit**

---

### Task 4: The photo row block

**Files:**
- Modify: `wp-content/themes/post165/inc/blocks.php`
- Modify: `wp-content/themes/post165/style.css`
- Modify: `scripts/validate-theme.mjs`

**Interfaces:**
- Consumes: `post165_photos()`.
- Produces: block `post165/work-photos`, markup `.post165-work`, `.post165-work__grid`, `.post165-work__cap`.

- [ ] **Step 1: Validator** — extend `inc/blocks.php` `requiredText` with `'post165/work-photos'`; extend `style.css` with `'.post165-work'`.

- [ ] **Step 2: `npm test` FAILS**

- [ ] **Step 3: Register and render**

Add inside `post165_register_blocks()`:

```php
	register_block_type(
		'post165/work-photos',
		array(
			'api_version'     => 3,
			'render_callback' => 'post165_render_work_photos',
		)
	);
```

And append:

```php
/**
 * Render the row of work photographs.
 *
 * Renders nothing at all until the post supplies images — an empty frame or a
 * stock photograph would both be worse than absence here, since the page's
 * whole argument is that this post actually shows up.
 *
 * Images are deliberately displayed small: the available photographs are
 * amateur and sometimes low resolution, which reads as authentic at this size
 * and as careless when enlarged.
 */
function post165_render_work_photos(): string {
	$photos = post165_photos();

	if ( empty( $photos ) ) {
		return '';
	}

	$items = '';

	foreach ( $photos as $photo ) {
		$img = wp_get_attachment_image(
			$photo['id'],
			'medium',
			false,
			array(
				'class'   => 'post165-work__img',
				'loading' => 'lazy',
			)
		);

		if ( ! $img ) {
			continue;
		}

		$items .= '<figure>' . $img;

		if ( '' !== trim( (string) $photo['caption'] ) ) {
			$items .= '<figcaption class="post165-work__cap">' . esc_html( $photo['caption'] ) . '</figcaption>';
		}

		$items .= '</figure>';
	}

	if ( '' === $items ) {
		return '';
	}

	return '<div class="post165-work"><div class="post165-work__grid">' . $items . '</div></div>';
}
```

- [ ] **Step 4: Styles**

```css
.post165-work__grid {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 0.7rem;
}

.post165-work__grid figure {
	margin: 0;
}

.post165-work__img {
	width: 100%;
	height: auto;
	aspect-ratio: 4 / 3;
	object-fit: cover;
	border-radius: 3px;
	display: block;
}

.post165-work__cap {
	font-size: 0.7rem;
	color: #5b6572;
	margin: 0.3rem 0 0;
	line-height: 1.3;
}
```

- [ ] **Step 5: `npm test` passes; `php -l` clean; commit**

---

### Task 5: Board restructure — grid areas, data-first source order

**Files:**
- Modify: `wp-content/themes/post165/patterns/home-board.php`
- Modify: `wp-content/themes/post165/style.css`
- Modify: `scripts/validate-theme.mjs`

**This task carries the plan's most important constraint.** On a narrow screen, photographs must never appear before the dated events or the ask. Achieve that by making DOM order *be* mobile order and using `grid-template-areas` to reposition on desktop — never `order`, and never by moving markup.

- [ ] **Step 1: Validator** — extend the `patterns/home-board.php` entry with `'post165/work-photos'`; extend `style.css` with `'grid-template-areas'`.

- [ ] **Step 2: `npm test` FAILS**

- [ ] **Step 3: Restructure the pattern**

The board's children, in this exact DOM order:

1. `<div class="post165-board__events">` containing `<!-- wp:post165/upcoming /-->`
2. `<div class="post165-board__ask">` containing `<!-- wp:post165/join-panel /-->`
3. `<div class="post165-board__photos">` containing `<!-- wp:post165/work-photos /-->`
4. `<div class="post165-board__year">` containing `<!-- wp:post165/year-strip /-->`

Keep the existing strap markup above the board unchanged.

- [ ] **Step 4: Grid**

Replace the `.post165-board` rules:

```css
.post165-board {
	display: grid;
	grid-template-columns: 1fr 20rem;
	grid-template-areas:
		"events ask"
		"photos ask"
		"year   ask";
	align-items: start;
}

.post165-board__events { grid-area: events; }
.post165-board__photos { grid-area: photos; }
.post165-board__year   { grid-area: year; }
.post165-board__ask    { grid-area: ask; }

.post165-board__events,
.post165-board__photos,
.post165-board__year {
	background: var(--wp--preset--color--cream);
	padding-inline: clamp(1rem, 4vw, 2rem);
}

.post165-board__events { padding-block: 1.5rem 0.6rem; }
.post165-board__photos { padding-block: 0.4rem 1.2rem; }
.post165-board__year   { padding-block: 0 1.8rem; }

.post165-board__ask {
	grid-area: ask;
	background: #fff;
	border-left: 1px solid #e2d9c4;
	padding: 1.5rem clamp(1rem, 3vw, 1.6rem) 2rem;
	height: 100%;
}

/*
 * Single column below this width. The areas are re-declared rather than
 * removed so the stacking order is explicit and matches DOM order:
 * events, then the ask, then photographs, then the year. Photographs must
 * never push the answer below the fold on a phone.
 */
@media (max-width: 52.5rem) {
	.post165-board {
		grid-template-columns: 1fr;
		grid-template-areas:
			"events"
			"ask"
			"photos"
			"year";
	}

	.post165-board__ask {
		border-left: 0;
		border-top: 2px solid var(--wp--preset--color--navy);
	}

	.post165-year__grid {
		grid-template-columns: repeat(6, 1fr);
	}
}
```

Remove the superseded `.post165-board__main` / `.post165-board__side` rules once nothing references them — grep first.

- [ ] **Step 5: Verify order in the rendered DOM**

Assert markup order programmatically, not by eye:

```bash
curl -s http://192.168.37.41:8080/ | grep -o 'post165-board__[a-z]*' | head -4
```

Expected exactly: `post165-board__events`, `post165-board__ask`, `post165-board__photos`, `post165-board__year`. If the Docker site is not running, skip and note it.

- [ ] **Step 6: `npm test` passes; `php -l` clean; commit**

---

### Task 6: Documentation

**Files:**
- Modify: `docs/wordpress/setup.md`, `docs/HANDOFF.md`

- [ ] **Step 1:** Document the Photographs settings section: three images, chosen from the media library, each with a caption; the row renders nothing until images are set; images display small deliberately.
- [ ] **Step 2:** Record that dues and eligibility no longer appear on the homepage and are for the membership page.
- [ ] **Step 3:** Record the source-order constraint in `HANDOFF.md` so a future developer does not "tidy" the markup and silently break mobile ordering.
- [ ] **Step 4:** Record the local WordPress recipe (see Appendix) so it is not lost, noting it is not committed.
- [ ] **Step 5:** `npm test` passes; commit.

---

## Appendix: local WordPress for testing (not committed)

`docker compose` with `wordpress:php8.3-apache`, `mariadb:11`, and `wordpress:cli-php8.3`, the theme bind-mounted at `/var/www/html/wp-content/themes/post165`. Three settings are essential:

- `WP_HOME`/`WP_SITEURL` must be the LAN address, or WordPress redirects to localhost and is unreachable from another machine.
- Site timezone `America/Chicago` — the meeting logic is timezone-sensitive.
- Permalinks `/%postname%/`.

Events created via WP-CLI need `_EventTimezone`, `_EventStartDateUTC` and `_EventEndDateUTC` meta, or The Events Calendar rejects them into its custom tables and `tribe_get_events()` returns nothing.

## Verification checklist

- [ ] Dates read month-first with the weekday, legible at a glance.
- [ ] No dues or eligibility anywhere on the homepage.
- [ ] With no photographs set, the row renders nothing and the layout is undisturbed.
- [ ] With photographs set, three appear with captions.
- [ ] At 390px: events, then ask, then photos, then year — verified in the DOM.
- [ ] `Settings → Post 165` picker sets an attachment; the screen still works with JS disabled.
- [ ] No PHP notices in `wp-content/debug.log` with `WP_DEBUG` on.
