# Self-answer report — `docs/adr/` and `docs/nfdr.md`

This report records one unattended run that answered `docs/architecture_open_issues.md` in the
owner's seat. It is written for the owner, who reads it to learn what was decided and why. It is also
written for the `product-architecture` run that folds the answer.

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-03
- **Sources re-read:** None. The answer rests on this repository alone: `crates/`, `.github/` and
  `docs/` at `nozoki@b7ff27a`, and on the commands named below. Nothing outside the repository was
  relied on, and nothing was read on the web.

**What this run read.** The companion, whole. From `docs/nfdr.md`: the header and preamble
(`:L1-L44`), QC-5 whole (`:L182-L207`), QC-15 whole (`:L406-L441`), § 10's preamble and its QC-1 to
QC-7 rows (`:L1475-L1502`), and RN-45 whole (`:L4010-L4059`). ADR-0018's § Consequences
(`:L88-L95`), and a grep of the record for its pins at `nozoki@8edec4f`. The three named test cases
and the helpers they call (`crates/nozoki-core/tests/root_finding.rs:L24-L68`, `:L160-L215`). The
adapter's `.git`-entry dispatch and `probe_git_file`
(`crates/nozoki-core/src/git_reader/libgit2.rs:L44-L72`). CI's test step
(`.github/workflows/ci.yml:L20-L30`). **Not read whole:** `docs/nfdr.md` (379 KB) and `docs/SDD.md`
(492 KB). The answer is checked against the entries it moves or rests on, which are listed above.

**Run, not only read, at `nozoki@b7ff27a`.**
- `git diff --stat 48308ff HEAD -- checks crates nozoki-mac .github Cargo.toml Cargo.lock` prints
  nothing, so a pin at the merge `nozoki@48308ff` is a pin on this tree.
- `git log 1d81e12..HEAD -- docs/SRS.md docs/SDD.md docs/fdr.md docs/PRD.md docs/UXD.md
  docs/DESIGN.md docs/CONTENT.md` prints nothing, so no input moved under QC-5's traces.
- `cargo test --locked -p nozoki-core --test root_finding` prints "37 passed; 0 failed". The three
  named cases are among them, each `ok`.

## Items worked

### 2.1 — QC-5's *verified by* said its three named cases were unwritten and would go red until the provisional `.git`-file arm was replaced; that change has landed, and all three cases are written and pass

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** **Keep the v34 tail, and add one clause.** The clause says what the missing-directory case
  does not catch and where that half of the bound is held.

  *Check 1 — whose.* The edit lands in `docs/nfdr.md` QC-5, this companion's own document. It binds
  only the record's agreement with the tree. It commits no person, no outside party and no risk
  anyone carries. This seat answers it.

  *Check 2 — is the draft sound?* Every fact in the drafted tail matched the tree when re-measured:
  - The three cases exist under the names the tail gives (`root_finding.rs:L175`, `:L185`, `:L196`).
  - Each asserts `RootFinding::Root`.
  - Each passes.
  - The adapter sends a `.git` regular file to `probe_git_file` (`libgit2.rs:L46`), which is defined
    at `:L58`.
  - CI runs the target inside `cargo test --workspace --locked` (`ci.yml:L26`).
  - The tree has not moved since `nozoki@48308ff`.

  The draft's reason also holds. The old forward clause ("all three go red … until the change …
  lands") described a change that has happened. Read now, it says the read bound has no check, and
  it has one. Keeping the old text as a dated parenthetical follows the document's own practice, the
  same form QC-15's tail uses (`nfdr.md:L431-L435`).

  *The addition, and why the draft needs it.* The tail calls the missing-directory case "the case
  that goes red if `probe` ever follows the pointer, so the read bound has a check". That is true of
  a `probe` whose attempt to follow the pointer changes its answer. It is not true of every `probe`
  that follows it. The case checks three things: the answer, that the answer holds no path, and that
  the scene is unchanged (`root_finding.rs:L24-L37`, `:L65-L68`). Reading a directory changes none of
  them. A `probe` that tries the named directory, swallows the failed open and still answers `Root`
  breaks the bound and passes the case.

  That half of the bound already has a gate. QC-15's tail lists "which read the adapter makes inside
  its owner file" as one of the two parts the script does not hold. It names review at
  `development-design` as their gate (`nfdr.md:L424-L432`). QC-5 does not point there. A cold reader
  of QC-5 could take the test as the whole bound. That is the misreading this item exists to remove,
  in the other direction: the old tail said the bound had no check, and the new one can be read as
  saying the check is complete.

  So the fold adds one clause to QC-5's *verified by*. The missing-directory case catches a follow
  that changes the answer. A follow that does not change it is QC-15's review half at
  `development-design`. It is a pointer, not a restatement of QC-15.

  *Check 3 — does it contradict anything settled?*
  - **QC-5's body does not move.** It states the bound; only its tail moves.
  - **§ 10's QC-5 row does not move.** It names the same command, gated at
    `development-implementation`, as the QC-4 row gates its `cargo test` (`nfdr.md:L1499-L1500`). The
    tail's CI citation is a fact about where the command also runs. It does not change the gate.
  - **ADR-0018 does not move.** Its § Consequences says "a `probe` that ever follows the pointer turns
    that case red" (`adr/0018-…:L91-L92`). That carries the same imprecision the addition corrects.
    But the record is append-only, and its decision ("`probe` reads only inside the opened folder")
    stands. The sentence is a consequence stated at too coarse a grain, not a decision that changed,
    and superseding a record to sharpen one consequence would not pass the significance test. The
    NFDR is where the binding precision lives, and the addition puts it there.
  - **No input moved.** None of QC-5's traces has moved since the last fold; the inputs log above
    prints nothing.

  *Check 4 — failure paths.*
  - **Stale.** The next edit to `root_finding.rs` or `libgit2.rs` moves these line numbers. The pin at
    `nozoki@48308ff` makes that a re-measurement rather than a contradiction. A test that is renamed
    leaves the tail naming a function that no longer exists, while § 10's command still runs every
    case. The pin is what lets a reader tell those apart.
  - **Absent.** If the `linked-worktree` or `submodule` fixture archive is missing,
    `archived_scene` unpacks nothing it can use (`root_finding.rs:L49-L54`), and the case cannot
    answer `Root`. The bound fails closed.
  - **Refused.** An unreadable `.git` file is a separate condition with its own cases. It is not this
    item's.
  - **Concurrent and empty.** Neither applies to a statement of what a test covers.

  *What was close.* I nearly answered *confirmed* with no addition. The draft is accurate on every
  fact it states, and the clause I added was in the tail before v34 too. It was not this draft's
  error. What tipped it: v34 rewrites this tail precisely so that a reader learns how much of the
  bound has a check. A fold that fixes "no check" while leaving "the check is complete" standing gets
  that reader half right. The clause costs one sentence in the same fold.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
