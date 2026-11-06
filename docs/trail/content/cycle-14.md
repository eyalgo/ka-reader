# CONTENT open issues — ka-reader

> Companion to `CONTENT.md`. The Content Manager authored the verbal language non-interactively;
> this file holds the calls it made and wants your sign-off on — each with the reason behind it,
> and what moves underneath it if you override — plus the few things it genuinely could not
> settle.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**,
> then re-run `product-content`. It folds your answers into `CONTENT.md` and drops the resolved
> items. When nothing is left open, `product-content` **deletes this file**: no file = the verbal
> language is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git refuses
> to remove a file with uncommitted edits in it — so an uncommitted answer stops that run before
> it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the Content Manager folds them in, it first copies
> this file whole to `docs/trail/content/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 comes from outside this run.** The verbal language is read by everyone who writes a string,
> and a seat downstream can find a pattern it has no rule for. It is recorded there, answered here,
> and folded by the same run.

> **No `product-content` run wrote this file.** A `companion-self-answer` run opened it on
> 2026-11-06, in the CDO's seat, while answering `docs/SDD_open_issues.md` item 2.4 — the PRD at
> v17 – v18 requires that in the beta the Git view, the tree's changed-file markers and the README's
> known gaps say plainly that they show the Git state read when the folder was opened, and the SDD
> at v68 (§ 6 S-7, S-8) closes on "the sentence `docs/CONTENT.md` fixes" for it. `CONTENT.md` is
> Settled at v14 and fixes none; its companion was correctly deleted, and it is re-opened because
> the PRD moved after v14 was authored and the document has no other channel: with no companion on
> disk a `product-content` re-run reads it as done and has nothing to act on. The reasoning is in
> `docs/trail/sdd/self_answer-77.md` § 2.4 and § *Companions opened*.

---

## 1. Open issues

None.

## 2. Choices to confirm

### 2.1 The beta's statement — the Git view and the tree's markers show the Git state read when the folder was opened — is a stated limit on three surfaces, and this document fixes no wording for it
- **Written into CONTENT.md:** nothing — this run writes no document. Proposed, for the
  `product-content` run that folds this item, reading `docs/PRD.md` at v18 (`ka-reader@d1ea3ac`)
  and `docs/UXD.md` at the version that draws the statement (`docs/UXD_open_issues.md` § 2.1,
  opened by the same run): one row in § *Standing sentences* — the beta's Git view
  (`docs/PRD.md` § Scope (In), *The first public release — a beta*) — with one wording that the Git
  view, the tree's markers and the README's known gaps all carry verbatim, and a retirement clause
  like the before-1.0.0 row's: retired the day the Git view follows the disk
  (`docs/SDD.md` § 6 S-8), with nothing written in its place. A § *Traceability* row for the beta
  state of UX-S3 and UX-S2 follows once the UXD names it. The wording is this seat's; the rules it
  meets are already this document's — *KA-Reader* as the subject of what the tool did, simple past
  for what it observed (*read when you opened the folder* is an observation), present for what is
  true now, no future tense and no softening, sentence case (§ Grammar and mechanics). A draft to
  write against, not to copy: *"The Git view and the changed-file markers show the Git state
  KA-Reader read when you opened the folder. They do not follow later changes."*
- **Grounds:** the PRD's requirement (`docs/PRD.md:L327-L329`; `:L261-L263`; owner-confirmed at
  `docs/trail/prd/cycle-15.md` § 3.1) and the SDD's bar on it: S-7's command half closes on "a
  `grep` of `README.md` for the sentence `docs/CONTENT.md` fixes", and S-8's on "the entry
  `docs/CONTENT.md` names for the beta's statement, once it names one" (`docs/SDD.md` § 6 S-7, S-8
  *Reached when*). `grep -c 'read when the folder was opened' docs/CONTENT.md` prints 0 at
  `ka-reader@796f7df`. § *Standing sentences* is the table for exactly this — "a promise or a stated
  limit that appears on more than one surface", with one wording — and this limit appears on three.
- **What moves if you override:** no sentence exists for the README's known gaps or for the two
  surfaces, so the beta's seed either writes one at the change — a published string with no
  standard behind it, which the Developer may not write (`<CORE>/roles/CROSS_ROLE.md` § 2) — or
  S-7 cannot close. Nothing else in the document derives from the row.
- **Confirm or override:** confirm, with four additions for the fold, decided in the Content Manager's seat.
  (1) **The draft's wording moves off two phrases; the row is otherwise as drafted.** *Markers* is the PRD's and the SRS's working word, and no string of the product shows it; § Terminology does not fix it, and the reading bar (§ Accessibility of text) lets a word into a message only from four sources, which it is not. What the reader sees is the letters beside changed files. And *later changes* misreads in the beta, where the tree does follow the disk: a reader can take it to mean the files. Write against: *"The Git view and the letters beside changed files show the Git state KA-Reader read when you opened the folder. They do not update while KA-Reader is open."* It keeps the document's own rules: no contraction (a standing sentence is fixed as written), *the folder you opened* is § Terminology's phrase, and KA-Reader is the subject of what it read, in the simple past. It is true on a clean repository, where there are no letters. The retirement clause has the before-1.0.0 row's shape: retired the day the Git view follows the disk (`docs/SDD.md` § 6 S-8), with nothing written in its place.
  (2) **One wording serves all three surfaces, and the README's second clause is not a standing sentence.** `docs/SRS.md` AC-14 asks the README's known gaps for two things: the statement, and that a repository created at the folder's root after it is opened is not followed. The second appears on the README alone, so it is no standing sentence and gets no row. The row's note says so, so that whoever writes the README does not take the statement to carry it. That sentence is written with the README, to this document's rules.
  (3) **No other sentence on the Git view restates the limit.** The short status and the Empty sentence (*"Nothing has changed in this repository."*, *"A rebase is in progress in this repository."*) stay in the present tense and rest on the line the UXD places beside the short status. Adding *when you opened the folder* to each would be a second wording of one limit, which § Standing sentences forbids.
  (4) **§ Tone gets one entry for it.** Its *Arrival, nothing open* and *The first file opens* rows say one sentence and nothing. The beta's line is a standing fact of two surfaces and not an announcement. It is written in the register of an empty-state sentence: no label (*Note:*, *Beta:*), no emphasis, and no louder in one state than another (§ Voice, *Urgent*). Say that in the entry and leave both rows as they are for everything else KA-Reader says.
  **Fold order:** the row and the Tone entry derive from the PRD and can be written now. The two § Traceability rows (UX-S3, UX-S2) cite the UXD at the version that folds `docs/UXD_open_issues.md` § 2.1, so `product-uxd` runs first. Reasoning: `docs/trail/content/self_answer-12.md` § 2.1.

### 2.2 In the beta nothing re-reads Git state, so the Git view's lock message — "the Git view shows the status as soon as KA-Reader can read it" — promises a recovery the beta never makes

> **No `product-content` run wrote this item.** A `companion-self-answer` run appended it on
> 2026-11-06, in the CDO's seat, while answering `docs/UXD_open_issues.md` § 2.1 — the beta's
> statement as a state of the Git view and the tree. Checking that answer's failure paths found
> that the UXD's Git-view error cell recovers "on refresh", and that in the beta no refresh of Git
> state comes. The UXD answer carries the experience half; this item is the words. The reasoning is
> in `docs/trail/uxd/self_answer-6.md` § 2.1 and § *Companions opened*.

- **Written into CONTENT.md:** nothing — this run writes no document. Proposed, for the
  `product-content` run that folds this item, reading `docs/SRS.md` v14 FR-35 and `docs/UXD.md` at
  the version that folds `docs/UXD_open_issues.md` § 2.1: the Git view's observed-condition error
  gains its beta case. Today it is § Traceability's row *UX-S3 Git view — error (lock)*, "the
  nothing-to-do form, with the condition that ends the wait", and § Message patterns § *Error — an
  observed condition*'s example, *"KA-Reader can't read this repository's Git status while
  `.git/index.lock` is there. There's nothing to do: the Git view shows the status as soon as
  KA-Reader can read it."* Where Git state is read once, when the folder is opened, and not
  followed, that wait never ends on its own. Nothing reads Git state again until the folder is
  opened again, which in v1 means starting KA-Reader again (`docs/UXD.md` UX-S4). So in that state
  the message takes the formula's other branch, *what you can do next*, and names opening the folder
  again. It says nothing that waits on a later read, and it states the lock as observed at open, in
  the simple past this document already uses for what the tool observed. A present-tense *"is
  there"* would claim something about now that the tool is no longer checking. The same holds for
  any other Git-view message whose *what ends the wait* is a later read. Retired with the beta's
  statement, the day the Git view follows the disk (`docs/SDD.md` § 6 S-8), when the present form is
  true again. The wording is this seat's.
- **Grounds:** the example and the row (`docs/CONTENT.md:L269-L270`, `:L529`); the formula's own
  two branches (`:L261-L263`, *"what you can do next, or that there is nothing to do and what ends
  the wait"*); the read-at-open state as a settled system requirement (`docs/SRS.md` FR-35,
  `:L255-L264` — Git state "read once, when the folder is opened, and not followed"); and the
  slices: in `see-git-status` and the beta the Git view shows "the state read when the folder
  opened", and only `follow-the-folder` re-runs the read (`docs/SDD.md` § 6 S-4 *Not in this slice*;
  S-8 *Rests on*). A message promising a state the tool will not reach this session is the view
  lying forward: what it says is not what will happen (`docs/UXD.md` UX-I4, UX-I13).
- **What moves if you override:** the beta ships a message telling the reader there is nothing to
  do and the status will come, and in that session it never comes. The lock clears, and the view
  goes on saying it is there. A reader who trusts the message waits for nothing. That is the stale
  state presented as current, the one case the beta's statement exists to rule out.
- **Confirm or override:** confirm, with two additions for the fold, decided in the Content Manager's seat.
  (1) **The beta form is its own whole sentence, and today's form is kept for the day it returns.** § Localization forbids one sentence with a switch inside, so the lock message holds two whole sentences: the beta's now, and today's restored when the Git view follows the disk (`docs/SDD.md` § 6 S-8), which makes the retirement a swap and not a rewrite. The beta's takes the formula's other branch, as drafted: the lock is stated as observed at open, in the simple past; the lock file is named as a file seen and never as a cause; the reader is told what to do, in the document's own phrase *start KA-Reader again*; and nothing waits on a later read. It does not say a restart will succeed, because the lock is commonest exactly when an agent is running Git, and a restart can meet it again. Write against: *"KA-Reader couldn't read this repository's Git status when you opened the folder, and `.git/index.lock` was there. Start KA-Reader again to read it again."* Two sentences, inside the formula's three. The first names *when* because the line beside it says the view is as read then. That is the failure's own time, and not the limit restated (item 2.1 (3)).
  (2) **The rule reaches every sentence whose way on is a later read, and there are three more than the lock message.** (a) The unexplained-fault example (`docs/CONTENT.md:L302-L303`), *"the Git view shows the status again if KA-Reader can read it"*, promises the same read. Its beta form keeps *the file tree is unaffected* and takes *start KA-Reader again* as the one thing to do next. (b) The § Grammar *Tense* bullet (`:L108-L109`) quotes the lock message's closing clause as its example of a named condition. It would hand a writer a sentence the beta makes false, so the fold swaps it for one that is true in both states. (c) The *Recovered* pattern's Git example (`:L391-L394`) describes a state the beta never reaches and gets a one-line bound saying so. § Traceability's UX-S3 lock row (`:L529`) then names the beta form and its retirement. Reasoning: `docs/trail/content/self_answer-12.md` § 2.2.

## 3. Raised from downstream — an item from a seat that did not write the verbal language

None.
