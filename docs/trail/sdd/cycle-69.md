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
>
> **No `product-sdd` run wrote this file. A `companion-self-answer` run opened it on 2026-11-07**,
> in the Principal Architect's seat, while it answered `docs/architecture_open_issues.md` § 2.1.
> That item drafts NFDR QC-69, whose third verifier was taken from a sentence in § 2 *One read seam
> beside the decline* — "`git grep '0o000' -- crates` prints nothing" once the seam is built. The
> run measured the 37 sites that sentence counts, at `ka-reader@a499e4d`, whose `crates/` is
> `98aaa71`'s, and 14 of them in 5 files are cases SM-1's seam cannot reach. The NFDR narrows its
> own verifier; the SDD sentence is the CTO's, so the change is raised here. `SDD.md` was Settled
> at v74 with no companion, and without this file a `product-sdd` re-run reads it as done. The SDD
> itself is not edited. The one item is in § 2, the bucket a raised item takes.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

### 2.1 § 2 *One read seam beside the decline* says building SM-1's seam empties `git grep '0o000' -- crates`; 14 of the 37 sites sit where the seam cannot reach, and SM-1's call count reads fifteen where its locators hold sixteen
- **Raised by:** the `companion-self-answer` run, 2026-11-07, in the Principal Architect's seat — not one of the SDD's three seats
- **Seat:** cto
- **Drafted into the SDD:** Nothing. This run writes no document. The proposed reading is below for
  the CTO to draft or replace.
  1. **The grep sentence narrows to what the seam reaches.** § 2 now says (`docs/SDD.md:L444-L446`
     at v74): "Once the seam is built, every case that forced a failed read with a mode hands it a
     failing reader instead and `git grep '0o000' -- crates` prints nothing". Proposed: once the
     seam is built, every case whose failed read crosses SM-1 hands its unit a failing reader, and
     no such case forces the failure with a mode. The building change names those files. At
     `98aaa71` they hold 23 of the 37 lines, in 8 files: `src/folder_model.rs` (2),
     `tests/list_tree.rs` (4), `tests/failure_log.rs` (4), `tests/watch.rs` (6),
     `tests/markdown.rs` (1), `tests/unit/fs_reader.rs` (4, the real reader's own failure path,
     which § 2 already says is proven "by a condition every runner sees … never by a file mode"),
     and the bridge's `tests/open_file.rs` (1) and `tests/open_diagnostics.rs` (1). All of them
     reach `fs-reader` through the model's entry points (`open_folder`, `list_tree`, `asset_bytes`
     are `folder_model.rs:L78`, `:L101`, `:L278`) or test the reader itself.
  2. **The other 14 lines are stated as outside the seam**, so no reader takes the sentence as a
     promise about them:
     - **12 lines in 3 files are the Git adapter's.** `tests/git_state.rs` (7),
       `tests/root_finding.rs` (4) and `tests/unit/libgit2.rs` (1) lock a path libgit2 reads,
       such as `S/.git/config` (`git_state.rs:L1526`) or `repo/.git` (`root_finding.rs:L177`), and
       call the real port. `git-reader` imports nothing from `fs-reader` (QC-11), so no SM-1
       reader can be handed to it. The model-side cases already have SM-2's fake.
     - **1 line is the containment walk's.** `tests/tree_links.rs:L95` locks a link's target
       outside the folder, to prove the walk answers `Outside` without reading it. The walk is
       outside the seam by § 2's own rule.
     - **1 line is a write, not a read.** `crates/ka-reader-bridge/src/log_writer.rs:L419` seals
       the log's directory to prove a failed write is silent.
     Each of these 14 forces its failure with a mode and proves nothing when `root` runs it
     (`testing_doctrine.md` § *A test reads nothing of the machine it runs on*). Whether any of
     them is owed its own door is the CTO's call. This item asks only that § 2 stop saying the read
     seam empties them.
  3. **SM-1's count reads sixteen.** SM-1's cell says "fifteen free-function calls"
     (`docs/SDD.md:L622`), and RN-154 "fifteen reads". The locators they give hold sixteen, because `:L232-L233`
     holds two, `observe_file` at `:L232` and `locate` at `:L233`. NFDR RN-92 saw this and left
     it as the CTO's. It is carried here so this cycle settles it.
- **Rationale:** This is a fact that is false at the pin, and the strongest ground for reopening a
  settled document. Measured at `ka-reader@a499e4d`: `git grep -c '0o000' -- crates` gives 37
  lines in 13 files, `git grep -n` gives each site, and
  `git diff --stat 98aaa71 a499e4d -- crates checks` prints nothing, so these are `98aaa71`'s
  sites. The sentence is copied downstream. NFDR QC-69 took it as a verifier, and a verifier that
  building the seam cannot satisfy fails the building change, or pushes it to rewrite the Git
  adapter's tests, the walk's test and the log writer's test to clear a grep. The architecture
  companion's § 2.1 answer narrows QC-69 to the seam's own files and points here.
- **If overridden:** § 2 keeps the whole-tree sentence. The NFDR's narrowed verifier then reads
  narrower than the SDD it traces to. That gap is recorded in the NFDR's trace, not hidden, but a
  later reader meets two documents that disagree about what building the seam empties. SM-1's
  count stays one short.
- **Confirm or override:** confirm, with two additions and one reading of the item's own text
  corrected. (1) Taken as drafted: the sentence at `docs/SDD.md:L444-L446` narrows to what the seam
  reaches — once the seam is built, every case whose failed read crosses SM-1 hands its unit a failing
  reader, the real reader's own failure cases are proven at layer 2 by a condition every runner sees,
  and `git grep '0o000'` over the files the building change names prints nothing; at
  `ka-reader@98aaa71` those files are the eight the item lists, 23 lines, and the count is the pin's.
  (2) Added — one of those 23 lines is not a read: `crates/ka-reader-core/tests/unit/fs_reader.rs:L613`
  locks a link's target outside the root to prove the walk answers `Outside` without touching it, the
  same guard as `tests/tree_links.rs:L95`, so it is the walk's and not the reader's own failure path as
  the item reads it. The building change re-states it all the same, because the reader's own suite is
  that change's and the guard holds for every runner with a target that does not exist; so the
  file-level check holds and the item's line counts stand. (3) Added — what § 2 says of the 14 lines in
  5 files outside the seam: each forces its failure with a mode and proves nothing when `root` runs
  it, so they are a known defect at `98aaa71` under the rule this paragraph already states for the
  adapter's own failure path — proven by a condition every runner sees, named by the change that
  re-states each — and no second seam is added for them: the Git adapter's 12 are SM-2's adapter-side
  layer-2 cases, the walk's guard at `tests/tree_links.rs:L95` needs no door because its assertion is
  `Outside`, and `crates/ka-reader-bridge/src/log_writer.rs:L419` is a write, which this seam never
  covers. None of the three is the seam change's. (4) Taken as drafted — SM-1's cell (`:L622`) reads
  sixteen calls: the fifteen `fs_reader::`-qualified sites, `:L232` and `:L233` both among them, and
  `read_contained_bytes` at `:L287`, imported by name (`folder_model.rs:L11`); the cell carries the
  correction with a dated note, and RN-154's "fifteen" stands as that run's record. Reasoning:
  `docs/trail/sdd/self_answer-83.md`.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

None.
