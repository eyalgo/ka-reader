# SDD open issues — Nozoki

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
> `nozoki · tobiishi · 2026-10-04_the-tree-marks-what-changed` stopped at placement: the tree's
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
  `nozoki · tobiishi · 2026-10-04_the-tree-marks-what-changed`
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the change's code-integrity step. It stopped at placement and waits for this
  ruling. Its report gives the two rulings that would let a re-run pass (the instance's
  `system/projects/nozoki/journey/tobiishi/2026-10-04_the-tree-marks-what-changed/code-integrity-report.md:L57-L66`,
  at instance commit `8f2c5f1`).
- **Where it shows:** three SDD sentences give the marker to `folder-model`:
  - § 3, the `folder-model` row's *Owns*: "the tree … the Git state where the root finding says
    `root`" and "the projections the surfaces draw" (`docs/SDD.md:L333`).
  - § 3 *What the system holds*, `FolderModel`: "`TreeEntry` items: path, is-folder, expanded, and —
    on a root — the changed marker" (`:L447`). `GitState` lists the marker as in no landed change
    (`:L492-L496`).
  - § 6 S-4 *Rests on*: "`folder-model` (`kind` resolved; `GitState`; the tree's markers)"
    (`:L1802-L1803`).

  The change built the join in Swift: `nozoki-mac/Sources/Surfaces/TreeMarkers.swift:L1-L68`, at
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
- **Answer:** <the owner fills this in>

### 5.2 The Git view's row order, `GitRowOrder`, already landed in `surfaces` on the same reading. Is it in place?
- **Raised by:** Owner — 2026-10-04, from the same code-integrity stop
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. The sealed change `nozoki · tobiishi · 2026-10-04_the-shell-shows-git`
  placed it in `surfaces` (`nozoki-mac/Sources/Surfaces/GitRowOrder.swift`, product commit
  `d65eec4`). It writes `fs-reader`'s order key out over Unicode scalars and bytes
  (`GitRowOrder.swift:L1-L6`). That change's code-integrity report treated "cannot be moved
  without a core change" as "already in place" (its `code-integrity-report.md:L161-L164`, in the
  instance's tobiishi `trail/`). The newer report says the doctrine treats the same case as a stop,
  and that the ruling on 5.1 also decides whether `GitRowOrder` is a landed misplacement
  (`8f2c5f1`'s report, `:L68-L74`).
- **Where it shows:** the SDD names no owner for the Git list's row order. `folder-model`'s "the
  projections the surfaces draw" (`docs/SDD.md:L333`) could claim it, and `grep -n GitRowOrder
  docs/SDD.md` prints nothing. The order key it copies is `fs-reader`'s
  (`crates/nozoki-core/src/fs_reader.rs:L818-L832`).
- **If a document has to be written:** none. A sentence in § 3 naming the owner of the Git list's
  row order, or a § 11 risk or later slice that moves it into the core.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds these on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
