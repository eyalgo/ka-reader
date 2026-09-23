import Foundation

/// The three exported functions, and nothing else (CP-86, CP-97).
///
/// A `nil` return is the bridge's failure value: a panic was caught or no buffer could be made.
/// Every non-`nil` buffer is released once with `free`, and a `nil` is never released.
package protocol Bridging {
    /// `nozoki_open_folder`. A `nil` `location` is a cancelled panel.
    func openFolder(location: URL?) -> BridgeBuffer?

    /// `nozoki_list_tree`. The empty path is the root.
    func listTree(path: String) -> BridgeBuffer?

    /// `nozoki_free`.
    func free(_ buffer: BridgeBuffer)
}
