import AppKit

/// The startup content for a launch that has not reached the workbench: the projection it was
/// handed, drawn as one column from the surface's top-left — a status message led by its glyph,
/// then the routes, each a borderless button drawn as its title alone.
///
/// The surface takes the size it is given and asks for none. A path taller than the room the
/// column has gives way — its region stops at that room and the text past it is not drawn — and
/// the sentence and the routes beneath it stay whole (change_design.md § Architect Review Notes,
/// *CP-243's domain*).
@MainActor
package final class StartupView: NSView {
    private static let browseTitle = "Browse…"
    private static let quitTitle = "Quit"

    /// `docs/DESIGN.md`'s `{spacing.xl}`: how far the column stands in from the surface's edges,
    /// which is a status message's inset (§ *Components* "Status messages").
    private static let columnInset: CGFloat = 24

    /// `docs/DESIGN.md`'s `{spacing.sm}`: the gap between one element of the column and the next.
    private static let elementSpacing: CGFloat = 8

    private let onIntent: (StartupIntent) -> Void

    /// Draws the opening projection and sends route activations to the supplied intent sink.
    package init(
        projection: StartupProjection, glyphs: StatusGlyphs,
        onIntent: @escaping (StartupIntent) -> Void
    ) {
        self.onIntent = onIntent
        super.init(frame: .zero)
        place(makeColumn(of: makeElements(for: projection, glyphs: glyphs)))
    }

    @available(*, unavailable)
    package required init?(coder: NSCoder) {
        preconditionFailure("StartupView is built in code only")
    }

    /// The status message, then the routes beneath it. An empty or pending state leads with the
    /// empty glyph and a failure with the failure glyph (CP-256; § *Components* "Status messages").
    private func makeElements(for projection: StartupProjection, glyphs: StatusGlyphs) -> [NSView] {
        switch projection {
        case .empty:
            return [message(glyphs.empty, OpeningSentences.empty)] + makeRoutes()
        case .reading:
            return [message(glyphs.empty, ConditionSentences.readingFolder)]
        case .failed(let path, let condition):
            let sentence = OpeningSentences.observedFailure(for: condition)
            return [message(glyphs.failure, sentence, path: path)] + makeRoutes()
        case .stopped(let path):
            return [message(glyphs.failure, OpeningSentences.stopped, path: path)] + makeRoutes()
        }
    }

    /// A status message: the path above the sentence when there is one, both beside the glyph.
    private func message(_ glyph: NSImage, _ sentence: String, path: String? = nil) -> NSView {
        let texts =
            (path.map { [makePathLabel($0)] } ?? []) + [NSTextField(labelWithString: sentence)]
        return StatusMessageView(glyph: glyph, texts: texts)
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

    /// The two routes, which are the only way this surface raises an intent. Each is text alone:
    /// no border, no bezel and no glyph (CP-259; § *Components* "The startup surface").
    private func makeRoutes() -> [NSView] {
        [
            makeRoute(titled: Self.browseTitle, action: #selector(browse)),
            makeRoute(titled: Self.quitTitle, action: #selector(quit)),
        ]
    }

    private func makeRoute(titled title: String, action: Selector) -> NSButton {
        let route = NSButton(title: title, target: self, action: action)
        route.isBordered = false
        return route
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
