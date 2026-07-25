<?php
/**
 * Pure per-meeting override logic. No WordPress dependencies.
 *
 * Overrides are keyed by calendar month ("YYYY-MM") rather than by the
 * computed date, because the standing rule yields exactly one meeting per
 * month. Keying on the date would silently stop matching the moment anyone
 * edits the rule.
 *
 * @package post165
 */

declare(strict_types=1);

/**
 * Apply per-month overrides to computed meeting dates.
 *
 * Blank fields inherit from the standing rule, so relocating one meeting does
 * not require restating its date and time. A cancelled month is omitted
 * entirely — a visitor scanning for the next meeting should not have to parse
 * a negation.
 *
 * @param DateTimeImmutable[] $dates     Computed meeting datetimes.
 * @param array               $overrides Rows with month, and optional date, time, venue, address, cancelled.
 * @param array               $rule      Standing rule, supplying default venue and address.
 * @return array[] Entry arrays: start, title, venue, address, kind.
 */
function post165_apply_meeting_overrides( array $dates, array $overrides, array $rule ): array {
	$by_month = [];

	foreach ( $overrides as $override ) {
		if ( ! is_array( $override ) ) {
			continue;
		}
		$month = (string) ( $override['month'] ?? '' );
		if ( ! preg_match( '/^\d{4}-\d{2}$/', $month ) ) {
			continue;
		}
		// A later row for the same month replaces an earlier one.
		$by_month[ $month ] = $override;
	}

	$entries = [];

	foreach ( $dates as $date ) {
		$key      = $date->format( 'Y-m' );
		$start    = $date;
		$venue    = (string) ( $rule['venue'] ?? '' );
		$address  = (string) ( $rule['address'] ?? '' );

		if ( isset( $by_month[ $key ] ) ) {
			$override = $by_month[ $key ];

			if ( ! empty( $override['cancelled'] ) ) {
				continue;
			}

			$new_date = (string) ( $override['date'] ?? '' );
			if ( preg_match( '/^\d{4}-\d{2}-\d{2}$/', $new_date ) ) {
				$parsed = DateTimeImmutable::createFromFormat(
					'Y-m-d H:i:s',
					$new_date . ' 00:00:00',
					$date->getTimezone()
				);
				if ( $parsed instanceof DateTimeImmutable ) {
					$start = $parsed->setTime(
						(int) $start->format( 'G' ),
						(int) $start->format( 'i' )
					);
				}
			}

			$new_time = (string) ( $override['time'] ?? '' );
			if ( preg_match( '/^(\d{1,2}):(\d{2})$/', $new_time, $m ) && (int) $m[1] < 24 && (int) $m[2] < 60 ) {
				$start = $start->setTime( (int) $m[1], (int) $m[2] );
			}

			$new_venue = trim( (string) ( $override['venue'] ?? '' ) );
			if ( '' !== $new_venue ) {
				$venue   = $new_venue;
				$address = trim( (string) ( $override['address'] ?? '' ) );
			}
		}

		$entries[] = [
			'start'   => $start,
			'title'   => 'Post Meeting',
			'venue'   => $venue,
			'address' => $address,
			'kind'    => 'meeting',
		];
	}

	return $entries;
}
