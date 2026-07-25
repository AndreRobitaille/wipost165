<?php
/**
 * Pure formatting helpers. No WordPress dependencies — unit tested directly.
 *
 * @package post165
 */

declare(strict_types=1);

/**
 * Render a roster count as a rounded, understated figure.
 *
 * The post enters its true number; the site shows it rounded down to the
 * nearest 5 with a plus, so the figure stays true as the roster drifts and
 * never overstates. Counts below 5 render exactly, because flooring them
 * would print an absurd "0+".
 *
 * @param mixed $count Raw stored value.
 * @return string|null Display string, or null when the row should be omitted.
 */
function post165_format_member_count( $count ): ?string {
	if ( null === $count || '' === $count || ! is_numeric( $count ) ) {
		return null;
	}

	$n = (int) $count;

	if ( $n <= 0 ) {
		return null;
	}

	if ( $n < 5 ) {
		return (string) $n;
	}

	return (string) ( intdiv( $n, 5 ) * 5 ) . '+';
}
