# UXD open issues — KA-Reader

> Companion to `UXD.md`. The CDO authored the UXD non-interactively; this file holds
> what it could not settle from the inputs (the PRD, the project's finish line and its doctrine, the
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
> file whole to `docs/trail/uxd/` — so what you decided, and why, stays readable and citable
> for good.
>
> **A third source of items, and it is not the CDO.** § 3 holds what a seat downstream of the UXD
> found missing while working from documents the UXD fed. It is answered here and folded by the same
> run, but it was never this run's question.

---

## 1. Open issues — experience questions with no answer yet

None.

## 2. Choices to confirm — the CDO drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write the UXD

### 3.1 UX-A3 keeps the first screen "to the four things"; the README's opening now carries more
- **Raised by:** PM — 2026-11-24
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; whether the README's first screen still meets UX-A3 is unanswered.
- **Where it shows:** UX-A3 (`docs/UXD.md:L413-L416`) — "so the first screen keeps to the four things the PRD fixes for it". At `ka-reader@35d5e02` the README's opening carries, besides those four and the shell screenshot, a line naming KensaiApp as maker (`README.md:L5`), six repository-local badge pictures (`:L7-L12`) and a row of four text links (`:L14`). UX-A3 governs where the posture sentence goes and does not say whether other matter may stand on the first screen; the same question stands on `docs/CONTENT.md`'s first-screen tone row, through its own companion.
- **If a document has to be written:** none; UX-A3, or the entry that owns the first screen, states whether that matter belongs there.
- **Answer:** UX-A3 binds one thing about the README's first screen: the posture sentence is not on it (the owner's words, `docs/trail/uxd/cycle-1.md` § 2.4). It admits or excludes nothing else there, and that was never this document's call: the README's content is the CPO's (UX-A3's own last sentence; § 10). So the maker line, the badges and the link row are not the UXD's to rule on. They are the shared top block every KensaiApp product's README opens with, set by the owner outside this product, and what the first screen must still carry is the PRD's and the SRS's (PRD § Goals "Pick-it-up adoption"; `docs/SRS.md` C-9: the four things stay on it). The UXD's other first-screen binding, UX-I11 (the shell screenshot shows the product as it is), is untouched. The badges are repository-local pictures, so they sit inside the instance fence that reaches the README (`system/experience/visual_restrictions.md` § `no-runtime-remote-asset`). What moves is UX-A3's reason clause, which reads as an exclusive list it never was. The fold rewrites *"so the first screen keeps to the four things the PRD fixes for it"* to say that the posture sentence takes no place on the first screen beside the four things the PRD fixes for it. It adds one sentence: this entry binds where the posture sentence goes and nothing else about the first screen, and what else stands there is the README's, which is the CPO's. No flow, screen, pattern or other requirement changes. At `ka-reader@90edb50` the posture sentence stands at `README.md:L38`, under § Promises and limits, below the opening, so UX-A3 holds as written. Reasoning: `docs/trail/uxd/self_answer-7.md` (stand-in answer, not the owner's)

**How it closes.** `product-uxd` folds it on its next run, unchanged from how it folds §§ 1–2.
