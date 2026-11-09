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
> settled NFDR (v89) against the product at `ka-reader@98867b3`, where `ka-reader-mac/assemble.sh`
> copies the tree's `LICENSE` and `THIRD_PARTY_NOTICES.md` into the app before it signs and
> `checks/bundle.sh` fails on a missing or differing copy. One item follows in § 3; neither record is
> edited.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-41 says no check holds the bundle's copies; `checks/bundle.sh` and its suite now hold them at every change
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR QC-41, its *verified by:* tail; its § 10 row; and § 10's list of review gates
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; QC-41 names `development-design` as the gate for a rule a check now holds, and the release's later work cites the entry.
- **Where it shows:** `docs/nfdr.md:L1619-L1625` ("Two rules are owed to a check and held by none at `ka-reader@06e4a34`. The bundle's copies are owed to `checks/bundle.sh` …"); the § 10 row at `:L3341` ("`checks/bundle.sh` (suite `test_bundle.sh`) for the bundle's copies — not held at `ka-reader@06e4a34`", with `development-design` "(the bundle's copies and the copyright lines, until their checks hold them)" in its gate column); § 10's review-gate list at `:L3365` ("QC-41 (the bundle's copies and the copyright lines, until their checks hold them)"). At `ka-reader@98867b3`, `checks/bundle.sh:L358-L359` pairs `LICENSE` with `Contents/Resources/KA-Reader-LICENSE` and `THIRD_PARTY_NOTICES.md` with `Contents/Resources/THIRD_PARTY_NOTICES.md` and fails on a missing, symlinked or differing copy; it runs as the gate's *Bundle probe* step (`checks/gate.sh:L95`) with its suite as *Bundle probe suite* (`:L97`); `checks/tests/test_release_pack.sh` holds a copy dragged off the image keeping both. The copyright-lines rule is still held by no check.
- **If a document has to be written:** none — QC-41's tail, its § 10 row and the review-gate list are re-measured at the current tree: the bundle's copies held by `checks/bundle.sh` (suite `test_bundle.sh`) at the change and at the release, and `development-design` left the gate for the copyright lines alone.
- **Answer:** <the owner fills this in>
