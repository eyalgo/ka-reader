# Self-answer report — DESIGN.md

## Header

- **Companion:** `docs/DESIGN_open_issues.md`
- **Document:** `docs/DESIGN.md` (Settled, v5)
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-01

## Items worked

### 2.1 — Every trail pointer in this document is dead — the folders moved and the citations did not

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** The drafted rule is right and, unlike the PRD's item, its count of this document is
  right; what it did not do is prove that the rule is safe on the six `uxd_trail` citations, which
  the SRS run found it is not on that document. Here it is, and the proof is the addition.

  **Check 1.** The edit lands in `docs/DESIGN.md`, the CDO's own document, and binds nobody
  outside it — no person, no outside party, no risk anyone carries. Yours, in the owner's seat.
  The item's closing sentence leaves *how* the repair is done — one sweep or six cycles — to the
  owner; the slot decides whether this document's pointers are repaired and to what, not the
  mechanism, which is the reading the PRD and SRS runs took (`docs/trail/prd/self_answer-1.md`
  § 2.1, `docs/trail/srs/self_answer-1.md` § 2.2) and check 3 keeps consistent with them.

  **Check 2 — the measurement, re-done on this document.** `grep -o 'docs/[a-z]*_trail/'` gives
  30 and `grep -o '[a-z]*_trail/'` gives 30, so there is no bare-form citation the `docs/`-prefixed
  pattern misses; `grep -oE '@[0-9a-f]{6,}:docs/[a-z]*_trail/'` gives 0, so no pinned citation has
  to be protected. Seven distinct files are cited — `design_trail/cycle-{1,2,3,4}.md`,
  `prd_trail/cycle-10.md`, `uxd_trail/cycle-{1,2}.md` — and every one exists at
  `docs/trail/<x>/`. Beyond existence, every one of the seventeen `§ n.m` sections this document
  attributes to those files was opened and carries a heading matching what the citing sentence
  says it holds — design cycle-1 §§ 1.1, 2.1, 2.2, 2.3, 2.5, 2.7; cycle-2 §§ 1.1, 1.3; cycle-3
  §§ 1.1, 1.2; cycle-4 §§ 1.1, 1.2; prd cycle-10 § 2.2; uxd cycle-1 §§ 2.1, 2.5, 2.6; uxd cycle-2
  § 1.1 — checked one by one on 2026-09-01.

  **The addition — the `uxd_trail` provenance, which the draft did not check.** The SRS run found
  that a `docs/uxd_trail/cycle-N.md` citation can point at the UXD removed at `nozoki@9017ae2`
  (2026-08-14), whose cycle files differ from the re-authored UXD's under the same name, so the
  mechanical rule would send a reader to the wrong answer (`docs/trail/srs/self_answer-1.md`
  § 2.2). That hazard is real for any document that predates the removal. This one does not:
  `git log -- docs/DESIGN.md` puts v1 at `nozoki@e1e54f6` on 2026-08-26, authored *"off UXD v2"*
  by its own subject line, twelve days after the removal. The old cycle-1 at `1d5c553` carries only
  § 2.1 and § 2.2; this document cites cycle-1 § 2.5 (the initial theme) and § 2.6 (the Markdown
  link), which exist only in the re-authored file added at `nozoki@7505e1b`. The old cycle-2's § 1
  has no items; this document cites cycle-2 § 1.1 (the theme control's home) and pins it itself to
  `nozoki@f4bc928`, the commit that added the re-authored cycle-2. So all six `uxd_trail`
  citations resolve correctly under the drafted rule, and none is repaired by hand. That the draft
  reached the right rule without this check is why the verdict carries an addition rather than a
  plain confirm: a sweep that took this document's item as its licence for the SRS's would have
  written three false citations there.

  **The item's cross-document figures are stale, and are reported rather than edited.** The
  repo-wide count moved from 235 to 295 once the PRD's bare form was counted
  (`docs/trail/prd/self_answer-1.md` § 2.1), and three documents have since been repaired — PRD at
  `nozoki@2d8c99d`, SRS at `nozoki@82c199a`, UXD at `nozoki@05eac42`. Measured today with
  `grep -o '[a-z]*_trail/'` per document: DESIGN 30, SDD 40, CONTENT 12 — 82 unpinned across the
  three documents whose fold has not run — and residual mentions in the three that have: PRD 2,
  SRS 7 (2 pinned), UXD 6 (5 pinned). Why those residuals stand is each document's own version line
  to state; I did not open them, and this document's repair does not depend on them.

  **What the fold owes that no item says.** The writing bar's § 1.6 requires a change to a settled
  statement to be recorded in the document with the reason that authorized it
  (`system/doctrine/writing_bar.md` § 1.6), and this document records changes on its version line
  (`docs/DESIGN.md:302`) — the slot names `nozoki@1e8bf3d` as that reason so the fold has it in
  hand. The version line itself is one of the 30 (`docs/design_trail/cycle-4.md`), so it moves
  twice in one revision: its pointer and its record.

  **Check 3.** Nothing this document states changes — only where it points. The answer agrees
  with the three sibling answers already filled (UXD § 2.1, PRD § 2.1, SRS § 2.2: same rule, same
  pinned exception, same reading of the owner's *how*). Against what moved upstream since v5: UXD
  v7 counts the layout reference at seven images instead of four
  (`git diff 05eac42^ 05eac42 -- docs/UXD.md`) and this document never states that count — it
  names `docs/ux_reference/` and cites the README's sections (`docs/DESIGN.md:477`, `:604`,
  `:774`, `:877`) — so nothing here went false; PRD v12's diff carries no line outside its trail
  citations; SRS v9's NFR-11 bounds a diagnostic log, which this document has no rule about — its
  three uses of *diagnostic* (`:923`, `:998`, `:1018`) are the linter's, not a log's. RN-25 and
  RN-26 cite `docs/UXD.md` v5 and v6 as the version that settled a thing, which stays true at v7.

  **Check 4.** *Absent:* every target and every cited section exists (above), so the rule reaches
  a real file in all 30 cases. *Stale:* the pointers went dead because a folder moved and the
  citing documents were not in the sweep; a citation form that survives a second move is a
  convention for the seat that owns `kensaiapp_structure.md` § *A trail is not the document's
  sibling*, not a DESIGN item — named, not covered, as the PRD and SRS runs also found.
  *Concurrent:* if the owner runs one sweep across the remaining documents before re-running
  `product-design`, the fold meets a document already repaired and this item becomes a no-op; if
  the fold runs first, the drafted rule repairs all 30 correctly, since there is no pinned form and
  no bare form to mishandle. Either order lands the same text. *The gate:* the fold ends in the
  pinned `npx @google/design.md@0.4.0 lint` (RN-21); the repair moves no token, colour, type,
  spacing or radius value, so the counts RN-21 records are expected unchanged, and a run whose
  machine has no `npx` on PATH stops before committing, by the launcher's own precondition
  (`<CORE>/launchers/product-design/launcher.sh` § *THE NPX PRECONDITION*). *Refused:* nothing
  here asks anyone anything.

  **What I was close to deciding differently:** a plain *confirmed*. The draft's rule, count and
  exclusion are all right for this document, and the addition changes no character of the repair.
  What tipped it is that the addition is the one check a person doing the sweep would skip and
  the one that bit a sibling: recording that it was done, and why it came out clean, is what makes
  the next reader trust the six `uxd_trail` repairs without redoing the archaeology.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/DESIGN.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-design/launcher.sh nozoki`
