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
            ["python", "shell", "javascript", "json", "yaml", "toml", "plain"]
        );
    }
}
