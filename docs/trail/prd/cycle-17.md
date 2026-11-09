# PRD open issues — KA-Reader

> Companion to `PRD.md`. The CPO authored the PRD non-interactively; this file holds
> what it could not settle from the inputs. **Answer inline** — fill each **Answer** /
> **Confirm-or-override** slot — **commit this file**, then re-run `product-prd`. It folds
> your answers into the PRD and drops the resolved items. When nothing is left unresolved,
> `product-prd` clears this file: no file = the PRD is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CPO folds them in, it first copies
> this file whole to `docs/trail/prd/` — so what you decided, and why, stays readable
> and citable for good.

> **No `product-prd` run wrote this file.** The owner opened it on 2026-11-09, in an
> interactive session, to split the repository in two before the beta goes public. The PRD is
> Settled, so without a companion the decision would reach no one.

---

## 1. Open issues — product-defining questions with no answer yet

None.

## 2. Choices to confirm — the CPO drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write this document

### 3.1 Two repositories: the private one becomes `ka-reader-dev`, and a new public `<repository>` gets `main`'s history
- **Raised by:** Product (owner) — 2026-11-09
- **Which section:** § *Assumptions* — **Public identity** (`PRD.md` lines 414–423), which says the
  repository goes public with its own commit history, not as a fresh copy.
- **What moved:** the owner splits the repository in two. The repository that is
  `<owner>/<repository>` today is renamed `<owner>/<repository>-dev`. It stays
  private, it is where the work goes on, and it keeps every branch and record. A new, public
  `<owner>/<repository>` is created. It receives `main`'s whole history: every commit `main`
  reaches, trailers kept, the developer, red and merge commits among them. It receives no other
  branch. Publication is a first push of that history, after the privacy check of exactly what is
  pushed. Each later release is a push of `main` from `ka-reader-dev` to the public repository, and
  it is never a force push. The release is built and tagged in the public repository, so GitHub
  Actions is turned on there. The public identity is unchanged: `<owner>/<repository>`,
  under `eyalgo`.
- **Why:** the history stays the work being shown, since `main` carries every change's commits.
  Work in progress, change branches and anything not yet checked stay private in `-dev`. This is
  the same split ka-telemetry uses (`ka-telemetry-dev` private, `ka-telemetry` public), except that
  here the public repository carries the history and not a cut tree.
- **What it reaches downstream:** SRS § 7 C-12 and § 8 AC-14; FDR R-198 and R-128; SDD § 6 S-7 (its
  history check: the set to check becomes the history `main` reaches and is pushed, not every ref of
  the private remote) and § 4 C-R4 (where the tag build runs); NFDR QC-71 (the ref set and the root
  commit compared on a fresh clone of the public repository) and QC-28. Each follows through its
  own document's run.
- **Answer:** Two repositories. The private `<repository>-dev` (the current repository, renamed) is
  where KA-Reader is built, and it keeps all branches. The public `<repository>` is created new and
  receives `main`'s full history by a first push once the privacy check of that history passes,
  never a fresh copy and never a cut tree. Later releases are pushed from `-dev`'s `main` and never
  force-pushed. Actions runs the tagged release build in the public repository. The public identity
  stays `<owner>/<repository>` under `eyalgo`.

**How it closes.** `product-prd` folds it on its next run; the documents downstream follow by
their own runs.
