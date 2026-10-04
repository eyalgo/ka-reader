import AppKit

/// The letter a point lies on, as a host's lookup answers it: the letter's view, and the full text
/// of the tooltip it raises.
package struct LetterUnderPointer {
    package let letter: NSView
    package let text: String

    package init(letter: NSView, text: String) {
        self.letter = letter
        self.text = text
    }
}

/// A one-shot, cancellable schedule: it runs one action after an interval and hands back what
/// cancels it. `live` is the main run loop's; a test passes a double that fires on demand, because
/// the test windows run no run loop.
package struct TooltipRest {
    package typealias Cancel = @MainActor () -> Void

    package let schedule:
        @MainActor (_ interval: TimeInterval, _ action: @escaping @MainActor () -> Void) -> Cancel

    package init(
        schedule:
            @escaping @MainActor (
                _ interval: TimeInterval, _ action: @escaping @MainActor () -> Void
            )
            -> Cancel
    ) {
        self.schedule = schedule
    }

    /// Runs the action once on the main run loop, in the common modes so a rest completes while the
    /// run loop tracks a scroll or a drag.
    package static let live = TooltipRest { interval, action in
        let timer = Timer(timeInterval: interval, repeats: false) { _ in
            MainActor.assumeIsolated { action() }
        }
        RunLoop.main.add(timer, forMode: .common)
        return { timer.invalidate() }
    }
}

/// How the tooltip is drawn, `docs/DESIGN.md` § Components "The tooltip" (CP-590): the system font
/// at 13 points, regular, `{spacing.xs}` padding, `{rounded.sm}` corners and a 1 point hairline.
enum TooltipStyle {
    static let font = NSFont.systemFont(ofSize: 13, weight: .regular)
    static let padding: CGFloat = 4
    static let cornerRadius: CGFloat = 3
    static let hairlineWidth: CGFloat = 1
}

/// The drawn tooltip: one unwrapped line on a ground with a hairline, no shadow. It is never a
/// target (its hit test answers nothing, so a press reaches what lies beneath it), and it has no
/// animator, so it appears and leaves in place. Its ground and hairline are resolved under the
/// view's own appearance each time it joins a host or the appearance changes, and its ink is a
/// dynamic colour resolved when drawn, so it holds in both themes.
final class LetterTooltipView: NSView {
    let label: NSTextField

    init(text: String) {
        label = NSTextField(labelWithString: text)
        label.font = TooltipStyle.font
        label.textColor = CodeColors.primary
        label.maximumNumberOfLines = 1
        label.lineBreakMode = .byClipping
        label.cell?.wraps = false
        label.sizeToFit()
        let padding = TooltipStyle.padding
        super.init(
            frame: NSRect(
                x: 0, y: 0, width: label.frame.width + 2 * padding,
                height: label.frame.height + 2 * padding))
        label.frame.origin = NSPoint(x: padding, y: padding)
        addSubview(label)
        wantsLayer = true
        layer?.cornerRadius = TooltipStyle.cornerRadius
        layer?.borderWidth = TooltipStyle.hairlineWidth
        layer?.shadowOpacity = 0
        refreshColours()
    }

    required init?(coder: NSCoder) { nil }

    override func hitTest(_ point: NSPoint) -> NSView? { nil }

    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        refreshColours()
    }

    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        refreshColours()
    }

    private func refreshColours() {
        effectiveAppearance.performAsCurrentDrawingAppearance {
            layer?.backgroundColor = CodeColors.surface.cgColor
            layer?.borderColor = CodeColors.line.cgColor
        }
    }
}

/// Raises a tooltip when the pointer rests on a status letter, and removes it when the pointer
/// leaves (CP-589). Each surface that draws letters holds one, bound to that surface as its host.
/// The host owns the lookup of which shown letter lies at a point; everything else is here.
///
/// The pointer reaches it only through the one tracking area it installs on the host. A rest is
/// keyed to the identity of the letter view it started on, and when it fires the lookup is asked
/// again for the point the pointer last had, so a letter that moved from under a resting pointer
/// shows nothing.
@MainActor
package final class LetterTooltip: NSResponder {
    /// The pointer's rest on a letter before the tooltip shows (`docs/DESIGN.md:L651`).
    package static let restInterval: TimeInterval = 0.5

    private weak var host: NSView?
    private let rest: TooltipRest
    private let letterAt: @MainActor (NSPoint) -> LetterUnderPointer?

    private var pointer: NSPoint?
    private var pendingLetter: NSView?
    private var cancelPending: TooltipRest.Cancel?
    private var shownLetter: NSView?
    private var shown: LetterTooltipView?

    /// The text of the tooltip showing now, for tests.
    package var shownText: String? { shown?.label.stringValue }
    /// The drawn tooltip while it shows, for tests.
    package var shownView: NSView? { shown }

    /// `letterAt` answers which shown letter lies at a point in host coordinates, or nil.
    package init(
        host: NSView, rest: TooltipRest,
        letterAt: @escaping @MainActor (NSPoint) -> LetterUnderPointer?
    ) {
        self.host = host
        self.rest = rest
        self.letterAt = letterAt
        super.init()
        host.addTrackingArea(
            NSTrackingArea(
                rect: .zero,
                options: [.mouseMoved, .mouseEnteredAndExited, .activeInKeyWindow, .inVisibleRect],
                owner: self, userInfo: nil))
    }

    required init?(coder: NSCoder) { nil }

    /// Cancels any pending rest and removes any shown tooltip, at once. A host calls it whenever a
    /// letter could have moved from under a resting pointer.
    package func dismiss() {
        cancelPending?()
        cancelPending = nil
        pendingLetter = nil
        shown?.removeFromSuperview()
        shown = nil
        shownLetter = nil
    }

    override package func mouseMoved(with event: NSEvent) { pointerMoved(event) }
    override package func mouseEntered(with event: NSEvent) { pointerMoved(event) }
    override package func mouseExited(with event: NSEvent) { dismiss() }

    private func pointerMoved(_ event: NSEvent) {
        guard let host else { return }
        let point = host.convert(event.locationInWindow, from: nil)
        pointer = point
        guard let under = letterAt(point) else {
            dismiss()
            return
        }
        if under.letter === shownLetter || under.letter === pendingLetter { return }
        dismiss()
        pendingLetter = under.letter
        let letter = under.letter
        cancelPending = rest.schedule(Self.restInterval) { [weak self] in
            self?.restFired(on: letter)
        }
    }

    private func restFired(on letter: NSView) {
        guard letter === pendingLetter, let host, let pointer else { return }
        cancelPending = nil
        pendingLetter = nil
        guard let under = letterAt(pointer), under.letter === letter else { return }
        show(under, in: host)
    }

    private func show(_ under: LetterUnderPointer, in host: NSView) {
        let view = LetterTooltipView(text: under.text)
        let letter = host.convert(under.letter.bounds, from: under.letter)
        let top = host.isFlipped ? letter.maxY : letter.minY - view.frame.height
        view.frame.origin = NSPoint(x: letter.maxX - view.frame.width, y: top)
        host.addSubview(view)
        shown = view
        shownLetter = under.letter
    }
}
