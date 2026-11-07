# SDD open issues — ka-reader

> Companion to `SDD.md`. The CTO wrote the SDD; this file holds what that run could not settle from
> its inputs (the PRD, the SRS, the UXD, and any context or constraints), and the calls that are the
> CPO's or the CDO's to make. An item whose call is the CPO's or the CDO's carries that seat's
> `Seat:`; an item whose call is the CTO's carries `cto` or no `Seat:` field.
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time `product-sdd` folds them in, it first copies this
> file whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item may name the seat that answers it.** Any item in any section carries an optional
> `- **Seat:** <seat>` field beside its other fields. Its value is the name of the agent whose posture
> answers the item — `cto`, `cpo` or `cdo`. An item with no usable value, whether the field is absent,
> empty or still the `<seat>` placeholder, is answered in the seat of the skill that produced this file.
> The field names the *answering* seat. It is not the seat that raised the item (`Raised by:` /
> `Held by:`), and it is not the document an answer belongs to.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a
> disagreement is not something one seat asked, it is two positions held by different seats, and the
> answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the SDD's lanes entirely.** §§ 1–4 are all the SDD's own three
> lane seats; § 5 is a seat that never held a lane in it, reading it long after it settled and
> finding something only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's,
> which stay fixed to the three lane seats on purpose.

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-11-07, reading the settled SDD
> against the product at `ka-reader@98aaa71`, where `asset_bytes` and `open_relative_link` first have
> code. Five items follow in § 5; the SDD itself is not edited.

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 `SM-5`'s *Down* cell says three functions stand beside the request types; five do at `ka-reader@98aaa71`
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the cell names the bridge's fixed orders, and the link's is missing.
- **Where it shows:** § 3, the `SM-5` row (`docs/SDD.md:L562`): "At `ka-reader@d6bc3a3` three functions stand beside the request types", with its paragraph on how the bridge drives them. At `ka-reader@98aaa71` `folder-model` also holds `asset_bytes(folder, path, check)`, answering a contained bitmap's bytes or `None` (`crates/ka-reader-core/src/folder_model.rs:L278`), and `link_file(path, check)`, answering the path as given when the check passes it to a file (`:L305`); both take the check through `ContainmentCheck` and ask it once per call. The bridge's link is one more fixed order: `link_file` and the selection act under one lock hold, `read_file` outside it, then the open's fold under it (`crates/ka-reader-bridge/src/session.rs:L1243`, `link_to`; `:L1211`, `read_and_fold`).
- **If a document has to be written:** none — the cell is re-stated.
- **Answer:** Re-state the cell at `ka-reader@98aaa71`: five functions stand beside the request types. The three named at `d6bc3a3` as written, and two more, both public (`crates/ka-reader-core/src/lib.rs:L15`) so § 4 C-I3's in-process route is unchanged: `asset_bytes(folder, path, check) -> Option<Vec<u8>>` (`crates/ka-reader-core/src/folder_model.rs:L278-L288`) — the exact bytes of a contained bitmap, touching no model; `None` for a path the check refuses, a folder, a missing entry, a file that is not a bitmap by the renderer's test (`is_bitmap`, `:L284`) and a file that cannot be read (`read_contained_bytes`, `:L287`, which logs the failure and no path); and `link_file(path, check) -> Option<PathBuf>` (`:L305-L307`) — the path as given when the check passes it to a file, `None` otherwise, reading no content and touching no model. Both take the check through `ContainmentCheck`, ask it once per call and keep no answer (`contained_file`, `:L251`). How the bridge drives them: `asset_bytes` is one call with no fold — the held folder is cloned under the lock, the check is built over its root and the read runs outside the lock (`crates/ka-reader-bridge/src/session.rs:L1112-L1116`); the link is one more fixed order, the fourth in this cell: under one lock hold the check is built over the held root and `link_file` asked, and for a file the selection act is admitted, `select_file(FileRequest::Select(Some(linked)))`, so the link takes its place among the acts in arrival order and a select act that arrives later is admitted after it; then the open's read-and-fold runs from the snapshot taken in that same hold — `read_file` outside the lock, `open_read` under it, with `reread_open_file` when a batch landed during the read (`link_to`, `:L1243`; `read_and_fold`, `:L1211`, the same fold the open uses). No folder open, or a path that is not a contained file, applies nothing, reads nothing and answers `pending`. Keep the `d6bc3a3` reading as a dated note, as the cell keeps its earlier readings. The owner cell stands. Reasoning: `docs/trail/sdd/self_answer-82.md` § 5.1.

### 5.2 `SM-7` says `asset_bytes` is not built and stands as design; it is built at `ka-reader@98aaa71`
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the row describes as future what the core now does.
- **Where it shows:** § 3, the `SM-7` row (`docs/SDD.md:L564`): "`asset_bytes` is not built at that pin and stands as design — when built it is handed `FolderContainment` from the composition root". At `ka-reader@98aaa71` the bridge's session builds `FolderContainment` over the held folder's root (`crates/ka-reader-bridge/src/session.rs:L1114`, `:L1253`) and hands it to `folder-model`'s `asset_bytes` and `link_file`.
- **If a document has to be written:** none — the row is re-stated.
- **Answer:** Re-state the row at `ka-reader@98aaa71`: `asset_bytes` is built. The function is `folder-model`'s (`crates/ka-reader-core/src/folder_model.rs:L278-L288`; SM-5, item 5.1), the bridge's `Session::asset_bytes` is its production caller (`crates/ka-reader-bridge/src/session.rs:L1112-L1116`) and `ka_reader_asset_bytes` its export (`crates/ka-reader-bridge/src/exports.rs:L184`). It is handed `FolderContainment`, built by the bridge over the held folder's root (`session.rs:L1114`) — the composition root, as the row said it would be — and `link_file` is handed one the same way (`:L1253`). It asks the check once per call and keeps no answer; only a path the check admits that is a bitmap by the renderer's test is read, so a node built wrong still reaches no byte. The row's label places `asset_bytes` in `core-bridge`: say that the export is the bridge's and the function it wraps is the model's. The same re-statement reaches two sentences of § 2, *The four-layer default, declined by name*, written at `71f9f69`: "`crates/ka-reader-bridge` builds none" — at `98aaa71` it builds `FolderContainment` at the two sites above — and "the port is taken only where the check is handed in — by `markdown-renderer`, and by the model's `fill_view` and `reduce_open_file`" — `asset_bytes` and `link_file` take it too. The sentence that paragraph protects holds at the new pin: every production construction of the check is `FolderContainment` — five in the model (`folder_model.rs:L182`, `:L230`, `:L1057`, `:L1248`, `:L1318`) and two in the bridge — and a release build compiles no second implementor, so "one implementation" (the owner cell; § 11 R-10) stands; the owner cell's "two callers" reads four, none re-implementing the check. The `71f9f69` readings stay true at their pin and are kept as dated notes; the `fs-reader` row's locators pinned there do not move. Reasoning: `docs/trail/sdd/self_answer-82.md` § 5.2.

### 5.3 § 3's units paragraph names one edge from the model into the renderer, to fill a `FileView`; `asset_bytes` adds a second use of it
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the paragraph states what the edge carries, and it now carries one more call.
- **Where it shows:** § 3, the units paragraph (`docs/SDD.md:L463-L466`): "The model calls down to `markdown-renderer` and `highlighter` to fill a `FileView` … the one edge from the model into the two". At `ka-reader@98aaa71` the model also calls the renderer's bitmap-format test for `asset_bytes` (`crates/ka-reader-core/src/folder_model.rs:L18`, `:L284`, `is_bitmap`). It is still the one edge, in that direction only.
- **If a document has to be written:** none — the paragraph is re-stated.
- **Answer:** Re-state the paragraph at `ka-reader@98aaa71`: the model calls down to `markdown-renderer` and `highlighter` to fill a `FileView`, and to the renderer's bitmap-format test, `is_bitmap`, for `asset_bytes` (`crates/ka-reader-core/src/folder_model.rs:L18`, `:L284`) — so a file `asset_bytes` serves is exactly one the renderer draws as an image, one test with one home, and the model asks it only for a path the check already admitted (`contained_file` runs first, `:L283`). It is still the one edge from the model into the two, in that direction only; neither imports the model (`docs/nfdr.md` QC-11), and the direction the owner confirmed (RN-65) did not move. `docs/nfdr.md` QC-10 carries the same edge in an obligation's form; its correction is the Principal Architect's and is already raised on that record. Reasoning: `docs/trail/sdd/self_answer-82.md` § 5.3.

### 5.4 `SM-4`'s locator for the admitted export set points at lines that moved
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; a reader following the locator lands on the wrong lines.
- **Where it shows:** § 3, the `SM-4` row (`docs/SDD.md:L561`): "`--test exports` holds the admitted set (`crates/ka-reader-bridge/tests/exports.rs:L18-L22`)". At `ka-reader@98aaa71` the set is seven names at `crates/ka-reader-bridge/tests/exports.rs:L26-L34` (`const ADMITTED: [&str; 7]`).
- **If a document has to be written:** none — the locator is re-pinned.
- **Answer:** Re-pin: at `ka-reader@98aaa71` the admitted set is `const ADMITTED: [&str; 7]` at `crates/ka-reader-bridge/tests/exports.rs:L26-L34` — `ka_reader_open_folder`, `ka_reader_list_tree`, `ka_reader_select_file`, `ka_reader_read_git`, `ka_reader_asset_bytes`, `ka_reader_open_relative_link` and `ka_reader_free`: six of the list's ten and the release call beside it, each present from the build in which a change of its slice first built it, as the clause says. The test's own comment (`:L23-L25`) states that the export and declared sets come from the library and the header and that a name joins the array with the change that lands the function. Keep the `L18-L22` reading as a dated note. Nothing else in the clause moves. Reasoning: `docs/trail/sdd/self_answer-82.md` § 5.4.

### 5.5 § 2's decline of a filesystem port rests on tests that make their own folders, and does not say how a test forces a failed read
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-11-06_failed-reads-go-through-a-seam`
- **What it blocks:** that seed's route: a seam for the model's reads is the port this paragraph declines, and `docs/nfdr.md` QC-10's setting-aside re-opens only when this paragraph moves (its bound (3)).
- **Where it shows:** § 2, *The four-layer default, declined by name* (`docs/SDD.md:L340-L352`): "`folder-model`'s tests run against folders they make themselves, which `testing_doctrine.md` … admits at layer 1". The same doctrine's § *A test reads nothing of the machine it runs on*, "Who runs it", says a file made unreadable with a mode proves nothing when `root` runs the test, and that the code reads through a seam instead. At `ka-reader@98aaa71` 37 sites in 13 files force a failed read with mode `0o000` (`git grep -c '0o000' -- crates`), among them `crates/ka-reader-core/tests/markdown.rs:L403`; the model's reads have no door a test can hand a failing reader through (`crates/ka-reader-core/src/folder_model.rs:L287`, `read_contained_bytes`). Lean: the decline stands for the filesystem as the subject, and a read seam narrow enough to hand in a failure is stated beside it.
- **If a document has to be written:** none — the paragraph is re-stated, and QC-10 follows by its own bound.
- **Answer:** Confirm the lean, with what § 2 states beside the decline. **The decline stands for the filesystem as the subject.** Listings, bytes, the containment walk and the read-only promise are proven on real folders the tests make, which `<CORE>/doctrine/engineering/testing_doctrine.md` § *A unit test hands its unit fakes and touches nothing real* admits at layer 1 and `checks/read-only.sh` proves on the real filesystem; porting `fs-reader` whole stays declined for the paragraph's three reasons as written. **One thing a real folder cannot prove for every runner is a failed read**: `root` ignores a file mode, so a case that forces a failure with `0o000` proves nothing when `root` runs it (`testing_doctrine.md` § *A test reads nothing of the machine it runs on*, "Who runs it"). At `ka-reader@98aaa71` 37 sites in 13 files force a failed read that way (`git grep -c '0o000' -- crates`; among them `crates/ka-reader-core/tests/markdown.rs:L403`, the unreadable bitmap `asset_bytes` refuses), and the model's reads have no door: `folder-model` calls `fs-reader`'s reads as free functions — `open_root`, `list`, `read`, `observe_file`, `reobserve_file`, `observe_listing`, `locate`, `locate_parent`, `read_contained_bytes` (`crates/ka-reader-core/src/folder_model.rs:L79`, `:L102`, `:L183`, `:L232-L233`, `:L287`, `:L848`, `:L1022`, `:L1041`, `:L1058`, `:L1065`, `:L1070`, `:L1199`, `:L1211`, `:L1249`, `:L1317`). `fs-reader` itself already reads through two private traits for its own cases — `OpeningFilesystem` (`src/fs_reader.rs:L55-L59`) and `Filesystem` (`:L238-L246`) — so the form is not new to the crate; what is missing is the door the model is handed. **So § 2 states one read seam beside the decline, and SM-1 takes its form.** SM-1 — `fs-reader` ↔ `folder-model`, what crosses and the owner cell unchanged — is a trait defined in `fs-reader`, for the reason SM-2's cell gives for the Git port: the readers import nothing from the model. Its one production implementation is `fs-reader`'s real reads; its one fake sits in the test-support module beside `SeededContainment`, under the same `#[cfg(any(test, feature = "testing"))]` gate (`src/fs_reader.rs:L16-L17`), so a release build compiles one implementor; the fake answers, for a path a test names, the bytes or the condition SM-1's Up cell already carries, and refuses what is not seeded; one contract suite runs against both at layer 2, the real run inside a folder the test makes (`testing_doctrine.md` § *A fake is verified against its port's contract*). The real reader is handed to the model's entry points from the composition roots — the bridge's session and § 4 C-I3's in-process harness — as the Git port is: the Rust packet's "a unit is given its collaborators through a trait" (`<CORE>/doctrine/engineering/languages/rust/conventions.md`) taken for this edge. The trait's name and methods, and whether it arrives as a generic parameter or a trait object, are the change's design. **What stays outside the seam is what answers the paragraph's own objection.** The containment walk — `ContainmentCheck`, `FolderContainment` — is not behind it: the walk decides which path may be read and the seam decides what a read of an admitted path answers, so a fake reader can fail or refuse an admitted read and can never admit a path the real walk refuses. `FolderContainment` keeps being built where it is (item 5.2), because a real walk on a readable folder the test makes proves the same for every runner; a failed read is the one case that needs a door. **The adapter's own failure path** — the real reader at layer 2 — is proven by a condition every runner sees, named by the change that builds it, never by a file mode. **What this moves and what it does not.** QC-8, QC-9, QC-11, `checks/structure.sh` and the eleven-part table do not move: the trait is `fs-reader`'s, no part is added and the model still imports `fs-reader`. `docs/nfdr.md` QC-10's setting-aside of the packet line loses its ground for the reads by its own bound (3) once this paragraph folds, and narrows to the building of `FolderContainment`, which this paragraph keeps; that re-opening is the Principal Architect's. Once the change lands, every case that forced a failed read with a mode hands the seam a failing reader instead and `git grep '0o000' -- crates` prints nothing; the count above is the pin's. Reasoning: `docs/trail/sdd/self_answer-82.md` § 5.5.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
