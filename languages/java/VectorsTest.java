import java.nio.file.*;
import java.util.List;

/** Runs spec/vectors.tsv against HumanShortCode; exits non-zero on any failure. */
public final class VectorsTest {
    public static void main(String[] args) throws Exception {
        List<String> lines = Files.readAllLines(Paths.get("spec/vectors.tsv"));
        int failed = 0;
        for (int n = 0; n < lines.size(); n++) {
            String line = lines.get(n);
            if (line.isEmpty() || line.startsWith("#")) continue;
            String[] f = line.split("\t", -1);
            String alpha = f[2].equals("-") ? "ASDEIUNWRQXBOKH" : f[2];
            int len = f[3].equals("-") ? 8 : Integer.parseInt(f[3]);
            String got;
            try {
                switch (f[0]) {
                    case "encode": got = HumanShortCode.encode(Long.parseLong(f[1]), alpha, len); break;
                    case "decode": got = Long.toString(HumanShortCode.decode(f[1], alpha, len)); break;
                    default: got = Boolean.toString(HumanShortCode.verify(f[1], alpha, len));
                }
            } catch (IllegalArgumentException e) {
                got = e.getMessage().startsWith("human-short-code:") ? "!error" : "bad message";
            }
            if (!got.equals(f[4])) {
                System.out.println("line " + (n + 1) + ": got " + got + ", want " + f[4]);
                failed++;
            }
        }
        if (failed > 0) System.exit(1);
        System.out.println("all vectors passed");
    }
}
