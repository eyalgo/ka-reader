# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. Both items name `docs/nfdr.md`, and neither touches a
  record.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-22
- **Sources re-read:** LLVM's `llvm/lib/Transforms/Instrumentation/AddressSanitizer.cpp`, fetched from
  llvm-project `main` on 2026-10-22, with `main` at `044150762369` when it was fetched. It shows two
  things. First, `if (Opts.asan_globals)` wraps the call to `instrumentGlobals` and nothing else
  (`:L2645-L2654`), so the option controls the padding around globals and no other instrumentation.
  Second, `shouldInstrumentGlobal` skips ELF's `.preinit_array`, `.init_array` and `.fini_array`
  (`:L1986-L1992`, "dynamic linker will not properly handle redzones"), and the file never mentions
  Mach-O's `__mod_init_func`. One caveat: the guest's `nightly-2026-10-21` rustc ships its own fork of
  LLVM, which this run did not read. The answer leans on the upstream reading and on the gate's own
  measured comment (`checks/gate.sh:L55-L56`), and the two agree.
  **What was read in this repository, at `ka-reader@9ce336b`, which contains `389adad`:** the NFDR's
  header (`docs/nfdr.md:L1-L47`); § 8 from its opening paragraph through QC-56
  (`:L1473-L1612`); QC-13 (`:L513-L531`) and its § 10 row (`:L2285`); and every passage that reads under
  *Until the card runs the script* (`:L1611`, `:L1724`, `:L1782`, `:L2022`, `:L2212`). The NFDR was not
  read whole, because it runs to 6,434 lines. From the SDD: § 11 R-13 (`docs/SDD.md:L3207-L3214`) and
  RN-117, the fold that left both items here open (`:L8865-L8935`). From the code: `checks/gate.sh`
  whole, and every `unsafe` site and every static in `crates/ka-reader-bridge/src/`. From the managing
  instance: the project card's `**Test command:**` line
  (`system/projects/ka-reader/project.md:L8`) and that file's git log.

## Items worked

### 3.1 — § 8 counts the gate at 26 steps; at `ka-reader@389adad` it has 27

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item is right, and the fold should do what it proposes. The NFDR's sentence is pinned
  to `8b93322` and is still true of that tree. It is false as a description of the gate today, and a
  reader takes it as one. This is a correction, so the "widening waits until it occurs" rule does not
  apply.
  - **Seat.** It is the Principal Architect's. The edit lands in `nfdr.md` § 8 and commits no one but
    this document.
  - **Re-measured, not taken from the item.** At the tree this run read,
    `grep -c '^run_step' checks/gate.sh` prints 28, which is 27 steps plus the `run_step()`
    definition at `:L27`. The same count on `git show 8b93322:checks/gate.sh` prints 27.
    `git diff --stat 389adad HEAD -- checks/gate.sh` prints nothing, so `389adad` is still the gate
    as it stands. The script's version line, `checks/gate.sh:L2`, reads 1.1.0. The new step,
    *Bridge tests under the address sanitizer*, is at `:L57`, between *Test gate* (`:L50`) and
    *Structure check* (`:L58`).
  - **The additions.**
    1. The fold should pin the reading to `389adad` and give the version line. A bare count goes
       stale at the next step, just as the 26 did.
    2. Check 4's stale case: the item says the gate passed in the guest with this step in it, but
       it names no commit for that run. The fold should cite the guest pass as the PM's measurement,
       through the trail copy it makes of this file, and should not invent a commit for it.
    3. Check 3: this answer was decided together with § 2.1, which this run raised on the same
       paragraph. If § 2.1 is confirmed, the paragraph around this sentence is re-derived against the
       card. The `8b93322` and `389adad` readings stay either way, as dated records of the tree.
  - **What would have tipped it.** A plain *confirmed* would have done if the item had pinned the
    guest run to a commit, or if the paragraph had not also been stale on the card.

### 3.2 — QC-13's sanitizer run is met with the sanitizer's global-variable checks switched off

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** QC-13's sanitizer run admits `-Cllvm-args=-asan-globals=0`. QC-13's *verified by:* tail
  should say so, with the reason and the limit, and § 10's QC-13 row should name the flag. The
  answer is not an ADR, adds no `QC` and renumbers none, and SDD R-13's words stand.
  - **Seat.** The ruling is the Principal Architect's. It decides what QC-13's verification admits and
    lands in `nfdr.md`. It commits no person or outside party, so it is not the owner's call. It
    widens the document, but it cites an occurrence: the flag is in the tree at
    `checks/gate.sh:L57`. So it is answered, not "not until it occurs".
  - **The PM's lean is right, and one of its two reasons is not.** The lean has two reasons.
    - "The seam R-13 guards is heap buffers" holds. Every buffer the bridge hands across the C ABI
      is an owned heap buffer that `ka_reader_free` frees, and QC-13 already requires that.
    - "The bridge holds no logic of its own in statics" does not carry the weight. What matters is
      not logic but whether any unsafe code reaches a static's memory. At `389adad`, every `unsafe`
      site in `crates/ka-reader-bridge/src/` works on a caller's pointer, a heap box or the stack.
      That covers `boundary.rs`'s decoding and `CStr` reads, `exports.rs`'s `Box::from_raw`, the
      zeroed `passwd` entry in `log_install.rs`, and `machine_config.rs`'s libgit2 call. None works
      on a static. The bridge's statics are `SESSION`, `PROCESS`, `INSTALLED` and
      `INSTALL_LOG_AT_LOAD`, and safe Rust bounds-checks anything it indexes in them.
  - **What the flag turns off, read at the source.** The flag controls only the padding around
    globals; loads, stores, heap and stack are still checked. LLVM wraps `instrumentGlobals` and
    nothing else in `if (Opts.asan_globals)`. The PM saw this from the other side: with a test that
    overflows a heap buffer, the step reported `heap-buffer-overflow` and exited 101.
  - **Why the flag is needed.** LLVM declines to pad ELF's init arrays, because the dynamic linker
    cannot handle the padding. It makes no such exception for Mach-O's `__mod_init_func`. So the
    bridge's `INSTALL_LOG_AT_LOAD` (`exports.rs:L141-L143`) gets padded, and the linker refuses it,
    as `checks/gate.sh:L55-L56` records.
  - **Check 3.** QC-13's tail says "the bridge's tests under `-Zsanitizer=address`" and does not
    say which checks the run keeps. R-13 names a buffer freed twice or never, a lifetime crossed and
    a panic unwinding, and none of these lives in a static. The SDD's RN-117 explicitly leaves this
    ruling to the Principal Architect and does not move R-13. Nothing settled contradicts the
    answer.
  - **Check 4.**
    - *Breadth:* the flag sits in the target's rustflags, so it reaches every crate built for the
      host, not only the bridge. In `ka-reader-core` that costs nothing, because the workspace
      forbids `unsafe` outside the bridge (`docs/nfdr.md:L410`).
    - *Stale:* if a later nightly's LLVM excludes `__mod_init_func`, the gate can drop the flag,
      and the NFDR does not need to change.
    - *Lapse:* the admission no longer holds for any change that hands a static across the ABI or
      reaches one through a raw pointer. Such a change already breaks QC-13's owned-buffer rule,
      and `development-design` reading QC-13 is its gate. The tail should name that limit.
    - *Uncovered and named:* a buffer "freed never" is a leak, and this ruling does not claim the
      sanitizer run catches leaks. Whether it does is outside what the flag changes.
  - **What would have tipped it.** An *overridden* would have been right if any bridge `unsafe` site
    read or wrote a static, or if R-13 named a fault in a static.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.1 — § 8 says the card's command does not run `checks/gate.sh` yet; it has run it since 2026-10-20

- **What the document is owed:** re-read the project card and re-pin § 8 to it. Extend RN-6. Then
  re-derive every *Until the card runs the script* gate (QC-56, QC-64, QC-65, and § 9's two bullets)
  against a card whose command is now `checks/gate.sh`.
- **Why it is worth a cycle:** a fact in the document is now false. That is the first and strongest
  ground in `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md`
  § The items are not the whole of what a document is owed.
  - **The measurement.** The card moved at `kensaiapp-opensource@1941f963` (2026-10-20 17:14:01) and
    `85264c69` (17:14:17). Its `**Test command:**` reads `checks/gate.sh`. NFDR v59 was committed at
    `ka-reader@2baeecf` (17:12:04), and v60 (`435bb4e`, 2026-10-22) did not fold the move. § 8 still
    quotes the five-part command pinned at `a4204e5b`, and still says the move "is owed to
    `product-card`". The paragraph itself says it "goes false at the card's next move until RN-6 is
    extended".
  - **Why it matters.** The quote is the smaller half. Five passages name `development-design` as a
    rule's only gate because "no run issues" the script at a change, and since `1941f963` a run
    does.
  - **What the fold should keep.** A gate that rests on something other than the run gap, such as
    QC-64's *nothing else* half, which no script holds, keeps its review gate and says why.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
