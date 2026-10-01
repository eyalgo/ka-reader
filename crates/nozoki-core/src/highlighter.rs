//! The highlighter: a text and a floor language become the byte ranges of its tokens, each in one
//! of the five classes DESIGN draws (`docs/DESIGN.md:L390-L393`).
//!
//! The engine is tree-sitter. Each grammar and the nozoki-owned query beside this file are compiled
//! in, so nothing is loaded at run time, and nothing here reads a file, an environment variable or
//! the network (CP-295, CP-300). This module imports `language` and the engine crates and nothing
//! else of the crate (NFDR QC-11).

use std::sync::OnceLock;

use tree_sitter_highlight::{Highlight, HighlightConfiguration, HighlightEvent, Highlighter};

use crate::language::Language;

/// What a token is drawn as (CP-296). Punctuation, operators and everything else have no class.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum TokenClass {
    Keyword,
    String,
    Number,
    Comment,
    Name,
}

/// One token: the byte range `[start, end)` of the highlighted text, and its class.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Span {
    pub start: usize,
    pub end: usize,
    pub class: TokenClass,
}

/// The capture names every query uses, in the order the engine numbers them, with the class each
/// one is. A query capture outside this list maps to no class and so to no span.
const CAPTURE_CLASSES: [(&str, TokenClass); 5] = [
    ("keyword", TokenClass::Keyword),
    ("string", TokenClass::String),
    ("number", TokenClass::Number),
    ("comment", TokenClass::Comment),
    ("name", TokenClass::Name),
];

/// The six floor languages, in the order of `CONFIGURATIONS`.
const FLOOR_LANGUAGE_COUNT: usize = 6;

/// One compiled configuration per floor language, built on first use and then shared. `None` records
/// a configuration the engine refused, which answers no spans and never a panic (CP-298).
static CONFIGURATIONS: [OnceLock<Option<HighlightConfiguration>>; FLOOR_LANGUAGE_COUNT] =
    [const { OnceLock::new() }; FLOOR_LANGUAGE_COUNT];

/// The token spans of `text` read as `language`, in ascending order and never overlapping.
///
/// Each span is a non-empty byte range inside `text` whose ends fall on character boundaries, with
/// exactly one [`TokenClass`]. `Plain` and the empty text give no span. A text that is invalid in its
/// language, cut off partway through a construct, or in a different language still gets an answer,
/// possibly with no spans: no input makes this fail. The same two inputs always give the same spans.
///
/// # Examples
///
/// ```
/// use nozoki_core::{Language, TokenClass, highlight};
///
/// let spans = highlight("x = 1  # one", Language::Python);
/// assert!(spans.iter().any(|span| span.class == TokenClass::Number));
/// assert!(spans.iter().any(|span| span.class == TokenClass::Comment));
///
/// assert!(highlight("x = 1", Language::Plain).is_empty());
/// ```
pub fn highlight(text: &str, language: Language) -> Vec<Span> {
    if text.is_empty() {
        return Vec::new();
    }
    let Some(configuration) = configuration_of(language) else {
        return Vec::new();
    };
    spans_of(text, configuration)
}

/// The compiled configuration for a floor language, or `None` for `Plain` and for a language whose
/// configuration the engine refused.
fn configuration_of(language: Language) -> Option<&'static HighlightConfiguration> {
    let (index, build): (usize, fn() -> Option<HighlightConfiguration>) = match language {
        Language::Python => (0, python_configuration),
        Language::Shell => (1, shell_configuration),
        Language::JavaScript => (2, javascript_configuration),
        Language::Json => (3, json_configuration),
        Language::Yaml => (4, yaml_configuration),
        Language::Toml => (5, toml_configuration),
        Language::Plain => return None,
    };
    CONFIGURATIONS[index].get_or_init(build).as_ref()
}

fn python_configuration() -> Option<HighlightConfiguration> {
    configuration(
        tree_sitter_python::LANGUAGE.into(),
        "python",
        include_str!("highlighter/queries/python.scm"),
    )
}

fn shell_configuration() -> Option<HighlightConfiguration> {
    configuration(
        tree_sitter_bash::LANGUAGE.into(),
        "shell",
        include_str!("highlighter/queries/shell.scm"),
    )
}

fn javascript_configuration() -> Option<HighlightConfiguration> {
    configuration(
        tree_sitter_javascript::LANGUAGE.into(),
        "javascript",
        include_str!("highlighter/queries/javascript.scm"),
    )
}

fn json_configuration() -> Option<HighlightConfiguration> {
    configuration(
        tree_sitter_json::LANGUAGE.into(),
        "json",
        include_str!("highlighter/queries/json.scm"),
    )
}

fn yaml_configuration() -> Option<HighlightConfiguration> {
    configuration(
        tree_sitter_yaml::LANGUAGE.into(),
        "yaml",
        include_str!("highlighter/queries/yaml.scm"),
    )
}

fn toml_configuration() -> Option<HighlightConfiguration> {
    configuration(
        tree_sitter_toml_ng::LANGUAGE.into(),
        "toml",
        include_str!("highlighter/queries/toml.scm"),
    )
}

/// A grammar and its query compiled together and told the five capture names. No injection query and
/// no locals query: a language inside another is not highlighted (CP-300), and names are not tracked.
fn configuration(
    grammar: tree_sitter::Language,
    name: &str,
    query: &str,
) -> Option<HighlightConfiguration> {
    let mut configuration = HighlightConfiguration::new(grammar, name, query, "", "")
        .inspect_err(|error| log::warn!("highlighter: {name} query refused: {error}"))
        .ok()?;
    let capture_names = CAPTURE_CLASSES.map(|(capture_name, _)| capture_name);
    configuration.configure(&capture_names);
    Some(configuration)
}

/// Walks the engine's events with a stack of open highlights. A piece of source takes the innermost
/// open class; a piece with no class is dropped, and so is an empty one or one whose ends are not
/// character boundaries, which makes CP-296 hold by construction. An engine error ends the walk and
/// keeps the spans gathered so far.
fn spans_of(text: &str, configuration: &HighlightConfiguration) -> Vec<Span> {
    let mut highlighter = Highlighter::new();
    let events = match highlighter.highlight(configuration, text.as_bytes(), None, None, |_| None) {
        Ok(events) => events,
        Err(error) => {
            log::warn!("highlighter: engine refused to start: {error}");
            return Vec::new();
        }
    };

    let mut open_classes: Vec<TokenClass> = Vec::new();
    let mut spans = Vec::new();
    for event in events {
        match event {
            Ok(HighlightEvent::HighlightStart(Highlight(capture))) => {
                match CAPTURE_CLASSES.get(capture) {
                    Some((_, class)) => open_classes.push(*class),
                    None => return spans,
                }
            }
            Ok(HighlightEvent::HighlightEnd) => {
                open_classes.pop();
            }
            Ok(HighlightEvent::Source { start, end }) => {
                if let Some(class) = open_classes.last()
                    && start < end
                    && text.is_char_boundary(start)
                    && text.is_char_boundary(end)
                {
                    spans.push(Span {
                        start,
                        end,
                        class: *class,
                    });
                }
            }
            Err(error) => {
                log::warn!("highlighter: engine stopped early, keeping the spans so far: {error}");
                return spans;
            }
        }
    }
    spans
}
