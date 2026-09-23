// swift-tools-version:5.9
import PackageDescription

// No `dependencies:` at all — CP-95. The tools version is the lowest that has `.macOS(.v14)`, the
// deployment floor (CP-96); the runner's Swift is read from the first CI log (design § 4 B).
let package = Package(
    name: "nozoki-mac",
    platforms: [.macOS(.v14)],
    targets: [
        .target(name: "Surfaces"),
        .target(name: "Shell", dependencies: ["Surfaces"]),
        .testTarget(name: "SurfacesTests", dependencies: ["Surfaces"]),
        .testTarget(name: "ShellTests", dependencies: ["Shell", "Surfaces"]),
    ]
)
