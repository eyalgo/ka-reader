# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (NFDR v80, Settled; ADR-0001 – ADR-0024, ADR-0015 Accepted)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-07
- **Sources re-read:** None. No answer rests on a source outside this repository. The answers rest on the product at `ka-reader@71f9f69`, re-read for this run. That covers `crates/ka-reader-core/src/markdown_renderer.rs`, `src/fs_reader/fakes.rs`, `tests/containment.rs`, `src/folder_model.rs`, `checks/structure.sh` v1.7.1 and `checks/gate.sh`. The scan and its suite were run in a disposable clone. The answers also rest on this organisation's own doctrine, as the run's pinned store holds it: `doctrine/engineering/languages/README.md` § *A fix that hands a collaborator in is not a topology decision*, `languages/rust/conventions.md` and `testing.md`, and `testing_doctrine.md`.
- **Liveness check:** the header's pointer reads *Companion to `adr/` and `nfdr.md`*, two bare names. Both sit beside the companion in `docs/`, so it is live.
- **What was read:** the whole companion and ADR-0015 whole. Also the ADR index, and ADR-0024's head for the precedent of a correcting supersession. From NFDR v80: the header and version lines, QC-9's tail, QC-10, QC-11, QC-50 and QC-63, § 9's test table, and every trace that names ADR-0015 or ADR-0007. From SDD v72 (Settled): the version line, § 2 *The four-layer default, declined by name* (`:L339-L366`), § 3's `fs-reader`, `markdown-renderer` and `highlighter` rows, and SM-7. From the product: everything listed under *Sources re-read*, at `71f9f69`. Only `docs/` has changed since then (`7f0456a`). As input only, and cited in neither record: the merged change's design and code-integrity report, which weighed item 3.4's two readings and named the call as this seat's.
- **Scope:** four items, all in § 3, each with an **Answer** slot. No item list was given, so all four were this run's. Each is the Principal Architect's: the edits land in `docs/adr/` or `docs/nfdr.md`, and they bind only how faithfully the records describe the product and its settled design. None binds a person or an outside party. Items 3.3 and 3.4 each ask a record to say something it does not say yet. Each cites an occurrence on disk, so § *A widening item waits until it occurs* does not hold them back.

## Items worked

### 3.1 — ADR-0015's *Decision* says every block holds inline nodes and names fenced code alone

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** A superseding record, ADR-0025, is owed. It restates ADR-0015's decision whole, with the node set as built.

  **Check 1.** The edit lands in the decision log, which is this seat's. It describes a type the product already has, so it commits nothing to anyone.

  **Check 2: the item is right, and its stake is larger than it says.** At `71f9f69`, `Block` is `Heading { level, content: Vec<Inline> }`, `Paragraph(Vec<Inline>)`, `List { kind, items: Vec<Vec<Block>> }`, `Quote(Vec<Block>)`, `Rule`, and `Code { language, code, spans }`. The doc comment says the code block is fenced or indented, and plain with no spans in no floor language (`crates/ka-reader-core/src/markdown_renderer.rs:L35-L57`). ADR-0015 says every block holds inline nodes and names "fenced code" alone. Both are false of the type. The item says "nothing is blocked". That is true today, but the enumeration is not description. It *is* the closed set behind the record's second wall, "the document is data". The record's *Consequences* also make "a node outside the closed set" a red test. So a later change that read ADR-0015 as its fixed reference would treat indented code as outside the set.

  **Check 3: the append-only rule decides the form.** `product-architecture` never rewrites an Accepted record. A change lands as a new record, and only the old record's Status line moves. The log has done this once before, for a correction rather than a reversal: ADR-0024 superseded ADR-0007 to correct a repository address, and restated the rest of the decision unchanged. The NFDR then re-pointed its traces as "ADR-0024, which superseded ADR-0007 at v55" (`docs/nfdr.md:L1215`, `:L1229`, `:L2134`). ADR-0025 follows the same pattern. It takes the shape from SDD v72 § 3, settled this morning on the same measurement (RN-145, `docs/trail/sdd/cycle-66.md` § 5.1). So the record and its source agree again, and the record does not get ahead of the SDD. The inline set, the image and link forms, the three walls, the four-format and SVG decisions, the alternatives, and the paragraph on what the decision rests on carry over unchanged. Its Binds stay QC-6, QC-11, QC-22, QC-31 and QC-37.

  **Check 4.** *Empty:* an empty list or quote holds no blocks (SDD v72), and the record says so. *Nested:* nesting adds no kind. *Stale:* the record pins its shape at `71f9f69` and SDD v72. A later kind, a table or a task list, changes the closed set, so ADR-0025 says that adding one takes its own record. Otherwise the next addition reopens the same gap.

  **Close call:** I weighed answering "no record". On that reading the SDD owns the shape and ADR-0015's list is a stale illustration. What tipped me against it is that the list is the wall's own definition, and a delivery stage reads the record and not the SDD's entity.

### 3.2 — QC-11's *verified by* tail says `markdown-renderer` has no file yet

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** The tail should now say `markdown-renderer` is measured on its code, pinned at `ka-reader@71f9f69`. I measured that rather than taking the item's word for it.

  **Check 2: measured.** In a disposable clone at `71f9f69`, `checks/structure.sh` exits 0, printing "26 Rust files in 2 crates read — nothing found". `checks/tests/test_structure.sh` exits 0 with 120 `ok` lines. The scan's version 1.7.1 header says "watcher and markdown_renderer have files, and each is judged on them" (`:L126-L127`). Its unit list includes `markdown_renderer` (`:L410`, `:L1531`). The forbidden set for that subject is `folder_model`, `own_state`, `git_reader` and `watcher` (`:L567`). Header text alone is not proof, so I planted `use crate::folder_model::FolderModel;` in `src/markdown_renderer/fold.rs`. The script then exits 1 with "QC-11: markdown_renderer imports folder_model". The clone was removed afterwards.

  **Check 3.** The fold follows the tail's own pattern for `watcher`: the old sentence stays as a dated reading, true until this commit. Part (3) of the bound held by review is *not* closed by this change. The scan still judges an import a whole unit at a time, so it cannot tell whether the renderer's import of `fs-reader` reaches the containment check alone. Its *WHAT IS NOT HELD* lines have moved to `checks/structure.sh:L354-L357` at `71f9f69`, and the fold may pin them there beside `82a3fb1`'s `:L331-L334`.

  **Check 4, stale.** A renderer file added later is judged without editing the scan ("no edit here for a file added later", `:L127`). So the new pin stays true as files are added.

### 3.3 — § 9's layer-2 row names neither `--test containment` nor the containment port's contract suite

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** Name it in both cells. *Scope* gains the containment port's contract suite against `FolderContainment` and the port's one fake, `SeededContainment`. *Tool* gains `--test containment`.

  **Check 2: the item is right, and the cell is narrower than it implies.** `crates/ka-reader-core/tests/containment.rs` runs one generic suite through `test_real_containment_meets_the_contract` and `test_seeded_containment_meets_the_contract` (`:L90-L99` at `71f9f69`). It runs at layer 2 under `testing_doctrine.md` § *A fake is verified against its port's contract*, where both runs are layer 2. The gate already runs it through `cargo test --workspace --locked` (`checks/gate.sh:L77` at that commit). So this corrects the map and changes nothing about what runs. The *Tool* cell is not a complete list. Seven other core targets are unnamed in it too: `list_tree`, `walk`, `read_file`, `tree_links`, `failure_log`, `failure_log_kinds` and `git_state_log`. The item asks only about the one port suite, so the answer names that one and does not widen the cell to the rest. Naming port suites matters because the row already names the Git port's by its own rule (QC-50).

  **Check 3.** The Git port's "owed" note stays. Its contract suite is still not on disk at `71f9f69`: no core test file defines one, and only the containment suite calls itself a contract suite. The SDD states no containment port at all. It names only SM-2's as reached by the verified-fake rule (`docs/SDD.md:L361-L363`). So this answer names the test that exists and goes no further. It writes no QC-50 counterpart, "the containment port has one fake and one contract suite", because that constraint would have no upstream statement to trace to. The gap is raised on the SDD instead (§ *Companions opened*). Once the SDD states the port, such an entry becomes a derived constraint rather than an invented one. Only then is it owed.

  **Check 4, stale.** The row's citations are pinned at `71f9f69`. If the suite gains cases, nothing in the row moves.

### 3.4 — QC-10 lets `folder-model` import `fs-reader`; it does not say whether that sets aside the packet's trait-collaborator line for the containment check

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** It sets the line aside, for the model's edge into `fs-reader` alone, and the code keeps its form. QC-10 should say so, cite its ground, and state its bounds.

  **Check 1: this seat's, and decided upstream already.** `<CORE>/doctrine/engineering/languages/README.md` § *A fix that hands a collaborator in is not a topology decision* says that "An Accepted ADR, the NFDR or the FDR that sets the packet line aside still wins". The SDD is not on that list, so this record has to say it if anything does. But the choice is not this seat's to invent, and it does not have to be. SDD § 2 *The four-layer default, declined by name* (`docs/SDD.md:L339-L363` at v72, RN-126, settled by the CTO) declines porting `fs-reader`. Its reasons: the filesystem under the grant is the product's subject, not a capability it stands off from. `folder-model`'s tests run against folders they make themselves, which `testing_doctrine.md` admits at layer 1. And porting it "would re-cut `docs/nfdr.md` QC-8–QC-11 … for a testability the product has". So recording that decision is fidelity, not design. No ground I cannot see is in play.

  **Check 2: one question, not two.** The item offers two readings of one question. Reading (b) would give `folder-model` its `fs-reader` collaborators through ports wired at `core-bridge`'s composition root. That is exactly the porting the SDD declined. The two readings do not split into separate questions with separate seats.

  **Check 3.** Reading (b) contradicts the settled SDD § 2. It would also change the public signatures of `select_file`, `read_file` and `FolderModel` and every caller, with no upstream decision behind it. Reading (a) contradicts nothing settled. It matches the merged change's own record of the same call: its code-integrity report took the same reading and named it this seat's to confirm. It also matches `testing_doctrine.md`'s no-real-resource rule, since a temporary folder the test makes is admitted at layer 1. What it sets aside is the Rust `conventions.md` bullet alone ("a unit that constructs its own collaborator" does not satisfy the rule), and the README lets the NFDR set that aside. One fact the SDD does not yet hold: the containment check now *has* a port, `ContainmentCheck`, which the renderer and the fold take, and SDD § 2 and § 3 do not state it. That is raised on the SDD, with this answer named as resting on the decline (`docs/SDD_open_issues.md` § 2.1).

  **Check 4, the bounds the answer needs.** (1) *Scope:* the setting-aside reaches `fs-reader` only — the reads `read`, `observe_file` and `reobserve_file`, and the building of `FolderContainment` at the five entry points (`crates/ka-reader-core/src/folder_model.rs:L181`, `:L229`, `:L991`, `:L1182`, `:L1252` at `71f9f69`, each read this run). The Git port still arrives through SM-2's trait. Any other collaborator the model would build is not covered, and the run that meets it fixes it. (2) *The fakes:* `reduce_open_file` and `markdown-renderer` keep taking the check through `ContainmentCheck`, so every layer-1 test of the fold or the renderer is handed `SeededContainment`. Without this bound the setting-aside could be read as covering the renderer too, and the renderer would lose its door. (3) *Stale:* if SDD § 2's decline paragraph moves, including on the SDD item just raised, the setting-aside loses its ground and is reopened on this companion. (4) *Enforcement:* review at `development-design`. A scan cannot tell a permitted construction of `FolderContainment` in `folder_model` from one somewhere else, so naming the verifier is the honest surface.

  **Close call:** I weighed leaving this to the owner as a structural call. What tipped it is that the CTO had already made the call in the settled SDD, so the only thing left was recording it.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

- **docs/SDD_open_issues.md** — **opened** — companion to `SDD.md`, landed in commit `0be2d13`. One item, § 2.1, seated `cto`: § 2 and § 3 do not state the containment port the core built at `71f9f69` (`ContainmentCheck`, `FolderContainment`, `SeededContainment` and `tests/containment.rs`). The decline paragraph's "reaches SM-2's Git port today" now has a second port to name. The lean is that the decline still holds for `folder-model`'s entry points, which is the ground item 3.4's answer rests on. The ground for opening it is that a fact in the SDD is now false. The SDD had no companion (removed at v72), so this was its only channel. The confirm-or-override slot is left at its placeholder.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
- **docs/SDD_open_issues.md** — `<CORE>/launchers/companion-self-answer/launcher.sh ka-reader SDD`
