# FDR open issues — Nozoki

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

> **No `product-fdr` run opened this companion.** A `companion-self-answer` run answering
> `docs/architecture_open_issues.md` § 3.1 opened it on 2026-09-25, in the Principal Architect's
> posture. `fdr.md` is Settled at v8 and had no companion on disk, so a `product-fdr` re-run would
> read it as done and find nothing to act on. It holds one item, § 2.1: a clause of R-94 that the
> NFDR's QC-4 check was verifying word for word, found while that check was being corrected. The
> reasoning is `docs/trail/architecture/self_answer-18.md`.

---

## 1. Open issues — behavioural questions with no answer yet

None.

## 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override

### 2.1 R-94 says the surface shows *the word pending*, and the wording standard the FDR itself names fixes a different sentence for that state
- **Drafted into the FDR:** nothing — the run that raised this writes no document. The lean, for the
  seat that folds it: R-94's second clause names the state and not a string, and reads so — "where
  the product does not yet know, the surface shows that it is pending, in the words
  `docs/CONTENT.md` § Message patterns *Loading* fixes, and no spinner or progress bar is drawn."
  R-19 and R-32 already say it that way ("shows that it is pending", `docs/fdr.md:L61`, `:L82`).
- **Rationale:** R-88 makes `docs/CONTENT.md` the wording standard for every message the product
  writes (`docs/fdr.md:L170`). CONTENT § Message patterns *Loading* gives the pending folder
  *"Reading this folder."* (`docs/CONTENT.md:L314`; UX-S2's loading row at `:L492`), and its RN-4
  records why *pending* was not the word — it named the tool's state rather than what it was doing
  (`:L547-L554`). SDD C-E1, which R-94 traces to, says "the surface shows pending" with no "the
  word" (`docs/SDD.md:L823-L830`). So R-94 (`docs/fdr.md:L176`) is the one FDR line that names a
  string, and it names one the standard it defers to does not fix. The NFDR was verifying that
  string — QC-4's layer-4 check (`docs/nfdr.md:L121-L123`) — and is being corrected to verify no
  word at all, on `docs/architecture_open_issues.md` § 3.1. That correction is built on the reading
  above; this item is where the FDR's seat says whether the reading is right.
- **If overridden:** if R-94 is literal, CONTENT § Loading and UX-S2's loading row
  (`docs/UXD.md:L237`) cannot both hold beside it, and the product does not deliver it: at
  `nozoki@46bb275` a `pending` row draws its name and glyph and no word
  (`nozoki-mac/Sources/Surfaces/RootItemsView.swift:L161-L170`;
  `nozoki-mac/Tests/SurfacesTests/RootItemsViewTests.swift:L96-L115`). That is then a behaviour
  gap to route as a change, and the NFDR's QC-4 check takes the word back on a fresh item.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item raised against the FDR after it settled

None.
