# FDR open issues — KA-Reader

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
- **Answer:** The product neither quits nor presents the panel again on its own. Cancelling the Open panel at launch shows the startup surface R-8 names, with its two routes — a way to choose a folder and a way to quit — and no failure sentence: nothing failed, and no message names a cause the product did not observe (R-89). Choosing again presents the Open panel; cancelling that returns to the same surface, as often as it happens. Once the folder selector exists (R-5), the same holds for a panel presented because no folder is remembered or the remembered folder no longer resolves, with the selector as the route in place of choose-again. The experience cell this adds — UX-S4 outside failure — is raised on `docs/UXD_open_issues.md` § 2.1. Reasoning: `docs/trail/fdr/self_answer-1.md` § 1.1.

### 1.2 What the remembered-folders list holds, how long, and what the reader can do to it
- **Why it matters:** `fdr.md` R-108, R-122 and R-125 state that the product remembers folders and lists them in the selector, and R-5 says a remembered folder that no longer resolves is not restored at launch. No source says whether every folder ever chosen is remembered or only the last *n*; whether the list is ordered by recency or by name; whether an entry whose folder has since moved or been deleted is still listed, and what choosing it does; and whether the reader can remove an entry (the one write to own state R-110 makes reversible). Each is a rule a builder would otherwise invent, and the list is the product's only own-state surface beyond the theme.
- **Answer:** The product remembers the ten folders most recently viewed, listed most recently viewed first with the current folder among them and marked; nothing else orders the list, and an eleventh folder viewed removes the one viewed longest ago. An entry stays listed until it leaves that way — it is not dropped because its folder has since moved or gone, and, R-5's launch check aside, the product does not look until the entry is chosen: choosing an entry whose folder can still be found opens it, and choosing one whose folder cannot be found gets R-126's statement with the previous folder still viewed. No control removes an entry or clears the list; a folder the reader no longer wants listed ages out. R-110 holds as written: the only thing that changes the list is viewing a folder. Reasoning: `docs/trail/fdr/self_answer-1.md` § 1.2.

### 1.3 What the reader sees and can do at the end of the history's loaded window
- **Why it matters:** `fdr.md` R-120 carries the SDD's bounded window of commits (`docs/SDD.md` § Open Questions, the loaded-window size) and leaves its size to the CTO. No source says what the history shows where the window ends — nothing, a stated "older commits not loaded", or more commits loaded on demand — nor whether a branch whose tip lies beyond the window is drawn at all. R-117's default set already depends on the window (a branch's merge-base must lie inside it), so the answer changes which branches the reader sees without touching anything.
- **Answer:** The loaded window holds the most recent commits of the chosen branch set, so every chosen branch's tip is inside it and drawn. Where older commits exist past the window's end, the history states at its end that older commits are not shown; where the whole history fits, nothing is stated. No control loads more, and the window's size stays the CTO's (R-120). A chosen branch whose divergence from the others lies past the end runs as its own rail to the stated end without its join being drawn — which is why R-117's default set admits only branches whose merge-base lies inside the window, while any local branch may still be chosen. The stated end is a state UX-S6 does not draw; raised on `docs/UXD_open_issues.md` § 2.1. Reasoning: `docs/trail/fdr/self_answer-1.md` § 1.3.

### 1.4 What the "short repository status" contains, and what the branch element shows on a detached HEAD
- **Why it matters:** `fdr.md` R-65 carries the PRD's and SRS's four elements — changed files, staged files, branch name, and *"a short repository status"* (`docs/PRD.md` § Core Features; `docs/SRS.md` § 3.4 FR-12) — and the SDD's GitState holds "short status" as a field distinct from the repository state (normal / merge / rebase / cherry-pick / revert / bisect / detached) and from the branch name (`docs/SDD.md` § 3, entity GitState). Nothing states what the short status says. Two things turn on it: whether the repository's mid-operation state (R-71) is what the status reports, and whether anything about a remote — ahead/behind — is inside it, which OOS-24 excludes on FR-12's closed list and R-98's no-network rule. And on a detached HEAD there is no branch name; no source says what the branch element shows — the commit identifier is the reading I would draft.
- **Answer:** The short status is one statement of the repository's condition, shown only after Git state has been read (R-68) and only when it has something to say: it names the state the repository is in when that is anything but normal — mid-merge, mid-rebase, mid-cherry-pick, mid-revert, bisecting, or a detached HEAD — in Git's own word for it, and it states that nothing has changed when the working tree and the index are clean. Where files have changed, the changed and staged lists with their counts say so and the status adds no count of its own. So R-71's mid-operation state is what the short status reports, and the repository's relationship to a remote is not inside it (OOS-24). On a detached HEAD the branch element shows the commit's identifier as the history shows it (R-118), and the short status says HEAD is detached; during a rebase the element shows the identifier too and the status says rebase — the branch being rebased is not named, a case named as uncovered rather than drafted. Reasoning: `docs/trail/fdr/self_answer-1.md` § 1.4.

### 1.5 What the reader sees for a file too large to display with no perceived wait
- **Why it matters:** `fdr.md` R-50 binds file selection to no perceived wait, R-84 binds that across realistic file sizes with the reference size undecided, and the SRS's DR-6 requires the product to tolerate "arbitrarily large files". No source says what the reading panel shows for a file past whatever size the product can display inside R-50: the whole file with the wait, a truncated view that says so, or a cannot-display state. Each is product-visible and each is testable; none is derivable.
- **Answer:** The reading panel shows the whole file. While a file is still being read the panel shows that it is pending — R-94's word, no progress claim — the tree beside it stays enabled and the shell never blocks (R-85); when the read completes the content appears whole, with no truncation and no size-based cannot-display state: a file that is text (R-46) is shown. R-50's no-perceived-wait bar is held inside R-84's reference sizes and is not a promise past them. Should a ceiling exist above which the product cannot show a file at all, that ceiling is a number the CTO fixes in the SRS by revision with R-84's sizes, and a file past it takes R-51's statement of what the product observed, naming the ceiling — an observed condition, never a fault. Reasoning: `docs/trail/fdr/self_answer-1.md` § 1.5.

## 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override

### 2.1 Where the diff exists, a changed file's row in the Git view opens the diff, and the file is read from the tree
- **Drafted into the FDR:** R-70 — one click target on the row, opening the diff; the status letter a label, never a second target; the file read by selecting it in the tree. R-69 keeps the SRS's FR-13 behaviour (the row opens the file) for the product before the diff exists. RN-1 records the departure.
- **Rationale:** your answer to the SDD's question, by demonstration against VS Code's Source Control view: *"the row opens the diff. One click target on the row; the file itself is read by clicking it in the tree"* (`docs/trail/sdd/cycle-1.md` § 1.2), carried by `docs/SDD.md` § SDD Review Notes RN-20. It contradicts `docs/SRS.md` § 3.4 FR-13 — *"A file listed in the Git view can be opened for reading exactly as a tree selection is"* — at the closing release, and the SRS has not been revised. The FDR follows your later, authorized answer and surfaces the contradiction rather than arbitrating it; it is listed because a departure from a source is never a silent edit.
- **If overridden:** if FR-13 stands as written at the closing release, R-70 is removed and R-69 loses its condition; the diff then needs a different way to open (a second target on the row, or a control on the reading panel's path line — the two shapes the CDO offered in the same item), which is a UXD call and reaches the FDR by that document's revision. Either way the SRS's FR-13 and the UXD's UX-F2 want the CTO's and the CDO's revision through their own skills; confirming here does not make it.
- **Confirm or override:** confirm — R-69, R-70 and RN-1 stand. Two things ride with it. The two sibling revisions RN-1 names as owed are now raised where their seats can act: the SRS's FR-13 and AC-6 on `docs/SRS_open_issues.md` § 2.1, the UXD's UX-F2 on `docs/UXD_open_issues.md` § 2.1. And three cases the row's one rule reaches, for the example row: a file both staged and modified opens the diff of the list it was clicked in (R-112); an untracked file's row opens its diff as the whole file added; a conflicted file's row opens its unstaged diff with the conflict as Git left it. Reasoning: `docs/trail/fdr/self_answer-1.md` § 2.1.

### 2.2 The history's default branch set, and that only local branches are offered
- **Drafted into the FDR:** R-117 — the default set is the branch HEAD is on plus every local branch whose merge-base with HEAD lies inside the loaded window; only local branches are offered for choosing.
- **Rationale:** `docs/SRS.md` § 3.6 FR-18 binds the default as "the current branch and what relates to it" and leaves what chooses the set downstream; `docs/SDD.md` § SDD Review Notes RN-16 computes "relates to" as the merge-base reading and says in the same note that whether it matches what you meant is the CPO's and CDO's to challenge. "Local branches only" follows from OOS-24 (no relationship to a remote is reported) and from the same note's wording, "every local branch". The reference you supplied excluded `origin/*` refs (`docs/ux_reference/README.md` § `vscode-branch-filter.png`), which is consistent, but that file is not a source this document may cite.
- **If overridden:** a different reading of "relates to" rewords R-117 and the example row that exercises it; admitting remote-tracking branches to the choosable set narrows OOS-24 to ahead/behind and outgoing counts, touches no network rule (the refs are local files), and rewords R-117's second clause. The SDD's RN-16 is then revised through its own run.
- **Confirm or override:** confirm — R-117 stands, with two cases added: on a detached HEAD there is no branch HEAD is on, so the default set is HEAD's commit plus every local branch whose merge-base with it lies inside the window; and a repository with no commits has no set, and the history states that there are none. Tags and remote-tracking refs are never offered, which is OOS-24 as it stands. Reasoning: `docs/trail/fdr/self_answer-1.md` § 2.2.

### 2.3 The tree shows every entry, `.git` and dot-entries included; folders first, ordered by name; sub-folders collapsed at arrival
- **Drafted into the FDR:** R-29 (nothing hidden, `.git` included), R-30 (folders before files, each group ordered by name without regard to letter case), R-31 (root entries shown, every sub-folder collapsed at arrival).
- **Rationale:** `docs/SRS.md` § 3.2 FR-5 says "a navigable tree" and no source says more. Completeness is derived from `docs/PRD.md` § Goals — *"browse and read anything in the folder"* — and from the SRS's RN-14, "nothing hidden from the tree" (OOS-21); showing `.git` is the consequence I could not soften without inventing an exclusion, and the product's edge is that it hides nothing. The ordering and the arrival expansion are conventions of the editor-style layout the PRD's familiarity thesis bets on, and a convention is a domain default, never a derivation — so all three are yours.
- **If overridden:** hiding `.git` (or all dot-entries) adds an exclusion rule and an OOS entry, and narrows R-29's example row; a different ordering rewords R-30; a deeper or shallower arrival rewords R-31. Nothing else moves.
- **Confirm or override:** confirm — R-29, R-30 and R-31 stand, with the ground under R-29 corrected on the fold and one tie named. The ground: `docs/SRS.md` § SRS Review Notes RN-14's "nothing hidden from the tree" is said of FR-10's unrenderable files, not of dot-entries or `.git`; what R-29 and OOS-21 rest on is `docs/PRD.md` § Goals "browse and read anything in the folder" and PD-2's flat reading of a folder — cite those, not RN-14. The tie: two names equal without regard to case keep their byte order, and digits are compared as characters, so `file10` precedes `file2` — plain name order, nothing numeric-aware. `.git` sits collapsed at arrival like any sub-folder and carries no marker, because Git reports nothing about itself. Reasoning: `docs/trail/fdr/self_answer-1.md` § 2.3.

### 2.4 A file is text when its bytes decode as UTF-8; otherwise it cannot be shown as text
- **Drafted into the FDR:** R-46 — UTF-8, with or without a byte-order mark, is text; anything else lands in R-47's cannot-be-shown-as-text state.
- **Rationale:** `docs/SRS.md` § 3.3 FR-10 names "binary or undecodable content" without saying what decodes, and the SDD assigns "deciding text / not-text and decoding" to a part without stating the rule (`docs/SDD.md` § 3 `fs-reader`). UTF-8-only is the reading that keeps *never mis-highlighted* cheap and keeps the product from guessing an encoding — a guess shown as text is the garbled render the PRD forbids (§ UX Notes "Failure states"). It is a convention, so it is yours.
- **If overridden:** admitting other encodings (Latin-1, UTF-16 by byte-order mark) widens R-46 and adds each admitted encoding to the example row; the cannot-display state narrows to what still does not decode. R-47 stands.
- **Confirm or override:** confirm, with one encoding added: a file whose bytes begin with a UTF-16 byte-order mark and decode as UTF-16 is text too — the mark says what the file is, so admitting it is not a guess, and refusing a file the product can read without guessing is the refusal FR-29's "never refused" is written against. Everything else stands: no Latin-1, no detection by content, and a file with one byte sequence that does not decode is not text — a file torn mid-write included, which R-77's convergence and R-83's recovery cover on the next read. An empty file is text. R-46's example row gains the UTF-16 case. Reasoning: `docs/trail/fdr/self_answer-1.md` § 2.4.

### 2.5 A symbolic link inside the folder is read as its target; one pointing outside is an entry that cannot be read
- **Drafted into the FDR:** R-34.
- **Rationale:** the SDD's containment check refuses any read of a path outside the granted folder, symbolic links resolved (`docs/SDD.md` § 3 `fs-reader`; § 4 C-D1), which fixes the outside case as unreadable; that the entry is still shown follows from OOS-21. The inside case — read as the target — is the smallest behaviour that keeps "browse anything" true. What the reader sees for a link is product-visible, so the pair is yours.
- **If overridden:** omitting outside-pointing links from the tree adds an exclusion to OOS-21 and rewords R-34; showing a link as a link (target path, not content) adds a treatment to the reading panel the UXD does not draw, and reaches the FDR through that document.
- **Confirm or override:** confirm — R-34 stands, with two cases named that the inside rule reaches: a link whose target is a folder is shown as a folder and expands into its target; a link whose target contains the link's own position — a cycle — and a link whose target does not exist are each presented as R-33's entry that cannot be read, marked with what the product observed (the cycle; the missing target). No new treatment: R-33's state carries both. Reasoning: `docs/trail/fdr/self_answer-1.md` § 2.5.

### 2.6 The Git view and the tree report six change categories — added, modified, deleted, renamed, untracked, in conflict
- **Drafted into the FDR:** R-66.
- **Rationale:** `docs/SRS.md` § 3.4 FR-12 says "changed files" and `docs/SDD.md` § 3 (entity GitState) carries "status letters" without enumerating them. The six are Git's own status categories and the set the product's design and verbal language already draw as `A M D R U C`; the FDR may not cite those siblings, so the set is stated with Git as its basis. One consequence worth confirming on its own: an untracked file is a *changed* file here — it is marked in the tree and listed in the Git view — and an ignored file is not.
- **If overridden:** dropping untracked files from "changed" narrows R-35 and R-66 and the example rows; adding a category (copied, type-changed) widens R-66 and asks the design and verbal language for a letter and a word.
- **Confirm or override:** confirm — R-66 stands, with the mapping named for what Git can also report: a type change (a file becoming a link, or the reverse) is modified; a copy is added; an ignored file is listed in the tree (R-29) and is neither marked nor listed in the Git view. Untracked is changed, as drafted. Reasoning: `docs/trail/fdr/self_answer-1.md` § 2.6.

### 2.7 A linked worktree or submodule whose Git directory lies outside the folder shows a Git-view failure naming the folder to choose
- **Drafted into the FDR:** R-21 — the folder opens, the tree and reading panel work, and the Git view presents a failure state naming the folder that would need to be chosen for Git state to be read.
- **Rationale:** `docs/SRS.md` § 3.1 FR-33 makes both a repository root, and `docs/SDD.md` § 11 R-3 records that the grant to the chosen folder does not cover a Git directory outside it, with this presentation as the response and the case "recorded as a known limit beside the install path". A limit a stranger meets is behaviour, so the FDR states it — from § 11, which the authoring lens does not name among the SDD sections it draws on (RN-7), and that is the reason it is listed: the source is settled, the altitude is unusual.
- **If overridden:** if the SDD later finds a grant path for the outside case, R-21 is removed by that upstream change; if you want the case to read as a plain folder instead of a Git-view failure, R-21 rewords, R-15 gains an exception, and the SRS's FR-33 needs the CTO's revision.
- **Confirm or override:** override: R-21 keeps the folder opening, the tree and the reading panel working, and the Git view presenting a failure state — and that state names where the Git directory lies as what the product observed, says that this folder's Git state is therefore not read and that the tree and reading work, in R-88's nothing-can-be-done form; it does not present the folder holding the Git directory as the one to choose. Choosing that folder views *that* folder (PD-4) — the main worktree instead of the linked one, the superproject instead of the submodule — never this folder with its Git state, so the route the draft named leads somewhere else. The example row's expected behaviour changes to match, and `docs/SDD.md` § 11 R-3's response wording is the source departed from, recorded in a review note the way RN-1 records a departure. Reasoning: `docs/trail/fdr/self_answer-1.md` § 2.7.

### 2.8 An image whose reference escapes the folder takes the not-fetched placeholder, never the image
- **Drafted into the FDR:** R-59.
- **Rationale:** `docs/SDD.md` § 4 C-D3 has the product answer nothing for a path outside the folder (symbolic links followed), and the SDD's CDO seat drew that nothing as the same placeholder a remote image takes, naming it a reading the UXD's own run outranks (`docs/SDD.md` § SDD Review Notes RN-26). Two seats hedged it, and what the reader sees where an image would be is product-visible, so it is yours.
- **If overridden:** drawing the escaping image differently from a remote one — a distinct statement, or an empty box — rewords R-59 and the example row, and asks the UXD's UX-I12 and the verbal language for the new state; nothing about R-56 – R-58 moves.
- **Confirm or override:** confirm — R-59 stands. One adjacent hole closes with it: an image reference that resolves inside the folder but whose file is missing, unreadable, or not an image the platform renders takes a placeholder stating what the product observed, never a broken-image glyph — the same placeholder shape with a different sentence, because "not fetched" would be false of a file inside the folder. The sentence is `docs/CONTENT.md`'s; the state is raised with the UXD's others on `docs/UXD_open_issues.md` § 2.1. Reasoning: `docs/trail/fdr/self_answer-1.md` § 2.8.

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
- **Confirm or override:** confirm, with one word added: the discard is silent. A version that meets own state it cannot read discards it whole and opens as on first run — the Open panel, the platform's theme (R-106) — and says nothing about it in the window; the release that changed the state's shape is where it is said (R-142 before 1.0.0, PD-20's announcement after). The rule lands beside R-108 – R-110 as proposed, and it covers two instances of different versions sharing one own state: each launch reads or discards whole. Reasoning: `docs/trail/fdr/self_answer-1.md` § 2.9.

### 2.10 RN-14, RN-15 and RN-18 carry version numbers and states that are now false, and SRS v9's NFR-11 bound has not been read against R-93

> **This item was raised by a `companion-self-answer` run answering this companion, not by a
> `product-fdr` run.** It came from reading `docs/fdr.md` whole against the documents it cites,
> whose status lines have all moved since v1 was authored
> (`docs/trail/fdr/self_answer-1.md` § Raised on this document).

- **Drafted into the FDR:** RN-18 reads *"`docs/PRD.md` is Settled at v11, `docs/SRS.md` Settled
  at v8, `docs/SDD.md` Settled at v2, and no companion sits beside any of them"*; RN-14 reads the
  UXD at v6, DESIGN at v5 and CONTENT at v4; RN-15 records the Agari's `agari_trail/` locators as
  stale and *"not corrected here"*; R-93 carries NFR-11 as *"any diagnostic the product keeps lives
  with its own state on the machine — never inside the viewed folder, never transmitted, and never
  holding file content"*.
- **Rationale:** measured 2026-09-01 — PRD v12, SRS v10, SDD v3, UXD v7, DESIGN v6, CONTENT v6;
  `docs/architecture_open_issues.md` sits beside the NFDR and this run opened companions beside
  the SRS, the UXD and DESIGN (`docs/trail/fdr/self_answer-1.md` § Companions opened); the
  Agari's two pointers now read `trail/agari/` (`system/projects/ka-reader/agari.md:16`, `:35`). Most
  of those moves repaired citations and change no rule here. One did not: SRS v9's NFR-11 gained
  the diagnostic log's bound — *"the log holds at most the current session's lines: a launch
  creates the file where none exists and truncates it where one does, so nothing from an earlier
  session survives a launch. Within a session the log is bounded to 1 MiB ... past which it is
  emptied and writing continues ... A failure to write the log is not a failure the user must know
  about: it surfaces nowhere"* (`docs/SRS.md` § 4.5 NFR-11; inspected by AC-13) — and R-93, which
  traces to NFR-11, has not seen it. The log is the one thing in the product's own state a person
  might open, and what of it survives a launch is behaviour of R-108's kind, so the bound is
  proposed as R-93's addition: one session's lines, at most 1 MiB, nothing from an earlier session
  surviving a launch, and a failed log write surfacing nowhere. `docs/nfdr.md` QC-40 carries the
  check.
- **If overridden:** leaving the bound to the NFDR keeps R-93 as it is and the FDR silent on what
  a person finds in the log. Either way RN-14, RN-15 and RN-18 read the current versions and
  states, or are dropped where they no longer record anything.
- **Confirm or override:**
