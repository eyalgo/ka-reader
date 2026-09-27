import AppKit

/// The startup content for a launch that has not reached the workbench.
@MainActor
package final class StartupView: NSView {
    package private(set) var drawnText: [String]
    package private(set) var availableIntents: [StartupIntent]

    private let onIntent: (StartupIntent) -> Void

    package init(projection: StartupProjection, onIntent: @escaping (StartupIntent) -> Void) {
        self.onIntent = onIntent
        switch projection {
        case .empty:
            drawnText = [OpeningSentences.empty, "Browse…", "Quit"]
            availableIntents = [.browse, .quit]
        case .reading:
            drawnText = [ConditionSentences.readingFolder]
            availableIntents = []
        case .failed(let path, let condition):
            drawnText = [path, OpeningSentences.observedFailure(for: condition), "Browse…", "Quit"]
            availableIntents = [.browse, .quit]
        case .stopped(let path):
            drawnText = [path, OpeningSentences.stopped, "Browse…", "Quit"]
            availableIntents = [.browse, .quit]
        }
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    package required init?(coder: NSCoder) {
        preconditionFailure("StartupView is built in code only")
    }

    /// Emits a control intent without performing its composition-root action.
    package func activate(_ intent: StartupIntent) {
        guard availableIntents.contains(intent) else { return }
        onIntent(intent)
    }
}
