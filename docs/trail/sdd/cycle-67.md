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

> **No `product-sdd` run wrote this file.** A `companion-self-answer` run in the Principal
> Architect's seat opened it on 2026-11-07, while answering `docs/architecture_open_issues.md`
> items 3.3 and 3.4 (the run's report: `docs/trail/architecture/self_answer-75.md`). Reading the
> settled SDD at v72 against the product at `ka-reader@71f9f69`, the run found that § 2 and § 3 do
> not state the containment port the typed Markdown document built. The SDD is Settled and its
> companion was removed at v72, so without this file a `product-sdd` re-run would have nothing to act
> on. One item follows, in § 2. Its slot is left for the next round, and the SDD is not edited.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

### 2.1 § 2 and § 3 do not state the containment port — `ContainmentCheck`, its adapter, its one fake and its contract suite — that the core has had since `ka-reader@71f9f69`
- **Raised by:** Principal Architect — 2026-11-07, in a `companion-self-answer` run, outside the SDD's three lanes (the § 5 kind of raiser; it sits here because this run raises it with a lean)
- **Seat:** cto
- **Drafted into the SDD:** nothing. The SDD is not edited. The proposed change: (1) § 3's `fs-reader` row (`docs/SDD.md:L412`) and SM-7 (`:L542`) say that the containment check is reached by its two content-derived callers through a port, `ContainmentCheck`, defined in `fs-reader`, with `FolderContainment` the one implementation and `SeededContainment` the port's one fake. That fake is verified by one contract suite, `crates/ka-reader-core/tests/containment.rs`, run against both (`crates/ka-reader-core/src/fs_reader.rs`, `src/fs_reader/fakes.rs`, at `ka-reader@71f9f69`). (2) In § 2 *The four-layer default, declined by name*, "it reaches SM-2's Git port today" (`:L363`) names the second port it now reaches. (3) The same paragraph's sentence "Porting `fs-reader` would place the containment walk — SM-7's one implementation — behind a fake that can pass a path the real walk refuses" (`:L354-L356`) says how it stands beside the built port. The walk still has one implementation. The fake stands in for it only where `markdown-renderer` and the model's fold (`reduce_open_file`) are handed the check, and the contract suite is what keeps the fake from passing a path the real walk refuses. `folder-model`'s own entry points still call `fs-reader` and build `FolderContainment` themselves, so the decline holds for them.
- **Rationale:** a fact in the SDD is now false. The paragraph says the verified-fake rule reaches one port, and the product has two. A delivery-tier stage reading § 3 finds no port where the code has one. The change that built it placed the port and its fake by `<CORE>/doctrine/engineering/languages/README.md` § *A fix that hands a collaborator in is not a topology decision*, so no slice or edge moved and § 10 owes nothing. What is missing is the statement. The lean is that the decline stands for `folder-model`'s entry points. The constraint set records that same reading as the setting-aside of the Rust packet's trait-collaborator line for the model's edge into `fs-reader`, and cites the decline paragraph as its source (`docs/architecture_open_issues.md` § 3.4, answered on 2026-11-07). If the decline paragraph moved, that setting-aside would lose its ground.
- **If overridden:** if the SDD instead has `folder-model` take its `fs-reader` collaborators through ports, the reads and the check together, wired at `core-bridge`'s composition root, then the public signatures of `select_file`, `read_file` and `FolderModel` change with every caller, § 3's units paragraph and SM-1 re-cut, and the constraint set's QC-10 setting-aside is withdrawn on its own companion. If the SDD declines to name the port at all, § 3 keeps describing a check with no door that the code reaches through one.
- **Confirm or override:** confirm, with one clause of the draft replaced and three additions. The three edits are taken as drafted: § 3's `fs-reader` row and SM-7 state the port; § 2's "so it reaches SM-2's Git port today" (`docs/SDD.md:L363`) names `fs-reader`'s containment port as the second it reaches, from `ka-reader@71f9f69`; and the "Porting `fs-reader` would place the containment walk … behind a fake" sentence (`:L354-L356`) gains how the built port stands beside the decline, which holds for `folder-model`'s entry points. **Replaced:** the draft's reason that "the contract suite is what keeps the fake from passing a path the real walk refuses" does not carry that weight. `SeededContainment::seeded(reference, answer)` takes any answer (`crates/ka-reader-core/src/fs_reader/fakes.rs:L36-L40`), so a test can seed a pass for an outside reference, and the suite (`crates/ka-reader-core/tests/containment.rs:L64-L72`, `:L90-L102`) proves only that the fake answers as `FolderContainment` does for the contract's five cases. What keeps the decline's reason true is structural, and the SDD says that instead: (a) a release build compiles no implementor of the trait but `FolderContainment` — the fake sits behind `#[cfg(any(test, feature = "testing"))]` (`src/fs_reader.rs:L16-L17`), `testing` is in no default feature and is turned on only by the crate's dev-dependency on itself (`crates/ka-reader-core/Cargo.toml`, `[features]` and `[dev-dependencies]`), the form `<CORE>/doctrine/engineering/languages/rust/testing.md`'s contract-suite bullet names; (b) every production construction of the check at `71f9f69` is `FolderContainment`, built by `folder-model`'s own entry points from their root (`src/folder_model.rs:L181`, `:L229`, `:L991`, `:L1182`, `:L1252`), and `crates/ka-reader-bridge` builds none; (c) SM-7's own rule stands — a node built wrong still reaches no byte, because `asset_bytes` asks the real check again on every call. **Addition one — what the port is, for the `fs-reader` row:** `ContainmentCheck` is one method, `check(folder, reference) -> Result<ContainedEntry, Condition>` (`src/fs_reader.rs:L446-L448`), exported from `lib.rs` with `ContainedEntry` and `FolderContainment`; `SeededContainment` is exported under the `testing` feature alone (`lib.rs:L18-L19`) and answers `Missing` for any reference not seeded (`fakes.rs:L49-L58`), so its unseeded default refuses. **Addition two — who takes the port at the pin, so SM-7's "two callers" is not misread:** the renderer (`render`, `src/markdown_renderer.rs:L140`; `markdown_renderer/fold.rs:L21`; `references.rs:L57`, `:L82`) and the model's `fill_view` and `reduce_open_file` (`folder_model.rs:L146`, `:L1291`), each handed `&impl ContainmentCheck`. `asset_bytes` is not built at `71f9f69`, so SM-7's second caller stands as design; when built it is handed `FolderContainment` from the composition root, as every production caller is. **Addition three — the word "implementation":** SM-7's "has one implementation" and § 11 R-10's stay true and are not reworded. `FolderContainment` is the walk's one implementation; `SeededContainment` implements the trait and walks nothing. The fold states that distinction where it names the fake, so a reader does not count two walks. Nothing else moves: the decline of the four-layer default, `docs/nfdr.md` QC-8–QC-11, `checks/structure.sh` and the eleven-part table stand as written, and the units paragraph's "`markdown-renderer` calls `fs-reader`'s containment check" (`docs/SDD.md:L441`) stays true, through the port. Reasoning: `docs/trail/sdd/self_answer-81.md` § 2.1.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

None.
