/// The answer for the opened folder's root: the entries that were read, or the reason none were.
///
/// It is never built for `pending`: a root nothing was read for has no projection to draw.
package enum RootListing: Equatable, Sendable {
    case observed([Entry])
    case failed(Condition)
}
