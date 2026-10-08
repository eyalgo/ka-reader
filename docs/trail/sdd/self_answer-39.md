# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v31, Settled)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-04
- **Sources re-read:** Apple's *Accessing files from the macOS App Sandbox*
  (`https://developer.apple.com/documentation/security/accessing-files-from-the-macos-app-sandbox`),
  because the answer leans on the sandbox refusing a read outside the granted folder. It says the
  system "extends your app's sandbox to include the selected URLs", and for a folder "to items
  within that folder, and recursively in nested folders". It names no access to a path outside the
  selection. That matches § 11 R-16's response as the SDD states it. The SDD's statements about
  libgit2's own source were not re-read at the source: the answer does not depend on which lines of
  libgit2 follow the three keys, only on the SDD saying that they are followed.

**What this run read, and what it did not.** `docs/SDD.md` was not read whole. It is 5,719 lines.
This run read the header and version lines, *Who holds what*, § 3's parts rows from `fs-reader` to
`markdown-renderer` and the SM-4 row, § 4's opening note and C-D3's tail, § 6 S-4, the head of § 7
and of § 10, § 10 RC-4, § 11 R-14's tail to R-16, RN-90, RN-91 and *Open Questions*. It searched the
rest for `ka_reader_read_git`, `no later than`, `before the slice is reached`, `R-16` and `outside the
grant`. A sentence elsewhere that states the bound in other words was not seen. `docs/PRD.md`,
`docs/SRS.md` and `docs/UXD.md` were not opened: the answer moves no requirement and no experience
entry. `docs/nfdr.md` was read at its header and at QC-6 and QC-35 only.

**What this run measured,** at `ka-reader@78e823a`:

- `grep -rn 'ka_reader_read_git\|read_git\|readGit' ka-reader-mac/Sources` printed nothing.
- `grep -rn 'include.path\|excludesfile\|attributesfile' checks/fixtures` printed nothing.
- `grep -n 'no later than\|before the slice is reached' docs/SDD.md` printed six lines: `:L2676`,
  `:L2826`, `:L5227`, `:L5696`, `:L5698` and `:L5704`.
- `git tag` printed nothing.
- `ls docs/*open_issues*` listed `docs/SDD_open_issues.md` alone before this run.

## Items worked

### 5.1 — The config-named-path item's bound falls on the first build that calls `ka_reader_read_git`; move it to a later build of `see-git-status`

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** The item arrives with a route and no drafted wording, so it was answered from scratch.
  The bound moves, and the new bound is the half the item already carries: settled in
  `see-git-status` before the slice is reached. No build inside the slice is named in place of the
  old one.

  **Whose it is.** The item's `Seat:` is `cto`, and the change lands in `docs/SDD.md` alone, in
  three places the CTO's lane holds: *Open Questions*, § 11 R-16 and § 10 RC-4. I asked whether it
  is the owner's instead, because moving the bound means builds that open a reader's repository
  with a read outside the grant still unsettled. That trade-off is the owner's, and the owner has
  made it. The item records it under *The route the owner chose*, and the commit that opened the
  companion says the same (`ka-reader@78e823a`). This run did not see the owner's words. It rests on
  the PM's record of them in those two places. What is left is how the SDD words a bound the
  owner already chose to move, and the item gives that to the SDD.

  **Not a widening.** The item asks the SDD to change a statement it already makes, and it cites
  what it found in the tree. The rule that a widening item waits until it occurs does not apply.

  **One question, not two.** The item is careful to ask for the bound only. Which of the two
  forms closes R-16 is not asked and is not answered. The SDD keeps that in *Open Questions* on
  purpose: "Which of the two forms closes R-16 is not chosen by the answer and is not chosen here"
  (`docs/SDD.md:L5583`).

  **Why "before the slice is reached" and no named build.** The item asks for "a later build of
  `see-git-status`". The SDD can name a build only by what it does, and the two it has named this
  way both passed or were about to pass with the item open: the build that first exports a
  function reaching `git-reader` (`docs/SDD.md:L5704-L5706`), and the build in which the shell
  first calls the export (`docs/SDD.md:L5696-L5698`). A third named build is a third deadline of
  the same kind. "Before the slice is reached" is different. It cannot pass unmet without the
  slice staying unreached, so nothing has to notice a missed date. The item already carries it as
  "in every case before the slice is reached" (`docs/SDD.md:L5698`), and the request leaves that
  half in place. So the answer removes the first half and keeps the second as the whole bound.

  **This is the last move.** There is no later build of the slice than the one that reaches it.
  If the fixture and its case are missing when *Reached when* is claimed, the slice is not
  reached. The answer says that in the slot, so a later reader does not take this move as a
  pattern.

  **Who holds the bound.** The item says "No check enforces this bound. It is held by review of
  the change that makes the shell call the export" (`docs/SDD.md:L5700-L5701`). The second
  sentence names the old bound's holder and goes with it. The new holder is the review of the
  change after which `see-git-status`'s *Reached when* is claimed whole. There is still no check,
  and the answer keeps that sentence. I did not add the fixture and its case to S-4's *Reached
  when*. That would hold the bound with a command and not a review, and it is the stronger form.
  It also moves a slice's *Reached when*, which the item did not ask for and which § 10 treats
  as a re-cut matter (`docs/SDD.md:L2408-L2427`). It is named here so the CTO's fold can take it
  if it judges the review too weak.

  **Against the settled record.** Three things were checked.
  - § 4 C-D1 and `docs/fdr.md` R-101 say the product reads nothing outside the granted folder.
    R-16 already states the limit: "Until that item is settled this is a stated limit of § 4 C-D1
    outside the sandbox, not a held property" (`docs/SDD.md:L2826-L2828`). The answer leaves that
    sentence as it is. It makes the period it covers longer and does not change what holds in it.
  - My own earlier answer set the bound this one moves (`docs/trail/sdd/self_answer-38.md`, § 5.4).
    That answer is not re-opened here. It was folded as RN-91, and this item is the proper channel
    for changing a settled thing. That answer's reason was that the first calling build is "the
    first in which a reader's own repository reaches libgit2". That is still true. What changed is
    the owner's choice to accept those builds with the item open.
  - § 4 C-I3 and § 11 R-15 name the same build for the `nm` transport read
    (`docs/SDD.md:L771-L774`, `:L2802-L2803`). They are about a different risk and are not moved.
    The `nm` read runs on every build with nothing further owed.

  **On the failure paths.**
  - *Empty:* no fixture carries one of the three keys, so no case can pass or fail today, and the
    harness reads no outside path today. The grep is above.
  - *Absent:* in the harness nothing bounds a config-named read. That stays true until the item is
    settled, as R-16 says. Adding the fixture is the moment the harness could make such a read,
    and the fixture's own case is what shows it does not.
  - *Stale:* the SDD's dated note says "Until the shell calls the export the bundle opens no
    repository" (`docs/SDD.md:L5706-L5707`). After the next build that is no longer the state of
    the tree. The answer asks for a dated sentence after it, so the note is not read as current.
  - *Concurrent:* not reached. The bound is a date for a question, and no two actors meet on it.
  - *Refused:* in the bundle the sandbox refuses the read. Whether libgit2's open or status read
    survives that refusal "has not been run" (`docs/SDD.md:L2821-L2823`). If it does not, the Git
    item is `failed` with its condition, and S-4's observable half already draws that state
    (`docs/SDD.md:L1742-L1744`: "Git state the tool could not read … shows
    on that item what was observed, and the rest of the view stands"). The answer puts this in
    the item, because from the first calling build onward a reader can meet it.

  **Nothing is released in the meantime that this run can see.** `git tag` prints nothing. The
  slice that offers the product to a stranger is S-7, and S-4 is ahead of it in § 6. This run did
  not read § 7 whole, so it does not claim an edge between the two.

  **What would have tipped it.** If the owner's choice had not been on record, this would have
  been left for the owner, with the same answer under it: the trade-off between a held bound and
  an unblocked build is theirs. If the sandbox were not the wall in the bundle, I would not have
  moved the bound on any route, and would have said so against the item.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

- **`docs/architecture_open_issues.md`** — **opened** — companion to `adr/` and `nfdr.md`, landed
  in commit `250fc6e`

**Why it was opened.** `docs/nfdr.md` repeats the old bound in QC-6 (`docs/nfdr.md:L248-L249`) and
QC-35 (`docs/nfdr.md:L938-L940`). A later change reads those entries to learn what its review must
hold. Left as they are after the SDD folds, they would still refuse the build the SDD has stopped
refusing. The records were Settled with no companion on disk, so nothing would have carried the
change to the Principal Architect. The item is § 2.1 there, with its slot left open.

**One doubt, also written in that item.** The change is owed only after `product-sdd` folds § 5.1.
Until then QC-6 and QC-35 agree with the SDD as it reads. If the records' round runs first, the
item should stay open and not be closed as done.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
