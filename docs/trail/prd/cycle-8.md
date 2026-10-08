# PRD open issues — KA-Reader

> Companion to `PRD.md`. The CPO authored the PRD non-interactively; this file holds what it could
> not settle from the inputs. **Answer inline** — fill each **Answer** / **Confirm-or-override**
> slot — **commit this file**, then re-run `product-prd`. It folds your answers into the PRD and
> drops the resolved items. When nothing is left open, `product-prd` **deletes this file**: no
> file = the PRD is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git refuses
> to remove a file with uncommitted edits in it — so an uncommitted answer stops that run before
> it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CPO folds them in, it first copies this file
> whole to `docs/prd_trail/` — so what you decided, and why, stays readable and citable for good.

> **This companion was opened by the owner, not by a `product-prd` run.** The PRD is settled at v8
> and its companion was correctly deleted. It is re-opened deliberately because the **experience**
> round downstream of it — the UXD, the design language and the verbal language — surfaced three
> things that are the CPO's and nobody else's, and the PRD's loop has no other channel: with no
> companion on disk a `product-prd` re-run reads the document as done and has nothing to act on.
>
> **All three arrive with the owner's ruling already recorded**, so this round is a fold and not an
> interview. What is *not* settled in any of them is the replacement wording, which is the CPO's to
> write. Two of the three land on `README.md` rather than on `PRD.md` itself; they are here because
> the README's claims are the CPO's surface (`docs/CONTENT_open_issues.md` § 1.3 raised them rather
> than editing them, for that reason).

---

## 1. Open issues — product-defining questions with no answer yet

### 1.1 The stated expertise floor says the reader needs no Git knowledge; the owner says KA-Reader's readers most likely have it

- **Why it matters:** `docs/PRD.md` § Goals, *"No learning curve"* (`PRD.md:89-92`) sets the
  audience at *"anyone who can find their way around a repository on GitHub and follow a README"*,
  with no editor experience and no configuration. That floor is load-bearing downstream: it is the
  reason `docs/CONTENT_open_issues.md` § 1.2 treated Git's bare status letters (`A`, `U`, `M`, `D`,
  `C`, `R`) as unreadable to the audience, and it is what a legend, a README expansion or a tooltip
  were each weighed against. It also shapes what the product may assume a reader already knows
  anywhere else it speaks.
- **Reasoning / what would settle it:** the two statements are not compatible as written. The PRD's
  floor describes someone who has *browsed* a repository on a hosting site; the owner's statement
  describes someone who *works with Git*. Which is true changes what the product may leave
  unexplained. Note that the PRD's current line is **owner-confirmed** — `docs/prd_trail/cycle-2.md`
  — so changing it is a fresh authorization, not a correction of an unreviewed draft. What would
  settle it is the owner saying which floor the product is actually built for; that is below.
- **Answer:** **The reader is assumed to know Git.** The owner's words, given while settling the
  status-letter question: *"Remember, users of ka-reader most likely know how git works."* On that
  basis they chose a hover tooltip over a permanent legend or a README list
  (`docs/CONTENT_open_issues.md` § 1.2, committed at `ka-reader@3692585`), which is the weaker fix for
  a reader who does **not** know Git — and they made that call knowing so, because the mismatch was
  put to them in the same turn.

  **What is not settled here, and is the CPO's:** the replacement wording for `PRD.md:89-92`. The
  session drafted none. Two things for whoever writes it: the *no configuration / no onboarding /
  no setup* half of "No learning curve" is untouched by this and should survive — what moves is
  only the assumed Git knowledge; and the line's existing owner-confirmation
  (`docs/prd_trail/cycle-2.md`) should be superseded explicitly rather than silently overwritten.

### 1.2 The README's roadmap promises three things the Agari places permanently outside done

- **Why it matters:** the README is the surface where adoption is decided, and a promise there that
  the product has settled it will never build is the first failed claim a stranger meets.
- **Reasoning / what would settle it:** `README.md:31` — *"3. **Refinement** — pane resizing,
  keyboard navigation, diff/commit-preview, sidebar search."* Of those four, **three are outside the
  terminus**: `system/projects/ka-reader/agari.md` places sidebar search / filter, pane resizing and
  keyboard navigation outside the dock — *"ka-reader is done without them"* — and states the keyboard
  absence is **permanent, not deferred**; `docs/UXD.md` UX-I8 and UX-A1 carry the same. The fourth,
  **`diff/commit-preview`, is inside** the dock — the Agari's v1 cut carries diffs and commit
  history — so it is not part of this problem and should not be removed with the other three.
- **Answer:** **The roadmap is to be fixed.** The owner's words: *"need to fix the roadmap."* The
  three permanently-out-of-scope items come out of phase 3; `diff/commit-preview` stays.

  **What is not settled here, and is the CPO's:** what replaces them. The session's observation,
  offered and not ruled on: a plain statement that those three are outside what KA-Reader is built to
  become is more useful to a reader than silence, because it lets them stop waiting — the same
  reasoning the owner accepted for the accessibility sentence
  (`docs/CONTENT_open_issues.md` § 2.4, *"Neither is planned"*).

### 1.3 The README calls KA-Reader a web app, which it is not

- **Why it matters:** it is the product's one-line self-description, in the first sentence of the
  README (`README.md:4`), and it tells a stranger the wrong thing about what they are getting.
- **Reasoning / what would settle it:** `README.md:4` reads *"workspace viewer: a stripped-down, VS
  Code-like web app for browsing a project's files and…"*. `docs/SRS.md` C-11 promises macOS only,
  and `docs/PRD.md` § Out of Scope rules out *"any hosted operation of the tool itself"* — so
  nothing hosted is on offer. Whether *web app* is technically accurate for the shipped shape is the
  CTO's; whether the README should say it is the CPO's.
- **Answer:** **It is not a web app and the wording is to be changed.** The owner's words: *"it's
  not a webapp, so it needs to be changed."*

  **What is not settled here, and is the CPO's:** the replacement. The session's observation,
  offered and not ruled on: the misleading word is *web* rather than the *VS Code-like* comparison,
  which is doing real work in the sentence and is worth keeping.

  **Note the same sentence is being rewritten anyway.** `docs/CONTENT.md` § Terminology renames the
  README's four words for one thing — *code workspace viewer*, *a project's files*, *codebase*,
  *repository status* — to **repository**, owner-confirmed at
  `docs/CONTENT_open_issues.md` § 2.5. Two of those four are in this very sentence. This item and
  that rename, and § 1.2's roadmap fix, all land on `README.md` and want **one pass**, not three.

## 2. Choices to confirm — the CPO drafted a best-effort answer; confirm or override

None. This companion was opened to carry three already-ruled items, and the CPO drafted nothing on
this round.

## 3. Directives — an external action the owner confirms as a gate

None.
