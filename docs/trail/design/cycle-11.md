# DESIGN open issues — KA-Reader

> Companion to `DESIGN.md`. The CDO authored the design language non-interactively; this file
> holds the calls it made and wants your sign-off on — each with the reason behind it, and what
> moves underneath it if you override — plus the few things it genuinely could not settle, and,
> when a design run has produced output for this product, the pointer to it.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-design`. It folds your answers into `DESIGN.md` and drops the resolved
> items. When nothing is left open, `product-design` **deletes this file**: no file = the
> design language is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CDO folds them in, it first copies this
> file whole to `docs/trail/design/` — so what you decided, and why, stays readable and citable
> for good.
>
> **§ 3 is not the CDO asking.** The design language is read by everything built after it, and a
> seat downstream can find a rule missing that the authoring run had no occasion to write. That item
> lands in § 3 and is folded by the same run.

> **No `product-design` run wrote this file.** The PM opened it on 2026-10-01 from the design
> language's own companion template, while re-reading the route after the reading panel gained its
> pending and fault states. `DESIGN.md` is Settled, and with no companion on disk a `product-design`
> re-run reads it as done and has nothing to act on. Its one item is in § 3.

---

## 3. Raised from downstream — an item from a seat that did not write the design language

### 3.1 Whether the reading panel's path line shows while a selected file is still being read
- **Raised by:** PM — 2026-10-01
- **Tracked by:** `ka-reader · nemawashi · 2026-10-01_a-file-reads-in-the-panel`
- **What it blocks:** nothing is blocked. The pending state is built. What is missing is a rule
  that says whether it is built right, and the two documents it rests on read differently.
- **Where it shows:** § Components *The reading panel* says "Its first row is always
  `{components.path-line}`: the open file's folder-relative path" (`docs/DESIGN.md:L657-L658`).
  `docs/CONTENT.md` § Message patterns *Loading* has the panel say *Reading* plus the thing being
  read. It also says that where the reader can only wait, "the empty half of the surface stays
  empty" (`docs/CONTENT.md:L306-L310`). Its UX-S1 row for the reading panel's loading state asks for no
  progress claim and no ellipsis (`docs/CONTENT.md:L499`). As built, the pending panel draws only
  *Reading this file.* and hides the path line
  (`ka-reader-mac/Sources/Surfaces/ReadingPanelView.swift:L101-L109`), while the tree's bar already
  marks the selected file. The fault state that can follow does draw the path line
  (`ka-reader-mac/Sources/Surfaces/ReadingPanelView.swift:L114-L119`). The build reads "always" as
  holding only once a file's verdict is shown, the same way the no-file prompt draws no path line.
  Read literally, "always" and "the open file" would put the selected path above *Reading this
  file.* Two readings are open. (a) The path line is drawn only once a verdict or the fault is
  shown, and § Components says so. (b) The path line names the selected file from the moment it
  is selected, pending included. If (b), the item also needs to say how a path holding a digit or
  a `…` sits beside *Loading*'s no-progress rule.
- **If a document has to be written:** none. § Components *The reading panel*.
- **Answer:** Choose (a). The selected-file pending state shows the loading status message without a path line. In § Components *The reading panel*, scope the path line's first-row rule to the selected file's content or outcome: text (including an empty text file), cannot-display, an observed failed read (including a file gone or unreadable), and an unexplained fault. The no-file prompt has no path line; pending is a distinct state, not that prompt. This reading follows the UXD's path-with-content rule and its named failure states, and keeps the pending treatment to the loading message (`docs/UXD.md:L101-L103`, `L236-L236`; `docs/CONTENT.md:L306-L310`). Reasoning: the existing selection cue names the pending target without adding a second panel row, and the result's path identifies what was read or what stopped. This is a clarification of the pending case, not a change to the path line shared by code, rendered Markdown, raw source and diff (`docs/DESIGN.md:L657-L661`). On a replacement selection, no earlier file's path or content stands under the new pending message; an obsolete reply restores neither. A fault ends pending and identifies the current selection under its path, with the tree remaining the way on (`docs/UXD.md:L253-L255`, `L322-L331`; `ka-reader-mac/Sources/Surfaces/WorkbenchView.swift:L80-L98`). A path containing a digit or `…` is the reader's identifier, not KA-Reader's progress claim; CONTENT expressly keeps its writing rules off the reader's names, so no exception to Loading is owed (`docs/CONTENT.md:L41-L45`, `L306-L310`). Reasoning and failure-path checks: docs/trail/design/self_answer-7.md.

**How it closes.** `product-design` folds it on its next run like any other item here.
