import CoreGraphics
import Foundation
import ImageIO

// checks/icon_probe/main.swift — reads an .icns file and prints facts about the pixels of each of its
// representations, for checks/app-icon.sh to judge.
//
// WHY THIS EXISTS
//   No shell can read an image. checks/app-icon.sh compiles this file with swiftc into its own
//   temporary folder and runs it as `ka-reader-icon-probe <file>`. It never ships, and no shipped unit
//   depends on it. It imports the platform's ImageIO and CoreGraphics, which docs/nfdr.md § 1.2 does
//   not list for `checks/` (the correction is owed to that record, not made here).
//
// WHAT IT PRINTS
//   On stdout, one line for each representation, in the order the file holds them:
//     rep <width> <height> <distance>
//   <distance> is the largest, over the representation's fully opaque pixels, of that pixel's distance
//   from the straight line between #1E1F22 and #FBFBFA, in hundredths of a level, rounded up. The
//   distance of a pixel is the smallest, over t in [0, 1], of the largest per-channel gap between the
//   pixel and A + t(B − A), A = (30, 31, 34), B = (251, 251, 250). Rounding up fails closed: a pixel
//   exactly 2 levels off reads 200, and anything beyond reads 201 or more.
//   For a representation 1024 px wide it also prints the pixels the drawing fixes:
//     pixel <x> <y> <red> <green> <blue> <alpha>
//   for (512, 512), (512, 850) and (0, 0), counted from the top left.
//   It judges nothing. A failure goes to stderr with a non-zero exit (2 for the usage line, 1 else).
//
// HOW EACH IMAGE IS READ
//   The file is opened through ImageIO and each image is drawn into its own 8-bit RGBA bitmap in the
//   sRGB colour space. Alpha is premultiplied, which is harmless here: only fully opaque pixels are
//   measured, and for them the premultiplied and the plain value are the same.
//
// WHY THE DISTANCE IS EXACT
//   The gap to the line is a convex, piecewise linear function of t, so its smallest value lies at
//   t = 0, at t = 1, or where two channels' gaps meet. Those candidates are the only ones evaluated,
//   as fractions in whole numbers, so the rounding above is decided by integers and not by floating
//   point.

private let lineStart = [30, 31, 34]
private let lineEnd = [251, 251, 250]

private let fixedPixelSize = 1024
private let fixedPixelPoints = [(x: 512, y: 512), (x: 512, y: 850), (x: 0, y: 0)]

private let channelCount = 4
private let opaqueAlpha: UInt8 = 255

private let programName = "ka-reader-icon-probe"

private enum ProbeFailure: Error {
    case usage(argumentCount: Int)
    case cannotOpen(path: String)
    case holdsNoImage(path: String)
    case cannotReadImage(number: Int, path: String)
    case cannotDrawImage(number: Int, path: String)

    var message: String {
        switch self {
        case .usage(let argumentCount):
            return
                "\(programName): takes one argument, the path to an image file; "
                + "arguments given: \(argumentCount)"
        case .cannotOpen(let path):
            return "\(programName): cannot open \(path) as an image"
        case .holdsNoImage(let path):
            return "\(programName): \(path) holds no image"
        case .cannotReadImage(let number, let path):
            return "\(programName): cannot read image \(number) of \(path)"
        case .cannotDrawImage(let number, let path):
            return "\(programName): cannot draw image \(number) of \(path) into an sRGB bitmap"
        }
    }

    var exitStatus: Int32 {
        switch self {
        case .usage:
            return 2
        case .cannotOpen, .holdsNoImage, .cannotReadImage, .cannotDrawImage:
            return 1
        }
    }
}

/// The distance of a fully opaque pixel from the line, in hundredths of a level, rounded up.
private func hundredthsOffTheLine(red: Int, green: Int, blue: Int) -> Int {
    let offsets = [red - lineStart[0], green - lineStart[1], blue - lineStart[2]]
    let slopes = [lineEnd[0] - lineStart[0], lineEnd[1] - lineStart[1], lineEnd[2] - lineStart[2]]

    // Each candidate t is numerator / denominator, with the denominator positive.
    var candidates = [(numerator: 0, denominator: 1), (numerator: 1, denominator: 1)]
    for first in 0..<3 {
        for second in (first + 1)..<3 {
            for sign in [1, -1] {
                var denominator = sign * slopes[second] - slopes[first]
                var numerator = sign * offsets[second] - offsets[first]
                if denominator == 0 {
                    continue
                }
                if denominator < 0 {
                    denominator = -denominator
                    numerator = -numerator
                }
                if numerator >= 0 && numerator <= denominator {
                    candidates.append((numerator: numerator, denominator: denominator))
                }
            }
        }
    }

    var smallest = Int.max
    for candidate in candidates {
        var largestGap = 0
        for channel in 0..<3 {
            let scaledOffset = offsets[channel] * candidate.denominator
            let scaledSlope = candidate.numerator * slopes[channel]
            largestGap = max(largestGap, abs(scaledOffset - scaledSlope))
        }
        let hundredths = (100 * largestGap + candidate.denominator - 1) / candidate.denominator
        smallest = min(smallest, hundredths)
    }
    return smallest
}

/// The image drawn into a bitmap of its own size: sRGB, 8 bits per component, RGBA, top row first.
private func drawnPixels(of image: CGImage, number: Int, path: String) throws -> [UInt8] {
    let width = image.width
    let height = image.height
    guard width > 0, height > 0, let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else {
        throw ProbeFailure.cannotDrawImage(number: number, path: path)
    }
    var pixels = [UInt8](repeating: 0, count: width * height * channelCount)
    let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
    let drawn = pixels.withUnsafeMutableBytes { buffer -> Bool in
        guard
            let context = unsafe CGContext(
                data: buffer.baseAddress, width: width, height: height, bitsPerComponent: 8,
                bytesPerRow: width * channelCount, space: colorSpace, bitmapInfo: bitmapInfo)
        else {
            return false
        }
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        return true
    }
    guard drawn else {
        throw ProbeFailure.cannotDrawImage(number: number, path: path)
    }
    return pixels
}

/// The largest distance from the line of any fully opaque pixel, in hundredths of a level.
private func largestHundredthsOffTheLine(pixels: [UInt8]) -> Int {
    var largest = 0
    var distanceByColour: [UInt32: Int] = [:]
    var offset = 0
    while offset < pixels.count {
        if pixels[offset + 3] == opaqueAlpha {
            let colour =
                (UInt32(pixels[offset]) << 16) | (UInt32(pixels[offset + 1]) << 8)
                | UInt32(pixels[offset + 2])
            let distance: Int
            if let known = distanceByColour[colour] {
                distance = known
            } else {
                distance = hundredthsOffTheLine(
                    red: Int(pixels[offset]), green: Int(pixels[offset + 1]),
                    blue: Int(pixels[offset + 2]))
                distanceByColour[colour] = distance
            }
            largest = max(largest, distance)
        }
        offset += channelCount
    }
    return largest
}

private func fixedPixelLines(pixels: [UInt8], width: Int) -> String {
    var lines = ""
    for point in fixedPixelPoints {
        let offset = (point.y * width + point.x) * channelCount
        lines += "pixel \(point.x) \(point.y) \(pixels[offset]) \(pixels[offset + 1])"
        lines += " \(pixels[offset + 2]) \(pixels[offset + 3])\n"
    }
    return lines
}

private func reply(forFileAt path: String) throws -> String {
    guard let source = CGImageSourceCreateWithURL(URL(fileURLWithPath: path) as CFURL, nil) else {
        throw ProbeFailure.cannotOpen(path: path)
    }
    let imageCount = CGImageSourceGetCount(source)
    guard imageCount > 0 else {
        throw ProbeFailure.holdsNoImage(path: path)
    }
    var lines = ""
    for index in 0..<imageCount {
        let number = index + 1
        guard let image = CGImageSourceCreateImageAtIndex(source, index, nil) else {
            throw ProbeFailure.cannotReadImage(number: number, path: path)
        }
        let pixels = try drawnPixels(of: image, number: number, path: path)
        let distance = largestHundredthsOffTheLine(pixels: pixels)
        lines += "rep \(image.width) \(image.height) \(distance)\n"
        if image.width == fixedPixelSize && image.height > 850 {
            lines += fixedPixelLines(pixels: pixels, width: image.width)
        }
    }
    return lines
}

private func reportOnStandardError(_ message: String) {
    FileHandle.standardError.write(Data((message + "\n").utf8))
}

private func run(arguments: [String]) throws {
    guard arguments.count == 2 else {
        throw ProbeFailure.usage(argumentCount: arguments.count - 1)
    }
    print(try reply(forFileAt: arguments[1]), terminator: "")
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
