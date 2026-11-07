/// Every sentence this surface shows for a condition or for the root, and the only place those
/// strings exist (CP-185).
///
/// The row sentences are `docs/CONTENT.md` v7's, § Message patterns, *Partial* (CP-203).
package nonisolated enum ConditionSentences {
    /// The line for a root that could not be read, whatever the condition.
    package static let failedRoot = "KA-Reader can't read this folder."

    /// The line for a root that was read and holds nothing (`docs/CONTENT.md`).
    package static let emptyRoot = "This folder has no files."

    /// The line drawn beneath a folder while its read is out (`docs/CONTENT.md`, *Loading*).
    package static let readingFolder = "Reading this folder."

    /// The sentence the reading panel draws while a selected file's read is out (`docs/CONTENT.md`,
    /// *Loading*).
    package static let readingFile = "Reading this file."

    /// The sentence the reading panel draws under the path of a file whose read answered nothing
    /// (`docs/CONTENT.md` § Message patterns, *Error — an unexplained fault*): no cause, no code.
    package static let stoppedReadingFile =
        "KA-Reader stopped while reading this file and can't tell why. "
        + "The rest of the folder is still readable — select another file."

    /// The sentence the reading panel draws beneath the path line when a re-read of the open file
    /// found nothing at its path (`docs/CONTENT.md` § Message patterns, *Recovered*, and the UX-S1
    /// file-gone row).
    ///
    /// Shown in the reading panel, beneath the path line, when the file the reader has open is read
    /// again after the folder changed and nothing is at its path: the file was deleted, renamed or
    /// moved away, or a folder above it was removed or replaced. It names no cause, because those
    /// cases look the same to KA-Reader. It has no placeholder. It is not the sentence for a
    /// selection whose read found no file.
    package static let fileGone = "This file is no longer there."

    /// The line drawn beneath a folder that was read and holds nothing.
    package static let emptyFolder = emptyRoot

    /// The box's sentence for an image outside the folder: a remote address, a path that climbs
    /// out of the folder, or a link inside it that leads out. Shown when the reader is on a
    /// rendered Markdown page whose image KA-Reader did not try to read. It has no placeholder.
    package static let imageOutsideTheFolder =
        "This image is outside the folder you opened, so KA-Reader doesn't read it."

    /// The box's sentence for an image that points inside the folder where no file is: nothing at
    /// that path, or a folder. It has no placeholder.
    package static let imageMissing = "There's no file where this image points."

    /// The box's sentence for an image inside the folder that did not draw: its file could not be
    /// read, the panel's ask for its bytes got none, or the bytes make no image. One sentence for
    /// all three, whether KA-Reader learned it before or while it drew the page. It has no
    /// placeholder.
    package static let imageUnreadable = "KA-Reader can't read this image."

    /// The box's sentence for an image inside the folder in a format KA-Reader does not show, such
    /// as an SVG. It has no placeholder.
    package static let imageFormatNotDecoded = "KA-Reader doesn't show images in this format."

    /// The sentence for the box where an image with `condition` would sit. The switch has no
    /// `default`, so a fifth condition fails to compile here instead of drawing no sentence.
    package static func imagePlaceholder(for condition: ImagePlaceholderCondition) -> String {
        switch condition {
        case .outsideTheFolder:
            return imageOutsideTheFolder
        case .missing:
            return imageMissing
        case .unreadable:
            return imageUnreadable
        case .formatNotDecoded:
            return imageFormatNotDecoded
        }
    }

    /// The sentence shown on the row of an entry that failed with `condition`.
    package static func row(for condition: Condition) -> String {
        switch condition {
        case .unreadable, .notAFolder:
            return "KA-Reader can't read this folder."
        case .outside:
            return "This link leads outside the folder you opened, so KA-Reader doesn't read it."
        case .cycle:
            return "This link loops back on itself, so KA-Reader can't read it."
        case .missing:
            return "This link leads to something that isn't there."
        case .tooManyLinks:
            return "This link leads through more links than KA-Reader follows."
        }
    }

    /// The one sentence drawn beneath the path line of a file that is not text (`docs/CONTENT.md`
    /// § Terminology: *can't be shown as text*, said of the file). Both reasons read the same: the
    /// reader is told what KA-Reader observed about the file, not how it is encoded.
    package static func cannotDisplay(fileNamed name: String) -> String {
        "\(name) can't be shown as text."
    }

    /// The statement drawn beneath the path line of a file whose read failed with `condition`:
    /// what KA-Reader observed, naming the file, in one sentence (`docs/CONTENT.md` § Message
    /// patterns, *Error — an observed condition*). The switch has no `default`, so a seventh
    /// condition fails to compile here instead of drawing nothing.
    package static func reading(fileNamed name: String, failedWith condition: Condition) -> String {
        switch condition {
        case .unreadable, .notAFolder:
            return "KA-Reader can't read \(name)."
        case .outside:
            return
                "\(name) is a link that leads outside the folder you opened, so KA-Reader doesn't read it."
        case .cycle:
            return "\(name) is a link that loops back on itself, so KA-Reader can't read it."
        case .missing:
            // Not "no longer there": this condition also reaches a link whose target was missing
            // when its folder was listed, and that sentence would claim the target was once there
            // (`docs/CONTENT.md` § Message patterns, *Partial*). This one holds for both.
            return "KA-Reader looked for \(name) and didn't find it."
        case .tooManyLinks:
            return "\(name) leads through more links than KA-Reader follows."
        }
    }
}
