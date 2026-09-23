import Foundation

/// The Open panel: asks for a folder and answers with what was chosen, or `nil` on a cancel.
@MainActor
public protocol FolderChoosing {
    func chooseFolder() -> URL?
}
