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
		$out .= '<b>' . esc_html( $start->format( 'j' ) ) . '</b>';
		$out .= '<span>' . esc_html( $start->format( 'M' ) ) . '</span>';
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
 * Render the membership panel.
 */
function post165_render_join_panel(): string {
	$rule         = post165_meeting_rule();
	$member_count = (int) post165_fact( 'member_count', 0 );
	$members      = post165_format_member_count( $member_count );

	$when = '';
	if ( '' !== $rule['ordinal'] && '' !== $rule['weekday'] && '' !== $rule['time'] ) {
		// Build the time in the site's timezone. strtotime() would parse against
		// the server's timezone, shifting the displayed hour when the two differ.
		$parsed  = DateTimeImmutable::createFromFormat( 'H:i', $rule['time'], wp_timezone() );
		$display = $parsed instanceof DateTimeImmutable
			? $parsed->format( 'g:i a' )
			: $rule['time'];

		$when = ucfirst( $rule['ordinal'] ) . ' ' . ucfirst( $rule['weekday'] )
			. ', ' . esc_html( $display );

		if ( '' !== $rule['venue'] ) {
			$when .= '<br />' . esc_html( $rule['venue'] );
		}
		if ( '' !== $rule['address'] ) {
			$when .= '<br />' . esc_html( $rule['address'] );
		}
	}

	$size = '';
	if ( null !== $members ) {
		// The displayed value may be a rounded string like "180+", but the
		// plural form must be decided from the true, unrounded count.
		// post165_format_member_count() returns null for any count <= 0, so
		// $member_count is a positive integer whenever we reach this branch.
		$size = esc_html(
			sprintf(
				/* translators: %s: formatted member count, e.g. "180+" or "3" */
				_n( '%s member', '%s members', $member_count, 'post165' ),
				$members
			)
		);
	}

	$rows  = post165_fact_row( __( 'Who', 'post165' ), esc_html( (string) post165_fact( 'eligibility', '' ) ) );
	$rows .= post165_fact_row( __( 'Dues', 'post165' ), esc_html( (string) post165_fact( 'dues', '' ) ) );
	$rows .= post165_fact_row( __( 'We meet', 'post165' ), $when );
	$rows .= post165_fact_row( __( 'Size', 'post165' ), $size );

	$out  = '<div class="post165-join">';
	$out .= '<p class="post165-eyebrow">' . esc_html__( 'Thinking about joining', 'post165' ) . '</p>';
	$out .= '<p class="post165-join__head">' . esc_html__( "You served. That doesn't have to be past tense.", 'post165' ) . '</p>';
	$out .= '<p class="post165-join__lede">' . esc_html__( 'Straight answers, no pitch.', 'post165' ) . '</p>';

	if ( '' !== $rows ) {
		$out .= '<dl class="post165-facts">' . $rows . '</dl>';
	}

	$out .= '<p class="post165-join__cta"><a class="wp-block-button__link wp-element-button" href="'
		. esc_url( home_url( '/membership/' ) ) . '">' . esc_html__( 'How to join', 'post165' ) . '</a></p>';

	// The named contact: with this audience a person's name outperforms a form.
	$name  = trim( (string) post165_fact( 'contact_name', '' ) );
	$role  = trim( (string) post165_fact( 'contact_role', '' ) );
	$email = trim( (string) post165_fact( 'contact_email', '' ) );
	$phone = trim( (string) post165_fact( 'contact_phone', '' ) );

	if ( '' !== $name || '' !== $email || '' !== $phone ) {
		$out .= '<div class="post165-join__who">';
		$out .= '<p>' . esc_html__( 'Questions? Talk to a person.', 'post165' ) . '</p>';

		if ( '' !== $name ) {
			$out .= '<p class="post165-join__name">' . esc_html( '' !== $role ? $name . ', ' . $role : $name ) . '</p>';
		}

		$bits = [];
		if ( '' !== $email ) {
			$safe   = antispambot( $email );
			$bits[] = '<a href="mailto:' . esc_attr( $safe ) . '">' . esc_html( $safe ) . '</a>';
		}
		if ( '' !== $phone ) {
			$bits[] = '<a href="tel:' . esc_attr( preg_replace( '/[^0-9+]/', '', $phone ) ) . '">' . esc_html( $phone ) . '</a>';
		}
		if ( $bits ) {
			$out .= '<p class="post165-join__contact">' . implode( ' · ', $bits ) . '</p>';
		}

		$out .= '</div>';
	}

	$out .= '</div>';

	return $out;
}
