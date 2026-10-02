import AppKit

/// The code view (`docs/DESIGN.md` § Components *Code*): a line-number gutter and a scroll view side
/// by side, with one TextKit 1 text view in the scroll view.
///
/// The gutter sits outside the scroll view, so horizontal scrolling cannot move it and text scrolled
/// left is clipped at the scroll view's own left edge, never drawn over or under a number (CP-339).
/// The four insets are CP-335's: 16 above the first row, 16 below the last numbered row, 16 after the
/// longest row, and 16 before the number column, inside the gutter; each line's first character
/// starts at the column's right edge (CP-337).
///
/// Nothing here edits, accepts a drop or draws a control (CP-343).
final class CodeView: NSView {
    /// The text view holding the file's text. TextKit 1 from construction: the gutter reads its rows
    /// from the layout manager, and reading one off a TextKit 2 view would switch it over lazily.
    let textView: NSTextView
    private let codeTextView: CodeTextView

    /// The line numbers of `textView`'s rows.
    let gutter: CodeGutterView

    private let scrollView: NSScrollView
    private let gutterWidth: NSLayoutConstraint

    init() {
        let layoutManager = NSLayoutManager()
        let storage = NSTextStorage()
        storage.addLayoutManager(layoutManager)
        let container = NSTextContainer(
            size: NSSize(
                width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        container.widthTracksTextView = false
        container.lineFragmentPadding = 0
        layoutManager.addTextContainer(container)

        let textView = CodeTextView(frame: .zero, textContainer: container)
        textView.isEditable = false
        textView.isRichText = false
        textView.isSelectable = true
        // The ground is the views' own background, never a `.backgroundColor` text attribute, so a
        // plain file's text carries none (CP-315).
        textView.backgroundColor = CodeColors.surface
        textView.drawsBackground = true
        textView.minSize = .zero
        textView.maxSize = NSSize(
            width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = true
        textView.autoresizingMask = [.width]
        // Half of 16 either side: `CodeTextView` puts the container at x 0, so the whole of the
        // horizontal inset lands on the right.
        textView.textContainerInset = NSSize(
            width: CodeSpacing.inset / 2, height: CodeSpacing.inset)
        textView.unregisterDraggedTypes()

        let scrollView = NSScrollView()
        scrollView.documentView = textView
        scrollView.backgroundColor = CodeColors.surface
        scrollView.drawsBackground = true
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        // A window adds 6 points on the left, bottom and right to a scroll view that adjusts its own
        // content insets, or whose clip view does (design probe, macOS 26.6.2).
        scrollView.automaticallyAdjustsContentInsets = false
        scrollView.contentInsets = NSEdgeInsetsZero
        scrollView.contentView.automaticallyAdjustsContentInsets = false
        scrollView.contentView.contentInsets = NSEdgeInsetsZero

        let gutter = CodeGutterView(textView: textView)

        self.textView = textView
        codeTextView = textView
        self.scrollView = scrollView
        self.gutter = gutter
        gutterWidth = gutter.widthAnchor.constraint(equalToConstant: gutter.width)

        super.init(frame: .zero)

        for view in [gutter, scrollView] {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        NSLayoutConstraint.activate([
            gutter.leadingAnchor.constraint(equalTo: leadingAnchor),
            gutter.topAnchor.constraint(equalTo: topAnchor),
            gutter.bottomAnchor.constraint(equalTo: bottomAnchor),
            gutterWidth,
            scrollView.leadingAnchor.constraint(equalTo: gutter.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("CodeView is built in code only")
    }

    override var isFlipped: Bool { true }

    /// Replaces the text whole, so nothing of the previous file's colours, or the view's typing
    /// attributes, reaches this one (CP-313). It lays the text out, rebuilds the gutter from this text
    /// alone (CP-342) and scrolls to the top-left.
    func show(_ text: NSAttributedString) {
        textView.textStorage?.setAttributedString(text)
        if let container = textView.textContainer {
            textView.layoutManager?.ensureLayout(for: container)
        }
        codeTextView.measureWidestRow()
        textView.sizeToFit()
        gutter.reload()
        gutterWidth.constant = gutter.width
        scrollView.contentView.scroll(to: .zero)
        scrollView.reflectScrolledClipView(scrollView.contentView)
    }
}

// The actions the reading panel's text menu offers: Copy and nothing else (R-49, CP-377 – CP-379).
// A keep-list rather than a strike-list, so an entry a later macOS adds is out by construction
// (change_design.md § 4). The selector is compile-time: `NSSelectorFromString` is a refused token
// (`checks/view.sh`, family F10).
private let keptTextMenuActions: [Selector] = [#selector(NSText.copy(_:))]

/// A new menu holding copies of the top-level entries of `menu` whose action the panel keeps, or
/// nil when none is. A submenu's own entry carries `submenuAction:`, which is not kept, so no
/// submenu is entered; `menu` is left whole, whether or not AppKit shares it between calls.
///
/// The menu also refuses what AppKit adds only when it shows a menu as a context menu: plug-in
/// entries and, from macOS 15.2, Writing Tools entries (`NSMenu.h`, "if used as a context menu").
func keptTextMenu(from menu: NSMenu) -> NSMenu? {
    let kept = menu.items.filter { item in
        item.action.map(keptTextMenuActions.contains) ?? false
    }
    guard !kept.isEmpty else { return nil }
    let filtered = NSMenu(title: menu.title)
    for item in kept {
        guard let copy = item.copy() as? NSMenuItem else {
            preconditionFailure("NSMenuItem.copy() answers an NSMenuItem")
        }
        filtered.addItem(copy)
    }
    filtered.allowsContextMenuPlugIns = false
    if #available(macOS 15.2, *) {
        filtered.automaticallyInsertsWritingToolsItems = false
    }
    return filtered
}

/// A text view that starts its text at the container's left edge and ends its height at the last
/// numbered row.
private final class CodeTextView: NSTextView {
    /// The stock menu, cut down to Copy. `showContextMenuForSelection:` reaches this hook too, so
    /// the keyboard and Accessibility paths get the same menu.
    override func menu(for event: NSEvent) -> NSMenu? {
        super.menu(for: event).flatMap(keptTextMenu(from:))
    }

    /// The horizontal inset is all on the right: each line's first character starts at the scroll
    /// view's left edge, which is the number column's right edge (CP-337).
    override var textContainerOrigin: NSPoint {
        NSPoint(x: 0, y: super.textContainerOrigin.y)
    }

    /// TextKit gives the extra line fragment after a terminal break a row's height, which would put
    /// that height under the last numbered row. A break that ends the file begins no line (CP-336),
    /// so the view's height leaves the fragment out and the bottom inset is 16 either way. The width
    /// is the widest row's last character plus the inset, not the layout's own figure: that one
    /// counts the break glyph that ends a row, and is rounded to the pixel grid.
    override func setConstrainedFrameSize(_ desiredSize: NSSize) {
        var size = desiredSize
        if let extraLineFragment = layoutManager?.extraLineFragmentRect {
            size.height -= extraLineFragment.height
        }
        size.width = widestRowEnd + CodeSpacing.inset
        super.setConstrainedFrameSize(size)
    }

    /// Where the widest row's last character ends, break glyphs left out, as of the last
    /// `measureWidestRow()`. The text changes only through `CodeView.show(_:)`, so it is measured
    /// there and not on every layout pass.
    private(set) var widestRowEnd: CGFloat = 0

    /// Measures where the widest row's last character ends. The text must be laid out.
    func measureWidestRow() {
        guard let layoutManager, let container = textContainer else { return }
        let text = string as NSString
        var widest: CGFloat = 0
        layoutManager.enumerateLineFragments(
            forGlyphRange: NSRange(location: 0, length: layoutManager.numberOfGlyphs)
        ) { _, _, _, glyphRange, _ in
            var characters = layoutManager.characterRange(
                forGlyphRange: glyphRange, actualGlyphRange: nil)
            while characters.length > 0,
                CharacterSet.newlines.contains(
                    UnicodeScalar(text.character(at: characters.upperBound - 1)) ?? " ")
            {
                characters.length -= 1
            }
            guard characters.length > 0 else { return }
            let lastGlyph = layoutManager.glyphIndexForCharacter(at: characters.upperBound - 1)
            let end = layoutManager.boundingRect(
                forGlyphRange: NSRange(location: lastGlyph, length: 1), in: container
            ).maxX
            widest = max(widest, end)
        }
        widestRowEnd = widest
    }
}
