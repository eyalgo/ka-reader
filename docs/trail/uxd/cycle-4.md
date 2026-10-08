# UXD open issues — KA-Reader

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

> **This companion was opened by the owner, not by a `product-uxd` run.** The UXD is settled at v5
> and its companion was correctly deleted. It is re-opened deliberately because the **PRD and the
> SRS have both moved underneath it** — `docs/PRD.md` is Settled at v11 and `docs/SRS.md` at v8 —
> and the UXD's loop has no other channel: with no companion on disk a `product-uxd` re-run reads
> the document as done and has nothing to act on.
>
> **The change arrives settled, so this round is a fold and not an interview.** Everything below is
> already decided upstream and carried in the PRD and the SRS; what is open is the experience
> statement of it, which is the CDO's.

---

## 1. Open issues — experience questions with no answer yet

### 1.1 UX-S4 still owns the non-repository case; it is no longer a failure

- **Why it matters:** `UXD.md:205` (UX-S4, § 6) covers *"pointed at something that is not a local
  Git repository, or a path that does not exist or cannot be read"* as a **startup failure** — a
  surface that *"exists only in failure"*, whose v1 route out is *"to change the path and start
  again"*. `docs/PRD.md` v11 settles that a folder which is not a Git repository **opens and reads
  normally**, and that the plain folder is **inside v1**. `docs/SRS.md` v8 carries the contract:
  FR-1 takes one local folder, a Git repository or not, and **FR-33** states that Git is read only
  when the opened folder is itself a repository's root, with a folder inside a repository and a
  folder containing repositories each opened as a plain folder. So the UXD is now the only document
  in the set still drawing the old refusal, and it is the document every surface is drawn from.
- **Reasoning / what would settle it:** the product questions are answered; what is open is the
  experience. This round has to do three things, and the third is the one most easily missed —
  the new state is not only an addition, it is a **subtraction from UX-S4**, which otherwise keeps
  claiming a case it no longer owns.
- **Answer:** **Draw the plain folder as a working state, and narrow UX-S4 to the failures that
  remain.**

  **Three things this round carries, all settled upstream — none is a question:**

  1. **The Git view is present and shows *nothing*.** No message, no explanation, no label, and
     nothing that invites creating a repository. The owner's own words: *"the git button doesn't
     show anything. simple."* The grounds, recorded so the round does not soften it: VS Code fills
     that same state with *Initialize Repository* and *Publish to GitHub*, and **both are writes
     KA-Reader can never offer** — so the surface has no truthful next step, and saying nothing beats
     explaining its own emptiness (`docs/prd_trail/cycle-10.md` § 2.2).
  2. **The tree carries no changed-file markers** in that state.
  3. **UX-S4 narrows, it is not deleted.** A path that does not exist, or cannot be read, is still
     a startup failure. Only the non-repository case leaves it.

  **What is not settled here, and is the CDO's:**

  - **Whether the plain folder is a new row in § 6 or a second column of the existing surfaces.**
    The sidebar's Git view, the tree and the reading panel all exist already; what changes is one
    of them, in one condition. Either shape is defensible; the round picks one and is consistent.
  - **How the reader can tell the Git view is empty-because-no-repository rather than empty-because-clean.**
    A repository with no changes already has a "clean Git view" state that *does* carry a message.
    Two empty-looking views, one with words and one without, sit one folder apart. The owner chose
    the wordless surface knowing it cannot self-identify; whether the *shell* distinguishes them
    some other way — and whether it should at all — is an experience call this document owns.
  - **What the unexplained fault (UX-I16) looks like in the new state.** Every failure cell in § 6
    holds two classes and v1 has the fault class; a plain folder whose tree cannot be read is still
    a surface that can stop without saying why. The new state must not arrive with one class.
  - **Whether FR-33's live determination has any surface.** `docs/SRS.md` RN-33 and FR-33 make the
    repository-or-not determination **live**: a repository appearing or disappearing under the
    opened folder during a session changes the Git view. Whether that transition is drawn, or
    simply happens, is not stated upstream.

## 2. Choices to confirm — the CDO drafted a best-effort answer; confirm or override

*(none drafted — this companion was opened by the owner, so the round that reads it is the first
CDO pass over the change. Items the CDO drafts belong here on its own run.)*

**Standing, and not reopened by this round:** everything else `UXD.md` settles at v5. In particular
the unexplained-fault class being in v1 (§ 1.1, RN-23) with no control revealing a fault's detail
(RN-24); the tooltip's single home on the status letter (RN-23); and the surface being complete *"as
drawn, not as listed"* — sidebar search / filter, pane resizing and keyboard navigation staying
permanently outside the product's done (`system/projects/ka-reader/agari.md`).

**Values and words stay where they live.** Every token, colour, type, spacing and radius value is
`docs/DESIGN.md`'s and every final string is `docs/CONTENT.md`'s; both catch up after this document
does, as their own stations.
