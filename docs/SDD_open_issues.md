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

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 Does the four-layer default with verified fakes change § 2's "no" to the hexagonal shape?
- **Raised by:** PM — 2026-11-05
- **Seat:** cto
- **Tracked by:** none yet — `seeds-from-product-docs` cuts one from the fold
- **What it blocks:** holding ka-reader's code to the four-layer default and to one verified fake per port. That default binds a product "only once that SDD has chosen it" (`core/doctrine/engineering/arch_defaults.md:85-87`). This SDD has not weighed it by name, so today neither the dependency rule nor the contract suites bind ka-reader. What already binds it with no SDD choice is narrower: code-integrity refuses code that builds its own collaborators, and unit tests that touch a real resource (`skills/senior-engineer/.claude/skills/development-code-integrity/SKILL.md:192`).
- **Where it shows:** § 2's shape table weighs "**Hexagonal** — a domain core behind ports, an adapter at every edge" and declines it: "insulating a stable edge is ceremony; its one useful port, the Git reader (force 2), is kept inside the taken shape (§ 3 SM-2)" (`docs/SDD.md:306`). The paragraph after the table holds that call: "The hexagonal shape still answers with more seams than the product has volatile edges" (`docs/SDD.md:319`). That was decided before `arch_defaults.md` § *The four layers* (`:83-115`) and `testing_doctrine.md` § *A fake is verified against its port's contract* (`:80`) stood. The question is whether the new default changes the call. The default is four layers (`domain`, `ports`, `adapters`, `entrypoints`) under the dependency rule, with one fake per port in a test-support module and one contract suite per port, run against both the real adapter and the fake at layer 2. The Rust and Swift testing guides (`core/doctrine/engineering/languages/rust/testing.md`, `languages/swift/testing.md`) state each language's form.
- **If the answer is yes, the cost:** ports where the edges are: the filesystem read, the Git reader (SM-2 already draws it), the watcher now in `ka-reader-bridge` (§ 3, RC-7), and the clock if any part reads one. `domain` and `ports` would share one unit, because Rust crates and Swift targets may not depend on each other in a cycle (`arch_defaults.md:103-105`): presumably `ka-reader-core` for the Rust half, and one target for `ka-reader-mac`. Each port would also need a contract suite run against both its adapter and its fake.
- **If the answer stays no:** say so in § 2 against the new default by name, so that "hexagonal" in the table is read as the doctrine's four layers and the declining reason meets that default rather than an earlier one.
- **And either way:** what `docs/nfdr.md` § 1.2 *Forbidden imports* gains. A product records its layers and their forbidden imports there (`arch_defaults.md:111`). § 1.2 states today's graph (QC-8 onward), not layers.
- **If a document has to be written:** none beyond `SDD.md`, through `product-sdd`. The NFDR's § 1.2 then follows through `product-nfdr` if the answer moves it.
- **Answer:** <the CTO fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file.

### 5.2 § 3 `folder-model` still calls the removed-entry drop a known defect
- **Raised by:** PM — 2026-11-05
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** a reader of § 3 takes the drop pass as unbuilt, and the next slice's design plans around a defect the tree no longer has.
- **Where it shows:** the `folder-model` row (`docs/SDD.md:L371`), the sentence "At `ka-reader@8ef8c5b` the reducer does not do this, a known defect until a change lands". At `ka-reader@2529a42` the model's `Invalidate` request re-reads, drops every listing held under a removed entry, and reads a returned folder afresh; `cargo test --locked -p ka-reader-core --test watch` holds the removal-and-return case. `TreeRequest::Delta`, which no production code calls, keeps its names-only reduction.
- **If a document has to be written:** none beyond `SDD.md`, through `product-sdd`.
- **Answer:** <the CTO fills this in>

### 5.3 SM-4 and SM-5 describe the crossing before tree acts and invalidation were built
- **Raised by:** PM — 2026-11-05
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** the next slice reads SM-4 to plan the reading position's crossing, and SM-4 says the collapse does not cross yet.
- **Where it shows:** SM-4 (`docs/SDD.md:L495`) says `list_tree` takes the path alone until the shell's crossing is built. At `ka-reader@2529a42` `ka_reader_list_tree` takes the path and an act (expand `0`, collapse `1`) and the shell sends both; `select_file` still takes the path alone, now applies the selection to the held model, and the open file and the reading position do not cross. SM-5 (`docs/SDD.md:L496`) lists `TreeRequest` as `Expand`, `Collapse`, `Delta`; it now also has `Invalidate`, the model-owned request that the watcher's path hints enter through.
- **If a document has to be written:** none beyond `SDD.md`, through `product-sdd`.
- **Answer:** <the CTO fills this in>

### 5.4 § 3 `surfaces` leaves the order of two asks in flight undecided, and the built order lets two selections cross
- **Raised by:** PM — 2026-11-05
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** the open file following the disk follows the model's selection; if two selections can reach the model out of order, the model can hold a file the tree does not show.
- **Where it shows:** the `surfaces` row (`docs/SDD.md:L377`) says which side orders two asks in flight is the design of the change that moves the selection into the model (RN-76). As built at `ka-reader@2529a42`: tree acts cross SM-4 on one serial queue in the reader's order (`ka-reader-mac/Sources/Shell/ReadRunning.swift:L37-L48`); selections apply to the model in the order they reach the bridge's model lock and the shell draws only the latest answer, but `select_file` runs on the concurrent runner (`Sources/Shell/LaunchFlow.swift:L177-L179`, `ReadRunning.swift:L18-L27`), so two quick selections can reach the lock in reverse order. The question is what the row states: the order as built, or that the model's selection is always the reader's last.
- **If a document has to be written:** none beyond `SDD.md`, through `product-sdd`.
- **Answer:** <the CTO fills this in>

### 5.5 § 4 C-I1 and *Open Questions* still hold the failed re-read of an expanded folder as undecided
- **Raised by:** PM — 2026-11-05
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** later slices read C-I1 for what a failed folder does to its children, and find "not decided" over a form the product now has.
- **Where it shows:** § 4 C-I1 says what a failed re-read does to the entries listed under the folder is not decided (*Open Questions*, RN-89). The form built at `ka-reader@2529a42`: the folder's listing item becomes `failed` with the condition observed; the entries under it are no longer held (no row beneath it, every listing at a path under it dropped); the reader's place under it — expanded flags and the selection — is kept, inert; the next successful read replaces the failure with the fresh listing without ceremony, and each folder under it that the place holds expanded is read again in the same update. Held by `--test watch`'s failed-re-read cases and `RootItemsViewModelChangesTests`. *Open Questions* then loses the failed-re-read item, and its collapse-and-scroll item narrows to the scroll's crossing through `select_file` alone, since the collapse now crosses through `list_tree`'s act.
- **If a document has to be written:** none beyond `SDD.md`, through `product-sdd`.
- **Answer:** <the CTO fills this in>

### 5.6 § 4 C-I1 says the model sets `stopped` on an item it holds; the model has no such state
- **Raised by:** PM — 2026-11-05
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** a layer-2 case asked to pin a model-held `stopped` sibling has nothing to pin; NFDR QC-47 repeats the claim (raised on the architecture companion).
- **Where it shows:** C-I1 (`docs/SDD.md:L825`) says `stopped` is established "by the model, on an item it holds". At `ka-reader@2529a42` `ItemState` is `Pending`, `Observed` or `Failed` (`crates/ka-reader-core/src/fs_reader.rs:L129-L133`), and only the shell sets `stopped`, at SM-4's return. The question is whether the model is to gain the state or C-I1 is to say only the shell sets it.
- **If a document has to be written:** none beyond `SDD.md`, through `product-sdd`.
- **Answer:** <the CTO fills this in>
