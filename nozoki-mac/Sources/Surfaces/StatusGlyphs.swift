import AppKit

/// The two glyphs a status message leads with (`docs/DESIGN.md` § *Components* "Status messages"):
/// `empty` for an empty or pending state, `failure` for a failure. The owner fills it, because this
/// target never loads a resource (SM-8, the-window-holds-its-layout change_spec.md CP-266).
package struct StatusGlyphs {
    /// The image leading an empty or pending status.
    package let empty: NSImage
    /// The image leading an observed or unexplained failure.
    package let failure: NSImage

    /// Keeps the owner-resolved images; this value performs no resource lookup.
    package init(empty: NSImage, failure: NSImage) {
        self.empty = empty
        self.failure = failure
    }
}
