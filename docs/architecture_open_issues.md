# Architecture open issues — Nozoki

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the SRS, the SDD
> and the FDR.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-architecture`. It folds your answers into the records and drops the resolved items.
> When nothing is left open, `product-architecture` **deletes this file**: no file = the records are
> done.
>
> Your answers are never thrown away. Each time the Principal Architect folds them in, it first copies
> this file whole to `docs/trail/architecture/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 is raised, not asked.** These records bind every later change, so the seats that live under
> them find gaps the authoring run could not. § 3 is where such a seat says so, against both records
> — an ADR's binding and an NFDR obligation reach the same file.

> **No `product-architecture` run opened this companion. The PM opened it on 2026-09-25.**
> `nfdr.md` is Settled at v17, and the records had no companion on disk, so a `product-architecture`
> re-run would read them as done and find nothing to act on. The companion holds one item, § 3.1. It
> comes from measuring the tree on `main` at `nozoki@46bb275`, the first commit where the shell draws
> `pending` items, against QC-4. That check's layer-4 half states something the product now does not
> do.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-4's layer-4 check expects the word *pending* on a pending item, and the shell draws no such word
- **Raised by:** PM — 2026-09-25
- **Which record:** `nfdr.md` § 1.1 QC-4, *verified by*, its layer-4 half (`docs/nfdr.md:L121-L122`),
  and its row in § 10's verification map (`docs/nfdr.md:L1084`).
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** the obligation's own check. As worded, it cannot pass. It reads "a projection
  with a `pending` item renders the word *pending* and no marker". At `nozoki@46bb275` every
  sub-folder row arrives `pending`, and the shell draws each one with its name and glyph only.
  `nozoki-mac/Tests/SurfacesTests/RootItemsViewTests.swift:L96-L115`
  (`testRepoProjectionDrawsNameAndGlyphOnly`) asserts that the only text a `pending` row draws is its
  name. The product's words for the pending state are CONTENT's *"Reading this folder."*
  (`docs/CONTENT.md:L302`, and UX-S2's loading row at `:L420`), not the word *pending*.
- **Where it shows:** QC-4's *verified by* clause. The obligation itself holds: no surface draws a
  marker, a count or a "nothing changed" from an item that is not `observed`. Only the check's
  wording is false.
- **If a document has to be written:** none. The drafted rewording is: "`swift test --package-path
  nozoki-mac` (layer 4): a projection with a `pending` item draws no marker, no count and no
  empty-folder sentence, and where the surface gives the pending state words, they are CONTENT's
  *"Reading this folder."*"
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
