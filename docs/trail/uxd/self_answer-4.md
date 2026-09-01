# Self-answer report — UXD.md

## Header

- **Companion:** /Users/eyalgolan/products/nozoki/docs/UXD_open_issues.md
- **Document:** `docs/UXD.md` — the UXD, Draft at v9
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-01

Read whole before the item was decided: the companion; `docs/UXD.md` (v9, all 909 lines); and,
as the item names them, `docs/UXD.md` RN-25, RN-27 and RN-29; `docs/DESIGN.md` (v7) § Overview,
`{components.path-line}` and RN-27, with its live companion `docs/DESIGN_open_issues.md` § 2.1 and
`docs/trail/design/self_answer-2.md`; `docs/fdr.md` (v1) RN-14 and § Out of scope; `docs/PRD.md`
(v12) § Purpose, § Key Use Cases, § UX Notes, § Scope (In), § Out of Scope, § Data & Privacy,
with the owner's fold record `docs/trail/prd/cycle-10.md` § 2.1; `docs/CONTENT.md` (v6)
§ Terminology; `system/projects/nozoki/agari.md`; `system/doctrine/writing_bar.md` § 1.2;
`docs/SDD.md` for the term it already uses for the panel's path (`:235`, `:264`, `:768`:
*folder-relative*). Every `repositor*` in the UXD was re-measured on v9
(`grep -n -i repositor docs/UXD.md`, 2026-09-01) and each occurrence classified — the input,
Git state, a PRD or Agari quotation, or a review-note record.

## Items worked

### 2.2 — Five body entries still say *repository* where RN-25 says the document now says *folder* — § 2's two dials, § 4's path line, UX-I4, UX-I7 / UX-I9, and § 10's start sentence

- **Bucket:** 2. Choices to confirm — the CDO drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** Confirmed: the five places read *folder*, the path line *folder-relative*, and RN-25's
  moved list grows by them. The item's "draft" is a finding with a lean, so what was weighed is
  the lean and its grounds, and every ground was opened and holds: RN-25 does say *"every place
  this document said 'repository' where it meant the input now says 'folder'"* and lists what
  moved and what stays (`docs/UXD.md:784-804`); the five are in neither list; `docs/DESIGN.md`
  keeps *"Density is the repository's"* (`:340`) and *"repository-relative path"* (`:625`)
  *because* the UXD reads so (its RN-27, `:1044-1045`); `docs/fdr.md` RN-14 treated the DESIGN
  residue as *"a stale sibling … the CDO's to revise"*; the writing bar binds one name per term
  (`system/doctrine/writing_bar.md` § 1.2).

  **Check 1.** The edit lands in `docs/UXD.md`, this seat's document; the answer binds no
  person, party, money or risk — only this document's agreement with its own RN-25 and with
  three siblings on one word; and no unseeable ground could be named. Yours, in the owner's seat.
  Part of the answer belongs to another seat — the PRD's matching sentences — and that part is
  raised there (below), which is check 1's second outcome applied to one consequence, not to the
  item.

  **Check 2 — three additions.** *(a) The draft answers a smaller question than the item asks.*
  The heading's question is whether RN-25's *"every place"* is true; the item measured five
  places on v8 and stopped. Read whole on v9, three more body places name the input
  *repository* and sit in neither RN-25 list: UX-F3's closing sentence *"leaves certain the
  repository is exactly as they found it"* (`:173` — a sentence about the folder being untouched,
  not about Git state; RN-25 moved *"UX-F3's subject"* and left this line), UX-S2's Empty cell
  *"A repository with no files"* (`:237` — § 6's preface says every cell not naming the plain
  folder holds for both inputs, and this cell's own word narrows it), and § 10's terminus line
  *"the v1 cut plus diffs, commit history, and repository switching"* (`:428` — a claim about
  the Agari, which reads *"switching the viewed folder without restarting"* and says that is
  *"the same word the PRD uses for it"*, `system/projects/nozoki/agari.md:23-26`; a claim about
  another file that the file does not say). Eight places, not five. *(b) The doubt is settled by
  a rule the item did not reach for.* The item left open whether any of the five is *"a
  deliberate mirror of the PRD"*, to be decided at the fold. The test is not whether the PRD's
  sentence has moved but what the sentence is about: `docs/CONTENT.md` § Terminology fixes
  *folder* for *"the thing Nozoki is pointed at"* and *repository* for *"a folder that is the
  root of a Git repository, and the Git state Nozoki reads from it"* (`:154-155`), and elsewhere
  *repository* only *"where Git's own state is what the sentence is about"* (`:185`). RN-25's
  keep-list — UX-U1, UX-U2 — passes that test on its own terms: those entries describe the
  developer's situation, and the PRD's fold kept exactly the sections that do (*"The Problem
  Statement, Why This and Target Users keep their repository-shaped wording"*,
  `docs/trail/prd/cycle-10.md` § 2.1). The eight places are product rules — motion, density,
  the path shown, the view never lies, no write path, own state, leaving certain, the empty tree,
  the terminus — and each holds for a plain folder, which PRD Key Use Case 4 makes a full
  input (*"browses and reads it exactly as in case 1"*, `docs/PRD.md:149-152`). So they read
  *folder* whether or not the PRD's own sentences do; *folder* includes *repository*, and no
  rule becomes false either way. What stays, and why, is named in the slot so the fold does not
  over-apply the rename: UX-F2's *"short repository status"* is the PRD's own feature name
  (`docs/PRD.md:171`) and is Git state; UX-S3, UX-S6, UX-F4 and UX-I17 report Git state; review
  notes RN-2, RN-15, RN-22 and RN-23 are records of decisions in the words they were made in and
  do not move. *(c) The supporting text's line numbers are v8's.* At v9 (`nozoki@b8010dd`) the
  eight sit at `:41-42`, `:101`, `:173`, `:237`, `:256`, `:267`, `:276`, `:428`, `:447`. Reported
  here and in the slot, not corrected in the item.

  **Check 3.** The answer agrees with every settled thing it touches: PRD v12 § Purpose (*"a
  reader of folders, files and repositories — the three named flat"*, `:36-37`) and Key Use Case
  4; the Agari's terminus; CONTENT v6 § Terminology; the UXD's own RN-25, RN-26 and RN-27; the
  DESIGN companion's answered § 2.1, which already says the two DESIGN phrases follow this fold
  on the *upstream UXD change* authorization; and the SDD, which already calls the panel's path
  *folder-relative* (`docs/SDD.md:235`, `:264`, `:768`) — so the rename here closes a gap between
  the UXD and the document downstream of it, rather than opening one. The one place check 3
  found the answer reaching outside this document is the PRD: its § UX Notes "The character"
  (`:191`, `:194`), "The path" 5 (`:228`), the *view never lies* rule (`:230`), § Scope (In)'s
  full ambition (`:298`) and § Out of Scope "Editing, permanently" (`:305`) carry the same
  residue, in neither its v11 keep-list nor its widened lines (`:130`, `:152`, `:174`, `:250`,
  `:281`, `:328`), and `:298` contradicts the PRD's own `:326-328` and the Agari. That is *"a
  fact in it is now false"* and *"it contradicts a document it must agree with"* — raised on the
  PRD's companion (below), with the doubt stated there that "The character" may be read as the
  driving scenario's voice. It does not gate this item: the UXD's wording is right by the
  CONTENT rule regardless of the PRD's answer.

  **Check 4.** *Empty* — a plain folder with no files: UX-S2's cell now covers it by its own word
  rather than by the preface's rule. *Absent* — a repository that stops being one mid-session
  (UX-I17's live transition): every renamed sentence stays true through the transition, which
  *repository* did not. *Stale* — DESIGN's two quoted phrases go stale on the fold; their route
  is already stated in DESIGN's own companion. *Concurrent* — the PRD's fold and the UXD's fold
  may land in either order, or the PRD's may never come: the UXD's *folder* is wider than the
  PRD's *repository*, so neither order produces a contradiction. *Refused* — override: the eight
  stand, RN-25's keep-list names them, DESIGN keeps its two phrases; the item's own *If
  overridden* holds, extended to the three added places.

  **What I was close to deciding differently:** *confirmed* as it stood, five places. What
  tipped it is that the heading asks whether *"every place"* is true, and a confirm that left
  three more places unnamed would send the fold to fix five and leave RN-25's sentence false by
  three — the same defect one size smaller. The second close call was leaving the PRD alone: the
  cost is a `product-prd` cycle on a Settled document for six words. What tipped it is `:298`,
  which contradicts the PRD's own § Out of Scope and the Agari — not taste, a false fact — and
  the prompt's own rule that where unsure the answer is to raise it with the doubt in the why.

## Left for the owner

None this run.

## Skipped

None this run. The companion carries one item and one slot; the item was open and is answered.

## Companions opened

- **`docs/PRD_open_issues.md`** — **opened** — companion to `PRD.md`, landed in commit `70abec1`

`docs/PRD.md` was Settled at v12 with no companion, so it had no channel for the change. The
file was written from `<CORE>/templates/product-templates/prd_open_issues_template.md`, named
after the document, carries one item in *choices to confirm* with its slot at the placeholder
and a provenance blockquote saying this run opened it, and was committed and checked before the
UXD slot that names it was written. `docs/DESIGN.md`'s live companion was not touched: its § 2.1
answer already states that its two phrases follow the UXD's fold, and a second item there would
be the near-duplicate the skill forbids. `docs/CONTENT.md` (Settled, no companion) is owed
nothing by this item: its § Terminology is the rule applied here, and its own strings already say
*folder* for the input (`:197`). Nothing was raised on the UXD beyond the answer: the three added
places sit inside the item's own question and are carried in its slot.

## Launchers owed

- **`docs/UXD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-uxd/launcher.sh nozoki`
- **`docs/PRD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/launch-product-prd/launcher.sh nozoki`
