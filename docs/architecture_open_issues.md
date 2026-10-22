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

None.

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
- **Answer:** <the owner fills this in>

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
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
