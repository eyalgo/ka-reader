# UXD open issues — Nozoki 覗き

> Companion to `UXD.md`. The CDO authored the UXD non-interactively; this file holds
> what it could not settle from the inputs (the PRD, the project's Agari and its doctrine, the
> SRS when present, and any context the owner handed over) — and, when a design run has produced
> output for this product, the pointer to it. **Answer inline** — fill each **Answer** / **Confirm-or-override**
> slot — **commit this file**, then re-run `product-uxd`. It folds your answers into the UXD
> and drops the resolved items. When nothing is left open, `product-uxd` **deletes this file**:
> no file = the UXD is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CDO folds them in, it first copies this
> file whole to `docs/uxd_trail/` — so what you decided, and why, stays readable and citable
> for good.

> **This companion was opened by the owner, not by a `product-uxd` run.** `UXD.md` is settled at v3
> and its companion was correctly deleted. It is re-opened deliberately because the **verbal
> language** round downstream of it produced a state with no surface, and `docs/UXD.md` is where a
> state is declared to exist. It carries one item.

---

## 1. Open issues — experience questions with no answer yet

### 1.1 `CONTENT.md` now has an unexplained-fault message, and § 6 declares no surface that shows it

- **Why it matters:** `docs/UXD.md` **RN-4** (`UXD.md:444-448`) states the principle this item is
  measured against — *"an unhandled state is a defect of this document."* § 6's screen inventory
  carries a **Failure** cell for every surface (UX-S1 through UX-S7), and **every one of them is a
  condition Nozoki observed**: a path that is not a readable repository, a file no longer on disk, a
  file that cannot be read, Git state transiently unreadable behind a lock. There is no cell for a
  fault the tool cannot account for. Until § 6 says where such a state appears — or that it does not
  exist in v1 — `CONTENT.md` holds a wording rule with no surface, which is precisely the shape it
  refuses to carry elsewhere.

- **What was searched:** `docs/UXD.md` § 6 (`:190`, table rows at `:198-204`) for a failure cell
  naming an unaccounted fault — there is none; `:194` for the rule that *"every failure cell carries
  a route out on the same surface (UX-I14)"*, which any new cell must satisfy; RN-4 (`:444-448`) for
  the unhandled-state principle. The state's origin is the owner's own distinction, made while
  settling the error pattern — *"there's a difference between `file not found` ... and a system
  error"* (`docs/content_trail/cycle-1.md` § 2.3) — and acted on in the CONTENT fold
  (`nozoki@9ff5144`), which split § Message patterns *Error* into two formulas: applied to a fault
  with nothing behind it, the original formula's *what it observed* clause is empty and the message
  degrades to *something went wrong*. The second formula replaces that clause with the limit of what
  the tool knows, names what is unaffected, and keeps the route out. Its wording is settled;
  `docs/CONTENT_open_issues.md` § 1.1 raised the surface question rather than deciding it, and
  `CONTENT.md` § Traceability already records that the UXD names no state for it — so nothing can
  ship the message by accident.

  **Three sub-questions, and they do not belong to one seat.** The raising item partitioned them and
  that partition is carried here rather than re-made:

  1. **Which surfaces carry it** — the reading panel, a file tree row, the Git view, the whole shell
     at startup, or some subset. **This is the CDO's and is derivable on this run**: declaring that a
     state exists and where is `docs/UXD.md`'s job. Whatever is declared owes UX-I14 a route out on
     the same surface, and UX-I13 that nothing is drawn before the state is established.
  2. **Whether the underlying fault is ever visible or reportable to the reader.** `CONTENT.md`
     § Terminology *Banned* forbids passing internal text through (*error, exception, stack trace,
     ENOENT, EACCES*), and UX-I14 rules that an issue tracker is not a route out and never stands
     alone. Both hold and neither is reopened. But a fault nobody can see is a fault nobody can
     report, and the support posture declines to promise a fix rather than declining the report.
     Offering any way to see or copy the detail is **a control**, so it is the CDO's to declare and
     **the CTO's to cost** — which is why an answer here may hand work to `product-srs` rather than
     finishing it.
  3. **Whether v1 has this class at all.** Answering that v1 ships without it is legitimate and
     complete: every failure Nozoki can reach is one it observed, and the second formula stands
     written for the first release that proves otherwise — the shape § Message patterns *Recovered*
     already uses, a decision rather than a string. **This one is a scope call and is the owner's**;
     it is not answered below, and the run should not settle it silently. If the run's derivation for
     (1) makes the class real in v1, say so and park (3) for the owner rather than treating the
     derivation as the scope decision.

- **Answer:** <the owner fills this in — or, where the run can derive (1) and (2) from § 6, UX-I13
  and UX-I14 without a scope decision, it may do so and park (3). What must not happen is (3) being
  settled by implication.>
