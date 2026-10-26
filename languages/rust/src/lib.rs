//! Encode integer ids as short, human-friendly codes such as `QRQW-ISAA`.
pub const DEFAULT_ALPHABET: &str = "ASDEIUNWRQXBOKH";
pub const DEFAULT_LENGTH: usize = 8;
fn err<T>(msg: &str) -> Result<T, String> {
    Err(format!("human-short-code: {msg}"))
}

/// Validates the config; returns the upper-cased alphabet and `N^length`.
fn check(alphabet: &str, length: usize) -> Result<(Vec<char>, u64), String> {
    let a: Vec<char> = alphabet.to_uppercase().chars().collect();
    if a.len() < 2 || a.iter().enumerate().any(|(i, c)| a[..i].contains(c)) || length < 1 {
        return err("alphabet needs 2+ unique characters and length 1+");
    }
    let n = a.len() as u64;
    let total = (0..length).try_fold(1u64, |t, _| (t <= (1u64 << 53) / n).then(|| t * n));
    total.map_or_else(
        || err("alphabet and length exceed the safe integer range"),
        |t| Ok((a, t)),
    )
}

/// Writes `id` as a code such as `QRQW-ISAA`.
pub fn encode(id: i64, alphabet: &str, length: usize) -> Result<String, String> {
    let (a, total) = check(alphabet, length)?;
    if id < 0 || id as u64 >= total {
        return err("id out of range");
    }
    let n = a.len() as u64;
    let mut digits: Vec<char> = (0..length)
        .map(|i| a[(id as u64 / n.pow(i as u32) % n) as usize])
        .collect();
    if length > 1 {
        digits.insert(length / 2, '-');
    }
    Ok(digits.into_iter().collect())
}

/// Returns whether `code` has exactly `length` characters, all in the alphabet.
pub fn verify(code: &str, alphabet: &str, length: usize) -> Result<bool, String> {
    let (a, _) = check(alphabet, length)?;
    let clean: Vec<char> = code.replace('-', "").to_uppercase().chars().collect();
    Ok(clean.len() == length && clean.iter().all(|c| a.contains(c)))
}

/// Turns a code back into its id; errors when the code is invalid.
pub fn decode(code: &str, alphabet: &str, length: usize) -> Result<i64, String> {
    if !verify(code, alphabet, length)? {
        return err("invalid code");
    }
    let (a, _) = check(alphabet, length)?;
    Ok(code
        .replace('-', "")
        .to_uppercase()
        .chars()
        .rev()
        .fold(0, |id, c| {
            id * a.len() as i64 + a.iter().position(|&x| x == c).unwrap() as i64
        }))
}
