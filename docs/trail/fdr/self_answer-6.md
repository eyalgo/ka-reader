# Self-answer report — `fdr.md`

## Header

- **Companion:** `docs/fdr_open_issues.md`
- **Document:** `docs/fdr.md` (v9, Draft)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-25
- **Sources re-read:** None. No answer rests on a source outside this repository. Both rest on
  `docs/fdr.md` v9 read whole, `docs/SDD.md` v20, `docs/CONTENT.md` v7, `docs/UXD.md` v10,
  `docs/nfdr.md` v17, `docs/architecture_open_issues.md`, `docs/trail/sdd/cycle-15.md`,
  `docs/trail/sdd/self_answer-26.md`, the product tree at `nozoki@46bb275` and the git history, each
  read on disk this run.

## Items worked

### 2.1 — R-94 says the surface shows *the word pending*, and the wording standard the FDR itself names fixes a different sentence for that state

- **Bucket:** 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The lean is right — R-94's second clause names a state and not a string — and two cases the
  item did not walk are added.
  - **Seat.** The edit lands in `docs/fdr.md` R-94 and nowhere else. It commits only this document's
    consistency with R-88, which already makes `docs/CONTENT.md` the wording standard for every
    message (`docs/fdr.md:L172`). No word is chosen here: the FDR stops naming one and points at the
    document that owns it. Nothing unseeable is named; the owner already ruled on the word itself at
    CONTENT RN-4 (`docs/CONTENT.md:L547-L554`) and at DESIGN v10, which handed *pending* to CONTENT on
    both its lines (`docs/DESIGN.md:L302`, its RN-30). So this is the Principal PM's document and
    the call is made in the owner's seat.
  - **The draft is sound, for the reason it gives.** R-94's one source is SDD § 4 C-E1, which says
    "where it does not yet know, the surface shows pending" — no "the word" — and names "pending,
    nothing, and the unexplained fault" as three *states* (`docs/SDD.md:L823-L830`). The three FDR
    rules beside R-94 say it the same way: R-19 "shows that it is pending" (`:L61`), R-32 (`:L82`),
    R-157 "shows that it is pending (R-94)" (`:L113`). The UXD's loading cell for the tree says "shows
    that it is pending" (`docs/UXD.md:L237`). CONTENT § Message patterns *Loading* gives the words
    (`docs/CONTENT.md:L306-L314`). R-94 is therefore the one line in the definition set naming a
    string, and it names one the standard it defers to does not fix — which is what FDR RN-14's v9
    re-read also found (`docs/fdr.md:L408`).
  - **Check 3 — nothing settled contradicts the confirm.** The product at `nozoki@46bb275` draws a
    `pending` row with its name and glyph and no word
    (`nozoki-mac/Sources/Surfaces/RootItemsView.swift:L161-L170`, asserted by
    `nozoki-mac/Tests/SurfacesTests/RootItemsViewTests.swift:L96-L115`), which a literal R-94 would
    make a defect and the confirmed R-94 does not. The re-run rule that kept R-94 as written at v9
    (`<CORE>/prompts/principal_pm_create_fdr.md` § *On a re-run*, "change the FDR only if the owner
    answers") is met by this answer — it is the owner answer the rule waits for.
  - **Addition one — the pointer's reach.** The item's rationale quotes one example, *"Reading this
    folder."*. The pointer is to the *Loading* pattern whole — its formula is *Reading* + the thing
    being read (`docs/CONTENT.md:L307-L308`) — and that is what makes it cover every surface R-94
    reaches: the Git view (R-19; *"Reading Git status."*, `:L313`), a tree folder (R-32; `:L314`) and
    the reading panel (R-157; *"Reading this file."* is CONTENT's own example at `:L277`). Written
    into the slot so the fold does not narrow R-94 to the tree.
  - **Addition two — the concurrent case.** `docs/nfdr.md` QC-4's layer-4 check verifies the word
    *pending* (`docs/nfdr.md:L118-L124`); its correction is answered at
    `docs/architecture_open_issues.md` § 3.1 and awaits `product-architecture`. That fold and this
    one may land in either order. They converge: the corrected check points at CONTENT's *Loading*
    sentence "by pointer, never copied" and keeps QC-4's trace to R-94's first clause
    (`docs/architecture_open_issues.md:L101-L128`), so whichever lands first, no reader is left with the
    word. Named so nobody sequences the two runs by hand.
  - **Failure paths.** *Stale:* CONTENT re-words its *Loading* sentence — R-94 points and does not
    copy, so it stays true; that is the reason for the pointer form. *Absent:* today no expandable
    tree exists to carry the sentence for a collapsed folder — the open station's reached-when is
    where it arrives (`system/projects/nozoki/journey/shukuba/2026-09-24_the-whole-tree.md` § *What
    it is*, "A folder not yet read shows *Reading this folder.*"), so the confirmed R-94 is a bar the
    station is walking, not a defect in HEAD. *Refused:* a fault is R-91's and CONTENT's "a stopped
    read is never dressed as a pending one" (`docs/CONTENT.md:L276`); the answer does not reach it.
  - **What would have tipped it to an override:** SDD C-E1 saying "the word", or CONTENT having no
    Loading pattern for a pending surface. Neither is so.

### 2.2 — The SDD moved from v13 to v20 beneath this document and stands Settled; this run folded what the move reached — two rules added, the header line moved — and every other SDD-sourced entry was opened and holds

- **Bucket:** 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The fold holds as applied and for the reasons it gives; one case a QA seat would ask about
  is added, and the debt the fold names and does not carry is now raised where it can be acted on.
  - **Seat.** The edit is R-183, R-184, two example rows and the header line, all in `docs/fdr.md`.
    The decision underneath — that the check compares spellings outside the grant and refuses three
    spellings that may lead in, and that their row sentence is wrong about where the link leads — was
    made in the owner's seat at `docs/trail/sdd/cycle-15.md` § 5.1 and folded into the SDD, Settled at
    v20 (`nozoki@4b9425b`). The FDR follows the SDD here; nothing new is committed to anyone.
  - **The draft is sound.** The re-run rule admits an upstream change as a delta and requires it
    surfaced as a finding (`<CORE>/prompts/principal_pm_create_fdr.md:L469-L471`); RN-34 does both.
    The SDD moved six times, runs 13 – 18, 550 insertions and 78 deletions
    (`git log --oneline 5003426..HEAD -- docs/SDD.md`; `git diff --stat`, 2026-09-25). The one
    behavioural move is the containment check: `docs/SDD.md:L322` says the canonical form is taken at
    every position inside the grant, "at a position *outside* the grant nothing is read — no `lstat`,
    no `realpath`", names compared as spelled, re-entry only on the folder's own name from its parent,
    and three spellings refused. R-183 says exactly that (`docs/fdr.md:L87`) and R-184 the three
    spellings with each surface's presentation and the mark (`:L88`); C-E4's new sentence — the
    refused path carries CONTENT's one outside sentence, wrong for the three by the owner's call — is
    the hunk at `git diff 5003426 HEAD -- docs/SDD.md`, `@@ -822,8 +853,19 @@`, and R-184's mark clause
    reads it back. Two rules rather than a reworded R-34 is the right cut: R-34 (`:L84`) says *inside*
    and *outside* and R-183 defines them, so R-34 stays true as written and `docs/nfdr.md` QC-6 and
    `docs/CONTENT.md` § Message patterns *Partial*, which cite R-34, read no changed rule. The two
    example rows (`:L357-L358`) exercise `../<NAME>` re-entering, more-than-one-level-out-and-back,
    the cycle, and the volume-root case. `Inputs read: SDD Settled` is true — `docs/SDD.md:L3` reads
    Settled — and RN-33's stale case is walked at RN-18 (`:L412`).
  - **Check 3.** R-101 (`:L188`) is what R-183 rests on and it is unchanged. R-152's cycle for
    `self → ../NOZOKI` is cycle-15's own reading. R-59's "symbolic links followed" (`:L126`) is
    consistent: links are resolved at positions inside the grant. The v9 note on § 2.1 says no hunk
    falls on C-E1; checked — the `@@ -822` hunk is on C-E4 in v13's numbering (C-E1 sat at
    `5003426:docs/SDD.md` five lines into the § 4 C-E block, C-E4 at line 815 onward), so that holds
    too. The UXD tension cycle-15 named (UX-I4) was weighed by the SDD fold and accepted as C-D1's
    price (`docs/SDD.md:L856-L865`, "no observable half in § 6 tells them from a true outside"); a
    round on the UXD for a distinction an observer cannot make is not raised.
  - **The addition — the absent case.** The SDD says the volume's case rule and whether the folder is
    its volume's root are "both read from the folder itself … and as spelled wherever it cannot be
    sure" (`docs/SDD.md:L322`). R-183 does not say what happens when neither can be established. Its
    *only* already yields the answer — an unestablished condition means the other-case name does not
    count as back inside — but a QA seat reading R-183 alone would file the question. The slot asks
    R-183 to carry the clause.
  - **What the fold leaves out of date and this document does not carry.** `docs/nfdr.md` QC-6 still
    states the check "on the canonical path, symlinks resolved and after decoding"
    (`docs/nfdr.md:L130-L134`), traces to R-34, R-59 and R-62, and verifies `..` and symlink-out only.
    RN-34 and SDD RN-71 both name it as owed and open no item. The reason they gave — an input moving
    beneath the NFDR is its own rule to meet — is right about the seat and wrong about the channel:
    `git log` shows SDD run 18 (`4b9425b`, the § 5.1 fold) landed **after** NFDR v17 (`18250d6`), so no
    Principal Architect run has read the moved row, `nfdr.md` reads Settled, and its one open channel is
    `docs/architecture_open_issues.md`, which named QC-4 and not QC-6. `docs/trail/sdd/self_answer-26.md`
    § Companions opened deferred raising it until "the SDD's fold" existed; it does now. So the run
    appended § 2.1 there (`nozoki@9cfb727`) — under § *Companions opened* below — and the slot names it.
  - **Failure paths.** *Stale:* the SDD moves again — RN-34's pattern re-derives. *Concurrent:* QC-6's
    fold and this one are order-independent, since R-34 is unchanged and R-183/R-184 are additive.
    *Empty:* a viewed folder that is the root of its volume is R-184's third spelling. *Refused:* the
    three spellings are the refused case, and their mark is named as not where the target lies.
  - **What would have tipped it to an override:** an FDR entry that reads *inside* differently from
    R-183, or R-34's wording moved. Neither is so.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

- **`docs/architecture_open_issues.md`** — **appended** — companion to `adr/` and `nfdr.md`, landed in
  commit `9cfb727`. Item § 2.1: QC-6 states the containment check on the canonical path, and SDD v20
  § 3 `fs-reader` takes the canonical form only inside the grant, compares as spelled outside it and
  refuses three spellings that may lead in; the lean and the blast radius are in the item, its slot
  left for the next round. Why it is worth the round: a fact in the record is now false against the
  document it traces to, and the move landed after the record's last run (`git log --oneline
  5003426..HEAD -- docs/SDD.md docs/nfdr.md`: `4b9425b` above `18250d6`).

## Launchers owed

- **`fdr.md`** — `/Users/eyalgolan/.kensaiapp/pins/20260925T191701Z-hwtvc7/core/launchers/skill/launcher.sh product-fdr nozoki`
- **`adr/` and `nfdr.md`** — `/Users/eyalgolan/.kensaiapp/pins/20260925T191701Z-hwtvc7/core/launchers/skill/launcher.sh product-architecture nozoki`
