# SDD — nozoki

**Status:** Draft
<!-- Draft = open issues or choices to confirm remain (open-issues file present).
     Settled = nothing left for the owner to answer and no open technical question — the done
       signal, and the state a finished SDD carries; the open-issues file is gone.
     Locked = ratified as the source of truth. -->
**Owner:** CTO · CPO · CDO — one run, three seats
**Version:** 11 — CPO: § 1 (read-only bullet — the owner's no-network-entitlement ruling named as a fixed constraint); § 5 step 4 E-1 (bar re-pointed at "the entitlements C-R2 fixes", window-draws half added, third not-too-narrow case); § 12 the PRD boundary (cycle-8 item recorded as touching the promise with no PRD gap); SDD Review Notes RN-51 (CPO, changed). No slug, *Delivers*, *Moves toward* or fence moved; no companion item added.; CPO: nothing this dispatch — the round-1 edits already on disk stand: § 1 (read-only bullet), § 5 step 4 E-1 (bar re-pointed, window-draws half, third not-too-narrow case), § 12 the PRD boundary (cycle-8 item recorded, no PRD gap), SDD Review Notes RN-51 (CPO, changed). No slug, *Delivers*, *Moves toward* or fence moved; no companion item added.; CTO: § 4 C-R2 (rewritten to the owner's rule; *Violated by* rescoped; ADR-0003 departure named); § 4 C-I3 (renderer gate `checks/renderer.sh` added with its control; *Violated by* extended); § 6 S-1 *Reached when* command half (both gates; unmet-until-§ 1.1 note); § 10 RC-2 (new); § 12 the downstream boundary (ADR-0003 departure recorded; QC-25 to re-derive); Open Questions (fifth item, hosted runner); SDD Review Notes RN-52 (CTO, changed). Companion: § 5.1 consumed (trail copy `docs/trail/sdd/cycle-8.md`); item § 1.1 added (CTO — the renderer under C-R2's rule, the owner's call). No slug, slice, edge or place in the order moved.; CDO: § 6 S-1 *Reached when* (observable half — the artifact named: the CI-built bundle launched from Finder; a blank window stated as unmet); § 12 the UXD boundary (the ruling opens no UXD gap; `DESIGN.md`'s realisation sentence is what a native renderer moves); SDD Review Notes RN-53 (CDO, new). Companion: § 1.1 gains the CDO's position (no item added, none consumed).; CPO: companion § 1.1 (the CPO's position added — no item added, none consumed); § 12 the PRD boundary (one sentence: § 1.1 opens no PRD gap); SDD Review Notes RN-54 (CPO, added). No slug, slice, *Delivers*, *Moves toward*, fence or PRD trace moved.; CTO: § 2 row 4 (*Wrong when* citation re-pointed to `docs/DESIGN.md` § Overview / RN-1, UXD § 9 kept for assets, `third_party/lucide/` named); SDD Review Notes RN-2 (one parenthesis naming the correction); RN-55 (CTO, changed). No slice, edge, condition or companion item moved or added.
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
  C-R2 answers to. What the folder holds is displayed, never executed (NFR-16); the folder is
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
   *withholding a capability* at a boundary something outside the code enforces.
4. **What must be replaceable inside the terminus.** Two things, both live: the viewed folder —
   "an input, not a structural singleton", and the switch is inside done (`docs/SRS.md` NFR-12,
   FR-19; `system/projects/nozoki/agari.md`, first condition) — and the Git mechanism (force 2).
   Nothing else will be swapped before done: not the renderer technology, not the platform (C-11).
   A seam for either of those would be cost with no buyer.
5. **What the numbers force at runtime.** One machine, one process tree, one folder per run
   (`docs/SRS.md` C-1, FR-1); no network call during operation, none (NFR-8); own state in the
   tool's own data location and never in the folder (FR-21, DR-5); no configuration of any kind
   (NFR-14). And the promise must survive a crash (NFR-4) — which is what turns "the code declines
   to write" into "the operating system refuses the write": only a wall outside the process holds
   through the process dying.
6. **What a first slice could prove.** For each candidate below: the smallest build that shows it
   right or wrong is one that opens a folder, shows its tree, reads one file, and has the *wall*
   in place and machine-checked — because the wall is the shape's whole claim. A candidate whose
   wall cannot be checked until the product is whole carries a warning about itself.
7. **What being wrong costs.** Stated per row, below the table.

**The candidates, run against the forces.** Each row is checked against § 1's four questions —
*show* no write path; follow a moving folder without blocking or writing; swap the folder without
rewriting the viewing surface; install by one path in five minutes — and the question that decides
the row is named on it.

| Shape | Right when | Wrong when | Taken? |
|---|---|---|---|
| **Capability-split read pipeline** — a sandboxed host that holds *read* capability only, feeding one in-memory folder model; the surfaces in a separate renderer process that holds *no* filesystem, network or shell capability, reached through a closed command list and one read-only asset scheme | The system's rules are negative invariants that must hold through a crash (force 3, force 5), and change arrives as read surfaces rather than capabilities (force 1): the wall is then the design, and adding a surface costs nothing at the wall | The system needs a capability the wall forbids — a write, a socket, a process — or its rules are positive domain logic worth a guarded core; then the split is two processes and a serialized seam bought for nothing | **yes** — it answers § 1's first question with an entitlements file a reviewer reads (`codesign -d --entitlements`), not with "if the code is careful"; the second with a watcher and a model that never hold a write; the third with the folder as a value the model is replaced by (§ 3); the fourth with one bundle (§ 4 C-R1, C-R4) |
| **Hexagonal** — a domain core behind ports, an adapter at every edge | Many volatile edges owned by others, and a core carrying rules worth guarding from them (force 2, force 3 the other way round) | The edges are two, stable, and owned by Apple and Git, and the core would hold a folder model and no rule (force 2, force 3): every port but one guards nothing | no — insulating a stable edge is ceremony; its one useful port, the Git reader (force 2), is kept inside the taken shape (§ 3 SM-2). It would win only if the agent-workflow front end came inside the terminus and brought its own edges, which the Agari places outside done |
| **Layered, one process** — UI over services over a data-access layer | A product whose data layer's generic filesystem and network access is the point | A product whose defining promise is that such access does *not* exist (force 3): not-writing becomes discipline in a layer built to write | no — fails § 1's first question by construction: a reviewer is *told* the data layer never writes; nothing shows it |
| **Native single-process model-view (AppKit / SwiftUI) under the same sandbox** | The design language is native, no untrusted content is rendered as markup, and one language is worth more than a second wall | Markdown must render (`docs/SRS.md` FR-30) and the design language is realised as plain CSS custom properties over the product's own markup (`docs/DESIGN.md` § Overview, its opening sentence; RN-1 there), with every asset — the vendored SVG icons among them — shipping with the tool (`docs/UXD.md` § 9; `third_party/lucide/`): re-expressing it natively is a second design language. What survives re-expression is the CDO's finding, not this row's (RN-53) | no — the honest runner-up: it keeps the sandbox wall and loses the renderer wall, and it re-expresses a settled design language. It wins if that language is ever redrawn natively, which nothing inside the terminus asks for |
| **Local server + browser tab** — the input proposal's "web app" | A hosted or multi-client direction is inside done | A listening socket is a network call during operation, which NFR-8 forbids outright; and the README no longer calls the product a web app (`docs/PRD.md` § Out of Scope, last item) | no — fails § 1's first and fourth questions: a socket is a capability the wall must forbid, and a browser tab is a second thing to install |

**Which side this product falls on, and why.** The four questions § 1 sets are all *structural*:
each asks for something a reviewer can check without trusting the code. The capability-split
pipeline is the only candidate whose answer to every one is a boundary — an entitlement list, a
closed command list, a Content Security Policy, a model replaced whole — rather than a discipline.
The hexagonal shape answers the same questions with more seams than the product has volatile
edges; the layered and web-app shapes cannot answer the first question at all; the native shape
answers all four and loses only on the cost of re-expressing the experience. The Principal
Architect's log already records this shape and its runner-up as ADR-0001 (`docs/adr/0001-capability-split-read-pipeline.md`);
this run weighed it again from the forces above, against the SRS, UXD and PRD as they stand today,
and landed where the record stands (RN-1).

**Undoing it.** Three reversals, priced separately because they cost differently:

- *Collapsing the two processes into one* costs the IPC surface (§ 3 SM-4) rewritten as direct
  calls, and nothing else — the folder model, the readers and the harness survive. Cheap.
- *Replacing the renderer technology* costs every surface rewritten (§ 3 `surfaces`); the host, the
  model and the harness survive. Expensive, and not foreseen inside the terminus (force 4).
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
| `fs-reader` | crates/nozoki-core | Listing a folder's entries and reading a file's bytes, each returning its outcome as data (bytes, or the condition observed); the text rule — bytes decode as UTF-8, with or without a byte-order mark, or begin with a UTF-16 byte-order mark and decode as UTF-16, and the file is text; otherwise it is *cannot-display-as-text* (`docs/SRS.md` FR-10) — no encoding is detected from content, no third encoding is admitted, one undecodable sequence makes the file not text, and an empty file is text (the owner's value, RN-41); the extension map that names a floor language or *plain* (FR-29; the set is § 4 C-I5); the **containment check** — a canonical path, symlinks resolved and percent-decoding applied, is inside the granted folder or it is refused — run before any open, for every path derived from content or from outside | Any write. Git, in any form. Watching. Markdown. Deciding what a change means |
| `git-reader` | crates/nozoki-core | The **Git port** — `probe(folder)` answering `root` or `plain` with discovery disabled and never a path above the folder (FR-33); on a root only, `state()` (branch or detached identifier, the short status word), `status()` (changed and staged entries), `diff(kind, path)` and `walk(tips, window)` (beyond v1) — every method read-only and returning plain data — and its one adapter, libgit2 linked without its HTTPS and SSH transports. The installed-`git` adapter, run with `--no-optional-locks`, is the port's standing substitute and is not built ahead of the risk that needs it (§ 11 R-1) | Any mutating call — checkout, index write, ref update, lock file. Spawning a process. The model. A file outside Git's own on-disk layout |
| `watcher` | crates/nozoki-core | One FSEvents subscription on the granted folder, the root's `.git` entry included, delivering coalesced change events as paths; nothing else | Reading content. Interpreting a change. Any write |
| `folder-model` | crates/nozoki-core | The in-memory model of exactly one folder (FR-1): the tree, the selection and expansion, the open file, the Git state where the root finding says `root` and none where it says `plain`; every read held as an item carrying an `ItemState` (§ 4 C-I1); the **reducer** that applies reader results and watcher events and keeps the reader's place (FR-27); **replace-whole** — a new folder replaces the model as a value, never mutates it (NFR-12); the projections the surfaces draw; and the plain Rust API the host wraps and the harness calls (SM-5) | I/O of any kind. The Tauri runtime. Own state. Rendering |
| `markdown-renderer` | crates/nozoki-core | Markdown → sanitized HTML on the host, from bytes `fs-reader` read: an allowlist admitting no script, style, frame, object, event attribute or `src`, with one rewrite — an image whose reference passes the containment check becomes an `<img>` on the `nozoki-asset` scheme, every other image a stated placeholder; an external link inert text with its destination readable; a relative link a data attribute (`docs/SRS.md` FR-32, NFR-16; `docs/UXD.md` UX-I12) | Any network. Emitting a `file:` or `http(s):` URL. Reading the file itself. The raw-source view (§ 9 TO-5) |
| `own-state` | crates/nozoki-core | The tool's own remembered state — theme, window frame, and beyond v1 the remembered folders as security-scoped bookmarks with display names and which was viewed last — read whole or discarded whole, written only inside the app's container (FR-21, DR-5) | Anything of the folder's content. The diagnostic log. A path outside the container |
| `ipc-surface` | crates/nozoki-app | The Tauri 2 host and **composition root**: the closed command list and the events the renderer receives (SM-4); the asset handler serving bytes only for a path the containment check passes; the Open panel and the sandbox grant; the one window; the entitlements, the capability file and the Content Security Policy (§ 4 C-R2, C-R7); the diagnostic log writer (§ 4 C-I2); wiring the libgit2 adapter to the Git port | Read logic — every command delegates to `folder-model` and formats the result. Any plugin. A second window. A terminal line |
| `surfaces` | nozoki-ui | The shell the UXD draws: the rail, the tree, the reading panel and its treatments (code, rendered Markdown, and beyond v1 the diff), the Git view (and beyond v1 the history beneath its changes list), the chrome with the identity element and the theme control (`docs/UXD.md` § 4, § 6); the highlighter with its six bundled grammars; the theme tokens; the message catalogue. It draws projections and draws no state the host did not send | Filesystem, network or shell capability of any kind. Building a URL from content. A fetch, a socket, a dynamic import of a URL. A message not in the catalogue. A dialog, a toast, a notification |
| `read-only-harness` | checks | The scripts and fixtures that prove the promises on every build and every release: `read-only.sh`, `no-network.sh`, `bundle.sh`, `own-state.sh`, `churn.sh`, `latency.sh`, `structure.sh`, `deps.allow`, the fixture folders — a repository, a plain folder, a folder inside a repository, a parent of two repositories, a linked worktree, a submodule, a hostile Markdown corpus (§ 4 C-I3) — and, from `promise-one-point-zero`, `contract.sh` with the pin `contract/<major>` it reads (§ 4 C-I6) | Being a dependency of any shipped unit. Driving the rendered UI. Shipping in the bundle |

**Four physical units carry the nine parts.** `crates/nozoki-core` is a Rust library that imports
no Tauri crate, so the harness links it without a window; `crates/nozoki-app` is the Rust binary
and the only unit that imports Tauri; `nozoki-ui` is a TypeScript package bundled into the app and
holding no capability; `checks` is build-time and never shipped. The unit set is the one ADR-0009
records (`docs/adr/0009-physical-module-set.md`); the `crates/` placement is the owner's ruling
for every Rust product in this instance as `docs/nfdr.md` § 9 carries it (RN-4). Only `git-reader`
imports the libgit2 binding; only `own-state` and the host's log writer write anything; the
readers, the watcher and the renderer import neither the model nor one another, with one stated
edge — `markdown-renderer` calls `fs-reader`'s containment check.

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
| `crates/nozoki-app` | `Rust` | `crate` |
| `nozoki-ui` | `TypeScript` | `package` |
| `checks` | `Shell` | `directory` |

The TypeScript frame — `package.json`, `vite.config.ts` and the packet's tree — lands inside
`nozoki-ui/`, where the card's own test command goes to find it. `checks` is `directory` because
it builds nothing and is forbidden from being a dependency of any shipped unit; Shell is its
language because the card declares Shell for the `checks/*.sh` harness by name (RN-36).

**The seams.** Each names what crosses and which side owns the contract.

| Seam | What crosses | Owner of the contract |
|---|---|---|
| `SM-1` `fs-reader` ↔ `folder-model` | Down: a path to list or read. Up: the listing, or the bytes with the text rule applied and the floor language named, or the condition observed — always as data, never a panic | `folder-model` — it states what a read must return; the reader implements it |
| `SM-2` `git-reader` ↔ `folder-model` | Down: `probe`, and on a root `state`, `status`, `diff`, `walk`. Up: `root` or `plain`; plain-data Git state; or the condition observed. The port is a trait the model owns; the adapter is the only thing that knows libgit2 | `folder-model` — the port is its; a second adapter passes the same contract tests (§ 11 R-1) |
| `SM-3` `watcher` ↔ `folder-model` | Up only: coalesced change events as paths, the root's `.git` entry among them. The model decides what to re-read | `folder-model` — the event shape is its |
| `SM-4` `ipc-surface` ↔ `surfaces` | Down (renderer → host): commands from this list and no other — `open_folder`, `list_tree`, `select_file`, `open_relative_link`, `set_theme`, `open_diff`, `walk_history`, `switch_folder` — each crossing from the build in which a slice registers it and not before, and all eight from `v1.0.0`; and asset requests on the `nozoki-asset` scheme, from the slice that settles its origin form. Which of the list a given build grants is stated once, in § 4 C-R7. Up (host → renderer): the `model_changed` event carrying a projection delta. Nothing else crosses in either direction, and **this seam is the promise**: a builder of the renderer who holds only this contract cannot write, cannot connect and cannot read outside the folder | `ipc-surface` — the host registers the commands its landed slices built and grants exactly what it registers (§ 4 C-R7); the renderer receives what is registered and nothing more |
| `SM-5` `folder-model` ↔ `ipc-surface` | Down: the operations the commands name, as plain Rust calls. Up: projections and deltas. The harness calls this API directly, in-process, with no window (§ 4 C-I3) | `folder-model` — the API and its types are its; the host wraps, formats and delegates |
| `SM-6` `own-state` ↔ `ipc-surface` | Down: the theme set, the window frame, and beyond v1 a folder to remember. Up: the state read whole, or the first-run state where it could not be read | `own-state` — the record shape and the read-whole-or-discard-whole rule are its |
| `SM-7` `markdown-renderer` ↔ `fs-reader`, and the asset handler in `ipc-surface` | Rendering asks `fs-reader` whether an image reference is contained; serving asks the same question again on every request. Only a path that passes both is ever read; a bypass of the sanitizer or the CSP still reaches no byte outside the folder | `fs-reader` — the check is its and has one implementation; the two callers do not re-implement it |

**Three deliverables, one bundle.** The nine parts ship as `Nozoki.app`: the host binary with
`nozoki-core` linked in, and the renderer's built assets inside `Contents/Resources`. `checks`
runs against that bundle and is never inside it.

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
  (the work stopped and nothing read accounts for it — `docs/UXD.md` UX-I16). A surface draws a
  marker, a count or a "nothing changed" only from `observed` (UX-I13). This is the mechanism
  behind § 4 C-I1 and NFR-3.
- **`FileView`** — the open file (DR-3): its folder-relative path; its content as one of *text*
  (with the floor language or *plain*), *markdown* (the sanitized HTML), *cannot-display* (the
  reason), or *gone* (the file vanished under the reader — FR-28); the reading position the
  reducer preserves across a refresh (FR-27). In-session only.
- **`GitState`** — present only where `kind` is `root` (DR-4): the branch name or, detached, the
  commit identifier; the changed entries and the staged entries, each with its status letter; the
  short status word; and beyond v1 the history window — commits with identifier, message, author,
  date, parents and branch membership, against a chosen tip set — and a `Diff` (path, staged or
  unstaged, hunks). Derived by read-only means, never persisted.
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
  `com.kensaiapp.nozoki`: a Tauri 2 host (`crates/nozoki-app`, Rust) over the `nozoki-core`
  library, rendering `nozoki-ui` in the system WKWebView. No browser engine is bundled, no
  runtime is installed, and every asset a surface renders — fonts, the six grammars, the fourteen
  icons, the stylesheets — ships inside the bundle (`docs/SRS.md` C-3, NFR-13; `docs/UXD.md`
  UX-I15). *Violated by:* a second binary, a prerequisite the README must name, an asset fetched
  at runtime. The Principal Architect's record is ADR-0002 (RN-2).
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
  **What the rule is known to cost is § 10 RC-2:** under it the system WKWebView does not start in
  this bundle, and which gives way — the renderer C-R1 names, or nothing — is the owner's, open in
  the companion. *Violated by:* a network entitlement of any kind on any build; an entitlement
  outside the named set with no record naming its need; a build whose bundle the probe (C-I3)
  finds unsandboxed, or reports the out-of-grant read or the outbound connection allowed. The
  record is ADR-0003, from which this condition departs on the one word *exactly* (RN-52).
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
  is `14.0` and the floor is stated wherever the install path is offered (C-11). The runtime does
  not force it — Tauri 2 supports "macOS Catalina (10.15) and later"
  (https://v2.tauri.app/start/prerequisites/) — so the floor is the maintainer's narrowing: it is
  the oldest macOS the timed release walk (AC-10) is run on, and one WKWebView generation fewer
  to hold the walls (C-R7) against per release. The value is the one `docs/nfdr.md` QC-56 already
  binds, kept because nothing upstream moved to change it (RN-6). Raising it after 1.0.0 is a
  breaking change under C-6. *Violated by:* a bundle whose plist says otherwise, an install page
  that does not state it.
- **C-R6.** **Every dependency is a decision, and the tree is reviewed as code.** `Cargo.lock`
  and `pnpm-lock.yaml` are committed; CI installs with `--locked` and `--frozen-lockfile`; every
  crate and package the bundle contains is named in `checks/deps.allow`, and a lockfile diff that
  adds a name outside it fails the build until the allowlist change is reviewed in the same
  change. libgit2 is built without its HTTPS and SSH transports; no shipped unit links a network
  transport (NFR-8). Each dependency's licence rides into `THIRD_PARTY_NOTICES.md` (C-5).
  *Violated by:* a dependency added without an allowlist line, a lockfile not committed, a
  transport-bearing build of libgit2.
- **C-R7.** The renderer's Content Security Policy, declared in `tauri.conf.json`, is
  `default-src 'none'; script-src 'self'; style-src 'self'; img-src 'self' data: <asset-scheme>;
  font-src 'self'`, where `<asset-scheme>` is the origin form settled for `nozoki-asset` (Open
  Questions); no directive admits `http:`, `https:`, `file:`, `asset:` or `*`. **A build grants
  the renderer exactly the commands its landed slices register**, in the host's capability file,
  and no plugin. That set is always inside SM-4's list, and no command is granted before a slice
  registers it. From `v1.0.0` the set is SM-4's list whole (§ 6 S-11, C-I6). The check holds set
  equality between the commands the capability file grants and the commands the host registers,
  and holds that set inside SM-4's list; it reads the registered set and never a hand-kept copy
  of it. So a command whose slice has not landed is never granted, and two slices that each
  register a command apart from one another meet at one set when their changes are joined. The
  asset scheme enters the grant in the slice that settles its origin form (§ 6 S-3), keyed on
  this clause's own state: while the policy above carries the `<asset-scheme>` placeholder, no
  asset scheme is granted; where that grant is written is part of the same Open Question. **Not
  covered before `v1.0.0`:** a later change that stops registering a command an earlier slice
  built passes this check, because the grant and the registration move together. Only that
  slice's own bar holds the command until C-I6's pin exists — C-6's pre-1.0.0 half, stated
  rather than tested (§ 11 R-12) (NFR-16, NFR-8). *Violated by:* a command granted that the host
  does not register, or registered and not granted; a granted command outside SM-4's list; an
  asset scheme granted while the placeholder stands; a plugin; any widening of the policy's
  directives.

**Instrumentation and failure visibility.**

- **C-I1.** Every read is an `Item` with an `ItemState` (§ 3), and a failure is a state, not an
  exception: a failure to read one file, one entry or one part of Git state yields `failed` or
  `stopped` on that item and `observed` on its siblings, and the next successful read of the same
  item replaces it without ceremony (NFR-3; `docs/UXD.md` UX-I10, UX-I16). No surface draws a
  marker, a count or a "nothing changed" from an item that is not `observed` (UX-I13).
  *Violated by:* a read path with no item state, a panic that reaches the host, a marker drawn
  from `pending`.
- **C-I2.** The product's only diagnostic output is one log file at
  `~/Library/Containers/com.kensaiapp.nozoki/Data/Library/Logs/nozoki.log` — the app's own
  container, which is where the sandbox places the product's writable data — holding one line per
  `failed` or `stopped` item naming the part, the operation and the error text; never file
  content, never a path outside the folder's own entries, never transmitted. A launch creates it
  or truncates it; within a session it is bounded to 1 MiB on disk, past which it is emptied and
  writing continues; a failed write surfaces nowhere, stops nothing and is not retried (NFR-11).
  No internal text — no stack trace, error code or library name — reaches any surface; every
  message a surface shows is a whole sentence from the renderer's catalogue (UX-I6). *Violated
  by:* a second log, a line carrying content, a diagnostic on a surface, a log outside the
  container.
- **C-I3.** **The promises are proved on every build, from the first slice's first green build.**
  `checks/read-only.sh <fixture>` hashes a fixture (`.git` included where there is one), exercises
  every command the build grants (C-R7) through SM-5 in-process, hashes again, and prints `unchanged` or the
  differing paths — the plain-folder criterion "no `.git` and no entry of any kind has appeared"
  (AC-24) is the same hash; `--kill` sends SIGKILL to the host mid-churn and re-hashes (NFR-4).
  `checks/no-network.sh` diffs `cargo tree` and `pnpm ls` against `deps.allow`. `checks/bundle.sh`
  reads `codesign -d --entitlements :- Nozoki.app` against C-R2's exact list, then launches the
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
  `nozoki-core` and the command list, **not the rendered UI**: Tauri's WebDriver support states
  "macOS has no WKWebView driver tool" (https://v2.tauri.app/develop/tests/webdriver/), so the
  rendered UI's whole-product check is the timed release walk (AC-10) and the renderer's actual
  command use is covered by holding no capability the harness could catch it using (§ 9 TO-7).
  **The renderer's run is proved on the shipped bundle, beside the wall** — the owner's ruling
  (`docs/trail/sdd/cycle-8.md` § 5.1, answer 4), because a bundle passed every gate above and
  opened an empty window (§ 10 RC-2). `checks/renderer.sh Nozoki.app` launches the bundle CI
  built, as a user launches it, takes the pid the way `checks/bundle.sh` does, and within a
  bounded window of the same kind fails unless the launched main process is observed **inside
  `open_folder`** — the renderer's first and only unconditional command, invoked at page load
  (`nozoki-ui/src/main.ts:L14-L19`) and parked in the Open panel until someone answers it
  (`crates/nozoki-app/src/main.rs:L17-L19`). This is not the harness driving the rendered UI: it
  is the operating system's or the process's own report that the page ran far enough to call the
  host. The mechanism measured on one Mac is a thread sample of the launched pid showing the
  command's frames — `pick_folder → run_on_main` present exactly where the window drew and
  absent where it did not (`docs/trail/sdd/cycle-8.md` § 5.1, the sample table) — and the script
  fixes which mechanism it reads; what it may never read is a marker the product writes for the
  check, an environment variable, or a code path that exists for the gate: the shipped bundle is
  the artifact under test and holds nothing for the test. The gate's negative control is the same
  bundle with its renderer build removed from `Contents/Resources` (the build `checks/bundle.sh`
  reads before launch, its v1.3.0 line), which must go red — a page that never loads never
  reaches `open_folder`. It runs on every CI build after `checks/bundle.sh` and never instead of
  it: a wall proven on a bundle whose window never draws proved nothing a person could use, and a
  window that draws on a bundle the wall is not proven on is the shape unchosen (§ 5 step 4, E-1).
  Whether the observation reads the same on a GitHub-hosted macOS runner is unmeasured (*Open
  Questions*).
  The record is ADR-0008. *Violated by:* a build that skips a script, a bundle probe run without
  its negative control, a probe that reads the report once, an ask judged on a pid that no longer
  names a process, a control passed on fewer asks than the window, a bound not printed on a red
  run that ended because the window ran out or on a pass, a failed-ask run that does not name
  what failed, a renderer gate skipped or run without its control, a renderer-gate observation
  read from anything the product wrote or from a path that exists for the gate, a slice
  that lands a command the harness does not exercise, a release without AC-1 – AC-3 green.
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
  from the built bundle and the build's capability file — the macOS floor as
  `LSMinimumSystemVersion` prints it, the release's asset names (`Nozoki-<version>.dmg`,
  `SHA256SUMS`), and SM-4's command list as the capability file grants it — and nothing else: no
  message, no token and no line of the log, which the contract excludes (§ 6 S-11 *Delivers*).
  `checks/contract.sh <tag>` takes the pin as `git show v<major>.0.0:checks/contract/<major>` —
  the tag anchors it, so an edit to the working-tree file cannot move what a release is held to —
  and fails when the bundle's floor is above the pin's, a pinned asset is missing from the
  release, or a pinned command is absent from the capability file. It reads the priced set — C-R4,
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
  identifier, and by any read outside the granted folder and the app's own container.
- **C-D2.** The only writes the product performs are `own-state`'s and C-I2's log, both inside
  the app's container; nothing is written under the granted folder under any operation, and
  nothing of the folder's content is persisted anywhere (NFR-5, FR-21, DR-1, DR-5; AC-13).
  *Violated by:* a write anywhere else, a cache, a lock file, an index.
- **C-D3.** **Content is untrusted input** (DR-6, NFR-16): rendering executes nothing and loads no
  active content; every path derived from content or from outside — a tree entry, a symlink
  target, an image reference, a relative link, an asset request — passes `fs-reader`'s containment
  check before any open, and the asset handler re-runs it on every request. Three walls fail
  independently: the sanitizer, the CSP (C-R7), and the containment check — so a bypass of any one
  moves no byte across the folder's edge (SM-7). In-folder images are served for PNG, JPEG, GIF
  and WebP; SVG is excluded from the scheme in v1 because it is a document, not a bitmap, and the
  scheme serves bytes the sanitizer never sees (RN-8). An in-folder SVG therefore takes a
  placeholder stating that the format is one the tool does not render — UX-I12's "not an image"
  read as *not a bitmap format the asset scheme serves*, never as a file the tool could not read;
  the exclusion is a v1 cut with a stated reopening condition (RN-8). *Violated by:* an `<img>` on
  any other scheme, a path opened without the check, a `file:` URL anywhere.
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
  `system/experience/visual_restrictions.md` § `no-unestablished-state`). C-I1's `ItemState` is the
  mechanism; this is the surface's half of the same rule. *Violated by:* a marker drawn from
  `pending`, an empty Git view standing in for `stopped`, a spinner that moves on a timer.
- **C-E2.** **The reader's place survives every refresh.** Expanded nodes, the open file, the
  sidebar mode and the reading position hold through every update the reader did not ask for; only
  what actually changed changes; an update arrives with no notification, flash or attention bid;
  and what is shown is the folder's current state or is marked as no longer there — never stale
  content presented as current (UX-I2, UX-I3, UX-I4). *Violated by:* a refresh that collapses a
  node or resets a scroll position, a toast on change, a vanished file still shown as present, a
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
  *Violated by:* a message naming a cause the tool inferred, a string that is not a catalogue
  sentence, a next step named where the tool observed that nothing can be done.
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
  § `no-author-only-surface`). C-R7 and C-D3 make it structurally true. *Violated by:* a web font, an
  icon from a CDN, a glyph the tool does not ship.
- **C-E8.** **No meaning by hue alone, and no control by glyph alone**, in both themes: every state
  distinction carries a letter, word, shape or position that survives without colour, and every icon
  sits beside a text label or has a text form the surface shows; the contrast floor is the number
  `docs/DESIGN.md` § *Colors* states, and no surface falls below it. All of it sits inside UX-A1's
  stated posture — mouse-driven, no keyboard model, no assistive-technology promise — and no surface
  claims beyond it (UX-A1, UX-A2, UX-A4, UX-I8). *Violated by:* a staged/unstaged distinction told
  by colour only, an unlabelled icon, a shortcut a surface advertises, a conformance a surface
  claims.
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
  forces a shape § 2 rejected, which is § 10's to record. Not too broad — no intermediate result
  inside it changes its direction.
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
  not yet safe.
- **E-4 → `see-git-status`**, one slice, both conditions together. Bar: AC-6 and AC-18 on a
  repository; AC-24 on a plain folder; AC-25 on the three openings, the linked worktree and the
  submodule. The plain-folder half is not a slice of its own because it is the same decision
  answered the other way — the root finding says `plain` — and a Git view that can show a root but
  not stay wordless on a plain folder fails the view-never-lies rule; nor is it a fragment, since a
  plain folder already opens after `open-a-folder`.
- **E-5 → `follow-the-folder`**, one slice, the filesystem and Git clauses together. Bar: AC-7,
  AC-8, AC-19 and AC-20, and the first latency figures printed. One decision is inside it — the
  reducer keeps the reader's place under churn — and the Git clause is that decision applied to one
  more kind of item, not a second decision.
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
connection by construction, and that a renderer holding only SM-4 can show a folder. **The first
slice is E-1 alone, with the harness and the bundle probe green** — a granted folder, its tree, the
reading panel empty, UX-S4 in the window, and `checks/bundle.sh` proving the entitlement list and
the sandbox on the built bundle. It is the smallest build that can be wrong cheaply: if the sandbox
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
  ran on, carrying the entitlements it ships with, and never a developer's dev-server window or a
  bundle re-signed by hand — and double-clicks it in Finder: the system Open panel appears with
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
  tool was started (UX-S4 Error, UX-I14). On no surface is there an affordance to edit, create,
  save or initialise anything, enabled or disabled (UX-I1); closing asks nothing (UX-I5); every
  sentence shown says what the tool did, what it observed and what to do next, and no internal text
  appears (UX-I6). With the network disconnected, all of the above renders identically (UX-I15).
  *Command (CTO):* the workspace exists as § 3 draws it — `crates/nozoki-core`,
  `crates/nozoki-app`, `nozoki-ui`, `checks/` — and `cargo build --workspace --locked` and
  `pnpm install --frozen-lockfile && pnpm exec vite build` each exit 0; `cargo tree -p nozoki-core`
  names no libgit2 binding and no TLS or SSH crate — no `git-reader` links in this slice (RN-9);
  `cargo test --workspace --locked` exits 0 with tests on the reducer's tree items, `ItemState`
  transitions and `fs-reader`'s containment check; `.github/workflows/ci.yml` builds `Nozoki.app`
  and runs every script below on every push. `checks/bundle.sh Nozoki.app` prints the entitlement
  set C-R2's rule fixes for this slice — the two v1 entitlements, no network entitlement — and
  finds the launched main process reported sandboxed, with the out-of-grant read and outbound
  network denied, and the no-entitlement control reported unsandboxed — the first proof that the
  wall stands under an ad-hoc signature (R-8; the observable is C-I3's, re-cut at § 10 RC-1);
  `checks/renderer.sh Nozoki.app` finds the same bundle's launched main process inside
  `open_folder` within its window, and its control — the bundle with the renderer build removed —
  goes red (C-I3; re-cut at § 10 RC-2). *Until the owner's call on the renderer (companion
  § 1.1), no build meets both halves: the bundle that passes `checks/bundle.sh` under C-R2's rule
  is a bundle whose WKWebView does not start (RC-2).* *The promise
  clause:* `checks/read-only.sh checks/fixtures/plain` and `checks/read-only.sh
  checks/fixtures/repo` each print `unchanged` after `open_folder` and `list_tree` on every entry,
  `.git` hashed where present; `checks/no-network.sh` exits 0; `checks/own-state.sh` finds the
  diagnostic log under `~/Library/Containers/com.kensaiapp.nozoki/` and no entry under either
  fixture (C-I2, C-D2).
- **Rests on:** § 2 (the shape — this is the slice that proves it); § 3 `fs-reader`, `folder-model`
  (the tree and the `pending` kind), `ipc-surface`, `surfaces`, `read-only-harness`; `SM-1`, `SM-4`
  (`open_folder`, `list_tree`), `SM-5`; § 4 C-R1, C-R2, C-R3, C-R6, C-R7, C-I1, C-I2, C-I3, C-D1,
  C-D2. Slices: none — this is the first.
- **Traces to:** PRD § Key Use Cases 1; § UX Notes "The path" 1, "Failure states"; § Success
  Metrics "Zero required configuration"; § Scope (In) "Run posture", "Platform". SRS: FR-1, FR-2,
  FR-3, FR-4, FR-5, FR-23; NFR-4, NFR-5, NFR-8, NFR-9, NFR-11, NFR-14; DR-1, DR-2, DR-6; C-1, C-2,
  C-11; AC-9, AC-15 (the failure half), AC-24 (the tree and the empty state — the Git view's
  absence is `see-git-status`'s to fill).
  UXD: § 4 *Information Architecture* (one window, one shell; the sidebar beside a dominant
  reading panel); UX-U3 (one local folder, a repository or not); UX-F1 — the arrival, up to and
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
  shape (§ 5 step 5): the wall — entitlements, sandbox under an ad-hoc signature, a renderer holding
  only `SM-4` — is the design's whole claim, and this slice shows it with no Git, no watcher and no
  Markdown to unpick if the probe fails. Its result changes what happens next, which is step 4's
  test for not-too-narrow.

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
  `select_file` is on `SM-4`'s list and in the capability file — `cargo test --locked -p nozoki-app --test config` passes set equality;
  `cargo test --locked -p nozoki-core` includes `fs-reader` tests that, for every extension in
  C-I5, name that floor language, and for `checks/fixtures/text/` — a file with no extension, a
  file with an extension outside the set, a shell script whose only marker is a `#!/bin/sh` first
  line — yield *plain*, for a UTF-16 fixture that begins with its byte-order mark and for an
  empty file yield *text*, and for a fixture that decodes as neither UTF-8 nor marked UTF-16 —
  Latin-1 bytes, and a file torn mid-sequence — yield *cannot-display* with its reason (RN-41);
  `pnpm exec vitest run` includes reading-panel tests that a keystroke, a paste and a drop leave the
  rendered content unchanged and issue no command, and that the panel is named by the file's
  folder-relative path; `pnpm exec vitest run tests/architecture` passes (no `fetch`,
  `XMLHttpRequest`, `WebSocket`, `EventSource`, `sendBeacon` or URL import in `nozoki-ui`); the six
  grammars are files under `nozoki-ui/src/` and ship in `Contents/Resources`. *The promise clause:*
  `checks/read-only.sh` on both fixtures prints `unchanged` after `select_file` on every entry, the
  non-text ones included; `checks/no-network.sh` and `checks/bundle.sh` exit 0.
- **Rests on:** § 3 `fs-reader` (the text rule, the extension map), `folder-model` (`FileView`),
  `surfaces` (the reading panel and the highlighter); `SM-1`, `SM-4` (`select_file`); § 4 C-I5,
  C-I1, C-D3 (the containment check on every tree path before open). Slices: `open-a-folder`.
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
  event attribute, a frame, a style, a remote image, an in-folder PNG, an in-folder SVG, a `..`
  image path, a symlink-out image path, an external link and a relative link — with output that
  contains no `<script`, no `on*=` attribute, no `<iframe`, no `<style`, and exactly one `src=`,
  on the in-folder PNG, on the `nozoki-asset` scheme; the remote, `..` and symlink-out references
  each yield the not-fetched placeholder and the SVG the observed-condition placeholder (C-D3); the
  external link is inert text with its destination visible; the relative link is a data attribute;
  the asset handler returns the PNG's bytes for its path and nothing for every escaping path, on a
  second call with the same inputs. `open_relative_link` is on `SM-4`'s list; `cargo test --locked
  -p nozoki-app --test config` passes string equality of the CSP against C-R7 with the
  `nozoki-asset` origin form found — the third Open Question closes and C-R7 is updated in this
  slice. *The promise clause:* `checks/read-only.sh checks/fixtures/repo` prints `unchanged` after
  rendering every `.md` under it and requesting every asset; `checks/no-network.sh` exits 0.
- **Rests on:** § 3 `markdown-renderer`, `fs-reader` (the containment check), `ipc-surface` (the
  asset handler); `SM-4` (`open_relative_link`, the asset scheme), `SM-7`; § 4 C-R7, C-D3; § 9
  TO-5, TO-6; § 11 R-4, R-10, R-11. Slices: `read-a-file`.
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
  as HTML, and so the first that must prove C-D3's three walls — cheaper to prove on one treatment,
  with the hostile corpus, than after the diff and the history have added two more; and because
  no public release may ship a `.md` shown as plain text (RN-18), so it must precede
  `first-public-release`.

### S-4 — What Git says, where there is a Git to ask

- **Slug:** `see-git-status`
- **Delivers:** After this, a developer can switch the sidebar to Git and — where the opened
  folder is itself a repository's root — see the branch, the changed files, the staged files and
  the short status, with changed files marked in the tree, a mid-merge, mid-rebase or detached
  repository shown as the state it is in, and a changed file's row opening that file to read;
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
  each with its text cue (UX-S2 Success). They click a changed file's row: the file opens in the
  panel to read, exactly as a tree selection would — one click target, the status letter a label
  (UX-F2, the first reading). They switch back to Files: the open file and their reading position
  are untouched (UX-F2). A repository mid-merge, mid-rebase or detached shows that state, presented
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
  the R-3 case, injected because the in-process harness runs under no sandbox grant and the
  `linked-worktree` fixture reads fine there — and the model holds the Git item as
  `failed(condition)` with that path as the condition, no folder path in it, and every tree item
  `observed` (C-I1; RN-44); `checks/read-only.sh checks/fixtures/repo` with `.git/index` in the hash
  prints `unchanged` after `probe`, `state` and `status` — no optional-lock refresh (TO-2);
  `checks/structure.sh` finds no `std::process` in any shipped crate and the libgit2 import in
  `git-reader` alone. *The promise clause:* `checks/read-only.sh` on all six fixtures prints
  `unchanged`; `checks/no-network.sh` exits 0.
- **Rests on:** § 3 `git-reader` (the port, `probe`, `state`, `status`), `folder-model` (`kind`
  resolved; `GitState`; the tree's markers), `surfaces` (the rail's Git entry, the Git view);
  `SM-2`, `SM-4` (`model_changed` carrying Git state); § 4 C-R6, C-I1; § 9 TO-2, TO-10; § 11 R-1,
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
- **Reached when:** *Observable (CDO):* with Nozoki open on a folder, they run a script in a
  terminal that creates, changes and deletes files for thirty seconds. The tree changes on its own
  as the disk does, and nothing else moves: the nodes they had expanded stay expanded, the selected
  file stays selected, the sidebar stays on the mode it was on, and the panel's scroll position does
  not jump (`docs/UXD.md` UX-I3, UX-F3). No refresh control exists anywhere, and no update
  announces itself — no toast, no flash, no badge (UX-I2). The script changes the open file: its
  content updates in place, the reading position kept. The script deletes it: the panel keeps the
  file's name and states plainly that it is no longer there, and its old content is not shown as
  current (UX-S1 Error, UX-I4). The script stages, commits and checks out branches: the Git view
  and the tree's markers follow, each marker appearing only once the new state has been read
  (UX-S2 Loading, UX-I13). The script runs `git init` at a plain folder's root: the Git view fills
  and markers appear; it removes `.git`: the view empties and the markers go — without ceremony,
  their place untouched (UX-I17). Throughout, the window never blanks, blocks or closes; an entry
  made unreadable mid-run is marked with what was observed and the rest of the tree stands (UX-S2
  Error, UX-I10). When the script stops, what the window shows is what `ls -R` and `git status`
  show. They quit mid-run: no prompt (UX-I5). *Command (CTO):* `cargo test --locked -p nozoki-core
  --test watch` passes while `checks/churn.sh <fixture> 30` runs — thirty seconds of create,
  modify and delete including the displayed file, Git operations mid-flight, and `git init` at a
  plain root followed by its removal — with no panic, the model's final snapshot equal to a fresh
  open of the fixture, and expansion, selection and reading position surviving; an unreadable entry
  yields `failed` on that item and `observed` on its siblings; `checks/read-only.sh` against the
  churn's own final state as baseline prints `unchanged`; `checks/read-only.sh --kill` — SIGKILL to
  the host mid-churn — prints `unchanged` (NFR-4); `checks/structure.sh` finds the FSEvents
  subscription in `watcher` alone; `checks/latency.sh` exits 0 and prints file-switch and refresh
  p95 in milliseconds over `checks/fixtures/scale-small`, `scale-medium` and `scale-large` on every
  CI build — the first figures, which go to the SRS by revision and are asserted nowhere here
  (C-I4). *The promise clause:* the two `read-only.sh` runs above; `checks/no-network.sh` exits 0.
- **Rests on:** § 3 `watcher`, `folder-model` (the reducer, keyed by path; the root finding re-run
  on the `.git` entry), `surfaces` (the file-gone state); `SM-3`, `SM-4` (`model_changed` deltas);
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
  afterwards, and no file in it changed. *Command (CTO):* `set_theme` is on `SM-4`'s list and in
  the capability file (`--test config` passes); `cargo test --locked -p nozoki-core` includes
  `own-state` tests that a record is read whole, that an unreadable or foreign-shaped record yields
  the first-run state and never a partial one, and that the record holds the theme and the window
  frame and no other field (C-D4); `checks/own-state.sh` after a session in which the theme
  changed finds every changed file under `$HOME` inside
  `~/Library/Containers/com.kensaiapp.nozoki/` and none under the fixture, and inspection of the
  container finds the theme, the window frame, the log and nothing of the fixture's content;
  `checks/structure.sh` finds the container path in `own-state` and the host's log module alone.
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
  passes with C-R2's two entries; `checks/notices.sh` finds every name in `cargo tree` and `pnpm ls
  --prod` in `THIRD_PARTY_NOTICES.md`; `LICENSE` is MIT; `SECURITY.md` exists and `gh api
  repos/kensaiapp/nozoki/private-vulnerability-reporting` returns `"enabled": true`; `cargo audit`
  and `pnpm audit --audit-level=critical` exit 0; `gitleaks git` exits 0 and `gh secret list --repo
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
  on the port and `open_diff` joins `SM-4`'s list and the capability file (`--test config` passes with the wider
  set); `cargo test --locked -p nozoki-core --test git_state` passes diff cases over
  `checks/fixtures/repo` — a file with staged changes only, unstaged only, both (two diffs, told
  apart in the data), an untracked file — and a file removed between `status` and `diff` yields
  `failed` on that item with the file's tree entry still `observed`; the renderer's diff treatment
  is a surface test in `pnpm exec vitest run` that staged and unstaged carry a text cue and not
  colour alone. *The promise clause:* `checks/read-only.sh checks/fixtures/repo` with
  `.git/index` hashed prints `unchanged` after `open_diff` on every changed entry;
  `checks/no-network.sh` exits 0.
- **Rests on:** § 3 `git-reader` (`diff`), `folder-model` (`Diff`), `surfaces` (the diff
  treatment of the reading panel; the row's second reading); `SM-2`, `SM-4` (`open_diff`); § 4
  C-I1, C-R7 (the diff is text the renderer draws, never HTML from content). Slices:
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
  window)` is on the port and `walk_history` joins `SM-4`'s list and the capability file (`--test config` passes); `cargo test
  --locked -p nozoki-core --test git_state` passes history cases over `checks/fixtures/history` —
  a repository whose branches diverge and merge — returning, for the requested tips and a window of
  1,000 commits (RN-35), each commit's identifier, message, author, date, parents and branch
  membership, the tips named, and a flag that the window ended before the walk did; the default
  request the renderer sends names HEAD and every local branch sharing a commit with it inside the
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
  against C-R2's three entries; `switch_folder` joins `SM-4`'s list and the capability file
  (`--test config` passes); `cargo test --locked -p nozoki-core --test switch` passes: opening B
  after A yields a model equal to a fresh open of B with no item of A remaining, the root finding
  applied to B afresh; `own-state` holds A's and B's bookmark, display name and last-viewed mark
  and no folder content; an eleventh folder evicts the one viewed longest ago and no operation
  removes an entry; relaunching the bundle opens B with no Open panel, and relaunching after the
  container's remembered list is removed presents the panel (C-R3). `git diff --stat
  <first-public-release tag>..HEAD -- nozoki-ui/src/tree nozoki-ui/src/git-view
  nozoki-ui/src/reading-panel` prints nothing — the viewing surface untouched by the change that
  adds the selector (NFR-12). *The promise clause:* `checks/read-only.sh` prints `unchanged` on A
  and on B after the switch, `.git` hashed where present; `checks/own-state.sh` finds every write
  inside the container; `checks/no-network.sh` exits 0.
- **Rests on:** § 3 `folder-model` (replace-whole), `own-state` (bookmarks, the ten-entry list),
  `ipc-surface` (the grant restored from a bookmark), `surfaces` (the identity element become the
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
  build's capability file — the floor `14.0`, the two asset names, SM-4's eight commands — and
  `checks/contract.sh v1.0.0` passes against it (C-I6); `checks/own-state.sh --from
  <previous-tag>` passes — a container
  written by the previous release is opened by this build with no write outside the container, and
  a container the build cannot read leaves it at first-run state with no failure surface (C-D4);
  `checks/latency.sh`'s figures are within the numbers the SRS now carries, or the SRS still
  carries none and the figures are attached to the release (C-I4). *The promise clause, over the
  terminus whole:* `checks/read-only.sh` prints `unchanged` on every fixture after every command on
  `SM-4`'s complete list — `open_diff`, `walk_history` and `switch_folder` included — and after
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

- **TO-1:** Two processes and one serialized seam, with every projection crossing it — *buys* a
  renderer that can be handed *no* capability, so § 1's first question is answered by a list a
  reviewer reads (SM-4); *undoing it costs* the IPC surface rewritten as direct calls, the model
  untouched.
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
- **TO-4:** A rendering engine that is Apple's and moves with macOS — *buys* no bundled browser
  engine and a bundle that fits the install clock; *costs* a second wall (sanitizer and CSP, C-D3,
  C-R7) once untrusted content is HTML, and walls re-proved per WKWebView generation (C-R5);
  *undoing it costs* every surface rewritten (§ 2, "Undoing it").
- **TO-5:** The Markdown raw-source switch is **not built** — FR-31 permits it only "if it costs
  nothing", and it does not: switching "preserves the reading position both ways"
  (`docs/UXD.md` UX-I12), which needs a rendered↔source position mapping with no other use.
  A release ships rendered-only and says so where it is offered (AC-22); *buys* nothing added to
  the reading panel for a feature outside done; *undoing it costs* the mapping and one control.
  **The relative link opening its target is built** (FR-32's permission): a data attribute the
  renderer turns into the existing `select_file` command, on a path the containment check already
  validates — one attribute and no new capability (RN-10).
- **TO-6:** One asset scheme the renderer can address, and a wider `img-src` — *buys* a README
  whose in-folder images render in place with the network off (UX-I12); *costs* a containment
  check that must be right about `..`, symlinks, percent-encoding and Unicode normalization, run
  twice (SM-7); *undoing it costs* removing the handler and the scheme, the placeholder returning
  for every image.
- **TO-7:** No harness drives the rendered UI (C-I3) — *buys* a proof that runs in CI on macOS
  with no WebView driver; *costs* the renderer's actual command use being exercised only by the
  timed release walk — accepted because the renderer holds nothing the harness could catch it
  using; *undoing it costs* an embedded-WebDriver harness when one is worth its dependencies.
- **TO-8:** A macOS floor of 14 where the runtime allows 10.15 (C-R5) — *buys* one walk per
  release over the versions the maintainer will actually run, and fewer WKWebView generations to
  hold the walls against; *costs* every adopter on 12 or 13; *undoing it costs* a plist line and
  the walk widened — cheap before 1.0.0, a breaking change after it (C-6).
- **TO-9:** Ad-hoc signing, never notarized (C-R4) — *buys* a channel that costs nothing and
  holds no signing secret in CI; *costs* a Gatekeeper step inside every stranger's first five
  minutes, and a sandbox whose enforcement is proved by a probe rather than a signing chain
  (§ 11 R-2, R-8); *undoing it costs* a paid identity — a reversal the owner has ruled out
  (`docs/adr/0007-ad-hoc-signed-dmg-on-a-github-release.md` § Context).
- **TO-10:** A port for one edge only (SM-2) and none for the filesystem — *buys* the one
  substitution the design expects (§ 11 R-1) at one seam's cost; *costs* nothing insulating the
  filesystem edge, which is Apple's and stable; *undoing it costs* a second port, drawn the day a
  second filesystem is a live case, which nothing inside the terminus makes it.

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
  both are the Principal Architect's to bring into line (§ 12).
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
  network access. `open-a-folder`'s command half could not be met as written by the bundle its
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
- **Still unresolved:** The renderer (companion § 1.1). Whether `checks/renderer.sh`'s observation
  reads the same on a GitHub-hosted runner (*Open Questions*). ADR-0003 § Decision and NFDR QC-25
  (`docs/nfdr.md:L243-L245`) still state *exactly*, and are the Principal Architect's to bring
  into line (§ 12).

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
- **R-4:** A sanitizer bypass in the Markdown pipeline — *shows up as* the hostile corpus
  (`checks/fixtures/hostile.md`) producing HTML with a `<script`, an `on*=` attribute, a frame, or
  a `src=` on any scheme but `nozoki-asset`; *response* three independent walls (C-D3) so a bypass
  moves no byte across the folder's edge, and every reported bypass becomes a corpus line.
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
  runs on the canonical path, symlinks resolved and after decoding, has one implementation, and
  is called at render and again at every asset request (SM-7).
- **R-11:** Tauri 2's protocol registration or WKWebView's CSP handling of a custom scheme moves
  with a release — *shows up as* the local-image fixture rendering with a CSP violation on a macOS
  the floor admits; *response* the origin form is settled by the first Markdown slice and written
  into C-R7 (Open Questions); what moves is one directive and the scheme's registration, not the
  sanitizer or the check.
- **R-12:** A breaking change to the priced set ships under a minor or patch number by oversight
  — the floor raised in a plist line, a surface's command dropped from SM-4's list, an asset
  renamed — with every promise test green, because none of them reads the priced set — *shows up
  as* `checks/contract.sh` failing on the tag against the pin its major wrote (C-I6); before
  `promise-one-point-zero` it shows up as nothing, which is C-6's pre-1.0.0 half and not a gap;
  *response* the release is not offered, R-7's rule, and the change is reverted or carried to the
  next major with a new pin.

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
here. The item that ruling left open — the renderer that cannot start under it, companion
§ 1.1 — opens no PRD gap either: the PRD names no renderer, its § Dependencies / Integrations
naming the filesystem and Git alone, so whichever exit the owner takes changes nothing the
product promises, and the PRD stays at v15. The immediacy
thresholds the PRD leaves TBD are the SRS's to fold in by revision, and no slice here writes a
number for them.

**The SRS boundary.** This design changes no requirement. Every `FR-n`, `NFR-n`, `DR-n` and `C-n`
cited above is cited as `docs/SRS.md` v12 states it, and where the SRS delegates a value to this
document — the acquisition channel (C-3, RN-7), the macOS floor (C-11), the Git mechanism (§ 5.3),
the extension set (FR-29), the build-cost judgment on the raw-source switch and the relative link
(FR-31, FR-32), how the root finding is made (FR-33) — the value is fixed here and traced back. A
gap found in the SRS while designing is a companion item for the CTO's own SRS run, never a
rewrite from this document; none was found in this run.

**The UXD boundary.** This design changes no experience. Every `UX-` entry cited above is cited as
`docs/UXD.md` v10 (Settled) states it; the C-E conditions restate none of them and bind the slices to
them by reference. Where the UXD delegates to a document beside or below it — every token value to
`docs/DESIGN.md`, every message's wording to `docs/CONTENT.md`, where the diagnostic is kept to the
SRS (UX-I16) — this document cites the delegate and fixes nothing of its own. A gap in the UXD found
here is a companion item for the CDO's own UXD run, never a redesign from this document — even by
the seat that holds the UXD's pen in that run. One was found: UX-I12's in-folder image case names
no format, and § 4 C-D3 decides what an SVG is (`docs/trail/sdd/cycle-1.md` § 2.1, RN-31). One
defect in the UXD itself was found and is reported, not repaired from here: five citations in its
RN-29 no longer resolve (RN-32). The cycle-8 ruling and the renderer question it leaves (§ 10
RC-2; the companion's § 1.1) open no UXD gap: UX-I12 and § 9 name no renderer and no CSS, so the
UXD stands at v10 whichever exit the owner takes. What would move under a native renderer is
`docs/DESIGN.md`'s realisation sentence (its § Overview, RN-1) — in that document's own run, which
may trail this one — and no token value, no C-E condition and no *Traces to* UXD clause in § 6
(RN-53).

**The downstream boundary.** This document authors no ADR and designs no individual change. The
decision log already holds nine records written from the previous SDD
(`docs/adr/README.md`, ADR-0001 – ADR-0009); this run's § 2 table, § 9 and the Review Notes are
the three surfaces the Principal Architect reads, and where a decision here lands where a record
already stands, the record is cited rather than re-surfaced (RN-1). Where this document departs
from a record, the departure is a Review Note naming the record — one so far: C-R2 departs from
ADR-0003's "exactly these entitlements" on the owner's cycle-8 ruling (RN-52), and the same ruling
leaves C-R1 and ADR-0002 standing against C-R2 with the choice the owner's, not a departure this
document makes (§ 10 RC-2; the companion's § 1.1) — and the log is append-only: a departure is a
superseding record, never an edit. The enforcement store, `docs/nfdr.md`, is re-derived from § 4
where the two disagree (§ 4, opening note); the first run found no disagreement, one confirmation
(C-R5's floor) and one placement it takes from that document (the `crates/` layout, RN-4), and the
cycle-8 fold leaves one to re-derive: QC-25 states C-R2's members as *exactly*
(`docs/nfdr.md:L243-L245`) where C-R2 now states a rule (RC-2). One defect in the records themselves was found and is reported, not
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
  that path as the condition, no folder path in it, and every tree item `observed`. *Because* the
  observable half now states that case (RN-43) and the command half exercised nothing for it: the
  `linked-worktree` and `submodule` fixtures ran only through `root_finding`, and they cannot
  produce the failure on their own — the harness drives `nozoki-core` in-process (C-I3), under no
  sandbox grant, so libgit2 reads a gitdir outside the opened folder there without complaint; the
  failure R-3 names exists only under the bundle's grant (C-R2). A bar with one half checks one
  side of the slice. The double is the cheapest honest stand-in, and the check is the reducer's
  (C-I1: a failure is a state, its siblings `observed`), not the port's — R-3's *shows up as* stays
  the port's observation on a built bundle. Found while confirming RN-43 at run 4, round 2, and
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
  renderer's first and only unconditional call (`nozoki-ui/src/main.ts:L14-L19`) and it parks in
  the panel (`crates/nozoki-app/src/main.rs:L17-L19`), so a bounded window catches it the way
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
  the `log show` lines above; `nozoki-ui/src/main.ts:L14-L19`; `crates/nozoki-app/src/main.rs:L17-L19`;
  `crates/nozoki-app/Entitlements.plist`; `checks/bundle.sh` header, v1.3.0 line; ADR-0002 §
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
  the WKWebView and plain CSS on a public surface (C-E10), the CPO's if (a) is taken *(re: § 6
  S-1 *Reached when*, observable half; § 12 the UXD boundary; companion § 1.1; source:
  `docs/trail/sdd/cycle-8.md` § 5.1; `docs/DESIGN.md` § Overview, § Typography, § Shapes, RN-1;
  `docs/UXD.md` § 9, UX-I12; `README.md:L48-L49`; RC-2; RN-52)*.

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

- [OPEN: Whether a folder dropped on the Dock icon, or opened with *Open With*, is granted by the
  sandbox the same way as one chosen in the Open panel. Settled in the first slice by trying both
  against the built bundle; if not, C-R3 gains a clause saying those routes present the panel.]
- [OPEN: Whether libgit2 opens a repository correctly under a read-only user-selected grant with
  discovery disabled, for a plain `.git` folder and for a `.git` file naming a gitdir inside the
  grant. Settled by the first Git slice's `root_finding` and `git_state` fixtures running green
  on the built bundle; a failure is R-1 firing early.]
- [OPEN: The exact origin form WKWebView accepts in `img-src` for the `nozoki-asset` scheme, and
  whether Tauri 2's protocol registration on macOS serves it without a plugin. Settled by the
  first Markdown slice rendering the local-image fixture with no CSP violation; the form found is
  written into C-R7.]
- [OPEN: What the reference fixture sizes are (NFR-10) and what FSEvents coalescing latency the
  watcher sees on them. Settled by `checks/latency.sh`'s first figures, which the SRS then folds in
  by revision (`docs/SRS.md` RN-4); no number is written here before that.]
- [OPEN: Whether `checks/renderer.sh`'s observation — the launched main process seen inside
  `open_folder` — reads the same on a GitHub-hosted macOS runner as on the one Mac where a thread
  sample showed it (C-I3; § 10 RC-2). Settled by the gate's first run there, on whichever renderer
  the owner's companion call leaves standing; a runner that cannot observe it is a re-cut trigger
  on the gate's mechanism, never on the gate.]
