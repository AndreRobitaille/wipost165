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
