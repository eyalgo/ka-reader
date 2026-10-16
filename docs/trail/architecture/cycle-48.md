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

> **No `product-architecture` run wrote this file.** The owner opened it on 2026-10-16, in an
> interactive session, after `PRD.md` v16 (`ka-reader@74ca793`), `SRS.md` v13 (`ka-reader@3a6e021`)
> and `SDD.md` v52 (`ka-reader@ab7ba0b`) moved the public identity to `github.com/eyalgo/ka-reader`.
> The records are Settled, so without a companion the upstream move would reach no one.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 ADR-0007 and the NFDR's checks name `kensaiapp/ka-reader`; the repository is now `eyalgo/ka-reader`
- **Raised by:** Product (owner) — 2026-10-16
- **Which record:**
  - `adr/0007-ad-hoc-signed-dmg-on-a-github-release.md` lines 10 and 22: the product "is published
    from `github.com/kensaiapp/ka-reader`" and the channel is "a GitHub Release on
    `github.com/kensaiapp/ka-reader`".
  - `nfdr.md`, the forward-looking checks: line 824 (QC-25's command), 991 and 2019 (QC-28's
    `gh secret list`), 1284 and 1287 and 2032 (QC-42's identity and
    `gh api repos/…/private-vulnerability-reporting`), and § 10's QC-25 row (line 2015).
- **Tracked by:** no seed.
- **What moved upstream:** the owner transferred the repository from the `kensaiapp` organisation
  to the personal account `eyalgo` on 2026-10-16; it is still private, and its visibility and CI
  billing are to be settled later. PRD v16 § *Public identity*, SRS v13 C-12 and SDD v52 (the
  release channel, E-7) all now name `github.com/eyalgo/ka-reader`.
- **What it blocks:** nothing today. GitHub redirects the old address, so the commands still run.
  But the records state an address no upstream document does, and a check written against an
  organisation would fail if that name were ever reused.
- **Not to change:** lines that record runs made at the old address (for example 1750, 1763, 3642,
  5673, 5737 and 5775 — `gh run … --repo kensaiapp/ka-reader` with a run id or as measured) stay as
  written.
- **If a document has to be written:** the Principal Architect's call — an amendment to ADR-0007's
  address, or a superseding ADR if an Accepted ADR is not edited in place. The NFDR is a fold.
- **Answer:** Follow the upstream documents: the channel and every forward-looking check read
  `github.com/eyalgo/ka-reader` / `eyalgo/ka-reader`. The decision ADR-0007 records — an ad-hoc-signed
  `.dmg` on a GitHub Release, built by CI — is unchanged; only where it lives moves.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
