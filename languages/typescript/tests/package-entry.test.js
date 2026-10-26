const path = require("path");
const fc = require("fast-check");
const pkg = require("../package.json");

const entry = require(path.resolve(__dirname, "..", pkg.main));

describe("package entry (resolved from package.json main)", () => {
  test("main points at built output", () => {
    expect(pkg.main).toBe("dist/index.js");
    expect(pkg.types).toBe("dist/index.d.ts");
  });

  test("exposes hsc API", () => {
    const hsc = entry;
    expect(typeof hsc.encode).toBe("function");
    expect(typeof hsc.decode).toBe("function");
    expect(typeof hsc.verify).toBe("function");
    expect(hsc.ID_CODE_LENGTH).toBe(8);
    const code = hsc.encode(42);
    expect(hsc.verify(code)).toBe(true);
    expect(hsc.decode(code)).toBe(42);
  });

  test("property: decode(encode(n)) === n and verify(encode(n))", () => {
    const max = Math.pow(entry.ID_CODE_ALPHABET.length, entry.ID_CODE_LENGTH) - 1;
    fc.assert(
      fc.property(fc.integer({ min: 0, max: Math.min(max, Number.MAX_SAFE_INTEGER) }), (n) => {
        const code = entry.encode(n);
        return entry.verify(code) && entry.decode(code) === n;
      })
    );
  });
});
