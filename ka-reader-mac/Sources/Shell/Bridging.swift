import Foundation

/// The five exported functions, and nothing else (CP-86, CP-97).
///
/// A `nil` return is the bridge's failure value: a panic was caught or no buffer could be made.
/// Every non-`nil` buffer is released once with `free`, and a `nil` is never released.
///
/// It is `Sendable` because a folder read runs it on a background queue (`ReadRunning`); every
/// method is callable off the main actor.
package protocol Bridging: Sendable {
    /// `ka_reader_open_folder`. Cancellation is handled before this boundary.
    func openFolder(location: URL) -> BridgeBuffer?

    /// `ka_reader_list_tree`. The empty path is the root.
    func listTree(path: String) -> BridgeBuffer?

    /// `ka_reader_select_file`. The path is relative to the open folder's root.
    func selectFile(path: String) -> BridgeBuffer?

    /// `ka_reader_read_git`. It takes no argument: the open folder is the one read.
    func readGit() -> BridgeBuffer?

    /// `ka_reader_free`.
    func free(_ buffer: BridgeBuffer)
}
