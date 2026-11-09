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

> **No `product-fdr` run wrote this file.** The PM opened it on 2026-11-09, reading the settled FDR
> (v15) against the settled PRD v19. One item follows in § 3; the FDR is not edited.

---

## 1. Open issues — behavioural questions with no answer yet

None.

## 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item raised against the FDR after it settled

### 3.1 R-198 locks the one repository made public with its own history; PRD v19 publishes the main line's history from a private `ka-reader-dev` into the public repository
- **Raised by:** PM — 2026-11-09
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** the first public release's publication step is locked to a behaviour the PRD no longer states: R-198 has the repository R-128 names "made public", while PRD v19 keeps the work in a private repository and has the public one receive only the main line's history, never rewritten.
- **Where it shows:** `docs/fdr.md:L276` (R-198) against `docs/PRD.md:L420-L430` (v19 § Assumptions **Public identity**); the owner's answer is `docs/trail/prd/cycle-17.md` § 3.1. R-128 (`docs/fdr.md:L257`) keeps `github.com/eyalgo/ka-reader` as the release's one home, which v19 leaves unchanged.
- **If a document has to be written:** none — R-198 restates what the public repository receives and when.
- **Answer:** <the owner fills this in>

**How it closes.** `product-fdr` folds it on its next run like any other item.
