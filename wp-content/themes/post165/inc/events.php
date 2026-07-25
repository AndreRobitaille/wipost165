<?php
/**
 * Assembles the homepage's dated list: computed meetings merged with real
 * Events Calendar entries, plus the quiet-season note.
 *
 * @package post165
 */

defined( 'ABSPATH' ) || exit;

const POST165_QUIET_WINDOW_DAYS = 60;
const POST165_MEETINGS_AHEAD    = 6;

/**
 * The post's annual rhythm, filterable.
 */
function post165_year_map(): array {
	return (array) apply_filters( 'post165_year_map', post165_default_year_map() );
}

/**
 * Current time in the site's timezone.
 */
function post165_now(): DateTimeImmutable {
	return new DateTimeImmutable( 'now', wp_timezone() );
}

/**
 * Computed meetings, with overrides applied.
 *
 * @return array[] Entry arrays.
 */
function post165_meeting_entries(): array {
	$rule  = post165_meeting_rule();
	$dates = post165_meeting_dates( $rule, post165_now(), POST165_MEETINGS_AHEAD );

	return post165_apply_meeting_overrides( $dates, post165_meeting_overrides(), $rule );
}

/**
 * Upcoming public events from The Events Calendar, normalised to entry arrays.
 *
 * Returns an empty list when the plugin is absent, so the homepage keeps
 * working with meetings alone.
 *
 * @return array[]
 */
function post165_public_event_entries( int $limit ): array {
	if ( ! function_exists( 'tribe_get_events' ) ) {
		return [];
	}

	$events = tribe_get_events(
		[
			'posts_per_page' => $limit,
			'start_date'     => current_time( 'Y-m-d H:i:s' ),
			'orderby'        => 'event_date',
			'order'          => 'ASC',
			'post_status'    => 'publish',
		]
	);

	if ( ! is_array( $events ) ) {
		return [];
	}

	$tz      = wp_timezone();
	$entries = [];

	foreach ( $events as $event ) {
		$raw = function_exists( 'tribe_get_start_date' )
			? tribe_get_start_date( $event, true, 'Y-m-d H:i:s' )
			: '';

		if ( ! $raw ) {
			continue;
		}

		$start = DateTimeImmutable::createFromFormat( 'Y-m-d H:i:s', $raw, $tz );

		if ( ! $start instanceof DateTimeImmutable ) {
			continue;
		}

		$entries[] = [
			'start'   => $start,
			'title'   => get_the_title( $event ),
			'venue'   => function_exists( 'tribe_get_venue' ) ? (string) tribe_get_venue( $event ) : '',
			'address' => '',
			'kind'    => 'public',
			'url'     => get_permalink( $event ),
		];
	}

	return $entries;
}

/**
 * Merged, sorted list of what is coming up.
 *
 * @return array[]
 */
function post165_upcoming_entries( int $limit = 5 ): array {
	$entries = array_merge( post165_meeting_entries(), post165_public_event_entries( $limit ) );

	usort(
		$entries,
		static function ( array $a, array $b ): int {
			return $a['start'] <=> $b['start'];
		}
	);

	return array_slice( $entries, 0, $limit );
}

/**
 * The quiet-season note, or null when public events are imminent.
 *
 * Appears automatically when no public event falls inside the window, so
 * nobody toggles it in October or May.
 *
 * Deliberately queries public events directly rather than reading the board's
 * display list: that list is truncated to what fits, so an event pushed off
 * the end would produce a false "quiet season" note while a real event was
 * imminent. The question is "is anything coming?", not "is anything shown?".
 *
 * @return array{label:string, month_name:string}|null
 */
function post165_quiet_season_note(): ?array {
	$now = post165_now();

	if ( post165_has_public_event_within( post165_public_event_entries( 20 ), $now, POST165_QUIET_WINDOW_DAYS ) ) {
		return null;
	}

	$milestone = post165_next_annual_milestone( post165_year_map(), $now );

	if ( null === $milestone ) {
		return null;
	}

	return [
		'label'      => $milestone['label'],
		'month_name' => wp_date( 'F', mktime( 0, 0, 0, $milestone['month'], 1, $milestone['year'] ) ),
	];
}
