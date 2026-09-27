/// The content the startup surface is currently responsible for drawing.
package enum StartupProjection: Equatable {
    case empty
    case reading
    case failed(path: String, condition: OpeningCondition)
    case stopped(path: String)
}

/// An action the startup surface asks its owner to perform.
package enum StartupIntent: Equatable {
    case browse
    case quit
}
