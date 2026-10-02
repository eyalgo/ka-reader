# SDD open issues — Nozoki

> Companion to `SDD.md`. Three seats — the CTO, the CPO and the CDO — authored the SDD
> non-interactively in one run; this file holds what that run could not settle from its inputs (the
> PRD, the SRS, the UXD, and any context or constraints).
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time the seats fold them in, they first copy this file
> whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **§ 5 names a raiser from outside the run entirely.** It is a seat that never wrote the SDD,
> reading it after it settled and finding something only the SDD can fix.

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-01 from the SDD's own
> companion template, while re-reading the route after the reading panel gained its pending and
> fault states. `SDD.md` is Settled, and with no companion on disk a `product-sdd` re-run reads it as
> done and has nothing to act on. Its one item is in § 5.

---

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 The `surfaces` row says it draws no state the bridge did not send, and the reading panel's pending state is not sent
- **Raised by:** PM — 2026-10-01
- **Tracked by:** `nozoki · nemawashi · 2026-10-01_a-file-reads-in-the-panel`
- **What it blocks:** nothing is blocked. The pending state is built and passes its tests. What is
  missing is the SDD saying whether it is built in the right part. As written, § 3 says it is not.
- **Where it shows:** § 3's `surfaces` row ends "It draws projections and draws no state the bridge
  did not send" (`docs/SDD.md:L331`). The mechanism for a read that has not answered is
  `folder-model`'s: "every read held as an item carrying an `ItemState`" (`docs/SDD.md:L325`), whose
  `pending` is "not yet read" (`docs/SDD.md:L440`). C-E1 calls that `ItemState` "the mechanism", and
  the surface's showing of pending "the surface's half of the same rule" (`docs/SDD.md:L846-L851`).
  The app works differently. When a file is selected, the workbench draws the panel's *reading* state
  from its own selection, before the read is even asked for
  (`nozoki-mac/Sources/Surfaces/WorkbenchView.swift:L80-L88`; the panel is drawn at `:L86`, the intent raised at
  `:L88`). The read itself goes out through the shell (`nozoki-mac/Sources/Shell/LaunchFlow.swift:L112-L113`). A `nil` answer is an answer that
  did not decode. The SDD names that state `stopped`, an `ItemState` the model holds
  (`docs/SDD.md:L440-L443`). The workbench draws it from the `nil` itself
  (`nozoki-mac/Sources/Surfaces/WorkbenchView.swift:L94-L97`). The tree's *Reading this folder.*
  line follows the same pattern: it is set before the listing is asked for
  (`nozoki-mac/Sources/Surfaces/RootItemsView.swift:L254-L260`). Two readings
  are open. (a) A surface may draw the gap between an intent it raised and the answer, as long as
  that is the only state it originates. The `surfaces` row then names this exception. (b) Pending
  comes only from a `folder-model` projection. The current drawing is then misplaced, and the work
  to move it is owed.
- **If a document has to be written:** none. § 3's `surfaces` row, and C-E1 where it names the
  mechanism.
- **Answer:** Reading (a), with bounds. Reading (b) is not taken: no drawing is misplaced and no
  work to move it is owed. A surface may draw one state it was not handed: that an intent it raised
  has not been answered yet. § 3's `surfaces` row names that exception, and C-E1 names it beside the
  `ItemState` mechanism. Four bounds go with it.
  1. It is the gap of the surface's own ask, and it says nothing about the folder. It begins when
     the surface raises an intent across SM-8 and ends on that intent's answer. It carries the
     pending sentence alone: no marker, no count, no content and no progress figure (UX-I13).
  2. Every answer ends it, whether the answer is a projection or carries no verdict. No timer
     starts it, advances it or ends it (C-E1; `docs/CONTENT.md` § *Message patterns* → *Error*,
     "A stopped read is never dressed as a pending one").
  3. Only an intent the reader's own act raised opens it. A change that arrives unasked opens
     none, so from `follow-the-folder` on a refresh never draws pending over content being read
     (C-E2).
  4. `pending` as an `ItemState` stays the model's and still crosses the bridge: `kind` before the
     root finding answers, and a folder entry not yet read. A surface originates neither.

  The item carries a second question, the fault, and the answer covers it. The *stopped* state the
  workbench draws from a `nil` answer is not a state the surface originates. `mac-shell` hands that
  `nil` down SM-8 when the call's return carried no verdict: a NULL buffer after the bridge caught
  a panic (`crates/nozoki-bridge/src/boundary.rs:L21-L40`), or a buffer that does not conform
  (`nozoki-mac/Sources/Shell/BridgePayload.swift:L272-L277`). The SDD states this as a second place
  `stopped` is established: at SM-4's return, where the answer is read, beside the `stopped` the
  model holds on an item. C-I1's "a panic that reaches the host" stays a violation.

  Why (a). The gap is the one state the bridge cannot send. An SM-4 call's answer is its return,
  so until the call returns the bridge has said nothing, and the bridge exports no callback today
  (`crates/nozoki-bridge/src/exports.rs:L55-L104`; C-R7 admits one only from the slice that needs
  it). A pending that must itself cross the seam cannot be drawn in the one case UX-S1 *Loading*
  exists for, a core that is slow to answer. The rule's purpose holds: a surface still draws
  nothing about the folder from its own knowledge, and "asked, not yet answered" is the one thing
  the shell observes first-hand. C-E1 already says "where it does not yet know, the surface shows
  pending".

  What the fold writes: the exception and its bounds on § 3's `surfaces` row; C-E1's mechanism
  sentence; `stopped` at SM-4's return, in *What the system holds* and C-I1; and § 6
  `open-a-folder`'s command half, "a row is drawn from a projection and from nothing else", read
  with the exception, because the tree's *Reading this folder.* line is the same gap
  (`nozoki-mac/Sources/Surfaces/RootItemsView.swift:L254-L260`). No § 10 entry: no bar, no seam's
  list and no order moves. `docs/trail/sdd/cycle-17.md` § 5.2 stands: the open file, the selection
  and the expansion are the model's from `follow-the-folder` at the latest, and the gap is not held
  state. Two cases this answer does not cover. A read that never returns leaves pending standing,
  with the tree as the route out. Which side orders two asks in flight stays the moving change's
  design (RN-76). Downstream, after the fold and not before: `docs/nfdr.md:L983`, "A view is drawn
  from a projection and from nothing else", re-derives from the row, and that is the Principal
  Architect's. Reasoning: `docs/trail/sdd/self_answer-31.md` § 5.1.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
