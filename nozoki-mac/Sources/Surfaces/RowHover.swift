import AppKit

/// Flags the clickable row under the pointer, so the row draws its hover fill (CP-599 to CP-607).
/// Each surface that has such rows holds one, bound to that surface as its host. The host owns the
/// lookup of which clickable row lies at a point; everything else is here.
///
/// The pointer reaches it only through the one tracking area it installs on the host, with the
/// options of the tooltip's area (`LetterTooltip`), so the fill and the tooltip answer the same
/// pointer under the same conditions. It keeps the pointer's last position and never which row it
/// was over: every re-resolve asks the lookup again, so a row that moved from under a still
/// pointer, or a new row that moved under it, is found.
@MainActor
package final class RowHover: NSResponder {
    private weak var host: NSView?
    private let rowAt: @MainActor (NSPoint) -> BarRowView?

    private var pointer: NSPoint?
    private weak var flaggedRow: BarRowView?

    /// `rowAt` answers the `BarRowView` of the clickable row at a point in host coordinates, or nil
    /// for anything else.
    init(host: NSView, rowAt: @escaping @MainActor (NSPoint) -> BarRowView?) {
        self.host = host
        self.rowAt = rowAt
        super.init()
        host.addTrackingArea(
            NSTrackingArea(
                rect: .zero,
                options: [.mouseMoved, .mouseEnteredAndExited, .activeInKeyWindow, .inVisibleRect],
                owner: self, userInfo: nil))
    }

    required init?(coder: NSCoder) { nil }

    /// Resolves the row under the kept pointer again. A host calls it whenever its rows may have
    /// moved under a pointer that has not.
    func refresh() {
        flaggedRow?.pointerIsOver = false
        flaggedRow = nil
        guard let pointer, let row = rowAt(pointer) else { return }
        row.pointerIsOver = true
        flaggedRow = row
    }

    /// Un-flags the row and drops the kept point. A host calls it when it is hidden.
    func forget() {
        pointer = nil
        refresh()
    }

    override package func mouseMoved(with event: NSEvent) { pointerMoved(event) }
    override package func mouseEntered(with event: NSEvent) { pointerMoved(event) }
    override package func mouseExited(with event: NSEvent) { forget() }

    private func pointerMoved(_ event: NSEvent) {
        guard let host else { return }
        pointer = host.convert(event.locationInWindow, from: nil)
        refresh()
    }
}
