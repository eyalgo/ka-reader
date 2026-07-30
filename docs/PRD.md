# PRD — Nozoki 覗き

**Status:** Settled
**Owner:** CPO
**Version:** 2 — live refresh enters v1 (the view follows a changing tree, with a bar to match); the read-only promise is stated in full, with the boundary for the tool's own state drawn; the acquisition mechanism is dropped in favour of the single-simple-path product property; switching the viewed repository is named a future direction

> The PRD is the product source of truth: the product-facing **what and why**, read cold by the
> CTO, Principal PM, and Principal Architect. It is updated in place with versioning (bump the
> line above on each material change). The **how** — architecture, system requirements, delivery
> sequencing — belongs to the roles downstream.

---

## Purpose

Nozoki (覗き — *"to peek / peer in"*) is a lightweight code workspace viewer: a stripped-down,
VS Code-like shell for browsing a project's files and inspecting its Git status, in which nothing
can be changed. It is optimized for inspection rather than authoring — look, don't touch. It
exists because inspecting a working tree today is done with tools built for *authoring*, whose
safety against accidental change is discipline, not guarantee.

## Problem Statement

A developer who wants to look at a local repository — browse the tree, read files, see what has
changed — reaches today for tools that can also modify it. A full editor makes not-touching a
matter of care; terminal commands (`git status`, pagers) are safe but give up the tree, the
highlighting, and the editor shell; a hosting site's web UI shows only pushed state, when the
local working tree is exactly what inspection is usually about. The pain is sharpest in states
that must not be perturbed: mid-review of uncommitted work, and a working tree that an automated
tool or agent is in the middle of changing *(this scenario: added — not in the input beyond its
"agent workflows" future note; owner-confirmed: prd_trail/cycle-1.md)*.

## Why This

The nearest alternative is opening the repository in VS Code and being careful. VS Code can mark
paths read-only, but that is opt-in per-path configuration, not a whole-repository guarantee
*(verified (external): https://code.visualstudio.com/updates/v1_79 — covers: the read-only
settings and their per-path scope)*, and its Restricted Mode limits code execution while still
permitting editing *(verified (external):
https://code.visualstudio.com/docs/editing/workspaces/workspace-trust — the FAQ states text
editing is always supported)*. Nozoki's edge is that the guarantee **is** the product: there is
no write path to configure away. Beside that, it is lighter than an editor — nothing to
configure, nothing installed into the repository.

Stated honestly: for a developer content to rely on their own care, the full editor they already
have is good enough. The edge exists only where the no-write guarantee matters — trees that must
not be perturbed, or wanting the certainty itself. And the bet that a familiar editor-like shell
is what makes inspection comfortable is unproven; it is the product's central UX assumption (see
Assumptions).

## Target Users

*(added — the input names no user; owner-confirmed: prd_trail/cycle-1.md)*

- Developers inspecting a local repository they do not want to risk touching: reading unfamiliar
  code, checking the state of uncommitted work, verifying what changed.
- Developers peeking at a working tree that an automated tool or coding agent is actively
  changing — watching progress without perturbing it. This is the driving scenario.

## Goals

- **Inspection without risk** — a user can browse and read anything in the repository with the
  certainty that nothing about it changes.
- **Pick-it-up adoption** — a stranger goes from finding the tool to viewing a file of their own
  repository in minutes, guided by the README alone. The README's first screen is product
  surface: what the tool does in one sentence, one install path, one copy-paste example, and
  what the tool will and will not touch *(added — instance doctrine, not in the input)*.
- **Zero-config familiarity** — anyone who has used VS Code needs no learning; launching
  requires naming a repository and nothing else.

No revenue applies: Nozoki is free, non-commercial open source by design; its cost side is
maintainer time, held down by the deliberately small surface (see Assumptions).

## Success Metrics

- **Read-only integrity:** violations of the product's promises, under any operation — stated
  separately, none implied by another: no write to the working tree; no Git mutation (no
  checkout, stash, index, or commit operation); no telemetry; no non-essential network call.
  Nothing the product does writes into the repository it is pointed at — its own kept state
  lives elsewhere on the machine (see Data & Privacy). Bar: zero, absolutely; a single
  violation is a release-blocking defect. Reckoned at every release. *(whole-product scope:
  changed from the input, which scoped "read-only" to the editor area; owner-confirmed:
  prd_trail/cycle-1.md)*
- **Time-to-first-success:** from a stranger deciding to try Nozoki — by its single install
  path, whatever that path is — to viewing a file of their own repository. Bar: ≤ 5 minutes,
  checked before each release. *(bar value: added — not in the input; owner-confirmed:
  prd_trail/cycle-1.md)*
- **Zero required configuration:** launching against a repository requires the repository's
  location and nothing else. Bar: pass/fail, checked at each release.
- **Refresh immediacy:** a change on disk — file content, the tree, or Git state — appears in
  the view within a few seconds, with no user action. Bar: exact latency threshold TBD, tracked
  from the first working build. *(added — not in the input; owner-confirmed:
  prd_trail/cycle-1.md)*
- **File-switch immediacy:** selecting a file displays its content with no perceived wait. Bar:
  threshold TBD, tracked from the first working build.

## Key Use Cases

1. A developer opens Nozoki against a local repository and browses the file tree, reading files
   with syntax highlighting exactly as they would in an editor — minus the ability to change
   anything.
2. Mid-work, a developer switches the sidebar to the Git view — branch, changed files, staged
   files at a glance — opens the changed files to read them, and closes certain the tree is
   exactly as they found it.
3. A developer peeks at a repository an automated tool or agent is working on, watching its
   progress as the view follows the changing tree — without perturbing it *(added — not in the
   input; owner-confirmed: prd_trail/cycle-1.md, with Target Users)*.

## Core Features

- Read-only viewing of any file in the repository, with syntax highlighting.
- A file tree with changed-file markers and selected-file highlight.
- A sidebar that toggles between **Files** and **Git**.
- A Git view: changed files, staged files, branch name, short repository status.
- **Live refresh:** a change on disk — file content, the tree, or Git state — appears in the
  view automatically, with no user action *(added — not in the input; owner-confirmed:
  prd_trail/cycle-1.md)*.
- Fast file switching inside a familiar workbench-style shell.
- An empty state that prompts file selection when nothing is open.

## UX Notes

- The editor panel is the dominant visual surface; navigation is text-first, icons secondary.
- Dark and light themes from the start.
- Instantly familiar to anyone who has used VS Code; no onboarding, no configuration surface.
- The view follows the tree — there is no refresh control, because the driving scenario is
  watching progress, and a manual refresh turns the user into a poller *(added — not in the
  input; owner-confirmed: prd_trail/cycle-1.md)*.
- Empty state: a simple prompt such as "Select a file to view."
- v1 is mouse-driven — keyboard navigation is deferred (see Out of Scope), so v1 makes no
  keyboard-accessibility promise.
- UI language: English *(added — defaulted, not routed: the instance's products and their
  documentation are English-first)*.

## Scope (In)

v1 is the smallest version that proves the thesis: everything under Core Features, operating
against a **single local Git repository** on the user's own machine — one repository at a time
is a v1 cut, not a permanent property *(owner-confirmed: prd_trail/cycle-1.md)*.

**Run posture** *(added — the input never states how the tool runs against a repository;
owner-confirmed: prd_trail/cycle-1.md)*: Nozoki is a local tool — the user launches it on their
own machine against one local repository at a time; nothing about its operation leaves the
machine; there is no hosted mode. There is **exactly one way to get and start Nozoki, and it is
simple** — one path, not a menu of them: a stranger should not have to choose how to install a
viewer. The mechanism of that path is not stated here (see Out of Scope); that it must be single
and simple is the product's, and the time-to-first-success bar measures it.

The full ambition, so the cut reads as deliberate: a complete read-only inspection surface —
diffs, commit history, search, keyboard-driven navigation, switching which repository is viewed
without restarting (always one at a time) — and, further out, a front end for watching agent
workflows and repository-inspection services (the input's own growth direction). v1 cuts to
browsing, reading, status, and live refresh.

## Out of Scope

- **Editing, permanently** — not a v1 cut: the product has no write path to the repository, in
  any version. Adding one would be a different product.
- **Git operations** — staging, committing, pushing, branch switching, discarding: viewer only.
- **Diff and commit-history views** — beyond v1 (the input's own roadmap defers them).
- **Sidebar search / filter** — beyond v1 (input roadmap).
- **Pane resizing and keyboard navigation** — beyond v1 (input roadmap).
- **Remote or hosted repositories, and any hosted operation of the tool itself** — the product
  runs locally against local state.
- **Changing the viewed repository without restarting** — beyond v1: a named future direction
  (see Scope), never a v1 capability *(owner-confirmed: prd_trail/cycle-1.md)*.
- **Several repositories at once** — one at a time is the product; what becomes revisitable
  later is *which* one, never *how many* *(owner-confirmed: prd_trail/cycle-1.md)*.
- **Telemetry and any non-essential network call** — see Data & Privacy.
- **The acquisition and start mechanism** — how Nozoki is obtained and launched is not stated
  here; the product property is only that there is exactly one such path and it is simple (see
  Scope) *(owner-confirmed: prd_trail/cycle-1.md)*.
- The input's implementation-stack recommendations (editor component, UI framework, styling
  approach) are not carried here: implementation choices, not product properties.
- The input's three-phase delivery sequencing is not carried here: delivery, not product. Its
  phase-3 items appear above as the v1 exclusions they define.

## Assumptions

- Users can acquire and launch a local developer-style tool; for the v1 audience (developers)
  this is taken as given.
- **The familiarity thesis:** a VS Code-like shell is what makes inspection comfortable — the
  product's central UX assumption, unproven. If false, the product needs rethinking, not tuning.
- Nozoki is free, non-commercial open source; no revenue exists or is intended. The cost is
  maintainer time; the deliberately small surface is the sustainability strategy, and a version
  that can no longer be maintained is archived visibly rather than left looking staffed
  *(added — instance doctrine, not in the input)*.
- **Licence:** MIT *(added — not in the input; owner-confirmed: prd_trail/cycle-1.md; recorded
  with its reason at first release)*.
- **Regulatory posture:** published as free, non-monetized open source outside any commercial
  activity, Nozoki is outside the EU Cyber Resilience Act's scope *(verified (external):
  https://digital-strategy.ec.europa.eu/en/policies/cra-open-source — non-monetised free
  open-source provision is not a commercial activity)*. The classification rests on the
  non-commercial character and falls with it.

## Dependencies / Integrations (Conceptual)

- The local filesystem — the repository's files and folders, read continuously enough that the
  view follows changes on disk.
- Git — the product reads repository state (branch, changed files, staged files); it performs no
  Git operation that alters that state.

## Data & Privacy

- Nozoki stores nothing about its users: no accounts, no identity, no behavioural data.
- No telemetry and no non-essential network calls — the tool's operation stays entirely on the
  user's machine *(added — instance doctrine default, not in the input)*.
- The product reads only the repository it is pointed at and persists nothing of it.
- Nozoki may keep its own state — preferences such as theme choice, window state, anything it
  remembers between sessions — and that lives where the tool keeps its own data on the machine,
  **never inside the repository it is pointed at**. It holds nothing personal. *(boundary:
  owner-confirmed: prd_trail/cycle-1.md)*

## Risks

- **The promise breaks incidentally.** Any write to the target repository, however small — a
  refreshed index, a lock file, a cache dropped into the tree — breaks the defining promise, and
  for a stranger once is permanently. Shows up as modified files or changed repository state in
  the target. Treated as release-blocking (see Success Metrics).
- **Familiarity backfires.** Looking like VS Code invites expecting VS Code — editing, search,
  extensions. Shows up as instant abandonment or standing pressure to widen scope. The response
  is scope discipline, not accommodation.
- **"Careful enough" wins.** If the no-write guarantee doesn't matter to enough developers, the
  full editor they already have is good enough and adoption stalls. This is the Why This edge
  failing, not a marketing problem.
- **Maintenance is a standing liability.** Publishing opens issues, questions, and security
  reports against finite maintainer time; the small surface and a stated support posture in the
  README are the mitigations *(added — instance doctrine)*.

## Open Questions

None.
