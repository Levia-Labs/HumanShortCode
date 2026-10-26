using System;
using System.IO;
using System.Linq;
using Xunit;

public class VectorsTests
{
    [Fact]
    public void Vectors()
    {
        var path = Path.Combine(AppContext.BaseDirectory, "../../../../../../spec/vectors.tsv");
        foreach (var (line, n) in File.ReadAllLines(path).Select((l, i) => (l, i + 1)))
        {
            if (line.Length == 0 || line.StartsWith('#')) continue;
            var f = line.Split('\t');
            var alpha = f[2] == "-" ? HumanShortCode.DefaultAlphabet : f[2];
            var len = f[3] == "-" ? HumanShortCode.DefaultLength : int.Parse(f[3]);
            Func<string> run = f[0] switch
            {
                "encode" => () => HumanShortCode.Encode(long.Parse(f[1]), alpha, len),
                "decode" => () => HumanShortCode.Decode(f[1], alpha, len).ToString(),
                _ => () => HumanShortCode.Verify(f[1], alpha, len).ToString().ToLowerInvariant(),
            };
            if (f[4] == "!error")
            {
                var e = Assert.ThrowsAny<ArgumentException>(run);
                Assert.StartsWith("human-short-code:", e.Message);
            }
            else Assert.True(f[4] == run(), $"line {n}");
        }
    }
}
