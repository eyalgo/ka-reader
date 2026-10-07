# Architecture open issues — Nozoki

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
> walk fixture, and both are closed at `nozoki@b12e48c`. The NFDR is Settled, and with no companion
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
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. QC-2's tail tells a reader that no case asserts what
  `read_git` answers on `submodule`, and that the `submodule` run is made by hand. At
  `nozoki@b12e48c` both are false, so the obligation reads as less verified than it is.
- **Where it shows:** QC-2, *verified by*, the tail: "`plain`, `repo` and `submodule` are walk
  fixtures, and two limits stand beside `submodule` until a change closes them: the walk drops the
  Git answer (`checks/walk.rs:L288-L292`), so no case asserts what `read_git` answers on it; and CI
  runs the walk on `plain` and `repo` alone (`.github/workflows/ci.yml:L68`, `:L71` at
  `nozoki@076eac2`), so the `submodule` run is made by hand until it joins them"
  (`docs/nfdr.md:L107-L111`). At `nozoki@b12e48c`:
  - CI's step `Read-only, submodule` runs `checks/read-only.sh checks/fixtures/submodule`
    beside the `plain` and `repo` steps (`.github/workflows/ci.yml:L73-L74`).
  - `crates/nozoki-core/tests/git_state.rs:L787` asserts `read_git`'s whole answer on the fixture
    as the restore builds it, in a disposable copy (layer 2). That answer is `root`, `main` in the
    normal state, staged empty, and changed = {`submodule` modified, `README.md` untracked}.
  - `:L771`, `:L802`, `:L815` and `:L828` hold the scene and the three layouts in which the
    answer moves.

  Measured on a disposable copy of `nozoki@b12e48c`: the three walks printed `unchanged`, and
  `cargo test --workspace --locked` printed 23 `test result: ok` lines and no `FAILED`. The walk
  still drops the answer; the case is what asserts it. The step's result on the hosted runner has
  not been read: `origin/main` is at `nozoki@799c3d6`. § 10's QC-2 row reads "on every walk fixture"
  and does not change. The SDD's own clause is raised on `SDD_open_issues.md` § 5.1. The likely
  fold is the tail restated with both limits closed, naming the step and the case, and the old
  words kept in a dated note.
- **If a document has to be written:** none. A change in `nfdr.md` QC-2, written by
  `product-architecture`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
