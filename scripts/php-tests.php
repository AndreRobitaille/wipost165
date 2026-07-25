<?php
declare(strict_types=1);

$root = dirname(__DIR__);
$pure = $root . '/wp-content/themes/post165/inc/pure';

require $pure . '/format.php';
require $pure . '/meetings.php';
require $pure . '/overrides.php';
require $pure . '/year-map.php';

$tests = 0;
$fails = 0;

function ok(bool $cond, string $msg): void {
    global $tests, $fails;
    $tests++;
    if (!$cond) {
        $fails++;
        fwrite(STDERR, "FAIL: {$msg}\n");
    }
}

function eq($actual, $expected, string $msg): void {
    ok(
        $actual === $expected,
        $msg . ' (expected ' . var_export($expected, true) . ', got ' . var_export($actual, true) . ')'
    );
}

// --- post165_format_member_count -------------------------------------------
eq(post165_format_member_count(183), '180+', 'rounds 183 down to 180+');
eq(post165_format_member_count(200), '200+', 'exact multiple of 5 keeps the plus');
eq(post165_format_member_count(5),   '5+',   'lower boundary of rounding');
eq(post165_format_member_count(4),   '4',    'under 5 renders exactly, no plus');
eq(post165_format_member_count(1),   '1',    'one member renders exactly');
eq(post165_format_member_count(0),   null,   'zero omits the row');
eq(post165_format_member_count(''),  null,   'empty string omits the row');
eq(post165_format_member_count(null), null,  'null omits the row');
eq(post165_format_member_count(-3),  null,   'negative omits the row');
eq(post165_format_member_count('183'), '180+', 'numeric string is accepted');

// --- post165_meeting_dates -------------------------------------------------
$tz   = new DateTimeZone( 'America/Chicago' );
$rule = [
	'ordinal' => 'first',
	'weekday' => 'tuesday',
	'time'    => '18:30',
	'venue'   => 'Test Hall',
	'address' => '1 Test St',
];

$from  = new DateTimeImmutable( '2026-07-24 09:00:00', $tz );
$dates = post165_meeting_dates( $rule, $from, 3 );

eq( count( $dates ), 3, 'returns the requested number of meetings' );
eq( $dates[0]->format( 'Y-m-d H:i' ), '2026-08-04 18:30', 'July is already past, so first is Aug 4' );
eq( $dates[1]->format( 'Y-m-d H:i' ), '2026-09-01 18:30', 'second is Sep 1' );
eq( $dates[2]->format( 'Y-m-d H:i' ), '2026-10-06 18:30', 'third is Oct 6' );

// Same day, before the start time: today's meeting still counts.
$before = post165_meeting_dates( $rule, new DateTimeImmutable( '2026-08-04 17:00:00', $tz ), 1 );
eq( $before[0]->format( 'Y-m-d' ), '2026-08-04', 'before start time, today still counts' );

// Same day, after the start time: roll to next month.
$after = post165_meeting_dates( $rule, new DateTimeImmutable( '2026-08-04 19:00:00', $tz ), 1 );
eq( $after[0]->format( 'Y-m-d' ), '2026-09-01', 'after start time, rolls to next month' );

// Crossing a year boundary.
$ny = post165_meeting_dates( $rule, new DateTimeImmutable( '2026-12-15 09:00:00', $tz ), 2 );
eq( $ny[0]->format( 'Y-m-d' ), '2027-01-05', 'crosses into the new year' );
eq( $ny[1]->format( 'Y-m-d' ), '2027-02-02', 'and continues correctly' );

// A different standing rule.
$third = post165_meeting_dates(
	[ 'ordinal' => 'third', 'weekday' => 'thursday', 'time' => '19:00' ],
	new DateTimeImmutable( '2026-07-01 09:00:00', $tz ),
	1
);
eq( $third[0]->format( 'Y-m-d H:i' ), '2026-07-16 19:00', 'third Thursday rule is honoured' );

$last = post165_meeting_dates(
	[ 'ordinal' => 'last', 'weekday' => 'monday', 'time' => '18:00' ],
	new DateTimeImmutable( '2026-07-01 09:00:00', $tz ),
	1
);
eq( $last[0]->format( 'Y-m-d' ), '2026-07-27', 'last Monday rule is honoured' );

// Timezone is preserved.
eq( $dates[0]->getTimezone()->getName(), 'America/Chicago', 'keeps the timezone it was given' );

// Invalid rules degrade to empty rather than fataling.
eq( post165_meeting_dates( [ 'ordinal' => 'ninth', 'weekday' => 'tuesday', 'time' => '18:30' ], $from, 2 ), [], 'invalid ordinal yields no meetings' );
eq( post165_meeting_dates( [ 'ordinal' => 'first', 'weekday' => 'funday', 'time' => '18:30' ], $from, 2 ), [], 'invalid weekday yields no meetings' );
eq( post165_meeting_dates( [ 'ordinal' => 'first', 'weekday' => 'tuesday', 'time' => '25:00' ], $from, 2 ), [], 'invalid hour yields no meetings' );
eq( post165_meeting_dates( [ 'ordinal' => 'first', 'weekday' => 'tuesday', 'time' => 'evening' ], $from, 2 ), [], 'unparseable time yields no meetings' );
eq( post165_meeting_dates( $rule, $from, 0 ), [], 'zero count yields no meetings' );

// --- post165_apply_meeting_overrides ---------------------------------------
$base = post165_meeting_dates( $rule, new DateTimeImmutable( '2026-07-24 09:00:00', $tz ), 4 );
// Aug 4, Sep 1, Oct 6, Nov 3

$none = post165_apply_meeting_overrides( $base, [], $rule );
eq( count( $none ), 4, 'no overrides leaves every meeting' );
eq( $none[0]['start']->format( 'Y-m-d H:i' ), '2026-08-04 18:30', 'unchanged start' );
eq( $none[0]['venue'], 'Test Hall', 'venue inherits from the rule' );
eq( $none[0]['address'], '1 Test St', 'address inherits from the rule' );
eq( $none[0]['kind'], 'meeting', 'entries are marked as meetings' );
eq( $none[0]['title'], 'Post Meeting', 'entries carry a title' );

// Cancelled month disappears entirely.
$cancelled = post165_apply_meeting_overrides( $base, [ [ 'month' => '2026-09', 'cancelled' => true ] ], $rule );
eq( count( $cancelled ), 3, 'cancelled month is omitted, not struck through' );
eq( $cancelled[1]['start']->format( 'Y-m-d' ), '2026-10-06', 'the month after a cancellation is untouched' );

// Moved date keeps the rule's time.
$moved = post165_apply_meeting_overrides( $base, [ [ 'month' => '2026-11', 'date' => '2026-11-10' ] ], $rule );
eq( $moved[3]['start']->format( 'Y-m-d H:i' ), '2026-11-10 18:30', 'moved date inherits the rule time' );

// Changed time only.
$retimed = post165_apply_meeting_overrides( $base, [ [ 'month' => '2026-10', 'time' => '19:00' ] ], $rule );
eq( $retimed[2]['start']->format( 'Y-m-d H:i' ), '2026-10-06 19:00', 'time override applies to the rule date' );

// Changed venue only — date and time untouched.
$moved_venue = post165_apply_meeting_overrides(
	$base,
	[ [ 'month' => '2026-10', 'venue' => 'VFW Hall', 'address' => '9 Elm St' ] ],
	$rule
);
eq( $moved_venue[2]['venue'], 'VFW Hall', 'venue override applies' );
eq( $moved_venue[2]['address'], '9 Elm St', 'address override applies' );
eq( $moved_venue[2]['start']->format( 'Y-m-d H:i' ), '2026-10-06 18:30', 'venue override leaves date and time alone' );

// Date, time and venue together.
$all = post165_apply_meeting_overrides(
	$base,
	[ [ 'month' => '2026-09', 'date' => '2026-09-08', 'time' => '17:45', 'venue' => 'Legion Hall' ] ],
	$rule
);
eq( $all[1]['start']->format( 'Y-m-d H:i' ), '2026-09-08 17:45', 'combined override applies both' );
eq( $all[1]['venue'], 'Legion Hall', 'combined override applies the venue' );

// Irrelevant and malformed overrides are ignored.
$stale = post165_apply_meeting_overrides(
	$base,
	[
		[ 'month' => '2019-01', 'cancelled' => true ],
		[ 'month' => 'nonsense', 'cancelled' => true ],
		[ 'cancelled' => true ],
		[ 'month' => '', 'date' => '2026-08-11' ],
	],
	$rule
);
eq( count( $stale ), 4, 'past and malformed overrides are ignored' );
eq( $stale[0]['start']->format( 'Y-m-d' ), '2026-08-04', 'and do not disturb real meetings' );

// A malformed date inside an otherwise valid override is ignored.
$baddate = post165_apply_meeting_overrides( $base, [ [ 'month' => '2026-08', 'date' => '11/08/2026' ] ], $rule );
eq( $baddate[0]['start']->format( 'Y-m-d' ), '2026-08-04', 'unparseable override date falls back to the rule date' );

// Empty strings inherit rather than blanking the venue.
$blank = post165_apply_meeting_overrides( $base, [ [ 'month' => '2026-08', 'venue' => '' ] ], $rule );
eq( $blank[0]['venue'], 'Test Hall', 'blank override field inherits from the rule' );

// Last override wins when two target the same month.
$dupe = post165_apply_meeting_overrides(
	$base,
	[ [ 'month' => '2026-08', 'time' => '17:00' ], [ 'month' => '2026-08', 'time' => '20:00' ] ],
	$rule
);
eq( $dupe[0]['start']->format( 'H:i' ), '20:00', 'the later duplicate override wins' );

// Venue-only override: the old venue's address must NOT be carried over.
$venue_only = post165_apply_meeting_overrides( $base, [ [ 'month' => '2026-10', 'venue' => 'VFW Hall' ] ], $rule );
eq( $venue_only[2]['venue'], 'VFW Hall', 'venue-only override applies the venue' );
eq( $venue_only[2]['address'], '', 'a new venue does not inherit the old address' );

// Address-only override: applies, and leaves the venue alone.
$addr_only = post165_apply_meeting_overrides( $base, [ [ 'month' => '2026-10', 'address' => '9 Elm St' ] ], $rule );
eq( $addr_only[2]['address'], '9 Elm St', 'address-only override is applied, not dropped' );
eq( $addr_only[2]['venue'], 'Test Hall', 'address-only override leaves the venue inherited' );

// --- post165_default_year_map ----------------------------------------------
$map = post165_default_year_map();
eq( count( $map ), 12, 'year map covers twelve months' );
ok( array_key_exists( 1, $map ) && array_key_exists( 12, $map ), 'year map is keyed 1..12' );
eq( $map[8]['label'], 'Brat Fry', 'August carries the brat fry' );
eq( $map[9]['label'], 'Car Show', 'September carries the car show' );
eq( $map[1]['label'], '', 'January is quiet by default' );

// --- post165_next_annual_milestone -----------------------------------------
$m = post165_next_annual_milestone( $map, new DateTimeImmutable( '2027-01-15 09:00:00', $tz ) );
eq( $m['label'], 'Memorial Day', 'from January the next milestone is Memorial Day' );
eq( $m['month'], 5, 'and it is in month 5' );
eq( $m['year'], 2027, 'in the same year' );

$m2 = post165_next_annual_milestone( $map, new DateTimeImmutable( '2026-11-20 09:00:00', $tz ) );
eq( $m2['label'], 'Memorial Day', 'from November it wraps to next May' );
eq( $m2['year'], 2027, 'and rolls the year forward' );

$m3 = post165_next_annual_milestone( $map, new DateTimeImmutable( '2026-05-02 09:00:00', $tz ) );
eq( $m3['month'], 6, 'the current month is excluded, so May yields June' );

eq( post165_next_annual_milestone( [], new DateTimeImmutable( '2026-01-01 09:00:00', $tz ) ), null, 'an empty map yields null' );
eq(
	post165_next_annual_milestone(
		[ 1 => [ 'label' => '' ], 2 => [ 'label' => '' ] ],
		new DateTimeImmutable( '2026-01-01 09:00:00', $tz )
	),
	null,
	'a map with no labels yields null'
);

// --- post165_has_public_event_within ---------------------------------------
$now      = new DateTimeImmutable( '2026-07-24 09:00:00', $tz );
$meetings = post165_apply_meeting_overrides( post165_meeting_dates( $rule, $now, 3 ), [], $rule );

ok( ! post165_has_public_event_within( $meetings, $now, 60 ), 'meetings alone do not count as public events' );

$with_public   = $meetings;
$with_public[] = [
	'start'   => new DateTimeImmutable( '2026-08-16 10:00:00', $tz ),
	'title'   => 'Brat Fry',
	'venue'   => '',
	'address' => '',
	'kind'    => 'public',
];
ok( post165_has_public_event_within( $with_public, $now, 60 ), 'a public event inside the window is found' );
ok( ! post165_has_public_event_within( $with_public, $now, 7 ), 'a public event outside the window is not found' );
ok( ! post165_has_public_event_within( [], $now, 60 ), 'an empty list has no public events' );

// --- summary ---------------------------------------------------------------
if ($fails > 0) {
    fwrite(STDERR, "\n{$fails} of {$tests} assertions failed.\n");
    exit(1);
}
fwrite(STDOUT, "All {$tests} PHP assertions passed.\n");
