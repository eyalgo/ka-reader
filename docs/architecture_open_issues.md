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
- **Answer:** <the owner fills this in>

### 3.2 QC-66, QC-65 and § 9 do not name the proofs and the helper that now exist
- **Raised by:** PM — 2026-11-05
- **Which record:** `nfdr.md` QC-66, QC-65, § 9 (layer-5 row)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** QC-66 is the tree-refresh obligation; as written it names a design read as its gate and says `watch.rs` constructs `ModelDelta` values directly, so the record cannot be checked against what runs.
- **Where it shows:** QC-66 (`docs/nfdr.md:L1570`). At `ka-reader@2529a42` its proofs are the thirty-second tree scene and cases in `--test watch`, the native bridge case in `--test exports`, the structure scan's watcher rows, and `checks/read-only.sh` over `checks/fixtures/tree-scene` plain and `--kill` (`checks/gate.sh:L106-L107`); the built-app scene is a walk a person performs with `checks/tree-scene.sh`, and no command asserts it. `checks/tree-scene.sh` launches the bundle and refuses off a VM (held in `checks/tests/test_vm_refusal.sh`), so it belongs in QC-65's list of steps that launch the bundle (`:L2126`) and in § 9's layer-5 tool list.
- **If a document has to be written:** none beyond `nfdr.md`, through `product-architecture`.
- **Answer:** <the owner fills this in>

### 3.3 QC-64's `checks/gate.sh` locators point at lines that moved
- **Raised by:** PM — 2026-11-05
- **Which record:** `nfdr.md` QC-64
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** a reader following a `checks/gate.sh:L<n>` locator not pinned to a commit lands on a different step.
- **Where it shows:** QC-64 (`docs/nfdr.md:L2065` onward). `checks/gate.sh` is at version 1.7.0 at `ka-reader@2529a42` (`checks/gate.sh:L3`), with the tree-scene read-only steps at `:L106-L107` and the tree-scene helper's suite after them; every unpinned locator after that insertion point is off. Re-pin at a named commit.
- **If a document has to be written:** none beyond `nfdr.md`, through `product-architecture`.
- **Answer:** <the owner fills this in>

### 3.4 QC-47 names `stopped` among the model's layer-2 sibling states; the model has no such state
- **Raised by:** PM — 2026-11-05
- **Which record:** `nfdr.md` QC-47
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** a layer-2 case cannot pin a `stopped` sibling the model never holds; the Swift case pins all four.
- **Where it shows:** QC-47 (`docs/nfdr.md:L1537`) lists `observed`, `pending`, `failed` or `stopped` at layer 2. At `ka-reader@2529a42` `ItemState` is `Pending`, `Observed`, `Failed` (`crates/ka-reader-core/src/fs_reader.rs:L129-L133`); only the shell sets `stopped`. The SDD's C-I1 states the same claim and is raised on its own companion; QC-47 follows whichever way C-I1 settles.
- **If a document has to be written:** none beyond `nfdr.md`, through `product-architecture`.
- **Answer:** <the owner fills this in>

### 3.5 QC-30's boundary set does not say whether a check script may read an environment bound
- **Raised by:** PM — 2026-11-05
- **Which record:** `nfdr.md` QC-30
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** each new check that takes a wait or a count from the environment is a fresh judgement call, and the spellings already differ.
- **Where it shows:** QC-30 (`docs/nfdr.md:L1187`) covers what the shipped process reads. `checks/read-only.sh:L409-L412` reads `READ_ONLY_MARKER_WAIT` (default 120, refused when not a whole number); `checks/bundle.sh` reads `BUNDLE_SH_LAUNCH_TICKS` and `checks/renderer.sh` `RENDERER_SH_OBSERVATIONS`, a different spelling. The question is whether QC-30 (or the harness's own obligation) states that a check script may take such a bound, and in which name form.
- **If a document has to be written:** none beyond `nfdr.md`, through `product-architecture`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
