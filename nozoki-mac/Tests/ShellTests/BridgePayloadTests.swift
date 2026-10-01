import Foundation
import Surfaces
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
}
