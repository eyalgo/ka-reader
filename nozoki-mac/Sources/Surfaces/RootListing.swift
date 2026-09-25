/// The answer for one folder's read, the root's or any folder row's: the entries that were read, or
/// the reason none were.
///
/// It is never built for `pending`: a read that produced nothing to draw is no answer at all, and
/// reaches the view as `nil`.
package enum RootListing: Equatable, Sendable {
    case observed([Entry])
    case failed(Condition)
}
