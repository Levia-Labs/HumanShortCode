// Package hsc encodes integer ids as short, human-friendly codes such as QRQW-ISAA.
package hsc

import (
	"cmp"
	"errors"
	"math"
	"slices"
	"strings"
)

const DefaultAlphabet, DefaultLength = "ASDEIUNWRQXBOKH", 8

func fail(msg string) error { return errors.New("human-short-code: " + msg) }

// check validates the config and returns the upper-cased alphabet and N^length.
func check(alphabet string, length int) ([]rune, int64, error) {
	a := []rune(strings.ToUpper(alphabet))
	total := math.Pow(float64(len(a)), float64(length))
	if len(a) < 2 || len(slices.Compact(slices.Sorted(slices.Values(a)))) != len(a) || length < 1 {
		return nil, 0, fail("alphabet needs 2+ unique characters and length 1+")
	} else if total > 1<<53 {
		return nil, 0, fail("alphabet and length exceed the safe integer range")
	}
	return a, int64(total), nil
}

// Encode writes id as a code such as QRQW-ISAA.
func Encode(id int64, alphabet string, length int) (string, error) {
	a, total, err := check(alphabet, length)
	if err != nil || id < 0 || id >= total {
		return "", cmp.Or(err, fail("id out of range"))
	}
	digits := make([]rune, length)
	for i := range digits {
		digits[i], id = a[id%int64(len(a))], id/int64(len(a))
	}
	if length > 1 {
		digits = slices.Insert(digits, length/2, '-')
	}
	return string(digits), nil
}

// Verify reports whether code has exactly length characters, all in the alphabet.
func Verify(code, alphabet string, length int) (bool, error) {
	a, _, err := check(alphabet, length)
	clean := []rune(strings.ToUpper(strings.ReplaceAll(code, "-", "")))
	ok := err == nil && len(clean) == length
	for _, c := range clean {
		ok = ok && slices.Contains(a, c)
	}
	return ok, err
}

// Decode turns a code back into its id; it errors when the code is invalid.
func Decode(code, alphabet string, length int) (id int64, err error) {
	if ok, err := Verify(code, alphabet, length); err != nil || !ok {
		return 0, cmp.Or(err, fail("invalid code"))
	}
	a, clean := []rune(strings.ToUpper(alphabet)), []rune(strings.ToUpper(strings.ReplaceAll(code, "-", "")))
	for i := len(clean) - 1; i >= 0; i-- {
		id = id*int64(len(a)) + int64(slices.Index(a, clean[i]))
	}
	return id, nil
}
