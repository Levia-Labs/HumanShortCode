/** Encodes integer ids as short, human-friendly codes such as {@code QRQW-ISAA}. */
public final class HumanShortCode {
    public static final String DEFAULT_ALPHABET = "ASDEIUNWRQXBOKH";
    public static final int DEFAULT_LENGTH = 8;
    private HumanShortCode() {}
    private static IllegalArgumentException fail(String msg) { return new IllegalArgumentException("human-short-code: " + msg); }

    private static long check(String a, int length) {
        long n = a.length(), total = 1;
        if (n < 2 || length < 1 || a.chars().distinct().count() != n) throw fail("alphabet needs 2+ unique characters and length 1+");
        for (int i = 0; i < length; i++, total *= n)
            if (total > (1L << 53) / n) throw fail("alphabet and length exceed the safe integer range");
        return total;
    }

    /** Writes {@code id} as a code. */
    public static String encode(long id, String alphabet, int length) {
        String a = alphabet.toUpperCase();
        if (id < 0 || id >= check(a, length)) throw fail("id out of range");
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++, id /= a.length()) {
            if (i > 0 && i == length / 2) sb.append('-');
            sb.append(a.charAt((int) (id % a.length())));
        }
        return sb.toString();
    }

    /** True when {@code code} has exactly {@code length} characters, all in the alphabet. */
    public static boolean verify(String code, String alphabet, int length) {
        String a = alphabet.toUpperCase(), c = code.replace("-", "").toUpperCase();
        check(a, length);
        return c.length() == length && c.chars().allMatch(ch -> a.indexOf(ch) >= 0);
    }

    /** Turns a code back into its id; throws when the code is invalid. */
    public static long decode(String code, String alphabet, int length) {
        if (!verify(code, alphabet, length)) throw fail("invalid code");
        String c = code.replace("-", "").toUpperCase(), a = alphabet.toUpperCase();
        long id = 0; for (int i = c.length() - 1; i >= 0; i--) id = id * a.length() + a.indexOf(c.charAt(i));
        return id;
    }
    public static String encode(long id) { return encode(id, DEFAULT_ALPHABET, DEFAULT_LENGTH); }
    public static long decode(String code) { return decode(code, DEFAULT_ALPHABET, DEFAULT_LENGTH); }
    public static boolean verify(String code) { return verify(code, DEFAULT_ALPHABET, DEFAULT_LENGTH); }
}
