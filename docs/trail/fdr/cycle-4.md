# FDR open issues — KA-Reader

> Companion to `fdr.md`. The Principal PM authored the FDR non-interactively; this file holds what the
> run could not settle from its inputs — the PRD, the SRS and the SDD.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-fdr`. It folds your answers into the FDR and drops the resolved items. When nothing is
> left open, `product-fdr` **deletes this file**: no file = the FDR is done.
>
> Your answers are never thrown away. Each time the Principal PM folds them in, it first copies this
> file whole to `docs/trail/fdr/` — so what you decided, and why, stays readable and citable for good.
>
> **§ 3 is the odd one, and worth reading twice.** The Principal PM writes the FDR *and* is the seat
> most likely to raise an item against it later, cutting the same product's documents into seeds. The
> two are different acts at different times, and § 3 keeps the later one visible instead of letting
> it be quietly folded back into § 1 as though the authoring run had asked it.

> **This round.** The `product-fdr` run of 2026-09-04 consumed the cycle-3 companion
> (`docs/trail/fdr/cycle-3.md` — seven choices, all answered in the owner's seat) and took
> `docs/fdr.md` from v4 to v5: the v4 re-derivation is confirmed as applied, PD-40 gains the
> prerequisite clause, and one ground in RN-28 is corrected (`docs/fdr.md` RN-28). The same run
> found the SDD moved beneath this document a second time — v3 → v5 (`ka-reader@683db69`,
> `ka-reader@67372a5`), meeting the two owner answers RN-29 had found it against — and folded the move
> as an upstream change (`docs/fdr.md` RN-30). Two items stand: § 2.1, the part of that fold no item
> had asked for; and § 3.1, raised by a downstream seat on the three sites the same move reached,
> carried over unanswered with the repair now applied. Nothing here is a question the run could not
> answer from its inputs; each item is a fold under an upstream change, awaiting the owner's word.

---

## 1. Open issues — behavioural questions with no answer yet

<None this round.>

## 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override

### 2.1 The SDD moved from v3 to v5 beneath this document, and this run folded what the move reached beyond the three sites § 3.1 names — R-154 and R-155 gain a live source, R-88 is checked against the widened C-E4, and the status and sibling records are re-read
- **Drafted into the FDR:** applied at v5. R-154 and R-155 gain SDD § 3 `fs-reader` as a source
  beside their owner-answer tags — the SDD's text rule now states their clauses (*no encoding is
  detected from content, no third encoding is admitted, one undecodable sequence makes the file
  not text, and an empty file is text*, `docs/SDD.md` § 3 `fs-reader`; RN-41) — so, with R-46
  (§ 3.1's), every text-rule entry carries the relation *from* and none an *added* note. R-88 is
  read against `§ 4 C-E4` as widened at SDD v4 — the third part of a message may be *that there is
  nothing to do* (RN-43) — and does not move: R-88 already states that form. RN-18 is re-read (the
  SDD Settled at v5, its companion retired to `docs/trail/sdd/cycle-3.md`; the PRD and the SRS
  unmoved; no companion beside any of the three), RN-14 is re-read (no sibling moved since v4), and
  RN-29 gains its closing sentence and stays the dated record of v3. RN-30 lists the whole move,
  § 3.1's three sites included. No rule, product decision, exclusion or example changes its wording.
- **Rationale:** the authoring prompt's re-run rule — an upstream document that changed under a
  settled FDR is a legitimate source of a delta and also a finding, folded and surfaced with what it
  moved (`<CORE>/prompts/principal_pm_create_fdr.md` § On a re-run). Measured 2026-09-04:
  `git diff --stat 827aa1c HEAD -- docs/SDD.md` → 146 insertions, 12 deletions, the whole of it
  SDD RN-41 – RN-44's (`fs-reader`'s text rule, § 11 R-3's response, C-E4's terminal form, two slices'
  fixtures and a reducer case, the version line); `git log 2cd990f..HEAD -- docs/PRD.md docs/SRS.md
  docs/UXD.md docs/DESIGN.md docs/CONTENT.md docs/nfdr.md docs/adr` prints nothing. R-154 and
  R-155 are re-tagged for the reason the relation rule gives: a rule whose source now states it
  wears a trace, and an *added* note on a clause the SDD carries verbatim would read as this
  document's own where it is not (`<CORE>/prompts/principal_pm_create_fdr.md` § Every rule cites
  its relation to the three sources). The two slices' bars (§ 6 S-2, S-4) are the route and are not
  read into this document.
- **If overridden:** *keep R-154 and R-155 as added* — the two entries then claim as this
  document's own two clauses the SDD states, a mis-stated relation and nothing more; no rule moves.
  Or *name a further site the move reached that this run did not touch* — the next run folds it.
- **Confirm or override:** confirm, with one case named that the draft did not walk: C-E4's third form where no wait ends the condition. R-88's own words are *what to do next — or that nothing can be done and what ends the wait*, and the message R-21 binds for a Git directory outside the folder has no wait to end. R-88 still does not move — it names `docs/CONTENT.md` as the wording standard, that document's formula already reads the no-wait case (the not-text file, `docs/CONTENT.md` § *Tone*, which SDD RN-43 measures as the precedent), and R-21 states the one instance in full: the condition observed, that the tree and reading work, no folder to choose. The rest of the fold was opened site by site and holds: R-46, R-154 and R-155 carry `SDD § 3 fs-reader` with no *added* note and R-21 carries `§ 11 R-3` with no *changed* mark (`docs/fdr.md:62`, `:101-103`); the SDD's row states R-154's boundary and R-155's clause in those words (`docs/SDD.md:274`); RN-14 and RN-18 carry their v5 re-reads, RN-29 its closing sentence; the two measurements reproduce (146 insertions and 12 deletions on `docs/SDD.md` since `827aa1c`; nothing on the seven siblings since `2cd990f`; 2026-09-04). The relation is the authoring prompt's own word — a rule its source now states is *from*, and *added* would claim as this document's a clause the SDD carries verbatim. Neither *If overridden* path is taken: no further site the move reached was found — every entry citing § 3 `fs-reader`, § 4 C-E4 or § 11 R-3 was opened, and R-34, R-89, R-151 and the linked-worktree example row already read as the SDD stands. Decided in the owner's seat by a `companion-self-answer` run, 2026-09-04. Reasoning: `docs/trail/fdr/self_answer-4.md` § 2.1.

## 3. Raised from downstream — an item raised against the FDR after it settled

### 3.1 The SDD has met both sentences RN-29 found, so this document's record of the contradiction — the version note, RN-7, and R-21's and R-46's relation marks — describes a departure that no longer exists
> **This item was raised on 2026-09-04 by a `companion-self-answer` run, not by a `product-fdr`
> run.** The run was answering `docs/SDD_open_issues.md` § 5.1 and read `docs/fdr.md` as that
> item's named source; the finding is that answering it made three sentences here stale, which no
> item on this file asked. Its Answer slot is left at its placeholder: the reasoning is that run's,
> the decision is the next round's.

> **Applied at v5 by the `product-fdr` run of 2026-09-04, under the authoring prompt's rule that an
> upstream document changed beneath a settled FDR is a legitimate delta and a finding
> (`<CORE>/prompts/principal_pm_create_fdr.md` § On a re-run).** The three sites now read as the SDD
> stands: the version note names the close; RN-7 records it, with the sentence departed from pinned to
> `ka-reader@827aa1c:docs/SDD.md` § 11 R-3; and R-21's and R-46's relations are *from*, each tracing to
> the SDD section that now carries the owner's value (`docs/fdr.md` RN-30). The Answer slot below is
> left at its placeholder: the item is the raiser's, the repair is on disk for the owner to confirm or
> override, and § 2.1 carries the rest of the same move.

- **Raised by:** a `companion-self-answer` run answering `docs/SDD_open_issues.md` § 5.1 — 2026-09-04
  — reading `docs/fdr.md` as that item's source, in no authoring seat.
- **Tracked by:** none. ka-reader has no active 根回し Nemawashi seed and no open 宿場 Shukuba station
  (`system/projects/ka-reader/journey/` — both roots empty, 2026-09-04). Found while reading this
  document, not while cutting work from it.
- **What it blocks:** nothing stalls and no gate fails. What it costs is this document's
  traceability, which is what a reader uses to know whether the FDR and the SDD agree: three
  sentences say they disagree where they now agree, so a builder or a QA seat chasing the departure
  finds nothing at the other end and cannot tell a resolved departure from an unrecorded one.
- **Where it shows:** `docs/SDD.md` moved from v3 to v4 (`ka-reader@683db69`) and folded both sentences
  RN-29 found, under the owner's own answers at `docs/trail/fdr/cycle-1.md` §§ 2.4 and 2.7 — its
  § 3 `fs-reader` now admits UTF-16 by byte-order mark beside UTF-8 with its boundary stated
  (`docs/SDD.md` § SDD Review Notes RN-41), and its § 11 R-3's response now names where the Git
  directory lies as what was observed, says this folder's Git state is therefore not read, and
  offers no folder to choose (RN-42). Three sites here have not seen it. **(1) The version note**
  (`docs/fdr.md:5`) — *"Two owner-confirmed rules the re-authored SDD contradicts stand … and are
  surfaced, not arbitrated (RN-29)"*, present tense, and the SDD contradicts neither at v4.
  **(2) RN-7** (`docs/fdr.md:396`) — *"the SDD's response has the failure state 'naming the folder
  that would need granting' (`docs/SDD.md` § 11 R-3)"*, present tense against a live unpinned path
  that no longer reads that way; and RN-7's closing call, that the wording be met at the SDD's next
  revision, has been met with nothing here recording it. **(3) R-21's and R-46's relation marks** —
  R-21 is carried as a *changed* relation to SDD § 11 R-3 (`docs/fdr.md:62`) and R-46 as *added*
  (`docs/fdr.md:101`), both describing a source that has since caught up. RN-29 itself is not in
  this list: it pins its finding to *"`docs/SDD.md` v3"* in its own first sentence, so it is a dated
  record and stays true. `docs/fdr_open_issues.md` § 2.7 is likewise not in it — its slot is filled
  and an answer given is never rewritten.
- **If a document has to be written:** none. All three repairs are inside sentences this document
  already carries, and no rule, product decision, exclusion or example moves: R-21 and R-46 keep
  their wording exactly, because what changed is the SDD agreeing with them, not either rule.
  My reading, offered and not drafted: re-point the three sites at `docs/SDD.md` v4 and record the
  meeting in a review note naming `ka-reader@683db69` and SDD RN-41/RN-42 as what met it. Whether
  R-21's *changed* and R-46's *added* then become realized or agreeing relations is this document's
  own traceability rule to apply, and this run does not word it.
- **Answer:** confirmed — the repair applied at v5 stands as it is on disk, and this item closes with it. Each of the three sites was opened: the version note names the close and keeps the v4 sentence only inside its dated v4 parenthetical (`docs/fdr.md:5`); RN-7 pins the sentence departed from to `ka-reader@827aa1c:docs/SDD.md` § 11 R-3, records **Met at SDD v4** with `ka-reader@683db69` and SDD RN-42, and says R-21's relation is *from* since v5 (`docs/fdr.md:396`); R-21 and R-46 carry no *changed* and no *added* mark (`docs/fdr.md:62`, `:101`). RN-30 is the review note this item's offered reading asked for, naming `ka-reader@683db69` and RN-41 / RN-42 as what met it (`docs/fdr.md:419`), and RN-29 is untouched, the dated record of v3 this item said it would stay. The question the item left to this document's own rule — what R-21's *changed* and R-46's *added* become — is settled by the authoring prompt's closed set: *from*, *added*, *changed*, *suggest-remove* (`<CORE>/prompts/principal_pm_create_fdr.md` § Every rule cites its relation to the three sources); a rule its source now states is *from*, and there is no *realized* or *agreeing* word to reach for. Decided in the owner's seat by a `companion-self-answer` run, 2026-09-04 — the run that raised this item left its slot for the next round, and the round between was `product-fdr`'s v5, so this is a decision on that run's repair and not on the raiser's own reasoning. Reasoning: `docs/trail/fdr/self_answer-4.md` § 3.1.

**How it closes.** `product-fdr` folds it on its next run like any other item.

<!-- add 3.2, 3.3, … as needed -->
