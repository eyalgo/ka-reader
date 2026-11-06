import Foundation
import Surfaces
import Testing
import XCTest

@testable import Shell

final class BridgePayloadTests: XCTestCase {
    private func decode(_ payload: String) -> BridgePayload.OpenResult? {
        BridgePayload.decodeOpen(BridgeBuffer(payload: Data(payload.utf8), handle: 1))
    }

    func testOpenAnswerMatrixAcceptsOnlyOpenedAndThreeKnownFailures() {
        let accepted: [(String, BridgePayload.OpenResult)] = [
            (#"{"state":"opened"}"#, .opened),
            (#"{"state":"failed","condition":"missing"}"#, .failed(.missing)),
            (#"{"state":"failed","condition":"not_a_folder"}"#, .failed(.notAFolder)),
            (#"{"state":"failed","condition":"unreadable"}"#, .failed(.unreadable)),
        ]
        let rejected = [
            #"{"state":"opened","extra":true}"#,
            #"{"state":"failed"}"#,
            #"{"state":"failed","condition":7}"#,
            #"{"state":"failed","condition":"unknown"}"#,
            #"{"state":"failed","condition":"missing","extra":true}"#,
            #"{"state":"pending"}"#,
            "malformed",
            "",
        ]

        for (payload, expected) in accepted {
            XCTAssertEqual(decode(payload), expected, payload)
        }
        for payload in rejected {
            XCTAssertNil(decode(payload), payload)
        }
    }

    func testOpenAnswerAcceptsSemanticJSONEncodings() {
        // Mirrors boundary.rs test_open_answer_accepts_semantic_json_encodings byte-for-byte.
        let accepted: [(String, BridgePayload.OpenResult)] = [
            (#" { "state" : "opened" } "#, .opened),
            ("\n{\t\"state\":\t\"opened\"\r\n}\n", .opened),
            (#"{"condition":"missing","state":"failed"}"#, .failed(.missing)),
            (#"{"condition":"not_a_folder","state":"failed"}"#, .failed(.notAFolder)),
            (#"{ "condition" : "unreadable" , "state" : "failed" }"#, .failed(.unreadable)),
        ]

        for (payload, expected) in accepted {
            XCTAssertEqual(decode(payload), expected, payload)
        }
    }

    func testOpenAnswerRejectsEveryNamedComplementShape() {
        // Mirrors boundary.rs test_open_answer_rejects_non_objects_and_invalid_field_shapes.
        let rejected = [
            #"[]"#,
            #"["opened"]"#,
            #""opened""#,
            #"null"#,
            #"{}"#,
            #"{"condition":"missing"}"#,
            #"{"state":7}"#,
            #"{"state":null}"#,
            #"{"state":"unknown"}"#,
            #"{"state":"opened","condition":"missing"}"#,
            #"{"state":"failed"}"#,
            #"{"state":"failed","reason":"missing"}"#,
            #"{"state":"failed","condition":7}"#,
            #"{"state":"failed","condition":null}"#,
            #"{"state":"failed","condition":"unknown"}"#,
        ]

        for payload in rejected {
            XCTAssertNil(decode(payload), payload)
        }
    }

    private func decodeFile(_ payload: String) -> FileVerdict? {
        BridgePayload.decodeFile(BridgeBuffer(payload: Data(payload.utf8), handle: 1))
    }

    func testDecodeFileMapsEachOfTheFourWireShapes() {
        let mapped: [(String, FileVerdict?)] = [
            (
                #"{"state":"text","content":"héllo\n","language":"plain"}"#,
                .text("héllo\n", .plain)
            ),
            (
                #"{"state":"cannot_display","reason":"invalid_utf8"}"#,
                .cannotDisplay(.invalidUTF8)
            ),
            (
                #"{"state":"cannot_display","reason":"invalid_utf16"}"#,
                .cannotDisplay(.invalidUTF16)
            ),
            (#"{"state":"failed","condition":"outside"}"#, .failed(.outside)),
            (#"{"state":"failed","condition":"not_a_folder"}"#, .failed(.notAFolder)),
            (#"{"state":"pending"}"#, nil),
        ]

        for (payload, expected) in mapped {
            XCTAssertEqual(decodeFile(payload), expected, payload)
        }
    }

    func testDecodeFileAcceptsMembersInAnyOrderAndEmptyContent() {
        XCTAssertEqual(
            decodeFile(#"{"language":"plain","content":"","state":"text"}"#), .text("", .plain))
        XCTAssertEqual(
            decodeFile(#" { "reason" : "invalid_utf8" , "state" : "cannot_display" } "#),
            .cannotDisplay(.invalidUTF8))
    }

    func testDecodeFileRejectsAnExtraMember() {
        let rejected = [
            #"{"state":"text","content":"x","language":"plain","extra":1}"#,
            #"{"state":"cannot_display","reason":"invalid_utf8","extra":1}"#,
            #"{"state":"failed","condition":"outside","extra":1}"#,
            #"{"state":"pending","extra":1}"#,
            #"{"state":"text","content":"x","language":"plain","condition":"outside"}"#,
        ]

        for payload in rejected {
            XCTAssertNil(decodeFile(payload), payload)
        }
    }

    func testDecodeFileRejectsAMissingMember() {
        let rejected = [
            #"{"state":"text","language":"plain"}"#,
            #"{"state":"text","content":"x"}"#,
            #"{"state":"cannot_display"}"#,
            #"{"state":"failed"}"#,
            #"{"content":"x","language":"plain"}"#,
            #"{}"#,
        ]

        for payload in rejected {
            XCTAssertNil(decodeFile(payload), payload)
        }
    }

    func testDecodeFileRejectsAnUnknownStateLanguageReasonOrCondition() {
        let rejected = [
            #"{"state":"loading"}"#,
            #"{"state":"text","content":"x","language":"rust"}"#,
            #"{"state":"cannot_display","reason":"binary"}"#,
            #"{"state":"failed","condition":"unknown"}"#,
        ]

        for payload in rejected {
            XCTAssertNil(decodeFile(payload), payload)
        }
    }

    func testDecodeFileRejectsMalformedJSONAndANullBuffer() {
        for payload in ["malformed", "", "[]", "null", #""text""#, #"{"state":7}"#] {
            XCTAssertNil(decodeFile(payload), payload)
        }
        XCTAssertNil(BridgePayload.decodeFile(nil))
    }

    // MARK: - Spans (CP-309, CP-310)

    /// Fixture M as JSON text: 36 bytes of UTF-8, with characters 2, 3 and 4 bytes wide.
    private static let fixtureMJSON = ##""# café 日本 🙂\nname = \"é🙂\"\n""##
    private let fixtureM = "# café 日本 🙂\nname = \"é🙂\"\n"

    private func span(_ start: Int, _ end: Int, _ tokenClass: TokenClass) -> CodeSpan {
        CodeSpan(start: start, end: end, tokenClass: tokenClass)
    }

    /// A text answer for `language` whose `spans` member is the given JSON, or absent when `nil`.
    private func textPayload(
        content: String = BridgePayloadTests.fixtureMJSON, language: String, spans: String?
    ) -> String {
        let tail = spans.map { #","spans":\#($0)"# } ?? ""
        return #"{"state":"text","content":\#(content),"language":"\#(language)"\#(tail)}"#
    }

    private func mPayload(spans: String) -> String {
        textPayload(language: "python", spans: spans)
    }

    func testDecodeFileReadsFixtureMFromTheBridgesWireFile() throws {
        // `ka-reader-mac/Tests/ShellTests/BridgePayloadTests.swift` → the repository root, four levels up.
        let root = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent()
        let wire = try String(
            contentsOf: root.appendingPathComponent(
                "crates/ka-reader-bridge/tests/fixtures/m_answer.json"),
            encoding: .utf8)

        XCTAssertEqual(fixtureM.utf8.count, 36)
        XCTAssertEqual(
            decodeFile(wire),
            .text(fixtureM, .floor(.python, [span(0, 19, .comment), span(27, 35, .string)])))
    }

    func testDecodeFileRefusesPlainCarryingSpans() {
        XCTAssertNil(decodeFile(textPayload(language: "plain", spans: "[]")))
    }

    func testDecodeFileRefusesAFloorLanguageWithNoSpansMember() {
        XCTAssertNil(decodeFile(textPayload(language: "python", spans: nil)))
    }

    func testDecodeFileRefusesAnEndBeyondTheContent() {
        XCTAssertNil(decodeFile(mPayload(spans: #"[{"start":0,"end":37,"class":"comment"}]"#)))
    }

    func testDecodeFileRefusesAnEndInsideACharacter() {
        XCTAssertNil(decodeFile(mPayload(spans: #"[{"start":0,"end":18,"class":"comment"}]"#)))
    }

    func testDecodeFileRefusesAStartInsideACharacter() {
        XCTAssertNil(decodeFile(mPayload(spans: #"[{"start":16,"end":19,"class":"comment"}]"#)))
    }

    func testDecodeFileRefusesAnEmptySpan() {
        XCTAssertNil(decodeFile(mPayload(spans: #"[{"start":5,"end":5,"class":"comment"}]"#)))
    }

    func testDecodeFileRefusesAReversedSpan() {
        XCTAssertNil(decodeFile(mPayload(spans: #"[{"start":7,"end":5,"class":"name"}]"#)))
    }

    func testDecodeFileRefusesDisjointSpansInReverseOrder() {
        XCTAssertNil(
            decodeFile(
                mPayload(
                    spans:
                        #"[{"start":27,"end":35,"class":"string"},{"start":0,"end":19,"class":"comment"}]"#
                )))
    }

    func testDecodeFileRefusesTheWholeAnswerWhenALaterSpanIsInvalid() {
        XCTAssertNil(
            decodeFile(
                mPayload(
                    spans:
                        #"[{"start":0,"end":19,"class":"comment"},{"start":27,"end":37,"class":"string"}]"#
                )))
    }

    func testDecodeFileRefusesMalformedSpanLists() {
        for spans in ["null", "{}", "true", "[null]", "[7]", "[{}]"] {
            XCTAssertNil(decodeFile(mPayload(spans: spans)), spans)
        }
    }

    func testDecodeFileRefusesOffsetsThatAreNotIntegers() {
        for value in ["true", "null", #""5""#, "5.5", "9223372036854775808"] {
            XCTAssertNil(
                decodeFile(mPayload(spans: #"[{"start":\#(value),"end":19,"class":"comment"}]"#)),
                "start: \(value)")
            XCTAssertNil(
                decodeFile(mPayload(spans: #"[{"start":0,"end":\#(value),"class":"comment"}]"#)),
                "end: \(value)")
        }
    }

    func testDecodeFileRefusesAnUnknownLanguageEvenWithSpans() {
        XCTAssertNil(decodeFile(textPayload(language: "rust", spans: "[]")))
    }

    func testDecodeFileAcceptsEveryTokenClass() {
        let classes: [(String, TokenClass)] = [
            ("keyword", .keyword), ("string", .string), ("number", .number),
            ("comment", .comment), ("name", .name),
        ]
        for (name, tokenClass) in classes {
            XCTAssertEqual(
                decodeFile(mPayload(spans: #"[{"start":0,"end":5,"class":"\#(name)"}]"#)),
                .text(fixtureM, .floor(.python, [span(0, 5, tokenClass)])), name)
        }
    }

    func testDecodeFileAcceptsEmptyFloorContentOnlyWithNoSpans() {
        XCTAssertEqual(
            decodeFile(textPayload(content: #""""#, language: "python", spans: "[]")),
            .text("", .floor(.python, [])))
        XCTAssertNil(
            decodeFile(
                textPayload(
                    content: #""""#, language: "python",
                    spans: #"[{"start":0,"end":1,"class":"name"}]"#)))
    }

    func testDecodeFileRefusesAnUnknownClass() {
        XCTAssertNil(decodeFile(mPayload(spans: #"[{"start":0,"end":5,"class":"operator"}]"#)))
    }

    /// Bytes 7 and 8 are scalar boundaries of M (after `é`, before `日`) and 5 is the start of `é`, so
    /// the overlap is the only rule this payload breaks. The spec's `[0,10)` then `[5,12)` end inside
    /// `日` and `本` on M and would be refused by the boundary rule alone.
    func testDecodeFileRefusesOverlappingSpans() {
        XCTAssertNil(
            decodeFile(
                mPayload(
                    spans:
                        #"[{"start":0,"end":7,"class":"comment"},{"start":5,"end":8,"class":"comment"}]"#
                )))
    }

    func testDecodeFileRefusesANegativeStart() {
        XCTAssertNil(decodeFile(mPayload(spans: #"[{"start":-1,"end":5,"class":"comment"}]"#)))
    }

    func testDecodeFileRefusesANonIntegerOffset() {
        XCTAssertNil(decodeFile(mPayload(spans: #"[{"start":0,"end":5.5,"class":"comment"}]"#)))
    }

    func testDecodeFileRefusesASpanWithAFourthMember() {
        XCTAssertNil(
            decodeFile(
                mPayload(spans: #"[{"start":0,"end":5,"class":"comment","extra":1}]"#)))
    }

    func testDecodeFileRefusesASpanWithAMissingMember() {
        XCTAssertNil(decodeFile(mPayload(spans: #"[{"start":0,"end":5}]"#)))
    }

    func testDecodeFileAcceptsEachOfTheSixNamesWithNoSpans() {
        let names: [(String, FloorLanguage)] = [
            ("python", .python), ("shell", .shell), ("javascript", .javascript),
            ("json", .json), ("yaml", .yaml), ("toml", .toml),
        ]
        for (name, language) in names {
            XCTAssertEqual(
                decodeFile(textPayload(language: name, spans: "[]")),
                .text(fixtureM, .floor(language, [])), name)
        }
    }

    func testDecodeFileAcceptsAdjacentSpans() {
        XCTAssertEqual(
            decodeFile(
                mPayload(
                    spans:
                        #"[{"start":0,"end":5,"class":"comment"},{"start":5,"end":7,"class":"name"}]"#
                )),
            .text(fixtureM, .floor(.python, [span(0, 5, .comment), span(5, 7, .name)])))
    }

    func testDecodeFileAcceptsASpanEndingAtTheContentsByteLength() {
        XCTAssertEqual(
            decodeFile(mPayload(spans: #"[{"start":27,"end":36,"class":"string"}]"#)),
            .text(fixtureM, .floor(.python, [span(27, 36, .string)])))
    }

    func testDecodeFileAcceptsASpanEndingBetweenABaseLetterAndACombiningMark() {
        // "e" then U+0301: three bytes, and a scalar boundary at 1 that is not a grapheme boundary.
        XCTAssertEqual(
            decodeFile(
                textPayload(
                    content: #""e\u0301""#, language: "python",
                    spans: #"[{"start":0,"end":1,"class":"name"}]"#)),
            .text("e\u{301}", .floor(.python, [span(0, 1, .name)])))
    }
}

/// The `model_changed` payload: `{"listings":[{"path":…,"answer":<list answer>}…]}`, where each
/// answer is the shape `ka_reader_list_tree` answers. A `pending` answer reads as no listing.
struct BridgePayloadChangesTests {
    private func decode(_ payload: String) -> [(path: String, listing: RootListing?)]? {
        BridgePayload.decodeChanges(Data(payload.utf8))
    }

    private let folder = Entry(name: "src", path: "src", kind: .folder, state: .pending)
    private let file = Entry(name: "a.txt", path: "a.txt", kind: .file, state: .observed)

    @Test func thePositionWireFormRoundTripsAndAMalformedOneDecodesAsTheTopLeft() {
        let position = ReadingPosition(topLine: 400, horizontalOffset: 30.5)

        #expect(BridgePayload.encodePosition(position) == "line=400;x=30.5")
        #expect(BridgePayload.decodePosition(BridgePayload.encodePosition(position)) == position)
        #expect(
            BridgePayload.decodePosition(BridgePayload.encodePosition(.topLeft)) == .topLeft)
        for malformed in ["", "top", "line=;x=", "line=-1;x=2", "line=3", "line=3;x=nan", "x=2;line=3"] {
            #expect(BridgePayload.decodePosition(malformed) == .topLeft, "\(malformed)")
        }
    }

    @Test func decodeChangesReadsObservedFailedAndPendingAnswers() throws {
        let payload = """
            {"listings":[
              {"path":"src","answer":{"state":"observed","entries":[
                {"name":"a.txt","path":"src/a.txt","kind":"file","state":"observed","language":"plain"},
                {"name":"deep","path":"src/deep","kind":"folder","state":"pending"}]}},
              {"path":"gone","answer":{"state":"failed","condition":"missing"}},
              {"path":"later","answer":{"state":"pending"}}]}
            """

        let changes = try #require(decode(payload))

        #expect(changes.map(\.path) == ["src", "gone", "later"])
        #expect(
            changes[0].listing
                == .observed([
                    Entry(name: "a.txt", path: "src/a.txt", kind: .file, state: .observed),
                    Entry(name: "deep", path: "src/deep", kind: .folder, state: .pending),
                ]))
        #expect(changes[1].listing == .failed(.missing))
        #expect(changes[2].listing == nil)
    }

    @Test func decodeChangesReadsTheRootAsTheEmptyPath() throws {
        let payload = #"{"listings":[{"path":"","answer":{"state":"observed","entries":[]}}]}"#

        let changes = try #require(decode(payload))

        #expect(changes.map(\.path) == [""])
        #expect(changes[0].listing == .observed([]))
        #expect(try #require(decode(#"{"listings":[]}"#)).isEmpty)
    }

    @Test func decodeChangesReturnsNilForAMalformedPayload() {
        let rejected = [
            "", "malformed", "[]", #"{"listings":{}}"#, #"{}"#,
            #"{"listings":[],"extra":1}"#,
            #"{"listings":[{"path":"a"}]}"#,
            #"{"listings":[{"answer":{"state":"pending"}}]}"#,
            #"{"listings":[{"path":"a","answer":{"state":"pending"},"extra":1}]}"#,
            #"{"listings":[{"path":1,"answer":{"state":"pending"}}]}"#,
            #"{"listings":[{"path":"a","answer":{"state":"unknown"}}]}"#,
            #"{"listings":[{"path":"a","answer":{"state":"failed","condition":"nope"}}]}"#,
            #"{"listings":[{"path":"a","answer":{"state":"observed"}}]}"#,
            // One bad listing refuses the whole payload; none is kept.
            #"{"listings":[{"path":"a","answer":{"state":"pending"}},{"path":"b"}]}"#,
        ]

        for payload in rejected {
            #expect(decode(payload) == nil, Comment(rawValue: payload))
        }
    }
}
