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
> settled NFDR against the product at `ka-reader@06e4a34`, where the tree gained `LICENSE`,
> `SECURITY.md`, `THIRD_PARTY_NOTICES.md`, `checks/notices.sh` and its suite
> `checks/tests/test_notices.sh`, and `checks/gate.sh` 1.12.0 runs both as fatal steps. Five items
> follow in § 3; neither record is edited.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-41 says the notices check runs at the release only; it now runs at every change, with a suite
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR QC-41, its *verified by:* tail, and its § 10 row
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; QC-41 reads false against the tree, and the release's later work cites it.
- **Where it shows:** `docs/nfdr.md:L1598-L1600` ends the *verified by:* "(the release)", and the § 10 row at `:L3286` reads `checks/notices.sh` | the release | release, with no suite. At `ka-reader@06e4a34`, `checks/gate.sh:L129` runs *Notices check* (`checks/notices.sh`) and `:L130` *Notices check suite* (`checks/tests/test_notices.sh`), both fatal, so the check runs at the change through the gate and at the release through the release workflow's gate step.
- **If a document has to be written:** none — QC-41's tail names the change as well as the release, and its row reads `checks/notices.sh` (suite `test_notices.sh`) | the tree | the change (the gate's *Notices check* step); the release.
- **Answer:** Confirmed, with the map's own words. QC-41's *verified by:* names the check and its suite and ends where both run: `checks/notices.sh` and its suite `checks/tests/test_notices.sh` (the tree), run by the gate's *Notices check* and *Notices check suite* steps (`checks/gate.sh:L129-L130` at `ka-reader@06e4a34`) at every change, and at a tag by the release workflow's *Test gate* step. The § 10 row reads `checks/notices.sh` (suite `test_notices.sh`) | the tree | CI build; release — the shape QC-49's row already has. *Runs over* stays `the tree` rather than `the change`, because the check reads the tree's `cargo tree` and its notices file, not a change's diff, and § 10's preamble already reads `CI build` as `development-implementation` too. Decided together with 3.4, which adds the bundle's half to the same tail and row. Reasoning: `docs/trail/architecture/self_answer-83.md` § 3.1.

### 3.2 § 9's harness-suites bullet counts twenty-two suites; the tree holds twenty-three
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR § 9, the bullet "The harness's own suites, `checks/tests/`, run as steps of `checks/gate.sh`"
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; the bullet's count is one short and names `gate.sh` at 1.11.0.
- **Where it shows:** `docs/nfdr.md:L2805-L2806` ("Twenty-two top-level shell suites are in the tree at `ka-reader@2d7c4f9`, each the whole command of one `run_step` line of `checks/gate.sh` (1.11.0)"). At `ka-reader@06e4a34`, `ls checks/tests/*.sh | wc -l` → `23`; the new one is `test_notices.sh`, the whole command of `checks/gate.sh:L130`, and `checks/gate.sh:L2` reads `# Version: 1.12.0`.
- **If a document has to be written:** none — the bullet is re-measured at the current tree.
- **Answer:** Confirmed, with the measurement and one more sentence it moves. § 9's bullet reads: twenty-three top-level shell suites are in the tree at `ka-reader@06e4a34fca726badd0893dbb1cab08efc52a54ef`, each the whole command of one `run_step` line of `checks/gate.sh` (1.12.0): `test_secret_scan.sh` (`checks/gate.sh:L61`), `test_secret_scan_planted.sh` (`:L79`), `test_structure.sh` (`:L92`), `test_entry_points.sh` (`:L94`), `test_bundle.sh` (`:L97`), `test_view.sh` (`:L99`), `test_renderer.sh` (`:L109`), `test_read_only.sh` (`:L120`), `test_no_network.sh` (`:L122`), `test_notices.sh` (`:L130`), `test_offline_page.sh` (`:L132`), `test_strings.sh` (`:L138`), `test_strings_step.sh` (`:L139`), `test_release_shape.sh` (`:L146`), `test_release_version.sh` (`:L147`), `test_release_pack.sh` (`:L148`), `test_release_sums.sh` (`:L149`), `test_release_absent.sh` (`:L150`), `test_own_state.sh` (`:L151`), `test_vm_refusal.sh` (`:L157`), `test_launch.sh` (`:L158`), `test_own_state_step.sh` (`:L159`) and `test_tree_scene.sh` (`:L160`). Every locator moved, not only the count, so all are re-pinned; the twenty-two at `2d7c4f9` stay as a dated reading, as v87 kept the seventeen. The same bullet's pairing sentence (`docs/nfdr.md:L2868`) reads "Three of the twenty-three", and names `test_notices.sh` as pairing by name with `checks/notices.sh`. Reasoning: `docs/trail/architecture/self_answer-83.md` § 3.2.

### 3.3 QC-70's dated reading of the statuses the tree holds names none of `checks/notices.sh`'s
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR QC-70, the sentence "At `ka-reader@2d7c4f9` the tree holds the `3fa227e` reading below … and adds: …"
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; the statuses are within QC-70's five, but its reading of where each occurs is out of date.
- **Where it shows:** `docs/nfdr.md:L2588-L2596`. At `ka-reader@06e4a34`, `checks/notices.sh` exits 2 on a wrong count (`:L48`) and traps `trap 'exit 130' INT` and `trap 'exit 143' TERM` (`:L39-L40`).
- **If a document has to be written:** none — the reading is re-measured at the current tree.
- **Answer:** Confirmed, with two more moves the same measurement owes. QC-70's dated reading is re-measured at `ka-reader@06e4a34`: the tree holds the `2d7c4f9` reading, every one of its script locators unmoved, and adds `checks/notices.sh`'s `exit 2` on a wrong count (`:L48`) and its `trap 'exit 130' INT` and `trap 'exit 143' TERM` (`:L39-L40`); the script's own header says a signal landing inside a command substitution may end it with 1 (`:L18-L19`), which is inside QC-70's five and never 0, and its suite holds that (`test_a_signal_never_ends_with_zero`, `checks/tests/test_notices.sh:L283`). The literal scan over `checks/*.sh` still finds only 0, 1, 2, 130 and 143. Two more: `run_step` moved to `checks/gate.sh:L42-L49` at `06e4a34` (`:L40-L47` at `2d7c4f9` becomes its dated reading); and the *verified by:* list of suites that assert the 2 gains `checks/tests/test_notices.sh` — `test_wrong_argument_count_is_a_usage_error` (`:L264`). Reasoning: `docs/trail/architecture/self_answer-83.md` § 3.3.

### 3.4 QC-41's "every release carries `LICENSE` … and a `THIRD_PARTY_NOTICES.md`" does not say whether the disk image carries them
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR QC-41, its statement (traces to SRS C-5)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** the release's packing and its check: whether `KA-Reader-<version>.dmg` must hold the two files decides whether `ka-reader-mac/assemble.sh` and `checks/bundle.sh` change before the first tag.
- **Where it shows:** `docs/nfdr.md:L1596-L1597`. At `ka-reader@06e4a34` both files are at the repository root, so the release's source at its tag carries them; the bundle carries only the icon set's licence, `cp "$GLYPH_LICENSE" "$APP/Contents/Resources/LICENSE"` (`ka-reader-mac/assemble.sh:L111`), and no copy of the product's `LICENSE` or of `THIRD_PARTY_NOTICES.md`.
- **If a document has to be written:** none — QC-41 states which artifact "carries" means: the tagged source alone, or the disk image as well.
- **Answer:** The disk image as well as the tagged source. QC-41 states: every release carries `LICENSE` and `THIRD_PARTY_NOTICES.md` in two places — at the root of the tagged source, and inside `KA-Reader.app` in the release's `KA-Reader-<version>.dmg`, each byte-identical to the tree's at that tag. Inside the bundle, not beside it on the volume, because a copy of the app dragged off the image keeps them, and because `checks/release-pack.sh` holds the volume to one item. The grounds are the licences' own terms, which bind the binary a stranger downloads and not only the source: MIT asks for its notices in "all copies or substantial portions of the Software"; Apache-2.0 § 4(a) asks that "any other recipients" get a copy of the licence, in Source or Object form; and the LGPL-2.1 text the notices file carries for LibXDiff (§ 6) asks for notice "with each copy of the work". The owner's own record already says it — "whatever ka-reader ships as … the release has to carry their notices" (`docs/trail/prd/cycle-1.md` § 2.5). *Verified by:* `checks/bundle.sh` (suite `test_bundle.sh`) failing when the built bundle lacks either file or holds one that differs from the tree's — the tree, CI build; release, and on the downloaded bundle at release inspection. Until `bundle.sh` holds that rule, `development-design` reading QC-41 is its gate. Two bounds for the change that builds it: the product's `LICENSE` cannot take `Contents/Resources/LICENSE`, which is the icon set's licence (`ka-reader-mac/assemble.sh:L111`), so it needs a name of its own inside the bundle, and that name is the delivery tier's to choose; and both files are copied in before `codesign` (`assemble.sh` step 5), or the seal breaks. Decided together with 3.1, whose tail and row this extends. Reasoning: `docs/trail/architecture/self_answer-83.md` § 3.4.

### 3.5 QC-41's notices list each crate "with its licence"; the licences' own terms also ask for each component's copyright line
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR QC-41, its statement (traces to SRS C-4, C-5)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked today; how far the notices meet the MIT and Apache-2.0 attribution terms is a call no product record makes, and `checks/notices.sh` checks names only.
- **Where it shows:** `docs/nfdr.md:L1596-L1597`. At `ka-reader@06e4a34`, `THIRD_PARTY_NOTICES.md` gives each crate's licence expression and each licence's text once, and no crate's own copyright line. Of the 52 registry packages `cargo metadata --locked --offline` resolves, 35 carry a `Copyright` line in their licence file (aho-corasick, bitflags, cc, cfg-if, equivalent, errno, … ). None ships a `NOTICE` file.
- **If a document has to be written:** none — QC-41 states whether a notice entry carries the component's copyright line as well as its licence. This is a judgement on the licences' terms, and the owner may answer it.
- **Answer:** Yes — each entry carries its component's copyright line as well as its licence. QC-41 states: for every component the bundle ships, the notices carry its licence and every copyright line its own licence file states, at the version `Cargo.lock` resolves, plus the whole of any `NOTICE` file it ships (Apache-2.0 § 4(d); none at `ka-reader@06e4a34`). A component whose package holds no licence file, or one with no copyright line, is named as such in its entry rather than passed silently. The grounds are the licences' text: MIT's condition is that "the above copyright notice and this permission notice" are included, so the licence text once, with no line above it, meets half of it, and MIT-only crates the bundle ships carry such lines (`pulldown-cmark` 0.13.6, "Copyright 2015 Google Inc."; `tree-sitter` 0.27.0, "Copyright (c) 2018 Max Brunsfeld"). The libraries the crates compile already carry theirs in the notices (`THIRD_PARTY_NOTICES.md:L1281-L1300`, `:L1354`), so the crate entries are the inconsistent half. One rule for every component, not an election per dual-licensed crate: Apache-2.0 alone would not ask for the line in Object form, but the notices name each licence as the crate declares it and elect nothing, and an election per crate would be a second record that drifts with every lockfile change. *Verified by:* `checks/notices.sh` extended to read each resolved package's licence file and fail on a copyright line the notices lack — the tree; CI build; release. Building that is the delivery tier's; until it lands, `development-design` reading QC-41 is the gate, and release inspection reads the lines before the first tag. A crate update that changes its line fails the same check. Reasoning: `docs/trail/architecture/self_answer-83.md` § 3.5.
