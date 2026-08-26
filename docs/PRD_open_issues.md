# PRD open issues — Nozoki 覗き

> Companion to `PRD.md`. The CPO authored the PRD non-interactively; this file holds what it could
> not settle from the inputs. **Answer inline** — fill each **Answer** / **Confirm-or-override**
> slot — **commit this file**, then re-run `product-prd`. It folds your answers into the PRD and
> drops the resolved items. When nothing is left open, `product-prd` **deletes this file**: no
> file = the PRD is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git refuses
> to remove a file with uncommitted edits in it — so an uncommitted answer stops that run before
> it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CPO folds them in, it first copies this file
> whole to `docs/prd_trail/` — so what you decided, and why, stays readable and citable for good.

> **This round folded your plain-folder directive** (`docs/prd_trail/cycle-9.md` § 1.1) into
> `PRD.md` v10. The directive itself is settled and is not re-asked. What is below is the four
> calls the directive left to the CPO — drafted into the PRD, each marked *awaiting
> confirmation* where it sits — plus one correction the PRD owed from an earlier override of
> yours downstream. Confirm each, or override it.

---

## 1. Open issues — product-defining questions with no answer yet

None.

## 2. Choices to confirm — the CPO drafted a best-effort answer; confirm or override

### 2.1 The product sentence: a folder viewer that lights up Git, not a repository viewer that degrades

- **Drafted into the PRD:** § Blurb and § Purpose now say Nozoki is *a read-only viewer for a
  local folder* that, *when the folder is a Git repository*, also shows what has changed — *a
  folder viewer that lights up Git when it finds it, not a repository viewer that refuses
  everything else*. The Problem Statement, Why This and Target Users keep their repository-shaped
  wording: the pain and the driving scenario are still Git working trees under change; only the
  input widened.
- **Rationale:** it is the framing your own directive was recorded in (the answering commit,
  `nozoki@86903c2`, says the sentence changes *from a Git repository viewer to a folder viewer
  that lights up Git when it finds one*), and it is the honest one: a plain folder is a fully
  working state, so calling it a *degraded* repository would make the README's first line
  describe the exception as the product's failure. The alternative — *a repository viewer that
  also opens plain folders* — keeps Git in the first sentence, which is where the driving scenario
  lives; it is a fair reading, and the reason this is a choice rather than a fact.
- **Confirm or override:**

### 2.2 "Disabled" means present and inert, saying why — not hidden

- **Drafted into the PRD:** § Core Features and § UX Notes ("Checking") promise that in a plain
  folder the Git view *is there, disabled, and states plainly that this folder is not a Git
  repository* — a working state, not an error — and that nothing about it invites the person to
  create a repository. The changed-file markers in the tree are absent. How the disabled view is
  drawn is left to the UXD, as the station's guardrail requires.
- **Rationale:** your word was *disabled*, and a thing can only be disabled if it is present; a
  view that vanishes would leave a Git user wondering whether Nozoki failed to find their
  repository. Present-and-saying-why is also what the PRD's *view never lies* rule asks: the state
  is shown, with its reason. The alternative — the Git view not offered at all in a plain folder,
  the sidebar showing Files only — is simpler to draw and is the override if you meant that.
- **Confirm or override:**

### 2.3 The plain folder is inside v1, not beyond it

- **Drafted into the PRD:** § Scope (In) now reads *a single local folder — a Git repository or
  not*; § Key Use Cases gains case 4 (a plain folder); § Out of Scope no longer lists a
  non-repository as a failure. Time-to-first-success stays measured against a Git repository —
  the fuller path — with a plain folder not measured separately.
- **Rationale:** the directive was given while the SDD was cutting v1's slices, and it subtracts a
  failure rather than adding a feature: the tree, the reading and the live refresh already work;
  what changes is that the window opens. Deferring it would have v1 build the refusal and a later
  release remove it. **One consequence for you to note, not answer here:** the project's Agari
  (`system/projects/nozoki/agari.md`) describes the terminus as *point it at a local repository*;
  once this is confirmed it wants the same widening through its own skill, `project-agari` — a
  separate run, outside this station.
- **Confirm or override:**

### 2.4 Git is read only when the opened folder is itself a repository's root

- **Drafted into the PRD:** § Core Features: *Git is read only when the folder opened is itself
  the root of a Git repository. A folder inside a repository, and a folder that contains
  repositories, both open as plain folders.* § Out of Scope carries the exclusion.
- **Rationale:** no input mentions either case, and the product cannot stay silent on them — Git
  itself finds a repository from any folder beneath its root, so without a rule Nozoki would open
  `src/` of a repository with a Git view reporting changes in files the tree does not show, and a
  folder of ten repositories with a Git view for none or one. *The tree and the Git view always
  describe the same folder* is the smallest rule that keeps the view from lying. The override
  with a real case for it: a folder inside a repository shows Git scoped to that subtree — useful
  for monorepos, and a bigger promise than v1 needs.
- **Confirm or override:**

### 2.5 The Markdown raw-source switch is a permission, not a promise — the PRD's own line, corrected

- **Drafted into the PRD:** § Core Features: *Markdown is rendered by default. A switch to the
  raw source is permitted, not promised: it is built if it costs nothing, and a release that
  ships rendered-only says so where the release is offered.* Replaces *"if the toggle proves too
  costly for v1, v1 ships rendered-only and the toggle follows"*.
- **Rationale:** you overrode the earlier line downstream — `docs/srs_trail/cycle-5.md` § 2.3,
  *"render is what i need", "add the toggle if it costs nothing"* — and confirmed at
  `docs/SDD_open_issues.md` § 2.1 that the stale PRD line *"is a PRD correction for its own run"*.
  This is that correction. It is listed because the line it replaces was itself owner-confirmed
  (`docs/prd_trail/cycle-7.md`), so the supersession is put to you rather than made silently;
  nothing else about Markdown moves.
- **Confirm or override:**

## 3. Directives — an external action the owner confirms as a gate

None.
