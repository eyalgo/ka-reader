# Self-answer report — DESIGN.md

## Header

- **Companion:** `docs/DESIGN_open_issues.md`
- **Document:** `docs/DESIGN.md` (Draft, v9)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-25
- **Sources re-read:** None — no answer this run gave rests on a source outside this repository.
  Every ground opened is a file in this repository or the pinned core (`<CORE>/roles/loaders/cdo_global.md`).

## Items worked

### 2.1 — § Do's says "show pending as the word *pending*", and the words are CONTENT's — which fixes a different sentence

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** The lean is right and its grounds hold as cited; the string comes out of the Do's line
  and the rule stays. Two additions: the item names one line and the document carries the string
  in two, and the second one is the line CONTENT actually raised; and the answer does not depend
  on how the FDR's seat reads R-94, which the item left as an open dependency.

  **Check 1.** The edit lands in `docs/DESIGN.md`, the CDO's document, and I am in the CDO's seat.
  It binds nobody outside the document: no person, no outside party, no risk anyone carries — only
  this document's agreement with `docs/CONTENT.md` on who holds a string. No ground is unseeable:
  every source the item cites was opened (below). Yours, in the owner's seat. Not the Content
  Editor's: their RN-4 already made their call and sent it here (`docs/CONTENT.md:L547-L554`,
  "raised to the CDO rather than applied silently"); what is open is only whether this document
  takes it, which is the CDO's.

  **Check 2 — every ground, opened.** The Do's line reads as quoted at `docs/DESIGN.md:L745-L747`.
  § Components "Status messages" hands the words to CONTENT at `:L673-L674` ("only the words
  differ, and those are `docs/CONTENT.md`'s"). CONTENT § Message patterns *Loading* fixes
  *"Reading this folder."* at `docs/CONTENT.md:L314`, with the formula at `:L308-L311` — present
  participle, one clause, full stop, no ellipsis. RN-4 at `:L547-L554` records the collision and
  the raise. RN-14 at `docs/DESIGN.md:L917-L918` reads "Pending states carry a word and nothing
  that moves". The two greps the item reports were re-run 2026-09-25 and return what it says:
  `grep -n 'ellipsis\|full stop\|Reading this' docs/DESIGN.md` finds `:L471` only, and
  `grep -ni pending docs/trail/design/*.md` finds cycle-2's "record is pending" and cycle-3/4's
  "empty, pending, and failure state" — never the word on a surface. The lean's wording — "show
  pending as a word, in `docs/CONTENT.md`'s wording, not as a bar or a spinner" — keeps the
  negative that is this document's (no bar, no spinner; UX-I13's "no progress indicator that
  advances without observed progress", `docs/UXD.md:L306-L311`) and drops the one thing that is
  not: the string.

  **The first addition — the line the item did not cite.** `grep -n -i pending docs/DESIGN.md`
  (2026-09-25) finds the string in a second body line: § Components "Status messages",
  `:L689`, "A pending state carries no spinner and no bar; the word says pending, and nothing
  moves." That is the line CONTENT RN-4 cites — it names *§ Components ("Status messages")*, not
  the Do's (`docs/CONTENT.md:L548`). The item narrowed the raise to the Do's line; the fold that
  answers RN-4 has to reach the line RN-4 pointed at, or CONTENT's raise is still unanswered
  after this round closes. The Traceability row for UX-I13 (`docs/DESIGN.md:L1227`) reads
  "pending is a word, never a bar" — a word, not the word — and does not move. The same fold
  should record, in the Review Note that carries it, that RN-4's raise is what it answers: the
  item's Grounds name the absence of that record as part of the defect, and folding the wording
  without the record leaves the absence in place.

  **The second addition — the FDR dependency is not one.** The item says the same string "is
  raised on `docs/fdr_open_issues.md` § 2.1", and the architecture answer this companion came from
  (`docs/trail/architecture/self_answer-18.md:L56-L61`) is explicitly "built on R-88's reading",
  with the word returning to QC-4 if the FDR's seat reads R-94 as literal. This document's answer
  does not inherit that dependency. Which words a state carries is CONTENT's by this document's
  own seam (`:L673-L674`) and by the CDO's (`<CORE>/roles/loaders/cdo_global.md:L58-L65` —
  "`CONTENT.md` is a language document and it is not yours … What is not yours is the standard
  those words are written to"). If the FDR's seat answers that R-94 is literal, the document that
  moves is CONTENT — its *Loading* formula would have to admit the word — and this document's
  pointer at CONTENT is then still the right sentence. If R-94 names the state, CONTENT stands and
  the pointer is still right. So the two folds may land in either order and neither waits on the
  other.

  **Check 3.** The answer agrees with every settled thing it touches. UXD v10 UX-I13 says "the
  surface shows pending" and UX-S2's loading cell says "shows that it is pending" (`docs/UXD.md:L237`,
  `:L306-L309`) — the state, never a string. CONTENT v7 Settled: the *Loading* formula and RN-4.
  FDR v8 R-88 makes CONTENT the wording standard (`docs/fdr.md:L170`). FDR R-94 (`:L176`) is the
  one settled line that disagrees, and it is already raised on its own companion; this answer is
  not built on either reading of it (above). The prior self-answers on this document
  (`docs/trail/design/self_answer-1.md`, `self_answer-2.md`) are folded at v6 and v8 and touch
  nothing here. The v9 header's own note on this item (`docs/DESIGN.md:L1199-L1204`) calls it "a
  wording question about the Do's line that names the word *pending*, not a token" — consistent,
  and no token moves under this answer.

  **Check 4.** *Empty* — the startup surface (UX-S4) has no pending state (`docs/UXD.md:L239`,
  "n/a — nothing on this surface is read from disk"); nothing to say. *Absent* — CONTENT missing:
  the pointer would dangle, but CONTENT is Settled v7 on disk and the pointer form is one this
  document already uses at `:L665` and `:L673-L674`. *Stale* — CONTENT re-words its *Loading*
  sentence: the pointer stays true; the literal would go false, which is the whole reason the
  string comes out. *Concurrent* — the FDR fold, the architecture fold and this fold may land in
  any order; shown above that this answer holds under either FDR outcome. *Refused* — the owner
  overrides to keep the literal *pending*: then CONTENT RN-4 has to be overturned on CONTENT's own
  companion (none is on disk — CONTENT is Settled v7 with its companion gone) and
  `docs/fdr_open_issues.md` § 2.1 answered literal; naming that is the cost of the override, and
  nothing here forecloses it. One case this answer does not cover, named: whether the tree today
  *shows* a pending row at all. At `ka-reader@46bb275` a `pending` row draws its name and glyph and
  no word (`docs/fdr_open_issues.md` § 2.1 *If overridden*, citing
  `ka-reader-mac/Sources/Surfaces/RootItemsView.swift:L161-L170`), while UX-S2 requires that a folder
  not yet read "shows that it is pending rather than showing as empty" (`docs/UXD.md:L237`) and
  FDR R-32 says the same. That is a behaviour question against a settled requirement, the PM's to
  route, not a design-language one — this item decides how pending looks when it is shown, and
  its negative (no bar, no spinner) holds on a row that draws nothing.

  **What I was close to deciding differently:** a plain *confirmed*. The lean's wording is the
  right wording and I changed none of it. It stayed *confirmed with addition* because a fold made
  from the item as written would reword the Do's line and leave `:L689` — the line CONTENT's RN-4
  actually cites — saying "the word says pending", and CONTENT's raise would read answered while
  its target still stood.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/DESIGN.md`** — `<CORE>/launchers/skill/launcher.sh product-design ka-reader`
