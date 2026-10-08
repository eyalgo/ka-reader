# Self-answer report — PRD.md

## Header

- **Companion:** `docs/PRD_open_issues.md`
- **Document:** `docs/PRD.md` (Draft, v13)
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-01

## Items worked

### 2.1 — Eight sentences in four sections still named the input *repository* where v11 made it a *folder* — drafted as *folder* at v13, awaiting your confirmation

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed
- **Why:** The draft holds, for the reason it gives, and the residue it says it left alone is the
  whole residue. Confirmed as it stood; what follows is the checking, not an addition to the answer.

  **Check 1.** The edit lands in `docs/PRD.md` — eight sentences and their markers — and binds
  nobody outside the document: no person, no outside party, no risk anyone carries, only the
  document's agreement with its own § Out of Scope, the Agari and the settled term. No named ground I
  cannot see: the keep-list is a CPO reading the owner's cycle-10 override left standing
  (`docs/trail/prd/cycle-10.md` § 2.1 — the override replaced the product sentence, not the sentence
  about which sections keep *repository*), and the owner reserved no taste over wording. Yours, in
  the owner's seat.

  **Check 2.** The argument is the one that carries the weight: each of the eight is a rule the
  document makes true of a plain folder — Key Use Case 4 reads one *"exactly as in case 1"*, so
  *"any file in the repository"* and *"the repository is untouched"* read narrower than the feature
  and the guarantee they state — and none is in the three keep-list sections. The `product-prd`
  run's reading of the self-answer doubt is right and I would have reached it the same way: "The
  character" states the identity (*"Read-only is the product's identity, not a mode"*), the identity
  holds over the whole input, and its neighbours already say *folder* for the same guarantee
  (§ Blurb, § Success Metrics *"no write to the viewed folder"*, § Risks *"Any write to the target
  folder"*). "Watching" (`docs/PRD.md:228`) is the one sentence that genuinely is the scenario's
  voice, and it stays. The two added are the same kind as the six and carry the same authorization;
  neither is a keep I can name a reason for. The v13 count is real: seven markers over eight
  sentences (the "The character" marker covers two) at `docs/PRD.md:157, 199, 232, 240, 272, 308,
  317` — measured with `grep -n awaiting`, which finds 7 body lines plus the version line.

  **Check 3.** Nothing settled moves. The owner-confirmed clock stays read against a Git
  repository (`docs/trail/prd/cycle-10.md` § 2.3) and the goal that mirrors it stays with it; the
  Agari already names the terminus's input *folder* and cites the PRD's § Out of Scope line for the
  word (`system/projects/ka-reader/agari.md:23-26`); `docs/CONTENT.md` § Terminology settles *folder*
  for *"the thing KA-Reader is pointed at"* and *repository* for *"where Git's own state is what the
  sentence is about"* (`:154-155`); the UXD's companion answered its matching residue *folder* on the
  same rule (`docs/UXD_open_issues.md` § 2.2, slot filled). I walked every *repository* left in v13
  outside the eight (`grep -n repositor docs/PRD.md`, 50 lines): each is Blurb / Purpose naming the
  three flat, the keep-list (`:52, :63-71, :83`), Git's own state (`:128, :149-152, :173-180, :205,
  :219-223, :247-248, :288, :336, :343-347, :408-410, :432`), the input quoted (`:294, :311`), the
  clock and its goal (`:93, :119-121`), Key Use Case 1 by design (`:140`), or the driving scenario —
  "Watching" (`:228`) and **Key Use Case 3** (`:146`, *"peeks at a repository an automated tool or
  agent is working on"*), which the item's left-alone list does not name and which sorts with
  "Watching" and the Problem Statement as the scenario's own voice. Named in the slot so the fold
  does not read it as a ninth sentence missed.

  **Check 4.** *Empty:* a folder with no files — *"any file in the folder"* and *"the folder's current
  state"* still say something. *Absent:* a path that is not a folder is the failure-state line's
  (`:255-258`), already worded *folder*. *Stale:* the markers say *awaiting confirmation*; the fold
  turns them into a settled marker and the version line records the close — the item states this.
  *Concurrent:* the UXD fold and the PRD fold in either order — the UXD's answers stand regardless,
  and *folder* includes *repository*, so no rule is false between them; the item states this too.
  *Refused:* an override reverts the eight and records them as a deliberate keep beside the three
  sections — stated. One thing the item's fold description does not reach, recorded here and not
  corrected in the item: on confirm it writes the markers as *owner-confirmed: trail/prd/cycle-12.md
  § 2.1*, and the confirming seat is this run, not the owner. The trail copy carries the provenance
  — the slot names this report, as cycle-11's names `self_answer-1.md` (`docs/trail/prd/cycle-11.md:62`)
  — so the record is recoverable, and the marker's word is the producing skill's vocabulary, not this
  document's defect.

  **What was close to tipping it.** *Confirmed with addition*, for Key Use Case 3 — but the addition
  would be to the item's account of the residue, not to the answer: the sentence stays as the item's
  own rule already sorts it, and naming it changes nothing the fold does. So confirmed, with the
  sentence named in the slot.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.2 — § UX Notes "The character" names the dominant surface the *editor panel*; the document's own two other mentions and `docs/CONTENT.md` name it the *reading panel*

- **What the document is owed:** one sentence — *"The editor panel is the dominant visual surface"*
  (`docs/PRD.md:198`) reads *reading panel*, the term the document itself uses at `:359-360` and
  `:373-374` and that `docs/CONTENT.md` § Terminology settles.
- **Why it is worth a cycle:** *it contradicts a document it must agree with* — and itself. § Out of
  Scope says the input's *"reading panel dominant"* note *"is carried in UX Notes"*, and the UX Notes
  sentence it points at says *editor panel*; CONTENT rejects *editor* for the panel because *"the
  word implies a write path that does not exist"*, and the writing bar's check — *"take any concept
  named in two documents here; both use the same word for it"* (`system/doctrine/writing_bar.md`
  § 1.2) — fails on it. The cost is near zero: the document is already open and the fold that reads
  this companion is owed anyway. The doubt is in the item: no downstream reader is misled today, and
  if the CPO holds the word as the input's kept on purpose, the override is to record that.

## Companions opened

None this run.

## Launchers owed

- **`docs/PRD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/launch-product-prd/launcher.sh ka-reader`
