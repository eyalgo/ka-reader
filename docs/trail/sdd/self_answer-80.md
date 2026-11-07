# Self-answer report — SDD

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v71, Settled; the companion was opened by the PM at `ka-reader@e6bdacc` with two items under § 5 *Raised from downstream*, both seated `cto`; the invocation listed no items, so both were this run's)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-07
- **Sources re-read:** None — no answer rests on a source outside this repository. Every claim was measured in the tree at `ka-reader@71f9f69`, the merge both items name, and checked unchanged to `main` at `8547050` (`git diff --stat 71f9f69 HEAD -- checks/ crates/ .github/` prints nothing): `crates/ka-reader-core/src/markdown_renderer.rs`, `markdown_renderer/fold.rs`, `tests/markdown.rs`; `checks/fixtures/hostile.md`; `checks/gate.sh`; `git ls-tree` of `checks/`, `checks/fixtures/` and `checks/tests/` at both the row's pin `3431b7d` and `71f9f69`. The SDD was read at § 3 (the `markdown-renderer`, `highlighter`, `surfaces` and `read-only-harness` rows, the seam line and *What the system holds*), § 4 C-D3, § 6 S-3 and RN-84; the open station `2026-11-06_a-markdown-file-reads-rendered` and the seed's refine report as inputs. The SRS and UXD were searched for "fenced", "indented" and "code block" and carry none of them, so no input fixes the code-block form. `cargo test --locked -p ka-reader-core --test markdown` was run on a disposable clone at `71f9f69`: 5 passed, 0 failed; the clone was removed.

## Items worked

### 5.1 — § 3's `MarkdownDocument` says every block holds inline nodes and names fenced code alone; neither holds at `ka-reader@71f9f69`

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Check 1 — mine: the edit lands in § 3 *What the system holds*, a CTO column; it binds nobody outside the document, commits no money, risk or outside party, and no ground is unseeable. Check 2 — a correction, not a widening: the paragraph states a shape ("each holding inline nodes", "fenced code") that the type contradicts, so § *A widening item waits until it occurs* does not apply, and the occurrence is the type itself. Both of the PM's points held on reading the source rather than the item: `Block::List { items: Vec<Vec<Block>> }` and `Block::Quote(Vec<Block>)` hold blocks, `Heading` and `Paragraph` hold `Vec<Inline>` (`markdown_renderer.rs:L38-L55`), and the renderer maps `CodeBlockKind::Indented` to `Language::Plain` alongside the fence's info string (`fold.rs:L219-L223`). Two things the item did not say that the paragraph must: a block in *no floor language* is plain with no spans — which covers an indented block **and** a fence whose info string names no floor language (the type's own comment, `:L50-L52`), so the item's "an indented block plain, with none" was the narrower statement; and the `markdown-renderer` row at `:L415` repeats "fenced code" and takes the same correction, which the item's *Where it shows* left out. Three further "fenced" lines (`:L416`, `:L440`, `:L2097`) were read and left to the fold's word choice because they are true in substance: only a fence can carry a language, so the highlighter never sees an indented block. Check 3 — nothing settled moves: the closed set, the no-markup / no-URL / raw-HTML-as-text clauses, the image and link node forms and § 4 C-D3's "the document is data" all stand; the SRS and UXD say nothing about fence versus indent; S-3's command half asserts kinds in the closed set and inert text, which the corrected shape keeps. 5.2 was decided after this item and does not touch it. Check 4 — *empty:* an empty list or quote is a node holding no blocks, and the sentence says so. *Absent:* a code block with no language is plain, no spans — stated. *Stale:* the answer is pinned to `71f9f69` and `crates/` is unchanged to `main`; the fold keeps the old words in a dated note, the paragraph's own pattern. *Concurrent:* none for a value type. *Refused:* none — rendering is total (`markdown_renderer.rs`, `render`'s comment: "it has no failure arm").

### 5.2 — § 3's `read-only-harness` row is pinned before `checks/fixtures/hostile.md` landed, and the row does not name it

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Check 1 — mine: § 3's `read-only-harness` row, a CTO column; the row itself says a file landing after its pin "owes this row an item", and this is that item. Check 2 — the item's heading is right and its supporting text is inexact: the row *does* name `fixtures/hostile.md`, in its closing **Owed by a slice and not on disk at that commit** list as `read-markdown`'s (`docs/SDD.md:L421`, the cell's last sentence; RN-84's third call put it there as a file). So the false statement is "not on disk", and the fix is a move from the owed list to the on-disk inventory — said in the answer, because a fold that only inserted the name would leave the owed entry standing. The item asked for the row to be re-measured, and a re-measurement is whole, so the answer carries everything the measurement found since `3431b7d` rather than the corpus alone: two scripts, one suite and two fixture folders the row does not name (`tree-scene.sh`, `tree-walk.sh`, `tests/test_tree_scene.sh`, `fixtures/tree-scene`, `fixtures/open-file-scene`), five gate steps (33 → 38, `gate.sh` 1.6.0 → 1.9.0), fifteen named files modified, and the workflow unchanged at 41 lines. These were **not** raised as a separate item under § *Raising a change on the companion you are answering*: they are the same edit to the same cell by the same seat that this item already asks for, and a second item would be the near-duplicate the skill warns against; the report records them here so the owner can see the item's scope grew. Check 3 — the row's rule and its on-disk / owed split are unchanged and are what the answer applies; `docs/nfdr.md` § 9's suite count is the NFDR's own and is not restated; whether the tree-scene files discharge the owed `follow-the-tree` entry is a reading of § 6 S-5 the fold makes, named as open in the answer rather than decided here. 5.1 was decided before this item and is untouched. Check 4 — *empty:* none — the tree is enumerated. *Absent:* the markdown test is paired with no `checks/` suite, said plainly so the fold does not invent one. *Stale:* the pin moves to `71f9f69`, `checks/` and `.github/` are unchanged to `main` at `8547050`, and every `:L` locator the cell carries into modified files is re-read at the fold, the row's own pattern since v26. *Concurrent:* a later file in `checks/` owes the row the next item, by the row's rule — unchanged. *Refused:* none.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
