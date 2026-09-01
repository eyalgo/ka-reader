# UXD — Nozoki 覗き

**Status:** Draft
**Owner:** CDO
**Version:** 8 — bookkeeping only. `Status:` returns to Draft: a companion is open beside this document (`docs/UXD_open_issues.md`), and this UXD is Settled only when none is. No flow, screen row, interaction pattern, accessibility requirement or review note changed — the companion's one item is unanswered, and an unanswered re-run changes nothing this document states. (v7: nothing about the experience changes. The layout reference is counted at seven images, not four (§ 4, RN-13): the three added at `nozoki@b7119cb` were read and move no entry, by the owner's directive that this seat decide (`docs/trail/uxd/cycle-5.md` § 1.1). And the 67 unpinned `docs/<x>_trail/` citations this document rests on are repaired to `docs/trail/<x>/`, the answer-trails having moved at `nozoki@1e8bf3d` without the citing documents; the four commit-pinned `nozoki@1d5c553:docs/uxd_trail/` citations in RN-8, RN-15, RN-16 and RN-17 resolve as written and stand (`docs/trail/uxd/cycle-5.md` § 2.1). (v6: PRD v11 and the owner's fold directive (`docs/trail/uxd/cycle-4.md` § 1.1) folded: the input is one local folder, a Git repository or not. The plain folder is drawn as a **working state** — a condition on the surfaces that already exist, not a surface of its own — with its Git view present and showing nothing (UX-I17, RN-26, RN-27); UX-S4 narrows to a path that does not exist, is not a folder, or cannot be read; and every "repository" that meant the input now reads "folder", the selector included (RN-25). The SRS was re-read as a sibling and no collision found (RN-28). (v5: the owner's cycle-3 answers folded (`docs/trail/uxd/cycle-3.md`): v1 **has** the unexplained-fault class — every read path is one that can end in *stopped, can't tell why*, and the SDD sizes it (§ 1.1, RN-23); and the no-detail-control call is confirmed — no control on any surface reveals, expands or copies a fault's detail (§ 2.1, RN-24, UX-I16). No entry moves on either: UX-I16 was written scope-neutral and stands as drafted. (v4: the fault state given its surfaces — § 6, UX-I16, RN-23, RN-24; v3: the theme control's home — `docs/trail/uxd/cycle-2.md`; v2: the owner's cycle-1 answers — `docs/trail/uxd/cycle-1.md`.)))

> The UXD is the experience source of truth: the experience-level **what**, derived from the
> settled PRD, authored concurrent with the SRS, and consumed cold by the SDD (so
> the architecture accommodates the experience) and by UI-touching change specs. It is updated
> in place with versioning (bump the line above on each material change); on a revision or a
> re-authoring it is **stable by default** — every delta traces to an owner answer or an
> upstream PRD change. Every entry traces back to a PRD feature, goal, use case, or `## UX
> Notes` item — no entry without a source. Keep technical feasibility and architecture out
> (SRS/SDD), and product intent out (PRD). Give every requirement-shaped entry a stable typed ID
> (`UX-Un`, `UX-Fn`, `UX-Sn`, `UX-In`, `UX-An`) so downstream documents can reference it. Omit a
> section only when it genuinely does not apply; do not pad one to fill it.

This document is read by the CTO and the CDO at the SDD, by the `product-design` run that
authors `docs/DESIGN.md`, by the Content Editor run that authors `docs/CONTENT.md`, and by
every change spec that touches a surface. It binds what the product's surfaces show and how
they behave; it binds no token value and no wording standard.

---

## 1. Design Read

Reading this as: **a local, read-only reader of folders, files and repositories for developers,
with a calm, still, plain-spoken language, leaning toward a restrained code-workbench aesthetic
built from primitives rather than an established component design system.** *(→ PRD § Purpose —
the three named flat, the owner's own sentence; the product kind widened at v6 with PRD v11,
RN-25; § UX Notes
"The character" — "calm, truthful, still"; § Assumptions, the familiarity thesis. The aesthetic
lean is a taste call, confirmed by the owner — `docs/trail/uxd/cycle-1.md` § 2.1; see § 9 and
RN-8.)*

## 2. Design Dials

| Dial | Value (1–10) | Reasoning (from the PRD) |
|---|---|---|
| VARIANCE (layout experimentation: symmetric ↔ asymmetric) | 2 | § Assumptions, the familiarity thesis: a *conventional* editor-style layout — a file tree beside a reading panel — is the product's central bet. Layout experimentation attacks the product's own assumption. (RN-1) |
| MOTION (animation depth: static ↔ cinematic) | 2 | § UX Notes "The character": calm, truthful, **still**; "only what actually changed changes". Content moves because the repository moves (live refresh), so not 1 — but motion only ever carries a change; nothing animates for effect. (RN-1) |
| DENSITY (information per viewport: airy ↔ packed) | 6 | § Target Users are developers and the surface is a workbench: a tree, Git status and code, with "what changed?" answered by a glance (§ UX Notes "What must feel effortless"). Dense where the repository is dense; the reading panel dominant and the chrome minimal, so the density is the repository's, not the shell's. (RN-1) |
| TYPOGRAPHY (conventional ↔ characterful) | 2 | § Goals "No learning curve" and § UX Notes "trusting the tool": the type carries code and file names to a stranger who is deciding whether to trust what they see, and the product has no brand to express (`system/experience/visual_direction.md` § Colors). Character in the type would be the one decorative element in a product whose character is "still". (RN-1) |

## 3. Users & Contexts

- **UX-U1** — A developer inspecting a local repository they do not want to risk touching:
  reading unfamiliar code, checking the state of uncommitted work, verifying what changed.
  Expertise floor: can find their way around a repository on GitHub and follow a README — no
  editor experience, and no Git knowledge beyond that. *(→ PRD § Target Users; § Goals "No
  learning curve")*
- **UX-U2** — A developer watching a working tree an automated tool or coding agent is actively
  changing — the driving scenario. Attention is split: Nozoki shares the screen with the agent's
  own surface, so the view is read in glances and never asks for an action to stay current.
  *(→ PRD § Target Users; § Key Use Cases 3)*
- **UX-U3** — Context, both users: the tool runs on the user's own macOS machine, in a windowed
  environment, against one local folder at a time — a Git repository or not: a download, an
  export, a project with no Git yet is opened and read exactly as a repository is (UX-I17);
  interaction is mouse-driven; the UI language is English. Assistive technology: v1 makes no
  assistive-technology promise (UX-A1). *(→ PRD § Scope (In) run posture and platform; § Key Use
  Cases 4; § UX Notes "The bounds v1 draws"; the folder widening at v6 — RN-25)*

## 4. Information Architecture

- **One window, one shell.** A sidebar beside a dominant reading panel. No other top-level area
  exists: no settings area, no configuration surface, no onboarding surface — nothing to set
  up, sign into, or dismiss. *(→ PRD § UX Notes "The path" step 1; § Goals "No learning curve")*
- **The layout reference is `docs/ux_reference/`** — seven VS Code screenshots the owner
  supplied, with a README annotating every element of the first four as taken or excluded; the
  three added later are unannotated and bind nothing yet (RN-13). It is a reference for
  **layout, not style** (`docs/ux_reference/README.md`, its opening paragraph); the proportions
  (narrow navigation column, dominant reading panel) and the tree's shape are anchored there,
  and this document points at it rather than restating it. *(context the owner handed over;
  RN-13)*
- **The sidebar toggles between Files and Git** (v1). The toggle is a mode of the sidebar only
  and never affects the reading panel (UX-I3). Presentation: a vertical **rail** down the
  sidebar's left edge holding exactly the two entries that exist, Files and Git; each entry
  carries its icon with a small text label beneath it, never the icon alone. The rail leads with
  the glyph, which is a stated exception to the text-first rule below — recorded here, not
  implied (RN-16); the label beneath each entry keeps UX-A4 whole. *(→ PRD § Core Features "A
  sidebar that toggles"; the rail is the owner's override of the drafted tabs —
  `docs/trail/uxd/cycle-1.md` § 2.3, RN-16)*
- **Navigation is text-first, icons secondary.** Every icon sits beside a text label or has a
  text form (UX-A4). One stated exception: the sidebar rail leads with its glyph, label beneath
  (above; RN-16). *(→ PRD § UX Notes "The character")*
- **The shell names what it is looking at.** The viewed folder is identified in the shell
  chrome; where the folder is a Git repository, the branch lives in the Git view. The chrome
  carries no mark saying whether the folder is a repository: that fact is shown by what the Git
  view holds, and nowhere else (UX-I17, RN-27). Certainty about *what* is being inspected is part
  of the trust the product sells, and it becomes load-bearing when the viewed folder can change
  (UX-F5). Beyond v1 the identity element is itself the folder selector — what names the folder
  is what changes it (UX-F5; the placement is owner-confirmed — `docs/trail/uxd/cycle-1.md`
  § 2.2, RN-15). *(added — RN-2; "repository" read "folder" from v6 — RN-25)*
- **The theme control lives in the shell chrome, at its right end.** It is a `sun` or `moon`
  glyph with the word *Light* or *Dark* beside it, naming the theme the control switches **to**
  — so it reads as an action, never as a report of the current theme — and it keeps UX-A4
  whole: the glyph never stands alone. Theme is shell-scoped state, which is why it sits in
  the chrome beside the identity element (above) rather than in either sidebar mode. *(→ PRD § UX Notes "The
  character" — dark and light themes; the placement is the owner's — `docs/trail/uxd/cycle-2.md`
  § 1.1, RN-22)*
- **The reading panel names what is open.** The open file's repository-relative path is shown
  with its content, so the panel tells the reader what they are reading and, when that file is
  gone, what is gone (UX-I4). *(added — RN-3)*
- **Beyond v1, inside the terminus:** the same single window holds everything. A diff is shown
  in the reading panel — a diff is content to read; commit history is reached from the Git
  view; switching the viewed folder is the folder selector (UX-F5). No second window.
  *(→ PRD § Scope (In) full ambition; placement: RN-6)*

## 5. Key Flows

### 5.1 UX-F1 — Arrive and read *(→ PRD § Key Use Cases 1; § UX Notes "The path" steps 1–2)*

- Steps: the experience begins with Nozoki open against one local folder — a Git repository or
  not, and which it is is the tool's to find out, never the person's to declare — what precedes
  that moment is out of scope (§ 10). The workbench opens with the file tree visible and the
  reading panel in its empty state, prompting file selection. The user selects a file; its
  content appears with no perceived wait (PRD § Success Metrics "File-switch immediacy"): with
  syntax highlighting when the file is in one of the six floor languages, as plain text when it
  is any other text, rendered when it is Markdown, and as a stated cannot-display-as-text state
  when it is not text (UX-S1). They move file to file as fast as they can decide what to read
  next.
- Data the UI needs at each step: the folder's identity, and whether it is a Git repository;
  the tree — folders, files, and, where the folder is a repository, for each file whether Git
  reports it changed; per selected file — its path, its content, which
  floor language its extension maps to or none, and whether it is Markdown; the current
  selection.
- Failure/recovery: pointed at a path that does not exist, is not a folder, or cannot be read —
  UX-S4. A folder that is not a Git repository is not a failure: it opens, and its Git view shows
  nothing (UX-I17). A file that cannot be shown as text — the stated placeholder (UX-S1 Error), the shell fully
  usable. A single unreadable item degrades only its own presentation, never the shell (UX-I10).

### 5.2 UX-F2 — Check what changed *(→ PRD § Key Use Cases 2; § UX Notes "The path" step 3)*

- Steps: mid-reading, the user switches the sidebar to Git — branch, changed files, staged files
  and short repository status at a glance. They open a changed file from the Git view to read it
  (opening from the Git view behaves exactly as a tree selection). They switch back to Files;
  the open file and their reading position are untouched throughout. In a plain folder the same
  switch opens a Git view that shows nothing (UX-I17), and the switch back is the same: the
  checking step has nothing to report, which is not an error to explain.
- Data the UI needs at each step: whether the folder is a repository; where it is, Git state —
  branch name, the changed files, the staged files, the short status; tree markers consistent
  with the Git view's list, and absent in a plain folder.
- Failure/recovery: Git state transiently unreadable (a lock mid-operation) — that item's view
  shows that it is not yet read and recovers on a later refresh (UX-S3 Error). A repository
  mid-operation — a merge, a rebase, a detached state — is an inspection subject: the Git view
  presents whatever state the repository is truly in, never an error (UX-S3).

### 5.3 UX-F3 — Watch a moving tree *(→ PRD § Key Use Cases 3; § UX Notes "The path" step 4, "the view never lies")*

- Steps: the user leaves the view open while another process — an automated tool, an agent —
  changes the folder. Changes on disk appear in the view on their own, within the refresh
  bar (PRD § Success Metrics "Refresh immediacy"); there is no refresh control (UX-I2). The
  user's place survives every update: expanded tree nodes, the open file, the reading position —
  only what actually changed changes (UX-I3). If the open file changes on disk, its content
  updates in place; if it disappears, the view says so plainly (UX-I4). In a plain folder the
  same flow runs with nothing Git-shaped to move; a repository appearing at the folder's root
  mid-session, or leaving it, is a change in Git state like any other and arrives the same way
  (UX-I17).
- Data the UI needs at each step: the current tree and Git state — including whether the folder
  is a repository — fresh enough to meet the
  refresh bar; which items changed since the last view, so that only those update; for the open
  file, whether it still exists and whether its content changed.
- Failure/recovery: rapid concurrent changes never blank, block, or crash the shell; the view
  converges to the state on disk. Closing at any moment during this asks nothing — the user
  leaves certain the repository is exactly as they found it (UX-I5).

### 5.4 UX-F4 — Inspect changes and history *(beyond v1)* *(→ PRD § Scope (In) full ambition: diffs, commit history)*

- Exists only where the folder is a Git repository: in a plain folder the Git view holds
  nothing to open a diff or a history from (UX-I17).
- Steps: from the Git view, the user opens a changed file's **diff** — read-only, with staged
  changes distinguished from unstaged ones — in the reading panel. From the Git view they open
  the **commit history**. When the repository's history holds more than one branch, the reader
  can see the branches as branches: which commits belong to which, and where they diverge and
  merge — never a flat list that flattens them together. The history is drawn against a chosen
  **set** of branches — one, several, or all of them — with a default that asks nothing: the
  current branch and what relates to it, so a reader who never touches the choice still arrives
  at a graph, not a prompt. The choosing belongs to the history view itself. Per commit:
  identifier, message, author and date, with its changed files reachable from its entry.
  Selecting a commit presents what that commit changed, in the same diff presentation.
- Data the UI needs at each step: per changed file, its diff content with the staged/unstaged
  distinction; the commit history with its parent relationships (the topology) and each commit's
  branch membership, scoped by the chosen branch set; the set of branches to choose from; per
  commit — identifier, message, author, date, changed files; per selected commit, what it
  changed.
- Failure/recovery: read-only throughout — presenting the staged state stages nothing. History
  filtering and search do not exist (outside done — § 10). A diff or history item that cannot be
  read degrades only itself (UX-I10).
- The diff shape and the history shape are the owner's settled decisions, carried here and not
  reopened (RN-6, RN-14).

### 5.5 UX-F5 — Switch the viewed folder *(beyond v1)* *(→ PRD § Scope (In) "one folder at a time is a v1 cut"; § Out of Scope "Changing the viewed folder without restarting")*

- Steps: the **folder selector** shows the current folder's name — the name is both the label
  and the control (the owner's directive: `docs/ux_reference/README.md` § Owner directives 2 —
  RN-15; named the *repository selector* there, before the input widened: the same control,
  RN-25). Opening it lists the folders Nozoki remembers, with an entry to browse for one not in
  the list; on first run the list is empty and only the browse entry is there. Choosing one
  returns the shell to the arrival state (UX-F1) for that folder — a repository or a plain
  folder alike (UX-I17). Always exactly one folder at a time — switching replaces, never adds.
- The remembered list is the tool's own state, kept outside the viewed folder (→ PRD § Data
  & Privacy). The selector lives in the shell chrome — the identity element (§ 4, RN-2) is the
  control (owner-confirmed: `docs/trail/uxd/cycle-1.md` § 2.2, RN-15).
- Data the UI needs at each step: the remembered-folders list; the new folder's identity,
  whether it is a repository, its tree and Git state; the shell chrome's folder name.
- Failure/recovery: a chosen path that does not exist, is not a folder, or cannot be read gets
  the same plain failure language as startup (UX-S4 / UX-S7), and the previously viewed folder
  stays viewed; nothing about either folder changes. A plain folder is not a failure: choosing
  one lands the arrival state with an empty Git view (UX-I17).

## 6. Screen Inventory & States

The product has one window; the rows are its surfaces. A state that cannot arise is `n/a` with
its reason. Every indicator in every cell is drawn only after the tool has observed the state it
stands for (UX-I13), and every failure cell carries a route out on the same surface (UX-I14).
Every failure cell holds two classes of failure, not one: the **observed condition** the cell
names, and the **unexplained fault** — the tool stopped doing that cell's work and nothing it read
accounts for it. The second class takes the same slot, the same scope and the same route out as
the first; only what the message says differs, and that is `docs/CONTENT.md`'s (UX-I16, RN-23).
Two inputs share every row: a folder that is a Git repository, and a **plain folder** — one the
tool has found is not a repository's root. The plain folder is a condition on the surfaces below,
not a surface of its own: it changes what UX-S3 holds and whether UX-S2 carries markers, and
nothing else; every cell not naming it holds for both inputs as written (UX-I17, RN-26, RN-27).

| ID | Screen | Empty | Loading | Error | Success |
|---|---|---|---|---|---|
| UX-S1 | Reading panel | No file selected: one prompt to select a file, and nothing else — no shortcut list, no watermark *(→ PRD § Core Features "empty state"; § UX Notes "The path" step 1)* | The bar is no perceived wait (PRD § Success Metrics); a file that is genuinely still being read shows that it is being read, without a progress claim the tool has not measured, and without blocking the shell | A file that is not text: a stated cannot-display-as-text placeholder naming the file and saying why its content is not shown — never a garbled render, never an error *(→ PRD § UX Notes "Failure states")*. The open file gone from disk: the panel keeps the file's name and states plainly that it is no longer there; the vanished content is not shown as current (UX-I4). A file the tool cannot read: a plain statement of what it was doing and what it observed, recovering when readable. In every case the tree beside the panel stays enabled, and is the route out | Read-only content named by its path (§ 4): syntax-highlighted for the six floor languages, plain text for every other text file, rendered for Markdown (UX-I12); reading position preserved across refreshes (UX-I3) |
| UX-S2 | Files view (tree) | A repository with no files: a stated empty-tree message, not a blank pane *(added — RN-4)* | The tree appears as it is read; a folder not yet read shows that it is pending rather than showing as empty; changed-file markers appear only once Git state has been read *(added — RN-4, UX-I13)* | An entry that cannot be read is marked so with what the tool observed; the rest of the tree stands *(added — RN-4)* | The tree with the selected file highlighted and, where the folder is a repository, changed-file markers, each carrying its meaning in text as well as colour (UX-A2); in a plain folder the tree carries no markers (UX-I17) *(→ PRD § Core Features)* |
| UX-S3 | Git view | A clean tree, once Git state has been read: stated plainly — "nothing changed" is information, not a blank pane, and it is shown only after the tool has observed it *(added — RN-4, UX-I13)*. **A plain folder**, once the tool has found that the folder is not a repository's root: the view is present and shows **nothing** — no message, no label, no explanation, no control, and nothing that offers to create a repository (UX-I17). A clean repository and a plain folder are told apart by what the clean view carries — the branch, and its stated "nothing changed" — against nothing at all; the shell adds no other cue (RN-27) *(→ PRD § Core Features "the Git view is present and shows nothing"; § Key Use Cases 4)* | State appears as it is read; before it is read — before the tool has found whether the folder is a repository at all — the view shows that it is reading: not a clean tree, and not nothing (UX-I13, UX-I17) | Git state transiently unreadable: that item shows what the tool observed (a lock, an unreadable file) and recovers on refresh. A repository mid-operation (merge, rebase, detached) is **not** an error: the true state, presented *(→ PRD § UX Notes "the view never lies")*. Finding out whether the folder is a repository **stopped**: an unexplained fault in this slot (UX-I16), shown as a fault and never as nothing — nothing is shown only for an observed plain folder (UX-I17, RN-27) | Branch, changed files, staged files, short status; each file's state carried by a letter or word beside it, with colour repeating it (UX-A2) *(→ PRD § Core Features)* |
| UX-S4 | Startup failure | n/a — the surface exists only in failure | n/a | Pointed at a path that does not exist, is not a folder, or cannot be read: a plain statement of what the tool tried to open, what it observed, and what to do next, at the no-learning-curve bar — no dead end that presumes expertise *(→ PRD § UX Notes "Failure states")*. A folder that is not a Git repository is not on this list: it opens (UX-I17; narrowed at v6 with PRD v11 — RN-25). In v1 the route out is to change the path and start again, and the surface says so and carries a way to leave; beyond v1 the route is the selector's browse entry (UX-S7). Where the surface renders is a downstream question (§ Open Questions) | n/a — success is the workbench (UX-S1–S3) |
| UX-S5 | Diff view *(beyond v1)* | A file with no remaining changes: stated | As UX-S1 | A diff that cannot be produced: plain statement of what the tool observed, shell intact, the Git view beside it the route out | Read-only diff, staged distinguished from unstaged in text as well as colour (UX-F4, UX-A2) |
| UX-S6 | History view *(beyond v1)* | A repository with no commits: stated | The history appears as it is read; a graph not yet drawn shows as pending, never as a shorter history | History unreadable: plain statement, shell intact, the Git view the route out | Read-only history with branch topology visible when more than one branch exists — which commits belong to which branch, where they diverge and merge — drawn against a chosen set of branches with a default that asks nothing (UX-F4); each branch named at the commit that is its tip; per commit its identifier, message, author and date, with its changed files reachable from its entry; selecting a commit opens its diff (owner-settled shape, RN-14) |
| UX-S7 | Folder selector *(beyond v1)* | First run: no remembered folders — the list holds only the browse entry *(owner directive — RN-15)* | n/a — the list is the tool's own remembered state, held locally | A chosen path that does not exist, is not a folder, or cannot be read: the same plain failure language as UX-S4, with the current folder still viewed and the selector still open as the route out. A plain folder is not a failure (UX-I17) | The selector lists remembered folders plus browse; choosing one lands the arrival state (UX-F1) for the new folder, and the shell's folder name updates (§ 4) *("repository" read "folder" from v6 — RN-25)* |

## 7. Interaction Patterns

- **UX-I1** — No editing affordance exists anywhere, enabled or disabled, and no framing implies
  an editable mode exists elsewhere. Read-only is the product's identity, not a mode. *(→ PRD
  § UX Notes "The character")*
- **UX-I2** — There is no manual refresh control; the view follows the disk on its own. Updates
  arrive without ceremony — no notification, no flash, no attention bid; the changed content
  itself is the signal. *(→ PRD § UX Notes "The path" step 4; the no-ceremony sentence: added —
  RN-5)*
- **UX-I3** — An update the user did not ask for never takes their place away: expanded tree
  nodes, the open file, the sidebar mode and the reading position survive every refresh; only
  what actually changed changes. *(→ PRD § UX Notes "the view never lies", "The path" step 3)*
- **UX-I4** — The view never lies: what is shown is the repository's current state, or is
  explicitly marked as no longer there; stale content is never presented as current. *(→ PRD
  § UX Notes "the view never lies")*
- **UX-I5** — Closing asks nothing — no save prompt, no confirmation; there is never anything
  to save. *(→ PRD § UX Notes "The path" step 5)*
- **UX-I6** — Every message the product shows is written at the no-learning-curve bar: what the
  tool was doing, what it observed, and what to do next — never a raw internal diagnostic, and
  never a cause the tool did not observe. UI language: English. The standard those words are
  written to is `docs/CONTENT.md`'s; this entry fixes what each message carries, not how it is
  worded. *(→ PRD § UX Notes "Failure states", "The bounds v1 draws")*
- **UX-I7** — No undo or confirmation model exists, because no user action changes anything in
  the repository. The only state the user can change is the tool's own preferences, each
  reversible by the same control that set it. *(→ PRD § Out of Scope "Editing, permanently";
  § Data & Privacy)*
- **UX-I8** — Keyboard model: none. v1 is mouse-driven, and keyboard navigation is permanently
  outside the product's done. *(→ PRD § UX Notes "The bounds v1 draws"; permanence: the Agari,
  § 10)*
- **UX-I9** — Themes: dark and light from the start, both first-class and equally maintained.
  The initial theme follows the platform's own appearance setting; where no platform appearance
  signal can be read, the initial theme is light. The user may override, and the choice is
  remembered in the tool's own state — never in the repository. The control that overrides it
  is in the shell chrome (§ 4, RN-22). *(→ PRD § UX Notes "The
  character"; persistence: § Data & Privacy "theme choice"; the platform-signal default and the
  signal-less light default are owner-confirmed — `docs/trail/uxd/cycle-1.md` § 2.5, RN-7; the
  control's home is owner-set — `docs/trail/uxd/cycle-2.md` § 1.1, RN-22)*
- **UX-I10** — A slow or failing item degrades only its own presentation, visibly; the shell as
  a whole never blocks. *(→ PRD § Key Use Cases 3 — a view that blocks cannot watch a moving
  tree; § UX Notes "Failure states"; added as a stated pattern — RN-5)*
- **UX-I11** — The product's public visual surfaces tell the same truth as the product: a
  README screenshot, or any picture of the shell, shows the product as it currently is; a
  mismatch between the picture and the running product is a defect, checked at release. *(→ PRD
  § Goals "Pick-it-up adoption" — the README's first screen is product surface; added — RN-9)*
- **UX-I12** — Markdown is shown rendered by default. Where a release ships the raw-source
  switch, it is one control in the reading panel, and switching preserves the reading position
  both ways; a release without it shows rendered only and says nothing about a switch. Rendering
  fetches nothing: a remote image or other remote resource the document references is shown as
  a stated not-loaded placeholder where it would appear, naming that remote content is not
  fetched. A link is displayed with its destination readable; it is a control only where
  activating it does something — a relative link, in a release that opens relative links, opens
  the target file in the reading panel exactly as a tree selection does; an external link is
  never a control and never opens anything. *(→ PRD § Core Features "Markdown is rendered by
  default"; § Data & Privacy "no network call at all during operation"; the switch and the
  relative-link permission are the owner's settled calls, RN-10; the link presentation is
  owner-confirmed — `docs/trail/uxd/cycle-1.md` § 2.6, RN-10)*
- **UX-I13** — No indicator is drawn before the tool has observed the state it stands for: no
  changed-file marker before Git state is read, no "nothing changed" before it is read, no
  progress indicator that advances without observed progress. Where the tool does not yet know,
  the surface shows pending. *(→ PRD § UX Notes "the view never lies" — a state the tool has
  not established is a lie told early; the instance fence
  `system/experience/visual_restrictions.md` § `no-unestablished-state`; added — RN-11)*
- **UX-I14** — Every failure or refusal state carries a route out on the same surface: an
  enabled control, or a way back to the state before the failure. A control that only opens an
  unstaffed channel — an issue tracker, a support address — is not a route out and never stands
  alone. *(→ PRD § UX Notes "Failure states" — "no dead end"; the instance fence
  `system/experience/visual_restrictions.md` § `failure-says-what-next`; added — RN-11)*
- **UX-I15** — Everything a surface renders ships with the tool: no font, icon set, image or
  stylesheet is fetched from any origin at runtime, and every surface renders whole with the
  network unavailable. *(→ PRD § Data & Privacy "no network call at all during operation"; the
  instance fence `system/experience/visual_restrictions.md` § `no-runtime-remote-asset`;
  added — RN-11)*
- **UX-I16** — An **unexplained fault** — the tool stopped doing one surface's work and cannot
  account for it from anything it read — is presented **on that surface, in the failure slot of the
  item it stopped on**, exactly where that surface's observed-condition failure is presented (§ 6):
  the reading panel for the open file, the tree row for a tree entry, the Git view for Git state,
  the startup surface for opening the folder, the diff and history views for their own
  content, the selector for a chosen folder. It is scoped to that item: the rest of the shell
  stands and is the route out (UX-I10, UX-I14), and the state names what still works. What is
  drawn is what was observed — that the work stopped — and nothing more: no cause is shown, no
  pending treatment stands in for it, since the tool is not still working (UX-I13). It recovers
  the way an observed condition does: the next successful read replaces it, without ceremony
  (UX-I2). **No control on any surface reveals, expands or copies the fault's detail**, and no
  message asks the reader to report it; where the tool keeps a diagnostic, it keeps it away from
  every surface, and where that is is the SRS's. A fault that stops the shell itself has no
  surface to be shown on and is `n/a` here: not a state, but the crash-safety the SRS binds.
  Whether a given release can reach this class at all is a scope call this entry does not make;
  it declares what the first fault that proves the class real looks like. *(→ PRD § UX Notes
  "Failure states" — a plain statement of what went wrong and what to do next, no dead end; "the
  view never lies"; the class itself is the owner's — `docs/trail/content/cycle-1.md` § 2.3;
  added — RN-23; the no-detail-control call is owner-confirmed `docs/trail/uxd/cycle-3.md`
  § 2.1, RN-24)*
- **UX-I17** — In a **plain folder** — one the tool has found is not the root of a Git
  repository — the Git view is present and shows **nothing**: no message, no label, no
  explanation, no control, and nothing that invites creating or initialising a repository; the
  tree carries no changed-file markers; and the Git-derived surfaces (UX-S5, UX-S6) have nothing
  to be reached from. The Files/Git switch, the tree, the reading panel, the empty state and the
  live refresh are exactly as in a repository. It is a working state, not a failure: UX-I14 binds
  failure states and this is not one, so the view owes no route out — there is nothing to leave.
  Three states of the Git view are three different observations and are never drawn alike:
  **pending**, before the tool has found out (UX-I13); **nothing**, once it has found a plain
  folder; and the **unexplained fault**, where finding out stopped (UX-I16). The finding is live:
  a repository appearing at the folder's root mid-session, or leaving it, is a change in Git state
  and arrives as every change does — the Git view fills or empties and the markers appear or go,
  without ceremony (UX-I2), the reader's place untouched (UX-I3). That an empty view cannot by
  itself tell a plain folder apart from a repository the tool failed to read is accepted upstream;
  the fault the reader must know about is UX-I16's, never a message in this state. *(→ PRD § Core
  Features "the Git view is present and shows nothing"; § Key Use Cases 4; § UX Notes "The path"
  step 3 "Checking"; § Out of Scope "Creating or initialising a Git repository"; § Success
  Metrics "Refresh immediacy" — Git state among the changes that appear on their own; the
  wordless view is the owner's — `docs/trail/prd/cycle-10.md` § 2.2, carried to this document by
  `docs/trail/uxd/cycle-4.md` § 1.1; added — RN-26; the four calls the owner left to this seat —
  RN-27)*

## 8. Accessibility Requirements

- **UX-A1** — v1's posture, as the PRD settles it: mouse-driven, with no keyboard-accessibility
  promise — and that absence is permanent, because keyboard navigation sits outside the
  product's done (§ 10). Beyond that line, v1 makes no assistive-technology promise: its
  accessibility surface is what the product already carries — two themes, text-first
  navigation. This is a stated posture, not a conformance target; no standard is claimed. *(→
  PRD § UX Notes "The bounds v1 draws"; owner-confirmed: `docs/trail/prd/cycle-5.md` § 2.1)*
- **UX-A2** — No meaning by hue alone: changed-file markers, the staged/unstaged distinction,
  the selected file, and every other state distinction carry a cue that survives without
  colour — a letter, a word, a shape or a position — in both themes. This is a design-quality
  rule inside the settled posture, not an assistive-technology promise: it makes the markers
  legible to everyone, including readers with the common colour-vision deficiencies. The colour
  pairs themselves are token decisions and live in `docs/DESIGN.md`. *(→ PRD § Core Features
  "changed-file markers"; added — RN-12)*
- **UX-A3** — The declared posture (UX-A1) is stated where the adopter can read it before
  adopting — the README, **not its first screen**: one plain sentence further down, stating the
  fact and not apologising for it, so the first screen keeps to the four things the PRD fixes
  for it. No claim beyond what UX-A1 holds. The sentence's wording is `docs/CONTENT.md`'s and
  the README is the CPO's; this entry asks only that the sentence exists and where. *(→ PRD
  § UX Notes "The bounds v1 draws"; § Goals "Pick-it-up adoption"; owner-confirmed, the
  not-first-screen bound in the owner's own words — `docs/trail/uxd/cycle-1.md` § 2.4, RN-17)*
- **UX-A4** — No control and no state is carried by a glyph alone: every icon sits beside a text
  label or has a text form the surface shows. *(→ PRD § UX Notes "navigation is text-first,
  icons secondary"; added — RN-12)*
- **Minimum contrast** — no conformance number is claimed here, in keeping with UX-A1.
  `docs/DESIGN.md` states, as a number, the contrast floor its tokens hold on both themes, and
  that number is the product's floor from the moment it is written.

## 9. Design-System Direction

- **Direction:** no established component design system. A restrained code-workbench aesthetic
  built from primitives: the reading panel is the dominant visual surface, navigation is
  text-first with icons secondary (one stated exception, the sidebar rail — § 4, RN-16), chrome
  is minimal, and nothing visible is decorative — in
  this domain restraint is the credibility signal, and the product's own character ("calm,
  truthful, still") rules out imported component aesthetics. One system for the product. The
  platform's own controls and appearance are the starting point where this document and
  `DESIGN.md` are silent (`system/experience/visual_direction.md` § Overview, line 2).
  *(→ PRD § UX Notes "The character"; § Assumptions, the familiarity thesis. Owner-confirmed —
  `docs/trail/uxd/cycle-1.md` § 2.1, RN-8. Layout reference, not style:
  `docs/ux_reference/`, RN-13.)*
- **Constraints the design language must satisfy:**
  - Dark and light as first-class, equally maintained themes; initial polarity from the
    platform's appearance setting, and light where no signal can be read — `DESIGN.md` carries
    that default as a stated value with its reason (UX-I9, RN-7).
  - Every state distinction legible without colour, in both themes (UX-A2); the colour pairs are
    swappable token pairs, never hardcoded into a component.
  - Body text and code legible at code-reading sizes on both themes; the contrast floor stated
    as a number in `DESIGN.md` (§ 8).
  - Every asset ships with the tool — fonts, icons, images (UX-I15); a surface renders whole on
    a stock macOS machine holding only the platform default and the tool itself
    (`system/experience/visual_restrictions.md` § `no-author-only-surface`).
  - Syntax highlighting and a monospace reading surface are held as domain **expectations** —
    their absence reads as unfinished — and are recorded as expectations, never claimed as
    comprehension benefits (RN-18).
  - The Markdown rendered view and the code view are two treatments of one reading panel, not
    two panels: the same path line, the same position rule, the same route out (UX-I12).
- **Design language:** `docs/DESIGN.md` (authored by `product-design` off this direction; may
  trail the SDD). No token value lives in this document.

## 10. Out of Scope

Scoped against the project's 上がり Agari (`system/projects/nozoki/agari.md`) — the terminus:
the v1 cut plus diffs, commit history, and repository switching, which is why UX-F4/UX-F5 and
UX-S5–S7 are designed here despite being beyond v1.

- **Sidebar search / filter, pane resizing, keyboard navigation** — the Agari places them
  outside done; not designed here, and nothing here is drawn around their absence as if they
  were coming. The keyboard absence is permanent, not deferred (UX-I8, UX-A1).
- **History filtering and search** — outside done with them (owner decision:
  `docs/trail/srs/cycle-1.md` § 2.2). The history view's branch-set choice is not a filter: it
  chooses what the graph draws, and does not search the history (UX-F4).
- **The Markdown raw-source switch and relative-link opening** — permitted, not required, and
  outside done (owner: `docs/trail/srs/cycle-5.md` § 2.2, § 2.3). UX-I12 states what each looks
  like in a release that ships it, so that a release which does is not designed at code time;
  neither is a condition of done.
- **A second platform** — v1 promises macOS only, and done does not wait for Linux or Windows
  (owner: `docs/trail/srs/cycle-5.md` § 2.4). Nothing here is designed for another platform's
  conventions.
- **A front end for agent workflows and repository-inspection services** — where a next product
  might go, not where this one docks; nothing here designs for it.
- **The acquisition-and-start experience** — the PRD holds the mechanism out of scope; the
  experience defined here begins with the shell open against a repository (UX-F1). The README's
  content is the CPO's; this UXD constrains only the truthfulness of public pictures of the
  shell (UX-I11) and asks for one posture sentence (UX-A3).
- **Editing and Git operations** — excluded by the PRD as product capability; this document's
  share of that exclusion is UX-I1 (no affordance, no framing).
- **Creating or initialising a Git repository** — excluded by the PRD (§ Out of Scope); this
  document's share is UX-I17: the empty Git view carries nothing that offers it.
- **The standard the product's words are written to** — voice, tone, terminology, the wording
  of every message and of every promise the product states, and the accessibility bar for text —
  `docs/CONTENT.md`'s, inside `system/experience/voice_restrictions.md`. The words shown in this
  document are what each state carries, not its approved copy.
- **Every token value** — colours, type, spacing, radii live only in `docs/DESIGN.md` (§ 9).

## 11. Traceability

| UXD entry | PRD source |
|---|---|
| UX-U1 | § Target Users; § Goals "No learning curve" |
| UX-U2 | § Target Users (driving scenario); § Key Use Cases 3 |
| UX-U3 | § Scope (In) run posture, platform; § Key Use Cases 4; § UX Notes "The bounds v1 draws"; the folder widening: PRD v11 (RN-25) |
| UX-F1 | § Key Use Cases 1, 4; § UX Notes "The path" 1–2, "Failure states"; § Core Features (highlighting floor, Markdown, empty state) |
| UX-F2 | § Key Use Cases 2, 4; § UX Notes "The path" 3 |
| UX-F3 | § Key Use Cases 3; § UX Notes "The path" 4, "the view never lies"; § Success Metrics "Refresh immediacy" |
| UX-F4 | § Scope (In) full ambition (diffs, commit history); diff shape: owner decision `docs/trail/srs/cycle-1.md` § 2.2 (RN-6); history shape: owner decision `docs/trail/srs/cycle-3.md` § 2.1 (RN-14) |
| UX-F5 | § Scope (In) "one folder at a time is a v1 cut"; § Out of Scope "Changing the viewed folder without restarting"; § Data & Privacy (remembered list); the selector: owner directive `docs/ux_reference/README.md` § Owner directives 2 (RN-15); the input widened to any folder: PRD v11 (RN-25) |
| UX-S1 | § Core Features "empty state", "read-only viewing", the highlighting floor, Markdown; § UX Notes "Failure states", "the view never lies" |
| UX-S2 | § Core Features "file tree", markers, selection; empty/loading/error cells added (RN-4); no markers in a plain folder: § Core Features "Git view" (UX-I17) |
| UX-S3 | § Core Features "Git view", "the Git view is present and shows nothing"; § Key Use Cases 4; § UX Notes "the view never lies"; empty cell added (RN-4); the plain-folder state: owner decision `docs/trail/prd/cycle-10.md` § 2.2 (RN-26); the three-observations line and the no-cue call (RN-27) |
| UX-S4 | § UX Notes "Failure states" — "A folder without Git is not on this list"; narrowed at v6: PRD v11 (RN-25) |
| UX-S5 | § Scope (In) full ambition; owner decision `docs/trail/srs/cycle-1.md` § 2.2 |
| UX-S6 | § Scope (In) full ambition; history shape: owner decision `docs/trail/srs/cycle-3.md` § 2.1 (RN-14) |
| UX-S7 | § Scope (In) / § Out of Scope (folder switching); the selector: owner directive (RN-15); any folder: PRD v11 (RN-25) |
| UX-I1 | § UX Notes "The character" |
| UX-I2 | § UX Notes "The path" 4; no-ceremony: added (RN-5) |
| UX-I3 | § UX Notes "the view never lies", "The path" 3 |
| UX-I4 | § UX Notes "the view never lies" |
| UX-I5 | § UX Notes "The path" 5 |
| UX-I6 | § UX Notes "Failure states", "The bounds v1 draws" |
| UX-I7 | § Out of Scope "Editing, permanently"; § Data & Privacy |
| UX-I8 | § UX Notes "The bounds v1 draws"; permanence: Agari |
| UX-I9 | § UX Notes "The character"; § Data & Privacy; platform-signal default and signal-less light: owner-confirmed `docs/trail/uxd/cycle-1.md` § 2.5 (RN-7); the control's home in the chrome: owner-set `docs/trail/uxd/cycle-2.md` § 1.1 (RN-22) |
| UX-I10 | § Key Use Cases 3; § UX Notes "Failure states"; added as pattern (RN-5) |
| UX-I11 | § Goals "Pick-it-up adoption"; added (RN-9) |
| UX-I12 | § Core Features "Markdown is rendered by default"; § Data & Privacy; owner calls `docs/trail/srs/cycle-5.md` § 2.2, § 2.3, `docs/trail/srs/cycle-6.md` § 2.1; link presentation: owner-confirmed `docs/trail/uxd/cycle-1.md` § 2.6 (RN-10) |
| UX-I13 | § UX Notes "the view never lies"; instance fence; added (RN-11) |
| UX-I14 | § UX Notes "Failure states"; instance fence; added (RN-11) |
| UX-I15 | § Data & Privacy; instance fence; added (RN-11) |
| UX-I16 | § UX Notes "Failure states", "the view never lies"; the class: owner decision `docs/trail/content/cycle-1.md` § 2.3; added (RN-23); no-detail-control: owner-confirmed `docs/trail/uxd/cycle-3.md` § 2.1 (RN-24) |
| UX-I17 | § Core Features "the Git view is present and shows nothing", "Git is read only when the folder opened is itself the root"; § Key Use Cases 4; § UX Notes "The path" 3 "Checking"; § Out of Scope "Creating or initialising a Git repository"; § Success Metrics "Refresh immediacy"; the wordless view: owner decision `docs/trail/prd/cycle-10.md` § 2.2, carried by `docs/trail/uxd/cycle-4.md` § 1.1 (RN-26); the delegated calls (RN-27) |
| § 6 two classes per failure cell | § UX Notes "Failure states"; added (RN-23) |
| § 6 two inputs share every row | § Scope (In) "a Git repository or not"; § Key Use Cases 4; the condition-not-row call (RN-27) |
| § 1 Design Read (product kind) | § Purpose — "a reader of folders, files and repositories", owner's sentence `docs/trail/prd/cycle-10.md` § 2.1 (RN-25) |
| § 10 creating a repository | § Out of Scope "Creating or initialising a Git repository" (UX-I17) |
| UX-A1 | § UX Notes "The bounds v1 draws"; owner-confirmed `docs/trail/prd/cycle-5.md` § 2.1 |
| UX-A2 | § Core Features "changed-file markers"; added (RN-12), inside UX-A1's posture |
| UX-A3 | § UX Notes "The bounds v1 draws"; § Goals "Pick-it-up adoption"; owner-confirmed `docs/trail/uxd/cycle-1.md` § 2.4 (RN-17) |
| UX-A4 | § UX Notes "The character" — text-first; added (RN-12) |
| § 4 IA (shell, sidebar, text-first) | § UX Notes "The character", "The path" 1; § Core Features |
| § 4 layout reference | context the owner handed over, `docs/ux_reference/README.md` (RN-13) |
| § 4 Files/Git switch presentation | § Core Features "sidebar that toggles"; § UX Notes text-first, one stated exception; owner override — a labelled rail, `docs/trail/uxd/cycle-1.md` § 2.3 (RN-16) |
| § 4 folder identity in shell | added (RN-2); the element is the selector control beyond v1 — owner-confirmed `docs/trail/uxd/cycle-1.md` § 2.2 (RN-15); no repository-or-not mark in the chrome (RN-27) |
| § 4 theme control in shell chrome | § UX Notes "The character" (the themes); the placement: owner answer `docs/trail/uxd/cycle-2.md` § 1.1 (RN-22) |
| § 4 open file's path in the reading panel | § UX Notes "the view never lies"; added (RN-3) |
| § 9 Direction | § UX Notes "The character"; § Assumptions; owner-confirmed `docs/trail/uxd/cycle-1.md` § 2.1 (RN-8) |

---

## UXD Review Notes

- **RN-1:** *(added — derivations)* The four dial values are CDO derivations from PRD facts, not
  owner-set values: variance 2 from the familiarity thesis (a bet on a conventional layout),
  motion 2 from "calm, truthful, still" plus the only-what-changed-changes rule, density 6 from
  the developer workbench and the answered-at-a-glance bar, typography 2 from the
  no-learning-curve goal and the trust the type carries, with no brand to express
  (`system/experience/visual_direction.md` § Colors — the instance carries no shared colour or
  mark). Each is stated with its reasoning in § 2; none is a taste call beyond what those facts
  imply. *(re: § 2; PRD source: Assumptions, Goals, UX Notes)*
- **RN-2:** *(added)* The shell names the repository it is viewing — *because* certainty about
  what is being inspected is part of the trust the product sells (Key Use Case 2 ends with the
  user *certain*), and the element becomes load-bearing when the viewed repository can change
  (UX-F5): a switchable view with no visible identity cannot keep "the view never lies" true.
  The reference shows the same element (`docs/ux_reference/README.md` § `vscode-files-view.png`
  — Take, "The repository named in the shell chrome"). *(re: § 4, UX-F5; PRD source: Key Use
  Cases 2, UX Notes "What must feel effortless" — trust)*
- **RN-3:** *(added)* The reading panel carries the open file's path — *because* two states the
  PRD requires cannot be told without it: the open file gone from disk is stated *as that file*
  (UX-I4), and a cannot-display placeholder names the file it stands for (UX-S1). A panel that
  shows content with no name asks the reader to trust the tree's highlight alone, and the tree
  may have scrolled. *(re: § 4, UX-S1; PRD source: UX Notes "the view never lies", "Failure
  states")*
- **RN-4:** *(added)* Empty-repository, clean-tree, pending-folder and unreadable-entry states —
  *because* the surface can land in each and the PRD never names them; an unhandled state is a
  defect of this document. Each is designed to the view-never-lies rule: absence is stated,
  never shown as a blank pane, and "nothing changed" is shown only after Git state has been
  read, since a clean tree drawn before reading is a state the tool has not established
  (UX-I13). *(re: UX-S2, UX-S3; PRD source: UX Notes "the view never lies", implied)*
- **RN-5:** *(added)* Updates arrive without ceremony (UX-I2), and a failing item degrades only
  itself (UX-I10) — *because* the character is "still" and the driving scenario is a
  continuously changing tree: an attention bid per change would make the watching flow unusable,
  and a shell that blocks on one unreadable item cannot watch a moving tree at all. Both
  elaborate stated PRD intent; neither invents product intent. *(re: UX-I2, UX-I10; PRD source:
  UX Notes "The character", Key Use Cases 3)*
- **RN-6:** *(owner decision — placement added)* The beyond-v1 **diff** surfaces carry the
  owner's settled shape — staged distinguished from unstaged, per-commit diff reusing the same
  presentation (`docs/trail/srs/cycle-1.md` § 2.2, the override) — and this document's placement
  decisions are its own: the diff in the reading panel (a diff is content to read), history
  reached from the Git view (it is Git state), both in the same single window, *because* the
  shell's IA has exactly those two homes and a second window would break the one-shell arrival
  model. History filtering and search stay out — that part of the same answer is untouched
  (§ 10). *(re: UX-F4, UX-S5, UX-S6, § 4; PRD source: Scope (In) full ambition)*
- **RN-7:** *(confirmed choice)* The initial theme follows the platform's own appearance
  setting, and where no platform signal can be read the initial theme is **light** — *because*
  the adopter's environment outranks the product's aesthetic: which polarity reads better depends
  on the room the user is in, and the operating system already carries their answer; the instance
  direction starts every surface from the platform's own look
  (`system/experience/visual_direction.md` § Overview, line 2). The signal-less default is a
  polarity choice with no PRD basis; the lean to light rests on this seat's reading that
  dark-text-on-light is the more widely evidenced legibility default for reading text — held as
  reasoning, not a citation — and the owner confirmed it (`docs/trail/uxd/cycle-1.md` § 2.5).
  Dark stays a first-class, equally maintained theme — a preference honoured, never an ergonomic
  claim. `DESIGN.md` carries the stated default as a value with its reason. *(re: UX-I9, § 9;
  PRD source: UX Notes "dark and light themes from the start", Data & Privacy)*
- **RN-8:** *(confirmed choice)* The design direction — a restrained code-workbench built from
  primitives, no established component design system — is a taste call, and the owner confirmed
  it (`docs/trail/uxd/cycle-1.md` § 2.1) on two grounds of their own: every asset must ship
  inside the tool (UX-I15), so a system that fetches fonts or icons at runtime would have to be
  audited and vendored anyway — the cost without the convenience; and the surface is one reading
  panel, one sidebar, one chrome strip and a two-entry mode switch, too small for a design
  system's payoff of consistency across many unfamiliar components to arrive. An earlier
  confirmation of the same lean sits in a trail `9017ae2` removed
  (`nozoki@1d5c553:docs/uxd_trail/cycle-1.md` § 2.1); it was evidence, and the cycle-1 answer is
  the authorization this document stands on. *(re: § 1, § 9; PRD source: UX Notes "The
  character", Assumptions)*
- **RN-9:** *(added)* Public pictures of the shell must match the running product (UX-I11) —
  *because* the PRD makes the README's first screen product surface, and for a public tool the
  picture is part of the claim being checked there: a stale screenshot fails an adopter the same
  way a stale install command does (`system/doctrine/kensaiapp_doctrine.md` § Adoption is
  decided before the tool runs). This constrains truthfulness only; what the README says is the
  CPO's. *(re: UX-I11; PRD source: Goals "Pick-it-up adoption")*
- **RN-10:** *(owner decisions carried; one elaboration confirmed)* Markdown (UX-I12). Rendered by
  default is the PRD's. The raw-source switch is permitted, not required, and outside done —
  the owner's words: *"render is what i need"* and *"add the toggle if it costs nothing"*
  (`docs/trail/srs/cycle-5.md` § 2.3). A relative link may open its target if it costs nothing
  (`docs/trail/srs/cycle-5.md` § 2.2); an external link is *"shown, the reader can see where it
  points, and the system opens no path off the machine"* (`docs/trail/srs/cycle-6.md` § 2.1,
  the rationale the owner confirmed). Nothing fetched is the PRD's own promise. What this
  document adds and routes: a link that does nothing is drawn as text with its destination
  readable rather than as a control, *because* a control drawn as a route and wired to nothing
  is the shape the instance fence names as not a route
  (`system/experience/visual_restrictions.md` § `failure-says-what-next`), and a remote image
  that is not fetched is shown as a stated not-loaded placeholder, *because* a blank where an
  image belongs is a state the tool never established (UX-I13). Both are product-visible, so
  the link presentation went to the owner, who confirmed it as drafted
  (`docs/trail/uxd/cycle-1.md` § 2.6). *(re: UX-I12,
  UX-S1; PRD source: Core Features, Data & Privacy)*
- **RN-11:** *(added — the fence as product commitments)* UX-I13, UX-I14 and UX-I15 restate,
  as requirements this product's surfaces hold, three entries of the instance's visual fence —
  `no-unestablished-state`, `failure-says-what-next`, `no-runtime-remote-asset`
  (`system/experience/visual_restrictions.md` § 2). Each is written here *because* the fence
  binds every product and a UXD that did not name them would leave the SDD and the change specs
  to discover them from another folder; each carries a PRD source of its own, so none stands on
  the fence alone. The fence's fourth entry that reaches this product,
  `no-author-only-surface`, lands as a § 9 constraint; `terminal-no-color-no-tty` reaches only a
  surface this product may not have (§ Open Questions). A product may tighten a fence entry and
  may not loosen one (same file, § 1); nothing here loosens one. *(re: UX-I13–I15, § 9)*
- **RN-12:** *(added)* No meaning by hue alone (UX-A2) and no control by glyph alone (UX-A4) —
  *because* the tree's changed markers and the staged/unstaged distinction are exactly the
  kind of state distinction that collapses for the common colour-vision deficiencies, and
  redundant encoding is a component contract — deferring it means rebuilding, not adding. The
  reference's own status letters beside each file are the pattern
  (`docs/ux_reference/README.md` § `vscode-git-view.png` — Take, "The status letter"). Both are
  stated inside the settled v1 posture: they promise nothing to assistive technology (UX-A1
  stands untouched); they make the product's own markers legible to everyone. The instance
  records that colour-as-sole-carrier and text equivalents for glyphs are declared per product
  in its UXD (`system/experience/visual_restrictions.md` § 3), which is what these two entries
  do. *(re: UX-A2, UX-A4; PRD source: Core Features "changed-file markers", UX Notes
  "text-first")*
- **RN-13:** *(context the owner handed over)* The layout reference `docs/ux_reference/` — seven
  VS Code screenshots from the owner's own workbench with a README annotating every element as
  taken or excluded; an element not listed there was not considered. Its authority is **layout,
  not style** (its own opening paragraph), and this document points at it rather than restating
  it — a copied annotation would drift from the one the owner maintains. All seven images were
  opened for this revision. The README annotates the first four; the three added at
  `nozoki@b7119cb` — `vscode-git-view-worktree-stack.png`, `vscode-git-graph-merge-lanes.png`,
  `vscode-branch-filter-many-branches.png` — are not annotated, so by the README's own rule
  nothing in them is yet taken or excluded, and this document's entries rest on the four that
  are. Read against the entries they bear on, the three move nothing, and the owner directed
  this seat to make that call and record it (`docs/trail/uxd/cycle-5.md` § 1.1): the worktree
  stack lists several working trees as peers in one view, each with its own commit controls —
  several folders at once and editing affordances, both already excluded (UX-F5, UX-I1; PRD
  § Out of Scope); the merge-lanes graph is a picture of what UX-F4 and UX-S6 already state —
  commits belonging to branches, diverging and merging in both directions, the tip named — with
  branch membership carried by lane position as well as colour, which is UX-A2 as written; and
  the many-branches picker is the control `vscode-branch-filter.png` already shows, at a scale
  where its ref-list filter earns its place — the mechanism is unbound by the owner's own word
  (RN-14), and a ref-list filter is not history filtering (§ 10). Annotating the three is the
  README's owner's, not this seat's and not `product-design`'s: both of the README's commits
  carry `Role: Product` (`nozoki@d8ebfb1`, `nozoki@ea2e78a`). One defect beside the claim: that
  README's three *"Where it now stands"* lines and its § 2.1–2.3 pointers name a companion that
  `9017ae2` removed; this document keeps the `UX-…` identifiers the README cites so its entry
  references still resolve, and the retired companion (`docs/trail/uxd/cycle-1.md`) numbers the
  two placement questions the README routes (§ 2.2, § 2.3) to match. The README is the owner's
  file and is not edited here. *(re: § 4, § 9)*
- **RN-14:** *(owner decision)* The history view shows branch topology drawn against a chosen
  set of branches with a default that asks nothing — the owner's own statement of the shape, in
  their words: *"the reader can see the branches as branches — which commits belong to which,
  and where they diverge and merge — never a flat list that flattens them together. The history
  is drawn against a chosen set of branches — one, several, or all of them — with a default
  that asks nothing"* (`docs/trail/srs/cycle-3.md` § 2.1). The owner bound the properties, not
  the mechanism (same answer, *"Bind the properties, not the mechanism"*): how the graph is
  drawn and what control chooses the set stay downstream; that the choosing lives with the
  history view is this document's placement (RN-15's fence). The reference's modal checklist is
  one control among several that would serve (`docs/ux_reference/README.md`
  § `vscode-branch-filter.png`). The branch name shown at its tip commit is taken from the same
  annotation. Feasibility is downstream and does not narrow the statement. *(re: UX-F4, UX-S6;
  PRD source: Scope (In) full ambition "commit history")*
- **RN-15:** *(owner directive; placement confirmed)* The repository switch
  is a **dropdown selector** showing the current repository's name — the name is both label and
  control — listing the repositories Nozoki remembers plus a browse entry, empty of all but
  browse on first run: the owner's own naming (`docs/ux_reference/README.md` § Owner directives
  2). Remembering repositories is already permitted (PRD § Data & Privacy — tool state outside
  the viewed repository), so nothing here needs the CPO. Where it lives is drafted as the
  **shell chrome** — the identity element (RN-2) is the control — *because* what names the
  repository is what changes it (one element telling one truth, the owner's own framing in that
  directive), and the chrome is reachable from either sidebar mode while the Git view header is
  not. The alternative the reference shows — the selector grouped with repository-scoped state
  in the Git view header — buys grouping and costs reachability. The owner confirmed
  the chrome (`docs/trail/uxd/cycle-1.md` § 2.2); the earlier confirmation in the removed trail
  (`nozoki@1d5c553:docs/uxd_trail/cycle-2.md` § 2.2) was evidence, and the cycle-1 answer is
  the authorization. One fence drawn with it: where a **branch** control lives is a separate
  question — the history view's set-scoping choice is RN-14's and lives with that view. *(re:
  UX-F5, UX-S7, § 4; PRD source: Scope (In) / Out of Scope, repository switching; Data &
  Privacy)*
- **RN-16:** *(owner decision — override)* The Files/Git switch is a vertical rail down the
  sidebar's left edge, each of its two entries carrying its icon with a small text label beneath
  it — the owner's override of the drafted labelled tabs (`docs/trail/uxd/cycle-1.md` § 2.3).
  The draft's ground — § 4's text-first rule and a product with exactly two destinations — did
  not carry; the reference's own mechanism (`docs/ux_reference/README.md` § One question the
  reference raises) is taken, with the label the owner attached. Two consequences, both stated in
  the owner's answer: the rail leads with the glyph, so § 4 records a stated exception to its
  text-first rule rather than implying one; and the label beneath each entry means no control is
  carried by a glyph alone, so UX-A4 holds and no exception to it is owed. Which icons the two
  entries carry is `DESIGN.md`'s. An earlier confirmation of the tabs in the removed trail
  (`nozoki@1d5c553:docs/uxd_trail/cycle-2.md` § 2.3) was evidence, and this answer supersedes
  it. *(re: § 4, § 9, UX-A4; PRD source: UX Notes "The character" — text-first; Core Features —
  the sidebar toggle)*
- **RN-17:** *(confirmed choice)* The accessibility posture is stated on the README, not its
  first screen (UX-A3) — *because* the posture the owner settled
  (`docs/trail/prd/cycle-5.md` § 2.1) otherwise lives only in the PRD and this document, which an
  adopter never reads; a stated narrow floor is information they can act on before spending
  their first minute, and a claim the project can be held to. It adds a line to a surface the
  CPO owns, which is why it went to the owner rather than being asserted; the owner confirmed it,
  and the below-the-first-screen bound is their own words — *"agreed, keep it below the first
  screen"* (`docs/trail/uxd/cycle-1.md` § 2.4). The earlier confirmation in the removed trail
  (`nozoki@1d5c553:docs/uxd_trail/cycle-1.md` § 2.2) was evidence; the cycle-1 answer is the
  authorization. *(re: UX-A3; PRD source: UX Notes "The bounds v1 draws"; Goals "Pick-it-up
  adoption")*
- **RN-18:** *(added)* Syntax highlighting and monospace are recorded as expectations, not
  benefits — *because* their comprehension value is unproven while their absence reads as
  unfinished, and in this domain looking unfinished loses the stranger in the first minute
  (`system/doctrine/kensaiapp_doctrine.md` § What a tool here is, and what the adopter owes it).
  The same rule answers the next expected-but-unproven convention. *(re: § 9; PRD source: Core
  Features "syntax highlighting")*
- **RN-19:** *(accounting — no experience surface)* The PRD's licence, versioning, public
  identity, support posture, regulatory posture and maintenance-sustainability items produce no
  UXD entry: they are product- and release-level statements with no surface in the running
  experience, and the wording of any promise the product states is `docs/CONTENT.md`'s inside
  `system/experience/voice_restrictions.md` § `one-wording-per-promise`. The pre-1.0.0
  anything-may-change statement lives where releases are offered, not in the shell. Read-only
  *enforcement* is the SRS's; this document carries its experience half (UX-I1, UX-I4, UX-I7).
  The "familiarity thesis" (Assumptions) is carried as § 2's variance dial and § 4's shell; the
  "Why This" edge is carried as UX-I1. *(re: reverse walk; PRD source: Assumptions, Success
  Metrics, Why This)*
- **RN-20:** *(the SRS, read as a sibling)* No entry here traces to `docs/SRS.md`. It was read
  for collisions and none was found: its UI-visible requirements — `docs/SRS.md` FR-3, FR-4 and
  FR-23–FR-32 — say what this document says.
  One seam is handed forward rather than absorbed: FR-2 supplies the repository at start with no
  in-product chooser, so where UX-S4 renders in v1 depends on the start mechanism the SDD fixes
  (§ Open Questions). *(re: UX-S4, § Open Questions)*
- **RN-21:** *(the terminus)* The Agari (`system/projects/nozoki/agari.md`) was walked against
  every flow and screen. UX-F4, UX-F5 and UX-S5–S7 serve work inside done and are designed;
  search, resizing, keyboard navigation, history filtering and a second platform serve work
  outside done and are recorded in § 10, not designed. No entry traces to the Agari alone.
  *(re: § 10)*
- **RN-22:** *(owner answer)* The theme control UX-I9 requires lives in the **shell chrome, at
  its right end**, as a `sun`/`moon` glyph plus the word *Light*/*Dark* naming the theme it
  switches to (`docs/trail/uxd/cycle-2.md` § 1.1) — *because* the theme is shell-scoped state,
  exactly as the repository selector is (RN-15): the chrome is reachable from either sidebar
  mode, while the sidebar's foot — the other candidate — would tie a whole-shell setting to one
  of the sidebar's two modes. Labelling the control with its destination removes the ambiguity a
  lone moon glyph carries (is it the current theme or the next one?) and keeps UX-A4 whole.
  `docs/DESIGN.md` carries the same
  placement as tokens and a component contract; this entry is the experience half, so the two
  documents state one placement between them. *(re: § 4, UX-I9, UX-A4; PRD source: UX Notes
  "The character" — "dark and light themes from the start")*

- **RN-23:** *(added)* Every failure cell in § 6 holds a second class, the **unexplained fault**,
  and UX-I16 says where it is shown — *because* the class exists: the owner drew the line between
  a *file not found* and a system error while settling the verbal language
  (`docs/trail/content/cycle-1.md` § 2.3), `docs/CONTENT.md` § Message patterns *Error* carries a
  formula for it, and this document's own rule (RN-4) makes a state with no declared surface a
  defect here, not there. The surfaces are derived, not chosen: a fault is the tool stopping
  *one surface's* work, so it lands in that surface's existing failure slot, with the scope UX-I10
  already fixes (only the item degrades) and the route out UX-I14 already requires (the shell
  around it). Nothing new is drawn; the seven cells gain a second reading, not a new column.
  UX-I13 is met because the stopped state *is* the observation — what the tool has not established
  is the cause, and the message says exactly that. The entry is written for *the first fault that
  proves the class real* — the shape `docs/CONTENT.md` § Message patterns *Recovered* uses — so it
  declares no scope. The scope call was the owner's, and it is made: **v1 has the class**
  (`docs/trail/uxd/cycle-3.md` § 1.1) — the delivery tier treats every read path (a file, a tree
  entry, Git state, the repository at startup) as one that can end in *stopped, can't tell why*
  and builds the UX-I16 presentation on each; the SDD sizes it. The entry itself does not move on
  that answer, by design.
  The routing that put this here — which surface carries it is the CDO's, the detail control is
  the CDO's to declare and the CTO's to cost, the scope call is the owner's — is the owner's own
  partition (`nozoki@0713035`, the companion as opened; `docs/CONTENT_open_issues.md` § 1.1) and
  is carried, not re-made. *(re: § 6, UX-I16; PRD source: UX Notes "Failure states", "the view
  never lies")*
- **RN-24:** *(owner answer)* No control on any surface reveals, expands or
  copies an unexplained fault's detail (UX-I16) — *because* three settled rules leave a
  detail control nothing legitimate to show or do: the internal text such a control would reveal
  is banned from anything a person sees (`docs/CONTENT.md` § Terminology, *Banned* — *error,
  exception, stack trace, ENOENT, EACCES*, a product tightening of
  `system/experience/voice_restrictions.md` § `no-author-only-surface`); the one use of a copied
  detail is a report to a channel this instance does not staff, which UX-I14 rules is not a route
  out and `system/doctrine/kensaiapp_doctrine.md` § Maintainer capacity says will not be answered;
  and the diagnostic already has a home away from every surface — the SRS keeps it with the
  tool's own state, never transmitted (`docs/SRS.md` NFR-11), read here as a sibling for
  collision and none found. A fault nobody can see is a fault nobody can report, and that is
  accepted as the cost of the three rules rather than papered over: the surface tells the reader
  the limit of what the tool knows and what still works, which is the smaller true thing. The call
  is product-visible, so it went to the owner, who confirmed it as drafted
  (`docs/trail/uxd/cycle-3.md` § 2.1) — nothing reopens: `docs/CONTENT.md` owes no string and no
  exception to its ban, `docs/DESIGN.md` owes no control component, and the SRS's NFR-11 is asked
  for nothing more. *(re: UX-I16; PRD source: UX Notes "Failure states"; Data & Privacy)*
- **RN-25:** *(changed — upstream PRD v11)* The input is **one local folder, a Git repository or
  not**, and every place this document said "repository" where it meant the input now says
  "folder": the Design Read's product kind (§ 1), UX-U3, § 4's identity element and its beyond-v1
  bullet, UX-F1's opening and data, UX-F3's subject, UX-F5 and UX-S7 whole, UX-I16's list of
  surfaces. UX-S4 **narrows** on the same authority — a path that does not exist, is not a folder,
  or cannot be read stays a startup failure, and the non-repository case leaves it — *because*
  PRD v11 settles the product as *"a reader of folders, files and repositories — the three named
  flat"* (`docs/PRD.md` § Purpose; the owner's own sentence, `docs/trail/prd/cycle-10.md` § 2.1),
  admits the plain folder as a supported input inside v1 (`docs/PRD.md` § Scope (In); the
  directive `docs/trail/prd/cycle-9.md` § 1.1, its placement `docs/trail/prd/cycle-10.md` § 2.3),
  and strikes the non-repository from its own failure list (`docs/PRD.md` § UX Notes "Failure
  states" — *"A folder without Git is not on this list: it opens"*). The owner directed this
  document to catch up on exactly that ground (`docs/trail/uxd/cycle-4.md` § 1.1). Where the PRD
  keeps "repository" — § Target Users, § Problem Statement, the driving scenario — this document
  keeps it too: UX-U1 and UX-U2 do not move. The selector is renamed with the input, from the
  *repository selector* of the owner's directive (`docs/ux_reference/README.md` § Owner
  directives 2, written before the input widened) to the **folder selector**: the control, its
  list, its browse entry and its home are unchanged; only its input is wider, and one concept
  keeps one name across the product's documents (`system/experience/voice_restrictions.md`
  § `one-term-per-concept`). *(re: § 1, § 4, UX-U3, UX-F1, UX-F3, UX-F5, UX-S4, UX-S7, UX-I16;
  PRD source: Purpose, Scope (In), Out of Scope, Key Use Cases 4, UX Notes "Failure states")*
- **RN-26:** *(owner decision)* In a plain folder the Git view is present and shows **nothing** —
  no message, no label, no explanation, no control, no offer to create a repository — and the tree
  carries no changed-file markers (UX-I17, UX-S3 Empty, UX-S2 Success). The owner's words: *"the
  git button doesn't show anything. simple."* — overriding the CPO's drafted *present, disabled,
  and says why* (`docs/trail/prd/cycle-10.md` § 2.2, carried to this document at
  `docs/trail/uxd/cycle-4.md` § 1.1). The grounds are the owner's, recorded so this document does
  not soften them: VS Code fills the same empty state with *Initialize Repository* and *Publish to
  GitHub*, and **both are writes Nozoki can never offer** — so the surface an editor uses to sell
  a next step has no truthful next step here, and saying nothing beats explaining its own
  emptiness. The accepted cost is the owner's too: an empty view cannot by itself tell a plain
  folder apart from a repository the tool failed to read; where a fault needs telling apart it is
  UX-I16's, never a message in this state. Nothing here is a route-out breach: UX-I14 and the
  fence it restates (`system/experience/visual_restrictions.md` § `failure-says-what-next`) bind
  failure and refusal states, and the PRD names this one *"A working state, not an error"*
  (`docs/PRD.md` § UX Notes "The path" step 3). *(re: UX-I17, UX-S2, UX-S3; PRD source: Core
  Features "Git view", Key Use Cases 4, UX Notes "Checking", Out of Scope "Creating or
  initialising a Git repository")*
- **RN-27:** *(CDO-derived with basis — the four calls the owner's answer left to this seat,
  `docs/trail/uxd/cycle-4.md` § 1.1 "What is not settled here, and is the CDO's")* **(a) A
  condition, not a row.** The plain folder is drawn as a condition on UX-S2 and UX-S3 rather than
  as a new § 6 row — *because* no new surface exists: the shell, the tree, the reading panel and
  the Git view are the same objects in both inputs, and a row would name a screen the product
  does not have and owe it four states it cannot have. The two cells it changes are named in
  § 6's preface so a cold reader finds them without reading every row. **(b) No cue beyond the
  view itself.** The shell carries no mark saying whether the folder is a repository (§ 4) —
  *because* the clean Git view carries words (the branch; its stated "nothing changed") and the
  plain-folder view carries none, so the two are already told apart by what is on the surface; a
  second cue in the chrome would be a second statement of one fact, and during the live
  transition (d) the two could disagree, which is the state "the view never lies" forbids; and
  the owner chose a surface that says nothing, so a cue elsewhere would be the message moved, not
  removed. **(c) Three observations, three drawings.** Pending, nothing, and the unexplained
  fault are kept distinct in UX-S3 and UX-I17 — *because* UX-I13 forbids drawing a state the tool
  has not established: *nothing* is the drawing for an observed plain folder; before that
  observation the view is pending; and a determination that stopped is a stop the tool observed,
  which UX-I16 already places in this slot — so the new state arrives with both failure classes,
  as every cell does (RN-23). **(d) The live transition simply happens.** A repository appearing
  at the folder's root mid-session, or leaving it, is drawn as any Git-state change is — the
  view fills or empties, the markers appear or go — with no transition of its own — *because* the
  PRD names Git state among the changes that *"appear on their own"* (§ Success Metrics "Refresh
  immediacy"), UX-I2 already rules that the changed content is the signal and nothing else bids
  for attention, UX-I3 keeps the reader's place, and the motion dial (§ 2) admits movement only
  where content moved. Each is a design derivation from settled entries and PRD facts, none is a
  taste call, and the owner delegated all four in the answer cited. *(re: § 4, § 6 preface,
  UX-S3, UX-I17; PRD source: UX Notes "the view never lies", "Checking"; Success Metrics
  "Refresh immediacy")*
- **RN-28:** *(the SRS, read as a sibling)* `docs/SRS.md` v8 was read for collisions with this
  revision and none was found: its FR-33 and FR-34 (`docs/SRS.md` § 3.1) state, as system
  requirements, what UX-I17 states as experience — Git read only at a repository's root, the Git
  view present and showing nothing, no markers, a working state. No entry here traces to it. One
  seam is noted rather than absorbed: the SRS records its live-determination clause as CTO-derived
  and open to the owner narrowing it to a start-time check (`docs/SRS.md` RN-33). If that
  narrowing is ever made, UX-I17's live sentence has nothing to move and stands as written: a
  transition that cannot occur is not a state this document draws differently. *(re: UX-I17)*

---

## Open Questions

- [OPEN: Where the startup failure (UX-S4) renders in v1 — in a window the tool opens, or as
  text printed where the tool was started — depends on the acquisition-and-start mechanism the
  PRD leaves to the CTO and the SDD fixes. This document states what the surface carries either
  way (what was tried, what was observed, what to do next, and a way to leave). If any surface
  prints to a terminal, `system/experience/visual_restrictions.md` § `terminal-no-color-no-tty`
  and the terminal clause of § `failure-says-what-next` bind it. Settled by `docs/SDD.md` when
  it fixes the start mechanism.]
