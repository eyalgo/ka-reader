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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-11-09, reading the
> settled NFDR (v90) against the product at `ka-reader@75fe66c`, where `checks/notices.sh` reads each
> resolved package's licence files and fails on a copyright line the notices lack, and against the
> settled PRD v19. Two items follow in § 3; neither record is edited.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-41 says no check holds the copyright lines; `checks/notices.sh` and its suite now hold them at every change and at a tag
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR QC-41, its *verified by:* tail; its § 10 row; and § 10's list of review gates
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; QC-41 names `development-design` reading the entry as the copyright lines' gate "until it lands", and the check has landed, so the record states a gate the product no longer relies on and leaves unnamed the one it does.
- **Where it shows:** `docs/nfdr.md:L1632-L1637` ("One rule is owed to a check and held by none at `ka-reader@b503b6d`: the copyright lines, owed to `checks/notices.sh` … Until it lands, `development-design` reading this entry is that rule's gate"); the § 10 row, `:L3353` ("`checks/notices.sh` extended to the copyright lines — not held at `ka-reader@b503b6d`"; *Gated at* "`development-design` reading the entry (the copyright lines, until its check holds them)"); and the review-gate list, `:L3377` ("QC-41 (the copyright lines, until its check holds them)"). At `ka-reader@75fe66c`, `checks/notices.sh` 1.1.0 reads each resolved package's licence files and fails on a copyright line the notices lack, run by the gate's *Notices check* and *Notices check suite* steps (`checks/gate.sh:L129-L130`) and so by the release workflow's *Test gate*; `checks/notices.sh` exits 0 on that tree and its suite passes. What the check does not read stays with review and release inspection: the libraries' and the icon set's copyright lines, any `NOTICE` file whole, and the sentences saying a component has no licence file or no copyright line.
- **If a document has to be written:** none — QC-41's tail, its § 10 row and § 10's review-gate list name the extended check as holding the crates' copyright lines, and keep review for the parts it does not read.
- **Answer:** <the owner fills this in>

### 3.2 QC-71 checks every ref of one repository made public; PRD v19 publishes only the main line's history from a private `ka-reader-dev` into the public repository
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR QC-71, and its § 10 row
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** QC-71's check set is the private repository's refs: measured today, `origin` is `<owner>/<repository>-dev` and `git ls-remote --heads --tags origin` lists 11 refs, the branches v19 keeps private; and the public repository is to receive the main line by a push, not be made public.
- **Where it shows:** `docs/nfdr.md:L1691-L1700` (QC-71: "made public with its own commit history … every ref the public remote will hold — the set `git ls-remote --heads --tags origin` lists") and `:L3356` (its § 10 row), against `docs/PRD.md:L420-L430` (v19 § Assumptions **Public identity**) and `docs/trail/prd/cycle-17.md` § 3.1, which names QC-71 and QC-28 among what the split reaches.
- **If a document has to be written:** none — QC-71 names the set the public repository receives, the main line's history at its first push, and the root-commit comparison against it.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
