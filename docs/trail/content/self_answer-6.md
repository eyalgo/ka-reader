# Self-answer report — `docs/CONTENT.md`

## Header

- **Companion:** `docs/CONTENT_open_issues.md`
- **Document:** `docs/CONTENT.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-26
- **Sources re-read:** None. No answer rests on a source outside this repository. Every ground is a
  file in this repository, read at the lines cited.

The companion held one open item, § 2.1. A `companion-self-answer` run raised it on this file
(`docs/trail/content/self_answer-5.md` § Raised on this document), and `product-content` carried it
through the v8 fold unanswered. §§ 1 and 3 read "None.". This run answered § 2.1 and raised nothing.

## Items worked

### 2.1 — The reading panel's sentence for a file that is gone says it left the folder, which Nozoki did not observe

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** The reading panel's sentence for an open file that is gone becomes *"This file is no
  longer there."* in all three places the item names. I checked all three against the document and
  they are right: § Voice's *Urgent* row (`docs/CONTENT.md:L65`), § Message patterns, *Recovered*
  (`:L380-L381`), and § Traceability's UX-S1 file-gone row (`:L501`). There is no fourth place.
  `grep -n "no longer in the folder" docs/*.md` finds only L65 and L501 in `CONTENT.md`, because
  L380-L381 breaks the sentence across a line.

  *Seat (check 1).* This one is ours. The edit lands in `CONTENT.md`, and it binds only this
  document's wording. What the product does in this state, keeping the file's name and not showing
  the old content as current, is UX-S1's (`docs/UXD.md:L236`), and it does not move.

  *The draft's argument (check 2).* The argument holds, and for the reason it gives. Nozoki
  observes that nothing is at the open file's path. A rename or a move inside the folder leaves the
  file in the folder under another name, so *"no longer in the folder"* claims something Nozoki
  never read. That breaks § Voice's first row (`:L62`, *"never states something it has not read"*),
  and the break is in the document's own example. The draft's citations hold at their lines:
  `docs/UXD.md:L236` (*"states plainly that it is no longer there"*), `docs/SDD.md:L1604` (the same
  words), and `docs/fdr.md:L162` (R-81, *"explicitly marked as no longer there"*). Its cost claim
  also holds: `grep -rn "no longer" nozoki-mac crates` finds only a doc comment in
  `crates/nozoki-core/tests/failure_log_kinds.rs:6`. The product ships no sentence for this state
  yet (`nozoki-mac/Sources/Surfaces/ConditionSentences.swift` holds only the tree's sentences), so
  the change costs no string.

  *The addition.* The draft misses a second ground in the same sentence. *The folder* on its own can
  mean the open file's parent folder or the folder you opened. § Terminology's *folder* row
  (`:L156`) settles which words name the opened folder: *the folder you opened*, never *this
  folder*. The current sentence uses neither. The proposed sentence names no folder, so the
  ambiguity goes with the false claim.

  *Against the settled record (check 3).* The answer matches v8's folder sentence, *"This folder is
  no longer there."* (`:L339`, RN-34), which is the shape the draft says the two will share. It is
  one whole sentence (§ Localization, `:L467-L469`). It leaves the reading bar where it was
  (`:L446-L458`). It drops *in*, *the* and *folder*, and adds *there*, which the README uses
  (`README.md:L17`). *Longer* is already in the settled folder sentence. The *Recovered* example
  still reads correctly: the gone sentence is replaced by the file's content, and nothing announces
  the return.

  *Failure paths (check 4).* The new sentence stays true on every path I walked.
  - *Absent:* the file deleted, renamed or moved inside the folder, moved out of the folder, or its
    parent folder removed. Nothing is at the path in each case, and that is all the sentence says.
    The current sentence is false for the rename and the move inside the folder.
  - *Concurrent:* something else appears at the path, such as a folder where the file was. The file
    that was open is still not there, so the sentence holds. What the panel then shows is UX-S1's
    call, not this item's. Another concurrent case is an editor's save-by-rename, which can leave
    nothing at the path for a moment. Both wordings are shown or not shown the same way, and
    *Recovered* covers the return.
  - *Stale:* the sentence stands until the path is read again, then *Recovered* applies. The wording
    does not change that.
  - *Through a link:* an open file reached through a link whose link or target went away. The file
    the panel showed is no longer there. This is RN-34's reading of a folder row reached through a
    link, applied to a file.
  - *Refused:* a file that is still there but can no longer be read is UX-S1's *unreadable* cell.
    It takes *"Nozoki can't read …"* and not this sentence.

  *What was noticed and not raised.* § Traceability's UX-S1 row cites § Error for this sentence.
  But the sentence carries only the middle part of the observed-condition formula (`:L248-L251`).
  The panel's path line covers the first part and the tree on screen covers the third, as the
  formula allows where the way on is already on screen. I considered raising this and did not,
  because no reader of the document is misled by it.

  *What would have tipped it.* I would have overridden to a different wording if Nozoki could tell a
  rename from a delete. It cannot, so the sentence can say only what it read. A wording that names
  a cause, like *deleted* or *moved*, is what § Voice's *Urgent* row already rejects.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/CONTENT.md`** — `<CORE>/launchers/skill/launcher.sh product-content nozoki`
