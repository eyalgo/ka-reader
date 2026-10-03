# Self-answer report — `docs/CONTENT.md`

## Header

- **Companion:** `docs/CONTENT_open_issues.md`
- **Document:** `docs/CONTENT.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-04
- **Sources re-read:** Git's own `wt-status.c`, which the answer's wording rests on, read at
  https://raw.githubusercontent.com/git/git/master/wt-status.c on 2026-10-04. `show_am_in_progress`
  prints "You are in the middle of an am session."; `wt_status_get_state` takes the `rebase-apply`
  directory as an am session when `rebase-apply/applying` exists and as a plain rebase when it does
  not. Nothing else in the answer rests on a source outside this repository.

The companion held one open item, § 3.1, raised from downstream by the PM on 2026-10-04. §§ 1 and 2
read "None.". This run answered § 3.1 and raised nothing.

## Items worked

### 3.1 — The Git view's short status has no sentence for a repository mid-`am`

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the verbal language
- **Verdict:** answered
- **Why:** Answered from scratch: add a seventh whole sentence, *"An am session is in progress in
  this repository."* The item arrives with two ways forward and no lean, so it is read as a question
  and not as a draft to confirm.

  *Is it widening, and does it cite an occurrence?* It widens the document: § *The short status*
  (`docs/CONTENT.md:L394-L397`) fixes six states and six sentences, and this adds a seventh. The
  occurrence bar (`pm_shukuba_refine.md` § A gap is carried only where it occurs) is met by the item
  itself, and I re-read both sites: `RepositoryState::Am` is a variant at
  `crates/nozoki-core/src/git_reader.rs:L117`, and `GitRepositoryState::ApplyMailbox =>
  RepositoryState::Am` is the mapping at `crates/nozoki-core/src/git_reader/libgit2.rs:L339`. So the
  item is taken, not answered "not until it occurs".

  *Seat (check 1).* This one is ours. The edit lands in `CONTENT.md` and binds only its wording. The
  item names a second path, that the definition set decides *am* is shown another way. I did not
  split it: the halves are not separable, because that path is an override of a rule already
  settled, not a second question. R-162 says the short status names "any state but normal" in
  "Git's own word for it" (`docs/fdr.md:L141`), and the owner's answer behind it says the same with
  the same six as examples (`docs/trail/fdr/cycle-1.md` § 1.4; RN-22). The rule decides the seventh
  state, so the FDR needs no change and the item does not leave this document. I could not name a
  ground I cannot see that would make it the owner's.

  *Soundness (check 2).* The item's framing holds. Its citations hold at their lines:
  `docs/CONTENT.md:L394-L397` says six states and six sentences, and `docs/fdr.md:L141` stops its list
  at the same six. It is right that the reader can answer a seventh state.

  *Against the settled record (check 3).* The wording is Git's. `git status` prints "You are in the
  middle of an am session." (`wt-status.c`, `show_am_in_progress`, re-read at the source). The word
  is *am session*, so the sentence is Nozoki's and the word is Git's, which is the *Bilingual* row
  of § Voice and the rule in RN-32. The reading bar admits it as a word Git itself uses for the
  state in hand (`docs/CONTENT.md:L446-L458`). It does not use *paused*, *stuck* or *interrupted*,
  which L400-L402 bars. It names no remote, no count and no branch. It does not pass Git's sentence
  through: "You are in the middle of" makes the reader the actor, as RN-32 says of the rebase
  sentence. It is one whole sentence with no placeholder, so § Localization holds. The shape follows
  the rebase example at L406. *An* is correct: *am* is read as a vowel sound either way.

  *Failure paths (check 4).*
  - *Both states at once:* an am session on a detached HEAD. The reader returns the operation
    before the detached state (`libgit2.rs:L327-L339`, where `Clean if head_detached` is the only arm
    that yields `DetachedHead`), and `CONTENT.md:L397-L398` already says the operation is the one
    named (R-165). So the status says *am*, not *HEAD*.
  - *am against rebase:* libgit2's `ApplyMailboxOrRebase`, a `rebase-apply` directory with no
    `applying` file, is mapped to `Rebase` (`libgit2.rs:L338`). Git's own `wt_status_get_state`
    treats that case as a rebase, so the reader and Git agree and the sentence is never *am* where
    Git would say *rebase*.
  - *Stale:* the session ends, by `--continue`, `--abort` or `--skip`, between two reads. The sentence
    is replaced by the next read, and § *Recovered* applies: nothing announces it.
  - *Absent:* Git state cannot be read. That is UX-S3's error cell and the existing *Error* pattern,
    not this sentence.
  - *Empty and refused:* neither applies. The status is a read and there is nothing to refuse.

  *What the fold changes.* In `CONTENT.md`: § *The short status* (L394-L397) lists *am* and counts
  seven states and seven whole sentences; its examples may stay; RN-32 (L816-L829) adds Git's
  "You are in the middle of an am session." to the words it records, with this source and the read
  date; and a new Review Note records this item. The voice, the tone entries and the five formulas
  do not move.

  *Left alone, and why.* `docs/fdr.md` R-71, R-162 and R-165, `docs/UXD.md` UX-S3 and
  `docs/SDD.md:L1686` each list the same six. I did not raise a change on any of them. Each states a
  rule, "any state but normal" or "the state it is truly in", and the list follows as examples, so
  none is made false by a seventh state and no reader of them is misled about what the status says.
  The item's own condition, "if the call moves R-162's list", is not met by this call. That is a
  reading, and the near-tip is the one a different reader would take: if the Principal PM means R-162's
  list to be closed, the sentence is still the right wording and the FDR is what moves. This run
  would then expect it as a companion item raised by the PM, which is how this item reached us.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/CONTENT.md`** — `/Users/eyalgolan/.kensaiapp/pins/20261003T222410Z-402wmg/core/launchers/skill/launcher.sh product-content nozoki`
