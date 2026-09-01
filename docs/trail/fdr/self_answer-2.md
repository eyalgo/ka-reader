# Self-answer report — fdr.md

## Header

- **Companion:** /Users/eyalgolan/products/nozoki/docs/fdr_open_issues.md
- **Document:** `docs/fdr.md` — the FDR, Draft at v2
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-01

Read whole before any item was decided: the companion; `docs/fdr.md` (v2, 414 lines); the prior
round's record (`docs/trail/fdr/cycle-1.md` § 1.2, § 2.10; `docs/trail/fdr/self_answer-1.md`); and,
as the items name them, `docs/SRS.md` (v12) FR-13, FR-21, NFR-11, DR-5, AC-6, AC-12, AC-13, RN-36,
RN-37; `docs/PRD.md` (v15) § Data & Privacy; `docs/SDD.md` (v3) § 3 entity OwnState, § 4 C-I2,
RN-19; `docs/nfdr.md` (v1) QC-40, QC-52, QC-60; `docs/architecture_open_issues.md` § 1.2, § 2.2;
`<CORE>/doctrine/flow/change_classification.md` § Behaviour-preserving — definition;
`<CORE>/prompts/principal_pm_create_fdr.md` § The altitude test, § On a re-run. The siblings the FDR
may read and not cite — `docs/UXD.md` (v10) UX-I7, UX-I9, UX-S7 — were read for collision on 2.3.
The upstream measurement 2.2 rests on was re-run: `git diff a50718a HEAD` on each of the three
sources, citation-path repairs filtered out.

## Items worked

### 2.1 — Whether R-93 carries the diagnostic log's bound the SRS gained at v9

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** Confirmed: R-93 stands as written and the bound stays the SRS's. The draft holds for
  the reason it gives. The altitude test is doctrine's, not taste: a change may alter *"Logs,
  latency, internal file layout, and on-disk format internals"* silently and stay
  behaviour-preserving, and *"the fence is contract + public API — nothing finer"*
  (`<CORE>/doctrine/flow/change_classification.md:34-35`, quoted at
  `<CORE>/prompts/principal_pm_create_fdr.md:96-101`, which adds that writing one of those into
  the FDR *"makes routine work impossible"*). The SRS says the same of this log — *"the log is
  diagnostics, not a promise"* (`docs/SRS.md` RN-36) — and the bound already has its homes: NFR-11
  states it, AC-13 inspects it, QC-40 names NFR-11 as where it lands (`docs/nfdr.md` QC-40;
  `docs/architecture_open_issues.md` § 1.2's answer says QC-40 takes the number from NFR-11 by
  revision). Cycle 1's lean — fold it in, because *"what survives a launch is behaviour of R-108's
  kind"* — was weighed and does not hold: R-108 binds state the product reads back between
  sessions; the log is never read back, and a build that kept two sessions of it would breach
  NFR-11, not a promise a person relies on. Check 3: RN-13 already lists *"C-I2's log path"* as
  SDD structure that lands as no rule, and PD-32 has observability *"minimal by decision"* — the
  draft is the document's own practice. The addition is check 4's: the one clause of v9's bound
  that reads as surface behaviour — *a failed log write surfaces nowhere* — is not a hole. It is
  already this document's by R-85 (a failure degrades an *item's* presentation; the log is no
  item), R-86 (a failure state is presented in the item's own slot; the log has none) and R-87
  (no toast, dialog or terminal line carries a failure). And the reason the log's size and
  retention sit below the contract is stronger than the altitude test alone: the FDR already
  closes every route by which the log could reach a person through the product — R-89 (no
  diagnostic text reaches any surface), R-92 and OOS-22 (no control reveals a fault's detail).
  What a person finds by opening the file themselves is R-93's and R-109's promise about its
  contents, never its size. Absent: the log cannot be written (disk full, container unwritable)
  — nowhere to surface, nothing stops, per R-85 – R-87. Concurrent: two instances writing one
  file — the SRS's RN-36 sized the cap on disk for it; not this document's. Close call: none —
  what would have tipped it is a promise that diagnostics survive to be reported, and PD-22 and
  R-92 say the opposite. No rule and no review note changes on the fold beyond dropping the item.

### 2.2 — Three upstream documents moved under the settled FDR; what each moved, and that nothing else did

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** Confirmed: the three deltas the item lists are the three the sources show, and R-166
  is the one behaviour among them no rule carried. The measurement was not taken on trust: `git
  diff a50718a HEAD` was re-run on `docs/SRS.md`, `docs/PRD.md` and `docs/SDD.md` (2026-09-01,
  `a50718a` = the commit that authored FDR v1), with citation-path repairs filtered out. SRS:
  exactly FR-13, NFR-11, AC-6, AC-12, AC-13, RN-35's close, RN-36 and RN-37 — nothing else. SDD:
  `pnpm ls` in C-R6, § 12's downstream-boundary paragraph (the three surfaced decisions recorded
  as ADR-0001, ADR-0002, ADR-0004), RN-7 and RN-8 gaining their ADR pointers, RN-27 added, and
  RN-19's contingency closed — all structure or history; PD-27 traces to C-R6 and RN-13 already
  places C-R6's mechanics with the SDD, and R-106's trace to RN-19 holds because the sentence it
  realizes — the shell *"renders in the platform's reported appearance, or light where none is
  read"* — is in that note's body (`docs/SDD.md:1805`), which the closed contingency does not
  touch. PRD: *folder* for *repository* in eight body sentences, *reading panel* for *editor
  panel* in § UX Notes "The character", and nothing this document quotes — R-138 and R-143 quote
  § Assumptions "Support posture", unchanged; the Description already reads *reading panel*. The
  addition is completeness, for the cold reader this item exists for: the PRD (at v12) and the
  SRS (at v9) also repaired their answer-trail citations (`docs/prd_trail/` → `docs/trail/prd/`,
  `docs/srs_trail/` → `docs/trail/srs/`), and PRD § Core Features' highlighting sentence gained a
  confirmation annotation and no fact — neither moves a rule, and no citation here goes stale
  (RN-11 already cites `docs/trail/prd/cycle-1.md`; the FDR's only `_trail/` string is RN-15's
  narration of a defect that closed). R-166 confirmed on check 4: where the diff cannot be
  produced *and* the file cannot be read from the tree, each degrades in its own slot (R-85) and
  the shell stands — two failures, no fallback, nothing new. Check 3: RN-18's *"no companion sits
  beside any of them"* holds today (`ls docs/`: no `PRD_`, `SRS_` or `SDD_open_issues.md`).
  One note for the fold, recorded here rather than raised because the fold rewrites the line
  anyway: the v2 Version line says *"One item stays open in `docs/fdr_open_issues.md`"* and the
  file held three — 2.2 and 2.3 were the v2 run's own findings. The v3 line counts what its
  companion holds. Not worth a cycle of its own: a version line is rewritten at every fold by
  the document's own rule, so the defect cannot outlive the round this companion already owes.

### 2.3 — What R-110's reversibility clause binds, now that the remembered-folders list ages entries out

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** Confirmed: R-110's reversibility clause binds the deliberate choices, and the
  remembered-folders list is stated as the one own state it does not reach. Check 1 first,
  because the item hands the call up — *"the call is yours because R-110 is settled text and you
  said it holds"*. That is the producing skill's fold rule (*"a re-run does not reword settled
  content on its own reading"*, `<CORE>/prompts/principal_pm_create_fdr.md` § On a re-run)
  speaking, not a ground this seat cannot see: the edit lands in this document, binds no person
  and no outside party, and the seat that said *"R-110 holds as written"* was this one, in the
  owner's seat (`docs/trail/fdr/cycle-1.md` § 1.2 ends *"Reasoning:
  `docs/trail/fdr/self_answer-1.md` § 1.2"*). The prompt's re-run rule is met exactly: a prior
  answer that turns out wrong is *"raised rather than quietly corrected"* — and the v2 run raised
  it, as this item and RN-26. Answering it here is that channel, not a re-answer of 1.2. Check 2:
  the tension is real and the draft's reading is right for the reason it gives. R-110 traces to
  PRD § Data & Privacy and SRS DR-5, and neither says a word about reversibility (`docs/PRD.md` §
  Data & Privacy: own state *"lives where the tool keeps its own data ... holds nothing
  personal"*; `docs/SRS.md` DR-5: *"preferences the system remembers ... nothing personal"*) — so
  the clause is this document's own derivation and can be narrowed without moving anything
  upstream. The sibling that carries the same clause carries it the draft's way: UX-I7, *"the
  tool's own preferences, each reversible by the same control that set it"* (`docs/UXD.md` UX-I7),
  where the list is not a preference; UX-S7 has *"no control removes an entry or clears the
  list"*. Where the draft is incomplete: it names the theme alone, and R-108 lists four things
  that persist — theme, window state, the remembered folders, which was viewed last. Window
  state is a deliberate change and is reversible by its own control (move or resize back); which
  folder is viewed reverses by viewing the previous one again (R-121). Naming only the theme
  would read as if those two were not the user's to change, or not reversible. The addition
  names them, and pins the one-way step where it happens — an entry aging out under R-178 is not
  restored — rather than at viewing itself, which is the reversible half. The *If overridden*
  path was weighed and refused: keeping the clause as written would force a removal control that
  UX-S7 forbids and `docs/DESIGN.md` § Components "The menu" does not draw, reopening two
  siblings for a sentence nothing upstream requires. Check 4: empty — first run, no list, nothing
  to reverse; stale — an entry whose folder is gone stays until it ages out (R-180), so nothing
  changes under a person's feet; concurrent — two instances sharing own state is R-170's, not
  this clause's. One case named, not drafted: the theme's *mode* — after a deliberate choice,
  whether the control can return to following the platform (R-106's initial state) — is the
  UXD's (UX-I9: *"the user may override, and the choice is remembered"*) and DESIGN's; R-110 as
  reworded binds the reversal of the visible theme, which the toggle gives, and does not reach
  the mode. Read for collision and found none: `docs/nfdr.md` QC-40's *"a remembered folder
  until its entry is removed"* stays true under R-178 — the removal's agent is unspecified — so
  nothing is raised on the NFDR for it. Downstream: RN-26 closes on the fold, and RN-20's clause
  *"R-110 was stated by the owner to hold as written"* is read with this answer beside it.

## Left for the owner

None this run.

## Skipped

None this run. Section 1 holds no item this cycle, and no item in section 2 carries a slot
addressed to another actor.

## Companions opened

None this run. Two were considered and refused: the NFDR, whose QC-40 stays true under R-178
(2.3's why) and whose log-bound half is already carried by `docs/architecture_open_issues.md`
§ 1.2's answer (2.1's why); and the SDD, whose § 12 and RN-19 changes moved no rule here (2.2).

## Launchers owed

- **`fdr.md`** — `<CORE>/launchers/product-fdr/launcher.sh nozoki`
