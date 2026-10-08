/// Why an item could not be read, as the bridge names it on the wire (design § 3 C).
///
/// The set is closed: decoding any other string fails. A condition carries no text and no path. The
/// sentence a person reads for it lives in `ConditionSentences`, and nowhere else.
package enum Condition: String, Decodable, Sendable, CaseIterable {
    case unreadable
    case outside
    case cycle
    case missing
    case notAFolder = "not_a_folder"
    case tooManyLinks = "too_many_links"
}
