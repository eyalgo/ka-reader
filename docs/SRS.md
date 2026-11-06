# SRS — KA-Reader

**Status:** Settled
**Owner:** CTO
**Version:** 14 — follows PRD v17 – v18, derived against PRD v18, on the owner's answer at `docs/trail/srs/cycle-12.md` § 2.1 (RN-39). FR-20 and AC-11 drop "from the first release": the choice between the two themes, kept between sessions, is in place before 1.0.0. FR-35 and AC-26 carry the beta's statement as a system state: where Git state is read at open and not followed, the Git view and the tree's markers say so. C-12 gains the public history checked for anything private; AC-14 inspects it and the README's known gaps. The finish line's path is repaired (RN-40). Nothing is left for the owner to answer; the companion is closed.
**Inputs read:** PRD Settled

> The SRS is the technical source of truth: the system-level **what**, derived from the PRD and
> read cold by the Principal PM (Delivery Plan / FDR) and the Principal Architect (ADR / NFDR).
> It is updated in place with versioning (bump the line above on each material change); every
> delta in a revision traces to an owner answer/directive or a change in the upstream PRD, and
> the Version line names what changed and why.
> Every requirement traces back to a PRD feature or goal — no requirement without a source. The
> **how** — architecture, component design, delivery sequencing — is kept out; it belongs
> downstream (the SDD, worked as one run by the CTO, the CPO and the CDO; the ADRs/NFDR the
> Principal Architect owns; the Delivery Plan). Every item carries a stable typed ID (`FR-n`,
> `NFR-n`, `DR-n`, `C-n`, `AC-n`) so downstream documents can reference it.

---

## 1. Purpose

KA-Reader is a local, read-only reader of folders, files and repositories, one folder at a time: it
must present the folder's file tree and file contents with syntax highlighting — and, where the
folder is itself the root of a Git repository, its Git status — keep that view following the
folder as it changes on disk, and do all of it while provably changing nothing about the folder
it is pointed at. This SRS states what the system must do and hold to realize the PRD's intent —
inspection without risk, picked up by a stranger from the README alone, with no learning curve
and no configuration.

## 2. Scope

**This SRS covers** the whole product the terminus requires — not v1 alone. The terminus it is
scoped against is the project's finish line (`system/projects/ka-reader/finish_line.md`): the v1 cut the
PRD locks in (file tree, reading with highlighting, Git status, live refresh) **plus** the three
deferred features the finish line places inside done — diff view, commit history, and switching the
viewed folder without restarting (always one at a time). Requirements below that the PRD places
beyond v1 are marked *(beyond v1)*; they are product scope, and when they are delivered is the
Delivery Plan's, not this document's.

**The first public release is a beta, below 1.0.0** *(traces to: PRD Scope (In) "The first public
release — a beta")*. Which requirements a release meets is delivery, not this document's, with
the fixed points the PRD itself sets: what binds the first public release (C-4, C-7, C-12) binds
the beta; the theme choice (FR-20) and the Git view following the disk (FR-14's Git half, FR-33's
live clause) are in place before 1.0.0; and where Git state is read at open and not followed, the
view says so (FR-35). See RN-39.

**The input is a local folder, a Git repository or not.** A folder that is not a Git repository —
a plain folder — is inside v1 and inside the terminus: it is an input the whole surface takes, not
a capability added to it. The diff view and the commit history are Git's and exist only where the
folder is a repository (FR-33); the switch takes any folder *(traces to: PRD Scope (In) "a Git
repository or not"; owner-confirmed `docs/trail/prd/cycle-9.md` § 1.1, `docs/trail/prd/cycle-10.md`
§ 2.3; the terminus widened to the same input: `system/projects/ka-reader/finish_line.md`; see RN-31)*.

**Deliberately outside this SRS, with the terminus as the reason** — considered and bounded, not
forgotten:

- **Sidebar search / filter, pane resizing, keyboard navigation** — the PRD defers them beyond
  v1, and the finish line places them outside done; KA-Reader is done without them. One accepted
  consequence, carried from the finish line: the product is mouse-driven and makes no
  keyboard-accessibility promise — with keyboard navigation outside the terminus, that absence is
  permanent, not deferred. History filtering and search stay outside done with them — adjacent to
  the sidebar search, and placed out by the owner when widening the history surface *(owner:
  `docs/trail/srs/cycle-1.md` §2.2)*. FR-18's branch-set scoping — choosing which branches the
  history is presented against — is not a filter or a search, and does not reopen this exclusion
  *(owner: `docs/trail/srs/cycle-3.md`)*.
- **A front end for agent workflows and repository-inspection services** — the PRD's further-out
  growth direction; the finish line names it as where a next product might go, not where this one
  docks. Consequently this system exposes no programmatic surface (§5.2).
- **Linux and Windows** — the PRD promises macOS only for v1 and states the other two as an
  exclusion (C-11). The finish line draws the dock as three named surfaces beyond v1 and no platform,
  so a second platform sits outside done — the owner's confirmed reading (RN-30).
- **The Markdown raw-source switch, and a link in a rendered Markdown file opening its target** —
  the owner placed the switch outside done (`docs/trail/srs/cycle-5.md` §2.3), and made the
  switch and a relative link opening its target each a permission conditioned on build cost,
  neither required for v1 (`docs/trail/srs/cycle-5.md` §2.2, §2.3). FR-31 and FR-32 carry them as
  permitted, not required, and no closing-release criterion exercises them (RN-28, RN-29).

**Excluded by the PRD itself, permanently** (restated because they are load-bearing): editing, in
any version — the product has no write path to the viewed folder; Git operations (staging,
committing, pushing, branch switching, discarding); Git found anywhere but at the opened folder's
root — a folder inside a repository, or a folder holding repositories, opens as a plain folder in
any version (FR-33); creating or initialising a Git repository — the empty Git view offers no way
to change what the system found (FR-34); remote or hosted repositories and any hosted operation of
the tool; several folders at once — one at a time is the product, and only *which* one becomes
revisitable (FR-19); telemetry and non-essential network calls.

## 3. Functional Requirements

### 3.1 Startup, shutdown & the viewed folder

- **FR-1:** The system operates against exactly one local folder per run — a Git repository or
  not — and the only input it ever requires is which folder to view: no settings, no project file,
  no setup step. Whether the folder is a Git repository is found by the system (FR-33), never
  declared by the user. *(traces to: PRD Goals "No learning curve", Success Metrics "Zero required
  configuration" — "whether the folder is a Git repository is found, never asked", Scope (In) run
  posture; widened at v8 from one Git repository: RN-31)*
- **FR-2:** In v1 the folder to view is supplied when the system starts; the system offers no
  in-product way to choose or change it. Changing the viewed folder from inside the product is
  FR-19, beyond v1. *(traces to: PRD Out of Scope "Changing the viewed folder without
  restarting"; see RN-1; the word widened at v8 with the PRD: RN-31)*
- **FR-3:** Pointed at a path that does not exist, is not a folder, or cannot be read, the system
  states plainly what went wrong and what to do next, pitched at the PRD's no-learning-curve bar
  (no dead end that presumes expertise), and touches nothing. A readable folder that is not a Git
  repository is not on this list: it opens (FR-34). *(traces to: PRD UX Notes "Failure states
  speak the user's language" — "A folder without Git is not on this list: it opens"; widened from
  "says so clearly" by the re-authored UX Notes: RN-17; narrowed at v8 from "not a readable local
  Git repository": RN-31; see RN-10)*
- **FR-33:** The system reads Git state only when the opened folder is itself the root of a Git
  repository: the folder is the top level of a Git working tree, not a folder beneath one. A
  folder inside a repository — one whose root is an ancestor of the opened folder — and a folder
  that contains repositories — rooted in its descendants — are each opened as a plain folder: the
  tree and the Git view always describe the same folder. A folder that is the top level of its own
  working tree, a linked worktree or a submodule's folder included, is a repository's root by this
  rule. A determination that turns on Git resolving a repository from any folder beneath its root
  is not this rule. Finding out is a read and creates nothing — no `.git`, no entry of any kind
  (NFR-5, NFR-6); how the determination is made is the SDD's, bounded here. The determination is
  live, as the view is (FR-14): a repository whose root is the opened folder appearing or
  disappearing during a session is a change in that folder's Git state, and the view follows it
  within NFR-2's bar. *(traces to: PRD Core Features "Git is read only when the folder opened is
  itself the root of a Git repository", Out of Scope "Git found anywhere but at the opened
  folder's root", UX Notes "The path" — "Whether the folder is a Git repository is KA-Reader's to
  find out"; owner-confirmed `docs/trail/prd/cycle-10.md` § 2.4; the determination stated as a
  requirement: RN-32; the live clause: RN-33)*
- **FR-34:** In a plain folder — a folder FR-33 does not find to be a repository's root — the
  system presents the tree, the reading panel, the empty state and the live refresh exactly as it
  does in a repository (FR-4 – FR-10, FR-14 – FR-16, FR-23 – FR-25, FR-27 – FR-32). The Git view
  is present and shows nothing: no message, no explanation, no offer of a next step — nothing
  that invites creating or initialising a repository; the tree carries no changed-file markers;
  and every Git-derived presentation (FR-6, FR-12, FR-13, FR-17, FR-18, FR-22, FR-26, FR-35)
  presents nothing. The system needs nothing from Git in this state. It is a working state, not a failure
  (FR-3). That an empty Git view cannot by itself tell a plain folder apart from a failure to read
  a repository is accepted: a fault the user must know about is NFR-3's and NFR-11's, never a
  message in this state. *(traces to: PRD Core Features "Git view … When it is not, the Git view
  is present and shows nothing", Key Use Case 4, UX Notes "The path" step 3 "Checking", Out of
  Scope "Creating or initialising a Git repository", Dependencies / Integrations "it needs
  nothing from Git when the folder is not a repository"; owner-confirmed
  `docs/trail/prd/cycle-9.md` § 1.1 and `docs/trail/prd/cycle-10.md` § 2.2; see RN-31)*
- **FR-4:** When no file is open, the system presents an empty state that prompts file selection.
  *(traces to: PRD Core Features "empty state")*
- **FR-23:** Closing the system asks nothing — no save prompt, no confirmation, nothing to
  dismiss; there is never anything to save. *(traces to: PRD UX Notes "The path" step 5
  "Leaving")*

### 3.2 File tree

- **FR-5:** The system presents the viewed folder's files and folders as a navigable tree.
  *(traces to: PRD Core Features "file tree"; the word widened at v8: RN-31)*
- **FR-6:** Where the folder is a repository (FR-33), files its Git state reports as changed are
  marked as changed in the tree; in a plain folder there are no markers (FR-34). *(traces to: PRD
  Core Features "changed-file markers", "the changed-file markers in the tree are absent")*
- **FR-7:** The currently selected file is visibly highlighted in the tree. *(traces to: PRD Core
  Features "selected-file highlight")*

### 3.3 Reading files

- **FR-8:** Selecting a file displays its content read-only. A file in one of the floor languages
  — Python, shell, JavaScript, JSON, YAML, TOML — is displayed with syntax highlighting for that
  language. The floor is the whole of the highlighting promise: no other language is promised in
  v1, and the floor grows only by a PRD revision, which this SRS then follows. *(traces to: PRD
  Core Features "read-only viewing … with syntax highlighting", the stated floor; Key Use Case 1;
  floor: owner-confirmed `docs/trail/prd/cycle-7.md` §2.5; revised at v5 from "recognized
  languages": RN-22)*
- **FR-29:** A text file the system does not recognize as one of the floor languages is displayed
  as plain text — never refused, and never displayed with another language's highlighting. The
  system recognizes a floor language by the file's extension alone, never by its content: each
  floor language is recognized by every extension in common use for it — JavaScript by `.js` and
  `.mjs` both, never one alone — with the full extension set fixed in the SDD; a file with no
  extension, or with an extension outside that set, is plain text. *(traces to: PRD Core
  Features "shown as plain text, never refused and never mis-highlighted"; recognition rule
  owner-confirmed: `docs/trail/srs/cycle-5.md` §2.1; see RN-22, RN-27)*
- **FR-30:** A Markdown file is displayed rendered by default. *(traces to: PRD Core Features
  "Markdown is rendered by default"; owner-confirmed `docs/trail/prd/cycle-7.md` §2.5; see RN-23)*
- **FR-31:** A rendered Markdown file may be switchable to its raw source and back, in the
  reading panel. The switch is permitted, not required, and it is outside the terminus: it is
  built only if it costs nothing — a build-cost judgment the SDD makes and records — and a
  release that ships rendered-only states so where the release is offered. *(traces to: PRD Core
  Features "A switch to the raw source is permitted, not promised: it is built if it costs
  nothing, and a release that ships rendered-only says so where the release is offered" — the
  PRD's own line since v11, owner-confirmed `docs/trail/prd/cycle-10.md` § 2.5, carrying the
  override first given at `docs/trail/srs/cycle-5.md` §2.3; see RN-23, RN-29, RN-35)*
- **FR-32:** Rendering a Markdown file fetches nothing from outside the viewed folder: a remote
  image or other remote resource the document references is not loaded. An external link the
  document contains is displayed and not followed — the system neither opens it nor hands it to
  another program. A relative link to a file inside the viewed folder is displayed and, by
  default, not followed; the system may instead open that file in the reading panel exactly as a
  tree selection does (FR-7, FR-13) — permitted, not required, outside the terminus, and built
  only if it costs nothing, a build-cost judgment the SDD makes and records. That an external
  link stays unfollowed is the owner's confirmed call (`docs/trail/srs/cycle-6.md` §2.1, RN-28).
  *(traces to: PRD Data & Privacy "v1 makes no network call at all during operation"; added
  consequence of NFR-8 for rendered content: RN-23; link behavior owner-answered:
  `docs/trail/srs/cycle-5.md` §2.2 and `docs/trail/srs/cycle-6.md` §2.1, see RN-28; the word
  widened at v8: RN-31)*
- **FR-9:** No interaction with the displayed content changes it or the underlying file — typing,
  pasting, and dropping into the reading panel produce no modification, on screen or on disk.
  *(traces to: PRD Out of Scope "Editing, permanently")*
- **FR-10:** A file that cannot be rendered as text (binary or undecodable content) is presented,
  not rendered: a placeholder states why the content is not shown, the shell remains fully
  usable, and the file is not modified. *(traces to: PRD UX Notes "Failure states" — a stated
  cannot-display-as-text state, never a garbled render, never an error; PRD Out of Scope "Rich
  rendering of non-text content"; owner-confirmed: `docs/trail/srs/cycle-1.md` §2.3; see RN-14,
  RN-17)*
- **FR-24:** The system presents no editing affordance, enabled or disabled, and no framing that
  implies an editable mode exists elsewhere — nothing in the interface suggests the viewed folder
  could be changed from it. *(traces to: PRD UX Notes "The character" — read-only is the
  product's identity, not a mode; the word widened at v8: RN-31)*

### 3.4 Sidebar & Git view

- **FR-11:** A sidebar toggles between a **Files** view and a **Git** view. *(traces to: PRD Core
  Features "sidebar that toggles")*
- **FR-12:** Where the folder is a repository (FR-33), the Git view presents the repository's
  changed files, staged files, branch name, and a short repository status; in a plain folder it
  shows nothing (FR-34). *(traces to: PRD Core Features "Git view", Key Use Case 2, Key Use Case
  4)*
- **FR-13:** *(changed)* What activating a changed file's row in the Git view opens is a system
  state, not a delivery moment. Where the diff (FR-17) is not present, activating the row opens
  the file for reading exactly as a tree selection does. Where the diff is present, activating the
  row opens that file's diff, and the file is read from the tree (FR-5, FR-7). The row never falls
  back: a diff that cannot be produced degrades that item's view under NFR-3, and the file stays
  readable from the tree. In a plain folder the Git view lists nothing (FR-34). *(traces to: PRD
  Key Use Case 2 "opens the changed files to read them" — the first reading; the second reading
  is the owner's call, confirmed at `docs/trail/srs/cycle-10.md` § 2.1, and departs from the
  settled reading of that sentence: RN-37)*
- **FR-25:** Sidebar mode and the open file are independent: switching the sidebar between Files
  and Git never closes or changes the file being read. *(traces to: PRD UX Notes "The path"
  step 3 "Checking")*
- **FR-26:** A repository mid-operation — a merge, a rebase, a detached state — is presented by
  the Git view as the state the repository is truly in: an inspection subject, never an error.
  *(traces to: PRD UX Notes "the view never lies"; tolerance of the same states is FR-16's)*

### 3.5 Live refresh

- **FR-14:** A change on disk — file content, the tree, or Git state — appears in the view
  automatically, with no user action. *(traces to: PRD Core Features "Live refresh")* Where its
  Git half is not in place, FR-35 says what the view shows instead; that half stays a v1
  requirement, in place before 1.0.0 *(traces to: PRD Scope (In) "The Git view following the
  disk stays part of what v1 means"; RN-39)*.
- **FR-15:** The system has no manual refresh control. *(traces to: PRD UX Notes "there is no
  refresh control")*
- **FR-16:** The system tolerates the viewed folder being changed by another process at any
  moment — files created, modified, or deleted, including while being read or displayed, and,
  where the folder is a repository (FR-33), Git metadata in transient mid-operation states. None
  of it crashes the shell, blocks the view, or causes a write; the view converges to the state on
  disk. *(traces to: PRD Target Users driving scenario, Key Use Case 3; see RN-2; the Git clause
  bounded at v8: RN-31)*
- **FR-27:** An automatic update never takes the user's place away: the tree state they expanded,
  the file they have open, and the position they are reading survive a refresh — only what
  actually changed changes. *(traces to: PRD UX Notes "the view never lies")*
- **FR-28:** When the open file disappears from disk, the view states plainly that it is gone —
  never presenting the vanished content as if it were still there. What is shown is the viewed
  folder's current state within the refresh bar (NFR-2), or explicitly marked as no longer
  there; the view never presents stale content as current. *(traces to: PRD UX Notes "the view
  never lies"; crash-safety of the same event is FR-16's; the word widened at v8: RN-31)*
- **FR-35:** Where the folder is a repository (FR-33) and its Git state is read once, when the
  folder is opened, and not followed, the Git view and the tree's changed-file markers say plainly
  that they show the Git state read when the folder was opened — never presenting that state as
  current. Where Git state is followed (FR-14), the statement does not appear, because it would
  no longer be true. In a plain folder it does not appear either: the Git view stays empty and
  the tree carries no markers (FR-34). One case is left uncovered on the surface: in the
  read-at-open state, a repository created at the opened folder's root after it was opened is not
  followed (FR-33's live clause), and the view goes on presenting a plain folder, with no
  statement; the README's known gaps are where the user is told (AC-14). FR-14's Git half,
  FR-33's live clause and AC-7's Git clauses do not relax: they are met before 1.0.0. *(traces to:
  PRD UX Notes "the view never lies" — "or, in the beta's Git view, as read when the folder was
  opened" — and its bullet "In the beta, before the Git view follows the disk", Scope (In) "The
  first public release — a beta"; owner-confirmed `docs/trail/prd/cycle-15.md` § 3.1 and
  `docs/trail/srs/cycle-12.md` § 2.1; see RN-39)*

### 3.6 Beyond v1, inside the terminus

- **FR-17:** *(beyond v1)* Where the folder is a repository (FR-33), for any file the Git view
  reports as changed, the system presents its changes read-only, distinguishing staged changes
  from unstaged ones rather than collapsing both into a single working-vs-committed view; in a
  plain folder it presents nothing (FR-34). *(traces to: PRD Scope (In) full-ambition "diffs";
  widened by owner override: `docs/trail/srs/cycle-1.md` §2.2; see RN-13; bounded at v8: RN-31)*
- **FR-18:** *(beyond v1)* Where the folder is a repository (FR-33), the system presents the
  repository's commit history read-only; in a plain folder it presents nothing (FR-34). When the
  history holds more than one branch, the user can see the branches as branches — which
  commits belong to which branch, and where they diverge and merge — never a flat list that
  flattens them together. The history is presented against a chosen **set** of branches — one,
  several, or all of them — with a default that asks nothing (the current branch and what relates
  to it), so the user chooses what is presented and does not have to. Per commit: its identifier,
  message, author, and date, with its changed files reachable from its entry. The properties are
  bound; how the history is drawn and what chooses the branch set stay downstream. *(traces to:
  PRD Scope (In) full-ambition "commit history"; shape: owner override
  `docs/trail/srs/cycle-3.md`, superseding the cycle-1 list (`docs/trail/srs/cycle-1.md` §2.2);
  the experience document that override cited is no longer on disk — the wording stands on the
  cycle-3 answer alone: RN-20; see RN-19; bounded at v8: RN-31)*
- **FR-19:** *(beyond v1)* The user can switch which folder is viewed without restarting the
  system — always exactly one at a time, never several at once; the folder switched to is any
  folder FR-1 admits, and FR-33 is applied to it afresh. *(traces to: PRD Scope (In) "one folder
  at a time is a v1 cut", Out of Scope "Changing the viewed folder without restarting", "Several
  folders at once"; the word widened at v8 with the PRD: RN-31)*
- **FR-22:** *(beyond v1)* Selecting a commit in the history presents what that commit changed,
  read-only, in the same diff presentation FR-17 requires. *(traces to: PRD Scope (In)
  full-ambition "diffs, commit history"; added by owner override: `docs/trail/srs/cycle-1.md`
  §2.2; see RN-13)*

### 3.7 Appearance & own state

- **FR-20:** *(changed)* The system offers a dark and a light theme, and the user chooses between
  them; the choice is kept between sessions (FR-21). Both themes and the choice are in place
  before 1.0.0, and a release below 1.0.0 is not held to them. *(traces to: PRD UX Notes "dark and
  light themes from the start", Scope (In) "The first public release — a beta" — the beta waits
  "not for choosing a theme and keeping that choice", which is "in place before 1.0.0";
  owner-confirmed `docs/trail/prd/cycle-16.md` § 3.1 and `docs/trail/srs/cycle-12.md` § 2.1; see
  RN-39)*
- **FR-21:** The system's own remembered state — theme choice, window state, anything kept
  between sessions — persists in the tool's own data location on the machine, never inside the
  viewed folder. *(traces to: PRD Data & Privacy own-state boundary — "never inside the folder it
  is pointed at"; the word widened at v8: RN-31)*

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
- **NFR-4:** No failure mode of the system can lose or corrupt anything in the viewed folder: the
  read-only requirements (NFR-5 – NFR-8) hold during and after crashes and abnormal exits, not
  only in normal operation. *(traces to: PRD Success Metrics "Read-only integrity" — "under any
  operation"; the word widened at v8: RN-31)*

### 4.3 Security & Privacy

The PRD states the product's promises separately, none implied by another; so does this SRS:

- **NFR-5:** The system performs no write inside the viewed folder — no file or directory
  created, modified, or deleted anywhere under the folder's path, `.git` included where the
  folder is a repository, under any operation. Finding out whether the folder is a repository
  (FR-33) is inside this bar. *(traces to: PRD Success Metrics "no write to the viewed folder";
  the word widened at v8: RN-31)*
- **NFR-6:** Where the folder is a repository (FR-33), the system performs no Git mutation — no
  checkout, stash, index, or commit operation; the repository's full Git state (refs, HEAD,
  index, stash, objects) is identical before and after any session. *(traces to: PRD Success
  Metrics "no Git mutation"; bounded at v8: RN-31)*
- **NFR-7:** The system collects and transmits nothing about its users or their usage — no
  telemetry, no accounts, no identity, no behavioural data. *(traces to: PRD Success Metrics "no
  telemetry", Data & Privacy)*
- **NFR-8:** The system makes no network call during operation — none, not merely no
  non-essential ones; its operation stays entirely on the user's machine. Acquisition of the
  tool is not operation. The PRD keeps the phrase "no non-essential network call" as headroom for
  a possible future update or version check; such a feature enters the PRD as a stated feature
  before it exists, and reaches this SRS by revision — until then, none. *(traces to: PRD Data &
  Privacy "v1 makes no network call at all during operation; acquiring the tool uses the network,
  operating it does not", and its stated headroom; see RN-3)*
- **NFR-9:** The bar on NFR-5 – NFR-8 is zero violations, absolutely, reckoned at every release;
  a single violation is a release-blocking defect. *(traces to: PRD Success Metrics "Read-only
  integrity" bar)*
- **NFR-16:** Content read from the viewed folder is displayed, never executed: rendering a
  file — Markdown included — runs no script, loads no active content, and gives the file no
  path to the filesystem, the network, or the system's own state. *(traces to: PRD Success
  Metrics "Read-only integrity" under any operation, Data & Privacy; added consequence of DR-6's
  untrusted-input bar for rendered content: RN-23; the word widened at v8: RN-31)*

### 4.4 Scalability

- **NFR-10:** The performance bars (NFR-1, NFR-2) hold across realistic folder scale — the
  dimensions that matter are file count, tree depth, individual file size, and history length.
  Reference sizes are fixed alongside the first-build thresholds (same process as NFR-1/NFR-2)
  and recorded here by revision. *(traces to: PRD Success Metrics immediacy bars; threshold
  process: RN-4; the word widened at v8: RN-31)*

### 4.5 Observability

- **NFR-11:** A failure the user must know about is visible in the UI itself; any diagnostic
  output the system produces lives with its own state (FR-21), never inside the viewed folder
  and never transmitted anywhere. Where that output is a diagnostic log, the log holds at most
  the current session's lines: a launch creates the file where none exists and truncates it
  where one does, so nothing from an earlier session survives a launch. Within a session the log
  is bounded to 1 MiB, measured as the file's size on disk — so the bound holds when two
  instances of the system write one file — past which it is emptied and writing continues, so
  the most recent lines are always the ones present and the file never grows without bound. A
  failure to write the log is not a failure the user must know about: it surfaces nowhere, stops
  no item's presentation, and is not retried — the line is not written. *(traces to: PRD UX
  Notes "instantly usable without instruction", Data & Privacy; see RN-9; the word widened at
  v8: RN-31; the log's bound and the write-failure rule confirmed at v9: RN-36)*

### 4.6 Maintainability

- **NFR-12:** The viewed folder is an input, not a structural singleton: moving from FR-2
  (supplied at start) to FR-19 (switch without restarting) must not require rewriting the viewing
  surface. *(owner instruction: RN-5; the word widened at v8: RN-31)*

### 4.7 Usability & Adoption

*(category added beyond the standard six — the PRD's headline success metrics are usability bars;
see RN-8)*

- **NFR-13:** Time-to-first-success: from a stranger deciding to try KA-Reader — by its single
  install path, whatever that path is — to viewing a file of their own repository, ≤ 5 minutes,
  checked before each release on macOS, the one platform v1 promises (C-11). The clock is read
  against a Git repository, the fuller path; a plain folder is the same path with less in it and
  is not measured separately. *(traces to: PRD Success Metrics "Time-to-first-success" — "on
  macOS — the one platform v1 promises", "not measured separately"; owner-confirmed
  `docs/trail/prd/cycle-10.md` § 2.3)*
- **NFR-14:** Zero required configuration: the only input the system requires is which folder
  to view — no settings, no project file, no setup step required by any feature, v1 or later;
  whether the folder is a Git repository is found (FR-33), never asked. Pass/fail, checked at
  each release. *(traces to: PRD Success Metrics "Zero required configuration"; the word widened
  at v8 with the PRD: RN-31)*
- **NFR-15:** Usable without instruction, at the PRD's bar: anyone who works with Git and can
  follow a README can use it — the reader is assumed to know Git, and the product may leave
  Git's own vocabulary unexplained; no editor experience, no onboarding. Verified by per-release
  first-use inspection, not machine check. *(traces to: PRD Goals "No learning curve", UX Notes
  "Failure states" — "someone who works with Git, not necessarily an expert in it"; the floor
  owner-confirmed `docs/trail/prd/cycle-8.md` § 1.1, superseding the GitHub-browsing floor: RN-34)*

## 5. Interfaces

### 5.1 User Interface

- One shell: a sidebar toggling Files/Git (FR-11; the Git view empty in a plain folder, FR-34)
  beside a dominant read-only reading panel (FR-8), with an empty state when nothing is open
  (FR-4). Navigation is text-first, icons secondary; the layout explains itself — no onboarding
  surface, no configuration surface. *(traces to: PRD UX Notes)*
- Dark and light themes (FR-20). Mouse-driven; no keyboard-accessibility promise (§2, from the
  finish line — permanent). Beyond that line, v1 makes no assistive-technology promise: its
  accessibility surface is what the product already carries — the two themes, text-first
  navigation — a v1-scoped statement, not a permanent bound (RN-18). *(traces to: PRD UX Notes
  "The bounds v1 draws"; owner-confirmed: `docs/trail/prd/cycle-5.md`)*
- UI language: English (C-8).

### 5.2 API

- None — deliberately. The system exposes no programmatic surface; the agent-workflow /
  inspection-service front-end direction is outside the terminus (§2).

### 5.3 External Services

- None. The system depends on at most two local sources, both read-only: the local filesystem
  (the viewed folder's files and folders, read continuously enough for FR-14) and — only where
  the folder is a repository's root (FR-33) — that repository's Git state (branch, changed files,
  staged files — read without any state-altering operation). In a plain folder the system needs
  nothing from Git (FR-34). *(traces to: PRD Dependencies / Integrations — "it needs nothing from
  Git when the folder is not a repository")* Whether Git state is read through an installed Git
  or a library is the SDD's call, bounded either way by NFR-5, NFR-6, and C-2.

## 6. Data Requirements

- **DR-1:** **The viewed folder** — identified by its path, and by whether it is a repository's
  root, a property the system finds (FR-33) and never asks; the source of everything displayed;
  strictly a read-only input (NFR-5, NFR-6). Nothing of its content is persisted by the system.
  *(traces to: PRD Data & Privacy "persists nothing of it", Success Metrics "Zero required
  configuration"; widened at v8: RN-31)*
- **DR-2:** **File tree model** — the viewed folder's folders and files, with changed markers
  where the folder is a repository (FR-6), the current selection, and the user's expanded state
  (FR-27); derived from disk and Git state, held in memory, never persisted.
- **DR-3:** **File view** — the open file's path, content, the floor language recognized for it
  or none (FR-8, FR-29), whether it is Markdown and which of rendered / raw is showing (FR-30,
  FR-31), and the reading position FR-27 preserves; derived and in-session, never persisted.
- **DR-4:** **Git state** — branch name, changed files, staged files, short status; derived from
  repository metadata by read-only means, never persisted; present only where the folder is a
  repository's root (FR-33), and empty in a plain folder (FR-34).
- **DR-5:** **Own state** — preferences the system remembers between sessions (theme choice,
  window state, and the like), stored in the tool's own data location on the machine, never
  inside the viewed folder; contains nothing personal and no content of the viewed folder.
  *(traces to: PRD Data & Privacy; the word widened at v8: RN-31)*
- **DR-6:** **The input bar** — the system requires nothing of the folder beyond being a readable
  local folder (FR-3 is the failure behavior); being a Git repository is found, never required
  (FR-33). Everything else it must tolerate, not require: content changing at any moment mid-read
  (FR-16), unreadable, binary, or arbitrarily large files (FR-10, NFR-3, NFR-10), transiently
  inconsistent Git metadata where the folder is a repository (FR-16), and file content that is
  hostile when rendered (NFR-16). The folder is live, untrusted input; requirements on the
  *system's behavior* carry the tolerance, and no requirement assumes a quiescent or well-meaning
  folder. *(traces to: PRD Target Users driving scenario; widened at v8: RN-31)*

## 7. Constraints

- **C-1:** Local-only: the system runs on the user's machine against local state; no hosted mode,
  no remote repositories, nothing about its operation leaves the machine. *(traces to: PRD Scope
  (In) run posture, Out of Scope)*
- **C-2:** Viewer-only, permanently: no write path to the viewed folder exists in any version;
  adding one would be a different product. *(traces to: PRD Out of Scope "Editing,
  permanently", Success Metrics "no write to the viewed folder"; the word widened at v8: RN-31)*
- **C-3:** Exactly one acquisition-and-start path, and it is simple: documented on the README's
  first screen, requiring no clone of the source repository and no build from source, presuming
  at most one widely-available prerequisite, which the README's first screen names; the ≤ 5-minute
  clock (NFR-13) includes installing that prerequisite when absent. The concrete channel is
  fixed in the SDD, where the runtime is chosen (RN-7). *(traces to: PRD Scope (In) single-path
  property, Goals "Pick-it-up adoption"; owner-confirmed: `docs/trail/srs/cycle-1.md` §2.1; see
  RN-12)*
- **C-4:** Licence: MIT at first release, recorded with its reason; the code is open source.
  *(traces to: PRD Assumptions "Licence: MIT")*
- **C-5:** Every release carries the licence notices of the third-party components it ships.
  *(owner decision: RN-6)*
- **C-6:** From the first 1.0.0 release, releases are semantically versioned and a breaking
  change to the product's public contract requires a major version; before 1.0.0, that anything
  may change is stated plainly rather than left implied. *(traces to: PRD Assumptions
  "Versioning" — carried upstream since PRD v7; owner-confirmed: `docs/trail/srs/cycle-1.md`
  §2.4; see RN-15, RN-24)*
- **C-7:** Before the first public release, a private vulnerability-reporting channel is enabled
  on the public repository (C-12), and a SECURITY.md names where to report and states the
  posture the PRD sets for what follows — "Security reports have a private channel and are read,
  with no acknowledgement or response time promised" (`docs/PRD.md` § Assumptions, "Support
  posture") — in those terms, promising nothing the PRD does not. *(traces to: PRD Risks
  "Maintenance is a standing liability", Assumptions "Support posture"; owner-confirmed:
  `docs/trail/srs/cycle-1.md` §2.5; the response wording resolved at v5 from the PRD's stated
  posture: RN-24; see RN-16)*
- **C-8:** UI language: English. *(traces to: PRD UX Notes)*
- **C-9:** The README's first screen is product surface and carries: what the tool does in one
  sentence, one install path, one copy-paste example, and what the tool will and will not touch.
  *(traces to: PRD Goals "Pick-it-up adoption")*
- **C-10:** Regulatory posture: the product stays free, non-monetized open source outside any
  commercial activity — the premise of its position outside the EU Cyber Resilience Act's scope.
  The classification rests on that character and falls with it; revisiting the character is the
  CPO's call, and would reopen the classification. *(traces to: PRD Assumptions "Regulatory
  posture")*
- **C-11:** Platform: v1 runs on macOS and promises no other platform; Linux and Windows are
  outside v1. The minimum macOS version is not set by the PRD; it is fixed in the SDD with the
  runtime (the placement C-3 gives the acquisition channel, RN-7) and stated wherever the install
  path is offered, so a stranger knows before installing. *(traces to: PRD Scope (In)
  "Platform", Out of Scope "Linux and Windows"; owner-confirmed: `docs/trail/prd/cycle-7.md`
  §1.2; the version-floor placement: RN-21)*
- **C-12:** Public identity: the product is published from `github.com/eyalgo/ka-reader`, under
  the maintainer's personal GitHub handle `eyalgo`, and maintained under that handle; that
  repository is where C-7's channel is enabled and where releases are offered. The repository is
  made public with its own commit history, not as a fresh copy, and only once that history has
  been checked for anything private. *(traces to: PRD
  Assumptions "Public identity"; owner-confirmed: `docs/trail/prd/cycle-7.md` §1.1; the personal
  handle: changed at v13 with PRD v16, owner-confirmed `docs/trail/prd/cycle-14.md` § 3.1 and
  `docs/trail/srs/cycle-11.md` § 1.1; see RN-38; the public history: PRD v18, owner-confirmed
  `docs/trail/prd/cycle-16.md` § 3.1 and `docs/trail/srs/cycle-12.md` § 2.1; see RN-39)*
- **C-13:** The README states the support posture in the PRD's terms — "Issues and questions are
  welcome and read when there is time, with no response time, no commitment to fix, and no
  commitment that a fix ever arrives" (`docs/PRD.md` § Assumptions, "Support posture") — and
  promises nothing beyond it. *(traces to: PRD Assumptions "Support posture" — "The README says
  this plainly rather than implying more"; owner-confirmed: `docs/trail/prd/cycle-7.md` §2.4;
  see RN-24)*

## 8. Acceptance Criteria

- **AC-1:** Exercising the full product surface against an instrumented repository and against
  an instrumented plain folder leaves the filesystem under each folder's path byte-identical —
  file set, content, and, for the repository, Git internals (`.git` included); under the plain
  folder no `.git` and no other entry has appeared. Run at every release. *(covers: NFR-5,
  NFR-9, C-2, FR-33; the plain folder added at v8: RN-31)*
- **AC-2:** After any session, the repository's full Git state — refs, HEAD, index, stash,
  objects — is identical to before it. Run at every release. *(covers: NFR-6)*
- **AC-3:** Network monitoring across a full session shows zero outbound traffic. Run at every
  release. *(covers: NFR-7, NFR-8)*
- **AC-4:** Typing, pasting, and dropping into the reading panel change nothing, on screen or on
  disk. *(covers: FR-9)*
- **AC-5:** A user can navigate the tree, open files from it, and read them: a file under each
  extension the SDD's set names for each of the six floor languages is displayed with that
  language's highlighting; a text file outside the floor, a file with no extension (a shell
  script whose only marker is a `#!/bin/sh` first line), and a file whose extension is outside
  the set are each displayed as plain text with no other language's highlighting; changed files
  are marked and the selection highlighted. *(covers: FR-5 – FR-8, FR-29; widened at v5 with the
  floor: RN-22; the recognition cases added at v6: RN-27)*
- **AC-6:** Against a repository with staged and unstaged changes on a named branch, the Git view
  shows all four elements (changed files, staged files, branch, status) correctly, and activating
  a listed file's row opens the file for reading where the build under test has no diff (FR-17),
  or opens that file's diff where it does — the file readable from the tree either way. *(covers:
  FR-11 – FR-13; FR-13's two readings at v12: RN-37)*
- **AC-7:** An external file create, modify, and delete, and an external Git staging operation,
  each appear in the view with no user action, within NFR-2's bar. In a plain folder the file
  create, modify and delete appear the same way; and a repository initialised at the opened
  folder's root mid-session, or removed from it, is followed — the Git view populates, or
  empties, and the tree's markers appear, or go, within the same bar. *(covers: FR-14, NFR-2,
  FR-33; the plain-folder and presence clauses added at v8: RN-33)*
- **AC-8:** Scripted rapid concurrent changes — create/modify/delete including deleting the file
  currently displayed, plus Git operations mid-flight — cause no crash, no write, and the view
  converges to the final on-disk state. *(covers: FR-16, NFR-3, NFR-4)*
- **AC-9:** On a machine that has never run the product, it starts with the folder location as
  its only input; no settings, project file, or setup step exists to need, and nothing asks
  whether the folder is a repository. Pass/fail at each release. *(covers: FR-1, NFR-14; widened
  at v8: RN-31)*
- **AC-10:** A timed first-use check before each release, on macOS: a user new to the tool,
  guided by the README alone, reaches a viewed file of their own repository in ≤ 5 minutes.
  Verification is a timed manual walk — deliberately not automated, because the thing measured
  is a stranger's path. *(covers: NFR-13, C-3, C-9, C-11)*
- **AC-11:** *(changed)* At 1.0.0, and at every release from the one that ships them, both themes
  are present and usable, and the theme chosen in one session is the theme the next session
  opens in. A release below 1.0.0 that ships without them does not fail this criterion.
  *(covers: FR-20, FR-21; the first-release clause dropped at v14: RN-39)*
- **AC-12:** At the closing release, the diff view (staged distinguished from unstaged) — opened
  by activating a changed file's row in the Git view, with the file still read from the tree —
  the commit history — against a repository whose history holds more than one branch: the
  branches visible as branches, the presented branch set choosable, and the default asking
  nothing — with its per-commit diffs, and folder switching — to a repository and to a plain
  folder, each behaving as FR-33 and FR-34 require — are present, read-only, and AC-1 – AC-3
  still pass with them exercised. *(covers: FR-13, FR-17 – FR-19, FR-22; history coverage widened
  with FR-18: RN-19; the FR-31 clause removed at v6, the switch being outside the terminus:
  RN-29; the switch's two targets added at v8: RN-31; the row opening the diff added at v12:
  RN-37)*
- **AC-13:** After a session in which preferences changed, new or changed files exist only in the
  tool's own data location — none under the viewed folder's path — and inspection finds nothing
  personal and no content of the viewed folder in them. Where a diagnostic log is among them, it
  is no larger than 1 MiB, and a line it held before a launch is absent after that launch.
  *(covers: FR-21, DR-5, NFR-11; the word widened at v8: RN-31; the log's bound added at v9:
  RN-36)*
- **AC-14:** Release inspection: the release carries the MIT licence and third-party notices; the
  README first screen carries its four items, its one-sentence description does not call the
  tool a web app, the README states sidebar search / filter, pane resizing and keyboard
  navigation as outside the product's done rather than promising them, and the README states the
  support posture in the PRD's terms; where the release ships FR-35's read-at-open state, the
  README's known gaps state that the Git view and the tree's changed-file markers show the Git
  state read when the folder was opened, and that a repository created at the folder's root after
  it is opened is not followed — and where the release follows Git state, the README carries no
  such line; the version number obeys C-6; SECURITY.md and the private
  reporting channel exist per C-7, on the repository C-12 names, and SECURITY.md promises nothing
  the PRD does not; and before the repository was made public, its own commit history was checked
  for anything private, per C-12. *(covers: C-4 – C-7, C-9, C-12, C-13, FR-35; widened at v5:
  RN-24; the two README lines added at v8: RN-34; the known-gaps line and the history check added
  at v14: RN-39)*
- **AC-15:** With no file selected the empty state prompts selection; pointed at a path that does
  not exist, is not a folder, or cannot be read, the system states plainly what went wrong and
  what to do next, and a filesystem check shows it touched nothing. *(covers: FR-3, FR-4; widened
  with FR-3: RN-17; the failure list narrowed at v8 with FR-3: RN-31)*
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
- **AC-22:** Selecting a Markdown file displays it rendered; where the raw-source switch is
  shipped, switching shows the file's source byte-for-byte as on disk and switching back
  restores the rendered view, with the file unmodified throughout. A release that ships
  rendered-only states so where the release is offered. *(covers: FR-30, FR-31)*
- **AC-23:** Rendering a Markdown file that references a remote image, contains an external link
  and a relative link to a file in the viewed folder, and embeds a script and active HTML content
  produces zero outbound traffic, executes nothing, and leaves the filesystem and the tool's own
  state unchanged; activating the external link opens nothing and produces no outbound traffic;
  activating the relative link either does nothing or — where the release opens relative links —
  displays the target file read-only, exactly as selecting it in the tree would, with the file
  unmodified. *(covers: FR-32, NFR-16, NFR-8; the relative-link case added at v6: RN-28; the word
  widened at v8: RN-31)*
- **AC-24:** Against a readable folder that is not a Git repository: the workbench opens with no
  failure state; the tree, file reading (AC-5's cases), the empty state and the sidebar toggle
  work as against a repository; the Git view is present and, opened, contains no text, no
  control and no marker of any kind; the tree carries no changed-file markers; and a filesystem
  check shows nothing created or changed under the folder — no `.git`. *(covers: FR-34, FR-3,
  FR-33, NFR-5; added at v8: RN-31)*
- **AC-25:** Against one repository opened three ways — at its root, at a folder inside it, and
  at a parent folder that contains it beside a second repository — only the root shows Git state
  (AC-6); the other two behave exactly as AC-24. A linked worktree and a submodule's folder, each
  opened at its own top level, show their own Git state, not the enclosing repository's.
  *(covers: FR-33; added at v8: RN-32)*
- **AC-26:** Against a build that reads Git state once, at open, and does not follow it: opened at
  a repository with changed files, the Git view and the tree's changed-file markers each carry a
  plain statement that they show the Git state read when the folder was opened; an external Git
  staging operation after open leaves the state shown unchanged and still under that statement,
  never presented as current. Opened at a plain folder, the same build behaves exactly as AC-24
  — no statement, no text, no marker. Against a build that follows Git state, neither surface
  carries the statement, and AC-7 applies. Verification: inspection of both surfaces in each
  case. *(covers: FR-35, FR-34; added at v14: RN-39)*

---

## SRS Review Notes

- **RN-1:** The repository is supplied at start in v1, with no in-product chooser (FR-2) —
  *because* an in-product way to choose a repository is exactly the "changing the viewed
  repository without restarting" capability the PRD places beyond v1, and the owner delegated
  the start mechanism to the CTO *(re: FR-2; PRD source: Out of Scope; owner delegation:
  `docs/trail/prd/cycle-2.md` §2.2)*.
- **RN-2:** Mid-change tolerance stated as a requirement (FR-16) — *because* the PRD's driving
  scenario is watching a tree an automated tool is actively changing, which the PRD implies but
  never states as a behavior: a viewer that crashes, blocks, or writes when the tree moves under
  it cannot serve the scenario the product is driven by *(re: FR-16, NFR-3, DR-6; PRD source:
  Target Users, Key Use Case 3)*.
- **RN-3:** *(repaired at v5)* NFR-8's "no network call during operation — none" is the PRD's own
  statement since v8 — "v1 makes no network call at all during operation; acquiring the tool
  uses the network, operating it does not" (`docs/PRD.md` § Data & Privacy) — so the requirement
  no longer tightens beyond its source, and the earlier rationale here (that the SRS tightened
  "no non-essential call" to "none" on its own reading) no longer describes a divergence. The PRD
  keeps "non-essential" as headroom for a possible future update or version check, entering the
  PRD as a stated feature before it exists (owner: `docs/trail/prd/cycle-7.md` §2.3); NFR-8 now
  carries that headroom in the same sentence as the bar, so a reader of NFR-8 alone sees both.
  The repair was authorized by the owner's instruction at `docs/trail/srs/cycle-4.md` §2.1
  ("RN-3 explains a divergence from the PRD that no longer exists. Repair the note; NFR-8 itself
  stands") *(re: NFR-8; PRD source: Data & Privacy, Success Metrics)*.
- **RN-4:** The numeric thresholds for file-switch immediacy, refresh latency, and scalability
  reference sizes are deliberately unset — *because* the owner ruled that a threshold invented
  before there is a build to measure is noise; they are measured from the first working build
  and folded in here by revision *(re: NFR-1, NFR-2, NFR-10; owner decision:
  `docs/trail/prd/cycle-1.md` §2.4)*.
- **RN-5:** Repository selection must not be structurally singular (NFR-12) — *because* the
  owner recorded, for this SRS by name, that v1 must not design the single repository in so
  deeply that switching becomes a rewrite *(re: NFR-12, FR-19; owner instruction:
  `docs/trail/prd/cycle-1.md` §2.2)*.
- **RN-6:** Third-party licence notices ride every release (C-5) — *because* the owner recorded
  it as a release obligation routed to the SRS/SDD when confirming the MIT licence *(re: C-5;
  owner decision: `docs/trail/prd/cycle-1.md` §2.5)*.
- **RN-7:** The concrete acquisition channel is fixed in the SDD, not here — *because* the owner
  routed the mechanism to the CTO (`docs/trail/prd/cycle-1.md` §2.2), and at the SRS tier naming
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
  AC-10; owner confirmation: `docs/trail/srs/cycle-1.md` §2.1)*.
- **RN-13:** The diff and commit-history surface was widened by owner override — the diff
  distinguishes staged changes from unstaged ones (FR-17), selecting a commit presents what it
  changed (FR-22), and the history stayed a read-only list (FR-18) — a shape the owner has since
  revised to branch topology (RN-19); history filtering and search stay outside done, adjacent
  to the sidebar search the Agari excludes *(re: FR-17, FR-18, FR-22, AC-12, §2; owner override:
  `docs/trail/srs/cycle-1.md` §2.2)*. Propagating the override
  surfaced two pointers naming FR-18 as the repository-switch requirement — FR-2 and §2's
  one-at-a-time line — while that requirement is FR-19; both now point at FR-19. A reference
  correction forced by FR-18's changed content, not a re-derivation of either requirement.
- **RN-14:** FR-10's presentation of unrenderable files confirmed as drafted — a placeholder
  stating why the content is not rendered; no hex viewer, no image preview, nothing hidden from
  the tree *(re: FR-10, AC-5; owner confirmation: `docs/trail/srs/cycle-1.md` §2.3)*. PRD v8's
  Out of Scope line "Rich rendering of non-text content" (owner-confirmed:
  `docs/trail/prd/cycle-7.md` §2.2) states the same exclusion upstream; FR-10 gains that trace
  at v5 and is otherwise unchanged (RN-20).
- **RN-15:** C-6 confirmed — recorded by the owner as a consequence of the Agari rather than a
  fresh call: done already requires a public MIT release at 1.0.0 or later with the
  semantic-versioning promise in force, so C-6 is that condition's realization here *(re: C-6,
  AC-14; owner confirmation: `docs/trail/srs/cycle-1.md` §2.4)*.
- **RN-16:** C-7 confirmed as drafted — private vulnerability reporting enabled and a
  SECURITY.md in place before the first public release *(re: C-7, AC-14; owner confirmation:
  `docs/trail/srs/cycle-1.md` §2.5)*.
- **RN-17:** This revision (v3) derives the PRD's v4 → v6 move — `## UX Notes` re-authored whole
  (`docs/trail/prd/cycle-4.md`) and v1's accessibility posture settled
  (`docs/trail/prd/cycle-5.md`) — authorized by the owner's cycle-2 answer
  (`docs/trail/srs/cycle-2.md`): derive from the PRD as it now reads; every delta below traces
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
  PRD source: UX Notes "The bounds v1 draws"; owner-confirmed: `docs/trail/prd/cycle-5.md`)*.
- **RN-19:** *(changed — this revision, v4)* FR-18's history shape revised from a flat read-only
  list to branch topology, by owner override (`docs/trail/srs/cycle-3.md`) — superseding the
  cycle-1 answer on the history's shape only; cycle-1's diff decisions (FR-17, FR-22) and its
  history-filtering/search exclusion stand untouched. The owner reopened the shape during the
  UXD's rounds and confirmed the experience statement there; the wording authority is `UXD.md`
  UX-S6 and RN-14 (owner-confirmed: `ka-reader@1d5c553:docs/uxd_trail/cycle-2.md` § 2.1). The properties are
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
  §2; PRD source: Scope (In) full ambition "commit history")* The two files this note cites as
  wording authority, `UXD.md` and `docs/uxd_trail/cycle-2.md`, were removed from the product
  repository at `9017ae2` — see RN-20 for what FR-18 now stands on.
- **RN-20:** *(this revision, v5 — the pass and its bounds)* Re-authored on the owner's
  instruction (`docs/trail/srs/cycle-4.md` §2.1) against PRD v8, template 1.9.0 and prompt 3.6.0.
  The instruction reopened no requirement on its own: every value confirmed in
  `docs/trail/srs/cycle-1.md` – `cycle-3.md` stands as written, and every delta at v5 traces to
  one of three sources — a PRD fact added at v7/v8 (RN-21 – RN-24), a carrier rule (this note),
  or a wording repair that moves no technical fact (this note). Carrier deltas: the header
  blockquote takes template 1.9.0's shape, naming the SDD's three seats — the template's own
  wording says "the SDD you co-author with the CPO" while prompt 3.6.0 and the owner's
  instruction say the CTO, the CPO and the CDO; the conflict is about what the sentence
  contains, so the prompt and the owner's instruction settle it, and the template's two-seat
  wording is not carried. `## Open Questions` is omitted: the v4 section held no question — a
  "None" and its explanation — and template 1.9.0 omits an empty section because an empty
  heading reads as an unanswered question; nothing that section explained is lost (RN-4 holds
  the thresholds' process, and this trail holds the rest). Wording repairs: FR-10's "a clear
  placeholder" reads "a placeholder" — the sentence already states what the placeholder says,
  and "clear" collapses under the writing bar's prove-it test (`system/doctrine/writing_bar.md`
  § 1.2). The missing experience document: `docs/UXD.md` and `docs/uxd_trail/` were removed at
  `9017ae2` "to be authored again by a skill that has been measured"; FR-18's wording is the one
  folded at v4 and stands on the owner's cycle-3 answer, which is on disk — the instruction
  forbade re-deriving the UXD and forbade dropping what was traced to it, and neither is done;
  FR-18's trace and RN-19 now say so rather than citing a file a reader cannot open. Nothing
  at v5 needed the UXD to settle. The narration in RN-13, RN-17 and RN-19 of the rounds that
  wrote them predates prompt 3.6.0's rule that the trail records the system and not the round;
  those notes are settled wording and are left as written — the rule binds notes written from
  v5 on. *(re: header, §2, FR-10, FR-18, RN-19, the omitted section)*
- **RN-21:** *(added)* Platform constraint C-11 — *because* PRD v8 states v1 runs on macOS only
  and names Linux and Windows as an exclusion (owner: `docs/trail/prd/cycle-7.md` §1.2), a fact
  the SRS at v4 did not carry at all. Propagation: NFR-13 and AC-10 fix the time-to-first-success
  check to macOS, as the PRD's own metric does. Two consequences the PRD does not state: (i) a
  minimum macOS version is a limit a stranger reads before installing, so C-11 names who fixes it
  (the SDD, with the runtime — the same placement as the acquisition channel, RN-7) and requires
  it stated wherever the install path is offered; (ii) the Agari draws the dock as three named
  surfaces beyond v1 and says nothing of platform, so §2 reads a second platform as outside done
  and routed that reading to the owner as a choice — the terminus is the CPO's, not this
  document's to extend — who confirmed it (RN-30) *(re: C-11, NFR-13, AC-10, §2; PRD source:
  Scope (In) "Platform", Out of
  Scope "Linux and Windows", Success Metrics "Time-to-first-success")*.
- **RN-22:** *(changed — FR-8; added — FR-29)* The highlighting promise now has a floor —
  *because* PRD v8 promises highlighting for Python, shell, JavaScript, JSON, YAML and TOML and
  for no other language in v1, with a plain-text fallback that never refuses and never
  mis-highlights (owner: `docs/trail/prd/cycle-7.md` §2.5). FR-8 at v4 said "recognized
  languages", which promised an unstated set; it now names the floor, and FR-29 carries the
  fallback as its own testable behavior. AC-5 widens to exercise both. The PRD's growth rule —
  the floor grows when the maintainer needs a language — lands as no requirement: a change to
  the floor is a PRD revision this SRS follows, not a system behavior. One product-visible call
  the PRD leaves open is how a file is recognized as a floor language — by extension per the
  owner's own measurement (`.py`, `.sh`, `.js` / `.mjs`), which leaves an extension-less shell
  script, a `.yml` file, or a shebang script as plain text unless the recognition says
  otherwise; drafted as extension-based with the extension set the SDD's, routed to the
  companion as a choice, and confirmed (RN-27) *(re: FR-8, FR-29, AC-5, DR-3; PRD source: Core
  Features)*.
- **RN-23:** *(added — FR-30 – FR-32, NFR-16, AC-22, AC-23)* Markdown rendering — *because* PRD
  v8 states it: rendered by default, a toggle to the raw source, and the fallback that v1 may
  ship rendered-only with the toggle following (owner: `docs/trail/prd/cycle-7.md` §2.5). FR-30
  and FR-31 carry the two behaviors; FR-31 carries the fallback as a permission, in the PRD's own
  terms. Two bounds follow from requirements already settled, and are added with that basis
  rather than routed as choices: FR-32 — a rendered document may reference remote resources, and
  loading one is a network call during operation, which NFR-8 forbids absolutely; so rendering
  fetches nothing. NFR-16 — DR-6 already holds the repository as untrusted input, and a
  Markdown file may embed script or active HTML; a renderer that executed it would hand the
  repository a path to the filesystem, the network and the tool's own state, which NFR-4, NFR-5
  and NFR-8 each forbid; so rendered content executes nothing. AC-23 exercises both with a
  hostile document. Two product-visible calls were routed to the companion and answered at
  cycle-5 (RN-28, RN-29): what a link in a
  rendered document does when activated (drafted: nothing — the system follows none, FR-32),
  and whether the raw-source switch is inside the terminus (drafted: yes — AC-12 exercises it at
  the closing release, on the reading that "reading with highlighting" in the Agari's first
  condition covers the whole reading surface the PRD now draws) *(re: FR-30 – FR-32, NFR-16,
  DR-3, DR-6, AC-12, AC-22, AC-23; PRD source: Core Features, Data & Privacy, Success Metrics)*.
- **RN-24:** *(added — C-12, C-13; changed — C-6's trace, C-7's response wording)* Identity and
  support posture — *because* PRD v8 states the public identity (`github.com/kensaiapp/ka-reader`,
  owner: `docs/trail/prd/cycle-7.md` §1.1) and a support posture in which nothing is promised
  (owner: `docs/trail/prd/cycle-7.md` §2.4). C-12 carries the identity as the place C-7's
  channel and the releases live. C-7 at v4 asked SECURITY.md to state "what response to expect"
  against a posture the PRD had not yet stated; the PRD now states it, so C-7 quotes it and
  binds SECURITY.md to promise nothing beyond it. C-13 carries the PRD's requirement that the
  README states the posture plainly, quoting the PRD's terms — the writing bar requires a
  commitment quoted, never paraphrased (`system/doctrine/writing_bar.md` § 1.5). AC-14 widens to
  inspect both. C-6 gains its PRD trace: the versioning promise cycle-1 noted as absent from the
  PRD (`docs/trail/srs/cycle-1.md` §2.4, the follow-up) has been in PRD Assumptions since v7,
  so the constraint no longer rests on the Agari and this trail alone. The PRD's "a version that
  can no longer be maintained is archived visibly" lands as no requirement: it is an act on the
  repository after maintenance ends, not a behavior of the system, and this trail records the
  drop so a reader does not mistake the silence *(re: C-6, C-7, C-12, C-13, AC-14; PRD source:
  Assumptions "Public identity", "Support posture", "Versioning")*.
- **RN-25:** *(reverse walk, PRD v8)* Every PRD unit not named above lands where v4 already
  placed it: the Blurb restates Purpose and Problem Statement (no new unit); the familiarity
  thesis (Assumptions) is a product assumption with no system behavior, unchanged since v1 of
  this SRS; the Out of Scope line for rich rendering of non-text content is FR-10's (RN-14). No
  other unit of Goals, Success Metrics, Key Use Cases, Core Features, UX Notes, Scope, Out of
  Scope, Assumptions, Dependencies, Data & Privacy or Risks moved between PRD v6 and v8 beyond
  the four RN-21 – RN-24 derive *(re: §2 – §8)*.
- **RN-26:** *(the terminus, at v5)* The Agari (`system/projects/ka-reader/finish_line.md`) is unchanged
  since v4 of this SRS and predates PRD v7/v8. Two of v5's additions sat against its edge and
  were routed to the owner rather than read into it — the platform (RN-21) and the raw-source
  switch (RN-23); the owner placed both outside done (RN-29, RN-30). Its second condition quotes the promise as "no non-essential network call";
  NFR-8's "none" sits inside that wording, not against it, so no collision is raised *(re: §2,
  AC-12, NFR-8)*.
- **RN-27:** *(confirmed choice — FR-29, AC-5)* A floor language is recognized by file extension,
  never by content, and each floor language is recognized by every extension in common use for
  it — the owner confirmed the extension rule and, asked separately, ruled that the set is not one
  extension per language: "we should cover the options" (`docs/trail/srs/cycle-5.md` §2.1). The
  full extension set is fixed in the SDD; AC-5 exercises each extension that set names, plus the
  two cases the rule leaves as plain text — no extension, and an extension outside the set
  *(re: FR-29, AC-5, DR-3; PRD source: Core Features)*.
- **RN-28:** *(owner answer — FR-32, AC-23)* Links in rendered Markdown. The
  owner's answer is a permission conditioned on build cost, applied to each half on its own —
  "per each, if it costs nothing, do it" (`docs/trail/srs/cycle-5.md` §2.2): neither half is
  required for v1, neither is refused, and neither is inside the terminus. The relative-link half
  is folded as that permission — FR-32 lets a relative link open its target in the reading
  panel, the build-cost judgment the SDD's, AC-23 exercising whichever the release does. The
  external half is not folded as a permission: handing a URL to the system browser makes the
  system the initiator of a network call another process makes; the owner was told before
  answering that this half turns on Way 2's promise and not on cost, and the answer records no
  acceptance of that trade (`docs/trail/srs/cycle-5.md` §2.2, the session note beneath the
  answer). That half went back as its own choice to confirm and the owner confirmed the default
  (`docs/trail/srs/cycle-6.md` §2.1): an external link is displayed and not followed — the
  system neither opens it nor hands it to another program — the reading that leaves NFR-8's
  "none" unqualified and AC-3's zero-outbound-traffic check whole *(re: FR-32, NFR-8, AC-3,
  AC-23; PRD source: Data & Privacy)*.
- **RN-29:** *(changed — FR-31, AC-12, §2)* The raw-source switch is outside the terminus and
  permitted, not required — owner override (`docs/trail/srs/cycle-5.md` §2.3): "render is what
  i need", and "add the toggle if it costs nothing". This departs from the PRD, which says the
  toggle "follows" when v1 ships rendered-only (`docs/PRD.md` § Core Features): the PRD promises
  it in a later release; the SRS now promises it in none, carrying it as a permission the SDD
  settles on build cost. AC-12's FR-31 clause is removed; AC-22 stands, exercising the switch
  only where a release ships it. The PRD is not corrected here — folding the override upstream is
  a PRD correction cycle, the CPO's, carried forward the way `docs/trail/srs/cycle-1.md` §2.4
  carried the versioning promise *(re: FR-31, AC-12, AC-22, §2; PRD source: Core Features)*.
- **RN-30:** *(confirmed choice — §2, C-11)* A second platform is outside the terminus — the owner
  confirmed the reading (`docs/trail/srs/cycle-5.md` §2.4): the Agari's first condition
  enumerates the beyond-v1 features inside done and platform is not among them, so KA-Reader is
  done on macOS alone. C-11, NFR-13 and AC-10 stand as written. The confirmation does not say
  Linux or Windows is never built — only that done does not wait for either *(re: §2, C-11,
  NFR-13, AC-10; PRD source: Out of Scope "Linux and Windows")*.
- **RN-31:** *(changed — §1, §2, FR-1 – FR-3, FR-5, FR-6, FR-12, FR-16 – FR-19, FR-21, FR-24,
  FR-28, FR-32, NFR-4 – NFR-6, NFR-10 – NFR-14, NFR-16, §5.1, §5.3, DR-1, DR-2, DR-4 – DR-6, C-2,
  AC-1, AC-9, AC-12, AC-13, AC-15, AC-23; added — FR-34, AC-24)* The input contract widens from
  one local Git repository to one local folder, a Git repository or not — *because* PRD v10 and
  v11 admit the plain folder as a supported input inside v1, with the Git view present and
  showing nothing, and Git read only at a repository's root (owner: `docs/trail/prd/cycle-9.md`
  § 1.1; `docs/trail/prd/cycle-10.md` § 2.2 – § 2.4); the owner directed this SRS to carry the
  absence through every Git-derived requirement, and delegated the technical statement of it
  (`docs/trail/srs/cycle-7.md` § 1.1). Two structural calls under that delegation. First, the
  rule is stated once and cited: FR-33 says when Git is read and FR-34 what holds when it is not,
  and each Git-derived requirement (FR-6, FR-12, FR-16 – FR-18, NFR-6) carries the one clause
  that binds it to them, so a requirement read alone still says what it does without Git and no
  two requirements can drift apart on the answer. Second, "the viewed repository" reads "the
  viewed folder" wherever a requirement holds for both inputs, while a requirement that is Git's
  alone — FR-13, FR-22, FR-26, NFR-6, AC-2, AC-6, AC-18 — keeps "repository", now bounded by
  FR-33; the switch (FR-19) takes any folder, as the PRD's own line does. FR-3's failure list
  narrows to the PRD's three — a path that does not exist, is not a folder, or cannot be read —
  and AC-15 with it. AC-24 is the plain folder's criterion end to end, including that finding out
  created nothing. Time-to-first-success stays read against a repository (NFR-13), as the PRD's
  metric does. The terminus (`system/projects/ka-reader/finish_line.md`) widened to the same input on the
  owner's direction, its integrity bar now reading "no write to the viewed folder — whether or
  not it is a repository"; §2 scopes against it as widened, and nothing in this revision sits
  against its edge *(re: as listed; PRD source: Purpose, Success Metrics, Key Use Case 4, Core
  Features, UX Notes, Scope (In), Out of Scope, Dependencies / Integrations, Data & Privacy)*.
- **RN-32:** *(added — FR-33's determination, AC-25)* "Root" is stated as: the opened folder is
  the top level of a Git working tree — *because* the PRD's rule, "what the tree shows and what
  the Git view reports are always the same folder", forbids the resolution Git itself performs
  from any folder beneath a root; a requirement that said "ask Git whether this is a repository"
  would specify the behaviour the PRD excludes. Consequences of the definition, not further
  calls: a linked worktree and a submodule's folder are each the top level of their own working
  tree and count as a root; a bare repository has no working tree and is a plain folder; whether
  the folder's `.git` entry is a directory or a file (a worktree's or submodule's pointer) decides
  nothing — the working-tree top level does. The determination sits inside NFR-5's bar because
  the one way a check can write is to create what it looks for. The mechanism stays the SDD's.
  CTO-derived under the owner's delegation of "how 'is this folder a repository's root?' is
  determined" (`docs/trail/srs/cycle-7.md` § 1.1) *(re: FR-33, AC-25, NFR-5; PRD source: Core
  Features, Out of Scope "Git found anywhere but at the opened folder's root")*.
- **RN-33:** *(added — FR-33's live clause; changed — AC-7)* Live refresh in a plain folder is
  the same requirement (FR-14) with nothing Git-shaped to move — *because* PRD Key Use Case 4
  states "the tree, the reading, and the live refresh work as they always do" there; only the
  Git-derived half is empty (FR-34), so FR-14 and NFR-2 gain no clause. That the presence
  determination is itself live is CTO-derived with basis, under the owner's delegation of
  "whether the live refresh changes at all in a plain folder" (`docs/trail/srs/cycle-7.md`
  § 1.1): the PRD's "the view never lies" holds that what is shown is the current state and never
  stale, and "Refresh immediacy" names Git state among the changes that appear with no user
  action; a repository initialised at the opened folder's root mid-session is a change in that
  folder's Git state, and a Git view that stayed empty after it would present stale state as
  current. So FR-33 follows the disk as the rest of the view does, and AC-7 exercises both
  directions. The owner may narrow this to a start-time determination by answer; AC-7's clause
  and this note move with it *(re: FR-33, FR-14, AC-7; PRD source: Key Use Case 4, Success
  Metrics "Refresh immediacy", UX Notes "the view never lies")*.
- **RN-34:** *(changed — NFR-15, AC-14)* PRD v9's units, upstream since SRS v7 and folded on the
  stability rule's upstream-change branch, apart from the widening: NFR-15's floor reads the
  PRD's "anyone who works with Git and can follow a README", superseding "find their way around
  a repository on GitHub" (owner: `docs/trail/prd/cycle-8.md` § 1.1), and carries the PRD's
  permission to leave Git's own vocabulary unexplained — a permission, so `may`. AC-14's README
  inspection gains the two things PRD v9 states of the README: its one-sentence description does
  not call the tool a web app (owner: `docs/trail/prd/cycle-8.md` § 1.3), and sidebar search /
  filter, pane resizing and keyboard navigation are stated as outside the product's done rather
  than promised (owner: `docs/trail/prd/cycle-8.md` § 1.2). What the shipped shape technically
  is stays out of the PRD and lands as no requirement here — the SDD's, with the runtime (RN-7).
  PRD v9's "the keyboard absence is permanent" was already §2's from the Agari. No other v9 unit
  moves a requirement *(re: NFR-15, AC-14; PRD source: Goals "No learning curve", UX Notes
  "Failure states", Out of Scope)*.
- **RN-35:** *(reverse walk, PRD v8 → v11; the sibling)* Every unit the PRD moved lands above or
  is accounted for here: the Blurb and Purpose sentence in §1; "Read-only integrity" ("viewed
  folder") in NFR-5, NFR-9; "Zero required configuration" (found, never asked) in FR-1, NFR-14,
  DR-1, AC-9; "Time-to-first-success" (read against a repository) in NFR-13; Key Use Case 4 in
  FR-34, AC-24; Core Features' Git view and root rule in FR-12, FR-33, FR-34; UX Notes "The
  path" (one local folder, KA-Reader's to find out, "Checking") in FR-1, FR-33, FR-34; "Failure
  states" in FR-3, AC-15; Scope (In) and its run posture in §2, FR-1; Out of Scope's two new
  lines in §2, FR-33, FR-34; the widened "Changing the viewed folder" and "Several folders" in
  §2, FR-2, FR-19; Dependencies / Integrations in §5.3; Data & Privacy's own-state boundary in
  FR-21; and the Markdown switch line (`docs/trail/prd/cycle-10.md` § 2.5) is the PRD carrying
  the override FR-31 already holds, so FR-31's trace now names the PRD's own line and RN-29's
  "the PRD is not corrected here" describes a state that has since ended — the note stands as
  written, this one records the close. The accepted ambiguity of an empty Git view lands in
  FR-34 as an acceptance, not a requirement. The sibling: `docs/UXD.md` UX-S4 still makes a
  non-repository a startup failure; the UXD follows the PRD, not this SRS, and its revision is
  the CDO's through the UXD's own skill — this SRS records the divergence and does not reshape
  FR-3 or FR-34 to it *(re: §1 – §8, FR-31, RN-29)*. The divergence ended at UXD v6
  (`ka-reader@dd08f2d`, 2026-08-26): UX-S4 narrowed to a path that does not exist, is not a folder,
  or cannot be read, and a plain folder opens (`docs/UXD.md` § UX-S4, RN-25); UXD RN-28 read this
  SRS at v8 as its sibling and found no collision with FR-33 / FR-34. FR-3 and FR-34 stand as
  written and now agree with the UXD. Confirmed at `docs/trail/srs/cycle-9.md` § 2.1 — a
  self-answer in the owner's seat, its reasoning at `docs/trail/srs/self_answer-2.md` § 2.1.
- **RN-36:** *(confirmed choice — NFR-11, AC-13)* The diagnostic log's bound: one session's lines,
  the file created or truncated at launch, at most 1 MiB on disk within a session with
  emptied-and-continue, and a failed log write surfacing nowhere — *because* NFR-11 placed
  diagnostics with own state and bounded neither their size nor their retention, and a bound no
  document states is one a builder picks silently; the Principal Architect's constraint set
  records the bound as undecided and names NFR-11 as where it lands (`docs/nfdr.md` QC-40). The
  number is a design bound a reader can check, not a threshold a build measures, so RN-4's rule
  does not reach it. The cap is on the file's size on disk rather than on what one process wrote,
  because a second instance of the system can write the same file (`man open`: `-n` — "Open a new
  instance of the application(s) even if one is already running") and the bound must hold with two
  writers; that a second launch's truncation discards the first instance's lines is accepted. A
  failed log write sits outside NFR-11's first clause because the log is diagnostics, not a
  promise: it stops no item and is not retried. A one-generation rotation was declined: the log
  records item failures, not crashes of the host, and an item failure that persists is reproduced
  at the next session's first refresh (NFR-3). Confirmed at `docs/trail/srs/cycle-8.md` § 2.1 — a
  self-answer in the owner's seat, its reasoning at `docs/trail/srs/self_answer-1.md` § 2.1.
  AC-13's own-state inspection gains the bound; the mechanism and the test that reads the number
  are downstream, the SDD's and the NFDR's *(re: NFR-11, AC-13, FR-21, DR-5; PRD source: Data &
  Privacy, UX Notes)*.
- **RN-37:** *(changed — FR-13, AC-6, AC-12)* What activating a changed file's row in the Git view
  opens — the owner's call, confirmed at `docs/trail/srs/cycle-10.md` § 2.1, which carries the
  owner's words: *"the row opens the diff. One click target on the row; the file itself is read by
  clicking it in the tree."* The PRD says *"opens the changed files to read them"* (`docs/PRD.md`
  § Key Use Cases, item 2), and FR-13 traced to that sentence unconditionally, reading it as the
  Git view's row opening the file. FR-13 now states two readings as a system state, never a
  delivery moment — FR-17 already reads *(beyond v1)*: where the diff is not present the row opens
  the file for reading as a tree selection does, and Key Use Case 2 stays the trace of that
  reading; where it is present the row opens that file's diff and the file is read from the tree.
  The second reading departs from the settled reading of the PRD sentence, so the relation is
  *changed*, as RN-29's is. The PRD is not reopened: Key Use Case 2 names no control and no row,
  and "opens the changed files to read them" holds at the closing release — from the tree, with
  FR-6's markers naming which files — so no PRD fact is false and nothing upstream of it moved;
  this note records that so a later reverse walk does not re-raise it. The row never falls back: a
  diff that cannot be produced degrades that item's view under NFR-3 and the file stays readable
  from the tree — a row that changed meaning on failure would give one control two jobs, against
  the owner's "one click target on the row". Which diff a staged-and-modified, an untracked or a
  conflicted row opens is behaviour below this document's altitude and is not stated here: FR-13
  says the row opens *that file's diff*, and FR-17 says what a diff distinguishes. Propagation:
  AC-6 takes both readings; AC-12 exercises the row opening the diff at the closing release; FR-17
  and FR-22 do not move. Four further sites name FR-13 or its behaviour and stand as written —
  FR-32's "exactly as a tree selection does (FR-7, FR-13)" names the shape a relative link opens
  with, which the first reading still carries; FR-34's list of Git-derived presentations, true of
  both readings; AC-18's "files still open for reading", the tree's; RN-31's list of the
  requirements that keep "repository". No site beyond these names FR-13 *(re: FR-13, AC-6, AC-12;
  PRD source: Key Use Case 2)*.
- **RN-38:** *(changed — C-12; upstream: PRD v16)* The public identity is the maintainer's
  personal GitHub handle: the product is published from `github.com/eyalgo/ka-reader`, under the
  handle `eyalgo`, in place of the `kensaiapp` organisation RN-24 records — *because* PRD v16
  § Assumptions, "Public identity", states it (owner: `docs/trail/prd/cycle-14.md` § 3.1,
  superseding the organisation confirmed at `docs/trail/prd/cycle-7.md` § 1.1), and the owner
  directed the fold at `docs/trail/srs/cycle-11.md` § 1.1. C-12 carries the address as the
  repository where C-7's channel is enabled and where releases are offered. Three further sites
  reach the identity and stand as written: C-7 and AC-14 name the repository through C-12, so
  they follow it without a change of their own; RN-24 records why C-12 was added, against PRD v8,
  and stays the record of that. The PRD states neither when the repository becomes public nor how
  its CI is paid for, so neither lands as a requirement here; C-7 already binds the channel to the
  first public release *(re: C-12, C-7, AC-14, RN-24; PRD source: Assumptions "Public identity")*.
- **RN-39:** *(changed — FR-20, AC-11; added — FR-35, AC-26, C-12's public history, AC-14's two
  clauses, §2's beta paragraph; upstream: PRD v17 – v18)* PRD v17 and v18 make the first public
  release a beta below 1.0.0 that comes once the tree and the open file follow the disk and
  Markdown reads rendered, and waits neither for the Git view to follow the disk nor for choosing
  a theme and keeping that choice; both are in place before 1.0.0 (`docs/PRD.md` § Scope (In),
  "The first public release — a beta"; owner: `docs/trail/prd/cycle-15.md` § 3.1,
  `docs/trail/prd/cycle-16.md` § 3.1). The owner confirmed the fold, with four additions, at
  `docs/trail/srs/cycle-12.md` § 2.1; its reasoning is `docs/trail/srs/self_answer-4.md` § 2.1.
  **FR-20 is narrowed, not emptied:** what moves past the beta is the choice and its keeping, so
  FR-20 keeps its trace to § UX Notes "dark and light themes from the start" and states that both
  themes and the kept choice are in place before 1.0.0; the beta is not held to the themes, on
  § Scope (In)'s own words, not on C-6, which says only that anything may change before 1.0.0.
  AC-11 follows and, because FR-20 now names the kept choice, checks it across a restart (FR-21).
  **FR-35 carries the beta's statement as a system state, not a release** — the way RN-37 worded
  FR-13 — so §2's rule that delivery timing stays out of this document holds; it traces to § UX
  Notes "the view never lies" (the rule sentence and its beta bullet) and to § Scope (In). That the
  statement is absent where Git state is followed is the same rule's consequence: a statement that
  the state is from open, shown beside a followed state, would present the view as staler than it
  is. FR-34 bounds it — no message in a plain folder's Git view — so the case of a repository
  created at the root after open, in the read-at-open state, has no surface that could say so
  without breaking FR-34; it is named in FR-35 and told only in the README's known gaps, which
  AC-14's release inspection checks, beside C-9's README items. FR-14 gains a pointer to FR-35 and
  the PRD's "stays part of what v1 means"; FR-14's Git half, FR-33's live clause and AC-7's Git
  clauses keep their content. FR-34's list of Git-derived presentations gains FR-35, which in a
  plain folder presents nothing. **C-12 gains the public history:** the repository goes public
  with its own commit history, once that history is checked for anything private (`docs/PRD.md`
  § Assumptions, "Public identity"), carried on C-7's footing — a repository obligation that binds
  before the first public release and is checkable at release — so AC-14 inspects it; RN-24's
  "archived visibly" landed as no requirement because it is an act after maintenance ends, which
  this is not. The beta is the first public release for C-4, C-7 and AC-14, whose existing
  clauses stand. The beta's purpose — to be used and shown as the public evidence of what
  kensaiapp builds, linked from kensaiapp's public repository — is a product reason with no system
  behaviour and lands as no requirement *(re: FR-14, FR-20, FR-34, FR-35, C-12, AC-11, AC-14,
  AC-26, §2; PRD source: Scope (In), UX Notes "the view never lies", Assumptions "Public
  identity")*.
- **RN-40:** *(reverse walk, PRD v16 → v18; the finish line's path)* Every unit PRD v17 – v18 moved
  lands in RN-39 or here: the Version line restates § Scope (In) and § Assumptions; the § UX Notes
  rule sentence and its new bullet are FR-35's; § Scope (In)'s beta paragraph is §2's, FR-20's,
  FR-35's and AC-14's; § Assumptions "Public identity" is C-12's. The PRD's remaining v18 edits
  rename its pointer to the project's done — "Agari", at `system/projects/ka-reader/agari.md`,
  now the finish line at `system/projects/ka-reader/finish_line.md` (`docs/PRD.md` § Out of
  Scope, § UX Notes "The bounds v1 draws", § Assumptions "Versioning") — and move no product fact.
  The old path is gone from the instance (`<CORE>/doctrine/setup/kensaiapp_structure.md` § 6,
  the migration map), so §2, §5.1, RN-26 and RN-31 now name the finish line and its path; the
  terminus they describe is the same file. Elsewhere in these notes "the Agari" stays as written
  and names that same finish line. No other PRD unit moved between v16 and v18 *(re: §2, §5.1,
  RN-26, RN-31; PRD source: Out of Scope, UX Notes, Assumptions)*.
