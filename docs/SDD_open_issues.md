# SDD open issues — Nozoki

> Companion to `SDD.md`. Three seats — the CTO, the CPO and the CDO — authored the SDD
> non-interactively in one run; this file holds what that run could not settle from its inputs (the
> PRD, the SRS, the UXD, and any context or constraints).
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time the seats fold them in, they first copy this file
> whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a disagreement is not something one seat asked, it
> is something two seats answered differently, and the answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the run entirely.** §§ 1–4 are all the SDD's own three seats;
> § 5 is a seat that never wrote the SDD, reading it long after it settled and finding something
> only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's, which stay fixed
> to the three authoring seats on purpose.

> **No `product-sdd` run opened this companion. The PM opened it on 2026-09-23.** `SDD.md` is
> settled at v15 and had no companion on disk. Without one, a `product-sdd` re-run would read the
> SDD as done and find nothing to act on. The companion holds two items, § 5.1 and § 5.2, both
> found by measuring the built `nozoki-bridge` and `nozoki-mac` against the SDD.

---

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 C-R7 and S-1 admit only SM-4's list, and SM-4's list leaves out the `nozoki_free` that SM-4's own returns require
- **Raised by:** PM — 2026-09-23
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** S-1's command half cannot be met as written. It says "the staticlib exports
  `open_folder` and `list_tree`, the header declares the same two, and nothing else (C-R7)"
  (`SDD.md:L1285-L1287`). C-R7 holds the exported set "inside SM-4's list" (`:L597-L598`), and
  among its violations is "an exported function outside SM-4's list" (`:L610`). SM-4's list names
  nine functions, and `nozoki_free` is not one of them (`:L413`). Yet the same SM-4 cell says each
  call returns "an owned buffer of plain data … freed by `nozoki_free`" (`:L413`), and § 3's
  `core-bridge` row says the same (`:L328`). No build can meet both halves. A bridge that exports no
  release function breaks SM-4's return rule. A bridge that exports one breaks C-R7 and S-1's "same
  two, and nothing else".
- **Where it shows:** The bridge on `main` exports three C functions: `nozoki_open_folder`,
  `nozoki_list_tree` and `nozoki_free` (`crates/nozoki-bridge/src/exports.rs:L37`, `:L50`, `:L61`).
  Its generated header declares `nozoki_free` (`target/include/nozoki_bridge.h:L15`), and
  `--test exports` admits all three (`crates/nozoki-bridge/tests/exports.rs:L17`). The test passes,
  but only because it admits a function C-R7's letter refuses.
- **If a document has to be written:** None. What is owed is a statement of where the release
  function sits. **The PM's lean:** `nozoki_free` belongs beside SM-4's list, not on it. It is a
  down-call every build exports from S-1 on, because every call's return needs it, so it does not
  wait for a slice. C-R7 then holds the exported set inside SM-4's list plus `nozoki_free`. S-1's
  bar reads "the two, and `nozoki_free`, and nothing else". C-I6's `v1.0.0` pin takes the same
  set. **The doubt:** putting it on SM-4's list as a tenth function would also work, but it would
  make "all nine from `v1.0.0`" false wherever it is repeated.
- **Answer:** <the owner fills this in>

### 5.2 The Swift-frame paragraph says no Swift packet exists and that the card still owes Swift; both are now false
- **Raised by:** PM — 2026-09-23
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing is blocked from being built. But § 3's reasoning for `nozoki-mac`
  rests on a premise that is no longer true, and `docs/nfdr.md` § 9 and ADR-0016 copy that premise.
  The paragraph says "No Swift packet exists in the organisation's language registry
  (`<CORE>/doctrine/engineering/languages/`, listed 2026-09-23: `javascript`, `python`, `rust`,
  `shell`, `typescript`)". From that it concludes that the frame "is laid out by the slice that
  lands it rather than by a launcher", and that "the project card's `Languages:` line is owed
  `Swift` … and its test command the `swift test` half" (`SDD.md:L396-L401`, RN-60).
- **Where it shows:** The registry now carries `languages/swift/`, with `conventions.md`,
  `errors_logging.md`, `layout.md`, `quality_gates.md`, `testing.md` and `toolchain.md`
  (`kensaiapp-dev@3ab2e8553`, 2026-09-23). The project card already reads
  `Languages: Rust, Swift, Shell`, with `swift test --package-path nozoki-mac` in its test command
  (`kensaiapp-opensource@5b27023`). `nozoki-mac/Package.swift` exists on `main`, laid out by hand.
- **If a document has to be written:** None. The Swift-frame paragraph and RN-60 are owed a
  re-read against the packet: the packet exists, and the card has already moved. Where the packet's
  layout differs from what `nozoki-mac` does, `docs/nfdr.md` § 9 records the testing and tooling
  side, which is raised there. What is left for § 3 is whether *Kind* and the frame's layout still
  hold with a packet behind them.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
