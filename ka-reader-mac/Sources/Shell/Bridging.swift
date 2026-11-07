import Foundation
import Surfaces

/// What the reader did to a file: selected it by a click, opened it by that click, or moved the
/// position in the open file. A click crosses as the selection act first, then the open.
package enum FileAct: Sendable {
    case open
    case position
    case select
}

/// The seven exported functions, and nothing else (CP-86, CP-97).
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

    /// `ka_reader_select_file`. The path is relative to the open folder's root; the act is what the
    /// reader did to the file, and the position is the wire form `BridgePayload.encodePosition`
    /// writes. The selection act carries one too, and the bridge does not read it.
    func selectFile(path: String, act: FileAct, position: String) -> BridgeBuffer?

    /// `ka_reader_read_git`. It takes no argument: the open folder is the one read.
    func readGit() -> BridgeBuffer?

    /// `ka_reader_asset_bytes`. The path is a resolved image's folder-relative path. A refusal is a
    /// buffer whose `isRefusal` is true; `nil` is the bridge's failure value.
    func assetBytes(path: String) -> BridgeBuffer?

    /// `ka_reader_open_relative_link`. The path is a relative link's target path, never its
    /// destination. The call admits the link's selection act and reads the target in one call.
    func openRelativeLink(path: String) -> BridgeBuffer?

    /// `ka_reader_free`.
    func free(_ buffer: BridgeBuffer)
}
