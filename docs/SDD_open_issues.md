# SDD open issues — Nozoki 覗き

> Companion to `SDD.md`. Three seats — the CTO, the CPO and the CDO — authored the SDD
> non-interactively in one run; this file holds what that run could not settle from its inputs (the
> PRD, the SRS, the UXD, and any context or constraints).
>
> **Answer inline** — fill each **Answer** / **Confirm-or-override** / **Keep-or-recut** slot —
> **commit this file**, then re-run `product-sdd`. It folds your answers into the SDD and drops the
> resolved items. When nothing is left open, `product-sdd` **deletes this file**: no file = the SDD
> is done.
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

> **This companion was opened on 2026-09-04 by a `companion-self-answer` run, not by a
> `product-sdd` run.** The run was answering `docs/fdr_open_issues.md` § 2.7
> (`docs/trail/fdr/self_answer-3.md` § 2.7), and that item's change lands in this document and
> nowhere else. `SDD.md` is Settled at v3 (`nozoki@827aa1c`) and its companion was correctly absent;
> it is re-opened because two answers the owner gave on the FDR reach sentences only this document
> can change, and a settled document has no other channel — with no companion on disk a
> `product-sdd` re-run reads the design as done and has nothing to act on. One item, in § 5, the
> section this file's own header gives to a seat that did not write the SDD. Its slot is left at
> its placeholder: the reasoning is this run's, the decision is the next round's.

---

## 1. Open issues — questions with no answer yet

<None this round.>

## 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override

<None this round.>

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

<None this round.>

---

## 4. Disagreements — two seats hold different positions and neither yields

<None this round.>

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 Two sentences of this SDD cannot hold beside rules the owner confirmed on the FDR — `fs-reader`'s text rule omits UTF-16, and § 11 R-3's response names a folder to choose
- **Raised by:** Principal PM — 2026-09-04, by a `companion-self-answer` run answering
  `docs/fdr_open_issues.md` § 2.7; the FDR's own record of both is `docs/fdr.md` RN-29.
- **Tracked by:** none. nozoki has no active 根回し Nemawashi seed and no open 宿場 Shukuba station
  (`system/projects/nozoki/journey/`, 2026-09-04). Found while reading this document as the FDR's
  input, not while cutting work from it.
- **What it blocks:** nothing stalls and no gate fails. What it costs is two builds that disagree
  with the contract the QA seat derives acceptance from: a builder reading § 3 `fs-reader` refuses
  a UTF-16 file that the FDR's R-46 says is text, and a builder reading § 11 R-3 draws a Git-view
  failure that names a folder to choose — which the FDR's R-21 forbids, because choosing that folder
  views *that* folder (FDR PD-4: the main worktree instead of the linked one, the superproject
  instead of the submodule), never this one with its Git state, so the route leads somewhere else.
- **Where it shows:** two sentences, each a prose edit inside a cell or a row; no part, seam, slice,
  edge or place in the order moves for either.
  **(1) § 3 `fs-reader`'s *Owns* cell** — *"the text rule — bytes decode as UTF-8 or the file is
  cannot-display-as-text (`docs/SRS.md` FR-10)"* (`docs/SDD.md:250`). The owner's answer at
  `docs/trail/fdr/cycle-1.md` § 2.4 adds one encoding and nothing else: a file whose bytes begin
  with a UTF-16 byte-order mark and decode as UTF-16 is text — the mark says what the file is, so
  admitting it is not a guess, and refusing a file the tool can read without guessing is the
  refusal FR-29's *"never refused"* is written against; no detection by content, no Latin-1, one
  undecodable sequence is not text, an empty file is text (FDR R-46, R-154, R-155). FR-10 fixes no
  encoding, so the UTF-8-only sentence is this document's own reading and the clause widens it
  without contradicting the SRS. The deleted SDD stated no text rule at all (FDR RN-3), so the
  sentence is the re-author's and was never put beside the owner's answer.
  **(2) § 11 R-3's *response*** — *"the port reports it as a `failed` Git item naming the folder
  to choose instead"* (`docs/SDD.md:1838`). The owner overrode that wording at
  `docs/trail/fdr/cycle-1.md` § 2.7: the failed item names where the Git directory lies as what
  was observed, states that this folder's Git state is therefore not read and that the tree and the
  reading panel work, and offers no folder to choose — R-88's *nothing can be done* form (FDR R-21).
  The FDR's RN-7 recorded the owner's call that the wording be met at this document's next
  revision; the re-author read the deleted SDD only at its § 4 C-R3 (RN-1) and did not meet it.
  The FDR keeps both owner answers meanwhile (`docs/fdr.md` RN-29); nothing there waits on this.
- **If a document has to be written:** none. Both repairs are inside sentences this document
  already carries. My reading, offered and not drafted: fold both as prose — the `fs-reader` cell
  gains the UTF-16 clause with the boundary R-154 draws, and R-3's response reads the owner's form —
  each with a review note naming `docs/trail/fdr/cycle-1.md` as its authorization, since this
  document does not read the FDR and the trail is where the value was set.
- **Answer:** <the owner fills this in>

<!-- add 5.2, 5.3, … as needed -->
