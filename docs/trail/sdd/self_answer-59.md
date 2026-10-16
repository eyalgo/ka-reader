# Self-answer report — `docs/SDD.md`

The record of one unattended run that met `docs/SDD_open_issues.md` in the CTO's seat on 2026-10-16
and decided its two items. It is for the owner, who reads it to learn what was decided and on what,
and for the `product-sdd` run that folds the answers.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v52, `Status:` Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-16
- **Sources re-read:** None. Every claim an answer rests on is inside this repository — the model's
  source, the bridge's exports, the Swift bridge, the FDR, the UXD, CONTENT and the SDD — and each
  was read at its own locator rather than taken from the item. Two measurements were made in a
  disposable clone of this repository at `ka-reader@a2b9389` (`git diff --stat 8ef8c5b a2b9389 --
  . ':!docs'` prints nothing, so the tree outside `docs/` is the one the items pin): (1) `cargo test
  --locked -p ka-reader-core --test watch` → 13 passed, `place_survives_mixed_delta ... ok`; `cargo
  test --locked -p ka-reader-bridge --test exports` → 11 passed. (2) A scratch test through the
  public API alone, written in the clone and removed with it: a folder `src` expanded over `a.rs`
  and a file `top.md` selected; both removed on disk and reported removed in one delta; then `src`
  recreated holding `b.rs` and `top.md` rewritten, both reported present. Output: before —
  `expanded(src)=true selected=Some("top.md") listing(src)=["a.rs"] root=["src","top.md"]`; after
  removal — `expanded(src)=true selected=Some("top.md") listing(src)=["a.rs"] root=[]`; a collapse
  of the gone `src` — `expanded(src)=true`; a select of the gone `top.md` — `selected=Some("top.md")`;
  `Select(None)` — `selected=None`; after return — `expanded(src)=true selected=Some("top.md")
  listing(src)=["a.rs"] root=["src","top.md"]` with the disk holding `b.rs`. The clone was removed
  afterwards (`rm -rf`, its own command).
- **What was read of the document:** `docs/SDD.md` is 8,522 lines and was not read whole. This run
  read the header (`:L1-L60`), § *Who decides what* (`:L103-L168`), § 3 the `watcher`,
  `folder-model`, `core-bridge`, `mac-shell` and `surfaces` rows (`:L356-L363`), SM-1 – SM-5 and
  SM-8 (`:L449-L456`), § 3 *What the system holds* (`:L467-L520`), § 4 C-E2 whole and its
  neighbours (`:L1140-L1175`), § 4 C-I1 whole, § 6 S-5 `follow-the-folder` whole (`:L2133-L2208`),
  RN-77 whole (`:L5565-L5600`), RN-89 (`:L6308-L6330`), RN-112's close, *Open Questions* whole
  (`:L8454-L8522`), and every line `grep -n` prints for `folder-model`, `SM-4`, `SM-5`, `C-E2`,
  `reading position`, `removed`, `renamed` and `recreat`. Of the inputs and neighbours:
  `docs/SRS.md` FR-27, FR-28, NFR-3, DR-2, DR-3 at their lines; `docs/UXD.md` UX-F3 (`:L158-L172`),
  UX-I2 – UX-I5 (`:L254-L262`), UX-S2's row; `docs/fdr.md` R-33, R-78, R-80 – R-82, R-85 and the
  scenario table (`:L380-L392`); `docs/CONTENT.md` § *Message patterns* → *Partial*'s folder
  sentence and the rule under it (`:L345-L362`); `docs/nfdr.md` every line printing `QC-47`,
  `expansion` or `selection`. Of the product: `crates/ka-reader-core/src/folder_model.rs:L1-L120`,
  `:L280-L530`, `:L600-L870`; `crates/ka-reader-core/tests/watch.rs:L1-L60`, `:L226-L310`;
  `crates/ka-reader-bridge/src/exports.rs:L50-L115`;
  `ka-reader-mac/Sources/KAReader/NativeBridge.swift:L1-L60`. The journey was read as an input and is
  cited in no answer: `system/projects/ka-reader/journey/shukuba/` holds no open station, and the
  tracking seed's folder holds the refine report and recommendations that raised these items.

## Items worked

### 5.1 — The collapse-and-scroll item says the model has no operation to set a reading position, and it now has one

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's *If a document has to be written* field carries a lean — what the fold would
  state and what it would not — so I weighed it as a draft rather than answering from scratch. It is
  the CTO's: the edit lands in *Open Questions* and in § 3's SM-4 and SM-5 rows, every one the CTO's
  column of § *Who decides what*, and it commits nothing to anyone outside the document. It is a
  correction, not a widening: the *Open Questions* sentence "SM-5 carries the operations those
  functions name and no others, so `follow-the-folder`'s `--test watch` has no operation to set a
  reading position with" was true when RN-77 wrote it and is false now, which I read at the source
  rather than from the item — `FolderModel::list_tree(TreeRequest)` and
  `FolderModel::select_file(FileRequest)` at `folder_model.rs:L631` and `:L654`, with `TreeRequest`'s
  three variants (`:L400-L408`), `FileRequest`'s three (`:L491-L499`) and `ReadingPosition`
  (`:L286`) — and ran: the watch suite's 13 cases pass in a fresh clone, `place_survives_mixed_delta`
  among them (header). The C ABI's state I read the same way: `exports.rs:L74` and `:L91` take
  `path: *const c_char` alone, `NativeBridge.swift:L26-L39` calls them with the path alone, and the
  exports suite passes 11 unedited, so no function joined SM-4's list. **The draft's conclusion holds
  and its argument is incomplete in one place**, which is the addition. It says SM-4's row "owes its
  description once that crossing is built". The item's own settlement clause says the first form "is
  written into SM-4's row when found", and it is found; and SM-4's row already describes calls ahead
  of their build with a build-state clause ("each exported from the build in which a change of its
  slice first builds it"), so writing the form in now, pinned at `ka-reader@8ef8c5b` with the C ABI
  taking the path alone, is the row's own style, not a claim that the crossing is built. The second
  addition is what the item leaves implicit: the fork the question held open — three forms, two of
  them re-cuts — is settled, since the form built moves no list, so no § 10 entry is owed and the
  item **narrows rather than closes**. I did not close it: the question is how a collapse and a scroll
  reach the model *across SM-4*, and SM-4 has not moved, so the honest state is the narrowed item,
  whose settlement is the first build in which the shell passes the arguments and `--test exports`
  still passes with ten. The third addition is SM-5's row, whose "the operations the functions name"
  now reads as the model's request types; the fourth is S-5's *Rests on*, which says the model holds
  the place "from this slice at the latest" and now holds it from `8ef8c5b`. **Against the settled
  record:** no *Delivers*, no seam, no part's *Must not own*, no slice order moves; C-R7's set
  equality and the § 10 rule for an eleventh call stand as written and are what the narrowed item
  points at; RN-77 stays as a dated record, as every RN does. **Failure paths:** *stale* — the pin
  goes stale when the shell's crossing lands, and the clause states a build state with a SHA like
  every other in § 3; *absent* — had `--test exports` shown an eleventh export the form would be the
  third and the answer a § 10 entry, and it shows ten; *refused* — if the reading position cannot
  ride `select_file` across the C ABI without a new call, the narrowed item's own rule sends it to
  § 10 before it is built; *empty*, *concurrent* — not reached by a documentary correction. **What
  was close:** closing the item outright. What would have tipped it is a built crossing; one does not
  exist, and a question closed ahead of its mechanism is the shape RN-77 refused.

### 5.2 — No document says what the held expansion and selection hold when the entry they name is removed

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** No draft — the item lists three forms and a fact about the tree, with no lean — so it is
  answered from scratch. **Seat:** the CTO's. The edit lands in § 3's `folder-model` row and in
  S-5's command half, both the CTO's column; it commits nothing outside the document; and I can name
  no ground I cannot see. It is **not** § 4 C-E2's, which is the CDO's column: C-E2 already binds the
  surface's half — "what is shown is the folder's current state or is marked as no longer there" —
  and what this item asks is what the *model holds*, which is § 3's. **It widens the document and
  cites an occurrence**, so it is answered and not "not until it occurs": the item cites the site in
  the product where the form is present as it stands — `folder_model.rs:L772` and `:L710-L739` — the
  first kind of occurrence the shukuba-refine prompt defines, and I re-read both and measured them.
  **The answer is the second form, bounded.** The place is the reader's acts, not a read; a delta
  carries it as it was (`:L405-L407`, `reduce` at `:L772`). When the entry an act names is removed,
  the act is kept, inert — drawn nowhere, because the parent's listing drops a removed name
  (`reduce_listing`, `:L795-L815`) — and binds again when an entry returns at that path. Measured:
  after the removal `expanded(src)=true`, `selected=Some("top.md")`, root `[]`; after the return
  both still hold and the root lists both again (header). **Why not the first form** (drop): the
  churn the slice exists for removes and recreates folders — a branch checkout, a build directory,
  an agent's rewrite — and a node that comes back collapsed is the refresh taking the reader's place,
  the exact *Violated by* of C-E2 and the sentence of `docs/fdr.md` R-78 and `docs/SRS.md` FR-27.
  **Why not the third** (keep and say it is gone): a tree row for an entry its parent's listing no
  longer carries is state the bridge did not send from a read — the `surfaces` row allows one
  exception and this would be a second — and UX-I4's "marked as no longer there" is already met
  where the observation occurs: `docs/CONTENT.md:L349-L359` gives the folder row listed and then
  found empty its sentence, for the window before the parent re-lists, and R-80 gives the open file
  its own; a held ghost row after the parent re-lists would add a third sentence nothing upstream
  asks for. **Consequence one is the reason the answer needs a clause and not a sentence.** The
  held *listing* under a removed folder is not the place, and the model as built keeps it: `reduce`
  touches only the listings whose folder a reported path's parent resolves to (`apply_delta`,
  `:L669-L705`), so a removed folder's own listing stays, and when the folder returns with different
  children the model answers the old ones — measured, `listing(src)=["a.rs"]` with `b.rs` on disk.
  Drawn under the returned, still-expanded folder, that is stale content presented as current, which
  R-81 and UX-I4 forbid and R-78 does not license. So the clause states the reducer's rule: an entry
  reported removed drops every held listing at and under its path — the listings, never the place —
  and an entry reported present at a path the place holds expanded is read in that same delta, so the
  folder returns fresh or `pending` and never old. Both are SM-5's own and move no seam. **Consequence
  two** is a bound, not a defect: `admit` refuses a path that does not resolve (`:L710-L714`), so
  `expand` and `collapse` of an absent path leave the flag as it is (measured: a collapse of the gone
  `src` leaves it expanded) — and no row is drawn for it, so no act of the reader's reaches it;
  `Select(None)` clears the selection (measured). **Against the settled record:** FR-27, R-78, R-82
  (only what changed changes), R-81, UX-I3, UX-I4 and NFR-3 all hold under the answer; the open
  file's own removal is R-80's and the `FileView` *gone* state's, which the item itself fences out;
  QC-47's wording is the Principal Architect's and does not move, since the answer adds a case and
  changes no rule it states — no companion is opened on the NFDR, and I record the doubt here rather
  than spend a cycle. **Failure paths:** *empty* — nothing expanded or selected holds nothing;
  *absent* — the root's own disappearance is not an entry under it and is not decided here, named as
  not reached; *stale* — a held flag outlives its entry without bound, costing one path per folder
  the reader expanded and never a read, which is bounded by the reader's own acts; *concurrent* — an
  entry reported removed and present in one coalesced delta is decided by the fresh read
  (`reduce_listing`'s own rule, `:L791`), and the place is untouched either way; *refused* — the
  admission refusal above, stated as a bound. One case named and not covered: an entry of another
  kind returning at the held path — a file where a folder was — leaves a folder flag on a file row;
  a surface draws expansion for folder rows only, so nothing is drawn from it, and the flag binds
  again when a folder is at that path. **What was close:** *raised upstream* to the CDO, had the
  answer needed a row for a gone entry; it does not, so C-E2 stays as written and no companion is
  opened.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
