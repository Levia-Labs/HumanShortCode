<?php
declare(strict_types=1);
namespace LeviaLabs\HumanShortCode;
use InvalidArgumentException as Bad;
/** Human Short Code: implementation of spec/SPEC.md. */
final class HumanShortCode
{
    public const DEFAULT_ALPHABET = 'ASDEIUNWRQXBOKH';
    public const DEFAULT_LENGTH = 8;
    private const MAX = 9007199254740991;

    /** Validate the config and return the upper-cased alphabet. */
    private static function config(string $a, int $length): string
    {
        $a = strtoupper($a);
        if (($n = strlen($a)) < 2 || $length < 1 || count(array_unique(str_split($a))) !== $n) {
            throw new Bad('human-short-code: alphabet needs 2+ unique characters and length 1+');
        }
        for ($i = 0, $total = 1; $i < $length && $total - 1 <= self::MAX; $i++) {
            $total *= $n;
        }
        return $total - 1 > self::MAX ? throw new Bad('human-short-code: alphabet and length exceed the safe integer range') : $a;
    }

    /** Encode a non-negative integer as a code such as QRQW-ISAA. */
    public static function encode(int $id, string $alphabet = self::DEFAULT_ALPHABET, int $length = self::DEFAULT_LENGTH): string
    {
        $a = self::config($alphabet, $length);
        $n = strlen($a);
        if ($id < 0 || $id >= $n ** $length) {
            throw new Bad('human-short-code: id out of range');
        }
        for ($i = 0, $digits = ''; $i < $length; $i++, $id = intdiv($id, $n)) {
            $digits .= $a[$id % $n];
        }
        $half = intdiv($length, 2);
        return substr($digits, 0, $half) . ($half > 0 ? '-' : '') . substr($digits, $half);
    }

    /** True when the code has exactly $length characters, all in the alphabet. */
    public static function verify(string $code, string $alphabet = self::DEFAULT_ALPHABET, int $length = self::DEFAULT_LENGTH): bool
    {
        $a = self::config($alphabet, $length);
        $clean = strtoupper(str_replace('-', '', $code));
        return strlen($clean) === $length && strspn($clean, $a) === $length;
    }

    /** Decode a code back to its integer id; throws when invalid. */
    public static function decode(string $code, string $alphabet = self::DEFAULT_ALPHABET, int $length = self::DEFAULT_LENGTH): int
    {
        if (!self::verify($code, $alphabet, $length)) {
            throw new Bad('human-short-code: invalid code');
        }
        $a = strtoupper($alphabet);
        for ($i = $length - 1, $id = 0, $c = strtoupper(str_replace('-', '', $code)); $i >= 0; $i--) {
            $id = $id * strlen($a) + strpos($a, $c[$i]);
        }
        return $id;
    }
}
