# Self-answer report — `docs/SDD.md`

This is the record of one unattended run that answered `docs/SDD_open_issues.md` in the CTO's seat,
with nobody present. It is for the owner, who reads it to learn what was decided and why, and for
the `product-sdd` run that folds the answer.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-04
- **Sources re-read:** None. The answer rests on no source outside this repository. It rests on the
  product's own tree, read at `ka-reader@bc76311`. `git diff --stat 6a0725c HEAD -- crates checks`
  printed nothing, so the code is what the item measured.

**What this run read.** The companion whole. Of `docs/SDD.md` (5,384 lines, version 28): the header
and version lines (`:L1-L60`), § 3 *What the system holds* (`:L436-L462`), § 4 C-I1 and C-I2
(`:L676-L704`), § 6 S-4's command half (`:L1716-L1736`), S-5 whole (`:L1764-L1830`), the diff
slice's command clause (`:L1964-L1974`), RN-44 (`:L3323-L3340`), RN-88's close (`:L5276-L5308`) and
*Open Questions* whole (`:L5310-L5384`). The rest was searched for `siblings`, `` `pending` ``,
`` `observed` ``, `` `failed` `` and `` `stopped` ``, and each hit was read on its line. **§ 1, § 2,
§ 5, the other slices of § 6, §§ 7–12 and the review notes outside those hits were not read line by
line.** The prompt asks for the document whole; this run did not do that, and a sentence in those
sections that bears on the item and uses none of those words was not seen.

Outside the SDD: `crates/ka-reader-core/src/fs_reader.rs:L125-L140` and `:L846-L858`;
`docs/SRS.md:L285-L302`; `docs/nfdr.md:L1000-L1014`; `docs/UXD.md`'s UX-I10 lines (`:L136`,
`:L199`, `:L284`); `docs/architecture_open_issues.md` whole; `docs/trail/sdd/self_answer-35.md`
whole. `docs/nfdr.md`, `docs/fdr.md`, `docs/UXD.md`, `docs/CONTENT.md`, `docs/PRD.md` and
`docs/adr/` were searched for "on its siblings" and not otherwise opened; the one hit is
`docs/nfdr.md:L1010`. No test was run: the answer changes no code, and `--test watch` does not
exist yet.

**The companion held one open item**, § 2.1, with `Seat: cto` and its slot at the placeholder. The
invocation listed no items.

## Items worked

### 2.1 — § 4 C-I1 and S-5's command half say a failed read leaves "`observed` on its siblings"; a sibling not yet read is `pending`

- **Bucket:** 2. Choices to confirm — a best-effort answer was drafted; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The draft is taken: C-I1 and S-5's command clause stop saying "`observed` on its
  siblings" and say the failure is held on that item alone. Three things are added, because the
  draft's own wording would have left a smaller version of the same defect.

  **Whose call it is.** The item carries `Seat: cto`, and the three tests agree. The edits land in
  this document: § 4 C-I1, § 6 S-5's command half and RN-44, all the CTO's lane. The answer binds
  only what the SDD says about its own model. No ground this run can name is hidden from it. The
  item was raised by the previous run of this skill; that run's reasoning was weighed as a
  colleague's draft and not taken on its author's word.

  **Why the draft holds.** C-I1 reads "yields `failed` or `stopped` on that item and `observed` on
  its siblings" (`docs/SDD.md:L686-L687`), and S-5 reads "an unreadable entry yields `failed` on
  that item and `observed` on its siblings" (`:L1794-L1795`). A folder entry not yet expanded is
  `Pending`: `Ok(file_type) if file_type.is_dir() => (EntryKind::Folder, ItemState::Pending)`
  (`crates/ka-reader-core/src/fs_reader.rs:L853`). So a failed entry beside an unexpanded folder has a
  sibling that is not `observed`, and no folder that holds a folder meets either sentence as
  written. The SDD says the same thing against itself: § 3 `Item<T>` gives `pending` as "a folder
  entry not yet read" (`docs/SDD.md:L456-L457`). The requirement C-I1 cites says what the draft
  says, "degrades only that item's view" (`docs/SRS.md:L297-L298`), and so does UX-I10, "degrades
  only its own presentation" (`docs/UXD.md:L284`). The draft's doubt is fair: read as shorthand,
  the old wording is not false. It is confirmed anyway, because S-5's clause is a bar a test must
  pass, S-4 carried the same words and the change that built S-4 had to choose a tree of files only
  to meet them (`docs/SDD.md:L5249-L5252`).

  **Addition 1 — the rule, and four states where states are named.** The draft lists three states
  a sibling may hold: `observed`, `pending`, `failed`. § 3 gives four (`docs/SDD.md:L445-L448`),
  and C-I1 is the sentence that puts `stopped` on an item. A sibling whose work stopped earlier
  holds `stopped`. Three named states would read as a closed list, which is the fault the previous
  answer found in "`observed`, or `pending`" (`docs/trail/sdd/self_answer-35.md` § 5.4). So both
  sentences state the rule — a failed read changes that item and no other — and where C-I1 names
  states it names all four. S-4's sentence lists three and is left alone: it gives them as cases of
  "as they were", and the code it is checked against has three (`fs_reader.rs:L129-L133`).

  **Addition 2 — S-5 is concurrent, and "as they were before the read" is not.** S-4 reads Git once
  at open, so "as they were before the read" is checkable there. S-5's case runs while
  `checks/churn.sh` creates, changes and deletes files (`docs/SDD.md:L1790-L1795`). A sibling of the
  unreadable entry changes for its own reasons while that read is in flight, and a clause copied
  from S-4 would fail on a correct model. S-5's clause therefore says the failure changes no other
  item: each sibling holds the state its own read gave it.

  **Addition 3 — one case the answer does not cover, named.** When a folder that is already
  expanded fails on a re-read, the entries listed under it are not its siblings. Whether they
  stay, go, or are held under the failed folder is not said by C-I1 today and is not decided here.
  It is `follow-the-folder`'s design, and § 3 leaves the layout to the developer
  (`docs/SDD.md:L438`). Deciding it inside a wording correction would add a design call no item
  asked for.

  **Checked against the settled record.** The answer moves no requirement: NFR-3 and UX-I10 already
  say "only that item". C-I1's last sentences stand, including "a marker drawn from `pending`" as a
  violation (`docs/SDD.md:L695-L697`); the correction makes that sentence and the sibling sentence
  agree, since a `pending` sibling is one no marker is drawn from. The diff slice's clause, "the
  file's tree entry still `observed`" (`:L1971`), names one listed file and not siblings in
  general, and a listed file is `Observed` (`fs_reader.rs:L858`). It is left as it is. RN-44's
  parenthesis quotes C-I1 (`docs/SDD.md:L3333`) and follows it, corrected in place with a review
  note recording what it said, which is how RN-44 was corrected the round before (`:L3334-L3337`).
  RN-88's "Still standing, and not folded" paragraph (`:L5295-L5300`) is a dated note that says
  "until it is answered", and it stays as written.

  **Failure paths.** *Empty*: an item with no siblings meets "changes no other item" with nothing
  to check. *Absent*: a folder whose listing fails is itself the failed item, and its own siblings
  are untouched; its children are addition 3. *Stale*: the line locators are pinned to
  `ka-reader@bc76311` and move at the fold. *Concurrent*: addition 2. *Refused*: a sibling the system
  refuses to read is `failed` by its own read, which the rule already allows.

  **What would have tipped it.** Had C-I1 been a sentence no command bar repeats, the shorthand
  reading would have been enough and the draft would have been overridden as not worth a change.
  S-5's clause and `docs/nfdr.md` QC-47 both repeat it as something a test asserts.

  **Downstream.** `docs/nfdr.md:L1009-L1010` (QC-47, *verified by*) carries the same words. The
  SDD's fold cannot change the NFDR, so the change is raised on the NFDR's companion; see
  *Companions opened*.

## Left for the owner

None this run.

## Skipped

None this run. The companion held one open item and no filled slot.

## Companions opened

- **`docs/architecture_open_issues.md`** — **appended** — companion to `adr/` and `nfdr.md`, item
  `2.1`, landed in commit `f0789a682cee634b5c6f2eff60dd8f42e2073cec`

**Why.** QC-47's *verified by* says an unreadable entry yields "`failed` on that item and
`observed` on its siblings" (`docs/nfdr.md:L1009-L1010`). It has the defect this run confirmed in
the SDD, measured the same way (`crates/ka-reader-core/src/fs_reader.rs:L853`), and it is false on its
own whether or not the SDD moves: *a fact in it is now false*, and after the fold *something
upstream moved and it has not seen it* (`decide_companion_answers.md` § *The items are not the whole
of what a document is owed*). The previous run raised nothing there because the SDD's change was not
yet decided (`docs/trail/sdd/self_answer-35.md` § *Raised on this document*); it is decided now. The
companion was already live with one item, § 3.1, which is unchanged. The new item went under § 2 in
place of the line "None.", with its slot empty: it is the next round's to decide. `nfdr.md` was not
written.

**The doubt.** A `product-architecture` run that re-derives QC-47 from the SDD after the fold might
have caught this with no item. Nothing guarantees that it re-reads that clause, so it was raised.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
- **`adr/` and `nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
