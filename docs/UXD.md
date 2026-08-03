# UXD — Nozoki 覗き

**Status:** Settled
**Owner:** CDO
**Version:** 3 — the owner's cycle-2 answers folded and the companion closed: the history topology confirmed with the set-scoping refinement; the repository selector placed in the shell chrome; the Files/Git tabs confirmed

> The UXD is the experience source of truth: the experience-level **what**, derived from the
> settled PRD, authored concurrent with the SRS, and consumed cold by the SDD write pass (so
> the architecture accommodates the experience) and by UI-touching change specs. It is updated
> in place with versioning (bump the line above on each material change); on a revision or a
> re-authoring it is **stable by default** — every delta traces to an owner answer or an
> upstream PRD change. Every entry traces back to a PRD feature, goal, use case, or `## UX
> Notes` item — no entry without a source. Keep technical feasibility and architecture out
> (SRS/SDD), and product intent out (PRD). Give every requirement-shaped entry a stable typed ID
> (`UX-Un`, `UX-Fn`, `UX-Sn`, `UX-In`, `UX-An`) so downstream documents can reference it. Omit a
> section only when it genuinely does not apply; do not pad one to fill it.

---

## 1. Design Read

Reading this as: **a local, read-only repository viewer for developers, with a calm, restrained,
editor-workbench language, leaning toward a code-workbench aesthetic built from primitives — not
an established component design system.** *(→ PRD § Purpose; § UX Notes "The character" — "calm,
truthful, still"; § Assumptions, the familiarity thesis. The aesthetic lean is owner-confirmed:
`docs/uxd_trail/cycle-1.md` §2.1 — see § 9 and RN-8.)*

## 2. Design Dials

| Dial | Value (1–10) | Reasoning (from the PRD) |
|---|---|---|
| VARIANCE (layout experimentation: symmetric ↔ asymmetric) | 2 | The familiarity thesis (§ Assumptions) is the product's central bet: a *conventional* editor-style layout — file tree beside a reading panel — is what makes inspection comfortable. Layout experimentation attacks the product's own assumption. (RN-1) |
| MOTION (animation depth: static ↔ cinematic) | 2 | § UX Notes "The character": calm, truthful, **still** — the product presents state, and only what actually changed changes. Content genuinely moves (live refresh), so not 1 — but motion only ever communicates a change; nothing animates for effect. (RN-1) |
| DENSITY (information per viewport: airy ↔ packed) | 6 | The audience is developers and the surface is a workbench: a file tree, Git status, and code, with "what changed?" answered by a glance, not an investigation (§ UX Notes "What must feel effortless"). Information-dense where the repository is dense — but the editor panel dominant and chrome minimal, so the density is the repository's, not the shell's. (RN-1) |

## 3. Users & Contexts

- **UX-U1** — A developer inspecting a local repository they do not want to risk touching:
  reading unfamiliar code, checking the state of uncommitted work, verifying what changed.
  Expertise floor: can find their way around a repository on GitHub and follow a README — no
  editor experience, no Git expertise beyond that. *(→ PRD § Target Users; § Goals "No learning
  curve")*
- **UX-U2** — A developer watching a working tree an automated tool or coding agent is actively
  changing — the driving scenario. Attention is often split: Nozoki shares the screen with the
  agent's own surface, so the view must be trustworthy at a glance and must never demand action
  to stay current. *(→ PRD § Target Users; § Key Use Cases 3)*
- **UX-U3** — Context, both users: the tool runs on the user's own machine, in a desktop windowed
  environment, against one local repository at a time; interaction is mouse-driven. Assistive
  technology: v1 makes no assistive-technology promise (see UX-A1). *(→ PRD § Scope (In) run
  posture; § UX Notes "The bounds v1 draws")*

## 4. Information Architecture

- **One window, one shell.** A sidebar beside a dominant reading panel. There are no other
  top-level areas: no settings area, no configuration surface, no onboarding surface — nothing
  exists to set up, sign into, or dismiss. *(→ PRD § UX Notes "The path" step 1; § Goals "No
  learning curve")*
- **The shell's layout reference is `docs/ux_reference/`** — owner-supplied, annotated element by
  element as taken or excluded; a reference for **layout, not style**. The proportions (narrow
  navigation column, dominant reading panel) and the tree's shape are anchored there; this
  document points at it rather than restating it. *(owner answer: `docs/uxd_trail/cycle-1.md`
  §2.1 — RN-13)*
- **The sidebar toggles between Files and Git** (v1). The toggle is a mode of the sidebar only;
  it never affects the reading panel (UX-I3). Presentation: a pair of labelled tabs at the top of
  the sidebar — text-first, and exactly the two destinations that exist; not an icon rail.
  *(→ PRD § Core Features; the tab presentation: owner-confirmed — `docs/uxd_trail/cycle-2.md`
  §2.3, RN-16)*
- **Navigation is text-first, icons secondary.** *(→ PRD § UX Notes "The character")*
- **The shell names what it is looking at** — the viewed repository is identified in the shell
  chrome; the branch lives in the Git view (§ Core Features). Certainty about *what* is being
  inspected is part of the trust the product sells, and it becomes load-bearing when the viewed
  repository can change (UX-F5). Beyond v1 the identity element is itself the repository
  selector — what names the repository is what changes it (UX-F5; placement owner-confirmed:
  RN-15). *(added — RN-2)*
- **Beyond v1, inside the terminus:** the same single window holds everything. Diffs are shown in
  the reading panel — a diff is content to read; commit history is reached from the Git side;
  switching the viewed repository is the repository selector (UX-F5). No second window, ever.
  *(→ PRD § Scope (In) full ambition; placement: RN-6)*

## 5. Key Flows

### 5.1 UX-F1 — Arrive and read *(→ PRD § Key Use Cases 1; § UX Notes "The path" steps 1–2)*

- Steps: the experience begins with Nozoki open against one local repository (what precedes that
  moment is out of scope — § 10). The workbench opens with the file tree visible and the reading
  panel in its empty state, prompting file selection. The user selects a file; its content
  appears with syntax highlighting, with no perceived wait (PRD § Success Metrics,
  "File-switch immediacy"). They move file to file as fast as they can decide what to read next.
- Data the UI needs at each step: the repository's identity; the tree (folders, files,
  changed-file markers); per selected file — content, detected language; the current selection.
- Failure/recovery: pointed at a path that is not a readable local Git repository — UX-S4. A file
  that cannot be shown as text — the stated placeholder (UX-S1 Error), shell fully usable. A
  single unreadable item degrades only its own presentation, never the shell (UX-I10).

### 5.2 UX-F2 — Check what changed *(→ PRD § Key Use Cases 2; § UX Notes "The path" step 3)*

- Steps: mid-reading, the user toggles the sidebar to Git — branch, changed files, staged files,
  and short repository status at a glance. They open a changed file from the Git view to read it
  (opening from the Git view behaves exactly as a tree selection). They toggle back to Files;
  the open file and their reading position are untouched throughout.
- Data the UI needs at each step: Git state — branch name, changed files, staged files, short
  status; tree markers consistent with the Git view's list.
- Failure/recovery: Git state transiently unreadable (a lock mid-operation) — that item's view
  degrades visibly and recovers on a later refresh (UX-S3 Error). A repository mid-operation — a
  merge, a rebase, a detached state — is an inspection subject: the Git view presents whatever
  state the repository is truly in, never an error (UX-S3).

### 5.3 UX-F3 — Watch a moving tree *(→ PRD § Key Use Cases 3; § UX Notes "The path" step 4, "the view never lies")*

- Steps: the user leaves the view open while another process — an automated tool, an agent —
  changes the repository. Changes on disk appear in the view on their own, within the refresh bar
  (PRD § Success Metrics, "Refresh immediacy"); there is no refresh control (UX-I2). The user's
  place survives every update: expanded tree nodes, the open file, the reading position — only
  what actually changed changes (UX-I3). If the open file changes on disk, its content updates in
  place; if it disappears, the view says so plainly (UX-I4).
- Data the UI needs at each step: the current tree and Git state, fresh enough to meet the
  refresh bar; which items changed, so that only those update.
- Failure/recovery: rapid concurrent changes never blank, block, or crash the shell; the view
  converges to the state on disk. Closing at any moment during this — the user leaves certain the
  repository is exactly as they found it (UX-I5).

### 5.4 UX-F4 — Inspect changes and history *(beyond v1)* *(→ PRD § Scope (In) full ambition: diffs, commit history)*

- Steps: from the Git view, the user opens a changed file's **diff** — read-only, with staged
  changes distinguished from unstaged ones — in the reading panel. From the Git side they open
  the **commit history**. When the repository's history holds more than one branch, the reader
  can see the branches as branches: which commits belong to which, and where they diverge and
  merge — never a flat list that flattens them together. The history is drawn against a chosen
  **set** of branches — one, several, or all of them — with a default that asks nothing: the
  current branch and what relates to it, so a reader who never touches the choice still arrives
  at a graph, not a prompt. The choosing belongs to the history view itself. Per commit:
  identifier, message, author, and date, with its changed files reachable from its entry.
  Selecting a commit presents what that commit changed, in the same diff presentation.
- Data the UI needs at each step: per changed file, its diff content with the staged/unstaged
  distinction; the commit history with its parent relationships (the topology) and branch
  identity, scoped by the chosen branch set; per commit — identifier, message, author, date,
  changed files; per selected commit, what it changed.
- Failure/recovery: read-only throughout — presenting the staged state stages nothing. History
  filtering and search do not exist (outside done — § 10). A diff or history item that cannot be
  read degrades only itself, as everywhere (UX-I10).
- The diff shape — staged-vs-unstaged, per-commit diff reusing the same presentation — is the
  owner's settled decision, carried here (RN-6). The history shape was reopened by the owner and
  is now settled: the topology statement above, confirmed with the set-scoping refinement
  (`docs/uxd_trail/cycle-2.md` §2.1 — RN-14).

### 5.5 UX-F5 — Switch the viewed repository *(beyond v1)* *(→ PRD § Scope (In) "one repository at a time is a v1 cut"; § Out of Scope "Changing the viewed repository without restarting")*

- Steps: the **repository selector** shows the current repository's name — the name is both the
  label and the control *(owner directive: `docs/uxd_trail/cycle-1.md` §2.1 →
  `docs/ux_reference/README.md` § Owner directives 2 — RN-15)*. Opening it lists the repositories
  Nozoki remembers, with an entry to browse for one not in the list; on first run the list is
  empty and only the browse entry is there. Choosing one returns the shell to the arrival state
  (UX-F1) for that repository. Always exactly one repository at a time — switching replaces,
  never adds.
- The remembered list is the tool's own state, kept outside the viewed repository (→ PRD § Data &
  Privacy). Where the selector lives is settled: the shell chrome — the identity element (§ 4,
  RN-2) is the control (owner-confirmed: `docs/uxd_trail/cycle-2.md` §2.2 — RN-15).
- Data the UI needs at each step: the remembered-repositories list; the new repository's
  identity, tree, and Git state; the shell chrome's repository name updates (§ 4).
- Failure/recovery: a chosen path that is not a readable local Git repository gets the same plain
  failure language as startup (UX-S4 / UX-S7), and the previously viewed repository stays viewed;
  nothing about either repository changes.

## 6. Screen Inventory & States

The product has one window; the rows are its surfaces. A state that cannot arise is `n/a` with
its reason.

| ID | Screen | Empty | Loading | Error | Success |
|---|---|---|---|---|---|
| UX-S1 | Reading panel | No file selected: a simple prompt to select a file *(→ PRD § Core Features "empty state")* | Target is no perceived wait (PRD bar); a genuinely slow file states that it is opening, without blocking the shell | A file that cannot be shown as text: a stated cannot-display-as-text placeholder saying why — never a garbled render, never an error *(→ PRD § UX Notes "Failure states")*. The open file gone from disk: stated plainly, never shown as current (UX-I4). A file unreadable: plain statement, recovers when readable | Read-only content with syntax highlighting; reading position preserved across refreshes (UX-I3) |
| UX-S2 | Files view (tree) | A repository with no files: a stated empty-tree message, not a blank pane *(added — RN-3)* | The tree appears as it is read; the shell is usable throughout | An entry that cannot be read is marked so; the rest of the tree stands *(added — RN-3)* | The tree with changed-file markers and the selected file highlighted *(→ PRD § Core Features)* |
| UX-S3 | Git view | A clean tree is stated plainly — "nothing changed" is information, not a blank pane *(added — RN-3)* | State appears as it is read | Git state transiently unreadable: a visible degraded indication on that item, recovering on refresh. A repository mid-operation (merge, rebase, detached) is **not** an error: the true state, presented *(→ PRD § UX Notes "the view never lies")* | Branch, changed files, staged files, short status *(→ PRD § Core Features)* |
| UX-S4 | Startup failure | n/a — the surface exists only in failure | n/a | Pointed at something that is not a local Git repository, or a path that does not exist or cannot be read: a plain statement of what went wrong and what to do next, at the no-learning-curve bar — no dead end that presumes expertise *(→ PRD § UX Notes "Failure states")* | n/a — success is the workbench (UX-S1–S3) |
| UX-S5 | Diff view *(beyond v1)* | A file with no remaining changes: stated | As UX-S1 | A diff that cannot be produced: plain statement, shell intact | Read-only diff, staged distinguished from unstaged (UX-F4) |
| UX-S6 | History view *(beyond v1)* | A repository with no commits: stated | The history appears as it is read | History unreadable: plain statement, shell intact | Read-only history with branch topology visible when more than one branch exists — which commits belong to which branch, where they diverge and merge — drawn against a chosen set of branches with a default that asks nothing (UX-F4); per commit its identifier, message, author, and date, with its changed files reachable from its entry; selecting a commit opens its diff (owner-confirmed shape, RN-14) |
| UX-S7 | Repository selector *(beyond v1)* | First run: no remembered repositories — the list holds only the browse entry *(owner directive — RN-15)* | n/a — the list is the tool's own remembered state, held locally | A chosen path that is not a readable repository: the same plain failure language as UX-S4; the current repository stays viewed | The selector lists remembered repositories plus browse; choosing one lands the arrival state (UX-F1) for the new repository, and the shell's repository name updates (§ 4) |

## 7. Interaction Patterns

- **UX-I1** — No editing affordance exists anywhere, enabled or disabled, and no framing implies
  an editable mode exists elsewhere. Read-only is the product's identity, not a mode. *(→ PRD
  § UX Notes "The character")*
- **UX-I2** — There is no manual refresh control; the view follows the disk on its own. Updates
  arrive without ceremony — no notification, no flash, no attention bid; the changed content
  itself is the signal. *(→ PRD § UX Notes "The path" step 4; the no-ceremony sentence: added —
  RN-4)*
- **UX-I3** — An update the user did not ask for never takes their place away: expanded tree
  nodes, the open file, and the reading position survive every refresh; only what actually
  changed changes. *(→ PRD § UX Notes "the view never lies")*
- **UX-I4** — The view never lies: what is shown is the repository's current state, or is
  explicitly marked as no longer there; stale content is never presented as current. *(→ PRD
  § UX Notes "the view never lies")*
- **UX-I5** — Closing asks nothing, ever — no save prompt, no confirmation; there is never
  anything to save. *(→ PRD § UX Notes "The path" step 5)*
- **UX-I6** — Every message the product shows is written at the no-learning-curve bar: plain
  language, what happened and what to do next, never a raw internal diagnostic. UI language:
  English. *(→ PRD § UX Notes "Failure states", "The bounds v1 draws")*
- **UX-I7** — No undo or confirmation model exists, because no user action changes anything in
  the repository. The only state the user can change is the tool's own preferences, each
  reversible by the same control that set it. *(→ PRD § Out of Scope "Editing, permanently";
  § Data & Privacy)*
- **UX-I8** — Keyboard model: none. v1 is mouse-driven, and keyboard navigation is permanently
  outside the product's done. *(→ PRD § UX Notes "The bounds v1 draws"; permanence: the Agari,
  § 10)*
- **UX-I9** — Themes: dark and light from the start, both first-class and equally maintained. The
  initial theme follows the platform's own signal; the user may override, and the choice is
  remembered in the tool's own state — never in the repository. *(→ PRD § UX Notes "The
  character"; persistence: § Data & Privacy "theme choice"; platform-signal default: added —
  RN-5)*
- **UX-I10** — A slow or failing item degrades only its own presentation, visibly; the shell as a
  whole never blocks. *(→ PRD § Key Use Cases 3 — a view that blocks cannot watch a moving
  tree; § UX Notes "Failure states"; added as a stated pattern — RN-4)*
- **UX-I11** — The product's public visual surfaces tell the same truth as the product: a README
  screenshot (or any visual representation of the shell) shows the product as it currently is; a
  mismatch between the visual story and the running product is a defect, checked at release.
  *(→ PRD § Goals "Pick-it-up adoption" — the README's first screen is product surface; added —
  RN-7)*

## 8. Accessibility Requirements

- **UX-A1** — v1's posture, as the PRD settles it: mouse-driven, with no keyboard-accessibility
  promise — and that absence is permanent, because keyboard navigation sits outside the
  product's done (§ 10). Beyond that line, v1 makes no assistive-technology promise: its
  accessibility surface is what the product already carries — two themes, text-first
  navigation. This is a stated posture, not a conformance target; no standard is claimed. *(→
  PRD § UX Notes "The bounds v1 draws"; owner-confirmed: `docs/prd_trail/cycle-5.md`)*
- **UX-A2** — No meaning by hue alone: changed-file markers, staged/unstaged distinctions, and
  every other state distinction carry a cue that survives without color — shape, text, or
  position — in both themes. This is a design-quality rule inside the settled posture, not an
  assistive-technology promise: it makes the markers legible to everyone, including the most
  common color-vision deficiencies. The color pairs themselves are token decisions and live in
  `DESIGN.md`. *(added — RN-9)*
- **UX-A3** — The declared posture (UX-A1) is stated where the adopter can read it before
  adopting — the README, **not its first screen**: one plain sentence further down, stating the
  fact and not apologising for it, so the first screen keeps to the four things the PRD fixes
  for it. No claim beyond what UX-A1 holds. *(owner-confirmed with the placement bound:
  `docs/uxd_trail/cycle-1.md` §2.2 — RN-10)*

## 9. Design-System Direction

- **Direction:** no established component design system. A restrained code-workbench aesthetic
  built from primitives: the reading panel is the dominant visual surface, navigation is
  text-first with icons secondary, chrome is minimal, and nothing visible is decorative — in
  this domain restraint is the credibility signal, and the product's own character ("calm,
  truthful, still") rules out imported component aesthetics. One system for the product.
  *(→ PRD § UX Notes "The character"; § Assumptions, the familiarity thesis. Owner-confirmed:
  `docs/uxd_trail/cycle-1.md` §2.1 — RN-8. Layout reference, not style: `docs/ux_reference/`,
  RN-13.)*
- **Constraints the design language must satisfy:**
  - Dark and light as first-class, equally maintained themes; initial polarity from the
    platform signal, and where a hard default is ever needed with no signal, light — with the
    reason recorded in `DESIGN.md`, not left to look like taste (UX-I9, RN-5).
  - Every state distinction legible without color, in both themes (UX-A2); the deficiency-safe
    color pairs are swappable token pairs, never hardcoded into a component.
  - Body text and code legible at code-reading sizes on both themes.
  - Syntax highlighting and a monospace reading surface are held as domain **expectations** —
    their absence reads as unfinished — and are recorded as expectations, never claimed as
    comprehension benefits (RN-11).
- **Design language:** `docs/DESIGN.md` (authored by `product-design-md` off this direction; may
  trail the SDD). No token values live in this document.

## 10. Out of Scope

Scoped against the project's 上がり Agari (`system/projects/nozoki/agari.md`) — the terminus:
the v1 cut plus diffs, commit history, and repository switching, which is why UX-F4/UX-F5 and
UX-S5–S7 are designed here despite being beyond v1.

- **Sidebar search / filter, pane resizing, keyboard navigation** — the Agari places them outside
  done; not designed here. The keyboard absence is permanent, not deferred (UX-I8, UX-A1).
- **History filtering and search** — outside done with them (owner decision:
  `docs/srs_trail/cycle-1.md` §2.2).
- **A front end for agent workflows and repository-inspection services** — where a next product
  might go, not where this one docks; nothing here designs for it.
- **The acquisition-and-start experience** — the PRD deliberately holds the mechanism out of
  scope; the experience defined here begins with the shell open against a repository (UX-F1).
  The README's content is the CPO's; this UXD constrains only the truthfulness of public visual
  surfaces (UX-I11) and adds the one owner-confirmed posture sentence (UX-A3).
- **Editing and Git operations** — excluded by the PRD as product capability; this document's
  share of that exclusion is UX-I1 (no affordance, no framing).
- **Every token value** — colors, type, spacing, radii live only in `docs/DESIGN.md` (§ 9).

## 11. Traceability

| UXD entry | PRD source |
|---|---|
| UX-U1 | § Target Users; § Goals "No learning curve" |
| UX-U2 | § Target Users (driving scenario); § Key Use Cases 3 |
| UX-U3 | § Scope (In) run posture; § UX Notes "The bounds v1 draws" |
| UX-F1 | § Key Use Cases 1; § UX Notes "The path" 1–2; § Core Features |
| UX-F2 | § Key Use Cases 2; § UX Notes "The path" 3 |
| UX-F3 | § Key Use Cases 3; § UX Notes "The path" 4, "the view never lies"; § Success Metrics "Refresh immediacy" |
| UX-F4 | § Scope (In) full ambition (diffs, commit history); diff shape: owner decision, `docs/srs_trail/cycle-1.md` §2.2 (RN-6); history shape: reopened by the owner, `docs/uxd_trail/cycle-1.md` §2.1 → `docs/ux_reference/README.md` § Owner directives 1; confirmed with the set-scoping refinement: `docs/uxd_trail/cycle-2.md` §2.1 (RN-14) |
| UX-F5 | § Scope (In) "one repository at a time is a v1 cut"; § Out of Scope "Changing the viewed repository without restarting"; the selector: owner directive, `docs/uxd_trail/cycle-1.md` §2.1 (RN-15); placement owner-confirmed: `docs/uxd_trail/cycle-2.md` §2.2 (RN-15) |
| UX-S1 | § Core Features "empty state", "read-only viewing"; § UX Notes "Failure states", "the view never lies" |
| UX-S2 | § Core Features "file tree", markers, selection; empty/error cells added (RN-3) |
| UX-S3 | § Core Features "Git view"; § UX Notes "the view never lies"; empty cell added (RN-3) |
| UX-S4 | § UX Notes "Failure states" |
| UX-S5 | § Scope (In) full ambition; owner decision `docs/srs_trail/cycle-1.md` §2.2 |
| UX-S6 | § Scope (In) full ambition; history shape: owner-confirmed, `docs/uxd_trail/cycle-2.md` §2.1 (RN-14) |
| UX-S7 | § Scope (In) / § Out of Scope (repository switching); the selector: owner directive (RN-15) |
| UX-I1 | § UX Notes "The character" |
| UX-I2 | § UX Notes "The path" 4; no-ceremony: added (RN-4) |
| UX-I3 | § UX Notes "the view never lies" |
| UX-I4 | § UX Notes "the view never lies" |
| UX-I5 | § UX Notes "The path" 5 |
| UX-I6 | § UX Notes "Failure states", "The bounds v1 draws" |
| UX-I7 | § Out of Scope "Editing, permanently"; § Data & Privacy |
| UX-I8 | § UX Notes "The bounds v1 draws"; permanence: Agari |
| UX-I9 | § UX Notes "The character"; § Data & Privacy; platform-signal default: added (RN-5) |
| UX-I10 | § Key Use Cases 3; § UX Notes "Failure states"; added as pattern (RN-4) |
| UX-I11 | § Goals "Pick-it-up adoption"; added (RN-7) |
| UX-A1 | § UX Notes "The bounds v1 draws"; owner-confirmed `docs/prd_trail/cycle-5.md` |
| UX-A2 | added (RN-9), inside UX-A1's posture |
| UX-A3 | owner-confirmed with placement bound, `docs/uxd_trail/cycle-1.md` §2.2 (RN-10) |
| § 4 IA (shell, sidebar, text-first) | § UX Notes "The character", "The path" 1; § Core Features |
| § 4 layout reference | owner answer, `docs/uxd_trail/cycle-1.md` §2.1 (RN-13) |
| § 4 Files/Git switch presentation | owner-confirmed: `docs/uxd_trail/cycle-2.md` §2.3 (RN-16) |
| § 4 repository identity in shell | added (RN-2); the element is the selector control beyond v1 — owner-confirmed (RN-15) |
| § 9 Direction | § UX Notes "The character"; § Assumptions; owner-confirmed `docs/uxd_trail/cycle-1.md` §2.1 (RN-8) |

---

## UXD Review Notes

- **RN-1:** *(added — derivations)* The three dial values are CDO derivations from PRD facts, not
  owner-set values: variance 2 from the familiarity thesis (a bet on a conventional layout),
  motion 2 from "calm, truthful, still" plus the only-what-changed-changes rule, density 6 from
  the developer workbench and the answered-at-a-glance bar. Each is stated with its reasoning in
  § 2; none is a taste call beyond what those facts imply. *(re: § 2; PRD source: Assumptions,
  UX Notes)*
- **RN-2:** *(added)* The shell names the repository it is viewing — *because* certainty about
  what is being inspected is part of the trust the product sells (Key Use Case 2 ends with the
  user *certain*), and the element becomes load-bearing when the viewed repository can change
  (UX-F5): a switchable view with no visible identity cannot keep "the view never lies" true.
  *(re: § 4, UX-F5; PRD source: Key Use Cases 2, UX Notes "What must feel effortless" — trust)*
- **RN-3:** *(added)* Empty-repository, clean-tree, and unreadable-entry states — *because* the
  surface can land in each and the PRD never names them; an unhandled state is a defect of this
  document. Each is designed to the view-never-lies rule: absence is stated, never shown as a
  blank pane. *(re: UX-S2, UX-S3; PRD source: UX Notes "the view never lies", implied)*
- **RN-4:** *(added)* Updates arrive without ceremony (UX-I2), and a failing item degrades only
  itself (UX-I10) — *because* the character is "still" and the driving scenario is a
  continuously changing tree: an attention bid per change would make the watching flow unusable,
  and a shell that blocks on one unreadable item cannot watch a moving tree at all. Both
  elaborate stated PRD intent; neither invents product intent. *(re: UX-I2, UX-I10; PRD source:
  UX Notes "The character", Key Use Cases 3)*
- **RN-5:** *(added)* The initial theme follows the platform's own signal, and a signal-less hard
  default would be light — *because* the adopter's environment outranks the product's aesthetic:
  which polarity reads better depends on the room the user is in, and the operating system
  already carries their answer; where no signal exists, dark-text-on-light is the
  better-evidenced legibility default and the reason is recorded rather than left to look like
  taste. Dark stays a first-class, equally maintained theme — a preference honored, never an
  ergonomic claim. *(re: UX-I9, § 9; PRD source: UX Notes "dark and light themes from the
  start", Data & Privacy)*
- **RN-6:** *(changed this revision — placement stands; the history shape moved to RN-14)* The
  beyond-v1 **diff** surfaces carry the owner's settled shape — staged distinguished from
  unstaged, per-commit diff reusing the same presentation, decided at
  `docs/srs_trail/cycle-1.md` §2.2 — and this document's placement decisions stand: the diff in
  the reading panel (a diff is content to read), history reached from the Git side (it is Git
  state), both in the same single window, *because* the shell's IA has exactly those two homes
  and a second window would break the one-shell arrival model. The **history shape** that §2.2
  also settled — a flat read-only list — was **reopened by the owner's own revision**
  (`docs/uxd_trail/cycle-1.md` §2.1 → `docs/ux_reference/README.md` § Owner directives 1); its
  confirmed replacement is RN-14. History filtering and search stay out — that part of the §2.2
  decision is untouched (§ 10). *(re: UX-F4, UX-S5, UX-S6, § 4; PRD source: Scope (In) full
  ambition)*
- **RN-7:** *(added)* Public visual surfaces must match the running product (UX-I11) — *because*
  the PRD makes the README's first screen product surface, and for a public tool the visual
  story is part of the claim being checked there: a stale screenshot fails an adopter the same
  way a stale install command does. This constrains truthfulness only; what the README says is
  the CPO's. *(re: UX-I11; PRD source: Goals "Pick-it-up adoption")*
- **RN-8:** *(confirmed choice)* The design direction — a restrained code-workbench built from
  primitives, no established component design system — confirmed as drafted by the owner
  (`docs/uxd_trail/cycle-1.md` §2.1). The confirmation came with a layout reference (RN-13),
  supplied as layout evidence, not a style target: VS Code's visual language is not adopted.
  *(re: § 1, § 9; PRD source: UX Notes "The character", Assumptions)*
- **RN-9:** *(added)* No meaning by hue alone (UX-A2) — *because* the tree's changed markers and
  the staged/unstaged distinction are exactly the kind of state distinction that collapses for
  the most common color-vision deficiencies, and redundant encoding is a component contract —
  deferring it means rebuilding, not adding. Stated inside the settled v1 posture: it promises
  nothing to assistive technology (UX-A1 stands untouched); it makes the product's own markers
  legible to everyone. *(re: UX-A2; PRD source: Core Features "changed-file markers", within UX
  Notes "The bounds v1 draws")*
- **RN-10:** *(confirmed choice — with a placement bound)* Stating the accessibility posture in
  the README (UX-A3) confirmed by the owner, bounded: on the README but **not its first
  screen** — one plain sentence further down, so the adopter still reads it before adopting
  while the first screen keeps to the four things the PRD fixes for it (`PRD.md` § Goals
  "Pick-it-up adoption"). *(re: UX-A3; owner answer: `docs/uxd_trail/cycle-1.md` §2.2; PRD
  source: UX Notes "The bounds v1 draws"; Goals "Pick-it-up adoption")*
- **RN-11:** *(added)* Syntax highlighting and monospace are recorded as expectations, not
  benefits — *because* their comprehension value is unproven while their absence reads as
  unfinished, and in this domain looking unfinished loses the stranger in the first minute. The
  same rule answers the next expected-but-unproven convention. *(re: § 9; PRD source: Core
  Features "syntax highlighting")*
- **RN-12:** *(accounting — no experience surface)* The PRD's licence, versioning, regulatory
  posture, and maintenance-sustainability items produce no UXD entry: they are product- and
  release-level statements with no surface in the running experience. The pre-1.0.0
  anything-may-change statement lives where releases are offered (the SRS's C-6 territory), not
  in the shell. Read-only *enforcement* is likewise the SRS's; this document carries its
  experience half (UX-I1, UX-I4, UX-I7). *(re: reverse walk; PRD source: Assumptions, Success
  Metrics)*
- **RN-13:** *(added — owner answer)* The layout reference `docs/ux_reference/` — VS Code
  screenshots from the owner's own workbench with a README annotating every element as taken or
  excluded; an element not listed there was not considered. Its authority is **layout, not
  style** (the direction stays primitives, RN-8), and this document points at it rather than
  restating it — a copied annotation would drift from the one the owner maintains. *(re: § 4,
  § 9; owner answer: `docs/uxd_trail/cycle-1.md` §2.1)*
- **RN-14:** *(confirmed choice — with the owner's set-scoping refinement)* The history view
  shows branch topology — the owner directed it (`docs/uxd_trail/cycle-1.md` §2.1 →
  `docs/ux_reference/README.md` § Owner directives 1) and confirmed the drafted statement
  (`docs/uxd_trail/cycle-2.md` §2.1): a reader with more than one branch sees which commits
  belong to which and where they diverge and merge, never a flat list. The refinement the
  confirmation carried: the scoping is a chosen **set** of branches — one, several, or all of
  them — with a default that asks nothing (the current branch and what relates to it), so the
  reader chooses what the graph draws and does not have to
  (`docs/ux_reference/vscode-branch-filter.png`, annotated in `docs/ux_reference/README.md`).
  The reference's modal checklist is one control among several that would serve — the owner
  bound the properties, not the mechanism — and the set-scoping choice belongs to the history
  view itself (owner: `docs/uxd_trail/cycle-2.md` §2.2). The statement's basis is what the
  directive asked to be examined: VS Code's own documentation describes its source-control graph
  as "a graphical representation of your commit history and branch relationships"
  (https://code.visualstudio.com/docs/sourcecontrol/overview), and the supplied screenshots show
  that graph drawn against a chosen ref set, with each commit's changed files beneath it.
  Feasibility is downstream (SRS/SDD) and does not narrow the statement. Consequence handed
  forward, accepted by the owner with the confirmation: the SRS's FR-18 still describes the
  history as a flat read-only list (`SRS.md` FR-18) and needs a CTO revision — recorded here,
  not absorbed. *(re: UX-F4, UX-S6, RN-6; PRD source: Scope (In) full ambition "commit
  history")*
- **RN-15:** *(added — owner directive; placement owner-confirmed)* The repository switch is a
  **dropdown selector** showing the current repository's name — the name is both label and
  control — listing the repositories Nozoki remembers plus a browse entry, empty of all but
  browse on first run. The control is the owner's own naming (`docs/uxd_trail/cycle-1.md` §2.1 →
  `docs/ux_reference/README.md` § Owner directives 2); remembering repositories is already
  permitted (PRD § Data & Privacy — tool state outside the viewed repository), so nothing here
  needs the CPO. Where it lives is settled (`docs/uxd_trail/cycle-2.md` §2.2): the **shell
  chrome** — the identity element (RN-2) is the control — *because* what names the repository is
  what changes it (one element telling one truth, per the owner's own framing), and the chrome
  is reachable from either sidebar mode while the Git view header is not. The alternative the
  reference shows — the selector grouped with repository-scoped state in the Git view header —
  was weighed by the owner and declined: what it buys is grouping, what it costs is
  reachability. One fence the owner drew with the answer: where a **branch** control lives is a
  separate question, not settled by this placement — the history view's set-scoping choice is
  RN-14's and lives with that view. *(re: UX-F5, UX-S7, § 4; PRD source: Scope (In) / Out of
  Scope, repository switching; Data & Privacy)*
- **RN-16:** *(confirmed choice)* The Files/Git switch is a pair of labelled tabs at the top of
  the sidebar — *because* § 4's navigation rule is text-first with icons secondary and the
  product has exactly two destinations: an icon rail (the reference's own mechanism,
  `docs/ux_reference/README.md` § "One question") is built for many destinations and identifies
  them by icon alone. Confirmed by the owner (`docs/uxd_trail/cycle-2.md` §2.3): the Agari
  admits no third view, so the argument for a rail — that it scales to many — is an argument
  about a product this one is not going to become; no exception to § 4's text-first rule is
  taken. *(re: § 4; PRD source: UX Notes "The character" — text-first; Core Features — the
  sidebar toggle)*

---

## Open Questions

None — nothing awaits the owner. Every answered round is retired whole to `docs/uxd_trail/`,
where each decision and its reasoning stay citable.
