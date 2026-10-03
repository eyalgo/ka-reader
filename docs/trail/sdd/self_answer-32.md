# Self-answer report — `docs/SDD.md`

This is the record of one unattended run that answered `docs/SDD_open_issues.md` in the owner's
seat. It is for the owner, who reads it to learn what was decided and why, and for the
`product-sdd` run that folds the answer.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-03
- **Sources re-read:** None. The answer rests on this repository's documents and tree at
  `nozoki@4a31865`, and on no source outside it.

## Items worked

### 5.1 — The `read-only-harness` row's list of what the unit owns omits files `checks/` holds

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Yes, the row names them: `entry-points.sh` and `entry-points.allow`, the three helpers,
  and the suites folder, with the enumeration pinned to the commit it was measured at and told
  apart from what a slice still delivers. The item carried no draft. It stated a gap between the
  row and the tree and asked nothing narrower, so it is answered from scratch.

  **What this run read.** `docs/SDD.md` § 3 from its opening through the *Four physical units*
  paragraph (`:L306-L348`), § 4's opening note on the NFDR relation (`:L494-L501`), C-I3, C-I4 and
  C-R3, the slice lines that cite the harness's scripts and fixtures (`:L1209-L1213`,
  `:L1440-L1444`, `:L1494-L1500`, `:L1714-L1726`, `:L1839-L1843`), *Open Questions*, and § 12's
  ownership row. The rest was searched for `read-only-harness`, `entry-points`, `QC-30`,
  `checks/tests`, `churn.sh`, `latency.sh`, `walk.rs`, `sandbox_probe`, `deps.review` and
  `fixtures/`, and each hit was read. It was not read line by line. Of the inputs, `docs/nfdr.md`
  QC-30 half (2) (`:L595-L606`), § 9's suite count (`:L1063-L1075`), § 10's linked-tree rows
  (`:L1270-L1276`) and the `#[path]` note (`:L3309-L3310`) were read. The tree was read at
  `nozoki@4a31865`: `git ls-tree HEAD checks/`, `ls checks/fixtures`, `ls checks/tests`,
  `checks/read-only.sh:L1-L30`, `checks/bundle.sh:L40`, `:L321-L322`, `checks/walk.rs:L1-L12`,
  `checks/sandbox_probe.rs:L1-L8`, `checks/deps.review.md:L1-L6`, `checks/entry-points.sh:L1-L30`,
  `crates/nozoki-core/tests/walk.rs:L6`, and `.github/workflows/ci.yml`'s `checks/` steps. The
  PRD, the SRS, the UXD and the FDR were not opened: the answer names files in an ownership row
  and moves no requirement.

  **The widening rule, first.** The item sits under the heading carrying *Raised from downstream*.
  Whether naming a file the row does not name is a widening or a correction, the item cites its
  occurrence: `git ls-tree --name-only HEAD checks/` at `nozoki@4a31865` lists `entry-points.sh`,
  `entry-points.allow`, `walk.rs`, `sandbox_probe.rs`, `deps.review.md`, `fixtures`, `tests` and
  `.gitkeep` beside the scripts the row names, and `docs/nfdr.md:L992` places `entry-points.sh` in
  layer 6 with `structure.sh` and `view.sh`, both of which the row names. Occurrence cited, so the
  change proceeds.

  **Check 1: the seat.** The edit lands in `docs/SDD.md` § 3's `read-only-harness` row, the
  CTO's (`docs/SDD.md:L112` area, the ownership table). It binds no person and no outside party,
  changes nothing the product promises, and moves no slice's bar. I can name no ground I cannot
  see. So the item is mine in the owner's seat. One thing weighed and not routed: § 4 is the
  authoring surface and the NFDR the enforcement store (`docs/SDD.md:L494-L501`), and QC-30 half
  (2) has no § 4 condition behind it. That is not a gap by the SDD's own rule, which lets an NFDR
  entry trace "to the § 4 condition **or** SRS requirement it realizes"; QC-30 traces to SRS
  NFR-14, FDR R-2 and C-R3 (`docs/nfdr.md:L917-L919`). Had the rule read "the § 4 condition"
  alone, this would have been a second question for the same row's document and the same seat,
  answered in the same slot.

  **Check 2: the question.** One question, the row's enumeration against the tree, with a wide
  consequence. The item names two files it is about and three it is not sure about; the answer
  takes all five, because the row already enumerates at file granularity (`deps.allow` is a list,
  not a script) and a reader asking which unit owns `checks/sandbox_probe.rs` finds no row that
  says. The item's own listing also shows `tests` and `fixtures`, which the item did not raise and
  which the same enumeration has to meet, so the answer reaches them too. The item's supporting
  text holds: every file it names is on disk, every line it cites says what it is cited for, and
  the row's text at `:L332` is as quoted.

  **Why each name.**
  - `entry-points.sh` with `entry-points.allow`: the row pairs `deps.allow` with nothing because
    the review it belongs to lives in `deps.review.md`; here the script and the list are one check
    (`checks/entry-points.sh:L9-L17`), so the row names them together, the way the NFDR's row does
    (`docs/nfdr.md:L1273`). The condition the pair proves is the NFDR's, QC-30 half (2), and the
    row cites it there, as the SDD already cites `docs/nfdr.md` QC-56 from § 4 (`docs/SDD.md:L591`).
  - `walk.rs`: `checks/walk.rs:L1` says it is "the in-process walk `checks/read-only.sh`
    consumes", and `crates/nozoki-core/tests/walk.rs:L6` compiles it into a `nozoki-core` test
    target by `#[path]`. Named with that route, because the row's *Must not own* is "being a
    dependency of any shipped unit" and a test target is not shipped; `docs/nfdr.md:L3309-L3310`
    reads it the same way. `checks/read-only.sh:L9` names the shim and not the source, which is
    the script's wording and not this item's.
  - `sandbox_probe.rs`: `checks/bundle.sh:L40` and `:L321-L322` compile it with `rustc` at run
    time because "no shell can call" `sandbox_check`; the SDD already cites it by line at
    `:L698` and `:L3328-L3427` without saying which unit holds it.
  - `deps.review.md`: `checks/deps.review.md:L3-L4` is "recorded as code beside the list it
    reviews", and the `highlighter` row cites it (`docs/SDD.md:L327`). It belongs beside
    `deps.allow` in the row that owns the list.
  - `tests/`: eight `test_*.sh` on disk, each on its own CI step (`.github/workflows/ci.yml`),
    and `docs/nfdr.md` § 10 tags a script's suite beside it. The suites prove the scripts can go
    red; they are the harness's and nothing else's.

  **Check 3: against the settled record.**
  - `docs/SDD.md:L339`, "`checks` is build-time and never shipped": holds for every file named.
    `walk.rs` reaches a test target, `sandbox_probe.rs` a temporary directory, nothing the bundle.
  - § 4 C-I3 (`read-only.sh` exercises every granted command through SM-5): unchanged. Naming
    the driver's source does not move what the walk does.
  - `docs/nfdr.md` § 9 and § 10: agree. The NFDR already treats the suites and the entry-points
    pair as the harness's, and its own gap on the suite tag is `docs/architecture_open_issues.md`
    § 3.1, opened 2026-10-03 by the PM. Nothing is raised there from here.
  - `docs/trail/sdd/self_answer-31.md` § 5.1 and the row answers before it: untouched. None of
    them read the `read-only-harness` row.
  - The SDD's own pattern for a planned script: the row already marks `contract.sh` as arriving
    "from `promise-one-point-zero`" (`:L332`). The answer's second bound extends that marking to
    the other planned names rather than inventing a form.

  **Check 4: the failure paths.**
  - *Absent.* Three scripts the row names are not on disk at `nozoki@4a31865`: `churn.sh` and
    `latency.sh` (`ls checks/churn.sh checks/latency.sh` → no such file; § 6 `follow-the-folder`'s
    bar at `:L1717-L1724` and C-I4 at `:L786` are where they are owed) and `contract.sh`, which
    the row already marks. Five of the eight fixture folders the row names are not on disk either:
    a folder inside a repository, a parent of two repositories, a linked worktree, a submodule and
    a hostile Markdown corpus (`ls checks/fixtures` → `highlight`, `idle-shell`, `plain`, `repo`,
    `repo.git.tar`, `text`; § 6 `see-git-status` at `:L1211-L1212` and `read-markdown` are where
    they are owed). Two fixture folders on disk go unnamed: `highlight` (seven files,
    `crates/nozoki-core/tests/highlight.rs`) and `text` (seven files, `read_file.rs`,
    `select_file.rs`; `docs/SDD.md:L1498` names `checks/fixtures/text/` in a slice bar). The
    answer does not strike the planned names: they are the design's and slices deliver them. It
    asks the row to tell the two apart, as it already does once.
  - *Stale.* The enumeration went stale once and will again; the next station on the same seed
    adds a check (`structure-holds-the-boundary-reads`, named in the open station's *Not here*).
    The answer pins the enumeration to a commit, which is `docs/nfdr.md` § 9's own device
    (`:L1071-L1073`: "an eighth suite … is a re-measurement of this sentence and not a
    contradiction of it"). A pin makes the next landing a measured difference instead of a
    silent falsehood. It does not make the row self-updating; a later file still owes the row an
    item like this one.
  - *Empty*, *concurrent*, *refused*: not reached. An ownership row has no empty case, no second
    actor, and nobody to refuse it.
  - One case the slot names as outside it: `checks/.gitkeep`, a placeholder with no owner to
    assign. Not named.

  **What was close.** A narrower answer, naming only the two entry-points files the item was sure
  of, was the other reading. It did not carry: the row already names individual files, so a
  reader who meets `sandbox_probe.rs` in § 4 C-I3's record (`:L3328`) and asks which part owns it
  gets no answer from a row that stops at the item's two names. What would have tipped it the
  other way: a row that enumerated by kind ("the scripts, their lists and fixtures") rather than
  by name, in which case the item's own ask would have been a widening of the row's grain.

  **Downstream, named and not raised.** The NFDR's linked-tree row and suite count are owed a
  re-measurement, and `docs/architecture_open_issues.md` § 3.1 already carries it. The skeleton
  launcher reads the parts table "with nothing in the loop to interpret it" (`docs/SDD.md:L311-L315`);
  the answer changes the *Owns* cell's text and neither the row's shape nor its columns.

## Left for the owner

None this run.

## Skipped

None this run. The companion holds one item, and its slot was at its placeholder.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh nozoki`
