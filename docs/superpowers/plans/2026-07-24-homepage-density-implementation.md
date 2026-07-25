# Homepage Density Redesign ("The Board") Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the Post 165 homepage's six identically-shaped brochure bands (3.7 viewports, 426 words) with a two-column "answer board" that serves both audiences above the fold and stays alive through the October–March season with no public events.

**Architecture:** All date arithmetic, override resolution, and formatting live in **pure PHP functions with zero WordPress dependencies**, under `inc/pure/`. These are unit-tested by a dependency-free assertion runner executed through Docker (no PHP on the host). Thin WordPress layers on top read options, integrate The Events Calendar, and render three server-side dynamic blocks. Dynamic blocks — not PHP inside pattern files — because theme pattern output can be cached, which would freeze computed dates.

**Tech Stack:** WordPress 6.5+ block theme, PHP 8.1+ (tested on 8.3 via `php:8.3-cli` Docker image), Node 20 for the static validator, The Events Calendar (optional at runtime).

## Global Constraints

- **Invent no facts.** Dues, member count, contact person, venue address, and the year map are supplied by the post. Absent values omit their row — never a placeholder, never a plausible-looking guess. (Spec §9)
- **No JS build step**, no framework, no client-side rendering, no carousel or animation. (Spec §8)
- Pure logic in `inc/pure/` must never call a WordPress function — the test runner boots no WordPress.
- All output escaped at render: `esc_html`, `esc_attr`, `esc_url`; email through `antispambot()`.
- Empty facts omit their row entirely. A count of 0 or blank renders no Size row. (Spec §4.6)
- Cancelled meetings are **omitted**, not struck through. (Spec §4.3.1)
- Colour tokens are fixed: navy `#0e2340`, cream `#f7f1e3`, gold `#c49a3a`, gold-light `#d9b45b`, gold-deep `#7a5a12`, red `#9f1d2e`, ink `#1f2933`.
- Gold-toned text on light surfaces uses gold-deep `#7a5a12`; links on navy use gold-light `#d9b45b`. (Established by the prior spec; do not regress.)
- `npm test` must pass at the end of every task.

---

### Task 1: PHP test harness + member count formatting

Establishes the test infrastructure on the smallest piece of real logic, so the harness is proven before anything depends on it.

**Files:**
- Create: `wp-content/themes/post165/inc/pure/format.php`
- Create: `scripts/php-tests.php`
- Create: `scripts/php-tests.sh`
- Modify: `package.json` (scripts block)

**Interfaces:**
- Consumes: nothing.
- Produces: `post165_format_member_count(mixed $count): ?string` — returns `null` for empty/zero/negative, the exact integer as a string for 1–4, otherwise floor-to-nearest-5 with a `+` suffix. Also produces the `ok()` / `eq()` assertion helpers and the `sh scripts/php-tests.sh` entry point used by every later pure-logic task.

- [ ] **Step 1: Write the failing test**

Create `scripts/php-tests.php`:

```php
<?php
declare(strict_types=1);

$root = dirname(__DIR__);
$pure = $root . '/wp-content/themes/post165/inc/pure';

require $pure . '/format.php';

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

// --- summary ---------------------------------------------------------------
if ($fails > 0) {
    fwrite(STDERR, "\n{$fails} of {$tests} assertions failed.\n");
    exit(1);
}
fwrite(STDOUT, "All {$tests} PHP assertions passed.\n");
```

Create `scripts/php-tests.sh`:

```sh
#!/usr/bin/env sh
# Runs the pure-logic PHP tests. Uses a local php if present, otherwise Docker.
set -e
DIR="$(cd "$(dirname "$0")/.." && pwd)"

if command -v php >/dev/null 2>&1; then
  exec php "$DIR/scripts/php-tests.php"
elif command -v docker >/dev/null 2>&1; then
  exec docker run --rm -v "$DIR":/app -w /app php:8.3-cli php scripts/php-tests.php
else
  echo "Neither php nor docker is available. Install PHP 8.1+ or Docker to run these tests." >&2
  exit 1
fi
```

- [ ] **Step 2: Run the test to verify it fails**

```bash
chmod +x scripts/php-tests.sh && sh scripts/php-tests.sh
```

Expected: failure — PHP cannot open `inc/pure/format.php` (file does not exist yet).

- [ ] **Step 3: Write the minimal implementation**

Create `wp-content/themes/post165/inc/pure/format.php`:

```php
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
```

- [ ] **Step 4: Run the test to verify it passes**

```bash
sh scripts/php-tests.sh
```

Expected: `All 10 PHP assertions passed.`

- [ ] **Step 5: Wire into npm test**

In `package.json`, change the `test` script and add `test:php`:

```json
"test": "node scripts/validate-theme.mjs && sh scripts/php-tests.sh",
"test:php": "sh scripts/php-tests.sh",
```

Leave `lint`, `typecheck`, `build`, and `dev` unchanged.

- [ ] **Step 6: Verify the combined gate passes**

```bash
npm test
```

Expected: `Theme validation passed.` followed by `All 10 PHP assertions passed.`

- [ ] **Step 7: Commit**

```bash
git add scripts/php-tests.php scripts/php-tests.sh package.json wp-content/themes/post165/inc/pure/format.php
git commit -m "test: add dependency-free PHP test harness and member count formatting

Runs pure logic through a local php when available, otherwise the
php:8.3-cli Docker image, so the date and formatting rules are actually
verifiable on a machine with no PHP installed.

Member count is entered exactly and displayed rounded down to the nearest
5 with a plus, so the figure stays true as the roster drifts. Counts under
5 render exactly, since flooring them would print '0+'."
```

---

### Task 2: Meeting date computation

**Files:**
- Create: `wp-content/themes/post165/inc/pure/meetings.php`
- Modify: `scripts/php-tests.php`

**Interfaces:**
- Consumes: the `ok()` / `eq()` helpers from Task 1.
- Produces: `post165_meeting_dates(array $rule, DateTimeImmutable $from, int $count): array` — returns a list of `DateTimeImmutable`, one per consecutive month, each at the rule's time, all `>= $from`. Returns `[]` on an invalid rule. The `$rule` array shape defined here (`ordinal`, `weekday`, `time`, `venue`, `address`) is used by Tasks 3, 5, and 6.

- [ ] **Step 1: Write the failing test**

Add to `scripts/php-tests.php`, immediately after the `require` of `format.php`:

```php
require $pure . '/meetings.php';
```

And append before the summary block:

```php
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
```

- [ ] **Step 2: Run the test to verify it fails**

```bash
sh scripts/php-tests.sh
```

Expected: failure opening `inc/pure/meetings.php`.

- [ ] **Step 3: Write the minimal implementation**

Create `wp-content/themes/post165/inc/pure/meetings.php`:

```php
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
```

- [ ] **Step 4: Run the test to verify it passes**

```bash
sh scripts/php-tests.sh
```

Expected: all assertions pass (10 from Task 1 plus 16 here).

- [ ] **Step 5: Commit**

```bash
git add wp-content/themes/post165/inc/pure/meetings.php scripts/php-tests.php
git commit -m "feat: compute monthly meeting dates from a standing rule

Free Events Calendar has no recurrence, so the meeting is derived from an
ordinal/weekday/time rule instead of being entered. Covers the same-day
boundary either side of the start time, year rollover, alternate rules
including 'last', timezone preservation, and invalid rules degrading to an
empty list rather than fataling."
```

---

### Task 3: Per-meeting overrides

**Files:**
- Create: `wp-content/themes/post165/inc/pure/overrides.php`
- Modify: `scripts/php-tests.php`

**Interfaces:**
- Consumes: `post165_meeting_dates()` (Task 2) and the `$rule` shape.
- Produces: `post165_apply_meeting_overrides(array $dates, array $overrides, array $rule): array` — turns bare dates into **entry arrays** of the shape `['start' => DateTimeImmutable, 'title' => string, 'venue' => string, 'address' => string, 'kind' => 'meeting']`. This entry shape is the common currency for Tasks 4, 6, and 7; TEC events are normalised into the same shape with `kind => 'public'`.

- [ ] **Step 1: Write the failing test**

Add `require $pure . '/overrides.php';` to the requires in `scripts/php-tests.php`, then append:

```php
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

// Venue-only override: the old venue's address must NOT be carried over.
$venue_only = post165_apply_meeting_overrides( $base, [ [ 'month' => '2026-10', 'venue' => 'VFW Hall' ] ], $rule );
eq( $venue_only[2]['venue'], 'VFW Hall', 'venue-only override applies the venue' );
eq( $venue_only[2]['address'], '', 'a new venue does not inherit the old address' );

// Address-only override: applies, and leaves the venue alone.
$addr_only = post165_apply_meeting_overrides( $base, [ [ 'month' => '2026-10', 'address' => '9 Elm St' ] ], $rule );
eq( $addr_only[2]['address'], '9 Elm St', 'address-only override is applied, not dropped' );
eq( $addr_only[2]['venue'], 'Test Hall', 'address-only override leaves the venue inherited' );

// Last override wins when two target the same month.
$dupe = post165_apply_meeting_overrides(
	$base,
	[ [ 'month' => '2026-08', 'time' => '17:00' ], [ 'month' => '2026-08', 'time' => '20:00' ] ],
	$rule
);
eq( $dupe[0]['start']->format( 'H:i' ), '20:00', 'the later duplicate override wins' );
```

- [ ] **Step 2: Run the test to verify it fails**

```bash
sh scripts/php-tests.sh
```

Expected: failure opening `inc/pure/overrides.php`.

- [ ] **Step 3: Write the minimal implementation**

Create `wp-content/themes/post165/inc/pure/overrides.php`:

```php
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
 * Blank date, time and venue fields inherit from the standing rule, so
 * retiming one meeting does not require restating its date. A changed venue
 * clears the address unless a new one is supplied, because the rule's address
 * belongs to the usual venue. A cancelled month is omitted entirely — a
 * visitor scanning for the next meeting should not have to parse a negation.
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

			$new_venue   = trim( (string) ( $override['venue'] ?? '' ) );
			$new_address = trim( (string) ( $override['address'] ?? '' ) );

			if ( '' !== $new_venue ) {
				$venue = $new_venue;
				/*
				 * A new venue deliberately does NOT inherit the standing rule's
				 * address: that address belongs to the usual venue, and printing
				 * it against a different hall would send people to the wrong
				 * place. Supply an address alongside the venue, or the row shows
				 * the venue name alone.
				 */
				$address = $new_address;
			} elseif ( '' !== $new_address ) {
				// Same venue, corrected address.
				$address = $new_address;
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
```

- [ ] **Step 4: Run the test to verify it passes**

```bash
sh scripts/php-tests.sh
```

Expected: all assertions pass.

- [ ] **Step 5: Commit**

```bash
git add wp-content/themes/post165/inc/pure/overrides.php scripts/php-tests.php
git commit -m "feat: apply per-month overrides to computed meetings

Overrides are keyed by calendar month rather than computed date, so editing
the standing rule cannot silently orphan them. Blank fields inherit from the
rule, cancelled months are omitted rather than struck through, and past or
malformed rows are ignored."
```

---

### Task 4: Year map, next milestone, and quiet-season detection

**Files:**
- Create: `wp-content/themes/post165/inc/pure/year-map.php`
- Modify: `scripts/php-tests.php`

**Interfaces:**
- Consumes: the entry shape from Task 3.
- Produces:
  - `post165_default_year_map(): array` — keys 1–12, each `['label' => string]`.
  - `post165_next_annual_milestone(array $map, DateTimeImmutable $from): ?array` — `['month' => int, 'year' => int, 'label' => string]` or `null`. Searches the months **after** `$from`'s month.
  - `post165_has_public_event_within(array $entries, DateTimeImmutable $from, int $days): bool`.

- [ ] **Step 1: Write the failing test**

Add `require $pure . '/year-map.php';` to the requires, then append:

```php
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
```

- [ ] **Step 2: Run the test to verify it fails**

```bash
sh scripts/php-tests.sh
```

Expected: failure opening `inc/pure/year-map.php`.

- [ ] **Step 3: Write the minimal implementation**

Create `wp-content/themes/post165/inc/pure/year-map.php`:

```php
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
```

- [ ] **Step 4: Run the test to verify it passes**

```bash
sh scripts/php-tests.sh
```

Expected: all assertions pass.

- [ ] **Step 5: Commit**

```bash
git add wp-content/themes/post165/inc/pure/year-map.php scripts/php-tests.php
git commit -m "feat: add year map, next-milestone lookup, and quiet-season detection

The year map is editorial content rather than calendar data, so it stays
true through the October-March stretch when the calendar is empty. The
quiet-season note is driven by a 60-day public-event window, so nobody has
to toggle it seasonally.

Only the brat fry and car show are confirmed; the remaining months are
marked provisional pending confirmation by an officer."
```

---

### Task 5: Settings screen and fact accessor

**Files:**
- Create: `wp-content/themes/post165/inc/settings.php`
- Modify: `wp-content/themes/post165/functions.php`
- Modify: `scripts/validate-theme.mjs`

**Interfaces:**
- Consumes: `post165_meeting_dates()` rule shape (Task 2).
- Produces:
  - `post165_fact(string $key, mixed $default = ''): mixed`
  - `post165_meeting_rule(): array` — returns `['ordinal','weekday','time','venue','address']` ready for Task 2.
  - `post165_meeting_overrides(): array` — six rows ready for Task 3.
  - Option name constant `POST165_OPTION` = `'post165_facts'`.

- [ ] **Step 1: Add the validator assertions first**

In `scripts/validate-theme.mjs`, add to `requiredFiles`:

```js
  'wp-content/themes/post165/inc/settings.php',
```

And add a `requiredText` entry:

```js
  ['wp-content/themes/post165/inc/settings.php', ['post165_fact', 'post165_meeting_rule', 'post165_meeting_overrides', 'sanitize_email', 'manage_options']],
```

And extend the existing `functions.php` entry to require the include (replace that line):

```js
  ['wp-content/themes/post165/functions.php', ['post165_setup', 'post165_register_pattern_categories', 'add_theme_support', 'wp_enqueue_style', "add_theme_support( 'custom-logo'", 'inc/settings.php']],
```

- [ ] **Step 2: Run the validator to verify it fails**

```bash
npm test
```

Expected: `Missing required file: wp-content/themes/post165/inc/settings.php` and a missing-include failure on `functions.php`.

- [ ] **Step 3: Write the implementation**

Create `wp-content/themes/post165/inc/settings.php`:

```php
<?php
/**
 * Settings → Post 165. Facts that go stale must be fixable by an officer in
 * wp-admin, not by a developer via a commit.
 *
 * @package post165
 */

defined( 'ABSPATH' ) || exit;

const POST165_OPTION         = 'post165_facts';
const POST165_OVERRIDE_ROWS  = 6;

/**
 * Defaults. Every content value is deliberately empty: absent facts omit their
 * row rather than printing a plausible-looking invention.
 */
function post165_default_facts(): array {
	return [
		'eligibility'     => '',
		'dues'            => '',
		'member_count'    => 0,
		'charter_year'    => 1919,
		'meeting_ordinal' => 'first',
		'meeting_weekday' => 'tuesday',
		'meeting_time'    => '18:30',
		'venue'           => '',
		'address'         => '',
		'contact_name'    => '',
		'contact_role'    => '',
		'contact_email'   => '',
		'contact_phone'   => '',
		'overrides'       => [],
	];
}

/**
 * Read a single stored fact.
 *
 * @param string $key     Fact key.
 * @param mixed  $default Returned when the stored value is missing.
 * @return mixed
 */
function post165_fact( string $key, $default = '' ) {
	$stored = get_option( POST165_OPTION, [] );
	$facts  = array_merge( post165_default_facts(), is_array( $stored ) ? $stored : [] );

	return array_key_exists( $key, $facts ) ? $facts[ $key ] : $default;
}

/**
 * The standing meeting rule, shaped for post165_meeting_dates().
 */
function post165_meeting_rule(): array {
	return [
		'ordinal' => (string) post165_fact( 'meeting_ordinal', 'first' ),
		'weekday' => (string) post165_fact( 'meeting_weekday', 'tuesday' ),
		'time'    => (string) post165_fact( 'meeting_time', '18:30' ),
		'venue'   => (string) post165_fact( 'venue', '' ),
		'address' => (string) post165_fact( 'address', '' ),
	];
}

/**
 * Per-month override rows, shaped for post165_apply_meeting_overrides().
 */
function post165_meeting_overrides(): array {
	$rows = post165_fact( 'overrides', [] );

	return is_array( $rows ) ? $rows : [];
}

/**
 * Sanitise the whole option on save.
 */
function post165_sanitize_facts( $input ): array {
	$input  = is_array( $input ) ? $input : [];
	$out    = post165_default_facts();

	foreach ( [ 'eligibility', 'dues', 'venue', 'address', 'contact_name', 'contact_role', 'contact_phone' ] as $key ) {
		$out[ $key ] = sanitize_text_field( (string) ( $input[ $key ] ?? '' ) );
	}

	$out['member_count'] = absint( $input['member_count'] ?? 0 );
	$out['charter_year'] = absint( $input['charter_year'] ?? 0 );
	$out['contact_email'] = sanitize_email( (string) ( $input['contact_email'] ?? '' ) );

	$ordinal = strtolower( sanitize_text_field( (string) ( $input['meeting_ordinal'] ?? '' ) ) );
	$out['meeting_ordinal'] = in_array( $ordinal, POST165_ORDINALS, true ) ? $ordinal : 'first';

	$weekday = strtolower( sanitize_text_field( (string) ( $input['meeting_weekday'] ?? '' ) ) );
	$out['meeting_weekday'] = in_array( $weekday, POST165_WEEKDAYS, true ) ? $weekday : 'tuesday';

	$time = sanitize_text_field( (string) ( $input['meeting_time'] ?? '' ) );
	$out['meeting_time'] = preg_match( '/^([01]?\d|2[0-3]):[0-5]\d$/', $time ) ? $time : '18:30';

	$overrides     = [];
	$raw_overrides = is_array( $input['overrides'] ?? null ) ? $input['overrides'] : [];

	foreach ( array_slice( $raw_overrides, 0, POST165_OVERRIDE_ROWS ) as $row ) {
		if ( ! is_array( $row ) ) {
			continue;
		}

		$month = sanitize_text_field( (string) ( $row['month'] ?? '' ) );
		if ( ! preg_match( '/^\d{4}-\d{2}$/', $month ) ) {
			continue;
		}

		$date = sanitize_text_field( (string) ( $row['date'] ?? '' ) );
		$time = sanitize_text_field( (string) ( $row['time'] ?? '' ) );

		$overrides[] = [
			'month'     => $month,
			'date'      => preg_match( '/^\d{4}-\d{2}-\d{2}$/', $date ) ? $date : '',
			'time'      => preg_match( '/^([01]?\d|2[0-3]):[0-5]\d$/', $time ) ? $time : '',
			'venue'     => sanitize_text_field( (string) ( $row['venue'] ?? '' ) ),
			'address'   => sanitize_text_field( (string) ( $row['address'] ?? '' ) ),
			'cancelled' => ! empty( $row['cancelled'] ),
		];
	}

	$out['overrides'] = $overrides;

	return $out;
}

/**
 * Register the option.
 */
function post165_register_settings(): void {
	register_setting(
		'post165_settings',
		POST165_OPTION,
		[
			'type'              => 'array',
			'sanitize_callback' => 'post165_sanitize_facts',
			'default'           => post165_default_facts(),
		]
	);
}
add_action( 'admin_init', 'post165_register_settings' );

/**
 * Add the settings page.
 */
function post165_settings_menu(): void {
	add_options_page(
		__( 'Post 165', 'post165' ),
		__( 'Post 165', 'post165' ),
		'manage_options',
		'post165-settings',
		'post165_render_settings_page'
	);
}
add_action( 'admin_menu', 'post165_settings_menu' );

/**
 * Render one text input bound to a fact key.
 */
function post165_settings_field( string $key, string $label, string $type = 'text', string $help = '' ): void {
	$value = post165_fact( $key, '' );
	$name  = POST165_OPTION . '[' . $key . ']';
	$id    = 'post165-' . str_replace( '_', '-', $key );

	printf(
		'<tr><th scope="row"><label for="%1$s">%2$s</label></th><td>'
		. '<input type="%3$s" id="%1$s" name="%4$s" value="%5$s" class="regular-text" />%6$s</td></tr>',
		esc_attr( $id ),
		esc_html( $label ),
		esc_attr( $type ),
		esc_attr( $name ),
		esc_attr( (string) $value ),
		$help ? '<p class="description">' . esc_html( $help ) . '</p>' : ''
	);
}

/**
 * Render a select bound to a fact key.
 */
function post165_settings_select( string $key, string $label, array $choices ): void {
	$value = (string) post165_fact( $key, '' );
	$name  = POST165_OPTION . '[' . $key . ']';
	$id    = 'post165-' . str_replace( '_', '-', $key );

	echo '<tr><th scope="row"><label for="' . esc_attr( $id ) . '">' . esc_html( $label ) . '</label></th><td>';
	echo '<select id="' . esc_attr( $id ) . '" name="' . esc_attr( $name ) . '">';
	foreach ( $choices as $choice ) {
		printf(
			'<option value="%1$s"%2$s>%3$s</option>',
			esc_attr( $choice ),
			selected( $value, $choice, false ),
			esc_html( ucfirst( $choice ) )
		);
	}
	echo '</select></td></tr>';
}

/**
 * The settings screen.
 */
function post165_render_settings_page(): void {
	if ( ! current_user_can( 'manage_options' ) ) {
		return;
	}

	$overrides = post165_meeting_overrides();
	?>
	<div class="wrap">
		<h1><?php esc_html_e( 'Post 165', 'post165' ); ?></h1>
		<p><?php esc_html_e( 'These values appear on the homepage. Anything left blank is left off the page entirely rather than shown as a placeholder.', 'post165' ); ?></p>

		<form action="options.php" method="post">
			<?php settings_fields( 'post165_settings' ); ?>

			<h2><?php esc_html_e( 'Membership facts', 'post165' ); ?></h2>
			<table class="form-table" role="presentation">
				<?php
				post165_settings_field( 'eligibility', __( 'Who can join', 'post165' ), 'text', __( 'For example: any veteran with honorable service since WWII.', 'post165' ) );
				post165_settings_field( 'dues', __( 'Dues', 'post165' ), 'text', __( 'Written as it should appear, for example "$45 a year".', 'post165' ) );
				post165_settings_field( 'member_count', __( 'Member count', 'post165' ), 'number', __( 'Enter the true number. The site rounds down to the nearest 5 and adds a plus, so it stays accurate as the roster changes.', 'post165' ) );
				post165_settings_field( 'charter_year', __( 'Charter year', 'post165' ), 'number' );
				?>
			</table>

			<h2><?php esc_html_e( 'Meetings', 'post165' ); ?></h2>
			<p><?php esc_html_e( 'Meeting dates are calculated from this rule, so they never need entering by hand.', 'post165' ); ?></p>
			<table class="form-table" role="presentation">
				<?php
				post165_settings_select( 'meeting_ordinal', __( 'Which week', 'post165' ), POST165_ORDINALS );
				post165_settings_select( 'meeting_weekday', __( 'Which day', 'post165' ), POST165_WEEKDAYS );
				post165_settings_field( 'meeting_time', __( 'Start time', 'post165' ), 'text', __( '24-hour clock, for example 18:30.', 'post165' ) );
				post165_settings_field( 'venue', __( 'Venue name', 'post165' ) );
				post165_settings_field( 'address', __( 'Street address', 'post165' ) );
				?>
			</table>

			<h2><?php esc_html_e( 'Changes to individual meetings', 'post165' ); ?></h2>
			<p><?php esc_html_e( 'Use these only when a single meeting differs from the usual rule. Leave a field blank to keep the usual value. A cancelled meeting is left off the homepage.', 'post165' ); ?></p>
			<table class="widefat striped">
				<thead>
					<tr>
						<th scope="col"><?php esc_html_e( 'Month (YYYY-MM)', 'post165' ); ?></th>
						<th scope="col"><?php esc_html_e( 'New date', 'post165' ); ?></th>
						<th scope="col"><?php esc_html_e( 'New time', 'post165' ); ?></th>
						<th scope="col"><?php esc_html_e( 'New venue', 'post165' ); ?></th>
						<th scope="col"><?php esc_html_e( 'Cancelled', 'post165' ); ?></th>
					</tr>
				</thead>
				<tbody>
				<?php for ( $i = 0; $i < POST165_OVERRIDE_ROWS; $i++ ) : ?>
					<?php $row = $overrides[ $i ] ?? []; ?>
					<tr>
						<td><input type="text" placeholder="2026-11" name="<?php echo esc_attr( POST165_OPTION ); ?>[overrides][<?php echo (int) $i; ?>][month]" value="<?php echo esc_attr( $row['month'] ?? '' ); ?>" /></td>
						<td><input type="date" name="<?php echo esc_attr( POST165_OPTION ); ?>[overrides][<?php echo (int) $i; ?>][date]" value="<?php echo esc_attr( $row['date'] ?? '' ); ?>" /></td>
						<td><input type="text" placeholder="19:00" name="<?php echo esc_attr( POST165_OPTION ); ?>[overrides][<?php echo (int) $i; ?>][time]" value="<?php echo esc_attr( $row['time'] ?? '' ); ?>" /></td>
						<td><input type="text" name="<?php echo esc_attr( POST165_OPTION ); ?>[overrides][<?php echo (int) $i; ?>][venue]" value="<?php echo esc_attr( $row['venue'] ?? '' ); ?>" /></td>
						<td><input type="checkbox" value="1" name="<?php echo esc_attr( POST165_OPTION ); ?>[overrides][<?php echo (int) $i; ?>][cancelled]" <?php checked( ! empty( $row['cancelled'] ) ); ?> /></td>
					</tr>
				<?php endfor; ?>
				</tbody>
			</table>

			<h2><?php esc_html_e( 'Who to contact', 'post165' ); ?></h2>
			<table class="form-table" role="presentation">
				<?php
				post165_settings_field( 'contact_name', __( 'Name', 'post165' ) );
				post165_settings_field( 'contact_role', __( 'Role', 'post165' ), 'text', __( 'For example: Membership.', 'post165' ) );
				post165_settings_field( 'contact_email', __( 'Email', 'post165' ), 'email' );
				post165_settings_field( 'contact_phone', __( 'Phone', 'post165' ) );
				?>
			</table>

			<?php submit_button(); ?>
		</form>
	</div>
	<?php
}
```

In `wp-content/themes/post165/functions.php`, add near the top (after the `defined( 'ABSPATH' )` guard, before the existing setup function):

```php
require_once get_theme_file_path( 'inc/pure/format.php' );
require_once get_theme_file_path( 'inc/pure/meetings.php' );
require_once get_theme_file_path( 'inc/pure/overrides.php' );
require_once get_theme_file_path( 'inc/pure/year-map.php' );
require_once get_theme_file_path( 'inc/settings.php' );
```

Note the pure files are required **before** `settings.php`, because sanitisation uses the `POST165_ORDINALS` and `POST165_WEEKDAYS` constants defined in `meetings.php`.

- [ ] **Step 4: Run the validator to verify it passes**

```bash
npm test
```

Expected: `Theme validation passed.` and all PHP assertions pass.

- [ ] **Step 5: Verify the PHP parses**

```bash
docker run --rm -v "$PWD":/app -w /app php:8.3-cli sh -c 'for f in wp-content/themes/post165/inc/settings.php wp-content/themes/post165/functions.php wp-content/themes/post165/inc/pure/*.php; do php -l "$f" || exit 1; done'
```

Expected: `No syntax errors detected` for every file.

- [ ] **Step 6: Commit**

```bash
git add wp-content/themes/post165/inc/settings.php wp-content/themes/post165/functions.php scripts/validate-theme.mjs
git commit -m "feat: add Settings -> Post 165 for facts that go stale

Dues, member count, contact person, meeting rule and venue are editable by
any officer with manage_options, so a stale figure no longer needs a
developer and a commit. Six override rows cover single-meeting changes,
matching the six months the homepage computes.

All values default to empty so a fact nobody has supplied is omitted from
the page rather than rendered as a placeholder."
```

---

### Task 6: Event assembly and Events Calendar integration

**Files:**
- Create: `wp-content/themes/post165/inc/events.php`
- Modify: `wp-content/themes/post165/functions.php`
- Modify: `scripts/validate-theme.mjs`

**Interfaces:**
- Consumes: `post165_meeting_rule()`, `post165_meeting_overrides()` (Task 5); `post165_meeting_dates()` (Task 2); `post165_apply_meeting_overrides()` (Task 3); `post165_has_public_event_within()`, `post165_next_annual_milestone()`, `post165_default_year_map()` (Task 4).
- Produces:
  - `post165_upcoming_entries(int $limit = 5): array` — merged, sorted entry arrays.
  - `post165_year_map(): array` — the filtered map.
  - `post165_quiet_season_note(): ?array` — `['label' => string, 'month_name' => string]` or `null`. Takes no argument: it queries public events itself rather than reading the truncated display list.
  - `post165_month_timestamp(int $month, int $year): int` — a timestamp safely inside the month, built in the site's timezone. Never use `mktime()` for month names; see the docblock for why.

- [ ] **Step 1: Add the validator assertions first**

In `scripts/validate-theme.mjs`, add to `requiredFiles`:

```js
  'wp-content/themes/post165/inc/events.php',
```

Add a `requiredText` entry:

```js
  ['wp-content/themes/post165/inc/events.php', ['post165_upcoming_entries', 'post165_quiet_season_note', 'post165_year_map', 'tribe_get_events']],
```

Extend the `functions.php` entry to also require `'inc/events.php'`.

- [ ] **Step 2: Run the validator to verify it fails**

```bash
npm test
```

Expected: `Missing required file: wp-content/themes/post165/inc/events.php`.

- [ ] **Step 3: Write the implementation**

Create `wp-content/themes/post165/inc/events.php`:

```php
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
		'month_name' => wp_date( 'F', post165_month_timestamp( $milestone['month'], $milestone['year'] ) ),
	];
}

/**
 * A timestamp safely inside the given month, in the site's timezone.
 *
 * mktime() builds its timestamp in PHP's default timezone, which WordPress
 * fixes to UTC at boot. Formatting that instant with wp_date() in a
 * negative-offset site timezone rolls midnight on the 1st back into the
 * previous month, so every month name would print one month early.
 * Anchoring at midday in the site's own timezone removes both that error
 * and any daylight-saving edge.
 *
 * @param int $month 1-12.
 * @param int $year  Four-digit year.
 */
function post165_month_timestamp( int $month, int $year ): int {
	$date = new DateTimeImmutable(
		sprintf( '%04d-%02d-01 12:00:00', $year, $month ),
		wp_timezone()
	);

	return $date->getTimestamp();
}
```

Add to `functions.php` after the `inc/settings.php` require:

```php
require_once get_theme_file_path( 'inc/events.php' );
```

- [ ] **Step 4: Run the validator to verify it passes**

```bash
npm test
```

Expected: `Theme validation passed.` and all PHP assertions pass.

- [ ] **Step 5: Verify the PHP parses**

```bash
docker run --rm -v "$PWD":/app -w /app php:8.3-cli php -l wp-content/themes/post165/inc/events.php
```

Expected: `No syntax errors detected`.

- [ ] **Step 6: Commit**

```bash
git add wp-content/themes/post165/inc/events.php wp-content/themes/post165/functions.php scripts/validate-theme.mjs
git commit -m "feat: merge computed meetings with Events Calendar entries

Meetings and real TEC events are normalised to a common shape, merged and
sorted. TEC is optional at runtime: with the plugin absent or empty the
homepage still shows real dated meetings rather than an empty void.

The quiet-season note is derived from a 60-day public-event window and
names the next annual milestone, so it needs no seasonal switching."
```

---

### Task 7: The `post165/upcoming` block

**Files:**
- Create: `wp-content/themes/post165/inc/blocks.php`
- Modify: `wp-content/themes/post165/functions.php`
- Modify: `scripts/validate-theme.mjs`

**Interfaces:**
- Consumes: `post165_upcoming_entries()`, `post165_quiet_season_note()` (Task 6).
- Produces: registered block `post165/upcoming`; markup using `.post165-next`, `.post165-ev`, `.post165-ev--next`, `.post165-pill`, `.post165-quiet`. Tasks 8 and 9 add their render callbacks to this same file.

- [ ] **Step 1: Add the validator assertions first**

Add to `requiredFiles`:

```js
  'wp-content/themes/post165/inc/blocks.php',
```

Add a `requiredText` entry:

```js
  ['wp-content/themes/post165/inc/blocks.php', ['post165/upcoming', 'register_block_type', 'render_callback']],
```

Extend the `functions.php` entry to also require `'inc/blocks.php'`.

- [ ] **Step 2: Run the validator to verify it fails**

```bash
npm test
```

Expected: `Missing required file: wp-content/themes/post165/inc/blocks.php`.

- [ ] **Step 3: Write the implementation**

Create `wp-content/themes/post165/inc/blocks.php`:

```php
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
```

Add to `functions.php` after the `inc/events.php` require:

```php
require_once get_theme_file_path( 'inc/blocks.php' );
```

- [ ] **Step 4: Run the validator and the linter**

```bash
npm test && docker run --rm -v "$PWD":/app -w /app php:8.3-cli php -l wp-content/themes/post165/inc/blocks.php
```

Expected: validation passes, assertions pass, `No syntax errors detected`.

- [ ] **Step 5: Commit**

```bash
git add wp-content/themes/post165/inc/blocks.php wp-content/themes/post165/functions.php scripts/validate-theme.mjs
git commit -m "feat: add post165/upcoming dynamic block

Renders the merged dated list with the next entry highlighted, machine
readable <time> elements, and text pills so the members/public distinction
never depends on colour alone. The quiet-season note renders only when no
public event falls inside the window."
```

---

### Task 8: The `post165/year-strip` block

**Files:**
- Modify: `wp-content/themes/post165/inc/blocks.php`
- Modify: `scripts/validate-theme.mjs`

**Interfaces:**
- Consumes: `post165_year_map()` (Task 6), `post165_now()` (Task 6).
- Produces: registered block `post165/year-strip`; markup using `.post165-year`, `.post165-year__mo`, `.post165-year__mo--now`, `.post165-year__mo--has`.

- [ ] **Step 1: Add the validator assertion first**

Extend the `inc/blocks.php` `requiredText` entry to include `'post165/year-strip'`.

- [ ] **Step 2: Run the validator to verify it fails**

```bash
npm test
```

Expected: `wp-content/themes/post165/inc/blocks.php must include: post165/year-strip`.

- [ ] **Step 3: Write the implementation**

In `inc/blocks.php`, add inside `post165_register_blocks()`:

```php
	register_block_type(
		'post165/year-strip',
		[
			'api_version'     => 3,
			'render_callback' => 'post165_render_year_strip',
		]
	);
```

And append this function to the file:

```php
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
```

- [ ] **Step 4: Run the validator and linter**

```bash
npm test && docker run --rm -v "$PWD":/app -w /app php:8.3-cli php -l wp-content/themes/post165/inc/blocks.php
```

Expected: all pass.

- [ ] **Step 5: Commit**

```bash
git add wp-content/themes/post165/inc/blocks.php scripts/validate-theme.mjs
git commit -m "feat: add post165/year-strip dynamic block

Shows the post's annual rhythm with the current month marked aria-current,
and full month names exposed to assistive tech via abbr. Answers 'when is
the car show' before a date exists."
```

---

### Task 9: The `post165/join-panel` block

**Files:**
- Modify: `wp-content/themes/post165/inc/blocks.php`
- Modify: `scripts/validate-theme.mjs`

**Interfaces:**
- Consumes: `post165_fact()`, `post165_meeting_rule()` (Task 5); `post165_format_member_count()` (Task 1).
- Produces: registered block `post165/join-panel`; markup using `.post165-join`, `.post165-fact`, `.post165-join__who`.

- [ ] **Step 1: Add the validator assertion first**

Extend the `inc/blocks.php` `requiredText` entry to include `'post165/join-panel'` and `'antispambot'`.

- [ ] **Step 2: Run the validator to verify it fails**

```bash
npm test
```

Expected: missing `post165/join-panel`.

- [ ] **Step 3: Write the implementation**

In `inc/blocks.php`, add inside `post165_register_blocks()`:

```php
	register_block_type(
		'post165/join-panel',
		[
			'api_version'     => 3,
			'render_callback' => 'post165_render_join_panel',
		]
	);
```

And append:

```php
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
	$rule    = post165_meeting_rule();
	$members = post165_format_member_count( post165_fact( 'member_count', 0 ) );

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

	$rows  = post165_fact_row( __( 'Who', 'post165' ), esc_html( (string) post165_fact( 'eligibility', '' ) ) );
	$rows .= post165_fact_row( __( 'Dues', 'post165' ), esc_html( (string) post165_fact( 'dues', '' ) ) );
	$rows .= post165_fact_row( __( 'We meet', 'post165' ), $when );
	$rows .= post165_fact_row( __( 'Size', 'post165' ), null === $members ? '' : esc_html( $members . ' ' . __( 'members', 'post165' ) ) );

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
```

- [ ] **Step 4: Run the validator and linter**

```bash
npm test && docker run --rm -v "$PWD":/app -w /app php:8.3-cli php -l wp-content/themes/post165/inc/blocks.php
```

Expected: all pass.

- [ ] **Step 5: Commit**

```bash
git add wp-content/themes/post165/inc/blocks.php scripts/validate-theme.mjs
git commit -m "feat: add post165/join-panel dynamic block

Answers the on-the-fence veteran's actual questions with facts rather than
adjectives, and ends with a named human. Rows for facts nobody has supplied
are omitted entirely; the member count renders rounded."
```

---

### Task 10: Board styles

**Files:**
- Modify: `wp-content/themes/post165/style.css`
- Modify: `scripts/validate-theme.mjs`

**Interfaces:**
- Consumes: the class names produced by Tasks 7–9.
- Produces: no PHP interface. Establishes `.post165-strap`, `.post165-board` and the collapse behaviour Task 11 relies on.

- [ ] **Step 1: Add the validator assertions first**

In `scripts/validate-theme.mjs`, extend the `style.css` entry:

```js
  ['wp-content/themes/post165/style.css', ['Theme Name: Post 165', 'Text Domain: post165', 'Requires at least: 6.5', '.post165-ribbon', '.post165-seal', '.post165-strap', '.post165-board', '.post165-year', '.post165-join']],
```

Note `.post165-hero` is removed from the required list, because Task 11 deletes the hero pattern.

- [ ] **Step 2: Run the validator to verify it fails**

```bash
npm test
```

Expected: `style.css must include: .post165-strap` and the other three.

- [ ] **Step 3: Write the styles**

Append to `wp-content/themes/post165/style.css`:

```css
/* ---------------------------------------------------------------------------
   The Board — homepage answer layout
   Replaces the full-screen hero. See docs/superpowers/specs/
   2026-07-24-homepage-density-design.md
--------------------------------------------------------------------------- */

.post165-strap {
	background: var(--wp--preset--color--navy);
	color: #fff;
	border-bottom: 3px solid var(--wp--preset--color--gold);
	padding: 1.25rem clamp(1rem, 4vw, 2.25rem);
	display: flex;
	align-items: center;
	gap: 1.75rem;
	flex-wrap: wrap;
}

.post165-strap__title {
	font-family: var(--wp--preset--font-family--serif);
	font-size: clamp(1.4rem, 3vw, 1.75rem);
	font-weight: 600;
	line-height: 1.2;
	margin: 0;
}

.post165-strap__lede {
	font-size: 0.9rem;
	opacity: 0.85;
	max-width: 46ch;
	margin: 0.25rem 0 0;
}

.post165-strap__since {
	margin-left: auto;
	text-align: right;
}

.post165-strap__since b {
	font-family: var(--wp--preset--font-family--serif);
	font-size: clamp(1.6rem, 4vw, 2.1rem);
	font-weight: 600;
	color: var(--p165-gold-light);
	display: block;
	line-height: 1;
}

.post165-strap__since span {
	font-size: 0.62rem;
	letter-spacing: 0.12em;
	text-transform: uppercase;
	opacity: 0.75;
}

.post165-board {
	display: grid;
	grid-template-columns: 1fr 21rem;
	align-items: start;
}

.post165-board__main {
	background: var(--wp--preset--color--cream);
	padding: 1.5rem clamp(1rem, 4vw, 2rem) 2rem;
}

.post165-board__side {
	background: #fff;
	border-left: 1px solid #e2d9c4;
	padding: 1.5rem clamp(1rem, 3vw, 1.6rem) 2rem;
}

/* Event list ------------------------------------------------------------- */

.post165-ev-list {
	list-style: none;
	margin: 0;
	padding: 0;
}

.post165-ev {
	display: grid;
	grid-template-columns: 3.6rem 1fr;
	gap: 1rem;
	align-items: start;
	padding: 0.7rem 0;
	border-top: 1px solid #e0d6bf;
}

.post165-ev:first-child {
	border-top: 2px solid var(--wp--preset--color--navy);
}

.post165-ev--next {
	background: linear-gradient(90deg, rgba(196, 154, 58, 0.13), transparent 72%);
	padding-inline: 0.6rem;
	margin-inline: -0.6rem;
}

.post165-ev__date {
	text-align: center;
	font-family: var(--wp--preset--font-family--serif);
	display: block;
}

.post165-ev__date b {
	display: block;
	font-size: 1.55rem;
	font-weight: 600;
	line-height: 1;
	color: var(--wp--preset--color--navy);
}

.post165-ev__date span {
	font-family: var(--wp--preset--font-family--sans);
	font-size: 0.62rem;
	letter-spacing: 0.11em;
	text-transform: uppercase;
	font-weight: 700;
	color: var(--p165-gold-deep);
}

.post165-ev__title {
	font-family: var(--wp--preset--font-family--serif);
	font-size: 1.05rem;
	font-weight: 600;
	color: var(--wp--preset--color--navy);
	line-height: 1.25;
	margin: 0;
}

.post165-ev__meta {
	font-size: 0.8rem;
	color: #5b6572;
	margin: 0.15rem 0 0;
}

.post165-pill {
	display: inline-block;
	font-size: 0.6rem;
	letter-spacing: 0.09em;
	text-transform: uppercase;
	font-weight: 700;
	padding: 0.15rem 0.45rem;
	border-radius: 2px;
	vertical-align: 0.15em;
	white-space: nowrap;
}

.post165-pill--public {
	background: var(--wp--preset--color--red);
	color: #fff;
}

.post165-pill--members {
	background: #dfe4ea;
	color: #3d4652;
}

/* Quiet season ----------------------------------------------------------- */

.post165-quiet {
	margin-top: 0.9rem;
	padding: 0.8rem 0.9rem;
	background: #fff;
	border-left: 3px solid var(--wp--preset--color--gold);
	font-size: 0.85rem;
	color: #5b6572;
}

.post165-quiet p {
	margin: 0;
}

.post165-quiet__head {
	font-family: var(--wp--preset--font-family--serif);
	color: var(--wp--preset--color--navy);
	font-size: 0.98rem;
	font-weight: 600;
	margin-bottom: 0.2rem !important;
}

/* Year strip ------------------------------------------------------------- */

.post165-year {
	margin-top: 1.4rem;
	border-top: 2px solid var(--wp--preset--color--navy);
	padding-top: 0.9rem;
}

.post165-year__lede,
.post165-year__foot {
	font-size: 0.8rem;
	color: #5b6572;
	margin: 0;
}

.post165-year__foot {
	margin-top: 0.5rem;
	color: #6b7280;
}

.post165-year__grid {
	list-style: none;
	margin: 0.6rem 0 0;
	padding: 0;
	display: grid;
	grid-template-columns: repeat(12, 1fr);
}

.post165-year__mo {
	text-align: center;
	padding: 0.45rem 0.15rem 0.5rem;
	border-right: 1px solid #e0d6bf;
	min-width: 0;
}

.post165-year__mo:last-child {
	border-right: 0;
}

.post165-year__mo b {
	display: block;
	font-size: 0.62rem;
	letter-spacing: 0.05em;
	text-transform: uppercase;
	color: #8d93a0;
	font-weight: 700;
	margin-bottom: 0.3rem;
}

.post165-year__mo abbr {
	text-decoration: none;
	border: 0;
}

.post165-year__mo span {
	display: block;
	font-size: 0.6rem;
	line-height: 1.3;
	color: var(--p165-gold-deep);
	font-weight: 600;
}

.post165-year__mo--has {
	background: #fff;
}

.post165-year__mo--has b {
	color: var(--wp--preset--color--navy);
}

.post165-year__mo--now {
	background: var(--wp--preset--color--navy);
}

.post165-year__mo--now b {
	color: var(--p165-gold-light);
}

.post165-year__mo--now span {
	color: #fff;
}

/* Join panel ------------------------------------------------------------- */

.post165-join__head {
	font-family: var(--wp--preset--font-family--serif);
	font-size: 1.3rem;
	font-weight: 600;
	color: var(--wp--preset--color--navy);
	line-height: 1.2;
	margin: 0 0 0.3rem;
}

.post165-join__lede {
	font-size: 0.85rem;
	color: #5b6572;
	margin: 0 0 0.9rem;
}

.post165-facts {
	margin: 0;
}

.post165-fact {
	display: grid;
	grid-template-columns: 4.75rem 1fr;
	gap: 0.6rem;
	padding: 0.5rem 0;
	border-top: 1px solid #eae3d2;
	font-size: 0.85rem;
}

.post165-fact dt {
	font-size: 0.62rem;
	letter-spacing: 0.1em;
	text-transform: uppercase;
	color: var(--p165-gold-deep);
	font-weight: 700;
	padding-top: 0.2rem;
	margin: 0;
}

.post165-fact dd {
	margin: 0;
	color: var(--wp--preset--color--ink);
}

.post165-join__cta {
	margin: 1rem 0 0;
}

.post165-join__cta a {
	display: block;
	text-align: center;
}

.post165-join__who {
	margin-top: 0.9rem;
	padding-top: 0.85rem;
	border-top: 1px solid #eae3d2;
	font-size: 0.8rem;
	color: #5b6572;
}

.post165-join__who p {
	margin: 0;
}

.post165-join__name {
	font-family: var(--wp--preset--font-family--serif);
	font-size: 1rem;
	font-weight: 600;
	color: var(--wp--preset--color--navy);
	margin-top: 0.15rem !important;
}

.post165-join__contact a {
	color: var(--wp--preset--color--red);
}

/* Collapse: on narrow screens the "when is it?" answer comes first -------- */

@media (max-width: 52.5rem) {
	.post165-board {
		grid-template-columns: 1fr;
	}

	.post165-board__side {
		border-left: 0;
		border-top: 2px solid var(--wp--preset--color--navy);
	}

	.post165-year__grid {
		grid-template-columns: repeat(6, 1fr);
	}

	.post165-year__mo:nth-child(6) {
		border-right: 0;
	}

	.post165-strap__since {
		margin-left: 0;
		text-align: left;
	}
}
```

**Check first:** confirm `--p165-gold-light` and `--p165-gold-deep` are already defined in `style.css` from the earlier work. If either is missing, add it to the existing `:root` block (`--p165-gold-light: #d9b45b; --p165-gold-deep: #7a5a12;`) rather than duplicating a `:root` rule.

- [ ] **Step 4: Run the validator to verify it passes**

```bash
npm test
```

Expected: `Theme validation passed.`

- [ ] **Step 5: Commit**

```bash
git add wp-content/themes/post165/style.css scripts/validate-theme.mjs
git commit -m "style: add the board layout

Two-column answer board with a compact navy strap in place of the
full-screen hero. Collapses to one column below 52.5rem with the event list
first, since 'when is it?' is the more common mobile arrival."
```

---

### Task 11: Wire up the board, retire the old patterns

**Files:**
- Create: `wp-content/themes/post165/patterns/home-board.php`
- Modify: `wp-content/themes/post165/templates/front-page.html`
- Delete: `patterns/home-hero.php`, `home-events.php`, `home-membership.php`, `how-we-serve.php`, `support-post-165.php`, `contact-card.php`
- Modify: `scripts/validate-theme.mjs`

**Interfaces:**
- Consumes: the three blocks (Tasks 7–9) and the styles (Task 10).
- Produces: pattern slug `post165/home-board`.

- [ ] **Step 1: Update the validator first**

In `scripts/validate-theme.mjs`:

Remove these six entries from `requiredFiles`:

```
  'wp-content/themes/post165/patterns/home-hero.php',
  'wp-content/themes/post165/patterns/home-events.php',
  'wp-content/themes/post165/patterns/home-membership.php',
  'wp-content/themes/post165/patterns/how-we-serve.php',
  'wp-content/themes/post165/patterns/support-post-165.php',
  'wp-content/themes/post165/patterns/contact-card.php',
```

Add:

```js
  'wp-content/themes/post165/patterns/home-board.php',
```

Delete these five `requiredText` entries entirely (their files are going away): `patterns/home-hero.php`, `patterns/home-events.php`, `patterns/home-membership.php`, `patterns/how-we-serve.php`, `patterns/support-post-165.php`.

Replace the `front-page.html` entry with:

```js
  ['wp-content/themes/post165/templates/front-page.html', ['wp:pattern {"slug":"post165/home-board"']],
```

Add:

```js
  ['wp-content/themes/post165/patterns/home-board.php', ['wp:post165/upcoming', 'wp:post165/year-strip', 'wp:post165/join-panel', 'Still here. Still serving.']],
```

- [ ] **Step 2: Run the validator to verify it fails**

```bash
npm test
```

Expected: `Missing required file: wp-content/themes/post165/patterns/home-board.php`.

- [ ] **Step 3: Create the pattern**

Create `wp-content/themes/post165/patterns/home-board.php`:

```php
<?php
/**
 * Title: Home Board
 * Slug: post165/home-board
 * Categories: post165
 * Description: Compact strap plus the two-column answer board.
 *
 * @package post165
 */

$post165_charter = absint( post165_fact( 'charter_year', 0 ) );
?>
<!-- wp:group {"className":"post165-strap","layout":{"type":"default"}} -->
<div class="wp-block-group post165-strap">
	<!-- wp:html -->
	<div>
		<p class="post165-strap__title"><?php esc_html_e( 'Still here. Still serving.', 'post165' ); ?></p>
		<p class="post165-strap__lede"><?php esc_html_e( 'Veterans serving Two Rivers — ceremonies, community events, and each other.', 'post165' ); ?></p>
	</div>
	<?php if ( $post165_charter ) : ?>
	<div class="post165-strap__since">
		<b><?php echo esc_html( (string) $post165_charter ); ?></b>
		<span><?php esc_html_e( 'Chartered', 'post165' ); ?></span>
	</div>
	<?php endif; ?>
	<!-- /wp:html -->
</div>
<!-- /wp:group -->

<!-- wp:group {"className":"post165-board","layout":{"type":"default"}} -->
<div class="wp-block-group post165-board">
	<!-- wp:group {"className":"post165-board__main","layout":{"type":"default"}} -->
	<div class="wp-block-group post165-board__main">
		<!-- wp:post165/upcoming /-->
		<!-- wp:post165/year-strip /-->
	</div>
	<!-- /wp:group -->

	<!-- wp:group {"className":"post165-board__side","layout":{"type":"default"}} -->
	<div class="wp-block-group post165-board__side">
		<!-- wp:post165/join-panel /-->
	</div>
	<!-- /wp:group -->
</div>
<!-- /wp:group -->
```

- [ ] **Step 4: Rewire the front page**

Replace `wp-content/themes/post165/templates/front-page.html` entirely with:

```html
<!-- wp:template-part {"slug":"header","tagName":"header"} /-->
<!-- wp:group {"tagName":"main","layout":{"type":"default"}} -->
<main class="wp-block-group"><!-- wp:pattern {"slug":"post165/home-board"} /--></main>
<!-- /wp:group -->
<!-- wp:template-part {"slug":"footer","tagName":"footer"} /-->
```

Task 12 adds the two below-the-fold patterns to this file.

- [ ] **Step 5: Delete the retired patterns**

```bash
git rm wp-content/themes/post165/patterns/home-hero.php \
       wp-content/themes/post165/patterns/home-events.php \
       wp-content/themes/post165/patterns/home-membership.php \
       wp-content/themes/post165/patterns/how-we-serve.php \
       wp-content/themes/post165/patterns/support-post-165.php \
       wp-content/themes/post165/patterns/contact-card.php
```

- [ ] **Step 6: Rescue the Contact page's dangling reference**

`patterns/contact-page.php` references `post165/contact-card`, which Step 5 just deleted. WordPress renders an unregistered pattern slug as an empty string — no warning, no placeholder — so the Contact page starter would silently lose its meeting time, venue, mailing address, phone, email, and Facebook link. Nothing in the validator catches this.

Recover the deleted markup and inline it:

```bash
git show HEAD~1:wp-content/themes/post165/patterns/contact-card.php
```

Replace the `<!-- wp:pattern {"slug":"post165/contact-card"} /-->` line in `contact-page.php` with the recovered **block markup only** — not the recovered file's PHP docblock header, since `contact-page.php` already has one and a second would corrupt registration. Preserve every fact verbatim; these are real contact details.

Then add a guard to `scripts/validate-theme.mjs` so this class of breakage cannot recur. Scan `templates/`, `parts/`, and `patterns/` for every `wp:pattern` reference with a `post165/<slug>` slug, and assert `patterns/<slug>.php` exists, pushing to the existing `failures` array on a miss. Write the regex tolerantly — allow other JSON attributes and flexible whitespace. A too-strict regex silently matches nothing, which is precisely how this defect survived.

Verify the guard can fail: point a reference at a nonexistent slug, confirm `npm test` fails with your message, then revert.

- [ ] **Step 7: Remove the now-dead hero styles**

Deleting `home-hero.php` orphans its CSS. In `style.css`, delete the rules for `.post165-hero`, `.post165-hero::before`, `.post165-hero-watermark`, and `.post165-hero__content`, plus any `@media` overrides that target only those selectors.

Leave `.post165-eyebrow`, `.post165-ribbon`, `.post165-seal`, `.post165-strip`, `.post165-card`, `.post165-star-list`, and `.post165-page-eyebrow` alone — the interior page and 404 templates still use them.

- [ ] **Step 8: Run the validator to verify it passes**

```bash
npm test
```

Expected: `Theme validation passed.` and all PHP assertions pass. (Task 10 already removed `.post165-hero` from the validator's required strings, so deleting those rules will not fail the gate.)

- [ ] **Step 9: Rebuild the static preview and check it renders**

```bash
node scripts/preview.mjs
```

Expected: `Preview written to …/theme-preview.html`.

**Known limitation to note, not fix:** `scripts/preview.mjs` strips PHP and does not execute WordPress, so the three dynamic blocks render as empty comments in the static preview. The preview remains useful for the strap and page chrome only. Real verification of the board requires a WordPress install — record this in Task 13's docs rather than trying to teach the preview script to run PHP.

- [ ] **Step 10: Commit**

```bash
git add -A wp-content/themes/post165 scripts/validate-theme.mjs
git commit -m "feat: replace six homepage bands with the two-column board

Six identically shaped patterns become one. The full-screen hero collapses
into a ~130px strap; the category cards that announced taxonomy without
naming a single real event are deleted outright.

The static preview cannot render the dynamic blocks, since it strips PHP
and boots no WordPress. Verifying the board needs a real install."
```

---

### Task 12: Proof band and the condensed row

**Files:**
- Create: `wp-content/themes/post165/patterns/home-proof.php`
- Create: `wp-content/themes/post165/patterns/home-what-we-do.php`
- Modify: `wp-content/themes/post165/templates/front-page.html`
- Modify: `wp-content/themes/post165/style.css`
- Modify: `scripts/validate-theme.mjs`

**Interfaces:**
- Consumes: nothing from earlier tasks beyond styles.
- Produces: pattern slugs `post165/home-proof`, `post165/home-what-we-do`.

- [ ] **Step 1: Update the validator first**

Add to `requiredFiles`:

```js
  'wp-content/themes/post165/patterns/home-proof.php',
  'wp-content/themes/post165/patterns/home-what-we-do.php',
```

Add `requiredText` entries:

```js
  ['wp-content/themes/post165/patterns/home-proof.php', ['post165-proof']],
  ['wp-content/themes/post165/patterns/home-what-we-do.php', ['Veterans', 'Youth', 'Remembrance', 'Community']],
```

Extend the `front-page.html` entry to include `'wp:pattern {"slug":"post165/home-what-we-do"'`.

Extend the `style.css` entry to include `'.post165-proof'`.

- [ ] **Step 2: Run the validator to verify it fails**

```bash
npm test
```

Expected: both pattern files reported missing.

- [ ] **Step 3: Create the proof band**

Create `wp-content/themes/post165/patterns/home-proof.php`:

```php
<?php
/**
 * Title: Home Proof Band
 * Slug: post165/home-proof
 * Categories: post165
 * Description: Photographs of the post at work. Renders nothing until images are set.
 *
 * @package post165
 */

/*
 * Photographs must be supplied by the post — see spec §4.7 and §9.
 * Until then this pattern renders nothing rather than showing placeholder
 * imagery. To enable: attach images via the Site Editor, or replace the
 * figures below with real wp:image blocks and factual captions.
 */
?>
<!-- wp:group {"className":"post165-proof","layout":{"type":"constrained"}} -->
<div class="wp-block-group post165-proof">
	<!-- wp:paragraph {"className":"post165-eyebrow"} -->
	<p class="post165-eyebrow"><?php esc_html_e( 'The work', 'post165' ); ?></p>
	<!-- /wp:paragraph -->
	<!-- wp:paragraph -->
	<p><?php esc_html_e( 'Photographs of the post at work go here — honor guard, brat fry, flag placement — each with a plain caption naming what it is and when it happened.', 'post165' ); ?></p>
	<!-- /wp:paragraph -->
</div>
<!-- /wp:group -->
```

- [ ] **Step 4: Create the condensed row**

Create `wp-content/themes/post165/patterns/home-what-we-do.php`:

```php
<?php
/**
 * Title: Home What We Do
 * Slug: post165/home-what-we-do
 * Categories: post165
 * Description: The four pillars in one condensed row, plus support and contact lines.
 *
 * @package post165
 */

?>
<!-- wp:group {"className":"post165-do","style":{"spacing":{"padding":{"top":"1.75rem","bottom":"2.25rem","left":"1rem","right":"1rem"}}},"backgroundColor":"cream","layout":{"type":"constrained"}} -->
<div class="wp-block-group post165-do has-cream-background-color has-background" style="padding-top:1.75rem;padding-right:1rem;padding-bottom:2.25rem;padding-left:1rem">
	<!-- wp:paragraph {"className":"post165-eyebrow"} -->
	<p class="post165-eyebrow"><?php esc_html_e( 'The four pillars, locally', 'post165' ); ?></p>
	<!-- /wp:paragraph -->

	<!-- wp:columns -->
	<div class="wp-block-columns">
		<!-- wp:column -->
		<div class="wp-block-column">
			<!-- wp:heading {"level":3,"fontSize":"small"} -->
			<h3 class="wp-block-heading has-small-font-size"><?php esc_html_e( 'Veterans', 'post165' ); ?></h3>
			<!-- /wp:heading -->
			<!-- wp:paragraph {"fontSize":"small"} -->
			<p class="has-small-font-size"><?php esc_html_e( 'Helping veterans stay connected and find what they have earned.', 'post165' ); ?></p>
			<!-- /wp:paragraph -->
		</div>
		<!-- /wp:column -->

		<!-- wp:column -->
		<div class="wp-block-column">
			<!-- wp:heading {"level":3,"fontSize":"small"} -->
			<h3 class="wp-block-heading has-small-font-size"><?php esc_html_e( 'Youth', 'post165' ); ?></h3>
			<!-- /wp:heading -->
			<!-- wp:paragraph {"fontSize":"small"} -->
			<p class="has-small-font-size"><?php esc_html_e( 'Programs and scholarships for young people in Two Rivers.', 'post165' ); ?></p>
			<!-- /wp:paragraph -->
		</div>
		<!-- /wp:column -->

		<!-- wp:column -->
		<div class="wp-block-column">
			<!-- wp:heading {"level":3,"fontSize":"small"} -->
			<h3 class="wp-block-heading has-small-font-size"><?php esc_html_e( 'Remembrance', 'post165' ); ?></h3>
			<!-- /wp:heading -->
			<!-- wp:paragraph {"fontSize":"small"} -->
			<p class="has-small-font-size"><?php esc_html_e( 'Ceremonies and honors that keep service in public memory.', 'post165' ); ?></p>
			<!-- /wp:paragraph -->
		</div>
		<!-- /wp:column -->

		<!-- wp:column -->
		<div class="wp-block-column">
			<!-- wp:heading {"level":3,"fontSize":"small"} -->
			<h3 class="wp-block-heading has-small-font-size"><?php esc_html_e( 'Community', 'post165' ); ?></h3>
			<!-- /wp:heading -->
			<!-- wp:paragraph {"fontSize":"small"} -->
			<p class="has-small-font-size"><?php esc_html_e( 'Showing up for the events and causes that hold the city together.', 'post165' ); ?></p>
			<!-- /wp:paragraph -->
		</div>
		<!-- /wp:column -->
	</div>
	<!-- /wp:columns -->

	<!-- wp:separator {"className":"post165-ribbon"} -->
	<hr class="wp-block-separator has-alpha-channel-opacity post165-ribbon" />
	<!-- /wp:separator -->

	<!-- wp:paragraph {"fontSize":"small"} -->
	<p class="has-small-font-size"><?php
		printf(
			/* translators: 1: opening link tag, 2: closing link tag */
			esc_html__( 'The post runs on volunteers and local support. %1$sWays to support Post 165%2$s.', 'post165' ),
			'<a href="' . esc_url( home_url( '/support/' ) ) . '">',
			'</a>'
		);
	?></p>
	<!-- /wp:paragraph -->

	<!-- wp:paragraph {"fontSize":"small"} -->
	<p class="has-small-font-size"><?php
		printf(
			/* translators: 1: opening link tag, 2: closing link tag */
			esc_html__( 'Questions about the post or an event? %1$sGet in touch%2$s.', 'post165' ),
			'<a href="' . esc_url( home_url( '/contact/' ) ) . '">',
			'</a>'
		);
	?></p>
	<!-- /wp:paragraph -->
</div>
<!-- /wp:group -->
```

- [ ] **Step 5: Add the patterns to the front page**

Replace the `<main>` line in `templates/front-page.html`:

```html
<main class="wp-block-group"><!-- wp:pattern {"slug":"post165/home-board"} /--><!-- wp:pattern {"slug":"post165/home-proof"} /--><!-- wp:pattern {"slug":"post165/home-what-we-do"} /--></main>
```

- [ ] **Step 6: Add the proof band styles**

Append to `style.css`:

```css
.post165-proof {
	padding: 1.75rem 1rem 2rem;
	background: #fff;
}

.post165-proof figure {
	margin: 0;
}

.post165-proof figcaption {
	font-size: 0.78rem;
	color: #5b6572;
	margin-top: 0.35rem;
}
```

- [ ] **Step 7: Run the validator to verify it passes**

```bash
npm test
```

Expected: `Theme validation passed.` and all PHP assertions pass.

- [ ] **Step 8: Commit**

```bash
git add wp-content/themes/post165 scripts/validate-theme.mjs
git commit -m "feat: add proof band and condensed what-we-do row

The four pillars, support, and contact collapse from three full bands into
one short row. The proof band ships as a documented shell rather than
placeholder imagery, since the photographs must come from the post."
```

---

### Task 13: Documentation and final verification

**Files:**
- Modify: `docs/wordpress/setup.md`
- Modify: `docs/HANDOFF.md`
- Modify: `docs/wordpress/content-model.md`

**Interfaces:**
- Consumes: everything above.
- Produces: no code interface.

- [ ] **Step 1: Document the settings screen in `docs/wordpress/setup.md`**

Add a section:

```markdown
## Settings → Post 165

The homepage reads its facts from **Settings → Post 165** in wp-admin. Any
user with `manage_options` can update them; no developer or deploy is needed.

| Field | Notes |
| --- | --- |
| Who can join, Dues | Free text, shown verbatim. |
| Member count | Enter the **true** number. The page rounds down to the nearest 5 and adds a plus (183 → "180+"), so it stays accurate as the roster changes. Counts under 5 show exactly; 0 or blank hides the row. |
| Charter year | Shown in the strap. Blank hides it. |
| Meeting rule | Which week, which day, start time (24-hour), venue, address. **Meeting dates are calculated from this rule** — they are never entered by hand and never go stale. |
| Individual meeting changes | Six rows, each keyed by month (`2026-11`). Fill only what differs; blanks inherit from the rule. Ticking **Cancelled** leaves that month off the homepage entirely. |
| Contact | Name, role, email, phone. The email is obfuscated against scrapers on output. |

**Anything left blank is left off the page.** The site never invents a
placeholder value.

### Events

Public events come from The Events Calendar. The **monthly post meeting does
not need a calendar entry** — it is computed. If you also enter the meeting in
The Events Calendar it will appear twice; that duplicate is the signal to
delete the manual entry.

Between October and March, when no public event falls within 60 days, the
homepage automatically shows a short "quiet season" note pointing at the next
annual milestone. Nobody needs to switch this on or off.

### The year strip

The twelve-month rhythm is theme content, not calendar data, so it stays
correct when the calendar is empty. It lives in
`wp-content/themes/post165/inc/pure/year-map.php` and changing it needs a
developer. **Only the brat fry and car show are confirmed; the other months
are provisional and must be verified by an officer.**
```

- [ ] **Step 2: Update `docs/HANDOFF.md`**

Add:

```markdown
## Homepage: "The Board" (2026-07-24)

The homepage was rebuilt from six brochure bands into a two-column answer
board. See `docs/superpowers/specs/2026-07-24-homepage-density-design.md`.

- Pure, WordPress-free logic lives in `wp-content/themes/post165/inc/pure/`
  and is unit tested by `scripts/php-tests.php`.
- Run those tests with `npm run test:php`. There is no PHP on the dev machine;
  the runner falls back to the `php:8.3-cli` Docker image automatically.
- `npm test` runs the static validator **and** the PHP tests.

### What the automated tests do not cover

The validator is a static string checker and the PHP tests boot no WordPress.
Neither can verify:

- Rendering inside a real WordPress install.
- The Events Calendar integration (`post165_public_event_entries`).
- That `scripts/preview.mjs` shows the board — **it does not**. The preview
  strips PHP and cannot execute dynamic blocks, so the board renders empty
  there. Use a real install to review the homepage.

Check manually against a live site: meeting dates across a month boundary and
either side of the start time; TEC absent and TEC present-but-empty; the
October–March quiet season; each override kind; and member-count rounding at
0, 3, 5, 183, 200.
```

- [ ] **Step 3: Note the ownership boundary in `docs/wordpress/content-model.md`**

Add:

```markdown
### Homepage facts

Dues, member count, charter year, meeting rule, venue, and the contact person
are **owned by WordPress**, stored in the `post165_facts` option and edited at
Settings → Post 165. They are not in Git and a deploy will not overwrite them.

The twelve-month year map is **owned by Git**, in
`inc/pure/year-map.php`, because it is editorial content that changes at most
once a year.
```

- [ ] **Step 4: Run the full gate**

```bash
npm test
```

Expected: `Theme validation passed.` followed by all PHP assertions passing.

- [ ] **Step 5: Verify every PHP file parses**

```bash
docker run --rm -v "$PWD":/app -w /app php:8.3-cli sh -c 'find wp-content/themes/post165 -name "*.php" -print0 | xargs -0 -n1 php -l' | grep -v "No syntax errors" || echo "all files parse cleanly"
```

Expected: `all files parse cleanly`.

- [ ] **Step 6: Commit**

```bash
git add docs/
git commit -m "docs: document the settings screen and what tests cannot cover

Records that meeting dates are computed rather than entered, that blank
facts are omitted rather than guessed, and that neither the static
validator nor the PHP unit tests can verify WordPress rendering, the
Events Calendar integration, or the static preview — which cannot show the
dynamic blocks at all."
```

---

## Verification checklist before merge

Automated (`npm test`) covers the pure logic and file/string presence only. Before this ships, confirm on a real WordPress install:

- [ ] Homepage fits within roughly two viewports at 1440×900.
- [ ] Both questions — "when is it?" and "should I join?" — are answerable without scrolling.
- [ ] Meeting dates are correct across a month boundary, and either side of the start time on meeting day.
- [ ] With The Events Calendar deactivated, the page still renders meetings.
- [ ] With The Events Calendar active but empty, the page still renders meetings.
- [ ] In the October–March window the quiet-season note appears and names the right milestone.
- [ ] Each override kind works: moved date, changed time, changed venue, cancelled.
- [ ] A cancelled month vanishes; a past-month override row is ignored.
- [ ] Member count renders correctly at 0, 3, 5, 183, 200.
- [ ] Blank facts omit their rows rather than rendering empty ones.
- [ ] At 375px wide the event list precedes the join panel.
- [ ] Keyboard focus order is sensible and all focus rings are visible.
- [ ] The six items in spec §9 have been supplied by the post, or their absence is a conscious launch decision.
