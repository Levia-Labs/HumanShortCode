using System;
using System.Linq;
using System.Text;
/// <summary>Encodes integer ids as short, human-friendly codes such as <c>QRQW-ISAA</c>.</summary>
public static class HumanShortCode
{
    public const string DefaultAlphabet = "ASDEIUNWRQXBOKH";
    public const int DefaultLength = 8;
    private static ArgumentException Fail(string msg) => new("human-short-code: " + msg);
    private static long Check(string a, int length)
    {
        long n = a.Length, total = 1;
        if (n < 2 || length < 1 || a.Distinct().Count() != n) throw Fail("alphabet needs 2+ unique characters and length 1+");
        for (var i = 0; i < length; i++, total *= n)
            if (total > (1L << 53) / n) throw Fail("alphabet and length exceed the safe integer range");
        return total;
    }

    /// <summary>Writes the id as a code.</summary>
    public static string Encode(long id, string alphabet = DefaultAlphabet, int length = DefaultLength)
    {
        var a = alphabet.ToUpperInvariant();
        if (id < 0 || id >= Check(a, length)) throw Fail("id out of range");
        var sb = new StringBuilder();
        for (var i = 0; i < length; i++, id /= a.Length)
            sb.Append(i > 0 && i == length / 2 ? "-" : "").Append(a[(int)(id % a.Length)]);
        return sb.ToString();
    }

    /// <summary>True when the code has exactly <c>length</c> characters, all in the alphabet.</summary>
    public static bool Verify(string code, string alphabet = DefaultAlphabet, int length = DefaultLength)
    {
        string a = alphabet.ToUpperInvariant(), c = code.Replace("-", "").ToUpperInvariant();
        Check(a, length);
        return c.Length == length && c.All(ch => a.Contains(ch));
    }

    /// <summary>Turns a code back into its id; throws when the code is invalid.</summary>
    public static long Decode(string code, string alphabet = DefaultAlphabet, int length = DefaultLength)
    {
        if (!Verify(code, alphabet, length)) throw Fail("invalid code");
        var a = alphabet.ToUpperInvariant();
        return code.Replace("-", "").ToUpperInvariant().Reverse().Aggregate(0L, (id, ch) => id * a.Length + a.IndexOf(ch));
    }
}
