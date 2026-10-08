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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-01 from the records'
> own companion template, while re-reading the route after `select_file` was first built, because the
> NFDR is Settled and with no companion on disk a `product-architecture` re-run reads it as done and has
> nothing to act on. Its one item is in § 3; it pairs with `docs/SDD_open_issues.md` § 5.1, which asks
> the SDD the same question at C-R7 and C-I3.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

> **No `product-architecture` run wrote this section or its item.** A `companion-self-answer` run
> added it on 2026-10-01 while answering § 3.1 (`docs/trail/architecture/self_answer-22.md`,
> § Raised on this document). It was found by reading QC-62 and § 9 against the files they cite at
> `ka-reader@f5b7843`, after the SDD re-pointed the same citations in its own C-I3 at v22. No item
> raised it. It sits in this bucket because the run holds a lean, and its slot is the next round's.

### 2.1 QC-62's citations into `LaunchFlow.swift` and `checks/renderer.sh` point at lines that moved, its "five-frame list" is four frames, and § 9's `LaunchFlow.swift:L53` has moved too
- **Lands in:** `nfdr.md` QC-62 (its body and its *verified by*) and § 9, the `ka-reader-mac` bullet's
  Swift 6 migration-cost sentence. No ADR.
- **Drafted into the records:** Nothing. No producing run wrote this, and the run that raised it
  writes no record. The change it proposes is to re-point each citation and pin it to a commit, the
  way `docs/SDD.md` § 4 C-I3 now pins the same ones (`at ka-reader@7c7038f`). Measured at
  `ka-reader@f5b7843`: (1) QC-62's `LaunchFlow.swift:L35-L37` → `:L54-L60`, where `chooseFolder()` waits on
  the panel before it hands `openAndList(_:through:)` to the reader, and `:L69`, the `bridge.openFolder`
  call. These are the lines C-I3 cites. (2) The frame list `checks/renderer.sh:L44-L57`
  → header § *THE FRAMES*, the list at `:L53-L56`. (3) The Mac reading `:L58-L61` → `:L57-L60`.
  (4) The hosted-runner reading `:L62-L65` → `:L61-L64`. (5) "matched the five-frame list" → the run
  matched the five-frame list the script carried then, and the list has been four frames since
  `ka-reader@b75348f`, the last commit to touch `checks/renderer.sh`. The run's "byte-equal to `main`'s"
  is true of `main` at `ka-reader@37a962d` and has not been true of `main` since `b75348f`.
  (6) § 9's `LaunchFlow.swift:L53` (`bridge` captured in a `@Sendable` closure) → `:L60`. The same
  sentence's `ReadRunning.swift:L28` still names `deliver` and stands.
- **Rationale:** Each of these is a fact in the NFDR that is now false. A cold reader following
  QC-62 to `LaunchFlow.swift:L35-L37` lands on the lazy `statusGlyphs` property, not on the call
  order the entry argues from. `docs/SDD.md` v22 found and fixed the same drift in C-I3
  (`docs/trail/sdd/cycle-17.md` § 2.1), so the two documents that cite the frame list now disagree on
  where it is and how long it is. ADR-0012 cites `LaunchFlow.swift:L35-L37` and the five-frame
  reading too. It is an accepted record, so it is not edited. The NFDR is the living record a change
  is checked against, and pinning its citations keeps them true while the file moves on.
- **If overridden:** QC-62 keeps sending its reader to the wrong lines of two files, and to a frame
  count the script no longer has, while the SDD it traces to says otherwise. A red `Renderer gate`
  is diagnosed from those citations, and diagnosing it is the moment they would mislead.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-2's verification and QC-24's staging read false while `read-a-file` is built across several changes
- **Raised by:** PM — 2026-10-01
- **Which record:** `nfdr.md` QC-2 (*verified by*) and QC-24
- **Tracked by:** `ka-reader · nemawashi · 2026-10-01_a-file-reads-in-the-panel`
- **What it blocks:** nothing is blocked; two obligations state a verification and a staging rule the
  build does not meet today, so § 10's map reads as covering a command it does not exercise.
- **Where it shows:** QC-2 says `checks/read-only.sh <fixture>` prints `unchanged` "after every command
  the build exports"; `ka_reader_select_file` is exported now, and the walk the script drives calls
  `list_tree` alone (`crates/ka-reader-core/tests/walk.rs:L1-L6`). Until the walk drives `select_file`,
  QC-2 should name what holds the read: `cargo test --locked -p ka-reader-bridge --test select_file` keeps
  `checks/fixtures/text/` byte-identical. QC-24 says "No listed function is exported before a slice
  lands it", and `select_file` is exported while § 6 S-2's highlighter and read-only bars are not yet
  met; it should follow whichever reading `docs/SDD_open_issues.md` § 5.1 settles for C-R7 — exported
  from the first change of the slice that builds it, or held until the slice is whole. The set-equality
  mechanism is unaffected.
- **If a document has to be written:** none — QC-2's *verified by*, QC-24, and their § 10 rows.
- **Answer:** Overridden on QC-2 and taken on QC-24. Both follow the SDD, which settled the same
  question at v22 (`docs/trail/sdd/cycle-17.md` § 5.1; `docs/SDD.md` § 4 C-R7, C-I3; RN-76).
  **QC-24.** The export is staged by change, not by slice. "exactly the functions its landed slices
  built" reads *exactly the functions its landed changes built*. "No listed function is exported
  before a slice lands it" reads *no listed function is exported before a landed change has built
  it*. The entry carries C-R7's meaning of *built*: the bridge function exists and delegates to an
  operation `folder-model`'s API carries (SM-5). Set equality, the closed list, `ka_reader_free`, "from
  `v1.0.0`", the no-second-export clause and the pre-1.0.0 uncovered case stand as written. The
  trace reads C-R7 at v22.
  **QC-2.** It takes no interim cover. `cargo test --locked -p ka-reader-bridge --test select_file` is
  not named in place of `checks/read-only.sh`, because C-I3 now says the unit is the build and that no
  test of a slice's own stands in for `read-only.sh`. The tail's "after every command the build
  exports" already reads that way and stands. QC-2 gains the two cases C-I3 now names as held by no
  check, named so they are not read as coverage. First, nothing compares the walk's calls with the
  export set, so the match is held by review of the change that exports a command. Second, a fixture
  that offers no entry for a command exercises nothing for it, and which fixture a command needs is
  its slice's own bar. The trace reads C-I3 and C-R7 at v22.
  **§ 10.** The QC-2 row gains that reviewed half: the walk's calls against the export set, reviewed
  in the change that exports a command, gated at `development-design` as QC-3's reviewed half is.
  The QC-24 row does not move.
  On builds that export `select_file`, QC-2 is unmet: `crates/ka-reader-bridge/tests/exports.rs:L20`
  admits it, and `crates/ka-reader-core/tests/walk.rs:L1-L6` calls `list_tree` alone. That is the
  build's violation, not the record's, and it closes when the walk drives `select_file`. Like the
  SDD, the records say nothing about the interval.
  ADR-0013's Context sentence "exported from the build in which a slice lands it" is not
  superseded. The grain is cheap to reverse before `v1.0.0` and changes no decision the record
  makes. The fold names it in its review note, so a reader who meets it there finds where it moved.
  Reasoning: `docs/trail/architecture/self_answer-22.md` § 3.1.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
