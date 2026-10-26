const fs = require("fs");
const path = require("path");
const hsc = require("../src/index");

const file = path.resolve(__dirname, "..", "..", "..", "spec", "vectors.tsv");
const rows = fs
  .readFileSync(file, "utf8")
  .split("\n")
  .filter((line) => line !== "" && !line.startsWith("#"))
  .map((line) => line.split("\t"));

describe("spec/vectors.tsv", () => {
  test.each(rows)("%s %j %j %j -> %s", (op, input, alphabet, length, expected) => {
    const args = [op === "encode" ? Number(input) : input];
    if (alphabet !== "-" || length !== "-") {
      args.push(alphabet === "-" ? undefined : alphabet, length === "-" ? undefined : Number(length));
    }
    const call = () => hsc[op](...args);
    if (expected === "!error") {
      expect(call).toThrow(/^human-short-code:/);
    } else if (op === "verify") {
      expect(call()).toBe(expected === "true");
    } else {
      expect(call()).toBe(op === "decode" ? Number(expected) : expected);
    }
  });

  test("encode rejects non-integers", () => {
    expect(() => hsc.encode(1.5)).toThrow(TypeError);
    expect(() => hsc.encode("1")).toThrow(/^human-short-code:/);
  });
});

test("non-integer length is rejected", () => {
  expect(() => hsc.verify("AB", undefined, 2.5)).toThrow(/^human-short-code:/);
});
