# UXD open issues — Nozoki

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
> file whole to `docs/trail/uxd/` — so what you decided, and why, stays readable and citable
> for good.
>
> **A third source of items, and it is not the CDO.** § 3 holds what a seat downstream of the UXD
> found missing while working from documents the UXD fed. It is answered here and folded by the same
> run, but it was never this run's question.

> **No `product-uxd` run wrote this file.** A `companion-self-answer` run opened it on 2026-10-01
> from the UXD's own companion template, while it was answering `docs/SDD_open_issues.md` § 5.1. It
> acted under `<CORE>/prompts/decide_companion_answers.md` § *The items are not the whole of what a
> document is owed*. The UXD is an input of the SDD, so that run read it whole, and the finding
> below has nothing to do with the item it was answering. The file exists because `UXD.md` is
> Settled at v10, and with no companion on disk a `product-uxd` re-run reads it as done and has
> nothing to act on. Its one item is in § 2, and its slot is left at the placeholder: the reasoning
> is that run's, and the decision belongs to the next round. §§ 1 and 3 hold nothing. Reasoning:
> `docs/trail/sdd/self_answer-29.md`, § *Companions opened*.

---

## 1. Open issues — experience questions with no answer yet

None.

## 2. Choices to confirm — the CDO drafted a best-effort answer; confirm or override

### 2.1 UX-U1 states the reader floor the PRD replaced at v9
- **Drafted into the UXD:** Nothing has been written into the UXD. As it stands, UX-U1 reads
  "Expertise floor: can find their way around a repository on GitHub and follow a README — no
  editor experience, and no Git knowledge beyond that", and traces the sentence to PRD § Goals
  "No learning curve" (`docs/UXD.md:L49-L51`). The draft change: UX-U1's floor sentence takes the
  floor that PRD section states now, which is someone who works with Git and can follow a README,
  assumed to know Git, with no editor experience required. The wording is the CDO's.
- **Rationale:** The PRD section UX-U1 cites no longer says what UX-U1 says. It reads "anyone who
  works with Git and can follow a README can use Nozoki: the reader is assumed to know Git, and the
  product may leave Git's own vocabulary unexplained", and its marker says the sentence "supersedes
  the 'find their way around a repository on GitHub' floor" on the owner's answer at
  `docs/trail/prd/cycle-8.md` § 1.1 (`docs/PRD.md:L96-L103`). That answer is the owner's own words:
  "Remember, users of nozoki most likely know how git works." The PRD carried it from v9
  (`nozoki@a85bc24`, 2026-08-26). The UXD was revised after that, at v6 (`nozoki@dd08f2d`) and up to
  v10 (`nozoki@4d7b653`), and no review note records the floor being re-read: RN-25 and RN-30 say
  UX-U1 does not move, and each is about the word *repository*, not the floor
  (`docs/UXD.md:L799`, `:L920`). The other documents derived from the PRD carry the new floor:
  `docs/SRS.md` NFR-15 (`:L383-L388`), `docs/fdr.md` R-144 (`:L261`) and `docs/CONTENT.md` § *Voice*,
  the *Startup fails* row (`:L82`). `grep -n -i "works with Git" docs/UXD.md` prints nothing, and
  `grep -n "GitHub" docs/UXD.md` prints `:L49` as its one line about the reader. The UXD's later
  entries already assume the new floor: UX-S3's short status names a state "in Git's own word for
  it" (`docs/UXD.md:L238`). So UX-U1 contradicts the PRD it traces to, and it sits apart from the
  rest of its own document. The doubt, stated: the wording standard is `docs/CONTENT.md`'s and it
  carries the new floor, so a message written from that document is pitched correctly today. The
  item is raised because the UXD is read cold by every change spec that touches a surface
  (`docs/UXD.md:L18-L21`), and a spec that takes its reader from UX-U1 takes a floor the owner
  replaced.
- **If overridden:** UX-U1 keeps a floor that disagrees with `docs/PRD.md` § Goals, `docs/SRS.md`
  NFR-15, `docs/fdr.md` R-144 and `docs/CONTENT.md`. No flow, screen, interaction pattern or
  accessibility requirement moves under either answer. If the draft is taken, one sentence of UX-U1
  moves and a review note records why. § 11's row for UX-U1 already names the PRD section and stays
  as written.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write the UXD

None.
