export const ID_CODE_ALPHABET = "ASDEIUNWRQXBOKH";
export const ID_CODE_LENGTH = 8;

/**
 * encode number into human short code
 * @param idNumber number to encode
 * @param alphabet string of characters number would be cast into.
 * First characters should be the most accessible for users, specially on smartphones.
 * Initial alphabet starts with most commonly accessed letters.
 * @param length how many alphabet characters should the short code contain.
 * It DOES NOT count underscore in the middle!
 * @returns human short code
 */
export const encode = (
  idNumber: number,
  alphabet: string = ID_CODE_ALPHABET,
  length: number = ID_CODE_LENGTH
): string => {
  const codeBase = alphabet.length;
  const indices: number[] = [];

  // Generate indices using base conversion
  let num = idNumber;
  while (num > 0) {
    indices.push(num % codeBase);
    num = Math.floor(num / codeBase);
  }

  // Pad with zeros if necessary
  while (indices.length < length) {
    indices.push(0);
  }

  // Convert indices to corresponding letters in the alphabet
  const letters = indices
    .slice(0, length)
    .map((i) => alphabet[i])
    .join("");

  // Insert hyphen in the middle
  const half = Math.floor(length / 2);
  return letters.slice(0, half) + "-" + letters.slice(half);
};

/**
 * decode human short code into number, using provided alphabet.
 * It has to be the same alphabet in order to receive the same number!
 * @param idString short code to decode
 * @param alphabet alphabet used in encoding of idString
 * @param length how many characters is short code supposed to be, excluding underscore in the middle
 * @returns
 */
export const decode = (
  idString: string,
  alphabet: string = ID_CODE_ALPHABET,
  length: number = ID_CODE_LENGTH
): number => {
  if (!verify(idString, alphabet, length)) {
    throw Error(`invalid idString: ${idString}`);
  }

  const codeBase = alphabet.length;

  // Remove hyphen, ensure uppercase, and pad to length if necessary
  let cleanString = idString.replace("-", "").toUpperCase();
  cleanString = cleanString.padEnd(length, alphabet[0]);

  // Convert the string back to a number
  let number = 0;
  for (let i = 0; i < cleanString.length; i++) {
    number += alphabet.indexOf(cleanString[i]!) * Math.pow(codeBase, i);
  }

  return number;
};

/**
 * check whether string is valid code
 * @param code
 * @param alphabet
 * @param length
 * @returns
 */
export const verify = (
  code: string,
  alphabet: string = ID_CODE_ALPHABET,
  length: number = ID_CODE_LENGTH
): boolean => {
  const cleanedCode = code.replace("-", "").toUpperCase();
  return (
    cleanedCode.length <= length &&
    [...cleanedCode].every((char) => alphabet.includes(char))
  );
};

export const hsc = {
  encode,
  decode,
  verify,
};
