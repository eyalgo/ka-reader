# Architecture open issues — KA-Reader

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the FDR, the
> PRD, the project's finish line and the documents the project card's `Source material:` line names,
> and the SRS and the SDD where the product has them. A decision none of those inputs states, which
> the run wrote into the decisions document, `architecture_decisions.md`, is still a choice to confirm
> here.
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

### 3.1 NFDR § 9's suites bullet, pinned at `3463d17` with thirty-two suites, reads one short
- **Raised by:** PM — 2026-11-24
- **Which record:** `docs/nfdr.md` § 9, the bullet *The harness's own suites, `checks/tests/`, run as steps of `checks/gate.sh`*
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; the bullet's count and its locators describe a tree the main line has left.
- **Where it shows:** `git ls-tree --name-only 3463d17 checks/tests/ | grep -c '\.sh$'` → 32; at `ka-reader@35d5e02` `ls checks/tests/*.sh | wc -l` → 33. The new suite is `checks/tests/test_readme_badge.sh`, run as the fatal step *README badge check suite* (`checks/gate.sh:L210`), after its check *README badge check* (`:L209`). `git diff -U0 66f28cb 35d5e02 -- checks/gate.sh` → two lines added after old `:L1` and seven after old `:L201`, so the bullet's `gate.sh` locators move with them.
- **If a document has to be written:** none; § 9's suites bullet is re-measured and re-pinned.
- **Answer:** Confirmed with an addition: re-measure § 9's suites bullet at `ka-reader@35d5e02` and keep the thirty-two at `3463d17` as a dated reading, as the v100 and v102 folds did. The item's facts hold, but its locator shift is taken from `66f28cb`, not from the bullet's own pin. From `3463d17`, `git diff -U0 3463d17 35d5e02 -- checks/gate.sh` gives three hunks. The first adds three version lines after `:L1` (1.25.0–1.27.0), so the header reads `checks/gate.sh` 1.27.0 where the bullet says 1.24.0. The second turns old `:L197`, a comment line, into three lines: the comment, one line longer, and the *README picture check* step (`checks/readme-picture.sh`, `:L202`). The third adds seven lines after old `:L198`. So old `:L2`–`:L196` read three higher, old `:L198` five higher and every line from old `:L199` twelve higher. Measured by exact whole-command `run_step` match at `35d5e02`, the thirty-three suites are: `test_secret_scan.sh` `:L81`, `test_secret_scan_planted.sh` `:L99`, `test_git_view_memory.sh` `:L110`, `test_structure.sh` `:L119`, `test_entry_points.sh` `:L121`, `test_app_icon.sh` `:L129`, `test_assemble.sh` `:L133`, `test_bundle.sh` `:L136`, `test_view.sh` `:L138`, `test_renderer.sh` `:L148`, `test_read_only.sh` `:L159`, `test_no_network.sh` `:L161`, `test_notices.sh` `:L169`, `test_offline_page.sh` `:L171`, `test_strings.sh` `:L177`, `test_strings_step.sh` `:L178`, `test_readme.sh` `:L182`, `test_git_beta.sh` `:L184`, `test_release_shape.sh` `:L191`, `test_release_version.sh` `:L192`, `test_release_pack.sh` `:L193`, `test_release_sums.sh` `:L194`, `test_release_absent.sh` `:L195`, `test_readme_picture.sh` `:L203`, `test_readme_badge.sh` `:L210`, `test_own_state.sh` `:L211`, `test_vm_refusal.sh` `:L219`, `test_launch.sh` `:L220`, `test_own_state_step.sh` `:L221`, `test_tree_scene.sh` `:L222`, `test_git_beta_scene.sh` `:L223`, `test_git_beta_walk.sh` `:L224` and `test_readme_capture.sh` `:L225`. The bullet also has to move in three more places. "Four of the thirty-two" becomes "Four of the thirty-three". It is the same four, because `test_readme_badge.sh` pairs by name with `checks/readme-badge.sh`, and that pairing joins the bullet's list of pairings. "All thirty-two" becomes "all thirty-three". The `test_assemble.sh` comment locator `checks/gate.sh:L127` at `3463d17` reads `:L131` at `35d5e02`. "Unchanged at `ka-reader@9c2ed61`" becomes the fold's own check that the tree outside `docs/` has not moved since `35d5e02`. It had not moved at `bffd5fe`. If the tree has moved by the time of the fold, the fold measures the tree it reads, and these figures are only a reading. No obligation changes and no record is owed. Reasoning: `docs/trail/architecture/self_answer-99.md` § 3.1 (stand-in answer, not the owner's)

**How it closes.** `product-architecture` folds it on its next run like any other item here.
