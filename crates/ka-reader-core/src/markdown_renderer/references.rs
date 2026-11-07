//! What an image or a link reference comes to. The scheme test runs first, so a scheme reference
//! never reaches the containment check; every other reference is decided by the check's answer.

use std::path::Path;

use super::{ImageTarget, LinkTarget, PlaceholderCondition};
use crate::{Condition, ContainmentCheck, EntryKind};

/// The extensions of the four bitmap formats a surface can decode, compared without ASCII case.
const BITMAP_EXTENSIONS: [&str; 5] = ["png", "jpg", "jpeg", "gif", "webp"];

/// Whether `reference` begins with a scheme: a letter, then letters, digits, `+`, `-` or `.`, then
/// `:`.
fn begins_with_scheme(reference: &str) -> bool {
    let mut characters = reference.chars();
    if !characters
        .next()
        .is_some_and(|first| first.is_ascii_alphabetic())
    {
        return false;
    }
    for character in characters {
        if character == ':' {
            return true;
        }
        if !(character.is_ascii_alphanumeric() || matches!(character, '+' | '-' | '.')) {
            return false;
        }
    }
    false
}

/// Whether `path` names one of the bitmap formats, by its extension and without ASCII case. The one
/// list of formats: it decides a resolved image node and the bytes `folder-model` hands a surface.
pub(crate) fn is_bitmap(path: &Path) -> bool {
    path.extension()
        .and_then(|extension| extension.to_str())
        .is_some_and(|extension| {
            BITMAP_EXTENSIONS
                .iter()
                .any(|known| known.eq_ignore_ascii_case(extension))
        })
}

/// The one placeholder condition each refusal the check can observe lands on. The match names every
/// condition, so a new one is a compile error here.
fn condition_of(refusal: Condition) -> PlaceholderCondition {
    match refusal {
        Condition::Outside => PlaceholderCondition::OutsideTheFolder,
        Condition::Missing | Condition::NotAFolder => PlaceholderCondition::Missing,
        Condition::Cycle | Condition::TooManyLinks | Condition::Unreadable => {
            PlaceholderCondition::Unreadable
        }
    }
}

/// The image a reference came to. `source` goes to the check whole, as the parser gave it.
pub(super) fn image_target(
    check: &impl ContainmentCheck,
    folder: &Path,
    source: &str,
) -> ImageTarget {
    let placeholder = |condition| ImageTarget::Placeholder {
        condition,
        source: source.to_string(),
    };
    if begins_with_scheme(source) {
        return placeholder(PlaceholderCondition::OutsideTheFolder);
    }
    match check.check(folder, source) {
        Err(refusal) => placeholder(condition_of(refusal)),
        Ok(entry) => match entry.kind {
            EntryKind::Folder => placeholder(PlaceholderCondition::Missing),
            EntryKind::File if is_bitmap(&entry.path) => ImageTarget::Resolved(entry.path),
            EntryKind::File => placeholder(PlaceholderCondition::FormatNotDecoded),
        },
    }
}

/// The link a destination came to. A scheme and a fragment alone are external without a call; any
/// other destination goes to the check by its path, the part before the first `#`, and is relative
/// when the check reaches an entry and external when it does not.
pub(super) fn link_target(
    check: &impl ContainmentCheck,
    folder: &Path,
    destination: &str,
) -> LinkTarget {
    if destination.starts_with('#') || begins_with_scheme(destination) {
        return LinkTarget::External;
    }
    let path = destination
        .split_once('#')
        .map_or(destination, |(path, _fragment)| path);
    match check.check(folder, path) {
        Ok(entry) => LinkTarget::Relative(entry.path),
        Err(_) => LinkTarget::External,
    }
}
