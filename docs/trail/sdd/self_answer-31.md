# Self-answer report — `docs/SDD.md`

This is the record of one unattended run that answered `docs/SDD_open_issues.md` in the owner's
seat. It is for the owner, who reads it to learn what was decided and why, and for the
`product-sdd` run that folds the answer.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-02
- **Sources re-read:** None. The answer rests on this repository's documents and code, and on no
  source outside it.

## Items worked

### 5.1 — The `surfaces` row says it draws no state the bridge did not send, and the reading panel's pending state is not sent

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Reading (a), with four bounds. A surface may draw one state it was not handed: that an
  intent it raised has not been answered yet. Reading (b) is not taken, so no drawing is misplaced
  and no work to move it is owed. The item carried no draft. It named two readings and asked
  which one the SDD states.

  **What this run read.** `docs/SDD.md` from its header to the end of § 4 (`:L1-L930`), § 6
  `open-a-folder`, `read-a-file` and `follow-the-folder` (`:L1339-L1513`, `:L1667-L1732`), § 9
  TO-1 and TO-7, § 12, *Open Questions*, and RN-37, RN-76 and RN-77. The rest of the document
  (§ 5, the other eight slices, §§ 7, 10 and 11, and the other review notes) was searched for
  `pending`, `stopped`, `ItemState`, UX-I13, UX-I16 and "did not send", and each hit was read.
  It was not read line by line. Of the inputs, `docs/UXD.md` UX-S1, UX-S2, UX-I13 and UX-I16
  (`:L239-L240`, `:L309-L314`, `:L325-L336`) and `docs/CONTENT.md:L276-L279` were read. The PRD
  and the SRS were not opened beyond NFR-3's line, because the answer moves no goal and no
  requirement.

  **The widening rule, first.** The item sits under the heading carrying *Raised from
  downstream*. Reading (a) asks the SDD to state an exception it does not state now, so it
  widens the document. The item cites its occurrences, and each was re-read and holds at
  `nozoki@5b3040e`:
  - `WorkbenchView.swift:L80-L88`: `select` calls `readingPanel.showReading()` at `:L86` and
    raises the intent at `:L88`.
  - `WorkbenchView.swift:L92-L98`: a `nil` verdict draws `showStopped`.
  - `LaunchFlow.swift:L112-L114`: the read goes out through the shell's runner.
  - `RootItemsView.swift:L254-L261`: `beginRead` sets the *Reading this folder.* line and then
    asks for the listing.

  Occurrences cited, so the widening proceeds.

  **Check 1: the seat.** The edit lands in `docs/SDD.md`: § 3's `surfaces` row and *What the
  system holds* (the CTO's), and § 4 C-E1 (the CDO's). It binds no person and no outside party,
  and it changes nothing the product promises or shows. I can name no ground I cannot see. So
  the item is mine in the owner's seat. What would have tipped it: an answer that moved a
  slice's bar, a seam's list or the order is a re-cut under § 10, and the earlier answer on the
  open file reserved that for the owner (`docs/trail/sdd/self_answer-28.md` § 5.2, *Check 1*).
  Reading (b) is closer to that line than (a) is. Pending sent by the bridge needs something to
  send it before the call returns, which means the `model_changed` registration that C-R7 admits
  only "by the slice that needs it, and not before" (`docs/SDD.md:L614-L616`).

  **Check 2: the question.** The item hides a second question. Its heading asks about pending.
  Its body also says the workbench draws the fault from a `nil` answer, where the SDD names
  `stopped` as an `ItemState` the model holds. Both questions land on the same rows and take the
  same seat, so both are answered in the one slot. One sentence of the supporting text is
  narrower than the code: "A `nil` answer is an answer that did not decode." `decodeFile`
  returns `nil` in three cases: a NULL buffer, a buffer that does not conform, and the wire's
  own `pending` state (`nozoki-mac/Sources/Shell/BridgePayload.swift:L266-L277`). The answer
  covers all three. The sentence is the producing skill's to correct, and this run left it as
  written.

  **Why (a), on pending.**
  - The gap is the one state the bridge cannot send. SM-4 sends up in two ways: "the
    `model_changed` callback" and "each call's return as an owned buffer" (`docs/SDD.md:L418`).
    The bridge exports four functions and no callback today
    (`crates/nozoki-bridge/src/exports.rs:L55`, `:L73`, `:L90`, `:L104`;
    `grep -rn model_changed crates nozoki-mac/Sources` prints nothing). A call's answer is its
    return. Until it returns, the bridge has said nothing.
  - A pending that must cross the seam cannot be drawn when it matters. UX-S1 *Loading* exists
    for "a file that is genuinely still being read" (`docs/UXD.md:L239`). That is a core that is
    slow to answer. A core that is slow to answer is also slow to send a pending state. Under
    (b) the panel would go on showing the previous file while the new read is out, which is
    stale content presented as current (C-E2, `docs/SDD.md:L856-L858`).
  - The rule's purpose holds under (a). The row's sentence keeps a surface from drawing folder
    state out of its own knowledge (UX-I13). "I asked and have no answer" is not folder state.
    It is the one thing the shell observes first-hand. C-E1 already says "where it does not yet
    know, the surface shows pending" and calls itself "the surface's half of the same rule"
    (`docs/SDD.md:L846-L852`).
  - `pending` as an `ItemState` is a different thing and stays where it is. The model holds
    `kind` as `pending` until the root finding answers (`docs/SDD.md:L435-L436`), and a folder
    entry not yet read crosses the bridge as `pending`
    (`crates/nozoki-core/src/fs_reader.rs:L842`). Bound 4 keeps both the model's.

  **Why the fault is not originated by the surface.** `mac-shell` decodes the return and hands
  the surface a verdict or `nil` (`LaunchFlow.swift:L118-L124`). The surface draws *stopped*
  from the value it was handed over SM-8. The model cannot report its own panic: the bridge
  catches the panic at the boundary and returns NULL (`crates/nozoki-bridge/src/boundary.rs:L21-L40`).
  So for a call, `stopped` is established where the return is read. § 3 says only that the model
  holds `stopped` on an item (`docs/SDD.md:L440-L443`). The answer asks the SDD to state both
  places.

  **Check 3: against the settled record.**
  - `docs/trail/sdd/cycle-17.md` § 5.2 (the open file, the selection and the expansion are the
    model's from `follow-the-folder` at the latest): stands. That answer leaned on the
    `surfaces` row's sentence to keep held state out of the shell. The gap is not held state.
    It lasts from one ask to its answer and survives no event. The row's sentence still does
    that work with the exception named.
  - RN-76's uncovered case, which side orders two reads in flight: unchanged. The answer leaves
    it to the change that moves the selection into the model, as RN-76 did
    (`docs/SDD.md:L4382-L4385`).
  - SM-8, "a surface never holds a path it did not receive in a projection"
    (`docs/SDD.md:L422`): holds. The path in the intent comes from a tree entry.
  - C-I1, "*Violated by:* … a marker drawn from `pending`" (`docs/SDD.md:L638-L639`): holds.
    Bound 1 allows the pending sentence and no marker.
  - § 6 `open-a-folder`'s command half, "tests that a row is drawn from a projection and from
    nothing else" (`docs/SDD.md:L1395-L1396`): this one the answer touches. The tree's *Reading
    this folder.* line is drawn from the surface's own ask. The answer names the clause so the
    fold reads it with the exception.
  - `docs/CONTENT.md:L276-L279`, "A stopped read is never dressed as a pending one": agrees.
    Bound 2 ends the gap on every answer, the no-verdict answer included.
  - UX-I16, "no pending treatment stands in for it, since the tool is not still working"
    (`docs/UXD.md:L332-L333`): agrees, for the same reason.

  **Check 4: the failure paths.**
  - *Empty.* No file selected raises no intent, so no gap opens and the prompt stands
    (UX-S1 *Empty*).
  - *Absent.* A read that never returns leaves pending standing. That is a true statement: the
    tool does not know yet. No timeout turns it into a fault, because a fault nobody observed
    is a cause the tool inferred (C-E1's "a spinner that moves on a timer"). The tree stays
    enabled as the route out. Named in the slot as not covered further.
  - *Stale.* An answer to an earlier ask arriving after a later one draws nothing. The surface's
    count does that today (`WorkbenchView.swift:L81-L91`). Which side does it once the model
    holds the selection is RN-76's open case.
  - *Concurrent.* A watcher-driven change is not an intent the reader raised. Bound 3 keeps it
    from opening a gap, so a refresh never replaces content with a pending line (C-E2).
  - *Refused.* A `failed(condition)` answer is a projection and is drawn as one. An answer with
    no verdict draws the fault.
  - One case the slot does not name, because it is wiring and not design. A surface whose intent
    has no receiver draws pending for an ask that is not out (`WorkbenchView.swift:L40-L43`,
    "While it is unset a selection still moves the bar, and no answer ever comes"). The product
    sets the receiver before it presents the workbench (`LaunchFlow.swift:L111-L115`). The
    answer's first bound rests on `mac-shell` answering every intent it is handed once.

  **What was close.** Reading (b) has one real argument: with pending in the surface, the logic
  that chooses it sits in the unit no harness drives (§ 9 TO-7). I weighed it and it did not
  carry. The logic is two calls in one function, `swift test` covers it, and TO-7 accepts the
  cost for a shell that holds no I/O, which stays true.

  **Downstream, named and not raised.** `docs/nfdr.md:L983` reads "A view is drawn from a
  projection and from nothing else". It agrees with the SDD as the SDD reads today, so it is
  owed nothing until the fold lands. After the fold it re-derives from the row, which is the
  Principal Architect's (`docs/SDD.md` § 12, the downstream boundary).

## Left for the owner

None this run.

## Skipped

None this run. The companion holds one item, and its slot was at its placeholder.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh nozoki`
