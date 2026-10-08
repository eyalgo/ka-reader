# Self-answer report — `docs/CONTENT.md`

## Header

- **Companion:** `docs/CONTENT_open_issues.md`
- **Document:** `docs/CONTENT.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-26
- **Sources re-read:** None. No answer rests on a source outside this repository. Every ground is a
  file in this repository, read at the lines cited.

The companion held one open item, § 3.1, raised from downstream by the PM on 2026-09-26. §§ 1 and 2
read "None." This run answered § 3.1 and raised one item on the same companion, § 2.1.

## Items worked

### 3.1 — A folder that is no longer there has no sentence, so its row reads as a link

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the verbal language
- **Verdict:** answered
- **Why:** The verbal language takes two sentences, one for each thing KA-Reader can observe. A folder
  row that KA-Reader listed, and then found nothing at when it opened it, gets *"This folder is no
  longer there."* An entry that failed when its folder was listed keeps the settled link sentence,
  *"This link leads to something that isn't there."*

  *Seat (check 1).* This is ours. The change lands in `CONTENT.md` § Message patterns, *Partial*,
  and it binds only this document's wording. Nothing about what the product does or claims moves.

  *The item's evidence (check 2).* Every citation was re-read and holds. `condition_for` maps
  not-found to `Missing` (`crates/ka-reader-core/src/fs_reader.rs:L140-L146`). A folder row takes its
  sentence from its own read when it is opened (`ka-reader-mac/Sources/Surfaces/RootItemsView.swift:L163-L176`).
  That read maps `.missing` to the link sentence (`ConditionSentences.swift:L27-L28`). The shell
  cannot tell a link from what it reaches (`EntryKind.swift:L1-L9`). So a plain folder removed or
  renamed after listing does say it is a link. The item offers two remedies: a sentence for an entry
  that is gone, or one missing sentence reworded to be true of any entry. That is one question with
  two candidate answers, not two questions, so there is nothing to split.

  *Why two sentences and not one.* No single sentence is true in both cases. At listing, `Missing`
  is reached only through the link branch (`fs_reader.rs:L385-L388`; a failed entry is a file,
  `:L414-L418`). A link that pointed at nothing from the moment it was listed was never "there", so
  *no longer there* is false for it. The link sentence is false for a plain folder. Choosing by
  what was observed keeps both true. It also leaves the owner-settled link sentence
  (`docs/trail/content/cycle-6.md` § 3.1; `docs/CONTENT.md` RN-28) exactly where its premise holds,
  so a settled decision does not move to fix a case it never governed.

  *The wording.* *No longer there* is the phrase every upstream document already uses for this state:
  `docs/PRD.md:L245`, `docs/UXD.md:L236` (UX-S1's cell) and `:L257`, `docs/SRS.md:L241`,
  `docs/fdr.md` R-81. KA-Reader observed both halves of the claim: it listed the folder, and later
  found nothing in its place. The sentence names no cause, because moved, renamed and deleted all
  look the same to it (§ Voice, first row). It names no next step, like its three siblings on a
  tree row, because the rest of the tree is on screen (`docs/SDD.md` § 4 C-E4). *This folder* on a
  tree row means the row's own folder, as § Terminology requires. *KA-Reader can't read this folder.*
  already uses it that way.

  *Against the settled record (check 3).* The answer agrees with RN-28, with § Terminology's *link*
  row (a link sentence is said of the link, on its own row) and with § Localization (two whole
  sentences, not one with a switch inside it). It needs no upstream document to move. It also meets
  the widening bar: the item asks for a case the document does not state, and it cites sites in the
  product, which is an occurrence, so the form it cites is taken.

  *Failure paths (check 4).*
  - *Absent:* the folder removed, or renamed. The sentence is true in both.
  - *Concurrent:* a folder row reached through a link, where the link or its target went between
    listing and opening. The folder that row showed is gone, so the sentence is true there too, and
    it is the only true one the shell can choose, since the wire carries no link.
  - *Stale:* the sentence stands until the parent is read again. *Recovered* applies if the folder
    returns, and nothing announces it.
  - *Named and not carried:* two forms, neither cited by the item, so both wait until they occur.
    One is a folder row reporting outside, loop or too-many-links through a link *above* it; the
    link sentence would then be said of a row that is not a link. The other is a file row reporting
    `Missing` through the type-check error at `fs_reader.rs:L382`, where an entry vanishes between the
    directory read and its type check. I did not search the product for either, as the prompt directs.

  *What would have tipped it.* If the bridge told the shell that a folder row was a link, a gone
  target on a link-to-folder row could keep the link's wording. It does not (`EntryKind.swift:L1-L9`),
  and asking for that is a wire change, not a verbal one. The folder sentence is true without it, so
  nothing is raised to the CTO.

  *Consequence for the fold.* § Traceability's UX-S2 one-entry row names the folder case. The
  reading panel's sibling sentence is raised as § 2.1 so that the fold can take both together.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.1 — The reading panel's sentence for a file that is gone says it left the folder, which KA-Reader did not observe

- **What the document is owed:** *"This file is no longer in the folder."* becomes *"This file is
  no longer there."* in its three places: `docs/CONTENT.md:L65`, `:L367-L368` and `:L488`.
- **Why it is worth a cycle:** *A fact in it is now false*, in a case the product reaches
  (`decide_companion_answers.md` § The items are not the whole of what a document is owed). A file
  renamed or moved inside the folder is still in the folder, so the sentence claims something KA-Reader
  never observed. It observed only that nothing is at the path. That is § Voice's first row broken
  by the document's own example. The upstream documents all word the state as *no longer there*
  (`docs/UXD.md:L236`, UX-S1: *"states plainly that it is no longer there"*; `docs/SDD.md:L1604`;
  `docs/fdr.md` R-81). The cost is nil: `grep -rn "no longer in the folder" ka-reader-mac crates`
  prints nothing, and this round already owes a `product-content` fold for § 3.1. There is some
  doubt about whether this clears the bar, since a reader may not be misled much. The prompt says to
  raise when unsure, so this is raised with that doubt stated. It was appended to *Choices to
  confirm* with its slot at the placeholder, so the call is the next round's.

## Companions opened

None this run.

## Launchers owed

- **`docs/CONTENT.md`** — `<CORE>/launchers/skill/launcher.sh product-content ka-reader`
