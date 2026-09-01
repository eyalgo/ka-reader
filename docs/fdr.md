# FDR — Nozoki 覗き

**Status:** Draft
**Owner:** Principal PM
**Version:** 1 — the behavioural contract stated for the first time, over the whole surface the terminus names: one local folder — a plain folder or a repository — read through the tree, the reading panel, the Git view, the live refresh, and, beyond v1, the diff, the history and the folder selector; with the product decisions the SDD settled against the settled requirements (the folder chosen through the Open panel, an unsigned `.dmg` from a GitHub Release as the one path, macOS 14 as the floor, recognition by extension over a fixed set, Markdown rendered with in-folder images loaded).

> The FDR is the product's **behavioural contract**: what the product does, and the product decisions
> every change after it is built against. It is written once per product from the PRD, the SRS and the
> SDD, and read cold by the Principal Architect (ADR / NFDR), the PM, the Product Owner specifying a
> change, and the QA seat deriving acceptance. It is updated in place with versioning (bump the line
> above on each material change); every delta in a revision traces to an owner answer or directive, or
> to a change in one of the three upstream documents.
> **Keep the *how* out.** Module names, layer names, file paths, class and method names, protocols and
> data-structure design belong to the SDD and to the Principal Architect's ADR;
> `<CORE>/prompts/principal_pm_create_fdr.md` § The altitude test owns the test that draws the line.
> **Every entry carries a stable typed ID** — `R-n` a rule, `PD-n` a product decision, `OOS-n` an
> out-of-scope entry, `RN-n` a review note — so an acceptance criterion, a change spec, or a later
> revision cites one entry rather than a paragraph. An ID is never reused and never renumbered.
> **Every rule and product decision carries an inline trace tag** naming which upstream document it
> realizes and where: `*(traces to: SRS § 3.1 FR-2)*`, `*(traces to: PRD § Core Features)*`,
> `*(traces to: SDD § 4)*`.
> Omit a section only when it genuinely does not apply; do not pad one to fill it.

---

## Description

Nozoki is a local, read-only reader of folders, files and repositories — the three named flat, none subordinate to another — for a developer who must not disturb the folder they are looking at, above all one a coding agent or automated tool is changing while they watch. It presents one local folder's tree, reads its files with syntax highlighting, follows the folder as it changes on disk, and, where the folder is itself the root of a Git repository, reads that repository's state, its diffs and its history — while provably changing nothing about the folder. The PRD's edge is that the guarantee *is* the product: there is no write path to configure away (`docs/PRD.md` § Purpose, § Why This). This document states the behaviour that guarantee and that surface amount to, and the decisions a later change honours or escalates. Where a rule says *beyond v1*, the phrase is the PRD's own scope line (`docs/PRD.md` § Scope (In), § Out of Scope) carried through the SRS: it marks product scope inside the terminus, never when a thing is built.

---

## Rules

### The viewed folder — start, input, leaving

- **R-1:** The product operates against exactly one local folder per session. *(traces to: SRS § 3.1 FR-1)*
- **R-2:** The only input the product requires is which folder to view; no settings, no project file and no setup step exists. *(traces to: SRS § 3.1 FR-1; § 4.7 NFR-14)*
- **R-3:** The folder is chosen through the operating system's Open panel; the product accepts no typed path and no launch argument as the folder. *(traces to: SDD § 4 C-R3)*
- **R-4:** Until the folder selector (R-121) exists, the Open panel is presented at every launch and the folder chosen is the session's. *(traces to: SRS § 3.1 FR-2; SDD § 4 C-R3)*
- **R-5:** Once the folder selector exists, launch restores the last-viewed folder without asking, and presents the Open panel only when no folder is remembered or the remembered folder no longer resolves. *(traces to: SDD § 4 C-R3)*
- **R-6:** Whether the folder is a Git repository is found by the product and never asked of the user. *(traces to: SRS § 3.1 FR-1, FR-33; PRD § Success Metrics "Zero required configuration")*
- **R-7:** Pointed at a path that does not exist, is not a folder, or cannot be read, the product states — in its own window, never on a terminal — what it tried to open, what it observed, and what to do next, and touches nothing. *(traces to: SRS § 3.1 FR-3; SDD § 4 C-R3)*
- **R-8:** The startup-failure surface carries a way to choose a folder again and a way to quit. *(traces to: SDD § 4 C-R3)*
- **R-9:** A readable folder that is not a Git repository is not a startup failure: it opens. *(traces to: SRS § 3.1 FR-3, FR-34)*
- **R-10:** No onboarding surface and no configuration surface exists; the shell is usable the moment the folder appears. *(traces to: SRS § 5.1 User Interface; PRD § UX Notes "The path" step 1)*
- **R-11:** Closing the product asks nothing — no save prompt, no confirmation — at any moment, a file open or a refresh mid-flight included. *(traces to: SRS § 3.1 FR-23; § 8 AC-21)*

### Is the folder a repository — the root finding

- **R-12:** Git state is read only when the opened folder is itself the top level of a Git working tree. *(traces to: SRS § 3.1 FR-33; PRD § Core Features)*
- **R-13:** A folder inside a repository — one whose repository root is an ancestor of the opened folder — opens as a plain folder. *(traces to: SRS § 3.1 FR-33; PRD § Out of Scope "Git found anywhere but at the opened folder's root")*
- **R-14:** A folder that contains repositories opens as a plain folder. *(traces to: SRS § 3.1 FR-33)*
- **R-15:** The top level of a linked worktree, and a submodule's own folder, each count as a repository root. *(traces to: SRS § 3.1 FR-33)*
- **R-16:** A bare repository has no working tree and opens as a plain folder. *(traces to: SRS § SRS Review Notes RN-32)*
- **R-17:** Finding out creates nothing in the folder — no `.git`, no entry of any kind. *(traces to: SRS § 3.1 FR-33; § 4.3 NFR-5)*
- **R-18:** The finding is live: a repository appearing at the opened folder's root during a session, or leaving it, is followed as a change in Git state within the refresh bar (R-75). *(traces to: SRS § 3.1 FR-33; § 8 AC-7)*
- **R-19:** Before the product has found whether the folder is a repository, the Git view shows that it is pending — never a clean tree and never nothing. *(traces to: SDD § 4 C-E1, C-I1)*
- **R-20:** Where the finding stopped for a reason the product cannot name, the Git view shows a fault (R-91), never nothing. *(traces to: SDD § 4 C-E2, C-I1)*
- **R-21:** Where the opened folder is a repository root whose Git directory lies outside the folder — a linked worktree or a submodule pointing out — the Git view presents a failure state naming the folder that would need to be chosen for Git state to be read, and the tree and the reading panel are unaffected. *(traces to: SDD § 11 R-3)*

### The plain folder

- **R-22:** In a plain folder the tree, the reading panel, the empty state and the live refresh behave exactly as they do in a repository. *(traces to: SRS § 3.1 FR-34; PRD § Key Use Cases 4)*
- **R-23:** In a plain folder the Git view is present and shows nothing: no message, no label, no explanation, no control, and nothing that invites creating or initialising a repository. *(traces to: SRS § 3.1 FR-34; PRD § Core Features)*
- **R-24:** In a plain folder the tree carries no changed-file markers. *(traces to: SRS § 3.1 FR-34; § 3.2 FR-6)*
- **R-25:** In a plain folder the diff and the history present nothing and cannot be reached. *(traces to: SRS § 3.1 FR-34; § 3.6 FR-17, FR-18)*
- **R-26:** In a plain folder the product needs nothing from Git. *(traces to: SRS § 3.1 FR-34; PRD § Dependencies / Integrations (Conceptual))*
- **R-27:** The shell chrome carries the folder's identity and the theme control and no third element; no mark elsewhere says whether the folder is a repository. *(traces to: SDD § 4 C-E9)*

### The file tree

- **R-28:** The product presents the viewed folder's files and folders as a navigable tree. *(traces to: SRS § 3.2 FR-5)*
- **R-29:** Every entry in the folder appears in the tree, entries whose names begin with a dot and the `.git` entry included; nothing is hidden. *(traces to: PRD § Goals "Inspection without risk" — "browse and read anything in the folder"; SRS § 3.2 FR-5; added — RN-4)*
- **R-30:** Within a folder, sub-folders are listed before files, and each group is ordered by name, compared without regard to letter case. *(added — RN-4)*
- **R-31:** At arrival the root's entries are shown and every sub-folder is collapsed. *(added — RN-4)*
- **R-32:** A folder the product has not yet read shows that it is pending, never that it is empty. *(traces to: SDD § 4 C-E1)*
- **R-33:** An entry the product cannot read is marked with what the product observed, and the rest of the tree stands. *(traces to: SRS § 4.2 NFR-3; SDD § 4 C-E2)*
- **R-34:** A symbolic link whose target lies inside the viewed folder is read as its target; one whose target lies outside the viewed folder is presented as an entry that cannot be read. *(traces to: SDD § 3 `fs-reader` — the containment check; § 4 C-D1; added — RN-5)*
- **R-35:** In a repository, each file Git reports as changed is marked in the tree. *(traces to: SRS § 3.2 FR-6)*
- **R-36:** A changed-file marker is drawn only after Git state has been observed; before that, no marker is drawn. *(traces to: SDD § 4 C-E1)*
- **R-37:** A changed-file marker carries a status letter beside the file name; colour repeats the letter and never replaces it. *(traces to: SDD § 4 C-E6)*
- **R-38:** Resting the pointer on a status letter shows the file's name and the letter's meaning in words; no other element in the product raises a tooltip. *(traces to: SDD § 4 C-E6)*
- **R-39:** The selected file is highlighted in the tree, with a cue that survives without colour. *(traces to: SRS § 3.2 FR-7; SDD § 4 C-E6)*

### Reading a file

- **R-40:** Selecting a file displays its content read-only in the reading panel. *(traces to: SRS § 3.3 FR-8)*
- **R-41:** The reading panel shows the open file's folder-relative path with its content, on every treatment of the panel. *(traces to: SDD § 4 C-E9)*
- **R-42:** A file in one of the six floor languages — Python, shell, JavaScript, JSON, YAML, TOML — is displayed with that language's syntax highlighting. *(traces to: SRS § 3.3 FR-8; PRD § Core Features)*
- **R-43:** A floor language is recognized by the file's last extension alone, compared without regard to letter case, and never by the file's content. *(traces to: SRS § 3.3 FR-29; SDD § 3 "The floor-language extension set")*
- **R-44:** The extension set is: Python `.py` `.pyi` `.pyw`; shell `.sh` `.bash` `.zsh`; JavaScript `.js` `.mjs` `.cjs` `.jsx`; JSON `.json` `.jsonc`; YAML `.yaml` `.yml`; TOML `.toml`; Markdown `.md` `.markdown`. *(traces to: SDD § 3 "The floor-language extension set"; SRS § 3.3 FR-29)*
- **R-45:** A text file with no extension, or with an extension outside the set in R-44, is displayed as plain text — never refused, and never with another language's highlighting. *(traces to: SRS § 3.3 FR-29; PRD § Core Features)*
- **R-46:** A file whose bytes decode as UTF-8, with or without a byte-order mark, is text; a file whose bytes do not is a file that cannot be shown as text. *(added — RN-3)*
- **R-47:** A file that cannot be shown as text is presented, not rendered: a placeholder names the file and states that its content is not shown as text, the shell stays fully usable, and the file is not modified. *(traces to: SRS § 3.3 FR-10; PRD § UX Notes "Failure states")*
- **R-48:** No interaction with displayed content changes it or the file on disk — typing, pasting and dropping into the reading panel produce no modification, on screen or on disk. *(traces to: SRS § 3.3 FR-9; § 8 AC-4)*
- **R-49:** The product presents no editing affordance, enabled or disabled, and no framing that implies an editable mode exists elsewhere. *(traces to: SRS § 3.3 FR-24; SDD § 4 C-E3)*
- **R-50:** Selecting a file displays its content with no perceived wait. The numeric threshold is undecided; the CTO sets it in the SRS by revision, from measurement on the first working build. *(traces to: SRS § 4.1 NFR-1; § SRS Review Notes RN-4; SDD § 4 C-I4)*
- **R-51:** A file the product cannot read is presented in the reading panel as a statement of what the product was doing and what it observed; the tree beside it stays enabled, and the file is shown once it is readable again. *(traces to: SRS § 4.2 NFR-3; SDD § 4 C-E2)*
- **R-52:** Content read from the folder is displayed and never executed: no script runs, no active content loads, and no file content is resolved as a URL. *(traces to: SRS § 4.3 NFR-16; SDD § 4 C-D3)*

### Markdown

- **R-53:** A Markdown file is displayed rendered by default. *(traces to: SRS § 3.3 FR-30; PRD § Core Features)*
- **R-54:** A release that ships no switch from the rendered view to the raw source states so where the release is offered. *(traces to: SRS § 3.3 FR-31; PRD § Core Features)*
- **R-55:** Where a release ships the raw-source switch, switching shows the file's source byte-for-byte as it is on disk, switching back restores the rendered view, and the file is unmodified throughout. *(traces to: SRS § 8 AC-22)*
- **R-56:** Rendering a Markdown file fetches nothing from outside the viewed folder. *(traces to: SRS § 3.3 FR-32)*
- **R-57:** A remote image, or any other remote resource a Markdown file references, is not loaded; where the image would appear, a placeholder states that remote content is not fetched. *(traces to: SRS § 3.3 FR-32; SDD § 3 `markdown-renderer`; § 9 TO-6)*
- **R-58:** An image whose reference resolves to a file inside the viewed folder is loaded and rendered in place. *(traces to: SDD § 9 TO-6; § 3 `markdown-renderer`)*
- **R-59:** An image whose reference resolves, symbolic links followed, to a path outside the viewed folder is never loaded and takes the same placeholder as a remote image. *(traces to: SDD § 4 C-D3; § SDD Review Notes RN-26; added — RN-8)*
- **R-60:** An external link in a rendered Markdown file is displayed with its destination readable and is not followed: activating it opens nothing and hands nothing to another program. *(traces to: SRS § 3.3 FR-32)*
- **R-61:** Activating a relative link to a file inside the viewed folder opens that file in the reading panel exactly as selecting it in the tree does. *(traces to: SRS § 3.3 FR-32; SDD § SDD Review Notes RN-10; § 3 `markdown-renderer`)*
- **R-62:** Activating a relative link whose target is not a file inside the viewed folder does nothing. *(traces to: SDD § 4 C-D3; § 3 `markdown-renderer`)*

### The sidebar and the Git view

- **R-63:** The sidebar toggles between a Files view and a Git view, and nothing else. *(traces to: SRS § 3.4 FR-11; SDD § 4 C-E9)*
- **R-64:** Switching the sidebar between Files and Git never closes or changes the file being read, and never moves the reading position. *(traces to: SRS § 3.4 FR-25; § 8 AC-17)*
- **R-65:** Where the folder is a repository, the Git view presents the repository's changed files, its staged files, its branch name, and a short repository status. *(traces to: SRS § 3.4 FR-12; PRD § Core Features)*
- **R-66:** The changes the Git view and the tree report are Git's own status categories: added, modified, deleted, renamed, untracked, and in conflict. *(traces to: SDD § 3 `git-reader`, entity GitState — "changed and staged files with status letters"; added — RN-6)*
- **R-67:** The distinction between staged and unstaged changes is carried by the heading a file sits under, or a word beside it, never by hue alone. *(traces to: SDD § 4 C-E6)*
- **R-68:** A count of changes, and a statement that nothing has changed, are shown only after Git state has been read; a clean repository's Git view states that nothing has changed. *(traces to: SDD § 4 C-E1)*
- **R-69:** Where the diff (R-111) does not exist, activating a changed file's row in the Git view opens the file for reading exactly as a tree selection does. *(traces to: SRS § 3.4 FR-13)*
- **R-70:** Where the diff (R-111) exists, activating a changed file's row in the Git view opens that file's diff; the row has one click target, the status letter is a label and not a second one, and the file itself is read by selecting it in the tree. *(changed — RN-1; source: SDD § SDD Review Notes RN-20)*
- **R-71:** A repository mid-operation — a merge, a rebase, a cherry-pick, a revert, a bisect, or a detached HEAD — is presented by the Git view as the state it is truly in, never as an error. *(traces to: SRS § 3.4 FR-26; SDD § 3 entity GitState)*
- **R-72:** Where Git state is transiently unreadable — a lock file present, a file mid-write — the Git view shows what the product observed for that item and recovers on a later refresh. *(traces to: SRS § 4.2 NFR-3; § 8 AC-8)*
- **R-73:** *(beyond v1)* The commit history is opened from the Git view. *(traces to: SDD § SDD Review Notes RN-20)*

### Live refresh

- **R-74:** A change on disk — file content, the tree, or Git state — appears in the view automatically, with no user action. *(traces to: SRS § 3.5 FR-14; PRD § Core Features "Live refresh")*
- **R-75:** A change on disk appears within a few seconds. The numeric threshold is undecided; the CTO sets it in the SRS by revision, from measurement on the first working build. *(traces to: SRS § 4.1 NFR-2; § SRS Review Notes RN-4; SDD § 4 C-I4)*
- **R-76:** The product has no manual refresh control. *(traces to: SRS § 3.5 FR-15)*
- **R-77:** The viewed folder may be changed by another process at any moment — files created, modified or deleted, the open file included, and Git metadata mid-operation — and none of it crashes the shell, blocks the view, or causes a write; the view converges to the state on disk. *(traces to: SRS § 3.5 FR-16; § 8 AC-8)*
- **R-78:** An automatic update never takes the user's place away: the tree nodes they expanded, the file they have open, the sidebar mode, and the position they are reading survive every refresh. *(traces to: SRS § 3.5 FR-27; SDD § 4 C-E4)*
- **R-79:** When the open file changes on disk, its content updates in place. *(traces to: PRD § UX Notes "the view never lies"; SRS § 3.5 FR-14)*
- **R-80:** When the open file disappears from disk, the reading panel keeps the file's name and states plainly that it is gone; the vanished content is not shown as current. *(traces to: SRS § 3.5 FR-28; § 8 AC-20)*
- **R-81:** What is shown is the folder's current state within the refresh bar, or is explicitly marked as no longer there; stale content is never presented as current. *(traces to: SRS § 3.5 FR-28; PRD § UX Notes "the view never lies")*
- **R-82:** An update arrives in place with no transition, no flash and no attention bid; only what changed changes. *(traces to: SDD § 4 C-E4)*
- **R-83:** A failure state is replaced by the next successful read of the same item, without any message announcing the recovery. *(traces to: SRS § 4.2 NFR-3; SDD § 4 C-E4)*
- **R-84:** The immediacy bars (R-50, R-75) hold across realistic folder scale — file count, tree depth, individual file size, history length. The reference sizes are undecided; the CTO fixes them in the SRS by revision alongside the thresholds. *(traces to: SRS § 4.4 NFR-10; § SRS Review Notes RN-4)*

### Failures and faults — every surface

- **R-85:** A failure to read one file, one tree entry, or one part of Git state degrades only that item's presentation, visibly; the shell as a whole never blocks. *(traces to: SRS § 4.2 NFR-3)*
- **R-86:** Every failure state is presented on the surface whose work stopped, in that item's own slot, with an enabled route out on the same surface — the tree, the selector, or a way back. *(traces to: SDD § 4 C-E2)*
- **R-87:** No modal, toast, dialog or terminal line carries a failure. *(traces to: SDD § 4 C-E2)*
- **R-88:** Every message the product writes states what the product was doing, what it observed, and what to do next — or that nothing can be done and what ends the wait — pitched at the no-learning-curve bar: someone who works with Git and can follow a README. The wording standard is `docs/CONTENT.md`'s. *(traces to: SRS § 3.1 FR-3; § 4.7 NFR-15; SDD § 4 C-E2)*
- **R-89:** No message names a cause the product did not observe, and no internal diagnostic text reaches any surface. *(traces to: SDD § 4 C-E2)*
- **R-90:** A failure the user must know about is visible in the product's own window. *(traces to: SRS § 4.5 NFR-11)*
- **R-91:** An unexplained fault — the product stopped one item's work and nothing it read accounts for it — is shown in that item's failure slot as a fault: it states that the work stopped and what still works, and is drawn neither as pending nor as nothing. *(traces to: SDD § 4 C-E2, C-I1)*
- **R-92:** No control on any surface reveals, expands or copies a fault's detail, and no message asks the reader to report it. *(traces to: SDD § 4 C-E2)*
- **R-93:** Any diagnostic the product keeps lives with its own state on the machine — never inside the viewed folder, never transmitted, and never holding file content. *(traces to: SRS § 4.5 NFR-11; SDD § 4 C-I2)*
- **R-94:** No indicator is drawn before the product has observed the state it stands for; where the product does not yet know, the surface shows the word *pending*, and no spinner or progress bar is drawn. *(traces to: SDD § 4 C-E1)*

### The read-only promise

- **R-95:** The product performs no write inside the viewed folder — no file or directory created, modified or deleted anywhere under the folder's path, `.git` included — under any operation. *(traces to: SRS § 4.3 NFR-5; PRD § Success Metrics "Read-only integrity")*
- **R-96:** Where the folder is a repository, the product performs no Git mutation — no checkout, stash, index or commit operation — and the repository's full Git state (refs, HEAD, index, stash, objects) is identical before and after any session. *(traces to: SRS § 4.3 NFR-6; § 8 AC-2)*
- **R-97:** The product collects and transmits nothing about its users or their usage — no telemetry, no account, no identity, no behavioural data. *(traces to: SRS § 4.3 NFR-7; PRD § Data & Privacy)*
- **R-98:** The product makes no network call during operation — none; acquiring the product is not operation. *(traces to: SRS § 4.3 NFR-8; PRD § Data & Privacy)*
- **R-99:** R-95 – R-98 hold during and after crashes and abnormal exits, not only in normal operation. *(traces to: SRS § 4.2 NFR-4)*
- **R-100:** The bar on R-95 – R-98 is zero violations, reckoned at every release; a single violation is a release-blocking defect. *(traces to: SRS § 4.3 NFR-9; PRD § Success Metrics "Read-only integrity")*
- **R-101:** The product reads nothing outside the viewed folder except its own data location on the machine. *(traces to: SDD § 4 C-D1; § 3 seam 4)*
- **R-102:** The only writes the product performs land in its own data location on the machine. *(traces to: SDD § 4 C-D2; SRS § 3.7 FR-21)*
- **R-103:** Everything a surface renders ships with the product or is the platform's own; no font, icon, image, stylesheet or script is fetched at runtime, and every surface renders whole with the network unavailable. *(traces to: SDD § 4 C-E5; SRS § 4.3 NFR-8)*
- **R-104:** Every state distinction — a status letter, the staged/unstaged split, the selection, the active sidebar entry — carries a letter, word, shape or position that survives without colour, and every glyph sits beside its word. *(traces to: SDD § 4 C-E6)*

### Themes, and what the product remembers

- **R-105:** The product offers a dark and a light theme from the first release, both first-class. *(traces to: SRS § 3.7 FR-20; § 8 AC-11)*
- **R-106:** The initial theme follows the platform's reported appearance; where none can be read, the initial theme is light. *(traces to: SDD § SDD Review Notes RN-19)*
- **R-107:** A control in the shell chrome switches the theme. *(traces to: SDD § 4 C-E9)*
- **R-108:** The theme choice, the window state, and — beyond v1 — the remembered folders and which was viewed last persist between sessions in the product's own data location on the machine, never inside the viewed folder. *(traces to: SRS § 3.7 FR-21; § 6 DR-5; SDD § 3 entity OwnState)*
- **R-109:** Nothing else is persisted: the product's own state holds nothing personal and no content of the viewed folder, and a remembered folder is a reference to it and a display name. *(traces to: SRS § 6 DR-5; § 8 AC-13; SDD § 4 C-D4)*
- **R-110:** The only state a user can change is the product's own remembered state, and each such change is reversible by the control that made it. *(traces to: PRD § Data & Privacy; SRS § 6 DR-5)*

### Beyond v1, inside the terminus — the diff

- **R-111:** *(beyond v1)* For any file the Git view reports as changed, the product presents its changes read-only, with staged changes distinguished from unstaged ones rather than collapsed into one working-versus-committed view. *(traces to: SRS § 3.6 FR-17)*
- **R-112:** *(beyond v1)* Three diffs exist: unstaged — the index against the working tree; staged — the last commit against the index; and a commit's — its parent against it. *(traces to: SDD § 3 entity Diff; SRS § 3.6 FR-17, FR-22)*
- **R-113:** *(beyond v1)* A diff is shown in the reading panel, under the same path line as a file. *(traces to: SDD § 4 C-E9)*
- **R-114:** *(beyond v1)* A diff's staged and unstaged parts are separated by a heading, never by hue. *(traces to: SDD § 4 C-E6)*

### Beyond v1, inside the terminus — the history

- **R-115:** *(beyond v1)* The product presents the repository's commit history read-only; where the history holds more than one branch, the reader sees the branches as branches — which commits belong to which, and where they diverge and merge — never a flat list that flattens them together. *(traces to: SRS § 3.6 FR-18)*
- **R-116:** *(beyond v1)* The history is presented against a chosen set of branches — one, several, or all — with a default that asks nothing: the current branch and what relates to it. *(traces to: SRS § 3.6 FR-18)*
- **R-117:** *(beyond v1)* The default set is the branch HEAD is on plus every local branch whose merge-base with HEAD lies inside the loaded window of commits; only local branches are offered for choosing. *(traces to: SDD § SDD Review Notes RN-16; added — RN-9)*
- **R-118:** *(beyond v1)* Per commit the history shows its identifier, message, author and date, and its changed files are reachable from its entry. *(traces to: SRS § 3.6 FR-18)*
- **R-119:** *(beyond v1)* Selecting a commit presents what that commit changed, read-only, in the same diff presentation as R-111. *(traces to: SRS § 3.6 FR-22)*
- **R-120:** *(beyond v1)* The history loads a bounded window of commits before it is drawn. The window's size is undecided; the CTO fixes it in the SDD from measurement, alongside R-84's reference sizes. *(traces to: SDD § Open Questions — the loaded window)*

### Beyond v1, inside the terminus — switching the viewed folder

- **R-121:** *(beyond v1)* The user can switch which folder is viewed without restarting the product — always exactly one at a time — through a folder selector in the shell chrome whose label is the current folder's name. *(traces to: SRS § 3.6 FR-19; SDD § 4 C-R3, C-E9)*
- **R-122:** *(beyond v1)* The selector lists the folders the product remembers, with a browse entry that opens the Open panel; on first run the list holds only the browse entry. *(traces to: SDD § 4 C-R3; § 3 entity OwnState)*
- **R-123:** *(beyond v1)* The folder switched to is any folder R-1 admits, and R-12 is applied to it afresh. *(traces to: SRS § 3.6 FR-19)*
- **R-124:** *(beyond v1)* Choosing a folder returns the shell to its arrival state for that folder — the tree shown, the reading panel empty, the Git view per the new finding. *(traces to: SRS § 3.6 FR-19; SDD § SDD Review Notes RN-26)*
- **R-125:** *(beyond v1)* A remembered folder is re-opened without asking. *(traces to: SDD § 4 C-R3)*
- **R-126:** *(beyond v1)* A chosen path that does not exist, is not a folder, or cannot be read gets the same statement as R-7, the previously viewed folder stays viewed, and nothing about either folder changes. *(traces to: SDD § SDD Review Notes RN-26; SRS § 3.1 FR-3)*
- **R-127:** *(beyond v1)* Switching replaces the viewed folder and never adds a second one. *(traces to: SRS § 3.6 FR-19; PRD § Out of Scope "Several folders at once")*

### The release, the README, and the first five minutes

- **R-128:** There is exactly one way to acquire the product: a GitHub Release on `github.com/kensaiapp/nozoki` carrying `Nozoki-<version>.dmg` and a `SHA256SUMS` file. *(traces to: SRS § 7 C-3, C-12; SDD § 4 C-R4)*
- **R-129:** The install path is: download the `.dmg`, drag `Nozoki.app` to Applications, and on first launch take the one System Settings › Privacy & Security step macOS requires for software that is not notarized; the README's first screen names all three as the exact click path. *(traces to: SDD § 4 C-R4; § 11 R-2)*
- **R-130:** No terminal command is ever the documented route to install or start the product. *(traces to: SDD § 4 C-R4)*
- **R-131:** The install path requires no prerequisite, no clone of the source repository, and no build from source. *(traces to: SRS § 7 C-3; SDD § 4 C-R1)*
- **R-132:** Every release's `SHA256SUMS` matches its artifact, and the artifact is built from the release's tagged commit; a release with no build from its tag is not offered. *(traces to: SDD § 4 C-R4; § 11 R-7)*
- **R-133:** The product runs on macOS 14 (Sonoma) or later, and the floor is stated wherever the install path is offered. *(traces to: SDD § 4 C-R5; SRS § 7 C-11)*
- **R-134:** From a stranger deciding to try the product — README alone, on macOS, the Privacy & Security step included — to viewing a file of their own repository takes at most five minutes; the check is a timed manual walk before each release. *(traces to: SRS § 4.7 NFR-13; § 8 AC-10; SDD § 9 TO-9)*
- **R-135:** The README's first screen carries what the product does in one sentence, the one install path, one copy-paste example, and what the product will and will not touch. *(traces to: SRS § 7 C-9; PRD § Goals "Pick-it-up adoption")*
- **R-136:** The README's one-sentence description does not call the product a web app. *(traces to: SRS § 8 AC-14; PRD § Out of Scope)*
- **R-137:** The README states that sidebar search / filter, pane resizing and keyboard navigation are outside what the product is built to become, and promises none of them. *(traces to: SRS § 8 AC-14; PRD § Out of Scope)*
- **R-138:** The README states the support posture in the PRD's own terms — *"Issues and questions are welcome and read when there is time, with no response time, no commitment to fix, and no commitment that a fix ever arrives"* (`docs/PRD.md` § Assumptions, "Support posture") — and promises nothing beyond it. *(traces to: SRS § 7 C-13)*
- **R-139:** The README carries the accessibility posture sentence below its first screen, in the wording `docs/CONTENT.md` § Standing sentences fixes, and nowhere the product speaks is a conformance standard or number claimed. *(traces to: SDD § 4 C-E7; SRS § 5.1 User Interface)*
- **R-140:** Every public picture of the shell shows the product as the release it accompanies renders it, and every image the README shows is served from the repository. *(traces to: SDD § 4 C-E10, C-E5)*
- **R-141:** Every release carries the MIT licence and the licence notices of every third-party component it ships. *(traces to: SRS § 7 C-4, C-5)*
- **R-142:** From the first 1.0.0 release, releases are semantically versioned and a breaking change to the product's public contract takes a major version; before 1.0.0, the fact that anything may change is stated wherever a release is offered. *(traces to: SRS § 7 C-6; PRD § Assumptions "Versioning")*
- **R-143:** Before the first public release, private vulnerability reporting is enabled on the repository R-128 names, and a `SECURITY.md` states where to report and the posture the PRD sets — *"Security reports have a private channel and are read, with no acknowledgement or response time promised"* (`docs/PRD.md` § Assumptions, "Support posture") — promising nothing beyond it. *(traces to: SRS § 7 C-7)*
- **R-144:** The product is usable without instruction by anyone who works with Git and can follow a README, and may leave Git's own vocabulary unexplained; this is verified by first-use inspection before each release. *(traces to: SRS § 4.7 NFR-15; PRD § Goals "No learning curve")*
- **R-145:** The check that nothing has been written to a viewed repository and to a viewed plain folder, that Git state is identical before and after a session, and that a session produces zero outbound network traffic, runs at every release, with the whole product surface exercised. *(traces to: SRS § 8 AC-1, AC-2, AC-3; § 4.3 NFR-9)*

---

## Product decisions

- **PD-1:** Nozoki is viewer-only, permanently: no write path to the viewed folder exists in any version, and adding one would be a different product. *(traces to: SRS § 7 C-2; PRD § Out of Scope "Editing, permanently")*
- **PD-2:** Nozoki is a reader of folders, files and repositories, the three named flat: a repository is one of the things it reads, not the thing it is for, and a plain folder is an input the whole surface takes, never a capability added to it. *(traces to: PRD § Purpose; SRS § 2 Scope)*
- **PD-3:** Nozoki runs locally, on the user's own machine, against local state; there is no hosted mode. *(traces to: SRS § 7 C-1; PRD § Scope (In) "Run posture")*
- **PD-4:** One folder at a time is the product; what may change is *which* folder, never *how many*. *(traces to: PRD § Out of Scope "Several folders at once"; SRS § 3.6 FR-19)*
- **PD-5:** Git is read only at the opened folder's root; the tree and the Git view always describe the same folder, and Git scoped to a sub-folder of a repository is rejected. *(traces to: PRD § Core Features; § Out of Scope "Git found anywhere but at the opened folder's root")*
- **PD-6:** The read-only integrity bar names four promises separately, none implied by another — no write to the viewed folder, no Git mutation, no telemetry, no non-essential network call — and holds each at zero violations at every release. *(traces to: PRD § Success Metrics "Read-only integrity"; SRS § 4.3 NFR-9)*
- **PD-7:** During operation the product makes no network call at all. The PRD's word *non-essential* is headroom: a future update or version check enters the PRD as a stated feature before it exists, and reaches this contract by revision; until then, none. *(traces to: SRS § 4.3 NFR-8; PRD § Data & Privacy)*
- **PD-8:** The product's own state lives where the product keeps its own data on the machine, never inside the folder it is pointed at. *(traces to: PRD § Data & Privacy; SRS § 3.7 FR-21)*
- **PD-9:** The highlighting promise is the six floor languages and no other; the floor grows only by a PRD revision, which this contract then follows. *(traces to: SRS § 3.3 FR-8; PRD § Core Features)*
- **PD-10:** A floor language is recognized by extension, never by content, and the extension set is the one R-44 carries from the SDD. *(traces to: SRS § 3.3 FR-29; SDD § 3 "The floor-language extension set")*
- **PD-11:** Markdown is rendered by default; the raw-source switch is permitted, not promised, built only if it costs nothing — and the SDD's recorded judgment is that it does not, so it is not built, and every release states rendered-only where it is offered. *(traces to: SRS § 3.3 FR-31; SDD § 9 TO-5; PRD § Core Features)*
- **PD-12:** An image inside the viewed folder is loaded and rendered in place; a remote image is never loaded. *(traces to: SDD § 9 TO-6; SRS § 3.3 FR-32)*
- **PD-13:** An external link is never followed and never handed to another program; a relative link inside the folder opens its target in the reading panel. *(traces to: SRS § 3.3 FR-32; SDD § SDD Review Notes RN-10)*
- **PD-14:** The folder is granted through the operating system's Open panel and never typed; the product's whole authority over the folder is the user's choice of it in that panel. *(traces to: SDD § 4 C-R3, C-D1; § 9 TO-3)*
- **PD-15:** The product ships as one macOS application bundle from a GitHub Release, and GitHub is the only channel: no Mac App Store, no Homebrew cask, no second install path. *(traces to: SDD § 4 C-R1, C-R4)*
- **PD-16:** The release is never Developer ID-signed or notarized, and no Apple Developer Program membership is taken for it — the owner's standing call for every app in the instance, recorded so its cost (the Privacy & Security step inside R-134's five minutes) is stated, not so it is reopened. *(traces to: SDD § 4 C-R4; § 9 TO-9)*
- **PD-17:** The acquisition path presumes no prerequisite and never a build from source. *(traces to: SRS § 7 C-3; SDD § 4 C-R1)*
- **PD-18:** v1 runs on macOS and promises no other platform; the minimum version is macOS 14; Nozoki is done on macOS alone. *(traces to: SRS § 7 C-11; § 2 Scope; SDD § 4 C-R5)*
- **PD-19:** The licence is MIT, and every release carries the licence notices of the third-party components it ships. *(traces to: SRS § 7 C-4, C-5; PRD § Assumptions "Licence")*
- **PD-20:** Releases are semantically versioned from 1.0.0, and reaching 1.0.0 is a product event: after it a breaking change to what users rely on is priced, batched and announced, never casual. *(traces to: SRS § 7 C-6; PRD § Assumptions "Versioning")*
- **PD-21:** The product is published from the `kensaiapp` GitHub organisation and maintained under that name; no personal handle is its public face. *(traces to: SRS § 7 C-12; PRD § Assumptions "Public identity")*
- **PD-22:** Nothing is promised in support: issues, questions and security reports are read when there is time, with no response time, no commitment to fix, and no acknowledgement promised — stated on the README and in `SECURITY.md` in the PRD's own words (R-138, R-143). *(traces to: PRD § Assumptions "Support posture"; SRS § 7 C-7, C-13)*
- **PD-23:** The UI language is English. *(traces to: SRS § 7 C-8; PRD § UX Notes "The bounds v1 draws")*
- **PD-24:** The accessibility posture is mouse-driven with no keyboard model and no focus ring, and that absence is permanent; beyond it, no assistive-technology promise is made and no conformance standard is claimed. *(traces to: SRS § 5.1 User Interface; SDD § 4 C-E7; PRD § UX Notes "The bounds v1 draws")*
- **PD-25:** No state distinction is carried by hue alone and no control by a glyph alone — a rule of design quality inside PD-24, not an assistive-technology promise. *(traces to: SDD § 4 C-E6)*
- **PD-26:** The product exposes no programmatic surface: no API, no command-line interface, no integration point. *(traces to: SRS § 5.2 API)*
- **PD-27:** Nothing the product ships carries a network transport, and every dependency the bundle contains is allowlisted and reviewed as code when it changes. *(traces to: SDD § 4 C-R6)*
- **PD-28:** Every asset a surface renders ships with the product or is the platform's own. *(traces to: SDD § 4 C-E5; SRS § 4.3 NFR-8)*
- **PD-29:** Two things stay replaceable inside the terminus and nothing else does: the mechanism that reads Git state, behind a port whose standing substitute is the installed `git` run so that it refreshes nothing; and the viewed folder, which is an input replaced at runtime and never a structural singleton. The renderer technology and the platform are not replaceable inside the terminus. *(traces to: SDD § 3 seam 2; § 2 force 4; § 9 TO-1, TO-2; SRS § 4.6 NFR-12)*
- **PD-30:** A performance number is measured, never asserted: the file-switch and refresh thresholds and the scale reference sizes reach the SRS by revision from the first working build, and no threshold is written into a change's bar before then. *(traces to: SDD § 4 C-I4; SRS § SRS Review Notes RN-4)*
- **PD-31:** One window, one shell — rail, sidebar, reading panel under one chrome strip — and no settings surface, no onboarding surface, and no second window. *(traces to: SDD § 4 C-E9; SRS § 5.1 User Interface)*
- **PD-32:** Observability is minimal by decision: a failure the user must know about is shown in the window, and any diagnostic stays with the product's own state, never transmitted and never in the folder. *(traces to: SRS § 4.5 NFR-11; SDD § 4 C-I2)*
- **PD-33:** No identity exists — no account, no user record, no device identifier. *(traces to: SDD § 4 C-D1; SRS § 4.3 NFR-7)*
- **PD-34:** The product's position outside the EU Cyber Resilience Act's scope rests on its free, non-monetized, non-commercial character; revisiting that character is the CPO's call and reopens the classification. *(traces to: SRS § 7 C-10; PRD § Assumptions "Regulatory posture")*
- **PD-35:** The history's shape binds properties, not mechanism: branches visible as branches, a chosen set with a default that asks nothing, and the per-commit fields; how it is drawn and what control chooses the set are downstream. *(traces to: SRS § 3.6 FR-18)*
- **PD-36:** The diff distinguishes staged from unstaged, and a commit's diff reuses the same presentation. *(traces to: SRS § 3.6 FR-17, FR-22)*
- **PD-37:** In a plain folder the Git view says nothing — the owner's call over a drafted explanation — and the cost is accepted: an empty view cannot by itself tell a plain folder apart from a repository the product failed to read; a fault the user must know about is shown as a fault (R-91), never as a message in this state. *(traces to: PRD § Core Features; § UX Notes "The path" step 3; SRS § 3.1 FR-34)*
- **PD-38:** Every read path — a file, a tree entry, Git state, the folder at startup — is one that can end in an unexplained fault, from v1 on, and the product presents that class as R-91 states with no detail control. *(traces to: SDD § 4 C-E2, C-I1; § SDD Review Notes RN-4, RN-14)*

---

## Out of scope

- **OOS-1:** Editing, in any version — the product has no write path to the viewed folder. *(traces to: PRD § Out of Scope "Editing, permanently"; SRS § 7 C-2)*
- **OOS-2:** Git operations — staging, committing, pushing, branch switching, discarding, stashing. *(traces to: PRD § Out of Scope "Git operations")*
- **OOS-3:** Creating or initialising a Git repository; the empty Git view offers no way to change what the product found. *(traces to: PRD § Out of Scope "Creating or initialising a Git repository"; SRS § 3.1 FR-34)*
- **OOS-4:** Git found anywhere but at the opened folder's root — a folder inside a repository, or a folder holding repositories, opens as a plain folder in any version. *(traces to: PRD § Out of Scope "Git found anywhere but at the opened folder's root")*
- **OOS-5:** Sidebar search / filter — outside the product's done, not merely beyond v1. *(traces to: `system/projects/nozoki/agari.md`, first condition; PRD § Out of Scope)*
- **OOS-6:** Pane resizing — outside the product's done. *(traces to: `system/projects/nozoki/agari.md`, first condition; PRD § Out of Scope)*
- **OOS-7:** Keyboard navigation — outside the product's done, and the absence of a keyboard-accessibility promise is therefore permanent, not deferred. *(traces to: `system/projects/nozoki/agari.md`, first condition; PRD § UX Notes "The bounds v1 draws")*
- **OOS-8:** History filtering and search — outside done with the sidebar search; the branch-set choice of R-116 is not a filter. *(traces to: SRS § 2 Scope)*
- **OOS-9:** Rich rendering of non-text content — no image preview, no hex viewer; a file that cannot be shown as text lands in R-47's state. *(traces to: PRD § Out of Scope "Rich rendering of non-text content"; SRS § SRS Review Notes RN-14)*
- **OOS-10:** Linux and Windows — done does not wait for a second platform. *(traces to: SRS § 2 Scope; § 7 C-11; PRD § Out of Scope "Linux and Windows")*
- **OOS-11:** Remote or hosted repositories, and any hosted operation of the product. *(traces to: PRD § Out of Scope; SRS § 7 C-1)*
- **OOS-12:** Several folders at once. *(traces to: PRD § Out of Scope "Several folders at once")*
- **OOS-13:** Telemetry, and any network call during operation. *(traces to: PRD § Out of Scope; SRS § 4.3 NFR-7, NFR-8)*
- **OOS-14:** A front end for agent workflows and repository-inspection services — where a next product might go, not where this one docks. *(traces to: `system/projects/nozoki/agari.md`, first condition; SRS § 2 Scope)*
- **OOS-15:** A programmatic surface of any kind. *(traces to: SRS § 5.2 API)*
- **OOS-16:** The Markdown raw-source switch, as a condition of done — permitted, not required, and the SDD's judgment is that it is not built (PD-11). *(traces to: SRS § 2 Scope; SDD § 9 TO-5)*
- **OOS-17:** Relative-link opening as a condition of done — permitted, built by the SDD's judgment (R-61), and no closing-release criterion exercises it. *(traces to: SRS § 2 Scope; SDD § SDD Review Notes RN-10)*
- **OOS-18:** Developer ID signing, notarization, the Mac App Store, a Homebrew cask, or any second install path. *(traces to: SDD § 4 C-R4; § 9 TO-9)*
- **OOS-19:** A typed path, a launch argument, or a command-line way to start the product against a folder. *(traces to: SDD § 4 C-R3; § 9 TO-3)*
- **OOS-20:** A manual refresh control. *(traces to: SRS § 3.5 FR-15; PRD § UX Notes "The path" step 4)*
- **OOS-21:** Hiding any file or folder from the tree. *(traces to: SRS § SRS Review Notes RN-14 — "nothing hidden from the tree")*
- **OOS-22:** A control that reveals, expands or copies a fault's detail, and a message that asks the reader to report one. *(traces to: SDD § 4 C-E2)*
- **OOS-23:** A settings or preferences surface, an onboarding surface, and a second window. *(traces to: SDD § 4 C-E9; SRS § 5.1 User Interface)*
- **OOS-24:** Any report of the repository's relationship to a remote — ahead/behind counts, outgoing changes, remote-tracking branches — the Git view presents the four elements R-65 names and nothing more, and R-98 admits no network. *(traces to: SRS § 3.4 FR-12; § 5.3 External Services; § 4.3 NFR-8)*
- **OOS-25:** An update or version check — the headroom PD-7 names, out until a PRD revision states it. *(traces to: PRD § Data & Privacy; SRS § 4.3 NFR-8)*
- **OOS-26:** A second UI language. *(traces to: SRS § 7 C-8)*
- **OOS-27:** Assistive-technology promises beyond the surface the product already carries. *(traces to: SRS § 5.1 User Interface; PRD § UX Notes "The bounds v1 draws")*

---

## Examples

| Input / Scenario | Expected behaviour | Rule |
|---|---|---|
| The product is launched; the user picks `~/code/app` — a Git repository — in the Open panel | The shell opens: the tree shows `app`'s entries, the reading panel prompts for a file, the Git view is pending until Git state is read and then shows branch, changed files, staged files and status | R-3, R-19, R-65 |
| The user picks `~/Downloads/export` — a folder with no `.git` | The shell opens exactly as above; the Git view, once the finding is made, is present and holds nothing — no text, no control; the tree has no markers | R-9, R-22, R-23, R-24 |
| The user picks `~/code/app/src` — a folder inside a repository | Opens as a plain folder; the Git view shows nothing; the tree shows `src`'s entries only | R-13, R-23 |
| The user picks `~/code` — a folder holding `app/` and `lib/`, each a repository | Opens as a plain folder; no Git state for either child is shown | R-14, R-23 |
| The user picks a linked worktree at `~/wt/feature` whose `.git` file points to `~/code/app/.git/worktrees/feature` | The folder opens; the Git view presents a failure state naming `~/code/app` as the folder that would need choosing; tree and reading work | R-15, R-21 |
| The user picks a path that no longer exists | The window states what was tried, what was observed and what to do next, with a way to choose again and a way to quit; nothing is written | R-7, R-8 |
| The user cancels the Open panel at launch, before any folder exists | *Undecided — `docs/fdr_open_issues.md` § 1.1* | R-4 |
| `git init` is run inside the viewed plain folder mid-session | The Git view fills and the tree's markers appear within the refresh bar, with no message and the reader's place kept | R-18, R-78 |
| The viewed folder holds `README.MD`, `Makefile.py.bak`, `deploy.yml`, and `run` (a shell script whose only marker is `#!/bin/sh`) | `README.MD` renders as Markdown; `Makefile.py.bak` and `run` are plain text; `deploy.yml` is highlighted as YAML | R-43, R-44, R-45 |
| The user selects a PNG file in the tree | The reading panel shows a placeholder naming the file and stating its content is not shown as text; the tree stays usable; the file is untouched | R-47 |
| A Markdown file references `![](https://x.example/a.png)`, `![](img/b.png)` (inside the folder), and `![](../c.png)` (outside) | The remote and the outside images each show the not-fetched placeholder in place; `img/b.png` renders as the image | R-57, R-58, R-59 |
| A Markdown file contains `[docs](https://example.org)` and `[guide](docs/guide.md)` | The external link is shown with its destination readable and does nothing when activated; activating `guide` opens `docs/guide.md` in the reading panel | R-60, R-61 |
| A Markdown file embeds `<script>` and an `onload=` attribute | Nothing executes; no outbound traffic; the file and the product's own state are unchanged | R-52, R-98 |
| The user types into the reading panel, pastes, and drops a file onto it | Nothing changes on screen or on disk | R-48 |
| A file is both staged and further modified in the working tree | It appears under the staged and the unstaged headings; its unstaged diff is index→working tree and its staged diff is last commit→index | R-67, R-112 |
| With the diff not yet built, the user clicks a changed file's row in the Git view | The file opens for reading, as a tree selection would | R-69 |
| With the diff built, the user clicks a changed file's row in the Git view | The file's diff opens in the reading panel; clicking the status letter does the same; to read the file the user selects it in the tree | R-70 |
| The repository is mid-rebase with a conflict | The Git view presents the rebase state and the conflicted file as in conflict; no error state is shown; files still open for reading | R-71 |
| `.git/index.lock` exists while Git state is read | The Git view shows what was observed for that item and recovers on a later refresh; the tree and reading panel are unaffected | R-72, R-85 |
| An agent deletes the open file, then writes it again | The panel keeps the file's name and states it is gone; when it returns, its content replaces the statement with no message | R-80, R-83 |
| The user has three tree nodes expanded, a file open, and is scrolled to line 400 when a refresh arrives | The three nodes stay expanded, the file stays open, the position stays at line 400; only what changed changes | R-78, R-82 |
| The user switches the sidebar to Git and back while reading | The open file and the reading position are unchanged | R-64 |
| The product is launched with the machine's appearance set to dark, and no theme was ever chosen | The shell renders dark; switching to light is remembered in the product's own data location, never in the folder | R-106, R-108 |
| After a session in which the theme was changed, every changed file under `$HOME` is listed | All of them lie under the product's own data location; none lies under the viewed folder | R-102, R-109 |
| *(beyond v1)* The user chooses a folder from the selector that has since been deleted | The same statement as a startup failure appears, the previous folder stays viewed, and nothing about either folder changes | R-126 |
| *(beyond v1)* A repository has `main`, `feature` (branched from `main` 3 commits ago) and `old` (no merge-base inside the loaded window); HEAD is on `main` | The default set is `main` and `feature`; `old` is offered for choosing; the graph shows where `feature` diverges | R-116, R-117 |
| A stranger with a stock macOS 14 machine downloads the `.dmg`, drags the app to Applications, takes the Privacy & Security step, and opens their repository | A file of their own repository is on screen within five minutes; the README's first screen was the only guide | R-129, R-134 |

---

## FDR Review Notes

- **RN-1:** *(changed)* R-70 states that, where the diff exists, a changed file's row in the Git view opens its diff and the file is read from the tree — *because* the owner answered the SDD's question by demonstration: *"the row opens the diff. One click target on the row; the file itself is read by clicking it in the tree"* (`docs/trail/sdd/cycle-1.md` § 1.2), and the SDD carries it (`docs/SDD.md` § SDD Review Notes RN-20). The SRS says otherwise: FR-13, *"A file listed in the Git view can be opened for reading exactly as a tree selection is"* — a genuine contradiction between two of the three sources at the closing release. The owner's trail answer is the later, authorized value, so R-70 follows it and R-69 keeps FR-13 for the product before the diff exists; the departure is routed as a choice to confirm rather than absorbed, and the SRS revision it implies is the CTO's. The UXD's UX-F2 carries the pre-answer text too; the SDD's RN-20 already names it as the CDO's to revise. *(re: R-69, R-70; source: SRS § 3.4 FR-13; SDD § SDD Review Notes RN-20)*
- **RN-2:** *(added — with basis)* R-44 carries the floor-language extension set verbatim from the SDD — *because* FR-29 delegates the set to the SDD by name (*"the full extension set fixed in the SDD"*), AC-5 exercises each extension the set names, and a contract that pointed at the SDD for which files are highlighted would leave the one product-visible fact of R-42 in a document written at a different altitude. *(re: R-43, R-44, PD-10; source: SRS § 3.3 FR-29; SDD § 3 "The floor-language extension set")*
- **RN-3:** *(added)* R-46 states what counts as text — *because* FR-10 names "binary or undecodable content" without saying what decodes, and a builder would otherwise pick an encoding set silently. UTF-8 with or without a byte-order mark is a domain default and not a derivation, so it is drafted and routed to the owner. *(re: R-46; source: SRS § 3.3 FR-10)*
- **RN-4:** *(added)* R-29 – R-31 state the tree's completeness, ordering and arrival expansion — *because* FR-5 says "a navigable tree" and no source says whether dot-entries and `.git` are shown, in what order entries appear, or how far the tree opens at arrival; each is a reading a builder would otherwise make. Completeness is derived from the PRD's *"browse and read anything in the folder"*; the ordering and the arrival expansion are conventions, so all three are routed. *(re: R-29, R-30, R-31; source: SRS § 3.2 FR-5; PRD § Goals "Inspection without risk")*
- **RN-5:** *(added)* R-34 states how a symbolic link is presented — *because* the SDD's containment check refuses a path outside the granted folder, symlinks resolved (§ 3 `fs-reader`; § 4 C-D1), and no source says what the tree shows for such an entry. The inside/outside split follows from C-D1; that the outside case is presented as an unreadable entry rather than omitted follows from OOS-21. Routed, since what the reader sees for a link is product-visible. *(re: R-34; source: SDD § 3, § 4 C-D1; SRS § SRS Review Notes RN-14)*
- **RN-6:** *(added)* R-66 names the six change categories — *because* FR-12 says "changed files" and the SDD's GitState carries "status letters" without enumerating them; the six are Git's own categories and the set the product's design and verbal language draw, but the FDR may not cite those siblings, so the set is stated here with Git as its basis and routed. *(re: R-66; source: SRS § 3.4 FR-12; SDD § 3 entity GitState)*
- **RN-7:** *(added — with basis)* R-21 carries a user-visible limit from the SDD's § 11 — *because* R-3's response defines what the reader sees for a linked worktree or submodule whose Git directory lies outside the chosen folder, and a limit a stranger meets is behaviour whether or not it was written as a risk. § 11 is drawn on for this one entry and nothing else; the four sections the authoring prompt names carry every other SDD-sourced rule. Routed, since the state it describes is one the SDD names as a known limit stated beside the install path. *(re: R-21; source: SDD § 11 R-3)*
- **RN-8:** *(added)* R-59 states that an image escaping the folder takes the not-fetched placeholder — *because* C-D3 has the product answer nothing for it and the SDD's CDO seat drew that nothing as the placeholder while naming it a reading the UXD's own run outranks (`docs/SDD.md` § SDD Review Notes RN-26). Two seats hedged it, so it is routed. *(re: R-59; source: SDD § 4 C-D3; § SDD Review Notes RN-26)*
- **RN-9:** *(added)* R-117 states the default branch set and that only local branches are offered — *because* FR-18 binds "the current branch and what relates to it" and the SDD's RN-16 computes it as HEAD's branch plus every local branch whose merge-base lies inside the loaded window, and says in the same note that whether the reading matches what the owner meant is the CPO's and CDO's to challenge. Routed on that invitation. *(re: R-117; source: SRS § 3.6 FR-18; SDD § SDD Review Notes RN-16)*
- **RN-10:** *(added — from the SDD)* R-58 (in-folder images load) and R-61 (a relative link opens its target) state behaviours the SRS leaves open — *because* FR-32 permits the relative link on build cost and is silent on local images, and the SDD settled both: the owner overrode the draft to load local images (`docs/trail/sdd/cycle-1.md` § 2.4, folded as SDD RN-11 and TO-6) and the CTO judged the relative link inside the owner's permission (SDD RN-10). Both are settled SDD content, so they are carried, not routed. *(re: R-58, R-61, PD-12, PD-13; source: SDD § 9 TO-6; § SDD Review Notes RN-10, RN-11)*
- **RN-11:** *(added — the undecided numbers)* R-50, R-75, R-84 and R-120 each carry a limit that is undecided and name who decides it — *because* the owner ruled that a threshold invented before there is a build to measure is noise (`docs/trail/prd/cycle-1.md` § 2.4, carried as SRS RN-4 and SDD C-I4), and the instance's writing bar requires an undecided limit to say so and name its decider rather than carry a placeholder (`system/doctrine/writing_bar.md` § 1.5). A rule with no number is testable for the behaviour it states and re-tested for the number once the SRS carries it. *(re: R-50, R-75, R-84, R-120, PD-30; source: SRS § 4.1 NFR-1, NFR-2; § 4.4 NFR-10; SDD § 4 C-I4, § Open Questions)*
- **RN-12:** *(added — the phasing mark)* Rules under the three *Beyond v1* groups, and R-4, R-5, R-69 and R-70, are conditioned on a capability existing rather than on a date or a change unit — *because* the PRD phases the product (v1, beyond v1) and the Agari places the beyond-v1 three inside done, so the contract holds for every release along the way; and a definition document never names when a thing is built (`<CORE>/doctrine/setup/setting_up_a_project.md` § The definition set never names the journey). No rule here names a change unit or a station. *(re: § Rules; source: PRD § Scope (In), § Out of Scope; SRS § 3.6)*
- **RN-13:** *(reverse walk — what lands as no rule, and why)* SRS: NFR-12 lands as PD-29; DR-1 – DR-4 are in-memory models and land only where user-visible (R-108, R-109 for DR-5; R-112 for the Diff entity); § 5.3 lands as PD-29 and R-101; every AC maps to the rules its *covers* clause names. SDD § 4: C-R2 (entitlements), C-R6's mechanics (the allowlist file, the CI diff), C-R7 (the CSP), C-I2's log path, C-I3 (the harness and bundle probe), C-I4's script, and C-E8 (how strings are authored — whole sentences, named placeholders) are structure, process, or content-authoring rules, and belong to the SDD and `docs/CONTENT.md`; C-E3 restates FR-23 and FR-24. SDD § 3's parts, seams 1, 3, 5 – 7 and the entity fields are structure; seam 2 and seam 4's promise land as PD-29 and R-101. PRD: the familiarity thesis (§ Assumptions) is a product assumption with no behaviour; maintainer capacity and *"a version that can no longer be maintained is archived visibly"* are acts on the repository after maintenance ends, not behaviour of the system (the SRS's RN-24 dropped them the same way); § Problem Statement, § Why This and § Risks state intent and produce no rule. *(re: § Rules, § Product decisions)*
- **RN-14:** *(the siblings, read for collision)* `docs/UXD.md` v6: UX-F2 and UX-S6 still carry pre-answer text on the Git-view row and the history's placement (RN-1 above; the SDD's RN-20 names both as the CDO's to revise); UX-I17, UX-S4 and UX-I12 say what R-9, R-22 – R-26 and R-53 – R-62 say. `docs/DESIGN.md` v5: its § Overview still reads *"a read-only viewer for one local Git repository"* and § Components names a *"repository selector"*, both predating PRD v11 and CONTENT v4's *folder selector*; a stale sibling, not a collision with a rule here, and the CDO's to revise. `docs/CONTENT.md` v4: no collision; its RN-27 already records that the shipped `README.md` disagrees with it, which R-135 – R-139 will hold at release. Nothing from any sibling is absorbed into a rule. *(re: R-70, R-73, R-121)*
- **RN-15:** *(the terminus)* `system/projects/nozoki/agari.md` was walked against every rule. No rule serves only work the Agari places outside done; the five things it excludes land as OOS-5 – OOS-8 and OOS-14, and a second platform as OOS-10. No rule traces to the Agari alone. One defect beside the claim: the Agari cites `agari_trail/cycle-1.md` and `agari_trail/cycle-2.md`, and those files now live at `system/projects/nozoki/trail/agari/` — a stale locator in the CPO's document, recorded here and not corrected here. *(re: § Out of scope)*
- **RN-16:** *(quoted commitments)* R-138 and R-143 quote the PRD's support-posture wording rather than paraphrasing it — *because* the instance's writing bar requires a commitment another document owns to be quoted with its locator (`system/doctrine/writing_bar.md` § 1.5), and the SRS's C-7 and C-13 carry the same quotations for the same reason. *(re: R-138, R-143, PD-22; source: PRD § Assumptions "Support posture")*
- **RN-17:** *(the SDD's open questions)* Four questions the SDD leaves standing — a folder dropped on the Dock icon or opened with *Open With*, sandbox enforcement under an ad-hoc signature, libgit2's behaviour under the grant, the CSP origin form — change no rule here. If the first is verified, the SDD gains a second way to start and R-3 is revised by that upstream change; the other three are mechanism. *(re: R-3; source: SDD § Open Questions)*
- **RN-18:** *(status lines)* `docs/PRD.md` is Settled at v11, `docs/SRS.md` Settled at v8, `docs/SDD.md` Settled at v2, and no companion sits beside any of them; nothing about an input's status reaches the owner. *(re: the derivation)*
