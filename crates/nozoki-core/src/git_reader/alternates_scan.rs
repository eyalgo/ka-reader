//! git-reader's alternates line rule: the bytes of an `objects/info/alternates` file in, the entries
//! libgit2 would add as object directories out. Pure: it reads no file and names no libgit2. The rule is
//! libgit2 1.9.7's `load_alternates` (`src/libgit2/odb.c`).

/// Where an entry is spelled from, which decides whether it can lie inside the folder.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub(super) enum EntryClass {
    /// Begins with `.`: libgit2 joins it onto the object directory that holds the file.
    FromTheObjectDirectory,
    /// Begins with `/`: taken as written.
    Absolute,
    /// Any other entry, which the operating system would resolve against the process's working
    /// directory and never against the folder, so the reader refuses it without locating it,
    /// whatever it names.
    NotLocated,
}

/// One entry of an alternates file, as written.
#[derive(Debug, Clone, PartialEq, Eq)]
pub(super) struct AlternateEntry {
    pub value: Vec<u8>,
    pub class: EntryClass,
}

/// The entries `bytes` holds, in file order. Only the bytes before the first NUL count, lines end at
/// a CR or an LF, an empty line is no line, and a line whose first byte is `#` is skipped. Nothing is
/// trimmed, so a leading space puts an entry in the not-located class (`odb.c`, `load_alternates`, and
/// `git__strtok` in `util.c`).
pub(super) fn scan(bytes: &[u8]) -> Vec<AlternateEntry> {
    let counted = bytes
        .iter()
        .position(|byte| *byte == 0)
        .map_or(bytes, |end| &bytes[..end]);
    counted
        .split(|byte| matches!(byte, b'\r' | b'\n'))
        .filter(|line| !line.is_empty() && line[0] != b'#')
        .map(|line| AlternateEntry {
            value: line.to_vec(),
            class: class_of(line),
        })
        .collect()
}

fn class_of(entry: &[u8]) -> EntryClass {
    match entry.first() {
        Some(b'.') => EntryClass::FromTheObjectDirectory,
        Some(b'/') => EntryClass::Absolute,
        _ => EntryClass::NotLocated,
    }
}
