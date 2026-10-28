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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-28, from a
> `shukuba-refine` review, to carry item 3.1 below: the NFDR is Settled with no companion beside it,
> so without this file its own producing skill would find nothing to act on.

---

## 1. Open issues — questions with no answer yet

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-53 calls its error-path verifier "layer-5" tests and names none; § 9 puts the tests that hold it at layer 4, and they now exist

- **Raised by:** PM — 2026-10-28
- **Which record:** `nfdr.md` § 7 QC-53, *verified by* (`docs/nfdr.md:L1551`); § 9, the layer table's
  rows 4 and 5 (`:L2071-L2072`); § 10, QC-53's verification-map row (`:L2608`)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-03_no-internal-text-reaches-a-surface`
- **What it blocks:** nothing is blocked. QC-53's second half is verified, but the record names no
  verifier for it and gives it a layer its own § 9 assigns to something else.
- **Where it shows:** QC-53 ends its *verified by* with "layer-5 error-path tests that a `stopped`
  item's surface text is a catalogue sentence" (`:L1551`), and the § 10 row repeats "layer-5 error-path
  tests" (`:L2608`). § 9's table puts layer 5 at the built bundle, run from `checks/` (`:L2072`), and puts
  "renders the real component, in process", `swift test --package-path ka-reader-mac` over
  `ka-reader-mac/Tests/`, at layer 4 (`:L2071`). The tests that hold the clause are in-process Swift
  Testing cases under `ka-reader-mac/Tests/`: `stoppedReadingPanelUsesCatalogueSentence`,
  `stoppedStartupUsesCatalogueSentence` and `stoppedGitViewUsesCatalogueSentence`
  (`ka-reader-mac/Tests/SurfacesTests/StoppedCatalogueTests.swift:L52`, `:L74`, `:L88` at
  `ka-reader@bfa465a`). Measured in a disposable clone at `ka-reader@bfa465a`:
  `swift test --package-path ka-reader-mac --filter 'SurfacesTests.stopped'` printed
  `Test run with 3 tests in 0 suites passed`. With `ReadingPanelView.showStopped` drawing `"error"` in
  place of `ConditionSentences.stoppedReadingFile`, the reading-panel case failed and the other two
  passed. The three cases run in the gate's *Test gate* step (`checks/gate.sh:L73`).
- **If a document has to be written:** none. The fold would name the three cases (or their file) as
  QC-53's error-path verifier in QC-53 and the § 10 row, and settle which layer word they carry under
  § 9's table — layer 4 as they stand, or a reason they count as layer 5.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
