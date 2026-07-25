<?php
/**
 * The post's annual rhythm, plus quiet-season helpers. No WordPress deps.
 *
 * The year map is hand-authored editorial content, not calendar data. That is
 * precisely why it stays true in February when the calendar is empty: it
 * answers "when is the car show?" before a date exists.
 *
 * @package post165
 */

declare(strict_types=1);

/**
 * Default twelve-month rhythm.
 *
 * IMPORTANT: only the brat fry (August) and car show (September) have been
 * confirmed by the post. Every other entry is provisional and MUST be verified
 * by an officer before launch — see spec §4.4 and §9. Override via the
 * `post165_year_map` filter rather than editing consumers.
 *
 * @return array<int, array{label: string}>
 */
function post165_default_year_map(): array {
	return [
		1  => [ 'label' => '' ],
		2  => [ 'label' => '' ],
		3  => [ 'label' => '' ],
		4  => [ 'label' => '' ],
		5  => [ 'label' => 'Memorial Day' ],
		6  => [ 'label' => 'Flag Day' ],
		7  => [ 'label' => '' ],
		8  => [ 'label' => 'Brat Fry' ],
		9  => [ 'label' => 'Car Show' ],
		10 => [ 'label' => '' ],
		11 => [ 'label' => 'Veterans Day' ],
		12 => [ 'label' => '' ],
	];
}

/**
 * Find the next annual milestone after the given moment.
 *
 * The current month is deliberately excluded so the result is deterministic:
 * the quiet-season note always points forward, never at something that may
 * already have happened this month.
 *
 * @param array             $map  Year map keyed 1..12.
 * @param DateTimeImmutable $from Reference moment.
 * @return array{month:int, year:int, label:string}|null
 */
function post165_next_annual_milestone( array $map, DateTimeImmutable $from ): ?array {
	$month = (int) $from->format( 'n' );
	$year  = (int) $from->format( 'Y' );

	for ( $i = 1; $i <= 12; $i++ ) {
		$offset = $month - 1 + $i;
		$target = ( $offset % 12 ) + 1;
		$target_year = $year + intdiv( $offset, 12 );

		$label = trim( (string) ( $map[ $target ]['label'] ?? '' ) );

		if ( '' !== $label ) {
			return [
				'month' => $target,
				'year'  => $target_year,
				'label' => $label,
			];
		}
	}

	return null;
}

/**
 * Whether any public event falls within the next N days.
 *
 * Drives the quiet-season note automatically, so nobody has to remember to
 * switch it on in October or off in May.
 *
 * @param array[]           $entries Entry arrays with start and kind.
 * @param DateTimeImmutable $from    Reference moment.
 * @param int               $days    Window length in days.
 */
function post165_has_public_event_within( array $entries, DateTimeImmutable $from, int $days ): bool {
	$limit = $from->modify( '+' . $days . ' days' );

	foreach ( $entries as $entry ) {
		if ( 'public' !== ( $entry['kind'] ?? '' ) ) {
			continue;
		}
		if ( ! ( $entry['start'] ?? null ) instanceof DateTimeImmutable ) {
			continue;
		}
		if ( $entry['start'] >= $from && $entry['start'] <= $limit ) {
			return true;
		}
	}

	return false;
}
