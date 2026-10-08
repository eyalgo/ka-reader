# PRD open issues — KA-Reader

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

> **This companion was opened by the owner, not by a `product-prd` run.** The PRD is settled at v9
> and its companion was correctly deleted. It is re-opened deliberately because the owner issued a
> product directive during a downstream run — the SDD's `companion-answer` walk — and the PRD's loop
> has no other channel: with no companion on disk a `product-prd` re-run reads the document as done
> and has nothing to act on.
>
> **The directive arrives with the owner's ruling already recorded**, so this round is a fold and
> not an interview. What is *not* settled is the wording, the product sentence it implies, and the
> knock-on lines listed in § 2 — those are the CPO's to write. The round's job is to make `PRD.md`
> say this and stay coherent with everything else it settles at v9.

---

## 1. Open issues — product-defining questions with no answer yet

### 1.1 A folder that is not a Git repository is a startup failure; the owner wants it to open, with the Git view disabled

- **Why it matters:** `PRD.md` today admits exactly one input — a local Git repository — and every
  document downstream reads it that way. `docs/UXD.md:205` (UX-S4) makes a non-repository a
  **startup failure**, a surface that "exists only in failure", whose route out in v1 is "to change
  the path and start again"; `docs/SDD.md:276-280` (C-R3) implements exactly that, and its
  `read-a-repository` slice is built against it. Making a plain folder open is therefore not a
  UX tweak downstream — it changes what the product *is*, which is this document's and nobody
  else's. Until the PRD says it, the SRS cannot widen its input contract (FR-1, FR-2) and the UXD
  cannot draw a state that the product definition does not admit.
- **Reasoning / what would settle it:** the owner settled it; what follows is the record. The
  directive was given on 2026-08-26 during the `companion-answer` walk of `docs/SDD_open_issues.md`,
  in these words: *"and repo without git should be acdesible. the git tree will be disabled."* It was
  deliberately **not** written into any slot of that companion — an SDD companion slot would have
  put a product decision where only the CTO reads it, and the PRD, SRS and UXD would have gone on
  saying the opposite. It is recorded in full in the body of the answering commit, `ka-reader@86903c2`.
  The journey moves that followed are `kensaiapp-opensource@9fb6e9f` (the SDD station parked
  unreached) and `@04b709b` (the definition seed un-picked), and this station is item 1 of the seed
  `2026-08-26_open-a-plain-folder`.
- **Answer:** **A folder that is not a Git repository opens.** The tree and the reading panel work
  normally against it; the **Git view is disabled**, not absent-by-failure. KA-Reader becomes a folder
  viewer that lights up Git when it finds it, rather than a Git repository viewer that refuses
  everything else.

  **What is not settled here, and is the CPO's:**

  1. **The product sentence.** § Purpose, § Blurb and § Scope (In) all describe the input as a
     repository. Whether the product is now stated as *a folder viewer that lights up Git* or as *a
     repository viewer that degrades to a folder* is a positioning call, and it changes the README's
     first line. Neither is implied by the directive.
  2. **What "disabled" is promised to mean at product level.** The directive says the Git view is
     disabled. Whether the PRD promises the view is *present and inert* (visible, stating why) or
     *not offered at all* in that state is a product promise, and station 3 (`uxd-plain-folder`)
     draws whichever this settles. The PRD should say which, and stop — the treatment itself is the
     CDO's.
  3. **Whether the plain folder is v1 or beyond v1.** The directive does not say. § Scope and
     § Out of Scope both need a line either way, and `system/projects/ka-reader/agari.md` decides
     whether the terminus moves with it.

## 2. Choices to confirm — the CPO drafted a best-effort answer; confirm or override

*(none drafted — this companion was opened by the owner, so the round that reads it is the first
CPO pass over the directive. Items the CPO drafts belong here on its own run.)*

**Knock-on lines the round must reconcile, listed so none is missed rather than as choices:**

- § Success Metrics *"Time-to-first-success"* and *"Zero required configuration"* — both are measured
  through opening a repository. Whether the bar is now measured against a plain folder too.
- § Out of Scope *"Several repositories at once"* and *"Changing the viewed repository without
  restarting"* — both say *repository*. Whether the words widen to *folder* or the exclusions stay
  repository-shaped.
- § Key Use Cases — the cases are written over a repository with Git state. Whether a no-Git case
  joins them.
- **Everything else the PRD settles at v9 stands.** macOS only, read-only forever, one at a time,
  and sidebar search / filter, pane resizing and keyboard navigation permanently outside the done
  (`system/projects/ka-reader/agari.md`). This round widens the input; it does not reopen scope.

## 3. Directives — an external action the owner confirms as a gate

None.
