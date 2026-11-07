import Foundation
import Testing

@testable import Shell
@testable import Surfaces

/// The shell's closed decoder of the Markdown answer (CP-1100 – CP-1103): the pinned fixture both
/// languages read gives the expected document, anything that does not conform is refused whole, and
/// the link and asset answers read as the bridge writes them.

private func buffer(_ json: String, isRefusal: Bool = false) -> BridgeBuffer {
    BridgeBuffer(payload: Data(json.utf8), handle: 1, isRefusal: isRefusal)
}

private func answer(_ blocks: String) -> BridgeBuffer {
    buffer(#"{"state":"markdown","blocks":[\#(blocks)]}"#)
}

private let paragraphJSON = #"{"kind":"paragraph","content":[{"kind":"text","text":"words"}]}"#

private func refused(_ blocks: String) -> Bool {
    BridgePayload.decodeFile(answer(blocks)) == nil
}

private func inline(_ json: String) -> String {
    #"{"kind":"paragraph","content":[\#(json)]}"#
}

private func fixture(filePath: String = #filePath) throws -> Data {
    let root = URL(fileURLWithPath: filePath)
        .deletingLastPathComponent().deletingLastPathComponent()
        .deletingLastPathComponent().deletingLastPathComponent()
    return try Data(
        contentsOf: root.appendingPathComponent(
            "crates/ka-reader-bridge/tests/fixtures/markdown_answer.json"))
}

private func text(_ string: String) -> MarkdownInline { .text(string) }

private func words(_ string: String) -> MarkdownBlock { .paragraph([.text(string)]) }

@Suite struct BridgePayloadMarkdownTests {
    @Test func decodeFileOnThePinnedFixtureGivesTheExpectedDocument() throws {
        let verdict = BridgePayload.decodeFile(BridgeBuffer(payload: try fixture(), handle: 1))

        let link = MarkdownInline.link(
            [text("guide")], destination: "docs/guide.md", .relative(path: "docs/guide.md"))
        let external = MarkdownInline.link(
            [text("site")], destination: "https://example.com", .external)
        let expected = MarkdownDocument(blocks: [
            .heading(.one, [text("Title"), .emphasis(.strong, [text("bold")])]),
            .paragraph([
                text("Hello "), .emphasis(.single, [text("there")]), .code("x()"),
                .image(alt: "logo", .resolved(path: "logo.png")),
                .image(
                    alt: "remote",
                    .placeholder(.outsideTheFolder, source: "https://example.com/remote.png")),
                .image(alt: "", .placeholder(.missing, source: "img/missing.png")),
                .image(alt: "locked", .placeholder(.unreadable, source: "locked.png")),
                .image(alt: "diagram", .placeholder(.formatNotDecoded, source: "diagram.svg")),
                link, external,
            ]),
            .list(.unordered, items: [[words("one")], [words("two")]]),
            .list(
                .ordered(start: 3),
                items: [[words("three"), .list(.unordered, items: [[words("nested")]])]]),
            .quote([words("quoted")]),
            .rule,
            .code("plain text\n", .plain),
            .code("é = 1\n", .floor(.python, [CodeSpan(start: 0, end: 2, tokenClass: .name)])),
            .code("", .floor(.toml, [])),
        ])
        #expect(verdict == .markdown(expected))
    }

    @Test func decodeFileRefusesATableKind() {
        #expect(!refused(paragraphJSON))
        #expect(refused(#"{"kind":"table","rows":[]}"#))
        #expect(refused(inline(#"{"kind":"table"}"#)))
    }

    @Test func decodeFileRefusesAMissingAndAnExtraMember() {
        #expect(refused(#"{"kind":"heading","content":[]}"#))
        #expect(refused(#"{"kind":"paragraph","content":[],"extra":1}"#))
        #expect(refused(inline(#"{"kind":"text"}"#)))
        #expect(refused(inline(#"{"kind":"text","text":"a","extra":true}"#)))
        #expect(refused(#"{"kind":"rule","content":[]}"#))
        #expect(refused(#"{"kind":"list","order":"ordered","items":[]}"#))
    }

    @Test func decodeFileRefusesAConditionAListOrderAndAStrengthOutsideTheirSets() {
        #expect(
            refused(
                inline(
                    #"{"kind":"image","alt":"a","target":"placeholder","condition":"gone","source":"s"}"#
                )))
        #expect(refused(#"{"kind":"list","order":"random","items":[]}"#))
        #expect(refused(inline(#"{"kind":"emphasis","strength":"bold","content":[]}"#)))
        #expect(refused(inline(#"{"kind":"image","alt":"a","target":"remote"}"#)))
        #expect(
            refused(
                inline(
                    #"{"kind":"link","content":[],"destination":"d","target":"maybe"}"#)))
    }

    @Test(arguments: [0, 7, -1, 1000])
    func decodeFileRefusesHeadingLevelsZeroAndSeven(level: Int) {
        #expect(refused(#"{"kind":"heading","level":\#(level),"content":[]}"#))
    }

    @Test func decodeFileRefusesAStartOnAnUnorderedList() {
        #expect(refused(#"{"kind":"list","order":"unordered","start":1,"items":[]}"#))
        #expect(!refused(#"{"kind":"list","order":"ordered","start":1,"items":[]}"#))
    }

    @Test func decodeFileRefusesSpansOnPlainCodeAndNoSpansOnFloorCode() {
        #expect(refused(#"{"kind":"code","code":"a","language":"plain","spans":[]}"#))
        #expect(refused(#"{"kind":"code","code":"a","language":"python"}"#))
        #expect(refused(#"{"kind":"code","code":"a","language":"rust"}"#))
        #expect(!refused(#"{"kind":"code","code":"a","language":"python","spans":[]}"#))
    }

    @Test func decodeFileRefusesASpanPastItsBlocksCode() {
        let past =
            #"{"kind":"code","code":"ab","language":"python","spans":[{"start":0,"end":5,"class":"name"}]}"#
        let inside =
            #"{"kind":"code","code":"ab","language":"python","spans":[{"start":0,"end":2,"class":"name"}]}"#
        #expect(refused(past))
        #expect(!refused(inside))
        // The earlier block's code is long enough; the span is checked against its own block's.
        let long = #"{"kind":"code","code":"abcdef","language":"python","spans":[]}"#
        #expect(refused(long + "," + past))
    }

    @Test func decodeFileRefusesAMemberBesideBlocks() {
        #expect(
            BridgePayload.decodeFile(buffer(#"{"state":"markdown","blocks":[],"extra":1}"#)) == nil)
        #expect(BridgePayload.decodeFile(buffer(#"{"state":"markdown"}"#)) == nil)
        #expect(
            BridgePayload.decodeFile(buffer(#"{"state":"markdown","blocks":[]}"#))
                == .markdown(MarkdownDocument(blocks: [])))
    }

    @Test func decodeFileRefusesADocumentNestedPastTheDecoderLimitWithoutCrashing() {
        let depth = 3000
        let nested =
            String(repeating: #"{"kind":"quote","blocks":["#, count: depth) + paragraphJSON
            + String(repeating: "]}", count: depth)

        #expect(refused(nested))
        #expect(!refused(#"{"kind":"quote","blocks":["# + paragraphJSON + "]}"))
    }

    @Test func decodeChangesKeepsAListingBesideAConformingMarkdownOpenFileMember() throws {
        let payload = #"""
            {"listings":[{"path":"","answer":{"state":"observed","entries":[]}}],
             "open_file":{"revision":4,"path":"README.md","position":"line=0;x=0",
             "answer":{"state":"markdown","blocks":[\#(paragraphJSON)]}}}
            """#

        let changes = try #require(BridgePayload.decodeChanges(Data(payload.utf8)))

        #expect(changes.listings.count == 1)
        #expect(changes.openFile?.revision == 4)
        #expect(
            changes.openFile?.update.verdict
                == .markdown(MarkdownDocument(blocks: [words("words")])))
    }

    @Test func decodeChangesRefusesTheWholePayloadWithANonConformingMarkdownMember() {
        let payload = #"""
            {"listings":[{"path":"","answer":{"state":"observed","entries":[]}}],
             "open_file":{"revision":4,"path":"README.md","position":"line=0;x=0",
             "answer":{"state":"markdown","blocks":[{"kind":"table"}]}}}
            """#

        #expect(BridgePayload.decodeChanges(Data(payload.utf8)) == nil)
    }

    @Test
    func
        decodeLinkGivesNothingForPendingStoppedForNilAndForANonConformingAnswerAndOpenedForAVerdict()
    {
        #expect(BridgePayload.decodeLink(buffer(#"{"state":"pending"}"#)) == .nothing)
        #expect(BridgePayload.decodeLink(nil) == .stopped)
        #expect(BridgePayload.decodeLink(buffer(#"{"state":"markdown"}"#)) == .stopped)
        #expect(BridgePayload.decodeLink(buffer("not json")) == .stopped)
        #expect(
            BridgePayload.decodeLink(buffer(#"{"state":"text","content":"a","language":"plain"}"#))
                == .opened(.text("a", .plain)))
        #expect(
            BridgePayload.decodeLink(answer(paragraphJSON))
                == .opened(.markdown(MarkdownDocument(blocks: [words("words")]))))
    }

    @Test func decodeAssetGivesNilForARefusalTheBytesForBytesAndEmptyDataForAnEmptyNonRefusal() {
        let bytes = Data([1, 2, 3])
        #expect(BridgePayload.decodeAsset(BridgeBuffer(payload: bytes, handle: 1)) == bytes)
        #expect(
            BridgePayload.decodeAsset(BridgeBuffer(payload: Data(), handle: 2, isRefusal: true))
                == nil)
        #expect(BridgePayload.decodeAsset(BridgeBuffer(payload: Data(), handle: 3)) == Data())
    }

    @Test func decodeAssetGivesNilForANilBuffer() {
        #expect(BridgePayload.decodeAsset(nil) == nil)
    }
}
