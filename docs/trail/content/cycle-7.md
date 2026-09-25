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

### 2.1 The reading panel's sentence for a file that is gone says it left the folder, which Nozoki did not observe

> **No `product-content` run wrote this item, and the "None." above it came before it.** A
> `companion-self-answer` run raised it on 2026-09-26 while answering § 3.1 from a whole reading of
> `CONTENT.md`. What prompted it: § 3.1's answer gives a gone folder *"This folder is no longer
> there."*, in the phrase every upstream document uses, while this document's sentence for the same
> state in the reading panel claims more. The reasoning is in `docs/trail/content/self_answer-5.md`.

- **Written into CONTENT.md:** *"This file is no longer in the folder."*, the reading panel's
  sentence for the open file gone from disk. It appears three times: in § Voice's *Urgent* row as
  the example (`docs/CONTENT.md:L65`), in § Message patterns, *Recovered* (`:L367-L368`), and in
  § Traceability's UX-S1 file-gone row (`:L488`). This item proposes *"This file is no longer
  there."* in all three places.
- **Grounds:** Nozoki observes that nothing is at the file's path. It does not observe that the
  file left the folder. When a file is renamed or moved inside the folder, which is what an agent
  working in it does, the file is still in the folder under another name, and the sentence is false
  (§ Voice's first row: *"never states something it has not read"*). The upstream documents word
  this state as *no longer there*: UX-S1 says the panel *"states plainly that it is no longer
  there"* (`docs/UXD.md:L236`), and so do `docs/SDD.md:L1604` and `docs/fdr.md` R-81. No shipped
  string carries the current wording: `grep -rn "no longer in the folder"` over `nozoki-mac/` and
  `crates/` finds nothing, so the change costs no string. With it, the two gone sentences, file and
  folder, share one shape.
- **What moves if you override:** Nothing else. The three places keep the current sentence, and
  § 3.1's folder sentence stands on its own grounds either way.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

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
- **Answer:** Two sentences, chosen by what Nozoki observed. The link's sentence stays where it is
  true, and a folder that is gone gets its own:
  - a folder row that Nozoki listed, and then found nothing at when it opened it —
    *"This folder is no longer there."* It names no cause (moved, renamed or deleted) and no next
    step, because the rest of the tree is the way on (`docs/SDD.md` § 4 C-E4). *No longer there* is
    the phrase every upstream document uses for this state (`docs/PRD.md:L245`;
    `docs/UXD.md:L236`, `:L257`; `docs/SRS.md:L241`; `docs/fdr.md` R-81). Nozoki observed both
    halves of it: it listed the folder, and later found nothing in its place;
  - an entry that failed when its folder was listed keeps *"This link leads to something that isn't
    there."*, as § Message patterns, *Partial* has it (RN-28). At listing, only a link reaches that
    condition (`crates/nozoki-core/src/fs_reader.rs:L385-L388`, `:L414-L418`).

  The other option, one sentence true of any entry, is rejected because no single sentence is.
  *No longer there* is false for a link that pointed at nothing from the moment it was listed, and
  the link's sentence is false for a plain folder. The folder's sentence is also the true one for a
  folder row reached through a link. The shell lists a link as what it reaches
  (`nozoki-mac/Sources/Surfaces/EntryKind.swift:L1-L9`), and whether the link or its target went,
  the folder that row showed is no longer there. These are two whole sentences, not one with a
  switch inside it (§ Localization). § Traceability's UX-S2 one-entry row names the folder case.
  The reading panel's matching sentence is § 2.1 of this file. Two forms are not carried, because
  this item cites no occurrence of either. One is a folder row reporting an outside, loop or
  too-many-links condition through a link above it. The other is a file row reporting a missing
  entry through the type check at `fs_reader.rs:L382`. Both wait until they occur. Reasoning:
  `docs/trail/content/self_answer-5.md`.

**How it closes.** `product-content` folds it on its next run exactly as it folds §§ 1–2.
