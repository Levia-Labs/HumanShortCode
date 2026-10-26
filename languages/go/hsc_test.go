package hsc

import (
	"os"
	"strconv"
	"strings"
	"testing"
)

func TestVectors(t *testing.T) {
	raw, err := os.ReadFile("../../spec/vectors.tsv")
	if err != nil {
		t.Fatal(err)
	}
	for n, line := range strings.Split(strings.ReplaceAll(string(raw), "\r\n", "\n"), "\n") {
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		f := strings.Split(line, "\t")
		op, in, alpha, expected := f[0], f[1], f[2], f[4]
		if alpha == "-" {
			alpha = DefaultAlphabet
		}
		length := DefaultLength
		if f[3] != "-" {
			length, _ = strconv.Atoi(f[3])
		}
		var got string
		switch op {
		case "encode":
			id, perr := strconv.ParseInt(in, 10, 64)
			if perr != nil {
				t.Fatalf("line %d: %v", n+1, perr)
			}
			got, err = Encode(id, alpha, length)
		case "decode":
			var id int64
			id, err = Decode(in, alpha, length)
			got = strconv.FormatInt(id, 10)
		case "verify":
			var ok bool
			ok, err = Verify(in, alpha, length)
			got = strconv.FormatBool(ok)
		}
		if expected == "!error" {
			if err == nil || !strings.HasPrefix(err.Error(), "human-short-code:") {
				t.Errorf("line %d: want prefixed error, got %q, %v", n+1, got, err)
			}
		} else if err != nil || got != expected {
			t.Errorf("line %d: %s %q = %q, %v; want %q", n+1, op, in, got, err, expected)
		}
	}
}
