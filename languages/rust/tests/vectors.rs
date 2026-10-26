use human_short_code::{decode, encode, verify, DEFAULT_ALPHABET, DEFAULT_LENGTH};

#[test]
fn vectors() {
    let path = concat!(env!("CARGO_MANIFEST_DIR"), "/../../spec/vectors.tsv");
    let raw = std::fs::read_to_string(path).unwrap().replace("\r\n", "\n");
    for (n, line) in raw.lines().enumerate() {
        if line.is_empty() || line.starts_with('#') {
            continue;
        }
        let f: Vec<&str> = line.split('\t').collect();
        let alpha = if f[2] == "-" { DEFAULT_ALPHABET } else { f[2] };
        let len = if f[3] == "-" { DEFAULT_LENGTH } else { f[3].parse().unwrap() };
        let got = match f[0] {
            "encode" => encode(f[1].parse().unwrap(), alpha, len),
            "decode" => decode(f[1], alpha, len).map(|v| v.to_string()),
            _ => verify(f[1], alpha, len).map(|v| v.to_string()),
        };
        match (f[4], got) {
            ("!error", Err(e)) => assert!(e.starts_with("human-short-code:"), "line {}", n + 1),
            ("!error", Ok(v)) => panic!("line {}: expected error, got {}", n + 1, v),
            (want, Ok(v)) => assert_eq!(v, want, "line {}", n + 1),
            (_, Err(e)) => panic!("line {}: {}", n + 1, e),
        }
    }
}
