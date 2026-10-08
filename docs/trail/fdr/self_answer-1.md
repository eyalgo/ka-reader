# Self-answer report — fdr.md

## Header

- **Companion:** /Users/eyalgolan/products/ka-reader/docs/fdr_open_issues.md
- **Document:** `docs/fdr.md` — the FDR, Draft at v1
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-01

Read whole before any item was decided: the companion; `docs/fdr.md`; and, as the items name
them, `docs/PRD.md` (v12) § Goals, § Core Features, § UX Notes, § Out of Scope, § Assumptions,
§ Data & Privacy; `docs/SRS.md` (v10) FR-1 – FR-3, FR-5, FR-10, FR-12, FR-13, FR-17 – FR-21,
FR-26, FR-33, FR-34, NFR-1 – NFR-4, NFR-10, NFR-11, DR-1 – DR-6, AC-6, AC-12, AC-13, AC-18,
RN-4, RN-14; `docs/SDD.md` (v3) § 3 parts and entities, § 4 C-R3, C-D3, C-D4, C-E1, C-E2, C-I4,
S-6, S-8, § 11 R-3, RN-16, RN-20, RN-26, § Open Questions; `docs/nfdr.md` QC-59, QC-60, RN-2;
`docs/architecture_open_issues.md` § 2.2, § 2.8; `docs/trail/architecture/self_answer-1.md`
§ 2.2; `docs/trail/sdd/cycle-1.md` § 1.2. The siblings the FDR may read and not cite —
`docs/UXD.md` (v7), `docs/DESIGN.md` (v6), `docs/CONTENT.md` (v6) — were read for collision on
every item that touches a surface.

## Items worked

### 1.1 — What happens when the Open panel is cancelled at launch, before any folder is chosen

- **Bucket:** 1. Open issues — behavioural questions with no answer yet
- **Verdict:** answered
- **Why:** The startup surface, with its two routes and no failure sentence; the product never
  quits on its own and never re-presents the panel unasked. The item carried a lean, so it was
  weighed as a draft: it holds, but not for the reason it gives — R-86 forbids a dead end in a
  *failure state*, and a cancel is not one, so R-86 does not reach it. What does: R-88 and R-89
  forbid a sentence naming a cause the product did not observe, so the surface carries no failure
  text; PD-31 is one window and no second surface, and R-8's surface already exists with exactly
  the two routes a cancelled person needs; and R-134's five-minute clock is what a silent quit
  costs — a stranger who presses Escape on first launch watches the product vanish and goes
  looking for it. Re-presenting the panel unasked is a prompt loop, which UX-I7 (nothing asked of
  the reader) and CONTENT's *"KA-Reader asks the reader nothing"* rule out. Check 4: cancelling
  again from the surface returns to the same surface, stated; beyond v1 the panel R-5 presents for
  want of a remembered folder is cancelled the same way, with the selector as the route, which is
  the route C-R3 already gives UX-S4 beyond v1. Consequence: UX-S4's *Empty* cell reads *"n/a —
  the surface exists only in failure"* (`docs/UXD.md` § 6), so the UXD is owed a cell; raised on
  `docs/UXD_open_issues.md` § 2.1 rather than absorbed. Close call: a silent quit, which macOS
  single-window utilities do; what tipped it is the first-launch cost.

### 1.2 — What the remembered-folders list holds, how long, and what the reader can do to it

- **Bucket:** 1. Open issues — behavioural questions with no answer yet
- **Verdict:** answered
- **Why:** Ten folders, most recently viewed first, the current one marked, aging out by recency,
  stale entries kept until they age out, no removal control. Four questions hid in one item and
  each is answered. *Count:* bounded, because an unbounded list either needs a removal control or
  grows a menu nobody can scan — and a menu that needs scanning is a search, which OOS-5 places
  outside done; ten is the number a glance holds, and a limit here is a choice, not a
  measurement, so it is not the CTO's RN-4 process. *Order:* recency, because the list exists to
  go back to what was just being watched; by name would seat a folder from a year ago beside
  today's. *Stale entries:* kept, because R-126 already binds what choosing a gone folder shows
  (the example row exercises it) and dropping entries the moment they fail to resolve would make
  a folder on an unmounted volume flicker in and out of the list; R-5's launch check is the one
  place the product looks unasked, and that is already a rule. *Removal:* none — a control on a
  menu row is a treatment `docs/DESIGN.md` § Components "The menu" does not draw and no glyph in
  its fourteen exists for it, and aging-out does the work: what the reader stops opening leaves.
  R-110 holds as written. Consequence: `docs/DESIGN.md:565` *"lists remembered repositories by
  name"* is read as *shows each by its display name*, and the DESIGN companion asks the CDO to say
  which (`docs/DESIGN_open_issues.md` § 2.1); the order and bound land in UX-S7 through the UXD's
  item.

### 1.3 — What the reader sees and can do at the end of the history's loaded window

- **Bucket:** 1. Open issues — behavioural questions with no answer yet
- **Verdict:** answered
- **Why:** A stated end, no load-more, every chosen tip drawn. The rule the answer rests on is
  R-81 — *"stale content is never presented as current"* — read for history: a graph that stops
  silently presents a partial history as whole, which is the lie R-81 exists to forbid, so the end
  is stated where older commits exist and nothing is said where the whole history fits (nothing to
  say). Load-more adds a control and a second read that UX-S6 does not draw and that R-120's
  bounded window was chosen against; not built, and revisable through the UXD if ever wanted. The
  window is read as the most recent commits *of the chosen set* — the reading under which
  choosing `old` in the FDR's own example row draws it at all; RN-16's *"merge-base with HEAD lies
  inside the loaded window"* only makes sense if the window follows the set — so a chosen
  branch's tip is always inside, and what can fall past the end is its join, which is exactly the
  branch R-117 keeps out of the default set. Check 4: no commits — stated (S-8's bar); fewer than
  the window — no end statement; history unreadable — UX-S6's failure cell; new commits arriving
  — R-74's live refresh, unchanged. Consequence: UX-S6's success cell has no stated-end element;
  raised on `docs/UXD_open_issues.md` § 2.1.

### 1.4 — What the "short repository status" contains, and what the branch element shows on a detached HEAD

- **Bucket:** 1. Open issues — behavioural questions with no answer yet
- **Verdict:** answered
- **Why:** The short status is the repository's condition — the non-normal state in Git's word,
  or the clean statement — and nothing about a remote; the branch element shows the commit's
  identifier where HEAD is on no branch. Three facts fix it. The SDD's GitState holds *repository
  state* and *short status* as separate fields (`docs/SDD.md` § 3 entities), so the status is where
  the state is *said*; R-68 already gives the clean statement (*"Nothing has changed in this
  repository."* is CONTENT's wording for it); and `docs/DESIGN.md` § Components "Status letters"
  draws counts after the *Changes* / *Staged* headers, so a count in the status would be a second
  copy of one number. OOS-24 settles the remote half. Check 4: a merge with changed files — the
  status says merge, the lists carry the files; a clean tree on a detached HEAD — status says
  detached, and the branch element carries the identifier the history shows (R-118). One case is
  named uncovered rather than drafted: during a rebase Git's HEAD is detached and the branch being
  rebased is known to Git but not shown by this rule — the identifier and the word *rebase* are
  what the reader gets. VS Code names the rebased branch; if the owner wants that, it is one
  sentence on the fold. The wording is CONTENT's (its UX-S3 mid-operation row already routes it
  to *Voice*), so nothing is raised there.

### 1.5 — What the reader sees for a file too large to display with no perceived wait

- **Bucket:** 1. Open issues — behavioural questions with no answer yet
- **Verdict:** answered
- **Why:** The whole file, pending shown meanwhile, no truncation and no size-based refusal.
  DR-6 requires tolerating *"arbitrarily large files"* and FR-29's *"never refused"* and CONTENT's
  banned list (*unsupported*, *refused*) rule out a cannot-display-for-size state; a truncated view
  needs a number nobody has yet, and R-84 already says the bars hold *inside* reference sizes the
  CTO fixes — outside them R-50 is not a promise, which is what makes the wait honest. The pending
  state already exists (UX-S1's loading cell: *"shows that it is being read, without a progress
  claim"*; C-E1's word), so no new treatment. Check 4: a ceiling the product genuinely cannot show
  past — named as the CTO's number, with the statement it produces being R-51's observed
  condition naming the ceiling, not R-91's fault; the open file changing mid-read — R-79 in
  place; the file replaced by one of another kind — R-46/R-47 apply on the next read. Close call:
  truncation, which is what the driving scenario (an agent appending to a large log) might want
  for refresh cost; that is R-84's measurement to make, not this rule's.

### 2.1 — Where the diff exists, a changed file's row in the Git view opens the diff, and the file is read from the tree

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** Confirmed: the owner decided this by demonstration (`docs/trail/sdd/cycle-1.md`
  § 1.2), the SDD carries it (RN-20, S-7), and the FDR's R-69/R-70 follow the later authorized
  value with RN-1 recording the departure — the draft is sound and for the reason it gives. What
  the draft left undone is the part it said was not its to do: *"the SRS's FR-13 and the UXD's
  UX-F2 want the CTO's and the CDO's revision through their own skills; confirming here does not
  make it."* Nothing had raised either; the SRS closed its companion at v10 saying *"no
  requirement moves"* and the UXD went through v6 and v7 with UX-F2 untouched. The addition is
  that both are now raised where their seats act — `docs/SRS_open_issues.md` § 2.1 (FR-13 and
  AC-6 gain the until-the-diff-exists condition) and `docs/UXD_open_issues.md` § 2.1 — plus the
  three row cases check 4 reached for the example row: staged-and-modified opens the diff of the
  list clicked (R-112), untracked opens the whole file as added, conflicted opens the unstaged
  diff as Git left it.

### 2.2 — The history's default branch set, and that only local branches are offered

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** Confirmed: the merge-base reading is RN-16's, invited for challenge, and it survives
  the cases that would break it — a branch ahead of HEAD (merge-base is HEAD, inside), a branch
  HEAD is behind (merge-base is an ancestor, inside if recent), a branch that diverged long ago
  (out, and choosable, as the example row shows). Local-only follows from OOS-24 and costs no
  network either way. Two additions from check 4: a detached HEAD has no *"branch HEAD is on"*, so
  the default is HEAD's commit plus the local branches whose merge-base with it is inside the
  window; an empty repository has no set and states so (S-8's bar). Tags are not branches and are
  not offered — said so nobody adds them as a seventh kind of ref.

### 2.3 — The tree shows every entry, `.git` and dot-entries included; folders first, ordered by name; sub-folders collapsed at arrival

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** Confirmed, with the argument repaired. The conclusion — show everything — is right:
  `docs/PRD.md` § Goals *"browse and read anything in the folder"* and PD-2's flat reading admit no
  exclusion, `.git` collapsed at arrival costs one row, and a read of it changes nothing (R-95).
  The argument is not: OOS-21 cites `docs/SRS.md` § SRS Review Notes RN-14 for *"nothing hidden
  from the tree"*, and RN-14 says that of FR-10's *unrenderable files* — a binary is still listed
  — not of dot-entries or `.git`. The citation does not say what it is said to say, so the fold
  cites the PRD and PD-2 instead. Ordering and arrival expansion are the editor convention the
  familiarity thesis bets on; confirmed. Check 4 named two ties the rule leaves: names equal
  without regard to case keep byte order, and digits are characters (`file10` before `file2`) —
  plain order, chosen over numeric-aware sorting because it is the one rule a reader can predict
  without knowing the product. Close call on `.git`: VS Code hides it by default, and a reader
  watching an agent gains nothing from it; what tipped it is that hiding one entry is the first
  exclusion rule, and the product's edge is having none.

### 2.4 — A file is text when its bytes decode as UTF-8; otherwise it cannot be shown as text

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** Confirmed: UTF-8-only keeps *"never a garbled render"* (PRD § UX Notes) cheap, because
  a guessed encoding shown as text is that garbled render. The addition is the one case the draft
  refuses without needing to guess: UTF-16 with a byte-order mark says what it is, and a file the
  product can decode without guessing and refuses anyway is the refusal CONTENT's banned list and
  FR-29 are written against. Latin-1 stays out — every byte sequence decodes as Latin-1, so it
  is always a guess. Check 4: a torn read of a multibyte sequence mid-write flips to
  cannot-be-shown and back — R-77 and R-83 already cover it and it is named so nobody softens the
  rule for it; an empty file is text; a valid-UTF-8 file with a binary extension is text, which
  R-43 (extension never decides content) already implies.

### 2.5 — A symbolic link inside the folder is read as its target; one pointing outside is an entry that cannot be read

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** Confirmed: C-D1's containment check fixes the outside case and OOS-21 fixes that it is
  still shown. Check 4 found the inside rule unbounded on folders: a link to a folder *inside* the
  viewed folder, read as its target, expands — and a link to its own ancestor expands forever. The
  addition names the cycle and the dangling link as R-33's entry that cannot be read, marked with
  what was observed, which adds no treatment: R-33's state carries both, and the tree beside it
  stands. A link to a folder that is not a cycle is shown as a folder, said so the folder case
  is not read as excluded.

### 2.6 — The Git view and the tree report six change categories — added, modified, deleted, renamed, untracked, in conflict

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** Confirmed: the six are what `docs/DESIGN.md` § Components "Status letters" draws as
  `A U M D C R`, and untracked-is-changed matches the design's own grouping of `U` with `A`. The
  addition is the mapping for what Git reports that the six do not name — a type change is
  modified, a copy is added — and that an ignored file is listed (R-29) and unmarked, so a builder
  meets no eighth state. The words for the letters stay CONTENT's.

### 2.7 — A linked worktree or submodule whose Git directory lies outside the folder shows a Git-view failure naming the folder to choose

- **Bucket:** 2. Choices to confirm
- **Verdict:** overridden
- **Why:** The draft: the Git view's failure state *"naming the folder that would need to be
  chosen for Git state to be read"*. Replaced by: the state names where the Git directory lies as
  what was observed, says this folder's Git state is not read and the tree and reading work — R-88's
  *"or that nothing can be done"* form — and offers no folder to choose. Check 4 broke the draft
  on its own route: choosing the folder it names views *that* folder (PD-4, one folder at a
  time) — the main worktree instead of the linked worktree the reader chose, the superproject
  instead of the submodule, where the submodule is one modified entry — and never this folder
  with its Git state. A next step that leads somewhere else is the dead end R-86 is written
  against, wearing a route's clothes. The rest of R-21 stands: the folder opens, the tree and the
  reading panel work, the Git view carries the failure. The source departed from is
  `docs/SDD.md` § 11 R-3's response, *"naming the folder that would need granting"* — a sentence in a
  risk record, at the design altitude; the FDR records the departure in a review note as RN-1
  does, and the SDD's next revision meets it there. Not worth a three-seat SDD run on its own,
  and said so here rather than opened.

### 2.8 — An image whose reference escapes the folder takes the not-fetched placeholder, never the image

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** Confirmed: C-D3 answers nothing for the escaping path, the placeholder is the one
  shape an unloaded image has, and CONTENT's sentence for it — *"This image isn't loaded: KA-Reader
  fetches nothing from outside this folder."* — is true of a remote and of an escaping reference
  alike. Check 4 found the hole beside it: a reference that resolves *inside* the folder to a file
  that is missing, unreadable, or not an image is neither R-58's case (loaded) nor R-59's (outside),
  and a builder meets a broken-image glyph — the browser's own — which is a surface the product did
  not draw. The addition: the same placeholder, stating what was observed, because *"not fetched"*
  would be false of a file inside the folder. The sentence is CONTENT's; the state rides the UXD's
  item (`docs/UXD_open_issues.md` § 2.1).

### 2.9 — What a later version does with an earlier version's own state — kept, or discarded whole, never a startup failure

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** Confirmed: the rule was reached by the architecture self-answer through the same four
  checks (`docs/trail/architecture/self_answer-1.md` § 2.2), and re-running them here found the
  same result — symmetric because a rule about *a later version* cannot bind an older one that has
  shipped; never a startup failure because R-7's list is closed; whole because a half-read state is
  one nobody can reason about; not the owner's, because *discard after 1.0.0 is breaking* derives
  from PD-20, which they decided. The addition is the word the draft left implicit and 1.1 made
  load-bearing: the discard is *silent* in the window — CONTENT's *"Starting it: silence, unless
  something failed"*, and nothing failed — with the release notes as the place it is said (R-142,
  PD-20). Check 4's concurrent case is named: two instances of different versions sharing one own
  state each read or discard whole at their own launch, the same rule twice.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.10 — RN-14, RN-15 and RN-18 carry version numbers and states that are now false, and SRS v9's NFR-11 bound has not been read against R-93

- **What the document is owed:** its three sibling-and-input review notes brought to the current
  versions and states, and R-93 read against the diagnostic-log bound the SRS gained at v9.
- **Why it is worth a cycle:** `decide_companion_answers.md` § The items are not the whole of what
  a document is owed — *"a fact in it is now false"* and *"something upstream moved and it has not
  seen it"*. Measured 2026-09-01: RN-18 says PRD v11 / SRS v8 / SDD v2 and no companion beside any;
  the status lines read PRD v12, SRS v10, SDD v3, and after this run companions sit beside the SRS,
  the UXD and DESIGN. RN-14 says UXD v6 / DESIGN v5 / CONTENT v4; they are v7 / v6 / v6. RN-15
  records the Agari's `agari_trail/` locators as stale; `system/projects/ka-reader/agari.md:16` and
  `:35` now read `trail/agari/`. And `docs/SRS.md` § 4.5 NFR-11 at v9 gained a bound — one
  session's lines, at most 1 MiB, truncated at launch, a failed write surfacing nowhere — that R-93
  (traces to NFR-11) has not seen. It costs no extra cycle: it rides the fold this companion
  already owes. Appended as one item in choices to confirm, slot at its placeholder, with its
  provenance blockquote.

## Companions opened

- **/Users/eyalgolan/products/ka-reader/docs/UXD_open_issues.md** — **opened** — companion to `UXD.md`,
  landed in commit `c7589e3`
- **/Users/eyalgolan/products/ka-reader/docs/SRS_open_issues.md** — **opened** — companion to `SRS.md`,
  landed in commit `dde4493`
- **/Users/eyalgolan/products/ka-reader/docs/DESIGN_open_issues.md** — **opened** — companion to `DESIGN.md`,
  landed in commit `4a3308c`

The UXD's is both kinds of entry at once: item 2.1 routed its UX-F2 half there, and reading the
UXD against the SDD found UX-F2 and UX-S6 still carrying text the owner overrode two rounds ago
(`docs/SDD.md` RN-20 says so of v6; its v3 line says so of v7), with the four states this run's
answers add riding the same item. The SRS's is item 2.1's routed half — FR-13 and AC-6 at the
closing release. DESIGN's is the second kind alone: the FDR's RN-14 records the stale
*repository selector* wording as the CDO's to revise, `docs/DESIGN.md:322`, `:490`, `:552`, `:565`
still carry it at v6, and nothing had raised it. Each was committed and its stat checked before
the slot pointing at it was written. Nothing was opened on CONTENT or the SDD: CONTENT's
sentences follow the UXD's revision, and the SDD's one departed-from clause (2.7) is a risk
record's response, recorded rather than reopened.

## Launchers owed

- **`fdr.md`** — `<CORE>/launchers/product-fdr/launcher.sh ka-reader`
- **`UXD.md`** — `<CORE>/launchers/product-uxd/launcher.sh ka-reader`
- **`SRS.md`** — `<CORE>/launchers/product-srs/launcher.sh ka-reader`
- **`DESIGN.md`** — `<CORE>/launchers/product-design/launcher.sh ka-reader`
