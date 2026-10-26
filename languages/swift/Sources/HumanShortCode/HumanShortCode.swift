/// Error raised for an invalid config, id or code.
public struct HumanShortCodeError: Error, CustomStringConvertible {
    public let message: String
    public var description: String { message }
}

/// Human Short Code implementation of spec/SPEC.md.
public enum HumanShortCode {
    public static let defaultAlphabet = "ASDEIUNWRQXBOKH"
    public static let defaultLength = 8
    static let limit: Int64 = 1 << 53  // N^length must not exceed this

    /// Returns the upper-cased alphabet and N^length, or throws on a bad config.
    static func check(_ alphabet: String, _ length: Int) throws -> ([Character], Int64) {
        let chars = Array(alphabet.uppercased())
        guard chars.count >= 2, Set(chars).count == chars.count, length >= 1 else {
            throw HumanShortCodeError(message: "human-short-code: alphabet needs 2+ unique characters and length 1+")
        }
        let n = Int64(chars.count)
        var total: Int64 = 1
        for _ in 0..<length {
            if total > limit / n { throw HumanShortCodeError(message: "human-short-code: alphabet and length exceed the safe integer range") }
            total *= n
        }
        return (chars, total)
    }

    /// Encodes a non-negative id as a code such as `QRQW-ISAA`.
    public static func encode(_ id: Int64, alphabet: String = defaultAlphabet, length: Int = defaultLength) throws -> String {
        let (chars, total) = try check(alphabet, length)
        guard id >= 0, id < total else { throw HumanShortCodeError(message: "human-short-code: id out of range") }
        var rest = id
        var digits = [Character]()
        for _ in 0..<length {
            digits.append(chars[Int(rest % Int64(chars.count))])
            rest /= Int64(chars.count)
        }
        let half = length / 2
        return String(digits[..<half]) + (half > 0 ? "-" : "") + String(digits[half...])
    }

    /// True when the code has exactly `length` characters, all in the alphabet.
    public static func verify(_ code: String, alphabet: String = defaultAlphabet, length: Int = defaultLength) throws -> Bool {
        let (chars, _) = try check(alphabet, length)
        let clean = Array(code.uppercased()).filter { $0 != "-" }
        return clean.count == length && clean.allSatisfy(chars.contains)
    }

    /// Decodes a code back to its id; throws when the code is invalid.
    public static func decode(_ code: String, alphabet: String = defaultAlphabet, length: Int = defaultLength) throws -> Int64 {
        guard try verify(code, alphabet: alphabet, length: length) else { throw HumanShortCodeError(message: "human-short-code: invalid code") }
        let chars = Array(alphabet.uppercased())
        var id: Int64 = 0
        for c in Array(code.uppercased()).filter({ $0 != "-" }).reversed() {
            id = id * Int64(chars.count) + Int64(chars.firstIndex(of: c)!)
        }
        return id
    }
}
