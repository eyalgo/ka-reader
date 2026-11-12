# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-12
- **Sources re-read:** None. Both answers rest on the product's own tree at `ka-reader@03bb989`
  (the `main` this run read, at `c67b423`, with nothing under `checks/` changed since), on
  `docs/nfdr.md` v97, `docs/SDD.md` v88 and ADR-0020, all in this repository.
- **What was read, and what was not.** The NFDR is 9,747 lines. This run read its header and § 1's
  opening, § 1.2 whole, § 9's opening, layer table and suites bullet, the § 10 row for QC-14, and
  RN-36 (the last fold that moved QC-14). It did not read the rest of the NFDR whole; both items are
  confined to QC-14 and § 9, and a `grep` over the whole file for `idle-shell`, `sandbox_probe`,
  `checks/walk.rs`, `ImageIO`, `app-icon` and `QC-14` found no other passage either answer touches.

## Items worked

### 3.1 — QC-14 does not admit the platform frameworks the icon probe imports

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item is right, and the change belongs in QC-14, so it is this seat's to answer. It
  binds nothing beyond this record. § 1.2 opens by saying "may import" is the whole allowed set
  (`docs/nfdr.md:L418`). QC-14 allows `checks/` only `ka-reader-core` (`:L732`), and
  `checks/icon_probe/main.swift:L1-L3` imports CoreGraphics, Foundation and ImageIO. The item cites
  that file, so it is an occurrence and not a widening asked in the abstract. The SDD at v88 records
  the same imports and leaves this question to this seat (`docs/SDD.md:L546`).

  **The addition.** The item's list names the two Swift programs. It leaves out a third program of
  the same kind, which has stood outside QC-14's words since it landed. `checks/sandbox_probe.rs`
  declares the system library's `dlsym` and `kill` (`:L54-L57`), and `checks/bundle.sh` compiles it
  with `rustc` into its own work folder (`:L433-L434`). The SDD itself calls the icon probe "a
  compiled probe source like `sandbox_probe.rs`". With only the item's list, QC-14 would still fall
  short of the tree by one file. So the clause names the class, which is a program a check compiles
  into a temporary folder of its own at run time and which may use the platform's own frameworks and
  system library. It then names all three programs as they stand. The idle-shell control is
  compiled with `-framework AppKit` into `renderer.sh`'s `mktemp` folder
  (`checks/renderer.sh:L181`, `:L331`), and the icon probe goes into `app-icon.sh`'s folder
  (`checks/app-icon.sh:L107`, `:L120-L122`). The Rust standard library is not added. § 1.2 treats it
  as given throughout, and QC-9 forbids only `std::process` by name, so naming it for `checks/` alone
  would suggest that the other units' entries forbid it.

  **Check 3, against the records.** ADR-0020 is the accepted unit set, and it says "`checks/` may
  import `ka-reader-core`" (`docs/adr/0020-…:L55`), so its wording looks like the same closed set.
  It is not. That sentence is about edges between the four physical units, and a platform framework
  is not one of them. ADR-0016 already listed the `idle-shell` control in `checks/`
  (`docs/adr/0016-…:L30`), and ADR-0020 kept the same sentence after it, so the sentence was always
  read with an AppKit program beside it. No record is superseded, and no new record earns a place:
  this is not hard to reverse and it involves no real trade-off. QC-14's trace gains ADR-0020 read
  this way, plus this answer. QC-8's "AppKit and Foundation — the platform's own" for `ka-reader-mac`
  is the precedent for the wording.

  **Check 4, the failure paths.** (a) A later probe that imports something that is not the
  platform's own, such as a Swift package or a crate, is still outside QC-14 and a violation. (b) No
  check reads what these programs import. `checks/structure.sh` scans shipped sources, and
  `checks/view.sh` scans `ka-reader-mac/Sources`. So the clause's gate is `development-design`
  reading the entry, and the entry's tail has to say so rather than imply that a command holds it.
  (c) A program compiled into the tree rather than a temporary folder falls outside the clause by its
  own words, and it would already be the harness defect the cross-role contract names. (d) "Never
  ships" stays held by `checks/bundle.sh`'s existing rule that nothing of `checks/` is under
  `Contents/`.

  I came close to *confirmed*, taking the item as it stood. What tipped it was the SDD's own
  sentence pairing the icon probe with `sandbox_probe.rs`: an answer that fixed one probe and left
  its named twin out would fold into a QC-14 that was still short of the tree.

### 3.2 — § 9 names neither the application icon nor its check, and counts twenty-seven suites where the tree holds twenty-nine

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** Both facts are measured as the item states them, and the change is in § 9, so it is this
  seat's. Row 5 (`docs/nfdr.md:L3015`) names no icon check. At `ka-reader@03bb989`,
  `git ls-tree --name-only main checks/tests/ | grep -c '/test_.*\.sh$'` prints `29`.
  `checks/gate.sh` is at 1.20.0 (`:L2`), with `test_app_icon.sh` at `:L115` and `test_assemble.sh`
  at `:L119`. The item's *what* clause is the gate's own comment word for word (`checks/gate.sh:L108-L110`).
  It is a correction (a count now false, a check the row omits), not a widening, and it cites its
  occurrence.

  **Two additions.** (1) The *by* cell names the control beside the check:
  `checks/app-icon.sh` with `checks/fixtures/stand-in-icon.icns`. The row already writes
  `checks/renderer.sh` with `checks/fixtures/idle-shell`, and the gate says of this check that "a
  run without the control has not run the check" (`checks/gate.sh:L110-L111`). A row that named the
  check alone would read as if the control were optional. (2) The suites bullet enumerates a line
  locator for every suite (`docs/nfdr.md:L3130-L3139`), and those locators move as well as the
  count. This run re-measured every `run_step` line at `03bb989`. The four at or above old `:L104`
  read three higher: `test_secret_scan.sh` `:L74`, `test_secret_scan_planted.sh` `:L92`,
  `test_structure.sh` `:L105` and `test_entry_points.sh` `:L107`. Every one from old `:L107` down
  reads fifteen higher, `test_bundle.sh` `:L122` through `test_git_beta_walk.sh` `:L194`. The SDD
  measured the same shift (`docs/SDD.md:L546`). An answer that moved only the count would leave
  twenty-five locators false under a new pin. Following the bullet's own convention, the twenty-seven
  at `528c152` stay as a dated reading.

  **Check 3.** No `QC` binds the application icon. The NFDR's only mention of it is a review note
  saying no entry here covers it (`docs/nfdr.md:L5585-L5587`). The icon's rule is DESIGN's, held by the SDD's harness row. So
  § 10 gains no row, and this answer writes no new obligation: a quality floor this seat did not
  derive from an upstream requirement would be invented here. The row naming the check is the layer
  realization the item asks for, and nothing more. **Check 4.** The count is a dated reading under
  the bullet's own rule: a suite landing after `03bb989` is a re-measurement, not a contradiction.
  `test_assemble.sh` tests a script outside `checks/` (`ka-reader-mac/assemble.sh`), and it is still
  "the whole command of one `run_step` line", so it fits the bullet's definition of a counted suite
  without changing that definition.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
