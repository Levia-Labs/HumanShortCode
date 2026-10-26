// Package hsc encodes integer ids as short, human-friendly codes such as QRQW-ISAA.
package hsc

import (
	"errors"
	"strings"
)

const (
	// DefaultAlphabet is the alphabet used when none is given.
	DefaultAlphabet = "ASDEIUNWRQXBOKH"
	// DefaultLength is the number of code characters used when none is given.
	DefaultLength = 8
)

// space validates the config and returns the upper-cased alphabet and N^length.
func space(alphabet string, length int) ([]rune, int64, error) {
	a := []rune(strings.ToUpper(alphabet))
	seen := map[rune]bool{}
	for _, c := range a {
		seen[c] = true
	}
	if len(a) < 2 || len(seen) != len(a) || length < 1 {
		return nil, 0, errors.New("human-short-code: alphabet needs 2+ unique characters and length 1+")
	}
	n, total := int64(len(a)), int64(1)
	for i := 0; i < length; i++ {
		if total > (int64(1)<<53)/n { // total*n would exceed 2^53, so N^length - 1 > 2^53 - 1
			return nil, 0, errors.New("human-short-code: alphabet and length exceed the safe integer range")
		}
		total *= n
	}
	return a, total, nil
}

// Encode writes id as a code such as QRQW-ISAA.
func Encode(id int64, alphabet string, length int) (string, error) {
	a, total, err := space(alphabet, length)
	if err != nil {
		return "", err
	}
	if id < 0 || id >= total {
		return "", errors.New("human-short-code: id out of range")
	}
	digits := make([]rune, length)
	for i := range digits {
		digits[i] = a[id%int64(len(a))]
		id /= int64(len(a))
	}
	half := length / 2
	if half == 0 {
		return string(digits), nil
	}
	return string(digits[:half]) + "-" + string(digits[half:]), nil
}

// Verify reports whether code has exactly length characters, all in the alphabet.
func Verify(code, alphabet string, length int) (bool, error) {
	a, _, err := space(alphabet, length)
	if err != nil {
		return false, err
	}
	clean := []rune(strings.ToUpper(strings.ReplaceAll(code, "-", "")))
	if len(clean) != length {
		return false, nil
	}
	for _, c := range clean {
		if !strings.ContainsRune(string(a), c) {
			return false, nil
		}
	}
	return true, nil
}

// Decode turns a code back into its id; it errors when the code is invalid.
func Decode(code, alphabet string, length int) (int64, error) {
	if ok, err := Verify(code, alphabet, length); err != nil || !ok {
		if err == nil {
			err = errors.New("human-short-code: invalid code")
		}
		return 0, err
	}
	a, _, _ := space(alphabet, length)
	var id, scale int64 = 0, 1
	for _, c := range strings.ToUpper(strings.ReplaceAll(code, "-", "")) {
		id += int64(strings.IndexRune(string(a), c)) * scale
		scale *= int64(len(a))
	}
	return id, nil
}
