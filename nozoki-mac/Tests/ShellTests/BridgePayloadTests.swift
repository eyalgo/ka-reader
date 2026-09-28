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
        XCTAssertEqual(decode(" { \"state\" : \"opened\" } "), .opened)
        XCTAssertEqual(
            decode(#"{"condition":"missing","state":"failed"}"#),
            .failed(.missing))
    }

    func testOpenAnswerRejectsEveryNamedComplementShape() {
        let rejected = [
            "[]",
            #"{}"#,
            #"{"state":7}"#,
            #"{"state":"unknown"}"#,
            #"{"state":"opened","condition":"missing"}"#,
            #"{"state":"failed"}"#,
            #"{"state":"failed","condition":7}"#,
            #"{"state":"failed","condition":"unknown"}"#,
        ]

        for payload in rejected {
            XCTAssertNil(decode(payload), payload)
        }
    }
}
