# ADR-0021: KA-Reader is a sandboxed single-process read pipeline — one process under the App Sandbox, a Rust core reached across one closed C-ABI seam of ten calls, Git state pulled by `read_git` and not pushed, and its promise held by the process's own entitlements

**Status:** Accepted — supersedes ADR-0013
**Date:** 2026-10-04

## Context

ADR-0013 decided the shape: one process under the App Sandbox, a Rust core reached across one closed
C-ABI function list, `SM-4`, and the promise held by the process's own entitlements. It named the
list as nine calls, "all nine from `v1.0.0`", and Git state was to reach the shell on the
`model_changed` callback (`docs/adr/0013-sandboxed-single-process-read-pipeline.md:L44-L47`).

What moved is the list. `see-git-status` shows the open folder's Git state, and no call on the list
as written could bring the Git item to the shell without changing an answer the shipped shell
already decodes. No registration call for `model_changed` existed. `open_folder`'s answer holds one
member, and the shell's decoder rejects an `opened` answer with any other. `list_tree` and
`select_file` answer as they do whatever the Git item holds. `folder-model` already carried the
operation, and no export reached it (`docs/SDD.md` § 10 RC-4, *Observed reality*, read at
`ka-reader@ca915a4`). The PM raised it, and the CTO's seat answered by amending the SDD first
(`docs/trail/sdd/cycle-25.md` § 5.1; `docs/SDD.md` RN-90).

The forces ADR-0013 recorded stand and are restated so this record reads alone. The one rule this
product must never break is negative — nothing writes to the viewed folder, nothing connects,
nothing read from the folder is executed — and each must hold through a crash (`docs/SRS.md` § 4.2
NFR-4; § 4.3 NFR-5, NFR-6, NFR-8, NFR-16). The folder is live, untrusted input (§ 6 DR-6). A
negative invariant is not held by a guarded domain core. It is held by withholding a capability at
a boundary something outside the code enforces, and that boundary is the process's own entitlements
(`docs/SDD.md` § 2, forces 3 and 5). The renderer left WKWebView on the owner's ruling of
2026-09-23, because every WebKit XPC service checks the host's entitlements at its own start and a
sandboxed host with no network entitlement fails the check (`docs/trail/sdd/cycle-9.md` § 1.1, the
owner's (a); `docs/SDD.md` § 10 RC-2; the mechanism is ADR-0011 § Context). A view that executes
nothing has nothing for a renderer wall to contain, and under one process the rule covers the whole
product (`docs/SDD.md` § 10 RC-3, *Observed reality*; RN-56, RN-60).

## Decision

The system is a **sandboxed single-process read pipeline**. Two read-only sources — the
filesystem and, where the granted folder is itself a repository's root, that repository's Git
state — feed one in-memory folder model, and the surfaces are projections of it. Everything runs
in **one process under the App Sandbox with no network entitlement** (ADR-0011): a Rust core
(`ka-reader-core`) that does all the reading, and an AppKit shell (`ka-reader-mac`) that draws the
model's projections and **holds no I/O of its own**. It reads no file, opens no connection, spawns
no process, hands no URL to another program, and imports no web engine (`docs/SDD.md` § 4 C-R7).

The seam between them is **`SM-4`, one closed C-ABI function list** exported by `ka-reader-bridge`:
`open_folder`, `list_tree`, `select_file`, `open_relative_link`, `read_git`, `set_theme`,
`open_diff`, `walk_history`, `switch_folder` and `asset_bytes`. Each is exported from the build in
which a change of its slice first builds it, and all ten are exported from `v1.0.0`. Beside the list
and not on it is `ka_reader_free`, the one release call, exported from the first build because every
return is an owned buffer it alone frees. Upward runs a `model_changed` callback carrying projection
deltas. The header is generated from the bridge's source and never hand-kept (`docs/SDD.md` § 3
SM-4).

**Git state is pulled and not pushed.** `read_git`, exported as `ka_reader_read_git`, takes no
argument and returns the open folder's Git item: `root` with the Git state, `plain`, `failed` with
its condition, or `pending` where no folder is open. It is on the list and not beside it because it
reaches the model over `SM-5`, so it is a command, and the read-only walk calls it in the build that
exports it (`docs/SDD.md` § 3 SM-4; § 4 C-I3; § 10 RC-4, *Changed*). The registration call for
`model_changed` is still not admitted. The slice that needs a push raises it, which is
`follow-the-folder`, and not before (§ 4 C-R7; RC-4, *Retained*).

**The seam is where the promise is read, not where it is held.** The wall is the process's
entitlements. The seam makes visible that the shell reads through the core alone, and
`checks/view.sh` shows on every build that the shell adds no I/O of its own (C-R7). That check is a
source scan and a link check, and is not a process boundary.

Adding a **read surface** — a diff, a history, a folder chosen at runtime, the Git item — is priced
cheap. Adding a **capability** — a write, a socket, a shell — costs a visible change to a boundary a
reviewer reads: an entitlement on the file `codesign -d --entitlements` prints, a function on
`SM-4`'s list, or a symbol on the scan's forbidden set (`docs/SDD.md` § 2, force 1; "Which side
this product falls on"). A call the list does not name is a re-cut, recorded in the SDD's § 10
before it is built, and `read_git` is the first (RN-90).

## Alternatives ruled out

- **Carry the Git item on `open_folder`'s return** — it changes an answer the shipped shell already
  decodes. The bridge holds an `opened` answer to one member, and the shell's decoder rejects any
  other, so every existing caller moves to serve one slice (`docs/SDD.md` § 10 RC-4, *Observed
  reality* and *Stopped*).
- **Admit the `model_changed` registration call now, and push Git state on it** — `see-git-status`
  has nothing to push: it shows "the state read when the folder opened" (§ 6 S-4, *Not in this
  slice*). A callback adds a function pointer, a context lifetime and a second thread to the one
  unit that holds `unsafe` (§ 11 R-13). Admitting it here builds `follow-the-folder`'s delivery ahead
  of that slice, against C-R7's "by the slice that needs it, and not before" (RC-4, *Stopped*;
  RN-90, *What the answer decides*).
- **Hold the delivery back until the list is settled some other way** — the owner chose to amend
  the SDD first over either of the two above or holding the delivery back
  (`docs/trail/sdd/cycle-25.md` § 5.1, *The route the owner chose*; RN-90).
- **The capability-split read pipeline** — ADR-0001's shape, held to SDD v12: the surfaces in a
  separate renderer process holding *no* capability, reached through a closed command list and one
  read-only asset scheme. The only renderer that fits refuses to start under the wall (RC-2). A view
  that executes nothing has nothing to be walled off from, so the second process guarded a threat
  the taken shape does not carry and cost a serialized seam. It returns only if a view that executes
  content *and* starts under the rule ever exists, and none is known (`docs/SDD.md` § 2, table
  row 2).
- **Hexagonal — a domain core behind ports, an adapter at every edge** — the edges are two, stable,
  and owned by Apple and Git, and the core would hold a folder model and no rule, so every port but
  one guards nothing. Its one useful port, the Git reader, is kept inside the taken shape (ADR-0019;
  `docs/SDD.md` § 2, table row 3).
- **Layered, one process — UI over services over a data-access layer** — the data layer's generic
  filesystem and network access is exactly the capability this product must not hold, so
  not-writing becomes discipline. It fails § 1's first question by construction (`docs/SDD.md` § 2,
  table row 4).
- **Local server + browser tab — the input proposal's "web app"** — a listening socket is a network
  call during operation, which NFR-8 forbids, and a browser tab is a second thing to install
  (`docs/SDD.md` § 2, table row 7).
- Which view draws the one process — AppKit in Swift over a Rust-native toolkit, an in-process web
  engine, and AppKit through `objc2` — is ADR-0014's weighing, not this record's.

## Consequences

Easier: one entitlements file and one probe cover everything the product runs (`docs/SDD.md` § 4
C-R2, C-I3). There is no script engine to wall off and no serialization on every projection. The
read-only and no-network acceptance criteria (`docs/SRS.md` § 8 AC-1 – AC-3) pass because the
write and the network are *absent*, not avoided. Every foreseen change is still a new read surface
on the same two sources, and the model in the middle survives every reversal below. Git state
arrives the way the three landed calls' answers do, as a call's return
(`crates/ka-reader-bridge/src/exports.rs:L55`, `:L73`, `:L90`, cited by RN-90), and being a command, it
is walked by the read-only harness in the build that exports it.

Harder: the renderer wall — a process that could be handed *no* capability — is gone. In its place
is a shell whose "no I/O of its own" is a source scan and a link check on every build (C-R7), so an
API the scan does not name is caught by review, not by a red build. There are two languages and one
C ABI between them (ADR-0014, ADR-0020). The bridge is the one unit that holds `unsafe`, and a
misused buffer or a panic crossing the seam is a crash inside the wall (`docs/SDD.md` § 11 R-13;
`docs/SRS.md` NFR-4). The list grows by one call. From `v1.0.0`, `read_git` is inside the export set
the contract pin reads, so dropping it inside a major fails the pin (§ 4 C-I6). Git state on screen
is what the last ask returned. Nothing pushes a change to it until `follow-the-folder` raises the
registration call. When the model reads Git state, whether a `failed` item is asked again, and which
side orders two asks in flight, were left to the change that builds the call (RC-4, *Still
unresolved*). That change settled the first two: the item is read on the first ask after each
successful open, and an `observed` or `failed` item is answered with no second read
(`crates/ka-reader-bridge/src/session.rs:L650-L653`, cited by RC-4's dated note, RN-91).

What undoing it costs: *moving the view into a second process* costs the bridge re-wired as IPC and
nothing else, because the model, the readers and the harness survive. That is cheap in code, and
blocked while the rule stands for any view whose processes check the host's network entitlement
(RC-2). *Removing the sandbox* costs one entitlements file, and the wall goes with it, which is why
its presence is checked on every build rather than assumed (ADR-0010) (`docs/SDD.md` § 2, "Undoing
it"). *Replacing `read_git` with a push* costs the registration call that `follow-the-folder` will
raise anyway. Before `v1.0.0`, `read_git` can leave the list by a re-cut. After it, leaving costs a
major version.

**What this rests on, and whose it stays.** The App Sandbox and its entitlement semantics are
Apple's and move on Apple's schedule (ADR-0011). The shape also rests, by negation, on WebKit's
entitlement check in its XPC services' launch path, which is why the two-process shape was left. If
Apple drops that check, nothing here moves on its own: the capability-split shape returns to the
SDD's § 2 table as a candidate, and choosing it again is a superseding record, not a reversal that
happens by itself. No third-party holder underwrites the shape. The seam is the platform's C calling
convention, and the wall is the operating system's.

## Traces to

- `docs/SDD.md` at v31 (Settled) — § 3 SM-4 (the list of ten, `read_git` with what it takes and
  answers; RN-90) and SM-5; § 4 C-R7, C-I3, C-I6; § 6 `see-git-status`, *Rests on* ("`SM-4`
  (`read_git`; § 10 RC-4)"), and § 6 S-4, *Not in this slice*; § 10 RC-4 — *Prior assumption*,
  *Observed reality*, *Retained*, *Changed*, *Stopped*, *Still unresolved* and its dated note; § 11
  R-13; § SDD Review Notes RN-90, RN-91. RC-4 *Changed* names this log as owed a record on this
  ground. RN-90 raised no item on this log's companion, and this record is the run that found it.
- `docs/trail/sdd/cycle-25.md` § 5.1 — the PM's item and the answer in the CTO's seat that chose the
  route; its reasoning, `docs/trail/sdd/self_answer-37.md`.
- The tree at `ka-reader@2aed844`: `ka_reader_read_git` is exported
  (`crates/ka-reader-bridge/src/exports.rs:L105`), and the export-set test admits it
  (`crates/ka-reader-bridge/tests/exports.rs:L17-L23`). No Swift source calls it
  (`grep -rn ka_reader_read_git ka-reader-mac` prints nothing).
- ADR-0013 — the record this one supersedes on acceptance. Its decision is restated here whole,
  with the list at ten and the Git item pulled, so nothing in this record depends on that one being
  open. Its traces stand under this record: `docs/SDD.md` § 2 (forces 1, 3, 5 and 6; the candidates
  table, rows 1–4 and 7; "Which side this product falls on, and why"; "Undoing it"), § 3 SM-8, § 4
  C-R2, § 9 TO-1, § 10 RC-2, RC-3, § 12, the downstream boundary, RN-56, RN-60;
  `docs/trail/sdd/cycle-9.md` § 1.1; `docs/trail/sdd/cycle-8.md` § 5.1; `docs/SRS.md` § 4.2 NFR-4,
  § 4.3 NFR-5, NFR-6, NFR-8, NFR-16, § 6 DR-6, § 7 C-1; `docs/fdr.md` PD-1, PD-6, PD-7, PD-26, PD-29.
  ADR-0001 is the record ADR-0013 superseded.
- ADR-0011 (the wall this shape rests on), ADR-0012 (the gate that proves the shell ran beside it),
  ADR-0014 (the view), ADR-0019 (the port), ADR-0020 (the units).
- `docs/trail/architecture/cycle-35.md` § 2.2 — the choice between this record, a correction in
  place, and no record, confirmed in the owner's seat (`docs/trail/architecture/self_answer-39.md`
  § 2.2) and by the owner, 2026-10-04 (`ka-reader@bb75290`): a superseding record, because the closed
  list is the rule a later change is held to, and not a fact the rule does not rest on.
- Inputs read for this record: SDD Settled v31 · SRS Settled v12 · FDR Settled v10.

## Binds

QC-1, QC-2, QC-8, QC-9, QC-15, QC-16, QC-24, QC-30, QC-32, QC-34, QC-36.
