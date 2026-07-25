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
