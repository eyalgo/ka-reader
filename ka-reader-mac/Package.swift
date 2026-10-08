// swift-tools-version:5.9
import Foundation
import PackageDescription

// No `dependencies:` at all — CP-95. The tools version is the lowest that has `.macOS(.v14)`, the
// deployment floor (CP-96); the runner's Swift is read from the first CI log (design § 4 B).

// The repository root is this package's parent. The bridge's static library and its header are at
// fixed places below it, in the default `target/` directory (design § 3 A, *Artifacts*).
let repositoryRoot = URL(fileURLWithPath: Context.packageDirectory).deletingLastPathComponent().path

let package = Package(
    name: "ka-reader-mac",
    platforms: [.macOS(.v14)],
    targets: [
        .target(name: "Surfaces"),
        .target(name: "Shell", dependencies: ["Surfaces"]),
        // The C header the bridge's build script writes, as a Swift module.
        .systemLibrary(name: "CKAReaderBridge"),
        .executableTarget(
            name: "KAReader",
            dependencies: ["Shell", "CKAReaderBridge"],
            linkerSettings: [
                // An unsafe linker flag in a root package declares no dependency (CP-95). The
                // library search path follows the build configuration, as Cargo's profiles do.
                .unsafeFlags(
                    ["-L", "\(repositoryRoot)/target/debug"], .when(configuration: .debug)),
                .unsafeFlags(
                    ["-L", "\(repositoryRoot)/target/release"], .when(configuration: .release)),
                // What `cargo rustc -p ka-reader-bridge --lib -- --print native-static-libs` prints,
                // less what every link already carries (System, c, m).
                .linkedLibrary("iconv"),
                // The libgit2 that ka-reader-core links needs zlib and the Security framework; the
                // measured list above also names CoreFoundation, which the link carries once named.
                .linkedLibrary("z"),
                .linkedFramework("Security"),
                .linkedFramework("CoreFoundation"),
            ]),
        .testTarget(name: "SurfacesTests", dependencies: ["Surfaces"]),
        .testTarget(name: "ShellTests", dependencies: ["Shell", "Surfaces"]),
    ]
)
