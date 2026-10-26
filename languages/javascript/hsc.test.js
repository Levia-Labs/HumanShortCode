const test = require("node:test");
const assert = require("node:assert");
const fs = require("node:fs");
const path = require("node:path");
const hsc = require("./hsc.js");

const file = path.resolve(__dirname, "..", "..", "spec", "vectors.tsv");
const rows = fs
  .readFileSync(file, "utf8")
  .split("\n")
  .filter((line) => line !== "" && !line.startsWith("#"))
  .map((line) => line.split("\t"));

for (const [op, input, alphabet, length, expected] of rows) {
  test(`${op} ${JSON.stringify(input)} ${alphabet} ${length} -> ${expected}`, () => {
    const args = [op === "encode" ? Number(input) : input];
    args.push(alphabet === "-" ? undefined : alphabet, length === "-" ? undefined : Number(length));
    const call = () => hsc[op](...args);
    if (expected === "!error") assert.throws(call, /^\w*Error: human-short-code:/);
    else if (op === "verify") assert.strictEqual(call(), expected === "true");
    else assert.strictEqual(call(), op === "decode" ? Number(expected) : expected);
  });
}

test("non-integer length is rejected", () => {
  assert.throws(() => hsc.verify("AB", undefined, 2.5), /^RangeError: human-short-code:/);
});
