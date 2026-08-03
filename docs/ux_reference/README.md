# UX reference — layout, not style

Four screenshots of VS Code, taken by the owner as a layout reference for Nozoki's shell.

They are here for **what the layout does** — where things sit, how the sidebar relates to the
reading panel, how a changed file is marked. They are **not** a reference for how Nozoki should
look. The design direction is a restrained workbench built from primitives, no established
component design system (`UXD.md` § 9); VS Code's own visual language is not being adopted.

Neither image is annotated. This file is the annotation: every element is either taken or
excluded below, and an element not listed here was not considered.

Both shots are dark. That says nothing about Nozoki's default — the initial theme follows the
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

The drafted statement (`docs/UXD_open_issues.md` § 2.1) scopes the history by *a* branch choice.
This image shows the choice is a **set** — one branch, several, or all of them. The next round
reconciles the wording; it is a refinement of the drafted shape, not a new question.

---

## Owner directives

Two things the owner decided while reviewing these images. Both are for the CDO to draft into the
UXD; neither is settled here.

### 1. Branch topology in the history view

The owner wants a reader with more than one branch to be able to see that, rather than reading a
flat list that flattens them together.

This revises a decision the owner made earlier: `docs/srs_trail/cycle-1.md` §2.2 settled the
history as a read-only list of identifier, message, author and date. A list cannot show where
branches diverge or merge, so the shape is open again, by the owner's own revision — not by
inference from these screenshots. `UXD.md` RN-6 currently records the beyond-v1 shape as carried
and not re-opened; that note is now out of date.

**What the CDO is asked to do:** look at what VS Code's own source-control graph presents and what
its documentation says about it, then draft the experience-level statement — what a reader must be
able to see when a repository has more than one branch. Draft it; do not settle it.

**Feasibility is downstream.** Whether topology is expensive to render is the SRS's and the SDD's
question, not this document's. It does not narrow what the UXD asks for. One consequence to hand
forward: the SRS's `FR-18` describes the history as a list, so it needs a revision once this
lands.

Still inside the terminus either way — the Agari places the history inside done and does not bound
its shape.

**Where it now stands:** drafted, awaiting the owner. The statement is `docs/UXD_open_issues.md`
§ 2.1; `vscode-branch-filter.png` above was supplied after it was drafted.

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

**Where it now stands:** the dropdown is drafted into the UXD; the placement is leaned and awaiting
the owner at `docs/UXD_open_issues.md` § 2.2.

---

## One question the reference raises

VS Code switches views with a vertical rail of icons. Nozoki's navigation is text-first with icons
secondary (§ 4), and it has exactly two destinations. Whether the Files/Git switch is a rail, a
pair of labelled tabs at the top of the sidebar, or something else is not settled by these images
and is not settled here.

**Where it now stands:** leaned and awaiting the owner at `docs/UXD_open_issues.md` § 2.3.
