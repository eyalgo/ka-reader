# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (NFDR v20, Settled). The companion says the PM opened
  it outside `product-architecture` on 2026-10-01 (`docs/architecture_open_issues.md:L18-L22`).
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-01
- **Sources re-read:** None. No answer rests on a source outside this repository. Every claim was
  read at its source in the product repository at `nozoki@f5b7843`: `docs/SDD.md` v22 § 4 C-R7 and
  C-I3, `docs/trail/sdd/cycle-17.md` §§ 2.1 and 5.1, and the code and scripts named below.

One item was open, § 3.1, and it was worked. One item was raised on the records, § 2.1. Nothing is
left for the owner.

## Items worked

### 3.1 — QC-2's verification and QC-24's staging read false while `read-a-file` is built across several changes

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** overridden
- **Why:** The item asked two things. Its QC-2 half proposed an interim cover: name
  `cargo test --locked -p nozoki-bridge --test select_file` as what holds the read until the walk
  drives `select_file`. That proposal is replaced. Its QC-24 half asked QC-24 to follow whichever
  staging reading the SDD settled, and that half is taken.

  *Check 1, the seat.* The edits land in `nfdr.md` QC-2, QC-24 and § 10. That is this companion's
  document, so the item is answered here. The answer commits nothing to a person, money or a risk.
  It brings the NFDR into line with an SDD decision already made in the owner's seat, so it is not
  the owner's to reserve. Both questions have the same seat, so the item does not split and both are
  answered in the one slot.

  *Check 2, the draft.* The item reads as a draft: it leans toward the QC-2 interim clause and
  defers QC-24 to the SDD. The QC-2 lean was sound on the day it was written. The PM raised it before
  the SDD answered and offered the interim test as one of two readings
  (`docs/trail/sdd/cycle-17.md` § 5.1, "Where it shows"). The lean no longer holds.

  *Check 3, the settled record.* The SDD settled both questions at v22. On the export,
  `docs/SDD.md` § 4 C-R7 now reads "A build exports to the shell exactly the functions its landed
  changes built", "a function no landed change has built is never exported", and "A change has
  built a function when the bridge function exists and delegates to an operation `folder-model`'s
  API carries (SM-5)". QC-24 still reads "its landed slices built" and "No listed function is
  exported before a slice lands it" (`docs/nfdr.md:L358`, `:L364-L365`). QC-24 derives from C-R7,
  so those two sentences follow it and nothing else in the entry moves. On the harness, C-I3 now
  reads "The unit is the build … no test of a slice's own stands in for `read-only.sh`". That rules
  out the interim test the item proposed for QC-2. QC-2's tail, "after every command the build
  exports" (`docs/nfdr.md:L78-L79`), already agrees with that unit and stands. The SDD's own answer
  says the same: "QC-2's *verified by* agrees with C-I3 as it stands and takes no interim clause"
  (`docs/trail/sdd/cycle-17.md` § 5.1). C-I3 also gained two cases at v22 that no check holds: the
  walk's calls are never compared with the export set, and a fixture with no entry for a command
  exercises nothing for it. An NFDR entry names what its check does not cover, as QC-24's
  "**Not covered before `v1.0.0`**" clause does. So QC-2 carries both cases, and § 10's QC-2 row
  gains the reviewed half C-I3 names. The gate for that half is `development-design`, because that
  is where this NFDR places its other reviewed halves (QC-3, `docs/nfdr.md` § 10's QC-3 row). I
  nearly left the gate to the fold. What tipped it was that a reviewed half with no named gate is
  the "sentence about the product" the NFDR's own header refuses. ADR-0013's Context says "each
  exported from the build in which a slice lands it"
  (`docs/adr/0013-sandboxed-single-process-read-pipeline.md:L46-L47`). It is not superseded. The
  staging grain fails the significance test: it is cheap to reverse before `v1.0.0`, and the
  decision the record makes (one process, one closed seam) does not move with it.

  *Check 4, failure paths.* **Stale:** on product `main` since `select_file` was exported, QC-2 is
  unmet. `crates/nozoki-bridge/tests/exports.rs:L20` admits `nozoki_select_file`, and
  `crates/nozoki-core/tests/walk.rs:L1-L6` calls `list_tree` alone (both read at `nozoki@f5b7843`).
  That is a violation in the build, not a false sentence in the record, and the records state
  nothing about the interval, as the SDD states nothing. **Empty:** a fixture that offers no entry
  for a command is the second uncovered case, now named in QC-2. **Concurrent:** two slices that each
  export a function in separate changes meet at one set when the changes are joined (C-R7), and
  QC-24's set equality is unchanged. **Absent and refused:** a `select_file` that fails returns a
  failed item state and writes nothing, so it does not touch QC-2's write rule. Not covered: whether
  the review at `development-design` actually happens is held by that stage reading the entry, as
  every reviewed half in this NFDR is.

## Left for the owner

None this run.

## Skipped

- **§ 1 and § 2 as the file stood** — both read "None." There were no items to answer. The run
  replaced § 2's "None." with the item it raised, because "None." above an item would contradict it.
  `docs/trail/architecture/cycle-17.md` § 2 is the same move by an earlier run.

## Raised on this document

### 2.1 — QC-62's citations into `LaunchFlow.swift` and `checks/renderer.sh` point at lines that moved, its "five-frame list" is four frames, and § 9's `LaunchFlow.swift:L53` has moved too

- **What the document is owed:** QC-62's four line citations and its frame count re-pointed and
  pinned to a commit, and § 9's `LaunchFlow.swift:L53` re-pointed to `:L60`.
- **Why it is worth a cycle:** *A fact in it is now false*, and *it contradicts a document it must
  agree with* (`decide_companion_answers.md` § The items are not the whole of what a document is
  owed). Measured at `nozoki@f5b7843`: `nozoki-mac/Sources/Shell/LaunchFlow.swift:L35-L37` is the
  lazy `statusGlyphs` property. `chooseFolder()`'s panel wait is `:L54-L60`, the `[bridge]` capture is
  `:L60`, and `bridge.openFolder` is `:L69`. `checks/renderer.sh`'s frame list is `:L53-L56` and
  holds four frames. Its Mac reading is `:L57-L60`, and its hosted-runner reading is `:L61-L64`.
  `git show b75348f -- checks/renderer.sh` removes the fifth frame, `LaunchFlow.run()`. The NFDR cites
  `:L35-L37`, `:L44-L57`, `:L58-L61`, `:L62-L65`, a "five-frame list" and `:L53`
  (`docs/nfdr.md:L445`, `:L465`, `:L468`, `:L470-L472`, `:L1085`). The SDD fixed the same drift in
  C-I3 at v22 (`docs/trail/sdd/cycle-17.md` § 2.1). Since then the two documents disagree about where
  the frame list is and how long it is. ADR-0012 carries the same old citations and is not touched,
  because accepted records are not edited.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
