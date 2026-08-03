# UXD open issues — Nozoki 覗き

> Companion to `UXD.md`. The CDO authored the UXD non-interactively; this file holds
> what it could not settle from the inputs (the PRD, the project's Agari and its doctrine, the
> SRS when present, and any context the owner handed over). **Answer inline** — fill each
> **Answer** / **Confirm-or-override** slot — **commit this file**, then re-run `product-uxd`.
> It folds your answers into the UXD and drops the resolved items. When nothing is left open,
> `product-uxd` **deletes this file**: no file = the UXD is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CDO folds them in, it first copies this
> file whole to `docs/uxd_trail/` — so what you decided, and why, stays readable and citable
> for good.

---

## 1. Open issues — experience questions with no answer yet

None this cycle — every unsettled call carried a defensible lean, so each is listed under §2 as
a choice to confirm. All three arise from your cycle-1 answer (`docs/uxd_trail/cycle-1.md` §2.1)
and the reference it supplied (`docs/ux_reference/README.md`): the topology directive's drafted
statement, and the two placement questions the reference routes back here.

## 2. Choices to confirm — the CDO drafted a best-effort answer; confirm or override

### 2.1 The history view's branch topology — the drafted experience statement

- **Drafted into the UXD:** UX-F4 and UX-S6 (RN-14): when the repository's history holds more
  than one branch, the reader can see the branches as branches — which commits belong to which,
  and where they diverge and merge — never a flat list that flattens them together. The history
  is scoped by a branch choice (the current branch and what relates to it), not an attempt to
  draw every ref at once. Per commit: identifier, message, author, and date, with its changed
  files reachable from its entry; selecting a commit presents what it changed, in the same diff
  presentation. Read-only throughout; history filtering and search stay out (§ 10 — that part of
  `docs/srs_trail/cycle-1.md` §2.2 is untouched).
- **Rationale:** your directive reopened the flat-list shape and asked for a drafted statement
  after looking at what VS Code's own source-control graph presents. Its documentation calls the
  graph "a graphical representation of your commit history and branch relationships",
  highlighting incoming and outgoing commits
  (https://code.visualstudio.com/docs/sourcecontrol/overview); your screenshots show that graph
  scoped by a branch selector, with each commit's changed files beneath it. The draft carries
  those three properties at experience level — topology visible, branch-scoped, per-commit
  changed files — and adds nothing else: no filtering, no search, no promise about how topology
  is rendered (that is the SDD's). Feasibility is downstream and does not narrow the statement.
- **If confirmed, one consequence is handed forward:** the SRS's FR-18 describes the history as
  a flat read-only list (`SRS.md` FR-18) and needs a CTO revision once this lands — the CDO
  hands the collision forward; it is not silently absorbed here.
- **If overridden** (back to the flat list, or a different shape): UX-F4 and UX-S6 reword to the
  shape you name; RN-14 records the outcome and RN-6 re-records the history shape as settled;
  with a flat list the SRS's FR-18 needs no revision. The diff shape (staged/unstaged,
  per-commit diff) is untouched either way.
- **Confirm or override:**

### 2.2 Where the repository selector lives — the shell chrome, not the Git view header

- **Drafted into the UXD:** UX-F5 and § 4 (RN-15): the selector — the dropdown you named, current
  repository's name as both label and control, remembered repositories plus a browse entry —
  lives in the **shell chrome**: the identity element (RN-2) becomes the control. The dropdown
  itself is your directive and is not in question here; only its home is.
- **Rationale:** your own framing — a name in one place and a switch in another is two elements
  telling one truth — points at the chrome: what names the repository is what changes it, and
  the chrome is reachable from either sidebar mode, while the Git view header is unreachable
  with the sidebar in Files mode. Switching is a whole-shell act (it resets the arrival state),
  not a Git-scoped one, so it belongs to the shell rather than to one sidebar view.
- **If overridden** (the Git view header, as the reference image shows): the selector moves into
  UX-S3's header, grouped with repository-scoped state; the chrome's identity element (§ 4,
  RN-2) stays display-only; UX-F5 gains a step — switching from Files mode means toggling to
  Git first — and RN-15 records the trade taken knowingly.
- **Confirm or override:**

### 2.3 The Files/Git switch — a pair of labelled tabs at the top of the sidebar

- **Drafted into the UXD:** § 4 (RN-16): the sidebar's two modes are switched by a pair of
  labelled tabs at the top of the sidebar — text-first, exactly the two destinations that
  exist; not an icon rail.
- **Rationale:** the reference raises this and settles nothing (`docs/ux_reference/README.md`
  § "One question the reference raises"). VS Code's rail is built for many destinations and
  identifies them by icon alone; Nozoki's § 4 rule is text-first with icons secondary, and it
  has two destinations, ever — the Agari admits no third view. Labelled tabs say what each mode
  is in words, cost no chrome the shell doesn't already have, and keep the sidebar's full width
  for content.
- **If overridden** (a rail, or another control): § 4's presentation line and RN-16 reword; an
  icon rail would need a stated exception to § 4's text-first rule, recorded rather than
  implied.
- **Confirm or override:**
