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
- **Answer:** confirmed with addition — QC-64's statement and its § 10 row name `.github/workflows/ci.yml` as the workflow every rule of which `checks/gate.sh` holds, and "the workflow holds no rule of its own" is said of `ci.yml` alone. One sentence then states `.github/workflows/release.yml` at `ka-reader@2d7c4f9`: its first step after the checkout runs `checks/gate.sh` (`:L53-L54`); its step set and order, the *nothing else* half included, are held at the change by the gate's *Release workflow shape* step (`checks/gate.sh:L135`, `checks/release-shape.sh`, whose *No other write* requirement refuses a step it does not list), and the four release scripts it runs by their suites (`checks/gate.sh:L137-L140`); its *Cargo audit* step (`:L63-L66`) is QC-27's release gate and its *Verify checksums* step (`:L77-L78`) is QC-29's, both run at a tag push and at no change. QC-27's tail names that step as where its audit runs. While Actions is off `release.yml` runs nowhere, so the audit gates no release; none can be offered, because QC-29 offers only a release built from its tag by that workflow. `development-design` reading QC-64 stays the gate on `ci.yml`'s *nothing else* half only. Reasoning: `docs/trail/architecture/self_answer-81.md` § 3.1.

### 3.2 § 9's harness-suites bullet counts seventeen suites; the tree holds twenty-two
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR § 9, the bullet "The harness's own suites, `checks/tests/`, run as steps of `checks/gate.sh`"
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; the bullet's count is five short.
- **Where it shows:** `docs/nfdr.md:L2727-L2728` ("Seventeen top-level shell suites are in the tree at `ka-reader@3fa227e…`"). At `ka-reader@2d7c4f9`, `ls checks/tests/*.sh | wc -l` → `22`; the five new ones are `test_release_absent.sh`, `test_release_pack.sh`, `test_release_shape.sh`, `test_release_sums.sh` and `test_release_version.sh`, each the whole command of one `run_step` line of `checks/gate.sh` (version 1.11.0).
- **If a document has to be written:** none — the bullet is re-measured at the current tree.
- **Answer:** confirmed with addition — § 9's bullet is re-measured at `ka-reader@2d7c4f9`, and the seventeen at `3fa227e` stay as a dated reading. Twenty-two top-level suites are in the tree, each the whole command of one `run_step` line of `checks/gate.sh` (1.11.0): `test_secret_scan.sh` (`:L59`), `test_secret_scan_planted.sh` (`:L77`), `test_structure.sh` (`:L90`), `test_entry_points.sh` (`:L92`), `test_bundle.sh` (`:L95`), `test_view.sh` (`:L97`), `test_renderer.sh` (`:L107`), `test_read_only.sh` (`:L118`), `test_no_network.sh` (`:L120`), `test_offline_page.sh` (`:L122`), `test_strings.sh` (`:L128`), `test_strings_step.sh` (`:L129`), `test_release_shape.sh` (`:L136`), `test_release_version.sh` (`:L137`), `test_release_pack.sh` (`:L138`), `test_release_sums.sh` (`:L139`), `test_release_absent.sh` (`:L140`), `test_own_state.sh` (`:L141`), `test_vm_refusal.sh` (`:L147`), `test_launch.sh` (`:L148`), `test_own_state_step.sh` (`:L149`) and `test_tree_scene.sh` (`:L150`). The five counted now pair by name with `checks/release-shape.sh`, `release-version.sh`, `release-pack.sh`, `release-sums.sh` and `release-absent.sh`, so the "no script of its own name" sentence reads three of the twenty-two, the same three. The bullet's `Test gate` locator, `ci.yml:L28`, is unmoved at `2d7c4f9`; that `release.yml` runs the gate through its own `Test gate` step (`:L53-L54`) is stated once, in QC-64, as § 3.1's answer has it. Reasoning: `docs/trail/architecture/self_answer-81.md` § 3.2.

### 3.3 QC-70's dated reading of the statuses the tree holds names none of the five release scripts
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR QC-70, the sentence "At `ka-reader@3fa227e` the tree holds these: …"
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; the statuses are within QC-70's five, but its reading of where each occurs is out of date.
- **Where it shows:** `docs/nfdr.md:L2519-L2525`. At `ka-reader@2d7c4f9` each release script exits 2 on a wrong count — `checks/release-version.sh:L39`, `checks/release-pack.sh:L43`, `checks/release-sums.sh:L33`, `checks/release-absent.sh:L34`, `checks/release-shape.sh:L39` — and `checks/release-pack.sh` maps a signal to 1 with `trap 'exit 1' HUP INT TERM` (`:L68`).
- **If a document has to be written:** none — the reading is re-measured at the current tree.
- **Answer:** confirmed with addition — QC-70's dated reading is re-measured at `ka-reader@2d7c4f9`, and the `3fa227e` reading stays dated. It adds `exit 2` on a wrong count in the five release scripts — `checks/release-version.sh:L39`, `checks/release-pack.sh:L43`, `checks/release-sums.sh:L33`, `checks/release-absent.sh:L34` and `checks/release-shape.sh:L39` — and `checks/release-pack.sh`'s `trap 'exit 1' HUP INT TERM` (`:L68`), so the clause that lets a script map a signal to 1 names both scripts that do. Two locators the item does not name move with it: `run_step` sits at `checks/gate.sh:L40-L47` at `2d7c4f9` (`:L38-L45` at `3fa227e`); and `checks/tree-walk.sh` passes its child's status through, `exit "$scene_status"` (`:L128`), a pass-through already in the tree at `3fa227e` that the reading did not name, now named beside `checks/own-state-step.sh`. No other script under `checks/` changed between the two commits, so every other locator holds, and the literal scan still finds only 0, 1, 2, 130 and 143. No status outside QC-70's five is added. Reasoning: `docs/trail/architecture/self_answer-81.md` § 3.3.
