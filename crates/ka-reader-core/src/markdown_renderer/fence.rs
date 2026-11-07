//! A fenced code block's language, from the first word of its info string.

use crate::Language;

/// The floor languages with the words that name them in a fence: the language's own name, then its
/// extensions without the dot (SDD § 4 C-I5). Held here and not borrowed from the file reader's
/// extension map, which the renderer may not call; `tests/markdown.rs` fails when the two drift.
const FENCE_WORDS: [(Language, &[&str]); 6] = [
    (Language::Python, &["python", "py", "pyi", "pyw"]),
    (Language::Shell, &["shell", "sh", "bash", "zsh"]),
    (
        Language::JavaScript,
        &["javascript", "js", "mjs", "cjs", "jsx"],
    ),
    (Language::Json, &["json"]),
    (Language::Yaml, &["yaml", "yml"]),
    (Language::Toml, &["toml"]),
];

/// The language the first whitespace-separated word of `info` names, compared without ASCII case.
/// Every other word, and an empty info string, is `Plain`.
pub(super) fn language_of_fence(info: &str) -> Language {
    let Some(word) = info.split_whitespace().next() else {
        return Language::Plain;
    };
    FENCE_WORDS
        .iter()
        .find(|(_, words)| words.iter().any(|known| known.eq_ignore_ascii_case(word)))
        .map_or(Language::Plain, |(language, _)| *language)
}
