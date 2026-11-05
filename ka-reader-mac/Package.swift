// swift-tools-version:6.2
import PackageDescription

// No `dependencies:` at all — CP-95. The tools version is 6.2, the one that has the package-level
// language mode, `.treatAllWarnings(as:)`, `.strictMemorySafety()` and `.defaultIsolation(_:)`, and
// `.macOS(.v26)` is the deployment floor (CP-96); the runner's Swift is read from the first CI log
// (design § 4 B).

// The bridge's static library and header reach the package as one local binary target. `assemble.sh`
// writes `CKAReaderBridge.artifactbundle` from the release build of the bridge crate, before any
// `swift build` or `swift test`; it is generated, git-ignored and never committed.

// All five Swift targets carry these two settings, unconditionally, so they are written once and
// shared; `Surfaces` and `KAReader` add the main-actor default isolation to them. The binary target
// compiles nothing and carries no settings.
let strictness: [SwiftSetting] = [
    .treatAllWarnings(as: .error),
    .strictMemorySafety(),
]

let package = Package(
    name: "ka-reader-mac",
    platforms: [.macOS(.v26)],
    targets: [
        .target(
            name: "Surfaces",
            swiftSettings: strictness + [.defaultIsolation(MainActor.self)]),
        .target(name: "Shell", dependencies: ["Surfaces"], swiftSettings: strictness),
        // The C header and static library the bridge's build writes, packaged by `assemble.sh`.
        .binaryTarget(name: "CKAReaderBridge", path: "CKAReaderBridge.artifactbundle"),
        .executableTarget(
            name: "KAReader",
            dependencies: ["Shell", "CKAReaderBridge"],
            swiftSettings: strictness + [.defaultIsolation(MainActor.self)],
            linkerSettings: [
                // What `cargo rustc -p ka-reader-bridge --lib -- --print native-static-libs` prints,
                // less what every link already carries (System, c, m).
                .linkedLibrary("iconv"),
                // The libgit2 that ka-reader-core links needs zlib and the Security framework; the
                // measured list above also names CoreFoundation, which the link carries once named.
                // The bridge's watcher binds FSEvents, which lives in CoreServices: the same
                // measured list names it, and the link has no other way to find those symbols.
                .linkedLibrary("z"),
                .linkedFramework("Security"),
                .linkedFramework("CoreFoundation"),
                .linkedFramework("CoreServices"),
            ]),
        .testTarget(name: "SurfacesTests", dependencies: ["Surfaces"], swiftSettings: strictness),
        .testTarget(
            name: "ShellTests", dependencies: ["Shell", "Surfaces"], swiftSettings: strictness),
    ],
    swiftLanguageModes: [.v6]
)
