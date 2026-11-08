# Architecture open issues — KA-Reader

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

> **No `product-architecture` run wrote this file.** The Principal PM opened it on 2026-11-08, in
> `nemawashi-refine`'s answer to the retired seed `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`,
> on recommendation 1 of the unit `ka-reader · tobiishi · 2026-11-07_the-promise-holds-over-markdown`.
> One item follows in § 3; neither record is edited.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 The offline-page check can end 0 and print `same` when its comparison failed, and QC-70 records no such gap
- **Raised by:** Principal PM — 2026-11-08
- **Which record:** NFDR QC-70 (the check scripts' five statuses, "only a pass is 0")
- **Tracked by:** none yet — the cut from the product's documents that follows this item's fold draws the fix, together with QC-67's three known gaps, which the NFDR already states.
- **What it blocks:** nothing is blocked; the offline-page step of the gate can pass on a comparison that never ran, so the promise it proves (UX-I15, the page the same with the network off) can read held when it was not checked.
- **Where it shows:** `checks/offline-page.sh:L216-L220` at `ka-reader@8823057`: the comparison is `diff … | sed … | cut … | LC_ALL=C sort -u || true` under `set -euo pipefail` (`:L39`). The comment at `:L216-L218` gives the `|| true` for `diff`'s exit 1, but it also swallows `diff`'s exit 2 (trouble), which prints nothing to stdout, so `differing` is empty and `:L222-L224` set `same` and status 0. The unit's code-integrity report names it: `ka-reader · tobiishi · 2026-11-07_the-promise-holds-over-markdown`, `code-integrity-report.md:L103-L105` ("A failed `diff` would read as `same`"). QC-70 (`docs/nfdr.md:L2506-L2507`) states "only a pass is 0", and its dated reading of the tree (`:L2518-L2527`) lists no gap here, unlike QC-67, which carries its three as known gaps (`:L2488-L2493`).
- **If a document has to be written:** none — QC-70 records the swallowed `diff` failure as a known gap until a change lands, the way QC-67 records its three, so the cut from the documents can draw the fix.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
