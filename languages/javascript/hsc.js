// Human Short Code: copy this file into any project or browser console. See spec/SPEC.md.
const ID_CODE_ALPHABET = "ASDEIUNWRQXBOKH";
const ID_CODE_LENGTH = 8;

/** @param {string} alphabet @param {number} length @returns {[string, number]} upper-cased alphabet and N^length */
function check(alphabet, length) {
  const a = alphabet.toUpperCase();
  if (a.length < 2 || new Set(a).size !== a.length || !Number.isInteger(length) || length < 1) {
    throw new RangeError("human-short-code: alphabet needs 2+ unique characters and length 1+");
  }
  let size = 1;
  for (let i = 0; i < length; i++) {
    size *= a.length;
    if (!Number.isSafeInteger(size - 1)) throw new RangeError("human-short-code: config exceeds the safe integer range");
  }
  return [a, size];
}

/** @param {number} id @param {string} [alphabet] @param {number} [length] @returns {string} */
function encode(id, alphabet = ID_CODE_ALPHABET, length = ID_CODE_LENGTH) {
  const [a, size] = check(alphabet, length);
  if (!Number.isInteger(id)) throw new TypeError("human-short-code: id must be an integer");
  if (id < 0 || id >= size) throw new RangeError("human-short-code: id out of range");
  let s = "";
  for (let n = id, i = 0; i < length; i++, n = Math.floor(n / a.length)) s += a[n % a.length];
  const half = Math.floor(length / 2);
  return half ? `${s.slice(0, half)}-${s.slice(half)}` : s;
}

/** @param {string} code @param {string} [alphabet] @param {number} [length] @returns {boolean} */
function verify(code, alphabet = ID_CODE_ALPHABET, length = ID_CODE_LENGTH) {
  const [a] = check(alphabet, length);
  const clean = code.replace(/-/g, "").toUpperCase();
  return clean.length === length && [...clean].every((c) => a.includes(c));
}

/** @param {string} code @param {string} [alphabet] @param {number} [length] @returns {number} */
function decode(code, alphabet = ID_CODE_ALPHABET, length = ID_CODE_LENGTH) {
  if (!verify(code, alphabet, length)) throw new Error(`human-short-code: invalid code: ${code}`);
  const a = alphabet.toUpperCase();
  return [...code.replace(/-/g, "").toUpperCase()].reduce((id, c, i) => id + a.indexOf(c) * a.length ** i, 0);
}

if (typeof module !== "undefined") module.exports = { encode, decode, verify, ID_CODE_ALPHABET, ID_CODE_LENGTH };
