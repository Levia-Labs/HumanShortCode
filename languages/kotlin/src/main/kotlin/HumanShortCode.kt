/** Encodes integer ids as short, human-friendly codes such as `QRQW-ISAA`. */
object HumanShortCode {
    const val DEFAULT_ALPHABET = "ASDEIUNWRQXBOKH"
    const val DEFAULT_LENGTH = 8

    /** Validates the config and returns N^length. */
    private fun space(a: String, length: Int): Long {
        val n = a.length.toLong()
        require(n >= 2 && length >= 1 && a.toSet().size.toLong() == n) {
            "human-short-code: alphabet needs 2+ unique characters and length 1+"
        }
        var total = 1L
        repeat(length) {
            require(total <= (1L shl 53) / n) { "human-short-code: alphabet and length exceed the safe integer range" }
            total *= n
        }
        return total
    }

    private fun clean(code: String) = code.replace("-", "").uppercase()

    /** Writes [id] as a code. */
    fun encode(id: Long, alphabet: String = DEFAULT_ALPHABET, length: Int = DEFAULT_LENGTH): String {
        val a = alphabet.uppercase()
        require(id >= 0 && id < space(a, length)) { "human-short-code: id out of range" }
        var rest = id
        val digits = (0 until length).map { a[(rest % a.length).toInt()].also { rest /= a.length } }
        val half = length / 2
        return digits.take(half).joinToString("") + (if (half > 0) "-" else "") + digits.drop(half).joinToString("")
    }

    /** True when [code] has exactly [length] characters, all in the alphabet. */
    fun verify(code: String, alphabet: String = DEFAULT_ALPHABET, length: Int = DEFAULT_LENGTH): Boolean {
        val a = alphabet.uppercase()
        space(a, length)
        val c = clean(code)
        return c.length == length && c.all { it in a }
    }

    /** Turns a code back into its id; throws [IllegalArgumentException] when invalid. */
    fun decode(code: String, alphabet: String = DEFAULT_ALPHABET, length: Int = DEFAULT_LENGTH): Long {
        require(verify(code, alphabet, length)) { "human-short-code: invalid code" }
        val a = alphabet.uppercase()
        return clean(code).reversed().fold(0L) { id, c -> id * a.length + a.indexOf(c) }
    }
}
