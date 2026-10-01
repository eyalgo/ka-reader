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
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
