# PRD — Nozoki 覗き

**Status:** Settled
**Owner:** CPO
**Version:** 12 — nothing about the product changes: the 62 trail citations this document rests on (`prd_trail/`, `srs_trail/` — 58 and 2 in the body, 2 on this line) are repaired to `trail/prd/` and `trail/srs/`, because the answer-trails moved under `docs/trail/` at `nozoki@1e8bf3d` and the citing documents were not moved with them; commit-pinned citations were excluded, and this document carries none. Authorized by the owner's cycle-11 answer (`docs/trail/prd/cycle-11.md` § 2.1). (v11: the owner's cycle-10 answers folded — `docs/trail/prd/cycle-10.md` — a reader of folders, files and repositories; the Git view shows nothing in a plain folder.)

> The PRD is the product source of truth: the product-facing **what and why**, read cold
> by the CTO, the CDO, Principal PM, and Principal Architect. It is updated in place with
> versioning (bump the line above on each material change). Keep the **how** — architecture,
> system requirements, delivery sequencing — out; that belongs to the roles downstream.
> Omit a section only when it genuinely does not apply; do not pad one to fill it.
>
> **A decision the CPO introduced, or departed from the input on, wears its relation inline** —
> beside the decision itself, in whatever section it lives, so a cold reader can tell what came
> from the input and what the CPO put there without holding the two documents side by side. Which
> relations exist, which marker each takes, and when one is owed are the authoring prompt's
> (`<CORE>/prompts/cpo_create_prd.md` § *Every decision cites its relation to your input*); this
> template says only that the markers sit in the body, never in a section of their own. A
> **suggested removal** has nothing to mark here — the thing it concerns is not in the document —
> and lives only in the companion as a choice to confirm.

---

## Blurb

Nozoki is a read-only reader of folders, files and repositories: browse a folder's tree, read
its files with syntax highlighting, watch it as it changes, and — when it is a Git repository —
see what has changed, with the certainty that nothing in it can be changed from here. It is for
developers inspecting a working tree they must not disturb, above all one that a coding agent or
automated tool is actively changing.

## Purpose

Nozoki (覗き — *"to peek / peer in"*) is a lightweight code workspace viewer: a stripped-down
shell for browsing a folder's files — and, when that folder is a Git repository, inspecting its
Git status — in which nothing can be changed. It is **a reader of folders, files and
repositories** — the three named flat, none subordinate to another: a repository is one of the
things it reads, not the thing it is for, and a file is read in its own right rather than left
implicit inside "folder" *(the plain folder as a supported input: changed — the input admits only
a Git repository; owner-confirmed: trail/prd/cycle-9.md § 1.1. The sentence itself is the
owner's, overriding the CPO's drafted "folder viewer that lights up Git": trail/prd/cycle-10.md
§ 2.1)*. It is optimized for
inspection rather than authoring — look, don't touch. It exists because inspecting a working
tree today is done with tools built for *authoring*, whose safety against accidental change is
discipline, not guarantee. And it exists *now* because the state that most needs a guarantee
has become an everyday one: working trees that automated tools and coding agents are actively
changing — the product's driving scenario *(added — not in the input; the scenario itself
owner-confirmed: trail/prd/cycle-1.md)*.

## Problem Statement

A developer who wants to look at a local repository — browse the tree, read files, see what has
changed — reaches today for tools that can also modify it. A full editor makes not-touching a
matter of care; terminal commands (`git status`, pagers) are safe but give up the tree, the
highlighting, and the editor shell; a hosting site's web UI shows only pushed state, when the
local working tree is exactly what inspection is usually about. The pain is sharpest in states
that must not be perturbed: mid-review of uncommitted work, and a working tree that an automated
tool or agent is in the middle of changing *(this scenario: added — not in the input beyond its
"agent workflows" future note; owner-confirmed: trail/prd/cycle-1.md)*.

## Why This

The nearest alternative is opening the repository in a full code editor and being careful. An
editor's protections do not add up to the guarantee: VS Code's read-only settings are opt-in
per-path configuration, not a whole-repository guarantee *(verified (external):
https://code.visualstudio.com/updates/v1_79 — covers: the read-only settings and their per-path
scope)*, and its Restricted Mode limits code execution while still permitting editing *(verified
(external): https://code.visualstudio.com/docs/editing/workspaces/workspace-trust — the FAQ
states text editing is always supported)*. Nozoki's edge is that the guarantee **is** the
product: there is no write path to configure away. Beside that, it is lighter than an editor —
nothing to configure, nothing installed into the repository.

Stated honestly: for a developer content to rely on their own care, the full editor they already
have is good enough. The edge exists only where the no-write guarantee matters — trees that must
not be perturbed, or wanting the certainty itself. And the bet that a conventional editor-style
layout is what makes inspection comfortable is unproven; it is the product's central UX
assumption (see Assumptions).

## Target Users

*(added — the input names no user; owner-confirmed: trail/prd/cycle-1.md)*

- Developers inspecting a local repository they do not want to risk touching: reading unfamiliar
  code, checking the state of uncommitted work, verifying what changed.
- Developers peeking at a working tree that an automated tool or coding agent is actively
  changing — watching progress without perturbing it. This is the driving scenario.

## Goals

- **Inspection without risk** — a user can browse and read anything in the folder with the
  certainty that nothing about it changes.
- **Pick-it-up adoption** — a stranger goes from finding the tool to viewing a file of their own
  repository in minutes, guided by the README alone. The README's first screen is product
  surface: what the tool does in one sentence, one install path, one copy-paste example, and
  what the tool will and will not touch *(added — instance doctrine, not in the input)*.
- **No learning curve** — anyone who works with Git and can follow a README can use Nozoki: the
  reader is assumed to know Git, and the product may leave Git's own vocabulary unexplained. No
  editor experience required, no onboarding, and no configuration of any kind: no settings, no
  project file, no setup step. The only input it ever needs is which folder to view *(folder,
  not repository: owner-confirmed: trail/prd/cycle-9.md § 1.1; the assumed Git knowledge:
  changed — supersedes the "find their way around a repository on GitHub" floor owner-confirmed
  in trail/prd/cycle-2.md; owner-confirmed: trail/prd/cycle-8.md § 1.1. The no-configuration
  half is unchanged: owner-confirmed: trail/prd/cycle-2.md)*.

No revenue applies: Nozoki is free, non-commercial open source by design; its cost side is
maintainer time, held down by the deliberately small surface (see Assumptions).

## Success Metrics

- **Read-only integrity:** violations of the product's promises, under any operation — stated
  separately, none implied by another: no write to the viewed folder; no Git mutation (no
  checkout, stash, index, or commit operation); no telemetry; no non-essential network call.
  Nothing the product does writes into the folder it is pointed at — its own kept state
  lives elsewhere on the machine (see Data & Privacy). Bar: zero, absolutely; a single
  violation is a release-blocking defect. Reckoned at every release. *(whole-product scope:
  changed from the input, which scoped "read-only" to the editor area; owner-confirmed:
  trail/prd/cycle-1.md)*
- **Time-to-first-success:** from a stranger deciding to try Nozoki — by its single install
  path, whatever that path is — to viewing a file of their own repository. Bar: ≤ 5 minutes,
  checked before each release, on macOS — the one platform v1 promises (see Scope). The clock is
  read against a Git repository, the fuller path; a plain folder is the same path with less in
  it and is not measured separately *(added — not in the input; owner-confirmed:
  trail/prd/cycle-10.md § 2.3)*. This same
  clock is the no-learning-curve goal's observable: it runs through first use — finding,
  starting, and viewing — not install alone *(that link: added — not in the input)*. *(bar
  value: added — not in the input; owner-confirmed: trail/prd/cycle-1.md)*
- **Zero required configuration:** the only input Nozoki requires is which folder to view —
  no settings, no project file, no setup step; whether the folder is a Git repository is found,
  never asked. Bar: pass/fail, checked at each release. *(owner-confirmed: trail/prd/cycle-2.md;
  folder rather than repository: owner-confirmed: trail/prd/cycle-9.md § 1.1)*
- **Refresh immediacy:** a change on disk — file content, the tree, or Git state — appears in
  the view within a few seconds, with no user action. Bar: exact latency threshold TBD, tracked
  from the first working build. *(added — not in the input; owner-confirmed:
  trail/prd/cycle-1.md)*
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
   input; owner-confirmed: trail/prd/cycle-1.md, with Target Users)*.
4. A developer opens Nozoki against a folder that is not a Git repository — a download, an
   export, a project that has no Git yet — and browses and reads it exactly as in case 1. The
   Git view is there and shows nothing; the tree, the reading, and the live refresh work as they
   always do *(changed — the input makes a non-repository a failure; owner-confirmed:
   trail/prd/cycle-9.md § 1.1; the empty view: owner-confirmed: trail/prd/cycle-10.md § 2.2)*.

## Core Features

- Read-only viewing of any file in the repository, with syntax highlighting. Highlighting is
  promised for a stated floor of languages — Python, shell, JavaScript, JSON, YAML and TOML —
  and offered for no other in v1: a text file outside that floor is shown as plain text, never
  refused and never mis-highlighted. The floor grows when the maintainer needs a language, not
  on request *(floor and growth rule: added — not in the input; owner-confirmed:
  trail/prd/cycle-7.md)*.
- Markdown is rendered by default. A switch to the raw source is permitted, not promised: it is
  built if it costs nothing, and a release that ships rendered-only says so where the release is
  offered *(rendering: added — not in the input; owner-confirmed: trail/prd/cycle-7.md. The
  switch as a permission: changed — supersedes the "the toggle follows" promise owner-confirmed
  in trail/prd/cycle-7.md; first given at trail/srs/cycle-5.md § 2.3, and owner-confirmed as the
  PRD's own line: trail/prd/cycle-10.md § 2.5)*.
- A file tree with changed-file markers and selected-file highlight.
- A sidebar that toggles between **Files** and **Git**.
- A Git view: changed files, staged files, branch name, short repository status — when the
  folder is a Git repository. When it is not, the Git view is present and **shows nothing** — no
  message, no explanation, no offer of a next step; the changed-file markers in the tree are
  absent (see UX Notes) *(changed — the input admits only a repository; owner-confirmed:
  trail/prd/cycle-9.md § 1.1. The empty view is the owner's, overriding the CPO's drafted
  "present, disabled, and says why": trail/prd/cycle-10.md § 2.2)*.
- Git is read only when the folder opened is itself the root of a Git repository. A folder
  inside a repository, and a folder that contains repositories, both open as plain folders: what
  the tree shows and what the Git view reports are always the same folder *(added — no input
  states it; owner-confirmed: trail/prd/cycle-10.md § 2.4)*.
- **Live refresh:** a change on disk — file content, the tree, or Git state — appears in the
  view automatically, with no user action *(added — not in the input; owner-confirmed:
  trail/prd/cycle-1.md)*.
- Fast file switching inside a familiar workbench-style shell.
- An empty state that prompts file selection when nothing is open.

## UX Notes

*(Product-level only: no visual design, no mechanism.)*

**The character.** Nozoki looks at a repository; it never acts on one — and the experience
should feel like that: calm, truthful, still. The product presents state; the person moves
their attention around it. Read-only is the product's identity, not a mode: nothing in the
experience suggests the repository could be changed from here — no editing affordances
present-but-disabled, no framing that implies an editable mode exists somewhere else. The
editor panel is the dominant visual surface; navigation is text-first, icons secondary; dark
and light themes from the start.

**The path, end to end.** The experience begins with Nozoki open against one local folder —
whatever precedes that moment belongs to the acquisition-and-start mechanism, which this PRD
deliberately does not state (see Out of Scope). Whether the folder is a Git repository is
Nozoki's to find out, never the person's to declare.

1. **Arrival.** The workbench opens with the file tree visible and nothing open — the empty
   state, a simple prompt such as "Select a file to view." Nothing to set up, sign into, or
   dismiss: instantly usable without instruction — the layout explains itself; no onboarding,
   no configuration surface *(owner-confirmed: trail/prd/cycle-2.md)*.
2. **Reading.** Selecting a file shows it with syntax highlighting within the promised floor,
   as plain text outside it, and rendered when it is Markdown (see Core Features) — always with
   no perceived wait (see Success Metrics). The person moves file to file as fast as they can
   decide what to read next.
3. **Checking.** The sidebar toggles between Files and Git — branch, changed files, staged
   files at a glance, with changed-file markers in the tree. Sidebar mode and the open file
   are independent: checking Git never closes what the person is reading. In a folder that is
   not a Git repository the Git view is still there, and what it opens is empty — no message, no
   explanation, and nothing that invites the person to fix it: Nozoki does not create
   repositories, so a surface an editor would fill with "initialise" or "publish" offers have no
   truthful next step here and say nothing. A working state, not an error. An empty view cannot
   by itself tell "this folder has no repository" apart from "Nozoki failed to read it"; that is
   accepted — where a fault needs telling apart, it is the unexplained-fault state the experience
   defines downstream, never a message in this state. How the empty view is drawn is decided
   downstream of this document *(the plain folder: owner-confirmed: trail/prd/cycle-9.md § 1.1;
   the empty view and the accepted ambiguity: owner-confirmed: trail/prd/cycle-10.md § 2.2)*.
4. **Watching.** The view follows the tree as the repository changes — the driving scenario.
   Changes appear on their own, within the refresh bar; there is no refresh control, because
   a manual refresh turns the user into a poller *(owner-confirmed: trail/prd/cycle-1.md)*.
5. **Leaving.** Closing Nozoki asks nothing — nothing to save, nothing to confirm — and the
   person leaves certain the repository is exactly as they found it.

**The rule for every live state: the view never lies.** What is shown is the repository's
current state, or is explicitly marked as no longer there; the view never presents stale
content as current. And an update the person did not ask for never takes their place away —
the tree they expanded, the file they have open, the position they are reading stay theirs;
only what actually changed changes. Concretely:

- The open file changes on disk: its content updates in place, within the refresh bar.
- The open file disappears: the view says so plainly, rather than showing what is gone as if
  it were still there.
- The repository is mid-operation (a merge, a rebase, a detached state): an inspection
  subject, not an error — the Git view presents whatever state the repository is truly in.
  Those are exactly the trees that must not be perturbed.

**Failure states speak the user's language.** Error and edge states are pitched at the
no-learning-curve bar — someone who works with Git, not necessarily an expert in it *(the
floor: owner-confirmed: trail/prd/cycle-8.md § 1.1)*:

- Pointed at a path that does not exist, is not a folder, or cannot be read: a plain statement
  of what went wrong and what to do next — no dead end that presumes expertise. A folder without
  Git is not on this list: it opens (see "Checking", above) *(changed — the input's own frame
  makes a non-repository a failure; owner-confirmed: trail/prd/cycle-9.md § 1.1)*.
- A file that cannot be shown as text (binary and similar): openable like any file, landing
  in a stated cannot-display-as-text state — never a garbled render, never an error.
  Rendering non-text content richly is not part of v1's proof; the input's own scope is code
  viewing *(added — not in the input; owner-confirmed: trail/prd/cycle-7.md)*.

**What must feel effortless.**

- From arrival to reading a first file — minutes, README alone (the time-to-first-success
  bar).
- Switching files, and answering "what changed?" — a glance at the tree markers or the Git
  view, not an investigation.
- Trusting the tool: the person never wonders whether what they see is current, and never
  feels the need to check that the repository is untouched. Certainty is the product; the
  experience must never give a reason to doubt it.

**The bounds v1 draws.**

- Nozoki is mouse-driven — keyboard navigation is outside the product's done (see Out of
  Scope), so the absence of a keyboard-accessibility promise is permanent, not deferred *(the
  permanence: the project Agari's; owner-confirmed: trail/prd/cycle-8.md § 1.2)*.
- Beyond that line, v1 makes no assistive-technology promise: its accessibility surface is
  what the product already carries — two themes, text-first navigation — kept small with the
  rest of the surface *(added — not in the input; owner-confirmed: trail/prd/cycle-5.md)*.
- UI language: English *(added — not in the input; owner-confirmed: trail/prd/cycle-7.md)*.

## Scope (In)

v1 is the smallest version that proves the thesis: everything under Core Features, operating
against a **single local folder** on the user's own machine — a Git repository or not — one
folder at a time is a v1 cut, not a permanent property *(owner-confirmed: trail/prd/cycle-1.md;
the plain folder inside v1 rather than beyond it: changed — the input admits only a repository;
the directive is owner-confirmed at trail/prd/cycle-9.md § 1.1 and its placement in v1 at
trail/prd/cycle-10.md § 2.3)*.

**Run posture** *(added — the input never states how the tool runs against a repository;
owner-confirmed: trail/prd/cycle-1.md)*: Nozoki is a local tool — the user launches it on their
own machine against one local folder at a time; nothing about its operation leaves the
machine; there is no hosted mode. There is **exactly one way to get and start Nozoki, and it is
simple** — one path, not a menu of them: a stranger should not have to choose how to install a
viewer. The mechanism of that path is not stated here (see Out of Scope); that it must be single
and simple is the product's, and the time-to-first-success bar measures it.

**Platform** *(added — the input never states one; owner-confirmed: trail/prd/cycle-7.md)*: v1
runs on macOS, and promises nothing else. The promise is scoped to the maintenance it will get —
one platform is a narrower promise than three, and a truthful one.

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
- **Sidebar search / filter** — outside the product's done, not merely beyond v1: the project's
  Agari (`system/projects/nozoki/agari.md`) places it outside the terminus, and the README says
  so rather than promising it *(changed — the input's roadmap lists it as a later phase;
  owner-confirmed: trail/prd/cycle-8.md § 1.2)*.
- **Pane resizing and keyboard navigation** — outside the product's done, on the same footing as
  the line above; the keyboard absence is permanent (see UX Notes, "The bounds v1 draws")
  *(changed — the input's roadmap lists them as a later phase; owner-confirmed:
  trail/prd/cycle-8.md § 1.2)*.
- **Rich rendering of non-text content** — beyond v1: a file that cannot be shown as text lands
  in a stated cannot-display state (see UX Notes); the input's own scope is code viewing.
  Markdown is text and is rendered (see Core Features); this line is about images, documents
  and the like *(added — not in the input; owner-confirmed: trail/prd/cycle-7.md)*.
- **Linux and Windows** — beyond v1: v1 promises macOS only (see Scope). Stated as an
  exclusion rather than left unmentioned *(added — not in the input; owner-confirmed:
  trail/prd/cycle-7.md)*.
- **Remote or hosted repositories, and any hosted operation of the tool itself** — the product
  runs locally against local state.
- **Changing the viewed folder without restarting** — beyond v1: a named future direction
  (see Scope), never a v1 capability *(owner-confirmed: trail/prd/cycle-1.md; the word widened
  from repository to folder with the input: trail/prd/cycle-9.md § 1.1)*.
- **Several folders at once** — one at a time is the product; what becomes revisitable later is
  *which* one, never *how many* *(owner-confirmed: trail/prd/cycle-1.md; widened as above)*.
- **Git found anywhere but at the opened folder's root** — a folder inside a repository, or a
  folder holding repositories, opens as a plain folder in any version this document describes
  (see Core Features) *(added — no input states it; owner-confirmed: trail/prd/cycle-10.md
  § 2.4)*.
- **Creating or initialising a Git repository** — a plain folder is viewed as it is; the empty
  Git view offers no way to change that — no initialise, no publish *(added — not in the input;
  owner-confirmed: trail/prd/cycle-10.md § 2.2)*.
- **Telemetry and any non-essential network call** — see Data & Privacy.
- **The acquisition and start mechanism** — how Nozoki is obtained and launched is not stated
  here; the product property is only that there is exactly one such path and it is simple (see
  Scope) *(owner-confirmed: trail/prd/cycle-1.md)*.
- The input's implementation-stack recommendations (editor component, UI framework, styling
  approach, module structure) are not carried here: implementation choices, not product
  properties.
- The input's layout measurements and visual styling specifics (sidebar width, separators,
  button sizing, an optional header and status bar) are not carried here: visual design, which
  is decided downstream of this document. What the input says about the experience — the
  reading panel dominant, text-first navigation, two themes — is carried in UX Notes.
- The input's three-phase delivery sequencing is not carried here: delivery, not product. Its
  phase-3 items appear above — diffs and commit history as v1 exclusions, the other three as
  exclusions from the product's done.
- The README's one-line self-description does not call Nozoki a *web app*: nothing hosted is on
  offer (see Scope, "Run posture"), and the word tells a stranger the wrong thing about what they
  are getting. What the shipped shape technically is stays out of this document *(changed — the
  input's README says "web app"; owner-confirmed: trail/prd/cycle-8.md § 1.3)*.

## Assumptions

- Users can acquire and launch a local developer-style tool; for the v1 audience (developers)
  this is taken as given.
- **The familiarity thesis:** a conventional editor-style layout — a file tree beside a reading
  panel — is what makes inspection comfortable. The product's central UX assumption, unproven;
  if false, the product needs rethinking, not tuning. *(owner-confirmed: trail/prd/cycle-2.md)*
- Nozoki is free, non-commercial open source; no revenue exists or is intended. The cost is
  maintainer time; the deliberately small surface is the sustainability strategy, and a version
  that can no longer be maintained is archived visibly rather than left looking staffed
  *(added — instance doctrine, not in the input)*.
- **Licence:** MIT *(added — not in the input; owner-confirmed: trail/prd/cycle-1.md; recorded
  with its reason at first release)*.
- **Public identity:** Nozoki is published under the `kensaiapp` GitHub organisation
  (`github.com/kensaiapp/nozoki`) and maintained under that name; no personal handle is the
  public face. The maintainer behind it is a private individual, and Nozoki is a side project
  *(added — not in the input; owner-confirmed: trail/prd/cycle-7.md)*.
- **Support posture — nothing is promised.** Issues and questions are welcome and read when
  there is time, with no response time, no commitment to fix, and no commitment that a fix ever
  arrives. Security reports have a private channel and are read, with no acknowledgement or
  response time promised. The README says this plainly rather than implying more; and, as above,
  a version that can no longer be maintained is archived visibly *(added — not in the input;
  owner-confirmed: trail/prd/cycle-7.md)*.
- **Versioning:** releases are semantically versioned, and the version number is a compatibility
  promise to adopters. Before 1.0.0 anything may change, and that is stated plainly wherever a
  release is offered. Reaching 1.0.0 is a product event — the moment the promise starts — and
  after it a breaking change to what users rely on is priced, batched, and announced, never
  casual. *(added — not in the input; the 1.0.0-or-later closing condition is the project
  Agari's, owner-confirmed: trail/srs/cycle-1.md §2.4)*
- **Regulatory posture:** published as free, non-monetized open source outside any commercial
  activity, Nozoki is outside the EU Cyber Resilience Act's scope *(verified (external):
  https://digital-strategy.ec.europa.eu/en/policies/cra-open-source — non-monetised free
  open-source provision is not a commercial activity)*. The classification rests on the
  non-commercial character and falls with it.

## Dependencies / Integrations (Conceptual)

- The local filesystem — the viewed folder's files and folders, read continuously enough that
  the view follows changes on disk.
- Git — when the viewed folder is a repository, the product reads its state (branch, changed
  files, staged files); it performs no Git operation that alters that state, and it needs nothing
  from Git when the folder is not a repository.

## Data & Privacy

- Nozoki stores nothing about its users: no accounts, no identity, no behavioural data.
- No telemetry and no non-essential network calls — the tool's operation stays entirely on the
  user's machine *(added — instance doctrine default, not in the input)*. v1 makes no network
  call at all during operation; acquiring the tool uses the network, operating it does not. The
  word "non-essential" is kept deliberately: it leaves room for a possible future update or
  version check, which would enter this PRD as a stated feature before it exists — the headroom
  is what is being kept, not a current call *(the definition and the headroom: added — not in
  the input; owner-confirmed: trail/prd/cycle-7.md)*.
- The product reads only the folder it is pointed at and persists nothing of it.
- Nozoki may keep its own state — preferences such as theme choice, window state, anything it
  remembers between sessions — and that lives where the tool keeps its own data on the machine,
  **never inside the folder it is pointed at**. It holds nothing personal. *(boundary:
  owner-confirmed: trail/prd/cycle-1.md)*

## Risks

- **The promise breaks incidentally.** Any write to the target folder, however small — a
  refreshed index, a lock file, a cache dropped into the tree — breaks the defining promise, and
  for a stranger once is permanently. Shows up as modified files or changed repository state in
  the target. Treated as release-blocking (see Success Metrics).
- **Familiarity backfires.** Looking like an editor invites expecting an editor — editing,
  search, extensions. Shows up as instant abandonment or standing pressure to widen scope. The
  response is scope discipline, not accommodation.
- **"Careful enough" wins.** If the no-write guarantee doesn't matter to enough developers, the
  full editor they already have is good enough and adoption stalls. This is the Why This edge
  failing, not a marketing problem.
- **Maintenance is a standing liability.** Publishing opens issues, questions, and security
  reports against finite maintainer time; the small surface and the support posture stated in
  Assumptions — carried in the README — are the mitigations *(added — instance doctrine)*.

## Open Questions

None — every product-defining question raised to date is answered in the body, with its trail
record beside it.
