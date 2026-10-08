# SRS open issues — KA-Reader

> Companion to `SRS.md`. The CTO authored the SRS non-interactively; this file holds
> what it could not settle from the inputs (the PRD and any context/constraints).
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this
> file**, then re-run `product-srs`. It folds your answers into the SRS and drops the
> resolved items. When nothing is left open, `product-srs` **deletes this file**: no file =
> the SRS is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CTO folds them in, it first copies this
> file whole to `docs/srs_trail/` — so what you decided, and why, stays readable and citable
> for good.

> **This companion was opened by the owner, not by a `product-srs` run.** The SRS is settled at v7
> and its companion was correctly deleted. It is re-opened deliberately because the **PRD has moved
> underneath it** — it is now Settled at v11 and admits an input v7's contract does not — and the
> SRS's loop has no other channel: with no companion on disk a `product-srs` re-run reads the
> document as done and has nothing to act on.
>
> **The directive arrives settled, so this round is a fold and not an interview.** Everything below
> is already decided upstream by the owner and carried in `docs/PRD.md` v11; what is open is the
> technical statement of it, which is the CTO's.

---

## 1. Open issues — technical questions with no answer yet

### 1.1 The input contract says "exactly one local Git repository"; the PRD now admits a plain folder

- **Why it matters:** `SRS.md:73-76` (FR-1) states the system operates against *"exactly one local
  Git repository per run"*, and `:77-80` (FR-2) that *"the repository to view is supplied when the
  system starts"*. `docs/PRD.md` is Settled at **v11**: the input is a **local folder — a Git
  repository or not** — and the plain folder is **inside v1**, not beyond it (owner-confirmed,
  `docs/prd_trail/cycle-10.md` § 2.3). The SRS is the technical source of truth the SDD and every
  downstream slice build against, so while its contract says *repository* the whole chain below it
  keeps inheriting an input the product no longer only has.
- **Reasoning / what would settle it:** the owner settled the product questions; what is open is
  the technical statement. **This is not a two-line edit to FR-1 and FR-2.** The requirements
  derived from Git — status, changed files, branch, the live refresh, and every acceptance
  criterion written over them — are phrased as though Git is always present, and each owes a
  statement of what holds when it is not. A requirement that assumes Git and says nothing about its
  absence is the defect this round exists to remove.
- **Answer:** **Widen the input contract to a local folder, which may or may not be a Git
  repository, and carry the absence through every Git-derived requirement.** The owner's product
  sentence, given verbatim: **KA-Reader is a reader of folders, files and repos** — the three named
  flat, none subordinate to another. The Agari already carries the same widening
  (`system/projects/ka-reader/agari.md`, round 2), including its read-only integrity bar, which now
  reads *no write to the viewed folder — whether or not it is a repository*.

  **Three answers from the PRD are settled input and must be carried, not re-derived:**

  1. **In a plain folder the Git view is present and shows *nothing*.** No message, no explanation,
     no invitation to create a repository. The owner overrode the drafted *"states plainly that
     this folder is not a Git repository"* — the grounds being that VS Code fills that same state
     with *Initialize Repository* and *Publish to GitHub*, and **both are writes KA-Reader can never
     offer**, so the surface has no truthful next step (`docs/prd_trail/cycle-10.md` § 2.2). The
     tree's changed-file markers are absent in that state.
  2. **Git is read only when the folder opened is itself the root of a repository.** A folder
     *inside* a repository, and a folder that *contains* repositories, both open as plain folders.
     The rule holding it is *the tree and the Git view always describe the same folder*. The
     monorepo variant — Git scoped to a subtree — was put to the owner and **rejected**
     (`docs/prd_trail/cycle-10.md` § 2.4).
  3. **The plain folder is inside v1.** Time-to-first-success stays measured against a Git
     repository, the fuller path, with the plain folder not measured separately.

  **What is not settled here, and is the CTO's:**

  - The wording of FR-1 and FR-2, and **which requirement numbers the absence clauses attach to** —
    whether each Git-derived requirement gains a clause, or a single requirement states the rule
    once and the others cite it. Either is defensible; the round picks one and is consistent.
  - **How "is this folder a repository's root?" is determined**, stated as a requirement rather
    than an implementation — and note it must not be *"ask Git"* naively, since Git resolves a
    repository from any folder beneath its root, which is exactly the behaviour answer 2 forbids.
  - **Whether the live refresh (the watched tree) changes at all in a plain folder** — the file
    tree still moves, so refresh presumably still applies; only the Git-derived half goes quiet.
    Nothing upstream states it either way.
  - **What the acceptance criteria over Git state become** in a plain folder, so the bar is
    checkable rather than silent on the input just admitted.

## 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override

*(none drafted — this companion was opened by the owner, so the round that reads it is the first
CTO pass over the change. Items the CTO drafts belong here on its own run.)*

**Standing, and not reopened by this round:** everything else `SRS.md` settles at v7. In particular
the external-link call folded at v7 (`docs/srs_trail/cycle-6.md` § 2.1 — an external link in
rendered Markdown is displayed, not followed), the raw-source switch as a permission rather than a
promise (FR-31, RN-29), and macOS-only (C-11). This round widens the input; it does not re-cut the
scope.

## 3. Directives — an external action the owner confirms as a gate

None.
