# SDD — nozoki

**Status:** Settled
<!-- Draft = open issues or choices to confirm remain (open-issues file present).
     Settled = nothing left for the owner to answer and no open technical question — the done
       signal, and the state a finished SDD carries; the open-issues file is gone.
     Locked = ratified as the source of truth. -->
**Owner:** CTO · CPO · CDO — one run, three seats
**Version:** 38 — CTO, one run, with the one answered companion item folded: § 3, the `surfaces` row (the reading clause names the window's key status beside the pointer: it is the shell's own observation of the window and no state of the folder, the hover fill and the tooltip are drawn from the two together, the same bounds hold it, and the row's one exception stays one); § 6 `open-a-folder` *Reached when*, observable half (the hover sentence stated for the key window, and one sentence for a window that is not — the CDO's clause, settled by `docs/DESIGN.md` § *Components*, "Rows") and command half (the second reading clause names the window, and three `swift test` cases added, seven in place of four); § 6 `see-git-status` *Reached when*, observable half (the same, and one sentence on the tooltip — settled by § *Components*, "The tooltip") and command half (four `swift test` cases added, eleven in place of seven); SDD Review Notes RN-98 (new); trail copy at `docs/trail/sdd/cycle-33.md`; `docs/SDD_open_issues.md` removed, empty of items, and `Status:` stays Settled. No *Delivers*, no *Rests on*, no slice added, no § 10 entry, no § 7 edge, no slice order, no part's *Must not own* and no seam altered. Companion items added: none.
Version 37 — CTO, one run, with the one answered companion item folded: § 6 `see-git-status` *Reached when*, observable half (the clicked Git-view file row is drawn selected, with the selection fill and the left bar — the CDO's clause, settled by `docs/DESIGN.md` § *Components*, "Rows") and command half (one `swift test` case added, seven in place of six: after a click, with the pointer over no row, the clicked row shows the selection fill and the bar and no other row shows either), and *Rests on* (`surfaces` gains the Git view's selected row's fill); SDD Review Notes RN-97 (new); trail copy at `docs/trail/sdd/cycle-32.md`; `docs/SDD_open_issues.md` removed, empty of items, and `Status:` stays Settled. No *Delivers*, no slice added, no § 10 entry, no § 7 edge, no slice order, no part and no seam altered. Companion items added: none.
Version 36 — CTO, one run, with the one answered companion item folded: § 3, the `surfaces` row (one reading clause: what the pointer is over is the shell's own observation of the pointer and no state of the folder, the row's hover fill and the status letter's tooltip are drawn from it, and the row's one exception stays one); § 6 `open-a-folder` *Reached when*, observable half (the tree row's hover fill — the CDO's clause, settled by `docs/DESIGN.md` § *Components*, "Rows") and command half (four `swift test` cases, and the "from a projection" clause read with the new § 3 clause), and *Rests on* (`surfaces` gains the fill); § 6 `see-git-status` *Reached when*, observable half (the Git view's file row's hover fill, with the tooltip over it) and command half (six `swift test` cases), and *Rests on* (`surfaces` gains the fill); SDD Review Notes RN-96 (new); trail copy at `docs/trail/sdd/cycle-31.md`; `docs/SDD_open_issues.md` removed, empty of items, and `Status:` stays Settled. No *Delivers*, no slice added, no § 10 entry, no § 7 edge, no slice order, no part and no seam altered. Companion items added: none.
Version 35 — CTO, one run, with the two answered companion items folded: § 3 *What the system holds*, `GitState` (one sentence: the tree's marker join is in the shell and on `main` from `nozoki@67d103d`, under the `surfaces` row's four bounds; nothing else in § 3 moved); § 4 C-E8 (one sentence and two *Violated by* cases: a status letter's expansion is raised by the letter and by nothing else — the CDO's clause, settled by `docs/DESIGN.md` and `docs/CONTENT.md`); § 6 `see-git-status` *Delivers* (the pointer resting on a status letter shows the row's name and the letter's meaning — the CPO's field, settled by the owner's v1 decision), *Reached when*, observable half (the tooltip in the tree and in the Git view) and command half (a `swift test` case over the six status categories), and *Rests on* (`surfaces` gains the tooltip); § 6 `follow-the-folder` *Reached when*, observable half (the tooltip leaves when a refresh changes the row's state); SDD Review Notes RN-95 (new); trail copy at `docs/trail/sdd/cycle-30.md`; `docs/SDD_open_issues.md` removed, empty of items, and `Status:` stays Settled. No § 10 entry, no § 7 edge, no slice order, no part and no seam altered. Companion items added: none.
Version 34 — CTO: § 3, the `surfaces` row (one bounded clause: for `see-git-status` alone the tree's marker join and the Git lists' row order stand in `surfaces`, under four bounds, ending when `follow-the-folder` is reached; the row's one exception stays one); § 3 *What the system holds*, `GitState` (`folder-model` owns the lists' row order, with one implementation in the core; where the order and the marker join are computed meanwhile); § 6 `see-git-status` *Rests on* (the tree's markers and the lists' row order move from `folder-model` to `surfaces` for that slice); § 6 `follow-the-folder` *Rests on* (the debt) and *Reached when*, command half (a model case, and a `grep` that is red while either file remains in the shell); § 10 RC-5 (new, the CTO's ground); SDD Review Notes RN-94 (new); the two answered companion items folded, trail copy at `docs/trail/sdd/cycle-29.md`; `docs/SDD_open_issues.md` removed, empty of items, and `Status:` stays Settled. No slice's *Delivers*, observable half, edge or order altered. Companion items added: none.
Version 33 — CTO: § 4 C-I3 (the transport-read sentences: the claim is proved for each executable the read has met, which is two; the second links the `nozoki_read_git` export, from `nozoki@129586e`, and passed; where the read ran, and that no hosted runner has read that build); § 4 C-R6 (the three defined symbols the pattern does not match are pinned to the second executable); § 11 R-15 (the false sentence replaced by the measurement; the risk kept, with the three changes that make it real; *shows up as* is a red read on any release build; *response* holds the change whose build turns the read red until the re-cut is recorded); SDD Review Notes RN-93 (new); the two answered companion items folded, trail copy at `docs/trail/sdd/cycle-28.md`; `docs/SDD_open_issues.md` removed, empty of items, and `Status:` stays Settled. No slice's *Delivers*, *Reached when*, edge or order altered. Companion items added: none.
Version 32 — CTO: *Open Questions* (the config-named-path item's bound is "before the slice is reached" alone: the clause naming the build in which `mac-shell` first calls `nozoki_read_git` is removed, the review that holds the bound is the one of the change after which `see-git-status`'s *Reached when* is claimed whole, what a reader can meet in the builds between is stated, and a second dated note follows the first — eight stand); § 11 R-16 (the same bound, and the same builds between); § 10 RC-4 *Still unresolved* (a second dated parenthesis, the first one's words kept); SDD Review Notes RN-92 (new); the one answered companion item folded, trail copy at `docs/trail/sdd/cycle-27.md`; `docs/SDD_open_issues.md` removed, empty of items, and `Status:` stays Settled. No slice's *Delivers*, *Reached when*, edge or order altered. Companion items added: none.
Version 31 — CTO: § 3 *What the system holds*, `GitState` (the model holds `HeadState` and `StatusLists` from one read; what a failed half does; what is still only the design); § 4 C-R6 (the bridge manifest's `git2` line as landed; three defined symbols named beside "The three names are a floor"); § 4 C-I3 (the core suites and the walk run with the machine-level reads on and nothing isolates them; the `nm` transport read as landed, with the one executable it is proved for; the switch and its test as landed); § 10 RC-4 *Still unresolved* (a dated parenthesis, its words kept); § 11 R-15 (the measurement, and *shows up as* naming the build that links the export) and R-16 (fixture sentence re-pinned, the item named by what it is, its new bound); *Open Questions* (the config-named-path item's bound moves to the build in which `mac-shell` first calls `nozoki_read_git`, with a dated note — eight stand); SDD Review Notes RN-91 (new); the four answered companion items folded, trail copy at `docs/trail/sdd/cycle-26.md`; `docs/SDD_open_issues.md` removed, empty of items, and `Status:` stays Settled. No slice's *Delivers*, *Reached when*, edge or order altered. Companion items added: none.
Version 30 — CTO: § 3 SM-4 (the list gains `read_git`, exported as `nozoki_read_git`, with what it takes and answers; the list is ten, "all ten from `v1.0.0`"); § 6 `see-git-status` *Rests on* ("`SM-4` (`read_git`)" in place of "`SM-4` (`model_changed` carrying Git state)"); § 6 `promise-one-point-zero` *Reached when*, command half ("SM-4's ten functions"); § 10 RC-4 (new, the CTO's ground); *Open Questions* (the collapse-and-scroll item's counts — eight stand); SDD Review Notes RN-90 (new); the one answered companion item folded, trail copy at `docs/trail/sdd/cycle-25.md`; `docs/SDD_open_issues.md` removed, empty of items, and `Status:` stays Settled. § 4 C-R7 and C-I6 keep their words. No slice's *Delivers*, edge or order altered. Companion items added: none.
Version 29 — CTO: § 4 C-I1 (a failed read "changes no other item", in place of "`observed` on its siblings"; each sibling holds the state its own read gave it, all four `Item<T>` states named; one sentence naming the failed re-read of an expanded folder as not decided there); § 6 `follow-the-folder` *Reached when*, command half (the same rule, without "as they were before the read"); SDD Review Notes RN-44 (parenthesis corrected in place) and RN-89 (new); *Open Questions* (one item added — eight stand); the one answered companion item folded, trail copy at `docs/trail/sdd/cycle-24.md`; `docs/SDD_open_issues.md` removed, empty of items, so `Status:` moves from Draft to Settled. No slice's *Delivers*, edge or order altered. Companion items added: none.
Version 28 — CTO: § 3 *What the system holds*, `GitState` (the model defines the type and builds it from what the port returns, from `state` alone at `nozoki@87f6a48`; the hand-off to "the change that adds `state`" removed); § 3 SM-2 (the types `probe`, `state` and `status` answer are defined in `git-reader`; the rule kept for a type a later method brings); § 6 `see-git-status` *Reached when*, command half (the double's reason restated, the tree's items "as they were" in place of "every tree item `observed`", and where the adapter's refusal is exercised); SDD Review Notes RN-44 (corrected in place) and RN-88 (new); four answered companion items folded and dropped, trail copy at `docs/trail/sdd/cycle-23.md`; `docs/SDD_open_issues.md` stays on disk with § 2.1 unanswered, so `Status:` moves from Settled to Draft. No slice's *Delivers*, edge or order altered. Companion items added: none.
Version 27 — CTO: § 3 `core-bridge` row (*Owns*: the config search-path switch — four `set_search_path` calls before the libgit2 adapter is wired, failing closed, once per process, with the uncovered case named); § 3 `git-reader` row (what the reader sees with the machine-level config off: the global ignore file not applied, a repository not owned by the user a `failed` Git item); § 3 the *Four physical units* paragraph and SM-2 (the libgit2 import rule's one exception); § 4 C-R6 (every `git2` manifest line with default features off, and *Violated by*); § 4 C-I3 (the bridge test and what it does not reach, a third thing no check holds, and *Violated by*); § 4 C-D3 (one uncovered case named); § 6 `see-git-status` *Reached when*, command half (the same exception); § 11 R-16 (new); *Open Questions* (second item extended, one item added — seven stand); SDD Review Notes RN-87 (new); `docs/SDD_open_issues.md` removed, empty of items, trail copy at `docs/trail/sdd/cycle-22.md`. No slice's *Delivers*, edge or order altered. Companion items added: none.
Version 26 — CTO: § 3 `git-reader` row (libgit2 "built with its `https` and `ssh` features off"); § 3 `read-only-harness` row (*Owns* cell re-measured and re-pinned at `nozoki@814a369`: the four root-finding scenes and their archives move to on-disk, nine fixture folders, `see-git-status` leaves the slice-owed list); § 3 SM-2 (the trait and the types that cross are defined in `git-reader`, `folder-model` keeps the contract) and *What the system holds*, `GitState` (one sentence); § 4 C-R5 (one garbled sentence repaired); § 4 C-R6 (the transport claim restated at the shipped executable, with its evidence, its bounds and *Violated by*); § 4 C-I3 (the `nm` read named, and *Violated by*); § 11 R-15 (new); SDD Review Notes RN-85 and RN-86 (new); `docs/SDD_open_issues.md` removed, empty of items, trail copy at `docs/trail/sdd/cycle-21.md`. No slice altered. Companion items added: none.
Version 25 — CPO: nothing — no SDD section, slice or companion item altered by this seat.; CTO: § 3 `read-only-harness` row (*Owns* cell: pinned enumeration at `nozoki@7a125b4`, on-disk/slice-owed split, `entry-points.sh`+`entry-points.allow`, `walk.rs`, `sandbox_probe.rs`, `deps.review.md`, `tests/`, `repo.git.tar`, `highlight`, `text`, `history`, `scale-*`, `hostile.md`); SDD Review Notes RN-84 (new); `docs/SDD_open_issues.md` removed, empty of items. No slices altered. Companion items added: none.; CPO: nothing — no SDD section, slice or companion item altered by this seat.
Version 18 — CPO: nothing — no SDD section, slice or companion item altered by this seat.; CTO: § 4 C-I3 (observable, measured-frames sentence, hosted-runner sentence with the re-cut rule); § 6 `open-a-folder` *Reached when* command half; § 9 TO-7 *costs*; § 10 RC-2 and RC-3 *Still unresolved* (dated parentheses); *Open Questions* (seventh item removed — six remain); SDD Review Notes RN-70 (new); `docs/SDD_open_issues.md` removed, empty of items. Companion items added: none.; CPO: nothing — no SDD section, slice or companion item altered by this seat.
Version 8 — CTO: § 4 C-I3 (bounded window, first-ask-all-three pass, script-fixed and printed bound with no number here, per-ask live-pid check, uncovered yes→no case, control `no` for the whole window, error-on-any-ask, denial-as-proof clause narrowed to where the control reports the denials allowed with the hosted runner's read denial stated as separating nothing, Violated by extended); § 10 RC-1 Still unresolved (pointer to RN-48); § 11 R-8 shows up as and response; Open Questions (fourth item closed and removed — four remain); SDD Review Notes RN-48 (new). Companion items added: none. docs/SDD_open_issues.md removed, empty of items.
Version 7 — CTO: § 3 SM-4 (what crosses, and owner cell wording); § 4 C-R7 (the staged grant, set equality against registered commands, asset-scheme keying, named pre-1.0.0 uncovered case, Violated by); § 4 C-I3 (every command the build grants); § 6 S-7 Reached when, command half; SDD Review Notes RN-47 (new). Companion items added: none. docs/SDD_open_issues.md removed, empty of items.
Version 6 — CTO: § 4 C-I3 (observable and Violated by); § 6 open-a-folder Reached when, command half; § 10 RC-1 (new, first re-cut entry); § 11 R-8 shows up as; Open Questions fourth item (closed, replaced by the hosted-runner question); SDD Review Notes RN-45 (new). Companion items added: none. docs/SDD_open_issues.md removed, empty of items.; CPO: § 5 step 4 (E-1's sizing sentence); SDD Review Notes RN-46 (new). Companion items added: none.
Version 5 — run 5 (`docs/trail/sdd/run-5.md`): all three seats declared `no_followup` with no
recall outstanding, and `docs/SDD_open_issues.md` no longer stands on disk, so this document is
stamped Settled. The run consumed the one companion item standing at intake (§ 5.1, whose Answer
slot had come back filled — "confirm — and it is already done" — since run 4 ended): copied whole
to `docs/trail/sdd/cycle-3.md` before any seat touched it. CTO confirmed the fold it names needed
nothing further, repointed RN-41 and RN-42 from "keeps its Answer slot for the owner" to the
owner's confirm and the item's permanent trail copy, and removed `SDD_open_issues.md` from disk
(empty of items). CDO closed RN-43 with the same provenance: the run-4 C-E4/§ 6 S-4 widening was
this seat's own reading, now confirmed by the owner at the same trail item, re-checked and
unchanged. CPO verified its lane unchanged against the current PRD/Agari and named the `successor
CTO` that opened the close above; no edit. No content sentence changed — only the three review
notes' provenance, and the companion's removal. Version 4 — run 4 (`docs/trail/sdd/run-4.md`): all
three seats declared `no_followup` with no recall outstanding, but `docs/SDD_open_issues.md` still
stood on disk (§ 5.1, opened by a `companion-self-answer` run on the FDR side, Answer slot unfilled
and untouched throughout — the skill's rule leaves an unconsumed companion alone), so that run
stamped this document Draft rather than Settled. Content changes, both folded independently of
that companion: CTO, under the owner's own confirmed FDR-trail answers (`docs/trail/fdr/cycle-1.md`
§§ 2.4, 2.7) — widened § 3 `fs-reader`'s text rule to admit UTF-16 (BOM) alongside UTF-8, updated
§ 6 S-2's fixture set to match, rewrote § 11 R-3's response to state an observed condition with
nothing to do next and no folder offered, added a § 6 S-4 reducer case backing the observable
half's linked-worktree/submodule assertion (RN-41, RN-42, RN-44). CDO — named the terminal form in
§ 4 C-E4 (it did not, as written, carry the shape R-3's rewritten response now takes) and added
§ 6 S-4's observable-half sentence for the same case (RN-43). CPO — verified its lane unchanged
against the current PRD/Agari; no edit. Version 3 —
run 3 (`docs/trail/sdd/run-3.md`): folded the owner's confirm of companion § 2.2
(the 1.0.0 promise's contract) into § 6 S-11 *Delivers* / *Not in this slice* and § 12 *The PRD
boundary* (CPO); added § 3's `contract.sh` row, § 4 C-I6 (a tag-anchored contract-pin check
enforcing the priced set's install-path/floor/surface-presence members, which had no enforcing
command before), § 6 S-11's command half, § 11 R-12, and RN-38 (CTO); repointed § 6 S-11 *Reached
when*'s observable half and added the fourth confirmed exclusion, "nothing the harness prints"
(CDO, RN-40); added the exclusions sentence itself to § 6 S-11 *Delivers*, which the companion's
draft had carried since run 1 but the SDD never stated (CPO, round 2, RN-19); fixed two
found-while-walking defects in place, unrelated to § 2.2 (RN-39, RN-40); repointed every `SDD.md`
citation of the now-resolved companion items to `docs/trail/sdd/cycle-2.md` across all three lanes.
`SDD_open_issues.md` now holds no open item anywhere and is removed — nothing is left for the owner
to answer, so this document is Settled. Version 2 — run 2 (`docs/trail/sdd/run-2.md`): folded
companion § 2.4 into § 6 S-11 *Delivers* (priced set's (d) drops "and read-only", covered instead
by the unconditional set's C-2) and RN-19; repointed every `SDD.md` citation of a companion item
folded since run 1 (§§ 1.1, 2.1, 2.3, 3.1, 5.1, 5.2) from the transient `SDD_open_issues.md` to its
permanent copy at `docs/trail/sdd/cycle-1.md`, across all three lanes. Version 1 — first complete
cut: §§ 1–7, 9, 11, 12 and Review Notes RN-1–RN-37 written across a run interrupted once (API 529,
resumed clean per `docs/trail/sdd/run-1.md`).
**Inputs read:** PRD Settled · SRS Settled · UXD Settled

> The SDD is the technical **how**, and it ends in a **cut**. It states the architecture the rest of
> the system builds against — derived from the PRD (the *what and why*), the SRS (the system-level
> *what*) and the UXD (the experience) — and it then cuts that architecture into an ordered set of
> **slices, each of which delivers something on its own**. A slice is not itself a unit of work:
> the Principal PM draws one and cuts it into **one or more** 根回し Nemawashi seeds. § 8 states how
> a slice's fields land in them; how many seeds, when a slice is drawn, and what a seed's stations
> reach into are all `<CORE>/roles/loaders/principal_pm_global.md`'s.
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

The intent this architecture serves is the PRD's: a reader of folders, files and repositories in
which nothing can be changed — "look, don't touch" (`docs/PRD.md` § Purpose) — for a developer
inspecting a working tree they must not disturb, above all one an automated tool or coding agent
is changing as they watch (`docs/PRD.md` § Target Users, the driving scenario). The edge is that
the guarantee *is* the product: "there is no write path to configure away" (`docs/PRD.md` § Why
This). Every choice below serves the three goals the PRD names — inspection without risk,
pick-it-up adoption, no learning curve (`docs/PRD.md` § Goals) — and is measured by its success
metrics (`docs/PRD.md` § Success Metrics): read-only integrity at zero violations, reckoned at
every release; time-to-first-success at or under five minutes on macOS by the README alone; zero
required configuration; and the two immediacy bars, whose numbers are measured from the first
working build.

The terminus is the project's 上がり Agari (`system/projects/nozoki/agari.md`), and the cut in § 6
is scoped to it and no further. Inside done: the v1 surface — the file tree, reading with
highlighting, Git status, live refresh, against a plain folder as against a repository — plus
diffs, commit history, and switching the viewed folder without restarting, always one folder at a
time. Outside done: sidebar search and filter, pane resizing, keyboard navigation, a second
platform, and a front end for agent workflows or inspection services. Done also means public: MIT,
at version 1.0.0 or later, with the README alone taking a stranger to a viewed file of their own
folder, and the read-only bar at zero violations at the closing release as at every release before
it. A design that reaches for an exclusion — a hosted mode, a programmatic surface, an extension
point, several folders at once — is designing past done, and § 6's *Moves toward* holds every
slice to this line.

The constraints fixed before any shape was chosen are the SRS's; they are named here, not
re-listed:

- **The read-only bar is absolute and survives a crash.** No write under the viewed folder, no Git
  mutation, no telemetry, no network call during operation — zero violations at every release, a
  single one release-blocking (`docs/SRS.md` NFR-4 – NFR-9, C-2). The no-network half is held
  by the operating system, never by the code: no network entitlement is ever granted, whatever
  granting one would buy — the owner's ruling (`docs/trail/sdd/cycle-8.md` § 5.1), which § 4
  C-R2 answers to. The owner's second ruling holds the same line against the one thing it was
  found to cost: no mach-lookup exception under another name either, so the renderer that could
  not start without one leaves the system WKWebView (`docs/trail/sdd/cycle-9.md` § 1.1,
  2026-09-23). That is a constraint § 2's shape is re-chosen against, and this section names it
  as one; which native view, and what the seams become, is § 2's weighing and never this
  section's — redone under that ruling (§ 2; § 10 RC-3). What the folder holds is displayed,
  never executed (NFR-16); the folder is
  live, untrusted input that the system tolerates and never requires anything of (DR-6).
- **Local, macOS, one folder.** No hosted mode (C-1); macOS only, with a version floor this SDD
  fixes (C-11); exactly one folder per run, found to be a repository's root or not and never asked
  (FR-1, FR-33); the folder an input the shell can swap, never a structural singleton (NFR-12).
- **One way in.** Exactly one acquisition-and-start path — not a build from source, at most one
  named prerequisite, the channel this SDD fixes (C-3); nothing to configure (NFR-14); no
  programmatic surface at all (`docs/SRS.md` § 5.2).
- **The experience the UXD binds on every surface.** One window, one shell (`docs/UXD.md` § 4);
  the view never lies and draws no state it has not observed (UX-I4, UX-I13); every asset ships
  with the tool (UX-I15); a failing item degrades itself and never the shell (UX-I10, UX-I16).

The test this section sets for § 2 — what tells two shapes apart — is four questions. Can a
reviewer *show*, not be told, that no write path to the viewed folder exists? Does the shell
follow a folder another process is changing without blocking on it or writing to it? Can the
viewed folder be swapped without rewriting the viewing surface? Does the whole thing install on a
Mac by one path, in five minutes, from the README? A shape that cannot be checked on those four has
not been chosen against this section.

## 2. The shape, and what it was chosen over

**The forces, before any shape has a name.** Each is answered from this product's own documents;
the fact that grounds it is on the line.

1. **Where change arrives.** Every change the documents foresee is a new *read surface* over the
   same two sources: the diff, the history and the folder switch are the PRD's deferred features
   inside the terminus (`docs/SRS.md` § 3.6 FR-17 – FR-19, FR-22); the highlighting floor grows
   only by PRD revision (FR-8); the immediacy numbers are confessed unset and arrive by SRS
   revision (`docs/SRS.md` § 4.1 NFR-1, NFR-2, RN-4). No foreseen change adds a *capability* — a
   write, a socket, a shell — because every one of those is excluded permanently (`docs/SRS.md`
   § 7 C-1, C-2; § 4.3 NFR-7, NFR-8). So the shape must price a new read surface cheap and a new
   capability visibly expensive — a boundary a reviewer reads, not a convention a reviewer trusts.
2. **What the system talks to.** Two local sources, both read-only, both owned by others and both
   stable: the filesystem and — only at a repository's root — Git's on-disk state (`docs/SRS.md`
   § 5.3; FR-33). No API, no external service (§ 5.2, § 5.3). The one edge the design expects to
   *swap* is the Git-reading mechanism — "through an installed Git or a library is the SDD's call"
   (§ 5.3) — so that edge earns a port; the filesystem edge does not.
3. **Judgment against plumbing.** The system is mostly plumbing — read, project, watch — and its
   rules are *negative invariants*: never write, never connect, never execute what was read, and
   hold all three through a crash (`docs/SRS.md` NFR-4 – NFR-8, NFR-16). The positive rules are
   few and small: the root finding (FR-33), path containment for rendered content (FR-32, NFR-16),
   never draw an unobserved state (`docs/UXD.md` UX-I13, UX-I16), keep the reader's place across a
   refresh (FR-27). A negative invariant is not held by a guarded domain core; it is held by
   *withholding a capability* at a boundary something outside the code enforces. Since the
   owner's two rulings that boundary has a name — the process's own entitlements (§ 1) — and a
   shape that needs a second process the operating system will not start under them (a system
   service that checks the host's network entitlement at its own start, § 10 RC-2) is asking the
   wall for what the wall refuses.
4. **What must be replaceable inside the terminus.** Two things, both live: the viewed folder —
   "an input, not a structural singleton", and the switch is inside done (`docs/SRS.md` NFR-12,
   FR-19; `system/projects/nozoki/agari.md`, first condition) — and the Git mechanism (force 2).
   Nothing else will be swapped before done: not the platform (C-11), and not the view technology
   *again* — it moved once, before any release, when the system WKWebView was found unable to
   start under the wall (§ 10 RC-2, RC-3; `docs/trail/sdd/cycle-9.md` § 1.1). That reversal was
   priced "expensive" in this section's first draft and was paid at the cheapest moment it could
   be: one slice scaffolded, nothing shipped. A seam for a second swap would be cost with no buyer.
5. **What the numbers force at runtime.** One machine, one process tree, one folder per run
   (`docs/SRS.md` C-1, FR-1); no network call during operation, none (NFR-8); own state in the
   tool's own data location and never in the folder (FR-21, DR-5); no configuration of any kind
   (NFR-14). And the promise must survive a crash (NFR-4) — which is what turns "the code declines
   to write" into "the operating system refuses the write": only a wall outside the process holds
   through the process dying. One more thing the rulings force: no network entitlement and no
   mach-lookup exception, ever (§ 1; `docs/trail/sdd/cycle-8.md` § 5.1; `docs/trail/sdd/cycle-9.md`
   § 1.1) — so every process the product runs starts under that profile, and a view whose own
   processes must pass a network check at their start (WebKit's, RC-2) has no process to run in.
   That leaves one process.
6. **What a first slice could prove.** For each candidate below: the smallest build that shows it
   right or wrong is one that opens a folder, shows its tree, reads one file, and has the *wall*
   in place and machine-checked — because the wall is the shape's whole claim — and, since
   RC-2, a window shown to draw *under* that wall: a wall proven on a bundle whose window never
   drew proved nothing a person could use (§ 4 C-I3, the renderer gate). A candidate whose wall
   cannot be checked until the product is whole carries a warning about itself.
7. **What being wrong costs.** Stated per row, below the table.

**The candidates, run against the forces.** Each row is checked against § 1's four questions —
*show* no write path; follow a moving folder without blocking or writing; swap the folder without
rewriting the viewing surface; install by one path in five minutes — and the question that decides
the row is named on it.

| Shape | Right when | Wrong when | Taken? |
|---|---|---|---|
| **Sandboxed single-process read pipeline** — one process under the App Sandbox with no network entitlement; a Rust library that reads two sources into one in-memory folder model; an AppKit shell that draws the model's projections and holds no I/O of its own, reached across one closed C-ABI seam | The system's rules are negative invariants that must hold through a crash and are held by the process's own entitlements (force 3, force 5); change arrives as read surfaces rather than capabilities (force 1); and what is shown executes nothing — content reaches the view as data a text engine lays out, so no second process is needed to wall a script engine off | Content must be rendered by an engine that executes it — then a view process that can be handed nothing is worth its seam; or the view needs a system service the wall refuses to start | **yes** — it answers § 1's first question with one entitlements file a reviewer reads (`codesign -d --entitlements`) that covers everything the product runs; the second with a watcher and a model that never hold a write; the third with the folder as a value the model is replaced by (§ 3); the fourth with one bundle and no dependency the view brings (§ 4 C-R1, C-R4, C-R6). Taken over the row below on § 10 RC-2 and the owner's (a) (`docs/trail/sdd/cycle-9.md` § 1.1) |
| **Capability-split read pipeline** — the shape this document held to v12 (ADR-0001): the surfaces in a separate renderer process holding *no* filesystem, network or shell capability, reached through a closed command list and one read-only asset scheme | The renderer executes content — HTML, script — so the process that runs it must be one that can be handed nothing; and the operating system starts that process under the wall | The only renderer that fits refuses to start under the wall (RC-2: WebKit's processes check the host's network entitlement at their own start), or the content is data no engine executes — then the second process guards a threat the design no longer has and costs a serialized seam | no — yes until the owner's (a). No native view process exists that would earn the seam: a view that executes nothing has nothing to be walled off from. It returns if a view that executes content *and* starts under the rule ever exists; none is known |
| **Hexagonal** — a domain core behind ports, an adapter at every edge | Many volatile edges owned by others, and a core carrying rules worth guarding from them (force 2, force 3 the other way round) | The edges are two, stable, and owned by Apple and Git, and the core would hold a folder model and no rule (force 2, force 3): every port but one guards nothing | no — insulating a stable edge is ceremony; its one useful port, the Git reader (force 2), is kept inside the taken shape (§ 3 SM-2). It would win only if the agent-workflow front end came inside the terminus and brought its own edges, which the Agari places outside done |
| **Layered, one process** — UI over services over a data-access layer | A product whose data layer's generic filesystem and network access is the point | A product whose defining promise is that such access does *not* exist (force 3): not-writing becomes discipline in a layer built to write | no — fails § 1's first question by construction: a reviewer is *told* the data layer never writes; nothing shows it |
| **Rust-native toolkit, single process** — egui, iced, gpui or Slint: widgets the toolkit draws itself over a GPU surface, one language throughout | One language outweighs the platform's look, and the toolkit's dependency tree is one the product can vouch for | The design starts from what a stock Mac already draws — the platform's fonts, its text sizes, its flat list rows (`docs/DESIGN.md` § Overview; `docs/UXD.md` § 9, "the platform's own controls and appearance are the starting point") — and every dependency is a decision reviewed against an allowlist (§ 4 C-R6): a toolkit that rasterises its own text and ships a GPU stack is a second look and the largest tree of any row, brought to the one seat where the design asks for nothing shipped | no — it keeps one language and loses the look the design is drawn from, and it spends the dependency budget where the platform already provides everything |
| **In-process web engine** — WebKitLegacy's `WebView`, or HTML imported through `NSAttributedString` | The CSS design language must be kept byte for byte, and a deprecated API is acceptable | The engine is deprecated (macOS 10.14), it executes content inside the one process the wall covers, and whether it starts and stays offline under the rule is unmeasured | no — the renderer wall gone *and* a script engine in the host: the worst of the two rows above, on an API Apple has retired. (The previous table's row 4, "Native single-process model-view (AppKit / SwiftUI)", is the taken row now; what survives re-expression of the design language is the CDO's finding, RN-53, not this table's) |
| **Local server + browser tab** — the input proposal's "web app" | A hosted or multi-client direction is inside done | A listening socket is a network call during operation, which NFR-8 forbids outright; and the README no longer calls the product a web app (`docs/PRD.md` § Out of Scope, last item) | no — fails § 1's first and fourth questions: a socket is a capability the wall must forbid, and a browser tab is a second thing to install |

**Which side this product falls on, and why.** The four questions § 1 sets are all *structural*:
each asks for something a reviewer can check without trusting the code — and they are now answered
by one boundary rather than two. The process's entitlements — a read-only grant on the chosen
folder, no network, ever — cover everything the product runs, because everything it runs is one
process (§ 4 C-R2). What the previous shape added, a renderer process that could be handed nothing,
guarded a threat this shape does not carry: content reaches the view as data — a tree of typed
nodes, spans, bytes — and the view hands it to a text layout engine, never to an interpreter (§ 3
`markdown-renderer`; § 4 C-D3). The hexagonal shape still answers with more seams than the product
has volatile edges; the layered and web-app shapes still cannot answer the first question; the
Rust toolkit answers all four and loses on the look and the tree; the in-process engine loses both
walls at once. Until v12 this section landed where ADR-0001 stands
(`docs/adr/0001-capability-split-read-pipeline.md`; RN-1); it departs from that record now, on the
forces as the two rulings re-read them, and the departure is surfaced (§ 10 RC-3; § 12; RN-60).

**The view is AppKit, and its language is Swift.** Two ways draw AppKit: Swift, Apple's own
language for it, or Rust through the `objc2` bindings. Rust would keep the product to one language,
and it costs: every message send is `unsafe` in a workspace that forbids it (`Cargo.toml`,
`[workspace.lints.rust]`), TextKit and `NSOutlineView` are driven through bindings written for a
different idiom, and the contributor who knows AppKit knows it in Swift. Swift costs a second
language beside Rust — the count this product already carried with TypeScript — and one C ABI
between them (§ 3 SM-4); it buys the platform's own controls, and it brings nothing to the tree:
`Package.swift` declares no dependency (§ 4 C-R6). SwiftUI is not taken for the view: the reading
panel is a text view with attachments and block layout (`docs/UXD.md` UX-I12), which is TextKit's
through `NSTextView`, and a SwiftUI layer over it would add a second layout system for no surface
that needs one. The Principal Architect's log records the previous runtime as ADR-0002
(`docs/adr/0002-tauri-2-rust-host-wkwebview-renderer.md`); this paragraph departs from it whole, and
the departure is surfaced with the shape's (§ 10 RC-3; RN-60).

**Undoing it.** Three reversals, priced separately because they cost differently:

- *Moving the view into a second process* costs the bridge (§ 3 SM-4) re-wired as IPC, and nothing
  else — the folder model, the readers and the harness survive. Cheap in code, and blocked while the
  rule stands for any view whose processes check the host's network entitlement (RC-2).
- *Replacing the view technology* costs every surface rewritten (§ 3 `surfaces`, `mac-shell`); the
  core, the bridge's contract and the harness survive. Expensive — paid once, before any release
  (§ 10 RC-3) — and not foreseen again inside the terminus (force 4).
- *Removing the sandbox* costs one entitlements file — and the wall. That is the one reversal the
  design refuses to make cheap to *forget*: the wall's presence is checked on every build (§ 4
  C-I3), so it cannot go missing without a red build saying so.

## 3. The parts, and the seams between them

<The components the system is made of, what each owns, and — as load-bearing — what each must not
own. Then the seams: every place two parts meet, what crosses, and which side owns the contract.
A seam with no named owner is where the design will be argued about later.

**Both tables are read by a tool, not only by a person.** The skeleton launcher creates one
directory per part before any code exists, and it does that by reading the parts table with nothing
in the loop to interpret it. That is why the shape below is fixed rather than left to the run: prose
carries the same content, but no two documents shape it the same way, and a reader that has to
interpret gives a different answer twice over the same settled text. Leave both tables as written.>

**The parts.**

| Part | Lives in | Owns | Must not own |
|---|---|---|---|
| `fs-reader` | crates/nozoki-core | Listing a folder's entries and reading a file's bytes, each returning its outcome as data (bytes, or the condition observed); the text rule — bytes decode as UTF-8, with or without a byte-order mark, or begin with a UTF-16 byte-order mark and decode as UTF-16, and the file is text; otherwise it is *cannot-display-as-text* (`docs/SRS.md` FR-10) — no encoding is detected from content, no third encoding is admitted, one undecodable sequence makes the file not text, and an empty file is text (the owner's value, RN-41); the extension map that names a floor language or *plain* (FR-29; the set is § 4 C-I5); the **containment check** — after percent-decoding, the path is walked position by position from the granted folder: at every position *inside* the grant the canonical form is taken, symlinks resolved, and the walk goes on from it; at a position *outside* the grant nothing is read — no `lstat`, no `realpath` — and names are compared as spelled, the walk re-entering the grant only on the folder's own name met from its parent position: as spelled, or in another letter case where the folder is not the root of its volume and that volume ignores letter case, both read from the folder itself — never two names the volume keeps apart, and as spelled wherever it cannot be sure; a walk that ends inside the grant is contained and one that does not is refused — run before any open, for every path derived from content or from outside. Three spellings are refused as outside although they may lead in, because proving it would take a read outside the grant (§ 4 C-D1): a path that leaves by more than one level and returns in another case, a Unicode-normalization difference (§ 11 R-10), and a granted folder that is the root of its volume (the owner's answer, `docs/trail/sdd/cycle-15.md` § 5.1; RN-71) | Any write. Git, in any form. Watching. Markdown. Deciding what a change means |
| `git-reader` | crates/nozoki-core | The **Git port** — `probe(folder)` answering `root` or `plain` with discovery disabled and never a path above the folder (FR-33); on a root only, `state()` (branch or detached identifier, the short status word), `status()` (changed and staged entries), `diff(kind, path)` and `walk(tips, window)` (beyond v1) — every method read-only and returning plain data — and its one adapter, libgit2 built with its `https` and `ssh` features off (§ 4 C-R6). The installed-`git` adapter, run with `--no-optional-locks`, is the port's standing substitute and is not built ahead of the risk that needs it (§ 11 R-1). **With the machine-level config off** (the `core-bridge` row's switch) the reader sees two things differently from `git status` in a terminal. The user's global ignore file is not applied, so a file it hides there is listed here as untracked (`libgit2-sys 0.18.8+1.9.7`, `libgit2/src/libgit2/attrcache.c:L345`: the fallback is found through the same search path). And a repository the current user does not own fails to open, because the `safe.directory` entry that would allow it is read from those levels (`repository.c:L629-L634`, `:L1172-L1173`); it is a `failed` Git item. Both follow from `docs/fdr.md` R-101 as it stands — "The product reads nothing outside the viewed folder except its own data location on the machine" (`docs/fdr.md:L188`) — and honouring either means a read outside the grant, which is the owner's to allow (`docs/trail/sdd/cycle-22.md` § 2.1; RN-87) | Any mutating call — checkout, index write, ref update, lock file. Spawning a process. The model. A file outside Git's own on-disk layout |
| `watcher` | crates/nozoki-core | One FSEvents subscription on the granted folder, the root's `.git` entry included, delivering coalesced change events as paths; nothing else | Reading content. Interpreting a change. Any write |
| `folder-model` | crates/nozoki-core | The in-memory model of exactly one folder (FR-1): the tree, the selection and expansion, the open file, the Git state where the root finding says `root` and none where it says `plain`; every read held as an item carrying an `ItemState` (§ 4 C-I1); the **reducer** that applies reader results and watcher events and keeps the reader's place (FR-27); **the fill of the open `FileView`** — the model calls `highlighter` for a text file in a floor language and `markdown-renderer` for a Markdown file, on the bytes `fs-reader` returned, and holds a call that fails as that item's `failed(condition)`, never a panic (§ 4 C-I1; `docs/SRS.md` FR-8, FR-30, DR-6; drafted at RN-64, confirmed by the owner at `docs/trail/sdd/cycle-11.md` § 2.4 — RN-65); **replace-whole** — a new folder replaces the model as a value, never mutates it (NFR-12); the projections the surfaces draw; and the plain Rust API the host wraps and the harness calls (SM-5) | I/O of any kind. Any Apple framework. Own state. Drawing |
| `markdown-renderer` | crates/nozoki-core | Markdown → a **typed document**, from bytes `fs-reader` read: a `MarkdownDocument` (*What the system holds*, below) whose node kinds are a closed set and never markup — heading, paragraph, list, quote, rule, fenced code with its language and `highlighter`'s spans; an image whose reference passes the containment check carrying that folder-relative path, every other image a placeholder node carrying the condition observed; an external link an inert node with its destination readable; a relative link a node carrying its target path; raw HTML in the source a text node (`docs/SRS.md` FR-30, FR-32, NFR-16; `docs/UXD.md` UX-I12) | Any network. Emitting a URL of any scheme. Markup of any kind. Reading the file itself, or an image's bytes. The raw-source view (§ 9 TO-5) |
| `highlighter` | crates/nozoki-core | Text and a floor language → spans, each a byte range and one of the five token classes `docs/DESIGN.md` § Colors names (keyword, string, number, comment, name), for the reading panel's code treatment and for a fenced block in a `MarkdownDocument`; the six grammars compiled into the library by **tree-sitter** — its runtime, `tree-sitter-highlight` and one grammar crate for each floor language, built from C into `nozoki-core` at build time, with nozoki's own query files compiled in — a dependency decision under § 4 C-R6, made in a change of `read-a-file` and recorded beside the list it reviews (`checks/deps.review.md` § *The engine chosen*, `nozoki@85d9fa7`; RN-80); what the engine costs is § 9 TO-11 and what could break it is § 11 R-14 (FR-8, FR-29; § 4 C-I5) | Reading a file. Naming the language — that is `fs-reader`'s extension map. Drawing. A seventh grammar with no floor language behind it |
| `own-state` | crates/nozoki-core | The tool's own remembered state — theme, window frame, and beyond v1 the remembered folders as security-scoped bookmarks with display names and which was viewed last — read whole or discarded whole, written only inside the app's container (FR-21, DR-5) | Anything of the folder's content. The diagnostic log. A path outside the container |
| `core-bridge` | crates/nozoki-bridge | The C ABI over `folder-model`'s API and the **Rust-side composition root**: the closed function list the shell calls (SM-4), each function a thin wrapper that decodes its arguments, calls `folder-model` and returns plain data as an owned buffer freed by one `nozoki_free`; the `model_changed` callback; `asset_bytes`, returning an image's bytes only for a path the containment check passes (SM-7); the diagnostic log writer's install (§ 4 C-I2); wiring the libgit2 adapter to the Git port; and, before that wiring and before any thread can reach libgit2, **the config search-path switch**: four calls to `git2::opts::set_search_path`, one for each of the system, global, XDG and programdata levels, each setting that level's search path to empty, so that a repository open adds none of the four machine-level config files, which lie outside the granted folder (§ 4 C-D1; in `libgit2-sys 0.18.8+1.9.7`, the version `Cargo.lock:L122-L123` resolves, `libgit2/src/libgit2/repository.c:L1316-L1338` adds the four levels and `sysdir.c:L559-L560` returns before any file is touched where a level's search path is empty). The switch fails closed: each call returns a `Result` (`git2-0.21.0/src/opts.rs:L23`), and if any of the four fails the adapter is not wired and the Git item is `failed`, so a repository is never opened with the reads on. The switch runs once per process, and a second arrival at the composition root repeats nothing. The bridge names the libgit2 binding in those calls and their test and nowhere else, and its manifest's `git2` line turns default features off (§ 4 C-R6). **Not covered by the switch:** a path the repository's own config names — `include.path`, `core.excludesfile`, `core.attributesfile` — which libgit2 follows and which passes no containment check (§ 11 R-16) (answered in the CTO's seat, `docs/trail/sdd/cycle-22.md` § 2.1; RN-87). The one unit that holds `unsafe`, with the reason recorded in its manifest and its record (workspace `Cargo.toml`, `[workspace.lints.rust]`) | Read logic — every function delegates and formats. AppKit, or any Apple framework. A window. A path outside the grant. Anything the harness could not exercise through SM-5 |
| `mac-shell` | nozoki-mac | The `NSApplication`, the one window and the app's **composition root** on the Swift side: it presents the Open panel and holds the grant the panel returns, calls SM-4 and decodes what returns, marshals `model_changed` onto the main thread, hands projections to `surfaces` and turns their intents into SM-4 calls (SM-8); it owns `Info.plist`, `Entitlements.plist` and the bundle's assembly (§ 4 C-R1, C-R2) | Drawing — that is `surfaces`. Read logic. Any I/O of its own — a file read, a network API, a spawned process, `NSWorkspace.open` (§ 4 C-R7). A second window. A terminal line |
| `surfaces` | nozoki-mac | The shell's views as the UXD draws them: the rail, the tree (`NSOutlineView`), the reading panel and its treatments — code, rendered Markdown laid out from a `MarkdownDocument` by TextKit, and beyond v1 the diff — the Git view (and beyond v1 the history beneath its changes list), the chrome with the identity element and the theme control (`docs/UXD.md` § 4, § 6); the theme tokens as values; the message catalogue. It draws projections and draws no state the bridge did not send, with **one exception: that an intent it raised has not been answered yet**. That is the one state the bridge cannot send — a call's answer is its return (SM-4), so until the call returns the bridge has said nothing — and the one thing the shell observes first-hand. Four bounds hold it. **One:** it is the gap of the surface's own ask and says nothing about the folder. It begins when the surface raises an intent across SM-8 and ends on that intent's answer, and it carries the pending sentence alone — no marker, no count, no content and no progress figure (`docs/UXD.md` UX-I13; the sentence is `docs/CONTENT.md` § *Message patterns* → *Loading*'s). **Two:** every answer ends it, whether the answer is a projection or carries no verdict, and no timer starts it, advances it or ends it (§ 4 C-E1; `docs/CONTENT.md` § *Message patterns* → *Error*, "A stopped read is never dressed as a pending one"). **Three:** only an intent the reader's own act raised opens it. A change that arrives unasked opens none, so from `follow-the-folder` on a refresh never draws pending over content being read (§ 4 C-E2). **Four:** `pending` as an `ItemState` stays the model's and still crosses the bridge — `kind` before the root finding answers, and a folder entry not yet read — and a surface originates neither. The gap is not held state: it lasts from one ask to its answer, and the open file, the selection and the expansion stay `folder-model`'s. Two cases the exception does not cover: a read that never returns leaves the pending sentence standing, with the tree the route out; and which side orders two asks in flight is the design of the change that moves the selection into the model (RN-76). (Answered in the owner's seat, `docs/trail/sdd/cycle-19.md` § 5.1; RN-82) **Read with the exception, and not a second one:** what the pointer is over is the shell's own observation of the pointer and is no state of the folder. Whether the window is the key window is the shell's own observation of the window and is no state of the folder. The clickable row's hover fill and the status letter's tooltip are drawn from the pointer and the key status together, and neither is drawn while the window is not the key window (`docs/DESIGN.md` § *Components*, "Rows" and "The tooltip"). What the pointer is over is not held across a redraw, it raises no intent across SM-8, and it says nothing about the folder, so the exception above stays the only one. The same bounds hold the key status. It is asked each time the row or the letter under the pointer is resolved, and at the two moments the window stops being and becomes the key window. It is held across no redraw. It raises no intent across SM-8 and says nothing about the folder. A surface that is in no window reads as not key and draws neither the fill nor the tooltip. The observation stays inside `surfaces` and crosses no seam. Not decided by this clause: which window is the key window while the Open panel or a menu is up, which is the platform's answer. (Answered in the CTO's seat: the pointer, `docs/trail/sdd/cycle-31.md` § 5.1, RN-96; the key status, `docs/trail/sdd/cycle-33.md` § 5.1, RN-98) **Held here for `see-git-status` alone, and not a second exception:** two pieces of projection logic that `folder-model` owns stand in this part until `follow-the-folder` is reached (*What the system holds*, `FolderModel` and `GitState`). The first is the join of the Git item onto the tree's row paths, which decides which row carries which status letter (`nozoki-mac/Sources/Surfaces/TreeMarkers.swift`, built at `nozoki@6c49d5c`; that commit is not an ancestor of `main` at `nozoki@b640345`, and this clause reads the same whether or not it merges). The second is the order of the Git lists' rows (`nozoki-mac/Sources/Surfaces/GitRowOrder.swift`, on `main` since `nozoki@d65eec4`). Four bounds hold both. **One:** each derives only from projections the bridge sent, the Git item and the tree listings, so the exception above stays the only one. **Two:** the join marks a row only from an `observed` repository answer (§ 4 C-I1, C-E1). **Three:** neither raises an ask, and neither holds a path it did not receive in a projection (SM-8). **Four:** both end when `follow-the-folder` is reached. The marker and the order move into `folder-model`, the two files leave the shell, and that slice's command half is red while either remains (§ 6 S-5). The order needs no new seam, so a change that opens `crates/` may move it earlier. The marker waits for the `model_changed` delta (§ 10 RC-4, RC-5). A re-cut of `follow-the-folder` owes this clause a new end. (Answered in the CTO's seat, `docs/trail/sdd/cycle-29.md` §§ 5.1, 5.2; RN-94) | The bridge — a surface never calls SM-4; it hands `mac-shell` an intent (SM-8). Filesystem, network or process capability of any kind. A URL built from content and handed to any framework. An HTML import. A message not in the catalogue. A dialog, a toast, a notification |
| `read-only-harness` | checks | The scripts, their lists and helpers, the fixtures and the suites that prove the promises on every build and every release. The enumeration is measured at `nozoki@814a369` (2026-10-03) and pinned to it, as `docs/nfdr.md` § 9 pins its suite count: a file landing in `checks/` after that commit is a re-measurement of this cell and not a contradiction of it, and it owes this row an item. **On disk at that commit:** `read-only.sh` with `walk.rs`, the in-process driver it runs — compiled into a `nozoki-core` test target by `crates/nozoki-core/tests/walk.rs:L6`'s `#[path]`, never into the library; `no-network.sh`; `bundle.sh` with `sandbox_probe.rs`, which it compiles with `rustc` at run time into its temporary directory because no shell can call `sandbox_check` (`checks/bundle.sh:L321-L322`; § 4 C-I3); `renderer.sh`; `view.sh`; `own-state.sh`; `structure.sh`; `entry-points.sh` with `entry-points.allow`, the reviewed list it diffs the linked tree's environment and argument reads against — the check `docs/nfdr.md` QC-30 half (2) places in this unit; `deps.allow` with `deps.review.md`, the review recorded beside the list it reviews (`highlighter`'s row); `tests/`, one `test_<name>.sh` suite for each of the eight scripts above, each the whole `run` of its own CI step; and nine fixture folders — `plain`, a plain folder; `repo`, a repository, with `repo.git.tar`, the `.git` the suites unpack into it; `inside-a-repo`, `parent-of-two`, `linked-worktree` and `submodule`, the four root-finding scenes, each with its `<name>.git.tar`, the `.git` entries `crates/nozoki-core/tests/root_finding.rs:L49` unpacks into a scene of its own; `highlight` and `text`, the corpora `nozoki-core`'s `highlight.rs` and `read_file.rs` tests read; and `idle-shell`, the renderer gate's control bundle (§ 4 C-I3). **Owed by a slice and not on disk at that commit:** `churn.sh` and `latency.sh` with `fixtures/scale-small`, `scale-medium` and `scale-large` (`follow-the-folder`; § 4 C-I4); `fixtures/hostile.md`, the hostile Markdown corpus (`read-markdown`); `fixtures/history` (`read-the-history`); and, from `promise-one-point-zero`, `contract.sh` with the pin `contract/<major>` it reads (§ 4 C-I6) | Being a dependency of any shipped unit. Driving the AppKit views. Shipping in the bundle |

**Four physical units carry the eleven parts.** `crates/nozoki-core` is a Rust library that
imports no Apple framework and holds no `unsafe`, so the harness links it without a window;
`crates/nozoki-bridge` is a Rust static library, the only unit that exports a C ABI and the only
one that holds `unsafe`; `nozoki-mac` is a Swift package building the app's one executable, the
only unit that imports AppKit, declaring no package dependency and linking `libnozoki_bridge.a`;
`checks` is build-time and never shipped. *No `unsafe`* is said of each crate's own Rust source.
The C that `nozoki-core` links — the grammar engine (`highlighter`'s row) and libgit2
(`git-reader`'s row) — is compiled in beside that source and is outside the claim (§ 9 TO-2,
TO-11; § 11 R-14; RN-80). The unit set departs from the one ADR-0009 records
(`docs/adr/0009-physical-module-set.md`) — `nozoki-app` and `nozoki-ui` leave, `nozoki-bridge` and
`nozoki-mac` arrive — and the departure is surfaced, not recorded here (§ 10 RC-3; RN-60); the
`crates/` placement is the owner's ruling for every Rust product in this instance as
`docs/nfdr.md` § 9 carries it (RN-4). Only `git-reader` imports the libgit2 binding, with one
exception: `core-bridge` names it in the composition root's search-path switch and that switch's
test, and nowhere else (the `core-bridge` row; RN-87). `nozoki-core` still holds no `unsafe`. Only
`own-state` and the bridge's log writer write anything; the readers, the watcher, the highlighter
and the renderer import neither the model nor one another, with two stated edges —
`markdown-renderer` calls `fs-reader`'s containment check, and `highlighter` for a fenced block.
The model calls down to `markdown-renderer` and `highlighter` to fill a `FileView`, and neither
of them imports the model — the one edge from the model into the two, in that direction only
(drafted at RN-64, confirmed by the owner at `docs/trail/sdd/cycle-11.md` § 2.4 — RN-65).

<**Part** is a **slug**, and what makes one usable is not cosmetic. **Lowercase letters and digits,
single hyphens between them, and nothing else**, written in backticks — no capital, no space, no
underscore, no dot, and no `__PROJECT__`. The skeleton launcher joins this cell to `Lives in` to make
a real directory, and it uses the cell exactly as written — nothing in this column is substituted. A
cell of any other shape is refused, rather than turned into a directory whose name carries the wrong
characters.

It names *the thing* — `connect-unit`, `cache-reader`, `session-store` — never its position in the
list. A positional label (`P-1`, `C-3`) is what a document reaches for on its own and it fails twice
over: it cannot become a directory name, and renumbering the list silently invalidates every
reference to it. A slug survives a renumbering because it never encoded the number. **That half is
the author's to keep, because no tool can check it:** the launcher refuses `P-1` for its capital, and
a lowercase `p-1` is a well-formed slug it has no grounds to refuse.

**A part slug is not a slice slug.** § 6 gives every slice one too, and § 8's map from a slice's
fields to a seed's sections is keyed on *those*. The two name different kinds of thing — a part is a
component that goes on existing, a slice is a unit of work that lands once and is done — and they
must never be spelled the same. Where a slice delivers one part, give them different words rather
than letting one string mean both; § 8 cannot tell them apart, and neither can a reader six weeks
later.

**Lives in** is the module, package or crate the part belongs to, **written as a bare path and
nothing else** — `app-core`, `src/domain`, `crates/reader`. One value, relative to the product
root, no leading `/` and no `..` in it. Not a sentence, not two options, no backticks, no bold, no
trailing clause: a tool joins this cell to the part's slug to make a real directory, so a cell
reading ``app-core`, behind the **Sync port**`` becomes a directory of that name, punctuation and
all. Where a part's placement genuinely needs explaining, the explanation goes in *Owns* and the
cell stays a path. Leave the cell empty for a part that sits at the product root. This is the one
column in which `__PROJECT__` is substituted, for the package named after the product itself.

It is the column most easily left
out, because a human reader infers it from context a script does not have — and without it nothing
knows where a part's directory goes. On a product with more than one language it carries more still:
it is what says which language's layout this part takes.>

**The units.** One row per distinct value in the parts table's *Lives in* column; parts sharing a
value are inside that unit, not directories beneath it. *Language* is a value from the project
card's `Languages:` line; *Kind* is the word that language's packet uses for a buildable unit.

| Unit | Language | Kind |
|---|---|---|
| `crates/nozoki-core` | `Rust` | `crate` |
| `crates/nozoki-bridge` | `Rust` | `crate` |
| `nozoki-mac` | `Swift` | `package` |
| `checks` | `Shell` | `directory` |

The Swift frame — `Package.swift`, `Sources/`, `Tests/` — lands inside `nozoki-mac/`, where the
card's own test command goes to find it. *Kind* takes the word the Swift packet uses for a buildable
unit, `package` (`<CORE>/doctrine/engineering/languages/swift/layout.md`, in the registry since
`kensaiapp-dev@3ab2e8553`, 2026-09-23), which is also Swift Package Manager's own word; the frame
was laid out by hand in the slice that landed it rather than by a launcher, and how the package is
laid out inside is the packet's and `docs/nfdr.md` § 9's, not this section's. The project card
carries `Swift` in place of `TypeScript` on its `Languages:` line and the `swift test` half in place
of Vitest in its test command (`kensaiapp-opensource@5b27023`; RN-60, RN-66). `checks` is `directory` because
it builds nothing and is forbidden from being a dependency of any shipped unit; Shell is its
language because the card declares Shell for the `checks/*.sh` harness by name (RN-36).

**The seams.** Each names what crosses and which side owns the contract.

| Seam | What crosses | Owner of the contract |
|---|---|---|
| `SM-1` `fs-reader` ↔ `folder-model` | Down: a path to list or read. Up: the listing, or the bytes with the text rule applied and the floor language named, or the condition observed — always as data, never a panic | `folder-model` — it states what a read must return; the reader implements it |
| `SM-2` `git-reader` ↔ `folder-model` | Down: `probe`, and on a root `state`, `status`, `diff`, `walk`. Up: `root` or `plain`; plain-data Git state; or the condition observed. The port is a trait defined in `git-reader`, with the plain-data types that cross beside it; the adapter is the only thing that knows libgit2, with the one exception the *Four physical units* paragraph states: `core-bridge`'s search-path switch (RN-87). Every type `probe`, `state` and `status` answer is defined in `git-reader`, beside the trait (`crates/nozoki-core/src/git_reader.rs:L74-L263`, at `nozoki@87f6a48`; RN-88). A type that crosses this seam is never defined in `folder-model`. A type a later method brings is defined in `git-reader`, or in a module of `nozoki-core` that is no part, and which of the two is the design of the change that adds it. The model imports the trait and those types, and never the adapter | `folder-model` — it states what the port must answer; `git-reader` defines the trait and implements it, because the readers import nothing from the model (the *Four physical units* paragraph above) and an adapter cannot implement a trait the model defines without importing the model; a second adapter passes the same contract tests (§ 11 R-1) (answered in the owner's seat, `docs/trail/sdd/cycle-21.md` § 5.2; RN-85) |
| `SM-3` `watcher` ↔ `folder-model` | Up only: coalesced change events as paths, the root's `.git` entry among them. The model decides what to re-read | `folder-model` — the event shape is its |
| `SM-4` `core-bridge` ↔ `mac-shell` | Down (shell → core): calls from this list and no other — `open_folder` (taking the URL the Open panel returned, and no path from any other source), `list_tree`, `select_file`, `open_relative_link`, `read_git` (exported as `nozoki_read_git`; it takes no argument and returns the open folder's Git item — `root` with the Git state, `plain`, `failed` with its condition, or `pending` where no folder is open and so nothing was read; § 10 RC-4, RN-90), `set_theme`, `open_diff`, `walk_history`, `switch_folder`, `asset_bytes` — each exported from the build in which a change of its slice first builds it, and not before, and all ten from `v1.0.0`; and, **beside the list and not on it**, the seam's one release call, `nozoki_free`, exported from the first build on because every call's return needs it and never staged by slice (the owner's confirm, `docs/trail/sdd/cycle-12.md` § 5.1; RN-66). Which of the list a given build exports is stated once, in § 4 C-R7. Up (core → shell): the `model_changed` callback carrying a projection delta, on a thread the shell marshals to its main thread; and each call's return as an owned buffer of plain data — JSON, or flat structs the header declares — freed by `nozoki_free`; the header is generated from the bridge's source and never hand-kept. Nothing else crosses in either direction: the ten calls and `nozoki_free` down, the callback and the returns up. **This seam is where the promise is read, not where it is held**: the wall is the process's entitlements (§ 4 C-R2), and the seam makes visible that the shell reads through the core alone — a builder of the shell who holds only this header has no read, no write and no connection to make, and § 4 C-R7 checks on every build that the shell adds none of its own | `core-bridge` — it exports what its landed changes built, the header is generated from it, and the shell calls what is exported and nothing more |
| `SM-5` `folder-model` ↔ `core-bridge` | Down: the operations the functions name, as plain Rust calls. Up: projections and deltas. The harness calls this API directly, in-process, with no window (§ 4 C-I3) | `folder-model` — the API and its types are its; the bridge wraps, formats and delegates |
| `SM-6` `own-state` ↔ `core-bridge` | Down: the theme set, the window frame, and beyond v1 a folder to remember. Up: the state read whole, or the first-run state where it could not be read | `own-state` — the record shape and the read-whole-or-discard-whole rule are its |
| `SM-7` `markdown-renderer` ↔ `fs-reader`, and `asset_bytes` in `core-bridge` | Rendering asks `fs-reader` whether an image reference is contained; `asset_bytes` asks the same question again on every call. Only a path that passes both is ever read; a node built wrong still reaches no byte outside the folder | `fs-reader` — the check is its and has one implementation; the two callers do not re-implement it |
| `SM-8` `mac-shell` ↔ `surfaces` | Down: projections and deltas as Swift values the shell decoded from SM-4, delivered on the main thread. Up: intents — a row activated, a file selected, a link activated, a theme chosen, a folder chosen from the selector — named after SM-4's functions and nothing else; a surface never holds a path it did not receive in a projection, and never reaches the bridge | `mac-shell` — the intent set is its, and it alone calls the bridge |

**Two libraries, one executable, one bundle.** The eleven parts ship as `Nozoki.app`: the
`nozoki-mac` executable with `libnozoki_bridge.a` — `nozoki-core` inside it — linked statically,
and the fourteen icons inside `Contents/Resources`; the six grammars are compiled in, and no font
ships because the design's fonts are the platform's (`docs/DESIGN.md` § Typography). `checks` runs
against that bundle and is never inside it.

<Two tables, not one: merging them loses the seam's owner, and the unowned seam is the thing this
section already says arguments start over.>

**What the system holds.** Design-level; the physical layout is the developer's.

- **`FolderModel`** — the one viewed folder (`docs/SRS.md` DR-1): its granted path; its `kind`,
  an item that is `pending` until the root finding answers and then `root(GitState)` or `plain`;
  the tree (`TreeEntry` items: path, is-folder, expanded, and — on a root — the changed marker);
  the selection; the open `FileView`. It is a value: opening another folder replaces the whole
  thing (NFR-12). Nothing in it is persisted (DR-1, DR-2).
- **`Item<T>`** — every read the model holds, with its `ItemState`: `pending` (not yet read),
  `observed(T)` (read, and this is what was read), `failed(condition)` (read attempted, and this
  is what the tool observed — a lock, an unreadable entry, a file that is not text), or `stopped`
  (the work stopped and nothing read accounts for it — `docs/UXD.md` UX-I16). **`stopped` is
  established in two places.** The model holds it on an item whose work stopped inside the core.
  `mac-shell` establishes it at SM-4's return, where a call's answer is read, when the return
  carries no verdict: the failure value `core-bridge` returns after catching a panic at the
  boundary (§ 11 R-13), which is a NULL buffer, or a buffer that does not conform. The model can
  report neither: a panic is caught outside it, at the boundary, and a buffer that does not
  conform is found only where it is decoded. The shell hands that `stopped` down SM-8 as the
  state of the item the call was for, and a surface draws it as it draws the model's and
  originates neither. **`pending` here is the model's**, a statement about a read of the folder —
  `kind` before the root finding answers, a folder entry not yet read — and it crosses the
  bridge. The gap between a surface's ask and its answer is not an `ItemState` and nothing holds
  it: it is the one exception § 3's `surfaces` row names (answered in the owner's seat,
  `docs/trail/sdd/cycle-19.md` § 5.1; RN-82). A surface draws a marker, a count or a "nothing
  changed" only from `observed` (UX-I13). This is the mechanism behind § 4 C-I1 and NFR-3.
- **`FileView`** — the open file (DR-3): its folder-relative path; its content as one of *text*
  (with the floor language or *plain*, and `highlighter`'s spans where there is a language),
  *markdown* (a `MarkdownDocument`), *cannot-display* (the reason), or *gone* (the file vanished
  under the reader — FR-28); the reading position the reducer preserves across a refresh (FR-27).
  In-session only.
- **`MarkdownDocument`** — the rendered form of a Markdown `FileView` (DR-3, DR-6; FR-30, FR-32;
  `docs/UXD.md` UX-I12): an ordered list of block nodes — heading with its level, paragraph, list
  with its items, quote, rule, fenced code with its language and spans — each holding inline nodes
  — text, emphasis, code, image, link. An image node is *resolved* (a contained folder-relative
  path in one of § 4 C-D3's four formats) or a *placeholder* carrying the condition observed
  (outside the folder; missing; unreadable; a format not decoded). A link node is *external*
  (inert, its destination readable) or *relative* (a contained target path). The set is closed: no
  node carries markup, none names a URL the shell fetches, and raw HTML in the source is a text
  node. In-session only.
- **`GitState`** — present only where `kind` is `root` (DR-4): the branch name or, detached, the
  commit identifier; the changed entries and the staged entries, each with its status letter; the
  short status word; and beyond v1 the history window — commits with identifier, message, author,
  date, parents and branch membership, against a chosen tip set — and a `Diff` (path, staged or
  unstaged, hunks). Derived by read-only means, never persisted. The model holds it. `GitState`
  is a type `folder-model` defines and builds from what the port returns, and the port never
  returns it (SM-2; RN-85, RN-88). The model holds the port's `HeadState` and its `StatusLists`
  (`crates/nozoki-core/src/folder_model.rs:L169-L172`, at `nozoki@a7834f4`). It builds both from
  one read, which asks `state` and then `status` (`:L300-L306`). `status` is asked only if
  `state` succeeded. A failure of either makes the whole Git item `failed`, with the condition
  of the operation that failed, so the model never holds a `GitState` with one of the two
  missing (`:L267-L273`); this is § 4 C-I1 applied to the one Git item. Three things this entity
  lists are still the design and are in no landed change: the history window and the `Diff`,
  both beyond v1, and the tree's changed marker, which the `FolderModel` entity above gives
  `TreeEntry` (`grep -n marker crates/nozoki-core/src/folder_model.rs` prints nothing at that
  commit) (`docs/trail/sdd/cycle-26.md` § 5.1; RN-91). **Two things the design gives the model
  are computed in the shell meanwhile** (`docs/trail/sdd/cycle-29.md` §§ 5.1, 5.2; RN-94). The
  model holds the changed list and the staged list in the order their rows are drawn, and that
  order has one implementation, in the core. At `nozoki@b640345` the core orders neither list
  (`crates/nozoki-core/src/git_reader.rs:L121`, "no order is promised"), and the shell orders
  them. The tree's changed marker is still in no change landed on `main` at that commit. The
  join that produces it is in the shell (`nozoki-mac/Sources/Surfaces/TreeMarkers.swift`) and
  on `main` from `nozoki@67d103d`, the merge that landed it, under the four bounds § 3's
  `surfaces` row states (`docs/trail/sdd/cycle-30.md` § 5.1; RN-95). § 3's
  `surfaces` row names both files and bounds both placements, and both move into the model no
  later than `follow-the-folder` (§ 6 S-5). This document names who computes the order. It
  states no order rule.
- **`OwnState`** — what the tool remembers between sessions (DR-5): the theme, the window frame,
  and beyond v1 up to ten remembered folders as security-scoped bookmarks with display names and
  which was viewed last (`docs/UXD.md` UX-S7). Nothing personal, nothing of any folder's content;
  read whole or discarded whole (§ 4 C-D4).
- **The input bar is a rule on every entity, not an entity** (DR-6): every field above that comes
  from the folder arrives through an `Item`, so a folder that is missing, moving, hostile or
  enormous produces a state the surfaces can draw, never a panic and never a write.

## 4. What every slice inherits

<The conditions that hold across the whole build, whichever slice is being worked — written as
conditions rather than as chapters, because every slice in § 6 is checked against all of them.

Cover at least: the runtime and deployment shape; what is instrumented and what makes a failure
visible; how identity, authorization and data protection are handled; and the experience conditions
the UXD binds on every surface. Align each with the SRS non-functional requirement or the UXD
section it serves. State the conditions that bind this product and drop the ones that do not.

**This section and `docs/nfdr.md` are two constraint stores, and the relation is fixed.** § 4 is the
**authoring surface** — a condition is stated here first, in the design conversation, traced to the
SRS requirement it serves. The NFDR is the **enforcement store** — the consolidated, checkable form
the delivery loop reads, each entry tracing back to the § 4 condition or SRS requirement it realizes.
Where the two disagree, **the § 4 statement wins and the NFDR entry is re-derived**, because that is
the direction every derivation in this chain already runs: downstream is rebuilt from upstream, never
the reverse. Without this rule the same constraint can sit in both, disagree with itself, and give a
reader no way to tell which is stale.>

Each condition below names the SRS requirement or UXD entry it serves and what would violate it.
`C-R` is the runtime and deployment shape, `C-I` instrumentation and failure visibility, `C-D`
identity, authorization and data protection — the CTO's clauses. `C-E`, the experience conditions
the UXD binds on every surface, is the CDO's clause and follows them.

**The runtime and deployment shape.**

- **C-R1.** The product is one macOS application bundle, `Nozoki.app`, bundle identifier
  `com.kensaiapp.nozoki`, and **one process**: an AppKit shell in Swift (`nozoki-mac`) over the
  `nozoki-core` library, reached through `crates/nozoki-bridge`'s C ABI, with **no web engine of
  any kind** — no WKWebView, no WebKitLegacy `WebView`, no HTML import through
  `NSAttributedString`, no JavaScriptCore. No runtime is installed, no UI dependency ships
  (C-R6), and every asset a surface renders — the fourteen icons, the six grammars compiled into
  the library — ships inside the bundle; fonts are the platform's and none ship (`docs/SRS.md`
  C-3, NFR-13; `docs/UXD.md` UX-I15; `docs/DESIGN.md` § Typography). *Violated by:* a second
  binary, a second process the product starts, a prerequisite the README must name, an asset
  fetched at runtime, a web engine linked or loaded. The Principal Architect's record is ADR-0002
  (RN-2), from which this condition departs whole — the runtime, the renderer and the view's
  language — on the owner's (a) (`docs/trail/sdd/cycle-9.md` § 1.1); the departure is surfaced for
  a superseding record and none is written here (§ 10 RC-3; RN-60).
- **C-R2.** The bundle runs under the App Sandbox, and its entitlement set is bound by a **rule**,
  not held as a list. The rule, the owner's (`docs/trail/sdd/cycle-8.md` § 5.1, answer 2): **no
  network entitlement, ever** — not `com.apple.security.network.client`, not
  `com.apple.security.network.server` (Apple's two,
  https://developer.apple.com/documentation/bundleresources/security-entitlements), and no
  exception entitlement that reaches the network under another name (§ 10 RC-2 names the one
  WebKit's own check would take); **a read-only grant on the chosen folder** —
  `com.apple.security.files.user-selected.read-only` under `com.apple.security.app-sandbox`; and
  **any other entitlement only with a record that names why it is needed**, and only where the
  probe (C-I3) still finds the launched process sandboxed with the out-of-grant read and the
  outbound connection both denied. The v1 set under that rule is the two entitlements just named,
  and — from the slice that adds the folder selector — `com.apple.security.files.bookmarks.app-scope`,
  whose need ADR-0003 already records (a remembered folder is a security-scoped bookmark). The
  rule replaced "exactly these entitlements" after a network entitlement was shown to make the
  shipped window draw and was refused: the no-network promise is the operating system refusing an
  outgoing connection — never the list, and never the code declining (§ 1). No write under the
  granted folder is possible because the grant is read-only; the wall holds through a crash
  because it is not the process's to lower (`docs/SRS.md` NFR-4, NFR-5, NFR-8, NFR-9). Apple's
  entitlement reference states what the user-selected entitlement grants — "read-only access to
  files the user has selected using an Open or Save dialog"
  (https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.security.files.user-selected.read-only).
  **What the rule cost is § 10 RC-2 and RC-3:** the system WKWebView did not start under it, and
  the renderer gave way — the owner's (a), `docs/trail/sdd/cycle-9.md` § 1.1. Under one process
  the rule covers the whole product: no process the product runs has a network profile of its
  own, and the probe on the main process's pid (C-I3) covers everything that draws. *Violated
  by:* a network entitlement of any kind on any build; an entitlement
  outside the named set with no record naming its need; a build whose bundle the probe (C-I3)
  finds unsandboxed, or reports the out-of-grant read or the outbound connection allowed. The
  record is ADR-0011, superseding ADR-0003 — its status is the index row's
  (`docs/adr/README.md`, its row) and this line states none — which restates the wall under this
  rule; until it is Accepted, ADR-0003 is the record in force and this condition departs from it
  on the one word *exactly* (RN-52; the record line drafted on the companion's § 2.3, RN-61, and
  confirmed with the owner's addition, RN-64).
- **C-R3.** The folder is **granted, never typed**. In v1 the host presents the system Open panel
  at launch; the folder chosen is the session's (FR-2). The panel dismissed without a choice shows
  UX-S4's startup surface in the window, with its two routes — choose again, which presents the
  panel, and leave; the host neither exits on its own nor re-presents the panel unasked, as often
  as that happens (`docs/UXD.md` UX-S4, Empty cell). From the slice that adds the selector,
  launch restores the last-viewed folder from its bookmark without asking and presents the panel
  only when nothing is remembered or the bookmark no longer resolves; the panel is then the
  selector's *Browse…* entry (UX-S7, FR-19). A path that does not exist, is not a folder or cannot
  be read is shown in the window as UX-S4's Error cell, never printed where the tool was started
  (FR-3). A readable folder that is not a repository's root is not a failure: it opens (FR-34,
  UX-I17). The mechanism is forced by C-R2, not chosen beside it: under the sandbox a folder is
  readable only when the user selected it in an Open dialog, so a typed path or a launch argument
  cannot be granted — the alternative is no sandbox, which answers § 1's first question "if the
  code is careful" (RN-3). *Violated by:* a slice that reads a path it was not granted, that
  accepts a path by argument, environment or configuration file (NFR-14), that prints a surface to
  a terminal, or that exits or re-presents the panel on dismissal.
- **C-R4.** The one acquisition-and-start path (C-3) is a **GitHub Release on
  `github.com/kensaiapp/nozoki`** (C-12) carrying `Nozoki-<version>.dmg` and `SHA256SUMS`, built
  by CI from the tagged commit and never on a maintainer's machine, and the artifact verified to
  match the tag before it is offered. The bundle is **ad-hoc signed** (`codesign --sign -`) — what
  binds the entitlements to the binary at no cost — and is never Developer ID-signed or
  notarized: the owner's standing call that nothing is paid for this app, recorded in
  `docs/adr/0007-ad-hoc-signed-dmg-on-a-github-release.md` § Context (RN-5). The install walk is:
  download the `.dmg`, drag `Nozoki.app` to Applications, and on first launch take the one
  Privacy & Security step; the README's first screen names all three as the exact click path, and
  no terminal command is ever the documented route. No Homebrew cask, no second channel.
  *Violated by:* a release built anywhere but CI from its tag, a checksum that does not match, a
  second install path, an `xattr` or `spctl` line in the README.
- **C-R5.** The minimum macOS version is **14.0** (Sonoma): the bundle's `LSMinimumSystemVersion`
  is `14.0` and the floor is stated wherever the install path is offered (C-11). The floor
  is not forced by the stack — AppKit runs on every macOS Apple supports, and TextKit 2's
  `NSTextLayoutManager`, which the reading panel's Markdown treatment lays out with, is available
  from macOS 12.0 (https://developer.apple.com/documentation/appkit/nstextlayoutmanager) — so the
  floor is the maintainer's narrowing: it is
  the oldest macOS the timed release walk (AC-10) is run on, and one AppKit generation fewer to
  walk UX-I12's layout fixtures on per release (§ 11 R-11). The value is the one `docs/nfdr.md` QC-56 already
  binds, kept because nothing upstream moved to change it (RN-6). Raising it after 1.0.0 is a
  breaking change under C-6. *Violated by:* a bundle whose plist says otherwise, an install page
  that does not state it.
- **C-R6.** **Every dependency is a decision, and the tree is reviewed as code.** `Cargo.lock` is
  committed and CI builds with `--locked`; `nozoki-mac/Package.swift` declares **no dependency**
  and no `Package.resolved` exists — the view brings nothing to the tree; every crate the bundle
  contains is named in `checks/deps.allow`, and a lockfile diff that adds a name outside it fails
  the build until the allowlist change is reviewed in the same change. **The transport
  claim is made of the shipped executable, and of nothing smaller** (NFR-8). *What the build
  holds:* libgit2 is vendored and built with its `https` and `ssh` features off, so no TLS
  backend and no libssh2 is compiled or linked. Two things show it on every build:
  `cargo tree --locked -p nozoki-core` names no TLS or SSH crate, and the inline test in
  `crates/nozoki-core/src/git_reader/libgit2.rs` (`:L90-L95` at `nozoki@814a369`) asserts that
  `git2::Version` reports the vendored copy with HTTPS off and SSH off. *What the build does
  not hold:* the vendored libgit2 compiles its transports and its streams whatever the
  features, and registers `git://`, `http://` and `https://` with no guard (`libgit2-sys
  0.18.8+1.9.7`, the version `Cargo.lock:L122-L123` resolves: `build.rs:L152-L156` and
  `libgit2/src/libgit2/transport.c:L33-L35` in the registry copy). So this condition claims
  nothing about the library, or about `nozoki-core` as a unit. *What is claimed:* the shipped
  executable, `Nozoki.app/Contents/MacOS/Nozoki`, links no network transport. The evidence is
  an `nm` read of the release executable on every build: no defined `git_smart_subtransport_*`
  symbol, and no undefined import of `connect`, `socket` or `getaddrinfo`. The read rides
  `checks/view.sh`, which already reads that executable with `otool -L` (C-R7), under that
  script's rule that it never passes having read nothing, and with a suite case that turns it
  red; when the script carries it is C-I3's to say. Three bounds hold the read. The import
  half is read on the release executable only: a debug executable imports all three calls
  through Rust's standard library with no libgit2 in it (measured at
  `docs/trail/sdd/self_answer-33.md` § 5.3 and not re-run for this revision). The three names
  are a floor: a framework API that reaches the network is C-R7's scan's to find. The read's
  pattern also does not match three symbols the release executable defines:
  `_git_socket_stream_global_init`, `_git_stream_registry_global_init` and
  `_git_transport_ssh_libssh2_global_init` (`nm` on the executable C-I3's transport-read
  sentences name as the second the read has met, the one that links the `nozoki_read_git`
  export; re-read on 2026-10-04 for version 33, where each of the three prints as a local
  defined symbol, `t`). That executable imports none of `connect`, `socket`
  or `getaddrinfo`. What the three functions do was not read, no network call behind them is
  cited, and the pattern is not widened for them (`docs/trail/sdd/cycle-26.md` § 5.3; RN-91;
  `docs/trail/sdd/cycle-28.md` § 5.1, RN-93). And the wall
  that holds NFR-8 is C-R2's; this read is the second line behind it. What follows a red read
  is § 11 R-15 (answered in the owner's seat, `docs/trail/sdd/cycle-21.md` § 5.3; RN-85). Every
  manifest that names `git2` turns its default features off, as
  `crates/nozoki-core/Cargo.toml:L9` does. `crates/nozoki-bridge/Cargo.toml:L23` names `git2`
  with default features off, from the change that built the search-path switch (§ 3, the
  `core-bridge` row; landed at `nozoki@392177d`, read at `nozoki@a7834f4`; RN-91).
  A line with defaults on would turn HTTPS and SSH on for both crates: "When a dependency is
  used by multiple packages, Cargo will use the union of all features enabled on that
  dependency when building it"
  (https://doc.rust-lang.org/cargo/reference/features.html#feature-unification) (RN-87). Each
  dependency's licence rides into `THIRD_PARTY_NOTICES.md` (C-5). *Violated by:* a dependency
  added without an allowlist line, a lockfile not committed, a Swift package dependency, a
  libgit2 built with its `https` or `ssh` feature on, a manifest whose `git2` line leaves
  default features on, a shipped executable that defines a
  libgit2 transport symbol or imports `connect`, `socket` or `getaddrinfo`.
- **C-R7.** **The shell holds no I/O of its own, and reaches the core through the exported list
  alone.** `nozoki-mac` reads no file, opens no connection, spawns no process, hands no URL to
  another program and imports no web engine. The forbidden set: `WKWebView`, `WebView`,
  `JSContext`, `NSAttributedString` initialised from HTML or with the `.html` document type,
  `URLSession`, `NSURLConnection`, `Process`, `NSWorkspace.open`, `NSSharingService`, `FileManager`
  reads, `Data(contentsOf:)`, `String(contentsOf:)`, `dlopen`, and `Bundle.main` reads outside
  `Contents/Resources`. Every byte a surface shows crossed SM-4. **A build exports to the shell
  exactly the functions its landed changes built**: `cargo test --locked -p nozoki-bridge --test
  exports` holds set equality between the C symbols `libnozoki_bridge.a` exports (`nm -gU`, the
  `nozoki_` prefix) and the functions the generated header declares, and holds that set inside
  SM-4's list and `nozoki_free`; it reads the exported set and never a hand-kept copy. From
  `v1.0.0` the set is SM-4's list whole and `nozoki_free` (§ 6 S-11, C-I6). So a function no
  landed change has built is never exported, and two slices that each export a function apart from
  one another meet at one set when their changes are joined. A change has built a function when
  the bridge function exists and delegates to an operation `folder-model`'s API carries (SM-5).
  The export follows the change and not the slice, because a slice is built across one or more
  changes and each share of it is worth something on its own (§ 8, the *Delivers* row): a share
  that shows something through a function shows nothing until the shell can call that function
  across SM-4 (answered in the owner's seat, `docs/trail/sdd/cycle-17.md` § 5.1; RN-76). **`nozoki_free` is the one export
  beside the list**, admitted because every call's return is an owned buffer it alone releases
  (SM-4); it is not a command — it never reaches the model over SM-5, so C-I3's "every command the
  build grants" does not name it, and its misuse is § 11 R-13's case. No second plumbing export —
  a registration call for `model_changed`, or any other — is admitted by this sentence: one is
  raised, on this condition and SM-4, by the slice that needs it, and not before (the owner's
  confirm with additions, `docs/trail/sdd/cycle-12.md` § 5.1; RN-66). `checks/view.sh` scans `nozoki-mac/Sources` for the forbidden set and runs
  `otool -L` on the built executable, which names neither `WebKit` nor `JavaScriptCore`. **What
  this is and is not:** a source scan and a link check, run on every build — a reviewer is
  *shown* that the shell adds no I/O — and not a process boundary: the wall is C-R2's, and this
  condition keeps the shell inside it rather than raising a second wall (§ 9 TO-1). **Not covered
  before `v1.0.0`:** a later change that stops exporting a function an earlier slice built passes
  this check, because the export and the header move together; only that slice's own bar holds the
  function until C-I6's pin exists — C-6's pre-1.0.0 half, stated rather than tested (§ 11 R-12)
  (NFR-16, NFR-8). *Violated by:* a symbol exported that the header does not declare, or declared
  and not exported; an exported function outside SM-4's list and `nozoki_free`; a forbidden symbol in
  `nozoki-mac/Sources`; `WebKit` or `JavaScriptCore` on the executable's link list; a Swift package
  dependency; a view that reads a file, opens a connection or spawns a process by an API the scan
  does not name — the scan is the check, and the first sentence is the rule.

**Instrumentation and failure visibility.**

- **C-I1.** Every read is an `Item` with an `ItemState` (§ 3), and a failure is a state, not an
  exception: a failure to read one file, one entry or one part of Git state yields `failed` or
  `stopped` on that item and changes no other item, and the next successful read of the same
  item replaces it without ceremony (NFR-3; `docs/UXD.md` UX-I10, UX-I16). Each sibling of that
  item holds the state its own read gave it: `observed`, `pending`, `failed` or `stopped`. The
  entries already listed under an expanded folder are not that folder's siblings, and what a
  failed re-read of the folder does to them is not decided by this condition (*Open Questions*,
  the failed-re-read item; RN-89). `stopped` is
  established in two places (§ 3, *What the system holds*): by the model, on an item it holds;
  and by `mac-shell` at SM-4's return, where a call's answer is read, when that return carries no
  verdict — the bridge's failure value after a panic it caught at the boundary, or a buffer that
  does not conform — on the item the call was for. A panic caught at the boundary and answered
  with the failure value is a state under this condition, and a panic that reaches the host stays
  a violation (answered in the owner's seat, `docs/trail/sdd/cycle-19.md` § 5.1; RN-82). No
  surface draws a marker, a count or a "nothing changed" from an item that is not `observed`
  (UX-I13). *Violated by:* a read path with no item state, a panic that reaches the host, a
  marker drawn from `pending`.
- **C-I2.** The product's only diagnostic output is one log file at
  `~/Library/Containers/com.kensaiapp.nozoki/Data/Library/Logs/nozoki.log` — the app's own
  container, which is where the sandbox places the product's writable data — holding one line per
  `failed` or `stopped` item naming the part, the operation and the error text; never file
  content, never a path outside the folder's own entries, never transmitted. A launch creates it
  or truncates it; within a session it is bounded to 1 MiB on disk, past which it is emptied and
  writing continues; a failed write surfaces nowhere, stops nothing and is not retried (NFR-11).
  No internal text — no stack trace, error code or library name — reaches any surface; every
  message a surface shows is a whole sentence from `surfaces`' catalogue (UX-I6). *Violated
  by:* a second log, a line carrying content, a diagnostic on a surface, a log outside the
  container.
- **C-I3.** **The promises are proved on every build, from the first slice's first green build.**
  `checks/read-only.sh <fixture>` hashes a fixture (`.git` included where there is one), exercises
  every command the build grants (C-R7) through SM-5 in-process, hashes again, and prints `unchanged` or the
  differing paths — the plain-folder criterion "no `.git` and no entry of any kind has appeared"
  (AC-24) is the same hash; `--kill` sends SIGKILL to the host mid-churn and re-hashes (NFR-4).
  The unit is the build: a build that exports a command has that command's operation on SM-5, so
  the walk calls it in that same build, and no test of a slice's own stands in for
  `read-only.sh`. Two things no check holds: nothing in the build compares the calls the walk
  makes with the set the build exports, so their match is held by review of the change that
  exports a command, until a change makes it a check; and a fixture that offers no entry a
  command can act on exercises nothing for that command — which fixture a command needs is its
  slice's own bar (§ 6) (`docs/trail/sdd/cycle-17.md` § 5.1; RN-76). A third thing no check
  holds, from the config search-path switch (§ 3, the `core-bridge` row): `nozoki-core`'s
  in-process Git suites run without the bridge, and so with the machine-level config reads on.
  An answer there can differ from the bundle's on a machine with a global ignore file. The
  change that built the switch isolated nothing (`nozoki@392177d`). Those suites still run with
  the reads on: `grep -rn 'set_search_path\|search_path' crates/nozoki-core checks` prints
  nothing at `nozoki@a7834f4`. The read-only walk is a third caller with the reads on:
  `checks/walk.rs:L292` calls `read_git` with the libgit2 adapter and no switch. So
  `checks/read-only.sh`'s `unchanged` on a Git fixture is shown for libgit2 as the harness
  configures it. The bundle configures it differently, and no check runs the hash with the
  reads off. The answers the bundle serves are proved in the bridge's suite, after the switch
  has run: `crates/nozoki-bridge/tests/git_item.rs` reads through the production-wired session
  (`:L1-L2`) and `tests/read_git_export.rs` through the exported call (`:L1`). Isolating the
  core suites and the walk is not designed here. It is the CTO's call, and it is raised by the
  first measured difference: a suite answer or a `read-only.sh` hash that differs between the
  two configurations. None is cited at this revision
  (`docs/trail/sdd/cycle-22.md` § 2.1, RN-87; `docs/trail/sdd/cycle-26.md` § 5.2, RN-91).
  `checks/no-network.sh` diffs `cargo tree` against `deps.allow`, and fails where
  `nozoki-mac/Package.swift` declares a dependency or a `Package.resolved` exists (C-R6).
  `checks/view.sh` carries C-R6's transport read beside its link check: `nm` on the release
  executable, red on a defined libgit2 transport symbol or on an import of `connect`, `socket`
  or `getaddrinfo`, and red where `nm` is missing, fails or prints no symbol. The read is in
  the script from the build at `nozoki@392177d` (`checks/view.sh:L379-L404`), with its suite
  cases (`checks/tests/test_view.sh:L58-L64`). The claim is proved for each executable the
  read has met, and for no later one until the read meets it. It has met two. The first is the
  release bundle built at `nozoki@0aab3e7`, on which `checks/view.sh` exited 0
  (`docs/trail/sdd/self_answer-38.md:L26-L27`). `nm` on that executable, read on 2026-10-04
  for version 31, printed `_git_repository_open_ext` and `_git_status_list_new` among 781
  defined `_git_` symbols (`awk 'NF==3 && $2!="U" && $3 ~ /^_git_/'` over the `nm` output,
  counted), no `git_smart_subtransport_` symbol, and no undefined `_connect`, `_socket` or
  `_getaddrinfo`. It held no `_nozoki_read_git`, and no Swift source called the export then
  (RN-91). That executable is no longer on disk and was not re-read for version 33. The second
  is the first executable that links the `nozoki_read_git` export. From `nozoki@129586e` the
  shell calls it (`nozoki-mac/Sources/Nozoki/NativeBridge.swift:L26`). The measurement was
  made at `nozoki@cfcbedf`, whose tree outside `docs/` is the tree at `nozoki@129586e`
  (`git diff --quiet 129586e cfcbedf -- . ':!docs'` exits 0): `nozoki-mac/assemble.sh` exited
  0, and `checks/view.sh` exited 0 on the bundle it built, printing "38 Swift files scanned"
  and "links no WebKit or JavaScriptCore and carries no Git transport — nothing found"
  (`docs/trail/sdd/self_answer-40.md:L25-L43`). `nm` on that executable, re-read for version
  33, prints `T _nozoki_read_git`, `_git_repository_open_ext` and `_git_status_list_new`, 781
  defined `_git_` symbols by the same `awk` command, no `git_smart_subtransport_` symbol, and
  no undefined `_connect`, `_socket` or `_getaddrinfo`. So the read has met the executable
  that links the export, and it passed. Both reads ran on the owner's machine. No hosted
  runner has read the second build: `git status -sb` prints `main...origin/main [ahead 216]`
  at `nozoki@cc3a63f`, `gh run list --commit 129586e` prints nothing, and the newest run
  `gh run list` shows is dated 2026-10-02. CI runs the same script after `assemble.sh` on
  every push (`.github/workflows/ci.yml:L41`, `:L51`). A red read on any later build is
  § 11 R-15
  (`docs/trail/sdd/cycle-21.md` § 5.3, RN-85; `docs/trail/sdd/cycle-26.md` § 5.3, RN-91;
  `docs/trail/sdd/cycle-28.md` § 5.1, RN-93).
  A `nozoki-bridge` test asserts that the search path of each of the four machine config levels
  — system, global, XDG, programdata — is empty once the composition root has run (§ 3, the
  `core-bridge` row). The test proves the four paths are empty and observes no read: the step
  from an empty path to no file touched is `sysdir.c:L559-L560` in the registry copy of
  `libgit2-sys 0.18.8+1.9.7`, read and not run. The switch and its test are in the tree from
  the change that wired the libgit2 adapter in the bridge (`nozoki@392177d`):
  `crates/nozoki-bridge/src/machine_config.rs`, and the read-back case at
  `crates/nozoki-bridge/tests/search_path.rs:L36`. So no build opens a repository through the
  bridge with the reads on
  (`docs/trail/sdd/cycle-22.md` § 2.1, RN-87; `docs/trail/sdd/cycle-26.md` § 5.2, RN-91).
  `checks/bundle.sh` reads `codesign -d --entitlements :- Nozoki.app` against the set C-R2's rule
  admits, as the script's expected set records it — set equality, the expected set widened only
  by a change reviewed against the rule (drafted on the companion's § 2.3, RN-61) — then launches the
  bundle and takes the pid of the main process this run started — found by its absolute executable
  path, with no instance of it running beforehand. It then asks the operating system about that
  pid within a bounded window after launch, and it fails unless one ask inside the window reports
  the pid as sandboxed **and** reports two operations denied for it: a file read outside the
  grant and an outbound network connection. The pass is the first ask on which all three hold at
  once. The bound is the script's to fix and this document states no number; the script prints
  the bound in the probe's output, so a red run that ends because the window ran out says how
  long it waited — and that is the only red run the bound reaches. A run ended by a failed ask —
  `sandbox_check` missing or returning an error, or the pid no longer naming a process — ends at
  once and names what failed; it prints no bound, because the bound exists to separate "waited
  the whole window and the wall is absent" from "gave up early", and a run that stopped on a
  named failure did neither. Every ask first checks
  that the pid still names a process, because `sandbox_check` answers "sandboxed, everything
  denied" for a pid that names none (`checks/sandbox_probe.rs:L103-L115`); a process gone before
  the pass is a failure, and it ends the run on that same failed-ask path. Two cases the window
  does not cover: a report that turns from `yes` back
  to `no` after the pass is never read; and the failed-ask line does not say on which ask the run
  ended, so a process that dies does not say whether it died at launch or late in the window —
  the line names the failure and nothing about its timing. The sandboxed report is the state Apple names as the
  verification — "verify that the value in the Sandbox column is Yes"
  (https://developer.apple.com/documentation/security/protecting-user-data-with-app-sandbox) — and
  the two denials test the wall C-R2 promises rather than a proxy for it where the unentitled
  control reports them allowed. On a GitHub-hosted macOS runner that holds of the outbound half
  only: there the out-of-grant read is reported denied for the unentitled control on every ask as
  well, so on the runner the wall is evidenced by the sandboxed report and the outbound denial, and
  the read denial separates nothing. Why the runner reports it that way is not known, and whether
  the one Mac measured reports that read allowed for the control is not recorded (RN-48). The
  script reads the state through libSystem's `sandbox_check`, which is exported but is not
  declared in the SDK's `sandbox.h`: **the mechanism is undocumented, and is held as such.** So a
  negative control is part of the probe: the script's suite runs it on the same binary built with
  no entitlements and requires it to answer `sandboxed: no` on every ask for the whole window, and
  a probe that cannot tell the two apart goes red instead of green. The control's red run ends
  at once on the first report that is not `sandboxed: no`, so no red run of the control ends
  because its window ran out, and of the control's lines only its pass line prints the bound —
  the same scoping as the ordinary path's. The build also fails when
  `sandbox_check` is missing or returns an error on any ask, when no pid is found, or when more
  than one is. A container directory that already exists is never evidence, because it survives
  from an earlier launch. The environment marker this probe first read, and why it was dropped,
  is § 10 RC-1; the hosted runner, measured on 2026-09-23, is RN-48. The harness drives
  `nozoki-core` and SM-4's list through SM-5, **not the AppKit views**: no UI driver is built —
  driving AppKit from outside the process runs through the accessibility surface UX-A1 disclaims,
  and an XCUITest target needs an Xcode project this product does not keep — so the views'
  whole-product check is the timed release walk (AC-10), and the shell's actual use of the bridge
  is covered by its holding no I/O of its own (C-R7; § 9 TO-7).
  **The shell's run is proved on the shipped bundle, beside the wall** — the owner's ruling
  (`docs/trail/sdd/cycle-8.md` § 5.1, answer 4), because a bundle passed every gate above and
  opened an empty window (§ 10 RC-2); the ruling names no renderer, so it binds the native shell
  as it bound the page. `checks/renderer.sh Nozoki.app` launches the bundle CI built, as a user
  launches it, takes the pid the way `checks/bundle.sh` does, and within a bounded window of the
  same kind fails unless the launched main process is observed **parked in the Open panel's modal
  run, inside the shell's launch frames** — the shell's first and only unconditional act,
  presenting the Open panel at launch (C-R3) and parked in it until someone answers. `open_folder`
  is not among those frames: the shell calls it only after the panel returns
  (`nozoki-mac/Sources/Shell/LaunchFlow.swift`, `chooseFolder()` and `openAndList(_:through:)` —
  `:L54-L60` and `:L69` at `nozoki@7c7038f`), and the gate sends no input, so an
  observation inside that call would need a code path this clause forbids below. The frame list
  is the script's header's (`checks/renderer.sh`, header § *THE FRAMES* — `:L53-L56` at
  `nozoki@7c7038f`) and is not copied here, the way the
  probe's bound is the script's. This is not the harness driving the views: it is the
  operating system's or the process's own report that the shell ran far enough to present the
  panel. The mechanism measured on one Mac, for the previous renderer, was a thread sample of the
  launched pid showing the command's frames — present exactly where the window drew and absent
  where it did not (`docs/trail/sdd/cycle-8.md` § 5.1, the sample table); the frames the native
  shell shows were measured on the first slice's first built bundle and are recorded in the
  script's header (`checks/renderer.sh`, header § *THE FRAMES* — the list at `:L53-L56` and the
  Mac reading at `:L57-L60`, `nozoki@7c7038f`), and the script fixes which mechanism it reads.
  What it may never read is a marker the product writes for the check, an
  environment variable, or a code path that exists for the gate: the shipped bundle is the
  artifact under test and holds nothing for the test. The gate's negative control is a bundle the
  harness owns, not a build removed from the product — a single-process shell has no renderer
  build to remove: `checks/fixtures/idle-shell`, an AppKit executable that opens one window and
  never presents the panel, signed and entitled as the product is (the shape the empty window
  took), which must go red. It runs on every CI build after `checks/bundle.sh` and never instead
  of it: a wall proven on a bundle whose window never draws proved nothing a person could use,
  and a window that draws on a bundle the wall is not proven on is the shape unchosen (§ 5 step
  4, E-1). The observation was measured on the Mac (`checks/renderer.sh`, header § *THE FRAMES* —
  `:L57-L60` at `nozoki@7c7038f`, macOS 26.6.2)
  and on a GitHub-hosted macOS runner (GitHub Actions run 35988399477, image `macos-14-arm64`
  20260831.0302.1, macOS 14.8.9 — inside the C-R5 floor's major): the runner matched the script's
  frame list on observation 1 and its control was not matched on any of 30 — a match of the
  list the gate reads, not a comparison of full stacks, which only the Mac reading recorded. The
  list held five frames at that run (`nozoki@37a962d`) and holds four since `nozoki@b75348f`
  (2026-09-27), which removed `LaunchFlow.run()` from it; the four-frame list matched on the same
  runner image at run 36795836747 (`nozoki@702f7c4`, 2026-10-01), again on observation 1 with the
  control matched on none of 30 (RN-76). A
  runner image or macOS whose Open-panel frames read differently turns the gate red on the next
  build, because the gate runs on every build; that is a re-cut trigger on the gate's mechanism,
  never on the gate.
  The record is ADR-0010; the renderer gate's own record is ADR-0012 — its status is the index
  row's (`docs/adr/README.md`, its row) and this line states none — whose mechanism, control and
  observable's name are re-derived from this clause as it now reads (RN-61; confirmed with the
  owner's addition, RN-64). *Violated by:* a build that skips a script, a bundle probe run without
  its negative control, a probe that reads the report once, an ask judged on a pid that no longer
  names a process, a control passed on fewer asks than the window, a bound not printed on a red
  run that ended because the window ran out or on a pass, a failed-ask run that does not name
  what failed, a renderer gate skipped or run without its control, a renderer-gate observation
  read from anything the product wrote or from a path that exists for the gate, a build
  that exports a command the harness does not exercise (a command is a call on SM-4's list, driven
  through SM-5; `nozoki_free` is the seam's release call and no command — it never reaches the
  model, so this clause does not name it, and its misuse is § 11 R-13's: C-R7, RN-66), a build that
  exports a function reaching `git-reader` with no transport read of its release executable
  (C-R6), a bridge that wires the libgit2 adapter with no search-path switch run before it or
  with no test of that switch (§ 3), a release
  without AC-1 – AC-3 green.
- **C-I4.** **A performance number is measured, never asserted.** `checks/latency.sh` prints
  file-switch and refresh p95 in milliseconds over reference fixtures on every CI build, so the
  figures the SRS folds in by revision exist from the first working build (NFR-1, NFR-2, NFR-10;
  `docs/SRS.md` RN-4). No threshold is written into any slice's bar until the SRS carries it.
  *Violated by:* a bar with an invented number.
- **C-I5.** **The floor's extension set, fixed here** (FR-29, AC-5): Python — `.py`, `.pyi`,
  `.pyw`; shell — `.sh`, `.bash`, `.zsh`; JavaScript — `.js`, `.mjs`, `.cjs`, `.jsx`; JSON —
  `.json`; YAML — `.yaml`, `.yml`; TOML — `.toml`; Markdown, rendered — `.md`, `.markdown`.
  Recognition is by extension alone, case-insensitively; a file with no extension or one outside
  the set is plain text (RN-7). The set grows only when the floor grows (FR-8). *Violated by:*
  content sniffing, a shebang read, an extension added without a floor language behind it.
- **C-I6.** **The priced contract is proved on every tagged release from 1.0.0, against the pin
  its major wrote.** `checks/contract/<major>` is written once, at the major's `.0.0` release,
  from the built bundle and `libnozoki_bridge.a` — the macOS floor as
  `LSMinimumSystemVersion` prints it, the release's asset names (`Nozoki-<version>.dmg`,
  `SHA256SUMS`), and SM-4's function list and `nozoki_free`, the set as the bridge exports it
  (C-R7) — and nothing else: no
  message, no token and no line of the log, which the contract excludes (§ 6 S-11 *Delivers*).
  `checks/contract.sh <tag>` takes the pin as `git show v<major>.0.0:checks/contract/<major>` —
  the tag anchors it, so an edit to the working-tree file cannot move what a release is held to —
  and fails when the bundle's floor is above the pin's, a pinned asset is missing from the
  release, or a pinned function is absent from the bridge's exports. It reads the priced set — C-R4,
  C-R5, and the surfaces' presence through SM-4 — and nothing of the unconditional set, which C-I3
  proves on every build; a new major writes a new pin, and that is the one change the check reads
  as legal (`docs/SRS.md` C-6; AC-14 "the version number obeys C-6"; C-11). Before `v1.0.0`
  there is no pin and the script is not run — C-6's pre-1.0.0 half, stated rather than tested.
  *Violated by:* a tag inside a major whose bundle, asset list or command list disagrees with the
  pin; a pin rewritten without a new major; a release offered with the script red.

**Identity, authorization and data protection.**

- **C-D1.** No identity exists — no account, no user record, no device identifier (NFR-7) — and
  authorization is the operating system's: the sandbox grant to the folder the user chose is the
  whole of the product's authority over it, and the product holds no other. *Violated by:* any
  identifier, and by any read outside the granted folder and the app's own container — an
  `lstat` or `realpath` taken to canonicalize a position outside the grant included, which is why
  § 3 `fs-reader`'s containment check compares spellings there and reads nothing (RN-71).
- **C-D2.** The only writes the product performs are `own-state`'s and C-I2's log, both inside
  the app's container; nothing is written under the granted folder under any operation, and
  nothing of the folder's content is persisted anywhere (NFR-5, FR-21, DR-1, DR-5; AC-13).
  *Violated by:* a write anywhere else, a cache, a lock file, an index.
- **C-D3.** **Content is untrusted input** (DR-6, NFR-16): rendering executes nothing and loads no
  active content; every path derived from content or from outside — a tree entry, a symlink
  target, an image reference, a relative link, an `asset_bytes` call — passes `fs-reader`'s
  containment check before any open, and `asset_bytes` re-runs it on every call. Three walls fail
  independently. **The containment check.** **The document is data:** `markdown-renderer` emits
  a `MarkdownDocument` whose node set is closed (§ 3), no node carries markup or a URL the shell
  fetches, raw HTML in the source is a text node, and the shell has no interpreter to hand a node
  to (C-R7: no web engine, no HTML import) — so "nothing executes" is a property of the type, not
  of a filter over markup. **Image bytes cross only as bytes, for a contained path**, and are
  decoded in the shell by the platform's own decoder (`NSImage`) for PNG, JPEG, GIF and WebP
  alone — a hostile bitmap's failure is the decoder's, inside the one sandboxed process, with no
  write and no connection for it to reach (C-R2; § 11 R-4). So a wall built wrong still moves no
  byte across the folder's edge (SM-7). SVG is excluded in v1: it is a document, not a bitmap —
  it can reference resources and carry script — and `NSImage` renders it as one (RN-8). An
  in-folder SVG therefore takes a placeholder stating that the format is one the tool does not
  render — UX-I12's "not an image" read as *not a bitmap format the tool decodes*, never as a
  file the tool could not read; the exclusion is a v1 cut with a stated reopening condition
  (RN-8). *Violated by:* an HTML or attributed-string import from content anywhere in
  `nozoki-mac`; a node kind outside `MarkdownDocument`'s set; an image decoded from bytes
  `asset_bytes` did not return; a path opened without the check; a `file:` or `http(s):` URL
  built from content and handed to any framework. **Not covered, and named so it is not read as
  coverage:** a path the repository's own config names, which libgit2 follows without this check
  (§ 11 R-16; RN-87).
- **C-D4.** `OwnState` holds the theme, the window frame, and beyond v1 the remembered folders
  (bookmark, display name, last-viewed mark, at most ten) — and nothing else (DR-5, UX-S7). It is
  read whole or discarded whole: a version that meets own state it cannot read opens as on first
  run, says nothing about it in the window, and touches no folder (C-6). *Violated by:* a new
  field with no line here, a partial read, a startup failure caused by own state.

**The experience conditions the UXD binds on every surface** — the CDO's clause.

These are the UXD's cross-surface entries — § 7 *Interaction Patterns*, § 8 *Accessibility
Requirements*, and the instance fence they cite — stated as conditions every slice in § 6 inherits.
None restates a per-screen cell of `docs/UXD.md` § 6: a screen's own states are what a slice's
*Reached when* cites one at a time (RN-33). Each names the UXD entry it serves and what would violate
it; the words a surface shows are `docs/CONTENT.md`'s and every token value is `docs/DESIGN.md`'s,
and no condition here fixes either.

- **C-E1.** **Nothing is drawn before it is observed.** No surface shows a marker, a count, a
  "nothing changed", a progress treatment that advances, or an empty Git view from a state the tool
  has not established; where it does not yet know, the surface shows pending, and the Git view's
  three states — pending, nothing, and the unexplained fault — are three different observations
  and are never drawn alike (`docs/UXD.md` UX-I13, UX-I17; the instance fence
  `system/experience/visual_restrictions.md` § `no-unestablished-state`). C-I1 carries the state
  mechanism. Beside it, a surface may draw that an intent it raised has not been answered yet,
  under the exception and all four bounds in § 3's `surfaces` row; that gap is not an `ItemState`
  (answered in the owner's seat, `docs/trail/sdd/cycle-19.md` § 5.1; RN-83). This is the surface's
  half of the same rule. *Violated by:* a marker drawn from
  `pending`, an empty Git view standing in for `stopped`, a spinner that moves on a timer.
- **C-E2.** **The reader's place survives every refresh.** Expanded nodes, the open file, the
  sidebar mode and the reading position hold through every update the reader did not ask for; only
  what actually changed changes; an update arrives with no notification, flash or attention bid;
  and what is shown is the folder's current state or is marked as no longer there — never stale
  content presented as current (UX-I2, UX-I3, UX-I4). *Violated by:* a refresh that collapses a
  node, re-opens one the reader collapsed or resets a scroll position, a toast on change, a vanished file still shown as present, a
  manual refresh control.
- **C-E3.** **A failure is scoped to its item and carries its route out.** A slow or failing read
  degrades only its own presentation and the shell never blocks; a failure or refusal — observed or
  unexplained — is shown in the failure slot of the item it belongs to, on that surface, with an
  enabled route out on the same surface; the unexplained fault shows that the work stopped and
  nothing more, and no control reveals, expands or copies its detail, and no message asks the reader
  to report it (UX-I10, UX-I14, UX-I16; the fence § `failure-says-what-next`). C-I1 and C-I2 carry
  the mechanism and the log. *Violated by:* a modal, a toast, a blocking spinner, a "copy details"
  or "show log" control, a channel this instance does not staff standing alone as the route.
- **C-E4.** **Every message carries what the tool did, what it observed, and what to do next —
  or that there is nothing to do.** The third part takes one of the two forms `docs/CONTENT.md`
  fixes (§ *Voice*, the *Terminal* row; § *Message patterns* → *Error — an observed condition*,
  the formula's third part): one thing the reader can do next, or that nothing can be done and
  what ends the wait. Where no wait ends it, the message says the condition stands and the route
  out is the surface's own, named in the sentence only where it is not already on screen (UX-I14;
  that formula's closing sentence) — the not-text file is the precedent, the tree as the way on
  (`docs/CONTENT.md` § *Tone*, "A file that cannot be shown as text"), and § 11 R-3's Git item is
  the second case (RN-43). Never a cause the tool did not observe and never internal text
  (UX-I6); the wording is `docs/CONTENT.md`'s (§ *Message patterns*) and the catalogue is C-I2's.
  A path the containment check refuses is one thing the tool observed: the spelled path left the
  grant and no spelling § 3 `fs-reader` accepts brought it back, and nothing was read past that
  point. So a tree row, or an image's placeholder, for a refused path carries `docs/CONTENT.md`'s
  one outside sentence (§ *Message patterns* → *Partial*, "outside the folder you opened") — for
  the three spellings § 3 names as refused although they may lead in as much as for a path that
  does lead out. For those three the sentence is wrong about where the link leads; that is the
  owner's call (`docs/trail/sdd/cycle-15.md` § 5.1) and the price of C-D1, and no observable half
  in § 6 tells them from a true outside, because someone watching the surface cannot without the
  read the tool does not make. No further sentence exists for them: a wording is
  `docs/CONTENT.md`'s to change, never this document's (RN-72).
  *Violated by:* a message naming a cause the tool inferred, a string that is not a catalogue
  sentence, a next step named where the tool observed that nothing can be done, a sentence written
  for a refused-though-inward spelling that the catalogue does not carry.
- **C-E5.** **Read-only is the identity, not a mode.** No editing affordance exists, enabled or
  disabled; no framing implies an editable mode elsewhere; no undo or confirmation model exists;
  closing asks nothing; the only state the reader can change is the tool's own preferences, each
  reversible by the control that set it (UX-I1, UX-I5, UX-I7). *Violated by:* a disabled Save, a
  confirm dialog, a prompt at close, an "initialise a repository" control anywhere.
- **C-E6.** **The plain folder is a working state.** Where the tool has found the folder is not a
  repository's root, the Git view is present and shows nothing — no message, label, explanation or
  control — the tree carries no markers, and every other surface is exactly as in a repository; a
  repository appearing or leaving mid-session fills or empties the view as any change arrives
  (UX-I17). *Violated by:* a sentence in the empty Git view, a hidden Files/Git switch, a marker in a
  plain folder's tree.
- **C-E7.** **Every surface renders whole, offline, on a stock machine.** No font, icon, image or
  stylesheet is fetched from any origin at runtime, and nothing a surface needs to be read depends
  on what the reader's machine is not known to have (UX-I15; the fence § `no-runtime-remote-asset`,
  § `no-author-only-surface`). C-R1 (every asset ships inside the bundle; fonts are the
  platform's), C-R2 (the one process holds no network entitlement) and C-D3 (no URL built from
  content reaches any framework) make it structurally true; C-R7's scan shows the shell adds no
  fetch of its own. *Violated by:* a web font, an icon from a CDN, a glyph the tool does not ship.
- **C-E8.** **No meaning by hue alone, and no control by glyph alone**, in both themes: every state
  distinction carries a letter, word, shape or position that survives without colour, and every icon
  sits beside a text label or has a text form the surface shows; the contrast floor is the number
  `docs/DESIGN.md` § *Colors* states, and no surface falls below it. All of it sits inside UX-A1's
  stated posture — mouse-driven, no keyboard model, no assistive-technology promise — and no surface
  claims beyond it (UX-A1, UX-A2, UX-A4, UX-I8). **A status letter's expansion is raised by the
  letter and by nothing else**: it is drawn as `docs/DESIGN.md` § Components, "The tooltip",
  draws it, in the words `docs/CONTENT.md` § Accessibility of text gives, and no other element
  raises a tooltip (`docs/trail/sdd/cycle-30.md` § 5.2; RN-95). *Violated by:* a staged/unstaged
  distinction told by colour only, an unlabelled icon, a shortcut a surface advertises, a
  conformance a surface claims, a status letter drawn with nothing that expands it, a tooltip
  raised by anything that is not a status letter.
- **C-E9.** **Two themes, equal, from the platform, remembered.** Dark and light are both
  first-class and equally maintained; the initial theme follows the platform's appearance, light
  where no signal can be read; the reader's override is remembered in the tool's own state and
  never in the folder (UX-I9). The tokens are `docs/DESIGN.md`'s and the storage is C-D4's.
  *Violated by:* a surface styled in one theme only, a value written outside the tokens, a theme
  file in the folder.
- **C-E10.** **Public surfaces tell the same truth as the product.** A README screenshot, or any
  picture of the shell, shows the product as it currently is, and a mismatch is a defect checked
  at release; the posture UX-A1 states appears in the README, not on its first screen (UX-I11,
  UX-A3). *Violated by:* a mock-up in the README, a screenshot of a release that is not the one
  shipped, a first screen that carries the posture sentence.

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

**Applied to nozoki — the list.** *Now* is nothing built: at this run's start the product root
holds `docs/`, `README.md`, `scripts/` and `third_party/` and no source (`ls` of the product root,
2026-09-03). The entries are made from the PRD's use cases and features and from the Agari's three
conditions, each tagged with its source; § 3's parts are not consulted. The CPO holds the entries
and the CDO holds that each is genuinely observable; an entry the CDO bounces is rewritten or
struck by the CPO. Step 2 is applied to this list after that read.

- **E-1** — After this, a developer can start Nozoki on their Mac against one local folder —
  supplied at start, nothing else asked — and see that folder's tree in a single window with the
  reading panel empty and prompting a selection; pointed at a path that does not exist, is not a
  folder, or cannot be read, they see in that window what went wrong and what to do next. *(PRD
  § Key Use Cases 1; § UX Notes "The path" 1, "Failure states"; § Success Metrics "Zero required
  configuration")*
- **E-2** — After this, a developer can select any file in the tree and read it: highlighted in
  the six floor languages, as plain text for any other text, and as a stated cannot-display state
  for a file that is not text — and nothing they do in the panel changes the file or the folder,
  and closing asks nothing. *(PRD § Key Use Cases 1; § Core Features "Read-only viewing"; § UX
  Notes "The path" 2 and 5, "Failure states")*
- **E-3** — After this, a developer can read a Markdown file rendered, with nothing executed and
  nothing fetched from outside the folder — an image inside the folder shown in place, one outside
  it a stated placeholder. *(PRD § Core Features "Markdown is rendered by default"; § Data &
  Privacy)*
- **E-4** — After this, a developer can switch the sidebar to Git and see — where the opened
  folder is itself a repository's root — the branch, the changed files, the staged files and the
  short status, with changed files marked in the tree, a mid-merge, mid-rebase or detached
  repository shown as the state it is in, and a changed file's row opening that file to read;
  where the folder is not a repository's root — a plain folder, a folder inside a repository, a
  folder holding repositories — the Git view is present and shows nothing, and the tree carries
  no markers. *(PRD § Key Use Cases 2 and 4; § Core Features "Git view", "Git is read only when
  the folder opened is itself the root"; § UX Notes "the view never lies")*
- **E-5** — After this, a developer can leave Nozoki open while an agent changes the folder and
  watch the tree, the open file's content and the Git state follow the disk on their own — within
  the refresh bar, with no refresh control, their expanded nodes, open file and reading position
  kept, a vanished open file said to be gone, and nothing crashing or writing however fast the
  folder moves; a repository appearing at the root mid-session, or leaving it, fills or empties
  the Git view the same way. *(PRD § Key Use Cases 3; § Core Features "Live refresh"; § UX Notes
  "The path" 4, "the view never lies"; § Success Metrics "Refresh immediacy")*
- **E-6** — After this, a developer can switch between a dark and a light theme from the shell
  chrome, the first theme following the platform's appearance, and find the choice remembered at
  the next launch — kept in the tool's own data location, nothing of it in the folder. *(PRD § UX
  Notes "The character"; § Data & Privacy)*
- **E-7** — After this, a stranger can find Nozoki at `github.com/kensaiapp/nozoki`, install it
  by the one path the README's first screen names, and be reading a file of their own repository
  within five minutes — the README stating what the tool will and will not touch, the support
  posture, what is outside done, the MIT licence and what the version number promises, and a
  SECURITY.md naming where to report. *(PRD § Goals "Pick-it-up adoption"; § Assumptions
  "Licence", "Public identity", "Support posture", "Versioning"; Agari, third condition)*
- **E-8** — After this, a reviewer at a release can show — not be told — that exercising the
  whole surface against a repository and against a plain folder left both byte-identical, the
  repository's Git state identical, and no outbound traffic sent. *(PRD § Success Metrics
  "Read-only integrity"; § Risks "The promise breaks incidentally"; Agari, second condition)*
- **E-9** — After this, a developer can open a changed file's diff from its row in the Git view,
  in the reading panel, staged changes distinguished from unstaged — the file itself still read
  from the tree. *(PRD § Scope (In) full ambition "diffs"; Agari, first condition; beyond v1)*
- **E-10** — After this, a developer can open the commit history from the Git view — branches
  drawn as branches where more than one exists, against a chosen branch set whose default asks
  nothing — see each commit's identifier, message, author and date, and open any commit's diff.
  *(PRD § Scope (In) full ambition "commit history"; Agari, first condition; beyond v1)*
- **E-11** — After this, a developer can switch the viewed folder without restarting — from the
  shell chrome, choosing one of the ten most recently viewed or browsing for another, a repository
  or a plain folder alike — and arrive at that folder's tree with the previous folder untouched.
  *(PRD § Scope (In) "one folder at a time is a v1 cut"; § Out of Scope "Changing the viewed
  folder without restarting"; Agari, first condition; beyond v1)*

**Not on the list, with the reason.** The Markdown raw-source switch and a relative link opening
its target are permitted, not required, and outside the terminus (`docs/PRD.md` § Core Features
"A switch to the raw source is permitted, not promised"; `docs/SRS.md` FR-31, FR-32) — an entry no
Agari claims; a slice that ships either at no cost says so in its own block, and it is never an
entry. Sidebar search and filter, pane resizing, keyboard navigation and a second platform are
outside done (`system/projects/nozoki/agari.md`, first condition). The immediacy thresholds are
measured from the first working build and folded into the SRS by revision (`docs/SRS.md` RN-4) —
a bar a slice's *Reached when* inherits, not a difference a slice delivers.

**The observability read — the CDO's clause.** Each of E-1 – E-11 was read against one question:
could someone who did not build it watch it happen on a surface the product has? All eleven pass,
and none goes back to the CPO. Three were weighed rather than waved through. **E-8** names no
graphical surface and passes anyway: the harness's output at a release is a surface, and *show, not
be told* — the folder byte-identical, the Git state identical, no traffic — is a result a reviewer
watches arrive, not a layer being ready (`system/projects/nozoki/agari.md`, second condition). What
it is at step 2 is the CPO's; this seat's expectation, stated as a view and not a strike, is that it
folds into every slice's *Reached when* as the promise clause rather than standing as a slice,
because a check with nothing yet exercised has nothing to show. **E-4** packs two conditions and is
one observation: one surface — the Git view — under a repository root and under a plain folder, and
the UXD draws the plain folder as a working state on the surfaces that already exist, never a
surface of its own (`docs/UXD.md` UX-I17; RN-29 (4)). Whether it is one entry or two at step 4 is
sizing, and not this clause's. **E-3**'s *nothing fetched* and **E-6**'s *nothing of it in the
folder* are negatives, and observable ones: a folder compared before and after, a network watched
for traffic — the surfaces E-8 names, one entry at a time. No entry is written from § 3's boxes:
none says a crate, a seam or a model exists (RN-30).

### Step 2 — Strike the fragments

Strike every entry whose only value is that a later entry needs it, and fold it into the entry that
gives it value. A cut that needs a later cut to be worth anything is not a slice but a fragment of
one — `<CORE>/roles/loaders/principal_pm_global.md` owns that rule, and this step is where it is
applied to a design rather than to a program.

This is the step that catches infrastructure built ahead of its subject. A checker with nothing to
check is not a step forward, however finished it looks.

**Applied to nozoki.** One entry is struck. **E-8** — the release-time proof that the whole surface
left the folder, the Git state and the network untouched — has no value of its own: its worth can
be stated only by naming the entries it exercises, which is this step's definition of a fragment,
and the harness that produces the proof stands from the first slice's first build (§ 4 C-I3), so
making it a slice would build nothing. It folds two ways: as the **promise clause of every slice's
*Reached when*** — the harness green over that slice's fixtures and the folder untouched, each half
written by the seat that holds it — and into `first-public-release`, whose *Delivers* names the
whole-surface run as the result a reviewer reads (RN-15). Every other entry keeps its value when
read alone: after each, someone can do something on the product's surface that they could not
before, and none needs a later entry to be worth having. Two were tested hardest. **E-6**, the
theme, reads as small enough to be a fragment of E-1 and is not: after it a developer holds a
preference that survives a launch, and that worth does not depend on any later entry — it is kept
apart from E-1 for the reason step 4 states. **E-1** alone — a granted folder and its tree with
nothing yet readable — is the entry nearest to "infrastructure ahead of its subject", and it is not
that either: a stranger can watch a folder open, its tree appear and a bad path explained, and its
result decides whether the wall holds at all (step 5), which is exactly the test a fragment fails.
Ten entries go to step 4.

### Step 3 — Separate dependency from preference

For every remaining pair, ask **can the later one be built at all without the earlier one?** — not
whether building it first would be tidier. A stated order is often a preference wearing a
dependency's clothes, and the two behave differently the moment the build slips: a real dependency
blocks, a preference reorders for free.

Record each answer as a typed edge in § 7, with the reason on the same row. An edge with no reason
is a preference that has been written down as a fact.

**Applied to nozoki — the entries as they stand.** Step 2 has not yet been applied (the CPO's);
the answers below are on step 1's list and will be re-read onto the slices once the cut is drawn,
where they become § 7's rows. Each is stated in the form the test demands — *B cannot exist without
A because \<fact\>* — and where the sentence needs "should" it is marked a preference.

- **E-2 cannot exist without E-1** because the file is selected from the tree the folder's grant
  produced; there is no other way to name a file (FR-5, FR-7). *Dependency.*
- **E-3 cannot exist without E-2** because rendered Markdown is a treatment of the reading panel
  E-2 opens, not a surface of its own (`docs/UXD.md` UX-I12, § 9). *Dependency.*
- **E-4 cannot exist without E-1** because the root finding is asked of a granted folder (FR-33),
  and **without E-2** because a changed file's row opens the file for reading exactly as a tree
  selection does (FR-13, first reading). *Dependency.*
- **E-5's filesystem clause cannot exist without E-1 and E-2** — there is no tree to follow and no
  open file to update — and **its Git clause cannot exist without E-4** because Git state has no
  surface to change until the Git view exists (FR-14). Whether the two clauses are one slice or two
  is step 4's (CPO); the edges hold either way. *Dependency.*
- **E-6 cannot exist without E-1** because the theme control lives in the shell chrome
  (`docs/UXD.md` § 4). Nothing else depends on it structurally — but see E-7. *Dependency on E-1
  only.*
- **E-7 cannot exist without E-1** (there is nothing to release) **and without E-6** because
  both themes are a first-release requirement, not a v1-eventually one (FR-20, AC-11).
  *Dependency.* That E-7 should wait for E-3, E-4 and E-5 is a **preference** — C-6 lets a
  pre-1.0.0 release ship less, and the Agari's third condition binds the *closing* release —
  and it is the CPO's to state, not this seat's. What is not a preference: the bundle, the
  entitlement list and the probe are proved from the first slice's first build (§ 4 C-I3), so
  E-7's *mechanism* is exercised long before E-7 lands.
- **E-8 cannot exist without every entry whose surface it exercises** — its own sentence says
  "the whole surface". The harness that produces the proof exists from the first slice (C-I3);
  what E-8 adds is the release-time run over the complete surface. Whether E-8 is a slice or the
  condition E-7 carries is step 2's question (CPO) — this seat notes only that its mechanism is
  not built at the end.
- **E-9 cannot exist without E-4** because the diff is opened from the Git view's row, and the
  row's behaviour is a system state that changes when the diff is present (FR-13, FR-17).
  *Dependency.*
- **E-10 cannot exist without E-4** because the history is entered from the Git view (UX-S6),
  **and without E-9** because a commit's diff uses the same presentation as a file's (FR-22).
  *Dependency.*
- **E-11 cannot exist without E-1** because switching replaces a folder that was granted (FR-19).
  Nothing else is a dependency: the selector could land second. That it lands **last** is a
  preference with a reason, recorded in step 5 and § 7 as `validates`, not `depends_on`.

### Step 4 — Size each one against a reached-when

A slice is the right size when someone who **did not build it** can check it is finished from the
outside. Write the *Reached when* before deciding the slice is settled — the size follows the
checkable bar, not the other way round.

- **Too broad** when a plausible intermediate result could change the slice's direction or its
  acceptance. Two answers are hiding inside one slice.
- **Too narrow** when its result cannot change what happens next. Nothing is learned by finishing
  it, so it is a task inside a slice rather than a slice.

Cut where the decision changes, not where the size is convenient.

**Applied to nozoki.** Each of the ten remaining entries is sized against the bar it will carry,
named here in one phrase; the bar's wording is § 6's — the observable half the CDO's, the command
half the CTO's. Where two entries could have been one slice, or one entry two, the reason the cut
fell where it did is stated. The result is eleven slices: ten from the entries, and one the Agari
names that no entry did.

- **E-1 → `open-a-folder`**, one slice. Bar: a folder chosen in the panel shows its tree in the
  window, a bad path and a dismissed panel show UX-S4, and the bundle CI ships carries the
  entitlements C-R2 fixes with the sandbox enforced — and draws that window under them. The two
  halves are one bar on one artifact, not two: a wall proven on a bundle whose window never draws
  proves nothing a person can use, and a window that draws on a bundle the wall is not proven on
  is the shape unchosen. Not too narrow — if the probe finds the wall absent, every later slice
  is redrawn (§ 11 R-8); a probe that fails while the wall stands redraws the probe and no slice,
  which is what § 10 RC-1 records; a window that does not draw while the wall stands redraws the
  entitlement list or the host's configuration (C-R2) and no slice — unless the mechanism found
  forces a shape § 2 rejected, which is § 10's to record. *That case arrived (§ 10 RC-2), and the
  owner answered it: the renderer leaves WKWebView (`docs/trail/sdd/cycle-9.md` § 1.1,
  2026-09-23). The slice is not resized by the answer — its bar is still one bar on one artifact,
  the wall proven on the bundle whose window draws, and the window drawn is now a native one; what
  moves is the part § 3 draws behind the bar, which is the CTO's, and the date the bar is first
  met, which is no slice's.* Not too broad — no intermediate result
  inside it changes its direction.
  *Re-read 2026-09-30, on the owner-seat answer at `docs/trail/sdd/cycle-16.md` § 5.1: the
  observable half now holds `docs/DESIGN.md` § *Layout* and § *Components* for the surfaces this
  slice draws — the window's minimum width with the reading panel taking what the sidebar leaves,
  the status messages top-left and glyph-led, the startup surface's routes as text alone. The
  sizing stands. Still one bar on one artifact: how the window is drawn is inside "the window
  drawn", not a second decision beside it — a window that opens with the panel narrower than the
  sidebar is this bar unmet, the way a window that does not draw is, and redraws no slice. Not too
  broad, because nothing found while drawing changes the acceptance: the drawing's values are
  `docs/DESIGN.md`'s (§ *Layout*; its RN-8), fixed there and cited here by section. And no slice
  is added for it: § 6 holds no slice whose decision is a surface's drawing, and `choose-a-theme`'s
  decision is own state — its bar is the two themes over surfaces already drawn (E-6, below) — so
  placing the drawing there would put two answers in one slice, the case this step names. RN-73.*
  **E-6 is not folded into it**, though FR-20 makes both themes a first-release condition: the
  theme is the first thing the tool ever writes, and the slice whose job is to prove the wall is
  kept free of any write at all, so that a red `read-only.sh` on it has one possible cause.
- **E-2 → `read-a-file`**, one slice. Bar: every AC-5 case reads as stated, and typing, pasting and
  dropping change nothing (AC-4). Highlighting and plain text are one decision — what the panel
  shows for a given extension (§ 4 C-I5) — not two.
- **E-3 → `read-markdown`**, its own slice, not a share of `read-a-file`. Bar: the hostile corpus
  renders with nothing executed, nothing fetched and the folder unchanged (AC-23), and an in-folder
  image renders in place. The decision it carries — that three walls hold against untrusted content
  — is one `read-a-file` never asks, so a merged slice would hide two answers: files read, Markdown
  not yet safe. *Under the owner's answer at `docs/trail/sdd/cycle-9.md` § 1.1 the decision's
  content moves — what "three walls" become under a single-process view with no script engine is
  C-D3's redraw, the CTO's, and this seat re-reads this sentence once § 2 is redrawn — but the
  sizing does not wait on it: the slice stays its own under any renderer, because the
  intermediate result named here — files read, Markdown not yet right — changes the acceptance
  whichever engine draws, and that is the whole of step 4's test.* *Re-read against § 2 and C-D3
  as redrawn, 2026-09-23: the three walls are now the containment check, the document as data,
  and the decoder fed by the check alone (§ 4 C-D3), and the decision is still one `read-a-file`
  never asks — a plain or highlighted file crosses no content-derived path, no image and no link
  — so the sizing stands. The one question the redraw leaves inside this slice — how TextKit lays
  out UX-I12's two hard cells (*Open Questions*, third item) — is not a second slice: it settles
  in this slice's first build, its result changes nothing that happens next outside
  `read-markdown` (step 4's too-narrow test), and the bar it answers to — UX-I12's cells — is the
  UXD's and does not move with the layout form found. RN-63.*
- **E-4 → `see-git-status`**, one slice, both conditions together. Bar: AC-6 and AC-18 on a
  repository; AC-24 on a plain folder; AC-25 on the three openings, the linked worktree and the
  submodule. The plain-folder half is not a slice of its own because it is the same decision
  answered the other way — the root finding says `plain` — and a Git view that can show a root but
  not stay wordless on a plain folder fails the view-never-lies rule; nor is it a fragment, since a
  plain folder already opens after `open-a-folder`.
  *Re-read 2026-10-01, on the observable half as RN-78 sharpened it: the half now has the reader
  scroll partway down the file a changed row opened before they switch back to Files, so that
  "the open file and their reading position are untouched" is a sentence they can watch fail. The
  sizing stands. The sentence was in the bar before and is the same sentence made checkable. It
  asks nothing of the root finding, which is this slice's one decision answered both ways, and no
  result of the scroll and the switch changes what the Git view shows on a repository or on a
  plain folder. RN-79.*
- **E-5 → `follow-the-folder`**, one slice, the filesystem and Git clauses together. Bar: AC-7,
  AC-8, AC-19 and AC-20, and the first latency figures printed. One decision is inside it — the
  reducer keeps the reader's place under churn — and the Git clause is that decision applied to one
  more kind of item, not a second decision.
  *Re-read 2026-10-01, on the observable half as RN-78 sharpened it and on the question RN-77
  left open: before the churn starts the half now has the reader expand some nodes, collapse one
  again and scroll partway down a file longer than the panel, and it adds that the collapsed node
  stays collapsed and the panel does not return to the top. The sizing stands. It is still one
  decision: the setup gives the reader a place for the reducer to keep, and the two added
  observations are that decision's failures made visible, not a second answer. The open question
  does not make the slice too broad either (*Open Questions*, the collapse-and-scroll item). How
  a collapse and a scroll reach the model is the form this one decision takes, and the observable
  half reads the same under each of the three forms listed there. Cut out alone, the question is
  a fragment by step 2: a model told where the reader is shows a person nothing until the folder
  moves. Two of the three forms leave the command half or SM-4's list unable to stand as written,
  and each of those is a re-cut that § 10 records before it is built. A re-cut of that kind moves
  the bar this slice is sized against, and this step is re-read with it. RN-79.*
- **E-6 → `choose-a-theme`**, one slice. Bar: AC-11 and AC-13 — both themes present, the choice
  remembered, and the only new file under the tool's own container. Small, and not too narrow: its
  result — that own state lands in the container and nowhere else — is what `switch-the-folder`'s
  remembered list rests on.
- **E-7 → `first-public-release`**, one slice, placed after the v1 cut and before the three
  beyond-v1 slices, as a release below 1.0.0. Bar: AC-10 on the floor's macOS, AC-14 on the
  release, and AC-1 – AC-3 green over the whole surface built so far. The alternative — one public
  release at 1.0.0 with the terminus whole — passes the four tests too; the choice between them was
  the owner's, raised at `docs/trail/sdd/cycle-1.md` § 3.1 and answered **keep**: the owner had already
  ruled it — "The first public release waits for the full v1 cut the PRD names, so the first thing
  a stranger meets is the product `docs/PRD.md` calls v1, not a partial" (the previous SDD's
  `cycle-1.md` § 3.3, quoted in the § 3.1 answer and bound to this run by the § 1.1 answer). So the
  placement is an owner decision, not this seat's preference: the release lands after the whole v1
  cut and at it — before the beyond-v1 three (RN-17).
- **E-9 → `read-a-diff`** and **E-10 → `read-the-history`**, two slices, not one. Bars: AC-12's
  diff clause; AC-12's history clause. The history carries a decision the diff does not — what the
  branch-set default draws, and how a graph is presented in the sidebar — so a merged slice would
  change its acceptance on an intermediate result (diff done, history not).
- **E-11 → `switch-the-folder`**, one slice, the selector and launch-restores-the-last-viewed
  together. Bar: AC-12's switching clause, to a repository and to a plain folder, and NFR-12's
  proof — the tree, the Git view and the panel untouched by the change that adds the selector.
- **One slice no entry named: `promise-one-point-zero`.** The Agari's third condition has two
  halves — public by the README alone, and at 1.0.0 with the promise in force — and
  `first-public-release` meets the first at a version below 1.0.0. The second is a product event
  the PRD names as one (`docs/PRD.md` § Assumptions "Versioning": "Reaching 1.0.0 is a product
  event") and carries its own work: the contract the number covers is declared, the pre-1.0.0
  caveat is withdrawn, and the closing walk is run over the terminus whole (AC-12). It is not a
  milestone restating its last task's completion, because after it an adopter can do something
  they could not: rely on the number. Bar: the release reads 1.0.0, the README states the contract
  and no longer says anything may change, AC-12 and AC-14 green (RN-16).

### Step 5 — Order by what each slice falsifies

**The first slice is the smallest reversible one that proves the shape** — not the foundation the
rest will need. A first slice sized to the whole architecture cannot be wrong cheaply, and being
wrong cheaply is the one thing a first slice is for.

After the first, every slice's place in the order carries a reason: what an earlier slice must have
settled for it, or what it de-risks for the later ones. A slice that could sit anywhere in the order
says so plainly; a number is not a reason.

**Applied to nozoki — the first slice, and the order this seat argues for.** The shape's whole
claim is the wall (§ 2, force 6): that a sandboxed, ad-hoc-signed bundle refuses the write and the
connection by construction, and that a shell holding no I/O of its own (§ 4 C-R7) can draw a
folder's window under that wall — the window drawing being, since § 10 RC-2, half of what the
first slice proves. **The first slice is E-1 alone, with the harness, the bundle probe and the
renderer gate green** — a granted folder, its tree, the reading panel empty, UX-S4 in the window,
`checks/bundle.sh` proving the entitlement set and the sandbox on the built bundle, and
`checks/renderer.sh` proving the panel presented under them. It is the smallest build that can be
wrong cheaply: if the sandbox
is not enforced under an ad-hoc signature (§ 11 R-8), that is found with one reader written and no
Git, no watcher and no Markdown to unpick; if it is, every later slice inherits a wall that has
already been shown. It is not too narrow by step 4's test — its result changes what happens next.
No Git code links in it: the root finding is not asked until a Git surface exists, so the first
slice's model holds `kind` as `pending` and never resolves it (RN-9).

After the first, the order this seat argues for — the CPO sizes and the cut may merge neighbours,
but the reasons survive a merge: **E-2** next, because reading is what every later surface is a
treatment of; **E-3**, because it is the first slice that renders untrusted content and so the
first that must prove C-D3's three walls — cheaper to prove on one treatment than on three;
**E-4**, because it is the first slice that links `git-reader` and asks `probe`, the one
mechanism the design expects to swap (§ 11 R-1); **E-5**, because it is the slice the product is
*for* (`docs/PRD.md` § Target Users) and the first that can produce a latency figure (C-I4) —
and because following a moving folder is the hardest thing the model does, it is placed where
the model is already exercised by three read surfaces; **E-6**, which could sit anywhere after
E-1 and is placed before the release only because FR-20 makes it a release condition; **E-7**
(with E-8 as its proof), which the CPO may place earlier under C-6 — this seat has no dependency
that forbids it; **E-9** then **E-10**, in dependency order; **E-11 last**, because it is the
one slice that adds an entitlement (C-R2) and so is the one that changes the wall — landing it
last keeps the entitlement list frozen through every release gate before it — and because it is
the slice that *validates* NFR-12 against the fullest viewing surface: the bar is that the tree,
the Git view and the reading panel are untouched by the change that adds the selector.

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

The eleven slices below carry the CPO's fields — *Slug*, *Delivers*, *Moves toward*, *Not in this
slice*, and the PRD clause of *Traces to* — as cut at § 5 steps 2 and 4. *Reached when* is the
CDO's observable half and the CTO's command half; *Rests on*, *Why here in the order* and the SRS
clause of *Traces to* are the CTO's; the UXD clause of *Traces to* is the CDO's. A slot marked for
another seat is filled by that seat in its turn. The slugs name deliveries and share no spelling
with § 3's parts. *Moves toward* names the Agari's conditions by number — **first**, the surface
complete as drawn; **second**, the promise held at every release; **third**, standing on its own,
public at 1.0.0 or later (`system/projects/nozoki/agari.md`).

### S-1 — A granted folder, its tree in the window

- **Slug:** `open-a-folder`
- **Delivers:** After this, a developer can launch Nozoki on their Mac, choose one local folder in
  the system Open panel, and see that folder's tree in a single window with the reading panel
  empty and prompting a selection — and, having pointed at a path that does not exist, is not a
  folder or cannot be read, or having dismissed the panel, see in that same window what happened
  and what to do next.
- **Reached when:** *Observable (CDO):* someone who did not build it takes the `Nozoki.app` CI
  built from the commit under test — the same bundle `checks/bundle.sh` and `checks/renderer.sh`
  ran on, carrying the entitlements it ships with, and never a build launched from the toolchain
  outside a signed bundle (the previous shape's dev-server window, `docs/trail/sdd/cycle-8.md`
  § 5.1's sample table, is one such) or a bundle re-signed by hand — and double-clicks it in
  Finder: the system Open panel appears with
  nothing typed and nothing asked. A window that opens and shows nothing — no panel, no startup
  surface, no response to a right-click — is this half unmet, whatever the command half reported
  (the reading `e7b2bcd` gave; `docs/trail/sdd/cycle-8.md` § 5.1). They choose a
  folder — a repository or a plain folder, they are not asked which — and one window opens: a
  sidebar holding the Files view alone, and a reading panel carrying one prompt to select a file
  and nothing else — no shortcut list, no watermark (`docs/UXD.md` UX-S1 Empty). The tree shows the
  folder's entries with text labels beside every icon (UX-A4); a folder not yet read shows that it
  is pending rather than as empty, and no marker of any kind is drawn anywhere (UX-S2 Loading,
  UX-I13); a folder with no files shows a stated empty-tree sentence, not a blank pane (UX-S2
  Empty); an entry that cannot be read is marked with what the tool observed and the rest of the
  tree stands (UX-S2 Error). They dismiss the panel instead: the window shows the startup surface
  with two routes — choose a folder, which presents the panel again, and leave — and no failure
  sentence, as many times as they repeat it (UX-S4 Empty). They point it at a path that does not
  exist, is not a folder or cannot be read: the same window states what the tool tried to open,
  what it observed and what to do next, carries a way to leave, and nothing is printed where the
  tool was started (UX-S4 Error, UX-I14). The window this slice draws holds `docs/DESIGN.md`
  § *Layout* and § *Components* for the surfaces it draws, cited by section and never by value,
  the way `choose-a-theme` cites § *Colors* (RN-75). The window opens at no less than the minimum
  width § *Layout* states and cannot be resized below it — the window's own, held by `mac-shell`
  — and inside it the sidebar stands at the one width § *Layout* fixes, the surface's, with the
  reading panel taking every remaining point, so the panel is wider than the sidebar in the first
  window they see. Every status message this slice shows — the reading panel's prompt, the tree's
  empty-folder and failed-root lines, and the startup surface's message in each of its states —
  sits at the top-left of its surface at the inset § *Components* "Status messages" states, led
  by a glyph with the sentence beside it — one glyph for an empty or pending state and another
  for a failure, both named there — and is never centred (that document's RN-14). The startup
  surface's two routes are text alone, one to a row, with no glyph and no bordered control
  (§ *Components* "The startup surface"). While the window is the key window and the pointer is
  over a tree row that a click acts on, that row and no other shows the fill § *Components*
  "Rows" draws. While the window is not the key window, no row shows it, as the same paragraph
  states (RN-98). A row nothing acts on, a
  status message among them, never shows it. The selected row keeps its selection and its bar
  under the pointer (RN-96). The layout this slice holds is the window's minimum and
  the two panels it draws; the rail's entries, the chrome's two controls and the Git view arrive
  with the slices *Not in this slice* names, and the words every message carries are
  `docs/CONTENT.md`'s (C-E4). On no surface is there an affordance to edit, create,
  save or initialise anything, enabled or disabled (UX-I1); closing asks nothing (UX-I5); every
  sentence shown says what the tool did, what it observed and what to do next, and no internal text
  appears (UX-I6). With the network disconnected, all of the above renders identically (UX-I15).
  *Command (CTO):* the workspace exists as § 3 draws it — `crates/nozoki-core`,
  `crates/nozoki-bridge`, `nozoki-mac`, `checks/` — and `cargo build --workspace --locked` and
  `swift build --package-path nozoki-mac -c release` each exit 0; `cargo tree -p nozoki-core`
  names no libgit2 binding and no TLS or SSH crate — no `git-reader` links in this slice (RN-9);
  `cargo test --workspace --locked` exits 0 with tests on the reducer's tree items, `ItemState`
  transitions, `fs-reader`'s containment check, and `nozoki-bridge`'s `--test exports` — the
  staticlib exports `open_folder` and `list_tree` and the release call `nozoki_free`, the header
  declares the same three, and nothing else (C-R7; SM-4); `swift test --package-path nozoki-mac`
  exits 0 with tests that a row is drawn from a
  projection and from nothing else — read with the one exception § 3's `surfaces` row names: the
  tree's pending line beneath a folder row whose listing has been asked for and not yet answered
  is the surface's own ask and no projection; this is a reading clause and adds no test (RN-82);
  and read with the same row's clause on the pointer and the window: what the pointer is over,
  and whether the window is the key window, are the shell's own observations and no projection,
  which is a second reading clause and adds no test for itself (RN-96, RN-98) —
  that the shell issues no call SM-4 does not name, and that
  the window declares a minimum content width and the sidebar a fixed width, each the value
  `docs/DESIGN.md` § *Layout* states and neither restated here — the machine half of the layout
  bar the observable half holds, so a window that can open with the reading panel narrower than
  the sidebar goes red in CI and not in a reader's hands (RN-74); the same `swift test` run holds
  seven cases for the hover fill. Four are stated for a window that is the key window: a tree
  row a click acts on shows the fill while the pointer is
  over it and loses it when the pointer leaves; a row nothing acts on never shows it; the
  selected row under the pointer keeps its selection fill and its bar; and after a scroll, an
  expansion or a collapse moves rows under a pointer that has not moved, the fill is on the row
  now under the pointer and on no other (RN-96). Three hold the key window: when the window
  stops being the key window, the fill leaves under a pointer that has not moved; while the
  window is not the key window, no row shows the fill, whatever the pointer moves over and
  whatever a scroll or an expansion moves under it; and when the window becomes the key window
  again, the fill is on the row under the pointer as the rows stand then (RN-98);
  `checks/view.sh` finds no forbidden symbol in `nozoki-mac/Sources` and neither `WebKit` nor
  `JavaScriptCore` on the executable's link list (C-R7); `.github/workflows/ci.yml` builds
  `Nozoki.app` and runs every script below on every push. `checks/bundle.sh Nozoki.app` prints the
  entitlement set C-R2's rule admits for this slice — the two v1 entitlements, no network
  entitlement — and finds the launched main process reported sandboxed, with the out-of-grant
  read and outbound network denied, and the no-entitlement control reported unsandboxed — the
  first proof that the wall stands under an ad-hoc signature (R-8; the observable is C-I3's,
  re-cut at § 10 RC-1); `checks/renderer.sh Nozoki.app` finds the same bundle's launched main
  process parked in the Open panel's modal run, inside the shell's launch frames — the panel
  presented — within its window, and its control, `checks/fixtures/idle-shell`, goes red (C-I3;
  re-cut at § 10 RC-2 and RC-3); the frames the gate reads are fixed by the script from this
  bundle (`checks/renderer.sh`, header § *THE FRAMES* — `:L53-L56` at `nozoki@7c7038f`). *The promise
  clause:* `checks/read-only.sh checks/fixtures/plain` and `checks/read-only.sh
  checks/fixtures/repo` each print `unchanged` after `open_folder` and `list_tree` on every entry,
  `.git` hashed where present; `checks/no-network.sh` exits 0; `checks/own-state.sh` finds the
  diagnostic log under `~/Library/Containers/com.kensaiapp.nozoki/` and no entry under either
  fixture (C-I2, C-D2).
- **Rests on:** § 2 (the shape — this is the slice that proves it); § 3 `fs-reader`, `folder-model`
  (the tree and the `pending` kind), `core-bridge`, `mac-shell`, `surfaces` (among what it draws
  here, the tree row's hover fill; RN-96), `read-only-harness`;
  `SM-1`, `SM-4` (`open_folder`, `list_tree`), `SM-5`, `SM-8`; § 4 C-R1, C-R2, C-R3, C-R6, C-R7,
  C-I1, C-I2, C-I3, C-D1, C-D2. Slices: none — this is the first.
- **Traces to:** PRD § Key Use Cases 1; § UX Notes "The character" — the reading panel as the
  dominant visual surface, navigation text-first with icons secondary (the clause the window's
  minimum width and the startup surface's text-alone routes, held in the observable half, answer
  to; RN-73); § UX Notes "The path" 1, "Failure states"; § Success
  Metrics "Zero required configuration"; § Scope (In) "Run posture", "Platform". SRS: FR-1, FR-2,
  FR-3, FR-4, FR-5, FR-23; NFR-4, NFR-5, NFR-8, NFR-9, NFR-11, NFR-14; DR-1, DR-2, DR-6; C-1, C-2,
  C-11; AC-9, AC-15 (the failure half), AC-24 (the tree and the empty state — the Git view's
  absence is `see-git-status`'s to fill).
  UXD: § 4 *Information Architecture* (one window, one shell; the sidebar beside a dominant
  reading panel); § 9 *Design-System Direction* — the reading panel the dominant visual surface,
  navigation text-first with icons secondary (the clause the layout and the text-alone routes
  held in the observable half realize; RN-75); UX-U3 (one local folder, a repository or not); UX-F1 — the arrival, up to and
  not including the first selection; UX-S1 Empty; UX-S2 Empty, Loading and Error; UX-S4 Empty and
  Error — the v1 route out, the in-window rendering; UX-I1, UX-I5, UX-I6, UX-I10, UX-I13, UX-I14,
  UX-I15; UX-A4; § 4 C-E1, C-E3, C-E4, C-E5, C-E7 of this document.
- **Moves toward:** first — the file tree, the first of the v1 surface, against a plain folder as
  against a repository; and second — the read-only bar proven at zero violations from the first
  build, so that "the promise has held the whole way" has a first build to be counted from.
- **Not in this slice:** reading a file — `read-a-file`; the rail's Git entry and the Git view —
  `see-git-status`, so in this slice the sidebar holds the Files view alone; the view following
  the disk — `follow-the-folder`; the theme control — `choose-a-theme`; the README's install path
  and the public release — `first-public-release`; remembering the folder across launches, and
  switching it — `switch-the-folder`.
- **Why here in the order:** First because it is the smallest reversible slice that proves the
  shape (§ 5 step 5): the wall — entitlements, sandbox under an ad-hoc signature, a shell holding
  no I/O of its own with its window drawn under them — is the design's whole claim, and this slice
  shows it with no Git, no watcher and no Markdown to unpick if the probe or the gate fails. Its
  result changes what happens next, which is step 4's test for not-too-narrow.

### S-2 — Any file, read and unchangeable

- **Slug:** `read-a-file`
- **Delivers:** After this, a developer can select any file in the tree and read it in the panel,
  named by its path — highlighted in the six floor languages, as plain text for any other text,
  and as a stated cannot-display state for a file that is not text — while nothing they type,
  paste or drop changes anything, and closing asks nothing.
- **Reached when:** *Observable (CDO):* they click a file in the tree and its content is in the
  panel with no perceived wait, the panel named by the file's folder-relative path (`docs/UXD.md`
  § 4); the selected row is marked in the tree by more than colour (UX-A2). A file in one of the six
  floor languages is highlighted; any other text file is plain text; a `.md` file is plain text in
  this slice and nothing on the surface promises otherwise (UX-F1, UX-S1 Success). They click a
  file that is not text — an image, a binary: the panel shows a placeholder naming the file and
  saying why its content is not shown — never a garbled render, never a broken glyph — and the tree
  beside it stays enabled and is the route out (UX-S1 Error, UX-I14). They click a file the tool
  cannot read: a plain statement of what it was doing and what it observed, the shell fully usable
  (UX-S1 Error, UX-I10). They click into the panel, type, paste and drop a file onto it: nothing on
  the screen changes, no caret appears, and the file on disk is byte-identical afterwards; no
  editing affordance exists anywhere, enabled or disabled (UX-I1, UX-I7). They quit with a file
  open: no prompt (UX-I5). A file that is genuinely still being read shows that it is being read,
  with no progress figure the tool has not measured (UX-S1 Loading, UX-I13). *Command (CTO):*
  `select_file` is on `SM-4`'s list and exported — `cargo test --locked -p nozoki-bridge --test
  exports` passes set equality with the wider set (C-R7); `cargo test --locked -p nozoki-core`
  includes `fs-reader` tests that, for every extension in
  C-I5, name that floor language, and for `checks/fixtures/text/` — a file with no extension, a
  file with an extension outside the set, a shell script whose only marker is a `#!/bin/sh` first
  line — yield *plain*, for a UTF-16 fixture that begins with its byte-order mark and for an
  empty file yield *text*, and for a fixture that decodes as neither UTF-8 nor marked UTF-16 —
  Latin-1 bytes, and a file torn mid-sequence — yield *cannot-display* with its reason (RN-41);
  `cargo test --locked -p nozoki-core --test highlight` yields, for one fixture per floor language,
  spans in the five token classes and none outside them, and for a *plain* fixture no span
  (`highlighter`; C-I5); `swift test --package-path nozoki-mac` includes reading-panel tests that
  the text view reports `isEditable` false and registers no drop type, that a keystroke, a paste
  and a drop leave the drawn content unchanged and raise no intent (SM-8), and that the panel is
  named by the file's folder-relative path; `checks/view.sh` passes (C-R7); the six grammars are
  compiled into `nozoki-core`, and the engine that compiles them (§ 3 `highlighter`) is named in
  `checks/deps.allow` (C-R6). *The promise clause:*
  `checks/read-only.sh` on both fixtures prints `unchanged` after `select_file` on every entry, the
  non-text ones included; `checks/no-network.sh` and `checks/bundle.sh` exit 0.
- **Rests on:** § 3 `fs-reader` (the text rule, the extension map), `highlighter`, `folder-model`
  (`FileView`), `surfaces` (the reading panel and its code treatment), `mac-shell`; `SM-1`, `SM-4`
  (`select_file`), `SM-8`; § 4 C-I5, C-I1, C-R7, C-D3 (the containment check on every tree path
  before open). Slices: `open-a-folder`.
- **Traces to:** PRD § Key Use Cases 1; § Core Features "Read-only viewing of any file in the
  folder"; § UX Notes "The path" 2 and 5, "Failure states", "The character"; § Success Metrics
  "File-switch immediacy". SRS: FR-7, FR-8, FR-9, FR-10, FR-23, FR-24, FR-29; NFR-1 (measured, not
  bound — C-I4), NFR-3, NFR-16 (the cannot-display path executes nothing); DR-3, DR-6; C-2; AC-4,
  AC-5, AC-16, AC-21. UXD: § 4 (the panel named by its path); UX-F1 — selection and reading, the
  six floor languages, plain text, the cannot-display state; UX-S1 Loading, Error (the not-text
  and cannot-read cases) and Success — rendered Markdown excepted, which is `read-markdown`'s;
  UX-I1, UX-I5, UX-I6, UX-I7, UX-I10, UX-I13, UX-I14; UX-A2, UX-A4; § 4 C-E3, C-E5, C-E8 of this
  document.
- **Moves toward:** first — reading with highlighting; second — the panel is the surface an editor
  would write from, and here it cannot.
- **Not in this slice:** Markdown rendered — `read-markdown`; until it lands, a `.md` file is
  shown as plain text, an intermediate no release ships (RN-18); the raw-source switch — not built
  (§ 9 TO-5); the open file following the disk, and the file-gone state — `follow-the-folder`;
  the file-switch number — measured (§ 4 C-I4), never delivered by a slice.
- **Why here in the order:** Second because reading is what every later surface is a treatment
  of — rendered Markdown, the diff and a commit's diff all land in the panel this slice opens — and
  because it is the first slice that reads content, so it is where `fs-reader`'s text rule and the
  containment check are exercised before untrusted content is ever rendered.

### S-3 — Markdown rendered, with nothing let in or out

- **Slug:** `read-markdown`
- **Delivers:** After this, a developer can read a Markdown file rendered in the panel — an image
  inside the folder shown in place, one outside it a stated placeholder, an external link readable
  and inert, a relative link opening its target as a tree selection would — with nothing executed
  and nothing fetched from outside the folder.
- **Reached when:** *Observable (CDO):* they click a `.md` file and read it rendered — headings,
  lists, code blocks — in the panel, with no control anywhere that offers a raw view and no sentence
  that mentions one (`docs/UXD.md` UX-I12, UX-S1 Success). In a document that references an image
  inside the folder, the image is there, in place. Where it references a remote image, or a path
  that climbs out of the folder, the place the image would have been holds a placeholder beneath
  the image's alt text saying that content outside the folder is not fetched — never a broken-image
  glyph (UX-I12 second case, UX-I13; the sentence is `docs/CONTENT.md` § *Message patterns* →
  *Partial*'s). Where it references an in-folder image that is missing, unreadable or not one of
  the formats the tool shows — an SVG among them, as `docs/trail/sdd/cycle-1.md` § 2.1 confirms —
  the placeholder states what was observed: the file's condition, or its format, and that it is not
  shown (UX-I12 third case; RN-31). An external link is shown with its destination readable and
  does nothing when clicked — no browser opens, nothing is fetched; a relative link to a file in
  the folder opens that file in the panel exactly as a tree selection does, and the tree's selected
  row follows (UX-I12). A hostile document — script, event attribute, frame, style — renders as
  text and nothing runs, no dialog, no navigation. With the network disconnected, every rendered
  document is pixel-for-pixel what it was with it connected (UX-I15). *Command (CTO):* `cargo test
  --locked -p nozoki-core --test markdown` passes over `checks/fixtures/hostile.md` — a document embedding a script, an
  event attribute, a frame, a style, a raw HTML block, a remote image, an in-folder PNG, an
  in-folder SVG, a `..` image path, a symlink-out image path, an external link and a relative
  link — with a `MarkdownDocument` in which every node's kind is in § 3's closed set, the script,
  the event attribute, the frame, the style and the HTML block are each a text node holding their
  source verbatim, exactly one image node is *resolved* — the in-folder PNG, to its
  folder-relative path — and the remote, `..` and symlink-out references are each a placeholder
  node carrying *outside the folder* and the SVG a placeholder carrying *a format not decoded*
  (C-D3); the external link is an *external* node with its destination; the relative link a
  *relative* node with its target path. The same target includes one case driven through `SM-5`
  with no window (C-I3): `select_file` on a `.md` entry of the fixture folder yields a `FileView`
  holding that `MarkdownDocument` and no spans — the fill made in the model, where § 3 places
  it, and in no other unit (RN-65). `cargo test --locked -p nozoki-bridge --test asset_bytes`
  passes: `asset_bytes` returns the PNG's bytes for its path and a refusal for every escaping
  path, on a second call with the same inputs (SM-7) — tested in the bridge's crate, where § 3
  places the function (RN-64).
  `open_relative_link` and `asset_bytes` join `SM-4`'s list and the exports (`--test exports`
  passes with the wider set); `swift test --package-path nozoki-mac` includes a Markdown-treatment
  test that a *resolved* image node is drawn from the bytes `asset_bytes` returned and a
  placeholder node from no bytes at all, and that no attributed string in the treatment is built
  from HTML — the third Open Question closes and `surfaces`' row names the layout form found in
  this slice. *The promise clause:* `checks/read-only.sh checks/fixtures/repo` prints `unchanged`
  after rendering every `.md` under it and calling `asset_bytes` on every image reference;
  `checks/no-network.sh` exits 0.
- **Rests on:** § 3 `markdown-renderer`, `highlighter` (a fenced block's spans), `fs-reader` (the
  containment check), `folder-model` (the `FileView` fill's Markdown branch — RN-65),
  `core-bridge` (`asset_bytes`), `surfaces` (the Markdown treatment, laid out by TextKit); `SM-4`
  (`open_relative_link`, `asset_bytes`), `SM-5` (the fill, driven by the harness), `SM-7`, `SM-8`;
  § 4 C-R7, C-D3; § 9 TO-5, TO-6; § 11 R-4, R-10, R-11. Slices: `read-a-file`.
- **Traces to:** PRD § Core Features "Markdown is rendered by default"; § Data & Privacy "v1 makes
  no network call at all during operation"; § Out of Scope "Rich rendering of non-text content".
  SRS: FR-30, FR-31 (not built — stated where the release is offered), FR-32; NFR-8, NFR-16; DR-6;
  AC-22, AC-23. UXD: UX-I12 whole — rendered by default, the absent switch stated by silence, the
  three image cases, the two link behaviours; UX-S1 Success (rendered for Markdown); UX-F1 (rendered
  when it is Markdown); UX-I13, UX-I15; § 4 C-E1, C-E7 of this document. The SVG case is not in the
  UXD's text and is not traced to it: it is the confirmed choice at `docs/trail/sdd/cycle-1.md`
  § 2.1 (RN-31).
- **Moves toward:** first — reading, of which rendered Markdown is the PRD's stated part; second —
  the first untrusted content the product renders, with the promise held through it.
- **Not in this slice:** the raw-source switch — not built (§ 9 TO-5); an SVG inside the folder
  rendered in place — the placeholder, confirmed at `docs/trail/sdd/cycle-1.md` § 2.1 as a v1 cut that
  evidence reopens (RN-8), never a slice ahead of that evidence; a diff's rendering —
  `read-a-diff`; images and documents outside Markdown — beyond v1 (PRD § Out of Scope).
- **Why here in the order:** Third because it is the first slice that renders untrusted content
  beyond plain text, and so the first that must prove C-D3's three walls — the check, the closed
  document, the decoder fed by the check alone — cheaper to prove on one treatment, with the
  hostile corpus, than after the diff and the history have added two more; and because
  no public release may ship a `.md` shown as plain text (RN-18), so it must precede
  `first-public-release`.

### S-4 — What Git says, where there is a Git to ask

- **Slug:** `see-git-status`
- **Delivers:** After this, a developer can switch the sidebar to Git and — where the opened
  folder is itself a repository's root — see the branch, the changed files, the staged files and
  the short status, with changed files marked in the tree, a mid-merge, mid-rebase or detached
  repository shown as the state it is in, a changed file's row opening that file to read, and
  the pointer resting on a status letter showing the row's name and the letter's meaning in
  words (RN-95);
  where the folder is not a repository's root — a plain folder, a folder inside a repository, a
  folder holding repositories — the Git view is present and shows nothing and the tree carries no
  markers.
- **Reached when:** *Observable (CDO):* they open a folder that is a repository's root, and the
  sidebar now carries a Files/Git switch with text labels (`docs/UXD.md` § 4, UX-A4). Before Git
  state has been read the Git view shows that it is reading — not a clean tree, not nothing (UX-S3
  Loading, UX-I13). They switch to Git and see the branch, the changed files, the staged files and
  one short status: in Git's own word for a merge, a rebase, a cherry-pick, a revert, a bisect or a
  detached HEAD — the branch element showing the commit's identifier on a detached HEAD — or a
  stated "nothing changed" where the tree and index are clean, and no count (UX-S3 Success, Empty);
  each file's state is a letter or word beside it, with colour repeating it and never carrying it
  alone (UX-A2). The tree carries changed-file markers on exactly the files the Git view lists,
  each with its text cue (UX-S2 Success). They rest the pointer on a status letter, in the tree
  and then in the Git view: a tooltip shows the row's name and then the letter's meaning in
  words; the row stays one click target, and nothing else in the product raises a tooltip
  (`docs/DESIGN.md` § Components, "The tooltip"; `docs/CONTENT.md` § Accessibility of text; § 4
  C-E8; RN-95). While the window is the key window and the pointer is over a file row in the
  Git view, that row and no other
  shows the fill `docs/DESIGN.md` § *Components*, "Rows", draws. While the window is not the key
  window, no row shows it. A raised tooltip leaves at the moment the window stops being the key
  window, and it returns only after a fresh rest on the letter once the window is the key window
  again, as § *Components*, "The tooltip", states (RN-98). A section header and a status
  message never show it. The status letter's tooltip sits over the row's fill, as § *Components*,
  "The tooltip", states (RN-96). They click a changed file's row: the file opens in the
  panel to read, exactly as a tree selection would — one click target, the status letter a label
  (UX-F2, the first reading). The row they clicked is drawn as `docs/DESIGN.md` § *Components*,
  "Rows", draws the selected row: with the selection fill and the left bar. The bar is the cue
  that survives without colour (`docs/UXD.md` UX-A2; RN-97). They scroll partway down it and switch back to Files: the open file
  and their reading position are untouched — the panel has not returned to the top (UX-F2; RN-78). A repository mid-merge, mid-rebase or detached shows that state, presented
  as the state it is in and never as an error (UX-S3 Error). Git state the tool could not read — a
  lock, an unreadable file — shows on that item what was observed, and the rest of the view stands
  (UX-S3 Error, UX-I10). They open a linked worktree, or a submodule, whose `.git` file names a
  Git directory outside the folder: the Git view's item shows what was observed — where the Git
  directory lies — and that this folder's Git state is therefore not read; it offers no folder to
  choose, and the tree and the panel work exactly as before, which is the route out (§ 11 R-3;
  UX-I10, UX-I14; the sentence's third part is C-E4's terminal form). They open a plain folder, a
  folder inside a repository, or a folder holding repositories: the Git view is present and shows
  nothing at all — no message, no label,
  no control, nothing offering to create a repository — the tree carries no markers, and the
  switch, the tree, the panel and the empty state are exactly as in a repository (UX-I17, UX-S3
  Empty). A clean repository and a plain folder are told apart only by the branch and its "nothing
  changed" against nothing at all (UX-S3 Empty). Where finding out whether the folder is a
  repository stopped, the Git view shows a fault in its slot and never nothing (UX-I16, UX-S3
  Error). After all of it, `git status` in a terminal reports what it reported before. *Command
  (CTO):* `git-reader` links for the first time —
  the libgit2 binding joins `checks/deps.allow` in the same change, and `cargo tree -p nozoki-core`
  names it and still no TLS or SSH crate (C-R6); `cargo test --locked -p nozoki-core --test
  root_finding` passes over `checks/fixtures/` — `plain`, `repo`, `inside-a-repo`, `parent-of-two`,
  `linked-worktree`, `submodule` — answering `root` only where the opened folder is its own top
  level and never a path above it; `--test git_state` passes over a repository with staged and
  unstaged changes on a named branch, one mid-merge, one mid-rebase and one on a detached HEAD:
  branch name or commit identifier, both lists with their status letters, the short status word as
  Git names the state; the same test includes a reducer case with a port double whose `probe`
  answers `root` and whose `state()` returns the error naming a Git directory outside the folder —
  the R-3 case, reached through a double because the case checks what the reducer does with a
  failure (C-I1) and not what the port does, so no adapter stands behind it — and the model holds
  the Git item as `failed(condition)` with that path as the condition and no folder path in it.
  The failed Git read changes the Git item and nothing else: the tree and every item in it stand
  as they were before the read — a file stays `observed`, a folder not yet expanded stays
  `pending`, and an entry that had failed stays `failed` (C-I1; RN-44, RN-88). The adapter's side
  of the same case runs in the same suite: the `linked-worktree` and `submodule` fixtures go
  through the libgit2 adapter in-process, and both `state` and `status` answer the outside
  condition, because the adapter locates the Git directory and the common directory by spelling
  before libgit2 opens anything. A refusal by spelling shows what the adapter does and nothing
  about the sandbox (§ 11 R-3; RN-88); `checks/read-only.sh checks/fixtures/repo` with `.git/index` in the hash
  prints `unchanged` after `probe`, `state` and `status` — no optional-lock refresh (TO-2);
  `checks/structure.sh` finds no `std::process` in any shipped crate and the libgit2 import in
  `git-reader` alone, with the one exception § 3 states: `core-bridge` names the binding in the
  composition root's search-path switch and its test, and nowhere else (RN-87); `swift test
  --package-path nozoki-mac` passes with a case holding that each of the six status categories
  gives the word `docs/CONTENT.md` § Accessibility of text states for it, and that the tooltip's
  text is the row's name and then that word (RN-95); the same run holds eleven cases for the Git
  view's file row, six for the hover fill, one for the selected row's drawing and four for the
  key window. The first seven are stated for a window that is the key window: a file row
  shows the fill while the pointer is over it and loses it when
  the pointer leaves; a status message never shows it; a section header never shows it; after a
  click on a file row, with the pointer over no row, the clicked row shows the selection fill and
  the bar, and no other row shows either (RN-97); the
  selected row under the pointer keeps its selection fill and its bar; after a scroll moves rows
  under a pointer that has not moved, the fill is on the row now under the pointer and on no
  other; and the row still shows the fill while the tooltip is raised (RN-96). The four for the
  key window: when the window stops being the key window, the fill leaves under a pointer that
  has not moved; while the window is not the key window, no row shows the fill, whatever the
  pointer moves over and whatever rows an answer arriving then puts under it; when the window
  becomes the key window again, the fill is on the row under the pointer as the rows stand then;
  and a raised tooltip leaves when the window stops being the key window and returns only after
  a fresh rest on the letter (RN-98). *The promise clause:* `checks/read-only.sh` on all six fixtures prints
  `unchanged`; `checks/no-network.sh` exits 0.
- **Rests on:** § 3 `git-reader` (the port, `probe`, `state`, `status`), `folder-model` (`kind`
  resolved; `GitState`), `surfaces` (the rail's Git entry, the Git view, and in this slice the
  tree's markers and the Git lists' row order, under the bounds § 3's `surfaces` row states;
  § 10 RC-5, RN-94; the status letter's tooltip, its six words in the message catalogue;
  RN-95; the Git view's file row's hover fill; RN-96; and the Git view's selected row's
  fill; RN-97); `SM-2`, `SM-4` (`read_git`; § 10 RC-4); § 4 C-R6, C-I1; § 9 TO-2, TO-10; § 11 R-1,
  R-3. Slices: `open-a-folder`, `read-a-file`.
- **Traces to:** PRD § Key Use Cases 2 and 4; § Core Features "A Git view", "Git is read only when
  the folder opened is itself the root of a Git repository", "A file tree with changed-file
  markers"; § UX Notes "The path" 3, "the view never lies"; § Out of Scope "Creating or
  initialising a Git repository". SRS: FR-6, FR-11, FR-12, FR-13 (the first reading), FR-25,
  FR-26, FR-33, FR-34; NFR-3, NFR-5, NFR-6; DR-4; § 5.3; AC-6 (the first reading), AC-17, AC-18,
  AC-24 (the Git view's empty half), AC-25, AC-2. UXD: § 4 (the sidebar's two modes); UX-F2 — the
  switch, the glance, the row's first reading, the plain-folder switch; UX-S2 Loading (markers only
  once read) and Success (the markers, and none in a plain folder); UX-S3 all four cells, the short
  status's content included; UX-I13, UX-I16 (the stopped finding, shown as a fault), UX-I17 whole;
  UX-A2, UX-A4; § 4 C-E1, C-E3, C-E6, C-E8 of this document.
- **Moves toward:** first — Git status, against a plain folder as against a repository.
- **Not in this slice:** a changed file's diff, and the row's second reading — `read-a-diff`; the
  commit history — `read-the-history`; Git state following the disk — `follow-the-folder`, so in
  this slice the Git view shows the state read when the folder opened; the installed-`git`
  substitute — built when § 11 R-1 fires, never a slice.
- **Why here in the order:** Fourth because it is the first slice that links `git-reader` and asks
  `probe` — the one mechanism the design expects to swap (R-1), and the second Open Question
  (libgit2 under a read-only grant with discovery disabled) closes here; and because the Git view
  must exist before `follow-the-folder` has Git state to follow.

### S-5 — The view follows a folder someone else is changing

- **Slug:** `follow-the-folder`
- **Delivers:** After this, a developer can leave Nozoki open while an agent changes the folder
  and watch the tree, the open file's content and the Git state follow the disk on their own —
  within the refresh bar, with no refresh control, their expanded nodes, open file and reading
  position kept, a vanished open file said to be gone, and nothing crashing or writing however
  fast the folder moves; a repository appearing at the root mid-session, or leaving it, fills or
  empties the Git view the same way.
- **Reached when:** *Observable (CDO):* with Nozoki open on a folder, they expand some nodes,
  collapse one of them again, open a file longer than the panel and scroll partway down it, and
  then run a script in a terminal that creates, changes and deletes files for thirty seconds. The
  tree changes on its own as the disk does, and nothing else moves: the nodes they left expanded
  stay expanded, the one they collapsed stays collapsed, the selected file stays selected, the
  sidebar stays on the mode it was on, and the panel's scroll position does not jump — it does
  not return to the top (`docs/UXD.md` UX-I3, UX-F3; RN-78). No refresh control exists anywhere, and no update
  announces itself — no toast, no flash, no badge (UX-I2). The script changes the open file: its
  content updates in place, the reading position kept. The script deletes it: the panel keeps the
  file's name and states plainly that it is no longer there, and its old content is not shown as
  current (UX-S1 Error, UX-I4). The script stages, commits and checks out branches: the Git view
  and the tree's markers follow, each marker appearing only once the new state has been read
  (UX-S2 Loading, UX-I13). They rest the pointer on a status letter until its tooltip shows, and
  the script changes that row's state: the tooltip leaves at the refresh (`docs/DESIGN.md`
  § Components, "The tooltip"; RN-95). The script runs `git init` at a plain folder's root: the Git view fills
  and markers appear; it removes `.git`: the view empties and the markers go — without ceremony,
  their place untouched (UX-I17). Throughout, the window never blanks, blocks or closes; an entry
  made unreadable mid-run is marked with what was observed and the rest of the tree stands (UX-S2
  Error, UX-I10). When the script stops, what the window shows is what `ls -R` and `git status`
  show. They quit mid-run: no prompt (UX-I5). *Command (CTO):* `cargo test --locked -p nozoki-core
  --test watch` passes while `checks/churn.sh <fixture> 30` runs — thirty seconds of create,
  modify and delete including the displayed file, Git operations mid-flight, and `git init` at a
  plain root followed by its removal — with no panic, the model's final snapshot equal to a fresh
  open of the fixture, and expansion, selection and reading position surviving; the same suite
  holds a case in which a file's Git status changes mid-run, and the model's snapshot then
  carries the changed marker on that file's `TreeEntry` and both Git lists in row order;
  `grep -rn 'TreeMarkers\|GitRowOrder' nozoki-mac/Sources` prints nothing, because the join and
  the order have left the shell (§ 3, the `surfaces` row; § 10 RC-5; RN-94); an unreadable entry
  yields `failed` on that item and the failure changes no other item — each sibling holds the
  state its own read gave it (C-I1; RN-89); `checks/read-only.sh` against the
  churn's own final state as baseline prints `unchanged`; `checks/read-only.sh --kill` — SIGKILL to
  the host mid-churn — prints `unchanged` (NFR-4); `checks/structure.sh` finds the FSEvents
  subscription in `watcher` alone; `checks/latency.sh` exits 0 and prints file-switch and refresh
  p95 in milliseconds over `checks/fixtures/scale-small`, `scale-medium` and `scale-large` on every
  CI build — the first figures, which go to the SRS by revision and are asserted nowhere here
  (C-I4). *The promise clause:* the two `read-only.sh` runs above; `checks/no-network.sh` exits 0.
- **Rests on:** § 3 `watcher`, `folder-model` (the reducer, keyed by path, and beside it the
  state it keeps the reader's place in — the tree's expansion, the selection, and the open
  `FileView` with its reading position — which the model holds from this slice at the latest, no
  earlier slice's *Reached when* asserting that the model holds it
  (`docs/trail/sdd/cycle-17.md` § 5.2; RN-76), and how a collapse and a scroll reach it across
  SM-4 is open — *Open Questions*, the collapse-and-scroll item (RN-77); the
  root finding re-run on the `.git` entry; and, from this slice at the latest, the changed
  marker on `TreeEntry` and the two Git lists held in row order, which `surfaces` holds until
  this slice is reached — § 3, the `surfaces` row; § 10 RC-5; RN-94), `surfaces` (the file-gone
  state); `SM-3`, `SM-4` (`model_changed` deltas, which bring the marker to a row already
  drawn);
  § 4 C-I1, C-I3 (`--kill`), C-I4; § 11 R-5, R-6, R-8. Slices: `read-a-file`, `see-git-status`.
- **Traces to:** PRD § Key Use Cases 3; § Target Users, the driving scenario; § Core Features
  "Live refresh"; § UX Notes "The path" 4, "the view never lies"; § Success Metrics "Refresh
  immediacy". SRS: FR-14, FR-15, FR-16, FR-27, FR-28, FR-33 (the live clause); NFR-2 and NFR-10
  (measured — C-I4), NFR-3, NFR-4; DR-2, DR-6; AC-7, AC-8, AC-19, AC-20. UXD: UX-U2 (the driving
  scenario — read in glances, never asking for an action to stay current); UX-F3 whole; UX-S1 Error
  (the open file gone) and Success (position preserved across refreshes); UX-S2 Loading and Error;
  UX-I2, UX-I3, UX-I4, UX-I5, UX-I10, UX-I13; UX-I17 — the live finding, a repository appearing or
  leaving; § 4 C-E1, C-E2, C-E3, C-E6 of this document.
- **Moves toward:** first — live refresh, the last of the v1 surface; and the scenario the product
  exists for (PRD § Purpose, "it exists *now* because").
- **Not in this slice:** the refresh and file-switch numbers — printed here for the first time
  (§ 4 C-I4) and folded into the SRS by revision, never fixed by a slice; switching folders —
  `switch-the-folder`; a manual refresh control — never (PRD § UX Notes "The path" 4).
- **Why here in the order:** Fifth because following a moving folder is the hardest thing the
  model does and it is placed where three read surfaces already exercise the model, so a reducer
  defect shows against known-good projections; because it is the slice the product is for and the
  first that can print a latency figure (C-I4); and because it is the last of the v1 cut, so the
  release that follows carries the whole thesis.

### S-6 — A theme chosen, and remembered outside the folder

- **Slug:** `choose-a-theme`
- **Delivers:** After this, a developer can switch between a dark and a light theme from the shell
  chrome — the first theme following the platform's appearance — and find the choice, and the
  window's frame, remembered at the next launch, kept in the tool's own data location with nothing
  written in the folder.
- **Reached when:** *Observable (CDO):* on a Mac whose appearance is set to Dark, a first launch
  opens Nozoki dark; set to Light, light (`docs/UXD.md` UX-I9). A control in the shell chrome, with
  a text label beside its icon, switches between the two (§ 4, UX-A4). In each theme every surface
  reads — the tree, the panel and its highlighting, the Git view, the startup surface, every
  placeholder and every failure sentence — with no surface styled for one theme only, and every
  marker and state cue still carried by a letter, word, shape or position and not by colour alone
  (UX-A2; § 4 C-E8, C-E9). Held against the tokens `docs/DESIGN.md` § *Colors* states, the text
  on both themes meets the contrast floor that document names. They quit and relaunch: the theme
  they chose and the window's size and position are as they left them. They switch back: the same
  control, and nothing else, undoes it (UX-I7). The folder they were viewing has no new file in it
  afterwards, and no file in it changed. *Command (CTO):* `set_theme` is on `SM-4`'s list and
  exported (`--test exports` passes); `cargo test --locked -p nozoki-core` includes
  `own-state` tests that a record is read whole, that an unreadable or foreign-shaped record yields
  the first-run state and never a partial one, and that the record holds the theme and the window
  frame and no other field (C-D4); `checks/own-state.sh` after a session in which the theme
  changed finds every changed file under `$HOME` inside
  `~/Library/Containers/com.kensaiapp.nozoki/` and none under the fixture, and inspection of the
  container finds the theme, the window frame, the log and nothing of the fixture's content;
  `checks/structure.sh` finds the container path in `own-state` and the bridge's log module alone.
  *The promise clause:* `checks/read-only.sh` on both fixtures prints `unchanged` after
  `set_theme`; `checks/no-network.sh` exits 0.
- **Rests on:** § 3 `own-state`, `surfaces` (the theme control in the chrome, the token pairs);
  `SM-4` (`set_theme`), `SM-6`; § 4 C-D2, C-D4. Slices: `open-a-folder`.
- **Traces to:** PRD § UX Notes "The character" — "dark and light themes from the start"; § Data &
  Privacy — own state "never inside the folder it is pointed at". SRS: FR-20, FR-21; NFR-5, NFR-7;
  DR-5; AC-11, AC-13. UXD: UX-I9 whole — both themes first-class, the platform default and its
  signal-less fallback, the remembered override, the control's home; § 4 (the theme control in the
  chrome, RN-22); UX-I7 (a preference reversible by its own control); UX-A2, UX-A4; § 8 *Minimum
  contrast* (the floor `docs/DESIGN.md` states); § 9 *Design-System Direction* — two themes; § 4
  C-E8, C-E9 of this document.
- **Moves toward:** first — two themes are part of the v1 surface; second — the first thing the
  tool ever writes, shown to land outside the folder.
- **Not in this slice:** the remembered folders — `switch-the-folder`; any token value —
  `docs/DESIGN.md`'s; a preference beyond the theme and the window frame — none exists (§ 4 C-D4).
- **Why here in the order:** It could sit anywhere after `open-a-folder` — nothing structural
  waits on it — and it sits sixth only because FR-20 makes both themes a first-release condition,
  so it must precede `first-public-release`; and because it builds `own-state`, which
  `switch-the-folder`'s remembered list is stored in.

### S-7 — A stranger can pick it up

- **Slug:** `first-public-release`
- **Delivers:** After this, a stranger can find Nozoki at `github.com/kensaiapp/nozoki`, install
  it by the one path the README's first screen names, and be reading a file of their own
  repository within five minutes — the README stating what the tool will and will not touch, the
  support posture, what is outside done, the MIT licence, and that before 1.0.0 anything may
  change; a SECURITY.md naming where to report; and the release carrying the whole-surface proof —
  the folder and the repository byte-identical after every command, no outbound traffic — as a
  result a reviewer reads rather than a claim.
- **Reached when:** *Observable (CDO):* a stranger on a Mac holding only stock macOS opens
  `github.com/kensaiapp/nozoki` in a browser. The README's first screen tells them in one sentence
  what the tool does, shows one install path, and shows a screenshot that is the shell of the
  release they are about to download — not a mock-up, not an earlier build (`docs/UXD.md` UX-I11).
  The page's images all come from the repository itself; no badge or picture is served from
  anywhere else (UX-I15; the fence § `no-runtime-remote-asset`, the README clause). Further down —
  not on the first screen — one plain sentence states the posture: mouse-driven, no keyboard
  navigation, no assistive-technology promise, said as a fact and not an apology (UX-A3, UX-A1).
  They follow the install path, walk Gatekeeper, launch, choose a repository of their own in the
  Open panel, and are reading one of its files — a wall clock started at the README says under
  five minutes. Every surface they meet on the way behaves as S-1 to S-6's observable halves state.
  On the release page, beside the download, a reviewer reads — as text, not a claim — that the
  whole surface was exercised against a repository and a plain folder and left both byte-identical
  and the repository's Git state unchanged, with no outbound connection recorded. `SECURITY.md`
  names where to report. *Command (CTO):* `.github/workflows/release.yml`, on a tag `v0.y.z`,
  builds `Nozoki-<version>.dmg` and `SHA256SUMS` from that tag and attaches both to a
  GitHub Release on `kensaiapp/nozoki`; on the *downloaded* bundle, `shasum -a 256 -c SHA256SUMS`
  passes, `codesign -dv Nozoki.app` reports `Signature=adhoc`, `/usr/libexec/PlistBuddy -c 'Print
  :LSMinimumSystemVersion' Nozoki.app/Contents/Info.plist` prints `14.0`, and `checks/bundle.sh`
  passes with C-R2's two entries; `checks/notices.sh` finds every name in `cargo tree` in
  `THIRD_PARTY_NOTICES.md` — the Swift package declares no dependency to notice (C-R6); `LICENSE`
  is MIT; `SECURITY.md` exists and `gh api
  repos/kensaiapp/nozoki/private-vulnerability-reporting` returns `"enabled": true`; `cargo audit`
  exits 0; `gitleaks git` exits 0 and `gh secret list --repo
  kensaiapp/nozoki` prints no entry; the version in `Cargo.toml` and `CFBundleShortVersionString`
  is below 1.0.0. *The promise clause, over the whole surface built so far:* `checks/read-only.sh`
  prints `unchanged` on every fixture after every command the build grants (§ 4 C-R7); `checks/no-network.sh`
  exits 0; and a network monitor across one full session against the downloaded bundle records zero
  outbound connections (AC-3) — the result attached to the release as text a reviewer reads.
- **Rests on:** § 3 `read-only-harness`; § 4 C-R1, C-R4, C-R5, C-R6, C-I3; § 9 TO-8, TO-9; § 11
  R-2, R-7. Slices: `read-markdown` and `choose-a-theme` as edges (§ 7); `open-a-folder`,
  `read-a-file`, `see-git-status`, `follow-the-folder` by the owner's decided ordering — the first
  public release waits for the full v1 cut (RN-17) — which § 7 carries as a placement, not an
  edge, and which only a re-cut (§ 10) may move.
- **Traces to:** PRD § Goals "Pick-it-up adoption"; § Success Metrics "Read-only integrity",
  "Time-to-first-success"; § Assumptions "Licence", "Public identity", "Support posture",
  "Versioning", "Regulatory posture"; § Scope (In) "Run posture", "Platform"; § Risks "The promise
  breaks incidentally", "Maintenance is a standing liability". SRS: NFR-7, NFR-8, NFR-9, NFR-13,
  NFR-15; C-3, C-4, C-5, C-6 (the pre-1.0.0 statement), C-7, C-9, C-10, C-11, C-12, C-13; AC-1,
  AC-2, AC-3, AC-10, AC-14. UXD: UX-I11 (the README screenshot is product surface, checked at
  release); UX-A3 (the posture sentence, its place and its bound); UX-A1 (the posture it states);
  UX-I15 as the instance fence § `no-runtime-remote-asset` extends it to the README; § 4 C-E7,
  C-E10 of this document. The README's claims, its licence and its support posture are the PRD's
  and are not traced here.
- **Moves toward:** third — a stranger, by the README alone, at a release below 1.0.0; second — the
  bar at zero violations at the first public release, from which "every release before it" is
  counted. Not the 1.0.0 half of the third condition — that is `promise-one-point-zero`.
- **Not in this slice:** version 1.0.0 and the promise it starts — `promise-one-point-zero`;
  diffs, history and folder switching — `read-a-diff`, `read-the-history`, `switch-the-folder`; a
  second install channel, and notarization — never (§ 4 C-R4, § 9 TO-9); sidebar search and
  filter, pane resizing and keyboard navigation — outside done, and the README says so rather than
  promising them (PRD § Out of Scope).
- **Why here in the order:** Its two hard edges are `read-markdown` (no release ships a `.md` as
  plain text — FR-30, RN-18) and `choose-a-theme` (FR-20); nothing else it needs is unbuilt
  earlier. Its place after `follow-the-folder` — after the whole v1 cut, and at it rather than at
  the terminus — is the owner's decided ordering (RN-17), not a dependency and not a preference:
  step 3's test is what can be built, and this slice could be built earlier; but a decided
  placement is not reordered for free the way a preference is, so § 7 carries it as a placement
  and moving it is a re-cut (§ 10), never a re-sort. What this seat adds: its mechanism — the
  bundle, the entitlements, the probe — has passed on every build since `open-a-folder`, so the
  slice's technical risk is the stranger's Gatekeeper walk (R-2), not the artifact.

### S-8 — A changed file's changes, read

- **Slug:** `read-a-diff`
- **Delivers:** After this, a developer can activate a changed file's row in the Git view and read
  that file's changes in the panel, staged changes distinguished from unstaged, the file itself
  still read from the tree — and a diff that cannot be produced says so in the panel while the
  file stays readable.
- **Reached when:** *Observable (CDO):* in a repository with staged and unstaged changes, they
  click a changed file's row in the Git view and the panel shows that file's changes, read-only,
  staged told from unstaged by a word or label as well as by colour (`docs/UXD.md` UX-S5 Success,
  UX-A2). A file with both shows both, told apart. The row is one click target and the status
  letter beside it is a label, not a second control (UX-F2). They click the same file in the tree:
  the file itself opens, as it always did (UX-F2). A changed file with no remaining changes: the
  panel states so (UX-S5 Empty). They delete a changed file in a terminal and click its row: the
  panel states what the tool observed, the Git view beside it is the route out, and the file — if
  it still exists — is still readable from the tree; the row never quietly opens the file instead
  (UX-S5 Error, UX-F2). Nothing they do in the diff has an affordance to stage, unstage, revert or
  edit (UX-I1), and `git status` afterwards reports what it reported before. In a plain folder
  there is no row to click, and nothing offers one (UX-F4). *Command (CTO):* `diff(kind, path)` is
  on the port and `open_diff` joins `SM-4`'s list and the exports (`--test exports` passes with
  the wider set); `cargo test --locked -p nozoki-core --test git_state` passes diff cases over
  `checks/fixtures/repo` — a file with staged changes only, unstaged only, both (two diffs, told
  apart in the data), an untracked file — and a file removed between `status` and `diff` yields
  `failed` on that item with the file's tree entry still `observed`; the diff treatment is a
  `swift test` case that staged and unstaged carry a text cue and not colour alone, and that the
  treatment is built from the `Diff`'s hunks as text and from no markup. *The promise clause:* `checks/read-only.sh checks/fixtures/repo` with
  `.git/index` hashed prints `unchanged` after `open_diff` on every changed entry;
  `checks/no-network.sh` exits 0.
- **Rests on:** § 3 `git-reader` (`diff`), `folder-model` (`Diff`), `surfaces` (the diff
  treatment of the reading panel; the row's second reading); `SM-2`, `SM-4` (`open_diff`); § 4
  C-I1, C-R7, C-D3 (the diff is text the shell lays out, never markup from content). Slices:
  `see-git-status`.
- **Traces to:** PRD § Scope (In), the full ambition — "diffs"; § Out of Scope "Diff and
  commit-history views — beyond v1"; § Key Use Cases 2. SRS: FR-13 (the second reading), FR-17,
  FR-33, FR-34; NFR-3, NFR-6; DR-4; AC-6 (the second reading), AC-12 (the diff clause).
  UXD: UX-F2 — the row's second reading, one click target, the never-falls-back rule; UX-F4 — the
  diff steps and the read-only clause; UX-S5 all four cells; UX-I1, UX-I10; UX-A2; UX-I17 (nothing
  to open in a plain folder); § 4 C-E3, C-E5, C-E8 of this document.
- **Moves toward:** first — diffs, the first of the three beyond-v1 features the Agari places
  inside done.
- **Not in this slice:** a commit's diff — `read-the-history`; the row's first reading, opening
  the file — `see-git-status`'s, which this slice replaces on the row; a diff in a plain folder —
  nothing to show, by the same rule as the empty Git view.
- **Why here in the order:** First of the three beyond-v1 slices because the history needs its
  presentation (FR-22) and nothing needs the history first; and because it is the smallest widening
  of the Git port after the release, so a libgit2 lag (R-1) on the diff path is met before the walk
  path widens it further.

### S-9 — The history, branches drawn as branches

- **Slug:** `read-the-history`
- **Delivers:** After this, a developer can open the commit history from the Git view — commit
  rows beneath the changes list, branches drawn as branches where more than one exists, against a
  chosen branch set whose default asks nothing — see each commit's identifier, message, author and
  date, read any commit's diff in the panel, and, where the loaded history stops short of the
  repository's, see the view say so at its end.
- **Reached when:** *Observable (CDO):* the Git view carries a text-labelled entry for the
  history; they open it and commit rows appear in the sidebar beneath the changes list — each with
  its identifier, message, author and date — and nothing was asked first: the graph is drawn for
  the current branch and what relates to it (`docs/UXD.md` UX-S6 Success, § 4, UX-A4). In a
  repository with more than one branch they can see which commits belong to which and where they
  diverge and merge, each branch named at the commit that is its tip; a chooser in the history view
  lets them draw one, several or all branches (UX-F4). They click a commit: what it changed takes
  the panel, in the same diff presentation as `read-a-diff` (UX-S6 Success, UX-S5). A repository
  with no commits: the view states so (UX-S6 Empty). Before the graph is drawn the view shows
  pending — never a shorter history presented as whole (UX-S6 Loading, UX-I13). In a repository
  whose history is longer than the view loads, the last row is followed by a statement that older
  commits are not shown, and no control loads more; where the whole history fits, nothing is stated
  (UX-S6 Success). Where the history cannot be read: a plain statement, the shell intact, the Git
  view the route out (UX-S6 Error). No control anywhere filters or searches the history, and
  nothing on the surface stages, checks out, or otherwise changes the repository — `git log` and
  `git status` afterwards report what they reported before (UX-I1). *Command (CTO):* `walk(tips,
  window)` is on the port and `walk_history` joins `SM-4`'s list and the exports (`--test exports` passes); `cargo test
  --locked -p nozoki-core --test git_state` passes history cases over `checks/fixtures/history` —
  a repository whose branches diverge and merge — returning, for the requested tips and a window of
  1,000 commits (RN-35), each commit's identifier, message, author, date, parents and branch
  membership, the tips named, and a flag that the window ended before the walk did; the default
  request the shell sends names HEAD and every local branch sharing a commit with it inside the
  window (RN-35); a commit's `diff` reuses `read-a-diff`'s port call and treatment. *The promise
  clause:* `checks/read-only.sh checks/fixtures/history` prints `unchanged` after `walk_history`
  with every tip set and `open_diff` on every commit in the window; `checks/no-network.sh` exits 0.
- **Rests on:** § 3 `git-reader` (`walk`), `folder-model` (the history window in `GitState`),
  `surfaces` (the history beneath the changes list, the graph); `SM-2`, `SM-4` (`walk_history`);
  § 4 C-I1; § 11 R-1, R-5 (a long history is a scale dimension NFR-10 names). Slices:
  `see-git-status`, `read-a-diff`.
- **Traces to:** PRD § Scope (In), the full ambition — "commit history"; § Out of Scope "Diff and
  commit-history views — beyond v1". SRS: FR-18, FR-22, FR-33, FR-34; NFR-3, NFR-6, NFR-10 (history
  length); DR-4; AC-12 (the history clause). UXD: UX-F4 — the history steps, the branch set and its
  default, the per-commit fields, a commit's diff; UX-S6 all four cells — the home beneath the
  changes list, the stated end, no load-more; § 4 (where the history is drawn); UX-S5 (the diff
  presentation, reused); UX-I1, UX-I13; UX-A2, UX-A4; § 10 (filtering and search outside done); § 4
  C-E1, C-E3, C-E5, C-E8 of this document.
- **Moves toward:** first — commit history, the second of the three.
- **Not in this slice:** history filtering and search — outside done; a control that loads more —
  never (UXD UX-S6); the diff presentation — `read-a-diff`'s, reused and not redrawn.
- **Why here in the order:** After `read-a-diff` by dependency (FR-22) and before
  `switch-the-folder` by preference: it is the last widening of the Git port, so the port's
  contract is complete — and R-1's substitute, if ever built, has a fixed surface to match —
  before the one slice that changes the wall lands.

### S-10 — Another folder, without restarting

- **Slug:** `switch-the-folder`
- **Delivers:** After this, a developer can switch the viewed folder from the shell chrome without
  restarting — choosing one of the ten most recently viewed or browsing for another, a repository
  or a plain folder alike — arrive at that folder's tree with the previous folder untouched, and at
  the next launch find the last-viewed folder open without being asked.
- **Reached when:** *Observable (CDO):* the shell chrome's identity element shows the current
  folder's name, and the name is the control (`docs/UXD.md` UX-F5, § 4). They open it and see the
  folders they have viewed — at most ten, most recently viewed first, the current one marked, and a
  browse entry (UX-S7 Success). They choose another: the window is the arrival state for that
  folder — its tree, the panel's prompt, its Git view filled or empty by what that folder is — and
  the chrome's name has changed (UX-F1, UX-F5, UX-I17). The folder they left has no new file in it
  and no changed one. They browse to an eleventh folder: the one viewed longest ago is gone from
  the list; no control anywhere removes an entry or clears the list (UX-S7 Success). They choose an
  entry whose folder has since been deleted: the failure is stated in the same plain language as
  the startup surface's, the folder they were viewing is still viewed, and the selector is still
  open as the route out (UX-S7 Error, UX-S4). They quit and relaunch: the last-viewed folder is
  open and nothing was asked (UX-F5). On a Mac where Nozoki has never viewed a folder, the Open
  panel is presented; dismissed, the startup surface's route is the selector's browse entry, and
  the selector's list holds only that entry (UX-S4 Empty, UX-S7 Empty). A repository and a plain
  folder are chosen and arrived at the same way (UX-I17). *Command (CTO):* the entitlement list
  gains `com.apple.security.files.bookmarks.app-scope` and nothing else — `checks/bundle.sh` passes
  against C-R2's three entries; `switch_folder` joins `SM-4`'s list and the exports
  (`--test exports` passes); `cargo test --locked -p nozoki-core --test switch` passes: opening B
  after A yields a model equal to a fresh open of B with no item of A remaining, the root finding
  applied to B afresh; `own-state` holds A's and B's bookmark, display name and last-viewed mark
  and no folder content; an eleventh folder evicts the one viewed longest ago and no operation
  removes an entry; relaunching the bundle opens B with no Open panel, and relaunching after the
  container's remembered list is removed presents the panel (C-R3). `git diff --stat
  <first-public-release tag>..HEAD -- nozoki-mac` lists only files of the selector and of
  `mac-shell`'s launch-time restore, and no file of the tree, the Git view or the reading panel —
  the viewing surface untouched by the change that adds the selector (NFR-12). *The promise clause:* `checks/read-only.sh` prints `unchanged` on A
  and on B after the switch, `.git` hashed where present; `checks/own-state.sh` finds every write
  inside the container; `checks/no-network.sh` exits 0.
- **Rests on:** § 3 `folder-model` (replace-whole), `own-state` (bookmarks, the ten-entry list),
  `mac-shell` (the grant restored from a bookmark), `surfaces` (the identity element become the
  selector); `SM-4` (`switch_folder`), `SM-6`; § 4 C-R2 (the third entitlement), C-R3 (the
  restore-on-launch clause), C-D4. Slices: `open-a-folder`, `choose-a-theme`.
- **Traces to:** PRD § Scope (In) "one folder at a time is a v1 cut", the full ambition —
  "switching which folder is viewed without restarting"; § Out of Scope "Changing the viewed folder
  without restarting", "Several folders at once"; § Data & Privacy — own state. SRS: FR-1, FR-3
  (through the selector), FR-19, FR-21, FR-33 (applied afresh); NFR-5, NFR-12; DR-1, DR-5; AC-12
  (the switching clause), AC-13, AC-15. UXD: UX-F5 whole; UX-S7 all four cells — the bound, the
  order, the mark, the no-removal rule, the first-run list; UX-S4 Empty, the beyond-v1 clause (the
  browse entry as the route); § 4 (the identity element as the selector, RN-2, RN-15); UX-F1 (the
  arrival state, re-entered); UX-I7, UX-I17; § 4 C-E2, C-E3, C-E5, C-E6 of this document. How the
  current entry is marked is `docs/DESIGN.md`'s and is not traced here.
- **Moves toward:** first — switching the viewed folder, the last of the three; after it the
  terminus's surface is whole as drawn.
- **Not in this slice:** several folders at once — never; removing an entry from the list, or
  clearing it — never (UXD UX-S7); the 1.0.0 release — `promise-one-point-zero`; a folder switched
  to being opened any differently from `open-a-folder` — the root finding is applied to it afresh.
- **Why here in the order:** Last of the surfaces because it is the one slice that adds an
  entitlement (C-R2) and so the one that changes the wall — landing it after every other surface
  keeps the entitlement list frozen through every release gate before it; and because it
  *validates* NFR-12 against the fullest viewing surface: the tree, the Git view and the reading
  panel are all built, and the bar is that none of them moves. It depends on nothing after
  `choose-a-theme` and could have landed earlier; the reason above is a preference, stated as one.

### S-11 — The number becomes a promise

- **Slug:** `promise-one-point-zero`
- **Delivers:** After this, an adopter can rely on the version number: the release reads 1.0.0, the
  README's "anything may change" caveat is gone, and in its place the contract the number covers is
  stated as two kinds of thing, each member naming the constraint that places it — **what the
  number prices:** the one install path and the macOS floor, and every surface the PRD names
  present, so that removing a surface, raising the floor, adding a prerequisite or changing the
  install path costs a major version; and **what no version changes:** no write to the viewed
  folder ("no write path to the viewed folder exists in any version", `docs/SRS.md` C-2), no
  telemetry (NFR-7), no network call during operation — whose only route in is the one the SRS
  names, a PRD revision stating the feature before it exists, and until one lands, none (NFR-8) —
  and own state read whole or discarded whole, touching no folder (§ 4 C-D4). **Not covered, at
  any version:** the exact wording of any message, any token value, the diagnostic log's lines,
  and anything the harness prints — a change to any of those breaks no promise, so `docs/CONTENT.md`
  and `docs/DESIGN.md` may move without a major version. Which members the contract covers was the
  owner's call, and is made — the four members above and the exclusions, confirmed as drafted
  (`docs/trail/sdd/cycle-2.md` § 2.2); which kind a member is follows the rule RN-19 states.
- **Reached when:** *Observable (CDO):* this slice adds no surface, so what a person watches is
  the whole surface again, on the 1.0.0 bundle they downloaded: every observable half of S-1 to
  S-10 walks as written, in both themes, against a repository and a plain folder. The release page
  reads 1.0.0. The README's "anything may change" sentence is gone and the contract stands in its
  place, in the two kinds S-11's *Delivers* states; the posture sentence is still there, still not
  on the first screen; the screenshot is 1.0.0's shell (`docs/UXD.md` UX-A3, UX-I11). They launch
  1.0.0 over the state a previous release left: their theme, their window and their remembered
  folders are as they were, and no surface says anything about a migration. They launch it over a
  state file they have corrupted: it opens as on first run — the Open panel, then the selector
  holding only browse — and no sentence in the window mentions the state (UX-S7 Empty, UX-I13; § 4
  C-D4). No message, no token, no line of the log and nothing the harness prints is different from
  the release before in a way a reader would call a promise broken, because none of those is the
  promise (`docs/trail/sdd/cycle-2.md` § 2.2). *Command (CTO):* the tag is `v1.0.0` and `Cargo.toml`, `CFBundleShortVersionString` and
  the release page agree; every command in
  `first-public-release`'s half passes again on the downloaded bundle, with two differences —
  `checks/bundle.sh` now against C-R2's three entries, and that half's closing check inverted: the
  version is 1.0.0, not below it; `checks/contract/1` exists, written from this bundle and this
  build's `libnozoki_bridge.a` — the floor `14.0`, the two asset names, SM-4's ten functions and
  `nozoki_free` — and `checks/contract.sh v1.0.0` passes against it (C-I6); `checks/own-state.sh --from
  <previous-tag>` passes — a container
  written by the previous release is opened by this build with no write outside the container, and
  a container the build cannot read leaves it at first-run state with no failure surface (C-D4);
  `checks/latency.sh`'s figures are within the numbers the SRS now carries, or the SRS still
  carries none and the figures are attached to the release (C-I4). *The promise clause, over the
  terminus whole:* `checks/read-only.sh` prints `unchanged` on every fixture after every command on
  `SM-4`'s complete list — `open_diff`, `walk_history`, `switch_folder` and `asset_bytes`
  included — and after
  `--kill`; `checks/no-network.sh` exits 0; the network monitor across a full session exercising
  diffs, history and a switch records zero outbound connections (AC-12 with AC-1 – AC-3).
- **Rests on:** § 4 C-R4, C-R5, C-D4, C-I3, C-I4, C-I6; § 9 TO-8 (raising the floor is now a
  major version); § 11 R-7, R-12. Slices: `first-public-release`, `switch-the-folder`,
  `read-the-history`.
- **Traces to:** PRD § Assumptions "Versioning" — "Reaching 1.0.0 is a product event — the moment
  the promise starts"; § Goals "Pick-it-up adoption"; § Success Metrics "Read-only integrity",
  reckoned at the closing release. SRS: C-6 (the 1.0.0 half), C-11, C-3; NFR-9; DR-5; AC-12,
  AC-13, AC-14; AC-1 – AC-3 at the closing release. UXD: no section of its own — this slice
  realizes no experience entry the ten slices above do not; every UXD trace they carry is re-walked
  here at the closing release. The two public-surface entries recur by name: UX-I11 (the screenshot
  is 1.0.0's shell) and UX-A3 (the posture sentence, still placed as it binds); UX-S7 Empty and
  UX-I13 for the unreadable-state launch; § 4 C-E9, C-E10 of this document.
- **Moves toward:** third — "public under the MIT licence at version 1.0.0 or later — the
  semantic-versioning promise in force"; with it the terminus is reached.
- **Not in this slice:** any new surface — none; a second platform — outside done; a breaking
  change — after this slice, priced, batched and announced, never casual (PRD § Assumptions
  "Versioning"); any member the contract does not name — none is on offer: the owner confirmed
  the draft as it stands (`docs/trail/sdd/cycle-2.md` § 2.2), and widening it changes what the
  product promises, which the routing rule sends to the owner (RN-19), never to a slice.
- **Why here in the order:** Last by dependency: the promise it starts covers every surface the
  PRD names, so the surface must be whole (`switch-the-folder`, `read-the-history`); the caveat it
  withdraws was made by `first-public-release`; and the own-state test across versions needs a
  previous release to read from.

## 7. The order, and why

<The dependency edges between the slices in § 6, one row each. This table is a **projection of
§ 6, not a second store**: when the two disagree, § 6 is right and this table is stale
(`huangruiteng/loopx`, `docs/reference/protocols/task-graph-projection-v0.md` — the graph is
read-only over state that lives elsewhere).

Use these relations and no others. `depends_on` is the only one that constrains the build order;
the rest describe the cut without ordering it.>

| From | Relation | To | Why — the reason this holds |
|---|---|---|---|
| `read-a-file` | `depends_on` | `open-a-folder` | The file is selected from the tree the folder's grant produced; there is no other way to name one (FR-5, FR-7) |
| `read-markdown` | `depends_on` | `read-a-file` | Rendered Markdown is a treatment of the reading panel `read-a-file` opens, not a surface of its own (`docs/UXD.md` UX-I12, § 9) |
| `see-git-status` | `depends_on` | `open-a-folder` | The root finding is asked of a granted folder (FR-33) |
| `see-git-status` | `depends_on` | `read-a-file` | A changed file's row opens the file for reading exactly as a tree selection does (FR-13, first reading) |
| `follow-the-folder` | `depends_on` | `read-a-file` | There is no open file to update and no file-gone state to show without the reading panel (FR-14, FR-28) |
| `follow-the-folder` | `depends_on` | `see-git-status` | Git state has no surface to change on until the Git view exists; the Git clause of FR-14 cannot be met without it |
| `choose-a-theme` | `depends_on` | `open-a-folder` | The theme control lives in the shell chrome (`docs/UXD.md` § 4) |
| `first-public-release` | `depends_on` | `read-markdown` | No release ships a `.md` shown as plain text — FR-30 "displayed rendered by default" (RN-18) |
| `first-public-release` | `depends_on` | `choose-a-theme` | Both themes are a first-release requirement (FR-20, AC-11) |
| `read-a-diff` | `depends_on` | `see-git-status` | The diff is opened from the Git view's row, whose reading changes when the diff is present (FR-13, FR-17) |
| `read-the-history` | `depends_on` | `see-git-status` | The history is entered from the Git view (`docs/UXD.md` UX-S6) |
| `read-the-history` | `depends_on` | `read-a-diff` | A commit's diff uses the same presentation as a file's (FR-22) |
| `switch-the-folder` | `depends_on` | `open-a-folder` | Switching replaces a folder that was granted; the second folder is opened exactly as the first (FR-19, FR-33) |
| `switch-the-folder` | `depends_on` | `choose-a-theme` | The remembered list lives in `own-state`, which `choose-a-theme` builds (`SM-6`, C-D4) |
| `promise-one-point-zero` | `depends_on` | `first-public-release` | The caveat it withdraws was made there, and the own-state test across versions needs a previous release to read from (C-D4) |
| `promise-one-point-zero` | `depends_on` | `switch-the-folder` | The promise covers every surface the PRD names; the surface must be whole (Agari, first condition) |
| `promise-one-point-zero` | `depends_on` | `read-the-history` | The same — and `read-the-history` carries `read-a-diff` by its own edge |
| `first-public-release` | `validates` | `open-a-folder` | The wall proven on every CI build is proven again on a downloaded, ad-hoc-signed artifact through a stranger's Gatekeeper walk (R-2, R-8) |
| `follow-the-folder` | `validates` | `read-a-file` | The reducer keyed by path, built for the first read, is shown to keep the reader's place under churn and kill (FR-27, NFR-4) |
| `switch-the-folder` | `validates` | `open-a-folder` | Replace-whole, designed into the model at the first slice, is shown by the change that adds the selector touching no viewing surface (NFR-12) |
| `see-git-status` | `hands_off_to` | `read-a-diff` | The row control: one click target whose reading `read-a-diff` changes (FR-13) |
| `read-a-diff` | `hands_off_to` | `read-the-history` | The diff treatment of the reading panel, reused for a commit's diff and not redrawn (FR-22, UX-S5) |
| `open-a-folder` | `hands_off_to` | `switch-the-folder` | The grant and the identity element: the folder's name in the chrome becomes the selector (`docs/UXD.md` § 4, UX-F5) |
| `read-a-diff` | `supersedes` | `see-git-status` | On the row's reading only: where the diff is present the row opens it and the file is read from the tree (FR-13, second reading); nothing else of `see-git-status` is superseded |
| `promise-one-point-zero` | `supersedes` | `first-public-release` | On the version statement only: "anything may change" is withdrawn and the contract stated in its place (C-6) |

The order § 6 states is the `depends_on` rows above plus three placements no edge forces, each
carried in its slice's *Why here in the order*. They are not all of one kind. **One is the owner's
decided ordering:** `first-public-release` after `follow-the-folder` — the first public release
waits for the full v1 cut (RN-17). It is not a `depends_on` row, because step 3's test is what can
be built and that slice could be built earlier — a row there would be a ruling wearing a
dependency's clothes, which is the failure step 3 exists to catch; and it is not a preference,
because a preference reorders for free and this does not: moving it is a re-cut under § 10 with
RN-17 as the ground, never a re-sort at the cut. **Two are this seat's preferences,** stated as
such: `read-the-history` before `switch-the-folder` (the port completed before the wall changes);
`switch-the-folder` last (the one entitlement change, and NFR-12 validated against the fullest
surface).

## 8. Slice → seeds

<Stated once, here, so that cutting a slice is reading rather than re-deriving. A slice is **not a
seed**: the Principal PM draws one and cuts it into **one or more** 根回し Nemawashi seeds, authored
to `<CORE>/templates/journey-templates/nemawashi_template.md`. How many, and when a slice is drawn
at all, are that seat's — `<CORE>/roles/loaders/principal_pm_global.md` owns the round, and this
section neither restates it nor constrains it. What this section owns is the other half:
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

- **TO-1:** One process and one C-ABI seam, the shell drawing only what crosses it — *buys* a wall
  that covers the whole product with one entitlements file and one probe (C-R2, C-I3), a shell
  with no script engine to wall off, and no serialization on every projection; *costs* the
  renderer wall — a process that could be handed *no* capability — replaced by a shell whose "no
  I/O of its own" is a source scan and a link check on every build (C-R7), not a process boundary;
  *undoing it costs* the bridge re-wired as IPC, the model untouched — when a view exists that
  starts under the rule and earns the seam (§ 2, the second row). *(Until v12 this row read the
  other way: two processes, bought for the renderer wall; § 10 RC-3.)*
- **TO-2:** A native C dependency, libgit2, vendored and built — *buys* zero prerequisites on a
  fresh Mac (a spawned `git` prompts a Command Line Tools install on a fresh macOS —
  https://developer.apple.com/documentation/xcode/installing-the-command-line-tools — inside the
  five-minute clock), no optional-lock write under `.git` (`git status` refreshes the index unless
  `--no-optional-locks` — https://git-scm.com/docs/git-status), and a binary in which the absence
  of a mutating call is a fact, not a discipline; *undoing it costs* the installed-`git` adapter
  behind SM-2, whose seam is already drawn.
- **TO-3:** The App Sandbox (C-R2) — *buys* an operating-system wall against writes and
  connections that a crash cannot lower (NFR-4); *costs* the start mechanism (a folder granted
  through the Open panel rather than typed, C-R3), bookmarks for remembering, and the
  linked-worktree and submodule cases whose Git directory may lie outside the grant (§ 11 R-3);
  *undoing it costs* one entitlements file — and the wall.
- **TO-4:** A view drawn by AppKit — Apple's, moving with macOS — *buys* no engine bundled, no UI
  dependency at all (C-R6), and the look the design starts from drawn by the platform that
  defines it (`docs/DESIGN.md` § Overview); *costs* a second language, Swift, beside Rust and one
  C ABI between them (SM-4), Markdown laid out by TextKit from a document tree rather than by a
  web engine from CSS — UX-I12's two hard cells, an image or its placeholder in the flow and code
  on its own surface, are what the CDO priced that at (`docs/trail/sdd/cycle-9.md` § 1.1) — and
  layout fixtures re-walked per macOS generation (C-R5; § 11 R-11); *undoing it costs* every
  surface rewritten (§ 2, "Undoing it") — paid once already, from the WKWebView (§ 10 RC-3).
- **TO-5:** The Markdown raw-source switch is **not built** — FR-31 permits it only "if it costs
  nothing", and it does not: switching "preserves the reading position both ways"
  (`docs/UXD.md` UX-I12), which needs a rendered↔source position mapping with no other use.
  A release ships rendered-only and says so where it is offered (AC-22); *buys* nothing added to
  the reading panel for a feature outside done; *undoing it costs* the mapping and one control.
  **The relative link opening its target is built** (FR-32's permission): a *relative* link node
  the shell turns into the existing `select_file` call, on a path the containment check already
  validates — one node kind and no new capability (RN-10). *(Re-read under the native view,
  2026-09-23: the switch is no cheaper when both treatments are TextKit's — the raw source is the
  code treatment over the same bytes, and the position between a rendered block and its source
  line is still a mapping with no other use; the judgment stands. RN-60.)*
- **TO-6:** Image bytes cross the seam as bytes, for a contained path, and are decoded in the one
  process by the platform's decoder — *buys* a README whose in-folder images render in place with
  the network off (UX-I12), with no asset scheme, no handler and no policy to widen; *costs* a
  hostile bitmap decoded inside the process the wall covers (§ 11 R-4), and a containment check
  that must be right about `..`, symlinks, percent-encoding and Unicode normalization, run twice
  (SM-7) — where *right* at a position outside the grant means refused as outside, never taken
  for inside, since the check reads nothing there (§ 3 `fs-reader`; RN-71); *undoing it costs* an
  out-of-process decoder — a second process, under the rule (§ 2,
  the second row's condition) — or the placeholder returning for every image.
- **TO-7:** No harness drives the AppKit views (C-I3) — *buys* a proof that runs in CI on macOS
  with no UI driver and no Xcode project; *costs* the shell's actual use of the bridge being
  exercised only by the timed release walk (AC-10) — the renderer gate exercises no bridge call,
  since the shell makes none before the panel returns; what the gate shows is that the launched
  shell ran its launch flow as far as the panel — accepted because the shell
  holds no I/O the harness could catch it using (C-R7); *undoing it costs* an XCUITest target and
  the Xcode project it needs, when one is worth what it brings.
- **TO-8:** A macOS floor of 14 where nothing in the stack forces one above 11 (C-R5) — *buys* one
  walk per release over the versions the maintainer will actually run, and fewer AppKit
  generations to walk UX-I12's layout fixtures on; *costs* every adopter on 12 or 13; *undoing it
  costs* a plist line and the walk widened — cheap before 1.0.0, a breaking change after it (C-6).
- **TO-9:** Ad-hoc signing, never notarized (C-R4) — *buys* a channel that costs nothing and
  holds no signing secret in CI; *costs* a Gatekeeper step inside every stranger's first five
  minutes, and a sandbox whose enforcement is proved by a probe rather than a signing chain
  (§ 11 R-2, R-8); *undoing it costs* a paid identity — a reversal the owner has ruled out
  (`docs/adr/0007-ad-hoc-signed-dmg-on-a-github-release.md` § Context).
- **TO-10:** A port for one edge only (SM-2) and none for the filesystem — *buys* the one
  substitution the design expects (§ 11 R-1) at one seam's cost; *costs* nothing insulating the
  filesystem edge, which is Apple's and stable; *undoing it costs* a second port, drawn the day a
  second filesystem is a live case, which nothing inside the terminus makes it.
- **TO-11:** The six grammars compiled by tree-sitter (§ 3 `highlighter`) — a second body of
  native C in the product beside libgit2 (TO-2), this one built from source into `nozoki-core` on
  every build — *buys* no lexing for six languages written and kept in the core, and a bundle
  that holds the six grammars and no others: what hand-written lexers and `syntect`, the two
  alternatives the dependency review weighed, would each have cost (`checks/deps.review.md`
  § *The engine chosen*, `nozoki@85d9fa7`); *costs* a C compile in every build, the names the
  engine adds to `checks/deps.allow` and the notices those names owe `THIRD_PARTY_NOTICES.md`
  (C-R6; the names are that list's and no count is kept here), a runtime and six grammars whose
  releases are followed upstream, and C that parses the folder's bytes inside the unit whose own
  source holds no `unsafe` (§ 3; § 11 R-14); *undoing it costs* `highlighter` rewritten behind
  what it owns — text and a floor language in, spans in the five classes out — with its query
  files, the names taken off the list in the same change (C-R6), and § 3's row re-pointed. No
  seam, no other part and no slice's bar moves with it: `read-a-file`'s bar reads the spans and
  the list, and names no engine. The weighing is the record's and is not redone here (RN-80).

## 10. Re-cut record

<A cut meets a reality that contradicts it, and the contradiction is recorded **before** the cut is
redrawn. A cut silently redrawn leaves the next reader unable to tell a correction from a drift.
Shape borrowed from `huangruiteng/loopx`,
`docs/reference/protocols/goal-vision-replan-contract-v0.md` § *Path Delta*.

Re-cut when, and only when, one of these holds: a slice's *Reached when* cannot be met as written; a
slice turned out to be a fragment once its neighbour landed; no slice is left that can be started;
or the PRD, SRS or UXD changed upstream. Finishing a slice is not a trigger.

Omit this section until the first re-cut. An empty heading reads as a cut already in doubt.

**A re-cut that moves the shape is also an ADR.** This section is the home for *cut* history — the
slices are this document's own and no other record holds them, and that does not change. But an
`RC-n` whose *Changed* line moves § 2's shape or § 3's seams is an architecturally significant
reversal, and the decision log is append-only: it lands there as a **new record superseding** the one
it reverses, in addition to the row here. Without that, shape history has two homes and the log
silently misses every reversal made mid-build.>

### RC-1 — 2026-09-19 — the observable C-I3's bundle probe reads, and the `open-a-folder` command bar that quotes it

- **Prior assumption:** A sandboxed process carries `APP_SANDBOX_CONTAINER_ID` in its environment,
  so `checks/bundle.sh` finding that marker in the launched bundle proves the App Sandbox is
  enforced under an ad-hoc signature. The cut held this without a vendor locator and said so: the
  fourth *Open Questions* item named the first slice's first built bundle as what would settle it,
  and a wrong observable as "a re-cut trigger on the probe's mechanism".
- **Observed reality:** The first built bundle — ad-hoc signed, both C-R2 entitlements `true` —
  fails the probe under four launch routes while its sandbox holds: over the same process
  `sandbox_check` reports a read of `~/.zshrc` and outbound network denied, and
  `~/Library/Containers/com.kensaiapp.nozoki` is created at first launch. A trivial ad-hoc app with
  the same two entitlements behaves the same way, and the same binary with no entitlements is
  unsandboxed and also shows no marker (`nozoki@ccb58d8`, commit body; macOS 26.6.2, arm64). A
  team-signed sandboxed third-party app measured on the same Mac carries no marker in its main
  process, though its two helper processes do (`docs/trail/sdd/cycle-4.md` § 5.1). So the marker
  is absent from a sandboxed main process under either signature and does not separate a
  sandboxed bundle from an unsandboxed one. `open-a-folder`'s command half could not be met as
  written by any build. R-8 did not fire: the wall stands, and what failed is the observable.
- **Retained:** § 2's shape, § 3's parts and seams, every slice, every § 7 edge and the order.
  C-R2's entitlement list and its *Violated by*, which names the probe and not its mechanism. The
  entitlement half of `checks/bundle.sh`. The probe running on every build from the first slice
  (§ 5 step 5) — this finding arriving with one reader written is what that placement was for.
  The ad-hoc signature (§ 9 TO-9) and R-8's response.
- **Changed:** C-I3's runtime observable is now the operating system's own report on the launched
  main process — sandboxed, with an out-of-grant file read and an outbound network connection both
  denied — with a no-entitlement control that must fail (§ 4 C-I3). § 6 `open-a-folder`'s *Command*
  bar, § 11 R-8's *shows up as* and the fourth *Open Questions* item state the same observable.
  Neither § 2's shape nor § 3's seams move, so this entry owes the decision log no superseding
  record on that ground. ADR-0008 and NFDR QC-25 still state the marker
  (`docs/adr/0008-harness-over-core-and-bundle-probe-from-first-build.md:L28`, `docs/nfdr.md:L203`);
  both are the Principal Architect's to bring into line (§ 12). *(Both were, since this entry was
  written: ADR-0010, Accepted 2026-09-19, supersedes ADR-0008 with this observable as its
  § Decision, and QC-25 reads the sandbox report — `docs/nfdr.md:L246-L252`. Noted 2026-09-23,
  RN-56; the sentence above is left as it was written.)*
- **Stopped:** Reading any environment variable as evidence of the sandbox. Taking the container
  directory as evidence: it survives from an earlier launch, so a stale one would pass an
  unsandboxed rebuild.
- **Still unresolved:** Whether the probe reads the same on a GitHub-hosted macOS runner, which no
  one has measured (`nozoki@ccb58d8`: "I did not test another macOS version or a hosted runner") —
  carried in *Open Questions* when this entry was written; measured on 2026-09-23 and closed at
  RN-48: the wall holds there, and a read-once probe read too early. Why helper processes carry
  the marker and a main process does not is unexplained by the records; the design no longer
  rests on it.

### RC-2 — 2026-09-23 — C-R2's exact list, the renderer that list cannot start, and the gate `open-a-folder`'s command bar lacked

- **Prior assumption:** C-R2 granted exactly two entitlements and held that a bundle carrying
  them — sandboxed, the read and the connection denied — was a bundle a person could use.
  `open-a-folder`'s command bar proved the wall (`checks/bundle.sh`) and nothing about the page.
  That the renderer would run was inferred from the sandbox not forbidding it; no document asked
  whether WebKit's own processes start under those two entitlements.
- **Observed reality:** The bundle CI built from `e7b2bcd` passed every gate and opened one empty
  window with no Open panel (`docs/trail/sdd/cycle-8.md` § 5.1). The mechanism, found from the
  unified log on the Mac the owner sampled and from WebKit's source: every WebKit XPC service
  checks the *host's* entitlements at its own start — `XPCServiceInitializerDelegate::checkEntitlements()`
  — and when the host is sandboxed and lacks `com.apple.security.network.client`, it asks the
  sandbox whether the host may `mach-lookup` `com.apple.nsurlsessiond`; denied, it logs
  `Application does not have permission to communicate with network resources` at fault level and
  returns false, so the service does not initialize
  (`Source/WebKit/Shared/EntryPointUtilities/Cocoa/XPCService/XPCServiceEntryPoint.mm`,
  https://github.com/WebKit/WebKit/blob/bb75cbc0003033ea73c42ef02370767aa52d6ba6/Source/WebKit/Shared/EntryPointUtilities/Cocoa/XPCService/XPCServiceEntryPoint.mm
  — WebKit's own comment beside the check: "This requirement is too strict, it should be possible
  to load file:// resources without network access", `rdar://problem/54178641`). On this Mac,
  `log show` over the owner's two sampling windows of 2026-09-23 carries that fault once from
  `com.apple.WebKit.GPU` and then from a fresh `com.apple.WebKit.Networking` pid every 15–30 ms
  for the whole window, under a launched `nozoki-app` (the command and its lines are RN-52). That
  relaunch loop is the `WebProcessProxy::processDidTerminateOrFailedToLaunch` the sample showed;
  the content process never gets a network process to pair with, the page never runs, and
  `main.ts` never reaches `open_folder`. The requirement is not new and not this product's:
  reported against macOS 10.14.6 on 2019-08-11 and still open (FB6993802,
  https://github.com/feedback-assistant/reports/issues/1), answered on Apple's forum the same
  year with the deprecated in-process WebView as the only way round
  (https://developer.apple.com/forums/thread/116359), and reported to Tauri as a white screen in
  sandboxed apps without the entitlement (https://github.com/tauri-apps/tauri-docs/issues/3171).
  The check lives in WebKit's process-launch path and reads the host's entitlements and sandbox:
  **no WebKit setting, no Tauri configuration and nothing in this product's code reaches it.**
  Two entitlements pass it — the network-client entitlement, which the owner refused (answer 1),
  and one granting the host that single mach-lookup
  (`com.apple.security.temporary-exception.mach-lookup.global-name` naming
  `com.apple.nsurlsessiond`), which is unmeasured and which this seat reads as a network
  entitlement under another name: the service it opens is the one WebKit's own check treats as
  network access. *(The ground in the sentence just given was withdrawn at run 11: the
  `mach-lookup` is a stand-in in `checkEntitlements` and opens nothing by itself; what passing it
  starts is WebKit's Networking process, whose own sandbox profile allows outbound TCP and UDP
  unless `BlockNetworkAccess` is set. RN-56 and `docs/trail/sdd/cycle-9.md` § 1.1, the CTO's
  addition, carry the corrected ground and its WebKit sources; the sentence keeps its words.
  Confirmed by the owner, `docs/trail/sdd/cycle-9.md` § 2.2, 2026-09-23; RN-61.)*
  `open-a-folder`'s command half could not be met as written by the bundle its
  wall half admits. R-8 did not fire: the wall stands, and what failed is the renderer behind it.
- **Retained:** § 2's forces and the sandbox wall — the ruling makes the wall firmer, not weaker.
  § 3's parts and seams. Every slice, every § 7 edge and the order. C-R2's v1 members (the two
  entitlements, the third from `switch-the-folder`) — under a rule now, not a list.
  `checks/bundle.sh` whole. R-8's response. The ad-hoc signature (§ 9 TO-9).
- **Changed:** C-R2 states the owner's rule and its *Violated by* names a network entitlement of
  any kind, an entitlement with no record, and a probe report of either denial allowed. C-I3 gains
  the renderer gate — `checks/renderer.sh`: the launched main process observed inside
  `open_folder` within a bounded window, the renderer-build-removed bundle its red control — and
  `open-a-folder`'s command bar quotes it. § 12's downstream boundary records the departure from
  ADR-0003's *exactly* (RN-52). Neither § 2's shape nor § 3's seams move in this entry, and the
  entry owes the decision log no superseding record on that ground — **but it records that two
  conditions cannot both stand:** C-R1 renders `nozoki-ui` in the system WKWebView (ADR-0002),
  and C-R2 as now written forbids the one thing WKWebView requires to start. Which gives way is
  the owner's — the runtime was the owner's confirmation
  (`nozoki@70a879a:docs/trail/sdd/cycle-1.md` § 2.2) and the rule is the owner's ruling — and it
  is the companion's one item (§ 1.1), where this seat's position is written; it is not written
  here. Until it is answered, no build meets `open-a-folder`'s command bar, and every later slice
  rests on it (§ 7).
- **Stopped:** Reading a green wall probe as a bundle that runs. Taking "no entitlement forbids
  it" as evidence that a system process will start. Holding an entitlement set by exact members.
- **Still unresolved:** The renderer (companion § 1.1) *(answered — the owner's (a),
  `docs/trail/sdd/cycle-9.md` § 1.1; the cut is redrawn at RC-3)*. Whether `checks/renderer.sh`'s
  observation reads the same on a GitHub-hosted runner (*Open Questions*) *(measured — the
  runner matched the script's frame list, run 35988399477, 2026-09-24; the item is closed and
  removed from *Open Questions*, and C-I3 carries the reading; noted 2026-09-24, RN-70)*. ADR-0003 § Decision and
  NFDR QC-25 (`docs/nfdr.md:L243-L245`) still state *exactly*, and are the Principal Architect's
  to bring into line (§ 12) *(QC-25 states the rule since NFDR v10, and ADR-0011 restates ADR-0003
  under it, Proposed — `docs/nfdr.md` § Version, its v10 note; `docs/adr/README.md`; noted
  2026-09-23, RN-61)*.

### RC-3 — 2026-09-23 — the renderer leaves WKWebView: one process, an AppKit shell in Swift, a C-ABI seam in place of IPC

- **Prior assumption:** Two processes: a host holding read capability and a renderer holding
  none, the seam between them a closed command list and one asset scheme, and that seam the
  promise (§ 2's first row to v12; § 3 SM-4; § 9 TO-1). The renderer was the system WKWebView
  (C-R1; ADR-0002), and § 2 force 4 held the renderer technology as not replaceable inside the
  terminus, priced "expensive" under *Undoing it* and never expected to be paid.
- **Observed reality:** RC-2's — WebKit's processes check the host's network entitlement at
  their own start, and the owner's rule forbids it (`docs/trail/sdd/cycle-8.md` § 5.1) — and the
  owner's second ruling on the exit: the renderer leaves WKWebView; no network entitlement and no
  mach-lookup exception; (b) and (c) refused, (d) and (e) not exits (`docs/trail/sdd/cycle-9.md`
  § 1.1, 2026-09-23). Two facts the weighing added. A view that executes nothing has nothing for
  a second process to wall off: content laid out by a text engine from typed data carries no
  script for a renderer wall to contain, so the wall the previous shape bought guarded a threat
  the new one does not have. And under one process the rule covers the whole product: no process
  the product runs has a network profile of its own, which was (c)'s exact gap (RN-56).
- **Retained:** § 1 whole. § 2's forces 1, 2 and 7 as written; forces 3, 4, 5 and 6 with the
  rulings folded in. The sandbox wall, C-R2's rule and the entitlement set. § 3's seven
  `nozoki-core` parts — `fs-reader`, `git-reader`, `watcher`, `folder-model`, `own-state`, and
  `markdown-renderer` in its place with its output redrawn — and SM-1, SM-2, SM-3, SM-6 as
  written. SM-4's function names, the closed-list rule and its staging by slice (C-R7). Every
  slice, every slug, every *Delivers*, every § 7 edge and the order: step 1 made the entries from
  behaviour and never from the boxes (RN-30, RN-59). `checks/bundle.sh` whole; the renderer gate's
  two rules — observed from the process, never from a marker; a control that must go red — and its
  place after the wall probe (ADR-0012's decision). C-D3's three-wall structure and the SVG
  exclusion (RN-8). TO-2, TO-3, TO-5's judgment, TO-9, TO-10. R-1 – R-3, R-5 – R-10.
- **Changed:** § 2's taken shape is the **sandboxed single-process read pipeline**, the previous
  shape now the second row and rejected on the rulings; the view is AppKit in Swift, chosen over
  a Rust toolkit, an in-process web engine and AppKit through `objc2`, each with its row or
  paragraph. § 3: `ipc-surface` (`crates/nozoki-app`) and `surfaces` (`nozoki-ui`) leave;
  `core-bridge` (`crates/nozoki-bridge`), `mac-shell` and `surfaces` (`nozoki-mac`) and
  `highlighter` (`crates/nozoki-core`) arrive; the units table reads Rust, Rust, Swift, Shell;
  SM-4 is a C ABI with `asset_bytes` its ninth function and the header generated, SM-5 – SM-7
  name the bridge, SM-8 is new; `markdown-renderer` emits a `MarkdownDocument` and no HTML.
  § 4: C-R1 (one process, no web engine), C-R6 (no Swift dependency), C-R7 (from CSP and
  capability grant to the shell's no-I/O scan and the bridge's export set), C-I3 (the harness
  against SM-5; the gate's observable and its control re-derived), C-I6 (the pin reads the
  exports), C-D3 (the three walls: the check, the document as data, the decoder fed by the check
  alone). § 5 step 5's first-slice sentence. § 6 S-1 – S-3, S-6 – S-11's command halves and CTO
  *Rests on*. § 9 TO-1, TO-4, TO-6, TO-7, TO-8. § 11 R-4, R-11, R-12, and R-13 added. **This
  entry moves § 2's shape and § 3's seams, so it owes the decision log superseding records** — for
  ADR-0001 (the shape), ADR-0002 (the runtime, renderer and view language), ADR-0006 (the sanitizer
  and the asset scheme) and ADR-0009 (the unit set) — and the enforcement store a re-derivation of
  every entry written against the previous shape (§ 12, the downstream boundary). Both are the
  Principal Architect's; this document surfaces and records nothing there (RN-60).
- **Stopped:** Reading a second process as the way a "never" is held — the wall is the process's
  entitlements, and a view that executes nothing needs no wall of its own. Pricing a view's
  replacement as unforeseeable: it was paid, and the price is on this row. Rendering untrusted
  content as markup anywhere in the product.
- **Still unresolved:** The frames `checks/renderer.sh` reads on the native shell, and whether
  they read the same on a hosted runner (*Open Questions*) *(measured — the five frames are the
  script's header's, `nozoki@153f5a1:checks/renderer.sh:L53-L61`, and the runner matched that list, run
  35988399477; the item is closed and removed from *Open Questions*, and C-I3 carries the reading
  and the observable's corrected name; noted 2026-09-24, RN-70)* *(the list holds four frames
  since `nozoki@b75348f`, and the runner matched the four, run 36795836747; C-I3 carries both
  readings; noted 2026-10-01, RN-76)*. How TextKit lays out UX-I12's two hard
  cells, and which engine compiles the six grammars (*Open Questions*) *(the engine is decided —
  tree-sitter, in a change of `read-a-file` under C-R6, `checks/deps.review.md` § *The engine
  chosen*, `nozoki@85d9fa7`; that item is closed and removed from *Open Questions*, § 3
  `highlighter` names the engine, and the TextKit item stands; noted 2026-10-01, RN-80)*. The records and the NFDR
  entries owed above (§ 12). The project card's `Languages:` and test command, and
  `README.md:L46-L51`'s stack and proof sentences — outside this document (RN-59, RN-60) *(the
  card moved: `Languages: Rust, Swift, Shell` and `swift test --package-path nozoki-mac` in its
  test command, `kensaiapp-opensource@5b27023`; noted 2026-09-23, RN-66)* *(the README moved:
  `## Stack` and the status block now name the one bundle and one process, `nozoki-mac`,
  `crates/nozoki-core` and `crates/nozoki-bridge`, and no web engine, and they keep the `checks/`
  proof sentence word for word, `nozoki@61748fe`; the sentences this clause cites stand at
  `nozoki@a4ab8e6:README.md:L46-L51`; noted 2026-09-24, RN-68)*.

### RC-4 — 2026-10-04 — SM-4's closed list gains `read_git`, the call `see-git-status` shows Git state through

The seat whose ground moved is the CTO's: what could not be met is `see-git-status`'s observable
half, and what failed is not that half but the seam under it (§ 3 SM-4; § 4 C-R7).

- **Prior assumption:** SM-4's nine calls were everything the shell would ever ask of the core,
  and Git state would reach the shell on the `model_changed` callback: `see-git-status`'s *Rests
  on* read "`SM-4` (`model_changed` carrying Git state)". C-R7 admitted no registration call for
  that callback until a slice raised one, and no slice had.
- **Observed reality:** No call on the list as written can bring the open folder's Git item to
  the shell without changing an answer the shipped shell already decodes
  (`docs/trail/sdd/cycle-25.md` § 5.1, raised by the PM). Read at `nozoki@ca915a4`: the export
  test admits `nozoki_open_folder`, `nozoki_list_tree`, `nozoki_select_file` and `nozoki_free`
  (`crates/nozoki-bridge/tests/exports.rs:L17-L22`); `grep -rn model_changed crates
  nozoki-mac/Sources` prints nothing, so no registration call exists; the bridge's own check
  holds an `opened` answer to one member (`crates/nozoki-bridge/src/boundary.rs:L51`) and the
  shell's decoder rejects an `opened` answer with any member besides `state`
  (`nozoki-mac/Sources/Shell/BridgePayload.swift:L49-L53`), so `open_folder`'s return cannot
  carry it; and § 4 C-I1 keeps `list_tree` and `select_file` answering as they do whatever the
  Git item holds. `folder-model` already carries the operation
  (`crates/nozoki-core/src/folder_model.rs:L273`, `read_git`), and no export reaches it.
- **Retained:** § 2's shape. SM-4's closed-list rule, its owner, its staging by slice, and
  `nozoki_free` beside the list and not on it. Everything SM-4 says crosses upward, the
  `model_changed` callback included. C-R7 word for word, its sentence on the registration call
  included: that call is still raised by the slice that needs it, which is `follow-the-folder`
  (§ 6 S-5 *Rests on*, "`model_changed` deltas"), and not before. C-I6 word for word; it reads
  the list by reference. Every slice, slug, *Delivers*, § 7 edge and the order. No existing
  call's answer changes.
- **Changed:** SM-4's list is ten: `read_git`, exported as `nozoki_read_git`, joins it between
  `open_relative_link` and `set_theme`, staged by slice like the rest. It takes no argument and
  returns the open folder's Git item as an owned buffer freed by `nozoki_free`: `root` with the
  Git state, `plain`, `failed` with its condition, or `pending` where no folder is open — what
  `list_tree` answers in that case (`crates/nozoki-bridge/src/session.rs:L308-L315`). It is on
  the list and not beside it because it reaches the model over SM-5, so it is a command, and
  `checks/read-only.sh` calls it in the build that exports it (§ 4 C-I3). The counts follow:
  SM-4's row ("all ten", "the ten calls"), § 6 S-11's pin ("SM-4's ten functions"), and the
  collapse-and-scroll item in *Open Questions*. `see-git-status`'s *Rests on* reads "`SM-4`
  (`read_git`)". **This entry moves a § 3 seam's list, so the decision log is owed a record on
  that ground:** ADR-0013 quotes the nine names and "all nine from `v1.0.0`"
  (`docs/adr/0013-sandboxed-single-process-read-pipeline.md:L44-L47`). `docs/nfdr.md` names
  SM-4's list (`docs/nfdr.md:L75`) and is re-derived from § 3 and § 4 as they now read. Both
  are the Principal Architect's; this document records nothing there (§ 12).
- **Stopped:** Carrying the Git item on `open_folder`'s return. Admitting the `model_changed`
  registration call for a slice with nothing to push: `see-git-status` shows "the state read
  when the folder opened" (§ 6 S-4 *Not in this slice*), and a callback adds a function pointer,
  a context lifetime and a second thread to the one unit that holds `unsafe` (§ 11 R-13).
- **Still unresolved:** When the model reads Git state — at open or on the first ask — and
  whether an ask on a `failed` item reads again: the design of the change that builds the call,
  bounded by S-4's fence, under which an `observed` item is not re-read in this slice. Which
  side orders two asks in flight (§ 3, the `surfaces` row; RN-76). Whether the Git view's
  reading state is drawn from the call's answer or under the `surfaces` row's exception: the
  design of the change that builds the view, bound by § 4 C-E1. And three things this document
  already ties to the first export that reaches `git-reader`, which `nozoki_read_git` is: the
  search-path switch and its test (§ 4 C-I3), the `nm` transport read in `checks/view.sh` with
  its suite case (§ 4 C-R6, C-I3; § 11 R-15), and the config-named-path item in *Open
  Questions* (§ 11 R-16). *(On 2026-10-04 the build that exports `nozoki_read_git` landed, at
  `nozoki@392177d`. It settled the first question: the Git item is read on the first ask after
  each successful open, and an `observed` or `failed` item is answered with no second read
  (`crates/nozoki-bridge/src/session.rs:L650-L653`). The search-path switch and its test
  landed there, and so did the `nm` read (§ 4 C-I3). The config-named-path item did not: its
  bound passed unmet, and the item is now settled no later than the build in which `mac-shell`
  first calls `nozoki_read_git` (*Open Questions*, the config-named-path item; § 11 R-16). The
  other two questions stand. `docs/trail/sdd/cycle-26.md` § 5.3, § 5.4; RN-91.)* *(Later on
  2026-10-04 that bound moved a second time, before the build it named had landed: the
  config-named-path item is settled in `see-git-status` before the slice is reached, and no
  build inside the slice bounds it. The parenthesis before this one is a dated record and its
  last bound is no longer the current one (*Open Questions*, the config-named-path item; § 11
  R-16). `docs/trail/sdd/cycle-27.md` § 5.1; RN-92.)*

### RC-5 — 2026-10-04 — the tree's marker join and the Git lists' row order stand in `surfaces` until `follow-the-folder`

The seat whose ground moved is the CTO's: what the build contradicts is `see-git-status`'s
*Rests on*, and under it § 3's placement of two pieces of projection logic. The slice's
*Delivers* and both halves of its *Reached when* keep their words.

- **Prior assumption:** `see-git-status`'s *Rests on* read "`folder-model` (`kind` resolved;
  `GitState`; the tree's markers)", so the model's `TreeEntry` would carry the changed marker
  in that slice. No sentence of § 3 named the part that orders the Git lists' rows.
- **Observed reality:** Read at `nozoki@b640345`. `grep -n marker
  crates/nozoki-core/src/folder_model.rs` prints nothing. `grep -rn model_changed crates
  nozoki-mac/Sources` prints nothing, and RC-4 holds that registration back to
  `follow-the-folder`. The join of the Git item onto the tree's rows was built in the shell
  (`git show 6c49d5c:nozoki-mac/Sources/Surfaces/TreeMarkers.swift` prints 68 lines; `git
  merge-base --is-ancestor 6c49d5c HEAD` fails, so it is not on `main`). The Git lists' order
  is computed in the shell on `main` (`nozoki-mac/Sources/Surfaces/GitRowOrder.swift`, since
  `nozoki@d65eec4`), and the core promises none
  (`crates/nozoki-core/src/git_reader.rs:L121`). The reasoning that follows is this seat's
  and is not a measurement. The Git item reaches the shell as `read_git`'s answer, after the
  tree's rows may already be drawn from `list_tree`'s answer. For the core to mark a drawn row
  in this slice, SM-4 would need a second `list_tree` ask or a changed `read_git` answer, and
  `follow-the-folder`'s delta would then replace that crossing. Raised from downstream by the
  owner and answered in this seat (`docs/trail/sdd/cycle-29.md` §§ 5.1, 5.2).
- **Retained:** § 2's shape. Every seam row, word for word. `folder-model` as the owner of the
  marker and of the lists' order: `FolderModel`'s sentence giving `TreeEntry` the changed
  marker stands. The `surfaces` row's one exception stays one. Every slice, slug, *Delivers*,
  § 7 edge and the order. `see-git-status`'s *Reached when*, both halves.
- **Changed:** `see-git-status`'s *Rests on* places the tree's markers and the Git lists' row
  order in `surfaces` for that slice. § 3's `surfaces` row states the placement, its four
  bounds and its end. § 3 `GitState` names the model as the owner of the lists' order and says
  where both are computed meanwhile. `follow-the-folder`'s *Rests on* carries the debt, and
  its command half gains a model case and a `grep` that is red while either file remains in
  the shell. No seam row and no § 2 row moves, so the rule in this section's opening note owes
  the decision log no superseding record on that ground. Whether a dated placement earns a
  record of its own is the Principal Architect's (§ 12).
- **Stopped:** Building the marker in the core inside `see-git-status` over a crossing that
  `follow-the-folder` would replace.
- **Still unresolved:** Whether the two implementations of the order ever sort the same names
  differently. `fs-reader` compares Rust `to_lowercase()` forms
  (`crates/nozoki-core/src/fs_reader.rs:L818-L832`) and `GitRowOrder` compares Swift
  `lowercased()` scalars (`GitRowOrder.swift:L13-L20`). Nobody has run one list of names with
  non-ASCII letter case through both. That run would settle it, and a difference found there
  is raised on this document's companion, because the bound's end would then be too late.
  Whether the
  `model_changed` delta can carry the marker is the design of `follow-the-folder`. Where it
  cannot, that slice's new command clause stays red and the question returns here as a re-cut.

## 11. Technical risks

<The risks this design carries, each with what would make it real and what the design does about it.
A risk with no trigger and no response is an observation.>

- **R-1:** libgit2 lags Git — a newer index format, a sparse index, an extension it does not
  know — *shows up as* a `failed` Git item on a repository the installed `git` reads fine, first
  in the harness's fixtures and then in an adopter's report; *response* the port (SM-2) is drawn
  for it: the installed-`git` adapter, run with `--no-optional-locks`, is built when this fires
  and passes the port's contract tests unchanged, spending C-3's one named prerequisite on it.
- **R-2:** Apple tightens Gatekeeper's treatment of un-notarized software again — on Sequoia a
  stranger already goes through System Settings › Privacy & Security rather than Control-click
  (https://developer.apple.com/news/?id=saqachfa) — *shows up as* the timed walk (AC-10) crossing
  five minutes on a macOS the floor admits; *response* the walk is re-run on every macOS the floor
  admits before each release, the README's click path is updated, and if the clock cannot be met
  the finding goes to the SRS's C-3 as a companion item — never to a signing identity (TO-9).
- **R-3:** A linked worktree or a submodule whose `.git` *file* names a Git directory outside the
  granted folder cannot be read past the grant — *shows up as* `probe` answering `root` and
  `state()` failing on the gitdir path; *response* the port reports it as a `failed` Git item
  whose observed condition is where the Git directory lies — this folder's Git state is
  therefore not read — and that offers no folder to choose, because choosing the folder that holds
  the Git directory views *that* folder (the main worktree in place of the linked one, the
  superproject in place of the submodule; FR-1's one folder), never this one with its Git state;
  the tree and the reading panel unaffected (C-I1; the message's shape is C-E4's; AC-25's
  own-top-level case is the fixture; the owner's wording, RN-42).
- **R-4:** Untrusted content reaches something that interprets it — a `MarkdownDocument` node
  built from a passage the parser must leave as text, a surface that imports HTML into an
  attributed string, or a hostile bitmap that crashes the platform's decoder — *shows up as* the
  hostile corpus (`checks/fixtures/hostile.md`) yielding a node outside § 3's closed set or a
  text node that does not hold its source verbatim, `checks/view.sh` finding an HTML import in
  `nozoki-mac/Sources`, or the churn fixture's malformed-image case ending the process; *response*
  three independent walls (C-D3) so a wall built wrong moves no byte across the folder's edge,
  and a decoder crash is a crash inside a process that cannot write or connect (C-R2, NFR-4); a
  malformed PNG, JPEG, GIF and WebP join the fixtures, and every reported case becomes a corpus
  line.
- **R-5:** FSEvents storms and large trees push the refresh bar — an agent rewriting thousands of
  files, a tree deeper or wider than the reference fixtures — *shows up as* `checks/latency.sh`'s
  p95 figures rising across builds, or the shell blocking under `checks/churn.sh`; *response* the
  watcher coalesces and the model re-reads only what an event names (SM-3); the figures are
  measured from the first build (C-I4) and the SRS's numbers are set from them, not before.
- **R-6:** The reader's place is lost on a refresh — an expansion collapsed, a position reset —
  *shows up as* AC-19 failing under churn; *response* the reducer keys items by path and applies
  deltas, never replaces the tree wholesale except on a folder switch (FR-27, NFR-12).
- **R-7:** The release is not the reviewed tag — an archive assembled on a machine, a checksum
  that does not match — *shows up as* `shasum -a 256 -c SHA256SUMS` failing against a rebuild
  from the tag; *response* CI builds from the tag, publishes the checksum, and a release with no
  build from its tag is not offered (C-R4).
- **R-8:** The sandbox is silently absent under an ad-hoc signature — every test green and the
  wall gone — *shows up as* `checks/bundle.sh` finding no ask, within the bounded window C-I3
  fixes after launch, on which the launched main process is reported sandboxed with the
  out-of-grant read and the outbound network connection both denied for it — the red run printing
  how long it waited — or the negative control reported sandboxed on any ask of its window, or
  the entitlement list not matching; on a GitHub-hosted runner the read denial separates nothing
  (C-I3), so there the finding rests on the sandboxed report and the outbound denial; *response*
  the probe runs on every build from the first slice (C-I3), so the finding arrives with one
  reader written; a failure there is a re-cut trigger on the gate's mechanism, never on the
  signature; a probe that fails while the wall stands is not this risk — it redraws the probe and
  no slice (§ 10 RC-1; RN-48).
- **R-9:** The Open panel reads as a setup step to a stranger — *shows up as* the timed walk
  stalling at launch, or a first-use inspection (NFR-15) recording confusion at the panel;
  *response* the panel *is* the one input NFR-14 admits — which folder — and the README's first
  screen names it as the start; UX-S4's Empty cell keeps a dismissed panel from being a dead end.
- **R-10:** The containment check is wrong about one encoding — `..` after percent-decoding, a
  symlink out of the folder, a Unicode normalization that compares unequal — *shows up as* the
  `..` and symlink-out fixtures yielding bytes instead of the placeholder; *response* the check
  runs as § 3 `fs-reader` defines it — after decoding, the canonical form with symlinks resolved
  at every position inside the grant, and spellings compared with nothing read at a position
  outside it, so a normalization difference met outside is refused as outside and never taken for
  inside — has one implementation, and is called at render and again at every asset request
  (SM-7). The response moves with § 3's definition (RN-71).
- **R-11:** TextKit's layout of an attachment or a text block moves with a macOS release — *shows
  up as* UX-I12's layout fixtures (an image or its placeholder in the flow of the prose; code on
  its own surface) mis-laid on a macOS the floor admits, in the release walk; *response* the
  layout form is settled by the first Markdown slice and written into `surfaces`' row (*Open
  Questions*), the fixtures are walked on every macOS the floor admits before each release
  (C-R5), and what moves is the treatment's layout, never the `MarkdownDocument` or the check.
- **R-12:** A breaking change to the priced set ships under a minor or patch number by oversight
  — the floor raised in a plist line, a function dropped from SM-4's exports, an asset
  renamed — with every promise test green, because none of them reads the priced set — *shows up
  as* `checks/contract.sh` failing on the tag against the pin its major wrote (C-I6); before
  `promise-one-point-zero` it shows up as nothing, which is C-6's pre-1.0.0 half and not a gap;
  *response* the release is not offered, R-7's rule, and the change is reverted or carried to the
  next major with a new pin.
- **R-13:** The C ABI seam is misused — a buffer freed twice or never, a lifetime crossed, a panic
  unwinding into Swift — in `nozoki-bridge`, the one unit that holds `unsafe` (§ 3) — *shows up
  as* the process ending under `checks/churn.sh` or the address sanitizer's report on the
  bridge's tests; *response* the bridge holds no logic, every function catches a panic at the
  boundary and returns a failure value, every buffer it returns is owned and freed by
  `nozoki_free` alone, the header is generated and never hand-edited, and the bridge's tests run
  under `-Zsanitizer=address` in CI on every build; a crash there is a crash inside the wall
  (NFR-4), and the fix is in one unit.
- **R-14:** The grammar engine's C faults, or does not return, on a file it is handed.
  Tree-sitter's runtime, the six generated parsers and the hand-written scanners some of them
  carry are C compiled into `nozoki-core` (§ 3; § 9 TO-11). What they parse is the folder's bytes:
  content that may be hostile (DR-6, NFR-16) and, as everyday input, a file another process is
  still writing, cut off partway through a construct (FR-16; `docs/PRD.md` § Target Users, the
  driving scenario) — *shows up as* `cargo test --locked -p nozoki-core --test highlight` ending
  without a result, or not ending; the process ending, or the open file never drawn, under
  `checks/churn.sh`; `checks/latency.sh`'s file-switch p95 rising across builds on a
  floor-language fixture; or an adopter's report naming the file; *response* a parse the engine
  refuses or stops early is not this risk: it comes back as data and is held by `folder-model`'s
  fill rule, never a panic (§ 3; C-I1). A fault in the C is FR-16 unmet on that file — "None of
  it crashes the shell, blocks the view, or causes a write" (`docs/SRS.md` FR-16) — and what the
  design holds then is NFR-4: the crash is inside the one sandboxed process, which can neither
  write nor connect, so the session is lost and nothing in the folder is (C-R2). The file that
  did it joins the highlight fixtures; a grammar's or the runtime's version moves only through a
  lockfile change reviewed as code (C-R6); and the engine stands behind one part, so replacing a
  grammar or the engine rewrites `highlighter` and moves no seam (§ 9 TO-11). **Not covered, and
  named so it is not read as coverage:** no condition in § 4 runs the engine's C under a
  sanitizer — R-13's run is over the bridge's tests — or against a hostile corpus for the six
  languages, and none bounds how long a parse may take. A slow parse is measured (C-I4) and not
  bounded; a bound enters with the number the SRS folds in for NFR-1, and not before (RN-80).
- **R-15:** The shipped executable links libgit2's transport code once a bridge export reaches
  `git-reader`. The vendored library compiles its transports whatever the features (§ 4 C-R6),
  and whether the link drops them from an executable that calls into libgit2 has been measured
  on this product on two builds. The release executable built at `nozoki@0aab3e7` defined
  libgit2's open and status code without the `nozoki_read_git` export, and passed both halves
  of the read. The release executable built from the tree at `nozoki@129586e` is the first
  that links the export, and it passes both halves (§ 4 C-I3, the transport-read sentences,
  which carry both measurements). So the build that links the export has been read. Both
  passes are local ones: the read ran on the owner's machine, and no hosted runner has run it
  on a build that links the export (§ 4 C-I3). This risk is kept, and it is not closed. One
  passing build answers whether the link drops the transports from an executable that links
  the export. It does not remove what the pass depends on: this version of `libgit2-sys`,
  this release link, and the libgit2 code the product calls today, which is the open and the
  status read. The history window and the `Diff` are in no landed change (§ 3, `GitState`).
  The read on every build is what holds the risk. The earlier measurement on record is a
  scratch binary calling `Repository::open_ext` alone, which passed both halves of the read
  (`checks/deps.review.md`, the `libgit2-sys` row) (`docs/trail/sdd/cycle-26.md` § 5.3, RN-91;
  `docs/trail/sdd/cycle-28.md` § 5.2, RN-93) —
  *shows up as* C-R6's `nm` read turning red on any release build: a defined
  `git_smart_subtransport_*` symbol, or an import of `connect`, `socket` or `getaddrinfo`.
  Three changes can make it real: a `libgit2-sys` version change, a change to how the release
  executable is built or linked, and a change that calls libgit2 code beyond the open and the
  status read; *response* the change whose build turns the read red does not land until a
  re-cut is recorded in § 10.
  Changing the build so that the claim holds is this document's to draw. Stating the claim
  lower is not: `docs/fdr.md` PD-27 carries it as a product decision — "Nothing the product
  ships carries a network transport" — and lowering it is the owner's call (RN-85).
- **R-16:** A repository's own config names a path outside the granted folder, and libgit2 opens
  it. The search-path switch (§ 3, the `core-bridge` row) stops the four machine levels and
  nothing else. From the repository's config libgit2 follows `include.path`
  (`libgit2-sys 0.18.8+1.9.7`, `libgit2/src/libgit2/config_file.c:L564`), `core.excludesfile`
  (`ignore.c:L362-L364`) and `core.attributesfile` (`attr.c:L413`), and none passes
  `fs-reader`'s containment check. That config is content: whoever wrote the folder wrote it
  (§ 4 C-D3). This sits beside R-3, which is the other way Git's own layout points outside the
  grant — *shows up as* a read of the named path wherever nothing refuses it, which is the
  in-process harness, on a fixture repository whose `.git/config` carries one of the three keys
  with a path outside the fixture. No such fixture is in the tree:
  `grep -rn 'include.path\|excludesfile\|attributesfile' checks/fixtures` prints nothing at
  `nozoki@a7834f4`. In the
  shipped bundle the sandbox refuses the read, and whether the open or the status read survives
  that refusal has not been run; *response* in the bundle the wall is C-R2's and it is the only
  bound, so no byte outside the grant is read there. In the harness nothing bounds it. The read
  is named as uncovered beside the two claims it falls under (§ 3, the `core-bridge` row; § 4
  C-D3), and how it is closed is the config-named-path item of *Open Questions*, which is
  settled in `see-git-status` before the slice is reached. No build inside the slice bounds
  it. From the first build in which `mac-shell` calls `nozoki_read_git` until that item is
  settled, the bundle opens a reader's own repositories with this read unsettled. In those
  builds the sandbox is the only bound, and a repository whose config names an outside path
  shows a failed Git item if libgit2's open or status read does not survive the refusal (§ 6
  S-4 *Reached when*, observable half, "Git state the tool could not read"). Until
  that item is settled this is a stated limit of § 4 C-D1 outside the sandbox, not a held
  property (RN-87; `docs/trail/sdd/cycle-26.md` § 5.4, RN-91; `docs/trail/sdd/cycle-27.md`
  § 5.1, RN-92).

## 12. What this design is not

<The boundaries, so a reader does not look here for something this document never held.

Above: it never changes product goals or scope (the PRD), system requirements (the SRS), or the
experience (the UXD). A gap in any of them is an open issue in the companion, not a rewrite here.

Below: it authors no ADR. The architecturally-significant decisions are **surfaced**; the Principal
Architect records them, and this SDD references those ADRs once they exist. It designs no individual
change — that is the delivery-tier Architect's `change_design.md`, one change at a time against the
system defined here.

**What "surfaced" means, exactly:** the Principal Architect reads three surfaces of this document and
no fourth — **§ 2's shape table** (each alternative's *right when / wrong when / taken?* row),
**§ 9's trade-offs**, and **the SDD Review Notes**. That is the set, not a sample: a run that has
written those three has surfaced everything the recorder will look for. What earns a record, how one
is written, and what to do with a decision visible in the design but argued in none of the three are
`<CORE>/prompts/principal_architect_create_architecture.md`'s, not this section's.>

**The PRD boundary** — the CPO's clause.

This design changes no product goal and no scope. Every PRD section cited above is cited as
`docs/PRD.md` v15 (Settled) states it; the cut in § 6 delivers what the PRD names and nothing it
excludes, and § 1 holds every slice to the Agari the PRD is scoped against. The PRD delegates no
value to this document directly — its delegations run through the SRS (the acquisition channel,
the macOS floor) and this document takes the SRS's word for them. A gap in the PRD found here is a
companion item for the CPO's own PRD run, never a rewrite from this document — **even by the seat
that holds the PRD's pen in that run**. One gap was found and went to the companion, not into the
PRD: what the 1.0.0 promise covers for an application with no library surface, which
§ Assumptions "Versioning" names as "what users rely on" and does not define — answered
**confirm** by the owner, 2026-09-04, and folded (`docs/trail/sdd/cycle-2.md` § 2.2, RN-19); the
PRD is unchanged by the answer, and the contract lives in § 6 S-11. One further item is not a gap but a call the PRD leaves open by design — "Before 1.0.0
anything may change" — raised as the owner's cut call (`docs/trail/sdd/cycle-1.md` § 3.1) and
answered *keep* on the owner's own prior ruling (RN-17). One item touched the promise itself
without opening a gap: a network entitlement was found to make the shipped window draw
(`docs/trail/sdd/cycle-8.md` § 5.1), and the owner's answer held the PRD's line — "no network
call at all during operation" (`docs/PRD.md` § Data & Privacy) — as the operating system's
refusal and not the code's, so the PRD is unchanged and the mechanism moves in § 4 C-R2, never
here. The item that ruling left open — the renderer that cannot start under it — is answered:
the renderer leaves WKWebView (`docs/trail/sdd/cycle-9.md` § 1.1, the owner, 2026-09-23), and it
opens no PRD gap either: the PRD names no renderer, its § Dependencies / Integrations naming the
filesystem and Git alone, so the exit taken changes nothing the product promises, and the PRD
stays at v15. What the exit costs in product terms is a date and not a surface — every slice
rests on `open-a-folder` (§ 7), so the first public release moves later, not smaller — and the
one public sentence it does reach is the README's, not the PRD's (RN-59). The immediacy
thresholds the PRD leaves TBD are the SRS's to fold in by revision, and no slice here writes a
number for them.

**The SRS boundary.** This design changes no requirement. Every `FR-n`, `NFR-n`, `DR-n` and `C-n`
cited above is cited as `docs/SRS.md` v12 states it, and where the SRS delegates a value to this
document — the acquisition channel (C-3, RN-7), the macOS floor (C-11), the Git mechanism (§ 5.3),
the extension set (FR-29), the build-cost judgment on the raw-source switch and the relative link
(FR-31, FR-32), how the root finding is made (FR-33) — the value is fixed here and traced back. A
gap found in the SRS while designing is a companion item for the CTO's own SRS run, never a
rewrite from this document; none was found in this run, and none in the fold of the owner's (a):
FR-30, FR-31 and FR-32 name no engine, and the two build-cost judgments they delegate are re-made
here under the native view with the same result (§ 9 TO-5; RN-60).

**The UXD boundary.** This design changes no experience. Every `UX-` entry cited above is cited as
`docs/UXD.md` v12 (Settled) states it; the C-E conditions restate none of them and bind the slices to
them by reference. This document was cut against v10. v11 moved one entry, UX-U1's expertise
floor, and nothing above cites UX-U1 (RN-81). v12 corrects § 4's layout-reference inventory and
changes no experience requirement (`docs/UXD.md` RN-32; RN-83). Where the UXD delegates to a document beside or
below it — every token value to
`docs/DESIGN.md`, every message's wording to `docs/CONTENT.md`, where the diagnostic is kept to the
SRS (UX-I16) — this document cites the delegate and fixes nothing of its own. A gap in the UXD found
here is a companion item for the CDO's own UXD run, never a redesign from this document — even by
the seat that holds the UXD's pen in that run. One was found: UX-I12's in-folder image case names
no format, and § 4 C-D3 decides what an SVG is (`docs/trail/sdd/cycle-1.md` § 2.1, RN-31). One
defect in the UXD itself was found and is reported, not repaired from here: five citations in its
RN-29 no longer resolve (RN-32). The cycle-8 ruling and the exit the owner took from the renderer
question it left — the renderer leaves WKWebView for an AppKit view in one process (§ 2; § 10
RC-2, RC-3; `docs/trail/sdd/cycle-9.md` § 1.1, the owner, 2026-09-23) — open no UXD gap: UX-I12
and § 9 name no renderer and no CSS, § 9's direction is the platform's own controls and
appearance, and every `UX-` entry cited in § 4's C-E conditions and § 6's observable halves and
UXD traces was re-read against § 2 as it now stands and binds an observation or a token, never
an engine — so the UXD stands at v10 under the view taken *(v10 was the UXD's version on
2026-09-23; it is v11 since `nozoki@24d652b`, moved by the reader floor the PRD states and not by
the exit — `docs/UXD.md` RN-31; noted 2026-10-01, RN-81)*. What the exit moves is
`docs/DESIGN.md`'s, in that document's own run, which may trail this one: its realisation
sentence (§ Overview, "realised in plain CSS custom properties over the product's own markup"),
the CSS font-stack syntax its § Typography and frontmatter use to name the platform's two
families, and RN-1's "every value here is a CSS value and holds in either" — and no token value,
since every value that document fixes is a number or a colour a native view draws directly *(that
run has happened since this sentence was written: DESIGN v11, `nozoki@cce8bde`, recorded in that
document's RN-31. In `docs/DESIGN.md` v13 the three stand like this. § Overview reads "realised in
AppKit views drawn by the product's own Swift package". RN-1 keeps the CSS sentence as what
"Revisions 1–10 read". The two font stacks stay as written in § Typography and the frontmatter,
and § Typography now says each stack "is how the token format names a platform family" and that
the shell "looks up no family by name". No token value moved: the frontmatter differs from the
one this sentence was written beside in its `description:` line alone. Noted 2026-10-01, RN-81;
the sentence above is left as it was written)*. No
C-E condition, no observable half and no *Traces to* UXD clause in § 6 moved for it (RN-53,
RN-62).

**The downstream boundary.** This document authors no ADR and designs no individual change. The
decision log holds sixteen records (`docs/adr/README.md`, ADR-0001 – ADR-0016, read 2026-09-23),
the first nine written from the previous SDD; this run's § 2 table, § 9 and the Review Notes are
the three surfaces the Principal Architect reads, and where a decision here lands where a record
already stands, the record is cited rather than re-surfaced (RN-1). Where this document departs
from a record, the departure is a Review Note naming the record — and after the owner's (a) the
departures are these, every one surfaced for a superseding record and none written here: ADR-0001's
two-process shape and ADR-0002's runtime, renderer and view language (§ 2; § 10 RC-3; RN-60);
ADR-0006's sanitizer and asset scheme (§ 4 C-D3; RN-60); ADR-0009's unit set (§ 3; RN-60); and
C-R2's departure from ADR-0003's "exactly these entitlements" on the owner's cycle-8 ruling
(RN-52), which ADR-0011 restates and supersedes (RN-61). ADR-0012's gate stands as
decided — observed from the process, a control that goes red, after the wall probe — and its
mechanism, control and observable's name are re-derived from C-I3 as it now reads (RN-61). What
status either record holds is the index row's to say and never this document's: C-R2's and
C-I3's record lines cite the row and state no status word (the owner's addition,
`docs/trail/sdd/cycle-10.md` § 2.3; RN-64). The
log is append-only: a departure is a superseding record, never an edit. The enforcement store,
`docs/nfdr.md`, is re-derived from § 4 where the two disagree (§ 4, opening note); the first run
found no disagreement, one confirmation (C-R5's floor) and one placement it takes from that
document (the `crates/` layout, RN-4); the cycle-8 fold left QC-25 to re-derive from C-R2's rule,
which NFDR v10 did (`docs/nfdr.md` § Version, its v10 note); and the (a) fold leaves every entry
written against the previous shape to re-derive from §§ 2 – 4 as they now read — QC-21's
non-invariant (the view technology *was* replaced, once, before any release), QC-23 (the CSP),
QC-24 (the capability grant), QC-62's mechanism and control, and every entry naming `nozoki-app`,
`nozoki-ui`, `pnpm` or Vitest (`docs/nfdr.md` § 9) — the Principal Architect's (RN-60). The § 3
placement the companion's § 2.4 drafted — the model fills the `FileView` by calling
`markdown-renderer` and `highlighter` — is confirmed by the owner with one addition
(`docs/trail/sdd/cycle-11.md` § 2.4; RN-65), and QC-10 is transcribed from it at NFDR v12,
carrying the reason the addition states — the renderer's containment call reaches the filesystem
through `fs-reader` over SM-7, never through the model (`docs/nfdr.md` QC-10 and its v12 note;
the reading it answers is on that document's trail, `docs/trail/architecture/cycle-9.md` § 1.1).
Two things of this document's are owed to that store on the cycle-12 fold, and both are already
raised there rather than from here: C-R7 now admits `nozoki_free` beside SM-4's list, and
`docs/nfdr.md` QC-24 still holds the export set inside the list alone
(`docs/architecture_open_issues.md` § 2.1); and § 3's Swift-frame paragraph now rests on the Swift
packet, where `docs/nfdr.md` § 9 and ADR-0016 still say none exists and `nozoki-mac`'s departures
from it are that document's to record (`docs/architecture_open_issues.md` § 3.4) — the Principal
Architect's, both (RN-66) *(both were folded since this sentence was written: QC-24 holds the
export set inside the list "and `nozoki_free`, the seam's one release call beside the list and
not on it" — `docs/nfdr.md` QC-24 — and `docs/nfdr.md` § 9 takes `nozoki-mac`'s tooling from the
Swift packet and states where the package departs from it, with ADR-0016 § Decision corrected in
place on 2026-09-23; the two items cited stand at `docs/trail/architecture/cycle-10.md` § 2.1 and
§ 3.4, and `docs/architecture_open_issues.md` holds neither; noted 2026-10-01, RN-80; the
sentence above is left as it was written)*. One defect in the records
themselves was found and is reported, not
repaired from here: 14 citations of the deleted trail across five ADRs, 23 review-note citations
written against the previous SDD's numbering, and one stale slice reference in `docs/nfdr.md` no
longer resolve (RN-34) — routed to the Principal Architect, and the reason RN-20 – RN-29 are left
empty in this document.

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

- **RN-1:** *(CTO)* *(added)* The shape was weighed from the forces in § 2 against the SRS, UXD and
  PRD as they stand today, and the decision log's nine records were read beforehand as the
  authoring lens requires — a run that has not read them re-surfaces a decision already recorded.
  The previous SDD (`nozoki@70a879a:docs/SDD.md`, deleted at `nozoki@9c91359` for this
  re-author) was **not** read as an input beyond its § 4 C-R3, opened once before this turn to
  answer the companion's § 1.1; nothing in this document is copied from it. Where the weighing
  landed where a record stands, the record is cited as the existing record, not as a ground —
  every row's ground is the SRS, UXD or PRD fact on the row *(re: § 2, § 12; source: `docs/adr/`)*.
- **RN-2:** *(CTO)* *(added)* The runtime is Tauri 2 — a Rust host over a Rust library, the
  surfaces in the system WKWebView, one bundle — *because* C-3 and `docs/SRS.md` RN-12 press toward
  a self-contained artifact with no prerequisite; the design language is realised as plain CSS
  custom properties over the product's own markup (`docs/DESIGN.md` § Overview; RN-1 there),
  its assets — the vendored SVG icons among them — shipping with the tool (`docs/UXD.md` § 9),
  which a native shell would re-express; and the shape needs a host that exposes only the
  commands it registers (SM-4). (The `docs/UXD.md` § 9 citation for the CSS sentence was wrong
  when this note was written and is re-pointed — RN-55.)
  Electron was rejected for the browser engine it bundles against a five-minute install and an
  allowlisted tree (C-R6); native AppKit / SwiftUI is the runner-up (§ 2, row 4). The Principal
  Architect's record is ADR-0002; this is the call made afresh on the same facts *(re: § 2, § 4
  C-R1; source: SRS C-3, NFR-13; UXD § 9)*.
- **RN-3:** *(CTO)* *(added)* The start mechanism — the folder granted through the system Open
  panel at launch, UX-S4 in the window on dismissal — is stated in C-R3 as **forced by C-R2**, not
  as a preference: under the App Sandbox a folder is readable only when the user selected it in an
  Open dialog (Apple's entitlement page, cited in C-R2), so the only way to a typed path is no
  sandbox. The UXD already carries the experience half in its own body (UX-S4, v10 Settled), so
  the C-E clause and this one meet on the same surface either way. The companion's § 1.1 asks the
  owner whether the previous SDD's answered companions bind this run; **this clause does not wait
  on that answer** — it stands on the sandbox argument alone, and would read the same under either
  answer. The record is ADR-0003. § 1.1 was answered at round 3 — the prior answers bind, the
  Open-panel grant among them through ADR-0003 — and nothing here moved for it, as this note
  said it would not (`docs/trail/sdd/cycle-1.md` § 1.1, answer 2) *(re: § 4 C-R2, C-R3; source:
  SRS FR-2, FR-3, NFR-4, NFR-14; UXD UX-S4, UX-S7)*.
- **RN-4:** *(CTO)* *(added)* The parts' *Lives in* cells read `crates/nozoki-core`,
  `crates/nozoki-app`, `nozoki-ui` and `checks` — *because* the `crates/` placement is the owner's
  ruling for every Rust product in this instance, as `docs/nfdr.md` carries it (its Version line,
  v3: "§ 9's Rust test paths move under `crates/`, the placement the owner ruled for every Rust
  product here"; § 9's table paths). The Rust packet's own layout file was not opened: it is not
  in this run's input set, and a file outside the set is surfaced, never opened quietly. One
  consequence for the tool that reads § 3: joining a part's slug to its cell yields
  `crates/nozoki-core/fs-reader`, and a Rust module cannot carry a hyphen — the Rust spelling of
  each part is the developer's (`docs/nfdr.md` § 1, opening paragraph). This document keeps the
  template's slug shape and records the join here for the launcher's measurement rather than
  bending either *(re: § 3; source: `docs/nfdr.md` § 1, § 9; ADR-0009)*.
- **RN-5:** *(CTO)* *(added)* The channel is a GitHub Release carrying an ad-hoc-signed,
  un-notarized `.dmg` with a checksum, built by CI from the tag — *because* C-3 forbids a build
  from source and C-12 names the repository, and the owner's standing call that nothing is paid for
  this app — no Developer Program, no App Store, do not raise signing again — is on disk in
  `docs/adr/0007-ad-hoc-signed-dmg-on-a-github-release.md` § Context, quoting a trail file this
  run cannot open. This seat carries the call as recorded there and does not re-ask it; if the
  owner's answer to the companion's § 1.1 is that no prior answer binds, this call is theirs to
  re-give and C-R4's alternatives table in § 9 TO-9 is where the cost of the other branch is
  stated. **Closed at round 3:** § 1.1 is answered — the prior answers bind, and this one binds
  through the decision log rather than the trail: ADR-0007 is Accepted and was never deleted, so
  "C-R4 and § 9 TO-9 stand as written and RN-5's contingency does not open"
  (`docs/trail/sdd/cycle-1.md` § 1.1, answer 2; reasoning `docs/trail/sdd/self_answer-1.md`
  § 1.1) *(re: § 4 C-R4, § 9 TO-9, § 11 R-2, R-7; source: SRS C-3, C-11, C-12, NFR-13)*.
- **RN-6:** *(CTO)* *(added)* The macOS floor is 14.0 — *because* C-11 delegates it here; the
  runtime does not force it (Tauri 2's prerequisites page: "macOS Catalina (10.15) and later"), so
  it is the oldest version the timed walk is run on, chosen for fewer WKWebView generations to hold
  C-R7 and C-D3 against; and `docs/nfdr.md` QC-56 already binds 14.0, which this run keeps rather
  than re-derives with no upstream cause to move it *(re: § 4 C-R5, § 9 TO-8; source: SRS C-11;
  https://v2.tauri.app/start/prerequisites/)*.
- **RN-7:** *(CTO)* *(added)* The floor's extension set (C-I5) is this document's value: FR-29
  requires "every extension in common use" per language "with the full extension set fixed in the
  SDD", and names one example (`.js` and `.mjs` both). The set is deliberately modest — an
  extension on the list must have a floor language behind it — and grows only with the floor
  (FR-8). AC-5's cases (no extension, an extension outside the set, a shebang-only script) are
  plain text by the same rule *(re: § 4 C-I5; source: SRS FR-8, FR-29, AC-5)*.
- **RN-8:** *(CTO)* *(added)* In-folder images are served on one host-owned scheme for PNG, JPEG,
  GIF and WebP, with SVG excluded in v1 — *because* UX-I12 binds that an image inside the folder
  renders in place and one outside it never loads, which needs a scheme the CSP can name (C-R7)
  and a containment check run at request time (SM-7); and the scheme serves bytes the sanitizer
  never sees, so a document format is kept off it. An SVG inside the folder takes the
  observed-condition placeholder UX-I12's third case names — with the fit stated rather than
  assumed: that case reads "not an image", and this document reads it as *not a bitmap format the
  asset scheme serves*; a well-formed SVG is an image and is not broken, so the placeholder's
  sentence describes a format the tool does not render, never a file it could not read. **The
  exclusion is a v1 cut, not a permanence, and what reopens it is evidence, not taste:** the timed
  release walk (AC-10) or an adopter report showing an in-folder SVG is common enough in a README
  to be the first thing a stranger meets. Adding SVG later is additive under S-11's contract —
  removes no surface, raises no floor, adds no prerequisite, changes no install path — so it costs
  a minor version, never a major one, and no version bump on its own reopens it. If reopened, the
  mechanism is a host-side SVG sanitizer in `markdown-renderer`'s pipeline — an XML allowlist
  admitting no script, no event attribute, no external reference and no `foreignObject` — with the
  sanitized bytes served on the same `nozoki-asset` scheme: C-D3's format list and
  `read-markdown`'s bar move, and C-R7 does not, since `img-src` already names the scheme.
  Confirmed as drafted with these two additions at `docs/trail/sdd/cycle-1.md` § 2.1 *(re: § 4
  C-D3, C-R7, § 9 TO-6; source: SRS FR-32, NFR-16; UXD UX-I12)*.
- **RN-9:** *(CTO)* *(added)* The first slice links no `git-reader` and never resolves the
  model's `kind` — *because* step 5 demands the smallest reversible slice that proves the shape,
  and the shape's claim is the wall, not Git; the root finding is a port call asked only when a
  Git surface exists to draw its answer (SM-2), and a `pending` kind that is never asked draws as
  the Git view's Loading cell would, which the first slice has no Git view to show. The record
  for the finding's placement is ADR-0005 *(re: § 5 step 5, § 3 `git-reader`; source: SRS FR-33,
  FR-34; UXD UX-I17)*.
- **RN-10:** *(CTO)* *(added)* Two build-cost judgments FR-31 and FR-32 delegate here: the
  raw-source switch is **not built**, the relative link **is** — *because* the switch must
  preserve the reading position both ways (UX-I12) and that mapping has no other use, so it does
  not cost nothing; and the relative link is one data attribute resolved to the existing
  `select_file` command on a path the containment check already validates, so it does. A release
  states rendered-only where it is offered (AC-22) *(re: § 9 TO-5; source: SRS FR-31, FR-32,
  AC-22, AC-23; UXD UX-I12)*.
- **RN-11:** *(CTO)* *(added)* The harness proves the pipeline through `nozoki-core` and SM-5,
  not through the rendered UI, and the bundle probe runs on every build from the first — *because*
  Tauri's WebDriver page states there is no WKWebView driver on macOS, and because a sandbox
  silently absent under an ad-hoc signature would leave every test green with the wall gone
  (R-8); publishing late does not require verifying late. The record is ADR-0008 *(re: § 4 C-I3,
  § 9 TO-7, § 11 R-8; source: SRS NFR-9, AC-1 – AC-3, AC-10; https://v2.tauri.app/develop/tests/webdriver/)*.
- **RN-12:** *(CTO)* *(added)* The diagnostic log's path is inside the app's sandbox container
  and it is the product's only diagnostic output (C-I2) — *because* NFR-11 places diagnostics with
  the tool's own state and forbids transmission, and the container is the one writable location
  the sandbox gives a bundle; the path as written is the one `docs/nfdr.md` QC-52 already binds,
  kept for the same reason as C-R5's value *(re: § 4 C-I2, C-D2; source: SRS NFR-11, FR-21, AC-13)*.
- **RN-13:** *(CTO)* *(added)* Git is read through libgit2 behind a port, with the installed
  `git` as the standing substitute not built ahead of its risk — *because* `docs/SRS.md` § 5.3
  leaves the mechanism here bounded by NFR-5 and NFR-6, and two vendor facts decide it (TO-2): a
  spawned `git` prompts a Command Line Tools install on a fresh Mac, and `git status` writes the
  index unless told not to. The record is ADR-0004 *(re: § 3 `git-reader`, SM-2, § 9 TO-2, TO-10,
  § 11 R-1; source: SRS § 5.3, NFR-5, NFR-6, C-3, AC-1, AC-2)*.
- **RN-14:** *(CTO)* *(added)* § 5 step 3 is applied to step 1's entries before step 2 has run,
  and step 5 argues an order over entries rather than slices — *because* write-as-you-go binds
  this turn and the cut is not yet drawn; both applications are written so that a merge of
  neighbouring entries at step 2 or step 4 leaves every stated reason true, and they are re-read
  onto the slices — as § 6's *Rests on* and *Why here in the order* and § 7's rows — in the turn
  after the cut lands. Done in round 2, in two halves: the § 6 fields before the interruption
  `docs/trail/sdd/run-1.md` I-1 records, § 7 and S-8's *Why here in the order* after it; every
  `depends_on` row is one of step 3's answers re-read onto slugs, and the three placements no edge
  forces are named beneath the table as preferences *(re: § 5 steps 3 and 5, § 6, § 7)*.
- **RN-15:** *(CPO)* *(added)* E-8 — the release-time proof over the whole surface — is struck at
  step 2 and folds into every slice's *Reached when* as the promise clause and into
  `first-public-release`'s *Delivers* — *because* its worth can only be stated by naming the
  entries it exercises, which is step 2's definition of a fragment, and its mechanism exists from
  the first build (§ 4 C-I3), so a slice for it would build nothing. The CDO's observability read
  passed it and expected the same fold (RN-30); the strike is this seat's *(re: § 5 step 2, § 6
  `first-public-release`; source: PRD § Success Metrics "Read-only integrity";
  `system/projects/nozoki/agari.md`, second condition)*.
- **RN-16:** *(CPO)* *(added)* `promise-one-point-zero` is a slice no step-1 entry named — *because*
  the Agari's third condition has two halves and `first-public-release` meets only the first at a
  version below 1.0.0; the second is a product event the PRD names as one ("Reaching 1.0.0 is a
  product event — the moment the promise starts", `docs/PRD.md` § Assumptions "Versioning") with
  work of its own — the contract declared, the caveat withdrawn, the closing walk over the whole
  terminus. It clears the sixth-cut test "a milestone that only restates its last task's
  completion" on its *Delivers*: after it an adopter can rely on the number, which they could not
  before. Its *Not in this slice* keeps `switch-the-folder` free of the release event, so the last
  surface and the promise's start are two seeds, not one *(re: § 5 step 4, § 6 S-11; source: PRD
  § Assumptions "Versioning"; Agari, third condition)*.
- **RN-17:** *(CPO)* *(added)* `first-public-release` is placed after the v1 cut (`open-a-folder`
  through `choose-a-theme`) and before the three beyond-v1 slices, as a release below 1.0.0 —
  *because* the PRD calls v1 "the smallest version that proves the thesis" (`docs/PRD.md` § Scope
  (In)) and names that thesis unproven — the familiarity thesis, "if false, the product needs
  rethinking, not tuning" (§ Assumptions) — so the product reason to put the v1 cut in strangers'
  hands early is that the bet is tested before the three slices that build on it are paid for; and
  C-6 makes a pre-1.0.0 release honest about what it is. The CTO's step 3 finds no dependency
  forbidding it; the one alternative that passes the four tests — a single public release at 1.0.0
  with the terminus whole — is the owner's call and was raised at `docs/trail/sdd/cycle-1.md` § 3.1.
  **Changed at round 3**, authorized by that item's answer (`docs/trail/sdd/self_answer-1.md`
  § 3.1, binding through § 1.1's answer, same file): **keep** — and on the owner's own prior ruling
  rather than on this seat's argument: the previous SDD's companion had put the same question and
  the owner answered "the first public release waits for the full v1 cut the PRD names, so the
  first thing a stranger meets is the product `docs/PRD.md` calls v1, not a partial." That settles
  the placement twice — *after* the v1 cut, where S-7 sits, and *at* it, ruling out the alternative
  raised here. The placement is therefore no longer a preference of this seat's but a decided
  ordering; whether § 7 carries an owner-decided ordering as a `depends_on` row or as a stated
  placement is step 3's call, the CTO's, and S-7's *Rests on* and *Why here in the order* and § 7's
  closing paragraph are theirs to reword. This seat's argument stands beneath the ruling and is
  kept as the reason the ruling was right *(re: § 5 step 4, § 6 S-7, § 7; source: PRD § Scope
  (In), § Assumptions "Versioning", "The familiarity thesis"; SRS C-6; `docs/trail/sdd/cycle-1.md`
  § 3.1, § 1.1)*.
- **RN-18:** *(CPO)* *(changed)* Between `read-a-file` landing and `read-markdown` landing, a `.md`
  file is shown as plain text — a departure from FR-30 ("displayed rendered by default") for an
  intermediate build — *because* rendering untrusted content is a decision `read-a-file` never
  asks and is cut into its own slice (step 4), and the honest intermediate is plain text rather
  than a Markdown surface without its walls. No release ships in that state: `first-public-release`
  lands after `read-markdown`, an edge the CTO's § 7 carries *(re: § 6 S-2 *Not in this slice*;
  source: SRS FR-30; PRD § Core Features "Markdown is rendered by default")*.
- **RN-19:** *(CPO)* *(added)* The content of the 1.0.0 contract is drafted into
  `promise-one-point-zero`'s *Delivers* — the install path and the macOS floor, the two promises,
  own state readable or discarded whole, every PRD-named surface present and read-only — *because*
  the PRD's "a breaking change to what users rely on" (§ Assumptions "Versioning") and the SRS's
  "the product's public contract" (C-6) name the promise without defining what it covers for an
  application with no library surface, and the CPO's own posture makes that declaration this seat's
  (the flags, exit codes, output formats and config schema a CLI would declare have their
  application-shaped equivalents here). It is a best-effort draft of product intent the PRD does
  not carry, so it is routed to the owner as the companion's § 2.2 (retired to
  `docs/trail/sdd/cycle-2.md` § 2.2), and § 12's PRD boundary
  names it as the one PRD gap this run found. **Changed at run 1's round-2 re-run**, authorized by
  the companion's § 2.3 (retired to `docs/trail/sdd/cycle-1.md` § 2.3) — an item split out of
  § 2.2 by the `companion-self-answer` run and confirmed there (`docs/trail/sdd/self_answer-3.md`
  § 2.3; `docs/trail/sdd/self_answer-4.md` § 2.3): the
  *Delivers* sentence had put two kinds of thing in one list of four, and a reader asking what a
  change to the read-only or no-network promise costs got a major version as the only inference,
  which is wrong — no version buys either. It now states the two kinds apart under this rule: **a
  member sits in the priced set when a change to it is on offer and the closing clause reaches it,
  and in the unconditional set when an upstream constraint forbids the change at every version —
  and each member names the constraint that puts it there.** Applied today: the install path, the
  floor and the PRD-named surfaces are priced; no-write (C-2), no-telemetry (NFR-7), no-network
  (NFR-8 — which names its own route, a PRD revision first, so the member carries that route rather
  than asserting a wall the SRS wrote as a door) and own-state safety (§ 4 C-D4) are unconditional.
  No member was added or removed; § 2.2 — which members the contract covers, and whether the owner
  is willing to be held to it — stays the owner's, under the routing rule the companion's § 1.1
  answer binds (`docs/trail/sdd/cycle-1.md` § 1.1, answer 3): an item goes to the owner when its
  answer changes what the product promises, not when it changes how the work is divided
  (`docs/trail/sdd/self_answer-1.md` § 1.1). The rule above applies to whatever § 2.2 settles, with
  no second decision. **Changed at run 2, round 1**, authorized by the companion's § 2.4 — raised
  by the `companion-self-answer` run after run 1 closed, with its slot left for this run
  (`docs/trail/sdd/self_answer-5.md` § 2.4) — and decided by this seat, not the owner, under the
  same routing rule: it changes where a promise already made is stated, not what the product
  promises. The priced set's member (d) read "present and read-only", and read-only is C-2's — the
  invariant the unconditional set already carries — so the two sets gave a reader opposite answers
  to what making a surface writable costs: a major version from the one, *never, at any version*
  from the other, which is what C-2 says. The two words are deleted and (d) reads *every surface
  the PRD names, present*. No member is added or removed; read-only stays covered, in the set whose
  constraint places it; and this too applies to whatever § 2.2 settles — an override that drops (d)
  moots it. **Closed at run 3, round 1**, by the owner's answer to § 2.2 — **confirm**, 2026-09-04,
  given as "i guess confirm" (`docs/trail/sdd/cycle-2.md` § 2.2): the draft stands exactly as
  §§ 2.3 and 2.4 left it, four members in two kinds and the exclusions, and none of the six
  additions the walking session offered was taken (`docs/trail/sdd/self_answer-5.md` § 2.2) — they
  were that session's, not the item's. The fold changes no member; what it changes is standing:
  the contract is the owner's declaration now, no longer this seat's draft; the two "whatever
  § 2.2 settles" clauses above are settled, with (d) kept; and S-11's *Delivers* and *Not in this
  slice* and § 12's PRD boundary cite the permanent copy in place of the transient companion.
  **One sentence is added to the *Delivers* at run 3, round 2** — the contract's four exclusions,
  "the exact wording of any message, any token value, the diagnostic log's lines, and anything the
  harness prints" — *because* the companion's draft bullet had carried them since run 1
  (`docs/trail/sdd/cycle-1.md` § 2.2, "Not covered") and the owner confirmed them with the members,
  but no version of the *Delivers* had ever stated them: the observable half enforced them from
  run 1 (RN-40) and C-I6 cites the *Delivers* for them (RN-38), both against a sentence that was
  only in the companion. Found while walking the peers' round-1 edits and fixed in place
  (`<CORE>/doctrine/governance/found_while_walking.md`, clause 1); the exclusions are the fence of
  the contract, not a member of it, so the sets and the rule above are unchanged *(re: § 6 S-11,
  § 12; source: PRD § Assumptions "Versioning"; SRS C-2, C-6, NFR-7, NFR-8; § 4 C-R5, C-D4, C-E5,
  C-I6)*.
- **RN-30:** *(CDO)* *(added)* § 5 step 1's observability read passes all eleven entries — and
  E-8 among them — *because* observable does not mean graphical: a command's output and a file the
  product leaves untouched are surfaces, and behaviour on them passes the check, where a layer being
  ready does not (`<CORE>/prompts/cdo_create_sdd.md` § *Applying § 5 step 1*). The read is written
  into the step-1 block rather than only here so the CPO's step 2 starts from a stated result, not
  a remembered one; what E-8 becomes at step 2 is the CPO's and this note binds nothing about it
  *(re: § 5 step 1; source: `system/projects/nozoki/agari.md`, second condition; `docs/UXD.md`
  UX-I17)*.
- **RN-31:** *(CDO)* *(added)* § 4 C-D3 serves in-folder images for four bitmap formats and sends
  an SVG to UX-I12's third-case placeholder (RN-8). The UXD's first case — *an image whose file is
  inside the folder renders in place* — names no format, so the SDD is deciding an experience the
  UXD left open rather than contradicting one; but a reader of a README whose diagram is an SVG
  sees a placeholder where the UXD promised the image, and that is a narrowing the owner can see.
  It was routed to the companion's § 2.1 — retired to `docs/trail/sdd/cycle-1.md` § 2.1 — as a
  choice to confirm, not written into the UXD from here (§ 12, the UXD boundary). Two consequences hold either way: the placeholder states what was
  observed — the file's format, which the tool does not show — and never a broken-image glyph
  (UX-I12, UX-I13); and its sentence follows `docs/CONTENT.md` § *Message patterns* → *Partial* —
  *what is not shown, marked in the place it would have been* — whose one example covers the
  remote case only, so a sentence for this case is the Content Editor's to add at their fold, and
  this note names the gap rather than wording it. **Confirmed** at `docs/trail/sdd/cycle-1.md`
  § 2.1, with one clause this seat carries: the fit with UX-I12's third case is stated, not assumed. That case
  reads *missing, unreadable or not an image*, and a well-formed SVG is none of those in the
  ordinary sense; the placeholder therefore describes **a format the tool does not render**, never a
  file it could not read — which is what the Content Editor's sentence must say, and what
  `read-markdown`'s observable half now asks a person to see. The narrowing clause in C-D3 and the
  reopening condition are the CTO's (RN-8) *(re: § 4 C-D3, C-E4, § 6 S-3; source: `docs/UXD.md`
  UX-I12; `docs/CONTENT.md:305-311`; `docs/trail/sdd/self_answer-1.md` § 2.1)*.
- **RN-32:** *(CDO)* *(added)* A defect in the UXD, found while reading it for this run and
  reported rather than repaired: `docs/UXD.md` RN-29 cites `docs/trail/sdd/cycle-1.md` § 1.2,
  § 1.3, § 2.3 and § 2.4 and `docs/SDD.md` § 4 C-R3 (`docs/UXD.md:865, 874, 885, 895`), and none
  resolves since `nozoki@9c91359` deleted the previous SDD and its trail for this re-author. The
  cited file stands unchanged at `nozoki@70a879a:docs/trail/sdd/cycle-1.md` — byte-identical to
  `nozoki@1e8bf3d`'s copy, which is the commit that moved it there (`git diff --quiet 1e8bf3d
  70a879a -- docs/trail/sdd/cycle-1.md`, 2026-09-03). The repair is the UXD's own and belongs to
  its run: pin the five citations to that commit, as RN-8, RN-15, RN-16 and RN-17 already pin
  theirs to `nozoki@1d5c553` (`docs/UXD.md`, version line, v7). Nothing in this document cites the
  dead paths; C-R3 stands on its own argument (RN-3) and the experience half is in the UXD's body
  *(re: § 12; source: `docs/UXD.md` RN-29)*.
- **RN-33:** *(CDO)* *(added)* The C-E clause carries the UXD's cross-surface entries — § 7 and
  § 8, and the fence entries they cite — and none of § 6's per-screen cells, *because* § 4 is what
  every slice is checked against, and a condition that only one screen carries is not a condition
  on every surface: it is that slice's *Reached when*, cited from the UXD cell when the slice is
  drawn. Two of the UXD's cross-surface entries are absent by that rule and not by oversight: UX-I12
  (rendered Markdown) is one surface's, and lands in the slice that renders it; UX-A3 is carried
  inside C-E10 rather than alone, because it binds the README, which is a public surface and not a
  screen *(re: § 4 C-E; source: `docs/UXD.md` § 7, § 8; `system/experience/visual_restrictions.md`
  § 2)*.
- **RN-34:** *(CTO)* *(added)* A defect in the decision log and the enforcement store, found while
  reading them for this run and reported rather than repaired: **14** citations of
  `docs/trail/sdd/cycle-1.md` across ADR-0002, ADR-0003, ADR-0006, ADR-0007 and ADR-0008 no longer
  resolve since `nozoki@9c91359` deleted the previous SDD's trail; **23** citations of this
  document's review notes by number across ADR-0001 – ADR-0008 were written against the deleted
  numbering — RN-24 and RN-25 (cited by ADR-0005, ADR-0007 and ADR-0008) have no note here, and the
  eight that resolve now land on notes about other subjects; and `docs/nfdr.md:385` cites
  `SDD § 6 S-4` for live refresh, which is now `see-git-status`. The cited file stands at
  `nozoki@70a879a:docs/trail/sdd/cycle-1.md`. The repair is the records' own, never this document's
  (§ 12, *The downstream boundary*), and is already routed to the Principal Architect at
  `docs/architecture_open_issues.md` § 3.1, opened at `nozoki@20b9a94`. Two consequences for this
  document: RN-20 – RN-29 stay **empty** until the records are re-pointed, so a dead citation into
  that range keeps failing visibly rather than resolving silently to the wrong subject — which is
  why this note is RN-34 and the next is RN-35; and this run's own citations of the records (§ 2,
  § 4, § 12, RN-1 – RN-13) point at record numbers and section names, never at a record's review-note
  numbers. Measured 2026-09-03 against `nozoki@59287c9`; raised at `docs/trail/sdd/cycle-1.md`
  § 5.2 *(re: § 12; source: `docs/adr/0001` – `0008`; `docs/nfdr.md:385`)*.
- **RN-35:** *(CTO)* *(added)* Two values for the history that FR-18 leaves downstream, fixed in
  `read-the-history`'s command half: the port's **window** is 1,000 commits from the requested
  tips, past which the walk stops and says so — the mechanism behind UX-S6's stated end, "older
  commits are not shown", with no control that loads more; and the **default tip set** the renderer
  requests is HEAD plus every local branch sharing a commit with it inside the window — FR-18's "the
  current branch and what relates to it" made mechanical, so a reader who never touches the choice
  arrives at a graph. The window is an invented value with no measurement behind it: it is a design
  bound, not a performance bar, and is revisited when `checks/latency.sh` prints figures over the
  `scale-large` fixture's history (C-I4); the tip-set rule is a mechanism, and the words the history
  view uses for the choice are the FDR's and the Content Editor's, not this document's *(re: § 6
  S-9, § 3 `git-reader`; source: SRS FR-18; UXD UX-S6, UX-F4)*.
- **RN-36:** *(CTO)* *(added)* § 3 gains the units table `sdd_template.md` v4.1.0 requires under the
  parts table — four rows, the four distinct *Lives in* values, and nothing else in § 3 moved —
  *because* the skeleton launcher's measurement against this document on 2026-09-03 showed that a
  path alone does not say what it is: it made four bare directories, gave neither Rust crate a
  `Cargo.toml` and put the TypeScript frame at the product root. Each cell's ground: `Rust` and
  `crate` for the two crates, whose `crates/` placement the Rust packet's layout requires;
  `TypeScript` and `package` for `nozoki-ui`, where the frame lands, as the card's test command
  already assumes; `Shell` and `directory` for `checks` — Shell because the card declares it for
  the `checks/*.sh` harness by name, `directory` because it builds nothing and is exactly itself.
  One tension, named: the template glosses `directory` as a unit with no language, and this row has
  one; the load-bearing test is what gets created, and on that test `checks` is a `directory`. If
  that reading is wrong the fix is the template's and the row that changes is one cell. Answered
  in the owner's seat at `docs/trail/sdd/cycle-1.md` § 5.1 *(re: § 3; source: `sdd_template.md`
  v4.1.0 § 3; `system/projects/nozoki/project.md` `Languages:`)*.
- **RN-37:** *(CPO)* *(changed)* From `open-a-folder` until `see-git-status` lands, the sidebar
  holds the Files view alone — S-1's *Not in this slice* fences the rail's Git entry and the Git
  view to `see-git-status`, and S-1's observable half states the consequence — which departs, for
  intermediate builds, from `docs/UXD.md` § 4's rail "holding exactly the two entries that exist,
  Files and Git" — *because* the first slice is cut to prove the wall with no Git linked (RN-9,
  step 5), and a Git entry whose view could show only *pending* forever would draw a state the
  tool never resolves (UX-I13). It is the same shape as RN-18's `.md`-as-plain-text intermediate,
  and closes the same way: no release ships it. `first-public-release` lands after the whole v1
  cut by the owner's ruling (RN-17; `docs/trail/sdd/cycle-1.md` § 3.1, § 1.1), and `see-git-status` is
  inside that cut *(re: § 6 S-1 *Not in this slice*, S-4; source: UXD § 4, UX-I13; SRS FR-11)*.
- **RN-38:** *(CTO)* *(added)* § 4 gains C-I6 — the priced contract pinned at each major's `.0.0`
  tag and proved by `checks/contract.sh` on every tagged release after it — with the script and
  its pin added to `read-only-harness` (§ 3), the artifact and the command added to
  `promise-one-point-zero`'s command half, and R-12 naming what it catches — *because* the owner's
  confirm (`docs/trail/sdd/cycle-2.md` § 2.2) makes the four-member contract the product's
  declaration rather than a seat's draft, and a declaration is held by a test or by memory. The
  unconditional set already had its tests on every build — `read-only.sh`, `no-network.sh`,
  `own-state.sh` (C-I3, C-D4). The priced set had none: the floor was held by a literal `prints
  14.0` in one slice's bar and by C-R5's sentence that raising it after 1.0.0 is a breaking
  change, and a surface's presence by nothing — `read-only.sh` exercises whatever SM-4 lists, so a
  command removed from the list is a command it stops exercising, not a failure. What the check
  reads is exactly the priced members and nothing the contract excludes: no wording, no token, no
  log line. The pin is read from the `.0.0` tag rather than the working tree so that holding a
  release to it needs no reviewer's memory either — the reason `deps.allow` is diffed rather than
  trusted (C-R6). A technical call inside this seat's lane: it changes no member of the contract
  and nothing the owner was asked; the CPO's declaration and the CDO's observable half stand as
  written *(re: § 3 `read-only-harness`, § 4 C-I6, § 6 S-11 *Reached when* and *Rests on*, § 11
  R-12; source: `docs/trail/sdd/cycle-2.md` § 2.2; SRS C-6, C-11, AC-14; § 4 C-R4, C-R5)*.
- **RN-39:** *(CTO)* *(changed)* `promise-one-point-zero`'s command half re-runs
  `first-public-release`'s and now exempts that half's closing check — the version "is below
  1.0.0" — which the same sentence's `v1.0.0` tag cannot pass; the bar had named only
  `bundle.sh`'s entry count as the difference. Found while walking the slice at run 3, round 1,
  and fixed in place (`<CORE>/doctrine/governance/found_while_walking.md`, clause 1); owed since
  run 1, and no other field or slice moves *(re: § 6 S-11 *Reached when*, command half; source:
  § 6 S-7 *Reached when*, command half; SRS C-6)*.
- **RN-40:** *(CDO)* *(changed)* `promise-one-point-zero`'s observable half now cites the owner's
  confirm where it stands for good (`docs/trail/sdd/cycle-2.md` § 2.2) rather than the transient
  companion, and its closing sentence names all four of the contract's exclusions where it had
  named three: the harness's output joins the message wording, the token values and the log's
  lines as what a person may see differ between releases without a promise breaking — *because*
  the confirmed item excludes "anything the harness prints" in terms, and that output is a surface
  a person watches at a release (§ 5 step 1, E-8; RN-30), so an observable half that left it out
  let a reader hold a changed check line against the promise. Found while repointing at run 3,
  round 1, and fixed in place (`<CORE>/doctrine/governance/found_while_walking.md`, clause 1). No
  member of the contract moves, no other field, and nothing in the C-E clause or § 12 reacts to
  §§ 2.2 or 2.4 settling: C-E5 already carries read-only as the identity, which is the
  unconditional set's kind and not the priced set's, and every C-E condition names its wording as
  `docs/CONTENT.md`'s and its tokens as `docs/DESIGN.md`'s — outside the promise, as the confirm
  leaves them *(re: § 6 S-11 *Reached when*, observable half; source: `docs/trail/sdd/cycle-2.md`
  § 2.2, the exclusions; § 3 `read-only-harness`; § 4 C-E5)*.
- **RN-41:** *(CTO)* *(changed)* § 3 `fs-reader`'s text rule admits a second encoding: a file whose
  bytes begin with a UTF-16 byte-order mark and decode as UTF-16 is text, beside UTF-8 with or
  without its mark; and the rule now states its own boundary — no detection from content, no third
  encoding, one undecodable sequence makes the file not text, an empty file is text. `read-a-file`'s
  command half gains the matching fixtures. *Because* the owner set that value, confirmed at
  `docs/trail/fdr/cycle-1.md` § 2.4: the mark says what the file is, so admitting it is not a
  guess, and refusing a file the tool can read without guessing is the refusal FR-29's "never
  refused" is written against. The SRS fixes no encoding — FR-10 names "binary or undecodable
  content" and no more — so the UTF-8-only sentence was this seat's own reading at run 1, written
  without that answer in front of it (the SDD this one replaced stated no text rule, so the answer
  had no earlier sentence to land in). The value is taken from where the owner set it and nowhere
  else: the FDR is not an input of this document and no rule is read from it; the companion's § 5.1,
  which names the same two sentences, kept its Answer slot for the owner, untouched by that run.
  That slot came back **confirm** — the owner's seat found the fold already matching cycle-1
  §§ 2.4 and 2.7 clause by clause — and the item stands whole at `docs/trail/sdd/cycle-3.md`
  § 5.1; run 5 re-checked the fold against the same answers and folded nothing further.
  No part, seam, slice, edge or place in the order moves *(re: § 3 `fs-reader`; § 6 S-2 *Reached
  when*, command half; source: `docs/trail/fdr/cycle-1.md` § 2.4; SRS FR-10, FR-29;
  `docs/trail/sdd/cycle-3.md` § 5.1)*.
- **RN-42:** *(CTO)* *(changed)* § 11 R-3's response no longer has the `failed` Git item "naming
  the folder to choose instead": the item's observed condition is where the Git directory lies,
  this folder's Git state is therefore not read, and no folder is offered. *Because* the owner
  overrode the earlier wording at `docs/trail/fdr/cycle-1.md` § 2.7 and called for it to be met at
  this document's next revision (`docs/fdr.md` RN-7): choosing the folder that holds the Git
  directory views *that* folder — the main worktree in place of the linked one, the superproject in
  place of the submodule — never this one with its Git state, so the route the old response named
  led somewhere else, and a route that leads elsewhere is a dead end in a route's clothes. This
  document's first cut (run 1) carried the old wording without that answer in front of it. The
  message's shape — an observed condition with nothing to do next — is C-E4's and
  `docs/CONTENT.md`'s, not this note's; the fixture (AC-25's own-top-level case, C-I3's
  `linked-worktree` and `submodule`) is unchanged. The same provenance rule as RN-41: the owner's
  answer is taken from where it was set, the FDR is read for no rule, and the companion's § 5.1
  kept its slot for the owner — answered **confirm** and retired whole to
  `docs/trail/sdd/cycle-3.md` § 5.1 (RN-41 carries the close). No part, seam, slice, edge or place
  in the order moves *(re: § 11 R-3; source: `docs/trail/fdr/cycle-1.md` § 2.7; `docs/fdr.md`
  RN-7; § 4 C-E4, C-I1, C-I3; SRS FR-1, FR-33; `docs/trail/sdd/cycle-3.md` § 5.1)*.
- **RN-43:** *(CDO)* *(changed)* § 4 C-E4 names the terminal form a message's third part may
  take, and § 6 `see-git-status`'s observable half gains the linked-worktree and submodule case.
  *Because* the CTO asked this seat to confirm that C-E4 carries the shape § 11 R-3's `failed`
  item now takes — an observed condition with nothing to do next (RN-42) — and it did not as
  written: C-E4 said *what to do next* and no more, narrower than the formula it binds wording
  to, whose third part is *what you can do next, or that there is nothing to do and what ends the
  wait* (`docs/CONTENT.md` § *Message patterns* → *Error — an observed condition*; the *Terminal*
  row of § *Voice*, `docs/CONTENT.md:62`). A builder holding C-E4 alone would write R-3's item a
  next step, and the one step available — the folder holding the Git directory — is the wording
  the owner overrode (`docs/trail/fdr/cycle-1.md` § 2.7). The narrowing was not something C-E4
  could name as a violation, which is the defect: a condition whose positive text is stricter
  than its source binds by accident. UX-I6 reads the same three parts and is not departed from —
  it fixes what a message carries and sends the standard to `docs/CONTENT.md`, and the terminal
  form is that standard's. One reading is this seat's and is stated rather than assumed: the
  formula's *what ends the wait* is written for a condition a wait ends (its example is
  `.git/index.lock`), and R-3's condition no wait ends; `docs/CONTENT.md` already applies the same
  formula to such a case — the not-text file, "with the tree still there as the way on"
  (§ *Tone*), traced to § *Error* at its § *Traceability* — so the form covers R-3 and no gap is
  raised against that document. Whether it wants R-3's case as an example of its own is the
  Content Editor's, and this note names it rather than wording it. The S-4 clause exists so the
  owner's overridden wording has an observable in the slice that delivers it, not only a line in
  the risk register: S-4's command half already runs the `linked-worktree` and `submodule`
  fixtures and its *Traces to* carries AC-25. The UXD names the case nowhere — UX-S3's Error cell
  enumerates the transient reading, a lock or an unreadable file — so the clause cites the general
  entries it instantiates (UX-I10, UX-I14) and R-3 for the case, and no UXD gap is claimed: the
  entries cover it. Nothing else in this seat's lanes reacts to RN-41: `read-a-file`'s observable
  half says *any other text file is plain text* and lets `fs-reader`'s rule decide what text is.
  The widening was made in run 4 on this seat's own reading of the settled documents, not on an
  answer; the owner's seat has since read it as one of the "two additions this item did not
  predict" and confirmed it as correct (`docs/trail/sdd/cycle-3.md` § 5.1, its *Answer* slot),
  and run 5 re-checked C-E4 and S-4's sentence against that answer and changed neither.
  No part, seam, slice, edge or place in the order moves *(re: § 4 C-E4; § 6 S-4 *Reached when*,
  observable half; source: `docs/CONTENT.md:62`, § *Message patterns*, § *Tone*,
  § *Traceability*; `docs/UXD.md` UX-I6, UX-I10, UX-I14, UX-S3; § 11 R-3, RN-42;
  `docs/trail/sdd/cycle-3.md` § 5.1)*.
- **RN-44:** *(CTO)* *(added)* `see-git-status`'s command half gains one reducer case for § 11
  R-3: a port double whose `probe` answers `root` and whose `state()` returns the error naming a
  Git directory outside the folder, and the model holds the Git item as `failed(condition)` with
  that path as the condition and no folder path in it; the failed Git read changes the Git item
  and nothing else, so the tree and every item in it stand as they were before the read — a file
  stays `observed`, a folder not yet expanded stays `pending`, and an entry that had failed stays
  `failed`. *Because* the observable half now states that case (RN-43) and the command half
  exercised nothing for it: when this note was written the `linked-worktree` and `submodule`
  fixtures ran only through `root_finding`. A bar with one half checks one side of the slice. The
  double is how the reducer case reaches the model with no adapter behind it, and the check is
  the reducer's (C-I1: a failure is a state, and it changes no other item), not the port's — R-3's
  *shows up as* stays the port's observation on a built bundle. *(Corrected in place on
  2026-10-04. This note said every tree item is `observed`, and gave as the double's reason that
  the fixtures could not produce the failure in-process; RN-88 quotes what it said and records
  why it moved.)* *(Corrected in place a second time on 2026-10-04. The parenthesis quoting C-I1
  read "a failure is a state, its siblings `observed`"; RN-89 records why it moved.)* Found while confirming RN-43 at run 4, round 2, and
  fixed in place (`<CORE>/doctrine/governance/found_while_walking.md`, clause 1). No part, seam,
  slice, edge or place in the order moves *(re: § 6 S-4 *Reached when*, command half; source:
  § 11 R-3; § 3 `Item<T>`; § 4 C-I1, C-I3, C-R2; RN-43)*.
- **RN-45:** *(CTO)* *(changed)* C-I3's bundle probe no longer reads `APP_SANDBOX_CONTAINER_ID`
  from the launched bundle's environment. It reads the operating system's own report that the
  launched main process is sandboxed, with an out-of-grant file read and an outbound network
  connection denied, and it carries a no-entitlement control that must fail. Four sentences move
  with it: § 4 C-I3, § 6 `open-a-folder`'s *Command* bar, § 11 R-8's *shows up as*, and the fourth
  *Open Questions* item, which closes and leaves one narrower question standing — a GitHub-hosted
  macOS runner, unmeasured. *Because* the first built bundle answered the question this document
  had left open, and not the way the probe expected: the marker is absent from a sandboxed main
  process under either signature and does not separate a sandboxed bundle from an unsandboxed one
  (`nozoki@ccb58d8`, commit body), while the sandbox itself holds. The PM raised it from a
  post-build review, since no seat of this run could have seen it. The answer was written in the
  owner's seat by an unattended `companion-self-answer` run, not by the owner in person — its
  verdict and reasons are `docs/trail/sdd/self_answer-9.md`, and the item with its answer is kept
  whole at `docs/trail/sdd/cycle-4.md` § 5.1. This seat folded that answer as written and added
  two things of its own. First, § 10 RC-1: the template's trigger "a slice's *Reached when* cannot
  be met as written" held literally for `open-a-folder`'s command half, that half is this seat's,
  and a bar redrawn with no record would leave the next reader unable to tell this correction
  from a drift. Second, C-I3's *Violated by* gains "a bundle probe run without its negative
  control": the answer makes the control part of the probe, and the probe rests on an
  undocumented function, so the control is what keeps a silent change in that function from
  reading green — a condition a slice could break, and now one it can be named for breaking.
  Apple's sentence was re-read at its source this run; the page names neither the marker nor
  `sandbox_check`. ADR-0008 and NFDR QC-25 still state the marker and are the Principal
  Architect's to bring into line. No part, seam, slice, edge or place in the order moves *(re:
  § 4 C-I3; § 6 `open-a-folder` *Reached when*, command half; § 10 RC-1; § 11 R-8; Open Questions;
  source: `docs/trail/sdd/cycle-4.md` § 5.1; `docs/trail/sdd/self_answer-9.md`; `nozoki@ccb58d8`;
  https://developer.apple.com/documentation/security/protecting-user-data-with-app-sandbox; SRS
  NFR-9)*.
- **RN-46:** *(CPO)* *(added)* § 5 step 4's sizing of E-1 said "if the probe fails, every later
  slice is redrawn (§ 11 R-8)". It now names which failure it means: the probe finding the wall
  absent redraws every later slice, and a probe that fails while the wall stands redraws the probe
  and no slice. *Because* when the sentence was written the document knew one kind of probe
  failure, and § 10 RC-1 now records the other: the first built bundle failed the probe, R-8 did
  not fire, and every slice was retained. Left as it was, the sentence would read as contradicted
  by RC-1 to anyone who met both cold. The sizing itself does not move: `open-a-folder` stays one
  slice of the same size, not too narrow because its result changes what happens next — and the
  first result did, by re-cutting the probe. No slug, *Delivers*, *Moves toward*, fence or PRD
  trace changes, and the PRD names no sandbox observable, so its boundary (§ 12) is untouched
  *(re: § 5 step 4, E-1; source: § 10 RC-1; § 11 R-8; `docs/trail/sdd/cycle-4.md` § 5.1)*.
- **RN-47:** *(CTO)* *(changed)* § 4 C-R7 no longer says the capability file grants "exactly SM-4's
  command list". It says a build grants exactly the commands its landed slices register, that the
  set is always inside SM-4's list, and that from `v1.0.0` the set is the list whole. The grant is
  stated there once. § 3 SM-4 matches it: the seam names all eight commands as the closed list,
  each crossing from the build in which a slice registers it, where it had marked only the last
  three "where built". § 4 C-I3's `read-only.sh` exercises "every command the build grants", where
  it said "every command on SM-4's list". *Because* the document contradicted itself, and the
  built tree showed which side was wrong. The slices already stage the grant: S-2, S-3 and S-6 put
  their command in the capability file in the slice that builds it, S-8, S-9 and S-10 say theirs
  "joins" it, and S-11 checks for all eight at `v1.0.0`. So no build before the last slice could
  meet C-R7 as it read. The first built tree grants `allow-open-folder` and `allow-list-tree` and
  nothing else (`nozoki@1741429:crates/nozoki-app/capabilities/main.json`). The PM raised it from a
  post-build review, since no seat of this run could have seen it. The answer was written in the
  owner's seat by an unattended `companion-self-answer` run, not by the owner in person. Its
  verdict and reasons are `docs/trail/sdd/self_answer-11.md`, and the item with its answer is kept
  whole at `docs/trail/sdd/cycle-5.md` § 5.1. This seat folded the answer's sentence and its three
  additions as written. The first is C-I3's staging, above. The second is that C-R7's set equality
  reads the commands the host registers and never a hand-kept copy. The tree's test holds two
  hand-kept constants today (`nozoki@1741429:crates/nozoki-app/tests/config.rs:L228-L231`), and
  how the test comes to read the registered set is the delivery tier's to plan. The third is the
  case the staged check does not cover, named in C-R7 so it is not read as coverage: before
  `v1.0.0`, a change that stops registering a built command passes, and § 11 R-12 already says the
  same of the priced set. The answer leaves open where the asset scheme's grant is written,
  because the third *Open Question* asks exactly that, so C-R7 says when the scheme enters the
  grant and not where. This seat added two things of its own. C-R7's *Violated by* is rewritten
  from "any widening of either list" to the five violations the new sentences make nameable,
  because "either list" no longer names a fixed list a slice could widen. And § 6 S-7's command
  half carried C-I3's old sentence, "every command on `SM-4`'s list", under a clause headed "the
  whole surface built so far". It now reads "every command the build grants": the same defect in
  the same lane, fixed in place (`<CORE>/doctrine/governance/found_while_walking.md`). The six
  slice bars the answer quotes are unchanged, since they were the side that was right, and S-11's
  "`SM-4`'s complete list" is unchanged, since at `v1.0.0` the two readings are one list. § 10
  gains no entry: no slice's *Reached when* failed as written, and the sentence that failed is a
  § 4 condition. `docs/nfdr.md` QC-24 still states the whole list and is the Principal Architect's
  to bring into line. No part, seam owner, slice, edge or place in the order moves *(re: § 3
  SM-4; § 4 C-R7, C-I3; § 6 S-7 *Reached when*, command half; source:
  `docs/trail/sdd/cycle-5.md` § 5.1; `docs/trail/sdd/self_answer-11.md`; `nozoki@1741429`; § 6
  S-11; § 4 C-I6; § 11 R-12; SRS NFR-16, NFR-8, C-6)*.
- **RN-48:** *(CTO)* *(changed)* § 4 C-I3's bundle probe reads the operating system's report
  within a bounded window after launch, not once: the pass is the first ask on which the launched
  main process is reported sandboxed with the out-of-grant read and the outbound connection both
  denied, every ask first checks that the pid still names a process, the bound is the script's to
  fix and is printed in the probe's output, and this document states no number. The negative
  control answers `sandboxed: no` on every ask for the whole window. C-I3's "the two denials test
  the wall C-R2 promises rather than a proxy for it" is narrowed to where the unentitled control
  reports them allowed, and C-I3 now says that on a GitHub-hosted macOS runner the read denial
  separates nothing. § 11 R-8's *shows up as* states the same window, and the fourth *Open
  Questions* item — whether the probe reads the same on a hosted runner — is closed and removed:
  the sandbox holds on a hosted runner, and the probe read too early. § 10 RC-1's *Still
  unresolved* gains the pointer here, because its "carried in *Open Questions*" would otherwise
  lead a cold reader to nothing. *Because* the hosted runner was measured on 2026-09-23 and the
  measurement was neither of the two outcomes the item named. A temporary CI diagnostic (product
  branch `ci-sandbox-diagnostic`, `nozoki@247b5ed`) launched a bundle and asked
  `checks/sandbox_probe.rs` five times, 0.25 s apart. GitHub Actions run 35797893381 (`macos-14`,
  read with `gh run view 35797893381 --log` on 2026-09-23 by the answering run): the real bundle
  `sandboxed: no` with the outbound connection allowed on ask 1, then `sandboxed: yes` with both
  denied on asks 2–5; the unentitled copy `sandboxed: no` on all five, with the out-of-grant read
  reported `denied` on every one; the same run's one-ask *Bundle probe* step failed on pid 18980,
  `sandboxed: no`. Run 35794012057 answered `yes` on all 60 asks of three launches. On the owner's
  Mac the same diagnostic's re-signed copy answered `no` on ask 1 and `yes` on asks 2–5 — taken
  from the item's own record (`docs/trail/sdd/cycle-6.md` § 5.1); this seat did not measure it. A
  read-once probe was racing the process's own sandbox initialisation, and the wall stood. The PM
  raised it from the first hosted-runner CI runs, since no seat of this run could have seen it.
  The answer was written in the owner's seat by an unattended `companion-self-answer` run, not by
  the owner in person — its verdict and reasons are `docs/trail/sdd/self_answer-12.md`, and the
  item with its answer is kept whole at `docs/trail/sdd/cycle-6.md` § 5.1. This seat folded the
  answer's close and its four additions as written. The dead-pid check rests on what the probe
  records of `sandbox_check` — "sandboxed, everything denied" for a pid that names no process
  (`checks/sandbox_probe.rs:L103-L115`) — and the script on `main` already holds the window, the
  printed bound, the whole-window control and the per-ask existence check (`nozoki@cf539a4`;
  `checks/bundle.sh:L38-L40`, `:L76-L82`, `:L290-L296`, `:L326-L330`, `:L383`): the fold makes
  this document state what the script relies on. This seat added three things of its own. First,
  C-I3's *Violated by* names the four conditions the new sentences make nameable — a read-once
  probe, an ask judged on a pid that no longer names a process, a control passed on fewer asks
  than the window, a bound not printed — because a condition a slice cannot be named for
  breaking binds nothing. Second, C-I3 names the case the window does not cover, a report that
  turns from `yes` back to `no` after the pass, so the window is not read as coverage; every
  observed sequence is `no` then `yes`, and no run has shown the other. Third, § 10 gains no
  entry, and the reason is recorded because the other side was close: every red one-ask run read
  literally as R-8, but RC-1 exists because the *observable* was wrong, and here the observable
  is right and only the moment it was read was wrong — `open-a-folder`'s command bar states the
  observable and not the timing, so no *Reached when* failed as written, and that bar is
  unchanged. A reader who takes the other side would record RC-2 with *Changed* limited to C-I3's
  timing clause, and nothing else here would move. Why the runner reports the out-of-grant read
  denied for an unsandboxed process is not known: the log shows it and nothing this seat read
  explains it. The same narrowing stands in ADR-0010 § Consequences and NFDR QC-25, which are the
  Principal Architect's to bring into line; the window and the narrowing are raised there as
  `docs/architecture_open_issues.md` §§ 3.2 and 3.3. No part, seam, slice, edge or place in the
  order moves *(re: § 4 C-I3; § 10 RC-1; § 11 R-8; Open Questions; source:
  `docs/trail/sdd/cycle-6.md` § 5.1; `docs/trail/sdd/self_answer-12.md`; `nozoki@247b5ed`;
  `nozoki@cf539a4`; `checks/sandbox_probe.rs:L103-L115`; `checks/bundle.sh:L38-L40`; ADR-0010
  § Consequences; SRS NFR-9)*.
- **RN-49:** *(CPO)* *(added)* The header gains the `**Inputs read:**` line — `PRD Settled · SRS
  Settled · UXD Settled` — in the one form `<CORE>/doctrine/governance/unsettled_inputs.md` § *The
  rule* fixes. *Because* the line was absent, and had never been in this document (`git log
  -S'Inputs read' -- docs/SDD.md` returns no commit, 2026-09-23), while the template
  (`<CORE>/templates/product-templates/sdd_template.md`, header) and the rule require it on every
  revision, so that a later reader can tell the document was built on settled ground rather than
  on ground nobody checked. A defect found while walking, fixed in place
  (`<CORE>/doctrine/governance/found_while_walking.md` § *The rule*, clause 1); the line names no
  seat's part in § *Who holds what*, so no lane is crossed. The statuses are read from the inputs'
  own headers this run: `docs/PRD.md:L3` (v15), `docs/SRS.md:L3` (v12), `docs/UXD.md:L3` (v10) —
  the same versions § 12's three boundary clauses cite. Nothing in §§ 1–12 moves *(re: header;
  source: `unsettled_inputs.md` § *The rule*; `docs/PRD.md:L3-L5`; `docs/SRS.md:L3-L5`;
  `docs/UXD.md:L3-L5`)*.
- **RN-50:** *(CTO)* *(changed)* § 4 C-I3's "a red run says how long it waited" now states which
  red runs it reaches: only a run that ends because the window ran out. A run ended by a failed
  ask — `sandbox_check` missing or returning an error, or the pid no longer naming a process —
  ends at once, names what failed, and prints no bound; a process gone before the pass is named
  as taking that same path. The negative control is scoped the same way: its red run ends at once
  on the first report that is not `sandboxed: no`, so only its pass line carries the bound. A
  second case the window does not cover is named beside the yes→no one — the failed-ask line does
  not say on which ask the run ended, so a process that dies does not say whether it died at
  launch or late in the window. *Violated by*'s "a bound not printed" is rescoped to the two
  lines that owe one (the pass line and the window-ran-out red line), and gains "a failed-ask run
  that does not name what failed", which is the condition the failed-ask path is now bound to.
  *Because* the sentence as v8 wrote it named one failure and read as covering three, and the
  script it describes has never printed the bound on the failed-ask path: the ordinary loop's
  failed ask dies with the probe's stderr and no bound (`checks/bundle.sh:L338`), the control's
  failed ask dies the same way (`:L303`), the window-out red line is the one that states the
  bound (`:L375`), the control's pass line is the control's only one (`:L322`, red at `:L323`),
  and a gone pid reaches the failed-ask path because the probe refuses it
  (`checks/sandbox_probe.rs:L103-L115`). The reason the clause gives for the bound — separating
  "waited the whole window and the wall is absent" from "gave up early" — is the one the bound
  was added under (`docs/trail/sdd/self_answer-12.md`, addition 1), and it is why a failed-ask
  run owes none: it neither waited out the window nor gave up. The PM raised it
  (`docs/trail/sdd/cycle-7.md` § 5.1, "a run that did not wait has no wait to report"); the
  answer was written in the owner's seat by an unattended `companion-self-answer` run, not by the
  owner in person — its verdict, the corrected reason, and the three additions (a)–(c) are
  `docs/trail/sdd/self_answer-17.md` § 5.1, and this seat folded them as written. The doubt's
  widening — "or on which ask it ended" — is not taken: the item cites no run where a process was
  gone mid-window, and the answer holds it until one occurs; C-I3 names the gap instead, so a
  reader does not take the window as coverage of it. `checks/bundle.sh` changes nothing. § 11
  R-8's *shows up as* already describes only the window-out case and does not move; the
  `open-a-folder` command bar quotes the observable, not the bound, and does not move. NFDR QC-25
  (`docs/nfdr.md:L253-L254`) copies the v8 sentence and is the Principal Architect's to re-derive
  from § 4 under this section's opening note — not contradicted, only less precise, so no item is
  raised on the architecture companion. **The Version line** (companion § 2.1): runs 6, 7 and 8
  each replaced line 9 instead of adding above it, so v8's entry ran into the tail of v5's and
  v5–v7 had no opening — `nozoki@67372a5`, `b3439e8`, `c1f8a20`, `9b36a42`, line 9 of each. This
  seat restored v5's opening clause and the v6, v7 and v8 entries from those commits verbatim,
  newest first below v9, each as its own line. One departure from the item's literal draft: the
  restored entries open `Version <n> —`, not `**Version:** <n> —`, so the bold marker names the
  header line alone, the way this document already writes Versions 4 to 1 inline. The item's slot
  was left at its placeholder by the raising run, which named the decision as this round's; a
  header line stating something false is a defect found while walking, clause 1
  (`<CORE>/doctrine/governance/found_while_walking.md` § *The rule*), and the text is all in git,
  so nothing was re-derived. The companion was consumed this run: copied whole to
  `docs/trail/sdd/cycle-7.md` before any seat touched it, and removed from disk empty of items.
  No part, seam, slice, edge or place in the order moves *(re: § 4 C-I3; header; source:
  `docs/trail/sdd/cycle-7.md` §§ 2.1, 5.1; `docs/trail/sdd/self_answer-17.md`;
  `docs/trail/sdd/self_answer-12.md`; `checks/bundle.sh:L303`, `:L322-L323`, `:L338`, `:L375`;
  `checks/sandbox_probe.rs:L103-L115`; `nozoki@67372a5`; `nozoki@b3439e8`; `nozoki@c1f8a20`;
  `nozoki@9b36a42`; SRS NFR-9)*.
- **RN-51:** *(CPO)* *(changed)* Three sentences in this seat's lane move on the owner's
  cycle-8 ruling, and no slice does. § 1's read-only bullet names the ruling as a constraint
  fixed above the design — no network entitlement is ever granted, the refusal is the operating
  system's and never the code's — so that § 4 C-R2's rewrite has a § 1 to answer to rather than
  only a trail item. § 5 step 4's E-1 bar no longer quotes C-R2's list as "exact" — it points at
  "the entitlements C-R2 fixes", because the list is C-R2's to state once and the ruling replaces
  *exactly* with a rule (`docs/trail/sdd/cycle-8.md` § 5.1, answer 2) — and gains the half the bar
  always needed: the bundle CI ships draws its window under those entitlements. *Because* the
  bar as written was met by a bundle that delivers nothing: `checks/bundle.sh` passed on
  `e7b2bcd` and the window it launched was empty (`docs/trail/sdd/cycle-8.md` § 5.1, the sample
  table), so "carries C-R2's exact entitlements with the sandbox enforced" was a bar on the wall
  alone, and a wall with nothing running behind it is the fragment step 2 exists to catch — the
  checker with nothing to check. The sizing itself holds: `open-a-folder` stays one slice, since
  the wall and the window are one decision on one artifact, and a third not-too-narrow case is
  named beside RC-1's — a window that does not draw while the wall stands redraws C-R2 or the
  host's configuration and no slice, with the § 2 exception left to § 10. § 12's PRD boundary
  records that the item touched the promise and opened no gap: `docs/PRD.md` § Data & Privacy
  already says "no network call at all during operation", the owner held that line, and the PRD
  is unchanged. No slug, *Delivers*, *Moves toward* or fence moves: S-1's *Delivers* — "see that
  folder's tree in a single window" — was never wrong, it was never met on the shipped bundle,
  and which half of its *Reached when* failed is the CDO's and the CTO's to record at § 10, not
  this seat's. The gate the ruling's answer 4 orders, the mechanism its answer 3 owes and C-R2's
  rewrite are the CTO's; the observable half's artifact — that S-1 is walked on the bundle CI
  built, launched from Finder, and on nothing else — is the CDO's *(re: § 1; § 5 step 4, E-1;
  § 12 the PRD boundary; source: `docs/trail/sdd/cycle-8.md` § 5.1; `docs/PRD.md` § Data &
  Privacy; § 10 RC-1; § 11 R-8; RN-46)*.
- **RN-52:** *(CTO)* *(changed)* The owner's cycle-8 ruling is folded on this seat's four lanes,
  and the mechanism it asked for (answer 3) is found and is not a configuration. **The
  mechanism.** WebKit's XPC services — Networking, GPU, and the content process that needs them —
  check the host's entitlements at their own start: `XPCServiceInitializerDelegate::checkEntitlements()`
  returns true at once when the host holds `com.apple.security.network.client`, and otherwise,
  for a sandboxed host, calls `sandbox_check_by_audit_token(…, "mach-lookup", …,
  "com.apple.nsurlsessiond")` on the host's audit token and, on a non-zero result, logs
  `RELEASE_LOG_FAULT(Network, "Application does not have permission to communicate with network
  resources. rc=%d : errno=%d", …)` and returns false
  (https://github.com/WebKit/WebKit/blob/bb75cbc0003033ea73c42ef02370767aa52d6ba6/Source/WebKit/Shared/EntryPointUtilities/Cocoa/XPCService/XPCServiceEntryPoint.mm,
  `checkEntitlements`, under `#if PLATFORM(MAC) || PLATFORM(MACCATALYST)`). WebKit's own comments
  on those lines: "Remove this check once WebKit can work without network access" and "This
  requirement is too strict, it should be possible to load file:// resources without network
  access" (`rdar://problem/54178641`). On this Mac, `/usr/bin/log show --start "2026-09-23
  01:31:20" --end "2026-09-23 01:32:50" --style compact --predicate '(process CONTAINS[c]
  "WebKit" OR …)'` — the owner's first sampling window — prints `com.apple.WebKit.GPU[87803] …
  (WebKit) Application does not have permission to communicate with network resources. rc=1 :
  errno=34` at 01:31:24.109, then the same line from `com.apple.WebKit.Networking` pids 87805,
  87810, 87813, 87816, … every 15–30 ms to the window's end, all under `nozoki-app[87785]`
  launched at 01:31:23; the 02:12 window reads the same under `nozoki-app[39010]` and
  `nozoki-app[42457]`. So the content process's `processDidTerminateOrFailedToLaunch` in the
  owner's sample is the network process refusing to initialize and being relaunched: the
  requirement is WebKit's, on the host's entitlements, in the process-launch path — reachable by
  no `tauri.conf.json` key, no `wry` setting and no line of this product's, and the cycle-8
  table's last two rows are the two host states that pass the check. Corroborated, not derived:
  FB6993802, filed 2019-08-11 against macOS 10.14.6 and open
  (https://github.com/feedback-assistant/reports/issues/1); Apple's forum thread of the same year,
  where the only route named is the deprecated in-process WebView
  (https://developer.apple.com/forums/thread/116359); Tauri's docs issue reporting a white screen
  in sandboxed apps without the entitlement (https://github.com/tauri-apps/tauri-docs/issues/3171).
  **What that leaves.** Answer 3's own clause — "if the fix needs no entitlement, the list
  stands" — does not decide this case, because the fix needs the one entitlement answer 1 refuses,
  or its mach-lookup twin, which this seat reads as refused with it (RC-2 names it so the owner's
  refusal is the owner's and not assumed). So C-R1 and ADR-0002 (the system WKWebView) and C-R2
  as the ruling writes it cannot both stand, and the choice is the owner's on two grounds: the
  runtime was confirmed by the owner (`nozoki@70a879a:docs/trail/sdd/cycle-1.md` § 2.2), and
  ADR-0002 states the renderer technology is not replaceable inside the terminus
  (`docs/fdr.md` PD-29). It is the companion's § 1.1, with the exits priced and this seat's
  position — the renderer leaves WKWebView, because the wall is the product and the renderer
  wall was always the cheaper of the two to lose (§ 2, row 4) — held there, not in the lanes.
  **C-R2** is rewritten to the rule, with the v1 members kept under it — the same three members
  ADR-0003 names, so S-7's "two entries" and S-10's and S-11's "three entries" stay true and are
  not touched; *Violated by* is rescoped from "a slice that adds an entitlement" to a network
  entitlement of any kind, an entitlement with no record, and a probe report of either denial
  allowed, because the rule admits an entitlement with a record and the old clause forbade
  exactly that. **The gate** (answer 4) is C-I3's new clause and a new script,
  `checks/renderer.sh`, not a branch of `checks/bundle.sh`: that script has one job and refuses
  to launch anything but C-R2's set (`checks/bundle.sh`, its header), and the wall gate must keep
  its meaning when the renderer gate is red. Its observable is the host inside `open_folder` —
  the owner's floor, "at the least, that the page reached `open_folder`" — because it is the
  renderer's first and only unconditional call (`nozoki@a4ab8e6:nozoki-ui/src/main.ts:L14-L19`)
  and it parks in the panel (`nozoki@a4ab8e6:crates/nozoki-app/src/main.rs:L17-L19`), so a
  bounded window catches it the way
  C-I3's window catches the sandbox report. It is read from the operating system or the process
  and never from a line the product writes, for two reasons: C-I2's log holds failed and stopped
  items and nothing else, and a marker written for a check is the class of evidence RC-1 stopped
  reading. The mechanism named is the one already measured — a thread sample showing
  `pick_folder → run_on_main` (`docs/trail/sdd/cycle-8.md` § 5.1) — and the script fixes it, as
  C-I3 leaves the bound to `checks/bundle.sh`; the hosted runner is an *Open Questions* item on
  the same footing RC-1's was. Its control is the renderer build removed from `Contents/Resources`,
  the artifact `checks/bundle.sh` v1.3.0 reads before launch: a bundle with no page cannot reach
  `open_folder`, and a gate that cannot go red has not run (C-I3's own rule for the wall probe).
  **`open-a-folder`'s command half** quotes both gates and states, in italics, that no build meets
  both until § 1.1 is answered — written into the bar because a reader of S-1 must not take a
  green wall for a met slice, which is the reading `e7b2bcd` invited. **§ 12** records the
  ADR-0003 departure and QC-25's *exactly* to re-derive; the downstream boundary's "none in this
  run" was true when written and is not now. **The companion** was consumed: § 5.1 is on the trail
  byte-identical (`diff docs/SDD_open_issues.md docs/trail/sdd/cycle-8.md` printed nothing before
  this turn's edits) and is dropped from the live file as folded; § 1.1 is raised in its place, so
  the file stands and the SDD stays Draft until the owner answers it. Nothing in the SRS moves: the
  no-network requirement (NFR-8) is what the ruling holds, and whether FR-30's Markdown renders in
  a web engine or a native one is this document's, not the SRS's. § 11 gains no risk: WebKit's
  requirement is a fact recorded at RC-2, not a trigger awaited *(re: § 4 C-R2, C-I3; § 6 S-1
  *Reached when*, command half; § 10 RC-2; § 12 the downstream boundary; *Open Questions*;
  source: `docs/trail/sdd/cycle-8.md` § 5.1; WebKit `XPCServiceEntryPoint.mm` at the URL above;
  the `log show` lines above; `nozoki@a4ab8e6:nozoki-ui/src/main.ts:L14-L19`;
  `nozoki@a4ab8e6:crates/nozoki-app/src/main.rs:L17-L19`;
  `nozoki@a4ab8e6:crates/nozoki-app/Entitlements.plist`; `checks/bundle.sh` header, v1.3.0 line; ADR-0002 §
  Consequences; ADR-0003 § Decision; `docs/nfdr.md:L243-L245`; `nozoki@70a879a:docs/trail/sdd/cycle-1.md`
  §§ 2.2, 2.3; RN-51)*.
- **RN-53:** *(CDO)* *(changed)* Three moves on the cycle-8 ruling, none of them a re-cut.
  **S-1's observable half names its artifact**: the `Nozoki.app` CI built from the commit under
  test, the same bundle the two gates ran on, launched from Finder — and states that a window
  showing nothing is the half unmet whatever the command half reported. *Because* `e7b2bcd`'s
  failure was visible to this half as it stood — "the system Open panel appears" was not met —
  and nobody had run the half on that bundle: the observation was right and its aim was loose.
  "Double-clicks `Nozoki.app`" admitted a dev-server window and a hand re-signed bundle, both of
  which draw (`docs/trail/sdd/cycle-8.md` § 5.1, the sample table's third and fourth rows), so a
  reader could meet the sentence on an artifact that is not the one shipped. The correction is to
  the instrument's aim, not its reading, which is why this is a note and not a § 10 entry: the
  ground that moved is C-R2's and the command half's, and RC-2 is rightly the CTO's — the
  observable half caught what the gates missed, when the owner ran it by hand at the station.
  **§ 12's UXD clause** records that the ruling opens no UXD gap: UX-I12 and § 9 name no renderer
  and no CSS (`docs/UXD.md` § 9, UX-I12), so whichever exit the owner takes the UXD stands at v10;
  what a native renderer would move is `docs/DESIGN.md`'s realisation sentence (§ Overview: "plain
  CSS custom properties over the product's own markup"; RN-1), in that document's own run, which
  may trail this one (`<CORE>/roles/loaders/cdo_global.md` § *Output*). No C-E condition binds a
  web engine, so § 4's CDO clause is untouched by the question. **The companion's § 1.1** carries
  this seat's position on the CTO's item — (a), on the design's own grounds, with what the design
  language loses and keeps and what UX-I12 costs a native renderer — held there and not in the
  lanes, because which condition gives way is the owner's (RC-2). Two things this note surfaces
  and does not fix: § 2 row 4 cites `docs/UXD.md` § 9 for "CSS tokens over the product's own
  markup", a sentence that is `docs/DESIGN.md`'s (the CTO's row); and `README.md:L48-L49` names
  the WKWebView and plain CSS on a public surface (C-E10), the CPO's if (a) is taken *(the README
  moved: `## Stack` and the status block now name the one bundle and one process, `nozoki-mac`,
  `crates/nozoki-core` and `crates/nozoki-bridge`, and no web engine, and they keep the `checks/`
  proof sentence word for word, `nozoki@61748fe`; the two lines this clause cites stand at
  `nozoki@a4ab8e6:README.md:L48-L49`; noted 2026-09-24, RN-69)* *(re: § 6
  S-1 *Reached when*, observable half; § 12 the UXD boundary; companion § 1.1; source:
  `docs/trail/sdd/cycle-8.md` § 5.1; `docs/DESIGN.md` § Overview, § Typography, § Shapes, RN-1;
  `docs/UXD.md` § 9, UX-I12; `nozoki@a4ab8e6:README.md:L48-L49`; RC-2; RN-52)*.

- **RN-54:** *(CPO)* *(added)* Companion § 1.1 — the renderer that cannot start under C-R2's
  rule — carries this seat's position, (a), and § 12's PRD boundary gains one sentence: the item
  opens no PRD gap. *Because* the PRD names no renderer — § Dependencies / Integrations names the
  filesystem and Git alone, and no PRD section names WKWebView, Tauri or CSS (`grep -n -i
  'webview\|tauri\|css' docs/PRD.md`, empty, 2026-09-23) — so no exit changes what a stranger was
  promised, and the boundary clause would otherwise leave a reader to wonder whether a renderer
  change reaches the PRD. What this seat holds about the cut, recorded here so it is not read
  as silence: the eleven slices, their slugs, *Delivers*, fences and PRD traces do not move under
  (a), because step 1 made the entries from behaviour and never from the boxes (§ 5 step 1, the
  applied list; RN-30) — a renderer is a box. The one sizing to re-check is `read-markdown`'s,
  and only once § 2 is redrawn: its decision (three walls against untrusted content, § 5 step 4)
  becomes part structure and part layout under a single-process view, and it stays its own
  slice for the reason step 4 gives. That re-check is not written into step 4 now, because the
  owner has not chosen (a) and a sentence sized against a shape that may not be taken is
  designing ahead of the call. § 5 step 4's E-1 sentence — "unless the mechanism found forces a
  shape § 2 rejected, which is § 10's to record" (RN-51) — is the case § 10 RC-2 records, and it
  does not move. Nothing else in this seat's lanes moves; the `README.md:L48-L49` stack sentence
  the CDO names is a public surface outside this document, moved with the README if (a) lands
  *(re: § 12 the PRD boundary; companion § 1.1; source: `docs/PRD.md` § Dependencies /
  Integrations; `system/projects/nozoki/agari.md`; § 2 row 1 and *Undoing it*; § 5 step 1, step
  4; § 7; § 10 RC-2; `docs/trail/sdd/cycle-8.md` § 5.1)*.
- **RN-55:** *(CTO)* *(changed)* One citation re-pointed, in two places, on the CDO's finding
  (RN-53) seconded by the CPO (RN-54): § 2 row 4's *Wrong when* and RN-2 attributed "CSS tokens
  over the product's own markup" to `docs/UXD.md` § 9. That section names a direction, a
  token-pair rule and "every asset ships with the tool — fonts, icons, images" (its
  *Constraints* list), and neither the word CSS nor the word markup; the sentence is
  `docs/DESIGN.md`'s — "plain CSS custom properties over the product's own markup on a macOS
  window" (`docs/DESIGN.md:L12-L13`, § Overview) and RN-1 there, which itself cites UXD § 9 as
  the *direction* it realises. So the row now cites `DESIGN.md` for the realisation and UXD § 9
  for the assets shipping with the tool, and names `third_party/lucide/` for the icons (ADR-0002
  § Context). *Because* the row's ground matters more now than when it was written: the owner's
  companion § 1.1 call is priced against exactly this sentence — what a native renderer would
  re-express — and a reader who followed the citation found a section that does not say it. The
  row's *right when*, *wrong when* and *taken?* judgments do not move; the CDO's RN-53 states
  what survives re-expression (the values) and what does not (the realisation sentence), and the
  row points at it rather than restating it. RN-2 keeps its original reasoning and gains one
  parenthesis naming the correction, since a note is history and is not silently rewritten.
  Nothing else in this seat's lanes moves this round: the three seats' positions on § 1.1 are
  one — (a) — and the call is the owner's; § 4 of the companion carries no disagreement *(re: § 2
  row 4; RN-2; source: `docs/UXD.md` § 9; `docs/DESIGN.md:L12-L13`, RN-1; ADR-0002 § Context;
  RN-53; RN-54)*.
- **RN-56:** *(CTO)* *(changed)* § 4 C-I3's record line reads ADR-0010 where it read ADR-0008 —
  the fold the companion's § 2.1 proposes, drafted here for the owner's confirm — *because*
  ADR-0008's Status is "Superseded by ADR-0010"
  (`docs/adr/0008-harness-over-core-and-bundle-probe-from-first-build.md:L3`), ADR-0010 is
  "Accepted — supersedes ADR-0008"
  (`docs/adr/0010-harness-over-core-and-bundle-probe-reads-the-os-sandbox-report.md:L3`), and
  C-I3's observable is the one ADR-0010 § Decision fixes — the operating system's report on the
  launched pid — so the citation sent a reader to the marker RC-1 dropped. Found on the same walk
  and fixed with it: RC-1's *Changed* said ADR-0008 and QC-25 "still state the marker", true on
  2026-09-19 and false since — ADR-0010 landed that day and `docs/nfdr.md` QC-25 reads the
  sandbox report (`docs/nfdr.md:L246-L252`) — so the sentence keeps its words and gains a dated
  parenthesis, the shape RC-1's *Still unresolved* took at v8 (RN-48). RN-11 and RN-45 keep
  "ADR-0008": a note is history (RN-55). What ADR-0010 does not record is the renderer gate C-I3
  gained at v11; whether a record carries it is the Principal Architect's, raised there as the
  companion's § 2.1 *If overridden* cites it (`docs/architecture_open_issues.md` § 2.1), and C-I3
  claims no record for it. On the companion: § 1.1's CTO position gains the ground
  `docs/trail/sdd/self_answer-19.md` gave for refusing (c), re-read at its WebKit sources this
  round rather than relayed — the `mach-lookup` is a stand-in in `checkEntitlements`, and what
  passing it starts is a Networking process whose own profile allows outbound TCP and UDP unless
  `BlockNetworkAccess` is set, a flag set only under an inheritance that reached macOS in WebKit
  on 2026-08-22 — so (c) is refused for what runs behind the check, not for the service's name,
  and C-I3's host-pid probe would not see the gap. The position, (a), does not move. No part,
  seam, slice, edge, condition or place in the order moves *(re: § 4 C-I3; § 10 RC-1; the
  companion's § 2.1 and § 1.1; source: ADR-0008:L3; ADR-0010:L3, § Decision;
  `docs/nfdr.md:L243-L256`; `docs/trail/sdd/self_answer-19.md`; WebKit at
  `bb75cbc0003033ea73c42ef02370767aa52d6ba6` — `XPCServiceEntryPoint.mm:L52-L64`,
  `com.apple.WebKit.NetworkProcess.sb.in:L492-L496, L563-L568`,
  `NetworkProcessCocoa.mm:L90-L121`, `PlatformEnableCocoa.h:L1214-L1216`; WebKit commits
  `cb7daacd43` 2026-08-22 and `e0e27e741c` 2025-12-10)*.
- **RN-57:** *(CDO)* *(changed)* Two sentences of this seat's position in the companion's § 1.1
  brought to what is now true, and no lane of this document moved. The first said this seat
  reads (c) "as the CTO does, a network entitlement under another name" — the ground the CTO
  withdrew this round (RN-56), so the sentence attributed to a peer a reading the peer no longer
  holds; it now follows the corrected ground — refused for what runs behind the check — and
  states what that correction does on the design side, which is nothing: (c)'s design cost stays
  nil, and the refusal stays the owner's. The second asked the CTO to re-point § 2 row 4's
  citation, done at v11 (RN-55); it gains a dated line saying so and keeps its words, the shape
  RC-1 took this round. *Because* a companion position is the seat's own to keep true, and a
  ground a peer has corrected is not one this seat may go on citing as the peer's. Verified
  before writing that nothing upstream moved: `docs/UXD.md` v10 (Settled, `4d7b653`),
  `docs/DESIGN.md` v8 (`269bcf5`), `docs/CONTENT.md` settled (`6789e19`), `README.md:L48-L49`
  still the stack sentence this seat's position cites *(as read then; those two lines stand at
  `nozoki@a4ab8e6:README.md:L48-L49`, and the README moved at `nozoki@61748fe`; noted
  2026-09-24, RN-69)* — so § 4's CDO clause, every § 6
  observable half and UXD trace, and § 12's UXD boundary stand as v11 wrote them, and this
  seat's position, (a), does not move *(re: the companion's § 1.1, the CDO's position; source:
  RN-55; RN-56; the companion's § 1.1, the CTO's addition of run 11;
  `nozoki@a4ab8e6:README.md:L48-L49`)*.
- **RN-58:** *(CPO)* *(changed)* One dated parenthesis added to this seat's position in the
  companion's § 1.1, on its (c) bullet; no words of the position change, and no lane of this
  document moves. The bullet said (b) and (c) "fail the same product test, whatever the probe
  reports"; the CTO's corrected ground this round (RN-56) gives that clause a measured meaning
  — under (c) the page sits behind a Networking process the operating system lets connect, and
  C-I3's host-pid probe goes green without seeing it — and the parenthesis names the product
  consequence the value seat owns: `nozoki@a4ab8e6:README.md:L50-L51`, "A shell harness under `checks/` proves
  the read-only and no-network promises on every build", becomes a public claim the harness
  cannot back on a (c)-signed bundle. *Because* the position's product test was stated on one
  public surface, the entitlements file, and the correction reaches a second — the README's
  proof sentence — and a claim the tool does not keep is release-blocking under this instance's
  posture, which is a reason for refusing (c) that no technical seat is placed to give. The
  position, (a), does not move; § 12's PRD boundary does not move — the README is a public
  surface outside this document, and the PRD names no harness sentence. Verified before writing
  that nothing above this seat moved: `docs/PRD.md` v15 (Settled, last commit `7c89e19`),
  `system/projects/nozoki/agari.md` (`ee561fb`, 2026-09-01); so § 1, § 5 steps 1, 2 and 4,
  every § 6 slug, *Delivers*, *Moves toward*, fence and PRD trace stand as v11 wrote them, and
  the `read-markdown` re-check RN-54 holds back stays held back — the owner has not chosen (a).
  On the companion's § 2.1, the CTO's draft this round is in the CTO's lane and is read here
  only as correct: C-I3 now cites the record in force *(re: the companion's § 1.1, the CPO's
  position; source: RN-56; `nozoki@a4ab8e6:README.md:L50-L51`; `docs/trail/sdd/cycle-8.md` § 5.1, answer 1;
  `system/loaders/cpo.md` § *The documentation is the product*; RN-54)*.
- **RN-59:** *(CPO)* *(changed)* The owner's answer to the companion's § 1.1 — **(a), the renderer
  leaves WKWebView; no network entitlement and no mach-lookup exception, (b) and (c) refused, (d)
  and (e) not exits** (`docs/trail/sdd/cycle-9.md` § 1.1, 2026-09-23) — folded into this seat's
  lanes, in three places. § 1's read-only constraint gains the second ruling as a constraint the
  shape is re-chosen against, with the weighing itself left to § 2. § 5 step 4 gains two dated
  sentences: on E-1, that the case its "unless" clause held open (RN-51) has arrived and the slice
  is not resized by it — one bar on one artifact, the window drawn now native; on E-3, that
  `read-markdown` stays its own slice under any renderer, because step 4's test — an intermediate
  result that changes the acceptance — is met whichever engine draws, while the *content* of its
  decision is C-D3's redraw, the CTO's, and this seat re-reads the sentence once § 2 is redrawn.
  § 12's PRD boundary moves from "whichever exit the owner takes" to the exit taken, and names what
  the exit costs in product terms: a date, since every slice rests on `open-a-folder` (§ 7).
  *Because* the answer is an owner directive on settled content, and RN-54 had held the step-4
  sentences back for exactly one reason — the owner had not chosen (a) — which no longer holds.
  What does not move, and why: § 5 step 1's entries E-1 – E-11, step 2's strikes, every § 6 slug,
  *Delivers*, *Moves toward*, fence and PRD trace, because step 1 made the entries from behaviour
  and never from the boxes (RN-30) and a renderer is a box; and the PRD, at v15 — re-verified
  before writing: `docs/PRD.md` last commit `7c89e19` (2026-09-01), `system/projects/nozoki/agari.md`
  `ee561fb` (2026-09-01), neither touched since RN-58. Two things this seat owns and names as
  owed outside this document, so the fold is not read as complete: `README.md:L46-L49` ("rendering
  a TypeScript package (`nozoki-ui`) in the system WKWebView", "styled in plain CSS custom
  properties") becomes a public sentence the product no longer keeps once (a) lands, and moves
  with the README in its own change — never from here *(the README moved: `## Stack` and the
  status block now name the one bundle and one process, `nozoki-mac`, `crates/nozoki-core` and
  `crates/nozoki-bridge`, and no web engine, and they keep the `checks/` proof sentence word for
  word, `nozoki@61748fe`; the sentences this clause cites stand at
  `nozoki@a4ab8e6:README.md:L46-L49`; noted 2026-09-24, RN-67)*; and the first-release date the owner has
  been counting toward moves out by the rewrite of § 3 `surfaces`, which is the CTO's to price.
  The companion's § 1.1 is the CTO's item; this seat's position in it stands as written and the
  item leaves the companion with the CTO's fold of § 2 *(re: § 1; § 5 step 4, E-1 and E-3; § 12
  the PRD boundary; source: `docs/trail/sdd/cycle-9.md` § 1.1; `docs/PRD.md` § Dependencies /
  Integrations; `system/projects/nozoki/agari.md`; § 7; § 10 RC-2; RN-30, RN-51, RN-54, RN-58)*.
- **RN-60:** *(CTO)* *(changed)* The owner's answer to the companion's § 1.1 — **(a), the renderer
  leaves WKWebView** (`docs/trail/sdd/cycle-9.md` § 1.1, 2026-09-23) — is folded on every lane
  this seat holds, and § 2's weighing is redone from the forces rather than patched. **The
  shape:** the taken row is the *sandboxed single-process read pipeline* — one process, a Rust
  core, an AppKit shell that holds no I/O of its own, one closed C-ABI seam — and the
  capability-split shape this document held to v12 is the second row, rejected on RC-2 and on a
  fact the weighing added: a view that executes nothing has nothing for a renderer wall to
  contain, so the second process guarded a threat the new shape does not carry. Three further
  rows and one paragraph weigh what (a) left open — a Rust-native toolkit (loses on the look the
  design starts from and on the tree, `docs/DESIGN.md` § Overview, `docs/UXD.md` § 9, C-R6), an
  in-process web engine (deprecated, and a script engine inside the wall), and AppKit through
  `objc2` against AppKit in Swift (Swift taken: `unsafe` on every message send in a workspace that
  forbids it, `Cargo.toml` `[workspace.lints.rust]`; the contributor who knows AppKit knows it in
  Swift; no dependency either way). Forces 3, 4, 5 and 6 carry the rulings; force 4 records that
  the view technology moved once, before any release, at the cheapest moment the reversal could
  be paid. **The parts and seams:** `ipc-surface` and `surfaces` in `nozoki-ui` leave;
  `core-bridge` (`crates/nozoki-bridge`, the one unit holding `unsafe` and the C ABI), `mac-shell`
  and `surfaces` (`nozoki-mac`, Swift, no package dependency) and `highlighter`
  (`crates/nozoki-core`, the six grammars compiled in) arrive; SM-4 is the C ABI with
  `asset_bytes` its ninth function and a generated header, SM-8 is the shell ↔ surfaces intent
  seam, and `markdown-renderer` emits a `MarkdownDocument` — a closed set of typed nodes — and no
  HTML. **The conditions:** C-R1 (one process, no web engine of any kind), C-R6 (`Package.swift`
  declares nothing), C-R7 (from CSP and capability grant to the shell's forbidden-API scan, the
  link check and the bridge's export-set test — stated plainly as a scan and not a process
  boundary), C-I3 (the harness against SM-5; the gate's observable is `open_folder`'s call with
  the panel presented, its control a harness-owned `idle-shell` bundle, the frames re-measured on
  the first native build), C-I6 (the pin reads the exports), C-D3 (three walls: the check, the
  document as data, the decoder fed by the check alone; SVG still excluded, now because `NSImage`
  renders it as a document). **The cut's CTO fields:** S-1 – S-3 and S-6 – S-11's command halves
  and *Rests on* read the new units and checks; no slice, slug, edge or place in the order moves
  (RN-59). **Costs and risks:** TO-1, TO-4, TO-6, TO-7, TO-8 redrawn; TO-5's judgment re-read and
  kept; R-4, R-11, R-12 redrawn; R-13 (the C ABI seam) added. **§ 10 RC-3** records the re-cut
  before the redraw, and states that it moves the shape and the seams and so owes the decision log
  superseding records for ADR-0001, ADR-0002, ADR-0006 and ADR-0009 and the NFDR a re-derivation of
  every entry written against the previous shape — the Principal Architect's, surfaced in § 12 and
  written nowhere here. *Because* the answer is an owner directive on a question this seat raised,
  and § 2's bar — a shape presented with no alternative has been assumed — binds the redraw as it
  bound the first draft: the native view is chosen against three alternatives from the forces, not
  read off the ruling. **Owed outside this document, named so the fold is not read as complete:**
  the project card's `Languages:` line (`Swift` in place of `TypeScript`) and its test command
  (`swift test` in place of Vitest) — `system/projects/nozoki/project.md`, not this seat's to edit;
  `README.md:L46-L51`'s stack and proof sentences, the CPO's (RN-59) *(the README moved:
  `## Stack` and the status block now name the one bundle and one process, `nozoki-mac`,
  `crates/nozoki-core` and `crates/nozoki-bridge`, and no web engine, and they keep the `checks/`
  proof sentence word for word, `nozoki@61748fe`; the sentences this clause cites stand at
  `nozoki@a4ab8e6:README.md:L46-L51`; noted 2026-09-24, RN-68)*; `docs/DESIGN.md`'s
  realisation sentence, the CDO's, in that document's own run (RN-53); and no Swift packet exists
  in `<CORE>/doctrine/engineering/languages/` (listed 2026-09-23), so `nozoki-mac`'s frame is laid
  out by the slice that lands it *(history: the registry gained `languages/swift/` the same day,
  `kensaiapp-dev@3ab2e8553`, and the card moved at `kensaiapp-opensource@5b27023`; § 3's
  Swift-frame paragraph now rests on the packet — noted 2026-09-23, RN-66)*. The companion's
  § 1.1 leaves the file with this fold *(re: § 2
  whole; § 3 parts, units, seams, *What the system holds*; § 4 C-R1, C-R2, C-R5, C-R6, C-R7, C-I2,
  C-I3, C-I6, C-D3; § 5 step 5; § 6 S-1 – S-3, S-6 – S-11, the CTO's fields; § 9 TO-1, TO-4, TO-5,
  TO-6, TO-7, TO-8; § 10 RC-3; § 11 R-4, R-11, R-12, R-13; § 12 the SRS and downstream boundaries;
  *Open Questions*; source: `docs/trail/sdd/cycle-9.md` § 1.1 — the owner's answer and the three
  positions; `docs/trail/sdd/cycle-8.md` § 5.1; `docs/DESIGN.md` § Overview, § Typography;
  `docs/UXD.md` § 9, UX-I12; `docs/SRS.md` FR-30 – FR-32, NFR-16, C-3, C-11; `Cargo.toml`
  `[workspace.lints.rust]`; `docs/adr/README.md`; `docs/nfdr.md` § Version (v10), QC-21, QC-62;
  `<CORE>/doctrine/engineering/languages/` listing; RN-1, RN-8, RN-30, RN-53, RN-56, RN-59)*.
- **RN-61:** *(CTO)* *(changed)* Two folds from the companion, one drafted for the owner and one
  confirmed. **§ 2.3, drafted here for the owner's confirm:** § 4 C-I3's `checks/bundle.sh` reads
  the entitlements "against the set C-R2's rule admits, as the script's expected set records it"
  where it read "against C-R2's exact list" — the form `docs/nfdr.md` QC-25 took at v10 — *because*
  C-R2 has stated a rule since v12 and a delivery reader taking C-I3 at its word would fail the
  bundle that carries the folder-selector's third entitlement. The record lines move with it:
  C-R2 names ADR-0011 — Proposed, superseding ADR-0003 on acceptance — and says ADR-0003 is the
  record in force until then; C-I3 names ADR-0012 — Proposed — beside ADR-0010 for the renderer
  gate, and says its mechanism, control and observable's name are re-derived from C-I3 as it now
  reads under RC-3. Each line states the status `docs/adr/README.md` shows on 2026-09-23. **§ 2.2,
  confirmed by the owner** (`docs/trail/sdd/cycle-9.md` § 2.2): § 10 RC-2's *Observed reality*
  keeps its words and gains the dated parenthesis the item drafted — the `mach-lookup` is a
  stand-in in `checkEntitlements`, what passing it starts is a Networking process with a network
  profile of its own — pointing at RN-56 and the companion's § 1.1 for the sources rather than
  restating the WebKit citations; RN-52's matching sentence stays as written, a note being dated
  history (RN-55). Found on the same walk: RC-2's *Still unresolved* said QC-25 "still state[s]
  *exactly*", true on 2026-09-23 at the hour it was written and not since NFDR v10; it keeps its
  words and gains a dated parenthesis, and § 12's downstream boundary says the same. § 2.1 was
  drafted at v12 (RN-56) and confirmed by the owner (`cycle-9.md` § 2.1); nothing further moves
  for it, and it leaves the companion. The companion after this turn holds § 2.3 alone, its slot
  the owner's *(re: § 4 C-I3, C-R2's record line; § 10 RC-2 *Observed reality*, *Still unresolved*;
  § 12 the downstream boundary; the companion's §§ 2.1 – 2.3; source: `docs/trail/sdd/cycle-9.md`
  §§ 2.1 – 2.3; `docs/adr/README.md` rows ADR-0011, ADR-0012; `docs/nfdr.md` § Version (v10),
  QC-25; RN-52, RN-55, RN-56)*.
- **RN-62:** *(CDO)* *(changed)* The owner's (a) read through this seat's lanes against § 2 as
  the CTO redrew it; three sentences moved and no condition, observable or trace did. **§ 12's
  UXD boundary** said the UXD stands "whichever exit the owner takes" and named what "would move
  under a native renderer" — a clause written before the exit and stale once it was taken. It
  now names the exit (§ 2; § 10 RC-3; `docs/trail/sdd/cycle-9.md` § 1.1), records that every
  `UX-` entry the C-E conditions and the § 6 observable halves and UXD traces cite was re-read
  against the AppKit view and binds an observation or a token, never an engine, and lists what
  the exit does move — three sentences of `docs/DESIGN.md` (its realisation sentence, § Overview;
  the CSS font-stack syntax of § Typography and the frontmatter; RN-1's "every value here is a
  CSS value") and no token value — in that document's own run, which may trail this one
  (`<CORE>/roles/loaders/cdo_global.md` § *Output*). **C-E7's mechanism pointer** said "C-R7 and
  C-D3 make it structurally true"; C-R7 as redrawn is a source scan and a link check and says of
  itself that it is "not a process boundary: the wall is C-R2's", so the pointer now names what
  holds the condition by structure — C-R1 (every asset ships inside the bundle, fonts the
  platform's), C-R2 (no network entitlement on the one process) and C-D3 (no URL from content
  reaches a framework) — and keeps C-R7 as the scan that shows the shell adds no fetch of its
  own; the condition's words, its UXD and fence sources and its *Violated by* are unchanged.
  **S-1's observable half** excluded "a developer's dev-server window" — an artifact of the
  previous shape that the taken one cannot produce; the exclusion is now stated as the class it
  belongs to, a build launched from the toolchain outside a signed bundle, with the dev-server
  window kept as the cited instance (`docs/trail/sdd/cycle-8.md` § 5.1's sample table; RN-53).
  *Because* the observable halves, the C-E conditions and the UXD traces were made from the
  UXD's surfaces and never from the boxes, a renderer change reaches them only where a sentence
  named the box — and three did. Checked and unmoved: S-3's observable half (rendered headings,
  lists and code; the in-folder image in place; the two placeholders; the inert external link;
  the hostile document shown as text; pixel-identical offline) states what a person sees on the
  panel and holds under a TextKit view exactly as under a web one — how TextKit lays out
  UX-I12's two hard cells is the CTO's *Open Question*, and the bar it must meet is UX-I12's and
  `docs/DESIGN.md` § Components "Rendered Markdown"'s, neither of which moved; S-7's "in a
  browser" is the stranger's, reading the README; every other observable half and UXD trace
  names no engine (`grep -n -i 'wkwebview\|webview\|css\|webkit\|html' docs/SDD.md` over § 4's
  CDO clause, § 6 and § 12, 2026-09-23 — the hits outside the three sentences above are S-1's
  command half, S-3's command-half fixture list and § 12's PRD clause). Verified before
  writing that nothing above this seat moved: `docs/UXD.md` v10 (Settled, `4d7b653`),
  `docs/DESIGN.md` v8 (Settled, `269bcf5`), `docs/CONTENT.md` v6 (Settled, `6789e19`) — the
  commits RN-57 pinned. No § 10 entry from this seat: the UXD did not change upstream and no
  observable half failed as written, so neither trigger that would name this seat fired; RC-3
  is rightly the CTO's. No companion item: nothing here is the owner's to settle *(re: § 4 C-E7,
  the mechanism sentence; § 6 S-1 *Reached when*, observable half; § 12 the UXD boundary; source:
  `docs/trail/sdd/cycle-9.md` § 1.1; § 2 as redrawn, § 4 C-R1, C-R2, C-R7, C-D3, § 10 RC-3;
  `docs/UXD.md` § 9, UX-I12, UX-I15; `docs/DESIGN.md` § Overview, § Typography, § Components
  "Rendered Markdown", RN-1; `system/experience/visual_restrictions.md` § `no-runtime-remote-asset`;
  RN-53, RN-57, RN-60)*.
- **RN-63:** *(CPO)* *(changed)* This seat's lanes re-read against § 2 and § 4 C-D3 as the CTO
  redrew them under the owner's (a) (§ 10 RC-3; RN-60) — the successor work the CTO named — with
  two sentences moved and everything else left as it stands. § 5 step 4's E-3 sentence gains its
  dated close: the three walls are now the containment check, the document as data and the
  decoder fed by the check alone, the decision is still one `read-a-file` never asks (a plain or
  highlighted file crosses no content-derived path, no image and no link), so `read-markdown`'s
  sizing stands; and the layout question the redraw leaves — how TextKit lays out UX-I12's two
  hard cells (*Open Questions*, third item) — is not a second slice: it settles inside this
  slice's first build, its result changes nothing that happens next outside the slice, which is
  step 4's too-narrow test, and the bar it answers to is the UXD's and does not move with the
  form found. § 1's clause "§ 2's weighing to redo" read as work still owed once § 2 was redrawn;
  it now says the weighing is § 2's and was redone under the ruling. *Because* RN-59 held the
  E-3 re-read open until § 2 existed to read it against, and the CTO's redraw is that ground.
  What was checked and left alone, and why: § 6 S-3's *Delivers* names behaviour a TextKit view
  draws as a web one did; its fence "the raw-source switch — not built" rests on § 9 TO-5, whose
  judgment the CTO re-read under the native view and kept (TO-5's dated parenthesis); the SVG
  placeholder in the same fence is C-D3's exclusion, kept (RN-8); its PRD trace is unchanged.
  Every other § 6 slug, *Delivers*, *Moves toward*, fence and PRD trace, step 1's entries and
  step 2's strikes stand — RC-3 § *Retained* says so with RN-59, and this seat confirms it from
  its own lane. The second language § 2 takes — Swift beside Rust — reaches no product promise:
  `grep -n -i 'swift\|rust\|typescript\|appkit' docs/PRD.md` (2026-09-23) hits only the
  highlighting floor's six languages (`docs/PRD.md:L161-L163`), the `highlighter`'s grammars and
  not the product's language, and the Agari names none; so § 12's PRD boundary stands as RN-59
  wrote it. Nothing for the companion: it holds § 2.3 alone, the owner's slot, and no product
  call is open. Nothing further is owed from this seat in this run *(re: § 1; § 5 step 4, E-3;
  source: § 2 as redrawn; § 4 C-D3; § 9 TO-5; § 10 RC-3; *Open Questions*, third item;
  `docs/PRD.md` § Core Features; `system/projects/nozoki/agari.md`; RN-8, RN-59, RN-60)*.
- **RN-64:** *(CTO)* *(changed)* Two folds from the companion (`docs/trail/sdd/cycle-10.md`), one
  confirmed and one drafted for the owner. **§ 2.3, confirmed with one addition** (the owner's
  seat, 2026-09-23): the C-I3 wording and the two record lines RN-61 drafted hold, and the record
  lines drop the status word — C-R2's read "ADR-0011 — Proposed, superseding ADR-0003 on
  acceptance" and C-I3's "ADR-0012 — Proposed"; each now names its record, says its status is the
  index row's (`docs/adr/README.md`) and states none. *Because* the index moved under the draft
  before this fold — ADR-0011 reads `Accepted — supersedes ADR-0003` on 2026-09-23 and ADR-0012
  still `Proposed`, and ADR-0012 may move again under the RC-3 re-derivation
  (`docs/architecture_open_issues.md` § 2.3) — so a status word here is a copy of a row that
  changes without this document, and this companion item was the file's last: the word would
  have misstated a record with no fold left to correct it. C-R2's conditional, "until it is
  Accepted, ADR-0003 is the record in force", is true in both states and stays as written, per
  the addition. § 12's downstream boundary says the same in one sentence, and its count of the
  log — "nine records", true when written and sixteen on the index today — is corrected on the
  same walk (`docs/adr/README.md`, the table). **§ 2.4, drafted here for the owner's confirm,
  reading (a):** `folder-model`'s *Owns* gains the fill of the open `FileView` — the model calls
  `highlighter` for a text file in a floor language and `markdown-renderer` for a Markdown file,
  on the bytes `fs-reader` returned, a failed call held as the item's `failed(condition)`; its
  *Must not own* reads "I/O of any kind. Any Apple framework. Own state. Drawing" where it read
  "I/O of any kind. The Tauri runtime. Own state. Rendering"; and the units paragraph gains the
  edge — the model calls down to the two, neither imports the model. *Because* the row for
  `core-bridge` rules out the other reading: the bridge "must not own read logic — every function
  delegates and formats" and nothing "the harness could not exercise through SM-5", SM-5 is the
  model's API driven in-process with no window (§ 4 C-I3), and a parse of untrusted content
  belongs nowhere near the one unit that holds `unsafe` (§ 11 R-13) — so the value is built in
  the unit that holds it and the harness reaches it there. "Rendering" was the previous shape's
  word for what the renderer process did and never named the model's actual bar, which is
  drawing — `surfaces`' alone (§ 3, its row); "The Tauri runtime" named a runtime § 10 RC-3
  retired, and "Any Apple framework" is the boundary the units paragraph already states for
  `nozoki-core`. The model's "I/O of any kind" still holds — *as first written here:* because
  neither callee reads anything (their *Must not own*); *corrected in place on the owner's
  addition at the fold, 2026-09-23* (`docs/trail/sdd/cycle-11.md` § 2.4; RN-65): that reason does
  not hold, since `markdown-renderer` reaches `fs-reader`'s containment check over SM-7 for every
  image reference and that check resolves symlinks on disk (§ 3 `fs-reader` row), so filling a
  Markdown `FileView` does touch the filesystem; the bar holds because every filesystem touch the
  fill causes belongs to `fs-reader` — the model's own reads go through it over SM-1, the
  renderer's check through it over SM-7 — and "I/O of any kind" means I/O the model performs
  itself. What the draft leaves to others, named so the fold is not read as complete:
  `docs/nfdr.md` QC-10's import set follows by transcription on the owner's confirm — the
  Principal Architect's, and that entry says so of itself; `docs/architecture_open_issues.md`
  § 1.1's Answer already routes to this item (that companion was retired to
  `docs/trail/architecture/cycle-9.md` at NFDR v12, where § 1.1 now reads). No slice, slug, § 7
  edge or place in the order moves: S-2 and S-3 name behaviour and never a unit, and the call sits
  inside `nozoki-core`, which every slice already links (*Rests on* stood in that list as written;
  S-3's gains the model's row at the fold — RN-65). **Found on the same walk, in this seat's own
  field:** S-3's command half had `cargo test --locked -p nozoki-core --test markdown` asserting
  what `asset_bytes` returns, and § 3 places `asset_bytes` in `core-bridge`, `crates/nozoki-bridge`
  — a command that cannot reach the function it names; the assertion now runs as `cargo test
  --locked -p nozoki-bridge --test asset_bytes`, the `MarkdownDocument` assertions stay in the
  core crate, and nothing S-3 delivers or fences moves (`docs/nfdr.md` RN-22 saw it and left it
  to this run; QC-37 cites the command as the SDD states it and follows in that document's own
  run). The companion after this turn holds § 2.4
  alone, its slot the owner's; § 2.3 leaves it, consumed and on the trail *(re: § 3 `folder-model`
  row, the units paragraph's edges; § 4 C-R2 and C-I3, the record lines; § 6 S-3 *Reached when*,
  command half; § 12 the downstream
  boundary; the companion's §§ 2.3 – 2.4; source: `docs/trail/sdd/cycle-10.md` §§ 2.3, 2.4;
  `docs/adr/README.md` rows ADR-0011, ADR-0012; `docs/nfdr.md` QC-10, RN-22;
  `docs/architecture_open_issues.md` § 1.1, § 2.3 — retired to `docs/trail/architecture/cycle-9.md`
  at NFDR v12; `docs/SRS.md` FR-8, FR-30, DR-6; § 3
  `core-bridge` row, SM-5; § 4 C-I1, C-I3; § 11 R-13; RN-52, RN-56, RN-60, RN-61)*.
- **RN-65:** *(CTO)* *(changed)* The companion's § 2.4 folded — **confirmed with one addition**
  (the owner's seat, 2026-09-23; `docs/trail/sdd/cycle-11.md` § 2.4, its reasoning
  `docs/trail/sdd/self_answer-22.md` § 2.4): reading (a) stands as RN-64 drafted it, no § 3
  sentence moves, and § 3's two "drafted" marks now cite the confirm. The addition corrects
  RN-64's *because*: the model's "I/O of any kind" does not hold because "neither callee reads
  anything" — `markdown-renderer` reaches `fs-reader`'s containment check over SM-7 for every
  image reference, and that check resolves symlinks on disk (§ 3 `fs-reader` row), so filling a
  Markdown `FileView` does touch the filesystem. It holds because every filesystem touch belongs
  to `fs-reader`: the model's own reads go through it over SM-1 ("Down: a path to list or read"),
  the renderer's check through it over SM-7, and "I/O of any kind" reads as I/O the model performs
  itself. Corrected in RN-64 where it stood, dated, the way RN-64 corrected § 12's record count,
  so a reader who follows the stated reason finds no hole in it. Three consequences, each in this
  seat's field. **§ 12's downstream boundary** no longer waits on a confirm: `docs/nfdr.md` QC-10
  was transcribed at NFDR v12 (`nozoki@1dfdd86`) and already carries the corrected reason, so the
  sentence reads the confirmed state, and its pointer at the retired architecture companion
  re-aims at `docs/trail/architecture/cycle-9.md` § 1.1, where that item now reads. **S-3's
  *Rests on* gains `folder-model`** (the `FileView` fill's Markdown branch) **and `SM-5`** —
  raised by the CPO on the same walk, decided here: RN-64 held that no *Rests on* moved because
  every slice already links `nozoki-core`, but *Rests on* names what a slice *realizes*, not what
  it links, and under (a) the model's fill for a Markdown file is § 3 text no earlier slice
  realizes — S-2 fills the `FileView` with spans and shows a `.md` as plain text (its *Not in
  this slice*). The Principal PM reads this field to know which parts a seed touches, and a seed
  cut from S-3 touches the model. **S-3's command half gains one case** inside the existing
  `--test markdown` target — `select_file` on a `.md` entry, driven through SM-5 with no window,
  yields a `FileView` holding the `MarkdownDocument` and no spans — *because* the placement is now
  settled and the command that proves it can be written: before it, the target proved the
  renderer alone, and a build that made the bridge do the fill would have passed the command and
  failed the observable — the reading the item's own *If overridden* warned two architects would
  reach. No slice, slug, *Delivers*, *Moves toward*, fence, seam, § 7 edge or place in the order
  moves, and nothing S-3 is sized against changes. Nothing is left for the owner: § 2.4 is
  consumed, the companion is empty and removed — its absence is the done signal — and its last
  state is whole at `docs/trail/sdd/cycle-11.md` *(re: § 3 `folder-model` row, the units
  paragraph's edge; § 6 S-3 *Reached when* command half, *Rests on*; § 12 the downstream
  boundary; RN-64; source: `docs/trail/sdd/cycle-11.md` § 2.4; `docs/trail/sdd/self_answer-22.md`
  § 2.4; `docs/nfdr.md` QC-10, its v12 note; `docs/trail/architecture/cycle-9.md` § 1.1; § 3
  `fs-reader` row, SM-1, SM-5, SM-7; § 4 C-I3; § 6 S-2 *Not in this slice*; RN-64)*.
- **RN-66:** *(CTO)* *(changed)* The companion's two items folded, both raised from downstream by
  the PM against the built `nozoki-bridge` and `nozoki-mac` and both answered in the owner's seat
  (`docs/trail/sdd/cycle-12.md` § 5.1, § 5.2; reasoning `docs/trail/sdd/self_answer-23.md`).
  **§ 5.1, confirmed with additions — `nozoki_free` stands beside SM-4's list, not on it.** The
  contradiction was this document's own: SM-4's Down cell admitted "calls from this list and no
  other", C-R7 held the export set "inside SM-4's list" and S-1's command half read "the same two,
  and nothing else", while the same SM-4 cell and § 3's `core-bridge` row had every return "freed
  by `nozoki_free`" — no build could meet both halves, and the one on `main` met the second
  (`crates/nozoki-bridge/src/exports.rs:L61`, `tests/exports.rs:L17`). Now: SM-4's Down cell and
  its closing sentence name `nozoki_free` as the seam's one release call beside the nine, exported
  from the first build on and never staged by slice; C-R7's held set and its `v1.0.0` sentence
  read the list and `nozoki_free`, its *Violated by* reads "outside SM-4's list and
  `nozoki_free`", and it states that `nozoki_free` is no command (it never reaches the model over
  SM-5, so C-I3's "every command the build grants" does not name it, and its misuse is R-13's —
  said in C-I3's *Violated by* too) and that no second plumbing export is admitted by this fold —
  one is raised by the slice that needs it, and not before; C-I6's pin takes the same set; S-1's
  command half reads "the two, and the release call `nozoki_free`, the same three, and nothing
  else"; S-11's pin reads "SM-4's nine functions and `nozoki_free`". "All nine from `v1.0.0`"
  stays true everywhere it is said, which is why beside and not on. *Because* a release function
  is the C ABI's cost of returning owned buffers, not a capability the shell gains — it reads
  nothing and grants nothing — so it belongs to the seam's mechanics, which SM-4 states once,
  rather than to the staged list a slice earns. **§ 5.2, answered — *Kind* and where the frame
  lands hold; their grounds change.** § 3's Swift-frame paragraph rested on "no Swift packet
  exists" and on the card being owed `Swift` and `swift test`; the registry carries
  `languages/swift/` (`kensaiapp-dev@3ab2e8553`, 2026-09-23) and the card carries both
  (`kensaiapp-opensource@5b27023`). The paragraph now cites the packet's `layout.md` for
  `package`, states that the frame was laid out by hand in the slice that landed it, leaves the
  package's inner layout to the packet and `docs/nfdr.md` § 9, and reads the card's line as fact;
  RC-3's *Still unresolved* and RN-60's closing sentence keep their words and gain a dated
  parenthesis, the shape RC-1 (RN-48) and RN-55 took. **What moves downstream, raised there and
  not from here:** `docs/nfdr.md` QC-24's "inside SM-4's list" (`docs/architecture_open_issues.md`
  § 2.1) and § 9's and ADR-0016's Swift premise with `nozoki-mac`'s five departures from the packet
  (`docs/architecture_open_issues.md` § 3.4) — § 12's downstream boundary names both. No part,
  seam, slice, slug, *Delivers*, *Moves toward*, fence, § 7 edge or place in the order moves; no
  observable half moves; no PRD, SRS or UXD gap surfaced. Nothing is left for the owner: both items
  are consumed, the companion is empty and removed — its absence is the done signal — and its last
  state is whole at `docs/trail/sdd/cycle-12.md` *(re: § 3 SM-4, the Swift-frame paragraph; § 4
  C-R7, C-I3 *Violated by*, C-I6; § 6 S-1 and S-11 *Reached when*, command halves; § 10 RC-3
  *Still unresolved*; § 12 the downstream boundary; RN-60; source: `docs/trail/sdd/cycle-12.md`
  § 5.1, § 5.2; `docs/trail/sdd/self_answer-23.md` § 5.1, § 5.2; § 3 `core-bridge` row; § 11
  R-13; `crates/nozoki-bridge/src/exports.rs`, `tests/exports.rs`;
  `<CORE>/doctrine/engineering/languages/swift/layout.md`;
  `system/projects/nozoki/project.md`; `docs/architecture_open_issues.md` § 2.1, § 3.4; RN-48,
  RN-55, RN-60)*.

---

- **RN-67:** *(CPO)* *(changed)* The companion's § 5.1 folded on this seat's one sentence in it —
  the addition the owner's answer names, RN-59's `README.md:L46-L49` clause, "confirmed with one
  addition" (`docs/trail/sdd/cycle-13.md` § 5.1, 2026-09-24). The clause keeps its words and
  gains the dated parenthesis in the form RN-66 gave the card's move: the README's `## Stack` and
  status block moved at `nozoki@61748fe`, and the sentences the clause cites are pinned to
  `nozoki@a4ab8e6:README.md:L46-L49`. Re-verified before writing, not taken from the answer:
  `git show 61748fe:README.md` lines 44–50 name one bundle running as one process, `nozoki-mac`,
  `crates/nozoki-core`, `crates/nozoki-bridge` and "no web engine"; its lines 11–13 name the same
  three units; the sentence "A shell harness under `checks/` proves the read-only and no-network
  promises on every build." is byte-identical at `a4ab8e6` and `61748fe`; and lines 46–49 at
  `a4ab8e6` hold both phrases RN-59 quotes. *Because* the clause named as owed something that is
  done, and a note that records a debt records its payment in the same place, dated, never by
  rewriting the debt away — the reading RN-66 set for the card. What does not move, and why:
  RN-59's words before the parenthesis, because the fold this clause guarded against being read
  as complete was true when written and the parenthesis is how it stops being read that way now;
  § 1, § 5 steps 1, 2 and 4, every § 6 slug, *Delivers*, *Moves toward*, fence and PRD trace, and
  § 12's PRD boundary, because a README sentence catching up with the shape is not a product
  change; and the PRD, at v15, and the Agari — re-verified: `docs/PRD.md` last commit `7c89e19`
  (2026-09-01), `system/projects/nozoki/agari.md` `ee561fb` (2026-09-01), neither touched since
  RN-59. The answer's other two places — § 10 RC-3's *Still unresolved* and RN-60's *Owed outside
  this document* — and the whole of § 5.2 (four citations in RN-52 pinned to `nozoki@a4ab8e6:`)
  are the CTO's, and this seat writes none of them. Round 2, on the CDO's finding (RN-69): RN-58's
  two `README.md:L50-L51` citations — the prose and the source list — are of the class § 5.2
  pinned and the companion did not reach, and are pinned to `nozoki@a4ab8e6:` on the same ground;
  re-verified: `git show a4ab8e6:README.md` lines 50–51 hold the proof sentence RN-58 quotes,
  RN-58 was written at `6ebdc42` and `git diff --quiet 6ebdc42 a4ab8e6 -- README.md` is silent.
  No dated parenthesis: RN-58 names the sentence as a public claim, not as owed, and the claim
  stands word for word at `HEAD` (lines 49–50), so a pin dates the reading and nothing is paid
  *(re: SDD Review Notes RN-59, RN-58; source: `docs/trail/sdd/cycle-13.md` § 5.1;
  `nozoki@61748fe:README.md:L11-L13`, `:L44-L50`; `nozoki@a4ab8e6:README.md:L46-L49`, `:L50-L51`;
  RN-59, RN-60, RN-66, RN-69)*.
- **RN-68:** *(CTO)* *(changed)* The companion's § 5.1 and § 5.2 folded on this seat's ground, and
  the file removed. **§ 5.1** — the two places the owner's answer names as this seat's: § 10 RC-3's
  *Still unresolved* and RN-60's *Owed outside this document*, each keeping its words and gaining
  the dated parenthesis RN-67 gave RN-59's clause — the README's `## Stack` and status block moved
  at `nozoki@61748fe`, the sentences each clause cites pinned to `nozoki@a4ab8e6:README.md:L46-L51`.
  Re-verified before writing, not taken from the answer: `git show 61748fe:README.md` lines 44–50
  name one bundle running as one process, `nozoki-mac`, `crates/nozoki-core`,
  `crates/nozoki-bridge` and "no web engine", lines 11–13 the same three units; the sentence "A
  shell harness under `checks/` proves the read-only and no-network promises on every build." reads
  the same at `a4ab8e6` (lines 50–51) and `61748fe` (lines 49–50), wrapped differently and word for
  word the same; `nozoki@a4ab8e6:README.md:L46-L51` is the Tauri stack paragraph these clauses cite.
  **§ 5.2** — RN-52's four citations into files the tree no longer holds are pinned to
  `nozoki@a4ab8e6:`: `nozoki-ui/src/main.ts:L14-L19` and `crates/nozoki-app/src/main.rs:L17-L19` in
  the gate's prose and again in the note's source list, and `crates/nozoki-app/Entitlements.plist`
  in the source list — the fourth the owner's answer added, which the item's line-anchored grep had
  missed. Re-verified: `git ls-files nozoki-ui crates/nozoki-app | wc -l` → `0` on `main`;
  `git show a4ab8e6:nozoki-ui/src/main.ts` lines 14–19 hold `start()` calling `runStartFlow` and
  `renderRows` then `await start()`, and `a4ab8e6:crates/nozoki-app/src/main.rs` lines 17–19 hold
  `open_folder` calling `pick_folder()` — the lines the note describes; `git diff --quiet ba63b44
  a4ab8e6 -- <path>` is silent for all three, so the pinned lines are the ones run 10 read;
  `a4ab8e6` is an ancestor of `HEAD` and the last first-parent commit before `0aca57e`, the
  removal's merge, so a reader following the pin lands on `main`'s own line. *Because* a citation
  into a file that has left the tree is a claim a reader cannot check until it says when it was
  read, and a note that records a debt records its payment beside it, dated, never by rewriting
  the debt away (RN-66, RN-67). What does not move, and why: RC-3's and RN-60's words before the
  parentheses, and RN-52's claim about the gate's observable — the mechanism it measured was the
  previous renderer's, superseded at RC-3 and C-I3 as RN-60 records, and a pin dates a reading, it
  does not re-argue it; § 2, § 3, § 4, § 7, § 9, § 11 and *Open Questions*, because a README
  catching up with the shape and four citations gaining a commit change no shape, seam, condition,
  order, cost or risk; and the SRS boundary — no requirement moves. **The companion** is consumed:
  its two items are the whole of it, the trail copy stands at `docs/trail/sdd/cycle-13.md`
  (`diff docs/SDD_open_issues.md docs/trail/sdd/cycle-13.md` printed nothing before this turn's
  edits), and the file is removed, empty of items, per its own header's rule — no file is the done
  signal *(re: § 10 RC-3; SDD Review Notes RN-52, RN-60; source: `docs/trail/sdd/cycle-13.md`
  §§ 5.1, 5.2; `nozoki@61748fe:README.md:L11-L13`, `:L44-L50`; `nozoki@a4ab8e6:README.md:L46-L51`;
  `nozoki@a4ab8e6:nozoki-ui/src/main.ts:L14-L19`; `nozoki@a4ab8e6:crates/nozoki-app/src/main.rs:L17-L19`;
  `nozoki@a4ab8e6:crates/nozoki-app/Entitlements.plist`; `nozoki@0aca57e`; RN-52, RN-59, RN-60,
  RN-66, RN-67)*.
- **RN-69:** *(CDO)* *(changed)* Four citations in this seat's own notes pinned, found while
  walking the companion's fold and not raised by it. RN-53 and RN-57 each cite `README.md:L48-L49`
  twice — RN-53 for the WKWebView and plain-CSS sentence it surfaced as a public surface the CPO
  would own under (a), RN-57 for the verification that the sentence still stood — and none of
  the four says when it was read. At `HEAD` those two lines hold the bridge and the Lucide icons
  (`sed -n 48,49p README.md`), and `grep -n -i "tauri\|webview\|css\|nozoki-ui\|typescript"
  README.md` exits 1: the citations point at lines that no longer carry the claim, the class the
  companion's § 5.2 pinned in RN-52 (`docs/trail/sdd/cycle-13.md` § 5.2). All four now read
  `nozoki@a4ab8e6:README.md:L48-L49`; RN-53's surfaced-and-not-fixed clause gains the dated
  parenthesis RN-67 and RN-68 gave RN-59, RC-3 and RN-60, since it named as the CPO's a public
  sentence that has since moved, and RN-57's verification gains a shorter one saying it is a
  reading of that date. Re-verified before writing, not taken from the answer: RN-53 was written
  at `nozoki@ba63b44` and RN-57 at `nozoki@6ebdc42` (`git log -S` on each note's heading), lines
  48–49 at both hold "the system WKWebView — no browser engine bundled" and "styled in plain CSS
  custom properties", and `git diff --quiet <each> a4ab8e6 -- README.md` is silent for both —
  so the pin is the owner's own for § 5.2, the last first-parent commit before the removal's
  merge `0aca57e`, and the lines pinned are the ones each note read. *Because* the boy-scout
  rule fixes a small defect where the session finds it (`<CORE>/doctrine/governance/found_while_walking.md`
  § *The rule*, clause 1), and a citation into lines a later change rewrote is one until it
  says which commit it read — and these are this seat's own notes, so the pin is this seat's to
  write and no request to a peer. What does not move, and why: RN-53's and RN-57's words before
  the parentheses, because a pin dates a reading and does not re-argue it (RN-68); § 4's CDO
  clause, every § 6 observable half and UXD trace, and § 12's UXD boundary, because no citation in
  them names a file the tree has lost (`grep` for line-anchored paths over § 4 C-E1 – C-E10, § 6
  and § 12's UXD clause finds only these four, 2026-09-24) and the documents they bind stand at
  the commits RN-62 pinned — `docs/UXD.md` v10 (`4d7b653`), `docs/DESIGN.md` v8 (`269bcf5`),
  `docs/CONTENT.md` v6 (`6789e19`), `git log 4d7b653..HEAD` on the three printing nothing — and
  `docs/DESIGN.md:L330` still reads "realised in plain CSS custom properties", so the sentence
  § 12's UXD clause says that document's own run will move is still there to move. No § 10 entry:
  the UXD did not change upstream and no observable half failed as written. No companion item:
  nothing here is the owner's to settle. Two citations of the same class sit in peers' notes and
  are theirs to pin, requested in this seat's turn and not written here: RN-55's
  `README.md:L48-L49` (the CTO) and RN-58's `README.md:L50-L51`, twice (the CPO) — the proof
  sentence, which at `nozoki@a4ab8e6` is lines 50–51 as RN-68 records *(re: SDD Review Notes
  RN-53, RN-57; source: `nozoki@a4ab8e6:README.md:L48-L49`; `nozoki@ba63b44`; `nozoki@6ebdc42`;
  `nozoki@61748fe`; `docs/trail/sdd/cycle-13.md` § 5.2; `docs/DESIGN.md:L330`;
  `<CORE>/doctrine/governance/found_while_walking.md` § *The rule*; RN-52, RN-62, RN-67, RN-68)*.
- **RN-70:** *(CTO)* *(changed)* The companion's § 5.1 and § 5.2 folded, both raised from
  downstream by the PM on 2026-09-24 and answered by a `companion-self-answer` run, and the file
  removed. **§ 5.1** — § 4 C-I3's observable no longer reads "inside `open_folder`'s call": the
  gate fails unless the launched main process is observed parked in the Open panel's modal run,
  inside the shell's launch frames, and the clause now says why `open_folder` is not among them
  and where the frame list lives — the script's header, cited and not copied. `open-a-folder`'s
  command half moves in the same words, and § 9 TO-7's *costs* names the timed release walk
  alone, with what the gate shows instead. **§ 5.2** — the last *Open Questions* item is closed
  and removed, the way RN-48 closed the probe's hosted-runner question: C-I3's "is unmeasured"
  sentence is replaced by the two readings, the Mac's and the runner's, and by the item's own
  re-cut rule, which now binds from C-I3; RC-2's and RC-3's *Still unresolved* keep their words
  and gain the dated parenthesis (the form RN-48, RN-66 and RN-68 used), RC-2's because its
  pointer would otherwise lead a cold reader to nothing; `open-a-folder`'s "fixed by the script
  from this bundle" keeps the sentence and drops the dead pointer for a line citation. Re-verified
  before writing, not taken from the answer: `LaunchFlow.swift:L35-L37` calls `panel.chooseFolder()`
  and only then `bridge.openFolder(location:)`; `checks/renderer.sh:L51-L57` lists the five
  frames and says `nozoki_open_folder` is not among them for that reason, and `:L58-L61` records
  the Mac reading (macOS 26.6.2); `gh run view 35988399477 --json headSha,conclusion` → `37a962d`,
  `success`; its log's *Set up job* prints `Image: macos-14-arm64`, `14.8.9` and the image
  release `macos-14-arm64/20260831.0302`, and its *Renderer gate* step prints "the main process
  was observed at the Open panel, inside the shell's launch, on observation 1" and "control pid …
  was not observed at the Open panel in any of 30 observations — the expected red"; `git diff
  --stat 37a962d 153f5a1 -- checks/renderer.sh nozoki-mac checks/fixtures/idle-shell` and the
  same against `HEAD` both print nothing, so the run read the script and the shell `main` holds.
  *Because* a condition that names an observation no admitted gate can make is a bar every build
  fails as written while passing in substance, and the owner's cycle-8 floor was written for a
  page whose `open_folder` call presented the panel — in the native shell that act is the panel's
  own modal run, and C-I3 already carries the ruling as binding the shell as it bound the page
  (the self-answer's ground, `docs/trail/sdd/self_answer-25.md` § 5.1); and a question the gate's
  first runs answered is not open, while the rule it carried still binds the next image or macOS
  that reads differently. What does not move, and why: no § 10 entry — RC-3's *Still unresolved*
  recorded the native frames as open and this fold is the resolution it anticipated, not a new
  contradiction, and no command half is unmet as it now reads; § 2, § 3, § 7 and § 11, because a
  gate's observable renamed to what it measures and a measurement recorded change no shape, seam,
  order or risk; TO-7 itself, because its acceptance (the shell holds no I/O, C-R7) still holds
  and only its *costs* line was false; the *Open Questions* count in § 5 step 4 E-3's "third item"
  pointer, which keeps its ordinal with the seventh item gone; RN-52's and RN-60's history, which
  RN-55's rule leaves as written; and the SRS boundary — no requirement moves. The gate's
  uncovered half stands as before: a thread sample shows the shell is in the panel's run, not
  that the panel is on screen, which is S-1's observable half, the CDO's. **Downstream:** the same
  false sentence in NFDR QC-62 and ADR-0012 is raised at `docs/architecture_open_issues.md` § 3.2
  and is the Principal Architect's; nothing is opened there. **The companion** is consumed: its
  two items are the whole of it, the trail copy stands at `docs/trail/sdd/cycle-14.md` (`diff`
  against `docs/SDD_open_issues.md` printed nothing before this turn's edits), and the file is
  removed, empty of items, per its own header's rule — no file is the done signal *(re: § 4 C-I3;
  § 6 `open-a-folder` *Reached when*, command half; § 9 TO-7; § 10 RC-2, RC-3; *Open Questions*;
  source: `docs/trail/sdd/cycle-14.md` §§ 5.1, 5.2; `docs/trail/sdd/self_answer-25.md` §§ 5.1,
  5.2; `nozoki-mac/Sources/Shell/LaunchFlow.swift:L35-L37`; `checks/renderer.sh:L44-L61`; GitHub
  Actions run 35988399477 at `nozoki@37a962d`; `nozoki@153f5a1`; `docs/trail/sdd/cycle-8.md`
  § 5.1; `docs/architecture_open_issues.md` § 3.2; RN-48, RN-55, RN-60, RN-66, RN-68)*.
- **RN-71:** *(CTO)* *(changed)* The companion's § 5.1 folded — raised from downstream by the PM
  on 2026-09-25, answered by a `companion-self-answer` run — and the file removed. **§ 3
  `fs-reader`'s containment check** no longer reads "a canonical path, symlinks resolved and
  percent-decoding applied, is inside the granted folder or it is refused", which left open
  whether reaching the canonical form may touch a position outside the grant. It now says where
  the canonical form is taken: at every position inside the grant, with symlinks resolved; at a
  position outside it nothing is read — no `lstat`, no `realpath` — and names are compared as
  spelled, the walk re-entering the grant only on the folder's own name met from its parent
  position, as spelled or, under two conditions both read from the folder itself (not the root of
  its volume; that volume ignores letter case), in another letter case — never two names the
  volume keeps apart, and as spelled wherever the check cannot be sure. Three spellings are named
  as refused although they may lead in — more than one level out and back in another case, a
  Unicode-normalization difference, a granted folder that is the root of its volume — because
  proving otherwise takes a read outside the grant. So `back → ../<NAME>` on a case-folding
  volume re-enters the folder and ends as a cycle, and `../<NAME>/docs` is read as its target;
  the three named cases stay outside and their row's sentence stays wrong about where the link
  leads, C-D1 winning there. **§ 4 C-D1**'s *Violated by* names the canonicalizing read outside
  the grant as one of the reads it forbids, which is the ground the § 3 definition rests on.
  **§ 9 TO-6**'s *costs* keeps "right about … Unicode normalization" and says what *right* means
  outside the grant — refused, never taken for inside. **§ 11 R-10**'s response describes the
  check as § 3 does and says it moves with § 3, so the two cannot drift again. Re-verified before
  writing, not taken from the answer: `crates/nozoki-core/src/fs_reader.rs:L170-L177` documents
  the walk as one lexical position, "nothing is touched" while it lies outside the root, `lstat`
  only on a name whose position lies inside — the reader already meets the definition on every
  spelling but the one re-entry spelling the answer adds; `docs/nfdr.md:L130-L134` QC-6 states
  the check in the old words ("on the canonical path, symlinks resolved and after decoding") with
  SM-7's one-implementation clause; SM-7 (§ 3, the seams) is unchanged — one implementation, two
  callers. *Because* the SDD defined the check on a canonical form it did not say how to reach,
  and the one way to reach it for a path outside the grant is a read C-D1 and `docs/nfdr.md`
  QC-35 forbid, so the two settled statements disagreed on exactly one spelling and the fold picks
  the reading under which both hold (the self-answer's ground, `docs/trail/sdd/self_answer-26.md`
  § 5.1); and a definition that names its own refused cases is one a fixture can be written
  against, where "canonical" alone was not. What does not move, and why: § 2, § 7 and the cut,
  because a check's reach redrawn inside one part changes no shape, seam, order or slice; SM-7,
  because one implementation serving two callers is still the whole of it; § 4 C-D3, because
  "passes `fs-reader`'s containment check before any open" is true of the check as now defined;
  no § 10 entry, because no command half is unmet as written and the SRS did not move; the SRS
  boundary, because FR-32 and NFR-16 ask for containment and neither says how the form is
  reached. What a link row *says* in the three refused cases is the CDO's ground (§ 4 C-E4, the
  observable halves) and is raised to that seat in this run, not written here. **Downstream:**
  `docs/nfdr.md` QC-6 is owed re-derivation from § 3 as it now reads, by the NFDR's own rule for
  an input moving beneath it, and is the Principal Architect's; no item is opened at
  `docs/architecture_open_issues.md`, per the self-answer's reasoning that there was nothing to
  re-derive until the fold landed. **The companion** is consumed: its one item is the whole of
  it, the trail copy stands at `docs/trail/sdd/cycle-15.md` (`diff` against
  `docs/SDD_open_issues.md` printed nothing before this turn's edits), and the file is removed,
  empty of items, per its own header's rule — no file is the done signal *(re: § 3 `fs-reader`;
  § 4 C-D1; § 9 TO-6; § 11 R-10; source: `docs/trail/sdd/cycle-15.md` § 5.1;
  `docs/trail/sdd/self_answer-26.md` § 5.1; `crates/nozoki-core/src/fs_reader.rs:L170-L177`;
  `docs/nfdr.md:L130-L134`, QC-35 at `:L579-L580`; `docs/fdr.md` R-34, R-151, R-152; SRS FR-32,
  NFR-16; UXD UX-I4; RN-70)*.
- **RN-72:** *(CDO)* *(changed)* § 4 C-E4 now says what a link row or an image's placeholder
  carries for a path the containment check refuses, the three refused-though-inward spellings
  § 3 `fs-reader` names among them: the refusal is a thing the tool observed — the spelled path
  left the grant, no accepted spelling brought it back, nothing was read past that point — so the
  row carries `docs/CONTENT.md`'s one outside sentence (§ *Message patterns* → *Partial*), wrong
  about where the link leads in those three cases by the owner's call, and no observable half in
  § 6 separates them from a true outside. *Because* the CTO's fold (RN-71) raised to this seat
  whether any observable half or experience condition states what the row *says* there, and none
  did: § 6 `open-a-folder`'s observable half binds "marked with what the tool observed" (UXD
  UX-S2 Error), `read-markdown`'s binds "a placeholder … saying that content outside the folder is
  not fetched" (UX-I12), and C-E4 bound "never a cause the tool did not observe" — and a builder
  holding those beside § 3's "refused as outside although they may lead in" could read the outside
  sentence as an inferred cause and write a fourth sentence the catalogue does not carry. The
  clause closes that reading in the one place every slice inherits, and adds it to *Violated
  by*. What this seat did not do, and why: no edit to `open-a-folder`'s or `read-markdown`'s
  observable half — "what the tool observed" and "outside the folder" are each stated on the
  check's verdict, not on the volume's truth, and stay true as written; no companion item — the
  owner settled the sentence's being wrong there at the same trail item and C-D1 winning is not a
  two-position disagreement; no wording written — the sentence is `docs/CONTENT.md`'s, and UX-I4
  ("the view never lies") is not reopened here: a gap in the UXD found in this run is that seat's
  in another run (§ 12), and the owner's answer already holds the tension. *Traces to* unchanged:
  no slice gains a UXD section. *(re: § 4 C-E4; § 6 S-1 and S-3 *Reached when*, observable
  halves — read, unchanged; source: `docs/trail/sdd/cycle-15.md` § 5.1; § 3 `fs-reader`; § 4
  C-D1; `docs/CONTENT.md` § *Message patterns* → *Partial*, § *Terminology* "link";
  `docs/UXD.md` UX-S2 Error, UX-I4, UX-I12; `docs/fdr.md` R-34, R-152; RN-71)*.
- **RN-73:** *(CPO)* *(changed)* The companion's § 5.1 folded on this seat's two fields — raised
  from downstream by the PM on 2026-09-30, answered in the owner's seat by a
  `companion-self-answer` run (`docs/trail/sdd/cycle-16.md` § 5.1; reasoning
  `docs/trail/sdd/self_answer-27.md` § 5.1): `open-a-folder` holds `docs/DESIGN.md` § *Layout* and
  § *Components* for the surfaces it draws, and no later slice is named. **§ 6 S-1 *Traces to*,
  the PRD clause** gains `docs/PRD.md` § UX Notes "The character" — "The reading panel is the
  dominant visual surface; navigation is text-first, icons secondary" (`docs/PRD.md:L198-L199`) —
  *because* the bar the CDO's half now holds makes a claim the PRD carries, in a section the
  trace did not name: the window's minimum width is the number the panel's dominance resolves to
  (`docs/DESIGN.md:L504`; its RN-8 at `:L922`, `:L927`), and the startup surface's routes as text
  alone are that clause's "text-first" on the one surface this slice draws before a folder is
  chosen. A bar holding a PRD claim under a trace that does not name it is a gap for the reader
  this field is written for — the one who cuts seeds from § 6 and carries *Traces to* narrowed to
  a seed's share (§ 8). The PRD carries no clause for the status messages' glyphs or their
  placement, and none is owed: § Assumptions leaves "layout measurements and visual styling
  specifics" downstream and names what it keeps — "the reading panel dominant, text-first
  navigation, two themes" (`docs/PRD.md:L371-L374`) — so no PRD gap, and no companion item.
  **§ 5 step 4, E-1's sizing** gains one dated re-read: the sizing stands under the widened bar —
  one bar on one artifact, the drawing inside "the window drawn" and not a second decision; not
  too broad, since the values are `docs/DESIGN.md`'s and nothing found while drawing changes the
  acceptance; and no slice is added, since none in § 6 has a surface's drawing as its decision and
  `choose-a-theme`'s is own state (E-6). Re-verified before writing, not taken from the answer:
  `docs/DESIGN.md` at `nozoki@705e6f1` (v13) holds § *Layout* at `:L491` with the 720 minimum at
  `:L504`, § *Components* "Status messages" left-aligned at the top and "never centred" at
  `:L716`, and "The startup surface" with its routes as text at `:L725-L729` — the self-answer's
  line numbers (`:L487-L489`, `:L695-L705`, `:L914`) are DESIGN v10's and have moved, which is
  one more reason the bar cites sections and never lines; `docs/PRD.md` last moved at `7c89e19`
  (2026-09-01, v15) and `system/projects/nozoki/agari.md` at `ee561fb` (2026-09-01), neither
  since RN-67. What does not move, and why: S-1's *Slug*, *Delivers*, *Moves toward* and *Not in
  this slice* — the answer keeps every fence (RN-37), and how the window is drawn is not a thing a
  person can newly do; S-6's *Not in this slice* — "any token value — `docs/DESIGN.md`'s" is still
  true; § 1, § 5 steps 1 and 2, and § 12's PRD boundary — the PRD is unchanged and carries the
  claim. The observable-half sentence itself is the CDO's (§ 6 *Reached when*, observable) and is
  named to that seat in this run, not written here; the companion's removal follows that fold,
  the last the item needs, and the trail copy stands at `docs/trail/sdd/cycle-16.md` (`diff`
  against `docs/SDD_open_issues.md` printed nothing before this turn's edits). Header `Version:`
  untouched — the runner stamps it
  (`skills/product-sdd-runner/.claude/skills/product-sdd/SKILL.md:L3`) *(re: § 5 step 4 E-1; § 6
  `open-a-folder` *Traces to*, PRD clause; source: `docs/trail/sdd/cycle-16.md` § 5.1;
  `docs/trail/sdd/self_answer-27.md` § 5.1; `docs/PRD.md:L198-L199`, `:L371-L374`;
  `docs/DESIGN.md:L491`, `:L504`, `:L716`, `:L725-L729`, `:L922`, `:L927`; RN-37, RN-67)*.
- **RN-74:** *(CTO)* *(changed)* The companion's § 5.1 read against this seat's lanes
  (`docs/trail/sdd/cycle-16.md` § 5.1; the CPO's fold is RN-73). One field moves: **§ 6 S-1
  *Reached when*, the command half** gains, under `swift test --package-path nozoki-mac`, a test
  that the window declares a minimum content width and the sidebar a fixed width, each the value
  `docs/DESIGN.md` § *Layout* states — *because* the observable half now holds that section (the
  CDO's fold, this run), and the two halves check one slice from two sides: a bar a person can
  see and no script holds is the gap the item came from. The window as sealed opens at 480 and
  declares no minimum (`nozoki-mac/Sources/Shell/WindowPresenting.swift:L21`, and `grep -n -i
  'minSize\|contentMinSize\|minimum'` on that file exits 1, at `nozoki@705e6f1`), passed every
  command S-1 stated, and was found by the PM reading the tree. The two widths are the part of the
  drawing a test holds cheaply: the shell's test target already builds a window
  (`nozoki-mac/Tests/ShellTests/LaunchWindowWorkbenchTests.swift:L314`), and the sidebar's width is
  already the code's copy of DESIGN's token (`nozoki-mac/Sources/Surfaces/WorkbenchView.swift:L13-L14`).
  The status messages' placement and glyphs and the routes' form stay the observable half's
  alone — a person's eye is the truer check there, and no script is invented for them. No value
  is restated: the test carries the number as the code does, and this document cites the section,
  so a DESIGN revision moves the code and the test and nothing here. What does not move, and
  why: S-1 *Rests on* — `mac-shell` already owns "the one window" and `surfaces` the drawing
  (§ 3, both rows), and C-R1 already puts the glyphs in the bundle; § 3 — which part draws is
  unchanged, only which slice's bar holds the drawing; § 5 steps 3 and 5 and § 7 — no slice is
  added and no pair changes, S-1 first as before; § 9 and § 11 — no cost is taken and no trigger
  is named, the values being `docs/DESIGN.md`'s and owner-confirmed there (its RN-8 — "Every
  measurement confirmed by the owner", `docs/DESIGN.md:L929`);
  § 12, the SRS boundary — the SRS carries the dominant panel and text-first navigation at
  § 5.1 *User Interface* (`docs/SRS.md:L394-L397`) as an interface statement traced to the PRD, not
  as a numbered requirement, so S-1's SRS clause gains no tag and no SRS gap opens; *Open
  Questions* — nothing resolves downstream. `grep -n -i '720\|minimum width' docs/nfdr.md
  docs/adr/*.md` finds nothing: no record binds the layout, and none is surfaced — a layout value
  is DESIGN's, not an architecturally-significant decision. Header `Version:` untouched — the
  runner stamps it *(re: § 6 `open-a-folder` *Reached when*, command half; source:
  `docs/trail/sdd/cycle-16.md` § 5.1; `docs/trail/sdd/self_answer-27.md` § 5.1; `docs/DESIGN.md`
  § *Layout*; `docs/SRS.md:L394-L397`; § 3 `mac-shell`, `surfaces`; § 4 C-R1; RN-73)*.
- **RN-75:** *(CDO)* *(changed)* The companion's § 5.1 folded on this seat's lane — the item's
  answer, given in the owner's seat (`docs/trail/sdd/cycle-16.md` § 5.1; reasoning
  `docs/trail/sdd/self_answer-27.md` § 5.1), lands here. **§ 6 S-1 *Reached when*, the
  observable half** gains the sentence the answer asks for: the window this slice draws holds
  `docs/DESIGN.md` § *Layout* and § *Components* for the surfaces it draws — the window's
  minimum width as the window's own, held by `mac-shell`, and the sidebar's width as the
  surface's, with the panel wider than the sidebar in the first window a stranger sees; every
  status message this slice shows top-left, glyph-led and never centred, the reading panel's
  prompt counted among them as the answer names it; and the startup surface's two routes as
  text alone, one to a row. Cited by section and never by value, as `choose-a-theme` cites
  § *Colors*, and never by line: the answer's line numbers were DESIGN v10's and had moved by
  v13 (RN-73), which is the case the rule exists for. *Because* the bar was one a person could
  see unmet and no half of § 6 held: re-read at `nozoki@705e6f1`, the sealed window opens 480
  wide and declares no minimum (`nozoki-mac/Sources/Shell/WindowPresenting.swift:L21`, `:L44-L47`),
  beside a sidebar held at 260 (`nozoki-mac/Sources/Surfaces/WorkbenchView.swift:L14`,
  `:L32-L34`) — a panel narrower than the sidebar under a trace to "the sidebar beside a dominant
  reading panel" (`docs/UXD.md` § 4); the tree's root line is centred
  (`nozoki-mac/Sources/Surfaces/RootItemsView.swift:L69-L72`); the startup routes are two
  `NSButton`s and no glyph is drawn on that surface
  (`nozoki-mac/Sources/Surfaces/StartupView.swift:L65-L70`; `grep -n -i 'NSImage\|symbol'` on
  it exits 1); and the reading panel's prompt is top-left at the inset but carries no glyph
  (`WorkbenchView.swift:L46-L53`, which cites DESIGN's RN-14 itself). Each is a departure from
  `docs/DESIGN.md` § *Layout* (`:L491-L532`) or § *Components* "Status messages" / "The startup
  surface" (`:L716-L741`) as v13 states them. The sentence is sourced, not invented: every
  observation it binds is a section of the settled design language, and the glyphs it needs
  ship — `info.svg` and `circle-alert.svg` are in `third_party/lucide/icons/` and the shell
  already draws from the bundle through `GlyphSource` (`nozoki-mac/Sources/Shell/GlyphSource.swift:L1-L18`),
  so C-E7 is met and no UXD gap opens. **§ 6 S-1 *Traces to*, the UXD clause** gains
  `docs/UXD.md` § 9 *Design-System Direction* — "the reading panel is the dominant visual
  surface, navigation is text-first with icons secondary" (`docs/UXD.md:L395-L397`) — the UXD
  clause the widened bar realizes on the first window, which the trace named only through § 4's
  "dominant reading panel"; the CPO's RN-73 makes the same move for the PRD clause. What does not
  move, and why: § 4's CDO clause — it still fixes no token value, and the new sentence fixes
  none either; § 12's UXD boundary — "this document cites the delegate and fixes nothing of its
  own" is the sentence applied; § 5 step 1's observability — E-1 was observable before and is
  no more or less so now; every other observable half — none draws a surface this sentence
  binds before S-1 does, and `choose-a-theme`'s bar is the two themes over surfaces already
  drawn (E-6), so how a surface is drawn stays S-1's and no sentence is added there; S-6's UXD
  trace; no § 10 entry — no *Reached when* failed as written, the bar is being stated for the
  first time. No companion item: the item's two options are both defensible and the owner's seat
  chose between them on the record, so there is no two-position disagreement left to carry.
  **The companion is removed**, empty of unfolded items: `diff docs/SDD_open_issues.md
  docs/trail/sdd/cycle-16.md` printed nothing before the removal, so the trail copy is the file
  whole. One thing the self-answer opened beside the SDD and this seat owns in another run:
  `docs/DESIGN_open_issues.md` § 2.1 (CSS-over-markup) — folded by DESIGN v11 (`nozoki@cce8bde`)
  and the companion gone at v13 (`ls docs/DESIGN_open_issues.md` fails at `705e6f1`), so nothing
  is owed there. Header `Version:` untouched — the runner stamps it *(re: § 6 `open-a-folder`
  *Reached when*, observable half; *Traces to*, UXD clause; source: `docs/trail/sdd/cycle-16.md`
  § 5.1; `docs/trail/sdd/self_answer-27.md` § 5.1; `docs/DESIGN.md` § *Layout*, § *Components*
  "Status messages", "The startup surface", RN-8, RN-14; `docs/UXD.md` § 4, § 9, UX-A4, UX-S1,
  UX-S2, UX-S4; § 4 C-E4, C-E7; § 3 `mac-shell`, `surfaces`; RN-37, RN-73, RN-74)*.
- **RN-76:** *(CTO)* *(changed)* The companion's §§ 5.1, 5.2 and 2.1 folded, all three on this
  seat's ground, and the companion emptied of items. §§ 5.1 and 5.2 were raised from downstream by
  the PM on 2026-10-01 and answered in the owner's seat by a `companion-self-answer` run; § 2.1 was
  raised by that same run with its slot left at the placeholder, and is settled here by this seat.
  **§ 5.1, the export** — three sentences move as the answer words them, and a fourth that
  restated one of them moves with it. § 4 C-R7's "exactly the functions its landed slices built"
  reads *its landed changes built*; C-R7's "a function whose slice has not landed is never
  exported" reads *a function no landed change has built is never exported*; § 3 SM-4's "exported
  from the build in which a slice lands it and not before" reads *from the build in which a change
  of its slice first builds it, and not before*; and SM-4's owner cell, which said "it exports what
  its landed slices built", reads *its landed changes built* — the answer did not list that cell,
  and it is C-R7's first sentence said again, so leaving it would have the seam and the condition
  disagree. C-R7 also gains what *built* means at that grain — the bridge function exists and
  delegates to an operation `folder-model`'s API carries — and the reason the grain is the change,
  both from the answer. *Because* a slice yields one or more seeds and each share is "worth
  something on its own" (§ 8, the *Delivers* row), and no share of `read-a-file` shows a file in
  the panel without the shell calling `select_file` across SM-4, so an export that waited for the
  slice whole would make every share but the last a fragment. **§ 5.1, the harness** — § 4 C-I3's
  headline and its `read-only.sh` sentence stand, and its *Violated by* reads *a build that
  exports a command the harness does not exercise* where it read "a slice that lands a command
  the harness does not exercise", so the clause names the unit the headline names. C-I3 gains one
  sentence saying the unit is the build and no test of a slice's own stands in for
  `read-only.sh`, and one naming the two things the answer says it does not cover: nothing in the
  build compares the walk's calls with the export set, so that match is held by review, and a
  fixture with no entry for a command exercises nothing for it. This seat does not ask for the
  comparing check here: the answer left that to the fold, a new check on every build is a
  widening no item raised, and the limit is stated beside the claim so a reader does not take
  "every command the build grants" for a thing a script holds. **What the product shows today,
  recorded here and in no condition:** on `main` at `nozoki@7c7038f`,
  `crates/nozoki-bridge/tests/exports.rs:L17-L22` admits `nozoki_select_file` and
  `crates/nozoki-core/tests/walk.rs:L1-L6` calls `list_tree` alone, so C-I3 is unmet on that
  build as it reads, and the walk driving `select_file` closes it. The answer keeps that interval
  out of § 4, and so does this fold. **§ 5.2** — § 3 stands: the open file, the selection and the
  expansion are `folder-model`'s. § 6 `follow-the-folder`'s *Rests on* gains one clause on its
  `folder-model` entry, naming the held state beside the reducer — the tree's expansion, the
  selection, and the open `FileView` with its reading position — and saying the model holds it
  from that slice at the latest. *Because* that slice's command half asserts in `nozoki-core`,
  with no window, "expansion, selection and reading position surviving", which a core test can
  assert only of state the core holds; and as the field read, a seed cut from the slice would take
  that state as already in the model, where the product keeps it in the shell
  (`crates/nozoki-core/src/folder_model.rs:L13-L15`, `:L99-L101`;
  `nozoki-mac/Sources/Surfaces/WorkbenchView.swift:L78-L93`;
  `nozoki-mac/Sources/Surfaces/RootItemsView.swift:L55-L57`, all at `nozoki@7c7038f`). The clause
  adds no bar: the command half is unchanged and already forces the move. One case the answer
  leaves to the change that moves the state, and this document does not write: which side orders
  two reads in flight once the model holds the selection. It is one change's design against SM-8
  and the `surfaces` row as they stand, which § 12's downstream boundary keeps out of here.
  **§ 2.1** — five citations and one count in this seat's lanes pointed at lines that had moved.
  § 4 C-I3's `LaunchFlow.swift:L35-L37` now names `chooseFolder()` and `openAndList(_:through:)`
  at `:L54-L60` and `:L69`; C-I3's three `checks/renderer.sh` citations and
  `open-a-folder`'s one now name the header's § *THE FRAMES*, with the list at `:L53-L56` and the
  Mac reading at `:L57-L60`; each carries the commit it was read at, `nozoki@7c7038f`, and the
  section or function name, so the next edit to either file leaves a locator that still opens.
  C-I3's "five-frame list" now says the list held five frames when run 35988399477 matched it and
  holds four since `nozoki@b75348f`, and adds the later reading: run 36795836747 matched the
  four-frame list on the same image. § 10 RC-3's dated parenthesis of 2026-09-24 keeps its words,
  gains the commit its citation was read at (`nozoki@153f5a1`), and gains a second dated
  parenthesis for the four frames — the item listed six places and this is a seventh of the same
  class, found while folding them. *Because* a locator opens on the sentence it is cited for
  (`system/doctrine/writing_bar.md` § 1.2, in the instance), and a count a reader checks against
  the script has to match it. **Why this seat settled § 2.1 with its slot unfilled:** the repair
  changes no shape, seam, condition, order or bar and nothing the product promises, so it is this
  seat's call and not the owner's (RN-19's routing rule); the CPO read it the same way in this
  run and found no product intent in it. The item stands whole, slot unfilled, in the trail copy.
  Re-verified before writing, not taken from the item: `sed -n 53,60p checks/renderer.sh` prints
  the four frames and the Mac reading's "then the four frames above"; `git show b75348f --
  checks/renderer.sh` removes `LaunchFlow.run()` from the header and from `FRAME_LIST`; `git show
  153f5a1:checks/renderer.sh` holds five frames at lines 53–57 and the Mac reading at 58–61;
  `gh run view 36795836747 --json headSha,conclusion` → `702f7c4`, `success`, its log's *Set up
  job* prints `Image: macos-14-arm64`, `Version: 20260831.0302.1` and `14.8.9`, and its *Renderer
  gate* step prints "observed at the Open panel, inside the shell's launch, on observation 1" and
  the control "not observed at the Open panel in any of 30 observations"; `git diff --stat
  702f7c4 HEAD -- checks/renderer.sh checks/fixtures/idle-shell` prints nothing; `git diff --stat
  fcb7910 HEAD -- checks crates nozoki-mac` prints nothing, so the tree the answers were written
  against is the tree at `7c7038f`. What does not move, and why: § 2, § 7, § 9 and § 11 — an
  export's grain restated, a held state named on one field and citations re-pointed change no
  shape, order, cost or risk, and `follow-the-folder` gains no slice to rest on; § 3's
  `folder-model` and `surfaces` rows and *What the system holds* — the answer rests on them as
  written; `read-a-file`'s *Rests on* — it realizes the value `select_file` answers, not the model
  holding it; C-R7's set equality, the closed list, `nozoki_free` beside it, "all nine from
  `v1.0.0`" and its uncovered case before `v1.0.0`; § 6 S-2's and S-7's command halves, which read
  the same under the change grain; RN-70's own citations, which name the commits they were read
  at, a note being history (RN-55); no § 10 entry — no command half is unmet as written and the
  SRS did not move; the SRS boundary — no requirement moves; *Open Questions* — this fold adds
  nothing there, and the one item this run does add is RN-77's. **Downstream, the Principal
  Architect's, nothing opened by this seat:** `docs/nfdr.md` QC-24 ("before a slice lands it",
  `:L364-L365`) follows C-R7 and is already raised at `docs/architecture_open_issues.md` § 3.1,
  whose QC-2 half proposes an interim clause this fold does not take for C-I3; and the "five-frame"
  wording, beside a `checks/renderer.sh:L58-L61` citation with no commit, stands at
  `docs/nfdr.md:L468-L470` and
  `docs/adr/0012-renderer-run-proved-on-the-shipped-bundle-beside-the-wall.md:L120-L122`, each
  reading run 35988399477 — whether and how either moves is that seat's. **The companion:** its three items are the whole of
  it, the trail copy stands at `docs/trail/sdd/cycle-17.md` (`diff docs/SDD_open_issues.md
  docs/trail/sdd/cycle-17.md` printed nothing before this turn's edits), and the file now lists no
  item; the runner retires a companion that stands empty at the seats' close. Header `Version:`
  untouched — the runner stamps it *(re: § 3 SM-4; § 4 C-R7, C-I3; § 6 `open-a-folder` *Reached
  when*, command half; § 6 `follow-the-folder` *Rests on*; § 10 RC-3; source:
  `docs/trail/sdd/cycle-17.md` §§ 2.1, 5.1, 5.2; `docs/trail/sdd/self_answer-28.md`; § 8;
  `nozoki@7c7038f`, `nozoki@b75348f`, `nozoki@153f5a1`, `nozoki@37a962d`, `nozoki@702f7c4`; GitHub
  Actions runs 35988399477 and 36795836747; `docs/architecture_open_issues.md` § 3.1; RN-19,
  RN-55, RN-66, RN-68, RN-69, RN-70)*.
- **RN-77:** *(CTO)* *(added)* *Open Questions* gains a seventh item, and § 6
  `follow-the-folder`'s *Rests on* points at it: how a collapsed tree node and a scroll of the
  reading panel reach `folder-model`. The CDO found the gap in this run, reading RN-76's clause
  against its own halves. The finding holds on this document's own text. § 3 gives the model the
  tree's expansion and the open `FileView`'s reading position, as `docs/SRS.md` DR-2 and DR-3
  require (`:L427-L432`). SM-4 says of its nine calls "Nothing else crosses in either direction",
  SM-5 carries "the operations the functions name", and SM-8's intents are "named after SM-4's
  functions and nothing else". No call on the list is named for a collapse or a scroll, and the
  two calls built so far that could carry one take a path alone
  (`crates/nozoki-bridge/src/exports.rs:L72`, `:L89`, at `nozoki@7c7038f`). So a model that is
  authoritative for a place it was never told sends a delta that, drawn faithfully, re-expands a
  node the reader collapsed or moves the panel — the jump § 4 C-E2 and `follow-the-folder`'s
  observable half forbid — and `--test watch` has no operation to set a reading position with.
  The answer RN-76 folded named one uncovered case, two reads in flight, and not this one
  (`docs/trail/sdd/cycle-17.md` § 5.2). **Why it is an open question and not a decision made
  here:** three forms are open and they do not cost the same. An argument on a call the list
  already names moves no list. Keeping the disclosure state and the scroll offset where AppKit
  keeps them leaves the slice's command half unmet as written, which is the re-cut the answer's
  own reasoning reserves for the owner (`docs/trail/sdd/self_answer-28.md` § 5.2, *What was
  close*). A call the list does not name moves SM-4, C-R7's set and C-I6's nine. Choosing between
  them takes a build that keeps the place under churn, and no such build exists: the product
  keeps all of this state in the shell today (RN-76). A form picked here would be a guess written
  as a seam. So the item states the three forms, which of them are re-cuts, and that a re-cut is
  recorded in § 10 before it is built. **Why it differs from the two-reads case RN-76 leaves to a
  change:** ordering two reads needs nothing new to cross SM-4, so it is one change's design
  inside the seams as drawn; a collapse and a scroll may need a crossing the closed list does not
  have, and the list is this document's. **Not a companion item:** no form changes what the
  product promises or shows — FR-27 and UX-I3 hold under each — and no two seats hold different
  positions; the CDO asked for no mechanism and said its half reads the same under any. The
  sidebar mode is not in the item: no SM-4 call carries a mode, § 3 does not give it to the model,
  and the CDO's half holds it. What does not move, and why: § 3's rows, SM-4's list and S-5's
  *Reached when* — the question is recorded and nothing is redrawn; § 5 step 4's sizing of E-5 —
  no bar moved, which is the condition the CPO set for re-reading it; § 7 — no edge changes;
  § 11 R-6 — its trigger and response stand, and the item names the case its response does not
  reach; no § 10 entry — no command half has been tried and found unmet. Header `Version:`
  untouched — the runner stamps it *(re: *Open Questions*; § 6 `follow-the-folder` *Rests on*;
  source: § 3 `folder-model`, SM-4, SM-5, SM-8, *What the system holds*; § 4 C-E2, C-R7, C-I6;
  `docs/SRS.md` DR-2, DR-3, FR-27; `docs/UXD.md` UX-I3; `docs/trail/sdd/cycle-17.md` § 5.2;
  `docs/trail/sdd/self_answer-28.md` § 5.2; `crates/nozoki-bridge/src/exports.rs:L72`, `:L89`;
  RN-76)*.
- **RN-78:** *(CDO)* *(changed)* § 6 `follow-the-folder`'s observable half now says what the
  person sets up before the script runs, and § 4 C-E2's *Violated by* names one more case. The
  half read "with Nozoki open on a folder, they run a script", then "the nodes they had expanded
  stay expanded" and "the panel's scroll position does not jump". Followed as written, it could
  be met by someone who collapsed no node and never scrolled, and for that person two failures
  show nothing: a panel reset to the top of a file already at its top, and a collapsed node
  re-opened where none was collapsed. Those are the two failures RN-77's open question names — a
  model that was never told of a collapse or a scroll, drawn faithfully. So the half now has them
  expand some nodes, collapse one again, open a file longer than the panel and scroll partway
  down it, and adds that the collapsed node stays collapsed and the panel does not return to the
  top. C-E2's *Violated by* read "a refresh that collapses a node or resets a scroll position"
  and now also names a refresh that re-opens a node the reader collapsed. *Because* an observable
  half is checked by someone who did not build the slice, and a bar they can pass without doing
  the thing it protects is not a bar. The source is the UXD as it stands and nothing above it:
  "expanded tree nodes, the open file, the sidebar mode and the reading position survive every
  refresh; only what actually changed changes" (`docs/UXD.md` UX-I3), and a node re-opened with
  no change on disk is a change that did not happen. No experience moves and no UXD gap is
  opened (§ 12, the UXD boundary). The half holds under each of the three forms RN-77's item
  lists, so it picks none. What does not move, and why: C-E2's headline sentence — it already
  binds both cases, and only its examples grew; the command half, *Rests on* and *Open
  Questions* — the CTO's, and the item's closing sentence about C-E2 still reads true; the UXD
  clause of *Traces to* on both slices — UX-I3, UX-F2 and UX-F3 were already cited. **One more
  half of the same shape, repaired with it:** § 6 `see-git-status` read "They switch back to
  Files: the open file and their reading position are untouched", which a file never scrolled
  passes whatever the switch does. It now has them scroll partway down before switching back, and
  says the panel has not returned to the top; the source is UX-F2's own sentence, "the open file
  and their reading position are untouched throughout". The other nine observable halves were
  searched for a reading position, a scroll or an expansion and hold none (`grep -n "reading
  position\|scroll\|expanded" docs/SDD.md` over § 6 hits only these two slices' halves and
  `follow-the-folder`'s own fields). The sizing of the two slices is the CPO's to say (§ 5
  step 4): this seat reads each as the same one decision as before, and has asked the CPO to
  confirm it in this run *(re: § 6 `follow-the-folder` and `see-git-status` *Reached when*,
  observable half; § 4 C-E2 *Violated by*; source: `docs/UXD.md` UX-I3, UX-F2, UX-F3;
  `docs/SRS.md` FR-27; *Open Questions*, the collapse-and-scroll item; RN-77)*.
- **RN-79:** *(CPO)* *(added)* § 5 step 4 gains one dated re-read on E-4 and one on E-5, each
  saying the sizing stands. The CDO sharpened the observable halves of `see-git-status` and
  `follow-the-folder` in this run (RN-78) and asked this seat to confirm the sizing against them.
  The size follows the bar (§ 5 step 4), so a bar that moved is re-read, and RN-77's "no bar
  moved" was written before RN-78's edits. **`see-git-status`:** the half has the reader scroll
  before switching back to Files. The sentence it sharpens was already in the bar, and it asks
  nothing of the root finding, the slice's one decision. **`follow-the-folder`:** the half has
  the reader expand, collapse and scroll before the churn, and adds two observations — the
  collapsed node stays collapsed, the panel does not return to the top. *Because* both are the
  failures of the decision step 4 already names for this slice, "the reducer keeps the reader's
  place under churn", made visible to someone who did not build it; neither is a second answer.
  **The open question RN-77 recorded was weighed against step 4's too-broad test and does not
  split the slice.** Three reasons. The observable half reads the same under each of the three
  forms the item lists (RN-78). The question cut out alone is a fragment by step 2: a model told
  of a collapse or a scroll shows a person nothing until the folder moves. And the two forms that
  cannot stand beside the command half or SM-4's list as written are each a re-cut § 10 records
  before it is built (*Open Questions*, the collapse-and-scroll item), which is where this
  document handles a mechanism found to contradict a bar — the way E-1's sizing handles a window
  that does not draw. The doubt, stated: step 4 calls a slice too broad "when a plausible
  intermediate result could change the slice's direction or its acceptance", and the second form
  would change the command half's acceptance. This seat reads that as a re-cut trigger and not a
  sizing defect, because no cut of the slice gives the intermediate result a delivery of its own.
  Re-verified before writing: the PRD carries the claim both halves protect — "the tree they
  expanded, the file they have open, the position they are reading stay theirs; only what
  actually changed changes" (`docs/PRD.md` § UX Notes "the view never lies") and
  "checking Git never closes what the person is reading" (`docs/PRD.md` § UX Notes "The path" 3)
  — and both slices' *Traces to* already name those sections, so no PRD clause is added and no
  PRD gap is opened. What does not move, and why: both slices' *Slug*, *Delivers*, *Moves toward*
  and *Not in this slice* — the halves add a way to check what *Delivers* already says, and
  nothing a person can newly do; `read-a-file`'s *Not in this slice* — the held state gains no
  fence, since the answer RN-76 folded permits a change to bring it into the model earlier
  (`docs/trail/sdd/cycle-17.md` § 5.2); § 1, § 5 steps 1 and 2, and § 12's PRD boundary — the PRD
  and the Agari have not moved since RN-73. No companion item: nothing here is product intent the
  PRD does not carry, and no two seats hold different positions. Header `Version:` untouched —
  the runner stamps it *(re: § 5 step 4 E-4, E-5; source: § 6 `see-git-status` and
  `follow-the-folder` *Reached when*, observable half; *Open Questions*, the collapse-and-scroll
  item; `docs/PRD.md` § UX Notes; `docs/UXD.md` UX-I3, UX-F2; RN-46, RN-76, RN-77, RN-78)*.
- **RN-80:** *(CTO)* *(changed)* The companion's § 5.1 folded, and this seat's sentence of its
  § 2.1. § 5.1 was raised from downstream by the PM on 2026-10-01 and answered in the owner's seat
  by a `companion-self-answer` run: confirmed, with three additions
  (`docs/trail/sdd/cycle-18.md` § 5.1; reasoning `docs/trail/sdd/self_answer-29.md` § 5.1).
  § 2.1 was raised by that same run with its slot left at the placeholder.
  **§ 5.1, the four places the answer names.** *Open Questions*: the fourth item, which grammar
  engine compiles the six floor grammars, is closed and removed, the way RN-48 and RN-70 closed
  theirs, and six items remain. § 3 `highlighter`: the clause that left the engine to "the slice
  that lands it (*Open Questions*)" names tree-sitter — the runtime, `tree-sitter-highlight`, one
  grammar crate per floor language, built from C into `nozoki-core`, nozoki's own query files
  compiled in — and cites the record by file, section and commit. § 6 `read-a-file`, the command
  half: "where it is a crate" and the pointer to *Open Questions* leave, and a pointer to § 3's
  row arrives. The half names no engine itself, so the row is the one place the engine is named.
  § 10 RC-3's *Still unresolved*: its words stay and it gains a dated parenthesis, so its pointer
  does not lead to an item that is gone. No count of names and no version of the engine is
  written anywhere in this document: the names are `checks/deps.allow`'s and the versions are
  `Cargo.lock`'s (the answer's addition (b)). *Because* the item said the question would be
  settled "in `read-a-file` by the dependency review that change carries under C-R6", and it was:
  the record, the list and the lockfile landed in one commit, and a question the tree has
  answered is not open.
  **Three calls the answer left to this seat.** The answer names two things it does not cover —
  a § 11 risk for a C parser reading a hostile file, and a § 9 row for what the engine costs —
  and says "whether the fold adds one is the seat's call". (1) **§ 9 TO-11 is added.** § 3 now
  names an engine that is C built into the core, and § 9 is where this design states what a
  choice gives up; TO-2 is the row of the same kind for libgit2. The row states the cost and the
  reversal and cites the record for what was weighed — hand-written lexers and `syntect` — and
  re-weighs nothing (the answer's addition (c)). (2) **§ 11 R-14 is added.** `docs/SRS.md` FR-16
  requires that a file changed while it is read or displayed neither "crashes the shell" nor
  "blocks the view", the engine's C is where either could happen on a floor-language file, and no
  row named it: R-4 names the platform's image decoder and R-13 the bridge. The CPO's fact in
  this run bears on the trigger: a file caught mid-write is everyday input in the driving
  scenario (`docs/PRD.md:L85-L86`, `:L253`), not only a hostile one. The row's response is what
  the design already holds — an engine error returned as data, the sandbox around a fault, a
  fixture for the file, the lockfile reviewed as code, one part to replace — and it names what
  nothing covers. **No check is added**, and this is why: a sanitizer run or a hostile corpus for
  the engine is a new condition on every build, no item raised one, and the answer cites no
  failure for either. RN-76 made the same call on C-I3's comparing check. So `read-a-file`'s bar
  does not move, which is the condition the CPO set in this run for re-reading E-2's sizing.
  (3) **§ 3's units paragraph gains two sentences** saying that *no `unsafe`* is a claim about
  each crate's own Rust source, and that the C `nozoki-core` links is outside it. The claim holds
  on the tree as worded. The sentences are there because the row beside it now names C compiled
  into that unit, and a limit is stated beside the claim it limits
  (`system/doctrine/writing_bar.md` § 1.6, in the instance).
  **§ 2.1, this seat's sentence.** § 12's downstream boundary said two things "are owed" to the
  enforcement store and that both "are already raised there". Both were folded, and neither
  pointer opens on its item. The sentence keeps its words and gains a dated parenthesis, the form
  RC-1, RC-2 and RC-3 took (RN-56, RN-61, RN-66). This seat settles it with the slot unfilled, as
  RN-76 settled that cycle's § 2.1: the repair changes no shape, seam, condition, order or bar and
  nothing the product promises, and the CPO read no product call in it in this run. The item's
  other sentence is in § 12's UXD boundary and is the CDO's. It is not written here, and the item
  stays in the companion until that seat has handled it.
  **Re-verified before writing, not taken from the answer or the item**, on `main` at
  `nozoki@24d652b`. `checks/deps.review.md:L8-L16` is § *The engine chosen* and names the engine
  and the two alternatives. `git show --stat 85d9fa7` lists `Cargo.lock`, `checks/deps.allow`,
  `checks/deps.review.md` and `crates/nozoki-core/Cargo.toml`, and `git merge-base --is-ancestor
  85d9fa7 HEAD` exits 0. `cargo test --locked -p nozoki-core --test highlight` prints `test
  result: ok. 18 passed; 0 failed`. `bash checks/no-network.sh` prints `ok — 40 cargo names match
  checks/deps.allow; the Swift package declares 0 dependencies and holds 0 Package.resolved`.
  `grep -rl 'tree_sitter\|tree-sitter'` over the `.rs`, `.toml` and `.swift` files of `crates`
  and `nozoki-mac` prints `crates/nozoki-core/Cargo.toml` and
  `crates/nozoki-core/src/highlighter.rs` and nothing else, so one part imports the engine. `grep
  -rn unsafe crates/nozoki-core/src` prints nothing, and the workspace `Cargo.toml` sets
  `unsafe_code = "forbid"`. `crates/nozoki-core/src/highlighter.rs:L183-L189` keeps the spans
  gathered so far when the engine stops, and passes the engine `None` where it takes a
  cancellation flag, which is the ground for R-14's "none bounds how long a parse may take".
  `crates/nozoki-core/tests/highlight.rs:L201`, `:L206` and `:L213` hold a truncated, a deeply
  nested and a wrong-language case, which the tree carries beyond `read-a-file`'s bar. The
  registry copies of the Python, Bash, JavaScript, YAML and TOML grammar crates the lockfile
  resolves each hold a `src/scanner.c`, and the JSON one holds none. `git diff --stat 2026553
  HEAD -- crates checks Cargo.lock Cargo.toml` prints nothing, so the engine as merged is the
  engine at `24d652b`. For § 2.1: `docs/nfdr.md:L368-L374` is QC-24 with `nozoki_free` beside
  the list; `:L923-L932` is § 9 on the Swift packet, and `:L1056` opens the bullet that states
  where `nozoki-mac` departs from it;
  `docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md:L45-L49` is the correction dated
  2026-09-23; `docs/architecture_open_issues.md` reads "None." under § 2 and its § 3 holds §§ 3.1
  and 3.2 only; and `grep -n "^### " docs/trail/architecture/cycle-10.md` prints § 2.1 at `:L29`
  and § 3.4 at `:L121`.
  **One thing the tree shows, recorded here and in no condition.** R-14 says R-13's sanitizer run
  is over the bridge's tests. That run is a statement of this design and of `docs/nfdr.md` QC-13
  (`:L254`), and the tree does not carry it yet: `grep -rn -i sanitizer .github checks` over the
  `.yml` and `.sh` files prints nothing, and `.github/workflows/ci.yml:L26` runs `cargo test
  --workspace --locked && swift test --package-path nozoki-mac`. It is the delivery tier's,
  against the NFDR, and no slice's bar in § 6 states it.
  What does not move, and why: § 2, § 5 steps 3 and 5 and § 7 — an engine named inside one part
  changes no shape, pair, edge or order; SM-1 – SM-8 — nothing new crosses a seam;
  § 4 C-R1, C-R6 and C-I5 — the answer re-read them and the tree meets them, and R-14's limits
  are stated in § 11 and are not conditions; `read-a-file`'s *Rests on* and SRS trace — the
  slice realizes the same parts and requirements; "third item" in § 5 step 4 E-3, "the third
  Open Question" in § 6 S-3 and "the second Open Question" in § 6 S-4 — the removed item was the
  fourth, and the first three keep their order; RC-1's "fourth *Open Questions* item" — it names
  the item that held that place on 2026-09-19, and a re-cut entry is history; no § 10 entry — no
  *Reached when* failed and the SRS did not move, and the question resolved downstream as it
  said it would; § 12's SRS boundary — `docs/SRS.md` stands at v12 and no requirement moves.
  **Downstream, nothing opened by this seat:** `docs/nfdr.md` QC-3 still calls the one-time
  review owed and is raised at `docs/architecture_open_issues.md` § 3.1, the Principal
  Architect's. `checks/deps.review.md:L14` cites this document's lines `:L4521-L4524` for the
  question, with no commit, and those lines no longer hold it. That file is the delivery tier's.
  The question as it stood is at `nozoki@24d652b:docs/SDD.md:L4521-L4524`. **The companion:**
  `diff docs/SDD_open_issues.md docs/trail/sdd/cycle-18.md` printed nothing before this turn's
  edits. § 5.1 is removed from it as folded, and § 2.1 stays, with a line saying which of its two
  sentences is done. Header `Version:` untouched — the runner stamps it *(re: *Open Questions*;
  § 3 `highlighter` and the units paragraph; § 6 `read-a-file` *Reached when*, command half; § 9
  TO-11; § 10 RC-3; § 11 R-14; § 12 the downstream boundary; source:
  `docs/trail/sdd/cycle-18.md` §§ 2.1, 5.1; `docs/trail/sdd/self_answer-29.md`;
  `checks/deps.review.md` § *The engine chosen*; `nozoki@85d9fa7`, `nozoki@2026553`,
  `nozoki@24d652b`; `docs/SRS.md` FR-8, FR-16, FR-29, NFR-1, NFR-4, NFR-16, DR-6;
  `docs/PRD.md:L85-L86`, `:L253`; `docs/nfdr.md` QC-3, QC-13, QC-24, § 9; ADR-0016;
  `docs/trail/architecture/cycle-10.md` §§ 2.1, 3.4; `docs/architecture_open_issues.md` § 3.1;
  RN-48, RN-56, RN-61, RN-66, RN-70, RN-76)*.
- **RN-81:** *(CDO)* *(changed)* § 12's UXD boundary is brought to the UXD and the design
  language as they stand, in three places, and no condition, observable half or trace moved.
  **The version it cites.** The clause said every `UX-` entry "is cited as `docs/UXD.md` v10
  (Settled) states it". The UXD is at v11 since `nozoki@24d652b` (its header's `Version:` field),
  so the clause now reads v11 and says what v11 moved. The reason is the upstream change, which
  the UXD records in its RN-31: UX-U1's expertise floor now carries the one `docs/PRD.md` § Goals
  "No learning curve" states. The change reaches no sentence of this document. `git diff 4d7b653
  24d652b -- docs/UXD.md` has three hunks: the `Version:` line, UX-U1, and RN-31 appended at the
  end. `grep -n "UX-U[0-9]" docs/SDD.md`, run before this turn's edits, printed two lines,
  `:L1433` (UX-U3) and `:L1717` (UX-U2), so UX-U1 was cited nowhere. The three line-anchored UXD
  citations this document carries (`docs/UXD.md:L3`, `:L3-L5`, `:L395-L397`) open on the same
  lines: the first two hunks replace lines one for one and the third starts at `:L938`.
  **"The UXD stands at v10 under the view taken."** That sentence is about the renderer exit of
  2026-09-23 and was true on that day. It keeps its words and gains a dated parenthesis saying the
  UXD is now at v11 and that the exit did not move it, the form RC-1, RC-2 and RC-3 took (RN-56,
  RN-61, RN-66).
  **What the exit moves in `docs/DESIGN.md`.** This is the second sentence of the companion's
  § 2.1 (`docs/trail/sdd/cycle-18.md` § 2.1, its last paragraph of *Drafted into the SDD*). The
  clause named three things that document's own run would move and quoted § Overview as "realised
  in plain CSS custom properties over the product's own markup". That run has happened: DESIGN
  v11, `nozoki@cce8bde`. The sentence keeps its words and gains a dated parenthesis saying how
  each of the three stands. The item measured the first and said the other two "were not
  measured", so all three were read at DESIGN v13 (`nozoki@705e6f1`) before writing. § Overview
  reads "realised in AppKit views drawn by the product's own Swift package"
  (`docs/DESIGN.md:L331-L332`). RN-1 says "Revisions 1–10 read *plain CSS custom properties*
  here … and held that every value was a CSS value" (`:L855-L857`). The two font stacks did not
  move: the frontmatter still names them (`:L29`, `:L46`), § Typography says each "is how the
  token format names a platform family" and that the shell "looks up no family by name"
  (`:L447-L452`), and that document's RN-31 gives the reason, "the owner confirmed the families
  in those words" (`:L1336-L1337`). So one of the three things the clause expected to move
  stayed. That call is the design language's, made in its own run as the clause said it would be,
  and the parenthesis records it without reopening it. "And no token value" held: a `diff` of the
  frontmatter at `nozoki@269bcf5`, the revision RN-62 read, against the file on disk prints one
  changed line, `description:`.
  **Why this seat settled its half of § 2.1 with the slot unfilled.** The parenthesis records
  what another document now says. It changes no experience, no C-E condition, no observable half
  and no trace, and nothing the product promises, so it is this seat's call and not the owner's
  (RN-19's routing rule). The CTO settled the item's first sentence on the same ground (RN-80),
  and the CPO read no product call in the item in this run.
  **No § 10 entry, and the doubt.** § 10 lists "the PRD, SRS or UXD changed upstream" among the
  re-cut triggers, the lane table gives an upstream change to the seat that owns the document,
  and the UXD is this seat's. RN-62 and RN-69 wrote "the UXD did not change upstream"; that is no
  longer so. This seat reads the trigger as permission to redraw the cut where an upstream change
  contradicts it, because § 10 opens "A cut meets a reality that contradicts it, and the
  contradiction is recorded **before** the cut is redrawn". UX-U1's floor contradicts no slice:
  no field of § 6 and no C-E condition cites it, so there is no prior assumption to record and
  nothing to redraw. A reader could hold that every upstream revision earns an entry, to show it
  was looked at. This note and the clause in § 12 are where that is shown.
  What does not move, and why: § 4's CDO clause, C-E1 – C-E10 — none cites UX-U1 or a reader's
  Git knowledge (`grep -n -i "git knowledge\|expertise\|know Git" docs/SDD.md` printed nothing
  before this turn's edits); § 5 step 1's observability — no entry changed; every § 6 observable
  half and UXD trace — none cites UX-U1, and the half read closest against the new floor,
  `see-git-status`'s, states the short status "in Git's own word" as UX-S3 does, which
  `docs/UXD.md` RN-31 records as an entry that "already assumes this reader"; the rest of § 12's
  UXD boundary — the gap found, the defect reported and the
  delegations stand. `git log f5b7843..HEAD -- docs/DESIGN.md docs/CONTENT.md` prints nothing, so
  the design language and `docs/CONTENT.md` are as this seat last read them, in the run that
  ended at `nozoki@f5b7843`. No companion item: nothing here is the owner's to settle and no two
  seats hold different positions. **The companion:** § 2.1 is removed as folded, both sentences
  now written, and the file lists no item. The item stands whole, slot unfilled, at
  `docs/trail/sdd/cycle-18.md` § 2.1. Header `Version:` untouched — the runner stamps it *(re:
  § 12 the UXD boundary; source: `docs/UXD.md` header `Version:`, UX-U1, RN-31; `docs/PRD.md`
  § Goals "No learning curve"; `docs/DESIGN.md` § Overview, § Typography, RN-1, RN-31;
  `docs/trail/sdd/cycle-18.md` § 2.1; `nozoki@24d652b`, `nozoki@4d7b653`, `nozoki@cce8bde`,
  `nozoki@705e6f1`, `nozoki@269bcf5`, `nozoki@f5b7843`; § 10, opening note; RN-19, RN-56, RN-61,
  RN-62, RN-66, RN-69, RN-80)*.
- **RN-82:** *(CTO)* *(changed)* The companion's § 5.1 folded in the four places it names in
  this seat's lanes. The item was raised from downstream by the PM on 2026-10-01 and answered in
  the owner's seat by a `companion-self-answer` run on 2026-10-02: reading (a), with four bounds
  (`docs/trail/sdd/cycle-19.md` § 5.1; reasoning `docs/trail/sdd/self_answer-31.md` § 5.1). Its
  fifth place, § 4 C-E1's mechanism sentence, is the CDO's and is not written by this note.
  **§ 3, the `surfaces` row.** The row's last sentence said a surface "draws no state the bridge
  did not send". It now names one exception — that an intent the surface raised has not been
  answered yet — with the answer's four bounds in the answer's order, the sentence that the gap
  is not held state, and the two cases the answer says it does not cover. *Because* the gap is
  the one state the bridge cannot send: an SM-4 call's answer is its return, and the bridge
  exports no callback today. A pending that had to cross the seam could not be drawn while the
  core is slow to answer, which is the case `docs/UXD.md` UX-S1 *Loading* exists for.
  **§ 3, *What the system holds*, and § 4 C-I1.** Both now say `stopped` is established in two
  places: by the model on an item it holds, and by `mac-shell` at SM-4's return when the return
  carries no verdict. C-I1's *Violated by* is unchanged, and "a panic that reaches the host"
  stays a violation. The `Item<T>` entry also gains two sentences that keep the model's
  `pending`, which crosses the bridge, apart from the surface's gap, which is not an `ItemState`
  (the answer's fourth bound).
  **§ 6 `open-a-folder`, the command half: a reading clause, and no new test.** "A row is drawn
  from a projection and from nothing else" keeps its words and gains a clause saying it is read
  with the row's exception, because the tree's pending line is the same gap. No test is added,
  and this is why: the answer says "no bar, no seam's list and no order moves", a test of the
  four bounds would be a new bar on the first slice, and no item raised one. RN-76 and RN-80 made
  the same call on a check no item asked for. So the CPO's sizing of `open-a-folder` in § 5 step 4
  rests on the same bar as before.
  **Three calls the answer left to this seat.** (1) **SM-4's and SM-8's rows and `mac-shell`'s
  row stand as written.** The answer lists none of them. SM-8's Down cell carries "projections
  and deltas", and the `stopped` the shell hands down is the state of an item, which is what a
  projection carries. `mac-shell`'s row already has it decode what returns, and § 11 R-13 already
  has every bridge function answer a caught panic with "a failure value". (2) **The two uncovered
  cases are written on the row** and not left in the trail copy alone, because a limit is stated
  beside the claim it limits (`system/doctrine/writing_bar.md` § 1.6, in the instance). (3) **No
  § 9 or § 11 row is added.** § 9 TO-7 accepts that no harness drives the views because the shell
  holds no I/O, and the one state a surface originates reads nothing and writes nothing. A read
  that never returns is stated on the row as not covered; no slice's bar depends on it and the
  answer cites no failure for it.
  **Re-verified before writing, not taken from the item or the answer**, on `main` at
  `nozoki@18007b3`. `nozoki-mac/Sources/Surfaces/WorkbenchView.swift:L80-L99` draws the panel's
  reading state at `:L86`, raises the intent at `:L88` and draws the fault from a `nil` answer at
  `:L97`. `nozoki-mac/Sources/Surfaces/RootItemsView.swift:L254-L261` sets the tree's pending line
  at `:L258` and asks for the listing at `:L260`.
  `nozoki-mac/Sources/Shell/LaunchFlow.swift:L108-L115` wires both intents to the shell's reader
  before the workbench is presented. `crates/nozoki-bridge/src/boundary.rs:L21-L42` returns NULL
  when the work panics and when the answer cannot be serialized.
  `crates/nozoki-bridge/src/exports.rs` declares four exported functions, at `:L55`, `:L73`, `:L90`
  and `:L104`, and `grep -rn model_changed crates nozoki-mac/Sources` printed nothing, so no
  callback is exported. `nozoki-mac/Sources/Shell/BridgePayload.swift:L272-L277` returns `nil` for
  a NULL buffer and for a buffer that does not conform.
  **Two things the tree shows, recorded here and in no condition.** First, the same decoder
  returns `nil` in a third case, where the call's own answer is the wire's `pending`
  (`BridgePayload.swift:L266-L267`), which the bridge sends "when nothing was read"
  (`crates/nozoki-bridge/src/exports.rs:L83`). This seat reads that as covered by "carries no
  verdict": the call has returned, so nothing is still reading. That reading is reasoning, and the
  answer's own text names the first two cases only. Second, the tree and the panel treat a
  no-verdict answer differently. The panel draws the fault. The tree draws nothing beneath the row
  and no sentence beside it (`nozoki-mac/Sources/Surfaces/RootItemsView.swift:L290-L291`, `:L391`;
  the test at `nozoki-mac/Tests/SurfacesTests/RootItemsViewExpansionTests.swift:L245-L253` holds
  it). `docs/UXD.md` UX-I16 names "the tree row for a tree entry" as that fault's slot. Whether
  the tree meets it is read against § 4 C-E3, which is the CDO's, and the build is the delivery
  tier's. This seat writes no condition on it.
  **What the tree carries beyond the bar.** The tests were read and not run in this turn. The
  tree's pending line carrying the sentence alone, with no count and no spinner, is
  `RootItemsViewExpansionTests.swift:L169-L186`. The panel's pending and fault states are tested
  in `nozoki-mac/Tests/SurfacesTests/WorkbenchSelectionTests.swift` from `:L263` on.
  What does not move, and why: § 2, § 5 steps 3 and 5 and § 7 — an exception named on one part
  changes no shape, pair, edge or order; SM-1 – SM-8 and § 4 C-R7 — nothing new crosses a seam
  and no export is added, and C-R7's rule that a callback registration is raised "by the slice
  that needs it, and not before" stands; `read-a-file`'s and `follow-the-folder`'s command
  halves — neither carries the "from a projection" clause, and the panel's pending is covered by
  the row; every *Rests on* and SRS trace — the slices realize the same parts and requirements;
  *Open Questions* — the collapse-and-scroll item stands, and the gap adds no held state to it;
  no § 10 entry — no command half is unmet as written and the SRS did not move; § 12's SRS
  boundary — `docs/SRS.md` is Settled and no requirement moves. `docs/trail/sdd/cycle-17.md`
  § 5.2 stands: the open file, the selection and the expansion are the model's from
  `follow-the-folder` at the latest.
  **Downstream, nothing opened by this seat:** `docs/nfdr.md:L983` reads "A view is drawn from a
  projection and from nothing else". It re-derives from the `surfaces` row now that the row has
  moved, and that is the Principal Architect's (§ 12, the downstream boundary).
  **The companion:** `diff docs/SDD_open_issues.md docs/trail/sdd/cycle-19.md` printed nothing
  before this turn's edits. § 5.1 stays in it with a line saying which places are written, until
  the CDO's sentence in C-E1 is. Header `Version:` untouched — the runner stamps it *(re: § 3
  `surfaces` and *What the system holds*; § 4 C-I1; § 6 `open-a-folder` *Reached when*, command
  half; source: `docs/trail/sdd/cycle-19.md` § 5.1; `docs/trail/sdd/self_answer-31.md` § 5.1;
  `docs/trail/sdd/cycle-17.md` § 5.2; `nozoki@18007b3`; `docs/UXD.md` UX-S1, UX-I13, UX-I16;
  `docs/CONTENT.md` § *Message patterns*; `docs/nfdr.md:L983`; § 9 TO-7; § 11 R-13; RN-76,
  RN-80)*.

- **RN-83:** *(CDO)* *(changed)* C-E1 names the surface's own unanswered intent beside C-I1's
  state mechanism, under the exception and four bounds held on § 3's `surfaces` row. The bounds
  have one home rather than a second copy in C-E1. This completes the fifth place named by the
  answer in `docs/trail/sdd/cycle-19.md` § 5.1; the other four are recorded in RN-82. The answer
  permits the gap alone, not a surface-originated verdict about the folder. C-E1's observable
  condition and its *Violated by* examples stand; C-E2 still forbids an unasked refresh taking
  the reader's place. The resolved § 5.1 leaves no companion item, so `docs/SDD_open_issues.md`
  is removed; the answer remains whole in `docs/trail/sdd/cycle-19.md`.
  **The UXD boundary reads v12.** The upstream change at `nozoki@5b3040e` corrects the reference
  inventory in § 4 and its § 11 trace and records the correction in RN-32. That note says the
  correction authorizes no change to a flow, screen or interaction requirement. § 12 names the
  revision now read; no observable half, UXD trace or experience condition changes for it.
  **The tree's no-verdict answer fails C-E3.** This is this seat's reading of the code against
  the settled experience, not a runtime observation. At `nozoki@18007b3`,
  `nozoki-mac/Sources/Surfaces/RootItemsView.swift:L286-L303` clears the pending line and sets
  `.noAnswer` for a `nil` listing; `:L235-L249` supplies a sentence only for `.failed`, and
  `:L386-L392` supplies no child for `.noAnswer`. The test explicitly expects both no child and
  no condition sentence (`nozoki-mac/Tests/SurfacesTests/RootItemsViewExpansionTests.swift:L245-L253`).
  The shell's decoder can return this `nil` for a NULL buffer or a non-conforming answer
  (`nozoki-mac/Sources/Shell/BridgePayload.swift:L106-L109`), so this is not evidence of an empty
  folder. C-E3 requires an unexplained failure in the item's failure slot, and `docs/UXD.md`
  UX-I16 names the tree row for a tree entry. Ending pending meets the answer's second bound;
  showing no fault does not meet C-E3. Keeping the rest of the tree usable supplies a route out
  but does not substitute for the required fault presentation. The repair is implementation
  against that existing condition, not a new experience choice; C-E3 and UX-I16 stand as written.
  The code and its test were read, not run. Language resolution for this source check stops at
  `system/projects/nozoki/project.md`'s `Languages:` field in the instance; the Swift packet at
  `<CORE>/doctrine/engineering/languages/swift/README.md` was opened.
  **No re-cut.** No observable bar has proved impossible to meet: the tree fails an existing
  condition, and the answered item says no bar, seam list or order moves. § 6's observable
  halves and UXD traces stand, including `open-a-folder`'s C-E3 trace. No new test, § 10 entry or
  companion question is added. This note identifies the delivery defect without granting an
  exception or prescribing its implementation. *(re: § 4 C-E1, C-E3; § 6 `open-a-folder`;
  § 12 the UXD boundary; source: `docs/trail/sdd/cycle-19.md` § 5.1; `docs/UXD.md` UX-I16,
  RN-32; `nozoki@18007b3`; `nozoki@5b3040e`)*.

- **RN-84:** *(CTO)* *(changed)* § 3's `read-only-harness` row now names everything `checks/`
  holds, pinned to the commit it was measured at, and tells what is on disk from what a slice still
  owes. The item was raised from downstream by the PM on 2026-10-03, after `entry-points.sh` and
  `entry-points.allow` landed, and answered in the owner's seat by a `companion-self-answer` run
  the same day (`docs/trail/sdd/cycle-20.md` § 5.1; reasoning `docs/trail/sdd/self_answer-32.md`
  § 5.1). The row is this seat's and nothing else moves: the slug, *Lives in* and *Must not own*
  cells are as they were, so the parts table keeps the shape the skeleton launcher reads.
  **What the cell gains, from the answer.** `entry-points.sh` with `entry-points.allow`, cited to
  `docs/nfdr.md` QC-30 half (2) as the condition the pair proves — this SDD adds no § 4 condition
  for the half, because § 4's opening note lets an NFDR entry trace to "the § 4 condition or SRS
  requirement it realizes" and QC-30 traces to SRS NFR-14 and FR-1 beside C-R3's *Violated by* and
  C-R7 (`docs/nfdr.md:L618-L620`). The three helpers, each beside the script that uses it: `walk.rs`
  (`checks/walk.rs:L1`, "the in-process walk `checks/read-only.sh` consumes";
  `crates/nozoki-core/tests/walk.rs:L6` compiles it by `#[path]` into a test target, which is why
  it is not "a dependency of any shipped unit"); `sandbox_probe.rs` (`checks/bundle.sh:L321-L322`
  compiles it with `rustc` at run time; the SDD already cited it by line at § 4 C-I3 and in RN-48's
  record without saying which part owns it); `deps.review.md` (`checks/deps.review.md:L3`,
  "recorded as code beside the list it reviews"; the `highlighter` row cites it). And `tests/`,
  the suites `docs/nfdr.md` § 10 tags beside each script. *Because* the row already enumerated at
  file granularity — `deps.allow` is a list, not a script — and a reader meeting
  `checks/sandbox_probe.rs` in C-I3's record found no row saying which part owns it.
  **The two bounds, from the answer.** The enumeration is pinned to `nozoki@7a125b4`, the device
  `docs/nfdr.md` § 9 uses for its suite count ("a re-measurement of this sentence and not a
  contradiction of it"), so the next file in `checks/` is a measured difference and not a silent
  falsehood; the pin does not make the row self-updating, and the cell says a later file owes it an
  item. And the cell is split into *on disk at that commit* and *owed by a slice*, the marking the
  row already carried for `contract.sh` extended to every planned name, with the slice that owes
  each — none struck, because they are the design's.
  **Three calls the answer left to this seat.** (1) **`repo.git.tar` is named with `repo`.** It is
  on disk and the answer did not name it; `checks/tests/test_own_state.sh:L67` unpacks it into
  `fixtures/repo` and `test_read_only.sh:L137`, `:L217` and `:L267` read it, so it is the
  repository fixture's `.git` and belongs beside it. (2) **Two fixture sets the row never named
  go in as slice-owed.** `fixtures/history`, which `read-the-history`'s command half runs
  `git_state` over (`docs/SDD.md` § 6 S-9), and `fixtures/scale-small`, `scale-medium` and
  `scale-large`, which `follow-the-folder`'s runs `latency.sh` over (§ 6 S-5; § 4 C-I4). The
  answer's second bound is that the row tells on-disk from slice-owed for what it names; a fixture
  a bar cites and the row omits fails the same test one step earlier, and § 3's *Must not own* for
  every other part leaves no other owner for a file under `checks/`. (3) **The hostile corpus is
  named as `fixtures/hostile.md`, a file**, because that is what `read-markdown`'s command half
  cites (§ 6 S-3); the old cell called it a folder, and the bar is the owner of its form.
  **Re-verified before writing, not taken from the item or the answer**, at `nozoki@7a125b4`:
  `git ls-tree --name-only HEAD checks/` lists `.gitkeep`, `bundle.sh`, `deps.allow`,
  `deps.review.md`, `entry-points.allow`, `entry-points.sh`, `fixtures`, `no-network.sh`,
  `own-state.sh`, `read-only.sh`, `renderer.sh`, `sandbox_probe.rs`, `structure.sh`, `tests`,
  `view.sh`, `walk.rs`; `ls checks/fixtures` → `highlight`, `idle-shell`, `plain`, `repo`,
  `repo.git.tar`, `text`; `ls checks/tests` → eight `test_*.sh`, one per on-disk script, each the
  whole `run` of its own step in `.github/workflows/ci.yml` (`:L32`, `:L38`, `:L48`, `:L54`,
  `:L65`, `:L74`, `:L80`, `:L83`); `ls checks/churn.sh checks/latency.sh checks/contract.sh` →
  no such file, three times. `git diff --stat b158052 HEAD -- checks/` and
  `git diff --stat 4a31865 HEAD -- checks/` both print nothing, so the commit the item measured
  at, the commit the answer measured at and the pin are one tree for this unit.
  `crates/nozoki-core/tests/highlight.rs:L23` and `read_file.rs:L26`, `:L279` read `highlight`
  and `text`. `.gitkeep` is a placeholder with nothing to own and is not named.
  What does not move, and why: § 2, § 5 steps 3 and 5 and § 7 — a part's enumeration changes no
  shape, pair, edge or order; SM-1 – SM-8 — nothing new crosses a seam, and `walk.rs` reaching
  `nozoki-core` through a test target is SM-5's existing route; § 4 C-I3 and C-I4 — naming the
  driver's and the probe's source files moves nothing either condition requires; the *Four
  physical units* paragraph's "`checks` is build-time and never shipped" — holds for every file
  named, since `walk.rs` reaches a test target and `sandbox_probe.rs` a temporary directory;
  every § 6 command half and SRS trace — the bars cite the same scripts and fixtures, and the
  cell now says which slice owes each; no § 10 entry — no command half is unmet as written and
  the SRS did not move; § 12's SRS boundary — `docs/SRS.md` is Settled and no requirement moves.
  **Downstream, nothing opened by this seat:** `docs/nfdr.md` § 9's suite count and § 10's
  linked-tree rows are owed a re-measurement against this row, and the self-answer records that
  `docs/architecture_open_issues.md` § 3.1 already carries it; that is the Principal Architect's
  (§ 12, the downstream boundary).
  **The companion:** `diff docs/SDD_open_issues.md docs/trail/sdd/cycle-20.md` printed nothing
  before this turn's edits. Its one item is folded and nothing else stands, so
  `docs/SDD_open_issues.md` is removed; the answer remains whole in `docs/trail/sdd/cycle-20.md`.
  Header `Version:` and `Status:` untouched — the runner stamps both *(re: § 3
  `read-only-harness`; source: `docs/trail/sdd/cycle-20.md` § 5.1; `docs/trail/sdd/self_answer-32.md`
  § 5.1; `nozoki@7a125b4`; `docs/nfdr.md` QC-30, § 9, § 10; § 4 C-I3, C-I4, C-I6; § 6 S-3, S-4,
  S-5, S-9, S-11; RN-48, RN-80)*.
- **RN-85:** *(CTO)* *(changed)* Three statements of § 3 and § 4 no longer matched the tree once
  `git-reader` landed, and are corrected. The PM raised the three from downstream on 2026-10-03,
  and a `companion-self-answer` run answered them in the owner's seat the same day
  (`docs/trail/sdd/cycle-21.md` §§ 5.1 – 5.3; reasoning `docs/trail/sdd/self_answer-33.md`). Each
  is a correction of a sentence that had become false and widens nothing. No slice's bar, edge or
  order moves.
  **§ 5.1, the `read-only-harness` row.** The cell is re-measured and re-pinned at
  `nozoki@814a369`, the commit this fold is made on. `inside-a-repo`, `parent-of-two`,
  `linked-worktree` and `submodule` leave *Owed by a slice* and join *On disk*, each with its
  `<name>.git.tar`; the fixture-folder count moves from five to nine; `see-git-status` leaves
  the slice-owed list, because those four were all it owed the row by name. Measured for this
  fold and not taken from the item or the answer: `git ls-tree --name-only HEAD checks/fixtures/`
  lists `highlight`, `idle-shell`, `inside-a-repo`, `inside-a-repo.git.tar`, `linked-worktree`,
  `linked-worktree.git.tar`, `parent-of-two`, `parent-of-two.git.tar`, `plain`, `repo`,
  `repo.git.tar`, `submodule`, `submodule.git.tar` and `text`; `git ls-tree --name-only HEAD
  checks/` lists the sixteen names RN-84 records and no other; `git ls-tree --name-only HEAD
  checks/tests/` lists eight `test_*.sh`. `git diff --name-status 7a125b4 HEAD -- checks/` shows
  six fixture files and four archives as added and six files as modified — `deps.allow`,
  `deps.review.md`, `entry-points.allow`, `structure.sh`, `tests/test_no_network.sh`,
  `tests/test_structure.sh` — all six already named by the row, so the enumeration owes them
  nothing. `crates/nozoki-core/tests/root_finding.rs:L46-L51` is the function that unpacks each
  archive. The cell's other clauses are as RN-84 left them.
  **§ 5.2, SM-2.** "The port is a trait the model owns" and the owner cell's "the port is its"
  said the trait is defined in `folder-model`. It is defined in `git-reader`:
  `crates/nozoki-core/src/git_reader.rs:L33` holds `pub trait GitPort`, with `RootFinding` at
  `:L55` and `ProbeCondition` at `:L75`, and `grep -n 'GitPort\|git_reader\|RootFinding\|ProbeCondition'
  crates/nozoki-core/src/folder_model.rs` prints nothing. This document had said two things about
  one port: § 3's `git-reader` row opens its *Owns* cell with "The **Git port**", and the *Four
  physical units* paragraph has the readers "import neither the model nor one another". The tree
  took that reading and SM-2 now agrees with it, in the form SM-1's owner cell has. The reason is
  written into the owner cell from this document's own paragraph and not from `docs/nfdr.md`
  QC-11, which derives from it. `folder-model` keeps the contract: it states what the port must
  answer, and a second adapter passes the same contract tests (§ 11 R-1). The rule for the types
  `state`, `status`, `diff` and `walk` bring is the answer's second addition: a type that crosses
  SM-2 is never defined in `folder-model`, and its home — `git-reader`, or a module of
  `nozoki-core` that is no part — is the design of the change that adds it. *What the system
  holds* gains one sentence on `GitState` so that "the model holds it" is not read as "the model
  defines the type the port returns". § 2's hexagonal row, § 9 TO-10, § 11 R-1, the `core-bridge`
  row and `see-git-status`'s port double say nothing of where the trait is defined and do not
  move.
  **§ 5.3, C-R6.** "No shipped unit links a network transport" was false of `crates/nozoki-core`,
  which § 3 names as a unit, and unproved of the executable. Read for this fold in the registry
  copy of `libgit2-sys 0.18.8+1.9.7`: `build.rs:L152-L156` adds `libgit2/src/libgit2/transports`
  and `…/streams` under the comment "they're all unconditionally always compiled", and
  `libgit2/src/libgit2/transport.c:L33-L35` registers `git://`, `http://` and `https://` outside
  the `#ifdef GIT_SSH` that guards the three SSH schemes (`:L38-L42`). The answer takes the
  second of the item's two folds: the claim is kept, made of the shipped executable, and given
  evidence. The first fold, stating the claim lower, is not taken, because `docs/fdr.md` PD-27
  carries the claim as a product decision and lowering it is not this seat's. § 3's `git-reader`
  row changes "linked without its HTTPS and SSH transports" to "built with its `https` and `ssh`
  features off", which is what the source shows: `https://` is registered and what is absent is
  the TLS stream behind it.
  **Two calls the answer left to this seat.** (1) **The read rides `checks/view.sh`.** The answer
  asks for no new script and names `checks/view.sh` as one that already reads the executable; the
  script's header states the `otool -L` read and its rule that it never passes having read
  nothing (`checks/view.sh:L17-L22`). The harness row therefore gains no file. (2) **When the
  script carries the read.** The answer says "on every build" and the script does not hold the
  read at `nozoki@814a369` (`grep -n 'nm ' checks/view.sh` prints nothing). C-I3 says so, and
  says `see-git-status` owes it no later than the build that first exports a function reaching
  `git-reader`. That slice is the one whose command half already carries C-R6's tree evidence,
  and `grep -rn 'git_reader\|GitPort\|Libgit2' crates/nozoki-bridge/src` prints nothing, so no
  shipped path reaches libgit2 before that build. The slice's § 6 block is not edited: the read
  is inherited through § 4, as every script is.
  **Known limit, stated beside the claim.** This document's record holds no `nm` reading of a
  release executable built after `git-reader` merged (`docs/trail/sdd/self_answer-33.md` § 5.3,
  "Not measured"), so whether the claim holds once a Git command is exported is not known. § 11 R-15 is new and carries the trigger and the response. The debug
  and release `nm` readings C-R6 cites are the self-answer's and were not re-run here.
  **Not weighed here, and named.** `nozoki-mac/Package.swift:L32-L37` links `iconv`, `z`,
  `Security` and `CoreFoundation` for the bridge's static library. C-R7's link list names only
  `WebKit` and `JavaScriptCore`; whether it says anything about `Security` was not weighed by the
  answer or by this fold.
  **Downstream, nothing opened by this seat.** `docs/adr/0004-git-read-through-libgit2-behind-a-port.md`,
  `docs/nfdr.md` QC-3 and QC-11's trace carry the sentences corrected here, and
  `docs/architecture_open_issues.md` §§ 3.2 and 3.4 already raise them to the Principal Architect
  (§ 12, the downstream boundary). `docs/nfdr.md` § 10's linked-tree rows are owed a
  re-measurement against the re-pinned row and re-derive from it.
  **The companion:** `diff docs/SDD_open_issues.md docs/trail/sdd/cycle-21.md` printed nothing
  before this fold's first edit. All three items are folded and nothing else stands, so
  `docs/SDD_open_issues.md` is removed and `Status:` stays Settled *(re: § 3 `git-reader`,
  `read-only-harness`, SM-2, `GitState`; § 4 C-R6, C-I3; § 11 R-15; source:
  `docs/trail/sdd/cycle-21.md` §§ 5.1 – 5.3; `docs/trail/sdd/self_answer-33.md`; `nozoki@814a369`;
  `docs/SRS.md` NFR-8; `docs/fdr.md` PD-27)*.
- **RN-86:** *(CTO)* *(changed)* § 4 C-R5's sentence "The runtime does is not forced by the
  stack" is repaired to "The floor is not forced by the stack". The sentence was not grammatical;
  its own continuation names the subject — "so the floor is the maintainer's narrowing". The
  floor, its value and its reason are untouched. Found while folding RN-85 and fixed in place
  under `<CORE>/doctrine/governance/found_while_walking.md` § *The rule*, clause 1;
  `docs/trail/sdd/self_answer-33.md` § *Weighed and not raised* had recorded the slip and left
  it, because that run may not edit this document *(re: § 4 C-R5)*.
- **RN-87:** *(CTO)* *(changed)* The rule that only `git-reader` imports the libgit2 binding gains
  one exception, and `core-bridge` gains the config search-path switch. A `companion-self-answer`
  run raised the item on 2026-10-03 while answering `docs/architecture_open_issues.md` § 3.5,
  which the PM raised after `git-reader` landed, and a second such run answered it in the CTO's
  seat the same day: "confirm, with six additions the fold carries"
  (`docs/trail/sdd/cycle-22.md` § 2.1; reasoning `docs/trail/sdd/self_answer-34.md` § 2.1). The
  item carries `Seat: cto`, so no owner's answer stands behind this note. § 4 C-D1 and
  `docs/fdr.md` R-101 stand as written, and no slice's *Delivers*, edge or order moves.
  **What was wrong.** A libgit2 repository open adds the global, XDG, system and programdata
  config levels, and under the App Sandbox takes the global level's home from the password
  entry. Those files lie outside the granted folder and the container, and C-D1's *Violated by*
  names any read there. The one call that stops them, `git2::opts::set_search_path`, is an
  `unsafe fn`. `nozoki-core` holds no `unsafe` and only `git-reader` could name the binding, so
  no unit could make the call.
  **Read for this fold, at the sources the item and the answer cite.** In the registry copy of
  `libgit2-sys 0.18.8+1.9.7` under `libgit2/src/libgit2/`: `repository.c:L997-L999` (the open
  takes a config snapshot, and an error other than not-found leaves the open),
  `:L1316-L1338` (the four levels are added), `:L629-L634` and `:L1172-L1173` (ownership is
  validated on open and `safe.directory` is read from the global config), `sysdir.c:L282`
  (`/etc`), `:L347-L359` (`APP_SANDBOX_CONTAINER_ID` read, and the home taken from the password
  entry when it is set), `:L458-L459` (every level is guessed at init), `:L559-L560` (an empty
  search path leaves before any file is touched), `config_file.c:L117-L123` (an unreadable
  config file is treated as absent), `:L564` (`parse_include`), `config.c:L143-L147`,
  `ignore.c:L362-L364`, `attr.c:L413`, `attrcache.c:L345`. In `git2-0.21.0/src/opts.rs`:
  `:L20-L23` (`set_search_path` is `unsafe`, for global state with no thread safety, and returns
  a `Result`), `:L27` (it initialises the library first), `:L63` (`get_search_path`, which a
  test can read the four levels back with). In the tree at `nozoki@f471a9e`:
  `crates/nozoki-core/Cargo.toml:L9` (`default-features = false`);
  `crates/nozoki-core/src/git_reader/libgit2.rs:L52` (`Repository::open_ext`) and `:L56` (any
  other open error is a failed probe); `grep -rn 'git2\|git_reader\|GitPort' crates/nozoki-bridge/src
  crates/nozoki-bridge/Cargo.toml` prints nothing; `grep -rn unsafe crates/nozoki-core/src`
  prints nothing. Each line says what the item and the answer say it says. Nothing was run:
  no build, no test and no bundle launch belongs to this fold.
  **Where each of the answer's parts landed.** The three proposed edits: § 3's `core-bridge`
  row (*Owns*), the *Four physical units* paragraph, and § 4 C-I3 with *Open Questions*' second
  item. The six additions: (1) the row does not say "and no other" — the paths the repository's
  own config names are stated as not covered there, and § 11 R-16 is new; (2) fail closed and
  once, in the row; (3) the bridge manifest's default features, in the row and in § 4 C-R6 with
  its *Violated by*; (4) the import rule's other statements — § 6 `see-git-status`'s command
  clause, as the answer names it; (5) what the reader sees, in `git-reader`'s row; (6) what the
  evidence does not reach, in C-I3.
  **Five calls the answer left to this seat.** (a) **SM-2 takes the exception too.** Addition 4
  says every statement of the rule moves together and names two. SM-2's "the adapter is the only
  thing that knows libgit2" is a third, and the answer's own reasoning reads it as the meaning
  of the rule (`docs/trail/sdd/self_answer-34.md` § 2.1, *The other readings, weighed*). A
  search of this document for `imports the libgit2`, `libgit2 import` and `only thing that knows
  libgit2` finds those three and no other. (b) **§ 4 C-D3 names the uncovered case.** C-D3 says
  every path derived from content passes the containment check, and a path in the repository's
  config is one that does not. The answer asks for the case to be named at the row and in § 11;
  C-D3 gains one sentence because a limit is stated beside the claim it limits
  (`system/doctrine/writing_bar.md` § 1.6, in the instance repository). C-D3's rule is not
  changed. (c) **When the switch lands.** The answer does not say. C-I3 says: in the change that
  wires the libgit2 adapter in the bridge, which is the first moment a repository can be opened
  through the bridge. (d) **How R-16 is closed is an Open Question and not a companion item.**
  The answer leaves it undecided and gives it to no one. It is a technical question that a
  build settles, so it stands in *Open Questions* with the two forms open. One of the two would
  change what a reader sees, and the item says that form is written into this document before it
  is built. (e) **The Cargo sentence is quoted from Cargo's own page.** The answer states that
  feature unification was its own knowledge and not re-read; C-R6 quotes the page's sentence,
  fetched for this fold.
  **Known limits, stated beside the claims.** No reading shows the open surviving the sandbox,
  with or without the switch; *Open Questions*' second item carries it. The bridge test proves
  four empty paths and observes no read. `nozoki-core`'s in-process Git suites run with the
  reads on. libgit2 still reads `HOME`, `XDG_CONFIG_HOME` and `APP_SANDBOX_CONTAINER_ID` from
  the environment at init (`sysdir.c:L347`, `:L357`, `:L402`); those reads open no file and are
  raised against the NFDR's boundary set at `docs/architecture_open_issues.md` § 2.2. A libgit2
  release that adds a fifth config level is not caught by a test naming four; the lockfile
  change reviewed as code (C-R6) is the only gate. `checks/structure.sh` does not hold the
  import rule outside three units' files today (its header, `:L249-L250`), and changing the
  script for the exception is the design of the change that builds the switch.
  **Downstream, nothing opened by this seat.** `docs/nfdr.md` QC-9, QC-11, QC-13, QC-17 and
  QC-35 re-derive from this document, and `docs/architecture_open_issues.md` §§ 2.1 and 2.2
  already hold the NFDR open for it. `docs/fdr.md` R-153's "an ignored file" reads, after this
  fold, as a file the folder's own rules ignore; that is the FDR seat's to carry and is not
  raised from here (`docs/trail/sdd/self_answer-34.md` § 2.1, *Downstream*).
  **The companion:** `diff docs/SDD_open_issues.md docs/trail/sdd/cycle-22.md` printed nothing
  before this fold's first edit, and the companion matched `nozoki@f471a9e`. Its one item is
  folded and nothing else stands, so `docs/SDD_open_issues.md` is removed and `Status:` returns
  to Settled *(re: § 3 `core-bridge`, `git-reader`, the units paragraph, SM-2; § 4 C-R6, C-I3,
  C-D3; § 6 `see-git-status`; § 11 R-16; Open Questions; source: `docs/trail/sdd/cycle-22.md`
  § 2.1; `docs/trail/sdd/self_answer-34.md`; `nozoki@f471a9e`; `docs/fdr.md` R-101;
  `docs/SRS.md` NFR-7, DR-6)*.
- **RN-88:** *(CTO)* *(changed)* Four statements that the landed `state` and `status` change made
  false or out of date are corrected: § 3 `GitState`, SM-2's row, `see-git-status`'s command half,
  and RN-44. The PM raised the four as companion items on 2026-10-04, after `git-reader` answered
  `state` and `status` and `folder-model` folded the answer into a Git item (`nozoki@6a0725c`). A
  `companion-self-answer` run answered all four in the CTO's seat the same day, each "Take the
  likely fold" with additions (`docs/trail/sdd/cycle-23.md` §§ 5.1 – 5.4; reasoning
  `docs/trail/sdd/self_answer-35.md`). Every item carries `Seat: cto`, so no owner's answer
  stands behind this note. No part, seam, slice's *Delivers*, edge or place in the order moves.
  **What each statement said, and what it says now.**
  (1) § 3 `GitState` said: "The model holds it; whether it is the type the port returns or one
  the model builds from what the port returns is the design of the change that adds `state`". The
  change has chosen. The entity now states that `folder-model` defines `GitState` and builds it
  from what the port returns, and that the port never returns it. The answer's bound is carried:
  the entity does not say the model builds it from `state` and `status` both, because at the
  commit read the model asks `state` alone (`docs/trail/sdd/cycle-23.md` § 5.1).
  (2) SM-2's row said a crossing type "is defined in `git-reader`, or in a module of `nozoki-core`
  that is no part, and which of the two is the design of the change that adds it". The row now
  states where the types that cross today are defined, in `git-reader` beside the trait, and
  keeps the rule for a type a later method brings. The row chooses no home for the types of
  `diff` and `walk`: neither method exists, and the answer declines the choice until a type
  exists (`docs/trail/sdd/cycle-23.md` § 5.2).
  (3) `see-git-status`'s command half said the R-3 case is "injected because the in-process
  harness runs under no sandbox grant and the `linked-worktree` fixture reads fine there". The
  fixture does not read fine there: the adapter refuses it by the path's spelling. The clause now
  gives the double's reason as the answer states it — the case checks the reducer and needs no
  adapter — and says where the adapter's refusal is exercised
  (`docs/trail/sdd/cycle-23.md` § 5.3).
  (4) The same command half and RN-44 said "every tree item `observed`". A folder not yet
  expanded is `pending`, so no tree holding a folder met that wording. Both now state the rule:
  the failed Git read changes the Git item and nothing else, and every tree item stands as it
  was — `observed`, `pending` or `failed` (`docs/trail/sdd/cycle-23.md` § 5.4).
  **What RN-44 said before it was corrected in place.** Its *Because* read: "the
  `linked-worktree` and `submodule` fixtures ran only through `root_finding`, and they cannot
  produce the failure on their own — the harness drives `nozoki-core` in-process (C-I3), under no
  sandbox grant, so libgit2 reads a gitdir outside the opened folder there without complaint; the
  failure R-3 names exists only under the bundle's grant (C-R2)", and "The double is the cheapest
  honest stand-in". Three clauses of the first sentence are false at the commit read: "cannot
  produce the failure on their own", "reads a gitdir outside the opened folder there without
  complaint" and "exists only under the bundle's grant". The item quoted the first two and the
  answer added the third. The full prior text is in this file's history at `nozoki@87f6a48`.
  **Read for this fold, at `nozoki@87f6a48`.** `git diff --stat 22e36c3 HEAD -- crates checks`
  prints nothing, so the code is what the answers read at `nozoki@22e36c3`. In
  `crates/nozoki-core/`: `src/folder_model.rs:L166-L168` (`pub struct GitState` with one field,
  `head: HeadState`) and `:L273-L288` (`read_git` asks `probe`, asks `state` on a root, and
  returns `FolderModel { kind, ..model }`); `src/git_reader.rs:L46-L58` (the trait's three
  methods return `RootFinding`, `HeadState` and `StatusLists`) and the nine public types
  declared from `:L74` to `:L249`; `src/git_reader/libgit2.rs:L79-L81` (`open_verified` calls
  `verified_locations` before `Repository::open_ext`) and `:L129-L142` (`locate_inside` answers
  `GitDirectoryOutside` for a location outside the root); `src/fs_reader.rs:L137` and `:L853` (a
  folder entry is `Pending`); `tests/git_state.rs:L714-L725`
  (`test_linked_worktree_and_submodule_answer_outside_from_both_calls`), `:L929-L931` (the
  double panics if asked `status`), `:L941-L948` (`model_over_files`) and `:L983`
  (`assert_eq!(folded.tree(), &tree_before)`). One command was run:
  `cargo test --locked -p nozoki-core --test git_state` printed "test result: ok. 36 passed; 0
  failed". `docs/SRS.md:L297-L299` (NFR-3) was read.
  **Three calls the answers left to this seat.** (a) **The entity cites the commit.** The
  answer to § 5.1 says a later change that brings `status` into the model re-measures the
  sentence; the entity therefore pins its claim to `nozoki@87f6a48`. (b) **The adapter's side is
  stated in the command half as a fact about the suite, not as a new bar.** The answer to § 5.3
  asks that the fold say where the in-process refusal is exercised. The test that exercises it
  is already in `--test git_state`, which the command half already requires to pass, so the
  clause adds no command. (c) **RN-44's parenthesis is left as written.** It quotes § 4 C-I1,
  "its siblings `observed`", and the answer to § 5.4 leaves it alone because the condition it
  quotes is a companion item of its own.
  **Known limits, stated beside the claims.** The fold claims nothing about the bundle: a
  refusal by spelling shows nothing about the sandbox, and § 11 R-3 and *Open Questions*' second
  item stand as written. Whether libgit2, asked directly with no adapter check before it, reads
  an outside Git directory in-process was not run by the answer or by this fold. This fold read
  the header, § 3, § 4 C-I1, § 6 S-4 and S-5, RN-43 to RN-44, RN-85 to RN-87 and *Open
  Questions* of this document, and searched the rest for the phrases the items quote; §§ 1, 2,
  5, 7 to 12 and the other review notes were not re-read line by line. Of the inputs, the
  status lines of `docs/PRD.md`, `docs/SRS.md` and `docs/UXD.md` were read, and the SRS's NFR-3;
  no answer folded here moves a requirement, a surface or a product statement.
  **Still standing, and not folded.** § 4 C-I1 and `follow-the-folder`'s command half say a
  failed read leaves "`observed` on its siblings", which has the defect (4) corrects.
  `docs/SDD_open_issues.md` § 2.1 holds that as a choice to confirm with its slot empty, raised
  by the run that answered the four items. This fold changes neither sentence: no answer
  authorizes it. Until it is answered, `see-git-status` says "as they were" where the condition
  it cites says "`observed`".
  **Downstream, nothing opened by this seat.** `docs/nfdr.md:L1009-L1010` repeats C-I1's
  wording and re-derives from this document once § 2.1 is decided.
  `docs/adr/0018-root-finding-answers-root-for-a-git-file-and-reads-only-inside-the-folder.md`
  carries a hand-off in the words item § 5.1 quotes; it is a dated record, and the answer raised
  nothing on it (`docs/trail/sdd/self_answer-35.md` § 5.1, *Not raised*).
  **The companion:** `diff docs/SDD_open_issues.md docs/trail/sdd/cycle-23.md` printed nothing
  before this fold's first edit, and the companion matched `nozoki@87f6a48`. The four answered
  items are dropped. § 2.1 stands unanswered, so the companion stays on disk and `Status:` moves
  from Settled to Draft *(re: § 3 `GitState`, SM-2; § 6 `see-git-status` *Reached when*, command
  half; RN-44; source: `docs/trail/sdd/cycle-23.md` §§ 5.1 – 5.4;
  `docs/trail/sdd/self_answer-35.md`; `nozoki@87f6a48`; `docs/SRS.md` NFR-3)*.
- **RN-89:** *(CTO)* *(changed)* § 4 C-I1 and `follow-the-folder`'s command half stop saying that
  a failed read leaves "`observed` on its siblings". Both now state the rule: the failure changes
  that item and no other item. RN-44's parenthesis, which quoted C-I1, follows it. *Because* the
  companion's one item, § 2.1, was answered "confirm — with three additions" by a
  `companion-self-answer` run in the CTO's seat on 2026-10-04 (`docs/trail/sdd/cycle-24.md`
  § 2.1, committed at `nozoki@9c9ee29`; reasoning `docs/trail/sdd/self_answer-36.md` § 2.1). The
  item carries `Seat: cto`, so no owner's answer stands behind this note. No part, seam, slice's
  *Delivers*, edge or place in the order moves.
  **What each sentence said, and what it says now.** The prior text is in this file's history at
  `nozoki@9c9ee29`.
  (1) § 4 C-I1 said a failed read "yields `failed` or `stopped` on that item and `observed` on
  its siblings" (`docs/SDD.md:L686-L687` at that commit). A folder entry not yet expanded is
  `pending`, so no folder holding a folder met the wording. C-I1 now says the failed read
  "changes no other item", and that each sibling holds the state its own read gave it. It names
  all four states § 3 `Item<T>` gives — `observed`, `pending`, `failed`, `stopped` — as the
  answer's first addition asks: C-I1 itself puts `stopped` on an item, and three named states
  would read as a closed list.
  (2) `follow-the-folder`'s command half said "an unreadable entry yields `failed` on that item
  and `observed` on its siblings" (`docs/SDD.md:L1794-L1795` at that commit). It now says the
  failure changes no other item, and each sibling holds the state its own read gave it. It does
  not say the siblings stand "as they were before the read", which is `see-git-status`'s
  wording. The answer's second addition gives the reason: `checks/churn.sh` runs while the
  failed read is in flight, so a sibling changes for its own reasons, and a clause copied from
  `see-git-status` would fail a correct model.
  (3) RN-44's parenthesis said "C-I1: a failure is a state, its siblings `observed`"
  (`docs/SDD.md:L3333` at that commit). It is corrected in place and carries a dated note saying
  so, as the answer directs.
  **One case the answer names and does not decide.** When a folder that is already expanded
  fails on a re-read, the entries listed under it are not its siblings. The answer's third
  addition leaves what happens to them to `follow-the-folder`'s design. C-I1 says so in one
  sentence. **A call of this seat's:** the question is also written into *Open Questions* as
  an eighth item, because that section is where this document records a technical question a
  slice settles, and a reader of C-I1 alone would not learn where the answer lands.
  **Left as written, on the answer's own reading.** `see-git-status`'s sentence lists three
  states as cases of "as they were", and the code it is checked against has three
  (`crates/nozoki-core/src/fs_reader.rs:L129-L133`). The diff slice's clause "the file's tree
  entry still `observed`" names one listed file. C-I1's *Violated by* list is unchanged. RN-88's
  paragraph "Still standing, and not folded" is a dated note about the state before this fold
  and stays as written; this note is where that item closes.
  **Read for this fold, at `nozoki@9c9ee29`.** `git diff --stat bc76311 HEAD -- crates checks`
  prints nothing, so the code is what the answer read. `crates/nozoki-core/src/fs_reader.rs:L853`
  reads `Ok(file_type) if file_type.is_dir() => (EntryKind::Folder, ItemState::Pending)`.
  `docs/SRS.md:L297-L299` (NFR-3) reads "degrades only that item's view". No test was run:
  the fold changes no code, and `--test watch` does not exist yet.
  **Known limits, stated beside the claims.** This fold read the header, § 3 *What the system
  holds*, § 4 C-I1 and C-I2, § 6 `see-git-status`'s command half and `follow-the-folder` whole,
  RN-44, RN-88 and *Open Questions* of this document, and searched the rest for "siblings". §§ 1,
  2, 5, 7 to 12 and the other review notes were not re-read line by line, so a sentence there
  that carries the old meaning in other words was not seen. Of the inputs, the status lines of
  `docs/PRD.md`, `docs/SRS.md` and `docs/UXD.md` were read, with NFR-3 and UX-I10's line; the
  answer moves no requirement, surface or product statement. `ItemState` in the code has three
  arms and no `stopped` (`fs_reader.rs:L129-L133`); C-I1 names four states because § 3 gives
  four, and when the model first holds `stopped` is not something this fold decides.
  **Downstream, not this document's to change.** `docs/nfdr.md` QC-47's *verified by* repeats
  the old wording (`docs/nfdr.md:L1009-L1010`). The change is carried as
  `docs/architecture_open_issues.md` § 2.1, appended at `nozoki@f0789a6`, for the Principal
  Architect's records to fold. Until then the NFDR's clause differs from the condition it
  traces to, and § 4's statement is the one that holds.
  **The companion:** `diff docs/SDD_open_issues.md docs/trail/sdd/cycle-24.md` printed nothing
  before this fold's first edit, and the companion matched `nozoki@9c9ee29`. Its one item is
  folded and nothing is unresolved, so `docs/SDD_open_issues.md` is removed and `Status:` moves
  from Draft to Settled *(re: § 4 C-I1; § 6 `follow-the-folder` *Reached when*, command half;
  RN-44; *Open Questions*; source: `docs/trail/sdd/cycle-24.md` § 2.1;
  `docs/trail/sdd/self_answer-36.md` § 2.1; `nozoki@9c9ee29`; `docs/SRS.md` NFR-3)*.
- **RN-90:** *(CTO)* *(changed)* SM-4's list gains a tenth call, `read_git`, and § 10 gains RC-4.
  The companion's one item is folded: raised from downstream by the PM and answered in the CTO's
  seat (`docs/trail/sdd/cycle-25.md` § 5.1; reasoning `docs/trail/sdd/self_answer-37.md`). The
  owner chose the route — amend this document first — over carrying the item on `open_folder`'s
  return or holding the delivery back (same item, *The route the owner chose*).
  **What the answer decides.** A Git-named call on SM-4's list, `read_git`, exported as
  `nozoki_read_git`, and not the `model_changed` registration call. *Because* `see-git-status`
  has nothing to push: its fence says the Git view shows "the state read when the folder
  opened", so a pull call whose answer is its return is the shape the three landed calls already
  have (`crates/nozoki-bridge/src/exports.rs:L55`, `:L73`, `:L90`), and it is a command, so the
  harness walks it (§ 4 C-I3). A registration call is no command, and admitting it here would
  build `follow-the-folder`'s delivery ahead of that slice, against C-R7's "by the slice that
  needs it, and not before".
  **What moved, each named.** (1) § 3 SM-4: `read_git` joins the list with what it takes and
  answers; "all nine from `v1.0.0`" reads "all ten", and "the nine calls" reads "the ten calls".
  (2) § 6 `see-git-status` *Rests on*: "`SM-4` (`read_git`; § 10 RC-4)" in place of "`SM-4`
  (`model_changed` carrying Git state)". (3) § 6 `promise-one-point-zero`'s command half:
  "SM-4's ten functions" in place of "nine". (4) *Open Questions*, the collapse-and-scroll item:
  "SM-4's ten calls", "C-I6's ten" and "an eleventh call", with a dated note. (5) § 10 RC-4,
  new, in the CTO's seat: that item already said a call the list does not name "is a re-cut,
  recorded in § 10 before it is built", and this is the first.
  **Left as written.** § 4 C-R7 and C-I6 read SM-4's list by reference and keep every word. The
  `core-bridge` row's "the `model_changed` callback", SM-4's upward half and `follow-the-folder`'s
  *Rests on* stand: the callback is that slice's. § 10 RC-3's "`asset_bytes` its ninth function"
  and the review notes that say "nine" (RN-66, RN-77 among them) are dated records, true when
  written, and are not corrected. No slice's *Delivers*, *Reached when*, § 7 edge or order moves.
  **A call of this seat's:** `read_git` sits between `open_relative_link` and `set_theme`, where
  the list's order by slice puts `see-git-status`'s call. The order of the names binds nothing:
  C-R7 holds a set.
  **Not decided by the answer, and not here.** RC-4's *Still unresolved* lists the four: when the
  model reads Git state and whether a `failed` item is asked again; which side orders two asks in
  flight; where the Git view's reading state is drawn from; and the three things already tied to
  the first export reaching `git-reader`.
  **Read for this fold, at `nozoki@ca915a4`.** The sites RC-4 cites were opened and each reads as
  cited. `grep -rn model_changed crates nozoki-mac/Sources` printed nothing. No test was run: the
  fold changes no code.
  **Known limits, stated beside the claims.** This fold read the header, the `core-bridge`,
  `mac-shell`, `surfaces` and `read-only-harness` rows and the seams table of § 3, § 4 C-R7 and
  C-I1, § 6 S-4, S-5 and S-11, § 10, § 11 R-13 to R-16, § 12's downstream boundary and *Open
  Questions*; it read § 4 C-I3 and C-I6, RN-66, RN-77 and RN-89 in part, where they name SM-4,
  the exports or `git-reader`; and it searched the rest for "nine", "ninth", "tenth",
  "model_changed", "read_git" and "registration". §§ 1, 2, 5, 7 to 9 and the other review notes
  were not re-read line by line, so a sentence there that counts the list in other words was not
  seen. Of the inputs, the status lines of `docs/PRD.md`, `docs/SRS.md` and `docs/UXD.md` were
  read and their bodies were not: the answer moves no requirement, surface or product statement.
  `docs/nfdr.md` and the decision log were searched for "nine" and SM-4's list, and read only
  where the search landed.
  **Downstream, not this document's to change.** ADR-0013 quotes the nine names and "all nine
  from `v1.0.0`" (`docs/adr/0013-sandboxed-single-process-read-pipeline.md:L44-L47`), and
  `docs/nfdr.md` names SM-4's list (`docs/nfdr.md:L75`). Both are the Principal Architect's to
  bring into line, and this fold raised no item on that seat's companion. Until they move, § 3's
  list is the one that holds (§ 4, opening note).
  **The companion:** `diff docs/SDD_open_issues.md docs/trail/sdd/cycle-25.md` printed nothing
  before this fold's first edit, and the companion matched `nozoki@ca915a4`. Its one item is
  folded and nothing is unresolved, so `docs/SDD_open_issues.md` is removed and `Status:` stays
  Settled *(re: § 3 SM-4; § 6 `see-git-status` *Rests on*; § 6 `promise-one-point-zero` *Reached
  when*, command half; § 10 RC-4; *Open Questions*; source: `docs/trail/sdd/cycle-25.md` § 5.1;
  `docs/trail/sdd/self_answer-37.md`; `nozoki@ca915a4`)*.
- **RN-91:** *(CTO)* *(changed)* Four statements that were true of the tree before the bridge
  served Git are corrected to the tree as it stands, and one bound that passed unmet is moved.
  The companion's four items are folded: raised from downstream by the PM after the build at
  `nozoki@392177d`, and answered in the CTO's seat by an unattended run
  (`docs/trail/sdd/cycle-26.md` §§ 5.1 to 5.4; reasoning `docs/trail/sdd/self_answer-38.md`).
  Each is a dated correction. None is a § 10 re-cut: no slice's *Reached when*, *Delivers*,
  § 7 edge or order moves, and § 2's shape and § 3's seams keep their words.
  **What moved, each named.** (1) § 3 `GitState` (5.1): the model holds the port's `HeadState`
  and its `StatusLists`, built from one read. The sentence "the changed and staged entries this
  entity lists are the design, and no landed change puts them in the model" is removed. The
  entity gains what a failed half does, and which of its listed things are still only the
  design. (2) § 4 C-I3, the third thing no check holds (5.2): "How those suites are isolated is
  the design of the change that builds the switch" is removed. In its place: that change
  isolated nothing, the walk is a third caller with the reads on, where the bundle's answers
  are proved, and what raises the isolation. (3) § 4 C-I3, the transport read (5.3): "The read
  is not in the script at `nozoki@814a369`", "until that build the claim is stated and not
  proved" and "no bridge function names `git-reader`" are removed. In their place: where the
  read is, and the one executable the claim is proved for. (4) § 4 C-I3 and C-R6 (5.2,
  addition (c)): the switch, its test and the bridge manifest's `git2` line are stated as in
  the tree. (5) § 4 C-R6 (5.3, addition (c)): three defined symbols the read's pattern does not
  match are named beside "The three names are a floor". (6) § 11 R-15 (5.3, addition (b)): "has
  not been measured on this product" is replaced by the measurement, and *shows up as* names
  the build that links the export. R-15 stays open. (7) § 10 RC-4 *Still unresolved* (5.3,
  addition (d)): its words stay and it gains a dated parenthesis, the form RC-2's and RC-3's
  took. (8) *Open Questions*, the config-named-path item, and § 11 R-16 (5.4): the bound is the
  build in which `mac-shell` first calls `nozoki_read_git`, with a dated note that the first
  bound passed unmet. R-16's fixture sentence is re-pinned.
  **Why the bound moved to that build.** The first bound was taken to be the moment a
  repository is first opened through the bridge. The build showed two moments: the export
  exists, and nothing calls it. The first build in which the shell calls the export is the
  first in which a reader's repository reaches libgit2 in the bundle. Which of the two forms
  closes R-16 is not chosen by the answer and is not chosen here.
  **Where this fold departs from the answer's words.** The answer to 5.3 gives 731 defined
  `_git_` symbols and states no method. This fold counted 781 on the same executable, with the
  command C-I3 now carries, so C-I3 states 781 with its method and not 731. The findings the
  answer rests on are the same under either count: both named symbols are present, no
  `git_smart_subtransport_` symbol is, and none of the three imports is. The answers pin
  `nozoki@0aab3e7`; the fold pins what it re-read at `nozoki@a7834f4`, the commit it was made
  on. `git diff --stat 0aab3e7 a7834f4` names `docs/SDD_open_issues.md` and
  `docs/trail/sdd/self_answer-38.md` and no other file.
  **Found on the same walk, and fixed.** § 11 R-16 named its item "the last item of *Open
  Questions*". It stopped being the last when RN-89 added the failed-re-read item. R-16 and
  RC-4's parenthesis name it "the config-named-path item".
  **Read and measured for this fold, at `nozoki@a7834f4`.** Opened, and each reads as cited:
  `crates/nozoki-core/src/folder_model.rs:L164-L182` and `:L262-L310`; `checks/walk.rs:L288-L294`;
  `checks/view.sh:L376-L406`; `checks/tests/test_view.sh:L56-L65`;
  `crates/nozoki-bridge/Cargo.toml:L20-L24`; `crates/nozoki-bridge/tests/search_path.rs:L30-L48`;
  `crates/nozoki-bridge/src/exports.rs:L98-L106`; `crates/nozoki-bridge/src/session.rs:L646-L654`;
  the first lines of `tests/git_item.rs` and `tests/read_git_export.rs`. The four greps this
  note's sections quote were run and printed nothing. `nm` was run on
  `target/release/bundle/macos/Nozoki.app/Contents/MacOS/Nozoki` as it stood on disk, modified
  2026-10-04 08:20.
  **Known limits, stated beside the claims.** This fold built nothing and ran no test and no
  `checks/` script. That the executable on disk is the one the answering run built at
  `nozoki@0aab3e7` rests on that run's report (`docs/trail/sdd/self_answer-38.md:L26-L30`) and
  on the file's time, and was not otherwise shown. `checks/view.sh` exiting 0 on it, and
  `cargo test --locked -p nozoki-bridge --test search_path` passing, are that run's
  measurements (`:L24-L27`). Of this document, the fold read the header, § 3's `GitState`,
  § 4 C-R6 and C-I1 to C-I3, § 10 RC-4, § 11 R-15 and R-16, RN-90 and *Open Questions*, and
  searched the rest for `f471a9e`, "not in the tree", "not in the script" and "last item of".
  §§ 1, 2, 5 to 9 and the other review notes were not re-read, so a sentence there that states
  one of these landed things as still to come was not seen. Of the inputs, the status lines of
  `docs/PRD.md`, `docs/SRS.md` and `docs/UXD.md` were read and their bodies were not: no answer
  moves a requirement, a surface or a product statement. `docs/nfdr.md` was read at its status
  line, and the decision log was not opened.
  **Downstream, not this document's to change.** `docs/nfdr.md` restates § 4's conditions, and
  where an entry repeats one of the sentences removed here it is the Principal Architect's to
  re-derive (§ 4, opening note). This fold did not search for such an entry and raised no item
  on that seat's companion; `docs/architecture_open_issues.md` was already on disk at
  `nozoki@0aab3e7` and was not read.
  **The companion:** `diff docs/SDD_open_issues.md docs/trail/sdd/cycle-26.md` printed nothing
  before this fold's first edit, and the companion matched `nozoki@a7834f4`. Its four items are
  folded and nothing is unresolved, so `docs/SDD_open_issues.md` is removed and `Status:` stays
  Settled *(re: § 3 `GitState`; § 4 C-R6, C-I3; § 10 RC-4 *Still unresolved*; § 11 R-15, R-16;
  *Open Questions*; source: `docs/trail/sdd/cycle-26.md` §§ 5.1 to 5.4;
  `docs/trail/sdd/self_answer-38.md`; `nozoki@a7834f4`)*.
- **RN-92:** *(CTO)* *(changed)* The config-named-path item's bound moves a second time, and
  this time no build is named in its place. The companion's one item is folded: raised from
  downstream by the PM and answered in the CTO's seat by an unattended run
  (`docs/trail/sdd/cycle-27.md` § 5.1; reasoning `docs/trail/sdd/self_answer-39.md`). It is a
  dated correction and not a § 10 re-cut: no slice's *Reached when*, *Delivers*, § 7 edge or
  order moves, and § 2's shape and § 3's seams keep their words.
  **Who authorized it.** The item records that the owner chose on 2026-10-04 to move the
  bound, over settling the item in or before the build that first calls the export and over
  waiving the bound at that build's review (`docs/trail/sdd/cycle-27.md` § 5.1, *The route the
  owner chose*). This fold did not see the owner's words. It rests on the PM's record of them
  in that item and in the commit that opened the companion (`nozoki@78e823a`).
  **What moved, each named.** (1) *Open Questions*, the config-named-path item: the clause "no
  later than the build in which `mac-shell` first calls `nozoki_read_git`, which is the first
  build whose release executable links that export, and in every case" is removed, and the
  bound is "before the slice is reached" alone. "It is held by review of the change that makes
  the shell call the export" is removed. In its place: the bound is held by review of the
  change after which `see-git-status`'s *Reached when* is claimed whole, and a slice claimed
  without the fixture and its case is not reached. The item gains what a reader can meet in
  the builds between, and a second dated note after the first. (2) § 11 R-16: the same bound,
  and the same builds between. (3) § 10 RC-4 *Still unresolved*: the first parenthesis keeps
  its words and a second dated parenthesis follows it.
  **Why no later build is named.** This is reasoning, and it is the answer's. This document
  can name a build only by what it does. The two builds it named for this item were the one
  that first exports a function reaching `git-reader`, which landed at `nozoki@392177d` with
  the item open, and the one in which the shell first calls the export, which the owner chose
  not to hold to it. A third named build is a third bound of the same kind. "Before the slice
  is reached" cannot pass unmet while the slice is called reached, so nothing has to notice a
  missed build.
  **A call of this seat's: the bound stays held by review, not by a command.** The answer
  names a stronger form and leaves it to this fold: adding the fixture and its case to § 6 S-4
  *Reached when*, command half (`docs/trail/sdd/self_answer-39.md:L83-L87`). This fold does
  not take it. Which of the two forms closes the item is still open, and the case's command
  and its expected result differ by form, so a command written now would be written before the
  thing it checks is designed. § 10 also admits a change to a *Reached when* on four triggers,
  and none holds here. When a form is found, the change that builds it writes its case, and
  whether that case joins S-4's command half is decided then, as a § 10 entry.
  **What the builds between hold, stated beside the claim.** R-16 already said the read is "a
  stated limit of § 4 C-D1 outside the sandbox, not a held property". That sentence keeps its
  words. What changes is how long it applies: from the first build in which the shell calls
  the export until the item is settled, and no longer only until that first build. In those
  builds the sandbox is the only bound, and whether libgit2's open or status read survives
  its refusal has not been run by any fold, this one included.
  **What does not move.** Which of the two forms closes the item; what settles it; the rule
  that the second form is written into `git-reader`'s row and § 11 R-16 before it is built;
  § 4 C-I3's and § 11 R-15's sentences naming the build in which the shell first calls the
  export, which are about the `nm` transport read and a different risk. RN-91's sentence
  naming the second bound, and RC-4's first parenthesis, are dated records and are not
  corrected.
  **Read and measured for this fold, at `nozoki@b780d58`.**
  `grep -rn 'nozoki_read_git\|read_git\|readGit' nozoki-mac/Sources` printed nothing, and so
  did `grep -rn 'include.path\|excludesfile\|attributesfile' checks/fixtures`.
  `grep -n -E 'no later than|before the slice is reached|held by review' docs/SDD.md` was run
  before the first edit. Outside the three places above it printed three lines, and none
  states this item's bound: § 4 C-I3 and RN-76 on the walk's match with the export set, and
  RN-85 on the build that owes the `nm` read.
  **Known limits, stated beside the claims.** This fold built nothing and ran no test and no
  `checks/` script: it changes no code. Of this document it read the header, *Who holds what*,
  § 6 S-4, the head of § 10 and RC-4, § 11 R-14's tail to R-16, RN-89's tail to RN-91 and *Open
  Questions*, and searched the rest with the grep above and for `nozoki_read_git`. §§ 1 to 5,
  7 to 9 and 12 and the other review notes were not re-read, so a sentence there that states
  the old bound in other words was not seen. Of the inputs, the status lines of `docs/PRD.md`,
  `docs/SRS.md` and `docs/UXD.md` were read, each Settled, and their bodies were not: the
  answer moves no requirement, surface or product statement. `docs/nfdr.md` was read at its
  header and at the two entries named next, and the decision log was not opened.
  `<CORE>/templates/product-templates/sdd_template.md` was not re-read against this document.
  **Downstream, not this document's to change.** `docs/nfdr.md` QC-6 and QC-35 state the bound
  this fold removes, as "settled no later than the build in which `mac-shell` first calls
  `nozoki_read_git`" (`docs/nfdr.md:L248-L249`, `:L938-L940`, read at `nozoki@b780d58`). The
  change is carried as `docs/architecture_open_issues.md` § 2.1, opened at `nozoki@250fc6e`,
  for the Principal Architect's records to fold. Until then the two entries differ from this
  document. The NFDR derives this bound from this document and does not set it, so the bound
  stated here is the current one; § 4's opening note states that direction for the two stores,
  "downstream is rebuilt from upstream, never the reverse".
  **The companion:** `diff docs/SDD_open_issues.md docs/trail/sdd/cycle-27.md` printed nothing
  before this fold's first edit, and the companion matched `nozoki@b780d58`. Its one item is
  folded and nothing is unresolved, so `docs/SDD_open_issues.md` is removed and `Status:` stays
  Settled *(re: *Open Questions*, the config-named-path item; § 10 RC-4 *Still unresolved*;
  § 11 R-16; source: `docs/trail/sdd/cycle-27.md` § 5.1; `docs/trail/sdd/self_answer-39.md`;
  `nozoki@b780d58`)*.
- **RN-93:** *(CTO)* *(changed)* Two statements that the `nm` transport read had not met an
  executable linking the `nozoki_read_git` export are replaced by the measurement, and § 11
  R-15 is kept. The companion's two items are folded: raised from downstream by the PM after
  the shell began calling the export at `nozoki@129586e`, and answered in the CTO's seat by an
  unattended run (`docs/trail/sdd/cycle-28.md` §§ 5.1, 5.2; reasoning
  `docs/trail/sdd/self_answer-40.md`). Each is a dated correction. Neither is a § 10 re-cut: no
  slice's *Reached when*, *Delivers*, § 7 edge or order moves, and § 2's shape and § 3's seams
  keep their words.
  **What moved, each named.** (1) § 4 C-I3, the transport-read sentences (5.1): "It has not met
  one that links the `nozoki_read_git` export: the same `nm` output holds no
  `_nozoki_read_git`, and no Swift source calls it" and "The read runs on every build, so it
  meets that executable in the build where `mac-shell` first calls the export, with nothing
  further owed" are removed. In their place: the second executable the read has met, its
  figures, and where the read ran. "The claim is proved for one executable" becomes "for each
  executable the read has met, and for no later one until the read meets it" (5.1, addition
  4). The first executable's figures stay, in the past tense, as a dated earlier measurement.
  (2) § 4 C-R6 (5.1, addition 3): the three defined symbols the pattern does not match are
  pinned to the second executable. (3) § 11 R-15 (5.2): "That executable does not link the
  `nozoki_read_git` export, which no Swift source calls, so the build that links the export
  has not been read and this risk is not closed" is removed. In its place: the build has been
  read and passes, the passes are local, and the risk is kept with the three things the pass
  depends on. *Shows up as* named "the first release build whose executable links a Git
  export"; it now names a red read on any release build. *Response* read "a re-cut recorded
  in § 10 before anything is built on that export"; it now holds the change whose build turns
  the read red until the re-cut is recorded. R-15's last two sentences keep their words.
  **Why R-15 is kept.** This is reasoning, and it is the answer's. § 11's rule is "A risk with no
  trigger and no response is an observation", and R-15 still has both. The pass rests on the linker leaving out code the
  vendored library compiles whatever the features (§ 4 C-R6), and three later changes can
  move that: the `libgit2-sys` version, the release link, and the libgit2 code the product
  calls. Whether a risk stays listed changes no claim the product makes, so it is this seat's
  call. Lowering the claim itself stays the owner's (`docs/fdr.md` PD-27, as R-15 quotes it).
  **Where this fold departs from the answer's words.** The answer gives the response as "the
  change whose build turns the read red does not land until the re-cut is recorded in § 10"
  and allows the fold its own wording; the fold keeps that substance. The answer says
  "`see-git-status` is not reached yet". This fold did not check that slice's state and R-15
  does not carry the sentence; it carries what § 3 `GitState` states, that the history window
  and the `Diff` are in no landed change. The answer measured `main` 214 commits ahead of
  `origin/main`; this fold measured 216 at `nozoki@cc3a63f` and C-I3 states 216.
  **Read and measured for this fold, at `nozoki@cc3a63f`.**
  `git diff --quiet 129586e cfcbedf -- . ':!docs'` and the same against `HEAD` each exit 0.
  `nozoki-mac/Sources/Nozoki/NativeBridge.swift:L26` reads `adopt(nozoki_read_git())`.
  `.github/workflows/ci.yml:L41` runs `nozoki-mac/assemble.sh` and `:L51` runs
  `checks/view.sh`. On `target/release/bundle/macos/Nozoki.app/Contents/MacOS/Nozoki` as it
  stood on disk, modified 2026-10-04 15:02: the `nm` figures C-I3 and C-R6 now carry, and
  `checks/view.sh`, which exited 0 printing the line C-I3 quotes. `gh run list --commit
  129586e` printed nothing, and the newest run `gh run list` printed is dated 2026-10-02.
  **Known limits, stated beside the claims.** This fold built nothing. That the executable on
  disk is the one the answering run built from the tree at `nozoki@129586e` rests on that
  run's report (`docs/trail/sdd/self_answer-40.md:L30-L34`) and on the file's time.
  `checks/tests/test_view.sh` was not run, by the answering run or by this fold. The read has
  run on no hosted runner. Of this document the fold read the header, *Who holds what*, § 3
  `GitState`'s closing sentences, § 4 C-R6 and C-I3, § 10 RC-4 *Still unresolved*, § 11 R-14's
  tail to R-16, RN-91, RN-92 and *Open Questions*, and searched the rest for
  `nozoki_read_git`, "no Swift source", "has not met", "has not been read", "not closed", "one
  executable" and "on one build". The other sections were not re-read, so a sentence there
  that states either claim in other words was not seen. Of the inputs, the status lines of
  `docs/PRD.md`, `docs/SRS.md` and `docs/UXD.md` were read, each Settled, and their bodies were
  not: neither answer moves a requirement, a surface or a product statement. `docs/nfdr.md`
  was read at its status line, and the decision log was not opened.
  **What does not move.** § 10 RC-4 *Still unresolved* ties the `nm` read to the first export
  that reaches `git-reader` and says nothing of the calling build. *Open Questions*'
  config-named-path item and § 11 R-16 speak of the builds from the first in which the shell
  calls the export, which is still true now that the build exists. RN-91's and RN-92's
  sentences on the calling build are dated records and are not corrected.
  **Found on the same walk, and not fixed.** This document's `**Owner:**` line and its *Who
  holds what, inside one run* section carry the wording of an earlier template. The current
  one (`<CORE>/templates/product-templates/sdd_template.md` § *Who decides what*, version
  5.1.0) words the same split as one CTO run with the CPO's and the CDO's calls decided
  through the companion. The table's rows and seats are the same in both. Later notes cite
  the section by its present name, and this fold did not read the document whole, so the
  rewording is left for a run that does, on an item that bounds it.
  **Downstream, not this document's to change.** `docs/nfdr.md` QC-3 repeats C-I3's removed
  sentences and quotes R-15's former response (`docs/nfdr.md:L164-L167`, `:L170-L171`, as
  `docs/architecture_open_issues.md` § 3.1 cites them). That item is open on the Principal
  Architect's companion, and its second half is owed from this fold on. Until that seat's
  records fold it, QC-3 differs from this document, and § 4's opening note says which wins.
  **The companion:** `diff docs/SDD_open_issues.md docs/trail/sdd/cycle-28.md` printed nothing
  before this fold's first edit, and the companion matched `nozoki@cc3a63f`. Its two items are
  folded and nothing is unresolved, so `docs/SDD_open_issues.md` is removed and `Status:` stays
  Settled *(re: § 4 C-R6, C-I3; § 11 R-15; source: `docs/trail/sdd/cycle-28.md` §§ 5.1, 5.2;
  `docs/trail/sdd/self_answer-40.md`; `nozoki@cc3a63f`)*.
- **RN-94:** *(CTO)* *(changed)* `folder-model` stays the owner of the tree's changed marker
  and is named the owner of the Git lists' row order. For `see-git-status` alone both stand in
  `surfaces`, under four bounds and an end in `follow-the-folder`, and § 10 gains RC-5. The
  companion's two items are folded. The owner opened that companion on 2026-10-04 with no
  lean recorded, and an unattended run answered both in the CTO's seat
  (`docs/trail/sdd/cycle-29.md` §§ 5.1, 5.2; reasoning `docs/trail/sdd/self_answer-41.md`).
  **What moved, each named.** (1) § 3, the `surfaces` row, *Owns*: one clause is added after
  the exception, beginning "Held here for `see-git-status` alone". The row's earlier words
  stand. (2) § 3 *What the system holds*, `GitState`: eight sentences are added after RN-91's.
  `FolderModel`'s sentence stands, and so does "the tree's changed marker" among the things in
  no landed change. (3) § 6 S-4 *Rests on*: "`folder-model` (`kind` resolved; `GitState`; the
  tree's markers), `surfaces` (the rail's Git entry, the Git view)" becomes "`folder-model`
  (`kind` resolved; `GitState`), `surfaces` (the rail's Git entry, the Git view, and in this
  slice the tree's markers and the Git lists' row order, …)". (4) § 6 S-5 *Rests on*: the
  `folder-model` parenthesis gains the marker and the ordered lists, and "`model_changed`
  deltas" gains "which bring the marker to a row already drawn". (5) § 6 S-5 *Reached when*,
  the command half: one clause is added between "reading position surviving" and "an
  unreadable entry", a model case and a `grep`. The observable half is the CDO's and keeps
  its words. (6) § 10 RC-5, new.
  **Why, in short.** This is reasoning, and it is the answer's. A row's status letter and a
  list's order are projections, and § 3 gives "the projections the surfaces draw" to
  `folder-model`. Logic in the shell is out of the harness's reach, because the harness calls
  the model with no window (SM-5), and S-5's command half compares the model's snapshot. The
  join still stands in the shell for this slice because no path from the core reaches a row
  already drawn until `model_changed` is registered, which RC-4 holds back to
  `follow-the-folder`. § 7 places `first-public-release` after `follow-the-folder`, so no
  public release carries either file in the shell. The full argument, the failure paths and
  what would have tipped it the other way are in `docs/trail/sdd/self_answer-41.md`.
  **Where this fold departs from the answer's words.** The answer lets the fold word each of
  its eight points differently. Five departures. The answer puts "the order has one
  implementation, in the core" in the `folder-model` row or beside it; the fold puts it in
  `GitState` and leaves that row's cell as it was. The answer says the order rule "is the
  FDR's and the sealed spec's"; the answering run's own search of `docs/fdr.md` found no rule
  for the Git lists (`docs/trail/sdd/self_answer-41.md:L219-L221`), so `GitState` says only
  that this document states no order rule. The answer gives the red clause as "for example
  that `nozoki-mac/Sources` holds no `TreeMarkers`"; the fold writes the `grep` as typed and
  names both files. The fold adds the sentence that a re-cut of `follow-the-folder` owes the
  clause a new end, which the answering run listed as not covered (`:L147-L148`). And RC-5's
  *Still unresolved* sends a measured difference between the two orders to this document's
  companion; the answering run said it would then have asked for the move in the next change
  that opens `crates/`, and when a move is made is the PM's.
  **Read and measured for this fold, at `nozoki@b640345`.** `git status --short` printed
  nothing before the fold's first write, so the companion's answers were committed.
  `git show 6c49d5c:nozoki-mac/Sources/Surfaces/TreeMarkers.swift` prints the 68-line join,
  and `git merge-base --is-ancestor 6c49d5c HEAD` fails. `git merge-base --is-ancestor d65eec4
  HEAD` succeeds, and `nozoki-mac/Sources/Surfaces/GitRowOrder.swift:L1-L20` reads as RC-5
  cites it. `grep -rn model_changed crates nozoki-mac/Sources` and `grep -n marker
  crates/nozoki-core/src/folder_model.rs` each print nothing.
  `crates/nozoki-core/src/git_reader.rs:L121`, `crates/nozoki-core/src/fs_reader.rs:L818-L832`
  and `crates/nozoki-bridge/src/session.rs:L279-L280` read as the answering run quotes them.
  **Known limits, stated beside the claims.** This fold built nothing and ran no test. The
  `grep` in S-5's command half finds the two files by name. A join or an order rebuilt in the
  shell under another name passes it, and only the model case beside it and review catch
  that. No file states which script runs the `grep`; that is the design of the change that
  makes the move. Of this document the fold read the header's first lines, *Who holds what*,
  § 2 and § 3 whole, § 4 C-I1 and C-E1, § 6 S-4 and S-5, § 7, § 10's opening note and RC-4,
  RN-93 and *Open Questions*, and searched the rest for `marker`, `row order`, `GitRowOrder`,
  `TreeMarkers` and `order key`. The other sections were not re-read, so a sentence there
  that gives the marker or the order an owner in other words was not seen. Of the inputs, the
  status lines of `docs/PRD.md`, `docs/SRS.md` and `docs/UXD.md` were read, each Settled, and
  their bodies were not: neither answer moves a requirement, a surface or a product
  statement. The project's Agari, its two doctrine files and the instance's writing bar were
  read whole. `docs/nfdr.md`, `docs/fdr.md` and `docs/adr/` were searched and not read.
  **What does not move.** § 4 C-I1 and C-E1 keep their words, and the join meets both: it
  marks only from a repository answer (`TreeMarkers.swift:L16-L24`, at `nozoki@6c49d5c`). No
  § 11 risk is added. A placement with a named owner and a named end is a debt on a slice, and
  § 11's rule asks a risk for a trigger and a response. No *Open Questions* item is added or
  changed. The record of the change that landed `GitRowOrder` is not this document's and is
  not touched.
  **Found on the same walk, and not fixed.** RN-93's finding stands: the `**Owner:**` line
  and *Who holds what, inside one run* carry an earlier template's wording, and this fold did
  not read the document whole either.
  **Downstream, not this document's to change.** `docs/nfdr.md` QC-48 restates S-5's command
  half without the new clause (`docs/nfdr.md:L1090-L1094`). `docs/nfdr.md`'s layer-4 row reads
  the `surfaces` row "with the one exception" (`docs/nfdr.md:L1291`), which is still true.
  Both are the Principal Architect's, and this fold opened no item on that seat's companion.
  Until QC-48 is re-derived it differs from S-5's command half.
  **The companion:** `diff docs/SDD_open_issues.md docs/trail/sdd/cycle-29.md` printed nothing
  before this fold's first edit to this document. Its two items are folded and nothing is
  unresolved, so `docs/SDD_open_issues.md` is removed and `Status:` stays Settled *(re: § 3
  `surfaces`, `GitState`; § 6 `see-git-status`, `follow-the-folder`; § 10 RC-5; source:
  `docs/trail/sdd/cycle-29.md` §§ 5.1, 5.2; `docs/trail/sdd/self_answer-41.md`;
  `nozoki@b640345`)*.
- **RN-95:** *(CTO; the CPO's and the CDO's columns named below)* *(changed)* `see-git-status`
  delivers the status letter's expansion and is not reached without it, and `GitState` says
  the tree's marker join is on `main`. The companion's two items are folded. The PM opened
  that companion on 2026-10-04, and an unattended run answered both in the CTO's seat
  (`docs/trail/sdd/cycle-30.md` §§ 5.1, 5.2; reasoning `docs/trail/sdd/self_answer-42.md`).
  **What moved, each named.** (1) § 3 *What the system holds*, `GitState`: the sentence "The
  join that produces it is built in the shell, at a commit that is not on `main`" is replaced
  by one saying the join is in the shell and on `main` from `nozoki@67d103d`, under the
  `surfaces` row's four bounds. (2) § 4 C-E8: one sentence is added before *Violated by*,
  and *Violated by* gains two cases. (3) § 6 S-4 *Delivers*: "and a changed file's row opening
  that file to read" becomes "a changed file's row opening that file to read, and the pointer
  resting on a status letter showing the row's name and the letter's meaning in words". (4)
  § 6 S-4 *Reached when*, observable half: one sentence is added before "They click a changed
  file's row". (5) § 6 S-4 *Reached when*, command half: one `swift test` clause is added
  before *The promise clause*. (6) § 6 S-4 *Rests on*: the `surfaces` parenthesis gains the
  tooltip and its six words in the message catalogue. (7) § 6 S-5 *Reached when*, observable
  half: one sentence is added before "The script runs `git init`".
  **Whose columns, and what settled each.** (1), (5) and (6) are the CTO's. (3) is the CPO's
  field. It is settled by the owner's decision that the tooltip is in v1
  (`docs/DESIGN.md` § DESIGN Review Notes, `:L990-L992`: "i think that tooltips should be
  included in v1", recorded "as a v1 decision rather than a one-off exception") and by
  `docs/fdr.md` R-38. (2), (4) and (7) are the CDO's clauses. They are settled by
  `docs/DESIGN.md` § Components, "The tooltip" (`:L644-L656`), which gives the tooltip one
  home, "a status letter, wherever one is drawn — the tree and the Git view", has it carry
  "the file's name and the letter's word, in that order", and has it leave "the moment the
  pointer leaves the letter or a refresh changes the row's state"; and by `docs/CONTENT.md`
  § Accessibility of text (`:L423-L433`), which gives the six words. This run found no call
  in either seat's column that those documents leave open, so no item is raised for the CPO
  or the CDO.
  **Why this slice. This is reasoning, and it is the answer's.** `see-git-status` is the
  slice that first draws the letters, in the tree and in the Git view. The row's name and
  its status category already reach `surfaces` in the projections it draws
  (`nozoki-mac/Sources/Surfaces/GitItem.swift:L54-L62`, the six categories), the words go in
  the catalogue `surfaces` owns, and no part, seam or SM-4 call is added, so § 7 gains no
  edge. A slice of its own would deliver a tooltip with no letter to rest on. The refresh half
  is stated in `follow-the-folder` because in `see-git-status` the Git view shows the state
  read when the folder opened, and no refresh changes a row there.
  **An omission restored, and no § 10 entry.** This document carried the clause before it
  was re-authored (`nozoki@70a879a:docs/SDD.md:L436-L439`, § 4 C-E6: "a status letter's
  expansion is raised by the letter, as the tooltip, and nowhere else"), and `docs/fdr.md`
  R-38 (`:L93`) traces to "SDD § 4 C-E8", which now carries it again. None of § 10's four
  triggers holds: S-4's *Reached when* could be met as written, no slice became a fragment, a
  slice can still be started, and the PRD, the SRS and the UXD did not change.
  **Where this fold departs from the answer's words.** Three departures. The answer has C-E8
  cite "`docs/CONTENT.md` § Terminology"; the six words stand under § Accessibility of text
  (`docs/CONTENT.md:L411`, the heading; `:L423-L426`), so both C-E8 and S-4 cite that section.
  The answer's command half says "a `swift test` case in `nozoki-mac`"; the fold writes the
  command as this document types it elsewhere, `swift test --package-path nozoki-mac`. The
  answer names five edits and a sentence for `follow-the-folder`'s observable half "where it
  is stated"; that sentence was not yet stated there, and this fold writes it as (7).
  **Read and measured for this fold, at `nozoki@6dc3cdf`.** `git status --short` printed
  nothing before the fold's first write, so the companion's answers were committed
  (`nozoki@6dc3cdf`). `git merge-base --is-ancestor 6c49d5c 67d103d` exits 0 and the same
  test against `67d103d^1` exits 1. `git diff --stat 6c49d5c main --
  nozoki-mac/Sources/Surfaces/TreeMarkers.swift` prints nothing. `git grep -n marker main --
  crates/nozoki-core/src/folder_model.rs` prints nothing. `grep -c -i tooltip` printed 0 for
  this document, `docs/UXD.md` and `docs/SRS.md` before the fold. `grep -rn -i tooltip
  nozoki-mac/Sources` prints two lines, both comments saying none is raised
  (`GitView.swift:L24`, `RailSwitchView.swift:L35`).
  **Known limits, stated beside the claims.** This fold built nothing and ran no test. At
  `nozoki@6dc3cdf` both surfaces draw the letters and raise no tooltip, so on this bar
  `see-git-status` is not reached on `main`; what that means for work in flight is the PM's.
  The command half's case holds the words and their order. Whether a test also drives the
  pointer rest, the 500ms delay and the tooltip's leaving is the design of the change, and
  until one does, those three are held by the observable half alone. No requirement in
  `docs/SRS.md` and no entry in `docs/UXD.md` names the expansion: S-4's SRS and UXD traces
  are unchanged, and the expansion traces to the owner's v1 decision, `docs/fdr.md` R-38,
  `docs/DESIGN.md` and `docs/CONTENT.md`, three documents outside the three this document's
  `Inputs read:` line names. They were opened at the lines cited here and were not read
  whole; each is Settled at its status line. A row name longer than the sidebar is wide is
  not covered: `docs/DESIGN.md` says "one line, never wrapped" and states nothing of what is
  cut. Of this document the fold read the header, *Who holds what*, § 3 *What the system
  holds*, § 4 C-E3 to C-E10, § 5 step 1's E-4, § 6 S-4 and S-5, § 10's opening note, RN-93's
  tail, RN-94 and *Open Questions*, and searched the rest for `status letter` and `tooltip`.
  The other sections were not re-read, so a sentence there that speaks of the expansion in
  other words was not seen. The PRD, the SRS and the UXD were read at their status lines,
  each Settled, and searched for `status letter` and `tooltip`; their bodies were not read.
  The project's Agari, its two doctrine files and the instance's writing bar were read
  whole. `docs/nfdr.md` was searched and `docs/adr/` was not opened.
  **What does not move.** The sentence before the replaced one is pinned to `nozoki@b640345`
  and is true of that commit. The `surfaces` row's clause is pinned the same way and says of
  itself that it reads the same whether or not the commit merges. `FolderModel`'s `TreeEntry`
  marker and the marker among the things in no landed change are statements about the model.
  § 10 RC-5's *Observed reality* is a dated record. § 5 step 1's E-4 keeps its words: it is
  the entry the slice was cut from, the answer names § 6 alone, and S-4's *Delivers* is where
  the addition is authorized. § 4 C-E3 and C-E6 keep their words: a status letter is not a
  fault, and a plain folder draws no letter, so nothing raises a tooltip there. S-4's "one
  click target, the status letter a label" stands, because the tooltip is raised by pointer
  rest and not by a click.
  **Found on the same walk, and not fixed.** RN-93's finding stands: the `**Owner:**` line
  and *Who holds what, inside one run* carry an earlier template's wording, and this fold
  did not read the document whole either. `docs/fdr.md` R-38 says "the file's name" where
  `docs/CONTENT.md` now names "the row — the file or the folder"; this document says "the
  row's name", and R-38's wording is the Principal PM's.
  **Downstream, not this document's to change.** `grep -n -i tooltip docs/nfdr.md` prints
  nothing, so `docs/nfdr.md` restates neither C-E8's new sentence nor S-4's new command
  clause. It is the Principal Architect's, and this fold opened no item on that seat's
  companion.
  **The companion:** `diff docs/SDD_open_issues.md docs/trail/sdd/cycle-30.md` printed
  nothing before this fold's first edit to this document. Its two items are folded and
  nothing is unresolved, so `docs/SDD_open_issues.md` is removed and `Status:` stays Settled
  *(re: § 3 `GitState`; § 4 C-E8; § 6 `see-git-status`, `follow-the-folder`; source:
  `docs/trail/sdd/cycle-30.md` §§ 5.1, 5.2; `docs/trail/sdd/self_answer-42.md`;
  `nozoki@6dc3cdf`)*.
- **RN-96:** *(CTO; the CDO's clauses named below)* *(changed)* `open-a-folder` and
  `see-git-status` each hold the clickable row's hover fill in their bar, and § 3's `surfaces`
  row says what the fill is drawn from. The companion's one item is folded. The PM opened that
  companion on 2026-10-04, and an unattended run answered it in the CTO's seat
  (`docs/trail/sdd/cycle-31.md` § 5.1; reasoning `docs/trail/sdd/self_answer-43.md`).
  **What moved, each named.** (1) § 3, the `surfaces` row: one clause, "Read with the
  exception, and not a second one", is added between the pending exception's paragraph and the
  clause held for `see-git-status`. (2) § 6 S-1 *Reached when*, observable half: three
  sentences are added after the startup surface's routes. (3) § 6 S-1 *Reached when*, command
  half: the "from a projection and from nothing else" clause gains a second reading clause, and
  four `swift test` cases are added after the layout clause. (4) § 6 S-1 *Rests on*: `surfaces`
  gains a parenthesis naming the tree row's fill. (5) § 6 S-4 *Reached when*, observable half:
  three sentences are added before "They click a changed file's row". (6) § 6 S-4 *Reached
  when*, command half: six `swift test` cases are added before *The promise clause*. (7) § 6
  S-4 *Rests on*: the `surfaces` parenthesis gains the Git view's file row's fill.
  **Whose columns, and what settled each.** (1), (3), (4), (6) and (7) are the CTO's. (2) and
  (5) are the CDO's clauses. They are settled by `docs/DESIGN.md` § *Components*, "Rows"
  (`:L618-L625`): "A clickable row has a hover state and an inert row has none", the fill is
  drawn "while the pointer is over a row that selection or opening acts on — a tree row, a
  Git-view file row, a commit row, a menu item", a "section header, a status message, the path
  line, a diff line" never takes it, and "The selected row keeps `{colors.selection}` and its
  bar under the pointer; selection outranks hover". The tooltip sentence in (5) is settled by
  § *Components*, "The tooltip" (`:L666-L667`): "It stacks with the row's hover fill, which is
  the row's and not the letter's". § *Do's and Don'ts* (`:L860-L861`) states the same rule
  again. This fold found no call in the CDO's clauses that those lines leave open for the
  sentences it wrote, so no item is raised for the CDO. No field of the CPO's moved.
  **Why these two slices, and no slice of its own. This is reasoning, and it is the answer's.**
  Each row's fill goes into the slice that first draws the row, the placement RN-95 gave the
  tooltip. S-1's observable half already held `docs/DESIGN.md` § *Components* "for the
  surfaces it draws", and "Rows" is a paragraph of that section, so the tree row's fill was
  inside S-1's bar before this fold and is now named in it. No sentence of S-4 held
  § *Components* for the Git view's file row, so there the fill is new to the bar. § 5 step 4
  already says "§ 6 holds no slice whose decision is a surface's drawing" (the E-1 re-read),
  and a slice whose result cannot change what happens next is too narrow by that step's test.
  **Why no *Delivers* moved.** *Delivers* states what a developer can do after the slice. The
  fill shows that a row can be clicked and adds nothing they can do. The answer leaves the
  field as written, and so does this fold.
  **Why the `surfaces` row gains a clause.** The row says the part "draws no state the bridge
  did not send, with **one exception**". A fill drawn from where the pointer is comes from
  neither a projection nor that exception, and the tooltip folded in v35 is in the same
  position. The clause reads the row's sentence as a statement about the folder's state: the
  pointer's position is the shell's own observation of the pointer, held across no redraw and
  raising no intent. That reading is the answer's and this seat's, and it is reasoning.
  **No § 10 entry.** None of § 10's four triggers holds: both bars can be met as written, no
  slice became a fragment, a slice can still be started, and the PRD, the SRS and the UXD did
  not change. `first-public-release` and `promise-one-point-zero` walk the earlier slices'
  observable halves, so the fill is inside both release bars with no edit to either.
  **The commit row and the menu item take no change.** `docs/DESIGN.md` gives both the same
  fill. `read-the-history` and `switch-the-folder` are not built, the item cites no site for
  either row, and the answer is "not until each occurs". When either surface is built with no
  fill, that is the occurrence.
  **Where this fold departs from the answer's words.** Three departures. The answer has both
  slices' "`surfaces` parenthesis" gain the fill; S-1's *Rests on* carried no parenthesis on
  `surfaces`, so the fold adds one. The answer gives S-4 "the same cases" as S-1; S-1's fourth
  case names a scroll, an expansion and a collapse, and the fold writes S-4's as a scroll
  alone, because this fold found no expansion in the Git view's list
  (`nozoki-mac/Sources/Surfaces/GitView.swift:L72`, the one scroll observer). The answer says
  S-1's "from a projection" clause "gains no test for it"; the fold writes that as a second
  reading clause that "adds no test for itself", beside the four cases the same answer adds.
  **Read and measured for this fold, at `nozoki@f16d940`.** `git status --short` printed
  nothing before the fold's first write, so the companion's answer was committed.
  `grep -rn -i hover nozoki-mac/Sources | wc -l` prints `0`. `grep -n -i hover` printed
  nothing for this document, `docs/UXD.md`, `docs/SRS.md` and `docs/PRD.md` before the fold.
  Every tree row is a `BarRowView` (`nozoki-mac/Sources/Surfaces/RootItemsView.swift:L527`),
  every Git-view file row is one (`GitView.swift:L253-L254`), and `BarRowView.swift:L1-L27`
  draws a bar and no fill under the pointer. The Git view holds a selection
  (`GitView.swift:L47`, `:L162-L164`), so S-4's selected-row case has a row to test. `git tag`
  prints nothing, so no release has shipped without the fill.
  **Known limits, stated beside the claims.** This fold built nothing and ran no test. At
  `nozoki@f16d940` neither surface draws a fill, so on these bars neither `open-a-folder` nor
  `see-git-status` is reached on `main`; what that means for work in flight is the PM's. No
  requirement in `docs/SRS.md` and no entry in `docs/UXD.md` names the fill: both slices' SRS
  and UXD traces are unchanged, and the fill traces to `docs/DESIGN.md` alone, a document
  outside the three this document's `Inputs read:` line names. Three things the design
  language does not state, and this document does not decide: whether the row of an entry that
  cannot be read is one "that selection or opening acts on"; what the fill does when the
  window stops being the key window with the pointer still over a row; and whether § 4 C-E8's
  "no meaning by hue alone" is met by the fill, which the answer reads as met because the
  pointer's own position says the same thing without colour. All three are the CDO's, in
  `docs/DESIGN.md` or in C-E8, and no sentence written by this fold turns on any of them. A
  refresh that moves a row under a still pointer is reached by "the row now under the
  pointer", and no sentence is added to `follow-the-folder`. Of this document the fold read
  the header, *Who holds what*, § 3's `surfaces` row and SM-8, § 4 C-E1 to C-E10, § 5 step 4's
  E-1, § 6 S-1 and S-4, RN-95 and *Open Questions*, and searched the rest for `hover`,
  `pointer`, `tooltip` and `from a projection`. The other sections were not re-read, so a
  sentence there that speaks of the pointer in other words was not seen. The PRD, the SRS and
  the UXD were read at their status lines, each Settled, and searched for `hover`; their
  bodies were not read. `docs/DESIGN.md` was read at `:L606-L671` and at every line `grep -n -i
  hover` prints, and is Settled at its status line (`:L301`). The project's Agari, its two
  doctrine files and the instance's writing bar were read whole. `docs/nfdr.md` and
  `docs/adr/` were not opened.
  **Found on the same walk, and not fixed.** RN-93's finding stands: the `**Owner:**` line and
  *Who holds what, inside one run* carry an earlier template's wording.
  **Downstream, not this document's to change.** `docs/nfdr.md` may restate S-1's and S-4's
  command halves without the new cases; it is the Principal Architect's, and this fold opened
  no item on that seat's companion. Whether `docs/fdr.md` carries a requirement for the fill
  is the Principal PM's.
  **The companion:** `diff docs/SDD_open_issues.md docs/trail/sdd/cycle-31.md` printed nothing
  before this fold's first edit to this document. Its one item is folded and nothing is
  unresolved, so `docs/SDD_open_issues.md` is removed and `Status:` stays Settled
  *(re: § 3 `surfaces`; § 6 `open-a-folder`, `see-git-status`; source:
  `docs/trail/sdd/cycle-31.md` § 5.1; `docs/trail/sdd/self_answer-43.md`; `nozoki@f16d940`)*.
- **RN-97:** *(CTO; the CDO's clause named below)* *(changed)* `see-git-status` holds the Git
  view's selected file row's drawing in its bar: the selection fill and the left bar. The
  companion's one item is folded. The PM opened that companion on 2026-10-04, and an unattended
  run answered it in the CTO's seat (`docs/trail/sdd/cycle-32.md` § 5.1; reasoning
  `docs/trail/sdd/self_answer-44.md`).
  **What moved, each named.** (1) § 6 S-4 *Reached when*, observable half: two sentences are
  added after "They click a changed file's row", saying the clicked row is drawn as
  `docs/DESIGN.md` draws the selected row and that the bar is the cue that survives without
  colour. (2) § 6 S-4 *Reached when*, command half: one `swift test` case is added before the
  case "the selected row under the pointer keeps its selection fill and its bar", and the
  count reads seven cases, six for the hover fill and one for the selected row's drawing.
  (3) § 6 S-4 *Rests on*: the `surfaces` parenthesis gains the Git view's selected row's fill.
  **Whose columns, and what settled each.** (2) and (3) are the CTO's. (1) is the CDO's clause.
  It is settled by `docs/DESIGN.md`, which is Settled at its status line (`:L301`). § *Components*,
  "Rows" (`:L613-L619`) says "`{components.tree-row}` is every list row in the product: the
  file tree, the Git view's changed and staged files, the history view's commits, and menu
  items" and "The selected row is `{components.tree-row-selected}` with the left bar". The same
  paragraph (`:L634-L635`) says "The selected row keeps `{colors.selection}` and its bar under
  the pointer". § *Shapes* (`:L574-L577`) says "The bar is the cue that survives without colour
  (`docs/UXD.md` UX-A2)". The sentences in (1) cite the section and state no value. No item is
  raised for the CDO. No field of the CPO's moved.
  **One reading this rests on. It is reasoning.** § *Shapes* also says "The selected tree row
  is `{colors.selection}` edge to edge" (`:L574`). Read alone, that sentence limits the fill to
  the tree. This fold reads it with "Rows", which names the Git view's file rows as the same
  component and gives the selected row the fill. If the CDO states in `docs/DESIGN.md` that the
  fill is the tree's alone, sentence (1) and the case in (2) lose their ground, and S-4's bar
  returns to the bar alone.
  **Why this slice, and no slice of its own. This is reasoning, and it is the answer's.** The
  Git view's file row is first drawn and first clickable in `see-git-status`, the placement
  RN-95 and RN-96 gave a row's drawing. § 5 step 4 says "§ 6 holds no slice whose decision is a
  surface's drawing", so a later slice holding the fill alone is excluded.
  **Why no *Delivers* moved.** *Delivers* states what a developer can do after the slice. The
  fill shows which row is open and adds nothing they can do, the reason RN-96 gave for the hover
  fill.
  **No § 10 entry.** None of § 10's four triggers holds: the bar can be met as written, no slice
  became a fragment, a slice can still be started, and the PRD, the SRS and the UXD did not
  change. S-1 and S-2 keep their words.
  **Where this fold departs from the answer's words.** Two departures. The answer adds "One
  sentence" to the observable half; the fold writes two, so that the drawing and the cue each
  have a sentence of their own. The answer does not say how the command half's count reads
  after the added case; the fold writes "seven cases for the Git view's file row, six for the
  hover fill and one for the selected row's drawing", because the added case holds a selection
  fill and no hover fill.
  **One correction to the item's own text.** The item cites `docs/DESIGN.md` at `:L612-L618` and
  `:L624-L625`. `docs/DESIGN.md` moved to v18 at `nozoki@6cf1014` after the item was written.
  The quoted words are at `:L613-L619` and `:L634-L635`, where this fold opened them. The trail
  copy keeps the item as it was written.
  **Read and measured for this fold, at `nozoki@29239bc`.** `git status --short` printed nothing
  before the fold's first write, so the companion's answer was committed. The Git view's
  selection sets `drawsBar` on one row and nothing else
  (`nozoki-mac/Sources/Surfaces/GitView.swift:L190-L194`). `grep -rn isSelected
  nozoki-mac/Sources` prints one line, `BarRowView.swift:36`, which reads the flag and marks no
  Git-view row selected. The shell's test for the existing selected-row case holds the bar and
  that the row's image is the same with the pointer over the row as with the pointer elsewhere
  (`nozoki-mac/Tests/SurfacesTests/GitViewHoverTests.swift:L178-L194`); it asserts no fill, so
  it passes with the bar alone. `git tag` prints nothing, so no release has shipped without the
  fill. `grep -n -i 'hover\|selection fill' docs/nfdr.md docs/fdr.md` prints nothing.
  **Known limits, stated beside the claims.** This fold built nothing and ran no test. At
  `nozoki@29239bc` the Git view's selected row draws the bar alone, so on this bar
  `see-git-status` is not reached on `main`; what that means for work in flight is the PM's. No
  requirement in `docs/SRS.md` and no entry in `docs/UXD.md` names the Git view's selected row:
  FR-7 is about the tree (`docs/SRS.md:L144-L145`), and UX-A2 asks that "the selected file"
  carry "a cue that survives without" colour (`docs/UXD.md:L375-L377`). S-4's SRS and UXD traces
  are unchanged, and the fill traces to `docs/DESIGN.md` alone, a document outside the three
  this document's `Inputs read:` line names. Four cases are named and not decided here.
  (a) Whether a Git-view row is drawn selected when its file was opened from the tree: the
  shell clears the Git view's selection on a tree selection
  (`nozoki-mac/Sources/Surfaces/WorkbenchView.swift:L161-L165`), and `docs/DESIGN.md` does not
  say. (b) Which row is drawn selected when one file has a row in both lists: sentence (1) says
  "the row they clicked", which is what the shell draws. (c) What the selected row's fill does
  in a window that is not the key window. (d) What a refresh does to a selected row that leaves
  or moves in the list, which is `follow-the-folder`'s; § 4 C-E2 holds "the open file" through
  every refresh and does not name the Git view's selected row. (a) to (c) are the CDO's, in
  `docs/DESIGN.md`, and no sentence written by this fold turns on any of the four. Of this
  document the fold read the header, *Who holds what*, § 4 C-E2, § 5 step 4's E-1 sentence,
  § 6 S-4 and RN-96, and searched the rest for `selection fill`, `selected row` and `selected
  file row`. The other sections were not re-read, so a sentence there that speaks of the Git
  view's selected row in other words was not seen. The PRD, the SRS and the UXD were read at
  their status lines, each Settled, and searched for `selected` and `selection`; their bodies
  were not read. `docs/DESIGN.md` was read at `:L570-L578` and `:L610-L636`. The project's
  Agari, its two doctrine files, the instance's domain doctrine and its writing bar were read
  whole. `docs/nfdr.md` and `docs/fdr.md` were searched and not read. `docs/adr/` was listed
  and not opened.
  **Found on the same walk, and not fixed.** RN-93's finding stands: the `**Owner:**` line and
  *Who holds what, inside one run* carry an earlier template's wording.
  **Downstream, not this document's to change.** `docs/nfdr.md` and `docs/fdr.md` restate
  neither the hover cases nor the added case, by the search above. Whether either takes the
  fill is the Principal Architect's and the Principal PM's, and this fold opened no item on
  either seat's companion.
  **The companion:** `diff docs/SDD_open_issues.md docs/trail/sdd/cycle-32.md` printed nothing
  before this fold's first edit to this document. Its one item is folded and nothing is
  unresolved, so `docs/SDD_open_issues.md` is removed and `Status:` stays Settled
  *(re: § 6 `see-git-status`; source: `docs/trail/sdd/cycle-32.md` § 5.1;
  `docs/trail/sdd/self_answer-44.md`; `nozoki@29239bc`)*.
- **RN-98:** *(CTO; the CDO's clauses named below)* *(changed)* § 3's `surfaces` row names the
  window's key status beside the pointer as what the hover fill and the tooltip are drawn from,
  and `open-a-folder` and `see-git-status` hold the key window in their bars. The companion's
  one item is folded. The PM opened that companion on 2026-10-04, and an unattended run answered
  it in the CTO's seat (`docs/trail/sdd/cycle-33.md` § 5.1; reasoning
  `docs/trail/sdd/self_answer-45.md`).
  **What moved, each named.** (1) § 3, the `surfaces` row, the clause "Read with the exception,
  and not a second one": one sentence naming the key status is added after the pointer's, the
  sentence on what the fill and the tooltip are drawn from names both, and seven sentences
  follow the pointer's bounds, giving the key status the same bounds and naming one case the
  clause does not decide. (2) § 6 S-1 *Reached when*, observable half: the hover sentence is
  stated for the key window, and one sentence is added for a window that is not. (3) § 6 S-1
  *Reached when*, command half: the second reading clause names the window beside the pointer,
  and the hover cases read seven, the four in place stated for the key window and three added.
  (4) § 6 S-4 *Reached when*, observable half: the hover sentence is stated for the key window,
  and two sentences are added, one for the fill and one for the tooltip. (5) § 6 S-4 *Reached
  when*, command half: the count reads eleven cases, the seven in place stated for the key
  window and four added.
  **Whose columns, and what settled each.** (1), (3) and (5) are the CTO's. (2) and (4) are the
  CDO's clauses. They are settled by `docs/DESIGN.md`, which is Settled at its status line
  (`:L301`). § *Components*, "Rows" (`:L640-L643`) says "The fill is drawn only while the window
  is the key window", that when the window stops being the key window "a fill already shown
  leaves at that moment, under a still pointer", and that when it becomes the key window again
  "the fill is drawn on the row under the pointer at that moment, read against the rows as they
  stand then". § *Components*, "The tooltip" (`:L689-L691`, `:L698-L700`) says the tooltip leaves
  the moment "the window stops being the key window", that "It is not restored when the window
  becomes the key window again", and that "It is raised again only by a fresh 500ms rest on the
  letter". This fold found no call those lines leave open for the sentences it wrote, so no item
  is raised for the CDO. No field of the CPO's moved.
  **Why the clause gives neither observation a number. This is reasoning, and it is the
  answer's.** The item calls the key status the shell's "second first-hand observation". The
  row already says the pending gap is "the one thing the shell observes first-hand", and RN-96
  reads that sentence as a statement about the folder's state. A count of first-hand
  observations in the clause would make that sentence read false. The clause says what each
  observation is of, the pointer and the window, and that neither is a state of the folder.
  **No seam moved.** The three surfaces that hold a key-window source default it to the live
  one themselves (`nozoki-mac/Sources/Surfaces/GitView.swift:L64`, `RootItemsView.swift:L173`,
  `WorkbenchView.swift:L83`), so nothing is handed down SM-8. Asking a window whether it is the
  key window is no filesystem, network or process capability, so the row's *Must not own* cell
  keeps its words. `mac-shell` still owns the one window, and `surfaces` reads one fact about
  it.
  **No *Delivers* and no *Rests on* moved.** The key window adds nothing a developer can do,
  the reason RN-96 gave for the fill. Both slices' *Rests on* already name the fill and the
  tooltip in `surfaces`.
  **No § 10 entry.** None of § 10's four triggers holds: both bars can be met as written, no
  slice became a fragment, a slice can still be started, and the PRD, the SRS and the UXD did
  not change.
  **The commit row and the menu item take no change.** `docs/DESIGN.md:L643-L645` gives both
  the same rule. Neither surface is built and the item cites no site for either, the ground
  RN-96 stated.
  **Where this fold departs from the answer's words.** Four departures. (a) The answer leaves
  the pointer's bounds sentence as written. The fold opens it with "What the pointer is over"
  in place of "It", because a sentence about the window now stands before it and "It" would
  read as either. The sentence states what it stated. (b) The answer says each hover sentence
  "is stated for a window that is the key window". The fold does that and also writes, in each
  observable half, what a window that is not the key window shows, in the words of
  `docs/DESIGN.md` cited above. Without it the three added command cases would hold a
  behaviour neither observable half names. (c) The answer gives each slice the case "no row
  shows the fill, whatever the pointer does and whatever rows move under it". S-1's reads
  "whatever a scroll or an expansion moves under it", which is what the tree's suite holds
  (`nozoki-mac/Tests/SurfacesTests/RootItemsViewHoverTests.swift:L484-L498`). S-4's reads
  "whatever rows an answer arriving then puts under it", which is what the Git view's suite
  holds (`GitViewHoverTests.swift:L463-L479`). The Git view's scroll case asserts only after
  the window is the key window again (`:L481-L499`). (d) The clause names one case it does not
  decide, which window is the key window while the Open panel or a menu is up. The answer's
  reasoning names it as not covered, and the answer's text does not.
  **Two earlier notes, their words kept.** RN-96 lists "what the fill does when the window
  stops being the key window with the pointer still over a row" among things the design
  language does not state. RN-97 lists as (c) "What the selected row's fill does in a window
  that is not the key window". Both were true when written. `docs/DESIGN.md` now states the
  first at `:L640-L645` and the second at `:L645-L651`: "The selected row looks the same whether
  or not the window is the key window". The second is outside this item, and this fold adds no
  sentence and no case for the selected row.
  **One correction to the item's own text.** The item cites `docs/DESIGN.md` at `:L635-L640`
  and `:L681-L685`. That document moved to v19 at `nozoki@6f92b29` after the item was written.
  The rule for the fill is at `:L640-L645` and the tooltip's at `:L689-L700`, where this fold
  opened them. The trail copy keeps the item as it was written.
  **Read and measured for this fold, at `nozoki@6a300e1`.** `git status --short` printed
  nothing before the fold's first write, and `git log -1 -- docs/SDD_open_issues.md` names
  `6a300e1`, so the companion's answer was committed. The live source asks the host's window
  (`nozoki-mac/Sources/Surfaces/KeyWindowSource.swift:L50-L51`), and a host in no window answers
  not key by the same line. `RowHover` asks the key status at each resolve and at each pointer
  event and keeps no copy of it (`RowHover.swift:L52`, `:L81`), and clears the fill and reads
  the pointer again at the two moments (`:L69-L78`). `LetterTooltip` dismisses when the window
  stops being the key window, shows nothing when it becomes key, and asks again when a rest
  fires (`LetterTooltip.swift:L176-L191`, `:L214`). The added cases are held by
  `RootItemsViewHoverTests.swift:L443`, `:L468`, `:L484` and `:L500` for the tree, and by
  `GitViewHoverTests.swift:L403`, `:L419`, `:L444` and `:L463` for the Git view. `swift test
  --package-path nozoki-mac --filter 'RootItemsViewHoverTests|GitViewHoverTests'` executed 50
  tests with 0 failures, 24 of them in `RootItemsViewHoverTests`. `grep -n -i 'key window\|key
  status'` prints nothing for `docs/SRS.md`, `docs/UXD.md`, `docs/PRD.md`, `docs/nfdr.md`,
  `docs/fdr.md` and `docs/CONTENT.md`.
  **Known limits, stated beside the claims.** Every key-window case runs against a double. The
  source's own header says "a test passes a double that flips on demand, because the test
  windows never become key" (`KeyWindowSource.swift:L6`). So no test in those suites reaches the
  live answer or the observer of the window's two notifications (`:L50-L55`, `:L62-L86`), and a
  window that is the key window on a reader's screen is checked by the observable halves alone.
  The run above is two suites on one machine, and it is no claim that either slice is reached:
  the full gate was not run and no bundle was built. No requirement in `docs/SRS.md` and no
  entry in `docs/UXD.md` names the key window. Both slices' SRS and UXD traces are unchanged,
  and the rule traces to `docs/DESIGN.md` alone, a document outside the three this document's
  `Inputs read:` line names. Of this document the fold read the header, *Who holds what*, § 3's
  parts table from `watcher` to `read-only-harness`, § 6 S-1 and S-4 whole, RN-96 and RN-97,
  and searched the rest for `hover`, `tooltip`, `the pointer`, `key window` and `key status`.
  The other sections were not re-read, so a sentence there that speaks of the window's key
  status in other words was not seen. The PRD, the SRS and the UXD were read at their status
  lines, each Settled, and searched; their bodies were not read. `docs/DESIGN.md` was read at
  `:L622-L705`. The project's Agari, its two doctrine files, the instance's domain doctrine and
  its writing bar were read whole. `docs/nfdr.md` and `docs/fdr.md` were searched and not read.
  `docs/adr/` was listed and not opened. No `docs/definition_brief.md` is on disk.
  **Found on the same walk, and not fixed.** RN-93's finding stands: the `**Owner:**` line and
  *Who holds what, inside one run* carry an earlier template's wording.
  **Downstream, not this document's to change.** `docs/nfdr.md` and `docs/fdr.md` restate
  neither the clause nor the hover cases, by the search above. Whether either takes the key
  window is the Principal Architect's and the Principal PM's, and this fold opened no item on
  either seat's companion.
  **The companion:** `diff docs/SDD_open_issues.md docs/trail/sdd/cycle-33.md` printed nothing
  before this fold's first edit to this document. Its one item is folded and nothing is
  unresolved, so `docs/SDD_open_issues.md` is removed and `Status:` stays Settled
  *(re: § 3 `surfaces`; § 6 `open-a-folder`, `see-git-status`; source:
  `docs/trail/sdd/cycle-33.md` § 5.1; `docs/trail/sdd/self_answer-45.md`; `nozoki@6a300e1`)*.

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

- [OPEN: Whether a folder dropped on the Dock icon, or opened with *Open With*, is granted by the
  sandbox the same way as one chosen in the Open panel. Settled in the first slice by trying both
  against the built bundle; if not, C-R3 gains a clause saying those routes present the panel.]
- [OPEN: Whether libgit2 opens a repository correctly under a read-only user-selected grant with
  discovery disabled, for a plain `.git` folder and for a `.git` file naming a gitdir inside the
  grant. Settled by the first Git slice's `root_finding` and `git_state` fixtures running green
  on the built bundle; a failure is R-1 firing early. The same run shows the open answering
  `root` with the four machine-level config reads switched off (§ 3, the `core-bridge` row).
  Before the switch, a `stat` of a config path refused with anything but `ENOENT` or `ENOTDIR`
  is an error (`libgit2-sys 0.18.8+1.9.7`, `libgit2/src/libgit2/config.c:L143-L147`) and a
  failed config snapshot fails the open (`repository.c:L997-L999`); whether the sandbox's
  refusal took that path was never run. *(Extended on 2026-10-03; RN-87.)*]
- [OPEN: How TextKit lays out UX-I12's two hard cells — an image or its placeholder box in the
  flow of the prose, and fenced code on its own surface inside prose: `NSTextAttachment` and
  `NSTextBlock`, or a custom layout fragment. Settled by `read-markdown`'s first build rendering
  the layout fixtures at `docs/DESIGN.md`'s prose measure on the floor macOS; the form found is
  written into `surfaces`' row in § 3. *(This item replaced the WKWebView `img-src` origin
  question on 2026-09-23, which § 10 RC-3 made moot; RN-60.)*]
- [OPEN: In what form `open_folder`'s argument crosses the bridge so that the grant the Open panel
  conferred is the one the core reads under — the path alone, on the process-wide grant the panel
  confers for the session, or the URL's security-scoped form once `switch-the-folder`'s bookmarks
  exist (C-R3, C-D1). Settled in `open-a-folder` by the first read through the bridge on the
  built bundle; a read the sandbox refuses on the panel's own path is a re-cut trigger on SM-4's
  first function.]
- [OPEN: What the reference fixture sizes are (NFR-10) and what FSEvents coalescing latency the
  watcher sees on them. Settled by `checks/latency.sh`'s first figures, which the SRS then folds in
  by revision (`docs/SRS.md` RN-4); no number is written here before that.]
- [OPEN: How a collapsed tree node and a scroll of the reading panel reach `folder-model`, which
  § 3 gives the tree's expansion and the open `FileView`'s reading position (`docs/SRS.md` DR-2,
  DR-3). SM-4's ten calls name neither act: an expansion crosses as `list_tree` and a selection
  as `select_file`, and no call is named for a collapse or for a scroll. SM-5 carries the
  operations those functions name and no others, so `follow-the-folder`'s `--test watch` has no
  operation to set a reading position with. Three forms are open. One: the place crosses as an
  argument on a call the list already names. Two: the disclosure state and the scroll offset stay
  where AppKit keeps them, and the model's deltas are scoped so that drawing them moves neither.
  Three: a call the list does not name. Settled by `follow-the-folder`'s first build keeping the
  place under `checks/churn.sh`, or by an earlier change that brings the held state into the
  model. The first form moves no list and is written into SM-4's row when found. The second
  leaves `follow-the-folder`'s command half unmet as written, and the third moves SM-4's list,
  § 4 C-R7's set and C-I6's ten; each of those two is a re-cut, recorded in § 10 before it is
  built, and an eleventh call built without one fails C-R7's set equality. Whichever form is found,
  § 4 C-E2 binds it: a refresh that collapses a node or resets a scroll position violates that
  condition. *(Added on 2026-10-01, on the CDO's finding in the run that folded
  `docs/trail/sdd/cycle-17.md` § 5.2; RN-77.)* *(The counts read nine, nine and "a tenth export"
  until 2026-10-04, when SM-4's list gained `read_git`; § 10 RC-4, RN-90.)*]
- [OPEN: How a path the repository's own config names is kept from being read outside the grant
  (§ 11 R-16). libgit2 follows `include.path`, `core.excludesfile` and `core.attributesfile`
  with no containment check, and the search-path switch does not reach them. Two forms are open.
  One: a libgit2 setting that stops the three being followed; the answer that named the case
  found none and states that it did not look for long (`docs/trail/sdd/self_answer-34.md`
  § 2.1, the first addition). Two: the adapter reads the repository's config through
  `fs-reader`'s check first and answers `failed` for a repository whose config carries one of
  the three with a path outside the folder. Settled in `see-git-status`, before the slice is
  reached. No build inside the slice bounds it. It is settled
  by a fixture repository whose config names an outside path and a case showing that path is
  not read. No check enforces this bound. It is held by review of the change after which
  `see-git-status`'s *Reached when* is claimed whole: where the fixture and its case are
  missing at that review, the slice is not reached. There is no later build of the slice than
  the one that reaches it, so this bound has nowhere later to move to. From the first build in
  which `mac-shell` calls `nozoki_read_git` until this item is settled, the bundle opens a
  reader's own repositories with the item open. In those builds the sandbox is the only bound
  (§ 4 C-R2; § 11 R-16), and whether libgit2's open or status read survives the sandbox's
  refusal has not been run. Where it does not survive, a repository whose config names an
  outside path shows a failed Git item, the state § 6 S-4's observable half draws for Git
  state the tool could not read. The second form adds a
  condition under which a repository's Git state is not shown, which a reader sees; where it is
  the form found, it is written into `git-reader`'s row and § 11 R-16 before it is built.
  *(Added on 2026-10-03; RN-87.)* *(The bound read "no later than the build that first exports
  a function reaching `git-reader`" until 2026-10-04. That build landed at `nozoki@392177d`
  with the item unsettled and neither form chosen. Until the shell calls the export the bundle
  opens no repository: the Git item is read on the first ask
  (`crates/nozoki-bridge/src/exports.rs:L102-L103`), and
  `grep -rn 'nozoki_read_git\|read_git' nozoki-mac/Sources` prints nothing at `nozoki@a7834f4`.
  `docs/trail/sdd/cycle-26.md` § 5.4; RN-91.)* *(The bound read "no later than the build in
  which `mac-shell` first calls `nozoki_read_git`, which is the first build whose release
  executable links that export, and in every case before the slice is reached", held "by
  review of the change that makes the shell call the export", until later on 2026-10-04. The
  owner then chose to move it, and the first half was removed. The note before this one is a
  dated record: its sentence "Until the shell calls the export the bundle opens no repository"
  describes the tree at `nozoki@a7834f4`, and stops describing it at the first build in which
  the shell calls the export. At `nozoki@b780d58` the same grep still prints nothing.
  `docs/trail/sdd/cycle-27.md` § 5.1; RN-92.)*]
- [OPEN: What a failed re-read of a folder that is already expanded does to the entries listed
  under it: whether they stay as last read, go, or are held under the failed folder. Those
  entries are not the folder's siblings, so § 4 C-I1's rule that a failed read changes no other
  item does not answer it, and § 3 leaves the model's layout to the developer. Settled in
  `follow-the-folder`, by the reducer's design and a `--test watch` case that fails the re-read
  of an expanded folder; the form found is written into § 4 C-I1. Whichever form is found,
  `docs/SRS.md` NFR-3 binds it: the failure "degrades only that item's view".
  *(Added on 2026-10-04, from the third addition to the answer at `docs/trail/sdd/cycle-24.md`
  § 2.1; RN-89.)*]
