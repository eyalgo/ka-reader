# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (NFDR v81, Settled; ADR-0001 – ADR-0025)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-07
- **Sources re-read:** None. No answer rests on a source outside this repository. Every code claim was measured in the tree at `ka-reader@09397d3`. `git diff --stat 98aaa71 09397d3 -- crates checks` prints nothing, so the item's pin and `main` agree. The files measured: `crates/ka-reader-core/src/folder_model.rs` (the `is_bitmap` import `:L18`, `contained_file` `:L251`, `asset_bytes` `:L278-L288` with `is_bitmap` at `:L284` and `read_contained_bytes` at `:L287`, `link_file` `:L305`, every `fs_reader::` call, the five `FolderContainment::new` sites, and `mod tests` at `:L1523-L1524` with no `asset_bytes` or `link_file` call in it), `src/fs_reader.rs:L704`, `src/markdown_renderer/references.rs:L35`, `tests/markdown.rs` (`check_of` `:L393-L395`, the `asset_bytes` and `link_file` tests from `:L410`), and `crates/ka-reader-bridge/src/session.rs` and `src/exports.rs`.
- **Liveness check:** the header's pointer reads *Companion to `adr/` and `nfdr.md`*, two bare names. Both sit beside the companion in `docs/`, so it is live.
- **What was read:** the whole companion. From NFDR v81: the header and version lines, QC-9, QC-10 whole (`:L431-L484`), QC-11's head, QC-68 whole (`:L1759-L1788`), and § 9's layer-2 row (`:L2496`), which places `--test markdown` at layer 2. From SDD v74 (Settled): the version line; § 2 *The four-layer default, declined by name* (`:L340-L402`) and *One read seam beside the decline* (`:L404-L449`); § 3's units paragraph (`:L515-L530`); the `core-bridge` row; the SM-1, SM-4, SM-5 and SM-7 rows; and RN-150 – RN-154. Also `docs/trail/sdd/self_answer-82.md`, which records why the CTO's run opened no item here and left QC-10's re-opening to this seat. The NFDR was not read whole (8,179 lines). It was read wherever the item and the raised change land, and the § 2 change names QC-10 as the one entry the SDD's move reaches. As input only, and cited in neither record: the open station `2026-11-06_a-markdown-file-reads-rendered`.
- **Scope:** one open item, § 3.1, with an **Answer** slot. No item list was given. The item is the Principal Architect's: the edit lands in `docs/nfdr.md`, and it binds only how faithfully QC-10 describes the code and the settled SDD. One item was raised on this companion (§ 2.1).

## Items worked

### 3.1 — QC-10 lists the model's reads, its edge into the renderer and what takes the check through the port, and `asset_bytes` and `link_file` are in none of the three

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** All three lists are corrected, and (b) goes past what the item names. **Check 1:** this seat's. The edit lands in QC-10 and commits no one outside the record. **Not widening:** the item reports three statements that the merge at `98aaa71` made incomplete, and it cites the code for each. That is a correction with an occurrence, so § *A widening item waits until it occurs* does not hold it. **Check 2:** each fact holds at `09397d3`. (a) `folder_model.rs:L18` imports `is_bitmap` from `markdown_renderer`, and `:L284` calls it after `contained_file` admits the path (`:L283`). (b) `:L11` imports `read_contained_bytes` and `:L287` calls it, defined at `fs_reader.rs:L704`. (c) `asset_bytes` and `link_file` take `&impl ContainmentCheck` and ask it through `contained_file` (`:L251`). The item answers a smaller question than (b) asks, though. QC-10's parenthetical names three reads, and the model calls nine: `open_root`, `list`, `read`, `observe_file`, `reobserve_file`, `observe_listing`, `locate`, `locate_parent` and `read_contained_bytes`. I counted fifteen `fs_reader::` calls by `grep`, and SDD v74's SM-1 cell gives the same count and the same locators. The list was six short before this merge, so the answer corrects the list rather than adding one name. **Check 3:** (a) agrees with SDD v74 § 3's units paragraph, which calls `is_bitmap` "still the one edge" (RN-152). The import set QC-10 allows does not change, so QC-11 and `checks/structure.sh` do not move. (c) agrees with SDD v74 SM-7: the bridge builds `FolderContainment` for both functions (`session.rs:L1114`, `:L1253`; RN-151). (b) collides with the change raised as § 2.1. SDD v74 moves the model's reads behind SM-1's trait, which rewrites the same sentence. So the answer points at SM-1's cell instead of listing the reads again, and asks the fold to take 3.1 (b) and 2.1 together. The two were decided together. **Check 4:** *Stale:* the line numbers are pinned at `98aaa71`, and `09397d3` has the same code. The list goes stale again when SM-1's trait is built, which is why the answer points at SM-1 rather than listing. *Empty:* bound (2)'s consequence, "a layer-1 test of any of them is handed `SeededContainment`", would make today's code break the bound if the functions already had layer-1 tests that build the real check. They do not. Their tests sit in `tests/markdown.rs`, which § 9 places at layer 2 "against the containment check", and `folder_model.rs`'s `mod tests` calls neither function. So the extension binds future layer-1 tests only. *Refused:* QC-10's review clause, "has the renderer, `fill_view` or `reduce_open_file` build its own check", has to name the two new functions too, or a change that makes `asset_bytes` build its own check would pass review. The answer includes that. I was close to *raised upstream* for (a) and decided against it, because SDD v74 already carries the statement. The NFDR is the record that is behind.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.1 — QC-10's setting-aside loses its ground for the model's reads: SDD v74 moved the decline paragraph its bound (3) rests on

- **What the document is owed:** QC-10's setting-aside of "a unit is given its collaborators through a trait" narrows to the building of `FolderContainment` in `folder-model`. The model's reads are stated as SM-1's trait, which is design at `98aaa71`, held by `development-design` review until a change builds it. Bounds (1) and (3) and the § 2 trace locator follow that narrowing. The fold also decides whether the reads port gets its one-fake, one-suite obligation now, as owed.
- **Why it is worth a cycle:** two grounds from § *The items are not the whole of what a document is owed* apply. *Something upstream moved and it has not seen it:* SDD v74 (Settled, 2026-11-07) changed § 2's decline. The decline's "for `folder-model`'s entry points: they call `fs-reader` and build `FolderContainment` themselves" now reads as the building of the walk alone, and a new paragraph, *One read seam beside the decline* (`docs/SDD.md:L404-L449`; RN-154), adds the read seam. *A fact in it is now false:* QC-10 says its setting-aside rests on that paragraph, and its own bound (3) says the setting-aside "loses its ground and is re-opened" when the paragraph moves (`docs/nfdr.md:L456`). The SDD names QC-10 as the one NFDR entry the move reaches, and names the re-opening as this seat's, on this companion (`docs/SDD.md:L441-L444`). The CTO's run opened nothing here and left the change to this round on purpose (`docs/trail/sdd/self_answer-82.md` § 5.5, check 3). No item raised it, and the § 3.1 answer touches the same sentence, so it is raised now and not left for a later cycle.

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
