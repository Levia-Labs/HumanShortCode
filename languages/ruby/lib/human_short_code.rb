# frozen_string_literal: true

# Human Short Code: implementation of spec/SPEC.md.
module HumanShortCode
  ALPHABET = 'ASDEIUNWRQXBOKH'
  LENGTH = 8
  MAX = (2**53) - 1

  module_function

  # Return the upper-cased alphabet, raising ArgumentError on a bad config.
  def config(alphabet, length)
    alphabet = alphabet.upcase
    unless alphabet.length >= 2 && alphabet.chars.uniq.length == alphabet.length && length >= 1
      raise ArgumentError, 'human-short-code: alphabet needs 2+ unique characters and length 1+'
    end
    size = 1
    length.times { break if (size *= alphabet.length) > MAX + 1 }
    raise ArgumentError, 'human-short-code: alphabet and length exceed the safe integer range' if size > MAX + 1

    alphabet
  end

  # Encode a non-negative integer as a code such as QRQW-ISAA.
  def encode(id, alphabet: ALPHABET, length: LENGTH)
    alphabet = config(alphabet, length)
    raise ArgumentError, 'human-short-code: id must be an integer' unless id.is_a?(Integer)
    raise ArgumentError, 'human-short-code: id out of range' unless id >= 0 && id < alphabet.length**length

    digits = Array.new(length) do
      id, digit = id.divmod(alphabet.length)
      alphabet[digit]
    end.join
    half = length / 2
    digits[0, half] + (half.positive? ? '-' : '') + digits[half..]
  end

  # True when the code has exactly +length+ characters, all in the alphabet.
  def verify(code, alphabet: ALPHABET, length: LENGTH)
    alphabet = config(alphabet, length)
    clean = code.delete('-').upcase
    clean.length == length && clean.chars.all? { |c| alphabet.include?(c) }
  end

  # Decode a code back to its integer id; raises ArgumentError when invalid.
  def decode(code, alphabet: ALPHABET, length: LENGTH)
    raise ArgumentError, 'human-short-code: invalid code' unless verify(code, alphabet: alphabet, length: length)

    alphabet = alphabet.upcase
    code.delete('-').upcase.reverse.chars.reduce(0) { |id, c| (id * alphabet.length) + alphabet.index(c) }
  end
end
