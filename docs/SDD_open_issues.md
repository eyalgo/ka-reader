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
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

None.
