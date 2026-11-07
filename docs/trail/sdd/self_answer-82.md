# Self-answer report — SDD

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v73, Settled; the companion was opened by the PM on 2026-11-07 at `ka-reader@2ec392d`, reading the settled SDD against the product at `ka-reader@98aaa71`, with five items under § 5 *Raised from downstream*, all seated `cto`; the invocation listed no items, so all five were this run's)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-07
- **Sources re-read:** None — no answer rests on a source outside this repository. Every code claim was measured in the tree at `ka-reader@98aaa71`, the merge the items name, and checked unchanged to `main` at `abb6ad6` (`git diff --stat 98aaa71 HEAD -- crates checks .github` prints nothing): `crates/ka-reader-core/src/folder_model.rs` (`asset_bytes` `:L278-L288`, `link_file` `:L305-L307`, `contained_file` `:L251`, the `is_bitmap` import `:L18` and call `:L284`, `read_contained_bytes` `:L287`, the five `FolderContainment::new` sites `:L182`, `:L230`, `:L1057`, `:L1248`, `:L1318`, and every `fs_reader::` call), `src/lib.rs:L15`, `src/fs_reader.rs` (`OpeningFilesystem` `:L55-L59`, `Filesystem` `:L238-L246`, `ContainmentCheck` `:L446`, the `cfg` gate `:L16-L17`, `read_bytes` `:L680`, `read_contained_bytes` `:L704`), `crates/ka-reader-bridge/src/session.rs` (`asset_bytes` `:L1112-L1116`, `open_relative_link` `:L1136`, `read_and_fold` `:L1211`, `link_to` `:L1243`, the two `FolderContainment::new` sites `:L1114`, `:L1253`), `src/exports.rs` (`ka_reader_asset_bytes` `:L184`, `ka_reader_open_relative_link` `:L219`), `tests/exports.rs:L23-L34`, `crates/ka-reader-core/tests/markdown.rs:L403`; `git grep -c '0o000' -- crates` at the pin, 37 lines in 13 files. The SDD was read at its header, § 2 *The four-layer default, declined by name* (`:L339-L380`), § 3's units paragraph (`:L459-L470`), the `fs-reader`, `core-bridge` and `SM-1`, `SM-2`, `SM-4`, `SM-5`, `SM-7` rows, § 4 C-R7 and every line naming `asset_bytes` or `open_relative_link`. `docs/nfdr.md` was read at its header and QC-10 whole (`:L431-L458`); `docs/architecture_open_issues.md` § 3.1 as the PM's parallel item on QC-10; `docs/trail/sdd/self_answer-81.md` as the record of the previous round's reasoning on the same paragraph; the SRS was searched for failed and unreadable reads (FR-3, FR-10, NFR-3, NFR-10), none of which fixes how a test forces one. As input only, cited in no answer: the seeds `ka-reader · nemawashi · 2026-11-06_failed-reads-go-through-a-seam` (unpicked) and `2026-10-02_markdown-reads-rendered`, and the open station `2026-11-06_a-markdown-file-reads-rendered`. Doctrine in the run's pinned store: `testing_doctrine.md` §§ *A unit test hands its unit fakes and touches nothing real*, *A fake is verified against its port's contract*, *A test reads nothing of the machine it runs on*; `languages/rust/conventions.md` § *A unit is given its collaborators through a trait*; `languages/README.md` § *A fix that hands a collaborator in is not a topology decision*; `<CORE>/../skills/pm/.claude/skills/shukuba-refine/prompts/rich.md` § *A gap is carried only where it occurs*, for the term **Occurrence**.

## Items worked

### 5.1 — `SM-5`'s *Down* cell says three functions stand beside the request types; five do at `ka-reader@98aaa71`

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Answered: the cell is re-stated at `98aaa71` with five functions, the two new ones described as the three before them are, and the bridge's link named as a fourth fixed order.

  **Check 1 — mine, in the CTO's seat.** The edit lands in § 3's SM-5 row, the CTO's architecture column. It binds only the document's agreement with the code; no person, outside party or risk turns on it, and I can name no ground I cannot see.

  **Check 2 — one question, no draft, the facts hold.** This item widens the cell (it asks it to state two functions it does not state) and it cites its occurrence as the term is defined — a path and line where the form is present (`folder_model.rs:L278`, `:L305`; `session.rs:L1243`, `:L1211`), each of which I opened and found. So it is answered, not "not until it occurs". The item's description of the link's order matched the code: `link_to` builds the check and asks `link_file` under one lock hold, admits the selection act for a file in that same hold, and the open's read-and-fold runs from the snapshot taken there — the code's own comment says the point of the order is that a later select act is admitted after the link. Two facts the item did not name and the cell needs for a cold read, added: both functions are public (`lib.rs:L15`), so § 4 C-I3's in-process route holds without a sentence of its own; and `asset_bytes` reads outside the lock, with the folder cloned under it, which is the same shape as the open's read.

  **Check 3 — nothing settled moves.** SM-4's `open_relative_link` and `asset_bytes` entries say each is exported from the build that first builds it, and now one does. The `surfaces` row's rule — the model's selection is the reader's last selection act, in the order the acts arrive — is what the link's lock hold serves, so the rule gains a case and loses nothing. § 4's "a relative link … passes `fs-reader`'s containment check before any open" (`docs/SDD.md:L1295`) is what `link_file` does. SRS FR-32 lets a relative link open its target; it says nothing about order. No earlier answer in this companion exists to read against; item 5.2 is decided after this one and reads it.

  **Check 4.** *Empty:* no folder open → `None` for the bytes, `pending` for the link — said. *Absent:* a file gone between the check and the read → `read_contained_bytes` answers `None` and logs no path; for the link, `read_file` answers the condition as any open does — the first said, the second is the open's already. *Stale:* every locator is pinned at `98aaa71`, and `crates/` is unchanged to `main`. *Concurrent:* the link's whole point — the selection is admitted in the arrival order under the lock, and the read runs outside it — said. *Refused:* a path the check refuses → `None` / `pending`, nothing read — said.

### 5.2 — `SM-7` says `asset_bytes` is not built and stands as design; it is built at `ka-reader@98aaa71`

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Answered: the row is re-stated — built, handed `FolderContainment` by the bridge as the row said it would be — and the same re-statement is carried to the two sentences of § 2 that say the same thing in other words.

  **Check 1 — mine.** § 3 SM-7 and § 2 are the CTO's columns; the answer binds the document to the code and nothing else.

  **Check 2 — the question is wider than the row.** The fact holds: `Session::asset_bytes` builds `FolderContainment` over the held root (`session.rs:L1114`) and hands it to the core's `asset_bytes`; `link_to` does the same at `:L1253`. But the SDD says "`asset_bytes` is not built" in one place and "the bridge builds none [of the check]" and "the port is taken only where the check is handed in — by `markdown-renderer`, and by the model's `fill_view` and `reduce_open_file`" in another (§ 2, `docs/SDD.md:L363-L364`), and the three are one fact. The item named the row alone; the answer names all three and says so, because a fold that re-states SM-7 and leaves § 2 contradicting it reads worse than the file as it stands. The row's label, "`asset_bytes` in `core-bridge`", is read against the code: the export is the bridge's, the function is the model's (item 5.1), and the answer asks the row to say both rather than pick one.

  **Check 3 — the protected sentence survives.** § 2's "every production construction of the check at the pin is `FolderContainment`" was the structural reason v73 gave for "one implementation" (`self_answer-81.md` § 2.1). I counted the sites at `98aaa71`: five in the model (`:L182`, `:L230`, `:L1057`, `:L1248`, `:L1318`) and two in the bridge — seven, every one `FolderContainment` — so the reason stands at the new pin and § 11 R-10's "has one implementation" does not move. The `fs-reader` row's locators are pinned at `71f9f69` and stay true there. `docs/nfdr.md` QC-10 bound (2) and QC-68 name the port's takers; the PM has raised the same fact on the architecture companion (§ 3.1 (c)), so I open nothing there. Decided after 5.1 and consistent with it: 5.1 names the two functions and their callers, 5.2 names what they are handed.

  **Check 4.** *Stale:* the five model locators moved between the pins (`:L181` → `:L182`, and so on); the answer gives the `98aaa71` lines and keeps the `71f9f69` readings as dated notes, the paragraph's own pattern. *Concurrent:* the bridge builds a fresh check per call from the held root; `asset_bytes` clones the folder under the lock and reads outside it, so no lock is held across a read — in the answer by reference to 5.1. *Refused:* an outside path → `None`, no byte read — said. *Empty / Absent:* 5.1's.

### 5.3 — § 3's units paragraph names one edge from the model into the renderer, to fill a `FileView`; `asset_bytes` adds a second use of it

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Answered: the paragraph gains the second use, keeps "the one edge, in that direction only", and says why the test lives in the renderer.

  **Check 1 — mine.** § 3's units paragraph is the CTO's. The owner confirmed the edge's *direction* (`docs/trail/sdd/cycle-11.md` § 2.4; RN-65); the direction does not move, so nothing the owner decided is re-decided.

  **Check 2.** The fact holds: `folder_model.rs:L18` imports `is_bitmap` from `markdown_renderer` and `:L284` calls it inside `asset_bytes`. The item cites its occurrence. One thing added beyond the item: the order — `contained_file` runs at `:L283` before `is_bitmap` at `:L284`, so the format test never sees a path the walk refused — because the paragraph's reader is the one who cares that no read reaches outside the folder. And the reason the test is the renderer's is stated: a file `asset_bytes` serves is exactly one the renderer draws, one test with one home.

  **Check 3.** `docs/nfdr.md` QC-10's "the one edge from the model into the two" is the same sentence in the obligation's form; the PM raised it there (`docs/architecture_open_issues.md` § 3.1 (a)), so the records agree once both fold and I open nothing. QC-11 — neither imports the model — is unchanged, and `checks/structure.sh` still proves it. Consistent with 5.1 and 5.2.

  **Check 4.** *Empty:* a non-bitmap path → `is_bitmap` false → `None`, no read. *Refused:* the containment check runs first — said. *Stale:* pinned. *Absent / Concurrent:* a pure function over a path; none.

### 5.4 — `SM-4`'s locator for the admitted export set points at lines that moved

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Answered: the locator is re-pinned at `98aaa71` to `tests/exports.rs:L26-L34`, the seven names are given, and the old reading is kept as a dated note.

  **Check 1 — mine.** A locator in § 3 SM-4.

  **Check 2.** A correction, not a widening: the clause's locator names lines that no longer hold the set. I opened the file: `const ADMITTED: [&str; 7]` at `:L26-L34`, with the rule in its comment at `:L23-L25`. The seven names are six of SM-4's ten plus `ka_reader_free`, which the clause's own staging rule predicts.

  **Check 3.** SM-4's "No function joins this list" is about the ten-call list, not the admitted set, and the admitted set is a subset of the list plus the release call — consistent. § 4 C-R7 states the rule for what a build exports, not a count, so it does not move.

  **Check 4.** *Stale:* the locator will move again when the next export lands; pinning by commit is the cell's defence and the answer follows it. Nothing else reaches this item.

### 5.5 — § 2's decline of a filesystem port rests on tests that make their own folders, and does not say how a test forces a failed read

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** Confirmed with addition: the item carried a lean — "the decline stands for the filesystem as the subject, and a read seam narrow enough to hand in a failure is stated beside it" — and I treated it as a draft, as the prompt says to. Both halves of the lean are taken. What is added is what the seam *is*, where it sits, what stays outside it, who builds the real implementation, and what moves downstream.

  **Check 1 — mine, in the CTO's seat.** The edit lands in § 2 and SM-1 — the architecture, the CTO's column. It is a design decision about how the model is built, and it costs a change (the unpicked seed's two stations), but it commits no person, no outside party and no risk the owner carries; it serves the Way `public-standard` the owner declared, and the doctrine it answers to is already the owner's. I can name no ground I cannot see. Not the owner's, and not another seat's: the NFDR consequence is downstream of this document and is handled under check 3.

  **Check 2 — the lean holds, and it is a widening with an occurrence.** The item asks § 2 to state a form it does not state (a read seam), so § *A widening item waits until it occurs* applies; it cites its occurrence by the term's definition — a path and line (`tests/markdown.rs:L403`) and a measured command (`git grep -c '0o000' -- crates`, 37 sites in 13 files), both of which I re-ran and found. So the widening is taken. The lean's reasoning holds for the reason it gives: the doctrine's "Who runs it" says a mode-forced failure proves nothing under `root` and that the code reads through a seam; and the model has no seam — every read is a free-function call into `fs-reader` (fifteen sites, listed in the answer). One thing the item did not know and the answer uses: `fs-reader` already carries two private filesystem traits for its own cases (`OpeningFilesystem` `:L55-L59`, `Filesystem` `:L238-L246`), so the form is not new to the crate — the door that is missing is the model's. The design choices the answer makes, and why: **the trait is defined in `fs-reader`**, for the reason SM-2's cell already gives (the readers import nothing from the model); **the fake sits beside `SeededContainment` under the same `cfg` gate**, so v73's structural reason for "one implementation" carries over unchanged; **the real reader is handed in from the composition roots**, not built by the model's entry points as `FolderContainment` is — because the whole purpose of the seam is a door a test hands a failing reader through, and a collaborator the unit builds for itself has no door (`languages/rust/conventions.md` § *A unit is given its collaborators through a trait*), whereas the walk needs no door at the model: a real walk on a readable folder the test makes proves the same for every runner. That asymmetry is stated in the answer so a reader does not take the two as inconsistent. **The containment walk stays outside the seam** — this is the sentence that answers § 2's own objection to porting `fs-reader` ("a fake that can pass a path the real walk refuses"): the walk decides which path may be read, the seam decides what a read of an admitted path answers, so the fake can never admit a path. What the answer leaves to the change: the trait's name and methods, generic versus trait object (the conventions file says that is the product's call about dispatch, not about the seam), and the condition the adapter's own layer-2 failure case rests on — the answer fixes only that it is a condition every runner sees, never a mode.

  **Check 3 — what moves, and what I did not open.** Against the SDD: § 2's decline of the four-layer *default* stands — the default is the layering, and v73 already says the verified-fake rule attaches to a port and not to the layer choice, so a third port is the same shape as the second. § 2's "would re-cut QC-8–QC-11, `checks/structure.sh` and the eleven-part table" is answered sentence by sentence: the trait is inside `fs-reader`, no part is added, the model's import set is unchanged, so QC-8, QC-9, QC-11, the script and the table do not move — and QC-10 does, honestly: its setting-aside of the packet line rests on this paragraph by its own bound (3) ("If the SDD's decline paragraph moves, the setting-aside loses its ground and is re-opened", `docs/nfdr.md:L456`), and the answer says it narrows to the building of `FolderContainment`, which the paragraph keeps. Against the SRS: FR-3, FR-10, NFR-3 and NFR-10 require the system to handle a read that fails; none fixes how a test forces one. Against the UXD and PRD: nothing. Against earlier answers in this run: 5.2 has the model's entry points building `FolderContainment` and the bridge building it too; 5.5 has the reader handed in — the two land in the same paragraph in one fold, they were decided together, and the answer says why they differ. Against the previous round: `self_answer-81.md` § 2.1 kept the decline for `folder-model`'s entry points on the ground that they "call `fs-reader` and build `FolderContainment` themselves"; the first half of that ground is what this answer moves, and it moves on a fact that round did not weigh — the runner-dependence of the failure cases — so it is a change to a settled thing made in the open, not a quiet re-answer. **What I did not open, and why.** The NFDR is owed a QC-10 change once this folds. I opened no item on `docs/architecture_open_issues.md`: QC-10's bound (3) is the NFDR's own record of the dependency, the paragraph has not moved until `product-sdd` folds this answer, and the PM already holds a QC-10 item open there (§ 3.1) whose answering run reads QC-10 whole and the SDD as its input. The previous round reasoned the same way about QC-50 (`self_answer-81.md` § 2.1, check 3). I record it here so the next architecture round sees it, and I say in the answer whose re-opening it is.

  **Check 4.** *Empty:* an unseeded fake refuses, so a test that seeds nothing gets conditions and never bytes — said, the same default as `SeededContainment`. *Absent:* a file gone between the walk and the read → the real reader answers the condition as data, which SM-1's Up cell already carries; the fake answers what it is seeded. *Stale:* "37 sites in 13 files" is the pin's and the answer says so; once the change lands the grep prints nothing. *Concurrent:* the bridge reads outside its lock (`read_and_fold`, `asset_bytes`), so the reader travels with the folder snapshot into the read and the seam adds no lock hold; the real reader holds no state (`NativeFilesystem` is a unit struct), so the trait's thread bounds are the change's — not written into the answer, recorded here. *Refused:* `root` ignoring a mode is a refusal that is not one, which is the whole item; with the seam, refusal is the fake's answer whatever the runner; and the real reader's own refusals (a FIFO, a device, a folder — `read_bytes` refuses by the handle's metadata, `fs_reader.rs:L680-L695`) are conditions every runner sees, which is the form the answer fixes for the adapter's layer-2 cases.

  **Close call:** I weighed *answered*, since the item sits in a bucket that arrives without a draft; the lean was a full position, so weighing it is what I did, and the verdict says so.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
