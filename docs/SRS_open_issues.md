# SRS open issues — Nozoki 覗き

> Companion to `SRS.md`. The CTO authored the SRS non-interactively; this file holds
> what it could not settle from the inputs (the PRD and any context/constraints).
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this
> file**, then re-run `product-srs`. It folds your answers into the SRS and drops the
> resolved items. When nothing is left open, `product-srs` **deletes this file**: no file =
> the SRS is done.
>
> Your answers are never thrown away. Each time the CTO folds them in, it first copies this
> file whole to `docs/trail/srs/` — so what you decided, and why, stays readable and citable
> for good.

> **This companion was opened by a `companion-self-answer` run, not by a `product-srs` run.**
> `SRS.md` is Settled at v10 and its companion was correctly deleted at that version. It is opened
> because a run answering the FDR's companion (`docs/fdr_open_issues.md`, recorded in
> `docs/trail/fdr/self_answer-1.md` § Companions opened) confirmed an FDR rule that contradicts
> FR-13 and AC-6 as written at the closing release — a contradiction the SDD and the FDR both
> record as this document's to resolve, with nothing raised here since. With no companion on disk
> a `product-srs` re-run reads the SRS as done and has nothing to act on. The one item below
> arrives with the run's proposal and its reasoning; the decision is the next round's.

---

## 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override

### 2.1 FR-13 and AC-6 have the Git-view row open the file for reading at the closing release, where the owner's answer has it open the diff
- **Drafted into the SRS:** FR-13 reads *"A file listed in the Git view can be opened for reading
  exactly as a tree selection is"* (`docs/SRS.md` § 3.4); AC-6 reads *"... the Git view shows all
  four elements (changed files, staged files, branch, status) correctly, and its files open for
  reading"* (`docs/SRS.md` § 8). Neither is conditioned on whether the diff (FR-17) exists.
- **Rationale:** the owner answered the SDD's question by demonstration against VS Code's Source
  Control view: the row opens the **diff** — one click target, the status letter a label, the file
  itself read from the tree (`docs/trail/sdd/cycle-1.md` § 1.2), folded as `docs/SDD.md` § SDD
  Review Notes RN-20 and S-7. The FDR follows it: R-69 keeps FR-13's behaviour while the diff does
  not exist and R-70 has the row open the diff once it does, with RN-1 recording *"a genuine
  contradiction between two of the three sources at the closing release"* and naming the SRS
  revision as the CTO's (`docs/fdr.md` § FDR Review Notes RN-1). The FDR companion's self-answer
  confirmed R-70 (`docs/trail/fdr/self_answer-1.md` § 2.1). At the closing release (AC-12), AC-6
  as written fails against the built product, and v10's status line says *"No requirement moves"*
  because nothing had raised this here.
  Proposed: FR-13 gains its condition — a file listed in the Git view opens for reading as a tree
  selection does **until the diff (FR-17) exists**; from then on activating its row opens that
  file's diff, and the file is read from the tree. AC-6's *"its files open for reading"* takes the
  same condition, and AC-12 exercises the row opening the diff. FR-17 and FR-22 do not move.
- **If overridden:** if FR-13 stands as written at the closing release, the FDR's R-70 is removed
  by that upstream change and the diff needs a different way to open — a second target on the row,
  or a control on the reading panel's path line — which is the UXD's call and reaches the FDR
  through it (`docs/fdr_open_issues.md` § 2.1 "If overridden"); the owner's trail answer is then
  the thing overridden, and RN-20 in the SDD says so.
- **Confirm or override:**
