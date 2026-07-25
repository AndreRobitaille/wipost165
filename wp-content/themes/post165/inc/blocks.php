<?php
/**
 * Server-side dynamic blocks.
 *
 * These are dynamic blocks rather than PHP inside pattern files because theme
 * pattern output can be cached, which would freeze the computed dates.
 *
 * @package post165
 */

defined( 'ABSPATH' ) || exit;

/**
 * Register the homepage blocks.
 */
function post165_register_blocks(): void {
	register_block_type(
		'post165/upcoming',
		[
			'api_version'     => 3,
			'render_callback' => 'post165_render_upcoming',
		]
	);
	register_block_type(
		'post165/year-strip',
		[
			'api_version'     => 3,
			'render_callback' => 'post165_render_year_strip',
		]
	);
	register_block_type(
		'post165/join-panel',
		[
			'api_version'     => 3,
			'render_callback' => 'post165_render_join_panel',
		]
	);
	register_block_type(
		'post165/work-photos',
		array(
			'api_version'     => 3,
			'render_callback' => 'post165_render_work_photos',
		)
	);
}
add_action( 'init', 'post165_register_blocks' );

/**
 * Render the dated list plus the conditional quiet-season note.
 */
function post165_render_upcoming(): string {
	$entries = post165_upcoming_entries( 5 );

	if ( empty( $entries ) ) {
		return '';
	}

	$out  = '<div class="post165-next">';
	$out .= '<p class="post165-eyebrow">' . esc_html__( "What's next", 'post165' ) . '</p>';
	$out .= '<ul class="post165-ev-list">';

	$first = true;

	foreach ( $entries as $entry ) {
		$start   = $entry['start'];
		$classes = 'post165-ev' . ( $first ? ' post165-ev--next' : '' );
		$first   = false;

		$is_meeting = 'meeting' === ( $entry['kind'] ?? '' );
		$pill_text  = $is_meeting ? __( 'Members', 'post165' ) : __( 'Public', 'post165' );
		$pill_class = $is_meeting ? 'post165-pill post165-pill--members' : 'post165-pill post165-pill--public';

		$title = (string) ( $entry['title'] ?? '' );
		if ( ! empty( $entry['url'] ) ) {
			$title = '<a href="' . esc_url( $entry['url'] ) . '">' . esc_html( $title ) . '</a>';
		} else {
			$title = esc_html( $title );
		}

		$meta = wp_date( 'g:i a', $start->getTimestamp() );
		if ( ! empty( $entry['venue'] ) ) {
			$meta .= ' · ' . $entry['venue'];
		}

		$out .= '<li class="' . esc_attr( $classes ) . '">';
		$out .= '<time class="post165-ev__date" datetime="' . esc_attr( $start->format( 'c' ) ) . '">';
		$out .= '<span class="post165-ev__mo">' . esc_html( wp_date( 'M', $start->getTimestamp() ) ) . '</span>';
		$out .= '<span class="post165-ev__dy">' . esc_html( wp_date( 'j', $start->getTimestamp() ) ) . '</span>';
		$out .= '<span class="post165-ev__wd">' . esc_html( wp_date( 'D', $start->getTimestamp() ) ) . '</span>';
		$out .= '</time>';
		$out .= '<div class="post165-ev__body">';
		$out .= '<p class="post165-ev__title">' . $title;
		$out .= ' <span class="' . esc_attr( $pill_class ) . '">' . esc_html( $pill_text ) . '</span></p>';
		$out .= '<p class="post165-ev__meta">' . esc_html( $meta ) . '</p>';
		$out .= '</div></li>';
	}

	$out .= '</ul>';

	$quiet = post165_quiet_season_note();

	if ( null !== $quiet ) {
		$out .= '<div class="post165-quiet">';
		$out .= '<p class="post165-quiet__head">' . esc_html__( 'Quiet season', 'post165' ) . '</p>';
		$out .= '<p>' . esc_html(
			sprintf(
				/* translators: 1: event name, 2: month name */
				__( 'Public events run in the warmer months. Meetings continue every month and visitors are welcome. Next up is %1$s in %2$s.', 'post165' ),
				$quiet['label'],
				$quiet['month_name']
			)
		) . '</p>';
		$out .= '</div>';
	}

	$out .= '</div>';

	return $out;
}

/**
 * Render the twelve-month rhythm.
 *
 * Editorial content rather than calendar data, which is why it stays true in
 * February when the calendar is empty.
 */
function post165_render_year_strip(): string {
	$map = post165_year_map();

	if ( empty( $map ) ) {
		return '';
	}

	$now       = post165_now();
	$now_month = (int) $now->format( 'n' );

	$out  = '<div class="post165-year">';
	$out .= '<p class="post165-eyebrow">' . esc_html__( 'Our year', 'post165' ) . '</p>';
	$out .= '<p class="post165-year__lede">' . esc_html__( "The post's rhythm — the same every year, whether or not a date is posted yet.", 'post165' ) . '</p>';
	$out .= '<ul class="post165-year__grid">';

	for ( $month = 1; $month <= 12; $month++ ) {
		$label = trim( (string) ( $map[ $month ]['label'] ?? '' ) );
		$stamp = post165_month_timestamp( $month, (int) $now->format( 'Y' ) );

		$classes = 'post165-year__mo';
		if ( '' !== $label ) {
			$classes .= ' post165-year__mo--has';
		}
		if ( $month === $now_month ) {
			$classes .= ' post165-year__mo--now';
		}

		$out .= '<li class="' . esc_attr( $classes ) . '"';
		$out .= $month === $now_month ? ' aria-current="date"' : '';
		$out .= '>';
		$out .= '<b><abbr title="' . esc_attr( wp_date( 'F', $stamp ) ) . '">' . esc_html( wp_date( 'M', $stamp ) ) . '</abbr></b>';

		if ( '' !== $label ) {
			$out .= '<span>' . esc_html( $label ) . '</span>';
		}

		$out .= '</li>';
	}

	$out .= '</ul>';
	$out .= '<p class="post165-year__foot">' . esc_html__( 'Meetings run every month, year round.', 'post165' ) . '</p>';
	$out .= '</div>';

	return $out;
}

/**
 * Render one definition row, or nothing when the value is empty.
 *
 * Absent facts are omitted rather than rendered as an empty row or a
 * plausible-looking placeholder.
 */
function post165_fact_row( string $label, string $value ): string {
	$value = trim( $value );

	if ( '' === $value ) {
		return '';
	}

	return '<div class="post165-fact"><dt>' . esc_html( $label ) . '</dt><dd>' . wp_kses_post( $value ) . '</dd></div>';
}

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

/**
 * Render the photo strip inside the navy strap at the top of the page.
 *
 * This block no longer renders a full-width row below the board: it now
 * sits between the tagline and the charter year inside `.post165-strap`
 * (see `patterns/home-board.php`), producing a bare
 * `.post165-strap__shots` wrapper around plain `<img>` elements — no
 * `<figure>`, no visible `<figcaption>`.
 *
 * Because there is no visible caption any more, the stored description is
 * the primary text alternative, so it is passed through as `alt` when set.
 * This is the reverse of the row this replaced, where a visible figcaption
 * already carried the description and an empty alt was correct to avoid a
 * screen reader announcing the same text twice. Do not "restore" that
 * behaviour here. But the `alt` key is only added when the description is
 * non-empty: passing an explicit empty string would override whatever alt
 * text is already stored against the attachment in the Media Library, and
 * silently destroy it. Leaving the key out lets wp_get_attachment_image()
 * fall back to the attachment's own alt text (or `alt=""` if it truly has
 * none, which is still correct — a photograph with neither a description
 * nor Media Library alt text has no text to give a screen reader).
 *
 * Still renders nothing at all until the post supplies images — an empty
 * frame or a stock photograph would both be worse than absence here, since
 * the page's whole argument is that this post actually shows up.
 */
function post165_render_work_photos(): string {
	$photos = post165_photos();

	if ( empty( $photos ) ) {
		return '';
	}

	$items = '';

	foreach ( $photos as $photo ) {
		$attr = array(
			'class'   => 'post165-strap__shot',
			'loading' => 'lazy',
		);

		$caption = trim( (string) ( $photo['caption'] ?? '' ) );

		// Only override WordPress's own alt text when a description was
		// supplied. Passing an empty alt would discard whatever the Media
		// Library holds, and with no visible caption these images would then
		// have no text alternative at all.
		if ( '' !== $caption ) {
			$attr['alt'] = $caption;
		}

		$img = wp_get_attachment_image( $photo['id'], 'thumbnail', false, $attr );

		if ( ! $img ) {
			continue;
		}

		$items .= $img;
	}

	if ( '' === $items ) {
		return '';
	}

	return '<div class="post165-strap__shots">' . $items . '</div>';
}
