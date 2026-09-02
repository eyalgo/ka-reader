# UX reference — layout, not style

Eight screenshots of VS Code, taken by the owner as a layout reference for Nozoki's shell.

They are here for **what the layout does** — where things sit, how the sidebar relates to the
reading panel, how a changed file is marked. They are **not** a reference for how Nozoki should
look. The design direction is a restrained workbench built from primitives, no established
component design system (`UXD.md` § 9); VS Code's own visual language is not being adopted.

None of the images is annotated in itself. This file is the annotation: every element is either
taken or excluded below, and an element not listed here was not considered.

**Four of the eight carry a take / do-not-take reading; four carry only a description.** The four
annotated are the ones this file opened with — `vscode-files-view.png`, `vscode-git-view.png`,
`vscode-repo-selector.png`, `vscode-branch-filter.png`. The four added later — three at
`nozoki@b7119cb`, one at `nozoki@8879041` — are described under *Four images described, not
adjudicated* below, and by the rule above nothing in them is taken or excluded. That is not an
oversight to read past: `UXD.md` RN-13 rests on it, recording that the UXD's entries stand on the
four annotated images alone.

Every shot is dark. That says nothing about Nozoki's default — the initial theme follows the
platform's signal, and both themes are first-class (UX-I9).

---

## `vscode-files-view.png` — the Files view

### Take

- **The two-column shell.** Narrow navigation column on the left, reading panel taking the rest.
  The proportion is the reference: the panel you read in dominates. *(UXD § 4)*
- **The tree.** Repository name as the root, folders collapsible, files listed beneath, one
  selection at a time. *(UX-S2)*
- **The repository named in the shell chrome.** VS Code puts `nozoki` in the centre of the title
  row. The element is right — certainty about what is being inspected is part of what the product
  sells. Its behaviour there (a command field) is not. *(§ 4, RN-2)*

### Do not take

- **The activity bar's icon set** — search, run and debug, remote, extensions, testing, and the
  installed-tool icons below them. Nozoki has two views, Files and Git, and no other top-level
  area exists. *(§ 4)*
- **The title row** — back and forward arrows, the command field, the update button, the
  layout-toggle icon. No navigation history, no command surface, no updater in the shell.
- **The `...` overflow menu** on the panel header. It opens a configuration surface; there is
  nothing to configure. *(§ 4)*
- **The empty-state content** — the watermark and the keyboard-shortcut list. The empty reading
  panel states one thing: select a file. A shortcut list would also promise a keyboard model the
  product does not have. *(UX-S1, UX-I8)*
- **The count badge** on the extensions icon. Nothing in Nozoki bids for attention. *(UX-I2)*

---

## `vscode-git-view.png` — the Git view

### Take

- **Git as a mode of the same sidebar.** Same column, same width; the reading panel is untouched
  by the switch. *(§ 4, UX-I3)*
- **Changed files as a named, collapsible group.** *(UX-S3)*
- **The status letter beside each file** — `A`, `M`, `R`. The letter carries the meaning and the
  colour repeats it, which is the rule Nozoki holds itself to: no state distinction readable by
  hue alone. This is the reference's clearest single lesson. *(UX-A2)*
- **The branch shown inside the Git view**, not in the shell chrome. *(§ 4)*
- **Beyond v1** — a commit list with each commit's changed files beneath it is the shape the
  history view takes. *(UX-S6)*

### Do not take

- **The commit message box and the sync button.** These write. No editing affordance exists in
  Nozoki, enabled or disabled. *(UX-I1)*
- **The graph toolbar** — fetch, pull, push, refresh. Write operations, and there is no manual
  refresh control in any case. *(UX-I1, UX-I2)*
- **Outgoing-changes framing and the sync counter.** They describe a relationship to a remote and
  invite an action. Nozoki reports the state of the local repository.

### Neither — the graph's rails and commit dots

They carry branch topology, which the history view as currently written does not promise. The
owner has reopened that; see the directive below.

---

## `vscode-repo-selector.png` — where the repository is chosen

A second Git view, this one against a repository with two source-control roots and a long history.
The owner supplied it for one element: the repository name in the graph's header row is a control,
and choosing it is how the viewed repository changes.

### Take

- **A repository selector that shows the current repository's name.** The name is both the label
  and the control. *(UX-F5)*
- **The branch selector beside it.** Evidence for the topology directive below: the graph is
  scoped by a branch choice, not simply drawn whole.
- **The count on the changed-files group.** Unlike the badge excluded from the Files view, this one
  reports the repository's state rather than bidding for attention. *(UX-S3)*
- **`U` status letters** beside each file — the same redundant-encoding lesson as the first Git
  view. *(UX-A2)*

### Do not take

- **Two repositories open at once, each with its own section.** Nozoki views exactly one repository
  at a time; switching replaces, never adds. *(UX-F5)*
- **The per-repository commit boxes and the publish-branch button.** These write. *(UX-I1)*

---

## `vscode-branch-filter.png` — choosing which branches the graph draws

The same Git view with its ref picker open, supplied after the CDO had already drafted the topology
statement. The picker lists the repository's refs as checkboxes — `All`, `Auto` ("current history
item reference(s)"), then the local branches under a **branches** heading and `origin/*` under
**remote branches**, each with its tip identifier — over a filter field and an `OK`. Behind it the
graph is drawn with rails and commit dots, and the commit that is a branch tip carries the branch's
name as a chip.

The owner's framing when supplying it: **the mechanism is convenient, not binding.** What is taken
is that the reader chooses what the graph draws and does not have to; the modal checklist that does
the choosing here is one control among several that would serve.

### Take

- **The graph is drawn against a chosen set of refs, not against every ref there is.** This is the
  scoping property the topology statement rests on, shown as a mechanism rather than argued for.
  *(UX-S6)*
- **A default that asks nothing.** `Auto` — the current branch and what relates to it — means the
  reader who never opens the picker still gets a graph. The argument for taking it: a scoping
  control with no default would make the history view's arrival state a prompt, and every other
  surface in this product arrives as a state. *(UX-S6's arrival cell)*
- **Refs grouped by kind, each showing its tip identifier.** The list says what each entry is in
  words, without the reader knowing a naming convention. *(UX-I6, read as covering what the
  product labels and not only what it reports)*
- **The branch name on the commit that is its tip.** Where a branch currently points is readable in
  the graph itself, not only in the control that scopes it.

### Do not take

- **`origin/HEAD` and `origin/main`.** Nozoki reports the state of the local repository; a remote's
  refs describe a relationship it does not report. The same exclusion as the outgoing-changes
  framing in `vscode-git-view.png`.
- **The `Outgoing Changes` group** behind the picker — excluded already, and named again here
  because this image is where it is most visible.
- **The commit boxes, `Sync Changes`, and the `Commit` button** — these write. *(UX-I1)*
- **Two repositories open at once** — same exclusion as `vscode-repo-selector.png`. *(UX-F5)*

### Not what it looks like

The picker's filter field filters **the ref list**, not the history. History filtering and search
stay out of v1 (`UXD.md` § 10), and nothing in this image reopens them.

### One refinement it hands the CDO

The drafted statement scoped the history by *a* branch choice. This image shows the choice is a
**set** — one branch, several, or all of them. The next round reconciles the wording; it is a
refinement of the drafted shape, not a new question.

**It was reconciled.** *Set* is the word both settled documents now use — `UXD.md` UX-F4 and
`SRS.md` FR-18, each reading "a chosen **set** of branches — one, several, or all of them". The
draft this pointed at (`docs/UXD_open_issues.md` § 2.1) was removed at `nozoki@9017ae2`.

---

## Four images described, not adjudicated

Three were added at `nozoki@b7119cb` and one at `nozoki@8879041`, all from the same workbench.
They are here as evidence, not as annotation: nothing in them is taken or excluded, and by this
file's own rule nothing in them has been considered.

For the three from `b7119cb` there is a reading on record, made elsewhere. The owner directed the
CDO seat to say whether they moved any UXD entry, and the answer was that they move none, with a
reason per image — `UXD.md` RN-13, from the run at `docs/trail/uxd/cycle-5.md` § 1.1. **That is a
decision about the UXD, not an annotation of these images:** it says what the three do not change,
not what this file takes from them. The summaries below carry it so a reader here need not go and
find it.

### `vscode-git-view-worktree-stack.png` — the changes list under several working trees

The Source Control view with a repository and three worktree branches listed as peers, each its
own collapsible section with its own message box and its own `Commit` or `Publish Branch` button;
one section is expanded to its changed files, with `M` and `U` status letters and `.worktrees/…`
paths. The graph sits beneath it, drawn on `main`.

Recorded read (RN-13): moves no entry — several folders open at once, and editing affordances, are
both already excluded (UX-F5, UX-I1; `PRD.md` § Out of Scope).

### `vscode-git-graph-merge-lanes.png` — the graph under two lanes

The same view scrolled to the graph, which draws two lanes in different colours with merge commits
running both ways — `merge: ppm-creates-seeds → main` and `merge: main → ppm-creates-seeds` —
where the earlier shots show one lane. The tip commit carries the `main` chip.

Recorded read (RN-13): moves no entry — it is a picture of what UX-F4 and UX-S6 already state,
with branch membership carried by lane position as well as by colour, which is UX-A2 as written.

### `vscode-branch-filter-many-branches.png` — the same picker at scale

The ref picker of `vscode-branch-filter.png` over nine local branches plus `origin/HEAD` and
`origin/main`, `main` alone checked and the header reading `1 Selected`, with the graph and an
open file behind it. Kept as that image's sibling so the two sort together.

Recorded read (RN-13): moves no entry — the same control at a scale where its ref-list filter
earns its place; the mechanism is unbound by the owner's own word (RN-14), and a ref-list filter
is not history filtering (`UXD.md` § 10).

### `vscode-commit-detail-pane.png` — what selecting a commit opens

Added at `nozoki@8879041`. The graph with one commit selected and its detail filling the reading
panel: author avatar and name, the time both relative and absolute, the message body in full, the
commit's trailers as plain lines, the branch chip, `1 file changed`, the short identifier with a
copy control, and an `Open on GitHub` link. The seven images before it show the changes list and
the graph; none shows what selecting a commit opens.

**No read on record.** No seat has yet said what this image moves or does not move: it landed
after `UXD.md` v10, and after RN-13 counted seven. Two things it sits beside, named so the
question stays legible and not so it is answered here — UX-F4 and UX-S6 already settle that
selecting a commit presents what that commit changed and that a commit's entry carries identifier,
message, author and date; UX-I1 already excludes what writes. Whether anything else in this pane
is taken is open.

---

## Owner directives

Two things the owner decided while reviewing these images. Both are for the CDO to draft into the
UXD; neither is settled here.

### 1. Branch topology in the history view

The owner wants a reader with more than one branch to be able to see that, rather than reading a
flat list that flattens them together.

This revises a decision the owner made earlier: `docs/trail/srs/cycle-1.md` §2.2 settled the
history as a read-only list of identifier, message, author and date. A list cannot show where
branches diverge or merge, so the shape is open again, by the owner's own revision — not by
inference from these screenshots. RN-6 recorded the beyond-v1 shape as carried and not re-opened,
which this paragraph flagged as out of date; it since was. RN-6 now carries the **diff** shape and
the placement calls only, and the history's shape is RN-14's.

**What the CDO is asked to do:** look at what VS Code's own source-control graph presents and what
its documentation says about it, then draft the experience-level statement — what a reader must be
able to see when a repository has more than one branch. Draft it; do not settle it.

**Feasibility is downstream.** Whether topology is expensive to render is the SRS's and the SDD's
question, not this document's. It does not narrow what the UXD asks for. One consequence to hand
forward: the SRS's `FR-18` describes the history as a list, so it needs a revision once this
lands. **It got one** — FR-18 now binds the topology and the chosen branch set as properties, with
the drawing and the choosing left downstream (`docs/SRS.md` FR-18, on the owner's override at
`docs/trail/srs/cycle-3.md`).

Still inside the terminus either way — the Agari places the history inside done and does not bound
its shape.

**Where it now stands: settled.** The owner bound the properties and not the mechanism, in their
own words at `docs/trail/srs/cycle-3.md` § 2.1. The UXD carries the shape at UX-F4 and UX-S6 and
the reasoning at RN-14, and § 5.4's closing line records it as carried and not reopened. The
companion this line used to point at (`docs/UXD_open_issues.md` § 2.1) was removed at
`nozoki@9017ae2`.

### 2. Switching the viewed repository is a dropdown

`UX-F5` says only "a single switch action in the shell". The owner names the control: a dropdown,
listing the repositories Nozoki remembers, with an entry to browse for one not in the list. On
first run the list is empty and only the browse entry is there.

Remembering them is already permitted — `PRD.md:290-293` lets the tool keep its own state between
sessions, provided it lives outside the viewed repository. Nothing here needs the CPO.

**Not settled — where the control lives.** VS Code carries the repository name twice: in the title
row, and as the control in the graph header (this image). Nozoki has to choose one, because a name
in one place and a switch in another is two elements telling one truth.

- **In the shell chrome** — the identity element (§ 4, RN-2) becomes the control. Reachable from
  either view, and what names the repository is what changes it.
- **In the Git view header**, as the image shows — grouped with the other repository-scoped
  controls, but unreachable while the sidebar is in Files mode.

The CDO drafts a lean with the whole document in view and routes it back through the companion.

**Where it now stands: settled — the shell chrome.** The owner confirmed it
(`docs/trail/uxd/cycle-1.md` § 2.2); the UXD carries it at UX-F5, UX-S7 and § 4, with the
reasoning at RN-15. Two things moved with it, and restating them is not this file's job: the input
widened from a repository to any local folder, so the control is the **folder selector** (RN-25),
and its list is bounded to ten by recency (UX-S7, RN-29). The companion this line used to point at
(`docs/UXD_open_issues.md` § 2.2) was removed at `nozoki@9017ae2`.

---

## One question the reference raises

VS Code switches views with a vertical rail of icons. Nozoki's navigation is text-first with icons
secondary (§ 4), and it has exactly two destinations. Whether the Files/Git switch is a rail, a
pair of labelled tabs at the top of the sidebar, or something else is not settled by these images
and is not settled here.

**Where it now stands: settled — a vertical rail,** each of its two entries carrying its icon with
a small text label beneath it. The owner overrode the drafted labelled tabs
(`docs/trail/uxd/cycle-1.md` § 2.3), so the mechanism this section questioned is the one taken,
with a label attached; `UXD.md` RN-16 carries it. The companion this line used to point at
(`docs/UXD_open_issues.md` § 2.3) was removed at `nozoki@9017ae2`.
