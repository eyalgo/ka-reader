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

    func test_eachOfTheFifteenConditionsDecodesAndTheFourWithTextKeepTheirOwn() {
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
        XCTAssertEqual(
            decode(
                #"{"state":"failed","condition":"config_names_outside","key":"include.path","path":"../../outside.config"}"#
            ),
            .failed(.configNamesOutside(key: "include.path", path: "../../outside.config")))
        XCTAssertEqual(
            decode(
                #"{"state":"failed","condition":"object_store_names_outside","path":"../../../elsewhere/objects"}"#
            ),
            .failed(.objectStoreNamesOutside(path: "../../../elsewhere/objects")))
        XCTAssertEqual(
            decode(
                #"{"state":"failed","condition":"config_not_located","key":"core.excludesfile","path":"ignore-rel"}"#
            ),
            .failed(.configNotLocated(key: "core.excludesfile", path: "ignore-rel")))
        XCTAssertEqual(GitCondition.allCases.count + 4, 15)
    }

    func test_configNotLocatedWithAMissingOrExtraMemberIsRefused() {
        let rejected = [
            #"{"state":"failed","condition":"config_not_located"}"#,
            #"{"state":"failed","condition":"config_not_located","key":"include.path"}"#,
            #"{"state":"failed","condition":"config_not_located","path":"~/x"}"#,
            #"{"state":"failed","condition":"config_not_located","key":"include.path","path":"~/x","extra":1}"#,
            #"{"state":"failed","condition":"config_not_located","key":"include.path","path":"~/x","git_directory":"/y"}"#,
            #"{"state":"failed","condition":"config_not_located","key":null,"path":"~/x"}"#,
            #"{"state":"failed","condition":"config_not_located","key":"include.path","path":7}"#,
        ]
        for payload in rejected {
            XCTAssertEqual(decode(payload), .stopped, payload)
        }
    }

    func test_aKeyAndPathUnderAConditionNamingNeitherObservationIsRefused() {
        for payload in [
            #"{"state":"failed","condition":"config_refused","key":"include.path","path":"~/x"}"#,
            #"{"state":"failed","condition":"not_a_root","key":"include.path","path":"~/x"}"#,
        ] {
            XCTAssertEqual(decode(payload), .stopped, payload)
        }
    }

    func test_configNamesOutsideDecodesWithExactlyItsFourMembers() {
        XCTAssertEqual(
            decode(
                #"{"state":"failed","condition":"config_names_outside","key":"core.excludesfile","path":"/Users/you/shared/ignore"}"#
            ),
            .failed(.configNamesOutside(key: "core.excludesfile", path: "/Users/you/shared/ignore"))
        )
        XCTAssertEqual(
            decode(
                #"{"path":"~/.gitignore_global","key":"includeIf.gitdir:~/work/.path","condition":"config_names_outside","state":"failed"}"#
            ),
            .failed(
                .configNamesOutside(
                    key: "includeIf.gitdir:~/work/.path", path: "~/.gitignore_global")),
            "the members are read by name, in any order")
    }

    func test_configNamesOutsideWithAMissingOrExtraMemberIsRefused() {
        let rejected = [
            #"{"state":"failed","condition":"config_names_outside"}"#,
            #"{"state":"failed","condition":"config_names_outside","key":"include.path"}"#,
            #"{"state":"failed","condition":"config_names_outside","path":"/x"}"#,
            #"{"state":"failed","condition":"config_names_outside","key":"include.path","path":"/x","extra":1}"#,
            #"{"state":"failed","condition":"config_names_outside","key":"include.path","path":"/x","git_directory":"/y"}"#,
            #"{"state":"failed","condition":"config_names_outside","key":null,"path":"/x"}"#,
            #"{"state":"failed","condition":"config_names_outside","key":"include.path","path":7}"#,
        ]
        for payload in rejected {
            XCTAssertEqual(decode(payload), .stopped, payload)
        }
    }

    func test_theAlternatesWireObjectDecodesToTheFailureWithItsValue() {
        for path in ["/Volumes/cache/objects", "../../../elsewhere/objects", "relative/objects"] {
            XCTAssertEqual(
                decode(
                    #"{"state":"failed","condition":"object_store_names_outside","path":"\#(path)"}"#
                ),
                .failed(.objectStoreNamesOutside(path: path)), path)
        }
        XCTAssertEqual(
            decode(
                #"{"path":"/x","condition":"object_store_names_outside","state":"failed"}"#),
            .failed(.objectStoreNamesOutside(path: "/x")),
            "the members are read by name, in any order")
    }

    func test_aMissingPathDecodesAsStopped() {
        for payload in [
            #"{"state":"failed","condition":"object_store_names_outside"}"#,
            #"{"state":"failed","condition":"object_store_names_outside","path":null}"#,
            #"{"state":"failed","condition":"object_store_names_outside","path":7}"#,
        ] {
            XCTAssertEqual(decode(payload), .stopped, payload)
        }
    }

    func test_anExtraKeyMemberDecodesAsStopped() {
        XCTAssertEqual(
            decode(
                #"{"state":"failed","condition":"object_store_names_outside","path":"/x","key":"include.path"}"#
            ),
            .stopped)
        XCTAssertEqual(
            decode(
                #"{"state":"failed","condition":"object_store_names_outside","path":"/x","extra":1}"#
            ),
            .stopped)
    }

    func test_anExtraGitDirectoryMemberDecodesAsStopped() {
        XCTAssertEqual(
            decode(
                #"{"state":"failed","condition":"object_store_names_outside","path":"/x","git_directory":"/y"}"#
            ),
            .stopped)
    }

    func test_aKeyAndAPathBesideAnotherConditionAreStopped() {
        for condition in GitCondition.allCases {
            XCTAssertEqual(
                decode(
                    #"{"state":"failed","condition":"\#(condition.rawValue)","key":"include.path","path":"/x"}"#
                ),
                .stopped, condition.rawValue)
        }
        XCTAssertEqual(
            decode(
                #"{"state":"failed","condition":"git_directory_outside","git_directory":"/x","key":"include.path","path":"/y"}"#
            ),
            .stopped)
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

    // CP-561: a member holding a value of the wrong JSON type does not conform either.
    func test_aMemberOfTheWrongTypeIsStopped() {
        let rejected = [
            #"[{"state":"pending"}]"#,
            #"{"state":1}"#,
            #"{"state":"observed","kind":"root","branch":"main","repository_state":"normal","staged":[],"changed":[]}"#,
            root(branch: #"{"kind":"branch","name":null}"#),
            root(branch: #"{"kind":"detached","commit":7}"#),
            root(staged: "{}"),
            root(changed: #"["a.txt"]"#),
            root(staged: #"[{"path":5,"category":"added"}]"#),
            root(staged: #"[{"path":"a","category":"renamed","from":null}]"#),
            #"{"state":"failed","condition":"git_directory_outside","git_directory":null}"#,
            #"{"state":"failed","condition":null}"#,
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
