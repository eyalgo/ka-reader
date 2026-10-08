import Foundation

/// The Open panel: asks for a folder and answers with what was chosen, or `nil` on a cancel.
@MainActor
package protocol FolderChoosing {
    func chooseFolder() -> URL?
}
