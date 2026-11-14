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

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 § 5 does not say where the Git view's memory ceiling stands against QC-45

> A `companion-self-answer` run raised this item on 2026-11-14
> (`docs/trail/architecture/self_answer-96.md`, *Raised on this document*). No producing run wrote it.
> It came from reading the NFDR against the tree while answering § 3.1: the step that item names runs
> a suite asserting a memory number, and § 5 says the records assert none. Its slot is left for the
> next round.

- **Lands in:** `nfdr.md` § 5 (QC-45, or a sentence beside it). No ADR.
- **Drafted into the records:** nothing yet. The lean is that § 5 names the ceiling and says what it
  is. `ka-reader-mac/Tests/ShellTests/GitViewMemoryBoundTests.swift:L18` at `ka-reader@21f611f`
  asserts that the process's peak resident size rises by at most 154,000,000 bytes while the Git view
  is driven over a large repository, and the gate's *Git view memory bound* step holds it at every
  change (`checks/gate.sh:L104`). § 5 would state that this ceiling is a regression bound the
  delivery tier set from the owner's walk of a large repository. It is not a product requirement, it
  binds no change's bar beyond that suite, and making it one is the SRS's by revision, under QC-45's
  own rule. QC-45 names file-switch latency, refresh latency and a reference folder size, and no
  memory figure, so the ceiling breaks no rule as written. No obligation changes.
- **Rationale:** § 5 opens by saying the SRS leaves every number unset and that the section "asserts
  no number of its own" (`docs/nfdr.md:L1794-L1796`). QC-45 opens "A performance number is measured,
  never asserted". No SRS, SDD or FDR revision carries the 154,000,000-byte figure. The SDD records
  it only as the suite's, in § 3's `read-only-harness` row (RN-175). So since `21f611f` a cold reader
  meets a gated, asserted capacity number that § 5 does not mention. That reader cannot tell whether
  the suite breaks QC-45 or the NFDR has not seen it. The run is unsure the gap is worth a cycle,
  because nothing in § 5 is false as worded. It is raised because §§ 3.1–3.2 already owe this file a
  fold, so naming the ceiling costs no extra run.
- **If overridden:** § 5 stays silent on the ceiling. The suite stays as it is, and QC-45's opening
  sentence keeps reading against a number it does not name.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records


### 3.1 § 8 quotes the test gate as it stood before the gate split the Git view memory suite out
- **Raised by:** PM — 2026-11-14
- **Which record:** `nfdr.md` § 8, the paragraph opening "The execution context"
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; a reader of § 8 is given a test-gate command the gate no longer runs, and is not told of the step that now runs the Git view's memory cases.
- **Where it shows:** § 8 quotes the test gate as `cargo test --workspace --locked && swift test --package-path ka-reader-mac` (`docs/nfdr.md:L2158`). At `ka-reader@21f611f` *Test gate* reads `cargo test --workspace --locked && swift test --package-path ka-reader-mac --skip "^ShellTests\.GitViewMemoryBoundTests/"` (`checks/gate.sh:L98`, Version 1.22.0), and two steps follow it, *Git view memory bound* (`checks/git-view-memory.sh`, `:L104`), which runs each of that suite's cases alone in a process of its own because each reads a process-wide high-water mark, and *Git view memory bound suite* (`checks/tests/test_git_view_memory.sh`, `:L105`). § 8 should quote the command as the gate now holds it and name the new step beside the test gate.
- **If a document has to be written:** none.
- **Answer:** confirmed with addition. § 8's first paragraph quotes the test gate as `checks/gate.sh` holds it at `ka-reader@21f611f` (Version 1.22.0; the tree outside `docs/` is unchanged at `ka-reader@32bdbc1`): `cargo test --workspace --locked && swift test --package-path ka-reader-mac --skip "^ShellTests\.GitViewMemoryBoundTests/"`, with the workspace build at `checks/gate.sh:L87`, the bridge's assembly at `:L97` and the test gate at `:L98`; the unskipped command and the `f25fdbb` locators are kept as a dated reading, as every earlier pin in that paragraph is. Beside the test gate the paragraph names the two steps that now follow it, *Git view memory bound* (`:L104`, `checks/git-view-memory.sh`) and *Git view memory bound suite* (`:L105`, `checks/tests/test_git_view_memory.sh`), before the sanitizer step (`:L112`) and the structure pair (`:L113-L114`), and why: each of the suite's two cases reads the whole process's peak resident size, so the test gate skips the suite and the step runs each case alone, in a `swift test` of its own. The addition: § 9's runner paragraph, the Swift runner's one home, states the same one-case-per-process precondition beside its other run preconditions, because its sentence that every `verified by:` tail naming `swift test --package-path ka-reader-mac` reads under it is now read against a gate run that skips one suite; no tail in the NFDR names that suite, so no tail is made false. No obligation and no record changes. Reasoning: `docs/trail/architecture/self_answer-96.md` § 3.1.

### 3.2 § 9 counts twenty-nine suites where the tree holds thirty
- **Raised by:** PM — 2026-11-14
- **Which record:** `nfdr.md` § 9, the suites bullet
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; the pinned count is a re-measurement behind the tree.
- **Where it shows:** the bullet counts twenty-nine top-level shell suites at `ka-reader@03bb989` with `checks/gate.sh` 1.20.0 (`docs/nfdr.md:L3142-L3144`). At `ka-reader@21f611f` there are thirty (`git ls-tree --name-only main checks/tests/ | grep -c '/test_.*\.sh$'` → `30`); the new one is `checks/tests/test_git_view_memory.sh`, mode 100755, the whole command of *Git view memory bound suite* (`checks/gate.sh:L105`, Version 1.22.0). Re-measure at the current main line.
- **If a document has to be written:** none.
- **Answer:** confirmed with addition. Re-measured at `ka-reader@21f611f01ae8dc03c1e5341d1eafc0f3b0e2cdce` (`checks/gate.sh` Version 1.22.0; the tree outside `docs/` is unchanged at `ka-reader@32bdbc1`): thirty top-level shell suites, each the whole command of one `run_step` line — `test_secret_scan.sh` (`checks/gate.sh:L76`), `test_secret_scan_planted.sh` (`:L94`), `test_git_view_memory.sh` (`:L105`), `test_structure.sh` (`:L114`), `test_entry_points.sh` (`:L116`), `test_app_icon.sh` (`:L124`), `test_assemble.sh` (`:L128`), `test_bundle.sh` (`:L131`), `test_view.sh` (`:L133`), `test_renderer.sh` (`:L143`), `test_read_only.sh` (`:L154`), `test_no_network.sh` (`:L156`), `test_notices.sh` (`:L164`), `test_offline_page.sh` (`:L166`), `test_strings.sh` (`:L172`), `test_strings_step.sh` (`:L173`), `test_readme.sh` (`:L177`), `test_git_beta.sh` (`:L179`), `test_release_shape.sh` (`:L186`), `test_release_version.sh` (`:L187`), `test_release_pack.sh` (`:L188`), `test_release_sums.sh` (`:L189`), `test_release_absent.sh` (`:L190`), `test_own_state.sh` (`:L191`), `test_vm_refusal.sh` (`:L198`), `test_launch.sh` (`:L199`), `test_own_state_step.sh` (`:L200`), `test_tree_scene.sh` (`:L201`), `test_git_beta_scene.sh` (`:L202`) and `test_git_beta_walk.sh` (`:L203`). The new suite pairs by name with `checks/git-view-memory.sh`, so "Four of the twenty-nine" becomes "Four of the thirty", the same four; the tail's "all twenty-nine" becomes "all thirty"; and the twenty-nine at `03bb989` is kept as a dated reading, as each earlier count is. The addition: every other suite's line moved too — two lines down above old `:L96`, nine at or below old `:L97` — so the fold re-pins the whole list, not only the count. Reasoning: `docs/trail/architecture/self_answer-96.md` § 3.2.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
