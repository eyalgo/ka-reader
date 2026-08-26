
# SDD — nozoki

**Status:** Settled
<!-- Draft = open issues or choices to confirm remain (open-issues file present).
     Settled = nothing left for the owner to answer and no open technical question — the done
       signal, and the state a finished SDD carries; the open-issues file is gone.
     Locked = ratified as the source of truth. -->
**Owner:** CTO · CPO · CDO — one run, three seats
**Version:** 2 — run 2 folded the owner's answers to all 10 run-1 companion items (`docs/sdd_trail/cycle-1.md`): unsigned release with the install mechanism the CTO's to design (§ 1.1); the Git-view row opens the diff, one click target (§ 1.2); the history view sits in the sidebar (§ 1.3); the SDD follows the SRS on the Markdown raw-source switch (§ 2.1); Tauri 2 confirmed (§ 2.2); the system Open-panel start mechanism confirmed (§ 2.3); local repository images now load in place (§ 2.4, overridden); `read-markdown` and `read-the-history` kept as their own slices (§§ 3.1–3.2); `pick-it-up-release` re-cut to land after the full v1 cut (§ 3.3). The owner's widened input — a repository is now any local folder, Git or not — drove a folder-vs-repository sweep across every section and slice, renaming two slices (`read-a-repository` → `read-a-folder`, `switch-the-repository` → `switch-the-folder`); both halves (command and observable) of all eight slices now carry the plain-folder case. The companion is empty and removed this run; nothing is open.

> The SDD is the technical **how**, and it ends in a **cut**. It states the architecture the rest of
> the system builds against — derived from the PRD (the *what and why*), the SRS (the system-level
> *what*) and the UXD (the experience) — and it then cuts that architecture into an ordered set of
> **slices, each of which delivers something on its own**. A slice is not itself a unit of work:
> the Principal PM draws one and cuts it into **one or more** 根回し Nemawashi seeds. § 8 states how
> a slice's fields land in them; how many seeds, when a slice is drawn, and what a seed's stations
> reach into are all `<CORE>/roles/loaders/principal_pm_global.md`'s — § *The loop* and § *Where a
> seed's stations reach*.
>
> **The cut is the point of the document.** Part B states the method — the steps that turn a design
> into contained slices — and Part C is what those steps produce. A reader who needs to know how to
> plan opens § 5. A reader who needs to know what was planned opens § 6.
>
> It is a **living document**, updated in place with versioning: bump the Version line above on each
> material change. When the build contradicts the cut, § 10 records the contradiction before the cut
> is redrawn.
>
> Omit a section only when it genuinely does not apply; do not pad one to fill it.

## Who holds what, inside one run

<This document is authored by three seats working together, not handed between them in passes. The
table below is the standing split; leave it as written. A seat that finds itself editing another
seat's column has found an open issue, not a mandate.>

**The rule every row follows:** a part belongs to the seat that would have to be overruled for it to
be wrong. Where two seats would each be overruled about different clauses of one part, the part is
split by named clause and each clause names its seat. No part is shared — a shared row is an open
question in the shape of an answer.

| Part | Seat |
|---|---|
| § 1 What this design must achieve | **CPO** |
| § 2 The shape, and what it was chosen over | **CTO** |
| § 3 The parts, and the seams between them | **CTO** |
| § 4 — runtime and deployment shape, instrumentation and failure visibility, identity, authorization, data protection | **CTO** |
| § 4 — the experience conditions the UXD binds on every surface | **CDO** |
| § 5 step 1 — the entries themselves | **CPO** |
| § 5 step 1 — that each entry is genuinely observable, not an architecture box | **CDO** |
| § 5 step 2 Strike the fragments | **CPO** |
| § 5 step 3 Separate dependency from preference | **CTO** |
| § 5 step 4 Size each one against a reached-when | **CPO** |
| § 5 step 5 Order by what each slice falsifies | **CTO** |
| § 6 *Slug*, *Delivers*, *Moves toward*, *Not in this slice* | **CPO** |
| § 6 *Rests on*, *Why here in the order* | **CTO** |
| § 6 *Reached when* — the behaviour observable in the running product | **CDO** |
| § 6 *Reached when* — the command and its result, and the artifact that must exist | **CTO** |
| § 6 *Traces to* — the PRD section | **CPO** |
| § 6 *Traces to* — the SRS `FR-n` / `NFR-n` / `DR-n` / `C-n` | **CTO** |
| § 6 *Traces to* — the UXD section | **CDO** |
| § 7 The order, and why | **CTO** |
| § 9 Trade-offs taken | **CTO** |
| § 10 Re-cut record | the seat whose ground moved — see below |
| § 11 Technical risks | **CTO** |
| § 12 — the PRD boundary | **CPO** |
| § 12 — the SRS boundary, and the downstream boundary | **CTO** |
| § 12 — the UXD boundary | **CDO** |
| *Open Questions* | **CTO** |

§ 8 is authored by nobody — it is left as written. *SDD Review Notes* names its seat on every entry.

**§ 10 has no standing seat, deliberately.** A re-cut is written when a cut meets a reality that
contradicts it, and the trigger says whose ground moved: a *Reached when* that cannot be met belongs
to whichever half failed; a slice that turned out to be a fragment is the CPO's, by § 5 step 2; no
slice left that can be started is the CTO's, by step 3; an upstream change belongs to the seat that
owns that document. A standing owner here would have one seat recording another's error in its own
voice, which is how a correction stops being distinguishable from a drift.

**What each seat must not own:** the CTO, whether a slice is worth delivering — that is product
value. The CPO, the architecture style, the data model and the seams. The CDO, product scope and the
technical order.

---

# Part A — What is being cut

<Part A is the design, kept only as far as the cut is made from it. The SRS holds the requirements
and the UXD holds the experience; neither is restated here. A section of Part A that no slice in
§ 6 rests on is padding — cut it.>

## 1. What this design must achieve

*(CPO)* One intent: a developer looks at a local folder — a Git repository or not — the tree, the
files, and where it is a repository what changed, and the tree as it moves under an agent — with the
certainty that nothing about that folder changes (`docs/PRD.md` § Purpose — "a reader of folders,
files and repositories, the three named flat"; § Goals "Inspection without risk"; § Target Users, the
driving scenario). The PRD's own edge is that the guarantee *is* the product — "there is no write
path to configure away" (`docs/PRD.md` § Why This) — so a design in which not-writing is a matter of
care rather than of construction has failed § 1 before it is drawn.

The terminus is the project's 上がり Agari (`system/projects/nozoki/agari.md`): the v1 cut — file
tree, reading with highlighting, Git status, live refresh, against a plain folder as against a
repository — plus diffs, commit history, and switching the viewed folder without restarting, always
one at a time; the read-only bar at zero violations at every release; and a closing public release
at 1.0.0 or later under MIT, the README alone taking a stranger to a viewed file of their own
folder. The plain folder "has no line of its own" in the dock — "it is an input the whole surface
takes, not a capability added to it" (`system/projects/nozoki/agari.md`, first condition), which is
why no slice in § 6 delivers it and every slice takes it. Sidebar search / filter, pane resizing,
keyboard navigation, history filtering and search, and a second platform are outside the dock
(`docs/SRS.md` § 2; `docs/UXD.md` § 10) — a shape that carries capacity for them is designing past
done, and § 6's *Moves toward* holds every slice to the dock.

Fixed before any choice below: no write path to the viewed folder, in any version (`docs/SRS.md`
C-2, NFR-5, NFR-6); no network call during operation and every rendered asset shipped with the tool
(NFR-8, `docs/UXD.md` UX-I15); local-only, macOS only (C-1, C-11); exactly one acquisition path, no
build from source, at most one named prerequisite, ≤ 5 minutes to a viewed file (C-3, NFR-13); the
folder location as the only input, and whether it is a repository found, never asked (FR-1,
NFR-14); Git read only where the opened folder is itself a repository's root, and the finding a read
that creates nothing (FR-33); the plain folder a working state, not a failure — the Git view present
and showing nothing (FR-34, `docs/UXD.md` UX-I17); the folder as live, untrusted input that may
change under the view at any moment (DR-6, FR-16); the viewed folder an input, never a structural
singleton (NFR-12); the tool's own state outside the folder (FR-21); the promises holding through
crashes, not only in normal operation (NFR-4).

The test this section sets for § 2: two candidate shapes are told apart by three questions — is the
no-write, no-network promise true by construction, so that AC-1 – AC-3 pass because the write and
the network are absent rather than avoided; does a stranger's install stay inside C-3's bounds on a
machine that has never seen the tool; and does the view keep following a tree that is being rewritten
under it without blocking, crashing, or writing (FR-16, NFR-3). A shape that delivers every v1 feature
and answers one of the three with "if the code is careful" loses to one that answers all three
structurally, whatever else it costs.

## 2. The shape, and what it was chosen over

*(CTO)* **The forces, each answered from this product's documents before any shape was named.**

1. *Where change arrives.* Every change the documents foresee is a new **read surface** on the same
   two sources — diffs, history, a folder chosen at runtime (`docs/SRS.md` § 3.6) — or a number
   folded in by revision (NFR-1, NFR-2, NFR-10) or a wider highlighting floor (FR-8). None adds a
   source, a write, or a connection. The shape is priced to that: adding a read surface is cheap;
   adding a *capability* — a write, a socket, a shell — costs a visible change to a boundary a
   reviewer reads, on purpose. The input's widening at PRD v11 / SRS v8 — a folder, a repository or
   not — is the proof of the pricing: it added a *finding* (FR-33) and a state in which the second
   source is absent (FR-34), and no new source, write or connection.
2. *What it talks to.* Two interfaces, both local, both read-only, and no API (`docs/SRS.md` § 5.2,
   § 5.3): the filesystem and — where the granted folder is itself a repository's root (FR-33) —
   that repository's Git state. Both contracts are owned elsewhere — Apple's filesystem, Git's
   on-disk format — and neither moves inside the Agari's horizon. Insulating a core from two stable
   edges is ceremony, with one exception: *which mechanism reads Git* is this document's call
   (`docs/SRS.md` § 5.3) and is the one substitution that may be exercised (§ 11 R-1), so that edge
   alone gets a port — and the finding-out of FR-33 sits behind the same port, because it is a read
   of Git's on-disk format and nothing else.
3. *Judgment or plumbing.* Plumbing: read, derive DR-2 – DR-4, show. The one rule worth guarding is
   **negative** — nothing writes (NFR-5, NFR-6), nothing connects (NFR-8), nothing read is executed
   (NFR-16) — and it must hold through crashes (NFR-4). A negative invariant is not held by a domain
   core; it is held by **withholding the capability** at a boundary, so that the code that draws the
   repository cannot reach the disk or the network at all, and the code that reads the disk cannot
   write to it because the operating system refuses. This is the force that decides the section.
4. *What must be replaceable.* The viewed folder — an input, replaced at runtime by FR-19, which
   NFR-12 makes a structural demand; and the Git-reading mechanism (force 2). Nothing else inside the
   horizon: not the renderer, not the platform (C-11).
5. *What the numbers force.* One machine and no hosted mode (C-1): one deployment unit, no
   distribution. FR-16 and NFR-3 force every read off the surface's thread and every failure scoped
   to one item. NFR-8 and NFR-4 force the no-network and no-write walls to be ones a crash cannot
   lower — which convention cannot promise and an operating-system sandbox can.
6. *What a first slice proves.* A host that reads one tree and one file across the boundary, a
   renderer that draws them with no capability of its own, inside the sandbox, packaged as the bundle
   a stranger will download — one reader, one panel, wrong cheaply.
7. *What being wrong costs.* Undoing the process split is one IPC surface rewritten as direct calls;
   undoing the renderer technology is every surface rewritten; undoing the sandbox is one file —
   which § 11 R-8 treats as a risk, not a comfort.

**The candidates, run against the forces.**

| Shape | Right when | Wrong when | Taken? |
|---|---|---|---|
| **Capability-split read pipeline** — two read-only sources → one in-memory repository model → surfaces; the surfaces in a renderer process holding no filesystem, network or shell capability; the host holding read capability only, fenced by the OS sandbox | the invariant to guard is the *absence* of a capability, the sources are few and stable, and untrusted content is rendered (forces 2, 3; DR-6) | rich domain rules need a guarded core, or the surfaces need direct disk access to be fast — neither is in the SRS | **yes** — the one candidate that answers § 1's three questions structurally: no write and no network because the renderer has neither and the OS denies the host; a stranger's install is one bundle; the model follows a moving tree because every read is off-thread and per-item |
| Hexagonal — a domain core behind ports, an adapter at every edge | many volatile edges, or rules in the core worth shielding from them | two stable edges and a core that would hold DR-2 – DR-4 and no rule (forces 2, 3) | no — the core would guard nothing; its one useful port, the Git reader, is kept (§ 3 seam 2). It wins if the agent-workflow front end ever comes inside the Agari and brings its own edges — it is outside (`system/projects/nozoki/agari.md`, first condition) |
| Layered, one process — UI over services over a data-access layer | one code base serves several UIs, or the data layer's generality pays | the data layer's generic filesystem and network access is exactly the capability this product must not hold, so not-writing becomes discipline (force 3; § 1's "if the code is careful") | no — fails § 1's first question by construction |
| Native single-process model-view (AppKit / SwiftUI) under the same sandbox | nothing untrusted is rendered as HTML and the design language is native controls | Markdown must render (FR-30), and the design language is expressed as web tokens and SVG icons (`docs/UXD.md` § 9; the repository's vendored `third_party/lucide/`) | no — the honest runner-up: it keeps the sandbox wall and loses the renderer wall. The owner confirmed the WebView runtime (`docs/sdd_trail/cycle-1.md` § 2.2), and `docs/DESIGN.md` RN-1 binds no runtime — "every value here is a CSS value and holds in either" — so this row wins only if the design language is ever re-expressed natively, which nothing inside the Agari asks for |
| Local server + browser tab — the input proposal's "web app" | a hosted or multi-client direction is inside the terminus | the product promises no network call during operation (NFR-8) and a listening socket is one; the README no longer calls it a web app (`docs/PRD.md` § Out of Scope, last item) | no — fails § 1's first question, and the direction it serves is outside the dock |

**Undoing it.** The model in the middle survives every reversal. Collapsing the two processes into
one costs the IPC surface (§ 3 seam 4) rewritten as calls, and nothing else. Replacing the renderer
technology costs every surface — the expensive reversal, and why the runtime is surfaced for an ADR
(§ 12). Removing the sandbox costs one entitlements file, which is why § 4 C-I3 makes its presence a
check on every build from the first slice's bundle on, rather than an assumption — or a check first
run on release day.

## 3. The parts, and the seams between them

*(CTO)* Three deliverables — `nozoki-core` (a Rust library), `nozoki-app` (the Tauri host binary),
`nozoki-ui` (the renderer) — in one bundle, plus a build-time harness. Drawn against the SRS and the
UXD, not against code: the product repository holds `docs/`, `scripts/design-check.mjs` and
`third_party/lucide/` and no product code.

**The parts.**

| Part | Lives in | Owns | Must not own |
|---|---|---|---|
| `fs-reader` | `nozoki-core` | Listing a folder; reading a file's bytes; deciding text / not-text and decoding; recognizing a floor language or Markdown by extension (the table below); the **containment check** — that a path, symlinks resolved, lies inside the granted folder — which every read and the asset handler run before opening; every open is read-only | Any write, anywhere; any path outside the granted folder; knowledge of what a surface does with the result |
| `git-reader` | `nozoki-core`, behind the **Git port** | The **root finding** (FR-33): whether the granted folder is itself the top level of a working tree — a `.git` folder or a `.git` file naming a `gitdir` at the folder itself, never a repository discovered from an ancestor — answered by reading and creating nothing; repository state (normal / merge / rebase / cherry-pick / revert / bisect / detached); HEAD and branch name; changed and staged files with status letters; short status; *(beyond v1)* diffs — index-to-worktree, HEAD-to-index, parent-to-commit — and the commit walk with parents and branch tips | Any call that mutates — no checkout, no index write, no ref update, no lock file; a discovery that walks up from the folder; spawning `git`; a network transport |
| `watcher` | `nozoki-core` | Subscribing to the granted folder through FSEvents and emitting *the paths that changed*, coalesced over a short window — the folder's own `.git` entry included, so a repository appearing or leaving at the root is a change like any other | Reading content; deciding what a change means; anything under the tool's own state |
| `folder-model` | `nozoki-core` | The in-memory state of exactly one folder (DR-1 – DR-4): the tree with markers, the open file, and the root finding with its Git state — present where `git-reader` found a root, `plain` where it did not, in which case every Git-derived projection is empty and the tree carries no marker (FR-34); the **item state** of every read (`pending` / `observed` / `failed(condition)` / `stopped`); the reducer that applies a watcher event by re-reading only the paths named — a change to the root's `.git` entry re-running the root finding (FR-33's live clause) — and keeping expansion, selection and reading position (FR-27); opening a *different* folder by replacing the whole model (NFR-12) | Persisting anything; holding two folders; reaching a source other than through `fs-reader`, `git-reader`, `watcher`; inventing a message for the plain state — it projects nothing, and the surface draws nothing (UX-I17) |
| `own-state` | `nozoki-core` | DR-5: theme, window state, *(beyond v1)* the remembered-folders list as security-scoped bookmarks with display names, and which of them was viewed last; read and written in the app's own container only | Folder content; anything personal; a path outside the container |
| `markdown-renderer` | `nozoki-core` | Markdown → HTML on the host, through a sanitizer whose allowlist admits no script, style, frame, object, event attribute or `src` — with one rewrite, not an exception: an image whose reference resolves, by `fs-reader`'s containment check, to a file inside the granted folder becomes an `<img>` whose `src` is that file's path on the host's asset scheme (§ 4 C-R7); any other image — remote, or escaping the folder — becomes the not-loaded placeholder (RN-11); an external link becomes inert text with its destination readable; a relative link becomes a data attribute the renderer turns into an open-file command | Fetching anything; emitting a URL on any scheme but the asset scheme; emitting a `file:` or `http(s):` URL ever |
| `ipc-surface` | `nozoki-app` | The closed list of commands the renderer may invoke — reads, and writes to own-state only — and the events pushed to it (model projections, item-state changes); the **asset handler** — a custom URI scheme registered on the host that answers a request for a path by running `fs-reader`'s containment check and returning the bytes read-only, or nothing; the window; the sandbox entitlements; the Content Security Policy | A generic filesystem, shell, HTTP or dialog command; a scheme that serves anything outside the granted folder, or serves it writable; any Tauri plugin beyond what the listed commands need |
| `surfaces` | `nozoki-ui` (HTML / CSS / TypeScript, every asset bundled) | The shell chrome (identity / selector, theme control, sidebar rail), the tree, the Git view — drawn empty, with no text and no control, when the model's root finding is `plain` (UX-I17) — the reading panel and its treatments (code, Markdown, cannot-display, gone; *beyond v1* diff, history), the highlighter with bundled grammars for the six floor languages | Any filesystem, network or shell access — it has none; any state that is not a projection of the model or of own-state |
| `read-only-harness` | `checks/` (build-time, not shipped) | AC-1 – AC-3, AC-5, AC-8, AC-13, AC-23, AC-24, AC-25 as machine checks over fixture folders — repositories, plain folders, a folder inside a repository, a parent of two, a linked worktree, a submodule — run against `nozoki-core` and the built bundle in CI and before every release; and the bundle probe — entitlements and sandbox, § 4 C-I3 — run on every build from the first bundle on | Product behaviour; anything inside the bundle |

The parts realize § 2's shape: the three sources and the model are the pipeline, `ipc-surface` is
the capability boundary, `surfaces` is the capability-free side of it, and `read-only-harness` is
how the boundary is proved rather than trusted. No part is here that § 2 does not explain. The
**root finding** is placed in `git-reader`, not in `fs-reader` or the model, because it is a read of
Git's on-disk layout and the one part that may be substituted (seam 2) must carry it too — an
installed-`git` adapter would answer it with `git rev-parse --show-toplevel` compared to the folder,
a libgit2 one by opening the folder with discovery disabled; the model consumes the answer and the
surfaces draw it, and neither knows how it was found (FR-33: "how the determination is made is the
SDD's"). The CPO's cut lands the finding-out in `see-what-changed` (§ 5 step 4); this placement is
what makes that cut buildable — `read-a-folder` links no `git-reader`, and its model's root finding
is `pending`-never-asked until that slice, which is why its shell carries no Git surface (RN-19).

**The seams — what crosses, and whose contract it is.**

1. **OS filesystem ↔ `fs-reader` / `watcher`.** Read-only opens and FSEvents. Contract: Apple's,
   fenced by the sandbox grant (§ 4 C-R2). Crosses: bytes and change notifications; nothing crosses
   the other way.
2. **The Git port — `folder-model` ↔ `git-reader`.** Contract owned by the model: `probe(folder)`
   — the root finding, returning `root` or `plain` and never a path above the folder — then, only
   on `root`, `state()`, `status()`, `diff(kind, path)`, `walk(tips, window)`, each returning plain
   data and each documented as read-only. Two adapters may stand behind it: **libgit2**, the one
   built (RN-8), and an **installed-`git` adapter** kept as the substitution force 2 named — never
   built ahead of § 11 R-1 firing, by § 5 step 2.
3. **`watcher` → `folder-model`.** Crosses: a coalesced set of folder-relative paths. Contract owned
   by the model; the watcher knows nothing of what a path means.
4. **`nozoki-app` ↔ `nozoki-ui` — the IPC surface.** Crosses host → renderer: JSON projections of
   the model with item states, sanitized HTML for Markdown, decoded text for the highlighter, and —
   on request, over the asset scheme — the bytes of an image inside the granted folder; renderer →
   host: one command from the closed list (`open_folder`, `list_tree`, `select_file`,
   `open_relative_link`, `set_theme`, and *(beyond v1)* `open_diff`, `walk_history`,
   `switch_folder`), each named in `nozoki-app`'s capability file, plus a request on the asset
   scheme, which the handler answers only for a path the containment check passes. Contract owned
   by the host. This seam *is* the promise: a builder of the renderer who holds only this contract
   cannot write or connect, because nothing on the list does either — and cannot read outside the
   folder, because the one read channel it can address refuses.
5. **`folder-model` → `surfaces`.** Crosses: per-surface view state, every item carrying its
   state, and the root finding; the surface draws `pending`, `failed` and `stopped` in the slot the
   UXD fixes (UX-I16), and draws the Git view empty — no text, no control — on `plain` (UX-I17).
   Contract owned by the model; the surface projects and never derives.
6. **`own-state` ↔ shell chrome.** Crosses: theme, window state, the remembered list and the
   last-viewed entry. Contract owned by `own-state`. A change here is the only write the product
   ever performs, and it is to the container.
7. **`markdown-renderer` → `surfaces`.** Crosses: sanitized HTML, its only URLs on the asset scheme.
   Contract owned by `markdown-renderer` (what the allowlist admits); the renderer's CSP (§ 4 C-R7)
   is the second wall behind it, owned by `ipc-surface`, and the asset handler's containment check
   the third — a bypass of the first two still reaches no byte outside the folder.

**What the system holds** — design-level, each traced to the DR it realizes.

| Entity | Key fields | Relationships | Realizes |
|---|---|---|---|
| Folder | path; display name; the grant (sandbox extension, or bookmark beyond v1); root finding — `root` or `plain` (FR-33), itself an item with an ItemState | exactly one held by the model at a time | DR-1, DR-6 |
| TreeNode | folder-relative path; kind (folder / file); expanded; changed-marker (none, or the status letter); ItemState | children by path; the marker derived from GitState, and always none where the Folder is `plain` | DR-2 |
| OpenFile | path; bytes → decoded text, or the not-text reason; recognized language (one of six) or none; is-Markdown; treatment (`rendered`; `raw` only if FR-31 is ever built, RN-10); reading position; exists-on-disk; ItemState | at most one; its path is a TreeNode | DR-3 |
| GitState | HEAD / branch name; repository state (normal, merge, rebase, cherry-pick, revert, bisect, detached); changed[] and staged[] with status letters; short status; ItemState | one per Folder whose root finding is `root`; absent on `plain`, and every projection of it empty (FR-34) | DR-4 |
| Diff *(beyond v1)* | path; kind (`unstaged`: index → worktree; `staged`: HEAD → index; `commit`: parent → commit); hunks; ItemState | of a changed file, or of a Commit | DR-4, derived and in-session |
| History *(beyond v1)* | commits — id, message, author, date, parents[], branch membership inside the chosen set; the chosen branch set; the default set (RN-16); the loaded window | a walk over GitState's refs | DR-4, derived and in-session |
| ItemState | `pending` \| `observed` \| `failed(observed condition)` \| `stopped` | on every read above | NFR-3, NFR-11; UX-I13, UX-I16 |
| OwnState | theme (system / light / dark); window frame; *(beyond v1)* remembered folders as security-scoped bookmarks plus display names, and which was viewed last | persisted in the container; nothing else is persisted | DR-5 |

**The floor-language extension set** — FR-29's "fixed in the SDD"; matched case-insensitively on
the last extension only (RN-12): Python `.py` `.pyi` `.pyw`; shell `.sh` `.bash` `.zsh`; JavaScript
`.js` `.mjs` `.cjs` `.jsx`; JSON `.json` `.jsonc`; YAML `.yaml` `.yml`; TOML `.toml`. Markdown:
`.md` `.markdown`. A file with no extension, or any extension outside this set, is plain text.

## 4. What every slice inherits

*(CTO — runtime and deployment shape; instrumentation and failure visibility; identity,
authorization and data protection. Each is a condition a slice can violate, and each names the
violation. The CDO's experience conditions follow in their own clause.)*

**C-R — runtime and deployment shape** *(serves C-1, C-3, C-11, NFR-8, NFR-13, NFR-14; C-3's
channel and C-11's macOS floor are fixed here, where the SRS places them — its RN-7, RN-21)*

- **C-R1.** The product is one macOS application bundle, `Nozoki.app`, bundle identifier
  `com.kensaiapp.nozoki`: a Tauri 2 host (`nozoki-app`, Rust) over `nozoki-core`, rendering
  `nozoki-ui` in the system WKWebView. Every asset the renderer uses ships inside the bundle
  (UX-I15). *Violated by:* a slice that adds a second binary, a prerequisite, a runtime install, or
  a fetched asset. (The runtime: RN-7, owner-confirmed — `docs/sdd_trail/cycle-1.md` § 2.2.)
- **C-R2.** The bundle runs under the App Sandbox with exactly these entitlements:
  `com.apple.security.app-sandbox`, `com.apple.security.files.user-selected.read-only`, and — from
  `switch-the-folder` on — `com.apple.security.files.bookmarks.app-scope`. No network
  entitlement is present, so an outgoing connection is refused by the operating system: the
  read-only entitlement grants "read-only access to files the user has selected using an Open or
  Save dialog"
  (https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.security.files.user-selected.read-only),
  and outgoing connections are what `com.apple.security.network.client` enables
  (https://developer.apple.com/documentation/bundleresources/security-entitlements), which the
  bundle does not carry. *Violated by:* a slice that adds an entitlement. The release check reads
  `codesign -d --entitlements :- Nozoki.app` against this list.
- **C-R3.** The folder is granted, never typed. The grant is the sandbox's user-selected one, made
  once per folder through the system Open panel: in v1 the host presents the panel at every
  launch, and the folder chosen is the session's (FR-2); from `switch-the-folder` on, launch
  restores the last-viewed folder from its bookmark and presents the panel only when there is no
  remembered folder or the bookmark no longer resolves — a remembered folder is re-opened without
  asking, and the panel is the selector's *Browse…* entry (UX-S7). Pointed at a path that does not
  exist, is not a folder, or cannot be read, the window shows UX-S4 — in v1 with a way to choose
  again and a way to quit, beyond v1 with the selector as the route out — and never a terminal
  line; the UXD's open question is settled by that (RN-9, owner-confirmed —
  `docs/sdd_trail/cycle-1.md` § 2.3). A readable folder that is not a repository's root is **not**
  on that list: it opens, as a working state (FR-34, UX-I17). *Violated by:* a slice that reads a
  path it was not granted, that prints a surface to a terminal, that presents the panel for a
  folder the bookmark still resolves, or that treats a plain folder as a startup failure.
- **C-R4.** The acquisition channel is a GitHub Release on `github.com/kensaiapp/nozoki` (C-12)
  carrying `Nozoki-<version>.dmg` and `SHA256SUMS`, built by CI from the tagged commit and never on
  a maintainer's machine. The bundle is **ad-hoc signed** (`codesign --sign -`) in that build — a
  signature that costs nothing and is what binds the entitlements to the binary at all — and is
  **never Developer ID-signed or notarized**: the owner's standing call, for this and every app in
  the instance (`docs/sdd_trail/cycle-1.md` § 1.1), not to be raised again. The install path is
  therefore: download the `.dmg`, drag `Nozoki.app` to Applications, and — on first launch — the
  one System Settings › Privacy & Security step macOS Sequoia requires for software that is not
  notarized, Control-click no longer overriding Gatekeeper
  (https://developer.apple.com/news/?id=saqachfa); the README's first screen names all three, and
  no terminal command (no `xattr`, no `spctl`) is ever the documented route. A Homebrew cask is not
  offered: it is a second path, and Homebrew a prerequisite of its own, which C-3 forbids twice
  over. *Violated by:* a release whose checksum does not match a rebuild from its tag, a second
  install path, a README step that opens a terminal, or a build that reaches for a signing
  identity.
- **C-R5.** Minimum macOS: 14 (Sonoma) — the floor AC-10's release walk runs on. Tauri's own
  default is 10.13 (https://v2.tauri.app/reference/webview-versions/); the floor is raised to what
  is tested, and is stated wherever the install path is offered (C-11). *Violated by:* a README or
  release page that omits it, or a bundle whose `LSMinimumSystemVersion` disagrees.
- **C-R6.** The host links no network code: libgit2 is built without its HTTPS and SSH transports,
  and the dependency allowlist `checks/deps.allow` names every crate and package the bundle may
  contain; `cargo tree` and `npm ls` are diffed against it in CI. A dependency-tree change is
  reviewed as code in the change that makes it; lockfiles with integrity hashes are committed.
  *Violated by:* a lockfile diff adding a dependency outside the allowlist without the review
  recorded.
- **C-R7.** The renderer's Content Security Policy is `default-src 'none'; script-src 'self';
  style-src 'self'; img-src 'self' data: <asset-scheme>; font-src 'self'`, declared in
  `tauri.conf.json`, where `<asset-scheme>` is the origin form of the host's asset handler (§ 3
  `ipc-surface`) — the scheme is named `nozoki-asset` and the exact origin string the WebView
  accepts for it is settled in `read-markdown` (Open Questions); the renderer is granted no
  capability beyond the commands § 3 seam 4 lists and that one scheme. *Violated by:* a slice that
  loosens the policy past this — `http:`, `https:`, `file:`, `asset:` or `*` in any directive — or
  enables a plugin. (The image clause: the owner's override, `docs/sdd_trail/cycle-1.md` § 2.4.)

**C-I — instrumentation and failure visibility** *(serves NFR-3, NFR-11; the mechanism beneath
UX-I13 and UX-I16 — RN-4 agreed, RN-14)*

- **C-I1.** Every read is an item with an ItemState (§ 3); a surface draws nothing for an item still
  `pending` except that it is pending, and draws `failed` and `stopped` in that item's failure slot.
  A condition the sources report and the tool can name — not found, not readable, locked, not
  text — is `failed(condition)`; anything else is `stopped`. *Violated by:* a read path returning
  without a state, or a surface drawing a marker before `observed`.
- **C-I2.** The host writes a diagnostic log to the container only —
  `~/Library/Containers/com.kensaiapp.nozoki/Data/Library/Logs/nozoki.log` — one line per `failed`
  or `stopped` item naming the part, the operation and the error text; never file content, never
  transmitted, never under the repository (NFR-11). *Violated by:* a log line carrying content, or
  a write anywhere else.
- **C-I3.** The read-only harness runs on every CI build and before every release:
  `checks/read-only.sh <fixture>` hashes the fixture folder, `.git` included where there is one,
  exercises every command on the IPC list through `nozoki-core`, hashes again, and prints
  `unchanged` or the differing paths — against a plain fixture, "unchanged" includes that no
  `.git` and no entry of any kind appeared (AC-24); `checks/no-network.sh` diffs the dependency
  trees against C-R6's allowlist and exits non-zero on any hit; and the **bundle probe**,
  `checks/bundle.sh`, runs `codesign -d --entitlements :- Nozoki.app` and fails unless the list is
  exactly C-R2's, then launches the bundle and fails unless `APP_SANDBOX_CONTAINER_ID` is set in its
  environment. The probe runs on the bundle `cargo tauri build` produces **from `read-a-folder`'s
  first green build on** — on every CI build, published or not — so that the release gate § 11 R-8
  names has been passing for four slices before the first release is due, and a failure of it under
  the ad-hoc signature C-R4 fixes is found with one reader written, not on release day (the owner's
  mitigation, `docs/sdd_trail/cycle-1.md` § 3.3). *Violated by:* a slice that lands without
  extending the fixtures for the reads it adds, or a build whose bundle the probe did not run on.
- **C-I4.** A performance number is measured, never asserted: `checks/latency.sh` prints file-switch
  and refresh p95 in milliseconds over the reference fixtures, and the numbers reach the SRS by
  revision (NFR-1, NFR-2, NFR-10 — its RN-4). *Violated by:* a threshold written into a slice's bar.

**C-D — identity, authorization, data protection** *(serves NFR-5 – NFR-9, NFR-16, DR-5, C-2)*

- **C-D1.** No identity exists — no account, no user record, no device identifier (NFR-7).
  Authorization is the operating system's: the sandbox grant to the folder the user chose is the
  whole of the product's authority over the folder. *Violated by:* any identifier persisted, or
  any read outside the grant.
- **C-D2.** The only writes the product performs land inside its container (DR-5, FR-21): own-state,
  the log, and what WKWebView caches there. AC-13's inspection is machine-run by the harness: after
  a session, every file changed under `$HOME` is under
  `~/Library/Containers/com.kensaiapp.nozoki/`, and none is under the fixture. *Violated by:* any
  other path in that diff.
- **C-D3.** Folder content is untrusted input on every path (DR-6): Markdown is sanitized on the
  host before it reaches the renderer, decoded text is escaped before it is inserted, and no content
  is executed, evaluated or resolved as a URL (NFR-16) — with one resolution, done on the host and
  nowhere else: an image reference in Markdown is resolved against the granted folder, symlinks
  followed, and admitted onto the asset scheme only if the resolved path is inside it; the
  renderer never resolves a path, and the asset handler re-runs the same check on every request.
  *Violated by:* unsanitized content inserted as HTML, a URL built from content in the renderer, a
  `file:` URL anywhere, a plugin that resolves one, or an asset served without the check.
- **C-D4.** Own-state holds nothing personal and no folder content; a remembered folder is a
  security-scoped bookmark and a display name. *Violated by:* a field added to own-state that
  carries either.

**C-E — the experience conditions every surface inherits** *(CDO; each is a condition a slice can
violate, sourced in the UXD, `docs/DESIGN.md`, the two cross-cutting parts of `docs/CONTENT.md`, or
the instance fence `system/experience/visual_restrictions.md` — never in this seat's taste. The
experience begins with the shell open against a folder — a Git repository or not, and a plain
folder is a working state of the same surfaces, never a failure (`docs/UXD.md` UX-I17); the system
Open panel C-R3 puts before it is outside the UXD (`docs/UXD.md` § 10, "The acquisition-and-start
experience") and these conditions do not reach it.)*

- **C-E1.** No indicator is drawn before the tool has observed the state it stands for: no
  changed-file marker, count or "nothing changed" before Git state is read, no progress indicator
  that advances unobserved; where the tool does not yet know, the surface shows the word *pending*
  and nothing moves (`docs/UXD.md` UX-I13; `docs/DESIGN.md` § Do's and Don'ts, "show pending as the
  word *pending*"; fence § `no-unestablished-state`). The mechanism is C-I1's ItemState. *Violated
  by:* a marker drawn from anything but an `observed` item; a spinner or bar; a control drawn as
  enabled whose destination does not exist yet.
- **C-E2.** Every failure state is presented on the surface whose work stopped, in that item's
  failure slot, scoped to that item, with an enabled route out on the same surface — the tree, the
  selector, or a way back — and the shell around it stands. The unexplained fault (`stopped`) takes
  the same slot, scope and route as the observed condition; no control reveals, expands or copies
  its detail, and no message names a cause the tool did not observe (`docs/UXD.md` UX-I6, UX-I10,
  UX-I14, UX-I16; fence § `failure-says-what-next`). *Violated by:* a modal, a toast, a dialog or a
  terminal line carrying a failure; a failure surface with no enabled control on it; a "details" or
  "copy" control; a message carrying the log line C-I2 writes.
- **C-E3.** No editing affordance exists, enabled or disabled, and no framing implies an editable
  mode elsewhere; no undo, save or confirmation model exists; closing asks nothing (`docs/UXD.md`
  UX-I1, UX-I5, UX-I7; `docs/DESIGN.md` § Do's and Don'ts, "Don't draw an editing affordance").
  *Violated by:* a caret in the code view, a disabled *Save*, a quit prompt, any control whose act
  reaches the repository.
- **C-E4.** An update the user did not ask for never takes their place: expanded tree nodes, the
  open file, the sidebar mode and the reading position survive every refresh, only what changed
  changes, and it changes in place with no transition, flash or attention bid; there is no manual
  refresh control; nothing stale is shown as current (`docs/UXD.md` UX-I2, UX-I3, UX-I4;
  `docs/DESIGN.md` § Do's and Don'ts, "Don't animate"). *Violated by:* a refresh that collapses the
  tree or resets scroll; a refresh button; a transition on any state change; vanished content
  still drawn as the file.
- **C-E5.** Everything a surface renders ships with the tool or is the platform's own: the two
  type families are the system's, the icon inventory is the fourteen vendored Lucide glyphs, and
  every surface renders whole with the network off on a stock Mac (`docs/UXD.md` UX-I15, § 9
  fourth constraint; `docs/DESIGN.md` § Typography, § Components "Icons"; fence
  § `no-runtime-remote-asset`, § `no-author-only-surface`). The README as GitHub renders it is
  inside this condition: every image it shows is served from the repository. *Violated by:* a font,
  icon, image, stylesheet or script fetched at runtime; a fifteenth glyph drawn from an icon font;
  a third-party badge on the README.
- **C-E6.** No meaning by hue alone and no control by glyph alone: every state distinction — the
  status letter, the staged / unstaged heading, the selection bar, the active rail entry — carries a
  letter, word, shape or position that survives without colour, and every glyph sits beside its
  word; a status letter's expansion is raised by the letter, as the tooltip, and nowhere else
  (`docs/UXD.md` UX-A2, UX-A4; `docs/CONTENT.md` § Accessibility of text; `docs/DESIGN.md`
  § Components "The tooltip"). Both themes are first-class from `pick-it-up-release` on, and a text
  token is drawn only on the surfaces `docs/DESIGN.md` § Colors specifies it for, where the stated
  floor is ink ≥ 9:1 and every other text token ≥ 4.5:1. *Violated by:* a marker that is a colour
  and nothing else; a glyph with no word; a surface built in one theme after that slice; a
  token–surface pair outside the specification.
- **C-E7.** The accessibility posture is the declared one and no wider: mouse-driven, no keyboard
  model, no focus ring, no assistive-technology claim, no conformance number claimed anywhere the
  product speaks; from `pick-it-up-release` on the README carries the posture sentence below its
  first screen, in the wording `docs/CONTENT.md` § Standing sentences fixes (`docs/UXD.md` UX-A1,
  UX-A3, UX-I8; `docs/DESIGN.md` § Elevation & Depth, "Focus rings: none"). *Violated by:* a slice
  that adds keyboard navigation or a focus ring; a README or release page claiming a standard; a
  README from that slice on without the sentence, or with it on the first screen.
- **C-E8.** Every message is one whole sentence in the source, with named placeholders holding
  only the reader's own values, a context note beside it, and identifiers — paths, branch names,
  commit ids, status letters — never translated; a status message is prose on its surface, never
  text in a row that clips (`docs/CONTENT.md` § Localization). *Violated by:* a message assembled
  from fragments at runtime; a positional placeholder; a message placed in a clipping row.
- **C-E9.** One window, one shell — rail · sidebar · reading panel under one chrome strip — with
  the sidebar toggling Files and Git and nothing else; the chrome carries the repository identity
  (the selector, beyond v1) and the theme control and no third thing, no wordmark and no product
  name; the reading panel is one panel with several treatments — code, rendered Markdown, cannot-
  display, gone, and beyond v1 the diff — sharing one path line, one position rule and one route
  out; no settings, onboarding or second window exists (`docs/UXD.md` § 4, § 9 last constraint;
  `docs/DESIGN.md` § Layout, § Components "The chrome and its controls", "The reading panel").
  *Violated by:* a second window or panel; a preferences surface; a third chrome control; a diff or
  Markdown view without the path line.
- **C-E10.** Every public picture of the shell shows the product as the release it accompanies
  renders it (`docs/UXD.md` UX-I11). *Violated by:* a README screenshot with an element the
  release's shell does not draw, or missing one it does.

---

# Part B — How to cut it

## 5. The cut, step by step

<This section is the method. It is written once, here, so that § 6 carries slices and no method.
Leave it as written unless this product's cut genuinely departs from it — and if it does, say so
here, with the reason.>

### Step 1 — List what becomes observably different

Before any slicing, list the things that would be **observably different** about the running product
between where it is now and its Agari. Write each as one sentence in the form *after this, <someone>
can <do something they could not>*.

The list is made from behaviour, never from the architecture's boxes. "Set up the database", "build
the API layer" and "add the design system" are parts of the shape, not entries on this list. If an
entry cannot be finished in that sentence form, it is not yet a candidate.

**Applied to Nozoki — the entries** *(CPO; made from `docs/PRD.md` § Key Use Cases, § Core Features
and the Agari, before § 3 was drawn; the running product today is nothing — the repository holds
documents, a design-check script and vendored icons, and no product code)*:

- **E1** — after this, a developer can start Nozoki against one local folder — a Git repository
  or not — browse its tree, read any file from it — highlighted in the six floor languages, plain
  text for any other text, a stated cannot-display state for what is not text — and close with the
  folder exactly as they found it.
- **E2** — after this, a developer can open a Markdown file and read it rendered, with nothing
  fetched from outside the repository and nothing in it executed.
- **E3** — after this, a developer can switch the sidebar to Git and, where the folder is a
  repository's root, see the branch, the changed files, the staged files and the short status at
  a glance, see changed files marked in the tree, and open a changed file from the Git view — a
  repository mid-merge, mid-rebase or detached shown as the state it is in; and where it is a plain
  folder, find the Git view there and showing nothing, and the tree unmarked.
- **E4** — after this, a developer can leave Nozoki open over a folder an agent is changing and
  watch every change — file content, the tree, Git state, a repository appearing at the folder's
  root or leaving it — appear on its own, their expanded tree, open file and reading position kept,
  a vanished open file stated as gone.
- **E5** — after this, a stranger can install Nozoki by its one path and, guided by the README
  alone, be reading a file of their own folder within five minutes, under the MIT licence, with
  the support posture stated and the security channel open.
- **E6** — after this, a developer can read in the theme their machine uses, switch it, and find
  the choice remembered — outside the repository.
- **E7** — after this, a developer can open a changed file's diff from the Git view and read it,
  staged changes distinguished from unstaged.
- **E8** — after this, a developer can open the commit history and read it as branches — which
  commits belong to which, where they diverge and merge — against a chosen set of branches with a
  default that asks nothing, and open any commit's own diff from its entry.
- **E9** — after this, a developer can choose another folder from the shell — a repository or a
  plain folder — and be at the arrival state for it without restarting, always one at a time.
- **E10** — after this, an adopter can rely on the version number as a compatibility promise: the
  release is 1.0.0 or later.

### Step 2 — Strike the fragments

Strike every entry whose only value is that a later entry needs it, and fold it into the entry that
gives it value. A cut that needs a later cut to be worth anything is not a slice but a fragment of
one — `<CORE>/roles/loaders/principal_pm_global.md` owns that rule, and this step is where it is
applied to a design rather than to a program.

This is the step that catches infrastructure built ahead of its subject. A checker with nothing to
check is not a step forward, however finished it looks.

**Applied to Nozoki — struck and folded** *(CPO)*:

- **The read-only proof — AC-1 – AC-3 as their own entry.** Never listed: a harness with no product
  to run against is the checker with nothing to check. It is the bar every slice from `read-a-folder`
  on closes against, and no slice's worth.
- **A tree with nothing to read, an empty-state shell, a "workbench".** Never listed: boxes of the
  shape, not behaviour (RN-1).
- **The plain folder as its own entry — "support a folder that is not a repository".** Never
  listed: the Agari names it "an input the whole surface takes, not a capability added to it"
  (`system/projects/nozoki/agari.md`, first condition), and the SRS draws it as a condition on
  requirements that already exist (FR-34), so an entry for it could only be stated by naming the
  surfaces other entries deliver — the fragment's tell. It is inside E1, E3, E4 and E9, each of
  which names what it looks like there (RN-21).
- **E6, themes and remembered state.** Struck as a slice and folded into E5: FR-20 binds both themes
  to the first release and nothing before it, and on its own E6's result changes nothing that comes
  next (step 4's *too narrow*). Its one decision — where the tool's own state lives, never in the
  folder — is settled inside `pick-it-up-release` and inherited by `switch-the-folder`.
- **E10, the 1.0.0 release.** Struck: it is the sixth-cut list's *milestone that only restates its
  last task's completion*. 1.0.0 is a bar the last of the three beyond-v1 slices lands against, not
  a slice — which of the three is last is § 7's (RN-2).

What survives — E1 – E5, E7 – E9 — is § 6, one slice each.

### Step 3 — Separate dependency from preference

For every remaining pair, ask **can the later one be built at all without the earlier one?** — not
whether building it first would be tidier. A stated order is often a preference wearing a
dependency's clothes, and the two behave differently the moment the build slips: a real dependency
blocks, a preference reorders for free.

Record each answer as a typed edge in § 7, with the reason on the same row. An edge with no reason
is a preference that has been written down as a fact.

**Applied to Nozoki — the answers** *(CTO; each in the form the test requires — "B cannot exist
without A because <fact>" — and each a `depends_on` row in § 7)*:

- `read-markdown` cannot exist without `read-a-folder`, because the rendered view is a second
  treatment of the one reading panel (`docs/UXD.md` § 9, last constraint) over a file `fs-reader`
  delivered.
- `see-what-changed` cannot exist without `read-a-folder`, because its markers sit on the tree
  and its files open "exactly as a tree selection is" (`docs/SRS.md` FR-13).
- `watch-a-moving-tree` cannot exist without `read-a-folder` and `see-what-changed`, because what
  it delivers is *every* change appearing — file content, the tree, Git state, a repository
  appearing at the root (FR-14, FR-33) — and a Git change cannot appear before there is a Git view
  and a root finding for it to appear in.
- `pick-it-up-release` cannot exist without `read-a-folder`, because AC-10's walk ends at a viewed
  file; and — since run 2 — not without `read-markdown`, `see-what-changed` and
  `watch-a-moving-tree` either, because its *Delivers* now names "the whole v1 cut behind it": a
  release of less than that is a different slice, one the owner struck
  (`docs/sdd_trail/cycle-1.md` § 3.3; RN-22). The test holds without "should": the fact is the
  slice's own definition. What it does **not** wait for is the proof of the bundle, the
  entitlements and the sandbox gate — C-I3 runs that from `read-a-folder`'s first build.
- `switch-the-folder` cannot exist without `pick-it-up-release`, because the remembered list its
  *Delivers* names lives in own-state (DR-5), and not without `read-a-folder`, because it lands the
  arrival state.
- `read-the-diff` cannot exist without `see-what-changed`, because FR-17 is defined over "any file
  the Git view reports as changed" and the diff opens from that view.
- `read-the-history` cannot exist without `see-what-changed` — it is reached from the Git view
  (`docs/UXD.md` § 4, "Beyond v1, inside the terminus") — nor without `read-the-diff`, because a
  commit's diff is "the same diff presentation FR-17 requires" (FR-22).
- Preferences, recorded as preferences and not as edges: `read-markdown` before `see-what-changed`
  (each needs only `read-a-folder`); `switch-the-folder` before `read-the-diff` (step 5 gives the
  reason; § 7 carries no edge between them).

### Step 4 — Size each one against a reached-when

A slice is the right size when someone who **did not build it** can check it is finished from the
outside. Write the *Reached when* before deciding the slice is settled — the size follows the
checkable bar, not the other way round.

- **Too broad** when a plausible intermediate result could change the slice's direction or its
  acceptance. Two answers are hiding inside one slice.
- **Too narrow** when its result cannot change what happens next. Nothing is learned by finishing
  it, so it is a task inside a slice rather than a slice.

Cut where the decision changes, not where the size is convenient.

**Applied to Nozoki — the sizes, each named by the decision its bar settles** *(CPO; the bars'
observable wording is the CDO's and their machine-checkable half the CTO's — this step says only why
each slice is the size it is)*:

The sizes below are made on the owner's standing appetite — *smaller rather than larger, but not
too small* — and a cut call between two sizes that both pass the four tests is the seats' to make on
it, never the owner's; only an answer that changes what the product *promises* is parked
(`docs/sdd_trail/cycle-1.md` § 3.1, the owner's routing rule; RN-23).

- `read-a-folder` (E1) settles whether the shape keeps the promise by construction — one
  release-shaped check of AC-1 – AC-3 against a real repository and against a plain folder, with
  reading and the startup failure inside it. It takes either input alike: with no Git surface yet
  on the shell, a plain folder and a repository are the same slice here, and the finding-out is
  not (FR-33 lands with `see-what-changed`). Markdown is cut out of it (E2) because rendering
  untrusted content with no fetch and no execution (`docs/SRS.md` FR-32, NFR-16) is a decision of
  its own whose answer could change how the reading panel is built; a plain-text reading surface
  does not wait on it. The one-slice alternative was put to the owner in run 1 and came back
  *either is acceptable*; the two-slice cut is kept on the appetite above, and the question is not
  asked again (RN-1, RN-23).
- `read-markdown` (E2) settles the renderer and, with it, the two build-cost permissions the SRS
  routes here (FR-31, FR-32) — the CTO records the judgment — and now the read-only asset path for
  an image inside the folder (`docs/sdd_trail/cycle-1.md` § 2.4): a second decision, but one whose
  answer changes only this slice's bar, so it stays inside the slice rather than becoming one.
- `see-what-changed` (E3) settles how Git state is read without mutation (`docs/SRS.md` § 5.3 leaves
  installed-Git versus library to this document) and how a folder is found to be a repository's
  root or not without creating anything (FR-33); it is checkable against a repository with staged
  and unstaged changes, one mid-merge, one detached (AC-6, AC-18), against a plain folder (AC-24),
  and against one repository opened at its root, inside it, and above it (AC-25). The plain-folder
  half is not a slice of its own: an empty Git view proves nothing until there is a Git view.
- `watch-a-moving-tree` (E4) settles whether the view follows a tree being rewritten under it
  without blocking or writing (AC-7, AC-8, AC-19, AC-20) — the driving scenario, the one slice whose
  failure would send the shape back to § 2. Not folded into E1: a static read proves the promise
  without proving the watching, and they fail differently. FR-33's live clause — a repository
  appearing at the root mid-session or leaving it — is inside it, as one more change the view
  follows.
- `pick-it-up-release` (E5 with E6 folded in) settles the acquisition path inside C-3's bounds — the
  one decision a stranger meets — and is checkable by the timed walk (AC-10) and the release
  inspection (AC-14). It lands after the whole v1 cut, so that the first thing a stranger meets is
  the product `docs/PRD.md` § Scope (In) calls v1 — the owner's call
  (`docs/sdd_trail/cycle-1.md` § 3.3; RN-22); its place in the build order is § 7's.
- `read-the-diff` (E7) is checkable on its own (AC-12's diff clause) and its presentation is reused
  by `read-the-history`; smaller than one slice it would be a task.
- `read-the-history` (E8) is one slice: the default that asks nothing — the current branch and what
  relates to it — already needs the topology drawn, so a history against the current branch alone is
  not an intermediate result that could change the slice's direction, and the branch-set choice cut
  out would be a slice whose whole content is one control — *too small* on the appetite above
  (RN-23).
- `switch-the-folder` (E9) is checkable on its own (AC-12's switching clause, AC-13) and is what
  NFR-12 was written to make cheap; its bar is that nothing about either folder changes, and that a
  plain folder chosen lands its arrival state as a repository does (`docs/UXD.md` UX-F5).

### Step 5 — Order by what each slice falsifies

**The first slice is the smallest reversible one that proves the shape** — not the foundation the
rest will need. A first slice sized to the whole architecture cannot be wrong cheaply, and being
wrong cheaply is the one thing a first slice is for.

After the first, every slice's place in the order carries a reason: what an earlier slice must have
settled for it, or what it de-risks for the later ones. A slice that could sit anywhere in the order
says so plainly; a number is not a reason.

**Applied to Nozoki — the order** *(CTO; § 6 is numbered to it)*:

1. `read-a-folder` — the smallest reversible slice that proves § 2: one reader, one panel, across
   the IPC boundary, in the sandbox, in the bundle, under the harness — the bundle probe included,
   so that the ad-hoc-signed sandbox R-8 worries about is proved or disproved here. If the shape is
   wrong — the sandbox breaks a read, the boundary makes reading slow, the bundle will not launch
   on a clean machine, the entitlements do not bind under an ad-hoc signature — it is wrong here,
   with one reader written.
2. `read-markdown` — proves the second wall (sanitizer and CSP) against AC-23's hostile document
   while the reading panel is one treatment deep. It could sit anywhere before
   `pick-it-up-release`; it is placed here so the panel's second treatment is known before the Git
   surfaces widen it.
3. `see-what-changed` — the first crossing of the Git port; proves the root finding creates nothing
   (AC-24, AC-25) and `.git/index` stays byte-identical under status reads (RN-8) before slice 4
   starts reading it continuously.
4. `watch-a-moving-tree` — falsifies § 1's third question, the driving scenario, with both readers in
   place; before anything beyond v1, because every later surface inherits the refresh model.
5. `pick-it-up-release` — after the four above by dependency, not preference (step 3): its
   *Delivers* is the v1 cut. Before the three beyond v1 because `switch-the-folder` needs the
   own-state it lands, and because a first impression that matches the PRD's v1 is what the owner
   chose over an earlier proof of the channel (`docs/sdd_trail/cycle-1.md` § 3.3). The one thing
   this position would have deferred — the release gate's first exercise — it does not: C-I3's
   bundle probe has run on every build since slice 1.
6. `switch-the-folder` — first of the three beyond v1, because it falsifies § 3's claim that the
   folder is an input (NFR-12) before two more surfaces are built on the model; it needs own-state,
   which slice 5 lands.
7. `read-the-diff` — after 6 so that a failed NFR-12 claim is repaired before a third treatment is
   added to the panel; before 8 because history reuses its presentation.
8. `read-the-history` — last; it carries the closing release and the 1.0.0 tag (RN-2, C-6).

### The four tests one slice passes

<Apply all four to every block in § 6. A slice that fails one is not yet a slice.>

1. **It delivers something observable.** After it, something works that did not work before, and a
   person can watch it happen.
2. **Its inputs already exist when it starts.** Nothing it needs is still being built beside it.
3. **It states what it does not include** — the adjacent work a reader would assume is inside, and
   the slice that owns that instead.
4. **Its place in the order is a reason**, not a number.

### Six cuts that look like slices and are not

<Hunt these by name before § 6 is settled. The first five are the Principal PM's, at
`<CORE>/roles/loaders/principal_pm_global.md` § *You are not a scheduler*, applied here to a design;
the sixth is what a plan drifts into when it has a monitor in it.>

- **A dependency stated as an ordering preference** — a fact and a habit are not the same thing.
- **A slice whose only value is that a later slice needs it.**
- **A slice no Agari claims.**
- **A slice no project would own any of** — which project owns which seed is settled at the cut,
  not here, and a slice may well split across two.
- **A milestone that only restates its last task's completion.**
- **A slice whose completion evidence is that someone kept watching.** Observation is not delivery;
  a poll that reports no change keeps a plan alive without advancing it
  (`huangruiteng/loopx`, `skills/loopx-pr-program/SKILL.md`: "Quiet monitor polls keep liveness but
  do not count as delivery progress").

---

# Part C — The cut

## 6. The slices

<One block per slice, in the order they are to be built. Number them `S-1`, `S-2`, … and refer to a
slice by its slug everywhere else in this document. Copy the block below once per slice.>

<The numbering below is the CPO's provisional order of value; the build order is the CTO's by
step 5 and § 7, and the blocks are renumbered to it when § 7 is written. *Reached when*, *Rests on*
and *Why here in the order* are the CTO's and the CDO's and are left for them; *Traces to* carries
the PRD clause and leaves the SRS and UXD clauses to their seats.>

### S-1 — Read a folder, and leave it untouched

- **Slug:** `read-a-folder` *(renamed from `read-a-repository` at run 2 — RN-21)*
- **Delivers:** After this, a developer can start Nozoki against one local folder — a Git
  repository or not — browse its tree, read any file from it — highlighted in the six floor
  languages, plain text for any other text, a stated cannot-display state for what is not text —
  and close with the folder exactly as they found it.
- **Reached when:** *(CDO — the behaviour observable in the running product)* On a Mac that has
  never run it, a reader launches `Nozoki.app`, chooses `checks/fixtures/basic` in the Open panel,
  and sees one window: a chrome strip naming the folder, a rail carrying the *Files* entry — and
  only that entry, until `see-what-changed` gives *Git* a destination (RN-19) — the tree, and a
  reading panel showing one prompt to select a file and nothing else. Clicking a folder expands it
  in place; a folder not yet read shows the word *pending*, never as empty. Clicking a `.py` file
  puts its folder-relative path on the panel's first line and its content beneath, line-
  numbered, with keywords, strings, numbers, comments and names in distinct colours; a `.txt`, the
  extension-less `#!/bin/sh` script and the `.unknownext` file each show as plain text in one
  colour; a `.md` file shows as plain text here. Clicking a PNG shows, at the top left of the panel,
  a statement naming the file and saying its content is not shown as text, and the tree beside it
  still opens files. Typing, pasting and dropping into the panel change nothing on screen; no
  control anywhere writes, saves or edits, enabled or disabled; quitting with a file open presents
  no prompt. Relaunching and choosing `checks/fixtures/plain` — the same files, no `.git` — opens
  the same window, tree and panel, every file reading exactly as it did from `basic`, and nothing
  on screen tells the two folders apart: the shell has no Git surface yet (RN-19), and a plain
  folder is not a failure (`docs/UXD.md` UX-I17). Choosing a path that does not exist, is not a
  folder, or cannot be read shows in the window a statement of what Nozoki tried to open, what it
  observed and what to do, with an enabled control to choose again and a way to quit — no
  terminal output (UX-S4 as narrowed at v6). Every one of these renders the same with Wi-Fi off.
  *(CTO — the
  command, its result, the artifact)* `cargo test --workspace` exits 0, and inside it
  `checks/read-only.sh` prints `unchanged` against `checks/fixtures/basic` (a repository) and
  against `checks/fixtures/plain` (the same files, no `.git`) after `open_folder`, `list_tree` and
  `select_file` over every fixture file — the plain fixture's "unchanged" including that no `.git`
  and no entry of any kind appeared — and after the startup-failure path against a path that does
  not exist and against `checks/fixtures/unreadable` (a folder with no read permission) (AC-1,
  AC-2, AC-15's touched-nothing clause, AC-24's touched-nothing clause); `nozoki-core` links no
  `git-reader` in this slice and the model's root finding is never asked; `checks/floor.sh` prints
  one `ok <extension> <language>` line per extension in § 3's table and `ok plain` for the
  extension-less shebang script, a `.txt` and a `.unknownext` file in the fixture (AC-5's
  recognition cases); `cargo tauri build` produces `target/release/bundle/macos/Nozoki.app` and
  `Nozoki-<version>.dmg`, ad-hoc signed (C-R4); `checks/bundle.sh` passes — `codesign -d
  --entitlements :- Nozoki.app` lists exactly C-R2's entitlements and the launched bundle carries
  `APP_SANDBOX_CONTAINER_ID` (C-I3, the release gate exercised here first); `checks/no-network.sh`
  exits 0; `checks/latency.sh` prints a file-switch p95, recorded in these notes for the SRS to
  fold in (C-I4).
- **Rests on:** § 2; § 3 — `fs-reader`, `folder-model`, `ipc-surface`, `surfaces` (shell, tree,
  the reading panel's code and cannot-display treatments, the highlighter), `read-only-harness`;
  seams 1, 4, 5; § 4 — every C-R, C-I and C-D clause. No slice lands before it.
- **Traces to:** PRD § Key Use Cases 1 and 4 (the plain folder "browses and reads it exactly as in
  case 1"); § Core Features "Read-only viewing of any file in the repository, with syntax
  highlighting" (the floor and the plain-text fallback), "A file tree with … selected-file
  highlight", "An empty state"; § UX Notes "The path, end to end" steps 1, 2 and 5, "Failure
  states speak the user's language" (the path that does not exist, is not a folder or cannot be
  read — "A folder without Git is not on this list"; the cannot-display case); § Scope (In) "a
  single local folder … a Git repository or not", "Run posture"; § Success Metrics "Read-only
  integrity", "Zero required configuration"; SRS: FR-1, FR-2, FR-3, FR-4, FR-5, FR-7, FR-8, FR-9,
  FR-10, FR-23, FR-24, FR-29, FR-34 (the tree, reading and empty-state clauses — the Git-view
  clause waits for a Git view, `see-what-changed`); NFR-1 (measured, not met — C-I4), NFR-3,
  NFR-4, NFR-5, NFR-6, NFR-7, NFR-8, NFR-9, NFR-11, NFR-12, NFR-14, NFR-16 (the escaped-text
  half); DR-1, DR-2, DR-3, DR-6; C-1, C-2, C-11; AC-1, AC-2, AC-3, AC-4, AC-5 (all but its marker
  clause), AC-9, AC-15, AC-16, AC-21, AC-24 (its tree, reading and touched-nothing clauses; the
  Git-view clause with `see-what-changed`); UXD: UX-F1
  (arrive and read); § 4 "One window, one shell", "The shell names what it is looking at", "The
  reading panel names what is open"; UX-S1 (empty, loading, the cannot-display and cannot-read
  cells, success minus rendered Markdown), UX-S2 (all cells, success minus markers), UX-S4 (its
  v6 list: a path that does not exist, is not a folder, or cannot be read); UX-I17 (a plain folder
  opens — its Git-view and marker clauses wait for a Git view, `see-what-changed`); UX-I1, UX-I5,
  UX-I6, UX-I7, UX-I10, UX-I13, UX-I14, UX-I15, UX-I16 (for the file, tree and startup read
  paths); UX-A2 (the selection bar), UX-A4; § 9 (the direction and the monospace expectation).
  Not UX-I9: the shell renders in the polarity the platform reports, or light where none is read,
  and the theme control arrives with `pick-it-up-release`.
- **Moves toward:** The Agari's first condition — "file tree, reading with highlighting … against
  a plain folder as against a repository" — and its second: this is the first product the
  read-only bar is reckoned against, and it holds from here.
- **Not in this slice:** Markdown shown rendered — a Markdown file is plain text here
  (`read-markdown`). Changed-file markers in the tree, the Git view, and finding out whether the
  folder is a repository's root at all (`see-what-changed`) — here a repository and a plain folder
  are read alike, and the shell carries no Git surface to tell them apart. The view following a
  change on disk made after start (`watch-a-moving-tree`) — a slice, not a release, so the PRD's
  "the view never lies" rule is not yet met here and the fence says so. The two themes,
  remembered state, the install path and the README (`pick-it-up-release`). The numeric
  file-switch threshold (`docs/SRS.md` NFR-1) is measured from this slice's build and folded into
  the SRS by revision — a process, not a slice.
- **Why here in the order:** First, because it is the smallest reversible slice that proves § 2 —
  one reader and one panel across the IPC boundary, in the sandbox, in the bundle, under the
  harness; if the shape is wrong it is wrong here, with one reader written (§ 5 step 5).

### S-2 — Read Markdown rendered

- **Slug:** `read-markdown`
- **Delivers:** After this, a developer can open a Markdown file and read it rendered — an image
  that lives inside the folder shown in place, one from anywhere else left unfetched, nothing in
  it executed, every link displayed, an external one never followed.
- **Reached when:** *(CDO)* With Wi-Fi off, a reader clicks `README.md` in the tree and sees, under
  the same path line the code view uses, prose at reading size with three heading levels drawn
  distinct and code blocks set off on their own ground; no *Rendered* / *Source* control is on the
  panel. Clicking `checks/fixtures/hostile.md` shows: the external link as its own text followed
  by its destination in parentheses, and clicking it does nothing — no window, no dialog, no
  change on screen; the relative link the same way, and clicking it opens the target file in the
  panel with the tree's highlight moving to it, exactly as clicking that file in the tree does;
  the image whose file lives inside the fixture shown as the image itself, where the prose places
  it; where the remote image would be, a bordered box holding the image's alt text and its source
  and stating that remote content is not fetched; the two images whose paths escape the fixture —
  by `..` and by a symlink out of it — each shown as that same bordered box, never as an image
  (RN-26); the `<script>`, the event handler and the `<iframe>` rendered
  as nothing at all — no text of theirs on screen, nothing executed, no dialog. Switching to a
  code file and back to the Markdown file shows it rendered again. *(CTO)* `cargo test -p
  nozoki-core --test markdown` exits 0: rendering `checks/fixtures/hostile.md` — a remote image, a
  local image inside the fixture, an image whose path escapes the fixture by `..` and one by a
  symlink out of it, an external link, a relative link, a `<script>`, an inline event handler, an
  `<iframe>` — yields HTML containing no `<script`, no `on*=`, no `<iframe`, and exactly one
  `src=`, on the local image, whose value is on the `nozoki-asset` scheme and names the fixture-
  relative path; the remote image and both escaping images as the placeholder; the external link
  as inert text with its URL visible; the relative link as `data-nozoki-open="<path>"`; a request
  to the asset handler for the local image returns its bytes and for each escaping path returns
  nothing (C-D3); `checks/read-only.sh` on the fixture prints `unchanged`; `checks/no-network.sh`
  exits 0; the CSP string in `tauri.conf.json` equals C-R7's with the asset scheme's origin form
  filled in, and that form is recorded in these notes (Open Questions closed). The release notes
  of any release from this slice on state rendered-only (FR-31, RN-10).
- **Rests on:** § 3 — `markdown-renderer`, `fs-reader`'s containment check, `ipc-surface`'s asset
  handler, seam 7, seam 4's `open_relative_link` and the asset scheme; § 4 — C-R7, C-D3. Slices:
  `read-a-folder`.
- **Traces to:** PRD § Core Features "Markdown is rendered by default"; § Data & Privacy "v1 makes
  no network call at all during operation"; § Success Metrics "Read-only integrity" ("no
  non-essential network call"); SRS: FR-30, FR-31 (the build-cost judgment, RN-10), FR-32, NFR-8,
  NFR-16, DR-3, AC-22 (the rendered clause), AC-23; UXD: UX-I12 (rendered by default, nothing
  fetched, the link presentation, the not-fetched placeholder for remote content; the raw-source
  switch clause is not realized — RN-10; the local image shown in place is the owner's call,
  `docs/sdd_trail/cycle-1.md` § 2.4, folded as RN-11 — UX-I12 forbids only fetching); UX-S1 (success, "rendered for Markdown"); § 9 last constraint (two
  treatments of one panel); § 4 "The reading panel names what is open".
- **Moves toward:** The Agari's first condition, "reading with highlighting" — the reading surface
  the PRD draws includes rendered Markdown; and its second, "no non-essential network call", held
  on rendered content.
- **Not in this slice:** The raw-source switch — a permission the PRD and SRS condition on build
  cost, not a promise (`docs/PRD.md` § Core Features "permitted, not promised"; `docs/SRS.md`
  FR-31), the judgment the CTO's and recorded in this document (RN-10), and a release without it
  says so where it is offered. A relative link opening its target is the same class of permission
  (FR-32); whether it is taken is likewise RN-10's, not a promise of this slice. A remote image
  fetched — never (`docs/PRD.md` § Data & Privacy). Rich rendering of non-text content — outside
  the product (`docs/PRD.md` § Out of Scope).
- **Why here in the order:** Second, to prove the second wall — the host-side sanitizer and the
  CSP — against AC-23 while the reading panel is one treatment deep. It could sit anywhere before
  `pick-it-up-release`; it is placed here so the panel's second treatment is known before the Git
  surfaces widen it (§ 5 step 5).

### S-3 — See what changed

- **Slug:** `see-what-changed`
- **Delivers:** After this, a developer can switch the sidebar to Git and, where the folder is a
  repository's root, see the branch, the changed files, the staged files and the short status at
  a glance, see changed files marked in the tree, and open a changed file from the Git view to
  read it — a repository mid-merge, mid-rebase or detached shown as the state it is in, never as
  an error; and where the folder is not a repository's root — a plain folder, a folder inside a
  repository, a folder holding repositories — find the Git view there and showing nothing, and
  the tree unmarked, with nothing created to find that out.
- **Reached when:** *(CDO)* The rail now carries *Git* beneath *Files*, each a glyph over its word.
  Against `checks/fixtures/staged-unstaged`, with a file open and scrolled, a reader clicks *Git*
  and sees, in the sidebar: the branch name; a *Changes* heading with the modified and the
  both-staged-and-modified files under it; a *Staged* heading with the staged files; the short
  status; each file's name followed by its status letter, name and letter in one hue; and a count
  after each heading. Before Git state is read the view shows the word *pending* and no count, no
  letter and no "nothing changed". Resting the pointer on a letter — not the row — shows one line
  naming the file and then the letter's word. Switching to *Files* shows the same files coloured
  and lettered in the tree, and the open file and its scroll position are exactly as left — so is
  the sidebar after switching back. Clicking a file in the Git view opens it in the panel as the
  tree would, with the tree's highlight on it. Against `checks/fixtures/mid-merge` the view names
  the merge in progress and lists the conflicting files with `C`, no failure treatment on the
  surface; against `checks/fixtures/detached` it names the detached state and the commit; against
  a clean repository it states that nothing changed, after reading, never a blank pane. Against
  `checks/fixtures/plain`, `checks/fixtures/basic/src` (a folder inside a repository) and
  `checks/fixtures/parent` (a folder holding two repositories) alike: the rail still carries
  *Git*; before the tool has found out, the view shows the word *pending*; once it has, the view
  is present and shows nothing at all — no message, no label, no control, no count, nothing that
  offers to create a repository — and switching to *Files* shows the tree with no letter or hue on
  any file; the shell adds no other cue, and only the clean repository's branch name and its
  "nothing changed" tell the two apart (`docs/UXD.md` UX-S3, UX-I17). *(CTO)*
  `cargo test -p nozoki-core --test git_state` exits 0 over `checks/fixtures/staged-unstaged` (a
  named branch; one file staged, one modified, one both), `checks/fixtures/mid-merge` and
  `checks/fixtures/detached`: repository state, HEAD / branch, changed[], staged[] and short
  status equal what each fixture's build script declares; and `--test root_finding` exits 0: the
  port's `probe` answers `root` for those three, for `checks/fixtures/linked-worktree` and
  `checks/fixtures/submodule` opened at their own top level (each then reporting its *own* HEAD,
  not the enclosing repository's), and `plain` for `checks/fixtures/plain`, for
  `checks/fixtures/basic/src` (a folder inside a repository) and for `checks/fixtures/parent`
  (a folder holding two repositories) — on `plain` the model's GitState is absent and every
  Git-derived projection empty (AC-24, AC-25); `checks/read-only.sh` prints `unchanged` on every
  fixture above — `.git/index` byte-identical included, and on the three `plain` fixtures no
  `.git` and no entry of any kind created; `checks/no-network.sh` exits 0 with libgit2 linked.
- **Rests on:** § 3 — `git-reader` and its root finding, the Git port (seam 2), the Folder's root
  finding, GitState and the tree markers in `folder-model`, the Git view's empty projection (seam
  5); § 4 — C-R6, C-I1. Slices: `read-a-folder`.
- **Traces to:** PRD § Key Use Cases 2 and 4 ("The Git view is there and shows nothing"); § Core
  Features "A file tree with changed-file markers", "A sidebar that toggles between Files and
  Git", "A Git view" (with its plain-folder clause), "Git is read only when the folder opened is
  itself the root of a Git repository"; § UX Notes "The path, end to end" step 3 (the empty view
  as "a working state, not an error"), "the view never lies" (the mid-operation case); § Out of
  Scope "Git found anywhere but at the opened folder's root", "Creating or initialising a Git
  repository"; § Success Metrics "Read-only integrity" ("no Git mutation"), "Zero required
  configuration" ("found, never asked"); SRS: FR-33, FR-34, AC-24, AC-25, FR-6, FR-11, FR-12, FR-13, FR-25, FR-26, NFR-3, NFR-6, DR-4, AC-5 (the
  marker clause), AC-6, AC-17, AC-18, AC-24 (the Git-view clause), AC-25; UXD: UX-F2 (check what changed, its plain-folder switch); § 4 "The sidebar toggles
  between Files and Git" (the rail); UX-S3 (all cells — the plain-folder empty cell included), UX-S2 (success — the markers, and none in a plain folder); UX-I17 (the Git view present and showing nothing; the tree unmarked); UX-I3 (the
  sidebar mode and the open file survive the switch), UX-I13 (no marker before Git state is read),
  UX-I16 (the Git-state read path); UX-A2 (the letter carries the meaning), UX-A4 (the rail's
  labels).
- **Moves toward:** The Agari's first condition, "Git status" — and its "against a plain folder
  as against a repository", since this is the slice where the two inputs first look different;
  and its second — "no Git mutation" is first exercised by a product that reads Git state, and
  "no write to the viewed folder — whether or not it is a repository" by one that finds out which.
- **Not in this slice:** Git state following the disk after start, a repository appearing at the
  root mid-session included (`watch-a-moving-tree`). The diff of a changed file (`read-the-diff`).
  Commit history (`read-the-history`). Any Git operation, and any offer to create or initialise a
  repository in a plain folder — outside the product, in every version (`docs/PRD.md` § Out of
  Scope).
- **Why here in the order:** Third — the first crossing of the Git port. It proves `.git/index`
  stays byte-identical under status reads (RN-8) before `watch-a-moving-tree` starts reading it
  continuously (§ 5 step 5).

### S-4 — Watch a moving tree

- **Slug:** `watch-a-moving-tree`
- **Delivers:** After this, a developer can leave Nozoki open over a folder an automated tool or
  agent is changing and watch every change — file content, the tree, Git state, a repository
  appearing at the folder's root or leaving it — appear on its own within the refresh bar, their
  expanded tree, open file and reading position kept, a vanished open file stated as gone.
- **Reached when:** *(CDO)* A reader opens a file, scrolls halfway, expands two folders, and does
  nothing else; from a terminal beside the window they act on the repository and watch. `touch` a
  new file: its row appears in the tree, nothing else on screen moves, nothing flashes, the
  expanded folders stay expanded and the scroll position holds. Append to the open file: its
  content changes in place, the view still at the same position. `git add` it: in the Git view the
  file moves from under *Changes* to under *Staged*, and its letter in the tree follows. Delete the
  open file: the panel keeps its path line and states, at the top left, that the file is no longer
  there — the old content is not on screen — and its tree row is gone; the tree beside the panel
  still opens files. During `checks/churn.sh` the reader clicks folders and files and each click
  answers; when the script ends the tree and the Git view match `ls` and `git status` in the
  terminal. No refresh control exists anywhere on the shell. Quitting mid-churn presents no prompt.
  With `checks/fixtures/plain` viewed, a file open and scrolled and the Git view showing nothing,
  the reader runs `git init` at the folder's root from the terminal: the Git view fills on its own
  — the branch name and its "nothing changed", then, after `git add` of two files, those files
  under *Staged* with their letters — and switching to *Files* shows the letters and hues on those
  two rows, the expanded folders still expanded, the open file and its scroll position untouched
  throughout; the reader then removes `.git` and watches the Git view empty back to nothing and
  every letter and hue leave the tree, again with nothing else on screen moving — no message
  either way, and nowhere a control that did it (`docs/UXD.md` UX-I17's live sentence, UX-I2,
  UX-I3). *(CTO)* `cargo test -p nozoki-core --test watch` exits 0: `checks/churn.sh <fixture> 30` runs
  thirty seconds of scripted create / modify / delete — the displayed file included — with `git
  add`, `git stash` and `git checkout -b` mid-flight; run against `checks/fixtures/plain` the
  script also runs `git init` at the root mid-flight and later removes `.git`, and the model's root
  finding goes `plain` → `root` → `plain` with the GitState appearing and vanishing with it
  (FR-33's live clause); the host does not panic, the model's final snapshot equals a fresh open
  of the fixture, and its expanded, selected and reading-position fields survive the run;
  `checks/read-only.sh` prints `unchanged` against the churn script's own final state as baseline;
  `checks/latency.sh` prints refresh p95 over `checks/fixtures/scale-small`, `scale-medium`,
  `scale-large`, the sizes recorded in these notes for the SRS to fold in (C-I4).
- **Rests on:** § 3 — `watcher` (the root's `.git` entry included), seam 3, the reducer, the
  re-run of the root finding and ItemState in `folder-model`; § 4 — C-I1, C-I4. Slices:
  `read-a-folder`, `see-what-changed`.
- **Traces to:** PRD § Key Use Cases 3 and 4 ("the live refresh work[s] as [it] always do[es]" in
  a plain folder); § Target Users (the driving scenario); § Core Features "Live refresh"; § UX
  Notes "The path, end to end" step 4, "The rule for every live state: the view never lies";
  § Success Metrics "Refresh immediacy", "Read-only integrity" (under concurrent change); SRS:
  FR-33 (the live clause), FR-34, FR-14, FR-15, FR-16, FR-27, FR-28, NFR-2 (measured — C-I4), NFR-3,
  NFR-4, NFR-10 (measured), DR-2, DR-6, AC-7, AC-8, AC-19, AC-20; UXD: UX-F3 (watch a moving
  tree); UX-U2 (read in glances, never asks for an action to stay current); UX-I2, UX-I3, UX-I4,
  UX-I5, UX-I10; UX-I17 (the live sentence — a repository appearing or leaving mid-session arrives
  as every change does); UX-S1 (the open-file-gone cell), UX-S2 (loading — a folder pending as it
  is re-read); UX-S3 (the empty and the clean cells, each way).
- **Moves toward:** The Agari's first condition, "live refresh"; and its second, held under the
  condition the product exists for — a tree rewritten while it is watched.
- **Not in this slice:** A manual refresh control — never (`docs/PRD.md` § UX Notes step 4). The
  numeric refresh threshold's value (`docs/SRS.md` NFR-2) and the scale reference sizes (NFR-10) —
  measured from this slice's build and folded into the SRS by revision, a process, not a slice.
  Diffs of what changed (`read-the-diff`).
- **Why here in the order:** Fourth — it falsifies § 1's third question, the driving scenario, and
  needs both readers in place to watch both sources; before anything beyond v1, because every later
  surface inherits the refresh model (§ 5 step 5).

### S-5 — A stranger picks it up

- **Slug:** `pick-it-up-release`
- **Delivers:** After this, a stranger can install Nozoki by its one path and, guided by the README
  alone, be reading a file of their own folder within five minutes — the whole v1 cut behind it: a
  repository or a plain folder, the tree, reading, Git status where there is Git, live refresh —
  in the theme their machine uses, switchable and remembered outside the folder, under the MIT
  licence, with the support posture stated and the security channel open.
- **Reached when:** *(CDO)* On a Mac whose appearance is set to Dark and that has never run
  Nozoki, a stranger holding only the README reaches a viewed file of their own repository — the
  walk AC-10 times — and the shell opens dark. The chrome's right end shows a sun glyph with the
  word *Light* beside it; clicking it switches every surface to light with no transition, and the
  control now shows a moon with *Dark*. Quitting and relaunching opens light; setting the Mac to
  Light on a machine that has never seen the control opens light. Every surface this release
  reaches — the tree, the Git view if present, each reading-panel treatment, each failure state —
  is read in both themes, and neither theme shows pure black or pure white. Every picture of the
  shell on the README shows exactly the shell this release draws — no element in a screenshot the
  release lacks, none in the release the screenshot omits. Below the README's first screen, one
  sentence states the accessibility posture in the wording `docs/CONTENT.md` § Standing sentences
  fixes; the first screen does not carry it. Nothing the README shows is fetched from an origin
  other than the repository. *(CTO)* A release `v0.y.z` exists at
  `github.com/kensaiapp/nozoki/releases` carrying `Nozoki-0.y.z.dmg` and `SHA256SUMS`, produced by
  `.github/workflows/release.yml` from the tag with no signing identity in the workflow's secrets
  and `codesign -dv Nozoki.app` on the downloaded bundle reporting an ad-hoc signature
  (`Signature=adhoc`) (C-R4); `shasum -a 256 -c SHA256SUMS` passes against a rebuild from that tag;
  `checks/bundle.sh` passes on the downloaded bundle — the same probe that has passed on every CI
  build since `read-a-folder` (C-I3, § 11 R-8); the release page and the README carry the
  pre-1.0.0 anything-may-change line and the macOS 14 floor (C-R5), and the README's first screen
  carries the download, the drag to Applications and the Privacy & Security step, with no
  terminal command (C-R4); `LICENSE` is MIT; `THIRD_PARTY_NOTICES.md` lists every shipped crate and
  package with its licence (C-5); `SECURITY.md` exists; `gh api
  repos/kensaiapp/nozoki/private-vulnerability-reporting` returns `"enabled": true`
  (https://docs.github.com/en/rest/repos — "Check if private vulnerability reporting is enabled for
  a repository"); after a theme change, `checks/own-state.sh` finds changed files only under
  `~/Library/Containers/com.kensaiapp.nozoki/` and none under the fixture (AC-13); AC-10's timed walk
  is recorded with its time, the Gatekeeper step inside the clock.
- **Rests on:** § 3 — `own-state`, seam 6, the shell chrome's theme control, `read-only-harness`'s
  bundle probe; § 4 — C-R1, C-R4, C-R5, C-I3, C-D2, C-D4. Slices: `read-a-folder`, `read-markdown`,
  `see-what-changed`, `watch-a-moving-tree` — the v1 cut its *Delivers* names.
- **Traces to:** PRD § Goals "Pick-it-up adoption"; § Success Metrics "Time-to-first-success",
  "Zero required configuration"; § Scope (In) "Run posture" (one path, simple) and "Platform";
  § Assumptions "Licence", "Public identity", "Support posture", "Versioning" (the pre-1.0.0
  statement), "Regulatory posture"; § UX Notes "The character" (dark and light themes from the
  start); § Data & Privacy (own state, "never inside the folder it is pointed at"); § Risks "Maintenance is a
  standing liability"; SRS: FR-20, FR-21, NFR-13, NFR-14, NFR-15, DR-5, C-3, C-4, C-5, C-6 (the
  pre-1.0.0 clause), C-7, C-9, C-11, C-12, C-13, AC-9, AC-10, AC-11, AC-13, AC-14; UXD: UX-I9
  (both themes, the platform-signal default, light where no signal, the remembered override);
  § 4 "The theme control lives in the shell chrome, at its right end"; UX-I11 (public pictures
  tell the same truth); UX-A1 and UX-A3 (the posture, and where the README states it); UX-I15
  (the README's assets, through the fence's README clause). The install walk itself is outside
  the UXD (§ 10, "The acquisition-and-start experience") and traces to the PRD alone.
- **Moves toward:** The Agari's third condition, "It stands on its own" — public under MIT, the
  README alone taking a stranger to a viewed file — short of the 1.0.0 that closes it; and its
  second, reckoned at a release for the first time.
- **Not in this slice:** 1.0.0 — the closing release is carried by whichever of `read-the-diff`,
  `read-the-history` and `switch-the-folder` lands last (RN-2); this release states that anything
  may change (`docs/PRD.md` § Assumptions "Versioning"). A public release of less than the v1 cut —
  never: this slice lands after `read-a-folder`, `read-markdown`, `see-what-changed` and
  `watch-a-moving-tree`, so its README describes the product the PRD calls v1 and nothing short of
  it (the owner's call, `docs/sdd_trail/cycle-1.md` § 3.3; RN-22). Proving the bundle, the
  entitlements and the sandbox gate before this slice — a check, not a release, and where it sits
  is the CTO's (§ 4 C-I3). A second platform — outside done (`docs/SRS.md` § 2).
- **Why here in the order:** Fifth — after the four v1 slices by dependency, since its *Delivers*
  is the v1 cut (§ 5 step 3; the owner's call, `docs/sdd_trail/cycle-1.md` § 3.3), and before the
  three beyond v1 because `switch-the-folder` needs the own-state it lands. The proof this position
  might have deferred — that the ad-hoc-signed bundle passes the sandbox gate — has run on every
  build since `read-a-folder` (C-I3), so what this slice first exercises is the channel and the
  stranger's walk, nothing about the bundle (§ 5 step 5).

### S-6 — Switch the viewed folder

- **Slug:** `switch-the-folder` *(renamed from `switch-the-repository` at run 2 — RN-21)*
- **Delivers:** After this, a developer can choose another folder from the shell — one Nozoki
  remembers, or one browsed to; a repository or a plain folder — and be at the arrival state for
  it without restarting, always exactly one at a time, with nothing about either folder changed.
- **Reached when:** *(CDO)* The chrome's left end shows the viewed folder's name with a chevron
  after it. With `checks/fixtures/staged-unstaged` (A, a repository) open on first run, clicking
  the name opens a list holding *Browse…* and nothing else; choosing *Browse…* opens the system
  Open panel, and choosing `checks/fixtures/plain` (B) there puts the shell at the arrival state
  for B — its name in the chrome, its tree with no marker on any file, the panel's one prompt, and
  the Git view, once read, present and showing nothing at all: no message, no control, no offer
  to create a repository (`docs/UXD.md` UX-I17). Clicking the name again lists A and B, the
  current one marked with the bar a selected row carries, and choosing A lands A's arrival state
  — its markers back in the tree, its branch and changes back in the Git view. At no moment are
  two folders' trees, names or Git states on screen. Choosing a path that does not exist, is not
  a folder, or cannot be read shows the same statement the startup failure shows — what was
  tried, what was observed, what to do — with the current folder still viewed behind it and the
  selector still open as the way back (UX-S7); nothing in A or B changes, which the reader
  confirms with `git status` in A and with a listing of B that shows no `.git`. *(CTO)*
  `cargo test -p nozoki-core --test switch` exits 0: opening fixture A (`staged-unstaged`, a
  repository) and then fixture B (`plain`) leaves a model equal to a fresh open of B holding
  nothing of A — B's root finding `plain`, its GitState absent — and back to A a model equal to a
  fresh open of A; `checks/read-only.sh` prints `unchanged` on A and on B; `checks/own-state.sh`
  finds B's bookmark, display name and last-viewed mark in own-state and no folder content;
  relaunching the bundle opens B with no Open panel, and relaunching after own-state's remembered
  list is cleared presents the panel (C-R3); `git diff --stat <pick-it-up-release tag>..HEAD --
  nozoki-ui/src/tree nozoki-ui/src/git-view nozoki-ui/src/reading-panel` prints nothing — the
  viewing surface untouched (NFR-12); `checks/bundle.sh` passes with the entitlement list gaining
  `com.apple.security.files.bookmarks.app-scope` and nothing else (C-R2).
- **Rests on:** § 3 — the replace-whole rule in `folder-model`, `own-state` bookmarks and the
  last-viewed entry, the shell chrome's selector, seam 4's `switch_folder`; § 4 — C-R2, C-R3 (the
  restore-on-launch clause), C-D4. Slices: `read-a-folder`, `pick-it-up-release`.
- **Traces to:** PRD § Scope (In) "one folder at a time is a v1 cut, not a permanent property";
  § Out of Scope "Changing the viewed folder without restarting — beyond v1", "Several folders at
  once"; § Data & Privacy (the remembered list is own state, outside the folder); SRS: FR-19, FR-3 (through the selector), NFR-12, DR-5, AC-12 (the switching
  clause), AC-13, AC-15; UXD: UX-F5 (switch the viewed folder — "a repository or a plain folder
  alike"); UX-S7 (all cells, its v6 failure list); UX-I17 (the plain folder's arrival state); § 4
  "The shell names what it is looking at" (the identity element is the selector); UX-S4 (the
  failure language reused, and its beyond-v1 route out).
- **Moves toward:** The Agari's first condition, "switching the viewed folder without restarting
  (always one at a time)" — "switching is about the input and so takes any folder".
- **Not in this slice:** Several folders at once — never (`docs/PRD.md` § Out of Scope). The
  folder supplied at start (`read-a-folder`). Finding out whether the folder switched to is a
  repository's root (`see-what-changed` — applied afresh here, not redone). Where the tool's own
  state lives (`pick-it-up-release`) — this slice adds the remembered list to it.
- **Why here in the order:** Sixth — first of the three beyond v1, because it falsifies § 3's claim
  that the repository is an input (NFR-12) before two more surfaces are built on the model; it needs
  own-state, which `pick-it-up-release` lands (§ 5 step 5).

### S-7 — Read the diff

- **Slug:** `read-the-diff`
- **Delivers:** After this, a developer can open any changed file's diff from the Git view and read
  it, staged changes distinguished from unstaged.
- **Reached when:** *(CDO)* A reader clicks a changed file's row in the Git view — the row is
  one click target and it opens the diff, the status letter beside it a label and nothing more
  (the owner's call, `docs/sdd_trail/cycle-1.md` § 1.2; RN-20) — and the reading panel shows,
  under the file's path line, the
  changed lines with a `+` or `−` in the gutter and a tint behind each, unchanged context in plain
  ink, and no syntax colour. For the file that is both staged and modified, the hunks sit under
  two headings, *Staged* and *Unstaged*, and nothing but the heading tells them apart. Opening the
  diff of a file that has no remaining changes shows a statement saying so, not an empty panel.
  Nothing on the diff can be clicked to stage, discard or edit. Clicking a file in the tree beside
  it leaves the diff for that file's content — the tree, not the Git view, is where a file is
  read from this slice on — and clicking the file's row in the Git view again shows its diff.
  *(CTO)* `cargo test -p nozoki-core --test diff` exits 0 over
  `checks/fixtures/staged-unstaged`: for the file both staged and modified, two payloads — kind
  `staged` (HEAD → index) and kind `unstaged` (index → worktree) — whose hunks equal what the
  fixture's build script declares; `checks/read-only.sh` prints `unchanged`.
- **Rests on:** § 3 — `git-reader`'s diff calls through the Git port, the Diff entity, the reading
  panel's diff treatment, seam 4's `open_diff`; § 4 — C-I1. Slices: `see-what-changed`.
- **Traces to:** PRD § Scope (In), the full ambition — "diffs"; § Out of Scope "Diff and
  commit-history views — beyond v1"; SRS: FR-17, NFR-3, DR-4, AC-12 (the diff clause); UXD: UX-F4
  (the diff steps and its read-only failure clause); UX-S5 (all cells); § 4 "Beyond v1, inside the
  terminus" (a diff is shown in the reading panel); UX-A2 (staged / unstaged in text as well as
  colour); § 9 last constraint (a treatment of the one panel). The control that opens a diff
  rather than the file is a gap in the UXD, routed to the companion (§ 1.2), not filled here.
- **Moves toward:** The Agari's first condition, "diffs"; the presentation is the one
  `read-the-history` reuses per commit.
- **Not in this slice:** A commit's own diff (`read-the-history`). A diff in a plain folder —
  there is none: the Git view holds nothing to open one from (`docs/SRS.md` FR-17, FR-34), and
  this slice adds no state to that view. Staging, discarding, or any act on what the diff shows —
  outside the product, in every version (`docs/PRD.md` § Out of Scope).
- **Why here in the order:** Seventh — after `switch-the-folder` so that a failed NFR-12 claim
  is repaired before a third treatment is added to the panel; before `read-the-history` because
  history reuses its presentation (§ 5 step 5).

### S-8 — Read the history as branches

- **Slug:** `read-the-history`
- **Delivers:** After this, a developer can open the commit history from the Git view and read it
  as branches — which commits belong to which, where they diverge and merge — against a chosen set
  of branches with a default that asks nothing, each commit's identifier, message, author and date
  shown, and any commit's own diff opened from its entry.
- **Reached when:** *(CDO)* Against `checks/fixtures/branches`, a reader opens the history from
  the Git view — by the entry the Git view carries for it — and, without being asked anything,
  sees a graph: commit rows in one list, each with its identifier, message, author and date, rails
  drawn between them so that the three branches read as three lines, the divergence and the merge
  visible as the rails splitting and joining, the merge commit marked with its own glyph, and each
  branch named in a chip at its tip commit — no per-branch colour. The set drawn by default is
  the current branch and what relates to it. A control on the history view opens the branch set;
  choosing one, several or all redraws the graph to that set. Clicking a commit shows what it
  changed in the reading panel, in the same presentation `read-the-diff` draws. While the history
  is still being read the view shows the word *pending*, never a shorter list; against a
  repository with no commits it states that there are none. Nothing on the view checks out,
  switches or acts on a branch. The history is drawn in the sidebar, as rows beneath the Git
  view's changes list, and the reading panel stays free for the diff a commit opens (the owner's
  call, `docs/sdd_trail/cycle-1.md` § 1.3; RN-20). *(CTO)* `cargo test -p nozoki-core --test history` exits 0 over
  `checks/fixtures/branches` (three branches, one merge, one divergence): every commit's parents
  and branch membership equal what the fixture's build script declares; the default set computes
  to the set the script declares (RN-16); a commit's diff payload is kind `commit` and equals the
  script's; `checks/read-only.sh` prints `unchanged`; `checks/latency.sh` prints the history
  figures over `scale-large`. The closing release is tagged `v1.0.0`, AC-12 holds whole on it, and
  C-I3's harness is green on that build.
- **Rests on:** § 3 — `git-reader`'s walk through the Git port, the History entity, the history
  surface, seam 4's `walk_history`; § 4 — C-I1, C-I4. Slices: `see-what-changed`, `read-the-diff`.
- **Traces to:** PRD § Scope (In), the full ambition — "commit history"; § Out of Scope "Diff and
  commit-history views — beyond v1"; SRS: FR-18, FR-22, NFR-10, DR-4, AC-12, C-6 (the 1.0.0
  clause); UXD: UX-F4 (the history steps: branches as branches, the chosen set, the default that
  asks nothing, the per-commit fields, a commit's diff); UX-S6 (all cells); § 4 "Beyond v1, inside
  the terminus" (history reached from the Git view); RN-14 (the owner-settled shape, carried).
  The history view's home in the shell — the sidebar — is the owner's answer
  (`docs/sdd_trail/cycle-1.md` § 1.3), cited until the UXD carries it (RN-20).
- **Moves toward:** The Agari's first condition, "commit history".
- **Not in this slice:** History filtering and search — outside done (`docs/SRS.md` § 2;
  `docs/UXD.md` § 10); the branch-set choice is not a filter. A history in a plain folder — there
  is none, and the empty Git view carries no entry to reach one from (`docs/SRS.md` FR-18, FR-34).
  Branch switching or any branch operation — outside the product, in every version.
- **Why here in the order:** Last — it carries the closing release and the 1.0.0 tag (RN-2, C-6),
  and it is the one slice that needs both the Git port's walk and the diff treatment already
  standing (§ 5 step 5).

## 7. The order, and why

<The dependency edges between the slices in § 6, one row each. This table is a **projection of
§ 6, not a second store**: when the two disagree, § 6 is right and this table is stale
(`huangruiteng/loopx`, `docs/reference/protocols/task-graph-projection-v0.md` — the graph is
read-only over state that lives elsewhere).

Use these relations and no others. `depends_on` is the only one that constrains the build order;
the rest describe the cut without ordering it.>

*(CTO — a projection of § 6's *Rests on* and § 5 step 3's answers; when they disagree, § 6 is
right.)*

| From | Relation | To | Why — the reason this holds |
|---|---|---|---|
| `read-markdown` | `depends_on` | `read-a-folder` | the rendered view is a second treatment of the one reading panel over a file `fs-reader` delivered (`docs/UXD.md` § 9) |
| `see-what-changed` | `depends_on` | `read-a-folder` | markers sit on the tree, and a Git-view file opens "exactly as a tree selection is" (FR-13) |
| `watch-a-moving-tree` | `depends_on` | `read-a-folder` | the tree and the open file are what the refresh updates (FR-27) |
| `watch-a-moving-tree` | `depends_on` | `see-what-changed` | "every change — file content, the tree, Git state" (FR-14) and a root appearing (FR-33) cannot show without a Git view and a root finding |
| `pick-it-up-release` | `depends_on` | `read-a-folder` | AC-10's walk ends at a viewed file |
| `pick-it-up-release` | `depends_on` | `read-markdown` | its *Delivers* is the v1 cut, which includes rendered Markdown (`docs/sdd_trail/cycle-1.md` § 3.3; RN-22) |
| `pick-it-up-release` | `depends_on` | `see-what-changed` | its *Delivers* is the v1 cut, which includes Git status (same source) |
| `pick-it-up-release` | `depends_on` | `watch-a-moving-tree` | its *Delivers* is the v1 cut, which includes live refresh (same source) |
| `switch-the-folder` | `depends_on` | `read-a-folder` | it lands the arrival state |
| `switch-the-folder` | `depends_on` | `pick-it-up-release` | the remembered list lives in own-state, which that slice lands (DR-5) |
| `read-the-diff` | `depends_on` | `see-what-changed` | FR-17 is defined over "any file the Git view reports as changed" and opens from that view |
| `read-the-history` | `depends_on` | `see-what-changed` | reached from the Git view (`docs/UXD.md` § 4) over the Git port that slice opens |
| `read-the-history` | `depends_on` | `read-the-diff` | a commit's diff is "the same diff presentation FR-17 requires" (FR-22) |
| `watch-a-moving-tree` | `validates` | `read-a-folder` | proves the shape under motion — § 1's third question — on the reader slice 1 built |
| `see-what-changed` | `validates` | `read-a-folder` | proves the root finding creates nothing and the plain folder was already whole without Git (AC-24, AC-25) |
| `switch-the-folder` | `validates` | `read-a-folder` | proves § 3's replace-whole rule: the folder was an input, not a singleton (NFR-12) |
| `pick-it-up-release` | `validates` | `read-a-folder` | proves the channel C-R4 fixed reaches a stranger inside C-3's bounds; the bundle and its sandbox were proved by C-I3 from slice 1 |
| `read-the-diff` | `hands_off_to` | `read-the-history` | the diff treatment of the reading panel, taking a Diff payload of kind `commit` |
| `pick-it-up-release` | `hands_off_to` | `switch-the-folder` | the own-state store, to which the remembered list and its bookmarks are added |

No `supersedes` edge exists: no slice stops being needed. The preference `switch-the-folder`
before `read-the-diff` is § 5 step 5's and carries no row.

## 8. Slice → seeds

<Stated once, here, so that cutting a slice is reading rather than re-deriving. A slice is **not a
seed**: the Principal PM draws one and cuts it into **one or more** 根回し Nemawashi seeds, authored
to `<CORE>/templates/journey-templates/nemawashi_template.md`. How many, and when a slice is drawn
at all, are that seat's — `<CORE>/roles/loaders/principal_pm_global.md` § *The loop* owns the round,
and this section neither restates it nor constrains it. What this section owns is the other half:
where a slice's fields land once the cut is made. Leave this table as written.>

<Because a slice can yield several seeds, a field does one of three things, and the third column
says which. **Repeats** — the fact binds every seed cut from the slice, and each carries its own
copy, because each is read cold with no sibling beside it. **Divides** — the slice's whole is split
and each seed states only its share; copied whole instead, every seed would claim the slice's full
delivery. **Stays here** — a fact about this slice's place among slices, which no seed carries.>

| Slice field | Seed section | Across the seeds |
|---|---|---|
| **Slug** | recorded in `## Source` as the slice this seed came from | repeats |
| **Delivers** | `## What it is` | divides — each share must be worth something on its own, or it is a fragment (§ 5 step 2) |
| **Rests on**, the SDD sections it realizes | `## What it is` | repeats |
| **Moves toward** | `## What it is` | repeats — a seed that advances no Agari is a finding |
| **Traces to**, and this SDD's path | `## Source` | repeats, narrowed to what the seed's share touches |
| **Rests on**, the slices it names by slug | `## Relation to existing work` | repeats — the order *among* these seeds is decided at the cut and is not in this SDD |
| **Not in this slice** | `## Out (later / elsewhere)` | repeats, and grows — each seed also fences off its siblings' shares, naming the seed that owns each |
| **Reached when** | the bar each 宿場 Shukuba opened from that seed is closed against | divides — the slice's own bar is met when the last of its seeds closes |
| **Why here in the order** | — | stays here |

**A seed's `## Stations — dynamic checklist` is not in this table, and that is a decision.** No
field of a slice maps to it: the route a seed is walked by is the PM's, drawn at the cut and after
it, and nothing in this document proposes one. An SDD that named the change units a slice should
break into would be writing the PM's checklist under another name — and a route written by the seat
that designed the thing anchors the seat that has to walk it, however plainly it is labelled a
suggestion. The owner's call, 2026-08-26.

**No field lands in exactly one of the seeds.** Where one looks as though it should — a dependency
in *Rests on* that only one seed turns out to consume — the edge in § 7 was drawn coarser than the
work it constrains. That is a finding about § 7, not a call to be made at the cut.

**A slice that cannot fill one of these fields is not yet a slice — go back to § 5.** The rule
survives the cut being one-to-many and binds harder for it: an unfillable field is no longer one gap
in one seed, it is the same gap in every seed the slice yields. A slice whose *Delivers* is vague
cannot be divided into shares that each stand on their own, and a slice with no fence leaves every
one of its seeds without one.

---

# Part D — What the cut costs, and what it cannot reach

## 9. Trade-offs taken

<What this design gives up, one line each, with what it buys. A design with no stated cost has not
been weighed. For each, say what undoing it would take if it turned out wrong.>

*(CTO)*

- **TO-1:** Surfaces drawn in a WebView (HTML / CSS / TypeScript) rather than native views — *buys*
  the design language as it is expressed (tokens, SVG icons), mature highlighting, diff and graph
  rendering, and a renderer that can be handed *no* capability (§ 2 force 3); *costs* a second wall
  (sanitizer and CSP) to keep NFR-16, and a rendering engine whose behaviour is Apple's; *undoing it
  costs* every surface rewritten natively, the host untouched.
- **TO-2:** Git read through libgit2, not the installed `git` (RN-8) — *buys* zero prerequisites and
  no optional-lock write to `.git/index`; *costs* a native C dependency to vendor and build, and
  feature lag behind Git; *undoing it costs* the installed-`git` adapter behind the Git port (§ 3
  seam 2) — the seam is already drawn for it.
- **TO-3:** The App Sandbox (C-R2) — *buys* an operating-system wall against writes and connections
  that a crash cannot lower (NFR-4); *costs* the start mechanism (a folder granted through the Open
  panel rather than a path typed, C-R3), bookmarks for remembering, and the linked-worktree case
  (§ 11 R-3); *undoing it costs* one entitlements file — and the wall.
- **TO-4:** A Rust host — *buys* memory safety in the process that parses untrusted repository data
  and the smallest bundle Tauri produces; *costs* a second language beside the renderer's and a
  contributor bar; *undoing it costs* the host rewritten — the model and the harness fixtures survive.
- **TO-5:** The raw-source switch not built (RN-10) — *buys* nothing owed and no position-mapping
  code; *costs* the PRD's toggle in every release until built; *undoing it costs* one control and a
  rendered↔source position mapping.
- **TO-6:** Images inside the granted folder loaded through a host asset handler, remote images
  not loaded (RN-11, the owner's override) — *buys* image-bearing READMEs rendering as written,
  with the no-network promise untouched; *costs* one scheme the renderer can address, a third wall
  to keep (the containment check, C-D3, § 11 R-10) and a wider CSP `img-src`; *undoing it costs*
  removing the handler and the scheme, and the placeholder returning for every image.
- **TO-9:** An ad-hoc-signed, un-notarized release (C-R4, the owner's call) — *buys* a channel
  that costs nothing and asks no account of anyone; *costs* a Gatekeeper step inside AC-10's five
  minutes on every stranger's first launch, and a sandbox whose enforcement under an ad-hoc
  signature is proved by the probe rather than promised by a signing chain (§ 11 R-8); *undoing
  it costs* a Developer ID identity and a secret in CI — a reversal the owner has ruled out for
  every app in the instance, recorded here so the cost is stated, not so it is reopened.
- **TO-7:** The read-only harness exercises `nozoki-core` and the IPC list, not the rendered UI
  (C-I3) — *buys* a check that runs in CI on macOS, where Tauri's own WebDriver driver does not
  (https://v2.tauri.app/develop/tests/webdriver/ — "macOS has no WKWebView driver tool"); *costs*
  that the renderer's actual command use is exercised only by the release walk — accepted because
  the renderer holds no capability the harness could catch it using; *undoing it costs* adopting an
  embedded-WebDriver harness when one is worth its dependencies.
- **TO-8:** A tested macOS floor of 14 rather than Tauri's 10.13 (C-R5) — *buys* a floor that is a
  claim the release check backs; *costs* adopters on older systems; *undoing it costs* one
  configuration value and a machine to test on.

## 10. Re-cut record

<A cut meets a reality that contradicts it, and the contradiction is recorded **before** the cut is
redrawn. A cut silently redrawn leaves the next reader unable to tell a correction from a drift.
Shape borrowed from `huangruiteng/loopx`,
`docs/reference/protocols/goal-vision-replan-contract-v0.md` § *Path Delta*.

Re-cut when, and only when, one of these holds: a slice's *Reached when* cannot be met as written; a
slice turned out to be a fragment once its neighbour landed; no slice is left that can be started;
or the PRD, SRS or UXD changed upstream. Finishing a slice is not a trigger.

Omit this section until the first re-cut. An empty heading reads as a cut already in doubt.>

*No re-cut has been triggered; the heading stays so the section numbering holds, and the first
RC-1 is written here by the seat whose ground moves (RN-15).*

## 11. Technical risks

<The risks this design carries, each with what would make it real and what the design does about it.
A risk with no trigger and no response is an observation.>

*(CTO)*

- **R-1:** libgit2 lags Git — a repository Git reads and libgit2 refuses or misreads (a newer index
  format, a sparse index, an extension it does not know) — *shows up as* the Git view `stopped` or
  wrong on a repository where `git status` works, first in the harness's fixtures and then in an
  adopter's report; *response* the Git port (§ 3 seam 2) with the installed-`git` adapter as the
  standing substitute, built only when this fires, run with `--no-optional-locks` so it too
  refreshes nothing (https://git-scm.com/docs/git-status — the flag prevents `git status` from
  refreshing the index as a side effect); fixtures for each such feature added as they are met.
- **R-2:** Gatekeeper's step defeats the stranger — the un-notarized bundle is blocked on first
  launch with no Control-click override on macOS Sequoia
  (https://developer.apple.com/news/?id=saqachfa), and the README's Privacy & Security step is
  missed, or a later macOS changes the step — *shows up as* AC-10's walk exceeding five minutes or
  ending at launch; *response* C-R4's README step, written as the exact click path and re-walked
  on every macOS the floor admits before each release; signing is not a response — the owner has
  ruled it out (`docs/sdd_trail/cycle-1.md` § 1.1) — so if the step ever exceeds the clock, the
  finding goes to the SRS's C-3 as a companion item, not to a signing identity.
- **R-3:** The sandbox grant does not cover what the folder points at — a linked worktree whose
  `.git` is a file naming a `gitdir` outside the granted folder, or a submodule whose `gitdir`
  lives in the superproject's `.git/modules` — *shows up as* the root finding answering `root`
  (FR-33 says both are roots) and every Git read after it `failed(not readable)`, on a folder Git
  itself reads fine; *response* the Git port's `probe` reports the `gitdir` target, the model
  raises it as the Git view's failure state with FR-3's language naming the folder that would
  need granting, the tree and reading unaffected (UX-I16's slot, not UX-S4 — the folder itself
  opened); `linked-worktree` and `submodule` fixtures in `see-what-changed`'s harness, with the
  `gitdir` inside the fixture root so the passing case is proved, and one with it outside so the
  failure state is; recorded as a known limit beside the install path until a grant path for the
  outside case exists.
- **R-4:** A sanitizer bypass renders active content — *shows up as* AC-23's fixture producing
  a `<script`, `on*=` or `src=` in the output, or a CSP violation in the renderer's console;
  *response* two walls that fail independently — the host sanitizer's allowlist and the CSP
  (C-R7) — and a hostile corpus in `checks/fixtures/` that grows with every bypass reported.
- **R-5:** The refresh bar fails at scale — FSEvents coalescing, a full re-read on every event, or a
  tree too large to diff — *shows up as* `checks/latency.sh`'s refresh p95 over `scale-large`
  exceeding what the SRS folds in as NFR-2, or the model's snapshot diverging from disk after
  `checks/churn.sh`; *response* the reducer re-reads only the paths an event names, folders are
  read as expanded (UX-S2's pending state), and the reference sizes are fixed from the first
  measurement (C-I4) rather than guessed.
- **R-6:** A dependency brings a capability the product must not have — a crate with a network
  transport, a renderer package that fetches — *shows up as* `checks/no-network.sh` failing, or a
  lockfile diff adding a name outside `checks/deps.allow`; *response* C-R6: the allowlist, the diff
  in CI, the change reviewed as code, and libgit2 linked without transports.
- **R-7:** The release artifact is not the reviewed tag — *shows up as* `shasum -a 256 -c
  SHA256SUMS` failing against a rebuild from the tag, or a release with no CI run behind it;
  *response* C-R4: CI builds from the tag and publishes checksums; a release with no matching run is
  not offered.
- **R-8:** The sandbox is silently absent — the ad-hoc signature C-R4 fixes, or a misconfigured
  one, leaves the entitlements unenforced and the OS wall gone while every test still passes —
  *shows up as* the bundle probe (C-I3) finding no `APP_SANDBOX_CONTAINER_ID` in the launched
  bundle's environment, or `codesign -d --entitlements :-` printing a list other than C-R2's;
  *response* the probe runs on every CI build from `read-a-folder`'s first bundle on, and is a
  release gate: a bundle that fails it is not published. Because signing is not a lever (§ 1.1
  answered), a probe that fails under ad-hoc signing on the first slice is a § 10 trigger — the
  command half of S-1's bar unmet — and the re-cut it forces is on the gate's mechanism, never on
  the signature.
- **R-9:** The Open-panel start (C-R3) reads as a setup step to a stranger — *shows up as* AC-10's
  walk stalling at launch; *response* the README's first screen shows the panel as the launch
  itself, and from `switch-the-folder` on the panel is met once per folder; the drag-onto-icon
  and Open-With grants, if they hold, are added to C-R3 as a second way to start after
  `read-a-folder` verifies them (Open Questions).
- **R-10:** The asset handler serves a byte from outside the folder — a Markdown image path with
  `..`, a symlink inside the folder pointing out, a percent-encoded or Unicode-normalized path the
  check reads differently from the filesystem — *shows up as* `--test markdown`'s escaping fixtures
  yielding an asset URL, or the handler returning bytes for one; *response* the check is on the
  canonical path (`realpath`, symlinks resolved, after decoding) in the host, run twice — at
  render, and again on every request — and the escaping corpus in `checks/fixtures/hostile.md`
  grows with every bypass reported, as R-4's does.

## 12. What this design is not

<The boundaries, so a reader does not look here for something this document never held.

Above: it never changes product goals or scope (the PRD), system requirements (the SRS), or the
experience (the UXD). A gap in any of them is an open issue in the companion, not a rewrite here.

Below: it authors no ADR. The architecturally-significant decisions are **surfaced**; the Principal
Architect records them, and this SDD references those ADRs once they exist. It designs no individual
change — that is the delivery-tier Architect's `change_design.md`, one change at a time against the
system defined here.>

**The PRD boundary** *(CPO)*. This document changes no product goal, no success metric, no feature,
and no line of `docs/PRD.md` § Scope (In) or § Out of Scope. Every slice in § 6 traces to a PRD
section that carries its claim; a slice that could not is struck, not kept. A gap found in the PRD
while cutting — a value a slice needs that the PRD does not hold, or a PRD line the owner has since
overridden downstream — is an item in `docs/SDD_open_issues.md` and a later PRD revision cycle, never
a rewrite here, and not by the CPO seat either: in this run that seat holds the PRD's boundary, not
its pen. The one such line run 1 found — the Markdown raw-source switch — was confirmed by the owner
as the SRS's reading (`docs/sdd_trail/cycle-1.md` § 2.1) and has since been corrected in the PRD
itself by its own cycle (`docs/PRD.md` § Core Features, "permitted, not promised" — version 11), so
no PRD gap stands after run 2 (RN-3). The reverse direction is bound the same way: where the PRD
moved between runs — the input widened from a repository to a folder at v10 and v11 — this document
followed it (RN-21) and wrote nothing back.

**The SRS boundary** *(CTO)*. This document changes no requirement: every `FR`, `NFR`, `DR`, `C` and
`AC` in `docs/SRS.md` reads after this run as it read before it. Where the SRS routed a call here
by name — the Git mechanism (§ 5.3), the acquisition channel (C-3, its RN-7), the macOS floor
(C-11), the extension set (FR-29), the build-cost judgments (FR-31, FR-32), how the root finding is
made (FR-33) — this document makes the call and records it (§ 3, § 4, RN-8, RN-10, RN-12, RN-17,
RN-24); it does not write the call back into the SRS. The numbers the SRS leaves unset (NFR-1,
NFR-2, NFR-10) are measured here (C-I4) and reach the SRS by its own revision, never by this
document asserting them. Where the SRS moved between runs — the input widened at v8 — this
document followed it (RN-24) and wrote nothing back. A gap in the SRS found while cutting is an
item in `docs/SDD_open_issues.md`; none was found in run 1 or run 2.

**The UXD boundary** *(CDO)*. This document changes no experience: every flow, screen, state,
interaction pattern and accessibility entry in `docs/UXD.md` reads after this run as it read before
it, and every token value stays in `docs/DESIGN.md`. § 4's C-E conditions and § 6's observable bars
are sourced in those two documents, `docs/CONTENT.md`'s two cross-cutting parts and the instance
fence; none states an experience they do not. Where the UXD routed a call here by name — where
UX-S4 renders — the CTO's C-R3 makes it and RN-9 records it; this seat does not write it back into
the UXD. A gap in the UXD found while cutting is an item in `docs/SDD_open_issues.md`, never a
redesign here — and not by this seat either, which holds the UXD's pen in another run and its
boundary in this one. Two such gaps were found in run 1 and answered by the owner before run 2
(`docs/sdd_trail/cycle-1.md` § 1.2, § 1.3; RN-20); this document cites the answers and leaves the
UXD's entries to the UXD's own run. One consequence of a condition was recorded rather than
designed around (RN-19).

**The downstream boundary** *(CTO)*. This document authors no ADR. Three decisions are surfaced for
the Principal Architect to record, in § 2, § 4 and their notes: the capability-split shape and its
sandbox (RN-6), the runtime — Tauri 2, a Rust host, WKWebView (RN-7) — and Git read through libgit2
behind a port (RN-8). Once recorded, this document references those ADRs and does not restate them.
It designs no individual change: § 6's slices are cut into seeds by the Principal PM (§ 8), and
each change against this system is the delivery-tier Architect's `change_design.md`.

---

## SDD Review Notes

<This section is the SDD's **creation trail** — every load-bearing element carries a written *why*.
An element derived from an upstream document carries its why inline, as its *Traces to* tag;
**everything the upstream documents did not settle carries its why here**, with its reason: an
invented value, an owner's answer folded from the open-issues file, a best-effort choice drafted by
one of the three seats, or a place where a contradiction between the SRS and the UXD was resolved
the SDD's own way.

On a revision **or a recreate**, **every change to already-settled content carries the legitimate
reason that authorized it** — an owner answer or directive, or an upstream change. Settled content
is all of it: the shape, the seams, the cut, and the existing wording of these notes. A change with
no findable legitimate reason is a bug and should not appear in the SDD at all.

A genuine product-intent gap is *not* recorded here — it goes to the open-issues companion for the
owner. Once the owner answers, capture the answer here, because the companion is deleted when the
round finishes clean and this trail is the durable provenance.

Each note names the seat that made the call and its relation to the upstream documents: *added* (the
SDD states something they do not) or *changed* (it departs from what they say).>

- **RN-1:** *(CPO)* *(added)* Markdown rendering is its own slice, `read-markdown`, rather than
  part of `read-a-folder` — *because* rendering untrusted content with nothing fetched and
  nothing executed is a decision whose answer could change how the reading panel is built, and a
  plain-text reading surface proves the promise without waiting on it (§ 5 step 4). The PRD lists
  both under one feature set and states no cut. Run 1 put the one-slice alternative to the owner;
  the answer was *either is acceptable* with a standing appetite for the seats to apply instead
  (`docs/sdd_trail/cycle-1.md` § 3.1; RN-23), and the two-slice cut is kept on it *(re: § 5,
  `read-a-folder`, `read-markdown`; source: PRD § Core Features; SRS FR-30, FR-32, NFR-16)*.
- **RN-2:** *(CPO)* *(added)* 1.0.0 is not a slice — *because* the Agari's third condition is a
  release event that restates the first condition's completion, the sixth-cut list's milestone; it
  is the bar the last of `read-the-diff`, `read-the-history` and `switch-the-folder` lands
  against, and which is last is § 7's. Themes and remembered state (E6) are likewise not a slice —
  folded into `pick-it-up-release`, where FR-20 binds them *(re: § 5 step 2, `pick-it-up-release`;
  source: Agari, conditions 1 and 3; PRD § Assumptions "Versioning"; SRS FR-20, C-6)*.
- **RN-3:** *(CPO)* *(added — was *changed* in run 1)* The raw-source switch is required by no
  slice — *because* it is a permission conditioned on build cost, not a promise (`docs/SRS.md`
  FR-31, RN-29). In run 1 the PRD still said "the toggle follows" and this document followed the
  SRS against it, parking the departure as a choice to confirm; the owner confirmed the SRS's
  reading (`docs/sdd_trail/cycle-1.md` § 2.1), and the PRD has since carried the same line itself
  ("permitted, not promised" — `docs/PRD.md` § Core Features, version 11), so the note no longer
  records a departure from any upstream document *(re: `read-markdown`, § 12; source: PRD § Core
  Features; SRS FR-31)*.
- **RN-4:** *(CPO)* *(added)* The unexplained-fault class the UXD binds on every read path
  (`docs/UXD.md` UX-I16, RN-23 — "the SDD sizes it") is no slice's delivery — *because* it is a
  condition every read surface holds, so it inherits (§ 4, the CDO's experience conditions) and each
  slice carries it for the read paths that slice opens; a slice "adding fault states" after the fact
  would be a fragment of each slice it patched *(re: § 4, § 6 all slices; source: UXD UX-I16)*.
- **RN-5:** *(CPO)* *(added)* The read-only proof (AC-1 – AC-3) is no slice — *because* a harness
  before there is a product to run it against is the checker with nothing to check (§ 5 step 2); it
  is the bar `read-a-folder` and every slice after it closes against *(re: § 5 step 2; source:
  SRS AC-1 – AC-3, NFR-9)*.
- **RN-6:** *(CTO)* *(added)* The shape is a capability-split read pipeline under the App Sandbox —
  *because* the one invariant worth guarding is negative (no write, no connection, no execution;
  NFR-5, NFR-6, NFR-8, NFR-16) and must survive a crash (NFR-4), and a negative invariant is held
  by withholding capability at a boundary the OS enforces, not by a guarded domain core; the four
  alternatives and the conditions under which each would win are § 2's table. Surfaced for an ADR
  *(re: § 2, § 3, § 4 C-R2; source: SRS NFR-4 – NFR-8, NFR-16, DR-6, C-1)*.
- **RN-7:** *(CTO)* *(added)* The runtime is Tauri 2 — a Rust host over `nozoki-core`, the surfaces
  in the system WKWebView — packaged as one `.app` on a GitHub Release and running under the App
  Sandbox — *because* C-3 and its RN-12 press toward a self-contained artifact with no prerequisite;
  the design language is expressed as web tokens and vendored SVG icons (`docs/UXD.md` § 9,
  `third_party/lucide/`); the system WebView keeps the bundle free of a bundled browser engine, the
  largest dependency the alternative (Electron) would add; and a Tauri host exposes only the
  commands it registers, which is the closed list § 3 seam 4 needs. Native AppKit / SwiftUI is the
  runner-up (§ 2). Run 1 made this call without opening `docs/DESIGN.md` or `docs/CONTENT.md` and
  said so; the owner confirmed it at the fold (`docs/sdd_trail/cycle-1.md` § 2.2) and ran the check
  the note asked for: `docs/DESIGN.md` RN-1 states that the runtime — "a browser tab or a native
  window" — is the SDD's and that "every value here is a CSS value and holds in either", and
  `docs/CONTENT.md` names no rendering technology; this run re-read both lines and they say that.
  Confirmed, and surfaced for an ADR *(re: § 2, § 4 C-R1, C-R5; source: SRS C-3, C-11, RN-7,
  RN-12; DESIGN RN-1)*.
- **RN-8:** *(CTO)* *(added)* Git state is read through libgit2 behind a port, not by spawning the
  installed `git` — *because* on a fresh macOS "invoking any command in Xcode or the command-line
  tools package (such as git) from the command line prompts you to download and install the
  Command Line Tools"
  (https://developer.apple.com/documentation/xcode/installing-the-command-line-tools), a
  prerequisite install that would consume C-3's five minutes; because `git status` by default
  "will automatically refresh the index … and writing out the result" unless `--no-optional-locks`
  is given (https://git-scm.com/docs/git-status), a write under `.git` that AC-1 counts; and
  because a library links only the calls the tool makes, so the absence of a mutating call is a
  fact of the binary. The installed-`git` adapter is the port's standing substitute (§ 11 R-1).
  Surfaced for an ADR *(re: § 3 `git-reader`, seam 2; source: SRS § 5.3, NFR-5, NFR-6, C-3)*.
- **RN-9:** *(CTO)* *(owner answer folded)* The start mechanism: the folder is granted through the
  system Open panel, and the startup failure renders in the app's window — *because* under the
  sandbox a folder is readable only when the user selected it, and the entitlement C-R2 carries is
  defined on "files the user has selected using an Open or Save dialog"
  (https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.security.files.user-selected.read-only).
  This settles the UXD's open question (`docs/UXD.md` § Open Questions — where UX-S4 renders) in
  the window, so the terminal fences do not bind. FR-2 holds: the panel is the start, and no control
  changes the folder once viewing. Confirmed by the owner (`docs/sdd_trail/cycle-1.md` § 2.3), with
  one reconciliation they asked for and this run wrote into C-R3: the grant is once *per folder*,
  not once per launch — from `switch-the-folder` on, launch restores the last-viewed folder from
  its bookmark and the panel appears only when nothing is remembered or the bookmark no longer
  resolves; and, with UXD v6, a plain folder is not on UX-S4's list at all *(re: § 4 C-R3, S-6;
  source: SRS FR-2, FR-3, FR-34, RN-1; UXD UX-S4, UX-S7, UX-I17)*.
- **RN-10:** *(CTO)* *(added)* The two build-cost judgments the SRS routes here. **FR-31, the
  raw-source switch: not built.** The switch as the UXD specifies it "preserves the reading position
  both ways" (`docs/UXD.md` UX-I12), which needs a mapping between a position in rendered output and
  a position in source — code with no other use; the owner's bar was "if it costs nothing"
  (`docs/SRS.md` RN-29), and this does not. A release states rendered-only where it is offered.
  **FR-32, a relative link opening its target: built, in `read-markdown`** — the renderer emits the
  existing `select_file` path for a link the host has already resolved inside the repository, one
  containment check and no new command; that is close enough to nothing to be inside the owner's
  permission (`docs/SRS.md` RN-28) *(re: `read-markdown`, § 3 `markdown-renderer`, § 9 TO-5;
  source: SRS FR-31, FR-32, RN-28, RN-29; UXD UX-I12)*.
- **RN-11:** *(CTO)* *(owner answer folded — overrides run 1)* An image inside the granted folder
  **is loaded** and renders in place; a remote image, or one whose path escapes the folder, takes
  the not-loaded placeholder — *because* run 1 drafted the conservative reading (no image loaded,
  since the renderer holds no path to the folder, § 2 force 3) and the owner overrode it
  (`docs/sdd_trail/cycle-1.md` § 2.4). The mechanism keeps the wall the draft was protecting: the
  renderer still holds no path — it addresses one scheme, and the host's asset handler answers
  only for a path `fs-reader`'s containment check passes, so the capability handed over is "read a
  byte the host has already confirmed is inside the folder", not "read". The no-network promise is
  untouched: the scheme is local and the CSP admits no other. UX-I12's placeholder text narrows to
  remote images by the UXD's own run *(re: § 3 `markdown-renderer`, `ipc-surface`, seam 4, seam 7;
  § 4 C-R7, C-D3; § 9 TO-6; § 11 R-10; `read-markdown`; source: SRS FR-32, NFR-16; UXD UX-I12)*.
- **RN-12:** *(CTO)* *(added)* The floor-language extension set in § 3 — *because* FR-29 fixes it
  here and the owner's rule is every extension in common use for each language
  (`docs/SRS.md` RN-27); the set is the CTO's reading of common use and is matched on the last
  extension only, case-insensitively, so `Makefile.py.bak` is plain text and `README.MD` is
  Markdown *(re: § 3; source: SRS FR-29, RN-27, AC-5)*.
- **RN-13:** *(CTO)* *(added; the fifth position re-grounded at run 2)* The build order and the
  renumbering of § 6 — `switch-the-folder` is S-6, `read-the-diff` S-7, `read-the-history` S-8 —
  *because* the first of the three beyond v1 is the one that falsifies § 3's folder-as-input claim
  (NFR-12) before two more surfaces are built on the model; the CPO's provisional value order
  placed switching last, and the technical order is this seat's. `pick-it-up-release` is fifth: in
  run 1 as a stated preference, and since the owner's re-cut (`docs/sdd_trail/cycle-1.md` § 3.3;
  RN-22) as a dependency — its *Delivers* is the v1 cut, so step 3's test now holds without
  "should", and § 7 carries three edges it did not *(re: § 5 step 3, step 5, § 6, § 7; source: SRS
  NFR-12, RN-5)*.
- **RN-14:** *(CTO)* *(added)* RN-4 agreed, with the mechanism: the unexplained-fault class is
  carried by ItemState's `stopped` value on every read (§ 3) and by C-I1 / C-I2 (§ 4), so each slice
  inherits it for the read paths it opens and no slice delivers it *(re: § 3 ItemState, § 4 C-I;
  source: UXD UX-I16, RN-23; SRS NFR-3, NFR-11)*.
- **RN-15:** *(CTO)* *(added)* The read-only harness exercises `nozoki-core` and the IPC command
  list rather than driving the rendered UI — *because* Tauri's WebDriver driver has no WKWebView
  driver on macOS (https://v2.tauri.app/develop/tests/webdriver/), and a renderer that holds no
  capability cannot be caught using one; the release walk (AC-10) is the UI's check. § 10's stamped
  RC placeholder was removed and the heading kept with a note, since the template's own instruction
  is to omit the section until a re-cut fires and a placeholder reads as a cut in doubt *(re: § 4
  C-I3, § 9 TO-7, § 10; source: SRS AC-1 – AC-3, NFR-9)*.
- **RN-16:** *(CTO)* *(added)* The history's default branch set — "the current branch and what
  relates to it" (FR-18) — computes to HEAD's branch plus every local branch whose merge-base with
  HEAD lies inside the loaded window of commits, the window's size fixed with NFR-10's reference
  sizes — *because* the SRS binds the property and leaves the mechanism here; whether this reading
  matches what the owner meant is the CDO's and CPO's to challenge, and its size is an Open Question
  until `read-the-history` measures it *(re: § 3 History, `read-the-history`; source: SRS FR-18,
  RN-19)*.
- **RN-17:** *(CTO)* *(added)* The acquisition channel is a `.dmg` on a GitHub Release, and the
  macOS floor is 14 — *because* the SRS fixes both here (C-3 RN-7, C-11 RN-21); a release built by
  CI from its tag with published checksums is the shape the instance's release instinct requires;
  and a floor is a claim the release check must back, so it is the version the check runs on, not
  the oldest the runtime supports. Signing and notarization were the owner's and are answered:
  never — no Apple Developer Program membership for any app in this instance, no Mac App Store,
  GitHub the only channel (`docs/sdd_trail/cycle-1.md` § 1.1), and the owner handed the install
  mechanism itself to this seat within three bounds: costs nothing, comes from GitHub, one simple
  path. The mechanism chosen is C-R4's — an ad-hoc-signed `.dmg` on the Release, drag to
  Applications, the Privacy & Security step named on the README's first screen — *because* the
  ad-hoc signature is what makes the entitlements bind at all and costs nothing; a `.dmg` is the
  form `cargo tauri build` already produces and the one a Mac user expects to drag from; and the
  alternatives fail a bound each — a Homebrew cask is a second path and a prerequisite (C-3), a
  `.zip` is the same walk with one less convention, and a terminal `xattr` step is a route the
  README must not open to a stranger. The one thing this mechanism cannot settle from documents —
  whether the sandbox is enforced under an ad-hoc signature — is proved by C-I3's probe on the
  first slice's bundle, not assumed *(re: § 4 C-R4, C-R5, C-I3; § 9 TO-9; § 11 R-2, R-8; source:
  SRS C-3, C-11, C-12, AC-10, AC-14; PRD § Scope (In) "Run posture")*.
- **RN-24:** *(CTO)* *(changed — upstream moved)* This seat's lane follows the input's widening —
  a folder, a repository or not (`docs/PRD.md` v11, `docs/SRS.md` v8 FR-1, FR-33, FR-34, AC-24,
  AC-25; `docs/UXD.md` v6 UX-I17) — with these consequences and no others: **(1)** the CPO's two
  slug renames (RN-21) carried through § 5 steps 3 and 5, § 6's *Rests on* and *Why here*, § 7,
  § 4 C-R2, § 11 R-3 and R-9, RN-13 and Open Questions; **(2)** the part `repository-model` is
  renamed `folder-model`, the entity `Repository` is `Folder`, and seam 4's commands
  `open_repository` / `switch_repository` are `open_folder` / `switch_folder` — a part that holds a
  plain folder cannot be named for the thing it may not hold, which is the same rule the CPO
  applied to the slugs; **(3)** the **root finding** (FR-33) is placed in `git-reader` behind the
  Git port as `probe(folder)`, consumed by the model as a state — `root` with a GitState, or
  `plain` with none and every Git projection empty (FR-34) — and drawn by the surfaces as the Git
  view's empty state (UX-I17); it lands in `see-what-changed`, where the CPO cut it, and
  `read-a-folder` links no `git-reader` at all, which is what makes that cut buildable; **(4)** the
  watcher includes the root's `.git` entry so a repository appearing or leaving mid-session is one
  more change the reducer applies, re-running the finding (FR-33's live clause, in
  `watch-a-moving-tree`); **(5)** C-R3 is corrected — a plain folder is not a startup failure —
  and the harness gains plain, inside-a-repository, parent-of-two, linked-worktree and submodule
  fixtures (AC-24, AC-25). The CDO's run-1 observable bars on S-1 and S-6 showed a failure for a
  folder "that is not a Git repository" (the CPO's finding, RN-21 (3)); this note named it for that
  seat rather than editing it, and the CDO revised both in the same round (RN-26) *(re: § 2 forces
  1, 2, 4; § 3; § 4 C-R2, C-R3, C-I3,
  C-D1, C-D3, C-D4; § 5 steps 3, 5; § 6 S-1 – S-8; § 7; § 11; § 12; source: PRD v11; SRS v8; UXD
  v6; Agari, first condition)*.
- **RN-25:** *(CTO)* *(owner answer folded)* The release gate is exercised from the first slice's
  bundle, not first at release — *because* the owner accepted that moving `pick-it-up-release`
  after the v1 cut proves the acquisition path later, and asked that the bundle, the entitlement
  list and R-8's probe be proved on an unpublished artifact as soon as the runtime exists
  (`docs/sdd_trail/cycle-1.md` § 3.3). C-I3's `checks/bundle.sh` is that check; S-1's command bar
  runs it; § 5 step 5's first position names it; and a failure of it under the ad-hoc signature is
  a § 10 trigger on the gate's mechanism (R-8), since the signature is not a lever *(re: § 4
  C-I3, § 5 step 5, S-1, S-5, § 11 R-8; source: `docs/sdd_trail/cycle-1.md` § 1.1, § 3.3; SRS
  AC-14)*.
- **RN-26:** *(CDO)* *(changed — upstream moved)* This seat's lane follows UXD v6 and the owner's
  § 2.4 answer, with these consequences and no others: **(1)** the § 4 C-E preamble opens the
  experience against a folder, a repository or not, and names the plain folder a working state
  (`docs/UXD.md` UX-I17); **(2)** `read-a-folder`'s observable bar no longer shows a startup
  failure for "a folder that is not a Git repository" — the plain fixture opens and reads exactly
  as the repository does, and nothing on screen tells them apart until `see-what-changed` (RN-19);
  its failure clause is UX-S4's v6 list — a path that does not exist, is not a folder, or cannot be
  read; **(3)** `switch-the-folder`'s bar lands the plain fixture's arrival state — unmarked tree,
  Git view present and showing nothing — and its failure clause is UX-S7's, the same three cases,
  a plain folder not among them; **(4)** `read-markdown`'s bar shows the image inside the fixture
  as the image, in place, and the remote image as the placeholder stating remote content is not
  fetched (UX-I12, narrowed to remote; the owner's call, `docs/sdd_trail/cycle-1.md` § 2.4,
  folded by the CTO as RN-11). One reading is this seat's, named rather than left implicit: for
  an image whose path **escapes** the folder the UXD says nothing — UX-I12 speaks of remote
  content — and C-D3 has the host answer nothing for it; the bar draws that "nothing" as the same
  not-fetched placeholder, never as an image, because the fence's `no-unestablished-state`
  forbids a surface showing content the tool did not establish and the placeholder is the one
  shape UX-I12 already gives an image that is not loaded. Should the UXD's own run draw the
  escaping image differently, that entry outranks this bar. On the CPO's recall (run 2, round
  1) two more, the same ground: **(5)** `see-what-changed`'s bar carries the three plain
  fixtures — Git view *pending* then nothing, tree unmarked, the clean repository's branch and
  "nothing changed" the only cue (UX-S3, UX-I17; AC-24, AC-25); **(6)** `watch-a-moving-tree`'s
  bar carries a repository appearing at `plain`'s root mid-session and leaving it — the Git view
  filling and emptying, markers arriving and going, the reader's place untouched, no message and
  no control either way (UX-I17's live sentence, UX-I2, UX-I3; FR-33) *(re: § 4 C-E preamble,
  `read-a-folder`, `read-markdown`, `see-what-changed`, `watch-a-moving-tree`,
  `switch-the-folder`; source: UXD v6 UX-S3, UX-S4, UX-S7, UX-I2, UX-I3, UX-I12, UX-I17, UX-F5;
  `docs/sdd_trail/cycle-1.md` § 2.4; SRS v8 FR-1, FR-33, FR-34, AC-24, AC-25; fence
  § `no-unestablished-state`)*.
- **RN-18:** *(CDO)* *(added)* § 5 step 1's observability check, applied to E1 – E10: every entry
  passes — each names something a person watches on a surface the product has (the window, the
  README, the release page, the tool's own container on disk) and none names a layer, a schema or
  a readiness. The two that sit nearest the line are recorded: E6's "outside the repository" is
  observed as a filesystem diff after a session (AC-13), and E10's "1.0.0 or later" is observed as
  a tag on the release page; both are surfaces, so both stand. No entry was returned to the CPO
  *(re: § 5 step 1; source: PRD § Key Use Cases, § Core Features; SRS AC-13, C-6)*.
- **RN-19:** *(CDO)* *(added; slug moved at run 2 — RN-21)* `read-a-folder`'s rail carries the *Files* entry alone, and
  *Git* arrives with `see-what-changed` — *because* C-E1 forbids a control drawn as enabled whose
  destination does not exist, and a *Git* entry in a build with no Git view could only show
  *pending* for work the tool is not doing, which UX-I16 names as a state that lies (the tool is
  not still working). `docs/DESIGN.md` § Components "The rail" draws two entries; that is the
  released shell, and a slice is not a release — from `see-what-changed` on the rail is as drawn.
  If the owner moves `pick-it-up-release` ahead of `see-what-changed` (`docs/SDD_open_issues.md`
  § 3.3) the first public release ships a one-entry rail, and its README says so under
  `pick-it-up-release`'s fence. The same reasoning fixes S-1's polarity: the shell renders in the
  platform's reported appearance, or light where none is read (UX-I9's default), with no control to
  change it until `pick-it-up-release` — a control that arrives with its destination, not before
  *(re: `read-a-folder`, `see-what-changed`, § 4 C-E1, C-E6; source: UXD § 4 the rail, UX-I9,
  UX-I13, UX-I16; DESIGN § Components "The rail")*.
- **RN-20:** *(CDO)* *(owner answers folded — was *added* in run 1)* Two gaps in the UXD surfaced
  by writing the observable bars in run 1: `docs/UXD.md` UX-F2 had a Git-view file entry open the
  file to read while UX-F4 had the same entry open its diff, with no control named that told the
  two apart; and UX-F4 with § 4 placed the diff in the reading panel and reached the history
  "from the Git view" without saying where the history view itself is drawn. The owner answered
  both (`docs/sdd_trail/cycle-1.md` § 1.2, § 1.3), by demonstration against VS Code's Source
  Control view: **the Git-view row opens the diff** — one click target; the status letter stays a
  label, never a second target; the file itself is read from the tree — so the row's meaning
  changes at `read-the-diff`, and `see-what-changed`'s bar, where the row opens the file, holds
  until then; and **the history sits in the sidebar**, as commit rows beneath the changes list, a
  selected commit's diff taking the reading panel. `read-the-diff`'s and `read-the-history`'s
  observable bars now state those answers. The UXD at v6 still carries the pre-answer text in
  UX-F2 and UX-S6; the entries are revised by the UXD's own run, not here (§ 12), and this document
  cites the trail until it can cite the revised entries *(re: `see-what-changed`, `read-the-diff`,
  `read-the-history`, § 12; source: `docs/sdd_trail/cycle-1.md` § 1.2, § 1.3; UXD UX-F2, UX-F4,
  § 4, UX-S5, UX-S6)*.
- **RN-21:** *(CPO)* *(changed — upstream moved)* The input is one local folder, a Git
  repository or not, and this seat's lane now says so — *because* run 1 was written against PRD
  v9 and SRS v7, and both have since widened the input (`docs/PRD.md` § Purpose, § Scope (In),
  version 11; `docs/SRS.md` FR-1, FR-33, FR-34, version 8; the terminus with them,
  `system/projects/nozoki/agari.md`). Four consequences, and only these: **(1)** two slugs are
  renamed for what they deliver — `read-a-repository` → `read-a-folder`, `switch-the-repository`
  → `switch-the-folder` — a slug names a delivery, and the delivery takes any folder; the CTO
  and the CDO moved their occurrences in the same round (RN-24, RN-26). **(2)** The plain folder is no slice
  and no entry (§ 5 step 2): E1, E3, E4 and E9 each say what it looks like on the surface they
  deliver, and the one place the two inputs first look different — the Git view present and
  empty, the tree unmarked, the finding-out that creates nothing (FR-33) — is inside
  `see-what-changed`, because an empty Git view proves nothing until there is a Git view. **(3)**
  `read-a-folder` takes a plain folder and a repository alike and tells them apart not at all —
  its shell has no Git surface yet (RN-19) — so the CDO's run-1 bar for it, which showed a startup
  failure for "a folder that is not a Git repository", and the CTO's C-R3, which said the same,
  were against the settled documents (`docs/UXD.md` UX-I17, UX-S4 as narrowed at v6); named here
  as findings for their seats and corrected by them in the same round (RN-24, RN-26). **(4)** Every "repository" in § 1, § 5 steps 1, 2
  and 4, § 6's CPO fields and § 12 that meant the input now reads "folder"; where a sentence is
  about Git it keeps "repository", which is the PRD's own rule (§ Purpose, "the three named
  flat") *(re: § 1, § 5, § 6 S-1 – S-8, § 12; source: PRD v11 § Purpose, § Key Use Cases 4,
  § Core Features, § Scope (In), § Out of Scope; SRS v8 FR-1, FR-33, FR-34, AC-24, AC-25; UXD v6
  UX-I17; Agari, first condition)*.
- **RN-22:** *(CPO)* *(owner answer folded)* `pick-it-up-release` lands after the whole v1 cut —
  `read-a-folder`, `read-markdown`, `see-what-changed`, `watch-a-moving-tree` — never among them —
  *because* the owner chose the first impression over the early proof: "let's go with v1", the
  first thing a stranger meets being the product `docs/PRD.md` § Scope (In) calls v1
  (`docs/sdd_trail/cycle-1.md` § 3.3). This is the value reason and the fence (§ 5 step 4, S-5
  *Not in this slice*); the slice's number in the build order is § 7's, and the consequence the
  owner accepted — the acquisition path proved later — is recorded in the trail beside the answer
  and is the CTO's to place a check for. The § 6 field *Delivers* on S-5 now names the v1 cut it
  ships *(re: § 5 step 4, S-5; source: PRD § Scope (In) "everything under Core Features";
  `docs/sdd_trail/cycle-1.md` § 3.3)*.
- **RN-23:** *(CPO)* *(owner directive folded)* Cut-granularity calls are this seat's, made on the
  owner's standing appetite — *smaller rather than larger, but not too small* — and are not
  parked for the owner unless the answer changes what the product promises — *because* the owner
  said so on run 1's § 3.1 ("this is a question that I think should not come to me"), answered
  § 3.1 as *either is acceptable*, and § 3.2 was closed on the same rule without being re-asked
  (`docs/sdd_trail/cycle-1.md` § 3.1, § 3.2). Applied: `read-markdown` stays its own slice (RN-1)
  and `read-the-history` stays one slice, the branch-set choice alone being *too small*. Carried
  forward as the routing rule for every later cut this seat makes; the Principal PM re-slices
  whatever § 6 draws (§ 8), which is why the granularity here never needed the owner's turn *(re:
  § 5 step 4, § 6; source: `docs/sdd_trail/cycle-1.md` § 3.1, § 3.2)*.

---

## Open Questions

<A technical question this SDD leaves standing — recorded so a reader does not mistake silence for
an answer.

**This section is not the companion, and never a copy of it.** Anything awaiting the owner lives in
`SDD_open_issues.md` alone, and that file's **absence is the done signal**. An item written in both
has two homes and only one of them says when it is finished.

What belongs here is a question this SDD cannot close and is **not** asking the owner to close: one
that resolves downstream — in a slice, in a spike, or against a system that does not exist yet.

Omit this section entirely when there is nothing in it. An empty heading reads as an unanswered
question.>

- [OPEN: Whether a folder dropped onto the Dock icon, or opened through Finder's *Open With*, is
  granted to the sandboxed bundle the same way an Open-panel selection is — Apple's documentation
  pages for this are script-rendered and returned no text to this run, so the claim stays
  unverified. Settled in `read-a-folder` by launching the built bundle both ways against a
  fixture and reading the grant; if either works, C-R3 gains it as a second way to start, not a
  second install path.]
- [OPEN: Whether libgit2 opens and reads a repository correctly under a read-only sandbox grant
  with no attempt to create a lock or refresh; whether its discovery can be disabled so `probe`
  answers `plain` for a folder inside a repository rather than finding the ancestor (FR-33); and
  what it does on a linked worktree and a submodule (R-3). Settled in `see-what-changed` by the
  harness fixtures; a failure here is R-1's trigger.]
- [OPEN: The loaded-window size behind RN-16's default branch set and the history's draw — how many
  commits are walked before the graph is drawn against `scale-large`. Settled in `read-the-history`
  from `checks/latency.sh`, alongside NFR-10's reference sizes.]
- [OPEN: Whether the App Sandbox is enforced on a bundle carrying the entitlements under an ad-hoc
  signature. Settled in `read-a-folder` by the bundle probe (C-I3) — the first CI build answers it.
  Signing is not a lever (the owner's § 1.1 answer, `docs/sdd_trail/cycle-1.md`), so a *no* here is
  a § 10 trigger on the gate's mechanism (R-8): what changes is how the wall is proved, not whether
  the release is signed.]
- [OPEN: The origin form the WebView accepts in `img-src` for the host's `nozoki-asset` scheme
  (C-R7) — whether the CSP names the bare scheme or a scheme-plus-host form, and whether Tauri 2's
  custom-protocol registration on macOS serves it without a plugin. Settled in `read-markdown` by
  the local-image fixture rendering with the CSP as written and the console showing no violation;
  the form found is written into C-R7 and these notes.]
