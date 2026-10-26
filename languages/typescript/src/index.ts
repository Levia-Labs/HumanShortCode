export const ID_CODE_ALPHABET = "ASDEIUNWRQXBOKH";
export const ID_CODE_LENGTH = 8;

const fail = (E: ErrorConstructor, text: string): never => {
  throw new E(`human-short-code: ${text}`);
};

/** Validate the config and return the upper-cased alphabet and the code count N^length. */
const check = (alphabet: string, length: number): [string, number] => {
  const a = alphabet.toUpperCase();
  if (a.length < 2 || new Set(a).size !== a.length || !Number.isInteger(length) || length < 1) {
    fail(RangeError, "alphabet needs 2+ unique characters and length 1+");
  }
  let size = 1;
  for (let i = 0; i < length; i++) {
    size *= a.length;
    if (!Number.isSafeInteger(size - 1)) fail(RangeError, "alphabet and length exceed the safe integer range");
  }
  return [a, size];
};

/** Encode a non-negative integer as a code such as `QRQW-ISAA`. */
export const encode = (id: number, alphabet = ID_CODE_ALPHABET, length = ID_CODE_LENGTH): string => {
  const [a, size] = check(alphabet, length);
  if (!Number.isInteger(id)) fail(TypeError, "id must be an integer");
  if (id < 0 || id >= size) fail(RangeError, "id out of range");
  let letters = "";
  for (let n = id, i = 0; i < length; i++, n = Math.floor(n / a.length)) letters += a[n % a.length];
  const half = Math.floor(length / 2);
  return half ? `${letters.slice(0, half)}-${letters.slice(half)}` : letters;
};

/** True when the code has exactly `length` characters, all in the alphabet, ignoring hyphens and case. */
export const verify = (code: string, alphabet = ID_CODE_ALPHABET, length = ID_CODE_LENGTH): boolean => {
  const [a] = check(alphabet, length);
  const clean = code.replace(/-/g, "").toUpperCase();
  return clean.length === length && [...clean].every((c) => a.includes(c));
};

/** Decode a code back to its integer id; throws when `verify` is false. */
export const decode = (code: string, alphabet = ID_CODE_ALPHABET, length = ID_CODE_LENGTH): number => {
  if (!verify(code, alphabet, length)) fail(Error, `invalid code: ${code}`);
  const a = alphabet.toUpperCase();
  let id = 0;
  [...code.replace(/-/g, "").toUpperCase()].forEach((c, i) => (id += a.indexOf(c) * a.length ** i));
  return id;
};

export const hsc = { encode, decode, verify };
