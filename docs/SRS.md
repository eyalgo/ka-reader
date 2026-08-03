# SRS — Nozoki 覗き

**Status:** Settled
**Owner:** CTO
**Version:** 4 — folded the owner's cycle-3 override (`docs/srs_trail/cycle-3.md`): FR-18's commit history revised from a flat read-only list to branch topology drawn against a chosen set of branches, the owner-confirmed experience shape (`UXD.md` UX-S6, RN-14); AC-12's history coverage widened, RN-13's history clause superseded, §2's filtering exclusion clarified (RN-19)

> The SRS is the technical source of truth: the system-level **what**, derived from the PRD and
> read cold by the Principal PM (Delivery Plan / FDR) and the Principal Architect (ADR / NFDR).
> It is updated in place with versioning (bump the line above on each material change); every
> delta in a revision traces to an owner answer/directive or a change in the upstream PRD, and
> the Version line names what changed and why.
> Every requirement traces back to a PRD feature or goal — no requirement without a source. The
> **how** — architecture, component design, delivery sequencing — belongs downstream (the SDD,
> the ADRs/NFDR, the Delivery Plan).

---

## 1. Purpose

Nozoki is a local, read-only viewer for one Git repository at a time: it must present the
repository's file tree, file contents with syntax highlighting, and Git status, keep that view
following the repository as it changes on disk, and do all of it while provably changing nothing
about the repository it is pointed at. This SRS states what the system must do and hold to realize
the PRD's intent — inspection without risk, picked up by a stranger from the README alone, with no
learning curve and no configuration.

## 2. Scope

**This SRS covers** the whole product the terminus requires — not v1 alone. The terminus it is
scoped against is the project's 上がり Agari (`system/projects/nozoki/agari.md`): the v1 cut the
PRD locks in (file tree, reading with highlighting, Git status, live refresh) **plus** the three
deferred features the Agari places inside done — diff view, commit history, and switching the
viewed repository without restarting (always one at a time). Requirements below that the PRD
places beyond v1 are marked *(beyond v1)*; they are product scope, and when they are delivered is
the Delivery Plan's, not this document's.

**Deliberately outside this SRS, with the terminus as the reason** — considered and bounded, not
forgotten:

- **Sidebar search / filter, pane resizing, keyboard navigation** — the PRD defers them beyond
  v1, and the Agari places them outside done; Nozoki is done without them. One accepted
  consequence, carried from the Agari: the product is mouse-driven and makes no
  keyboard-accessibility promise — with keyboard navigation outside the terminus, that absence is
  permanent, not deferred. History filtering and search stay outside done with them — adjacent to
  the sidebar search, and placed out by the owner when widening the history surface *(owner:
  `docs/srs_trail/cycle-1.md` §2.2)*. FR-18's branch-set scoping — choosing which branches the
  history is presented against — is not a filter or a search, and does not reopen this exclusion
  *(owner: `docs/srs_trail/cycle-3.md`)*.
- **A front end for agent workflows and repository-inspection services** — the PRD's further-out
  growth direction; the Agari names it as where a next product might go, not where this one
  docks. Consequently this system exposes no programmatic surface (§5.2).

**Excluded by the PRD itself, permanently** (restated because they are load-bearing): editing, in
any version — the product has no write path to the repository; Git operations (staging,
committing, pushing, branch switching, discarding); remote or hosted repositories and any hosted
operation of the tool; several repositories at once — one at a time is the product, and only
*which* one becomes revisitable (FR-19); telemetry and non-essential network calls.

## 3. Functional Requirements

### 3.1 Startup, shutdown & repository

- **FR-1:** The system operates against exactly one local Git repository per run, and the only
  input it ever requires is which repository to view — no settings, no project file, no setup
  step. *(traces to: PRD Goals "No learning curve", Success Metrics "Zero required
  configuration", Scope (In) run posture)*
- **FR-2:** In v1 the repository to view is supplied when the system starts; the system offers no
  in-product way to choose or change it. Changing the viewed repository from inside the product
  is FR-19, beyond v1. *(traces to: PRD Out of Scope "Changing the viewed repository without
  restarting"; see RN-1)*
- **FR-3:** Pointed at a path that is not a readable local Git repository — or one that does not
  exist or cannot be read — the system states plainly what went wrong and what to do next,
  pitched at the PRD's no-learning-curve bar (no dead end that presumes expertise), and touches
  nothing. *(traces to: PRD Scope (In) "single local Git repository", UX Notes "Failure states
  speak the user's language"; widened from "says so clearly" by the re-authored UX Notes: RN-17;
  see RN-10)*
- **FR-4:** When no file is open, the system presents an empty state that prompts file selection.
  *(traces to: PRD Core Features "empty state")*
- **FR-23:** Closing the system asks nothing — no save prompt, no confirmation, nothing to
  dismiss; there is never anything to save. *(traces to: PRD UX Notes "The path" step 5
  "Leaving")*

### 3.2 File tree

- **FR-5:** The system presents the repository's files and folders as a navigable tree.
  *(traces to: PRD Core Features "file tree")*
- **FR-6:** Files the repository's Git state reports as changed are marked as changed in the
  tree. *(traces to: PRD Core Features "changed-file markers")*
- **FR-7:** The currently selected file is visibly highlighted in the tree. *(traces to: PRD Core
  Features "selected-file highlight")*

### 3.3 Reading files

- **FR-8:** Selecting a file displays its content read-only, with syntax highlighting for
  recognized languages. *(traces to: PRD Core Features "read-only viewing … with syntax
  highlighting", Key Use Case 1)*
- **FR-9:** No interaction with the displayed content changes it or the underlying file — typing,
  pasting, and dropping into the reading panel produce no modification, on screen or on disk.
  *(traces to: PRD Out of Scope "Editing, permanently")*
- **FR-10:** A file that cannot be rendered as text (binary or undecodable content) is presented,
  not rendered: a clear placeholder states why the content is not shown, the shell remains fully
  usable, and the file is not modified. *(traces to: PRD UX Notes "Failure states" — a stated
  cannot-display-as-text state, never a garbled render, never an error; owner-confirmed:
  `docs/srs_trail/cycle-1.md` §2.3; see RN-14, RN-17)*
- **FR-24:** The system presents no editing affordance, enabled or disabled, and no framing that
  implies an editable mode exists elsewhere — nothing in the interface suggests the repository
  could be changed from it. *(traces to: PRD UX Notes "The character" — read-only is the
  product's identity, not a mode)*

### 3.4 Sidebar & Git view

- **FR-11:** A sidebar toggles between a **Files** view and a **Git** view. *(traces to: PRD Core
  Features "sidebar that toggles")*
- **FR-12:** The Git view presents the repository's changed files, staged files, branch name, and
  a short repository status. *(traces to: PRD Core Features "Git view", Key Use Case 2)*
- **FR-13:** A file listed in the Git view can be opened for reading exactly as a tree selection
  is. *(traces to: PRD Key Use Case 2 "opens the changed files to read them")*
- **FR-25:** Sidebar mode and the open file are independent: switching the sidebar between Files
  and Git never closes or changes the file being read. *(traces to: PRD UX Notes "The path"
  step 3 "Checking")*
- **FR-26:** A repository mid-operation — a merge, a rebase, a detached state — is presented by
  the Git view as the state the repository is truly in: an inspection subject, never an error.
  *(traces to: PRD UX Notes "the view never lies"; tolerance of the same states is FR-16's)*

### 3.5 Live refresh

- **FR-14:** A change on disk — file content, the tree, or Git state — appears in the view
  automatically, with no user action. *(traces to: PRD Core Features "Live refresh")*
- **FR-15:** The system has no manual refresh control. *(traces to: PRD UX Notes "there is no
  refresh control")*
- **FR-16:** The system tolerates a repository being changed by another process at any moment —
  files created, modified, or deleted, including while being read or displayed, and Git metadata
  in transient mid-operation states. None of it crashes the shell, blocks the view, or causes a
  write; the view converges to the state on disk. *(traces to: PRD Target Users driving
  scenario, Key Use Case 3; see RN-2)*
- **FR-27:** An automatic update never takes the user's place away: the tree state they expanded,
  the file they have open, and the position they are reading survive a refresh — only what
  actually changed changes. *(traces to: PRD UX Notes "the view never lies")*
- **FR-28:** When the open file disappears from disk, the view states plainly that it is gone —
  never presenting the vanished content as if it were still there. What is shown is the
  repository's current state within the refresh bar (NFR-2), or explicitly marked as no longer
  there; the view never presents stale content as current. *(traces to: PRD UX Notes "the view
  never lies"; crash-safety of the same event is FR-16's)*

### 3.6 Beyond v1, inside the terminus

- **FR-17:** *(beyond v1)* For any file the Git view reports as changed, the system presents its
  changes read-only, distinguishing staged changes from unstaged ones rather than collapsing both
  into a single working-vs-committed view. *(traces to: PRD Scope (In) full-ambition "diffs";
  widened by owner override: `docs/srs_trail/cycle-1.md` §2.2; see RN-13)*
- **FR-18:** *(beyond v1)* The system presents the repository's commit history read-only. When
  the history holds more than one branch, the user can see the branches as branches — which
  commits belong to which branch, and where they diverge and merge — never a flat list that
  flattens them together. The history is presented against a chosen **set** of branches — one,
  several, or all of them — with a default that asks nothing (the current branch and what relates
  to it), so the user chooses what is presented and does not have to. Per commit: its identifier,
  message, author, and date, with its changed files reachable from its entry. The properties are
  bound; how the history is drawn and what chooses the branch set stay downstream. *(traces to:
  PRD Scope (In) full-ambition "commit history"; shape: owner override
  `docs/srs_trail/cycle-3.md`, superseding the cycle-1 list (`docs/srs_trail/cycle-1.md` §2.2);
  experience authority: `UXD.md` UX-S6, RN-14; see RN-19)*
- **FR-19:** *(beyond v1)* The user can switch which repository is viewed without restarting the
  system — always exactly one at a time, never several at once. *(traces to: PRD Scope (In)
  "one repository at a time is a v1 cut", Out of Scope "Several repositories at once")*
- **FR-22:** *(beyond v1)* Selecting a commit in the history presents what that commit changed,
  read-only, in the same diff presentation FR-17 requires. *(traces to: PRD Scope (In)
  full-ambition "diffs, commit history"; added by owner override: `docs/srs_trail/cycle-1.md`
  §2.2; see RN-13)*

### 3.7 Appearance & own state

- **FR-20:** The system offers a dark and a light theme from the first release. *(traces to: PRD
  UX Notes "Dark and light themes from the start")*
- **FR-21:** The system's own remembered state — theme choice, window state, anything kept
  between sessions — persists in the tool's own data location on the machine, never inside the
  viewed repository. *(traces to: PRD Data & Privacy own-state boundary)*

## 4. Non-Functional Requirements

### 4.1 Performance

- **NFR-1:** Selecting a file displays its content with no perceived wait. The numeric threshold
  is deliberately unset: it is measured from the first working build and folded in here by
  revision. *(traces to: PRD Success Metrics "File-switch immediacy"; threshold process: RN-4)*
- **NFR-2:** A change on disk appears in the view within a few seconds, with no user action. The
  exact latency threshold is deliberately unset: measured from the first working build, folded in
  by revision. *(traces to: PRD Success Metrics "Refresh immediacy"; threshold process: RN-4)*

### 4.2 Availability & Reliability

- **NFR-3:** A failure to read any one file or any part of Git state degrades only that item's
  view, with a visible indication — never the shell as a whole — and recovers on a subsequent
  refresh once the item is readable again. *(traces to: PRD Key Use Case 3; see RN-11)*
- **NFR-4:** No failure mode of the system can lose or corrupt anything in the viewed
  repository: the read-only requirements (NFR-5 – NFR-8) hold during and after crashes and
  abnormal exits, not only in normal operation. *(traces to: PRD Success Metrics "Read-only
  integrity" — "under any operation")*

### 4.3 Security & Privacy

The PRD states the product's promises separately, none implied by another; so does this SRS:

- **NFR-5:** The system performs no write inside the viewed repository — no file or directory
  created, modified, or deleted anywhere under the repository's path, `.git` included, under any
  operation. *(traces to: PRD Success Metrics "no write to the working tree")*
- **NFR-6:** The system performs no Git mutation — no checkout, stash, index, or commit
  operation; the repository's full Git state (refs, HEAD, index, stash, objects) is identical
  before and after any session. *(traces to: PRD Success Metrics "no Git mutation")*
- **NFR-7:** The system collects and transmits nothing about its users or their usage — no
  telemetry, no accounts, no identity, no behavioural data. *(traces to: PRD Success Metrics "no
  telemetry", Data & Privacy)*
- **NFR-8:** The system makes no network call during operation — none, not merely no
  non-essential ones; its operation stays entirely on the user's machine. Acquisition of the
  tool is not operation. *(traces to: PRD Data & Privacy "the tool's operation stays entirely on
  the user's machine"; tightening recorded: RN-3)*
- **NFR-9:** The bar on NFR-5 – NFR-8 is zero violations, absolutely, reckoned at every release;
  a single violation is a release-blocking defect. *(traces to: PRD Success Metrics "Read-only
  integrity" bar)*

### 4.4 Scalability

- **NFR-10:** The performance bars (NFR-1, NFR-2) hold across realistic repository scale — the
  dimensions that matter are file count, tree depth, individual file size, and history length.
  Reference sizes are fixed alongside the first-build thresholds (same process as NFR-1/NFR-2)
  and recorded here by revision. *(traces to: PRD Success Metrics immediacy bars; threshold
  process: RN-4)*

### 4.5 Observability

- **NFR-11:** A failure the user must know about is visible in the UI itself; any diagnostic
  output the system produces lives with its own state (FR-21), never inside the viewed
  repository and never transmitted anywhere. *(traces to: PRD UX Notes "instantly usable without
  instruction", Data & Privacy; see RN-9)*

### 4.6 Maintainability

- **NFR-12:** The viewed repository is an input, not a structural singleton: moving from FR-2
  (supplied at start) to FR-19 (switch without restarting) must not require rewriting the viewing
  surface. *(owner instruction: RN-5)*

### 4.7 Usability & Adoption

*(category added beyond the standard six — the PRD's headline success metrics are usability bars;
see RN-8)*

- **NFR-13:** Time-to-first-success: from a stranger deciding to try Nozoki — by its single
  install path, whatever that path is — to viewing a file of their own repository, ≤ 5 minutes,
  checked before each release. *(traces to: PRD Success Metrics "Time-to-first-success")*
- **NFR-14:** Zero required configuration: the only input the system requires is which repository
  to view — no settings, no project file, no setup step required by any feature, v1 or later.
  Pass/fail, checked at each release. *(traces to: PRD Success Metrics "Zero required
  configuration")*
- **NFR-15:** Usable without instruction, at the PRD's bar: anyone who can find their way around
  a repository on GitHub and follow a README can use it — no editor experience, no onboarding.
  Verified by per-release first-use inspection, not machine check. *(traces to: PRD Goals "No
  learning curve", UX Notes)*

## 5. Interfaces

### 5.1 User Interface

- One shell: a sidebar toggling Files/Git (FR-11) beside a dominant read-only reading panel
  (FR-8), with an empty state when nothing is open (FR-4). Navigation is text-first, icons
  secondary; the layout explains itself — no onboarding surface, no configuration surface.
  *(traces to: PRD UX Notes)*
- Dark and light themes (FR-20). Mouse-driven; no keyboard-accessibility promise (§2, from the
  Agari — permanent). Beyond that line, v1 makes no assistive-technology promise: its
  accessibility surface is what the product already carries — the two themes, text-first
  navigation — a v1-scoped statement, not a permanent bound (RN-18). *(traces to: PRD UX Notes
  "The bounds v1 draws"; owner-confirmed: `docs/prd_trail/cycle-5.md`)*
- UI language: English (C-8).

### 5.2 API

- None — deliberately. The system exposes no programmatic surface; the agent-workflow /
  inspection-service front-end direction is outside the terminus (§2).

### 5.3 External Services

- None. The system depends on exactly two local sources, both read-only: the local filesystem
  (the repository's files and folders, read continuously enough for FR-14) and the repository's
  Git state (branch, changed files, staged files — read without any state-altering operation).
  *(traces to: PRD Dependencies / Integrations)* Whether Git state is read through an installed
  Git or a library is the SDD's call, bounded either way by NFR-5, NFR-6, and C-2.

## 6. Data Requirements

- **DR-1:** **The viewed repository** — identified by its path; the source of everything
  displayed; strictly a read-only input (NFR-5, NFR-6). Nothing of its content is persisted by
  the system. *(traces to: PRD Data & Privacy "persists nothing of it")*
- **DR-2:** **File tree model** — the repository's folders and files with changed markers, the
  current selection, and the user's expanded state (FR-27); derived from disk and Git state,
  held in memory, never persisted.
- **DR-3:** **File view** — the open file's path, content, detected language, and the reading
  position FR-27 preserves; derived and in-session, never persisted.
- **DR-4:** **Git state** — branch name, changed files, staged files, short status; derived from
  repository metadata by read-only means, never persisted.
- **DR-5:** **Own state** — preferences the system remembers between sessions (theme choice,
  window state, and the like), stored in the tool's own data location on the machine, never
  inside the viewed repository; contains nothing personal and no repository content. *(traces
  to: PRD Data & Privacy)*
- **DR-6:** **The input bar** — the system requires nothing of the repository beyond being a
  readable local Git repository (FR-3 is the failure behavior). Everything else it must
  tolerate, not require: content changing at any moment mid-read (FR-16), unreadable, binary, or
  arbitrarily large files (FR-10, NFR-3, NFR-10), and transiently inconsistent Git metadata
  (FR-16). The repository is live, untrusted input; requirements on the *system's behavior*
  carry the tolerance, and no requirement assumes a quiescent repository. *(traces to: PRD
  Target Users driving scenario)*

## 7. Constraints

- **C-1:** Local-only: the system runs on the user's machine against local state; no hosted mode,
  no remote repositories, nothing about its operation leaves the machine. *(traces to: PRD Scope
  (In) run posture, Out of Scope)*
- **C-2:** Viewer-only, permanently: no write path to the viewed repository exists in any
  version; adding one would be a different product. *(traces to: PRD Out of Scope "Editing,
  permanently")*
- **C-3:** Exactly one acquisition-and-start path, and it is simple: documented on the README's
  first screen, requiring no clone of the source repository and no build from source, presuming
  at most one widely-available prerequisite, which the README's first screen names; the ≤ 5-minute
  clock (NFR-13) includes installing that prerequisite when absent. The concrete channel is
  fixed in the SDD, where the runtime is chosen (RN-7). *(traces to: PRD Scope (In) single-path
  property, Goals "Pick-it-up adoption"; owner-confirmed: `docs/srs_trail/cycle-1.md` §2.1; see
  RN-12)*
- **C-4:** Licence: MIT at first release, recorded with its reason; the code is open source.
  *(traces to: PRD Assumptions "Licence: MIT")*
- **C-5:** Every release carries the licence notices of the third-party components it ships.
  *(owner decision: RN-6)*
- **C-6:** From the first 1.0.0 release, releases are semantically versioned and a breaking
  change to the product's public contract requires a major version; before 1.0.0, that anything
  may change is stated plainly rather than left implied. *(owner-confirmed:
  `docs/srs_trail/cycle-1.md` §2.4; see RN-15)*
- **C-7:** Before the first public release, a private vulnerability-reporting channel is enabled
  on the public repository, and a SECURITY.md names where to report and what response to expect,
  consistent with the README's stated support posture. *(traces to: PRD Risks "Maintenance is a
  standing liability"; owner-confirmed: `docs/srs_trail/cycle-1.md` §2.5; see RN-16)*
- **C-8:** UI language: English. *(traces to: PRD UX Notes)*
- **C-9:** The README's first screen is product surface and carries: what the tool does in one
  sentence, one install path, one copy-paste example, and what the tool will and will not touch.
  *(traces to: PRD Goals "Pick-it-up adoption")*
- **C-10:** Regulatory posture: the product stays free, non-monetized open source outside any
  commercial activity — the premise of its position outside the EU Cyber Resilience Act's scope.
  The classification rests on that character and falls with it; revisiting the character is the
  CPO's call, and would reopen the classification. *(traces to: PRD Assumptions "Regulatory
  posture")*

## 8. Acceptance Criteria

- **AC-1:** Exercising the full product surface against an instrumented repository leaves the
  filesystem under the repository's path byte-identical — file set, content, and Git internals
  (`.git` included). Run at every release. *(covers: NFR-5, NFR-9, C-2)*
- **AC-2:** After any session, the repository's full Git state — refs, HEAD, index, stash,
  objects — is identical to before it. Run at every release. *(covers: NFR-6)*
- **AC-3:** Network monitoring across a full session shows zero outbound traffic. Run at every
  release. *(covers: NFR-7, NFR-8)*
- **AC-4:** Typing, pasting, and dropping into the reading panel change nothing, on screen or on
  disk. *(covers: FR-9)*
- **AC-5:** A user can navigate the tree, open files from it, and read them with syntax
  highlighting; changed files are marked and the selection highlighted. *(covers: FR-5 – FR-8)*
- **AC-6:** Against a repository with staged and unstaged changes on a named branch, the Git view
  shows all four elements (changed files, staged files, branch, status) correctly, and its files
  open for reading. *(covers: FR-11 – FR-13)*
- **AC-7:** An external file create, modify, and delete, and an external Git staging operation,
  each appear in the view with no user action, within NFR-2's bar. *(covers: FR-14, NFR-2)*
- **AC-8:** Scripted rapid concurrent changes — create/modify/delete including deleting the file
  currently displayed, plus Git operations mid-flight — cause no crash, no write, and the view
  converges to the final on-disk state. *(covers: FR-16, NFR-3, NFR-4)*
- **AC-9:** On a machine that has never run the product, it starts with the repository location
  as its only input; no settings, project file, or setup step exists to need. Pass/fail at each
  release. *(covers: FR-1, NFR-14)*
- **AC-10:** A timed first-use check before each release: a user new to the tool, guided by the
  README alone, reaches a viewed file of their own repository in ≤ 5 minutes. Verification is a
  timed manual walk — deliberately not automated, because the thing measured is a stranger's
  path. *(covers: NFR-13, C-3, C-9)*
- **AC-11:** Both themes are present and usable from the first release. *(covers: FR-20)*
- **AC-12:** At the closing release, the diff view (staged distinguished from unstaged), the
  commit history — against a repository whose history holds more than one branch: the branches
  visible as branches, the presented branch set choosable, and the default asking nothing — with
  its per-commit diffs, and repository switching are present, read-only, and AC-1 – AC-3 still
  pass with them exercised. *(covers: FR-17 – FR-19, FR-22; history coverage widened with FR-18:
  RN-19)*
- **AC-13:** After a session in which preferences changed, new or changed files exist only in the
  tool's own data location — none under the repository path — and inspection finds nothing
  personal and no repository content in them. *(covers: FR-21, DR-5)*
- **AC-14:** Release inspection: the release carries the MIT licence and third-party notices; the
  README first screen carries its four items; the version number obeys C-6; SECURITY.md and the
  private reporting channel exist per C-7. *(covers: C-4 – C-7, C-9)*
- **AC-15:** With no file selected the empty state prompts selection; pointed at a path that is
  not a readable Git repository, the system states plainly what went wrong and what to do next,
  and a filesystem check shows it touched nothing. *(covers: FR-3, FR-4; widened with FR-3:
  RN-17)*
- **AC-16:** Inspection of the full UI surface finds no editing affordance, enabled or disabled,
  and no framing implying an editable mode. *(covers: FR-24)*
- **AC-17:** With a file open, toggling the sidebar between Files and Git leaves the open file —
  and the position being read — unchanged. *(covers: FR-25)*
- **AC-18:** Against a repository mid-merge and one in a detached-HEAD state, the Git view
  presents the actual state, no error state is shown, and files still open for reading.
  *(covers: FR-26, FR-12)*
- **AC-19:** An external change arriving while tree nodes are expanded and a file is open at a
  reading position leaves the expanded nodes, the open file, and the position intact; only what
  changed updates. *(covers: FR-27)*
- **AC-20:** Externally deleting the open file yields a plain in-view statement that it is gone;
  the vanished content is not presented as current. *(covers: FR-28; the same event's
  crash-safety: AC-8)*
- **AC-21:** Closing at any moment — a file open, a refresh mid-flight — presents no prompt and
  no confirmation. *(covers: FR-23)*

---

## SRS Review Notes

- **RN-1:** The repository is supplied at start in v1, with no in-product chooser (FR-2) —
  *because* an in-product way to choose a repository is exactly the "changing the viewed
  repository without restarting" capability the PRD places beyond v1, and the owner delegated
  the start mechanism to the CTO *(re: FR-2; PRD source: Out of Scope; owner delegation:
  `docs/prd_trail/cycle-2.md` §2.2)*.
- **RN-2:** Mid-change tolerance stated as a requirement (FR-16) — *because* the PRD's driving
  scenario is watching a tree an automated tool is actively changing, which the PRD implies but
  never states as a behavior: a viewer that crashes, blocks, or writes when the tree moves under
  it cannot serve the scenario the product is driven by *(re: FR-16, NFR-3, DR-6; PRD source:
  Target Users, Key Use Case 3)*.
- **RN-3:** Runtime network tightened from "no non-essential call" to "none" (NFR-8) — *because*
  the PRD's own Data & Privacy sentence — "the tool's operation stays entirely on the user's
  machine" — leaves no runtime call essential; acquisition uses the network but is not
  operation *(re: NFR-8; PRD source: Data & Privacy, Success Metrics)*.
- **RN-4:** The numeric thresholds for file-switch immediacy, refresh latency, and scalability
  reference sizes are deliberately unset — *because* the owner ruled that a threshold invented
  before there is a build to measure is noise; they are measured from the first working build
  and folded in here by revision *(re: NFR-1, NFR-2, NFR-10; owner decision:
  `docs/prd_trail/cycle-1.md` §2.4)*.
- **RN-5:** Repository selection must not be structurally singular (NFR-12) — *because* the
  owner recorded, for this SRS by name, that v1 must not design the single repository in so
  deeply that switching becomes a rewrite *(re: NFR-12, FR-19; owner instruction:
  `docs/prd_trail/cycle-1.md` §2.2)*.
- **RN-6:** Third-party licence notices ride every release (C-5) — *because* the owner recorded
  it as a release obligation routed to the SRS/SDD when confirming the MIT licence *(re: C-5;
  owner decision: `docs/prd_trail/cycle-1.md` §2.5)*.
- **RN-7:** The concrete acquisition channel is fixed in the SDD, not here — *because* the owner
  routed the mechanism to the CTO (`docs/prd_trail/cycle-1.md` §2.2), and at the SRS tier naming
  a channel would fix the runtime choice inside the *what*; this SRS binds the path by
  requirement instead (C-3, NFR-13, AC-10), and the one product-visible part of the call — that
  the path is not build-from-source and what it may presume installed — was drafted as a choice
  and confirmed by the owner (RN-12) *(re: C-3)*.
- **RN-8:** A seventh NFR category, Usability & Adoption, was added — *because* the PRD's
  headline success metrics (time-to-first-success, zero configuration, no learning curve) are
  usability bars with no home among the six standard categories *(re: NFR-13 – NFR-15)*.
- **RN-9:** Observability is deliberately minimal (NFR-11) — *because* the product is a local,
  single-user tool whose promises (NFR-5 – NFR-8) rule out transmitted diagnostics and any log
  written into the repository; anything heavier would push against the promises it exists to
  keep *(re: NFR-11; PRD source: Data & Privacy)*.
- **RN-10:** Behavior on an invalid repository path stated (FR-3) — *because* the PRD implies it
  (zero configuration, a layout that explains itself) but never states it; the minimal reading —
  say so clearly, touch nothing — is taken *(re: FR-3, AC-15; PRD source: Scope (In), UX
  Notes)*. The re-authored UX Notes later stated the behavior itself; FR-3's widening to match
  is RN-17's.
- **RN-11:** Transient read failures degrade one item's view, visibly, never the shell (NFR-3) —
  *because* the driving scenario guarantees transient unreadable states (a file mid-write, a Git
  lock), so failure containment is a reliability requirement, not an implementation nicety; the
  minimal presentation is specified *(re: NFR-3; PRD source: Key Use Case 3)*.
- **RN-12:** C-3's bounds confirmed as drafted — no build from source, at most one
  widely-available prerequisite named on the README's first screen, its installation counted
  inside the ≤ 5-minute bar; the concrete channel stays the SDD's. The owner kept the bound
  knowing the likely prerequisite is a runtime whose cold install can consume most of that bar —
  the pressure toward a self-contained artifact is intended, not accidental *(re: C-3, NFR-13,
  AC-10; owner confirmation: `docs/srs_trail/cycle-1.md` §2.1)*.
- **RN-13:** The diff and commit-history surface was widened by owner override — the diff
  distinguishes staged changes from unstaged ones (FR-17), selecting a commit presents what it
  changed (FR-22), and the history stayed a read-only list (FR-18) — a shape the owner has since
  revised to branch topology (RN-19); history filtering and search stay outside done, adjacent
  to the sidebar search the Agari excludes *(re: FR-17, FR-18, FR-22, AC-12, §2; owner override:
  `docs/srs_trail/cycle-1.md` §2.2)*. Propagating the override
  surfaced two pointers naming FR-18 as the repository-switch requirement — FR-2 and §2's
  one-at-a-time line — while that requirement is FR-19; both now point at FR-19. A reference
  correction forced by FR-18's changed content, not a re-derivation of either requirement.
- **RN-14:** FR-10's presentation of unrenderable files confirmed as drafted — a placeholder
  stating why the content is not rendered; no hex viewer, no image preview, nothing hidden from
  the tree *(re: FR-10, AC-5; owner confirmation: `docs/srs_trail/cycle-1.md` §2.3)*.
- **RN-15:** C-6 confirmed — recorded by the owner as a consequence of the Agari rather than a
  fresh call: done already requires a public MIT release at 1.0.0 or later with the
  semantic-versioning promise in force, so C-6 is that condition's realization here *(re: C-6,
  AC-14; owner confirmation: `docs/srs_trail/cycle-1.md` §2.4)*.
- **RN-16:** C-7 confirmed as drafted — private vulnerability reporting enabled and a
  SECURITY.md in place before the first public release *(re: C-7, AC-14; owner confirmation:
  `docs/srs_trail/cycle-1.md` §2.5)*.
- **RN-17:** This revision (v3) derives the PRD's v4 → v6 move — `## UX Notes` re-authored whole
  (`docs/prd_trail/cycle-4.md`) and v1's accessibility posture settled
  (`docs/prd_trail/cycle-5.md`) — authorized by the owner's cycle-2 answer
  (`docs/srs_trail/cycle-2.md`): derive from the PRD as it now reads; every delta below traces
  to that upstream change, the stability rule's own permitted branch. The re-authored section's
  requirement-bearing statements land as FR-23 (closing asks nothing), FR-24 (no editing
  affordance, enabled or disabled), FR-25 (sidebar/open-file independence), FR-26
  (mid-operation states presented, not errored), FR-27 (refresh preserves the user's place),
  and FR-28 (a vanished open file is stated, never shown as current), each with its new
  criterion (AC-16 – AC-21); FR-3 and AC-15 widen from "says so clearly" to the PRD's now-stated
  what-went-wrong-and-what-to-do-next; FR-10 gains the PRD trace it previously lacked — the
  section now states the cannot-display-as-text behavior the owner had confirmed at cycle-1, so
  the requirement is unchanged and its source strengthened; DR-2 and DR-3 name the expanded
  state and reading position FR-27 preserves; §3.1 is retitled to hold FR-23. The rest of the
  re-authored section produces **no requirement delta** — its character, effortlessness, and
  trust statements restate what the SRS already carries (FR-4, FR-14 – FR-16, FR-20, NFR-1,
  NFR-2, NFR-5 – NFR-9, NFR-13 – NFR-15, §5.1) — a stated no-delta outcome, per the owner's
  answer *(re: FR-3, FR-10, FR-23 – FR-28, DR-2, DR-3, AC-15 – AC-21; PRD source: UX Notes,
  v6)*.
- **RN-18:** The assistive-technology posture is stated in §5.1 as a v1-scoped statement,
  deliberately apart from §2's keyboard line — *because* the two differ in duration: the
  keyboard absence is permanent (the Agari holds keyboard navigation outside done), while the
  wider no-assistive-technology-promise is the PRD's statement about v1 only *(re: §5.1, §2;
  PRD source: UX Notes "The bounds v1 draws"; owner-confirmed: `docs/prd_trail/cycle-5.md`)*.
- **RN-19:** *(changed — this revision, v4)* FR-18's history shape revised from a flat read-only
  list to branch topology, by owner override (`docs/srs_trail/cycle-3.md`) — superseding the
  cycle-1 answer on the history's shape only; cycle-1's diff decisions (FR-17, FR-22) and its
  history-filtering/search exclusion stand untouched. The owner reopened the shape during the
  UXD's rounds and confirmed the experience statement there; the wording authority is `UXD.md`
  UX-S6 and RN-14 (owner-confirmed: `docs/uxd_trail/cycle-2.md` §2.1). The properties are
  bound — the branches visible as branches when more than one exists, a chosen set of branches
  with a default that asks nothing, per commit its identifier, message, author, and date with
  changed files reachable — and the mechanism is not: how the history is drawn and what chooses
  the set stay downstream (the choosing's placement is the UXD's; the rendering is the SDD's).
  FR-18 stays *(beyond v1)* and inside the terminus — commit history is named in the Agari's
  first condition. Propagation: AC-12's history coverage widened to exercise the shape, RN-13's
  history clause marked superseded, §2's filtering exclusion clarified (branch-set scoping is
  not a filter or a search). Topology's scale exposure rides the existing NFR-10 process —
  history length is already a named scale dimension there, its reference sizes fixed from the
  first working build (RN-4) — so no new performance item is raised. *(re: FR-18, AC-12, RN-13,
  §2; PRD source: Scope (In) full ambition "commit history")*

---

## Open Questions

None — the owner's cycle-1 answers (`docs/srs_trail/cycle-1.md`) settled every drafted choice,
the cycle-2 answer (`docs/srs_trail/cycle-2.md`) scoped the v3 revision to the moved PRD, and the
cycle-3 override (`docs/srs_trail/cycle-3.md`) revised FR-18's history shape at v4; the numeric
thresholds are settled-as-process (RN-4), awaiting a build, not an answer.
