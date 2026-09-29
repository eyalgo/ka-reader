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
}
