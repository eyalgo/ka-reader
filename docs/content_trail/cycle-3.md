# CONTENT open issues — Nozoki 覗き

> Companion to `CONTENT.md`. The Content Editor authored the verbal language non-interactively;
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
> Your answers are never thrown away. Each time the Content Editor folds them in, it first copies
> this file whole to `docs/content_trail/` — so what you decided, and why, stays readable and
> citable for good.

> **This companion was opened by the owner, not by a `product-content` run.** `CONTENT.md` is settled
> at v3 and its companion was correctly deleted. It is re-opened deliberately because the **UXD and
> the design language have both moved again** — `docs/UXD.md` is Settled at **v6** and
> `docs/DESIGN.md` at **v5** — and this document's loop has no other channel: with no companion on
> disk a `product-content` re-run reads the verbal language as done and has nothing to act on.
>
> **The change arrives settled, so this round is a fold and not an interview.** All four items below
> are derivable from the settled documents. **Most of this round is subtraction**, which is unusual
> and is stated so the round does not mistake removal for damage.

---

## 1. Open issues

### 1.1 The worked example for the *Terminal* rule shows a message the product can no longer produce

- **What was searched:** `CONTENT.md:62` illustrates *a message names one thing the reader can do
  next* with *"Point Nozoki at the top folder of a repository — the one you cloned — and start it
  again."* — contrasted against *"Not a Git repository."*
- **Why it matters:** under `docs/PRD.md` v11 a folder that is not a Git repository **opens**. Both
  halves of that example describe a refusal that no longer happens, so the document teaches one of
  its own core rules with a message that can never be shown. It is also the most-quoted line in the
  file, which is how a stale example spreads.
- **Answer:** remove it, and illustrate the *Terminal* rule with a failure that **still exists**.
  UX-S4 still covers a path that does not exist, is not a folder, or cannot be read (`docs/UXD.md`
  v6), and any of those carries a real next action. Do **not** rewrite the old example into a
  message for a state that does not exist.

### 1.2 UX-S4 narrowed, and two traceability rows still describe the old scope

- **What was searched:** `:415` — *UX-S4 Startup failure | Message patterns § Error; Tone (first-run
  flow) | The worked example; three sentences at most.* And `:423` — *UX-F5 Switch the viewed
  repository | Terminology (repository selector, path) | The startup failure wording is reused for a
  chosen path.*
- **Why it matters:** UX-S4 no longer owns the non-repository case. The `:415` row points at the
  worked example item 1.1 removes. The `:423` row says the startup-failure wording is reused when a
  chosen path fails — but choosing a plain folder in the selector is now **success**, so the reuse
  claim is wider than the case that remains.
- **Answer:** repoint both rows at UX-S4 as it now reads, and narrow `:423`'s reuse claim to the
  failures that survive. `docs/UXD.md`'s own UX-S4 traceability row already carries the shape of the
  correction — *"A folder without Git is not on this list"*.

### 1.3 The plain folder's Git view carries no words, and nothing here says so

- **What was searched:** `grep -c 'UX-I17' CONTENT.md` returns **0**.
- **Why it matters:** this document owns **whether content is needed**, not only how it is worded. A
  surface that deliberately carries no words is this document's statement to make; its silence on the
  point is indistinguishable from having overlooked it, and the next reader may "fix" it by writing a
  message.
- **Answer:** state it positively. In a plain folder the Git view carries **no words at all** — no
  message, no label — and that is a decision, not a gap. The reason belongs with it: the two actions
  a Git-less folder would otherwise invite are **writes this product can never offer**
  (`docs/prd_trail/cycle-10.md` § 2.2, the owner's decision). `docs/DESIGN.md` v5 records the
  matching half — the state holds no instance of `{components.status-message}`.

  **Do not draft a message for it, not even as an example of one not used.**

### 1.4 Terminology: *repository* where it meant the input

- **What was searched:** `docs/UXD.md` v6 RN-25 — every *"repository"* that meant the input now reads
  *"folder"*, **the selector included**. `CONTENT.md`'s Terminology owns those names, and
  *repository selector* is one of them (`:423`).
- **Why it matters:** the two documents will name the same control differently, and this one is the
  authority for names.
- **Answer:** widen the terms that meant **the input**, and only those. The words for Git's own
  furniture — branch, commit, diff, history — are unaffected: they name Git things, not the input.
  Where a term's rationale column argues from the input being a repository, the argument moves with
  the word.

## 2. Choices to confirm — the Content Editor drafted a best-effort answer; confirm or override

*(none — all four items are derivable from the settled documents and arrive answered.)*

**Standing, and not reopened by this round:** every rule in this document. The register, the
no-exclamation rule, the silence during habitual use, and the unexplained fault's words (RN-12, the
UX-I16 surfaces folded at v3) all stand. This round removes a stale example, repoints two rows,
states one deliberate silence, and widens the input's name.
