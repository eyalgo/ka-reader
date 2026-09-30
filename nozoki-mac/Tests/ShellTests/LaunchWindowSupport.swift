import AppKit
import Shell
import Surfaces
import XCTest

// What every window test reads through (change_design.md § 5, *What a window test reads*).
//
// Two constraints shape this file, and neither is recoverable from the code:
// - Every place is read in the window's coordinates and the content area comes from the window,
//   never from the presented view being the window's content view, so a test is indifferent to
//   whether the shell hosts a surface inside a view of its own (change_design.md § 3, *Edges*).
// - It uses only names `nozoki@04dfab6` has, so a test built on it compiles on that tree and fails
//   there on an assertion, not on a compile error (change_spec.md CP-248).

/// The content area's size when the product first shows its window: `docs/DESIGN.md` § *Layout*'s
/// minimum width of 720, by the height the window has always opened at (the-window-holds-its-layout
/// change_spec.md CP-252, CP-253).
let openingContentSize = NSSize(width: 720, height: 640)

/// Half a point: the slack a frame comparison allows, since layout lands on half-point boundaries.
private let layoutTolerance: CGFloat = 0.5

/// Creates the shared application object, as the shipped app does before it shows its first
/// surface (`Sources/Nozoki/main.swift`). Nothing is activated and no run loop is started, so the
/// process holds the app's launch state and no side effect of one.
///
/// Called from a class-level set-up, once per class and before any of its tests: a test's click
/// then never depends on whether an earlier test created the object (change_design.md § 3 B). The
/// set-up runs on the main thread, and the isolation is asserted as `main.swift` asserts it.
func createTheSharedApplication() {
    MainActor.assumeIsolated { _ = NSApplication.shared }
}

/// A presenter that forwards to a real `MainWindowPresenter` and keeps each view it was handed, so
/// a whole launch can run through `LaunchFlow` into the product's own window.
@MainActor
final class ForwardingWindowPresenter: WindowPresenting {
    private let presenter = MainWindowPresenter()
    private(set) var contents: [NSView] = []

    func present(_ content: NSView) {
        contents.append(content)
        presenter.present(content)
    }
}

/// A launch wired to the test target's fakes and a real window.
@MainActor
struct WindowLaunch {
    let flow: LaunchFlow
    let bridge: RecordingBridge
    let panel: FakePanel
    let presenter: ForwardingWindowPresenter
    let glyphs: FakeGlyphSource
}

/// The base of every test case that puts a view in the product's window. It takes each window it
/// showed off the screen when the test ends.
@MainActor
class LaunchWindowTestCase: XCTestCase {
    private var shownWindows: [NSWindow] = []

    override class func setUp() {
        super.setUp()
        createTheSharedApplication()
    }

    override func tearDown() async throws {
        for window in shownWindows { window.orderOut(nil) }
        shownWindows = []
        try await super.tearDown()
    }

    /// Presents `view` through the product's presenting path and returns its laid-out window. With
    /// no `presenter` it is a new `MainWindowPresenter`, so the view is the first in its window;
    /// pass one to present over what that presenter already shows.
    func present(_ view: NSView, through presenter: WindowPresenting? = nil) throws -> NSWindow {
        // Built here and not as the default value: a default is evaluated off the main actor,
        // where `MainWindowPresenter.init` cannot be called.
        (presenter ?? MainWindowPresenter()).present(view)
        return try laidOutWindow(of: view)
    }

    /// The window `view` was presented in, laid out. Fails when the view is in no window.
    func laidOutWindow(of view: NSView) throws -> NSWindow {
        let window = try XCTUnwrap(view.window, "the view was presented in no window")
        if !shownWindows.contains(where: { $0 === window }) { shownWindows.append(window) }
        layOut(window)
        return window
    }

    /// A launch through `LaunchFlow` into a real window. The panel answers `answers` in order, and
    /// the bridge answers as `RecordingBridge` does until a test sets its answers. With no `reader`
    /// every read is answered at once; pass one to hold a read.
    func makeLaunch(
        answers: [URL?], reader: ReadRunning? = nil, terminate: @escaping () -> Void = {}
    ) -> WindowLaunch {
        let log = EventLog()
        let bridge = RecordingBridge(log: log)
        let panel = FakePanel(answers: answers, log: log)
        let presenter = ForwardingWindowPresenter()
        let glyphs = FakeGlyphSource()
        // Built here and not as the default value, for the reason `present(_:through:)` gives.
        let flow = LaunchFlow(
            panel: panel, bridge: bridge, glyphs: glyphs, presenter: presenter,
            reader: reader ?? InlineReadRunner(), terminate: terminate)
        return WindowLaunch(
            flow: flow, bridge: bridge, panel: panel, presenter: presenter, glyphs: glyphs)
    }
}

/// Lays `window` out. Twice, because a wrapping label takes its width on the first pass and its
/// height on the second.
@MainActor
func layOut(_ window: NSWindow) {
    window.layoutIfNeeded()
    window.layoutIfNeeded()
}

/// The window's area beneath its title bar, in the window's coordinates.
@MainActor
func contentArea(of window: NSWindow) -> NSRect {
    window.contentLayoutRect
}

/// Where `view` is, in its window's coordinates — or in its topmost ancestor's, in no window.
@MainActor
func frameInWindow(of view: NSView) -> NSRect {
    view.convert(view.bounds, to: nil)
}

/// The visible text elements beneath `root`, top to bottom: every visible, non-editable
/// `NSTextField` (change_design.md § 3, *Exposes*).
@MainActor
func textElements(beneath root: NSView) -> [NSTextField] {
    drawnElements(beneath: root).compactMap { $0 as? NSTextField }.filter(isTextElement)
}

/// The visible glyphs beneath `root`, top to bottom and then leading first: every visible image view
/// that cannot be edited and carries no action (the-window-holds-its-layout change_design.md § 5).
/// A glyph is neither text nor a control, so no other reader here returns one.
@MainActor
func glyphs(beneath root: NSView) -> [NSImageView] {
    sortedTopToBottom(visibleDescendants(of: root).compactMap { $0 as? NSControl }.filter(isGlyph))
        .compactMap { $0 as? NSImageView }
}

/// The visible controls beneath `root`, top to bottom: every visible `NSControl` that is not a
/// text element.
@MainActor
func controls(beneath root: NSView) -> [NSControl] {
    drawnElements(beneath: root).filter { !isTextElement($0) }
}

/// Every visible text element and control beneath `root`, top to bottom and then leading first. A
/// glyph is neither, and is read through `glyphs(beneath:)`.
@MainActor
func drawnElements(beneath root: NSView) -> [NSControl] {
    sortedTopToBottom(
        visibleDescendants(of: root).compactMap { $0 as? NSControl }.filter { !isGlyph($0) })
}

@MainActor
private func sortedTopToBottom(_ controls: [NSControl]) -> [NSControl] {
    controls.sorted { first, second in
        let firstFrame = frameInWindow(of: first)
        let secondFrame = frameInWindow(of: second)
        if firstFrame.maxY != secondFrame.maxY { return firstFrame.maxY > secondFrame.maxY }
        return firstFrame.minX < secondFrame.minX
    }
}

/// What each drawn element says, top to bottom: a button's title, any other element's text.
@MainActor
func drawnStrings(beneath root: NSView) -> [String] {
    drawnElements(beneath: root).map(drawnString)
}

/// What `element` says: a button's title, any other element's text.
@MainActor
func drawnString(of element: NSControl) -> String {
    (element as? NSButton)?.title ?? element.stringValue
}

/// The visible view of `kind` beneath `root`, for a test that asserts there is none.
@MainActor
func visibleViews<Kind: NSView>(of kind: Kind.Type, beneath root: NSView) -> [Kind] {
    visibleDescendants(of: root).compactMap { $0 as? Kind }
}

/// Why `element` is not *drawn whole* in `window`, or nil when it is (`change_spec.md`, *Terms*):
/// visible, a non-zero frame, the frame entirely inside the content area, the frame at least as
/// large as its text needs at its font and width, and none of its text cut off.
@MainActor
func wholenessFailure(of element: NSControl, in window: NSWindow) -> String? {
    let name = "“\(drawnString(of: element))”"
    guard element.window === window, !element.isHiddenOrHasHiddenAncestor else {
        return "\(name) is not visible in the window"
    }
    let frame = frameInWindow(of: element)
    guard frame.width > 0, frame.height > 0 else { return "\(name) has the empty frame \(frame)" }
    let area = contentArea(of: window)
    guard area.insetBy(dx: -layoutTolerance, dy: -layoutTolerance).contains(frame) else {
        return "\(name) at \(frame) is not inside the content area \(area)"
    }
    let needed = neededSize(of: element)
    guard
        frame.width >= needed.width - layoutTolerance,
        frame.height >= needed.height - layoutTolerance
    else {
        return "\(name) is \(frame.size) and its text needs \(needed)"
    }
    if let textField = element as? NSTextField, isCutOff(textField) {
        return "\(name) cuts its text off inside \(frame.size)"
    }
    return nil
}

/// Asserts `element` is drawn whole in `window`, naming what failed.
@MainActor
func assertDrawnWhole(
    _ element: NSControl, in window: NSWindow, file: StaticString = #filePath, line: UInt = #line
) {
    if let failure = wholenessFailure(of: element, in: window) {
        XCTFail(failure, file: file, line: line)
    }
}

/// Whether any two of `elements` share any area.
@MainActor
func overlappingPairs(among elements: [NSControl]) -> [(String, String)] {
    var pairs: [(String, String)] = []
    for (index, first) in elements.enumerated() {
        for second in elements.dropFirst(index + 1)
        where frameInWindow(of: first).intersects(frameInWindow(of: second)) {
            pairs.append((drawnString(of: first), drawnString(of: second)))
        }
    }
    return pairs
}

/// Each adjacent pair of `elements` whose second does not stand wholly beneath its first. A rule
/// that fixes an order "from top to bottom" (change_spec.md CP-240–CP-242) is not met by two
/// elements side by side on one line, which sorting them by place would still put in an order.
@MainActor
func pairsNotStackedTopToBottom(among elements: [NSControl]) -> [(String, String)] {
    zip(elements, elements.dropFirst()).compactMap { upper, lower in
        let isBeneath =
            frameInWindow(of: lower).maxY <= frameInWindow(of: upper).minY + layoutTolerance
        return isBeneath ? nil : (drawnString(of: upper), drawnString(of: lower))
    }
}

/// One activation of a drawn control, performed on the control itself (change_spec.md CP-247).
@MainActor
func click(_ control: NSControl) {
    control.performClick(nil)
}

/// One press, drag and release delivered to `window` at window coordinates, the way a person drags
/// (the-window-holds-its-layout change_spec.md CP-262: not a call on any view's API). The drag and
/// the release are queued before the press is delivered, so a view that tracks a drag in its own
/// loop finds them there; whatever is still queued afterwards is delivered in turn, so a view that
/// takes each event as it comes gets them too, and nothing is left for a later test.
@MainActor
func dragAsAPersonDoes(in window: NSWindow, from start: NSPoint, by distance: CGFloat) throws {
    let end = NSPoint(x: start.x + distance, y: start.y)
    let press = try mouseEvent(.leftMouseDown, at: start, in: window)
    NSApp.postEvent(try mouseEvent(.leftMouseDragged, at: end, in: window), atStart: false)
    NSApp.postEvent(try mouseEvent(.leftMouseUp, at: end, in: window), atStart: false)

    window.sendEvent(press)
    while let queued = NSApp.nextEvent(
        matching: [.leftMouseDragged, .leftMouseUp], until: .distantPast, inMode: .default,
        dequeue: true)
    {
        window.sendEvent(queued)
    }
    layOut(window)
}

@MainActor
private func mouseEvent(
    _ type: NSEvent.EventType, at location: NSPoint, in window: NSWindow
) throws -> NSEvent {
    try XCTUnwrap(
        NSEvent.mouseEvent(
            with: type, location: location, modifierFlags: [],
            timestamp: ProcessInfo.processInfo.systemUptime, windowNumber: window.windowNumber,
            context: nil, eventNumber: 0, clickCount: 1, pressure: type == .leftMouseUp ? 0 : 1))
}

/// The drawn control titled `title` beneath `root`. It throws when the surface draws none, which
/// is what "a control that is not drawn cannot be activated" comes to (change_spec.md CP-245).
@MainActor
func control(
    titled title: String, beneath root: NSView, file: StaticString = #filePath, line: UInt = #line
) throws -> NSControl {
    try XCTUnwrap(
        controls(beneath: root).first { drawnString(of: $0) == title },
        "the surface draws no control titled “\(title)”", file: file, line: line)
}

/// The workbench's panel holding `element`: the direct subview of `workbench` that is `element` or
/// an ancestor of it, or nil when `element` is not beneath `workbench`.
@MainActor
func panel(of workbench: NSView, containing element: NSView) -> NSView? {
    var current: NSView? = element
    while let view = current {
        if view.superview === workbench { return view }
        current = view.superview
    }
    return nil
}

/// An image view is a glyph only while nothing can be done with it: one that can be edited or
/// carries an action is still read as a control, so a test that finds no control still catches it.
@MainActor
private func isGlyph(_ element: NSControl) -> Bool {
    guard let imageView = element as? NSImageView else { return false }
    return !imageView.isEditable && imageView.action == nil
}

@MainActor
private func isTextElement(_ element: NSControl) -> Bool {
    guard let textField = element as? NSTextField else { return false }
    return !textField.isEditable
}

/// Every visible view beneath `root`, a button counted as one view: what AppKit places inside a
/// button to draw it is the button's drawing, not an element of the surface.
///
/// A button, and not every control: an outline view is a control too, and the sidebar's names are
/// the cells beneath it. What lies inside a button differs by OS: on macOS 14 a visible text field
/// holding its title, on macOS 26 one private hosting view (change_design.md § 1, cause A).
@MainActor
private func visibleDescendants(of root: NSView) -> [NSView] {
    root.subviews.filter { !$0.isHidden }.flatMap { view in
        [view] + (view is NSButton ? [] : visibleDescendants(of: view))
    }
}

/// The size `element`'s text needs at its font: a wrapping element's at the width it has, any
/// other's on one line. Measured: a label's intrinsic width is what layout gives it and draws whole
/// (120.5 for the reading prompt), where its cell's own size adds padding (124.3).
///
/// A wrapping element's height is also measured from the text itself, laid out across the whole of
/// the element's width, and the taller answer is the one used. The cell alone is not enough: a cell
/// capped at a number of lines answers with the capped height, so a 300-character path cut off
/// after its second line read as whole (measured: 32 points against the 80 its text needs).
@MainActor
private func neededSize(of element: NSControl) -> NSSize {
    guard let cell = element.cell, cell.wraps else { return element.intrinsicContentSize }
    let widestLine = NSSize(width: element.bounds.width, height: .greatestFiniteMagnitude)
    let cellSize = cell.cellSize(forBounds: NSRect(origin: .zero, size: widestLine))
    return NSSize(
        width: cellSize.width,
        height: max(cellSize.height, uncappedTextHeight(of: element, within: widestLine)))
}

/// The height `element`'s whole string takes at its font and line-break mode inside `size`, with
/// no limit on the number of lines. It is a lower bound on what the element needs: the element
/// draws its text in a little less than its whole width.
@MainActor
private func uncappedTextHeight(of element: NSControl, within size: NSSize) -> CGFloat {
    let paragraph = NSMutableParagraphStyle()
    paragraph.lineBreakMode = element.lineBreakMode
    var attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraph]
    if let font = element.font { attributes[.font] = font }
    return NSAttributedString(string: element.stringValue, attributes: attributes)
        .boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading]).height
}

/// Whether AppKit would offer an expansion for `textField`, which it does exactly when the text
/// does not fit the frame it is drawn in.
@MainActor
private func isCutOff(_ textField: NSTextField) -> Bool {
    guard let cell = textField.cell else { return false }
    return !cell.expansionFrame(withFrame: textField.bounds, in: textField).isEmpty
}
