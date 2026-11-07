import Foundation
import Surfaces

/// The closed decoder of a Markdown answer's `blocks` (CP-1100, CP-1103). Every object holds exactly
/// the members its kind names, and a kind, condition, list order, strength, target or language
/// outside its closed set, a heading level outside 1 to 6, a start without an ordered list, and
/// spans that do not match the language all throw. One throw anywhere refuses the whole answer.
extension BridgePayload {
    private enum BlockKind: String, Decodable {
        case heading, paragraph, list, quote, rule, code
    }

    private enum InlineKind: String, Decodable {
        case text, emphasis, code, image, link
    }

    private enum ListOrder: String, Decodable {
        case unordered, ordered
    }

    private enum Strength: String, Decodable {
        case single, strong
    }

    private enum ImageTarget: String, Decodable {
        case resolved, placeholder
    }

    private enum LinkTarget: String, Decodable {
        case relative, external
    }

    /// One block as the wire writes it.
    struct WireBlock: Decodable {
        let block: MarkdownBlock

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: WireKey.self)
            func key(_ name: String) -> WireKey { WireKey(stringValue: name) }
            switch try closed(BlockKind.self, in: container, key: "kind") {
            case .heading:
                try requireMembers(["kind", "level", "content"], in: container)
                let level = try container.decode(Int.self, forKey: key("level"))
                guard let heading = MarkdownHeadingLevel(rawValue: level) else {
                    throw DecodingError.dataCorrupted(
                        .init(
                            codingPath: container.codingPath,
                            debugDescription: "a heading level is 1 to 6"))
                }
                block = .heading(heading, try Self.content(in: container))
            case .paragraph:
                try requireMembers(["kind", "content"], in: container)
                block = .paragraph(try Self.content(in: container))
            case .list:
                let kind: MarkdownListKind
                switch try closed(ListOrder.self, in: container, key: "order") {
                case .unordered:
                    try requireMembers(["kind", "order", "items"], in: container)
                    kind = .unordered
                case .ordered:
                    try requireMembers(["kind", "order", "start", "items"], in: container)
                    kind = .ordered(start: try container.decode(UInt64.self, forKey: key("start")))
                }
                let items = try container.decode([[WireBlock]].self, forKey: key("items"))
                block = .list(kind, items: items.map { $0.map(\.block) })
            case .quote:
                try requireMembers(["kind", "blocks"], in: container)
                block = .quote(
                    try container.decode([WireBlock].self, forKey: key("blocks")).map(\.block))
            case .rule:
                try requireMembers(["kind"], in: container)
                block = .rule
            case .code:
                let language = try container.decode(
                    FileAnswer.WireLanguage.self, forKey: key("language"))
                let code = try container.decode(String.self, forKey: key("code"))
                switch language {
                case .plain:
                    try requireMembers(["kind", "code", "language"], in: container)
                    block = .code(code, .plain)
                case .floor(let floor):
                    try requireMembers(["kind", "code", "language", "spans"], in: container)
                    let spans = try container.decode(
                        [FileAnswer.WireSpan].self, forKey: key("spans")
                    ).map(\.span)
                    guard FileAnswer.spansConform(spans, to: code) else {
                        throw DecodingError.dataCorrupted(
                            .init(
                                codingPath: container.codingPath,
                                debugDescription: "a span does not conform to its block's code"))
                    }
                    block = .code(code, .floor(floor, spans))
                }
            }
        }

        private static func content(in container: KeyedDecodingContainer<WireKey>) throws
            -> [MarkdownInline]
        {
            try container.decode([WireInline].self, forKey: WireKey(stringValue: "content"))
                .map(\.inline)
        }
    }

    /// One inline node as the wire writes it.
    struct WireInline: Decodable {
        let inline: MarkdownInline

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: WireKey.self)
            func key(_ name: String) -> WireKey { WireKey(stringValue: name) }
            func content() throws -> [MarkdownInline] {
                try container.decode([WireInline].self, forKey: key("content")).map(\.inline)
            }
            switch try closed(InlineKind.self, in: container, key: "kind") {
            case .text:
                try requireMembers(["kind", "text"], in: container)
                inline = .text(try container.decode(String.self, forKey: key("text")))
            case .emphasis:
                try requireMembers(["kind", "strength", "content"], in: container)
                let strength: MarkdownEmphasis =
                    switch try closed(Strength.self, in: container, key: "strength") {
                    case .single: .single
                    case .strong: .strong
                    }
                inline = .emphasis(strength, try content())
            case .code:
                try requireMembers(["kind", "code"], in: container)
                inline = .code(try container.decode(String.self, forKey: key("code")))
            case .image:
                let alt = try container.decode(String.self, forKey: key("alt"))
                switch try closed(ImageTarget.self, in: container, key: "target") {
                case .resolved:
                    try requireMembers(["kind", "alt", "target", "path"], in: container)
                    inline = .image(
                        alt: alt,
                        .resolved(path: try container.decode(String.self, forKey: key("path"))))
                case .placeholder:
                    try requireMembers(
                        ["kind", "alt", "target", "condition", "source"], in: container)
                    inline = .image(
                        alt: alt,
                        .placeholder(
                            try closed(
                                ImagePlaceholderCondition.self, in: container, key: "condition"),
                            source: try container.decode(String.self, forKey: key("source"))))
                }
            case .link:
                let destination = try container.decode(String.self, forKey: key("destination"))
                switch try closed(LinkTarget.self, in: container, key: "target") {
                case .relative:
                    try requireMembers(
                        ["kind", "content", "destination", "target", "path"], in: container)
                    inline = .link(
                        try content(), destination: destination,
                        .relative(path: try container.decode(String.self, forKey: key("path"))))
                case .external:
                    try requireMembers(
                        ["kind", "content", "destination", "target"], in: container)
                    inline = .link(try content(), destination: destination, .external)
                }
            }
        }
    }
}
