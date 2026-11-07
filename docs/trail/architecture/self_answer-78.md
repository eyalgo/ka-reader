# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` — the decision log and the constraint set
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-07
- **Sources re-read:** Apple's developer documentation for the two TextKit layout classes, read for
  § 3.3 through its JSON endpoints on 2026-11-07. `NSTextLayoutManager`
  (https://developer.apple.com/documentation/appkit/nstextlayoutmanager): macOS, introduced 12.0,
  no deprecation marker. `NSLayoutManager`
  (https://developer.apple.com/documentation/appkit/nslayoutmanager): macOS, introduced 10.7 in the
  page's metadata, filed in a see-also group titled "TextKit 1", no class-level deprecation marker
  in the part read. Some of its members are listed on a separate deprecated-symbols page. The page
  is long, and only its first 100,000 characters were read.

Read for this run, at `ka-reader@c29193b`, whose tree outside `docs/` is `e95896f`'s
(`git diff --stat e95896f HEAD -- ':!docs'` prints nothing): ADR-0025 and ADR-0014 whole; the log's
index; `docs/nfdr.md` for every statement of a relative link, the TextKit class and the SM-4 call
list (QC-22, QC-24 — no other entry names either); `docs/SDD.md` v76 (Settled) at § 3's
`MarkdownDocument` entity, SM-4, SM-5, § 4 C-R5 and § 9 TO-5, and RN-158; `docs/fdr.md` R-61, R-62;
`docs/UXD.md` UX-I12; the code at every line cited below. `docs/nfdr.md` (8,360 lines) was searched
rather than read whole: the items name two ADRs, and the run checked every NFDR statement that
either answer could move. No product test ran.

## Items worked

### 3.1 — ADR-0025 says the shell turns a relative link into the existing `select_file` call; it makes an `open_relative_link` call

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The sentence names the wrong call and is re-stated. The addition is the form: a
  superseding record, not the in-place edit the item's "none" implies.

  **Check 1 — mine.** The edit lands in the decision log. The fact it records is already settled
  in the SDD's seam table and in the code, so the answer commits nothing to anyone.

  **Check 2 — the claim holds.** At `c29193b` the shell sends an activated link as
  `bridge.openRelativeLink(path:)` on the serial tree-act runner
  (`ka-reader-mac/Sources/Shell/LaunchFlow.swift:L206-L207`, `:L230`). The bridge's `link_to` asks
  `link_file` under one lock hold. For a contained file it runs
  `select_file(FileRequest::Select(Some(linked)))` and then the open's read-and-fold
  (`crates/ka-reader-bridge/src/session.rs:L1249-L1270`). So the call is `open_relative_link`, and
  it does end in the model's `select_file` operation, as the item says. The item's proposed wording
  is right in substance. I made it slightly more exact: the call reaches `select_file` only for a
  contained file, and it also opens the file.

  **Check 2 — the draft's form does not hold.** The item says no document has to be written and
  the sentence simply "reads" differently. ADR-0025 is Accepted, and an Accepted record is never
  rewritten (`docs/adr/README.md:L4-L5`). `product-architecture` changes only an Accepted record's
  Status line, and only to mark it superseded. ADR-0025 exists because ADR-0015's node list needed
  the same kind of correction, and ADR-0024 corrected ADR-0007's repository address the same way.
  So the correction is a new record superseding ADR-0025. It restates the decision whole and
  changes only the link sentence.

  **Check 3 — what it must not contradict.** SDD v76's SM-4 lists `open_relative_link` as one of
  its ten calls, and SM-5 gives the link its own fixed order (`docs/SDD.md:L656-L657`). NFDR QC-24
  already lists `open_relative_link` among the exports, so no constraint moves. The new record
  should trace to SM-4 and SM-5, because the SDD's own § 9 TO-5 still says "a *relative* link node
  the shell turns into the existing `select_file` call" (`docs/SDD.md:L3344-L3346`). ADR-0015's
  sentence was carried from that wording. TO-5 now contradicts the SDD's own seam table and the
  code. It is the CTO's, so I raised it on the SDD's companion (§ *Companions opened*), and the
  record does not cite it. FDR R-61, a link opening "exactly as selecting it in the tree does",
  agrees with the re-stated sentence.

  **Decided together with § 3.2.** Both items re-state the same sentence
  (`0025-…:L53-L54`). Two superseding records for one sentence would leave an Accepted record
  carrying half the correction, so the two changes land in one record. § 3.2's *why* says the same.

  **Check 4.** *Absent:* no folder open, or a path that is not a contained file, answers `pending`
  and applies nothing (`session.rs:L1256-L1262`). The re-stated sentence says "for a contained
  file", so the record promises nothing beyond that. *Concurrent:* a click raised while the link's
  read is out wins, because the selection is the last act in arrival order (SDD RN-158). That is the
  SDD's to state, and the record does not need to repeat it.

  **Close call:** I weighed **confirmed**, which would read the item's "none" as "no other
  document". I did not take it. The item's own sibling, § 3.2, already defers to "whichever form
  this log takes for § 3.1", which shows the form was left open, not decided.

### 3.2 — ADR-0025's *relative* link is "a contained target path"; the SDD now makes a contained folder an *external* node, so the set's link sentence moves

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item's draft is taken. The change lands in § 3.1's superseding record, in whatever
  form this log takes, and that form is a superseding record (§ 3.1). There are two additions:
  when the kind is read, and that the link form is a decision not yet built.

  **Check 1 — mine.** The CTO made the decision in the settled SDD v76
  (`docs/SDD.md:L738-L761`, decided 2026-11-07, RN-161). What remains is recording it in the
  record a delivery stage reads as fixed. That is this seat's fidelity question, and it commits
  nothing to anyone.

  **Check 2 — the item is right, and the reason is stronger than it says.** The item's stake is
  that the record and the SDD would define *relative* differently. The sharper reason is what
  happens next. The SDD names the renderer as a known defect at `e95896f`: `link_target` makes a
  *relative* node for any entry the check reaches
  (`crates/ka-reader-core/src/markdown_renderer/references.rs:L94-L96`). A change will land to fix
  it. If ADR-0025 still says *relative* is "a contained target path", that change contradicts an
  Accepted record, and the delivery tier checks a change against the records. So the record has
  to move before that change, not after it. That also answers the "record it once it is built"
  alternative, which I weighed and did not take. It is also why the new record must not describe
  the link form as built, even though ADR-0025's title says "the closed node set as built": the
  block kinds are built, and the folder-is-external rule is not yet.

  **Not a widening.** The item narrows an existing form (*relative* now means a file). It does not
  ask the record to state a new case. It also cites the occurrence: the SDD's decision, and the
  code that makes the folder link a control whose activation answers `pending`
  (`docs/SDD.md:L755-L761`). So § *A widening item waits until it occurs* does not apply.

  **Check 3.** FDR R-62 says activating a relative link whose target is not a file inside the
  folder does nothing. UXD UX-I12 makes a link a control only where activating it does something.
  SRS FR-32 permits a relative link "to a file". All three agree with the moved definition. NFDR
  QC-22's hostile fixture holds one relative link, `[other](other.md)`
  (`checks/fixtures/hostile.md:L38`), which targets a file, so QC-22 still reads true. No new NFDR
  obligation is owed: the closed set is bound through ADR-0025 and its Binds, and the unit test the
  SDD names is the renderer change's to re-state. This answer and § 3.1's re-state the same
  sentence, so they were decided together and land in one record.

  **Check 4.** *Stale:* the kind is read at render and never asked again. A file replaced by a
  folder after the render is a control whose activation answers `pending`. A folder replaced by a
  file stays inert until the document is read again. The check at activation stands, because
  `link_file` answers only a contained file (`crates/ka-reader-core/src/folder_model.rs:L305-L307`).
  The record says the kind is read at render and leaves the timings to the SDD. *Refused:* a
  symlink resolved to a folder is a folder by the check's canonical path, so it is external.
  *Absent:* a missing target is already external.

### 3.3 — ADR-0014 says the view rests on TextKit's `NSTextLayoutManager`; the Markdown page and the code view lay out with TextKit 1's `NSLayoutManager`

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** A superseding record is owed. It restates ADR-0014 whole and corrects the class its
  *rests on* paragraph names. The item has no draft: it hands the choice between a dated note and a
  superseding record to the log. So I answered from scratch.

  **Check 1 — mine.** The edit lands in the decision log. The class is a settled fact in SDD v76
  § 4 C-R5 (`docs/SDD.md:L911-L920`) and in the code, so the answer commits nothing to anyone.

  **Check 2 — the question has one answer, not two.** The item offers "a dated note or a
  superseding record". The NFDR takes dated notes because it is revised in place. The log is not:
  `product-architecture` lets only an Accepted record's Status line change, and only to record a
  supersession, and the log's own head says a change is "a new record that supersedes an old one,
  never an edit to it" (`docs/adr/README.md:L4-L5`). So a dated note inside ADR-0014 is the in-place
  edit this log never makes.

  **Check 2 — the claim holds, at the code and at the source.** At `c29193b`, `MarkdownPageView`
  builds an `NSLayoutManager` from construction, because "the placeholder box is a text block,
  which TextKit 2 does not lay out" (`ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift:L15-L16`,
  `:L29-L36`). `CodeView` does the same so its gutter can read rows (`CodeView.swift:L14-L15`,
  `:L37`). No source under `ka-reader-mac/Sources` names `NSTextLayoutManager`. Apple's pages,
  re-read today (§ Header), list `NSTextLayoutManager` from macOS 12.0 and file `NSLayoutManager`
  under "TextKit 1", with no class-level deprecation in the part read. So ADR-0014:L94-L95 names a
  class the view does not use and cites C-R5 for it. C-R5 now says the opposite.

  **Is it worth a whole restated record?** This is the close call. The CTO doubts it, because the
  change is one class name. Two things decided it. First, the false fact sits in the paragraph
  this seat's Dependence lens exists for: it names the platform fact the decision rests on. Naming
  the wrong class means naming the wrong dependency. Second, a delivery stage reads ADR-0014 as
  fixed. A later change to the page, for example one that moves the placeholder box so the page can
  leave TextKit 1, would be checked against a record that says the view already rests on TextKit 2.
  Precedent agrees: ADR-0024 superseded ADR-0007 for a repository address. What would have tipped
  me the other way is a record where the class was only an example. Here the parenthetical is what
  "rests on" names.

  **Check 2 — the CTO's reason is half right.** The item says the conclusion stands "more easily,
  since TextKit 1 is the older of the two". That holds for the floor: an older class constrains the
  minimum macOS less, and C-R5 says the floor is the maintainer's narrowing, not the stack's. It does
  not hold for dependence. TextKit 1 is the text system Apple keeps beside its newer one, and the
  page depends on a TextKit 1 feature, `NSTextBlock` layout, that TextKit 2 does not provide. So the
  restated paragraph adds what the decision becomes if Apple narrows TextKit 1. The page's layout
  moves: the placeholder box goes to a form TextKit 2 lays out. The `MarkdownDocument`, the
  containment check and the view technology do not move. That is R-11's re-cut, walked on the floor
  macOS before each release. This is the instance's Dependence reading: say what the decision
  becomes when the holder of the platform fact stops answering.

  **Check 3.** No NFDR entry names either TextKit class. The search for `NSTextLayoutManager`,
  `NSLayoutManager`, "TextKit 1" and "TextKit 2" in `docs/nfdr.md` finds nothing, so no constraint
  moves. ADR-0025 names no class, so the § 3.1/§ 3.2 record is untouched by this. ADR-0014's
  *Decision* — `NSTextView`, TextKit laying out a `MarkdownDocument`, no web engine, no
  `Package.swift` dependency — is unchanged. While restating, the fold should point the traces at
  the records in force: ADR-0021 for ADR-0013, ADR-0025 for ADR-0015, and ADR-0020 for ADR-0016, as
  ADR-0025 did for its own traces. It should also re-read "Unmeasured as this record is written:
  `swift build` and `swift test` on the GitHub-hosted `macos-14` runner" against C-R5, which now
  puts CI on `macos-26`, rather than copying a sentence the SDD has moved past. I did not measure
  whether S-1's native build has settled it. That is the fold's to read.

  **Check 4.** *Stale:* a macOS release that changes TextKit 1's layout of a text block moves the
  page's layout fixtures, never the document type. That is ADR-0014's existing sentence, kept.
  *Refused:* Apple deprecating `NSLayoutManager` or `NSTextBlock` is the case the addition covers.
  *Absent:* not reachable; the platform ships the class.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

- **`docs/SDD_open_issues.md`** — **opened** — companion to `SDD.md`, landed in commit `f7a6bd4`.
  One item, § 2.1, seated `cto`: § 9 TO-5 still names "the existing `select_file` call" for a
  relative link. It was found while reading the SDD for § 3.1, and no item raised it.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
- **docs/SDD.md** — `<CORE>/launchers/companion-self-answer/launcher.sh ka-reader SDD`
