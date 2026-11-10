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

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-44 still says no script checks the beta wording or the catalogue, and § 9 and § 10 do not name the one that now does
- **Raised by:** PM — 2026-11-10
- **Which record:** `nfdr.md` § 4 QC-44 (its local realization paragraph), § 9 *The harness's own suites*, and § 10's QC-44 row
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; QC-44's verification reads as not built for an obligation the gate now checks, and the release inspection would re-do work a gate step does.
- **Where it shows:** QC-44 (`docs/nfdr.md:L1693-L1712`) records that at `ka-reader@b46d896` no script runs the catalogue `grep`. Its local realization at `ka-reader@1ee6ba1` leaves "the beta wording and its catalogue/surface checks" outside the local subset. § 10's QC-44 row (`:L3420`) names only `checks/readme.sh` and its suite. At `ka-reader@7a88215`, `checks/git-beta.sh` checks the beta row's wording against the Swift catalogue and `GitReadPolicy`, in `atOpen` and `followed` modes. `checks/readme.sh` checks the README's known-gaps beta block between its delimiters. The gate runs both scripts and their suites (`checks/gate.sh:L143-L144`, `:L152-L153`), and both exit 0 in a clean clone at that commit. Rendered placement and meaning, release-note wording and the downloaded-release proof are still outside any script. `grep -n 'git-beta' docs/nfdr.md` prints nothing.
- **If a document has to be written:** none. QC-44's realization, § 9's suite list and § 10's row name the delivered wording checks. The remaining release-inspection obligations stay distinct, and the dated measurements are kept.
- **Answer:** <the owner fills this in>

### 3.2 § 9 leaves the Swift packet's "`@testable import` is for layer 1 only" in force, and 34 of the 54 Swift test files depart from it
- **Raised by:** PM — 2026-11-10
- **Which record:** `nfdr.md` § 9, *`ka-reader-mac` against the Swift packet* ("a rule of it not named here is followed as written")
- **Tracked by:** `ka-reader · nemawashi · 2026-11-08_the-swift-test-targets-wear-the-packets-names`
- **What it blocks:** the Swift test-target split cannot tell whether its moved files must also drop `@testable` in layers above 1. Doing that raises internal view parts such as `StatusMessageView` and `GitReadNotice` to `package`, which is an interface change.
- **Where it shows:** the Swift packet's `testing.md` ("`@testable import` is for layer 1 only"). At `ka-reader@7a88215`, `grep -rl '@testable import' ka-reader-mac/Tests` lists 34 of 54 Swift test files, among them the layer-4 view cases `Tests/SurfacesTests/GitBetaNoticeTests.swift:L4` and `Tests/SurfacesTests/WorkbenchViewTests.swift:L4`. `grep -in testable docs/nfdr.md` prints nothing.
- **If a document has to be written:** none. § 9 either names the departure with its reason, or states that the rule binds and that layer-4 cases reach views through `package` access.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
