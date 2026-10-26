using System;
using System.Linq;
using System.Text;

/// <summary>Encodes integer ids as short, human-friendly codes such as <c>QRQW-ISAA</c>.</summary>
public static class HumanShortCode
{
    /// <summary>Alphabet used when none is given.</summary>
    public const string DefaultAlphabet = "ASDEIUNWRQXBOKH";
    /// <summary>Code length used when none is given.</summary>
    public const int DefaultLength = 8;

    private static ArgumentException Fail(string msg) => new("human-short-code: " + msg);

    // Validates the config and returns N^length.
    private static long Space(string a, int length)
    {
        long n = a.Length, total = 1;
        if (n < 2 || length < 1 || a.Distinct().Count() != n)
            throw Fail("alphabet needs 2+ unique characters and length 1+");
        for (var i = 0; i < length; i++, total *= n)
            if (total > (1L << 53) / n) throw Fail("alphabet and length exceed the safe integer range");
        return total;
    }

    private static string Clean(string code) => code.Replace("-", "").ToUpperInvariant();

    /// <summary>Writes <paramref name="id"/> as a code.</summary>
    public static string Encode(long id, string alphabet = DefaultAlphabet, int length = DefaultLength)
    {
        var a = alphabet.ToUpperInvariant();
        if (id < 0 || id >= Space(a, length)) throw Fail("id out of range");
        var sb = new StringBuilder();
        for (var i = 0; i < length; i++, id /= a.Length)
        {
            if (i > 0 && i == length / 2) sb.Append('-');
            sb.Append(a[(int)(id % a.Length)]);
        }
        return sb.ToString();
    }

    /// <summary>True when the code has exactly <paramref name="length"/> characters, all in the alphabet.</summary>
    public static bool Verify(string code, string alphabet = DefaultAlphabet, int length = DefaultLength)
    {
        var a = alphabet.ToUpperInvariant();
        Space(a, length);
        var c = Clean(code);
        return c.Length == length && c.All(ch => a.Contains(ch));
    }

    /// <summary>Turns a code back into its id; throws when the code is invalid.</summary>
    public static long Decode(string code, string alphabet = DefaultAlphabet, int length = DefaultLength)
    {
        if (!Verify(code, alphabet, length)) throw Fail("invalid code");
        var a = alphabet.ToUpperInvariant();
        return Clean(code).Reverse().Aggregate(0L, (id, ch) => id * a.Length + a.IndexOf(ch));
    }
}
