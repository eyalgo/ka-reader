//! The language a text file is drawn as: the six floor languages and `Plain`.
//!
//! A value module shared by `fs_reader`, which names a file's language from its name, and
//! `highlighter`, which tokenises text in it. Neither imports the other, so the type lives here.

/// The language a text file is drawn as: one of the six floor languages, or `Plain` for every
/// text the floor does not name. There is no Markdown value, and the set is closed, so a `match`
/// over it names every value and a seventh language is a compile error at each one.
///
/// # Examples
///
/// ```
/// use nozoki_core::Language;
///
/// fn has_a_grammar(language: Language) -> bool {
///     match language {
///         Language::Python
///         | Language::Shell
///         | Language::JavaScript
///         | Language::Json
///         | Language::Yaml
///         | Language::Toml => true,
///         Language::Plain => false,
///     }
/// }
///
/// assert!(has_a_grammar(Language::Toml));
/// assert!(!has_a_grammar(Language::Plain));
/// ```
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Language {
    Python,
    Shell,
    JavaScript,
    Json,
    Yaml,
    Toml,
    Plain,
}

#[cfg(test)]
mod tests {
    use crate::Language;

    /// The match names every value and has no wildcard arm, so it compiles only while the set is
    /// exactly these seven: a value added or removed is a compile error here, not a silent pass.
    #[test]
    fn test_language_names_exactly_seven_values() {
        let named_by_arm = |language: Language| match language {
            Language::Python => "python",
            Language::Shell => "shell",
            Language::JavaScript => "javascript",
            Language::Json => "json",
            Language::Yaml => "yaml",
            Language::Toml => "toml",
            Language::Plain => "plain",
        };

        let every_value = [
            Language::Python,
            Language::Shell,
            Language::JavaScript,
            Language::Json,
            Language::Yaml,
            Language::Toml,
            Language::Plain,
        ];
        let names: Vec<&str> = every_value.into_iter().map(named_by_arm).collect();
        assert_eq!(
            names,
            [
                "python",
                "shell",
                "javascript",
                "json",
                "yaml",
                "toml",
                "plain"
            ]
        );
    }
}
