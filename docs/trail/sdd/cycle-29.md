# SDD open issues — KA-Reader

> Companion to `SDD.md`. The CTO wrote the SDD; this file holds what that run could not settle from
> its inputs (the PRD, the SRS, the UXD, and any context or constraints), and the calls that are the
> CPO's or the CDO's to make. An item whose call is the CPO's or the CDO's carries that seat's
> `Seat:`; an item whose call is the CTO's carries `cto` or no `Seat:` field.
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time `product-sdd` folds them in, it first copies this
> file whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item may name the seat that answers it.** Any item in any section carries an optional
> `- **Seat:** <seat>` field beside its other fields. Its value is the name of the agent whose posture
> answers the item — `cto`, `cpo` or `cdo`. An item with no usable value, whether the field is absent,
> empty or still the `<seat>` placeholder, is answered in the seat of the skill that produced this file.
> The field names the *answering* seat. It is not the seat that raised the item (`Raised by:` /
> `Held by:`), and it is not the document an answer belongs to.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a
> disagreement is not something one seat asked, it is two positions held by different seats, and the
> answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the SDD's lanes entirely.** §§ 1–4 are all the SDD's own three
> lane seats; § 5 is a seat that never held a lane in it, reading it long after it settled and
> finding something only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's,
> which stay fixed to the three lane seats on purpose.


> **No `product-sdd` run wrote this file.** The owner opened it on 2026-10-04, in an interactive
> session, from the SDD's own companion template. The code-integrity step of
> `ka-reader · tobiishi · 2026-10-04_the-tree-marks-what-changed` stopped at placement: the tree's
> changed-file marker logic is built in `surfaces`, and the SDD gives the marker to `folder-model`.
> The step's rule leaves placement to the owner, and the owner chose to have the SDD settle it rather
> than rule on the change alone. The SDD is Settled, and with no companion on disk a `product-sdd`
> re-run reads it as done and has nothing to act on. Its two items are in § 5.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 Which part owns the tree's changed-file marker: `folder-model`, as § 3 says, or `surfaces`, where the change built it?
- **Raised by:** Owner — 2026-10-04, from the code-integrity stop of
  `ka-reader · tobiishi · 2026-10-04_the-tree-marks-what-changed`
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the change's code-integrity step. It stopped at placement and waits for this
  ruling. Its report gives the two rulings that would let a re-run pass (the instance's
  `system/projects/ka-reader/journey/tobiishi/2026-10-04_the-tree-marks-what-changed/code-integrity-report.md:L57-L66`,
  at instance commit `8f2c5f1`).
- **Where it shows:** three SDD sentences give the marker to `folder-model`:
  - § 3, the `folder-model` row's *Owns*: "the tree … the Git state where the root finding says
    `root`" and "the projections the surfaces draw" (`docs/SDD.md:L333`).
  - § 3 *What the system holds*, `FolderModel`: "`TreeEntry` items: path, is-folder, expanded, and —
    on a root — the changed marker" (`:L447`). `GitState` lists the marker as in no landed change
    (`:L492-L496`).
  - § 6 S-4 *Rests on*: "`folder-model` (`kind` resolved; `GitState`; the tree's markers)"
    (`:L1802-L1803`).

  The change built the join in Swift: `ka-reader-mac/Sources/Surfaces/TreeMarkers.swift:L1-L68`, at
  product commit `6c49d5c` on branch `2026-10-04_the-tree-marks-what-changed`. The join takes a Git
  item onto row paths: only a repository answer marks, paths match byte for byte, one trailing `/`
  is allowed, and the changed list wins over the staged one. The change's design gives its grounds
  in Architect Review Note 1 (the instance's `change_design.md:L222-L246` in that tobiishi folder):
  - No core-to-shell path reaches a row already drawn in this slice. The `model_changed`
    registration is held back to `follow-the-folder` (§ 10 RC-4), and re-asking `list_tree` would
    be the second read CP-581 forbids.
  - The join derives only from projections the bridge sent, which the `surfaces` row allows
    (`docs/SDD.md:L339`).
  - It is one place, and deletable once the core holds the marker.

  The request barred any change under `crates/` (CP-585).
- **If a document has to be written:** none. The answer is either the three sentences above or the
  change's design. If `surfaces` owns it, the replacement wording is drafted in the change's
  `change_design.md` § *Records this change makes false* (`:L190-L216`). If `folder-model` owns it,
  the SDD stands, the change goes back to design with the `crates/` bar lifted, and that design owes
  the seam ARN 1 says this slice lacks. The owner recorded no lean and asked the SDD's seat to decide.
- **Answer:** `folder-model` owns the tree's changed-file marker. That stays the design. For
  `see-git-status` only, the join the change built stands in `surfaces`, as a placement the SDD
  states and bounds, and it ends in `follow-the-folder`. This is the code-integrity report's
  ruling 1 in its time-bounded form. Ruling 2 is not taken: the change does not go back to design
  and the `crates/` bar is not lifted for it. Answered in the CTO's seat by an unattended run. The
  fold writes five things, and may word each differently:
  1. **§ 3, the `surfaces` row, *Owns*.** One bounded clause. In `see-git-status` the row also
     holds the join of the Git item onto the tree's row paths. Four bounds: it derives only from
     projections the bridge sent (the Git item and the tree listings); it marks only from an
     `observed` repository answer (§ 4 C-I1, C-E1); it raises no ask and holds no path it did not
     receive in a projection (SM-8); and it ends when `follow-the-folder` is reached, where the
     join moves into `folder-model` and is deleted from the shell. It is a dated placement of
     projection logic. It is not a second exception to "draws no state the bridge did not send":
     the row's one exception stays one.
  2. **§ 3 *What the system holds*.** `FolderModel`'s sentence (`docs/SDD.md:L447`) stands:
     `TreeEntry` carries the changed marker. `GitState`'s sentence (`:L492-L496`) keeps the marker
     among the things the model holds in no landed change, and adds where the join is built
     meanwhile. Word it so it is true before and after the change merges: at the time of this
     answer `TreeMarkers.swift` is at `ka-reader@6c49d5c` on the change's branch and is not on `main`.
  3. **§ 6 S-4 *Rests on*.** `folder-model` (`kind` resolved; `GitState`), `surfaces` (the rail's
     Git entry, the Git view, and in this slice the tree's markers, under the § 3 bound).
  4. **§ 6 S-5, the CTO's halves.** *Rests on* gains the debt: from `follow-the-folder` the
     model's `TreeEntry` carries the marker and the `model_changed` delta brings it. The command
     half gains a clause that goes red while the shell still joins, for example that
     `ka-reader-mac/Sources` holds no `TreeMarkers`, and that the model's final snapshot carries the
     markers. Without this the bound in (1) has no end a build can check.
  5. **§ 10.** One re-cut entry on the CTO's ground: S-4's *Rests on* assumed the model's
     `TreeEntry` would carry the marker in `see-git-status`, and no call or callback of that
     slice can bring a marker to a row already drawn.

  Reasoning, and what it does not cover: `docs/trail/sdd/self_answer-41.md`.

### 5.2 The Git view's row order, `GitRowOrder`, already landed in `surfaces` on the same reading. Is it in place?
- **Raised by:** Owner — 2026-10-04, from the same code-integrity stop
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. The sealed change `ka-reader · tobiishi · 2026-10-04_the-shell-shows-git`
  placed it in `surfaces` (`ka-reader-mac/Sources/Surfaces/GitRowOrder.swift`, product commit
  `d65eec4`). It writes `fs-reader`'s order key out over Unicode scalars and bytes
  (`GitRowOrder.swift:L1-L6`). That change's code-integrity report treated "cannot be moved
  without a core change" as "already in place" (its `code-integrity-report.md:L161-L164`, in the
  instance's tobiishi `trail/`). The newer report says the doctrine treats the same case as a stop,
  and that the ruling on 5.1 also decides whether `GitRowOrder` is a landed misplacement
  (`8f2c5f1`'s report, `:L68-L74`).
- **Where it shows:** the SDD names no owner for the Git list's row order. `folder-model`'s "the
  projections the surfaces draw" (`docs/SDD.md:L333`) could claim it, and `grep -n GitRowOrder
  docs/SDD.md` prints nothing. The order key it copies is `fs-reader`'s
  (`crates/ka-reader-core/src/fs_reader.rs:L818-L832`).
- **If a document has to be written:** none. A sentence in § 3 naming the owner of the Git list's
  row order, or a § 11 risk or later slice that moves it into the core.
- **Answer:** No, by the same reading as § 5.1. The order of the Git lists' rows is part of the
  projection, so `folder-model` owns it. `GitRowOrder` is a landed misplacement that stands in
  `surfaces` under the same bound as the marker join, and it leaves the shell no later than
  `follow-the-folder`. Answered in the CTO's seat by an unattended run, after § 5.1 and together
  with it. The fold writes three things, and may word each differently:
  1. **§ 3 names the owner.** In *What the system holds*, `GitState`: the model holds its two
     lists in the order their rows are drawn. In the `folder-model` row or beside it: the order
     has one implementation, in the core. The SDD names the owner and does not restate the order
     rule, which is the FDR's and the sealed spec's.
  2. **The § 3 `surfaces` clause § 5.1 asks for covers this too.** One clause, two things held
     for `see-git-status`: the marker join and the Git lists' row order
     (`ka-reader-mac/Sources/Surfaces/GitRowOrder.swift`, on `main` since `ka-reader@d65eec4`). Same
     four bounds, same end.
  3. **§ 6 S-5, the CTO's halves, carry it with the marker.** The core sends the lists in row
     order and the shell draws them in the order they arrive. The clause that goes red names
     `GitRowOrder` beside `TreeMarkers`.

  The move needs no new seam, so a change that opens `crates/` may make it earlier.
  `follow-the-folder` is the latest point, not the scheduled one, and when it is scheduled is the
  PM's. No § 11 risk is added. The sealed change's record is not touched. Reasoning, and the one
  thing this run could not measure: `docs/trail/sdd/self_answer-41.md`.

**How it closes.** `product-sdd` folds these on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
