# Self-answer report — CONTENT.md

## Header

- **Companion:** `docs/CONTENT_open_issues.md`
- **Document:** `docs/CONTENT.md` (v14, Settled; the companion was opened by a `companion-self-answer` run on 2026-11-06 and gained § 2.2 from a second one the same day, both items under choices to confirm)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-06
- **Sources re-read:** None. No answer here rests on a source outside this repository. Read at the lines each entry names: `docs/CONTENT.md` (v14) whole; `docs/PRD.md` (v18) § UX Notes and § Scope (In); `docs/SRS.md` (v14) FR-35, AC-14, AC-26; `docs/SDD.md` (v68) § 6 S-7 and S-8; `docs/UXD_open_issues.md` § 2.1 with its answer; `docs/trail/uxd/self_answer-6.md`; and the README as it stands.

## Items worked

### 2.1 — The beta's statement — the Git view and the tree's markers show the Git state read when the folder was opened — is a stated limit on three surfaces, and this document fixes no wording for it

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** **Check 1: mine, in the owner's seat.** The edit lands in this document, in § Standing sentences, which exists for exactly this: a stated limit on more than one surface, with one wording. The statement itself is the owner's and is already settled (`docs/PRD.md` § UX Notes and § Scope (In), owner-confirmed at `docs/trail/prd/cycle-15.md` § 3.1). The answer commits only the words. I can name no ground I cannot see, and the owner has reserved no taste in this wording.

  **Check 2: the row is right, and the draft's wording is not yet one this document accepts.** The shape holds: one row, one wording carried verbatim by the Git view, the tree and the README, and a retirement clause like the before-1.0.0 row's. Two phrases in the draft's example do not. *Markers* is the PRD's and the SRS's working word. `grep -n -i marker README.md` prints nothing, and CONTENT's own Terminology does not fix it. The reading bar in § Accessibility of text admits a word into a message from four sources only, and *markers* is none. The reader sees letters beside changed files, so the wording says that. And *They do not follow later changes* misreads in the beta, because the tree does follow the disk there (`docs/SDD.md` § 6 S-7 and S-8): a reader can take *later changes* to mean the files. *They do not update while KA-Reader is open* says what is true of the Git view and the letters, and it can be checked: nothing in the beta re-reads Git state (`docs/SRS.md` FR-35).

  **Check 3: two readings of the record, both agreeing.** The SRS's AC-14 asks the README's known gaps for two things, the statement and the case of a repository created at the root after open. The SDD's S-7 binds only the first to the sentence this document fixes. So the second is README-only and is not a standing sentence, which this document's own definition requires to appear on more than one surface. Nothing in the row may claim it; the row says so, so the README's author does not assume the statement covers it. The standing-sentence rule forbids paraphrase, so the short status and the Empty sentence (present-tense, e.g. *"Nothing has changed in this repository."*) are not given *when you opened the folder* each. They rest on the line the UXD places beside the short status (`docs/UXD_open_issues.md` § 2.1, confirmed in `docs/trail/uxd/self_answer-6.md`). Last, § Tone says *nothing* on the first file opening and one sentence on arrival. The beta's line is a standing fact of a surface and not an announcement, and the entry for it has to say so.

  **Check 4: the failure paths.** *Empty*: a clean repository has no letters. The wording still reads true, which the UXD's own addition (2) needs, because the tree's line stands there too. *Absent*: a Git state unreadable at open is part of the state read at open, so the same line stands over it. Item 2.2 covers the message that sits under it. *Stale*: the sentence is the stale case's whole answer, and it retires with `follow-the-folder`. If any intermediate change re-reads Git state, the sentence is false from that change on, and retirement has to be tied to the first re-read and not to the slice. The row carries S-8 as the trigger because the SDD fixes it there. *Concurrent*: an external staging operation after open leaves the state shown unchanged and still under the line (`docs/SRS.md` AC-26). *Refused*: nothing in this item.

  **Close to a different verdict:** *confirmed* plain, since the row and the draft's rules are right. What tipped it to *with addition* is that a README written from the draft would carry *markers*, a word no reader sees, and would assume the statement covers the plain-folder clause AC-14 also requires. *Overridden* was never close. The fold order matters: the row and the Tone entry derive from the PRD; the two § Traceability rows cite the UXD at the version that folds its § 2.1, so `product-uxd` runs first.

### 2.2 — In the beta nothing re-reads Git state, so the Git view's lock message promises a recovery the beta never makes

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** **Check 1: mine, in the owner's seat.** The item asks a sentence this document owns to stop promising a state the tool will not reach. The experience half was the CDO's and is done (`docs/trail/uxd/self_answer-6.md` § 2.1). Nothing it commits goes beyond this document's consistency with a settled requirement (`docs/SRS.md` FR-35).

  **Check 2: the item is one question and the draft holds for the reason it gives.** *What the Git view's sentences say when no later read comes* is one question with one seat, and the draft answers it: the message takes the formula's other branch, *what you can do next*, states the lock as observed at open in the simple past, and retires with the statement. The simple past is right for a reason the draft gives and I checked: *is there* would claim something about now the tool is no longer checking (§ Grammar and mechanics, *Tense*). The draft is narrower than the rule it states. It says *any other Git-view message whose way on is a later read* and lists none.

  **Check 3: reading the document turned up three more.** (a) The unexplained-fault example, *"the Git view shows the status again if KA-Reader can read it"* (`docs/CONTENT.md:L302-L303`), promises the same read. (b) The *Tense* bullet (`:L108-L109`) uses the lock message's closing clause as its worked example of a future tense with a named condition. That teaches the rule, and in the beta it would give a writer a sentence that is false. (c) The *Recovered* pattern's Git example (`:L391-L394`) describes a state the beta never reaches. Each is named in the slot for the fold. This is the same pass as item 2.1: the line placed beside the short status qualifies those present-tense sentences, and this item removes the ones that outrun it.

  **Check 4: the failure paths.** *Concurrent*: the lock is commonest when an agent is running Git, which is the driving scenario (`docs/PRD.md` § Target Users). A reader who opens KA-Reader then has a Git view that stays unread until a restart, and a restart can meet the lock again. So the beta sentence says *start KA-Reader again* and claims no success from doing it. This is the smaller true thing. *Stale*: the lock may clear a moment after open, and the simple-past sentence stays true when it does. A present-tense *is there* would not. *Absent*: Git state unreadable for a reason with nothing behind it to name takes the unexplained-fault form, covered by (a). *Refused*: a permission refusal observed at open is an observed condition and takes the same beta form with the refusal named. *Empty*: no case. One uncovered thing is recorded and not decided: a stranger whose first launch meets a lock gets a Git view that is unread for the session. That is the beta's accepted limit, settled upstream (`docs/PRD.md` § Scope (In), owner-confirmed), and the words can only say it truthfully. Nothing is raised, because no document's requirement is wrong.

  **Close to a different verdict:** *confirmed* plain, since the draft's formula branch and tense are right. What tipped it to *with addition* is that folding the lock message alone leaves two sentences in the document that still promise the read, one of them taught as a model. Decided together with item 2.1; neither answer moved the other.

## Left for the owner

None this run.

## Skipped

None this run. Both items carried an empty slot and were worked. § 1 and § 3 read *None*, and no slot in the file was filled before this run.

## Companions opened

None this run.

## Launchers owed

- **docs/CONTENT.md** — `<CORE>/launchers/skill/launcher.sh product-content ka-reader`
