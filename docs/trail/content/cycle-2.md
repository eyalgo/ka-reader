# CONTENT open issues — KA-Reader

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

---

**Round 2.** The eight items of round 1 were all answered and are folded into `CONTENT.md` v2;
the answered file is retired whole to `docs/content_trail/cycle-1.md`. One item below is new: it
is the residue of § 2.3, where your answer settled the wording but left the state it is written
for without a home.

---

## 1. Open issues

### 1.1 The unexplained-fault message now exists, and no surface has been declared for it

- **Why it matters:** `CONTENT.md` § Message patterns *Error* — the second class, *an unexplained
  fault*, and § Traceability's row for it. The wording is settled. What is not settled is where a
  reader ever sees it, and until that is answered the pattern is a rule with no surface, which is
  exactly the kind of entry § Message patterns exists to prevent elsewhere in this document.

- **What was searched:** you drew the distinction that created this class — *"there's a difference
  between `file not found` (an example like your set of examples) and a system error"*
  (`docs/content_trail/cycle-1.md` § 2.3) — and it is a real one: applied to a fault with nothing
  behind it, the original formula's *what it observed* clause has nothing to put in it, so the
  message degrades to *something went wrong*. `CONTENT.md` now carries a second formula for it.

  The state itself, though, is not named anywhere. `docs/UXD.md` § 6 lists a failure cell for every
  surface, and **every one of them is a condition KA-Reader observed** — a path with no repository, a
  file that is no longer there, a file that cannot be read, `.git/index.lock` present. There is no
  cell for a fault the tool cannot account for. `docs/UXD.md` RN-4 states the principle that makes
  this a gap rather than an omission: *"an unhandled state is a defect of this document."*

  Three things follow, and each belongs to a different seat, which is why this run raised the item
  rather than deciding it:

  1. **Which surfaces carry it** — the reading panel, the file tree row, the Git view, the whole
     shell at startup, or some subset. That is the CDO's: declaring that a state exists, and where,
     is `docs/UXD.md`'s job, and this document only writes what it says.
  2. **Whether the underlying fault is ever recoverable by the reader.** `CONTENT.md` bans passing
     internal text through to a message (§ Terminology, *Banned*: *error, exception, stack trace,
     ENOENT, EACCES*), and `docs/UXD.md` UX-I14 rules that an issue tracker is not a route out and
     never stands alone. Both hold. But a fault nobody can see is also a fault nobody can report,
     and KA-Reader's support posture already declines to promise a fix rather than declining the
     report. Whether a release offers any way to see or copy the detail is a control, so it is the
     CDO's to declare and the CTO's to cost — this document deliberately writes **no** label for a
     control that does not exist, because a rule that cannot be applied to a real string is worth
     nothing.
  3. **Whether v1 has this class at all.** It is legitimate to answer that v1 ships without it —
     that every failure KA-Reader can reach is one it observed, and the second formula is written down
     for the first release that proves otherwise. The pattern would stay in `CONTENT.md` with that
     stated, which is how § Message patterns *Recovered* already carries a decision rather than a
     string.

  **What this run did meanwhile, so that nothing is blocked:** the second formula is written, and
  `CONTENT.md` § Traceability records that the UXD names no state for it. No release can ship the
  message by accident, because no surface has been told to show it.

- **Answer:** **Part 1 is answered by the UXD and is no longer this document's to wait on. Parts 2
  and 3 are not answered, and are open in the UXD's own companion as the owner's.** This slot
  records the state rather than a decision, because two of the three are still gated.

  **Part 1 — which surfaces carry it: DERIVED AND SETTLED.** `UXD.md` is at **v4**
  (`ka-reader@8af3e8d`). The run derived rather than chose: a fault is the tool stopping one surface's
  work, so it lands in **that surface's existing failure slot**, with the scope UX-I10 already fixes
  and the route out UX-I14 already requires. § 6's preamble now states that **every failure cell
  holds two classes** — the observed condition and the unexplained fault — and **UX-I16** states the
  presentation: on the surface of the item that stopped, scoped to it, drawn as what was observed
  (that the work stopped) and nothing more, recovering without ceremony. **RN-23** carries the basis
  and cites the owner's partition. A fault that takes the whole shell down is **n/a** — it has no
  surface, and is the SRS's crash-safety rather than a state.

  So `CONTENT.md` § Traceability's note that the UXD names no state for this is now **stale** and
  should be repointed at UX-I16 and § 6 on the fold. § 6's preamble also fixes the division of
  labour in this document's favour: *"only what the message says differs, and that is
  `docs/CONTENT.md`'s"* (`UXD.md:198`).

  **Part 2 — whether any control reveals or copies the fault's detail: DRAFTED "no", NOT CONFIRMED.**
  It is `docs/UXD_open_issues.md` § 2.1, a choice awaiting the owner. **The fold must not treat it as
  settled.** As drafted it changes nothing here: UX-I16's closing rule bans the control, which is
  consistent with this document's existing ban on internal text (§ Terminology, *Banned*) and needs
  no exception. **If the owner overrides it**, this document reopens — CONTENT would owe a string for
  the control and a stated exception to that ban — and `product-srs` re-runs to cost the detail.
  Nothing is written for that case now.

  **Part 3 — whether v1 has the class at all: OPEN, and the owner's scope call.** It is
  `docs/UXD_open_issues.md` § 1.1. The UXD records both answers as legitimate and complete, and that
  the call *"moves nothing in `UXD.md` either way — the entry is scope-neutral by design"*. The same
  is true here: the second formula is written and stays written whichever way it goes, in the shape
  § Message patterns *Recovered* already uses. What the call decides is whether the SDD and the first
  Tobiishi carry the state.

  **So what this round can fold is part 1 and nothing else.** If parts 2 and 3 are still unanswered
  when this is read, re-park them as a residue item pointing at the UXD companion rather than
  resolving them here — they are not this document's to close, and neither is blocking part 1.

<!-- Nothing is in § 2 this round: every choice put up for confirmation in round 1 was answered,
     and this run made no new call that the document hangs from. -->
