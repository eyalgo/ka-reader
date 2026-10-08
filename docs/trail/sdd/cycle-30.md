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


> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-04 from the SDD's own companion
> template. The shell's marker join is now on `main` (`ka-reader@6c49d5c` is an ancestor of `main` at
> `ka-reader@67d103d`), and one sentence of § 3 *What the system holds* says it is not. The status-letter
> expansion `docs/fdr.md` R-38 requires is delivered by no slice, and two surfaces now draw the letters
> it expands. The SDD is Settled, and with no companion on disk a `product-sdd` re-run reads it as done
> and has nothing to act on. Its two items are in § 5.

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

### 5.1 § 3 `GitState` says the marker join is built at a commit not on `main`; that commit is now on `main`
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. A reader of `GitState` learns the shell's join is off `main`, and
  it is on it.
- **Where it shows:** § 3 *What the system holds*, `GitState` (`docs/SDD.md:L502-L503`): "The join that
  produces it is built in the shell, at a commit that is not on `main`." Measured 2026-10-04:
  `git merge-base --is-ancestor 6c49d5c main` exits 0, and `git ls-tree main --name-only
  ka-reader-mac/Sources/Surfaces/` lists `TreeMarkers.swift`, at `ka-reader@67d103d`. The sentence before it
  is pinned to `ka-reader@b640345` and stays true; the `surfaces` row's clause (`:L340`) already "reads the
  same whether or not it merges". `FolderModel`'s `TreeEntry` marker (`:L448`) and the marker among the
  things "in no landed change" (`:L494-L496`) are RN-94's deliberate model-side statements, and this
  item does not ask to move them. The likely fold: the join is on `main` from `ka-reader@67d103d`, in the
  shell, under the `surfaces` row's four bounds.
- **If a document has to be written:** none. One sentence of `GitState` in `SDD.md`.
- **Answer:** Replace that one sentence, and move nothing else. In place of "The join that produces
  it is built in the shell, at a commit that is not on `main`", `GitState` says that the join that
  produces the marker is in the shell (`ka-reader-mac/Sources/Surfaces/TreeMarkers.swift`) and on
  `main` from `ka-reader@67d103d`, the merge that landed it, under the `surfaces` row's four bounds.
  The fold words it. Measured 2026-10-04 at `ka-reader@c79b26c`: `git merge-base --is-ancestor 6c49d5c
  67d103d` exits 0 and the same test against `67d103d^1` exits 1, so `67d103d` is the commit that
  brought the join to `main`; `git diff --stat 6c49d5c main --
  ka-reader-mac/Sources/Surfaces/TreeMarkers.swift` prints nothing, so the file on `main` is the one
  built at `ka-reader@6c49d5c`. Four things keep their words. The sentence before it is pinned to
  `ka-reader@b640345` and is true of that commit. The `surfaces` row's clause is pinned the same way
  and says of itself that it reads the same whether or not the commit merges. `FolderModel`'s
  `TreeEntry` marker and the marker among the things in no landed change are statements about the
  model, and `git grep -n marker main -- crates/ka-reader-core/src/folder_model.rs` still prints
  nothing. § 10 RC-5's *Observed reality* is a dated record of what was read at `ka-reader@b640345`.
  Answered in the CTO's seat by an unattended run; the reasoning is
  `docs/trail/sdd/self_answer-42.md`.

### 5.2 No slice delivers `docs/fdr.md` R-38's status-letter expansion, and two surfaces now draw the letters
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** no seed can be cut for the expansion, because no slice in § 6 names it; and
  `see-git-status`'s letters ship with nothing that expands them.
- **Where it shows:** `docs/fdr.md:L93` R-38: "Resting the pointer on a status letter shows the file's
  name and the letter's meaning in words", traced to "SDD § 4 C-E8". C-E8 (`docs/SDD.md:L1068-L1075`)
  requires that every state distinction carry a letter or word, and says nothing of the expansion;
  `grep -c -i tooltip docs/SDD.md` prints 0, as it does for `docs/UXD.md` and `docs/SRS.md`.
  `docs/CONTENT.md:L145-L147` says "A single-letter code is never the whole of a statement", and
  `:L422-L428` gives the expansion's two words and leaves how it is drawn to `docs/DESIGN.md`
  § Components, "The tooltip". In the product the Git view's rows draw the six letters with "no
  tooltip" (`ka-reader-mac/Sources/Surfaces/GitView.swift:L24`), and the tree's rows now draw the same
  letters (`ka-reader-mac/Sources/Surfaces/RootItemsView.swift:L208`, `:L236`); `grep -rn -i toolTip
  ka-reader-mac/Sources`, comments aside, prints nothing. The call is which slice delivers the
  expansion, and whether `see-git-status` is reached without it.
- **If a document has to be written:** none. A slice's *Delivers* and *Reached when* in § 6, and
  R-38's trace target in § 4.
- **Answer:** `see-git-status` delivers the expansion, and that slice is not reached without it. No
  new slice is cut, and no slice's order or edge moves.
  **Why that slice.** The owner put the tooltip in v1 (`docs/DESIGN.md:L990-L992`: "i think that
  tooltips should be included in v1", "recorded as a v1 decision"). The v1 cut ends at
  `follow-the-folder` (`docs/SDD.md:L1908`), and `see-git-status` is the slice that first draws the
  letters, in the tree and in the Git view (`docs/SDD.md:L1765-L1768`). The rest is reasoning.
  Nothing technical places the expansion later: the row's name and its status category already
  reach `surfaces` in the projections it draws, the six words are `docs/CONTENT.md`'s
  (`:L422-L426`) and go in the catalogue `surfaces` owns, and no part, seam or SM-4 call is added.
  A slice of its own would deliver a tooltip with no letter to rest on.
  **What the fold writes**, each in its own seat's words:
  (1) § 4 C-E8 gains one sentence: a status letter's expansion is raised by the letter and by
  nothing else, drawn as `docs/DESIGN.md` § Components "The tooltip" draws it, in the words
  `docs/CONTENT.md` § Terminology gives. The SDD said this before it was re-authored
  (`ka-reader@70a879a:docs/SDD.md:L439-L441`, § 4 C-E6: "a status letter's expansion is raised by the
  letter, as the tooltip, and nowhere else"), and `docs/fdr.md:L93` R-38 still traces to it.
  (2) § 6 S-4 *Delivers* gains that resting the pointer on a status letter shows the row's name and
  the letter's meaning in words.
  (3) § 6 S-4 *Reached when*, observable half: resting the pointer on a letter, in the tree and in
  the Git view, shows the name and then the word; the row stays one click target; nothing else
  raises a tooltip.
  (4) § 6 S-4 *Reached when*, command half: a `swift test` case in `ka-reader-mac` holds that each of
  the six status categories gives the word `docs/CONTENT.md` states, and that the text is the name
  and then the word. Whether a test also drives the pointer rest is the design of the change.
  (5) § 6 S-4 *Rests on*: `surfaces` gains the letter's tooltip.
  **Whose columns.** (2) is the CPO's column and (1) and (3) are the CDO's (`docs/SDD.md:L96-L123`).
  This answer decides nothing there that the owner's v1 decision, R-38, `docs/CONTENT.md` and
  `docs/DESIGN.md` have not already settled. A call the fold finds in those columns that they do
  not settle goes back to this file under that seat's `Seat:`.
  **What waits for `follow-the-folder`.** The tooltip "leaves the moment the pointer leaves the
  letter or a refresh changes the row's state" (`docs/DESIGN.md:L651-L652`). In `see-git-status`
  the Git view shows the state read when the folder opened (`docs/SDD.md:L1829-L1830`), so the
  refresh half is first observable in `follow-the-folder`, and that slice's observable half is
  where it is stated.
  **No § 10 entry.** None of that section's four triggers holds (`docs/SDD.md:L2452-L2454`): S-4's
  *Reached when* can be met as written, and the PRD, the SRS and the UXD did not move. This is an
  omission restored, and a review note records it.
  **Where the product stands.** At `ka-reader@c79b26c` both surfaces draw the letters and raise
  nothing (`ka-reader-mac/Sources/Surfaces/GitView.swift:L24`, `RootItemsView.swift:L236`), so on this
  ground `see-git-status` is not reached on `main`. What that means for the work in flight is the
  PM's. Answered in the CTO's seat by an unattended run; the reasoning, the failure paths and what
  would have tipped it are `docs/trail/sdd/self_answer-42.md`.

**How it closes.** `product-sdd` folds these on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
