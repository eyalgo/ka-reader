import Testing
import Surfaces

struct GitReadPolicyTests {
    private var failures: [GitFailure] {
        [.gitDirectoryOutside(gitDirectory: "空 白/.git"),
         .configNamesOutside(key: "submodule.a.path", path: "../空 白"),
         .configNotLocated(key: "include.path", path: "~/空 白"),
         .objectStoreNamesOutside(path: "../objects"),
         .objectStoreNotLocated(path: "relative/objects"),
         .submoduleElsewhere(name: "空 白", path: "elsewhere")]
         + GitCondition.allCases.map { .condition($0) }
    }

    private var repositories: [GitItem] {
        RepositoryState.allCases.flatMap { state in
            [[], [GitEntry(path: "空 白.swift", category: .modified)]].map { entries in
                GitItem.repository(GitRepository(branch: .named("main"), state: state,
                                                  staged: entries, changed: entries))
            }
        }
    }

    @Test func atOpenLabelsEveryRepositoryState() {
        for item in repositories { #expect(GitReadPolicy.atOpen.showsNotice(for: item)) }
    }

    @Test func atOpenLabelsOnlyObservedFailures() {
        let unexplained: [GitCondition] = [.probeRepositoryReadFailed, .notARoot,
                                          .repositoryReadFailed, .machineConfigNotSwitchedOff]
        for failure in failures {
            let observed: Bool
            if case .condition(let condition) = failure {
                observed = !unexplained.contains(condition)
            } else { observed = true }
            #expect(failure.hasObservedCondition == observed)
            #expect(GitReadPolicy.atOpen.showsNotice(for: .failed(failure)) == observed)
        }
    }

    @Test func pendingPlainAndStoppedHaveNoNotice() {
        for policy in [GitReadPolicy.atOpen, .followed] {
            for item in [GitItem.pending, .plain, .stopped] {
                #expect(!policy.showsNotice(for: item))
            }
        }
    }

    @Test func followedNeverShowsTheBetaNotice() {
        for item in repositories + failures.map({ .failed($0) }) + [.pending, .plain, .stopped] {
            #expect(!GitReadPolicy.followed.showsNotice(for: item))
        }
    }

    @Test func productionBuildUsesAtOpenPolicy() {
        #expect(GitReadPolicy.build == .atOpen)
    }
}
