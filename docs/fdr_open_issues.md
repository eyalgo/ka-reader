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

---

## 1. Open issues — behavioural questions with no answer yet

None.

## 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item raised against the FDR after it settled

### 3.1 The FDR still publishes from `kensaiapp/ka-reader`, where every document above it moved to `eyalgo/ka-reader`

- **Raised by:** Principal PM, cutting seeds (`seeds-from-product-docs`, the four-document pass) — 2026-10-22
- **Tracked by:** `ka-reader · nemawashi · 2026-10-22_the-fdr-publishes-from-eyalgo`
- **What it blocks:** the first public release (`docs/SDD.md` § 6 S-7) built against the FDR as it reads:
  it would publish where R-128 and PD-21 say it may not, at `eyalgo/ka-reader`, under a personal handle.
- **Where it shows:** R-128 names "a GitHub Release on `github.com/kensaiapp/ka-reader`" (`docs/fdr.md:L252`),
  and PD-21 says "The product is published from the `kensaiapp` GitHub organisation … no personal handle is
  its public face" (`:L295`), both tracing to SRS § 7 C-12. The sources moved: PRD v16 (§ Assumptions,
  *Public identity*, `docs/PRD.md:L396-L400`), SRS C-12 (`docs/SRS.md:L497-L499`, "published from
  `github.com/eyalgo/ka-reader`, under the maintainer's personal GitHub handle `eyalgo`") and SDD v52 C-R4
  (`docs/SDD.md:L632-L633`). ADR-0024 records the move, and NFDR QC-28 already names `eyalgo/ka-reader`. The
  FDR is the one settled document still on the old identity, and its header lists no re-derivation since
  v12. All at `ka-reader@eb50e87`.
- **If a document has to be written:** none. `product-fdr` re-derives R-128 and PD-21 against the moved
  sources on its next run.
- **Answer:** <the owner fills this in>

**How it closes.** `product-fdr` folds it on its next run like any other item.
