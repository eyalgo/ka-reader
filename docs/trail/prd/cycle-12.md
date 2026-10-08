# PRD open issues — KA-Reader

> Companion to `PRD.md`. The CPO authored the PRD non-interactively; this file holds
> what it could not settle from the inputs. **Answer inline** — fill each **Answer** /
> **Confirm-or-override** slot — **commit this file**, then re-run `product-prd`. It folds
> your answers into the PRD and drops the resolved items. When nothing is left unresolved,
> `product-prd` clears this file: no file = the PRD is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CPO folds them in, it first copies
> this file whole to `docs/trail/prd/` — so what you decided, and why, stays readable
> and citable for good.

> **This companion was opened by a `companion-self-answer` run, not by a `product-prd` run**
> (`ka-reader@70abec1`), on a PRD that was Settled at v12 with its companion correctly deleted. A
> run answering the UXD's companion (`docs/UXD_open_issues.md` § 2.2) read this document whole
> and found six sentences that still name the input *repository* after v11 made it a *folder*.
> Reasoning: `docs/trail/uxd/self_answer-4.md` § Companions opened.
>
> **A `product-prd` run has since taken the item up** — this file's current state. The run
> walked every remaining *repository* in the PRD, found two more sentences of the same kind, and
> drafted all eight into `PRD.md` v13 as *folder*, each marked *awaiting confirmation* where it
> sits, so the choice is in the body as a draft and here as the item — the skill's shape for a
> choice to confirm. `Status:` is Draft while this file is open. The one item below is a wording
> defect, not a product change; the slot is yours.

---

## 1. Open issues — product-defining questions with no answer yet

None.

## 2. Choices to confirm — the CPO drafted a best-effort answer; confirm or override

### 2.1 Eight sentences in four sections still named the input *repository* where v11 made it a *folder* — drafted as *folder* at v13, awaiting your confirmation

> **This item was raised by a `companion-self-answer` run, not by a `product-prd` run**, on six
> sentences (`ka-reader@70abec1`). The `product-prd` run that followed added two of the same kind
> and drafted the eight. The self-answer run's finding and its stated doubt are kept below as
> written, so what came from where stays legible; the CPO's own reading follows them.

- **Drafted into the PRD (v13):** eight sentences now read *folder*, each carrying the marker
  *(folder, not repository: the widening owner-confirmed at trail/prd/cycle-9.md § 1.1,
  applied here awaiting confirmation)*. The six the self-answer run found: § UX Notes "The
  character" — *"KA-Reader looks at a folder; it never acts on one"* and *"nothing in the experience
  suggests the folder could be changed from here"*; "The path" 5 "Leaving" — *"the person leaves
  certain the folder is exactly as they found it"*; the rule — *"the view never lies. What is
  shown is the folder's current state"*; § Scope (In)'s full ambition — *"switching which folder
  is viewed without restarting"*; § Out of Scope "Editing, permanently" — *"the product has no
  write path to the folder, in any version"*. The two the CPO added on its own walk: § Core
  Features — *"Read-only viewing of any file in the folder"* (was *"in the repository"*); § UX
  Notes "What must feel effortless", "Trusting the tool" — *"never feels the need to check that
  the folder is untouched"* (was *"the repository"*). The version line records the change and
  its authorization. Nothing else in the document moves.
- **Rationale (the self-answer run's, on the six):** the v11 fold states where *repository*
  stays on purpose — *"The Problem Statement, Why This and Target Users keep their
  repository-shaped wording: the pain and the driving scenario are still Git working trees under
  change; only the input widened"* (`docs/trail/prd/cycle-10.md` § 2.1) — and none of the six is
  in those three sections; the fold's own inline markers name the lines that widened and these
  are not among them. One of the six contradicted this document: the full ambition kept
  *"switching which repository is viewed"* while § Out of Scope reads *"Changing the viewed
  folder without restarting … the word widened from repository to folder with the input"*, and
  the project's Agari names the terminus with *folder* and cites that § Out of Scope line as
  *"the same word the PRD uses for it"* (`system/projects/ka-reader/agari.md:23-26`). Each of the
  six is a product rule this document makes true of a plain folder — Key Use Case 4 opens one
  and *"browses and reads it exactly as in case 1 … the tree, the reading, and the live refresh
  work as they always do"* — so a rule worded *repository* reads narrower than the product it
  governs. The verbal language settled the split downstream: *folder* for *"the thing KA-Reader is
  pointed at"*, *repository* for *"a folder that is the root of a Git repository, and the Git
  state KA-Reader reads from it"*, and *repository* elsewhere only *"where Git's own state is what
  the sentence is about"* (`docs/CONTENT.md` § Terminology); the instance's writing bar binds
  one name per term across every document here (`system/doctrine/writing_bar.md` § 1.2, *"A
  term has one name and one spelling across every document authored here"*). **The doubt, as
  the self-answer run stated it:** "The character" is written in the same voice as the driving
  scenario, and the CPO may read it as inside the keep-list — if so, the answer is to say so
  where the PRD records its reasons, so the residue reads as a decision and not an oversight,
  rather than to rename.
- **The CPO's reading, added by the `product-prd` run:**
  - *On the doubt:* "The character" is not the driving scenario's voice; it is the product's
    identity statement — its own words are *"Read-only is the product's identity, not a mode"*
    — and the identity holds over the whole input, not over the Git case. The keep-list is the
    pain and the people (Problem Statement, Why This, Target Users), where *repository* is what
    hurts and who is hurt; "The character" is neither. Its neighbours already say *folder* for
    the same guarantee: § Blurb *"with the certainty that nothing in it can be changed from
    here"* (*it* is the folder), § Success Metrics *"no write to the viewed folder"*, § Risks
    *"Any write to the target folder"*. So the CPO does not take the keep reading, and drafts the
    rename. "The path" 4 "Watching" — *"as the repository changes — the driving scenario"* — is
    the sentence that genuinely is the scenario's voice, and it stays as written.
  - *On the two added:* the walk was over every *repository* in v12, each sorted as Git's own
    state, the keep-list, the driving scenario, a metric owner-confirmed against a repository
    (`docs/trail/prd/cycle-10.md` § 2.3), or the input. Two more sorted as the input: § Core
    Features' first line, *"any file in the repository"* — Key Use Case 4 reads a plain folder's
    files with the same feature, so the line read narrower than the feature; and "Trusting the
    tool", *"check that the repository is untouched"* — the same guarantee as "Leaving", one
    subsection later. They carry the same authorization as the six and are drafted with them;
    if you hold either as a deliberate keep, say so in the override and it reverts alone.
  - *What was left alone, and why:* § Goals' pick-it-up line and § Success Metrics'
    time-to-first-success both say *"a file of their own repository"* — the clock is
    owner-confirmed as read against a Git repository (`docs/trail/prd/cycle-10.md` § 2.3), and
    the goal mirrors the clock. Key Use Case 1 opens *"a local repository"* — case 4 is defined
    as *"exactly as in case 1"* against a plain folder, so case 1 is the repository case by
    design. § Out of Scope's *"Remote or hosted repositories"* and every sentence about branch,
    staged files, mid-operation state or *"changed repository state"* are Git's own state.
  - *The fold, either way:* on **confirm**, each *awaiting confirmation* marker becomes
    *owner-confirmed: trail/prd/cycle-12.md § 2.1* and the version line records the close;
    nothing downstream waits on it — `docs/UXD.md` UX-I4, UX-I7 and § 10 mirror three of the
    eight and the UXD's companion answers them *folder* on the CONTENT rule above, and *folder*
    includes *repository*, so no rule this document states is false in the meantime. On
    **override**, the eight revert to their v12 wording and the version line records them as
    kept beside the three sections `docs/trail/prd/cycle-10.md` § 2.1 names, so the residue reads
    as a decision; the UXD's answers stand regardless.
- **Confirm or override:** confirm — the eight read *folder*, on the reasoning the item carries:
  none of the eight is in the three sections the v11 fold kept as *repository* on purpose
  (`docs/trail/prd/cycle-10.md` § 2.1), each is a rule this document makes true of a plain folder
  (Key Use Case 4 reads one *"exactly as in case 1"*), and the settled word for the input is
  *folder* (`docs/CONTENT.md` § Terminology). The two the `product-prd` run added are confirmed with
  the six; neither is a deliberate keep. The residue is complete as the item lists it: every
  *repository* left in v13 outside the eight is the keep-list, Git's own state, the owner-confirmed
  clock and the goal that mirrors it (`docs/trail/prd/cycle-10.md` § 2.3), or the driving scenario
  — Key Use Case 3 included, which the item did not name and which stays with "Watching". Decided
  by a `companion-self-answer` run in the owner's seat, not by the owner; the four checks and what
  was close to tipping are at `docs/trail/prd/self_answer-2.md` § 2.1.

### 2.2 § UX Notes "The character" names the dominant surface the *editor panel*; the document's own two other mentions and `docs/CONTENT.md` name it the *reading panel*

> **This item was raised by a `companion-self-answer` run, not by a `product-prd` run**
> (`docs/trail/prd/self_answer-2.md` § Raised on this document). The run read the document whole
> while answering § 2.1 and found it there; no producing run wrote this item, and its slot is the
> next round's, not this run's.

- **Drafted into the PRD:** nothing — a self-answer run does not write the document. The change
  proposed for the `product-prd` fold: § UX Notes "The character", *"The editor panel is the
  dominant visual surface"* (`docs/PRD.md:198`), reads *"The reading panel is the dominant visual
  surface"*, with a marker recording the rename and its authority. One sentence; nothing else moves.
- **Rationale:** the document names one surface two ways. § Out of Scope says what the input's
  experience notes carry — *"the reading panel dominant, text-first navigation, two themes — is
  carried in UX Notes"* (`docs/PRD.md:359-360`) — and § Assumptions says *"a file tree beside a
  reading panel"* (`:373-374`); the UX Notes sentence § Out of Scope points at says *editor panel*.
  `docs/CONTENT.md` § Terminology settles the term as **reading panel** and rejects *editor*:
  *"there is no editor; the word implies a write path that does not exist"*. The instance's writing
  bar binds every document authored here to one name per term, and its check is the one this fails
  — *"take any concept named in two documents here; both use the same word for it"*
  (`system/doctrine/writing_bar.md` § 1.2). The sentence sits in the paragraph that states *"Read-only
  is the product's identity, not a mode"*, so the one word that implies a write path is in the
  sentence after the one denying it. Every other *editor* in the document stays: *"editor-style
  layout"*, *"workbench-style shell"*, *"looking like an editor"*, *"the full editor they already
  have"* name the alternative or the resemblance, which is what the word is right for, and
  § Success Metrics' *"the editor area"* quotes the input. **The doubt:** this is one word, and
  the documents downstream — UXD, CONTENT, DESIGN — are already settled on *reading panel*, so no
  reader is misled today; it is raised because the document contradicts its own § Out of Scope
  sentence about what UX Notes carries, and the bar's check fails on it. If the CPO holds *editor
  panel* as the input's word kept on purpose, the override is to say so where the document records
  its reasons, so the residue reads as a decision.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Directives — an external action the owner confirms as a gate

None.
