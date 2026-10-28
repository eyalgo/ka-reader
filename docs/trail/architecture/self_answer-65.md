# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The one open item names `docs/nfdr.md` QC-53, § 9's
  layer table and § 10's QC-53 row. It touches no record in `docs/adr/`.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-28
- **Sources re-read:** None outside this repository. The answer rests on the NFDR's own § 9 and on the
  tree at `ka-reader@bfa465a`. Both were read for this run: `docs/nfdr.md:L1544-L1567` (QC-53),
  `:L2026-L2092` (§ 9's preamble, layer table and layer bullets), `:L2523-L2540` and `:L2600-L2620`
  (§ 10's preamble and rows). The NFDR is 7,240 lines and was not read whole. This run read the
  header, § 7, § 9 up to its `checks/structure.sh` bullet, § 10, and every line in the NFDR, the SDD
  and the ADRs that mentions an error-path test or a stopped-surface catalogue sentence. Only QC-53's
  two lines matched. In the tree it read
  `ka-reader-mac/Tests/SurfacesTests/StoppedCatalogueTests.swift` whole and `checks/gate.sh:L60-L80`,
  and it searched `ka-reader-mac/Sources` for `stopped`. The PM's `swift test … --filter
  'SurfacesTests.stopped'` run and its mutation run were not repeated.

## Items worked

### 3.1 — QC-53 calls its error-path verifier "layer-5" tests and names none; § 9 puts the tests that hold it at layer 4, and they now exist

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** The fold should name the three cases as QC-53's error-path verifier, call them layer 4,
  and say so in QC-53 and in § 10's row. The record has nothing to weigh against that.
  The item has no draft, so it is answered rather than confirmed. Its "If a document has to be
  written" line names two options (layer 4, or a reason for layer 5) and does not choose between them.
  - **Seat (check 1).** The edit lands in `docs/nfdr.md`, the document this companion belongs to. It
    binds only that record's consistency with § 9 and with the tree. No person, outside party or
    risk is committed by it. So it is answered here, in the owner's seat. It is a correction and not
    a widening: QC-53 already promises the error-path tests, and the item asks only that the record
    name them and give them the right layer. § *A widening item waits until it occurs* does not
    apply. Even if it did, the item cites what exists: three cases, a file, line numbers and a commit.
  - **Soundness (check 2).** The item's facts hold where this run checked them. QC-53 ends with
    "layer-5 error-path tests that a `stopped` item's surface text is a catalogue sentence"
    (`docs/nfdr.md:L1551`), and § 10 repeats it (`:L2608`). § 9's table puts layer 4 at
    `swift test --package-path ka-reader-mac` over `ka-reader-mac/Tests/` (`:L2071`). It puts layer 5
    at the built bundle, run from `checks/` (`:L2072`). The three cases are in-process Swift Testing
    `@Test` functions. Each builds the real `ReadingPanelView`, `StartupView` or `GitView` in a
    stopped state and checks that it shows the path once and exactly one catalogue symbol
    (`StoppedCatalogueTests.swift:L52`, `:L74`, `:L88` at `ka-reader@bfa465a`, the locators the item
    gives, which this run confirmed). That is
    layer 4 as § 9 defines it, "a view is drawn from a projection". The cases run in the gate's
    *Test gate* step, `cargo test --workspace --locked && swift test --package-path ka-reader-mac`
    (`checks/gate.sh:L73`).
  - **Why not layer 5 (check 3).** § 9 rules it out. Its layer-4 bullet says "layer 4 proves
    *rendering given state* and layer 5 proves the bundle" (`:L2079-L2082`). Its layer-5 bullet says
    the rendered UI at layer 5 is "the timed manual walk, deliberately not automated"
    (`:L2090-L2092`). An automated layer-5 error-path test therefore cannot exist under the record
    as written. "Layer-5" in QC-53 contradicts the NFDR's own § 9, and calling these cases layer 5
    would mean changing § 9. No source supports that. The answer moves no settled requirement. It
    traces to the same SDD § 4 C-E4 and FDR R-89 that QC-53 already cites.
  - **The § 10 row.** The row reads *Checked against* "the tree" and *Gated at* "CI build". That is
    right for the lint. The Swift runner, though, is held at the change in QC-51's row, which names
    the same runner at the same layer: "the change; the tree | `development-implementation`; CI
    build" (`:L2607`). So the fold should add *the change* and `development-implementation` to
    QC-53's row beside what it has. This addition is this run's own. The item did not ask for it,
    but it follows from naming the runner. Without it, two rows would treat one runner in two ways.
  - **Failure paths (check 4).**
    - *Empty.* At `bfa465a`, `ka-reader-mac/Sources` has a `stopped` state on exactly three
      surfaces: `ReadingPanelView.showStopped` (`:L163`), `StartupView`'s `.stopped` case (`:L51`)
      and `GitView`'s `.stopped` case (`:L154`). One case covers each surface, so no stopped surface
      is untested today.
    - *Stale.* A surface that later gains a `stopped` state is covered by no existing case. The
      answer states this as a limit. `development-design` reading QC-53 is that surface's gate, which
      is the record's general rule for a property no command holds yet. The case names and file are
      pinned to `ka-reader@bfa465a`, the way the record pins its other locators.
    - *Absent.* A precondition can make the runner fail on a correct change: an unassembled bridge,
      or a locked session. § 9's preamble already covers both for every tail that names the runner
      (RN-60, RN-63), and QC-53's tail will be one of those.
    - *Refused.* If a surface draws `"error"` instead of its catalogue symbol, its own case fails.
      That is the PM's measured mutation, and this run did not repeat it.
    - *Concurrent.* Not applicable. Each case draws one view in one state.
  - **What would have changed the verdict.** A reason in the SDD or in § 9 for treating an in-process
    view test as end-to-end would have done it. None exists, and § 9 says the opposite.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
