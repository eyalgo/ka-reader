#[cfg(test)]
mod tests {
    use super::{ConfigParseFailure, Placement, ReferenceKind, scan};

    /// The references of `text`, as `(key, value, kind, placement)` with the value spelled lossily.
    fn references(text: &str) -> Vec<(String, String, ReferenceKind, Placement)> {
        scan(text.as_bytes())
            .expect("the text parses")
            .references
            .into_iter()
            .map(|reference| {
                (
                    reference.key,
                    String::from_utf8_lossy(&reference.value).into_owned(),
                    reference.kind,
                    reference.placement,
                )
            })
            .collect()
    }

    fn one(text: &str) -> (String, String, ReferenceKind, Placement) {
        let mut found = references(text);
        assert_eq!(found.len(), 1, "{text:?} holds one reference: {found:?}");
        found.remove(0)
    }

    #[test]
    fn test_each_of_the_five_keys_is_refused_with_its_kind_and_placement() {
        let cases = [
            (
                "[include]\n\tpath = x\n",
                "include.path",
                ReferenceKind::Include,
                Placement::FromTheFile,
            ),
            (
                "[includeIf \"gitdir:/a/\"]\n\tpath = x\n",
                "includeIf.gitdir:/a/.path",
                ReferenceKind::Include,
                Placement::FromTheFile,
            ),
            (
                "[core]\n\tworktree = x\n",
                "core.worktree",
                ReferenceKind::Worktree,
                Placement::FromTheGitDirectory,
            ),
            (
                "[core]\n\texcludesfile = /abs\n",
                "core.excludesfile",
                ReferenceKind::ExcludesFile,
                Placement::FromTheFile,
            ),
            (
                "[core]\n\tattributesfile = /abs\n",
                "core.attributesfile",
                ReferenceKind::AttributesFile,
                Placement::FromTheFile,
            ),
        ];
        for (text, key, kind, placement) in cases {
            let (found_key, _, found_kind, found_placement) = one(text);
            assert_eq!(
                (found_key.as_str(), found_kind, found_placement),
                (key, kind, placement),
                "{text:?}"
            );
        }
    }

    #[test]
    fn test_include_if_is_refused_whatever_its_condition() {
        for condition in [
            "gitdir:/a/",
            "gitdir/i:~/x/",
            "onbranch:main",
            "hasconfig:remote.*.url:*",
            "nonsense",
        ] {
            let text = format!("[includeIf \"{condition}\"]\n\tpath = ../elsewhere\n");
            let (key, value, kind, _) = one(&text);
            assert_eq!(
                (key, value, kind),
                (
                    format!("includeIf.{condition}.path"),
                    "../elsewhere".to_string(),
                    ReferenceKind::Include
                )
            );
        }
    }

    #[test]
    fn test_the_key_matches_case_insensitively_in_section_and_name_and_not_in_the_subsection() {
        let (key, _, kind, _) = one("[CORE]\n\tExcludesFile = /abs\n");
        assert_eq!(
            (key.as_str(), kind),
            ("CORE.ExcludesFile", ReferenceKind::ExcludesFile)
        );
        assert_eq!(
            one("[INCLUDEIF \"gitdir:/a/\"]\n\tPATH = x\n").2,
            ReferenceKind::Include
        );
        assert!(
            references("[include \"Sub\"]\n\tpath = x\n").is_empty(),
            "include.Sub.path is not include.path"
        );
        assert!(references("[core \"Sub\"]\n\tworktree = x\n").is_empty());
    }

    #[test]
    fn test_any_of_several_occurrences_is_reported() {
        let found =
            references("[include]\n\tpath = a\n[core]\n\tworktree = b\n[include]\n\tpath = c\n");
        let values: Vec<_> = found.iter().map(|found| found.1.as_str()).collect();
        assert_eq!(values, ["a", "b", "c"]);
    }

    #[test]
    fn test_a_value_beginning_tilde_slash_is_outside_for_any_key() {
        for text in [
            "[include]\n\tpath = ~/x\n",
            "[core]\n\tworktree = ~/x\n",
            "[core]\n\texcludesfile = ~/x\n",
            "[core]\n\tattributesfile = ~/x\n",
        ] {
            assert_eq!(one(text).3, Placement::Outside, "{text:?}");
        }
        assert_eq!(
            one("[include]\n\tpath = ~x\n").3,
            Placement::FromTheFile,
            "only ~/ is a home spelling"
        );
    }

    #[test]
    fn test_a_relative_excludesfile_or_attributesfile_is_outside_and_an_absolute_one_is_not() {
        assert_eq!(
            one("[core]\n\texcludesfile = rel/x\n").3,
            Placement::Outside
        );
        assert_eq!(
            one("[core]\n\tattributesfile = rel/x\n").3,
            Placement::Outside
        );
        assert_eq!(
            one("[core]\n\texcludesfile = /abs/x\n").3,
            Placement::FromTheFile
        );
    }

    #[test]
    fn test_a_relative_include_is_spelled_from_the_file_and_a_relative_worktree_from_the_git_directory()
     {
        assert_eq!(one("[include]\n\tpath = ../x\n").3, Placement::FromTheFile);
        assert_eq!(
            one("[core]\n\tworktree = ../x\n").3,
            Placement::FromTheGitDirectory
        );
    }

    #[test]
    fn test_the_syntax_forms_libgit2_parses_are_parsed() {
        // A quoted subsection with escapes, the legacy dotted form, and the key written as the file writes it.
        assert_eq!(
            one("[includeIf \"a\\\"b\\\\c\"]\n\tpath = x\n").0,
            "includeIf.a\"b\\c.path"
        );
        assert_eq!(
            one("[includeif.legacy]\n\tpath = x\n").2,
            ReferenceKind::Include
        );
        // A header and a variable on one line.
        assert_eq!(one("[include] path = x\n").1, "x");
        // Quoted runs lose their quotes, escapes are applied, a comment outside quotes ends the value.
        assert_eq!(one("[include]\n\tpath = \"a b\" # c\n").1, "a b");
        assert_eq!(
            one("[include]\n\tpath = a\\tb\\\\c\\\"d ; c\n").1,
            "a\tb\\c\"d"
        );
        assert_eq!(one("[include]\n\tpath = \"a#b;c\"\n").1, "a#b;c");
        // A trailing backslash continues the line, a comment-only continuation line is skipped.
        assert_eq!(one("[include]\n\tpath = ab\\\n# note\ncd\n").1, "abcd");
        // A bare name has no value and follows nothing; a variable before any header has no section.
        assert!(references("[include]\n\tpath\n").is_empty());
        assert!(references("path = x\n").is_empty());
        // Comments, blank lines and a byte-order mark.
        assert_eq!(
            one("\u{feff}# top\n\n; more\n[include]\n\tpath = x\n").1,
            "x"
        );
        // Carriage returns end a value's trailing space, as strip_comments trims it.
        assert_eq!(one("[include]\r\n\tpath = x\r\n").1, "x");
    }

    #[test]
    fn test_a_line_that_cannot_be_parsed_is_a_failure_never_a_skip() {
        for text in [
            "[include\n\tpath = x\n",
            "[includeIf \"gitdir:/a/]\n\tpath = x\n",
            "[includeIf \"a\"x]\n\tpath = x\n",
            "[in clude]\n",
            "[core]\n\t= x\n",
            "[core]\n\tbad key = x\n",
            "[core]\n\tname = \\q\n",
            "[core]\n\tname = ok\n\tname2 = a\\x\n",
            "[core]\n\tpath = x\n\x0b\n",
        ] {
            assert_eq!(
                scan(text.as_bytes()).err(),
                Some(ConfigParseFailure),
                "{text:?}"
            );
        }
    }

    #[test]
    fn test_the_worktree_config_extension_is_noticed_as_git_reads_a_boolean() {
        let set = |text: &str| scan(text.as_bytes()).expect("parses").worktree_config;
        assert!(set("[extensions]\n\tworktreeConfig = true\n"));
        assert!(set("[extensions]\n\tworktreeconfig\n"));
        assert!(set("[extensions]\n\tworktreeConfig = 1\n"));
        assert!(!set("[extensions]\n\tworktreeConfig = false\n"));
        assert!(!set("[extensions]\n\tworktreeConfig = no\n"));
        assert!(!set("[core]\n\tworktreeConfig = true\n"));
        assert!(!set(""));
    }

    #[test]
    fn test_what_follows_the_first_nul_is_not_read_and_a_leading_nul_is_an_empty_file() {
        assert_eq!(
            scan(b"\0[include]\n\tpath = x\n")
                .expect("parses")
                .references
                .len(),
            0
        );
        assert_eq!(
            scan(b"[include]\n\tpath = x\0y\n")
                .expect("parses")
                .references[0]
                .value,
            b"x"
        );
    }
}
