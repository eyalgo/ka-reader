# CONTENT open issues — Nozoki

> Companion to `CONTENT.md`. The Content Editor authored the verbal language non-interactively;
> this file holds the calls it made and wants your sign-off on — each with the reason behind it,
> and what moves underneath it if you override — plus the few things it genuinely could not
> settle.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**,
> then re-run `product-content`. It folds your answers into `CONTENT.md` and drops the resolved
> items. When nothing is left open, `product-content` **deletes this file**: no file = the verbal
> language is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git refuses
> to remove a file with uncommitted edits in it — so an uncommitted answer stops that run before
> it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the Content Editor folds them in, it first copies
> this file whole to `docs/trail/content/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 comes from outside this run.** The verbal language is read by everyone who writes a string,
> and a seat downstream can find a pattern it has no rule for. It is recorded there, answered here,
> and folded by the same run.

> **No `product-content` run opened this companion. The PM opened it on 2026-09-26.**
> `CONTENT.md` is Settled at v7, and it had no companion on disk, so a `product-content` re-run would
> read it as done and find nothing to act on. The companion holds one item, § 3.1. It comes from
> reading the tree on `main` at `nozoki@f46269a`, where a folder row that is not a link can draw a
> link's sentence.

---

## 1. Open issues

None.

## 2. Choices to confirm

None.

## 3. Raised from downstream — an item from a seat that did not write the verbal language

### 3.1 A folder that is no longer there has no sentence, so its row reads as a link
- **Raised by:** PM — 2026-09-26
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** a true sentence on a plain folder's row. § Message patterns, *Partial*, gives
  one tree-row sentence per condition (`docs/CONTENT.md:L331-L337`). The one for a target that is not
  there is *"This link leads to something that isn't there."*, and § Terminology says a *link*
  sentence is "said of the link, on its own tree row" (`:L171`). But that condition is not only a
  link's. A folder is listed, and later expanded. If it has been removed or renamed in between, reading
  it finds nothing there:
  - `crates/nozoki-core/src/fs_reader.rs:L142` maps not-found to `Missing`, and
    `test_listing_a_missing_path_is_failed` (`:L715-L718`) pins that answer for a path that is not
    there.
  - The shell draws the one sentence for that condition (`nozoki-mac/Sources/Surfaces/ConditionSentences.swift:L27-L28`)
    beside the folder's row (`nozoki-mac/Sources/Surfaces/RootItemsView.swift:L163-L176`).
  - The shell cannot tell a link from a folder. A link is listed as what it reaches
    (`nozoki-mac/Sources/Surfaces/EntryKind.swift:L1-L9`).

  So a plain folder that the reader moved or deleted while Nozoki was open says it is a link.
- **Where it shows:** UX-S2, the file tree's one-entry error state: a row marked with what the product
  observed while the rest of the tree stands. The observation is *not there*. `CONTENT.md` holds that
  observation only in words that name a link.
- **If a document has to be written:** none. `CONTENT.md` § Message patterns, *Partial* either gives
  a sentence for an entry that is no longer there, or words the missing sentence so that it is true of
  any entry. `product-content` is the tool.
- **Answer:** <the owner fills this in>

**How it closes.** `product-content` folds it on its next run exactly as it folds §§ 1–2.
