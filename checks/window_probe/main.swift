import CoreGraphics
import Foundation
import ImageIO

// checks/window_probe/main.swift — finds the one window a process shows on screen, and prints the
// metadata of a picture, for checks/readme-capture.sh to judge.
//
// WHY THIS EXISTS
//   No shell can list the windows on screen or decode a PNG's metadata. checks/readme-capture.sh
//   compiles this file with swiftc into its own work folder and runs it there. It never ships, and
//   no shipped unit depends on it. It imports the platform's Foundation, CoreGraphics and ImageIO,
//   which docs/nfdr.md QC-14's dated list does not name for this file yet (the correction is owed to
//   that record, not made here).
//
// USAGE
//   window <pid>     prints the window number of the one on-screen, layer-0 window that <pid> owns.
//                    When <pid> owns none or more than one, it prints the count on stderr and exits 1.
//   metadata <png>   prints, as text, every property ImageIO decodes from the file, its PNG text
//                    chunks and its XMP included.
//   It judges nothing. 2 is a wrong invocation, with the usage line on stderr, and 1 is any other
//   failure.
//
// WHY THE METADATA IS DECODED
//   A PNG's text chunks may be compressed, and a byte search of the file would miss a name inside
//   one. The capture compares this decoded text and never the file's raw bytes, because compressed
//   pixel data can hold any short byte string by chance.

private let programName = "ka-reader-window-probe"

private let windowOnScreenLayer = 0
private let requiredWindowCount = 1

private enum ProbeFailure: Error {
    case usage
    case notAProcessNumber(argument: String)
    case cannotListWindows
    case windowCount(processNumber: Int32, count: Int)
    case cannotOpen(path: String)
    case cannotReadProperties(path: String)

    var message: String {
        switch self {
        case .usage:
            return "\(programName): usage: window <pid> | metadata <png>"
        case .notAProcessNumber(let argument):
            return "\(programName): \(argument) is not a process number"
        case .cannotListWindows:
            return "\(programName): cannot read the list of windows on screen"
        case .windowCount(let processNumber, let count):
            return
                "\(programName): process \(processNumber) owns \(count) on-screen windows at layer "
                + "\(windowOnScreenLayer), and exactly \(requiredWindowCount) is needed"
        case .cannotOpen(let path):
            return "\(programName): cannot open \(path) as an image"
        case .cannotReadProperties(let path):
            return "\(programName): cannot read the properties of \(path)"
        }
    }

    var exitStatus: Int32 {
        switch self {
        case .usage:
            return 2
        case .notAProcessNumber, .cannotListWindows, .windowCount, .cannotOpen,
            .cannotReadProperties:
            return 1
        }
    }
}

/// The window numbers of the on-screen windows at layer 0 that `processNumber` owns.
private func windowNumbers(ownedBy processNumber: Int32) throws -> [Int] {
    guard
        let windows = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID)
            as? [[String: Any]]
    else {
        throw ProbeFailure.cannotListWindows
    }
    return windows.compactMap { window in
        guard
            let owner = window[kCGWindowOwnerPID as String] as? Int32, owner == processNumber,
            let layer = window[kCGWindowLayer as String] as? Int, layer == windowOnScreenLayer,
            let number = window[kCGWindowNumber as String] as? Int
        else {
            return nil
        }
        return number
    }
}

private func windowReply(forProcess argument: String) throws -> String {
    guard let processNumber = Int32(argument) else {
        throw ProbeFailure.notAProcessNumber(argument: argument)
    }
    let numbers = try windowNumbers(ownedBy: processNumber)
    guard numbers.count == requiredWindowCount, let number = numbers.first else {
        throw ProbeFailure.windowCount(processNumber: processNumber, count: numbers.count)
    }
    return "\(number)\n"
}

/// Every leaf of `value` as one `path = value` line, the keys of a dictionary in sorted order.
private func flattened(_ value: Any, path: String) -> [String] {
    if let dictionary = value as? [String: Any] {
        return dictionary.sorted { $0.key < $1.key }.flatMap { key, child in
            flattened(child, path: path.isEmpty ? key : "\(path).\(key)")
        }
    }
    if let array = value as? [Any] {
        return array.enumerated().flatMap { index, element in
            flattened(element, path: "\(path)[\(index)]")
        }
    }
    return ["\(path) = \(String(describing: value))"]
}

/// The XMP tags of the first image, one `prefix:name = value` line for each.
private func metadataLines(of source: CGImageSource) -> [String] {
    guard
        let metadata = CGImageSourceCopyMetadataAtIndex(source, 0, nil),
        let tags = CGImageMetadataCopyTags(metadata) as? [CGImageMetadataTag]
    else {
        return []
    }
    return tags.map { tag in
        let prefix = CGImageMetadataTagCopyPrefix(tag) as String? ?? ""
        let name = CGImageMetadataTagCopyName(tag) as String? ?? ""
        let value = CGImageMetadataTagCopyValue(tag).map { String(describing: $0) } ?? ""
        return "xmp.\(prefix):\(name) = \(value)"
    }
}

private func metadataReply(forFileAt path: String) throws -> String {
    guard let source = CGImageSourceCreateWithURL(URL(fileURLWithPath: path) as CFURL, nil) else {
        throw ProbeFailure.cannotOpen(path: path)
    }
    guard
        let container = CGImageSourceCopyProperties(source, nil) as? [String: Any],
        let image = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any]
    else {
        throw ProbeFailure.cannotReadProperties(path: path)
    }
    let lines =
        flattened(container, path: "container") + flattened(image, path: "image")
        + metadataLines(of: source)
    return lines.joined(separator: "\n") + "\n"
}

private func reportOnStandardError(_ message: String) {
    FileHandle.standardError.write(Data((message + "\n").utf8))
}

private func run(arguments: [String]) throws {
    guard arguments.count == 3 else {
        throw ProbeFailure.usage
    }
    switch arguments[1] {
    case "window":
        print(try windowReply(forProcess: arguments[2]), terminator: "")
    case "metadata":
        print(try metadataReply(forFileAt: arguments[2]), terminator: "")
    default:
        throw ProbeFailure.usage
    }
}

do {
    try run(arguments: CommandLine.arguments)
} catch let failure as ProbeFailure {
    reportOnStandardError(failure.message)
    exit(failure.exitStatus)
} catch {
    reportOnStandardError("\(programName): \(String(describing: error))")
    exit(1)
}
