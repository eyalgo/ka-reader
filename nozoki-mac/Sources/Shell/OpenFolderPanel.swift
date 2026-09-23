import AppKit

/// The real Open panel. It chooses exactly one directory: files cannot be chosen and multiple
/// selection is off, as `pick_folder()` was before the native shell (CP-89).
@MainActor
public struct OpenFolderPanel: FolderChoosing {
    public init() {}

    public func chooseFolder() -> URL? {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        return panel.runModal() == .OK ? panel.url : nil
    }
}
