# CONTENT open issues — KA-Reader

> Companion to `CONTENT.md`. The Content Manager authored the verbal language non-interactively;
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
> Your answers are never thrown away. Each time the Content Manager folds them in, it first copies
> this file whole to `docs/trail/content/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 comes from outside this run.** The verbal language is read by everyone who writes a string,
> and a seat downstream can find a pattern it has no rule for. It is recorded there, answered here,
> and folded by the same run.

---

## 1. Open issues

None.

## 2. Choices to confirm

None.

## 3. Raised from downstream — an item from a seat that did not write the verbal language

### 3.1 Voice cites the superseded public identity

- **Raised by:** Principal Architect — 2026-11-02, during the architecture reread.
- **Tracked by:** This companion; no journey artifact.
- **What it blocks:** A consistent source citation for the voice's explanation of who speaks.
  It does not block the NFDR's existing constraints or change an architectural decision.
- **Where it shows:** `docs/CONTENT.md` § Voice, **Who "you" is** (`:L51-L54`), attributes
  publication under an organisation with no personal public face to `docs/PRD.md` § Assumptions.
  PRD v16 § Assumptions, **Public identity** (`:L396-L402`), instead names the maintainer's
  personal handle `eyalgo` as the public face. The PRD's owner-settled identity is the source;
  this finding does not reopen it or infer that the voice's no-*we* rule must change.
- **If a document has to be written:** Correct the obsolete attribution in `docs/CONTENT.md`
  through `product-content`, owned by the Content Manager; retain or revise the voice's
  explanation under that document's authority.
- **Answer:**

**How it closes.** `product-content` folds it on its next run exactly as it folds §§ 1–2.
