const hsc = require("../src/index");

describe("human-short-code", () => {
  test("encode and decode should be reversible", () => {
    const numbersToTest = [0, 1, 12345, 987654321];

    numbersToTest.forEach((num) => {
      const code = hsc.encode(num);
      const decoded = hsc.decode(code);
      expect(decoded).toBe(num);
    });
  });

  test("verify should return true for valid codes", () => {
    const code = hsc.encode(123456);
    expect(hsc.verify(code)).toBe(true);
  });

  test("verify should return false for invalid codes", () => {
    expect(hsc.verify("INVALID-CODE")).toBe(false);
    expect(() => hsc.decode("INVALID-CODE")).toThrow();
  });
});
