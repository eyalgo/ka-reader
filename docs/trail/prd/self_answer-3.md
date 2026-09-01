# Self-answer report — PRD.md

## Header

- **Companion:** `docs/PRD_open_issues.md`
- **Document:** `docs/PRD.md` (Draft, v14)
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-01

## Items worked

### 2.1 — § UX Notes "The character" named the dominant surface the *editor panel*; drafted as the *reading panel* at v14, awaiting your confirmation

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** The draft holds, for the reason it gives: the surface has one settled name and the
  sentence was the one place this document used another. The addition is a citation the draft
  gets one section wrong, and it changes what the marker should say on fold, not what the
  sentence says.

  **Check 1.** The edit lands in `docs/PRD.md` — one sentence and its marker — and binds nobody
  outside the document: no person, no outside party, no risk anyone carries, only the document's
  agreement with its own § Out of Scope and § Assumptions and with the settled term. No named
  ground I cannot see: the `product-prd` run's reading says outright the CPO holds *editor panel*
  as no deliberate keep (`docs/PRD_open_issues.md` § 2.1, *On the doubt*), and the owner has
  reserved no taste over wording — the one owner override on this document replaced a product
  sentence, not a word choice (`docs/trail/prd/cycle-10.md` § 2.1). Yours, in the owner's seat.

  **Check 2.** The argument carries the weight put on it. § Out of Scope says the input's
  *"reading panel dominant"* note *"is carried in UX Notes"* (`docs/PRD.md:371-372`), and the UX
  Notes sentence it points at said *editor panel*; § Assumptions says *"a file tree beside a
  reading panel"* (`:385-386`); `docs/CONTENT.md` § Terminology settles **reading panel** for
  *"the dominant surface where a file's content is read"* and rejects *editor* — *"there is no
  editor; the word implies a write path that does not exist"*. The CPO's reason for taking the
  rename rather than keeping the input's word is the right one: the input's word names the
  component it recommends (`docs/proposal.md` § Editor Choice, Monaco in read-only mode), which
  this document keeps out (§ Out of Scope, *"editor component"*). **Where the draft is
  incomplete:** it says *"the input's word is 'editor area'"* and cites § Overview. The input
  says both. § Overview has *"a main editor area that is strictly read-only"*
  (`docs/proposal.md:5`), and § Styling Guidance has *"Make the editor panel the dominant visual
  surface"* (`docs/proposal.md:99`) — verbatim the sentence the PRD carried. So the *changed*
  relation is exact and stronger than the draft states: the PRD sentence was a near-quote of the
  input's Styling Guidance line, and the rename departs from that line. The consequence for the
  fold is that the marker should cite § Styling Guidance, where a cold reader opening the input
  will find the sentence, rather than § Overview, where they will find a different phrase for the
  same surface. That is the addition — a case the argument did not reach, not a hedge — and it is
  the producing skill's to write on fold; nothing in the item's text is corrected here.

  **Check 3.** Nothing settled moves. Every downstream document already names the surface
  *reading panel* and nothing names it *editor panel*: `docs/UXD.md:65, :72, :396` (*"the reading
  panel is the dominant visual surface"*), `docs/DESIGN.md:486` (*"The reading panel takes every
  remaining pixel. It is the dominant surface"*), `docs/SRS.md:395` (*"a dominant read-only
  reading panel (FR-8)"*) — measured with `grep -n "editor panel\|reading panel\|editor area"`
  over the four documents. The Agari does not name the surface. The residue holds as the item
  states it, and I walked it whole: `grep -n editor docs/PRD.md` at v14 finds 16 lines, and every
  one outside the version line and the drafted marker names the alternative, the resemblance, or
  the input quoted — *"A full editor"* (`:53`), *"the editor shell"* (`:55`), *"a full code
  editor"* / *"An editor's protections"* (`:63-64`), *"lighter than an editor"* (`:70`), *"the full
  editor they already have"* (`:73, :450`), *"editor-style layout"* (`:75, :385`), *"No editor
  experience required"* (`:98`), *"the editor area"* quoting the input (`:116`), *"exactly as they
  would in an editor"* (`:141`), *"a surface an editor would fill"* (`:226`), *"editor component"*
  (`:366`), *"Looking like an editor invites expecting an editor"* (`:446`). Six of those the item
  does not name (`:55, :98, :141, :226, :366` and the Goals sentence); each sorts the same way and
  none names the surface. Named in the slot as *"no other editor in v14 names the surface"* so the
  fold does not read one as a second sentence missed.

  **Check 4.** *Empty:* nothing open — the reading panel is still the dominant surface, in its
  empty state, which is where the arrival prompt lives (`docs/PRD.md` "The path" 1;
  `docs/UXD.md:118-119`, *"the reading panel in its empty state"*); the sentence stays true.
  *Absent* and *concurrent:* not reached by a word; the fold in any order against the UXD,
  CONTENT and DESIGN changes nothing, as the item states. *Stale:* the marker says *awaiting
  confirmation*; the fold rewrites it and the version line records the close — stated. *Refused:*
  the item says an override reverts the sentence and records the keep, and that *"nothing
  downstream waits on it"* — true of confirm, not of override. On override the PRD's sentence
  would sit in CONTENT's rejected column, and CONTENT § Terminology or its rejection of *editor*
  would be owed a change to agree with it. Recorded here as the cost of the path not taken; it
  does not change the verdict, it says why the override was never close.

  **What was close to tipping it.** *Confirmed*, plain — the addition is to the marker's citation,
  not to the sentence. It is *with addition* because the marker is what a cold reader follows to
  the input, and a marker citing the section that does not carry the departed-from sentence is
  the exact defect the writing bar's first check names (`system/doctrine/writing_bar.md` § 1.2,
  *"open exactly what is cited and find the sentence there"*).

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/PRD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/launch-product-prd/launcher.sh nozoki`
