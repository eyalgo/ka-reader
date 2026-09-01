# FDR open issues — Nozoki 覗き

> Companion to `fdr.md`. The Principal PM authored the FDR non-interactively; this file holds what the
> run could not settle from its inputs — the PRD, the SRS and the SDD.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-fdr`. It folds your answers into the FDR and drops the resolved items. When nothing is
> left open, `product-fdr` **deletes this file**: no file = the FDR is done.
>
> Your answers are never thrown away. Each time the Principal PM folds them in, it first copies this
> file whole to `docs/trail/fdr/` — so what you decided, and why, stays readable and citable for good.

---

## 1. Open issues — behavioural questions with no answer yet

### 1.1 What happens when the Open panel is cancelled at launch, before any folder is chosen
- **Why it matters:** `fdr.md` R-4 has the product present the Open panel at every launch until the folder selector exists, and R-7 / R-8 define the startup-failure surface for a path that fails. Neither the SRS (FR-2, FR-3) nor the SDD (§ 4 C-R3) says what the product does when the person dismisses the panel without choosing: quit, present the panel again, or show the startup surface with its "choose again" and "quit" routes and no failure text. A stranger's first launch can end here, and whichever a builder picks becomes the contract. My lean, offered and not drafted: the product shows the startup surface with the two routes and no failure sentence — the person is not in a failure, they declined — because R-86 forbids a dead end and quitting silently is one.
- **Answer:**

### 1.2 What the remembered-folders list holds, how long, and what the reader can do to it
- **Why it matters:** `fdr.md` R-108, R-122 and R-125 state that the product remembers folders and lists them in the selector, and R-5 says a remembered folder that no longer resolves is not restored at launch. No source says whether every folder ever chosen is remembered or only the last *n*; whether the list is ordered by recency or by name; whether an entry whose folder has since moved or been deleted is still listed, and what choosing it does; and whether the reader can remove an entry (the one write to own state R-110 makes reversible). Each is a rule a builder would otherwise invent, and the list is the product's only own-state surface beyond the theme.
- **Answer:**

### 1.3 What the reader sees and can do at the end of the history's loaded window
- **Why it matters:** `fdr.md` R-120 carries the SDD's bounded window of commits (`docs/SDD.md` § Open Questions, the loaded-window size) and leaves its size to the CTO. No source says what the history shows where the window ends — nothing, a stated "older commits not loaded", or more commits loaded on demand — nor whether a branch whose tip lies beyond the window is drawn at all. R-117's default set already depends on the window (a branch's merge-base must lie inside it), so the answer changes which branches the reader sees without touching anything.
- **Answer:**

### 1.4 What the "short repository status" contains, and what the branch element shows on a detached HEAD
- **Why it matters:** `fdr.md` R-65 carries the PRD's and SRS's four elements — changed files, staged files, branch name, and *"a short repository status"* (`docs/PRD.md` § Core Features; `docs/SRS.md` § 3.4 FR-12) — and the SDD's GitState holds "short status" as a field distinct from the repository state (normal / merge / rebase / cherry-pick / revert / bisect / detached) and from the branch name (`docs/SDD.md` § 3, entity GitState). Nothing states what the short status says. Two things turn on it: whether the repository's mid-operation state (R-71) is what the status reports, and whether anything about a remote — ahead/behind — is inside it, which OOS-24 excludes on FR-12's closed list and R-98's no-network rule. And on a detached HEAD there is no branch name; no source says what the branch element shows — the commit identifier is the reading I would draft.
- **Answer:**

### 1.5 What the reader sees for a file too large to display with no perceived wait
- **Why it matters:** `fdr.md` R-50 binds file selection to no perceived wait, R-84 binds that across realistic file sizes with the reference size undecided, and the SRS's DR-6 requires the product to tolerate "arbitrarily large files". No source says what the reading panel shows for a file past whatever size the product can display inside R-50: the whole file with the wait, a truncated view that says so, or a cannot-display state. Each is product-visible and each is testable; none is derivable.
- **Answer:**

## 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override

### 2.1 Where the diff exists, a changed file's row in the Git view opens the diff, and the file is read from the tree
- **Drafted into the FDR:** R-70 — one click target on the row, opening the diff; the status letter a label, never a second target; the file read by selecting it in the tree. R-69 keeps the SRS's FR-13 behaviour (the row opens the file) for the product before the diff exists. RN-1 records the departure.
- **Rationale:** your answer to the SDD's question, by demonstration against VS Code's Source Control view: *"the row opens the diff. One click target on the row; the file itself is read by clicking it in the tree"* (`docs/trail/sdd/cycle-1.md` § 1.2), carried by `docs/SDD.md` § SDD Review Notes RN-20. It contradicts `docs/SRS.md` § 3.4 FR-13 — *"A file listed in the Git view can be opened for reading exactly as a tree selection is"* — at the closing release, and the SRS has not been revised. The FDR follows your later, authorized answer and surfaces the contradiction rather than arbitrating it; it is listed because a departure from a source is never a silent edit.
- **If overridden:** if FR-13 stands as written at the closing release, R-70 is removed and R-69 loses its condition; the diff then needs a different way to open (a second target on the row, or a control on the reading panel's path line — the two shapes the CDO offered in the same item), which is a UXD call and reaches the FDR by that document's revision. Either way the SRS's FR-13 and the UXD's UX-F2 want the CTO's and the CDO's revision through their own skills; confirming here does not make it.
- **Confirm or override:**

### 2.2 The history's default branch set, and that only local branches are offered
- **Drafted into the FDR:** R-117 — the default set is the branch HEAD is on plus every local branch whose merge-base with HEAD lies inside the loaded window; only local branches are offered for choosing.
- **Rationale:** `docs/SRS.md` § 3.6 FR-18 binds the default as "the current branch and what relates to it" and leaves what chooses the set downstream; `docs/SDD.md` § SDD Review Notes RN-16 computes "relates to" as the merge-base reading and says in the same note that whether it matches what you meant is the CPO's and CDO's to challenge. "Local branches only" follows from OOS-24 (no relationship to a remote is reported) and from the same note's wording, "every local branch". The reference you supplied excluded `origin/*` refs (`docs/ux_reference/README.md` § `vscode-branch-filter.png`), which is consistent, but that file is not a source this document may cite.
- **If overridden:** a different reading of "relates to" rewords R-117 and the example row that exercises it; admitting remote-tracking branches to the choosable set narrows OOS-24 to ahead/behind and outgoing counts, touches no network rule (the refs are local files), and rewords R-117's second clause. The SDD's RN-16 is then revised through its own run.
- **Confirm or override:**

### 2.3 The tree shows every entry, `.git` and dot-entries included; folders first, ordered by name; sub-folders collapsed at arrival
- **Drafted into the FDR:** R-29 (nothing hidden, `.git` included), R-30 (folders before files, each group ordered by name without regard to letter case), R-31 (root entries shown, every sub-folder collapsed at arrival).
- **Rationale:** `docs/SRS.md` § 3.2 FR-5 says "a navigable tree" and no source says more. Completeness is derived from `docs/PRD.md` § Goals — *"browse and read anything in the folder"* — and from the SRS's RN-14, "nothing hidden from the tree" (OOS-21); showing `.git` is the consequence I could not soften without inventing an exclusion, and the product's edge is that it hides nothing. The ordering and the arrival expansion are conventions of the editor-style layout the PRD's familiarity thesis bets on, and a convention is a domain default, never a derivation — so all three are yours.
- **If overridden:** hiding `.git` (or all dot-entries) adds an exclusion rule and an OOS entry, and narrows R-29's example row; a different ordering rewords R-30; a deeper or shallower arrival rewords R-31. Nothing else moves.
- **Confirm or override:**

### 2.4 A file is text when its bytes decode as UTF-8; otherwise it cannot be shown as text
- **Drafted into the FDR:** R-46 — UTF-8, with or without a byte-order mark, is text; anything else lands in R-47's cannot-be-shown-as-text state.
- **Rationale:** `docs/SRS.md` § 3.3 FR-10 names "binary or undecodable content" without saying what decodes, and the SDD assigns "deciding text / not-text and decoding" to a part without stating the rule (`docs/SDD.md` § 3 `fs-reader`). UTF-8-only is the reading that keeps *never mis-highlighted* cheap and keeps the product from guessing an encoding — a guess shown as text is the garbled render the PRD forbids (§ UX Notes "Failure states"). It is a convention, so it is yours.
- **If overridden:** admitting other encodings (Latin-1, UTF-16 by byte-order mark) widens R-46 and adds each admitted encoding to the example row; the cannot-display state narrows to what still does not decode. R-47 stands.
- **Confirm or override:**

### 2.5 A symbolic link inside the folder is read as its target; one pointing outside is an entry that cannot be read
- **Drafted into the FDR:** R-34.
- **Rationale:** the SDD's containment check refuses any read of a path outside the granted folder, symbolic links resolved (`docs/SDD.md` § 3 `fs-reader`; § 4 C-D1), which fixes the outside case as unreadable; that the entry is still shown follows from OOS-21. The inside case — read as the target — is the smallest behaviour that keeps "browse anything" true. What the reader sees for a link is product-visible, so the pair is yours.
- **If overridden:** omitting outside-pointing links from the tree adds an exclusion to OOS-21 and rewords R-34; showing a link as a link (target path, not content) adds a treatment to the reading panel the UXD does not draw, and reaches the FDR through that document.
- **Confirm or override:**

### 2.6 The Git view and the tree report six change categories — added, modified, deleted, renamed, untracked, in conflict
- **Drafted into the FDR:** R-66.
- **Rationale:** `docs/SRS.md` § 3.4 FR-12 says "changed files" and `docs/SDD.md` § 3 (entity GitState) carries "status letters" without enumerating them. The six are Git's own status categories and the set the product's design and verbal language already draw as `A M D R U C`; the FDR may not cite those siblings, so the set is stated with Git as its basis. One consequence worth confirming on its own: an untracked file is a *changed* file here — it is marked in the tree and listed in the Git view — and an ignored file is not.
- **If overridden:** dropping untracked files from "changed" narrows R-35 and R-66 and the example rows; adding a category (copied, type-changed) widens R-66 and asks the design and verbal language for a letter and a word.
- **Confirm or override:**

### 2.7 A linked worktree or submodule whose Git directory lies outside the folder shows a Git-view failure naming the folder to choose
- **Drafted into the FDR:** R-21 — the folder opens, the tree and reading panel work, and the Git view presents a failure state naming the folder that would need to be chosen for Git state to be read.
- **Rationale:** `docs/SRS.md` § 3.1 FR-33 makes both a repository root, and `docs/SDD.md` § 11 R-3 records that the grant to the chosen folder does not cover a Git directory outside it, with this presentation as the response and the case "recorded as a known limit beside the install path". A limit a stranger meets is behaviour, so the FDR states it — from § 11, which the authoring lens does not name among the SDD sections it draws on (RN-7), and that is the reason it is listed: the source is settled, the altitude is unusual.
- **If overridden:** if the SDD later finds a grant path for the outside case, R-21 is removed by that upstream change; if you want the case to read as a plain folder instead of a Git-view failure, R-21 rewords, R-15 gains an exception, and the SRS's FR-33 needs the CTO's revision.
- **Confirm or override:**

### 2.8 An image whose reference escapes the folder takes the not-fetched placeholder, never the image
- **Drafted into the FDR:** R-59.
- **Rationale:** `docs/SDD.md` § 4 C-D3 has the product answer nothing for a path outside the folder (symbolic links followed), and the SDD's CDO seat drew that nothing as the same placeholder a remote image takes, naming it a reading the UXD's own run outranks (`docs/SDD.md` § SDD Review Notes RN-26). Two seats hedged it, and what the reader sees where an image would be is product-visible, so it is yours.
- **If overridden:** drawing the escaping image differently from a remote one — a distinct statement, or an empty box — rewords R-59 and the example row, and asks the UXD's UX-I12 and the verbal language for the new state; nothing about R-56 – R-58 moves.
- **Confirm or override:**

### 2.9 What a later version does with an earlier version's own state — kept, or discarded whole, never a startup failure

> **This item was raised by a `companion-self-answer` run on the architecture companion
> (`docs/architecture_open_issues.md` § 2.2), not by a `product-fdr` run.** The Principal Architect
> drafted the rule as `docs/nfdr.md` QC-60 and put it to the owner; its visible half — remembered
> folders and the theme surviving an upgrade, or not — is behaviour, which is this document's, so
> the item lands here with the run's answer and its reasoning
> (`docs/trail/architecture/self_answer-1.md` § 2.2). The decision is the next round's.

- **Drafted into the FDR:** nothing yet — proposed as a rule beside R-108 – R-110: *A later version
  of the product either reads an earlier version's own state — theme, window state, remembered
  folders — or discards it whole, and in neither case touches the viewed folder; a version that
  meets own state it cannot read, earlier or later, discards it whole and opens as on first run,
  never as a startup failure. Before 1.0.0 a discard is inside the anything-may-change statement
  (R-142); from 1.0.0 a discard is a breaking change and takes a major version (PD-20).*
- **Rationale:** own state is the one thing a stranger accumulates across releases (`docs/SRS.md`
  § 6 DR-5; R-108), and no rule says whether an upgrade keeps it — "my remembered folders vanished"
  is behaviour an adopter meets. The NFDR's draft (QC-60) is taken with two additions. The rule is
  made *symmetric*, so a downgrade — an older `.dmg` over a newer own state, which a rule about
  "a later version" cannot bind once the older version has shipped — is covered by every version
  discarding what it cannot read. And an unreadable own state is named as *not a startup failure*:
  R-7's failure list is closed to the three folder cases, and a product that would not open because
  of its own file breaks that. "Read or discard whole", never partial, because a half-read state is
  one nobody can reason about. Adjacent to § 1.2 above: that item is about retention *inside* a
  version, this one about survival *across* versions; answering them together keeps R-108's two
  halves in one place.
- **If overridden:** requiring migration always adds a check per release and a migration path from
  the first release on; permitting discard always removes own state from what semantic versioning
  protects (`docs/nfdr.md` QC-59's contract). Either way the NFDR's QC-60 follows this document's
  rule by its own revision and keeps its check (`checks/own-state.sh --from <previous-tag>`).
- **Confirm or override:**
