import AppKit

/// One status message (`docs/DESIGN.md` § *Components* "Status messages"): a glyph leading one
/// column of text, top to bottom. The glyph's top and the column's top are the message's own top,
/// so the glyph stands on the text's first line
/// (the-window-holds-its-layout change_spec.md CP-258).
///
/// The text elements arrive built, so each keeps the wrapping and give-way settings its owner gave
/// it: this view holds none of them at a priority of its own.
@MainActor
final class StatusMessageView: NSView {
    /// `docs/DESIGN.md`'s `{components.icon}`: the size every glyph is drawn at.
    private static let glyphSize: CGFloat = 16

    /// `docs/DESIGN.md`'s `{spacing.sm}`: between the glyph and its text, and between one text
    /// element and the next.
    private static let spacing: CGFloat = 8

    private let glyphView: NSImageView

    /// The glyph leading the message.
    var glyph: NSImage? {
        get { glyphView.image }
        set { glyphView.image = newValue }
    }

    /// - Precondition: `texts` is not empty; a glyph never stands alone.
    init(glyph: NSImage, texts: [NSTextField]) {
        precondition(!texts.isEmpty, "a status message's glyph never stands alone")
        glyphView = NSImageView(image: glyph)
        super.init(frame: .zero)
        // Not editable, no action and never first responder: the glyph is not a control, and a
        // click on it raises nothing (CP-258).
        glyphView.isEditable = false
        glyphView.refusesFirstResponder = true
        glyphView.imageScaling = .scaleProportionallyUpOrDown

        var constraints = [
            glyphView.leadingAnchor.constraint(equalTo: leadingAnchor),
            glyphView.topAnchor.constraint(equalTo: topAnchor),
            glyphView.widthAnchor.constraint(equalToConstant: Self.glyphSize),
            glyphView.heightAnchor.constraint(equalToConstant: Self.glyphSize),
            glyphView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
        ]
        var above: NSView?
        for text in texts {
            constraints += [
                text.leadingAnchor.constraint(
                    equalTo: glyphView.trailingAnchor, constant: Self.spacing),
                text.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
                above.map {
                    text.topAnchor.constraint(equalTo: $0.bottomAnchor, constant: Self.spacing)
                }
                    ?? text.topAnchor.constraint(equalTo: topAnchor),
            ]
            above = text
        }
        if let last = above {
            constraints.append(last.bottomAnchor.constraint(equalTo: bottomAnchor))
        }
        for view in [glyphView] + texts {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
        }
        NSLayoutConstraint.activate(constraints)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        preconditionFailure("StatusMessageView is built in code only")
    }
}
