# Self-answer report — fdr.md

## Header

- **Companion:** /Users/eyalgolan/products/ka-reader/docs/fdr_open_issues.md
- **Document:** `docs/fdr.md` — the FDR, Draft at v5
- **Decided by:** `decide_companion_answers.md` v1.1.0
- **Date:** 2026-09-04

Read whole before any item was decided: the companion; `docs/fdr.md` (v5, 419 lines); the SDD's
version note, § 3 `fs-reader`, § 4 C-E4, § 11 R-3 and RN-41 – RN-44 (`docs/SDD.md` v5, Settled);
the authoring prompt's § *Every rule cites its relation to the three sources* and § *On a re-run*
(`<CORE>/prompts/principal_pm_create_fdr.md` v1.1.0); the previous round's report
(`docs/trail/fdr/self_answer-3.md`) and its answered file (`docs/trail/fdr/cycle-3.md`). Two
measurements the companion rests on were re-run rather than trusted: `git diff --stat 827aa1c HEAD
-- docs/SDD.md` → 146 insertions, 12 deletions; `git log 2cd990f..HEAD -- docs/PRD.md docs/SRS.md
docs/UXD.md docs/DESIGN.md docs/CONTENT.md docs/nfdr.md docs/adr` → nothing. Both as the companion
states them.

Two items were open, one per section, and both are the same upstream move seen from two sides:
§ 2.1 the part of the SDD v3 → v5 fold no item had asked for, § 3.1 the three sites a downstream run
had found stale, repaired at v5. Both were taken in the companion's order; neither depended on the
other.

## Items worked

### 2.1 — The SDD moved from v3 to v5 beneath this document, and this run folded what the move reached beyond the three sites § 3.1 names — R-154 and R-155 gain a live source, R-88 is checked against the widened C-E4, and the status and sibling records are re-read

- **Bucket:** 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The draft holds, and for the reason it gives. **Check 1 — the seat.** The edit lands in
  the FDR and nowhere else: relation marks and review notes, no rule's wording. It binds nobody
  outside the document and there is no ground I cannot name — the values behind it are the owner's
  own cycle-1 answers, which the SDD has now caught up to. Mine, in the owner's seat.
  **Check 2 — the draft.** Its argument is that R-154 and R-155 are *from* because the SDD now
  states their clauses. Opened: `docs/SDD.md:274` reads *"no encoding is detected from content, no
  third encoding is admitted, one undecodable sequence makes the file not text, and an empty file is
  text (the owner's value, RN-41)"* — R-154's boundary and R-155's sentence, in those words. The
  relation rule the draft cites says what it is said to say: *from* is *"the rule realizes something
  one of the three states"* and *added* is *"the FDR states something none of the three does"*
  (`<CORE>/prompts/principal_pm_create_fdr.md` § *Every rule cites its relation to the three
  sources*), so an *added* note on a clause the SDD carries verbatim is a mis-stated relation, as
  the draft says. The re-run rule it cites also holds — *"An upstream document that changed under a
  settled FDR is a legitimate source of a delta, and it is also a finding"* (§ *On a re-run*). The
  rest of the fold was opened site by site: R-46, R-154 and R-155 carry `SDD § 3 fs-reader` and no
  *added* note (`docs/fdr.md:101-103`); R-21 carries `§ 11 R-3` and no *changed* mark
  (`docs/fdr.md:62`); RN-14 and RN-18 carry a v5 re-read (`:403`, `:407`); RN-29 carries its closing
  sentence (`:418`); RN-30 lists the move whole (`:419`).
  **The addition.** The draft says R-88 is read against the widened C-E4 and does not move because
  *"R-88 already states that form"*. It does — but C-E4 at v5 carries a sub-case the draft did not
  walk: *"Where no wait ends it, the message says the condition stands and the route out is the
  surface's own"* (`docs/SDD.md` § 4 C-E4). R-88's own words are *"or that nothing can be done and
  what ends the wait"* (`docs/fdr.md:169`), and R-21's message — a Git directory outside the folder —
  is a condition no wait ends. Read strictly, R-88 would have a builder write an ending for it. It
  still does not move, on two grounds the answer now names: R-88 makes `docs/CONTENT.md` the wording
  standard, and that document's formula already applies the terminal form to a condition no wait ends
  — the not-text file, *"with the tree still there as the way on"* — which SDD RN-43 measures as the
  precedent (`docs/SDD.md` § SDD Review Notes RN-43); and R-21 states the concrete instance in full,
  so nobody builds it from R-88 alone. The addition is the case, not a hedge — a rewording of R-88
  would be a rule moving with no owner answer behind it, which the re-run rule forbids.
  **Check 3 — the settled record.** Nothing contradicted: the owner's cycle-1 § 2.4 and § 2.7 values
  are what the SDD now states, the owner's cycle-3 § 2.7 answer said R-46 and R-21 stand and both
  keep their wording, and RN-29 stays a dated record of v3. **Check 4 — the paths.** *Stale:* if the
  SDD moves again under v5, RN-30's commit pins hold and the next run records a further move; nothing
  here reads a live path as settled. *Absent / empty / concurrent / refused:* not reached — the fold
  is a traceability change inside one document. **Weighed and not taken:** the draft's second *If
  overridden* path, a further site. Every entry citing § 3 `fs-reader`, § 4 C-E4 or § 11 R-3 was
  opened: R-34 and R-151 cite the containment check, which the diff did not touch; R-89 cites
  C-E4's *never a cause the tool did not observe*, unchanged; the linked-worktree example row
  (`docs/fdr.md:348`) already reads the owner's form. None found. **Noted and not raised:** RN-3's
  header still reads *(added)* and RN-7's *(added — with basis)* where RN-1's header was updated to
  *(changed at v1; carried from v2)* when its relation flipped. Not a false fact — the header names
  why the note exists and each body or RN-30 carries the close, and a reader following R-46's tag
  meets *"met at SDD v4 (RN-30)"* beside *RN-3* — so it is an improvement no reader is missing, and
  the prompt's bar keeps it out of a cycle.

### 3.1 — The SDD has met both sentences RN-29 found, so this document's record of the contradiction — the version note, RN-7, and R-21's and R-46's relation marks — describes a departure that no longer exists

- **Bucket:** 3. Raised from downstream — an item raised against the FDR after it settled
- **Verdict:** confirmed
- **Why:** The repair `product-fdr` applied at v5 is taken as it stands. **Check 1 — the seat.**
  The item was raised by an earlier `companion-self-answer` run on the FDR's own traceability, and
  the change lands in the FDR alone — three sentences and two relation marks, no rule's wording. It
  commits nothing to anyone outside the document, and the values it rests on are the owner's own
  (`docs/trail/fdr/cycle-1.md` § 2.4, § 2.7), now stated by the SDD. Mine, in the owner's seat.
  One thing said plainly because the skill's own rule is close to it: a run may not answer an item
  it raised on its own reasoning *"with nothing in between"*. Here the round between is
  `product-fdr`'s v5 (`ka-reader@4a73c1a`), which applied a repair; what this run weighs is that repair,
  not the raiser's finding. **Check 2 — what was handed.** The item offers a reading and the v5
  blockquote states a repair; both were checked against disk. (1) The version note: the present-tense
  *"Two owner-confirmed rules the re-authored SDD contradicts stand"* now sits only inside the
  parenthetical that begins *"(v4: …"* — the version line's own convention for history — and the v5
  sentence before it names the close (`docs/fdr.md:5`). (2) RN-7: the departed-from sentence is
  pinned to `ka-reader@827aa1c:docs/SDD.md` § 11 R-3, past tense; the closing call is answered in the
  same note — *"Met at SDD v4 (`ka-reader@683db69`)"*, citing SDD RN-42 and the owner's confirm at
  `docs/trail/sdd/cycle-3.md` § 5.1 — and it ends *"R-21's relation is *from* since v5"*
  (`docs/fdr.md:396`). (3) R-21's tag carries `§ 11 R-3 — … as the owner set it` and *"the departure
  RN-7 recorded closed at SDD v4 — RN-30"* with no *changed*; R-46's carries `§ 3 fs-reader — the
  text rule, met at SDD v4 (RN-30)` with no *added* (`docs/fdr.md:62`, `:101`). The item's offered
  reading — re-point the sites and record the meeting in a note naming `ka-reader@683db69` and RN-41 /
  RN-42 — is what RN-30 does (`docs/fdr.md:419`). The one question the item declined to word, which
  relation word the two rules take, is closed by the prompt's vocabulary rather than by taste: the
  set is *from*, *added*, *changed*, *suggest-remove* and nothing else
  (`<CORE>/prompts/principal_pm_create_fdr.md` § *Every rule cites its relation to the three
  sources*), and *from* is *"the rule realizes something one of the three states"*. RN-29 is
  untouched and stays true as the item said it would — it pins to v3 in its first sentence.
  **Check 3 — the settled record.** The repair contradicts nothing: § 2.1 above confirms the wider
  fold the same way, and the two verdicts were decided in this order with § 2.1 in front of this one;
  the owner's cycle-3 § 2.7 answer that R-46 and R-21 stand is kept — neither rule's wording moved.
  **Check 4 — the paths.** *Stale:* the SDD is Settled at v5 and no companion sits beside it
  (`ls docs/`, 2026-09-04); a later move is RN-30's pins plus a further note, not a hole in this
  answer. *Absent:* `docs/SDD_open_issues.md` no longer exists, and the cycle the item cites is on
  disk at `docs/trail/sdd/cycle-3.md`. The other three classes are not reached by a traceability
  repair. **Close to a different verdict?** No — *confirmed with addition* was considered for RN-7's
  mid-note sentence *"R-21 is now a *changed* relation"*, which reads present-tense before the note
  reaches its close; it is the same dated-narrative shape the version line uses, the close is in the
  same note four sentences on, and reading it is not the defect this item was about. Recorded here,
  not raised.

## Left for the owner

None this run.

## Skipped

None this run. § 1 carries `<None this round.>` and no item; every item on the file had a slot at
its placeholder and was worked.

## Companions opened

None this run.

## Launchers owed

- **`fdr.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-fdr/launcher.sh ka-reader`
