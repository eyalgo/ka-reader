import AppKit

/// One of the Git view's two lists (*Staged*, *Changes*).
@MainActor
final class GitRowList: NSView {
    /// How many rows are kept realized past each edge of the visible rect.
    static let overscan = 4
}
