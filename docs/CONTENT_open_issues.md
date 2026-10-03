# CONTENT open issues — Nozoki

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

> **No `product-content` run wrote this file.** The PM opened it on 2026-10-04 from the verbal
> language's own companion template. `git-reader` now reads a repository's state, and it can answer one
> state for which the language has no sentence (`nozoki@6a0725c`). `CONTENT.md` is Settled, and with no
> companion on disk a `product-content` re-run reads it as done and has nothing to act on. Its one item
> is in § 3.

---

## 1. Open issues

None.

## 2. Choices to confirm

None.

## 3. Raised from downstream — an item from a seat that did not write the verbal language

### 3.1 The Git view's short status has no sentence for a repository mid-`am`
- **Raised by:** PM — 2026-10-04
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the Git view's short status has no wording to write against for one state the
  repository can be in. Showing it as normal, or as one of the six, would show a state the repository
  is not in (`docs/fdr.md` R-71).
- **Where it shows:** § *The Git view's short status* (`docs/CONTENT.md:L394-L397`) fixes "six states
  and six whole sentences": *merge*, *rebase*, *cherry-pick*, *revert*, *bisect*, and a detached HEAD.
  The reader answers a seventh state, a repository in the middle of applying a mailbox (`git am`):
  `RepositoryState::Am` (`crates/nozoki-core/src/git_reader.rs:L117`), mapped from libgit2's
  `ApplyMailbox` (`crates/nozoki-core/src/git_reader/libgit2.rs:L339`). `git status` reports it as
  "You are in the middle of an am session". `docs/fdr.md` R-162 (`:L141`) says a state other than
  normal is named "in Git's own word for it", and its list of examples stops at the same six. Two ways
  forward were seen: a seventh whole sentence in Git's word, or a decision by the definition set that
  *am* is shown another way. If the call moves R-162's list, that is the FDR's seat's to fold.
- **If a document has to be written:** none. § *The Git view's short status* in `CONTENT.md`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-content` folds it on its next run exactly as it folds §§ 1–2.
