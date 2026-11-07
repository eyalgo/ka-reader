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
> against the product at `ka-reader@71f9f69`, and found two § 3 statements the typed Markdown document
> made false. Both are in § 5 below; the SDD itself is not edited.

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 § 3's `MarkdownDocument` says every block holds inline nodes and names fenced code alone; neither holds at `ka-reader@71f9f69`
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the entry `read-markdown` (§ 6 S-3) and the panel's treatment read as the node shape is now false in two places.
- **Where it shows:** § 3 *What the system holds*, `MarkdownDocument` (`docs/SDD.md:L610-L616`): "heading with its level, paragraph, list with its items, quote, rule, fenced code with its language and spans — each holding inline nodes". In the core at `ka-reader@71f9f69` a heading and a paragraph hold inline nodes, a list item and a quote hold the block nodes inside them in source order (`crates/ka-reader-core/src/markdown_renderer.rs:L38-L49`: `items: Vec<Vec<Block>>`, `Quote(Vec<Block>)`), and code is "fenced or indented, with its language and spans (an indented block plain, with none)" (`:L50-L52`).
- **If a document has to be written:** none — the entry is re-stated.
- **Answer:** Re-state § 3's `MarkdownDocument` as the core builds it at `ka-reader@71f9f69`, the closed set unchanged: an ordered list of block nodes — a heading with its level and a paragraph each holding inline nodes (text, emphasis, code, image, link); a list with its kind (unordered, or ordered with its start) whose items each hold block nodes in source order; a quote holding block nodes in source order; a rule; and a code block, fenced or indented, with its language and the highlighter's spans over its text — a block in no floor language is plain and holds no spans, which is every indented block and any fence naming no floor language (`crates/ka-reader-core/src/markdown_renderer.rs:L35-L55`, `:L68-L73`; `crates/ka-reader-core/src/markdown_renderer/fold.rs:L219-L223`). The rest of the paragraph holds as written — an image node *resolved* or a *placeholder* with its four conditions, a link node *external* or *relative*, no markup, no URL the shell fetches, raw HTML a text node (`markdown_renderer.rs:L76-L133`). Carry the same correction to the `markdown-renderer` row's "fenced code with its language and `highlighter`'s spans" (`docs/SDD.md:L415`), the one other place the node shape is stated. `highlighter`'s row, the § 3 seam line and S-3's *Rests on* say "a fenced block" (`:L416`, `:L440`, `:L2097`) and stay true in substance — only a fence can name a language, so only a fenced block ever reaches the highlighter — the fold decides whether each wants a word. Nesting adds no kind: a list inside a quote inside a list is the same closed set, and an empty list or quote is a node holding no blocks. `cargo test --locked -p ka-reader-core --test markdown` passes on a fresh clone at `71f9f69` (5 passed), and nothing under `crates/` moved between that commit and `main` at `8547050`. Reasoning: `docs/trail/sdd/self_answer-80.md` § 5.1.

### 5.2 § 3's `read-only-harness` row is pinned before `checks/fixtures/hostile.md` landed, and the row does not name it
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the row says a file landing in `checks/` after its pin "owes this row an item", and this is that item.
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L421`), whose enumeration "is measured at `ka-reader@3431b7de250ddf37b8381bdf18d57f4db3a8d038` (2026-10-29) and pinned to it". `checks/fixtures/hostile.md`, the hostile Markdown corpus `--test markdown` runs over, was added at `ka-reader@602bb73` and is on `main` at `ka-reader@71f9f69`; the row's enumeration does not name it.
- **If a document has to be written:** none — the row is re-measured.
- **Answer:** Re-measure the row at `ka-reader@71f9f69` (2026-11-07), the merge that landed the corpus, and re-pin it there; nothing under `checks/` or `.github/` moved between that commit and `main` at `8547050`. One inexactness in the item: the row does name `fixtures/hostile.md` — under **Owed by a slice and not on disk at that commit**, as `read-markdown`'s (`docs/SDD.md:L421`, the cell's last sentence) — so the correction is a move, not an insertion: `fixtures/hostile.md` leaves the owed list and joins **On disk**, a file beside the fixture folders, read by `crates/ka-reader-core/tests/markdown.rs`, which the gate's *Test gate* step runs through `cargo test --workspace`; it is paired with no `checks/` suite, and § 6 S-3's command half names it. The same re-measurement finds what else landed in `checks/` since `3431b7d` that the row does not carry, each owing it by the row's own rule: `tree-scene.sh` and `tree-walk.sh` (scripts), `tests/test_tree_scene.sh` (a suite), `fixtures/tree-scene` and `fixtures/open-file-scene` (folders) — fifteen scripts, sixteen suites, fifteen fixture folders and one fixture file where the cell counts thirteen, fifteen and thirteen; `gate.sh` at 1.9.0 with 38 steps (`grep -c '^run_step' checks/gate.sh` prints 39), the five added being *Read-only, tree scene*, *Read-only, tree scene, killed*, *Displayed-file scene*, *Read-only, displayed-file scene* and *Tree scene helper suite*; the workflow still 41 lines (`git diff --stat 3431b7d 71f9f69 -- .github/workflows/ci.yml` prints nothing); and fifteen files the cell already names modified (`git diff --name-status 3431b7d 71f9f69 -- checks/`), so the cell's `:L` locators into `gate.sh` and the suites are re-read at the new pin, the row's own pattern. Whether the tree-scene files discharge the owed entry "the tree-only scene and watcher delivery proof (`follow-the-tree`, § 6 S-5)" is read off S-5 at the fold; this answer measures only that they are on disk. Reasoning: `docs/trail/sdd/self_answer-80.md` § 5.2.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
