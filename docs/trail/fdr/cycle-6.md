# FDR open issues — KA-Reader

> Companion to `fdr.md`. The Principal PM authored the FDR non-interactively; this file holds what the
> run could not settle from its inputs — the PRD, the SRS and the SDD.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-fdr`. It folds your answers into the FDR and drops the resolved items. When nothing is
> left open, `product-fdr` **deletes this file**: no file = the FDR is done.
>
> Your answers are never thrown away. Each time the Principal PM folds them in, it first copies this
> file whole to `docs/trail/fdr/` — so what you decided, and why, stays readable and citable for good.
>
> **§ 3 is the odd one, and worth reading twice.** The Principal PM writes the FDR *and* is the seat
> most likely to raise an item against it later, cutting the same product's documents into seeds. The
> two are different acts at different times, and § 3 keeps the later one visible instead of letting
> it be quietly folded back into § 1 as though the authoring run had asked it.

> **How this companion came to exist.** No `product-fdr` run opened it. A `companion-self-answer`
> run answering `docs/architecture_open_issues.md` § 3.1 opened it on 2026-09-25 (`ka-reader@80c222e`),
> in the Principal Architect's posture: `fdr.md` was Settled at v8 with no companion on disk, so
> without this file a `product-fdr` re-run would have read it as done. It held one item, § 2.1 — a
> clause of R-94 that the NFDR's QC-4 check was verifying word for word, found while that check was
> being corrected; the reasoning is `docs/trail/architecture/self_answer-18.md`. **The first
> `product-fdr` run after it — v9, 2026-09-25 — left § 2.1 as raised** (the re-run rule: R-94's one
> source did not move, so no rule moves on this seat's own preference) **and raised § 2.2**, on the
> SDD's move from v13 Draft to v20 Settled beneath this document and what the fold drafted. Both
> slots are yours.

---

## 1. Open issues — behavioural questions with no answer yet

None.

## 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override

### 2.1 R-94 says the surface shows *the word pending*, and the wording standard the FDR itself names fixes a different sentence for that state
- **Drafted into the FDR:** nothing — the run that raised this writes no document. The lean, for the
  seat that folds it: R-94's second clause names the state and not a string, and reads so — "where
  the product does not yet know, the surface shows that it is pending, in the words
  `docs/CONTENT.md` § Message patterns *Loading* fixes, and no spinner or progress bar is drawn."
  R-19 and R-32 already say it that way ("shows that it is pending", `docs/fdr.md:L61`, `:L82`).
  *(v9, 2026-09-25: R-94 stands as written. Its one source, SDD § 4 C-E1, did not move between v8
  and v20 — no hunk falls on it (`git diff 5003426 HEAD -- docs/SDD.md`) — and the re-run rule lets
  no settled rule move on this seat's own preference; the lean above is what a* confirm *writes into
  R-94, and the fold re-reads the entries that name the state beside it — R-19, R-32, R-157 and the
  example rows. The sibling move that bears on it: `docs/DESIGN.md` v10 handed the word to
  `docs/CONTENT.md` on both its lines (its RN-30), so R-94 is now the one line in the definition set
  naming the string — FDR RN-14.)*
- **Rationale:** R-88 makes `docs/CONTENT.md` the wording standard for every message the product
  writes (`docs/fdr.md:L170`). CONTENT § Message patterns *Loading* gives the pending folder
  *"Reading this folder."* (`docs/CONTENT.md:L314`; UX-S2's loading row at `:L492`), and its RN-4
  records why *pending* was not the word — it named the tool's state rather than what it was doing
  (`:L547-L554`). SDD C-E1, which R-94 traces to, says "the surface shows pending" with no "the
  word" (`docs/SDD.md:L823-L830`). So R-94 (`docs/fdr.md:L176`) is the one FDR line that names a
  string, and it names one the standard it defers to does not fix. The NFDR was verifying that
  string — QC-4's layer-4 check (`docs/nfdr.md:L121-L123`) — and is being corrected to verify no
  word at all, on `docs/architecture_open_issues.md` § 3.1. That correction is built on the reading
  above; this item is where the FDR's seat says whether the reading is right.
- **If overridden:** if R-94 is literal, CONTENT § Loading and UX-S2's loading row
  (`docs/UXD.md:L237`) cannot both hold beside it, and the product does not deliver it: at
  `ka-reader@46bb275` a `pending` row draws its name and glyph and no word
  (`ka-reader-mac/Sources/Surfaces/RootItemsView.swift:L161-L170`;
  `ka-reader-mac/Tests/SurfacesTests/RootItemsViewTests.swift:L96-L115`). That is then a behaviour
  gap to route as a change, and the NFDR's QC-4 check takes the word back on a fresh item.
- **Confirm or override:** confirm, with two additions — decided in the owner's seat by a `companion-self-answer` run; reasoning at `docs/trail/fdr/self_answer-6.md` § 2.1. The lean holds: R-94's second clause names the state, as its one source does (SDD § 4 C-E1, "the surface shows pending", `docs/SDD.md:L825`) and as R-19, R-32 and R-157 already do, and the words are `docs/CONTENT.md`'s by R-88 (`docs/fdr.md:L172`) — so R-94 reads "the surface shows that it is pending, in the words `docs/CONTENT.md` § Message patterns *Loading* fixes, and no spinner or progress bar is drawn". Addition one: the pointer is to the whole *Loading* pattern — its formula, *Reading* + the thing being read (`docs/CONTENT.md:L307-L308`) — not to the one example the item quotes, so it covers every surface R-94 reaches: the Git view (R-19; *"Reading Git status."*, `:L313`), a tree folder (R-32; *"Reading this folder."*, `:L314`) and the reading panel (R-157; *"Reading this file."*, `:L277`). Addition two — the concurrent case: this fold and `docs/nfdr.md` QC-4's (`docs/architecture_open_issues.md` § 3.1, answered, awaiting `product-architecture`) may land in either order and converge, because the corrected layer-4 check points at CONTENT's *Loading* sentence and keeps its trace to R-94's first clause; neither order leaves a reader holding the word. The example rows at `docs/fdr.md:L347` and `:L363` are state language already and do not move.

### 2.2 The SDD moved from v13 to v20 beneath this document and stands Settled; this run folded what the move reached — two rules added, the header line moved — and every other SDD-sourced entry was opened and holds
- **Drafted into the FDR:** R-183 and R-184, two example rows, and the header's `Inputs read:` line
  reading `SDD Settled`. R-183 states what *inside the viewed folder* means wherever R-34, R-59,
  R-61, R-62, R-151 and R-160 say it of a target — established while reading nothing outside the
  folder (R-101): a path outside the folder is compared as spelled, nothing about it is looked up,
  and it counts as back inside only on the folder's own name met from its parent, as spelled or in
  another letter case where the folder is not the root of its volume and that volume ignores letter
  case. R-184 names the three spellings presented as outside although their target may lie inside —
  more than one level out and back in another case, a Unicode-normalization difference, a viewed
  folder that is the root of its volume — and what each surface shows for them: R-34's entry that
  cannot be read, R-59's placeholder, R-62's link that does nothing, each marked as outside the
  folder in the sentence R-88's standard fixes, a mark that for these three is not where the target
  lies. No rule, product decision or exclusion changes its wording. RN-14, RN-17 and RN-18 carry a
  v9 re-read, and RN-34 records the move whole — what moved, the two rules, every entry opened
  against v20 with the diff's hunk list as the proof, and what lands as no rule.
- **Rationale:** The re-run rule: an upstream document that changed under a settled FDR is a
  legitimate source of a delta and a finding — fold what the change requires and surface the change
  itself with what it moved (`<CORE>/prompts/principal_pm_create_fdr.md` § *On a re-run*). The SDD
  moved six times, runs 13 – 18 (`git diff --stat 5003426 HEAD -- docs/SDD.md`: 550 insertions,
  78 deletions, 2026-09-25). One move reaches behaviour: the owner's answer at
  `docs/trail/sdd/cycle-15.md` § 5.1 defined the containment check as comparing spellings outside
  the grant and never canonicalizing there, named the three spellings that stay refused although
  they may lead in, and accepted that their row sentence is wrong about where the link leads —
  C-D1 winning (`docs/SDD.md` § 3 `fs-reader`; § 4 C-D1, C-E4; SDD RN-71, RN-72). A stranger meets
  that: a link a case-folding volume would resolve inside is marked as outside. R-34 read alone — a
  target *inside* is read as its target — would have a builder or the QA seat file that as a defect,
  and the Product Owner would check a change against a rule the SDD contradicts. Two rules rather
  than a reworded R-34, because the SDD adds a definition and three cases and reverses no sentence
  of R-34: its *inside* is R-183's, and it stays true as written. The mark's words are
  `docs/CONTENT.md`'s by R-88 and are pointed at, never copied — CONTENT v7 carries the one outside
  sentence (its § Message patterns *Partial*). Everything else the move touched is structure,
  process or the route (RN-34, part 3), re-walked under RN-13's list with the same result. The
  `Inputs read:` line is the stale case RN-33 asked to be walked: `product-sdd` folded § 2.3 at v14
  (SDD RN-64) and the fold reached no entry here (RN-18).
- **If overridden:** (a) *Fold R-183 and R-184 into R-34 instead* — R-34's wording moves, and every
  downstream citation of it (`docs/nfdr.md` QC-6; `docs/CONTENT.md` § Message patterns *Partial*)
  reads a changed rule; nothing else moves. (b) *Do not state the three spellings* — the FDR then
  contradicts the SDD and the built reader (`docs/trail/sdd/cycle-15.md` § 5.1 measured
  `Failed(Outside)` on the two-level case), and the next bar written from R-34 fails as written.
  (c) *A site the fold missed* — name it; RN-34 lists every entry opened and the hunks the diff
  holds, so a miss is one the walk did not reach and lands as a further delta under the same rule.
  Either way `docs/nfdr.md` QC-6 is owed the Principal Architect's re-derivation — named by SDD
  RN-71 and by RN-34, and raised on no companion by either, an input moving beneath the NFDR being
  that document's own rule to meet.
- **Confirm or override:** confirm, with one addition — decided in the owner's seat by a `companion-self-answer` run; reasoning at `docs/trail/fdr/self_answer-6.md` § 2.2. The fold holds as applied: R-183 and R-184 say what `docs/SDD.md` v20 § 3 `fs-reader` says (`:L322`) and what the owner set at `docs/trail/sdd/cycle-15.md` § 5.1; two rules rather than a reworded R-34 is right, because R-34's *inside* and *outside* are R-183's and no downstream citation of R-34 reads a changed rule; the two example rows exercise the four spellings; `Inputs read: SDD Settled` is true (`docs/SDD.md:L3`). The addition — the absent case: where the product cannot establish that the volume ignores letter case, or that the folder is not its volume's root, the SDD compares as spelled ("as spelled wherever it cannot be sure", `:L322`); R-183's *only* already yields that — an unestablished condition means the other-case name does not count as back inside — and R-183 gains the clause "and as spelled wherever the product cannot establish either" so the QA seat does not read it as a gap. Not reopened: that the three spellings' mark is wrong about where the link leads is the owner's call at cycle-15 § 5.1. What this fold leaves out of date and this document does not carry — `docs/nfdr.md` QC-6 — is now raised at `docs/architecture_open_issues.md` § 2.1 (`ka-reader@9cfb727`): SDD run 18 (`ka-reader@4b9425b`) landed after NFDR v17 (`ka-reader@18250d6`), so no item carried it; RN-34's sentence that none is opened here may record that one now is.

## 3. Raised from downstream — an item raised against the FDR after it settled

None.
