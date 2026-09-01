# UXD open issues — Nozoki 覗き

> Companion to `UXD.md`. The CDO authored the UXD non-interactively; this file holds
> what it could not settle from the inputs (the PRD, the project's Agari and its doctrine, the
> SRS when present, and any context the owner handed over) — and, when a design run has produced
> output for this product, the pointer to it. **Answer inline** — fill each **Answer** /
> **Confirm-or-override** slot — **commit this file**, then re-run `product-uxd`. It folds your
> answers into the UXD and drops the resolved items. When nothing is left open, `product-uxd`
> **deletes this file**: no file = the UXD is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CDO folds them in, it first copies this
> file whole to `docs/trail/uxd/` — so what you decided, and why, stays readable and citable
> for good.

> **This companion was opened by the owner, not by a `product-uxd` run.** `UXD.md` is Settled at
> v6 and its companion was correctly deleted at the end of cycle 4. It is re-opened deliberately
> because **new layout reference material landed underneath the document** (§ 1.1) and the UXD's
> loop has no other channel: with no companion on disk a `product-uxd` re-run reads the document
> as done and has nothing to act on.
>
> **This round is a look, not a fold.** The owner is not asking for a revision — they are asking
> the CDO to read what changed and decide for itself whether the UXD changes. Deciding it does
> not, and saying so, is a complete and correct outcome for this round.

---

## 1. Open issues — experience questions with no answer yet

### 1.1 Three more layout references landed; does the UXD change?

- **Raised by:** the owner, 2026-09-01, via a `principal-architect:` session that committed the
  images (`nozoki@b7119cb`). Not a CDO finding — the CDO has not read these three.

- **What is on disk.** `docs/ux_reference/` now holds **seven** VS Code screenshots, not four. The
  three new ones are the owner's own workbench, named for the state each shows:
  - `vscode-git-view-worktree-stack.png` — the Source Control changes list holding a repository
    **and three worktree branches at once**, each with its own message box and its own Commit or
    Publish Branch button.
  - `vscode-git-graph-merge-lanes.png` — the same list with the graph **drawing two lanes and
    merge commits in both directions**, where the four existing shots only ever show one lane.
  - `vscode-branch-filter-many-branches.png` — the reference picker over **nine local branches
    plus remotes**, with the graph and an open file behind it. The same control
    `vscode-branch-filter.png` shows over three.

- **Why it matters.** Two things, and the second is the real one.

  First, a plain fact: the UXD says **four** in two places — § 4 ("**The layout reference is
  `docs/ux_reference/`** — four VS Code screenshots the owner supplied", `docs/UXD.md:68-69`) and
  RN-13 ("The layout reference `docs/ux_reference/` — four VS Code screenshots from the owner's
  own workbench", `docs/UXD.md:608-609`). Both are now wrong by count.

  Second, and this is the question: the three new shots show **states the existing four do not** —
  several working trees listed as peers in one view, a graph with branch lanes rather than a
  single line, and a reference filter at a scale where the list is long enough to need filtering.
  Whether any of that bears on what the UXD says about the Git view's shape is the CDO's call.
  A count correction is not a revision; a changed statement about the Git view would be.

- **What would settle it.** Open the three images and read `docs/ux_reference/README.md` against
  them. Note that the README is **not yet annotated for any of the three** — it opens "Four
  screenshots of VS Code" and states its own rule as *"every element is either taken or excluded
  below, and an element not listed here was not considered."* So by the reference folder's own
  rule nothing in these three has been considered yet, and RN-13 restates that rule as the
  reference's authority. The annotation is likely the first move, and whether it is the CDO's to
  write is part of this item.

- **Not in scope of this item.** RN-13 already records the README's dangling `docs/UXD_open_issues.md`
  § 2.1–2.3 pointers, removed at `9017ae2`. This file existing does not resolve them — the sections
  it names are not the ones below — so that defect stands as RN-13 already states it.

- **Answer — the owner's standing directive, given 2026-09-01:** *The CDO decides.* Read the three
  images and the folder's README, and **re-write the UXD if and only if you judge that it changes**.
  If it does not change, record that finding in the round's output and drop this item — do not
  manufacture a revision to justify the round. If the only true delta is the count, treat that as a
  correction and judge for yourself whether it is material enough to move the version line, per the
  document's own rule ("bump the line above on each material change"). Whether the README's
  annotation for the three new images is the CDO's to author, the owner's to supply, or a
  `product-design` concern is yours to say; if it is not yours, name whose it is rather than
  absorbing it.

## 2. Choices to confirm — drafted best-effort; confirm or override

### 2.1 Every trail pointer in the UXD is dead — the folder moved and the citations did not

- **Raised by:** none of the document's own seats — the `principal-architect:` session that opened
  this companion, while verifying § 1.1's citations. Recorded here because a settled document with
  no companion has no other channel.

- **What the UXD says.** The version line cites `docs/uxd_trail/cycle-4.md`, `docs/uxd_trail/cycle-3.md`,
  `docs/uxd_trail/cycle-2.md` and `docs/uxd_trail/cycle-1.md` (`docs/UXD.md:5`).

- **What is true.** `docs/uxd_trail/` **does not exist.** The four cycles live at `docs/trail/uxd/`,
  moved by `nozoki@1e8bf3d` ("the six answer-trails move under `docs/trail/`"), which did not
  update the documents citing them. Every one of those pointers is one a cold reader follows and
  finds nothing — the failure mode a pointer has that an omission does not.

- **Drafted:** each `docs/uxd_trail/` in `docs/UXD.md` becomes `docs/trail/uxd/`. Nothing the
  document says changes; only where it points. A pointer repair, not a revision.

- **Beyond this document, surfaced not fixed.** The same dead path is cited **six times in
  `docs/DESIGN.md`** (lines 330, 389, 745, 836, 871, 1037) and **three times in `docs/SRS.md`**
  (lines 712, 724, 742). `DESIGN.md` is the `product-design` run's and `SRS.md` is the CTO's, so
  neither is repaired here and neither is this round's to repair. They are named so the fix is
  known to be partial: repairing the UXD alone leaves seven dead pointers standing in two sibling
  documents, and whoever folds this item should say so rather than let the repair read as complete.

- **Confirm or override:** **confirm — with two additions, and each changes what the repair must
  do.** (1) **The scale was understated.** The item says the version line cites four cycles; the
  document actually carries **71** `docs/<x>_trail/` citations across **four** dead folders —
  `uxd_trail`, `prd_trail`, `srs_trail`, `content_trail` — and the defect is repo-wide: **235**
  across six documents, one cause, `nozoki@1e8bf3d`. (2) **A blind sweep would introduce a new
  defect.** Four of the UXD's 71 are pinned to a commit — the `nozoki@<sha>:docs/uxd_trail/…` form in
  RN-8, RN-15, RN-16 and RN-17 — and those *resolve*, at a commit where the path did exist (`git show
  1d5c553:docs/uxd_trail/cycle-1.md` returns the file). They must be left exactly as they are; only
  the 67 unpinned ones move. The item's "surfaced not fixed" for the sibling documents is now
  carried rather than only named: the change is raised on all five, at
  `docs/SRS_open_issues.md` § 2.2, `docs/SDD_open_issues.md` § 2.2, and the newly opened
  `docs/PRD_open_issues.md`, `docs/CONTENT_open_issues.md` and `docs/DESIGN_open_issues.md`, each
  § 2.1. Reasoning and the full measurement: `docs/trail/uxd/self_answer-1.md`.
