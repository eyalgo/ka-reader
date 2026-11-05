import Foundation
import Surfaces

/// The five exported functions, and nothing else (CP-86, CP-97).
///
/// A `nil` return is the bridge's failure value: a panic was caught or no buffer could be made.
/// Every non-`nil` buffer is released once with `free`, and a `nil` is never released.
///
/// It is `Sendable` because a folder read runs it on a background queue (`ReadRunning`); every
/// method is callable off the main actor.
package protocol Bridging: Sendable {
    /// `ka_reader_open_folder`. Cancellation is handled before this boundary. A receiver, when
    /// given, is handed every model change the disk causes after a successful open; `nil` opens
    /// with no subscription and no delivery.
    func openFolder(location: URL, changes: ModelChangesReceiver?) -> BridgeBuffer?

    /// `ka_reader_list_tree`. The empty path is the root; the act is what the reader did.
    func listTree(path: String, act: DisclosureAct) -> BridgeBuffer?

    /// `ka_reader_select_file`. The path is relative to the open folder's root.
    func selectFile(path: String) -> BridgeBuffer?

    /// `ka_reader_read_git`. It takes no argument: the open folder is the one read.
    func readGit() -> BridgeBuffer?

    /// `ka_reader_free`.
    func free(_ buffer: BridgeBuffer)
}
