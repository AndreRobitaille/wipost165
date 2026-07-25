<?php
/**
 * Pure meeting-schedule logic. No WordPress dependencies — unit tested directly.
 *
 * The post's monthly meeting is computed from a rule rather than entered,
 * because the free Events Calendar has no recurrence and a volunteer will
 * eventually forget. This gives the homepage a real dated entry year round,
 * including the October–March stretch with no public events.
 *
 * @package post165
 */

declare(strict_types=1);

const POST165_ORDINALS = [ 'first', 'second', 'third', 'fourth', 'last' ];
const POST165_WEEKDAYS = [ 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday' ];

/**
 * Compute upcoming meeting datetimes from the standing rule.
 *
 * @param array             $rule  ordinal, weekday, time (24h "H:i").
 * @param DateTimeImmutable $from  Lower bound; meetings at or after this are returned.
 * @param int               $count How many to return.
 * @return DateTimeImmutable[] Empty when the rule is invalid.
 */
function post165_meeting_dates( array $rule, DateTimeImmutable $from, int $count ): array {
	$ordinal = strtolower( (string) ( $rule['ordinal'] ?? '' ) );
	$weekday = strtolower( (string) ( $rule['weekday'] ?? '' ) );
	$time    = (string) ( $rule['time'] ?? '' );

	if ( ! in_array( $ordinal, POST165_ORDINALS, true ) ) {
		return [];
	}
	if ( ! in_array( $weekday, POST165_WEEKDAYS, true ) ) {
		return [];
	}
	if ( ! preg_match( '/^(\d{1,2}):(\d{2})$/', $time, $m ) ) {
		return [];
	}

	$hour   = (int) $m[1];
	$minute = (int) $m[2];

	if ( $hour > 23 || $minute > 59 ) {
		return [];
	}
	if ( $count < 1 ) {
		return [];
	}

	$tz     = $from->getTimezone();
	$out    = [];
	$cursor = $from->setDate( (int) $from->format( 'Y' ), (int) $from->format( 'n' ), 1 )->setTime( 0, 0 );

	// Guard against pathological loops; count + 24 months is far beyond any real need.
	$guard = 0;

	while ( count( $out ) < $count && $guard < $count + 24 ) {
		$guard++;

		$spec = sprintf( '%s %s of %s', $ordinal, $weekday, $cursor->format( 'F Y' ) );
		$date = new DateTimeImmutable( $spec, $tz );
		$date = $date->setTime( $hour, $minute );

		if ( $date >= $from ) {
			$out[] = $date;
		}

		$cursor = $cursor->modify( 'first day of next month' );
	}

	return $out;
}
