<?php

declare(strict_types=1);

require __DIR__ . '/../src/HumanShortCode.php';

use LeviaLabs\HumanShortCode\HumanShortCode as H;

$lines = preg_split('/\r?\n/', (string) file_get_contents(__DIR__ . '/../../../spec/vectors.tsv'));
$failures = 0;
$count = 0;
foreach ($lines as $n => $line) {
    if ($line === '' || $line[0] === '#') {
        continue;
    }
    [$op, $in, $alpha, $len, $expected] = explode("\t", $line);
    $alpha = $alpha === '-' ? H::DEFAULT_ALPHABET : $alpha;
    $len = $len === '-' ? H::DEFAULT_LENGTH : (int) $len;
    $count++;
    try {
        $got = match ($op) {
            'encode' => H::encode((int) $in, $alpha, $len),
            'decode' => (string) H::decode($in, $alpha, $len),
            'verify' => H::verify($in, $alpha, $len) ? 'true' : 'false',
        };
    } catch (InvalidArgumentException) {
        $got = '!error';
    }
    if ($got !== $expected) {
        $failures++;
        fwrite(STDERR, 'line ' . ($n + 1) . ": $op '$in' expected '$expected' got '$got'\n");
    }
}
echo "$count vectors, $failures failures\n";
exit($failures === 0 ? 0 : 1);
