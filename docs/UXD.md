# UXD — Nozoki 覗き

**Status:** Draft
**Owner:** CDO
**Version:** 1 — re-authored from PRD v8 after the earlier UXD was removed at `9017ae2`; six experience calls the PRD does not make are drafted here and wait for the owner in `docs/UXD_open_issues.md`

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

Reading this as: **a local, read-only repository viewer for developers, with a calm, still,
plain-spoken language, leaning toward a restrained code-workbench aesthetic built from
primitives rather than an established component design system.** *(→ PRD § Purpose; § UX Notes
"The character" — "calm, truthful, still"; § Assumptions, the familiarity thesis. The aesthetic
lean is a taste call and is drafted, not settled — `docs/UXD_open_issues.md` § 2.1; see § 9 and
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
  environment, against one local repository at a time; interaction is mouse-driven; the UI
  language is English. Assistive technology: v1 makes no assistive-technology promise (UX-A1).
  *(→ PRD § Scope (In) run posture and platform; § UX Notes "The bounds v1 draws")*

## 4. Information Architecture

- **One window, one shell.** A sidebar beside a dominant reading panel. No other top-level area
  exists: no settings area, no configuration surface, no onboarding surface — nothing to set
  up, sign into, or dismiss. *(→ PRD § UX Notes "The path" step 1; § Goals "No learning curve")*
- **The layout reference is `docs/ux_reference/`** — four VS Code screenshots the owner
  supplied, with a README annotating every element as taken or excluded. It is a reference for
  **layout, not style** (`docs/ux_reference/README.md`, its opening paragraph); the proportions
  (narrow navigation column, dominant reading panel) and the tree's shape are anchored there,
  and this document points at it rather than restating it. *(context the owner handed over;
  RN-13)*
- **The sidebar toggles between Files and Git** (v1). The toggle is a mode of the sidebar only
  and never affects the reading panel (UX-I3). Presentation: a pair of labelled tabs at the top
  of the sidebar — text-first, exactly the two destinations that exist; not an icon rail.
  *(→ PRD § Core Features "A sidebar that toggles"; the tab presentation is drafted, not
  settled — `docs/UXD_open_issues.md` § 2.3, RN-16)*
- **Navigation is text-first, icons secondary.** Every icon sits beside a text label or has a
  text form (UX-A4). *(→ PRD § UX Notes "The character")*
- **The shell names what it is looking at.** The viewed repository is identified in the shell
  chrome; the branch lives in the Git view. Certainty about *what* is being inspected is part of
  the trust the product sells, and it becomes load-bearing when the viewed repository can change
  (UX-F5). Beyond v1 the identity element is itself the repository selector — what names the
  repository is what changes it (UX-F5; the placement is drafted, not settled —
  `docs/UXD_open_issues.md` § 2.2, RN-15). *(added — RN-2)*
- **The reading panel names what is open.** The open file's repository-relative path is shown
  with its content, so the panel tells the reader what they are reading and, when that file is
  gone, what is gone (UX-I4). *(added — RN-3)*
- **Beyond v1, inside the terminus:** the same single window holds everything. A diff is shown
  in the reading panel — a diff is content to read; commit history is reached from the Git
  view; switching the viewed repository is the repository selector (UX-F5). No second window.
  *(→ PRD § Scope (In) full ambition; placement: RN-6)*

## 5. Key Flows

### 5.1 UX-F1 — Arrive and read *(→ PRD § Key Use Cases 1; § UX Notes "The path" steps 1–2)*

- Steps: the experience begins with Nozoki open against one local repository — what precedes
  that moment is out of scope (§ 10). The workbench opens with the file tree visible and the
  reading panel in its empty state, prompting file selection. The user selects a file; its
  content appears with no perceived wait (PRD § Success Metrics "File-switch immediacy"): with
  syntax highlighting when the file is in one of the six floor languages, as plain text when it
  is any other text, rendered when it is Markdown, and as a stated cannot-display-as-text state
  when it is not text (UX-S1). They move file to file as fast as they can decide what to read
  next.
- Data the UI needs at each step: the repository's identity; the tree — folders, files, and for
  each file whether Git reports it changed; per selected file — its path, its content, which
  floor language its extension maps to or none, and whether it is Markdown; the current
  selection.
- Failure/recovery: pointed at a path that is not a readable local Git repository — UX-S4. A
  file that cannot be shown as text — the stated placeholder (UX-S1 Error), the shell fully
  usable. A single unreadable item degrades only its own presentation, never the shell (UX-I10).

### 5.2 UX-F2 — Check what changed *(→ PRD § Key Use Cases 2; § UX Notes "The path" step 3)*

- Steps: mid-reading, the user switches the sidebar to Git — branch, changed files, staged files
  and short repository status at a glance. They open a changed file from the Git view to read it
  (opening from the Git view behaves exactly as a tree selection). They switch back to Files;
  the open file and their reading position are untouched throughout.
- Data the UI needs at each step: Git state — branch name, the changed files, the staged files,
  the short status; tree markers consistent with the Git view's list.
- Failure/recovery: Git state transiently unreadable (a lock mid-operation) — that item's view
  shows that it is not yet read and recovers on a later refresh (UX-S3 Error). A repository
  mid-operation — a merge, a rebase, a detached state — is an inspection subject: the Git view
  presents whatever state the repository is truly in, never an error (UX-S3).

### 5.3 UX-F3 — Watch a moving tree *(→ PRD § Key Use Cases 3; § UX Notes "The path" step 4, "the view never lies")*

- Steps: the user leaves the view open while another process — an automated tool, an agent —
  changes the repository. Changes on disk appear in the view on their own, within the refresh
  bar (PRD § Success Metrics "Refresh immediacy"); there is no refresh control (UX-I2). The
  user's place survives every update: expanded tree nodes, the open file, the reading position —
  only what actually changed changes (UX-I3). If the open file changes on disk, its content
  updates in place; if it disappears, the view says so plainly (UX-I4).
- Data the UI needs at each step: the current tree and Git state, fresh enough to meet the
  refresh bar; which items changed since the last view, so that only those update; for the open
  file, whether it still exists and whether its content changed.
- Failure/recovery: rapid concurrent changes never blank, block, or crash the shell; the view
  converges to the state on disk. Closing at any moment during this asks nothing — the user
  leaves certain the repository is exactly as they found it (UX-I5).

### 5.4 UX-F4 — Inspect changes and history *(beyond v1)* *(→ PRD § Scope (In) full ambition: diffs, commit history)*

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

### 5.5 UX-F5 — Switch the viewed repository *(beyond v1)* *(→ PRD § Scope (In) "one repository at a time is a v1 cut"; § Out of Scope "Changing the viewed repository without restarting")*

- Steps: the **repository selector** shows the current repository's name — the name is both the
  label and the control (the owner's directive: `docs/ux_reference/README.md` § Owner
  directives 2 — RN-15). Opening it lists the repositories Nozoki remembers, with an entry to
  browse for one not in the list; on first run the list is empty and only the browse entry is
  there. Choosing one returns the shell to the arrival state (UX-F1) for that repository.
  Always exactly one repository at a time — switching replaces, never adds.
- The remembered list is the tool's own state, kept outside the viewed repository (→ PRD § Data
  & Privacy). Where the selector lives is drafted as the shell chrome — the identity element
  (§ 4, RN-2) is the control — and waits for the owner (`docs/UXD_open_issues.md` § 2.2,
  RN-15).
- Data the UI needs at each step: the remembered-repositories list; the new repository's
  identity, tree and Git state; the shell chrome's repository name.
- Failure/recovery: a chosen path that is not a readable local Git repository gets the same
  plain failure language as startup (UX-S4 / UX-S7), and the previously viewed repository stays
  viewed; nothing about either repository changes.

## 6. Screen Inventory & States

The product has one window; the rows are its surfaces. A state that cannot arise is `n/a` with
its reason. Every indicator in every cell is drawn only after the tool has observed the state it
stands for (UX-I13), and every failure cell carries a route out on the same surface (UX-I14).

| ID | Screen | Empty | Loading | Error | Success |
|---|---|---|---|---|---|
| UX-S1 | Reading panel | No file selected: one prompt to select a file, and nothing else — no shortcut list, no watermark *(→ PRD § Core Features "empty state"; § UX Notes "The path" step 1)* | The bar is no perceived wait (PRD § Success Metrics); a file that is genuinely still being read shows that it is being read, without a progress claim the tool has not measured, and without blocking the shell | A file that is not text: a stated cannot-display-as-text placeholder naming the file and saying why its content is not shown — never a garbled render, never an error *(→ PRD § UX Notes "Failure states")*. The open file gone from disk: the panel keeps the file's name and states plainly that it is no longer there; the vanished content is not shown as current (UX-I4). A file the tool cannot read: a plain statement of what it was doing and what it observed, recovering when readable. In every case the tree beside the panel stays enabled, and is the route out | Read-only content named by its path (§ 4): syntax-highlighted for the six floor languages, plain text for every other text file, rendered for Markdown (UX-I12); reading position preserved across refreshes (UX-I3) |
| UX-S2 | Files view (tree) | A repository with no files: a stated empty-tree message, not a blank pane *(added — RN-4)* | The tree appears as it is read; a folder not yet read shows that it is pending rather than showing as empty; changed-file markers appear only once Git state has been read *(added — RN-4, UX-I13)* | An entry that cannot be read is marked so with what the tool observed; the rest of the tree stands *(added — RN-4)* | The tree with changed-file markers and the selected file highlighted, the marker carrying its meaning in text as well as colour (UX-A2) *(→ PRD § Core Features)* |
| UX-S3 | Git view | A clean tree, once Git state has been read: stated plainly — "nothing changed" is information, not a blank pane, and it is shown only after the tool has observed it *(added — RN-4, UX-I13)* | State appears as it is read; before it is read, the view shows that it is reading, not a clean tree | Git state transiently unreadable: that item shows what the tool observed (a lock, an unreadable file) and recovers on refresh. A repository mid-operation (merge, rebase, detached) is **not** an error: the true state, presented *(→ PRD § UX Notes "the view never lies")* | Branch, changed files, staged files, short status; each file's state carried by a letter or word beside it, with colour repeating it (UX-A2) *(→ PRD § Core Features)* |
| UX-S4 | Startup failure | n/a — the surface exists only in failure | n/a | Pointed at something that is not a local Git repository, or a path that does not exist or cannot be read: a plain statement of what the tool tried to open, what it observed, and what to do next, at the no-learning-curve bar — no dead end that presumes expertise *(→ PRD § UX Notes "Failure states")*. In v1 the route out is to change the path and start again, and the surface says so and carries a way to leave; beyond v1 the route is the selector's browse entry (UX-S7). Where the surface renders is a downstream question (§ Open Questions) | n/a — success is the workbench (UX-S1–S3) |
| UX-S5 | Diff view *(beyond v1)* | A file with no remaining changes: stated | As UX-S1 | A diff that cannot be produced: plain statement of what the tool observed, shell intact, the Git view beside it the route out | Read-only diff, staged distinguished from unstaged in text as well as colour (UX-F4, UX-A2) |
| UX-S6 | History view *(beyond v1)* | A repository with no commits: stated | The history appears as it is read; a graph not yet drawn shows as pending, never as a shorter history | History unreadable: plain statement, shell intact, the Git view the route out | Read-only history with branch topology visible when more than one branch exists — which commits belong to which branch, where they diverge and merge — drawn against a chosen set of branches with a default that asks nothing (UX-F4); each branch named at the commit that is its tip; per commit its identifier, message, author and date, with its changed files reachable from its entry; selecting a commit opens its diff (owner-settled shape, RN-14) |
| UX-S7 | Repository selector *(beyond v1)* | First run: no remembered repositories — the list holds only the browse entry *(owner directive — RN-15)* | n/a — the list is the tool's own remembered state, held locally | A chosen path that is not a readable repository: the same plain failure language as UX-S4, with the current repository still viewed and the selector still open as the route out | The selector lists remembered repositories plus browse; choosing one lands the arrival state (UX-F1) for the new repository, and the shell's repository name updates (§ 4) |

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
  The initial theme follows the platform's own appearance setting; the user may override, and
  the choice is remembered in the tool's own state — never in the repository. *(→ PRD § UX Notes
  "The character"; persistence: § Data & Privacy "theme choice"; the platform-signal default is
  drafted, not settled — `docs/UXD_open_issues.md` § 2.5, RN-7)*
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
  drafted, not settled — `docs/UXD_open_issues.md` § 2.6, RN-10)*
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

## 8. Accessibility Requirements

- **UX-A1** — v1's posture, as the PRD settles it: mouse-driven, with no keyboard-accessibility
  promise — and that absence is permanent, because keyboard navigation sits outside the
  product's done (§ 10). Beyond that line, v1 makes no assistive-technology promise: its
  accessibility surface is what the product already carries — two themes, text-first
  navigation. This is a stated posture, not a conformance target; no standard is claimed. *(→
  PRD § UX Notes "The bounds v1 draws"; owner-confirmed: `docs/prd_trail/cycle-5.md` § 2.1)*
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
  the README is the CPO's; this entry asks only that the sentence exists and where. *(drafted,
  not settled — `docs/UXD_open_issues.md` § 2.4, RN-17)*
- **UX-A4** — No control and no state is carried by a glyph alone: every icon sits beside a text
  label or has a text form the surface shows. *(→ PRD § UX Notes "navigation is text-first,
  icons secondary"; added — RN-12)*
- **Minimum contrast** — no conformance number is claimed here, in keeping with UX-A1.
  `docs/DESIGN.md` states, as a number, the contrast floor its tokens hold on both themes, and
  that number is the product's floor from the moment it is written.

## 9. Design-System Direction

- **Direction:** no established component design system. A restrained code-workbench aesthetic
  built from primitives: the reading panel is the dominant visual surface, navigation is
  text-first with icons secondary, chrome is minimal, and nothing visible is decorative — in
  this domain restraint is the credibility signal, and the product's own character ("calm,
  truthful, still") rules out imported component aesthetics. One system for the product. The
  platform's own controls and appearance are the starting point where this document and
  `DESIGN.md` are silent (`system/experience/visual_direction.md` § Overview, line 2).
  *(→ PRD § UX Notes "The character"; § Assumptions, the familiarity thesis. Drafted, not
  settled — `docs/UXD_open_issues.md` § 2.1, RN-8. Layout reference, not style:
  `docs/ux_reference/`, RN-13.)*
- **Constraints the design language must satisfy:**
  - Dark and light as first-class, equally maintained themes; initial polarity from the
    platform's appearance setting (UX-I9, RN-7).
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
  `docs/srs_trail/cycle-1.md` § 2.2). The history view's branch-set choice is not a filter: it
  chooses what the graph draws, and does not search the history (UX-F4).
- **The Markdown raw-source switch and relative-link opening** — permitted, not required, and
  outside done (owner: `docs/srs_trail/cycle-5.md` § 2.2, § 2.3). UX-I12 states what each looks
  like in a release that ships it, so that a release which does is not designed at code time;
  neither is a condition of done.
- **A second platform** — v1 promises macOS only, and done does not wait for Linux or Windows
  (owner: `docs/srs_trail/cycle-5.md` § 2.4). Nothing here is designed for another platform's
  conventions.
- **A front end for agent workflows and repository-inspection services** — where a next product
  might go, not where this one docks; nothing here designs for it.
- **The acquisition-and-start experience** — the PRD holds the mechanism out of scope; the
  experience defined here begins with the shell open against a repository (UX-F1). The README's
  content is the CPO's; this UXD constrains only the truthfulness of public pictures of the
  shell (UX-I11) and asks for one posture sentence (UX-A3).
- **Editing and Git operations** — excluded by the PRD as product capability; this document's
  share of that exclusion is UX-I1 (no affordance, no framing).
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
| UX-U3 | § Scope (In) run posture, platform; § UX Notes "The bounds v1 draws" |
| UX-F1 | § Key Use Cases 1; § UX Notes "The path" 1–2; § Core Features (highlighting floor, Markdown, empty state) |
| UX-F2 | § Key Use Cases 2; § UX Notes "The path" 3 |
| UX-F3 | § Key Use Cases 3; § UX Notes "The path" 4, "the view never lies"; § Success Metrics "Refresh immediacy" |
| UX-F4 | § Scope (In) full ambition (diffs, commit history); diff shape: owner decision `docs/srs_trail/cycle-1.md` § 2.2 (RN-6); history shape: owner decision `docs/srs_trail/cycle-3.md` § 2.1 (RN-14) |
| UX-F5 | § Scope (In) "one repository at a time is a v1 cut"; § Out of Scope "Changing the viewed repository without restarting"; § Data & Privacy (remembered list); the selector: owner directive `docs/ux_reference/README.md` § Owner directives 2 (RN-15) |
| UX-S1 | § Core Features "empty state", "read-only viewing", the highlighting floor, Markdown; § UX Notes "Failure states", "the view never lies" |
| UX-S2 | § Core Features "file tree", markers, selection; empty/loading/error cells added (RN-4) |
| UX-S3 | § Core Features "Git view"; § UX Notes "the view never lies"; empty cell added (RN-4) |
| UX-S4 | § UX Notes "Failure states" |
| UX-S5 | § Scope (In) full ambition; owner decision `docs/srs_trail/cycle-1.md` § 2.2 |
| UX-S6 | § Scope (In) full ambition; history shape: owner decision `docs/srs_trail/cycle-3.md` § 2.1 (RN-14) |
| UX-S7 | § Scope (In) / § Out of Scope (repository switching); the selector: owner directive (RN-15) |
| UX-I1 | § UX Notes "The character" |
| UX-I2 | § UX Notes "The path" 4; no-ceremony: added (RN-5) |
| UX-I3 | § UX Notes "the view never lies", "The path" 3 |
| UX-I4 | § UX Notes "the view never lies" |
| UX-I5 | § UX Notes "The path" 5 |
| UX-I6 | § UX Notes "Failure states", "The bounds v1 draws" |
| UX-I7 | § Out of Scope "Editing, permanently"; § Data & Privacy |
| UX-I8 | § UX Notes "The bounds v1 draws"; permanence: Agari |
| UX-I9 | § UX Notes "The character"; § Data & Privacy; platform-signal default: drafted (RN-7) |
| UX-I10 | § Key Use Cases 3; § UX Notes "Failure states"; added as pattern (RN-5) |
| UX-I11 | § Goals "Pick-it-up adoption"; added (RN-9) |
| UX-I12 | § Core Features "Markdown is rendered by default"; § Data & Privacy; owner calls `docs/srs_trail/cycle-5.md` § 2.2, § 2.3, `docs/srs_trail/cycle-6.md` § 2.1 (RN-10) |
| UX-I13 | § UX Notes "the view never lies"; instance fence; added (RN-11) |
| UX-I14 | § UX Notes "Failure states"; instance fence; added (RN-11) |
| UX-I15 | § Data & Privacy; instance fence; added (RN-11) |
| UX-A1 | § UX Notes "The bounds v1 draws"; owner-confirmed `docs/prd_trail/cycle-5.md` § 2.1 |
| UX-A2 | § Core Features "changed-file markers"; added (RN-12), inside UX-A1's posture |
| UX-A3 | § UX Notes "The bounds v1 draws"; § Goals "Pick-it-up adoption"; drafted (RN-17) |
| UX-A4 | § UX Notes "The character" — text-first; added (RN-12) |
| § 4 IA (shell, sidebar, text-first) | § UX Notes "The character", "The path" 1; § Core Features |
| § 4 layout reference | context the owner handed over, `docs/ux_reference/README.md` (RN-13) |
| § 4 Files/Git switch presentation | § Core Features "sidebar that toggles"; § UX Notes text-first; drafted (RN-16) |
| § 4 repository identity in shell | added (RN-2); the element is the selector control beyond v1 — drafted (RN-15) |
| § 4 open file's path in the reading panel | § UX Notes "the view never lies"; added (RN-3) |
| § 9 Direction | § UX Notes "The character"; § Assumptions; drafted (RN-8) |

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
  presentation (`docs/srs_trail/cycle-1.md` § 2.2, the override) — and this document's placement
  decisions are its own: the diff in the reading panel (a diff is content to read), history
  reached from the Git view (it is Git state), both in the same single window, *because* the
  shell's IA has exactly those two homes and a second window would break the one-shell arrival
  model. History filtering and search stay out — that part of the same answer is untouched
  (§ 10). *(re: UX-F4, UX-S5, UX-S6, § 4; PRD source: Scope (In) full ambition)*
- **RN-7:** *(drafted — awaiting the owner)* The initial theme follows the platform's own
  appearance setting — *because* the adopter's environment outranks the product's aesthetic:
  which polarity reads better depends on the room the user is in, and the operating system
  already carries their answer; the instance direction starts every surface from the platform's
  own look (`system/experience/visual_direction.md` § Overview, line 2). Dark stays a
  first-class, equally maintained theme — a preference honoured, never an ergonomic claim. What
  a signal-less machine gets is the owner's call and is routed with this item
  (`docs/UXD_open_issues.md` § 2.5). *(re: UX-I9, § 9; PRD source: UX Notes "dark and light
  themes from the start", Data & Privacy)*
- **RN-8:** *(drafted — awaiting the owner)* The design direction — a restrained code-workbench
  built from primitives, no established component design system — is a taste call and is
  routed (`docs/UXD_open_issues.md` § 2.1). The owner confirmed the same lean once, in a trail
  that is no longer on disk (`nozoki@1d5c553:docs/uxd_trail/cycle-1.md` § 2.1, readable in the
  product repository's history); that answer is evidence of the owner's taste and not an
  authorization this document can stand on, since `9017ae2` removed it and the station that
  opened this run records that the removed UXD binds nothing
  (`system/projects/nozoki/journey/shukuba/2026-08-26_experience.md` § What it is). *(re: § 1,
  § 9; PRD source: UX Notes "The character", Assumptions)*
- **RN-9:** *(added)* Public pictures of the shell must match the running product (UX-I11) —
  *because* the PRD makes the README's first screen product surface, and for a public tool the
  picture is part of the claim being checked there: a stale screenshot fails an adopter the same
  way a stale install command does (`system/doctrine/kensaiapp_doctrine.md` § Adoption is
  decided before the tool runs). This constrains truthfulness only; what the README says is the
  CPO's. *(re: UX-I11; PRD source: Goals "Pick-it-up adoption")*
- **RN-10:** *(owner decisions carried; one elaboration drafted)* Markdown (UX-I12). Rendered by
  default is the PRD's. The raw-source switch is permitted, not required, and outside done —
  the owner's words: *"render is what i need"* and *"add the toggle if it costs nothing"*
  (`docs/srs_trail/cycle-5.md` § 2.3). A relative link may open its target if it costs nothing
  (`docs/srs_trail/cycle-5.md` § 2.2); an external link is *"shown, the reader can see where it
  points, and the system opens no path off the machine"* (`docs/srs_trail/cycle-6.md` § 2.1,
  the rationale the owner confirmed). Nothing fetched is the PRD's own promise. What this
  document adds and routes: a link that does nothing is drawn as text with its destination
  readable rather than as a control, *because* a control drawn as a route and wired to nothing
  is the shape the instance fence names as not a route
  (`system/experience/visual_restrictions.md` § `failure-says-what-next`), and a remote image
  that is not fetched is shown as a stated not-loaded placeholder, *because* a blank where an
  image belongs is a state the tool never established (UX-I13). Both are product-visible, so
  the link presentation goes to the owner (`docs/UXD_open_issues.md` § 2.6). *(re: UX-I12,
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
- **RN-13:** *(context the owner handed over)* The layout reference `docs/ux_reference/` — four
  VS Code screenshots from the owner's own workbench with a README annotating every element as
  taken or excluded; an element not listed there was not considered. Its authority is **layout,
  not style** (its own opening paragraph), and this document points at it rather than restating
  it — a copied annotation would drift from the one the owner maintains. The four images were
  opened for this revision. One defect beside the claim: that README's three *"Where it now
  stands"* lines and its § 2.1–2.3 pointers name a companion that `9017ae2` removed; this
  document keeps the `UX-…` identifiers the README cites so its entry references still resolve,
  and the companion this run writes numbers the two placement questions the README routes
  (§ 2.2, § 2.3) to match. The README is the owner's file and is not edited here. *(re: § 4,
  § 9)*
- **RN-14:** *(owner decision)* The history view shows branch topology drawn against a chosen
  set of branches with a default that asks nothing — the owner's own statement of the shape, in
  their words: *"the reader can see the branches as branches — which commits belong to which,
  and where they diverge and merge — never a flat list that flattens them together. The history
  is drawn against a chosen set of branches — one, several, or all of them — with a default
  that asks nothing"* (`docs/srs_trail/cycle-3.md` § 2.1). The owner bound the properties, not
  the mechanism (same answer, *"Bind the properties, not the mechanism"*): how the graph is
  drawn and what control chooses the set stay downstream; that the choosing lives with the
  history view is this document's placement (RN-15's fence). The reference's modal checklist is
  one control among several that would serve (`docs/ux_reference/README.md`
  § `vscode-branch-filter.png`). The branch name shown at its tip commit is taken from the same
  annotation. Feasibility is downstream and does not narrow the statement. *(re: UX-F4, UX-S6;
  PRD source: Scope (In) full ambition "commit history")*
- **RN-15:** *(owner directive; placement drafted — awaiting the owner)* The repository switch
  is a **dropdown selector** showing the current repository's name — the name is both label and
  control — listing the repositories Nozoki remembers plus a browse entry, empty of all but
  browse on first run: the owner's own naming (`docs/ux_reference/README.md` § Owner directives
  2). Remembering repositories is already permitted (PRD § Data & Privacy — tool state outside
  the viewed repository), so nothing here needs the CPO. Where it lives is drafted as the
  **shell chrome** — the identity element (RN-2) is the control — *because* what names the
  repository is what changes it (one element telling one truth, the owner's own framing in that
  directive), and the chrome is reachable from either sidebar mode while the Git view header is
  not. The alternative the reference shows — the selector grouped with repository-scoped state
  in the Git view header — buys grouping and costs reachability. Routed at
  `docs/UXD_open_issues.md` § 2.2; the owner confirmed the same placement once in the removed
  trail (`nozoki@1d5c553:docs/uxd_trail/cycle-2.md` § 2.2), which is evidence, not
  authorization (RN-8). One fence drawn with it: where a **branch** control lives is a separate
  question — the history view's set-scoping choice is RN-14's and lives with that view. *(re:
  UX-F5, UX-S7, § 4; PRD source: Scope (In) / Out of Scope, repository switching; Data &
  Privacy)*
- **RN-16:** *(drafted — awaiting the owner)* The Files/Git switch is a pair of labelled tabs at
  the top of the sidebar — *because* § 4's navigation rule is text-first with icons secondary
  and the product has exactly two destinations: an icon rail (the reference's own mechanism,
  `docs/ux_reference/README.md` § One question the reference raises) is built for many
  destinations and identifies them by icon alone, and the Agari admits no third view. Routed at
  `docs/UXD_open_issues.md` § 2.3; confirmed once in the removed trail
  (`nozoki@1d5c553:docs/uxd_trail/cycle-2.md` § 2.3) — evidence, not authorization (RN-8).
  *(re: § 4; PRD source: UX Notes "The character" — text-first; Core Features — the sidebar
  toggle)*
- **RN-17:** *(drafted — awaiting the owner)* The accessibility posture is stated on the README,
  not its first screen (UX-A3) — *because* the posture the owner settled
  (`docs/prd_trail/cycle-5.md` § 2.1) otherwise lives only in the PRD and this document, which an
  adopter never reads; a stated narrow floor is information they can act on before spending
  their first minute, and a claim the project can be held to. It adds a line to a surface the
  CPO owns, which is why it is routed (`docs/UXD_open_issues.md` § 2.4) rather than asserted;
  confirmed once with the not-first-screen bound in the removed trail
  (`nozoki@1d5c553:docs/uxd_trail/cycle-1.md` § 2.2) — evidence, not authorization (RN-8).
  *(re: UX-A3; PRD source: UX Notes "The bounds v1 draws"; Goals "Pick-it-up adoption")*
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
  for collisions and none was found: its UI-visible requirements — FR-3, FR-4, FR-23–FR-32 —
  say what this document says, and the station that opened this run lists them as states the
  UXD inherits (`system/projects/nozoki/journey/shukuba/2026-08-26_experience.md` § Guardrail).
  One seam is handed forward rather than absorbed: FR-2 supplies the repository at start with no
  in-product chooser, so where UX-S4 renders in v1 depends on the start mechanism the SDD fixes
  (§ Open Questions). *(re: UX-S4, § Open Questions)*
- **RN-21:** *(the terminus)* The Agari (`system/projects/nozoki/agari.md`) was walked against
  every flow and screen. UX-F4, UX-F5 and UX-S5–S7 serve work inside done and are designed;
  search, resizing, keyboard navigation, history filtering and a second platform serve work
  outside done and are recorded in § 10, not designed. No entry traces to the Agari alone.
  *(re: § 10)*

---

## Open Questions

- [OPEN: Where the startup failure (UX-S4) renders in v1 — in a window the tool opens, or as
  text printed where the tool was started — depends on the acquisition-and-start mechanism the
  PRD leaves to the CTO and the SDD fixes. This document states what the surface carries either
  way (what was tried, what was observed, what to do next, and a way to leave). If any surface
  prints to a terminal, `system/experience/visual_restrictions.md` § `terminal-no-color-no-tty`
  and the terminal clause of § `failure-says-what-next` bind it. Settled by `docs/SDD.md` when
  it fixes the start mechanism.]
