# Architecture open issues — KA-Reader

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the SRS, the SDD
> and the FDR.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-architecture`. It folds your answers into the records and drops the resolved items.
> When nothing is left open, `product-architecture` **deletes this file**: no file = the records are
> done.
>
> Your answers are never thrown away. Each time the Principal Architect folds them in, it first copies
> this file whole to `docs/trail/architecture/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 is raised, not asked.** These records bind every later change, so the seats that live under
> them find gaps the authoring run could not. § 3 is where such a seat says so, against both records
> — an ADR's binding and an NFDR obligation reach the same file.

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-07 from the
> architecture companion template. QC-2's *verified by* tail states two limits beside the `submodule`
> walk fixture, and both are closed at `ka-reader@b12e48c`. The NFDR is Settled, and with no companion
> on disk a `product-architecture` re-run has nothing to act on. Its one item is in § 3.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-2 says two limits stand beside the `submodule` walk fixture until a change closes them, and both are closed
- **Raised by:** PM — 2026-10-07
- **Which record:** `nfdr.md` QC-2
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. QC-2's tail tells a reader that no case asserts what
  `read_git` answers on `submodule`, and that the `submodule` run is made by hand. At
  `ka-reader@b12e48c` both are false, so the obligation reads as less verified than it is.
- **Where it shows:** QC-2, *verified by*, the tail: "`plain`, `repo` and `submodule` are walk
  fixtures, and two limits stand beside `submodule` until a change closes them: the walk drops the
  Git answer (`checks/walk.rs:L288-L292`), so no case asserts what `read_git` answers on it; and CI
  runs the walk on `plain` and `repo` alone (`.github/workflows/ci.yml:L68`, `:L71` at
  `ka-reader@076eac2`), so the `submodule` run is made by hand until it joins them"
  (`docs/nfdr.md:L107-L111`). At `ka-reader@b12e48c`:
  - CI's step `Read-only, submodule` runs `checks/read-only.sh checks/fixtures/submodule`
    beside the `plain` and `repo` steps (`.github/workflows/ci.yml:L73-L74`).
  - `crates/ka-reader-core/tests/git_state.rs:L787` asserts `read_git`'s whole answer on the fixture
    as the restore builds it, in a disposable copy (layer 2). That answer is `root`, `main` in the
    normal state, staged empty, and changed = {`submodule` modified, `README.md` untracked}.
  - `:L771`, `:L802`, `:L815` and `:L828` hold the scene and the three layouts in which the
    answer moves.

  Measured on a disposable copy of `ka-reader@b12e48c`: the three walks printed `unchanged`, and
  `cargo test --workspace --locked` printed 23 `test result: ok` lines and no `FAILED`. The walk
  still drops the answer; the case is what asserts it. The step's result on the hosted runner has
  not been read: `origin/main` is at `ka-reader@799c3d6`. § 10's QC-2 row reads "on every walk fixture"
  and does not change. The SDD's own clause is raised on `SDD_open_issues.md` § 5.1. The likely
  fold is the tail restated with both limits closed, naming the step and the case, and the old
  words kept in a dated note.
- **If a document has to be written:** none. A change in `nfdr.md` QC-2, written by
  `product-architecture`.
- **Answer:** confirm the likely fold, with four additions. Restate QC-2's tail with both limits closed at `ka-reader@b12e48c`, naming the CI step `Read-only, submodule` (`.github/workflows/ci.yml:L73-L74`) and the case `crates/ka-reader-core/tests/git_state.rs:L787`, and keep the old words in a dated note. (1) The case holds QC-2's own obligation too, not only the answer: `read_git_over` snapshots the whole scene before and after the call and asserts they are equal (`:L730-L738`), so the tail names it as a layer-2 no-write proof on the restored `submodule` beside the answer it asserts. (2) The CI half is bounded: the step is in the workflow, and its result on the hosted runner is unread, because `b12e48c` is on no remote branch and `origin/main` is at `ka-reader@799c3d6`. The tail says that, and it does not read as a green run. (3) The sentence that the walk drops the Git answer (`checks/walk.rs:L288-L292`) stays, as the reason the case and not the walk holds the answer. (4) The trace moves from "SDD § 4 C-I3 and § 6 S-4, command half, as they read at v42" to § 6 S-4 as it reads at v47 (SDD RN-107), and the v42 reading stays in the dated note. Nothing else moves: § 10's QC-2 row, § 9's suite count (pinned at `ka-reader@b158052`, and its own sentence makes an inserted step a re-measurement), the export-set clause, and every ADR. Reasoning: `docs/trail/architecture/self_answer-45.md`.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
