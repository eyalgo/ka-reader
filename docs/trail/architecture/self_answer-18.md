# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (NFDR v17, Settled)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-25
- **Sources re-read:** None — no answer this run gave rests on a source outside this repository.
  Everything was measured on the tree at `ka-reader@4b9425b`, the last commit before this run, whose
  `ka-reader-mac/` is the item's `ka-reader@46bb275` unchanged (`git diff --stat 46bb275 HEAD --
  ka-reader-mac` prints nothing).

One item, and it belongs to this document's seat. It is a correction — the check's wording states
something the tree does not do — so § *A widening item waits until it occurs* does not apply.
Nothing needed a call only the owner can make. Two documents this run read were found owed a change
no item raised, and both companions were opened and committed before the slot that names them was
written (§ Companions opened).

## Items worked

### 3.1 — QC-4's layer-4 check expects the word *pending* on a pending item, and the shell draws no such word

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** Confirmed, because the fact is as the item says and the obligation holds. At
  `ka-reader@46bb275` a `pending` row draws its name and its glyph and nothing else: the cell sets the
  name, the glyph, and a condition sentence for `failed` only
  (`ka-reader-mac/Sources/Surfaces/RootItemsView.swift:L161-L170`), and
  `testRepoProjectionDrawsNameAndGlyphOnly` asserts the only visible text is the name
  (`ka-reader-mac/Tests/SurfacesTests/RootItemsViewTests.swift:L96-L115`). QC-4's obligation — no
  marker, no count, no "nothing changed" from an item that is not `observed` — is what the tree
  does. The check's clause "renders the word *pending*" (`docs/nfdr.md:L121-L123`) is false.

  **What the PM's argument left out, and why it changes the rewording.** The item reads the clause
  as a slip and CONTENT as the only source for the state's words. The clause has a source: FDR
  R-94's second clause, "the surface shows the word *pending*" (`docs/fdr.md:L176`), which QC-4
  cites in its trace, and the same string sits in `docs/DESIGN.md` § Do's (`:L744-L746`). Against
  them `docs/CONTENT.md` § Message patterns *Loading* fixes *"Reading this folder."* (`:L314`) and
  RN-4 records why *pending* was not chosen (`:L547-L554`). Three settled documents, two words. The
  PM's drafted second clause — "where the surface gives the pending state words, they are CONTENT's
  *'Reading this folder.'*" — takes CONTENT's side silently and copies its string into this
  document, where a re-wording of CONTENT would make it false again.

  **The answer.** The NFDR verifies neither word, because naming one is not QC-4's job. The
  obligation is the negative; which words a surface shows is QC-53's (every message is a catalogue
  sentence, `docs/CONTENT.md`'s — `docs/nfdr.md:L759-L766`) and FDR R-88's ("the wording standard
  is `docs/CONTENT.md`'s", `docs/fdr.md:L170`). So the layer-4 half keeps the drafted first clause
  and replaces the second with a pointer: the only words a `pending` item may carry are the *Loading*
  sentence `docs/CONTENT.md` § Message patterns fixes. The trace to R-94 stays — R-94's first clause
  ("no indicator is drawn before the product has observed the state it stands for") is the
  obligation. Two more facts the fold needs: the layer table's row 4 (`docs/nfdr.md:L888`) says
  "*pending* as the word" and moves the same way, and § 10's QC-4 row (`:L1084`), which the item
  cites, names commands only and does not move.

  **Where the answer rests, and what it does not settle.** It is built on R-88's reading: R-94
  names the state and the string is CONTENT's. That reading is the FDR's seat's to confirm, and
  the contradiction between R-94, DESIGN and CONTENT is a defect in whichever is wrong, so both are
  raised on their own companions (§ Companions opened). If the FDR's seat answers that R-94 is
  literal, the tree at `46bb275` violates R-94 — a behaviour gap to route, not this seat's — and
  the word returns to QC-4's check on a fresh item.

  **Failure paths.** *Empty:* a `pending` row with no words at all is the tree today, and the check
  passes on the existing test. *Absent:* a root nothing was read for has no projection
  (`ka-reader-mac/Sources/Surfaces/RootListing.swift:L3`), so the check, which reads "a projection
  with a `pending` item", does not reach it; the root-before-read is C-E1's and QC-4's layer-1 half.
  *Stale:* CONTENT re-wording its *Loading* sentence leaves the check true, which the drafted
  clause would not have; the item's own cites already went stale between its writing and this run
  (`:L302` → `:L314`, `:L420` → `:L492`, CONTENT v7 at `ka-reader@1c95030`, 21:28 today; the item was
  committed at `ka-reader@41915e6`, 10:07) — reported here, not corrected in the item. *Concurrent:* a
  reused cell never carries a stale sentence because every row sets it
  (`RootItemsView.swift:L162`), and the check reads one projection. *Refused:* covered above — the
  FDR's seat refusing R-88's reading sends the word back on a fresh item.

  **What would have tipped it.** *Overridden* was close: the drafted second clause is replaced.
  It stayed *confirmed with addition* because the finding, the reading of the obligation and the
  drafted first clause stand exactly as the PM wrote them; only the copied string goes, and the
  reason it goes is an addition the item did not have. Had the NFDR carried no QC-53 and the FDR no
  R-88, the check would have had to name a word, and this item would have been the FDR's before it
  was this document's.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

- **`docs/fdr_open_issues.md`** — **opened** — companion to `fdr.md`, landed in commit `80c222e`
- **`docs/DESIGN_open_issues.md`** — **opened** — companion to `DESIGN.md`, landed in commit `1d5ba78`

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
- **`docs/fdr.md`** — `<CORE>/launchers/skill/launcher.sh product-fdr ka-reader`
- **`docs/DESIGN.md`** — `<CORE>/launchers/skill/launcher.sh product-design ka-reader`
