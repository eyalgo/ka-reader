# Architecture open issues — KA-Reader

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the SRS, the SDD
> and the FDR.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-architecture`. It folds your answers into the records and drops the resolved items.
> When nothing is left open, `product-architecture` **deletes this file**: no file = the records are
> done.
>
> Your answers are never thrown away. Each time the Principal Architect folds them in, it first copies
> this file whole to `docs/trail/architecture/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 is raised, not asked.** These records bind every later change, so the seats that live under
> them find gaps the authoring run could not. § 3 is where such a seat says so, against both records
> — an ADR's binding and an NFDR obligation reach the same file.

> **No `product-architecture` run opened this companion. The PM opened it on 2026-09-25.**
> `nfdr.md` is Settled at v17, and the records had no companion on disk, so a `product-architecture`
> re-run would read them as done and find nothing to act on. The companion holds one item, § 3.1. It
> comes from measuring the tree on `main` at `ka-reader@46bb275`, the first commit where the shell draws
> `pending` items, against QC-4. That check's layer-4 half states something the product now does not
> do.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 QC-6 states the containment check on *the canonical path, symlinks resolved*, and the SDD it traces to now takes the canonical form only inside the grant, compares as spelled outside it, and refuses three spellings that may lead in

> **Raised while answering another document's companion.** No `product-architecture` run wrote
> this item. A `companion-self-answer` run answering `docs/fdr_open_issues.md` § 2.2 appended it on
> 2026-09-25, in the Principal PM's posture; its reasoning is `docs/trail/fdr/self_answer-6.md`
> § Companions opened. What prompted it: the SDD's § 3 `fs-reader` row moved at run 18
> (`ka-reader@4b9425b`, folding `docs/trail/sdd/cycle-15.md` § 5.1) **after** NFDR v17 landed
> (`ka-reader@18250d6`), so no Principal Architect run has read the definition QC-6 now disagrees with.
> SDD RN-71 and FDR RN-34 each name QC-6 as owed and neither opened an item, and
> `docs/trail/sdd/self_answer-26.md` § Companions opened deferred one until "the SDD's fold" existed —
> it does now. The records had this file as their one open channel, so the change is raised here.

- **Lands in:** `nfdr.md` QC-6 — the obligation (`docs/nfdr.md:L130-L134`), its *verified by*
  (`:L135-L139`) and its trace tag (`:L139-L140`). § 10's QC-6 row (`:L1086`) names commands only and
  need not move.
- **Drafted into the records:** nothing — the run that raised this writes no document. The lean, for
  the seat that folds it: QC-6's obligation reads the check as `docs/SDD.md` § 3 `fs-reader` now
  defines it (`:L322`) — after percent-decoding, the canonical form is taken at every position inside
  the granted folder and nothing is read at a position outside it, no `lstat` and no `realpath`; names
  outside are compared as spelled, and the walk re-enters the grant only on the folder's own name met
  from its parent, as spelled or in another letter case where the folder is not the root of its volume
  and that volume ignores letter case, both read from the folder itself, and as spelled wherever it
  cannot be sure; three spellings are refused as outside although they may lead in — more than one
  level out and back in another case, a Unicode-normalization difference, a granted folder that is its
  volume's root. The *verified by* gains layer-1 cases for the spellings `docs/fdr.md` R-183, R-184
  and the example rows at `:L357-L358` fix — `../<NAME>` on a case-folding volume re-entering, and each
  of the three refused. The trace adds FDR R-183, R-184 and `docs/trail/sdd/cycle-15.md` § 5.1.
- **Rationale:** QC-6 states a fact its source no longer states. "A canonical path, symlinks resolved
  and percent-decoding applied, is inside the granted folder or it is refused" was SDD § 3's wording at
  v13 (quoted at `docs/trail/sdd/cycle-15.md` § 5.1, *What it blocks*); at v20 the same row says the
  canonical form is taken only inside the grant and "at a position *outside* the grant nothing is
  read" (`docs/SDD.md:L322`). Read as written, QC-6 asks for the read § 4 C-D1 forbids and QC-35
  excludes, and its two fixtures — `..` and symlink-out — exercise none of the spellings the
  definition turns on. `docs/fdr.md` v9 carries the definition as R-183 and R-184 (`:L87-L88`),
  confirmed in the owner's seat at `docs/fdr_open_issues.md` § 2.2. The ground the two review notes
  gave for opening nothing — an input moving beneath the NFDR is that document's own rule to meet — is
  right about whose the change is and silent about how it reaches them: `nfdr.md` was Settled at v17
  with no item naming QC-6, and a settled record's re-run acts on its companion.
- **If overridden:** QC-6 keeps stating the check on the canonical path. The change that builds the
  as-spelled walk (`docs/trail/sdd/cycle-15.md` § 5.1 measured it at `ka-reader@46bb275`,
  `crates/ka-reader-core/src/fs_reader.rs:L170-L177`) then fails the obligation it is checked against
  while meeting the SDD and the FDR, and the QA seat has no NFDR line to derive the three refused
  spellings' bar from. If the Principal Architect's re-run walks the SDD's move and re-derives QC-6 on
  its own, *confirm* records that and costs nothing.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-4's layer-4 check expects the word *pending* on a pending item, and the shell draws no such word
- **Raised by:** PM — 2026-09-25
- **Which record:** `nfdr.md` § 1.1 QC-4, *verified by*, its layer-4 half (`docs/nfdr.md:L121-L122`),
  and its row in § 10's verification map (`docs/nfdr.md:L1084`).
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** the obligation's own check. As worded, it cannot pass. It reads "a projection
  with a `pending` item renders the word *pending* and no marker". At `ka-reader@46bb275` every
  sub-folder row arrives `pending`, and the shell draws each one with its name and glyph only.
  `ka-reader-mac/Tests/SurfacesTests/RootItemsViewTests.swift:L96-L115`
  (`testRepoProjectionDrawsNameAndGlyphOnly`) asserts that the only text a `pending` row draws is its
  name. The product's words for the pending state are CONTENT's *"Reading this folder."*
  (`docs/CONTENT.md:L302`, and UX-S2's loading row at `:L420`), not the word *pending*.
- **Where it shows:** QC-4's *verified by* clause. The obligation itself holds: no surface draws a
  marker, a count or a "nothing changed" from an item that is not `observed`. Only the check's
  wording is false.
- **If a document has to be written:** none. The drafted rewording is: "`swift test --package-path
  ka-reader-mac` (layer 4): a projection with a `pending` item draws no marker, no count and no
  empty-folder sentence, and where the surface gives the pending state words, they are CONTENT's
  *"Reading this folder."*"
- **Answer:** Confirmed, with additions — decided in the owner's seat by a `companion-self-answer`
  run; reasoning at `docs/trail/architecture/self_answer-18.md` § 3.1. The layer-4 half is false as
  stated, and the obligation holds. But the false clause is not this document's own: it is
  `docs/fdr.md` R-94's second clause, "the surface shows the word *pending*" (`:L176`), which QC-4
  traces to, and `docs/DESIGN.md` § Do's says the same (`:L744-L746`) — while `docs/CONTENT.md`
  § Message patterns *Loading* fixes *"Reading this folder."* (`:L314`; the item's `:L302` and
  `:L420` held at `ka-reader@4c59262` and moved when CONTENT reached v7 at `ka-reader@1c95030`). So the
  check verifies neither word. QC-4's obligation is the negative, and which words a surface shows
  is already QC-53's (every message a catalogue sentence, `docs/CONTENT.md`'s) and FDR R-88's ("the
  wording standard is `docs/CONTENT.md`'s", `:L170`). The layer-4 half reads: "`swift test
  --package-path ka-reader-mac` (layer 4): a projection with a `pending` item draws no marker, no count
  and no empty-folder sentence, and the only words it may carry for the state are the *Loading*
  sentence `docs/CONTENT.md` § Message patterns fixes — by pointer, never copied here." The drafted
  first clause is kept as drafted; the drafted second clause, which copied CONTENT's sentence into
  this document, is replaced — a string is CONTENT's to hold, and a check that copies it goes false
  the day CONTENT re-words it. At `ka-reader@46bb275` the check passes on
  `ka-reader-mac/Tests/SurfacesTests/RootItemsViewTests.swift:L96-L115` as it stands, and rows do not
  expand there (`ka-reader-mac/Sources/Surfaces/RootItemsView.swift:L147-L149`), so no surface yet
  exists for the sentence; the pointer covers the day one does. The same fold moves one line the
  item did not cite: the layer table's row 4 (`docs/nfdr.md:L888`) says "*pending* as the word" and
  reads instead "nothing drawn from `pending` but the entry's name, its glyph and CONTENT's *Loading*
  sentence". § 10's QC-4 row (`:L1084`) names commands only and does not move. QC-4's trace to R-94
  stays, since R-94's first clause is the obligation. Which word R-94 means — the state or the
  string — is the FDR's seat's and is raised at `docs/fdr_open_issues.md` § 2.1; the same string in
  `docs/DESIGN.md` is raised at `docs/DESIGN_open_issues.md` § 2.1. This answer is built on R-88's
  reading; if the FDR's seat answers that R-94 is literal, the word comes back to this check on a
  fresh item.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
