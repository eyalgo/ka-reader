# PRD open issues — Nozoki 覗き

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

> **This companion was opened by a `companion-self-answer` run, not by a `product-prd` run.**
> `PRD.md` is Settled at v12 and its companion was correctly deleted. It is opened because a run
> answering the UXD's companion (`docs/UXD_open_issues.md` § 2.2 — five UXD entries still naming
> the input *repository* after PRD v11 made it a *folder*) read this document whole to test
> whether those entries mirror it deliberately, and found the same residue here: six sentences in
> five sections name the input *repository*, and none of them sits in the three sections the v11
> fold kept that wording in on purpose (`docs/trail/prd/cycle-10.md` § 2.1). With no companion on
> disk a `product-prd` re-run reads the PRD as done and has nothing to act on, so this file is the
> only channel the change has. The one item below is a wording defect, not a product change.
> Reasoning: `docs/trail/uxd/self_answer-4.md` § Companions opened.

---

## 2. Choices to confirm — the CPO drafted a best-effort answer; confirm or override

### 2.1 Six sentences in five sections still name the input *repository* where v11 made it a *folder* — § UX Notes "The character" and "Leaving", the *view never lies* rule, § Scope (In)'s full ambition, and § Out of Scope "Editing, permanently"

> **This item was raised by a `companion-self-answer` run, not by a `product-prd` run.** The run
> was answering `docs/UXD_open_issues.md` § 2.2, whose item asks whether the UXD's remaining
> *repository* wording is a deliberate mirror of this document; reading this document to answer
> that found the six sentences below in neither the v11 fold's list of what moved nor its list of
> what stays. Reasoning: `docs/trail/uxd/self_answer-4.md` § Companions opened.

- **Drafted into the PRD:** nothing — this is a finding, not a drafted change. Measured on v12
  (`grep -n -i repositor docs/PRD.md`, 2026-09-01), six sentences name the viewed input
  *repository*: § UX Notes "The character" — *"Nozoki looks at a repository; it never acts on
  one"* (`:191`) and *"nothing in the experience suggests the repository could be changed from
  here"* (`:194`); "The path" 5 "Leaving" — *"the person leaves certain the repository is exactly
  as they found it"* (`:228`); the rule — *"the view never lies. What is shown is the repository's
  current state"* (`:230`); § Scope (In)'s full ambition — *"switching which repository is viewed
  without restarting"* (`:298`); § Out of Scope "Editing, permanently" — *"the product has no write
  path to the repository, in any version"* (`:305`). The lean: each reads *folder* — *"looks at a
  folder"*, *"the folder could be changed from here"*, *"the folder is exactly as they found it"*,
  *"the folder's current state"*, *"switching which folder is viewed"*, *"no write path to the
  folder"* — on the authority v11 already carries.
- **Rationale:** the v11 fold states where *repository* stays on purpose — *"The Problem Statement,
  Why This and Target Users keep their repository-shaped wording: the pain and the driving scenario
  are still Git working trees under change; only the input widened"* (`docs/trail/prd/cycle-10.md`
  § 2.1) — and none of the six is in those three sections; the fold's own inline markers name the
  lines that widened (`:130`, `:152`, `:174`, `:250`, `:281`, `:328`) and these are not among
  them. One of the six contradicts this document: `:298` keeps *"switching which repository is
  viewed"* while § Out of Scope reads *"Changing the viewed folder without restarting … the word
  widened from repository to folder with the input"* (`:326-328`), and the project's Agari names
  the terminus with *folder* and cites that § Out of Scope line as *"the same word the PRD uses for
  it"* (`system/projects/nozoki/agari.md:23-26`). Each of the six is a product rule this document
  makes true of a plain folder — Key Use Case 4 opens one and *"browses and reads it exactly as
  in case 1 … the tree, the reading, and the live refresh work as they always do"* (`:149-152`) —
  so a rule worded *repository* reads narrower than the product it governs. The
  verbal language settled the split downstream: *folder* for *"the thing Nozoki is pointed at"*,
  *repository* for *"a folder that is the root of a Git repository, and the Git state Nozoki reads
  from it"*, and *repository* elsewhere only *"where Git's own state is what the sentence is
  about"* (`docs/CONTENT.md` § Terminology, `:154-155`, `:185`); the instance's writing bar binds
  one name per term across every document here (`system/doctrine/writing_bar.md` § 1.2). What
  stays as written: § Problem Statement, § Why This, § Target Users (the fold's keep-list); "The
  path" 4 "Watching" (`:224`), which names the driving scenario; § Risks' *"changed repository
  state"* (`:420`) and every sentence about Git state. The doubt, stated: "The character" (`:191`,
  `:194`) is written in the same voice as the driving scenario, and the CPO may read it as inside
  the keep-list — if so, the answer is to say so where the PRD records its reasons, so the residue
  reads as a decision and not an oversight, rather than to rename. Downstream: `docs/UXD.md` UX-I4,
  UX-I7 and § 10 mirror `:230`, `:305` and `:298`; the UXD's companion answers those *folder* on
  the CONTENT rule above and does not wait on this item — *folder* includes *repository*, so no
  rule this document states becomes false either way. If overridden, the six stand, the fold
  records them beside the three sections cycle-10 § 2.1 names, and nothing downstream moves.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">
