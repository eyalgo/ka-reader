# DESIGN open issues — Nozoki 覗き

> Companion to `DESIGN.md`. The CDO authored the design language non-interactively; this file
> holds the calls it made and wants your sign-off on — each with the reason behind it, and what
> moves underneath it if you override — plus the few things it genuinely could not settle, and,
> when a design run has produced output for this product, the pointer to it.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-design`. It folds your answers into `DESIGN.md` and drops the resolved
> items. When nothing is left open, `product-design` **deletes this file**: no file = the
> design language is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CDO folds them in, it first copies this
> file whole to `docs/trail/design/` — so what you decided, and why, stays readable and citable
> for good.

> **This companion was opened by a `companion-self-answer` run, not by a `product-design` run.**
> `DESIGN.md` is Settled at v6 and its companion was correctly deleted. It is opened because a run
> answering the FDR's companion (`docs/fdr_open_issues.md`, recorded in
> `docs/trail/fdr/self_answer-1.md` § Companions opened) measured the sibling collision the FDR's
> RN-14 records — this document still names the input as one Git repository and the chrome's
> control as the repository selector — and found it standing at v6, with nothing raised here. With
> no companion on disk a `product-design` re-run reads the language as done and has nothing to act
> on. The one item below is a wording defect and not a token; the decision is the next round's.

---

## 2. Choices to confirm

### 2.1 § Overview and § Components name the input as *one local Git repository* and the chrome's control as the *repository selector*, which PRD v11, UXD v6 and CONTENT v4 renamed
- **Drafted into DESIGN.md:** `DESIGN.md:322` — *"Nozoki is a read-only viewer for one local Git
  repository"*; `{components.chrome}` — *"the **repository selector** on the left — the current
  repository's name as both label and control"* (§ Components "The chrome and its controls",
  `:552`); `{components.menu}` — *"The selector's menu lists remembered repositories by name"*
  (§ Components "The menu", `:565`); § Layout `:490` and RN-20 carry the same name.
- **Grounds:** `docs/PRD.md` § Purpose (v11) makes the input a folder — *"a reader of folders,
  files and repositories — the three named flat"*; `docs/UXD.md` UX-F5 and RN-25 (v6) name the
  control the **folder selector** and read every input "repository" as "folder";
  `docs/CONTENT.md` § Terminology fixes *folder selector* and lists *repository selector* as the
  rejected name — *"the name this document carried while the input was a repository; the control,
  its list and its browse entry are unchanged and only its input is wider"*. DESIGN v6
  (2026-09-01) repaired citations and kept the words. `docs/fdr.md` § FDR Review Notes RN-14
  records this as *"a stale sibling, not a collision with a rule here, and the CDO's to revise"*,
  and nothing raised it here. Proposed: the four sentences read *folder* where they mean the
  input, and the control is the *folder selector*; no token, colour, type, spacing or radius value
  moves. One reading to settle while there: *"lists remembered repositories by name"* is read by
  the FDR companion's answer as *shows each by its display name*, not *ordered by name* — that
  answer orders the list most recently viewed first, ten entries, the current one marked
  (`docs/fdr_open_issues.md` § 1.2); say which this sentence means.
- **Confirm or override:**
