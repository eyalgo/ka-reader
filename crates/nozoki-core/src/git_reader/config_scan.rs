//! git-reader's config scanner: a repository's config bytes in, the entries of the five keys libgit2
//! would follow to a path, and every include value, out, or a parse failure. Pure: it does no I/O
//! and names no libgit2, because `git2::Config::open` loads a file and follows its
//! includes, which is the read the scanner exists to refuse. The grammar is libgit2 1.9.7's
//! (`src/libgit2/config_parse.c`), whose parse of the whole file decides what it follows: a line it
//! cannot parse is a failure here, never a skip.

use std::str;

/// Which of the five keys an entry is, as far as how its value is followed.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub(super) enum ReferenceKind {
    /// `include.path` and `includeIf.<condition>.path`, refused whatever the condition.
    Include,
    /// `core.worktree`.
    Worktree,
    /// `core.excludesfile`.
    ExcludesFile,
    /// `core.attributesfile`.
    AttributesFile,
}

/// Where a value is spelled from, which is what decides whether it can lie inside the folder.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub(super) enum Placement {
    /// Not located by rule: a value beginning `~/` (never expanded), or a relative excludes or
    /// attributes file, which libgit2 hands on with no base.
    NotLocated,
    /// Spelled from the directory of the file that carries the value.
    FromTheFile,
    /// Spelled from the Git directory (`core.worktree`).
    FromTheGitDirectory,
}

/// One entry of a refused key.
#[derive(Debug, Clone, PartialEq, Eq)]
pub(super) struct ConfigReference {
    /// The key as the file writes it: the section, the subsection where there is one, and the name,
    /// joined by `.`.
    pub key: String,
    /// The value as parsed: unquoted, unescaped, ended at the first NUL.
    pub value: Vec<u8>,
    pub kind: ReferenceKind,
    pub placement: Placement,
}

/// One `path` entry under a `[submodule]` header.
#[derive(Debug, Clone, PartialEq, Eq)]
pub(super) struct SectionPath {
    /// The key as the file writes it, `submodule.<name>.path` in the file's own spelling.
    pub key: String,
    /// The value as parsed, as [`ConfigReference::value`] is.
    pub value: Vec<u8>,
}

/// One `[submodule]` header occurrence, whether or not it holds a `path` entry.
#[derive(Debug, Clone, PartialEq, Eq)]
pub(super) struct SubmoduleSection {
    /// The section word as the file writes it: `submodule`, `Submodule`.
    pub word: String,
    /// The name as libgit2 stores it, as bytes: a quoted subsection unescaped and in its case, or
    /// the legacy dotted form's name lowercased. libgit2's map is keyed by these bytes.
    pub stored_name: Vec<u8>,
    /// The name as the file writes it, spelled lossily.
    pub written_name: String,
    /// Each `path` entry under this header, in file order.
    pub paths: Vec<SectionPath>,
}

/// What one config file holds that the check needs.
#[derive(Debug, Clone, PartialEq, Eq)]
pub(super) struct ConfigScan {
    pub references: Vec<ConfigReference>,
    /// Every `[submodule]` header the file holds, in file order.
    pub sections: Vec<SubmoduleSection>,
    /// Whether this file sets `extensions.worktreeconfig` to a true value, so `config.worktree`
    /// is read beside it.
    pub worktree_config: bool,
}

/// The bytes are not a config libgit2 parses to the end.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub(super) struct ConfigParseFailure;

const BYTE_ORDER_MARK: &[u8] = b"\xEF\xBB\xBF";
const HOME_PREFIX: &[u8] = b"~/";
const MIN_CONDITIONAL_KEY_LENGTH: usize = "includeif.".len() + ".path".len();
const WORKTREE_CONFIG_KEY: &str = "extensions.worktreeconfig";
const SUBMODULE_SECTION: &str = "submodule";
const SUBMODULE_PATH_KEY: &str = "path";

/// Scans one config file's bytes.
pub(super) fn scan(bytes: &[u8]) -> Result<ConfigScan, ConfigParseFailure> {
    let mut scan = ConfigScan {
        references: Vec::new(),
        sections: Vec::new(),
        worktree_config: false,
    };
    if bytes.first().is_none_or(|first| *first == 0) {
        return Ok(scan);
    }
    let content = bytes.strip_prefix(BYTE_ORDER_MARK).unwrap_or(bytes);
    let lines: Vec<&[u8]> = content
        .split(|byte| *byte == b'\n')
        .map(up_to_nul)
        .collect();
    // `split` yields a final empty piece after a trailing newline; it is no line.
    let lines = match lines.split_last() {
        Some((last, rest)) if last.is_empty() && content.last() == Some(&b'\n') => rest.to_vec(),
        _ => lines,
    };
    let mut section: Option<Section> = None;
    let mut index = 0;
    while index < lines.len() {
        let mut rest = lines[index];
        loop {
            let trimmed = trim_start_space(rest);
            let first = match trimmed.first() {
                Some(first) => *first,
                None => match rest.first() {
                    Some(first) => *first,
                    None => break,
                },
            };
            match first {
                b'[' => {
                    let (header, consumed) = parse_section_header(trimmed)?;
                    if let Some(record) = header.submodule_record() {
                        scan.sections.push(record);
                    }
                    section = Some(header);
                    rest = &trimmed[consumed..];
                    if trim_start_space(rest).is_empty() {
                        break;
                    }
                }
                b'\n' | b'\r' | b' ' | b'\t' | b';' | b'#' => break,
                _ => {
                    let variable = parse_variable(trimmed, &lines, &mut index)?;
                    record(&mut scan, section.as_ref(), variable);
                    break;
                }
            }
        }
        index += 1;
    }
    Ok(scan)
}

/// A section header: the name libgit2 stores, and the name as the file writes it.
struct Section {
    canonical: String,
    written: String,
    /// The header's section word as written, before any quoted subsection.
    base: String,
    /// The subsection's bytes, unescaped, when the header is the quoted form.
    subsection: Option<Vec<u8>>,
}

impl Section {
    /// The record a `[submodule "name"]` or `[submodule.name]` header starts, `None` for any other
    /// section.
    fn submodule_record(&self) -> Option<SubmoduleSection> {
        let (word, written_name, stored_name) = match &self.subsection {
            Some(subsection) => (
                self.base.as_str(),
                String::from_utf8_lossy(subsection).into_owned(),
                subsection.clone(),
            ),
            None => {
                let (word, name) = self.written.split_once('.')?;
                (
                    word,
                    name.to_string(),
                    name.to_ascii_lowercase().into_bytes(),
                )
            }
        };
        word.eq_ignore_ascii_case(SUBMODULE_SECTION)
            .then(|| SubmoduleSection {
                word: word.to_string(),
                stored_name,
                written_name,
                paths: Vec::new(),
            })
    }
}

struct Variable {
    name: String,
    value: Option<Vec<u8>>,
}

fn record(scan: &mut ConfigScan, section: Option<&Section>, variable: Variable) {
    let name_lowered = variable.name.to_ascii_lowercase();
    if let Some(section) = section.filter(|section| section.submodule_record().is_some())
        && name_lowered == SUBMODULE_PATH_KEY
        && let Some(record) = scan.sections.last_mut()
    {
        record.paths.push(SectionPath {
            key: format!("{}.{}", section.written, variable.name),
            value: variable.value.clone().unwrap_or_default(),
        });
    }
    let (canonical, written) = match section {
        Some(section) => (
            format!("{}.{name_lowered}", section.canonical),
            format!("{}.{}", section.written, variable.name),
        ),
        None => (name_lowered, variable.name),
    };
    if canonical == WORKTREE_CONFIG_KEY && variable.value.as_deref().is_none_or(is_true) {
        scan.worktree_config = true;
    }
    let Some(kind) = reference_kind(&canonical) else {
        return;
    };
    let Some(value) = variable.value else {
        return;
    };
    let placement = placement_of(kind, &value);
    scan.references.push(ConfigReference {
        key: written,
        value,
        kind,
        placement,
    });
}

/// The kind of key libgit2 would follow to a path, read off the stored name: the section and the
/// name lowercased and the subsection as written, as `read_on_variable` compares them.
fn reference_kind(canonical: &str) -> Option<ReferenceKind> {
    if canonical == "include.path"
        || (canonical.len() >= MIN_CONDITIONAL_KEY_LENGTH
            && canonical.starts_with("includeif.")
            && canonical.ends_with(".path"))
    {
        return Some(ReferenceKind::Include);
    }
    match canonical {
        "core.worktree" => Some(ReferenceKind::Worktree),
        "core.excludesfile" => Some(ReferenceKind::ExcludesFile),
        "core.attributesfile" => Some(ReferenceKind::AttributesFile),
        _ => None,
    }
}

fn placement_of(kind: ReferenceKind, value: &[u8]) -> Placement {
    let relative = value.first().is_some_and(|first| *first != b'/');
    match kind {
        _ if value.starts_with(HOME_PREFIX) => Placement::NotLocated,
        ReferenceKind::Include => Placement::FromTheFile,
        ReferenceKind::Worktree => Placement::FromTheGitDirectory,
        ReferenceKind::ExcludesFile | ReferenceKind::AttributesFile if relative => {
            Placement::NotLocated
        }
        ReferenceKind::ExcludesFile | ReferenceKind::AttributesFile => Placement::FromTheFile,
    }
}

/// Git's boolean reading of a value: `true`, `yes`, `on`, or a nonzero integer.
fn is_true(value: &[u8]) -> bool {
    let text = String::from_utf8_lossy(value).to_ascii_lowercase();
    match text.as_str() {
        "true" | "yes" | "on" => true,
        "" | "false" | "no" | "off" => false,
        other => other.parse::<i64>().is_ok_and(|number| number != 0),
    }
}

fn up_to_nul(bytes: &[u8]) -> &[u8] {
    bytes
        .iter()
        .position(|byte| *byte == 0)
        .map_or(bytes, |end| &bytes[..end])
}

/// C `isspace`, which libgit2's `git__isspace` is.
fn is_space(byte: u8) -> bool {
    matches!(byte, b' ' | b'\t' | b'\n' | 0x0B | 0x0C | b'\r')
}

fn trim_start_space(bytes: &[u8]) -> &[u8] {
    let start = bytes
        .iter()
        .position(|byte| !is_space(*byte))
        .unwrap_or(bytes.len());
    &bytes[start..]
}

fn is_keychar(byte: u8) -> bool {
    byte.is_ascii_alphanumeric() || byte == b'-'
}

/// `parse_section_header`: `line` begins at the `[`. Returns the section and the bytes consumed,
/// through the `]`.
fn parse_section_header(line: &[u8]) -> Result<(Section, usize), ConfigParseFailure> {
    if !line.contains(&b']') {
        return Err(ConfigParseFailure);
    }
    let mut position = 1;
    let mut written = String::new();
    loop {
        let byte = line.get(position).copied().unwrap_or(0);
        position += 1;
        if is_space(byte) {
            return parse_subsection_header(line, position, &written);
        }
        if !is_keychar(byte) && byte != b'.' {
            return Err(ConfigParseFailure);
        }
        written.push(char::from(byte));
        if line.get(position) == Some(&b']') {
            let canonical = written.to_ascii_lowercase();
            let section = Section {
                canonical,
                base: written.clone(),
                written,
                subsection: None,
            };
            return Ok((section, position + 1));
        }
    }
}

/// `parse_subsection_header`: the quoted subsection after the whitespace at `position - 1`.
fn parse_subsection_header(
    line: &[u8],
    mut position: usize,
    base: &str,
) -> Result<(Section, usize), ConfigParseFailure> {
    while line.get(position).is_some_and(|byte| is_space(*byte)) {
        position += 1;
    }
    if line.get(position) != Some(&b'"') {
        return Err(ConfigParseFailure);
    }
    let first_quote = position;
    let last_quote = line
        .iter()
        .rposition(|byte| *byte == b'"')
        .ok_or(ConfigParseFailure)?;
    if last_quote == first_quote {
        return Err(ConfigParseFailure);
    }
    let at = |index: usize| line.get(index).copied().unwrap_or(0);
    let mut subsection = Vec::new();
    let mut cursor = first_quote + 1;
    let mut byte = at(cursor);
    loop {
        match byte {
            0 => return Err(ConfigParseFailure),
            b'"' => break,
            b'\\' => {
                cursor += 1;
                byte = at(cursor);
                if byte == 0 {
                    return Err(ConfigParseFailure);
                }
            }
            _ => {}
        }
        subsection.push(byte);
        cursor += 1;
        byte = at(cursor);
        if cursor >= last_quote {
            break;
        }
    }
    if at(cursor) != b'"' || at(cursor + 1) != b']' {
        return Err(ConfigParseFailure);
    }
    let spelled = String::from_utf8_lossy(&subsection).into_owned();
    Ok((
        Section {
            canonical: format!("{}.{spelled}", base.to_ascii_lowercase()),
            written: format!("{base}.{spelled}"),
            base: base.to_string(),
            subsection: Some(subsection),
        },
        cursor + 2,
    ))
}

/// `strip_comments`: cuts the line at the first `;` or `#` outside quotes and an escape, trims the
/// end, and returns how many quotes it counted, from `in_quotes`.
fn strip_comments(line: &mut Vec<u8>, in_quotes: usize) -> usize {
    let mut quote_count = in_quotes;
    let mut backslash_count: usize = 0;
    let mut end = line.len();
    for (index, byte) in line.iter().enumerate() {
        if *byte == b'"' && (index == 0 || line[index - 1] != b'\\') {
            quote_count += 1;
        }
        if (*byte == b';' || *byte == b'#')
            && quote_count.is_multiple_of(2)
            && backslash_count.is_multiple_of(2)
        {
            end = index;
            break;
        }
        if *byte == b'\\' {
            backslash_count += 1;
        } else {
            backslash_count = 0;
        }
    }
    line.truncate(end);
    while line.last().is_some_and(|byte| is_space(*byte)) {
        line.pop();
    }
    quote_count
}

/// `unescape_line`: drops every `"`, applies `\n \t \b \" \\`, fails on any other escape, and reports
/// a trailing backslash as a continuation.
fn unescape_line(text: &[u8]) -> Result<(Vec<u8>, bool), ConfigParseFailure> {
    let mut out = Vec::with_capacity(text.len());
    let mut bytes = text.iter();
    while let Some(byte) = bytes.next() {
        match byte {
            b'"' => {}
            b'\\' => match bytes.next() {
                None => return Ok((out, true)),
                Some(b'n') => out.push(b'\n'),
                Some(b't') => out.push(b'\t'),
                Some(b'b') => out.push(0x08),
                Some(b'"') => out.push(b'"'),
                Some(b'\\') => out.push(b'\\'),
                Some(_) => return Err(ConfigParseFailure),
            },
            other => out.push(*other),
        }
    }
    Ok((out, false))
}

/// `parse_variable` and `parse_multiline_variable`: `line` begins at the name. A continuation
/// consumes the following lines, which moves `index` to the last of them.
fn parse_variable(
    line: &[u8],
    lines: &[&[u8]],
    index: &mut usize,
) -> Result<Variable, ConfigParseFailure> {
    let mut line = line.to_vec();
    let quote_count = strip_comments(&mut line, 0);
    let name_end = line
        .iter()
        .position(|byte| !is_keychar(*byte))
        .unwrap_or(line.len());
    if name_end == 0 {
        return Err(ConfigParseFailure);
    }
    let name = str::from_utf8(&line[..name_end])
        .map_err(|_| ConfigParseFailure)?
        .to_string();
    let after_name = trim_start_space(&line[name_end..]);
    match after_name.first() {
        None => return Ok(Variable { name, value: None }),
        Some(b'=') => {}
        Some(_) => return Err(ConfigParseFailure),
    }
    let (mut value, mut continues) = unescape_line(trim_start_space(&after_name[1..]))?;
    let mut in_quotes = quote_count % 2;
    while continues {
        *index += 1;
        let Some(next) = lines.get(*index) else {
            break;
        };
        if next.is_empty() {
            break;
        }
        let mut next = next.to_vec();
        in_quotes = strip_comments(&mut next, in_quotes);
        if next.is_empty() {
            continue;
        }
        let (more, again) = unescape_line(&next)?;
        value.extend(more);
        continues = again;
    }
    Ok(Variable {
        name,
        value: Some(value),
    })
}

#[cfg(test)]
mod tests {
    use super::{ConfigParseFailure, Placement, ReferenceKind, SubmoduleSection, scan};

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
    fn test_a_value_beginning_tilde_slash_is_not_located_for_any_key() {
        for text in [
            "[include]\n\tpath = ~/x\n",
            "[core]\n\tworktree = ~/x\n",
            "[core]\n\texcludesfile = ~/x\n",
            "[core]\n\tattributesfile = ~/x\n",
        ] {
            assert_eq!(one(text).3, Placement::NotLocated, "{text:?}");
        }
        assert_eq!(
            one("[include]\n\tpath = ~x\n").3,
            Placement::FromTheFile,
            "only ~/ is a home spelling"
        );
    }

    #[test]
    fn test_a_relative_excludesfile_or_attributesfile_is_not_located_and_an_absolute_one_is_not() {
        assert_eq!(
            one("[core]\n\texcludesfile = rel/x\n").3,
            Placement::NotLocated
        );
        assert_eq!(
            one("[core]\n\tattributesfile = rel/x\n").3,
            Placement::NotLocated
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

    /// The `[submodule]` sections of `text`.
    fn sections(text: &str) -> Vec<SubmoduleSection> {
        scan(text.as_bytes()).expect("the text parses").sections
    }

    /// A section's `path` entries as `(key, value)`.
    fn path_entries(section: &SubmoduleSection) -> Vec<(&str, &[u8])> {
        section
            .paths
            .iter()
            .map(|path| (path.key.as_str(), path.value.as_slice()))
            .collect()
    }

    #[test]
    fn test_one_record_per_submodule_header_in_file_order() {
        let found = sections("[submodule \"a\"]\n\tpath = x\n[submodule \"b\"]\n\tpath = y\n");
        let names: Vec<_> = found
            .iter()
            .map(|found| found.written_name.as_str())
            .collect();
        assert_eq!(names, ["a", "b"]);
        assert_eq!(
            path_entries(&found[0]),
            [("submodule.a.path", b"x".as_slice())]
        );
        assert_eq!(
            path_entries(&found[1]),
            [("submodule.b.path", b"y".as_slice())]
        );
    }

    #[test]
    fn test_section_word_and_written_name_are_as_written() {
        let found = sections("[Submodule \"MixedCase\"]\n\tPath = x\n");
        assert_eq!(found.len(), 1);
        assert_eq!(found[0].word, "Submodule");
        assert_eq!(found[0].written_name, "MixedCase");
        assert_eq!(
            path_entries(&found[0]),
            [("Submodule.MixedCase.Path", b"x".as_slice())]
        );
    }

    #[test]
    fn test_stored_name_keeps_quoted_subsection_case_and_unescapes_quotes() {
        let found = sections("[submodule \"A\\\"b\"]\n\tpath = x\n");
        assert_eq!(found[0].stored_name, b"A\"b");
        assert_eq!(found[0].written_name, "A\"b");
    }

    #[test]
    fn test_legacy_dotted_header_stores_lowercased_name() {
        let found = sections("[submodule.X]\n\tpath = y\n");
        assert_eq!(found.len(), 1);
        assert_eq!(found[0].word, "submodule");
        assert_eq!(found[0].stored_name, b"x");
        assert_eq!(found[0].written_name, "X");
        assert_eq!(
            path_entries(&found[0]),
            [("submodule.X.path", b"y".as_slice())]
        );
    }

    #[test]
    fn test_header_only_section_has_empty_path_list() {
        let found = sections("[submodule \"only\"]\n\turl = /somewhere\n");
        assert_eq!(found.len(), 1);
        assert_eq!(found[0].written_name, "only");
        assert!(found[0].paths.is_empty());
    }

    #[test]
    fn test_two_path_entries_under_one_header_are_both_kept_in_order() {
        let found = sections("[submodule \"a\"]\n\tpath = one\n\tpath = two\n");
        assert_eq!(found.len(), 1);
        let values: Vec<_> = found[0]
            .paths
            .iter()
            .map(|entry| entry.value.as_slice())
            .collect();
        assert_eq!(values, [b"one".as_slice(), b"two".as_slice()]);
    }

    #[test]
    fn test_path_without_equals_is_an_empty_value() {
        let found = sections("[submodule \"a\"]\n\tpath\n");
        assert_eq!(
            path_entries(&found[0]),
            [("submodule.a.path", b"".as_slice())]
        );
    }

    #[test]
    fn test_non_utf8_subsection_keeps_bytes_as_stored_name_and_is_lossy_in_written_name() {
        let mut text = b"[submodule \"a".to_vec();
        text.extend_from_slice(&[0xFF, 0xFE]);
        text.extend_from_slice(b"b\"]\n\tpath = x\n");
        let found = scan(&text).expect("parses").sections;
        assert_eq!(found.len(), 1);
        assert_eq!(found[0].stored_name, [b'a', 0xFF, 0xFE, b'b']);
        assert_eq!(found[0].written_name, "a\u{FFFD}\u{FFFD}b");
    }

    #[test]
    fn test_submodule_section_beside_include_leaves_references_as_before() {
        let scanned =
            scan(b"[include]\n\tpath = inc\n[submodule \"a\"]\n\tpath = x\n").expect("parses");
        assert_eq!(scanned.references.len(), 1);
        assert_eq!(scanned.references[0].key, "include.path");
        assert_eq!(scanned.sections.len(), 1);
    }

    /// Design § 3 A1: a record holds each `path` entry *under that header*, so a `path` under a
    /// later header of another section stays out of it.
    #[test]
    fn test_a_path_under_a_later_other_header_does_not_join_the_submodule_record() {
        let found = sections(
            "[submodule \"a\"]\n\tpath = x\n[include]\n\tpath = inc\n[core]\n\tpath = z\n",
        );
        assert_eq!(found.len(), 1);
        assert_eq!(
            path_entries(&found[0]),
            [("submodule.a.path", b"x".as_slice())]
        );
    }

    #[test]
    fn test_unparsable_header_is_still_a_parse_failure() {
        assert_eq!(
            scan(b"[submodule \"a]\n\tpath = x\n").err(),
            Some(ConfigParseFailure)
        );
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
