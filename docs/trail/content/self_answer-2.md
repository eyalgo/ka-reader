# Self-answer report — CONTENT.md

## Header

- **Companion:** `docs/CONTENT_open_issues.md`
- **Document:** `docs/CONTENT.md` (Draft, v5)
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-01

## Items worked

### 2.1 — RN-24 cites a file outside this repository, which RN-15 rules this document never does

- **Bucket:** 2. Choices to confirm
- **Verdict:** overridden
- **Why:** The draft's **choice** is right and its **remedy** is not, so the override is narrow:
  RN-15 does not move, and the pointer still goes — but what replaces it is a citation, not a
  restatement.

  **The defect verifies.** `system/projects/ka-reader/agari.md` is absent from this repository (there is
  no `system/` directory in it at all) and present at
  `kensaiapp-opensource/system/projects/ka-reader/agari.md` — checked 2026-09-01. Every other file
  `docs/CONTENT.md` cites resolves inside the repository: of the twelve distinct backticked paths in
  the file, eleven are present and this is the one that is not. (A thirteenth backticked filename, the
  bare `DESIGN.md` in § Voice's scope note, names the design language rather than pointing at a path,
  which the bar separates out — *"Naming a file in order to point at it is not a claim about what it
  says"*, `system/doctrine/writing_bar.md` § 1.2 *How a document reads*.) So the item is right that
  this is one place, not a pattern.

  **Why the drafted remedy fails.** It says to "state the Agari's ground in KA-Reader's own words" —
  which is a paraphrase of the product's defining guarantee, and the house bar forbids exactly that:
  *"A commitment is quoted, never paraphrased. Where a document here carries a commitment another
  document owns — a guarantee, a licence term, a limit, a support period — it quotes that document's
  wording exactly and cites it"* (`system/doctrine/writing_bar.md` § 1.5 *What open source adds*). The remedy would trade an
  unopenable locator for an unsourced assertion, which is the same rule broken from the other side.
  Its stated authority is a mis-fit too: RN-15 prescribes restatement "where a rule here restates a
  limit this product inherits from the organisation that publishes it", and RN-24's citation is not
  that — it is corroboration that the promise already covered the wider input before this document
  widened it.

  **What replaces it, and why nothing is lost.** `docs/PRD.md` § Purpose carries the same promise over
  the same wider input, inside this repository: *"browsing a folder's files — and, when that folder is
  a Git repository, inspecting its Git status — in which nothing can be changed"*. It is not a
  substitute of convenience — the Agari itself defers to it for that sentence: *"the product sentence
  is the PRD's, `docs/PRD.md` § Purpose"* (`system/projects/ka-reader/agari.md:L16-17`). The outside
  pointer was pointing at a document that points back inside this repository, so citing the PRD
  reaches the source rather than the summary, which is the direction the bar already runs in — *"A
  summary held in one of our own documents is never the citable source for what it summarizes"*
  (`system/doctrine/writing_bar.md` § 1.4 *How a claim declares its kind*). `docs/PRD.md` § Success Metrics "Read-only integrity"
  carries it a second time — *"Nothing the product does writes into the folder it is pointed at"* —
  and is already the locator on the standing-sentence row, so RN-24 and the sentence it explains end
  up citing one document instead of two.

  **Why the alternative is rejected outright.** Narrowing RN-15 to admit a named instance-repo
  citation would let a public product's document rest claims on files no member of the public can
  open. The instance bar has already settled who the reader is, and an outsider is named in it:
  *"an outsider who found the work and is deciding whether to trust it"*
  (`system/doctrine/writing_bar.md` § 1.1 *The reader*), with § 1.2 *How a document reads* requiring *"a locator the reader can open"*.
  RN-15 is a faithful restatement of that bar, not a local preference — so narrowing it would put the
  document below the instance bar, which no CONTENT-level note has the authority to do.

  **Check 1.** The edit lands in `docs/CONTENT.md`, this seat's own document. It binds no outside
  party, no money, no legal position and no reserved taste, and I can name no ground I cannot see. The
  previous run left this item because *"the second option moves a rule rather than a note"* — but that
  ground is about the option I am declining, not the one I am taking, and the prompt is explicit that
  a general possibility of being overruled is not a seat. Mine, in the owner's seat.

  **Check 3.** Nothing the document states changes. The standing sentence in § Terminology *Standing
  sentences* is untouched, RN-15 is untouched, and RN-24's argument for the widened wording stands —
  only its locator moves. It agrees with the answer given last round (§ 2.1 of
  `docs/trail/content/cycle-4.md`), which repaired twelve pointers on the ground that this document
  cites only what a cloner can open; this is the thirteenth and the last, decided on the same ground.

  **Check 4.** *Absent:* both replacement targets verified present, and `docs/PRD.md` § Purpose exists
  under that exact heading. *Stale:* a later rewording of PRD § Purpose would leave RN-24's quote
  stranded — the standing exposure of every citation in the document, not something this answer adds,
  and the bar's own § 1.2 *How a document reads* check is what catches it. Named, not covered. *Concurrent:* if the README
  revision RN-27 records lands before `product-content` re-runs, it touches no note in this document,
  so nothing collides. *Refused:* if the owner overturns this and narrows RN-15 instead, RN-24's
  pointer is the only thing that returns; nothing else in the document was written against this
  answer.

## Left for the owner

None this run.

## Skipped

None this run — the companion carried one item and its slot was at its placeholder.

## Companions opened

None this run — the change belongs to the document being answered, and it is decided in that
document's own slot rather than raised elsewhere.

## Launchers owed

- **`docs/CONTENT.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-content/launcher.sh ka-reader`
