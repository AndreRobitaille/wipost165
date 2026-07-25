<?php
declare(strict_types=1);

$root = dirname(__DIR__);
$pure = $root . '/wp-content/themes/post165/inc/pure';

require $pure . '/format.php';
require $pure . '/meetings.php';

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

// --- summary ---------------------------------------------------------------
if ($fails > 0) {
    fwrite(STDERR, "\n{$fails} of {$tests} assertions failed.\n");
    exit(1);
}
fwrite(STDOUT, "All {$tests} PHP assertions passed.\n");
