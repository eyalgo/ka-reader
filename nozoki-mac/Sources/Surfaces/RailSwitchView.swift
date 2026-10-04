import AppKit

/// The two things the rail switches the sidebar between.
package enum RailEntry: Sendable, Equatable {
    case files
    case git
}

/// The entry a click on the rail chose.
package typealias RailEntryChosen = @MainActor (_ entry: RailEntry) -> Void

private enum RailLayout {
    /// `docs/DESIGN.md` `{spacing.rail-width}` and `{spacing.rail-entry}`: the rail's width and each
    /// entry's height.
    static let side: CGFloat = 48
    /// `docs/DESIGN.md` `{spacing.rail-icon}`.
    static let glyphSide: CGFloat = 20
    /// `docs/DESIGN.md` `{typography.rail-label}`: 10 points at weight 500.
    static let labelPointSize: CGFloat = 10
    static let gap: CGFloat = 2
}

/// The Files/Git switch (`docs/DESIGN.md` § *Components*, "The rail"): two entries, each a glyph over
/// its word, the active one marked with the bar. It is told which entry is active and raises
/// `entryChosen` on a click on the *inactive* entry. It does not move its own bar on a click: the
/// owner decides what the choice does and tells the switch. It is handed both glyphs, because this
/// target never loads a resource, and it raises no tooltip.
@MainActor
package final class RailSwitchView: NSView {
    private struct Entry {
        let kind: RailEntry
        let row: BarRowView
        let glyph: NSImageView
        let label: NSTextField
    }

    private var entries: [Entry] = []

    /// The entry that carries the bar.
    package var active: RailEntry = .files {
        didSet { applyActive() }
    }

    /// Set by the view's owner, and called once per click on the inactive entry.
    package var entryChosen: RailEntryChosen?

    package init(folderGlyph: NSImage, gitGlyph: NSImage) {
        super.init(frame: .zero)
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.alignment = .leading
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: RailLayout.side),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        for (kind, glyph, word) in [
            (RailEntry.files, folderGlyph, GitSentences.filesLabel),
            (RailEntry.git, gitGlyph, GitSentences.gitLabel),
        ] {
            let entry = makeEntry(kind, glyph: glyph, word: word)
            entries.append(entry)
            entry.row.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(entry.row)
            entry.row.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        }
        applyActive()
    }

    @available(*, unavailable)
    package required init?(coder: NSCoder) {
        preconditionFailure("RailSwitchView is built in code only")
    }

    /// A click on an entry chooses it, unless it is the active one. Nothing else in the view acts on
    /// a click.
    override package func mouseDown(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        guard
            let entry = entries.first(where: {
                $0.row.convert($0.row.bounds, to: self).contains(point)
            }),
            entry.kind != active
        else { return }
        entryChosen?(entry.kind)
    }

    private func applyActive() {
        for entry in entries {
            let isActive = entry.kind == active
            entry.row.drawsBar = isActive
            // `{colors.primary}` for the active entry, `{colors.ink-muted}` for the other: the bar,
            // not the tone, is what a reader without colour reads.
            let tone = isActive ? NSColor.labelColor : NSColor.secondaryLabelColor
            entry.label.textColor = tone
            entry.glyph.contentTintColor = tone
        }
    }

    private func makeEntry(_ kind: RailEntry, glyph image: NSImage, word: String) -> Entry {
        let row = BarRowView()
        let glyph = NSImageView(image: image)
        glyph.imageScaling = .scaleProportionallyDown
        let label = NSTextField(labelWithString: word)
        label.font = .systemFont(ofSize: RailLayout.labelPointSize, weight: .medium)
        label.alignment = .center
        for part in [glyph, label] {
            part.translatesAutoresizingMaskIntoConstraints = false
            row.addSubview(part)
        }
        NSLayoutConstraint.activate([
            row.heightAnchor.constraint(equalToConstant: RailLayout.side),
            glyph.widthAnchor.constraint(equalToConstant: RailLayout.glyphSide),
            glyph.heightAnchor.constraint(equalToConstant: RailLayout.glyphSide),
            glyph.centerXAnchor.constraint(equalTo: row.centerXAnchor),
            glyph.topAnchor.constraint(equalTo: row.topAnchor, constant: RailLayout.gap * 2),
            label.centerXAnchor.constraint(equalTo: row.centerXAnchor),
            label.topAnchor.constraint(equalTo: glyph.bottomAnchor, constant: RailLayout.gap),
        ])
        return Entry(kind: kind, row: row, glyph: glyph, label: label)
    }
}
