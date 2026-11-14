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

None.

## 3. Raised from downstream — an item from a seat that did not write these records


### 3.1 § 8 quotes the test gate as it stood before the gate split the Git view memory suite out
- **Raised by:** PM — 2026-11-14
- **Which record:** `nfdr.md` § 8, the paragraph opening "The execution context"
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; a reader of § 8 is given a test-gate command the gate no longer runs, and is not told of the step that now runs the Git view's memory cases.
- **Where it shows:** § 8 quotes the test gate as `cargo test --workspace --locked && swift test --package-path ka-reader-mac` (`docs/nfdr.md:L2158`). At `ka-reader@21f611f` *Test gate* reads `cargo test --workspace --locked && swift test --package-path ka-reader-mac --skip "^ShellTests\.GitViewMemoryBoundTests/"` (`checks/gate.sh:L98`, Version 1.22.0), and two steps follow it, *Git view memory bound* (`checks/git-view-memory.sh`, `:L104`), which runs each of that suite's cases alone in a process of its own because each reads a process-wide high-water mark, and *Git view memory bound suite* (`checks/tests/test_git_view_memory.sh`, `:L105`). § 8 should quote the command as the gate now holds it and name the new step beside the test gate.
- **If a document has to be written:** none.
- **Answer:**

### 3.2 § 9 counts twenty-nine suites where the tree holds thirty
- **Raised by:** PM — 2026-11-14
- **Which record:** `nfdr.md` § 9, the suites bullet
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; the pinned count is a re-measurement behind the tree.
- **Where it shows:** the bullet counts twenty-nine top-level shell suites at `ka-reader@03bb989` with `checks/gate.sh` 1.20.0 (`docs/nfdr.md:L3142-L3144`). At `ka-reader@21f611f` there are thirty (`git ls-tree --name-only main checks/tests/ | grep -c '/test_.*\.sh$'` → `30`); the new one is `checks/tests/test_git_view_memory.sh`, mode 100755, the whole command of *Git view memory bound suite* (`checks/gate.sh:L105`, Version 1.22.0). Re-measure at the current main line.
- **If a document has to be written:** none.
- **Answer:**

**How it closes.** `product-architecture` folds it on its next run like any other item here.
