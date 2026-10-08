# SRS open issues — KA-Reader

> Companion to `SRS.md`. The CTO authored the SRS non-interactively; this file holds
> what it could not settle from the inputs (the PRD and any context/constraints).
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this
> file**, then re-run `product-srs`. It folds your answers into the SRS and drops the
> resolved items. When nothing is left open, `product-srs` **deletes this file**: no file =
> the SRS is done.
>
> Your answers are never thrown away. Each time the CTO folds them in, it first copies this
> file whole to `docs/trail/srs/` — so what you decided, and why, stays readable and citable
> for good.

> **This round folded the cycle-8 answers** (`docs/trail/srs/cycle-8.md` § 2.1 and § 2.2) into
> SRS v9: the diagnostic log's bound now stands in NFR-11 (RN-36), and the 80 dead trail pointers
> are repaired, three `docs/uxd_trail/` mentions excluded as that answer directed. Both items are
> settled and gone. The one item below was raised on the same companion with its slot at the
> placeholder (cycle-8 § 2.3) and is carried forward unanswered — the only item open.

---

## 1. Open issues — technical questions with no answer yet

None this round.

## 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override

### 2.1 RN-35's sibling sentence — "`docs/UXD.md` UX-S4 still makes a non-repository a startup failure" — describes a state that ended at UXD v6

> **Raised by the `companion-self-answer` run that answered cycle-8's § 2.1 and § 2.2, not by a
> `product-srs` run** (there it was § 2.3). No item on that companion asked for it. It is raised
> because the SRS was read whole for those two items and this sentence, true when v8 was written,
> is false now. The measurement is `docs/trail/srs/self_answer-1.md` § Raised on this document.
> The change is to a settled Review Note, so this run has **not** applied it: settled content moves
> on an answer, not on a re-read (`<CORE>/prompts/cto_create_srs.md` § On a re-run).

- **Raised by:** the run above — not one of this document's own seats.
- **What this document says:** RN-35 (`docs/SRS.md`, its closing sentence): *"The sibling: `docs/UXD.md`
  UX-S4 still makes a non-repository a startup failure; the UXD follows the PRD, not this SRS, and
  its revision is the CDO's through the UXD's own skill — this SRS records the divergence and does
  not reshape FR-3 or FR-34 to it."*
- **What is true:** the UXD reached v6 after SRS v8 — `ka-reader@e4ed5fe` (SRS v8) then
  `ka-reader@dd08f2d` (UXD v6), both 2026-08-26 — and UXD RN-28 says it read `docs/SRS.md` v8 as its
  sibling and found no collision with FR-33 / FR-34 (`docs/UXD.md` RN-28). At v6, UX-S4 *"narrows
  to a path that does not exist, is not a folder, or cannot be read"* (`docs/UXD.md` version line),
  and its row reads *"A folder that is not a Git repository is not on this list: it opens (UX-I17;
  narrowed at v6 with PRD v11 — RN-25)"* (`docs/UXD.md` § UX-S4). The divergence RN-35 records has
  closed.
- **Drafted:** RN-35's sibling sentence gains a closing clause — the divergence ended at UXD v6
  (UX-S4, RN-25; RN-28 reads this SRS as its sibling and finds no collision) — the same way RN-35
  itself records the end of RN-29's "the PRD is not corrected here" rather than rewriting RN-29.
  The note's wording as written stands as history; no requirement moves, and nothing else in the
  SRS changes for this item. Not yet in the SRS: it lands on confirmation, in the next fold.
- **If overridden:** leaving RN-35 as written keeps a claim about another document that a reader
  who opens `docs/UXD.md` finds false at the row it names. There is no third branch: the clause
  is either added or the sentence stands.
- **Confirm or override:** **confirm — with two additions, and the clause is pinned.** RN-35's
  sibling sentence gains its closing clause as drafted, written as history at a version, in this
  shape: *the divergence ended at UXD v6 (`ka-reader@dd08f2d`, 2026-08-26): UX-S4 narrowed to a path
  that does not exist, is not a folder, or cannot be read, and a plain folder opens (`docs/UXD.md`
  § UX-S4, RN-25); UXD RN-28 read this SRS at v8 as its sibling and found no collision with FR-33 /
  FR-34.* (1) **Pinned, because the sentence went false by being written in the present tense about
  a document that moved** — a clause naming the version and the commit stays true whatever UXD v8
  does, as RN-35's own "PRD v8 → v11" and RN-19's `9017ae2` already do. (2) **The form is the
  appended sentence, and its precedent in this document is RN-10 and RN-19, not RN-35's record of
  RN-29** — that one is the later-note form; RN-10's closing sentence ("The re-authored UX Notes
  later stated the behavior itself; FR-3's widening to match is RN-17's") and RN-19's on `9017ae2`
  are closes appended to the note they close, so a reader of RN-35 alone sees the divergence and its
  end — RN-3's own reason for putting the bar and its headroom in one sentence. The rest of RN-35's
  sentence stands as written: FR-3 and FR-34 are not reshaped, and now agree with the UXD. Nothing
  downstream quotes the sentence — `docs/SDD.md` RN-9 already records "with UXD v6, a plain folder
  is not on UX-S4's list at all", and `docs/fdr.md` R-9 traces to FR-3 / FR-34 — so the fold reaches
  RN-35 and the Version line and nothing else. Re-measured on 2026-09-01 (UXD v7 Settled, "nothing
  about the experience changes"; no `docs/UXD_open_issues.md` on disk), not inherited from the run
  that raised it. Decided in the owner's seat: `docs/trail/srs/self_answer-2.md` § 2.1.
