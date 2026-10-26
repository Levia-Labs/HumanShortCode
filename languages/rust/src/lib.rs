//! Encode integer ids as short, human-friendly codes such as `QRQW-ISAA`.

/// Alphabet used when none is given.
pub const DEFAULT_ALPHABET: &str = "ASDEIUNWRQXBOKH";
/// Number of code characters used when none is given.
pub const DEFAULT_LENGTH: usize = 8;

fn err<T>(msg: &str) -> Result<T, String> {
    Err(format!("human-short-code: {msg}"))
}

/// Validates the config; returns the upper-cased alphabet and `N^length`.
fn space(alphabet: &str, length: usize) -> Result<(Vec<char>, u64), String> {
    let a: Vec<char> = alphabet.to_uppercase().chars().collect();
    let mut unique = a.clone();
    unique.sort_unstable();
    unique.dedup();
    if a.len() < 2 || unique.len() != a.len() || length < 1 {
        return err("alphabet needs 2+ unique characters and length 1+");
    }
    let (n, mut total) = (a.len() as u64, 1u64);
    for _ in 0..length {
        if total > (1u64 << 53) / n {
            return err("alphabet and length exceed the safe integer range");
        }
        total *= n;
    }
    Ok((a, total))
}

/// Writes `id` as a code such as `QRQW-ISAA`.
pub fn encode(id: i64, alphabet: &str, length: usize) -> Result<String, String> {
    let (a, total) = space(alphabet, length)?;
    if id < 0 || id as u64 >= total {
        return err("id out of range");
    }
    let mut rest = id as u64;
    let digits: Vec<char> = (0..length)
        .map(|_| {
            let c = a[(rest % a.len() as u64) as usize];
            rest /= a.len() as u64;
            c
        })
        .collect();
    let half = length / 2;
    let (head, tail) = digits.split_at(half);
    let dash = if half > 0 { "-" } else { "" };
    Ok(format!("{}{dash}{}", head.iter().collect::<String>(), tail.iter().collect::<String>()))
}

/// Returns whether `code` has exactly `length` characters, all in the alphabet.
pub fn verify(code: &str, alphabet: &str, length: usize) -> Result<bool, String> {
    let (a, _) = space(alphabet, length)?;
    let clean: Vec<char> = code.replace('-', "").to_uppercase().chars().collect();
    Ok(clean.len() == length && clean.iter().all(|c| a.contains(c)))
}

/// Turns a code back into its id; errors when the code is invalid.
pub fn decode(code: &str, alphabet: &str, length: usize) -> Result<i64, String> {
    if !verify(code, alphabet, length)? {
        return err("invalid code");
    }
    let (a, _) = space(alphabet, length)?;
    let (mut id, mut scale) = (0u64, 1u64);
    for c in code.replace('-', "").to_uppercase().chars() {
        id += a.iter().position(|&x| x == c).unwrap() as u64 * scale;
        scale = scale.saturating_mul(a.len() as u64);
    }
    Ok(id as i64)
}
