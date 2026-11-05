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

### 3.1 QC-10, QC-11, QC-13 and QC-15 still carry their interim tails for the watcher
- **Raised by:** PM — 2026-11-05
- **Which record:** `nfdr.md` QC-10, QC-11, QC-13, QC-15
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** nothing fails; the four obligations describe a scan weaker than the one in the tree, so a reader cannot tell which edges are held.
- **Where it shows:** QC-10's tail (`docs/nfdr.md:L442`) says the scan's unit-edge row does not forbid the model-to-watcher edge; at `ka-reader@2529a42` `checks/structure.sh` forbids the model-to-watcher and core-to-bridge edges, with planted cases in its suite. QC-11 (`:L476`) says `watcher` and `markdown-renderer` have no file yet; the scan now judges the bridge's `watcher` files (`crates/ka-reader-bridge/src/watcher.rs`, `src/watcher/`), and only `markdown-renderer` has none. QC-13 says until the boundary is held the Apple row rejects the binding throughout the bridge; the row now exempts the watcher's files alone, with positive and planted cases. QC-15's watcher location follows QC-13's interim gate, which lapses with it.
- **If a document has to be written:** none beyond `nfdr.md`, through `product-architecture`.
- **Answer:** Yes — the four interim tails are now false and are corrected; this is a correction, not a widening. At `ka-reader@2529a42`, `checks/structure.sh` (version 1.7.0) holds the watcher placement: the bridge's `watcher` files (`crates/ka-reader-bridge/src/watcher.rs` and `src/watcher/`) alone stand outside QC-13's Apple row; a watcher file that names `ka_reader_core` or reaches a sibling bridge module is a QC-11 finding; a `folder_model` file that imports `watcher` or the bridge, and a core manifest that depends on the bridge, are QC-10 findings. Its suite (`checks/tests/test_structure.sh`, version 1.6.0) plants each: `test_watcher_native_binding_is_accepted_in_the_watcher_files`, `test_watcher_importing_core_or_a_sibling_bridge_module_is_rejected`, `test_folder_model_naming_watcher_or_bridge_is_rejected`, `test_core_manifest_depending_on_the_bridge_is_rejected`. Measured in a disposable clone at that commit: the scan exits 0 printing "20 Rust files in 2 crates read — nothing found", and the suite exits 0 with 120 `ok` lines. So: QC-10 drops its "until those clauses are checked" review gate; QC-11 says `watcher` has files in the bridge and is judged on them, and that only `markdown-renderer` has no file yet; QC-13 drops "until that boundary is held"; QC-15's watcher location reads the scan instead of QC-13's interim gate. The old sentences stay as dated history in the document's usual form, and § 10's rows for QC-10/QC-11, QC-13 and QC-15 stop naming an interim review. One part stays review, and the entries say so: what the watcher's native code *does* — that it never stats, canonicalizes or checks a reported path and reads no content (QC-15) — is in the scan's *WHAT IS NOT HELD* (`checks/structure.sh:L345-L348` at `ka-reader@2529a42`), and `development-design` reading QC-15 stays its gate. Reasoning: `docs/trail/architecture/self_answer-71.md` § 3.1.

### 3.2 QC-66, QC-65 and § 9 do not name the proofs and the helper that now exist
- **Raised by:** PM — 2026-11-05
- **Which record:** `nfdr.md` QC-66, QC-65, § 9 (layer-5 row)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** QC-66 is the tree-refresh obligation; as written it names a design read as its gate and says `watch.rs` constructs `ModelDelta` values directly, so the record cannot be checked against what runs.
- **Where it shows:** QC-66 (`docs/nfdr.md:L1570`). At `ka-reader@2529a42` its proofs are the thirty-second tree scene and cases in `--test watch`, the native bridge case in `--test exports`, the structure scan's watcher rows, and `checks/read-only.sh` over `checks/fixtures/tree-scene` plain and `--kill` (`checks/gate.sh:L106-L107`); the built-app scene is a walk a person performs with `checks/tree-scene.sh`, and no command asserts it. `checks/tree-scene.sh` launches the bundle and refuses off a VM (held in `checks/tests/test_vm_refusal.sh`), so it belongs in QC-65's list of steps that launch the bundle (`:L2126`) and in § 9's layer-5 tool list.
- **If a document has to be written:** none beyond `nfdr.md`, through `product-architecture`.
- **Answer:** Yes — QC-66 names the proofs that now run, QC-65 gains `checks/tree-scene.sh`, and § 9's layer-5 row gains the helper and the tree-scene read-only walks. **QC-66:** replace "These proofs are owed by `follow-the-tree`. Until they run, `development-design` reading this entry is the gate …" with the proofs at `ka-reader@2529a42`: the thirty-second scene and the fresh-read, preservation, removal/return and failure cases in `cargo test --locked -p ka-reader-core --test watch` (`crates/ka-reader-core/tests/watch.rs:L865` onward, driven through `TreeRequest::Invalidate`); the native route in `cargo test --locked -p ka-reader-bridge --test model_changed` (the real FSEvents watcher through the exported `ka_reader_open_folder`) and `--test watcher` (the FSEvents watcher against the watching contract) — not `--test exports`, which the item names but which holds the closed export set only, as QC-66 already says; the structure scan's watcher rows (item 3.1); and `checks/read-only.sh` over `checks/fixtures/tree-scene`, plain and `--kill` (`checks/gate.sh:L106-L107` at `ka-reader@2529a42`). The built-app scene — the tree following the disk with no refresh control, toast, flash or badge and a responsive window — is a walk a person performs with `checks/tree-scene.sh`; no command asserts it, QC-66 says so in those words, and that walk is the gate for those observations. The pinned sentence that `watch.rs` builds `ModelDelta` values at `7b170d7` stays as dated history. **QC-65:** add `checks/tree-scene.sh` to the set — it starts the bundle with `open -n -g` — with its refusal held by `test_off_a_vm_it_exits_non_zero_having_launched_nothing_and_copied_nothing` in `checks/tests/test_tree_scene.sh` and by `checks/tests/test_vm_refusal.sh` (`:L191-L204` at `ka-reader@2529a42`). The helper is not a gate step; its suite is (`checks/gate.sh:L127`), and that suite records `open` through a stand-in and launches nothing, so it is outside the set, like `checks/tests/test_own_state.sh`. **§ 9:** the layer-5 row names `checks/tree-scene.sh` with `checks/fixtures/tree-scene` as a manual walk beside AC-10's, and `checks/read-only.sh` over that fixture. Decided together with 3.4, which changes QC-66's failure sentence. Reasoning: `docs/trail/architecture/self_answer-71.md` § 3.2.

### 3.3 QC-64's `checks/gate.sh` locators point at lines that moved
- **Raised by:** PM — 2026-11-05
- **Which record:** `nfdr.md` QC-64
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** a reader following a `checks/gate.sh:L<n>` locator not pinned to a commit lands on a different step.
- **Where it shows:** QC-64 (`docs/nfdr.md:L2065` onward). `checks/gate.sh` is at version 1.7.0 at `ka-reader@2529a42` (`checks/gate.sh:L3`), with the tree-scene read-only steps at `:L106-L107` and the tree-scene helper's suite after them; every unpinned locator after that insertion point is off. Re-pin at a named commit.
- **If a document has to be written:** none beyond `nfdr.md`, through `product-architecture`.
- **Answer:** Yes — re-pin every unpinned `checks/gate.sh` locator in QC-64 at the commit the fold measures, keep each older pin as history, and name the step beside each line so a reader can still find it when lines move again. Two corrections to the item: the script is version 1.8.0 at `ka-reader@2529a42` (`checks/gate.sh:L2`; 1.7.0's line is `:L3`), and the drift is not only after the tree-scene insertion — QC-64's unpinned `:L51`, `:L61`, `:L63-L68`, `:L69`, `:L106-L109` and `:L110` are all off (at `2529a42`, *Secret scan suite* is `:L54`, *Secret scan* `:L64`, *Planted secret suite* `:L72`, *Strings check* `:L115`). Addition: QC-13 has the same defect — its unpinned `checks/gate.sh:L55-L56` for the linker's refusal now lands on the secret-scan comment — so the fold re-pins it in the same pass. The rule the fold applies is that no `checks/gate.sh:L<n>` locator in the document stands without a commit. Reasoning: `docs/trail/architecture/self_answer-71.md` § 3.3.

### 3.4 QC-47 names `stopped` among the model's layer-2 sibling states; the model has no such state
- **Raised by:** PM — 2026-11-05
- **Which record:** `nfdr.md` QC-47
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** a layer-2 case cannot pin a `stopped` sibling the model never holds; the Swift case pins all four.
- **Where it shows:** QC-47 (`docs/nfdr.md:L1537`) lists `observed`, `pending`, `failed` or `stopped` at layer 2. At `ka-reader@2529a42` `ItemState` is `Pending`, `Observed`, `Failed` (`crates/ka-reader-core/src/fs_reader.rs:L129-L133`); only the shell sets `stopped`. The SDD's C-I1 states the same claim and is raised on its own companion; QC-47 follows whichever way C-I1 settles.
- **If a document has to be written:** none beyond `nfdr.md`, through `product-architecture`.
- **Answer:** QC-47's layer-2 clause names three states, and the entry gains the failed-re-read clause it promised. The SDD settled C-I1 at v67 (`docs/SDD.md` § 4 C-I1, RN-126): the model holds `pending`, `observed` and `failed` (`ItemState`, `crates/ka-reader-core/src/fs_reader.rs:L129-L133` at `ka-reader@2529a42`), `stopped` is set only by `mac-shell` at SM-4's return, and the four-state sibling sentence stays true at a surface. So the `--test watch` clause reads "each sibling holds the state its own read gave it, `observed`, `pending` or `failed` (layer 2)", and the `swift test` clause (layer 4) keeps all four, `stopped` included. Addition: QC-47 says it "gains a clause when C-I1 states it" for the failed re-read of an expanded folder, and C-I1 now states it — the folder's listing item becomes `failed`; every listing under it is dropped and no row is drawn beneath it; the place under it is kept, inert; siblings hold their own states; the next successful read replaces the failure and re-reads each expanded folder under it. That form is held by `test_a_failed_expanded_folder_keeps_each_sibling_in_its_own_state` and `test_the_next_read_after_a_failure_lists_the_new_entry_and_rereads_nested_expanded_folders` (`crates/ka-reader-core/tests/watch.rs:L780`, `:L841`) and by `RootItemsViewModelChangesTests`. QC-47 gains that clause, traced to C-I1 at v67. QC-66's "the treatment of its existing children is settled by the implementing design under SDD C-I1" becomes a pointer to that stated form, and its Rust-scene sibling list drops to three states too. Decided together with 3.2. Reasoning: `docs/trail/architecture/self_answer-71.md` § 3.4.

### 3.5 QC-30's boundary set does not say whether a check script may read an environment bound
- **Raised by:** PM — 2026-11-05
- **Which record:** `nfdr.md` QC-30
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** each new check that takes a wait or a count from the environment is a fresh judgement call, and the spellings already differ.
- **Where it shows:** QC-30 (`docs/nfdr.md:L1187`) covers what the shipped process reads. `checks/read-only.sh:L409-L412` reads `READ_ONLY_MARKER_WAIT` (default 120, refused when not a whole number); `checks/bundle.sh` reads `BUNDLE_SH_LAUNCH_TICKS` and `checks/renderer.sh` `RENDERER_SH_OBSERVATIONS`, a different spelling. The question is whether QC-30 (or the harness's own obligation) states that a check script may take such a bound, and in which name form.
- **If a document has to be written:** none beyond `nfdr.md`, through `product-architecture`.
- **Answer:** Yes, state it — but not in QC-30, and bound what a check may take, not only how it is spelled. QC-30 stays the shipped process's boundary set: `checks/` never ships (QC-14), so a check script's environment read is not one of its members. The rule belongs with the gate, as a new entry under § 8 beside QC-64 and QC-65, in three parts. (1) A check script may read from the environment only a bound on a wait or a count. The bound has a default in the script, and the script refuses a value that is not a positive whole number before it launches or reads anything. (2) The name is the script's file name upper-cased, with `-` and `.` as `_`, then the bound: `BUNDLE_SH_LAUNCH_TICKS`, `RENDERER_SH_OBSERVATIONS`; `READ_ONLY_MARKER_WAIT` takes the form as `READ_ONLY_SH_MARKER_WAIT`. (3) Every step of `checks/gate.sh` runs at the scripts' defaults, whatever the host's environment holds, so a bound exists for the script's own suite and never shortens a gate run. Part (3) also covers a variable that replaces a reviewed input instead of bounding a wait: `ENTRY_POINTS_ALLOW_FILE` (`checks/entry-points.sh:L90`), which swaps the list QC-30 half (2) diffs against, and `BUNDLE_SH_GLYPH_DIR` (`checks/bundle.sh:L304`). A suite may set them; a gate run never reads them. Two sites miss (1) today: `BUNDLE_SH_LAUNCH_TICKS` is not checked as a whole number (`checks/bundle.sh:L105`), and `READ_ONLY_MARKER_WAIT` accepts `0` (`checks/read-only.sh:L409-L416`). Verified by a gate-suite case that sets each such variable to a sabotaging value and requires the gate's step to read the default, and by a scan of `checks/*.sh` for `${NAME:-` reads against the form. How the gate clears them is the delivery tier's. Reasoning: `docs/trail/architecture/self_answer-71.md` § 3.5.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
