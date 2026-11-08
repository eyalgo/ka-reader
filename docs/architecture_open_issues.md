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
> settled NFDR against the product at `ka-reader@2d7c4f9`, where the tree gained a second workflow,
> `.github/workflows/release.yml`, five release scripts under `checks/` and their five suites. Three
> items follow in § 3; neither record is edited.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-64 says "the CI workflow" holds no rule of its own; the tree now holds two workflows, and the release one holds a gate no gate step runs
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR QC-64, its statement and its § 10 row
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; QC-64 reads false against the tree, and the next change that touches a workflow cites it.
- **Where it shows:** `docs/nfdr.md:L2331` ("One script, `checks/gate.sh`, holds every rule the CI workflow holds") and the § 10 row at `:L3210` ("every workflow rule held by one script, run at the change; the workflow holds none of its own"). At `ka-reader@2d7c4f9`, `ls .github/workflows/` → `ci.yml`, `release.yml`; `release.yml:L66` runs `cargo audit` (QC-27), which no `checks/gate.sh` step runs; `release.yml`'s step list is held at the change by the gate step *Release workflow shape* (`checks/gate.sh:L135`, `checks/release-shape.sh`).
- **If a document has to be written:** none — QC-64 names `.github/workflows/ci.yml` as the workflow every rule of which `checks/gate.sh` holds, and its row says that `release.yml`'s step list is held at the change by `checks/release-shape.sh`, its pieces by the release suites in the gate, and its `cargo audit` at release under QC-27 (and QC-29 for the checksum).
- **Answer:** <the owner fills this in>

### 3.2 § 9's harness-suites bullet counts seventeen suites; the tree holds twenty-two
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR § 9, the bullet "The harness's own suites, `checks/tests/`, run as steps of `checks/gate.sh`"
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; the bullet's count is five short.
- **Where it shows:** `docs/nfdr.md:L2727-L2728` ("Seventeen top-level shell suites are in the tree at `ka-reader@3fa227e…`"). At `ka-reader@2d7c4f9`, `ls checks/tests/*.sh | wc -l` → `22`; the five new ones are `test_release_absent.sh`, `test_release_pack.sh`, `test_release_shape.sh`, `test_release_sums.sh` and `test_release_version.sh`, each the whole command of one `run_step` line of `checks/gate.sh` (version 1.11.0).
- **If a document has to be written:** none — the bullet is re-measured at the current tree.
- **Answer:** <the owner fills this in>

### 3.3 QC-70's dated reading of the statuses the tree holds names none of the five release scripts
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR QC-70, the sentence "At `ka-reader@3fa227e` the tree holds these: …"
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; the statuses are within QC-70's five, but its reading of where each occurs is out of date.
- **Where it shows:** `docs/nfdr.md:L2519-L2525`. At `ka-reader@2d7c4f9` each release script exits 2 on a wrong count — `checks/release-version.sh:L39`, `checks/release-pack.sh:L43`, `checks/release-sums.sh:L33`, `checks/release-absent.sh:L34`, `checks/release-shape.sh:L39` — and `checks/release-pack.sh` maps a signal to 1 with `trap 'exit 1' HUP INT TERM` (`:L68`).
- **If a document has to be written:** none — the reading is re-measured at the current tree.
- **Answer:** <the owner fills this in>
