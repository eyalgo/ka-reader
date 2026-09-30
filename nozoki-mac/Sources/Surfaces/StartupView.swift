import AppKit

/// The startup content for a launch that has not reached the workbench: the projection it was
/// handed, drawn as one column of labels and buttons from the surface's top-left.
///
/// The surface takes the size it is given and asks for none. A path taller than the room the
/// column has gives way — its region stops at that room and the text past it is not drawn — and
/// the sentence and the routes beneath it stay whole (change_design.md § Architect Review Notes,
/// *CP-243's domain*).
@MainActor
package final class StartupView: NSView {
    private static let browseTitle = "Browse…"
    private static let quitTitle = "Quit"

    /// `docs/DESIGN.md`'s `{spacing.xl}`: how far the column stands in from the surface's edges.
    private static let columnInset: CGFloat = 24

    /// `docs/DESIGN.md`'s `{spacing.sm}`: the gap between one element of the column and the next.
    private static let elementSpacing: CGFloat = 8

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
        place(makeColumn(of: makeElements(for: projection)))
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

    private func makeElements(for projection: StartupProjection) -> [NSView] {
        switch projection {
        case .empty:
            return [NSTextField(labelWithString: OpeningSentences.empty)] + makeRoutes()
        case .reading:
            return [NSTextField(labelWithString: ConditionSentences.readingFolder)]
        case .failed(let path, let condition):
            let sentence = OpeningSentences.observedFailure(for: condition)
            return [makePathLabel(path), NSTextField(labelWithString: sentence)] + makeRoutes()
        case .stopped(let path):
            return [makePathLabel(path), NSTextField(labelWithString: OpeningSentences.stopped)]
                + makeRoutes()
        }
    }

    /// The path as one text element holding the string it was handed, wrapping at any character.
    private func makePathLabel(_ path: String) -> NSTextField {
        let label = NSTextField(labelWithString: path)
        label.lineBreakMode = .byCharWrapping
        label.maximumNumberOfLines = 0
        // A path is one unbroken line until it is wrapped, so at the default priority its one-line
        // width became the surface's: 12841 points for 1023 `W` in a 480-point window.
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        // Below the priority a host holds the surface's size with, so a path taller than the room
        // left is the one element that gives way. At the default it outweighed the host, and the
        // surface grew to 16520 points for 1023 line-feeds, taking the routes out of the window.
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return label
    }

    /// The two routes, which are the only way this surface raises an intent.
    private func makeRoutes() -> [NSView] {
        [
            NSButton(title: Self.browseTitle, target: self, action: #selector(browse)),
            NSButton(title: Self.quitTitle, target: self, action: #selector(quit)),
        ]
    }

    @objc private func browse() {
        onIntent(.browse)
    }

    @objc private func quit() {
        onIntent(.quit)
    }

    private func makeColumn(of elements: [NSView]) -> NSStackView {
        let column = NSStackView(views: elements)
        column.orientation = .vertical
        column.alignment = .leading
        column.spacing = Self.elementSpacing
        return column
    }

    private func place(_ column: NSStackView) {
        column.translatesAutoresizingMaskIntoConstraints = false
        addSubview(column)
        // The column is bounded by the surface's bottom and trailing edges and pinned to neither:
        // pinned, a short column would be stretched to the surface's height.
        NSLayoutConstraint.activate([
            column.topAnchor.constraint(equalTo: topAnchor, constant: Self.columnInset),
            column.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Self.columnInset),
            column.bottomAnchor.constraint(
                lessThanOrEqualTo: bottomAnchor, constant: -Self.columnInset),
            column.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor, constant: -Self.columnInset),
        ])
    }
}
