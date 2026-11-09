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
>
> **§§ 1–2 are the CTO's own questions; § 3 is somebody else's.** A seat reading the SRS long after
> it settled can find a gap the authoring run had no way to see, and § 3 is where it says so.

> **No `product-srs` run wrote this file.** The PM opened it on 2026-11-09, reading the settled SRS
> (v15, derived against PRD v18) against the settled PRD v19. One item follows in § 3; the SRS is not
> edited.

---

## 1. Open issues — technical questions with no answer yet

None.

## 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write the SRS

### 3.1 C-12 and AC-14 still have the one repository made public; PRD v19 splits it into a private `ka-reader-dev` and a public repository that receives the main line's history
- **Raised by:** PM — 2026-11-09
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** the first public release's history check and publication step are measured against C-12's one repository "made public with its own commit history", which PRD v19 replaces; the documents below the SRS (FDR R-198, SDD S-7, NFDR QC-71) derive from C-12 and cannot follow the PRD until it does.
- **Where it shows:** `docs/SRS.md:L530-L534` (C-12: "The repository is made public with its own commit history, not as a fresh copy") and `:L623-L624` (AC-14: "before the repository was made public, its own commit history was checked"), against `docs/PRD.md:L420-L430` (v19 § Assumptions **Public identity**: built in a private `ka-reader-dev` that keeps every branch; the public repository carries the main line's own history, checked before it arrives, each later release adding to it and never rewriting it). The SRS header reads "derived against PRD v18" (`docs/SRS.md:L5`). The owner's answer and what it reaches downstream are `docs/trail/prd/cycle-17.md` § 3.1.
- **If a document has to be written:** none — C-12 and AC-14 restate the public repository as the one receiving the main line's history from the private one, and the check as over what it receives.
- **Answer:** Fold PRD v19 into C-12 and AC-14 as the line above says, with three things the PRD states that the line leaves out. **C-12:** KA-Reader is built in a separate, private repository, `ka-reader-dev`, which keeps every branch. It is published from `github.com/eyalgo/ka-reader` under `eyalgo`, and that is still the repository where C-7's channel is enabled and releases are offered. That public repository carries the main line's own commit history: every commit on it as it was made, not a fresh copy and not a cut tree, and no other branch. History reaches it only after exactly the commits it is to receive have been checked for anything private. This holds for the first publication and for every later release, and it holds whether or not the repository is visible yet. A commit that reaches the main line after the check is not sent until it has been checked itself. Each later release adds to the public history and never rewrites it. **AC-14:** in place of "before the repository was made public, its own commit history was checked", the inspection checks three things: the commits the public repository received were checked for anything private before they arrived, per C-12; it holds no branch but the main line; and from the second release on, the public history the previous release left is still whole in it. If the check finds something private, nothing is sent. What is done about the finding is not the SRS's to state, because the PRD names no remedy. Where the tag build runs, and which refs and which root commit the check compares, are the SDD's and the NFDR's, and each follows on its own companion. The reasoning is `docs/trail/srs/self_answer-6.md` § 3.1.

**How it closes.** `product-srs` folds it on its next run like any other item, and nothing about this
file's lifecycle changes.
