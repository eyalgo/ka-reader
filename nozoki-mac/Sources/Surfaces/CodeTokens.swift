import AppKit

/// The reading panel's colours: for the code view, the five code tokens, the `surface` ground, the
/// base ink `primary` and the line numbers' `gutter` colour, and for the path line, `inkMuted` and
/// the `line` hairline, each with the light and dark values of `docs/DESIGN.md` § Colors "The two
/// themes". A colour resolves when it is drawn, so an appearance change recolours the text without
/// the file being selected again (CP-314, CP-359), the way `RootItemsView`'s bar colour does.
enum CodeColors {
    static let surface = dynamic(light: 0xFBFBFA, dark: 0x1B1C1E)
    static let primary = dynamic(light: 0x1E1F22, dark: 0xE7E7E4)
    static let gutter = dynamic(light: 0x6F7177, dark: 0x8E8F94)
    static let inkMuted = dynamic(light: 0x5B5D63, dark: 0xABACB0)
    static let line = dynamic(light: 0xD8D8D4, dark: 0x3B3C41)
    private static let keyword = dynamic(light: 0x7A2E8F, dark: 0xD0A2E6)
    private static let string = dynamic(light: 0x1A6B3A, dark: 0x8FD6A4)
    private static let number = dynamic(light: 0x9A4B00, dark: 0xF0B47A)
    private static let comment = dynamic(light: 0x6A6C72, dark: 0x9A9BA0)
    private static let name = dynamic(light: 0x0F5A9A, dark: 0x8CC4F5)

    static func color(for tokenClass: TokenClass) -> NSColor {
        switch tokenClass {
        case .keyword: return keyword
        case .string: return string
        case .number: return number
        case .comment: return comment
        case .name: return name
        }
    }

    private static func dynamic(light: UInt32, dark: UInt32) -> NSColor {
        NSColor(name: nil) { appearance in
            srgb(appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? dark : light)
        }
    }

    private static func srgb(_ value: UInt32) -> NSColor {
        NSColor(
            srgbRed: CGFloat((value >> 16) & 0xFF) / 255,
            green: CGFloat((value >> 8) & 0xFF) / 255,
            blue: CGFloat(value & 0xFF) / 255, alpha: 1)
    }
}

/// The code type, `docs/DESIGN.md` `{typography.code}`: the monospaced system font at 13 points,
/// regular weight, on a line pitch of 1.55 times the size.
enum CodeType {
    private static let pointSize: CGFloat = 13
    private static let pitchMultiple: CGFloat = 1.55

    static let font = NSFont.monospacedSystemFont(ofSize: pointSize, weight: .regular)

    /// The baseline-to-baseline distance (CP-332). It is a multiple of the *size*: 1.55 times the
    /// font's own 16-point line height would be 24.8, which CP-332 rejects.
    static let linePitch = pitchMultiple * pointSize
}

/// The code view's three spacing values: `{spacing.lg}` around the text and the gutter's left
/// margin, `{spacing.xl}` as the gutter column's base width before its digits, and `{spacing.sm}`
/// as the padding at the column's right edge. The padding lies inside the column's width: it adds
/// nothing to it.
enum CodeSpacing {
    static let inset: CGFloat = 16
    static let gutterBase: CGFloat = 24
    static let gutterPadding: CGFloat = 8
}
