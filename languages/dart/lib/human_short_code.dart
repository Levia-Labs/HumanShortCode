/// Human Short Code implementation of spec/SPEC.md.
library human_short_code;

const defaultAlphabet = 'ASDEIUNWRQXBOKH';
const defaultLength = 8;
const _limit = 1 << 53; // N^length must not exceed this

/// Returns the upper-cased alphabet and N^length, or throws on a bad config.
(String, int) _check(String alphabet, int length) {
  final a = alphabet.toUpperCase();
  if (a.runes.length < 2 || a.runes.toSet().length != a.runes.length || length < 1) {
    throw ArgumentError('human-short-code: alphabet needs 2+ unique characters and length 1+');
  }
  final n = a.runes.length;
  var total = 1;
  for (var i = 0; i < length; i++) {
    if (total > _limit ~/ n) {
      throw ArgumentError('human-short-code: alphabet and length exceed the safe integer range');
    }
    total *= n;
  }
  return (a, total);
}

/// Encodes a non-negative [id] as a code such as `QRQW-ISAA`.
String encode(int id, {String alphabet = defaultAlphabet, int length = defaultLength}) {
  final (a, total) = _check(alphabet, length);
  if (id < 0 || id >= total) throw ArgumentError('human-short-code: id out of range');
  final chars = a.runes.map(String.fromCharCode).toList();
  final digits = <String>[];
  for (var rest = id, i = 0; i < length; i++, rest ~/= chars.length) {
    digits.add(chars[rest % chars.length]);
  }
  final half = length ~/ 2;
  return digits.sublist(0, half).join() + (half > 0 ? '-' : '') + digits.sublist(half).join();
}

/// True when [code] has exactly [length] characters, all in the alphabet.
bool verify(String code, {String alphabet = defaultAlphabet, int length = defaultLength}) {
  final (a, _) = _check(alphabet, length);
  final clean = code.toUpperCase().replaceAll('-', '').runes.map(String.fromCharCode).toList();
  final chars = a.runes.map(String.fromCharCode).toSet();
  return clean.length == length && clean.every(chars.contains);
}

/// Decodes a code back to its id; throws [ArgumentError] when invalid.
int decode(String code, {String alphabet = defaultAlphabet, int length = defaultLength}) {
  if (!verify(code, alphabet: alphabet, length: length)) throw ArgumentError('human-short-code: invalid code');
  final chars = alphabet.toUpperCase().runes.map(String.fromCharCode).toList();
  var id = 0;
  for (final c in code.toUpperCase().replaceAll('-', '').runes.map(String.fromCharCode).toList().reversed) {
    id = id * chars.length + chars.indexOf(c);
  }
  return id;
}
