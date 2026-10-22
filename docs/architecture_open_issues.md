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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-22, from a
> `shukuba-refine` review on the seed `ka-reader · nemawashi · 2026-10-01_the-bridge-runs-under-the-sanitizer`,
> to carry items 3.1 and 3.2 below. The NFDR is Settled, so without a companion they would reach no one.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 § 8 says the card's command does not run `checks/gate.sh` yet; it has run it since 2026-10-20

> **No `product-architecture` run wrote this item.** A `companion-self-answer` run raised it on
> 2026-10-22, in the Principal Architect's seat, while answering § 3.1 and § 3.2 of this file. No item
> asked for it. Reading § 8 whole to answer § 3.1, the run found the paragraph that § 3.1's sentence
> sits in describing a project card that has since moved. The reasoning is at
> `docs/trail/architecture/self_answer-56.md` § Raised on this document.

- **Lands in:** `nfdr.md` § 8 — the opening paragraph's quote of the card's test command and its pin
  (`docs/nfdr.md:L1475-L1501`), and *Until the card runs the script* (`:L1575-L1588`) — and every
  sentence that reads under that paragraph: QC-56 (`:L1610-L1612`), QC-64 (`:L1723-L1726`), QC-65
  (`:L1781-L1784`), § 9's harness-suites bullet (`:L2021-L2024`), § 9's `ka-reader-mac` bullet
  (`:L2211-L2213`), and RN-6, which the opening paragraph says is extended when the card moves.
- **Drafted into the records:** nothing yet. The change is proposed here, and only the fold may write
  it.
- **Rationale:** the paragraph is false now. § 8 quotes the card's test command as `cargo test
  --workspace --locked && ka-reader-mac/assemble.sh && swift test --package-path ka-reader-mac &&
  checks/structure.sh && checks/tests/test_structure.sh`, pinned at `kensaiapp-opensource@a4204e5b`.
  It also says the card's move to `checks/gate.sh` "is owed to `product-card`". The move landed at
  `kensaiapp-opensource@1941f963` (2026-10-20 17:14, "product-card: ka-reader — the test command runs
  checks/gate.sh (NFDR v59 § 8)"). The comment beside it landed at `85264c69`. The card's
  `**Test command:**` line now reads `checks/gate.sh` (`system/projects/ka-reader/project.md:L8` in
  the managing instance). Both commits landed two minutes after NFDR v59 (`ka-reader@2baeecf`, 17:12),
  and v60 (`ka-reader@435bb4e`) did not fold them. The paragraph says itself that it "goes false at the
  card's next move until RN-6 is extended". That move has happened. The consequence matters more than
  the quote. Five passages make `development-design` the gate for a rule because "no run issues" the
  script at a change. At `1941f963`, the card's command is the script, so a run does issue it. The
  fold would re-read the card, re-pin § 8 to it, extend RN-6, and re-derive each "until" against the
  card as it stands. A gate the script now holds moves to the script. A gate that rests on something
  else stays and names that ground; QC-64's *nothing else* half is one of these. Each pinned reading
  of an earlier tree stays as a dated record.
- **If overridden:** § 8 keeps describing a card that does not exist. Five entries keep naming a
  review as the only gate for rules a run now holds at every change. A contributor who reads them
  waits on a review that is no longer the only thing protecting them. Nothing supersedes and no ADR
  moves.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 § 8 counts the gate at 26 steps; at `ka-reader@389adad` it has 27
- **Raised by:** PM — 2026-10-22
- **Which record:** `nfdr.md` § 8, *Until the card runs the script* (`docs/nfdr.md:L1577`).
- **Tracked by:** `ka-reader · nemawashi · 2026-10-01_the-bridge-runs-under-the-sanitizer`
- **What it blocks:** nothing. The sentence is pinned to `ka-reader@8b93322` and is true of that tree;
  a reader takes it for the gate as it stands.
- **Where it shows:** `git show 8b93322:checks/gate.sh | grep -c '^run_step'` prints 27 (26 steps and
  the `run_step()` definition at `:L27`); at `ka-reader@389adad` the same count on `checks/gate.sh`
  prints 28, so 27 steps. The new one is *Bridge tests under the address sanitizer*
  (`checks/gate.sh:L57`), directly after *Test gate* (`:L50`). The whole gate exited 0 in the macOS
  guest with that step in it, the step printing `rustc 1.101.0-nightly (19833af72 2026-10-20)` before
  the bridge's `test result:` lines.
- **If a document has to be written:** none. The fold would add a dated, commit-pinned reading of the
  27-step gate and keep the `8b93322` statement, which stays true of that tree.
- **Answer:** Fold it as the item proposes: a correction, not a widening. Keep the `8b93322`
  sentence as a dated record of that tree. Beside it, add the gate as it stands, pinned to
  `ka-reader@389adad`, version 1.1.0 (`checks/gate.sh:L2`), with 27 steps.
  `grep -c '^run_step' checks/gate.sh` prints 28, which is 27 steps plus the dispatcher at `:L27`. The
  same count on `git show 8b93322:checks/gate.sh` prints 27. The new step is *Bridge tests under the
  address sanitizer* (`:L57`), between *Test gate* (`:L50`) and *Structure check* (`:L58`). The tree
  this run read, `ka-reader@9ce336b`, carries `389adad`, and `git diff --stat 389adad 9ce336b --
  checks/gate.sh` prints nothing. The guest pass is cited as the PM's measurement in this item, from
  the trail copy the fold makes. No commit is named for it, because the item names none. This was
  decided together with § 2.1, which re-reads the same paragraph against the card. If § 2.1 is
  confirmed, this dated reading stays as a record while the paragraph around it is re-derived.
  Reasoning: `docs/trail/architecture/self_answer-56.md` § 3.1.

### 3.2 QC-13's sanitizer run is met with the sanitizer's global-variable checks switched off
- **Raised by:** PM — 2026-10-22
- **Which record:** `nfdr.md` § 1.2 QC-13's *verified by* (`docs/nfdr.md:L524-L527`, "the bridge's
  tests under `-Zsanitizer=address` in CI on every build (layer 2)") and its § 10 row
  (`docs/nfdr.md:L2285`). `docs/SDD.md` § 11 R-13 (`:L3195-L3202`) states the same run.
- **Tracked by:** `ka-reader · nemawashi · 2026-10-01_the-bridge-runs-under-the-sanitizer`
- **What it blocks:** nothing today. It decides whether the step as it stands meets QC-13 or owes a
  later change.
- **Where it shows:** the gate step passes `-Cllvm-args=-asan-globals=0` beside `-Zsanitizer=address`
  (`checks/gate.sh:L57`), and its comment gives the reason: without it the linker refuses the bridge's
  load-time initializer once that initializer is instrumented (`checks/gate.sh:L55-L56`). The flag
  turns off the sanitizer's instrumentation of global and static variables, so an overflow of one of
  those is not reported. Heap faults are: with one bridge test changed to overflow a heap buffer, the
  step's command exited 101 with `AddressSanitizer: heap-buffer-overflow`. QC-13 names the flag and
  says nothing of which checks the run must keep.
- **If a document has to be written:** QC-13 would say whether its sanitizer run admits the
  global-variable checks being off, and why. The PM's lean is that it does: the seam R-13 guards is
  buffers handed across the C ABI and freed by `ka_reader_free`, which are heap, and the bridge holds
  no logic of its own in statics. If the record rules otherwise, a later change has to find another
  way to link the load-time initializer under the sanitizer.
- **Answer:** The step meets QC-13. QC-13's *verified by:* tail should say that its sanitizer run admits
  `-Cllvm-args=-asan-globals=0`, give the reason and give the limit. § 10's QC-13 row names the flag
  too. **Reason.** R-13 guards against a buffer freed twice or never, and a lifetime crossed. Every
  buffer the bridge hands across the C ABI is an owned heap buffer that `ka_reader_free` frees, as
  QC-13 already requires. The flag removes only the padding around globals. In LLVM, `if
  (Opts.asan_globals)` wraps `instrumentGlobals` alone (`AddressSanitizer.cpp:L2645`, llvm-project
  `main` at `044150762369`, read 2026-10-22). Load, store, heap and stack checks still run, and the PM
  saw a heap overflow reported. At `389adad`, every `unsafe` site in the bridge works on a caller's
  pointer, a heap box or the stack. None works on a static, and safe Rust bounds-checks any static it
  indexes. **Why it is needed.** LLVM skips ELF's init arrays but not Mach-O's `__mod_init_func`
  (`shouldInstrumentGlobal`, `:L1986-L1992`). So `INSTALL_LOG_AT_LOAD` (`exports.rs:L141-L143`) gets
  padding and the linker refuses it, as `checks/gate.sh:L55-L56` records. **Limit.** The flag reaches
  every crate built for the host target, not only the bridge. It costs nothing in `ka-reader-core`,
  which holds no `unsafe`. The admission lapses for any change that hands a static across the ABI or
  reaches one through a raw pointer. Such a change already breaks QC-13's owned-buffer rule, and
  `development-design` reading QC-13 is its gate. If a later toolchain links the instrumented
  initializer, the gate can drop the flag with no NFDR change. A leak (a buffer "freed never") is not
  something this ruling claims the run catches. No ADR, and no `QC` added or renumbered. SDD R-13's
  words stand. Reasoning: `docs/trail/architecture/self_answer-56.md` § 3.2.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
