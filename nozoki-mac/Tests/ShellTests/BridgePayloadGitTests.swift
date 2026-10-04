import Foundation
import Surfaces
import XCTest

@testable import Shell

final class BridgePayloadGitTests: XCTestCase {
    private func decode(_ payload: String) -> GitItem {
        BridgePayload.decodeGit(BridgeBuffer(payload: Data(payload.utf8), handle: 1))
    }

    private func root(
        branch: String = #"{"kind":"branch","name":"main"}"#,
        state: String = "normal",
        staged: String = "[]",
        changed: String = "[]"
    ) -> String {
        #"{"state":"observed","kind":"root","branch":\#(branch),"repository_state":"\#(state)","staged":\#(staged),"changed":\#(changed)}"#
    }

    func test_pendingDecodesToPending() {
        XCTAssertEqual(decode(#"{"state":"pending"}"#), .pending)
    }

    func test_plainDecodesToPlain() {
        XCTAssertEqual(decode(#"{"state":"observed","kind":"plain"}"#), .plain)
    }

    func test_rootMainNormalWithEmptyListsDecodesToARepository() {
        XCTAssertEqual(
            decode(root()),
            .repository(
                GitRepository(branch: .named("main"), state: .normal, staged: [], changed: [])))
    }

    func test_theSixCategoryAnswerDecodesAndFromOnRenamedIsAcceptedAndDropped() {
        let staged =
            #"[{"path":"a.txt","category":"added"},{"path":"new/b.txt","category":"renamed","from":"old/b.txt"}]"#
        let changed =
            #"[{"path":"c.txt","category":"modified"},{"path":"d.txt","category":"deleted"},{"path":"e.txt","category":"untracked"},{"path":"f.txt","category":"in_conflict"}]"#
        XCTAssertEqual(
            decode(root(staged: staged, changed: changed)),
            .repository(
                GitRepository(
                    branch: .named("main"), state: .normal,
                    staged: [
                        GitEntry(path: "a.txt", category: .added),
                        GitEntry(path: "new/b.txt", category: .renamed),
                    ],
                    changed: [
                        GitEntry(path: "c.txt", category: .modified),
                        GitEntry(path: "d.txt", category: .deleted),
                        GitEntry(path: "e.txt", category: .untracked),
                        GitEntry(path: "f.txt", category: .inConflict),
                    ])))
    }

    func test_theDetachedRebaseAnswerDecodesWithTheFullIdentifier() {
        let commit = "0123456789abcdef0123456789abcdef01234567"
        XCTAssertEqual(
            decode(root(branch: #"{"kind":"detached","commit":"\#(commit)"}"#, state: "rebase")),
            .repository(
                GitRepository(
                    branch: .detached(commit: commit), state: .rebase, staged: [], changed: [])))
    }

    func test_eachOfTheTwelveConditionsDecodesAndGitDirectoryOutsideKeepsItsPath() {
        for condition in GitCondition.allCases {
            XCTAssertEqual(
                decode(#"{"state":"failed","condition":"\#(condition.rawValue)"}"#),
                .failed(.condition(condition)), condition.rawValue)
        }
        XCTAssertEqual(
            decode(
                #"{"state":"failed","condition":"git_directory_outside","git_directory":"/elsewhere/.git"}"#
            ),
            .failed(.gitDirectoryOutside(gitDirectory: "/elsewhere/.git")))
        XCTAssertEqual(GitCondition.allCases.count + 1, 12)
    }

    func test_everyRepositoryStateDecodes() {
        for state in RepositoryState.allCases {
            XCTAssertEqual(
                decode(root(state: state.rawValue)),
                .repository(
                    GitRepository(
                        branch: .named("main"), state: state, staged: [], changed: [])),
                state.rawValue)
        }
    }

    func test_aNullBufferIsStopped() {
        XCTAssertEqual(BridgePayload.decodeGit(nil), .stopped)
    }

    func test_anUnknownStateKindBranchKindRepositoryStateCategoryOrConditionIsStopped() {
        let entry = { (category: String) in
            #"[{"path":"a","category":"\#(category)"}]"#
        }
        let rejected = [
            #"{"state":"something_new"}"#,
            #"{"state":"observed","kind":"something_new"}"#,
            root(branch: #"{"kind":"something_new","name":"main"}"#),
            root(state: "something_new"),
            root(staged: entry("copied")),
            root(changed: entry("something_new")),
            #"{"state":"failed","condition":"something_new"}"#,
            #"{"state":"failed","condition":"copied"}"#,
            "malformed",
            "",
        ]
        for payload in rejected {
            XCTAssertEqual(decode(payload), .stopped, payload)
        }
    }

    func test_aMissingMemberIsStopped() {
        let rejected = [
            #"{}"#,
            #"{"state":"observed"}"#,
            #"{"state":"failed"}"#,
            #"{"state":"observed","kind":"root","repository_state":"normal","staged":[],"changed":[]}"#,
            #"{"state":"observed","kind":"root","branch":{"kind":"branch","name":"main"},"staged":[],"changed":[]}"#,
            #"{"state":"observed","kind":"root","branch":{"kind":"branch","name":"main"},"repository_state":"normal","changed":[]}"#,
            #"{"state":"observed","kind":"root","branch":{"kind":"branch","name":"main"},"repository_state":"normal","staged":[]}"#,
            root(branch: #"{"kind":"branch"}"#),
            root(branch: #"{"kind":"detached"}"#),
            root(staged: #"[{"path":"a"}]"#),
            root(staged: #"[{"category":"added"}]"#),
            #"{"state":"failed","condition":"git_directory_outside"}"#,
            #"{"state":"failed","condition":"not_a_root","git_directory":"/x"}"#,
        ]
        for payload in rejected {
            XCTAssertEqual(decode(payload), .stopped, payload)
        }
    }

    func test_anExtraMemberAtEachLevelIsStopped() {
        let rejected = [
            #"{"state":"pending","extra":1}"#,
            #"{"state":"observed","kind":"plain","extra":1}"#,
            #"{"state":"observed","kind":"root","extra":1,"branch":{"kind":"branch","name":"main"},"repository_state":"normal","staged":[],"changed":[]}"#,
            root(branch: #"{"kind":"branch","name":"main","extra":1}"#),
            root(branch: #"{"kind":"detached","commit":"abc","extra":1}"#),
            root(staged: #"[{"path":"a","category":"added","extra":1}]"#),
            root(changed: #"[{"path":"a","category":"modified","extra":1}]"#),
            #"{"state":"failed","condition":"not_a_root","extra":1}"#,
            #"{"state":"failed","condition":"git_directory_outside","git_directory":"/x","extra":1}"#,
        ]
        for payload in rejected {
            XCTAssertEqual(decode(payload), .stopped, payload)
        }
    }

    func test_gitDirectoryBesideAnotherConditionIsStopped() {
        for condition in GitCondition.allCases {
            XCTAssertEqual(
                decode(
                    #"{"state":"failed","condition":"\#(condition.rawValue)","git_directory":"/x"}"#
                ),
                .stopped, condition.rawValue)
        }
    }

    func test_fromOnANonRenamedEntryIsStopped() {
        for category in ["added", "untracked", "modified", "deleted", "in_conflict"] {
            XCTAssertEqual(
                decode(
                    root(staged: #"[{"path":"a","category":"\#(category)","from":"b"}]"#)),
                .stopped, category)
        }
        XCTAssertEqual(
            decode(root(changed: #"[{"path":"a","category":"renamed"}]"#)), .stopped,
            "renamed without from")
    }

    func test_aStoppedAnswerIsNeverPartlyDecoded() {
        let good = #"{"path":"a","category":"added"}"#
        let bad = #"{"path":"b","category":"copied"}"#
        XCTAssertEqual(decode(root(staged: "[\(good),\(bad)]")), .stopped)
        XCTAssertEqual(decode(root(changed: "[\(good),\(bad),\(good)]")), .stopped)
        XCTAssertEqual(
            decode(root(staged: "[\(good)]", changed: #"[{"path":"b","category":"added","x":1}]"#)),
            .stopped)
    }
}
