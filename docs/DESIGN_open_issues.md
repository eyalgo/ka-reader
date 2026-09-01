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
> `DESIGN.md` was Settled at v6 and its companion was correctly deleted. It is opened because a run
> answering the FDR's companion (`docs/fdr_open_issues.md`, recorded in
> `docs/trail/fdr/self_answer-1.md` § Companions opened) measured the sibling collision the FDR's
> RN-14 records — this document still named the input as one Git repository and the chrome's
> control as the repository selector — and found it standing at v6, with nothing raised here. With
> no companion on disk a `product-design` re-run reads the language as done and has nothing to act
> on. The one item below is a wording defect and not a token.
>
> **Where this round stands.** A `product-design` run has taken this file up, found its one answer
> slot empty, and so folded no answer and retired no trail cycle. It applied the rename anyway, on
> the authorization its own rule gives an upstream UXD change (`docs/UXD.md` v6 RN-25 renamed the
> control with PRD v11's input — `<CORE>/prompts/cdo_create_design.md` § *The stability rule*), and
> recorded every line that moved and every line that stays at `docs/DESIGN.md` RN-27; `DESIGN.md`
> is at v7 and reads Draft while this file is on disk. The item is kept as **your sign-off on what
> was applied**: *confirm* and the next run closes this file; *override* and the next run rewords
> to what you say. No token, colour, type, spacing or radius value moved.

---

## 2. Choices to confirm

### 2.1 § Overview, § Layout, § Elevation & Depth and § Components name the input *folder* and the chrome's control the *folder selector* — applied at v7 on the UXD's authority, awaiting your sign-off
- **Drafted into DESIGN.md:** at v7 — § Overview `:322` *"a read-only viewer for one local folder —
  a Git repository or not"* and `:336` *"shows a folder"*; § Layout `:485` *"ordinary folders"* and
  `:490` *"the folder selector on the left"*; § Elevation & Depth `:512` *"the folder selector's
  list"*; `{components.chrome}` — *"the **folder selector** on the left — the current folder's name
  as both label and control"* (§ Components "The chrome and its controls", `:552`) and *"the chrome
  names the folder, not the product"* (`:558`); `{components.menu}` — *"lists the remembered
  folders, each shown by its name — the name is the entry's label, not the list's order, which is
  behaviour and the UXD's to state (UX-S7), so this document sets none"* (§ Components "The menu",
  `:565`); the wordmark Don't (`:736`); RN-9, RN-10 and RN-20 (*the folder's*, *the folder
  selector*); the UX-F5 / RN-15 / RN-25 Traceability row; and RN-27, which lists what moved and
  what stays. Left as written, because there the word means Git or follows a UXD entry still worded
  so: *colour belongs to the repository* (RN-2's signature, in the words you confirmed at
  `docs/trail/design/cycle-1.md` § 2.1), *Density is the repository's* (`docs/UXD.md` § 2 as it
  reads), the path line's *repository-relative path* (`docs/UXD.md` § 4 as it reads), and every
  sentence telling a clean repository from a plain folder.
- **Grounds:** `docs/PRD.md` § Purpose (v11) makes the input a folder — *"a reader of folders,
  files and repositories — the three named flat"*; `docs/UXD.md` UX-F5 and RN-25 (v6) name the
  control the **folder selector** and read every input "repository" as "folder";
  `docs/CONTENT.md` § Terminology fixes *folder selector* and lists *repository selector* as the
  rejected name — *"the name this document carried while the input was a repository; the control,
  its list and its browse entry are unchanged and only its input is wider"*; the instance's writing
  bar binds every document here to one name per term (`system/doctrine/writing_bar.md` § 1.2).
  `docs/fdr.md` § FDR Review Notes RN-14 records the residue as *"a stale sibling, not a collision
  with a rule here, and the CDO's to revise"*. The one reading the original item asked to settle —
  whether *"lists remembered repositories by name"* meant *shown by its name* or *ordered by name* —
  is settled as the first: the sentence now says so, and the list's order is stated nowhere in this
  document, because it is behaviour the UXD owns at UX-S7 (its own companion's answer, unfolded,
  orders the list most recently viewed first — `docs/UXD_open_issues.md` § 2.1 (5) — and this
  document will follow the UXD once that is folded, not before). No token, colour, type, spacing or
  radius value moves. If you override: the run rewords the lines above to what you say and
  records the override in RN-27; `docs/UXD.md`, `docs/PRD.md` and `docs/CONTENT.md` keep *folder*
  and *folder selector*, so an override here reopens the one-name rule across the set and is theirs
  to reconcile through their own runs.
- **Confirm or override:**
