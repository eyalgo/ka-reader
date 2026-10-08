# SRS open issues — KA-Reader

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
> `SRS.md` is Settled at v8 and its companion was correctly deleted. It is opened because the
> Principal Architect's constraint set could not bound the diagnostic log without a source —
> `docs/nfdr.md` QC-40 says the bound is undecided and names NFR-11 as where it lands — and the
> run answering that companion (`docs/architecture_open_issues.md` § 1.2, recorded in
> `docs/trail/architecture/self_answer-1.md` § 1.2) judged the change belongs here. With no
> companion on disk a `product-srs` re-run reads the SRS as done and has nothing to act on. The
> one item below arrives with the run's lean and its reasoning; the decision is the next round's.

---

## 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override

### 2.1 The diagnostic log holds one session's lines and is capped within a session — a bound NFR-11 does not state
- **Drafted into the SRS:** nothing yet — this item was raised by a `companion-self-answer` run
  on the architecture companion, not by a `product-srs` run. Proposed for NFR-11 by revision: *the
  diagnostic log holds at most the current session's lines — nothing from an earlier session
  survives a launch — and within a session it is bounded to 1 MiB, past which it is emptied and
  writing continues, so the most recent lines are always the ones present and the file never grows
  without bound.*
- **Rationale:** NFR-11 keeps diagnostics with the tool's own state, and the SDD has the host write
  one line per `failed` or `stopped` item to a log in the app's container (`docs/SDD.md` § 4 C-I2).
  Nothing bounds the file: a session over a folder an agent rewrites for a week grows a line per
  transient failure indefinitely, and a builder would pick a bound silently. The NFDR cannot state
  one without a source (`docs/nfdr.md` QC-40). *One session's log*, because every line in the file
  is then this session's or the last one's — which is what makes a log with no timestamp field
  (C-I2 names the part, the operation and the error text) readable at all. *A within-session cap*,
  because "one session" alone does not answer the week-long session that raised the question.
  *Emptied-and-continue* rather than stop-writing, so the newest failures — the ones a reader opens
  the file for — are the ones kept. *1 MiB*, because the file is text a person opens in an editor,
  and a megabyte is on the order of ten thousand lines of C-I2's shape — more failures than anyone
  reads; the number is proposed, not measured, and is the CTO's to replace.
- **If overridden:** keeping the previous session as well — a one-generation rotation to
  `ka-reader.log.1` at launch — covers the case this draft does not: a session that crashed and was
  relaunched before its log was read loses those lines. It costs a second file, which the NFDR's
  QC-52 ("written to … `ka-reader.log` and nowhere else") and the SDD's C-I2 would then have to name.
  A different cap changes one number. Whatever lands, the SDD's C-I2 carries the mechanism by its
  own revision, and the NFDR's QC-40 carries the checkable number and the test that reads it.
- **Confirm or override:** **confirm — with three additions, and the number stands.** NFR-11 takes the
  proposed sentence: one session's lines, emptied at launch, bounded within a session to 1 MiB with
  emptied-and-continue. 1 MiB is this seat's own call, not a placeholder for one — a design bound a
  reader can check, not a threshold a build measures, so RN-4's rule does not reach it. (1) **The cap
  is on the file's size on disk**, not on the bytes the writing process has produced — so two
  instances writing one file (reachable: `open -n`, *"Open a new instance of the application even if
  one is already running"*, `man open`) each empty it at the cap and the bound still holds. (2) **A
  failure to write the log is not a failure the user must know about**: it surfaces nowhere, stops no
  item's presentation, and is not retried — the line is simply not written. Without this, "visible
  in the UI itself" could be read as reaching the log's own failures. (3) **"Emptied at launch" reads
  create-or-truncate**: the first launch creates the file under the own-state location FR-21 and DR-5
  allow, every launch after truncates it. The one-generation rotation is declined: the log records
  item failures (SDD C-I2), not crashes of the host, and an item failure that persists is reproduced
  by the next session's first refresh (NFR-3) — the previous session's lines buy less than a second
  file costs QC-52. Reasoning: `docs/trail/srs/self_answer-1.md` § 2.1.

### 2.2 Every trail pointer in this document is dead — the folders moved and the citations did not

> **Raised by a `companion-self-answer` run answering `docs/UXD_open_issues.md`, not by a run of this
> document's own producing skill.** No item on this companion asked for it. It is raised because the
> same defect was measured across every document in `docs/` while answering that companion's § 2.1,
> and this document carries **80** of it. The full measurement is `docs/trail/uxd/self_answer-1.md`.

- **Raised by:** the run above — not one of this document's own seats.
- **What this document says:** **80** citations of the form `docs/<x>_trail/…` (`docs/prd_trail/`, `docs/srs_trail/`, `docs/uxd_trail/`).
- **What is true:** none of those folders exists. The retired cycles live at `docs/trail/<x>/`, moved by
  `ka-reader@1e8bf3d` ("the six answer-trails move under `docs/trail/`"), which did not update the documents citing them. Every one is a pointer a cold reader follows and finds nothing, and these are mostly
  **authorization** pointers — the owner answer a Review Note rests on cannot be opened to check it.
- **Drafted:** each `docs/<x>_trail/` becomes `docs/trail/<x>/`. Nothing the document says changes;
  only where it points. A pointer repair, not a revision.
- **One exception, and it is not hypothetical.** A citation pinned to a commit — the form
  `ka-reader@<sha>:docs/<x>_trail/…` — must be left exactly as it is: it resolves at a commit where that
  path did exist (verified — `git show 1d5c553:docs/uxd_trail/cycle-1.md` returns the file), so
  rewriting it breaks a citation that currently works. This document carries **0** pinned citations; `docs/UXD.md` carries 4. A sweep that does not exclude the
  pinned form is wrong.
- **Scale, so this is not read as a local slip:** **235** dead pointers across six documents — PRD 2,
  SRS 80, SDD 40, UXD 71, DESIGN 30, CONTENT 12; 231 of them unpinned. The cheapest repair is plainly
  one mechanical sweep across all six rather than six document cycles, and which way it is done is the
  owner's call. This item exists so the defect is not invisible if no cycle is ever spent on it.
- **Confirm or override:** **confirm — with two additions, and the second keeps three of the 80 out
  of the sweep.** (1) **The measurement holds for this document, and the bare form is absent.** 80
  by `docs/<x>_trail/`, 80 by the bare `<x>_trail/` pattern too — unlike the PRD, where the bare form
  hid 60 (`docs/trail/prd/self_answer-1.md` § 2.1) — and 0 commit-pinned, re-checked on the whole
  file for any `@<sha>:` form. All 16 distinct `prd_trail` / `srs_trail` files cited exist at
  `docs/trail/<x>/`, checked one by one on 2026-09-01. So the drafted rule applies to the **77**
  `docs/prd_trail/` and `docs/srs_trail/` citations. (2) **The three `docs/uxd_trail/` mentions are
  excluded**, and each for its own reason. RN-19 (`docs/SRS.md:724`) and RN-20 (`:742`) say that
  path *"were removed from the product repository at `9017ae2`"* — a historical statement, true as
  written and false once rewritten: `docs/trail/uxd/` was never removed. RN-19's citation
  (`:712`, *"owner-confirmed: `docs/uxd_trail/cycle-2.md` §2.1"*) points at the **pre-`9017ae2`**
  UXD's cycle 2 — its § 2.1 is the history's branch topology (`git show
  1d5c553:docs/uxd_trail/cycle-2.md`) — while the file now at `docs/trail/uxd/cycle-2.md` is the
  **re-authored** UXD's cycle 2, whose only item is the theme control's home. The rule applied there
  turns a dead pointer into a false one. That citation takes the commit-pinned form the item itself
  protects — `ka-reader@1d5c553:docs/uxd_trail/cycle-2.md` § 2.1 — which resolves. The version line
  records the change with its reason, `ka-reader@1e8bf3d` (`system/doctrine/writing_bar.md` § 1.6).
  Reasoning: `docs/trail/srs/self_answer-1.md` § 2.2.

### 2.3 RN-35's sibling sentence — "`docs/UXD.md` UX-S4 still makes a non-repository a startup failure" — describes a state that ended at UXD v6

> **Raised by the `companion-self-answer` run that answered this companion's § 2.1 and § 2.2, not by
> a `product-srs` run.** No item on this companion asked for it. It is raised because the SRS was
> read whole for those two items and this sentence, true when v8 was written, is false now. The
> measurement is `docs/trail/srs/self_answer-1.md` § Raised on this document. One item, appended in
> this bucket with its slot at the placeholder; the decision is the next round's.

- **Raised by:** the run above — not one of this document's own seats.
- **What this document says:** RN-35 (`docs/SRS.md:938-941`): *"The sibling: `docs/UXD.md` UX-S4
  still makes a non-repository a startup failure; the UXD follows the PRD, not this SRS, and its
  revision is the CDO's through the UXD's own skill — this SRS records the divergence and does not
  reshape FR-3 or FR-34 to it."*
- **What is true:** the UXD reached v6 after SRS v8 — `ka-reader@e4ed5fe` (SRS v8) then
  `ka-reader@dd08f2d` (UXD v6), and UXD RN-28 says it read `docs/SRS.md` v8 as its sibling
  (`docs/UXD.md:817-820`). At v6, UX-S4 *"narrows to a path that does not exist, is not a folder, or
  cannot be read"* (`docs/UXD.md:5`), and its row reads *"A folder that is not a Git repository is
  not on this list: it opens (UX-I17; narrowed at v6 with PRD v11 — RN-25)"* (`docs/UXD.md:229`).
  RN-28 found no collision with FR-33 / FR-34. The divergence RN-35 records has closed.
- **Drafted:** RN-35's sibling sentence gains a closing clause — the divergence ended at UXD v6
  (UX-S4, RN-25; RN-28 reads this SRS as its sibling and finds no collision) — the same way RN-35
  itself records the end of RN-29's "the PRD is not corrected here" rather than rewriting RN-29.
  The note's wording as written stands as history; no requirement moves, and nothing else in the
  SRS changes for this item. It rides the fold § 2.1 and § 2.2 already owe, so it costs no extra
  cycle.
- **If overridden:** leaving RN-35 as written keeps a claim about another document that a reader
  who opens `docs/UXD.md` finds false at the row it names.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">
