# Self-answer report — SRS.md

## Header

- **Companion:** `docs/SRS_open_issues.md`
- **Document:** `docs/SRS.md` (Draft, v9 — one item open)
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-01

## Items worked

### 2.1 — RN-35's sibling sentence — "`docs/UXD.md` UX-S4 still makes a non-repository a startup failure" — describes a state that ended at UXD v6

- **Bucket:** 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The draft is taken — RN-35's sibling sentence gains a closing clause recording that the
  divergence ended at UXD v6 — with two additions: the clause is pinned to a version and a commit,
  and the precedent the draft names for its form is replaced by the closer one. Nothing in the
  draft's conclusion moves.

  **Check 1 — yours, in the owner's seat.** The edit lands in `docs/SRS.md` RN-35, the CTO's
  document outright (`<CORE>/roles/loaders/cto_global.md` § What you own), and binds nobody outside
  it: no requirement moves, no person, party, risk or taste is committed. One thing worth saying
  plainly: this item was raised by the previous self-answer run
  (`docs/trail/srs/self_answer-1.md` § Raised on this document) and its slot left at the placeholder
  because "the decision is the next round's". This is that round — a `product-srs` fold (SRS v9,
  `ka-reader@82c199a`) sits between the raising and the deciding, and every fact below was re-measured
  on disk today rather than inherited from the report that raised it.

  **Check 2 — the conclusion holds; one reason is replaced.** The claim is on disk both ways:
  `docs/SRS.md` RN-35 says UX-S4 "still makes a non-repository a startup failure"; `docs/UXD.md`
  § UX-S4's row says "A folder that is not a Git repository is not on this list: it opens (UX-I17;
  narrowed at v6 with PRD v11 — RN-25)", RN-25 says UX-S4 "narrows … and the non-repository case
  leaves it", and RN-28 says "`docs/SRS.md` v8 was read for collisions with this revision and none
  was found: its FR-33 and FR-34 … state, as system requirements, what UX-I17 states as
  experience". Order: `git log` gives `e4ed5fe` (SRS v8) and `dd08f2d` (UXD v6), both 2026-08-26,
  UXD v6 the later commit — so the sentence was true when written and is false now, which is the
  prompt's strongest ground ("a fact in it is now false … a claim about another document"). The
  draft's analogy does not carry the weight put on it: RN-35 recording RN-29's close is the
  *later-note* form — a new note records that an older one's claim ended — while the draft proposes
  appending a clause *to RN-35 itself*. That form has its own precedent in this document, and it is
  the closer one: RN-10's appended sentence ("The re-authored UX Notes later stated the behavior
  itself; FR-3's widening to match is RN-17's") and RN-19's appended sentence on the removal at
  `9017ae2` are each a close written onto the note it closes. So the form is sanctioned, by the
  right precedent — and it is the right form here because RN-3's reasoning applies: a reader of
  RN-35 alone should see the divergence and its end in one place, the way NFR-8 carries its bar and
  its headroom in one sentence. I was close to proposing a new RN-37 instead; what tipped it is that
  a note carrying only "RN-35's sibling sentence has ended" is a pointer, not a record, and the
  appended-sentence form already exists twice in this document.

  **Check 3 — nothing settled contradicts it.** The SRS's own stability rule permits a delta that
  traces to an owner answer (`<CORE>/prompts/cto_create_srs.md` § On a re-run; the header
  blockquote, `docs/SRS.md:9-11`), and a confirm-or-override answer on this companion is that
  channel — RN-36 already records a self-answer in the owner's seat as its authorization. FR-3 and
  FR-34 are unchanged and now agree with UX-S4 and UX-I17, which is what "the divergence closed"
  means; the sentence's "does not reshape FR-3 or FR-34 to it" stays true. RN-19 and RN-20, which
  describe the UXD as removed at `9017ae2`, are history and stand — the previous run examined and
  declined to raise them (`docs/trail/srs/self_answer-1.md` § Raised on this document, "Not raised,
  and named"), and a re-run does not re-weigh a decided call. Downstream: nothing quotes RN-35's
  sibling sentence. `docs/SDD.md` RN-9 already records "with UXD v6, a plain folder is not on
  UX-S4's list at all"; `docs/fdr.md` R-9 ("A readable folder that is not a Git repository is not a
  startup failure: it opens") traces to FR-3 and FR-34, not to RN-35. So the fold reaches RN-35 and
  the Version line and propagates nowhere else.

  **Check 4 — the failure paths.**
  - *Stale* — the one that bit this sentence. It went false because it was written in the present
    tense about a document that then moved. The addition: the clause is pinned — "ended at UXD v6
    (`ka-reader@dd08f2d`, 2026-08-26)" — so it stays true whatever UXD v8 does, the way RN-35's own
    "PRD v8 → v11" and RN-19's `9017ae2` are already dated facts.
  - *Concurrent* — a UXD round in flight that could move UX-S4 again while the fold runs. None:
    `ls docs/*_open_issues.md` on 2026-09-01 shows `architecture`, `CONTENT`, `fdr` and `SRS`
    companions and no `UXD_open_issues.md`; `docs/UXD.md` is Settled at v7, whose Version line opens
    "nothing about the experience changes".
  - *Absent* — a reader who cannot open `docs/UXD.md` at the cited row. The commit pin and the row
    name (§ UX-S4, RN-25, RN-28) give three ways in; the sentence they replace gave one, and it was
    wrong.
  - *Refused* — the override branch. Leaving the sentence as written keeps a claim a reader finds
    false at the row it names; the item states this and there is no third branch. Not taken.
  - *Empty* — not reached; nothing in this item has an empty case.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SRS.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-srs/launcher.sh ka-reader`
