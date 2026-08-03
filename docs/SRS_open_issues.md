# SRS open issues — Nozoki 覗き

> Companion to `SRS.md`. The CTO authored the SRS non-interactively; this file holds
> what it could not settle from the inputs (the PRD and any context/constraints).
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this
> file**, then re-run `product-srs`. It folds your answers into the SRS and drops the
> resolved items. When nothing is left open, `product-srs` **deletes this file**: no file =
> the SRS is done.
>
> Your answers are never thrown away. Each time the CTO folds them in, it first copies this
> file whole to `docs/srs_trail/` — so what you decided, and why, stays readable and citable
> for good.

> **This companion was opened by the owner, not by a CTO run.** The SRS reached Settled at v3
> with no companion beside it. It is reopened to hand in one revision the UXD handed forward —
> already answered below, so the next `product-srs` run is a fold and a close rather than a
> fresh round. Anything the fold cannot settle goes back into a rewritten companion as usual.

---

## 1. Open issues — technical questions with no answer yet

None — the one item this companion carries is a decided override, in §2.

## 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override

### 2.1 The commit history's shape — a flat read-only list, or branch topology

- **Drafted into the SRS:** FR-18 *(beyond v1)*: "The system presents the repository's commit
  history as a read-only list — for each commit its identifier, message, author, and date."
  (`SRS.md` §3.6). RN-13 carries the same shape — "the history stays a read-only list (FR-18)" —
  and AC-12 covers it as "the commit history with its per-commit diffs".
- **Rationale:** it was owner-confirmed as a list at `docs/srs_trail/cycle-1.md` §2.2, which was
  the settled answer when the SRS was written. That answer has since been **superseded on the
  experience side**: the owner reopened the history's shape during the UXD's first round
  (`docs/uxd_trail/cycle-1.md` §2.1 → `docs/ux_reference/README.md` § Owner directives 1) and
  confirmed a topology statement in the second (`docs/uxd_trail/cycle-2.md` §2.1). The UXD
  recorded the collision and handed it here rather than absorbing it — `UXD.md` RN-14: "the SRS's
  FR-18 still describes the history as a flat read-only list … and needs a CTO revision".
- **If overridden** (the list stands): the UXD's UX-F4, UX-S6 and RN-14 would have to be reopened
  with the CDO, since the two documents cannot both be right. That is not what is being asked
  here — the override below runs the other way.
- **Confirm or override:** **OVERRIDE — revise FR-18 to the owner-confirmed experience shape.**
  The properties are bound; the mechanism is not, and stays the SDD's.
  - *The shape to carry.* When the repository's history holds more than one branch, the reader
    can see the branches as branches — which commits belong to which, and where they diverge and
    merge — never a flat list that flattens them together. The history is drawn against a
    **chosen set** of branches — one, several, or all of them — with a default that asks nothing
    (the current branch and what relates to it), so the reader chooses what is drawn and does not
    have to. Per commit: identifier, message, author, and date, with its changed files reachable
    from its entry. Read-only throughout. The authority is `UXD.md` UX-S6 and RN-14 — take the
    wording from there rather than from this paraphrase.
  - *Bind the properties, not the mechanism.* The owner bound what the reader can see, not how it
    is drawn or what control chooses the set (`UXD.md` RN-14 — "the owner bound the properties,
    not the mechanism"). A requirement that names a graph rendering, a control, or a layout has
    overreached into the SDD's territory.
  - *What does not move.* History **filtering and search stay outside done** — the set-scoping
    control chooses which branches are drawn, it does not filter the history, and nothing here
    reopens `docs/srs_trail/cycle-1.md` §2.2 beyond the history's shape. The diff shape is
    untouched: FR-17 (staged distinguished from unstaged) and FR-22 (selecting a commit presents
    what it changed, in the same diff presentation) both stand as written. FR-18 stays
    *(beyond v1)*, and it stays **inside the terminus** — commit history is named in the Agari's
    first condition, so the revision may not push it back out of §3.6.
  - *Blast radius to walk rather than assume.* At minimum FR-18 itself, RN-13's "the history stays
    a read-only list" clause, and AC-12's coverage of the history. Check §2's summary prose
    (`SRS.md` §2, the deferred-features sentence) and §3.6's framing too, and anything else that
    restates the list shape — grep the document for it rather than trusting this list. Add a note
    recording the revision and its source, as the SRS's own provenance rule requires.
  - *Feasibility is yours to raise, not to narrow with.* The UXD states plainly that feasibility
    is downstream and does not narrow the statement. If drawing topology raises a scale or
    performance concern — §4's scale dimensions already name history length — raise it as a new
    item in the rewritten companion. Do not quietly re-narrow the requirement to fit it.
