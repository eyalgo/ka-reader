# Self-answer report — `docs/adr/` and `docs/nfdr.md`

This report records one unattended run that answered `docs/architecture_open_issues.md` in the
owner's seat. It is written for the owner, who reads it to learn what was decided and why. It is also
written for the `product-architecture` run that folds the answers.

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-04
- **Sources re-read:** None. Both answers rest on this repository: the tree, the decision log, the
  NFDR at v38 and the Settled SDD at v31. Neither answer rests on a claim about a source outside the
  repository.

## Items worked

### 2.1 — QC-11 handed its exception's check to "the change that builds the switch"; that change landed and left `checks/structure.sh` as it was

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed
- **Why:** **The draft is right, and it is right over the item's second override for a reason the
  item does not give.**

  *Where this item came from.* The previous self-answer run raised it, with a proposal and no draft
  (`docs/trail/architecture/self_answer-38.md` § Raised on this document). The producing run then
  drafted it into QC-11 at v38 (`docs/nfdr.md:L340-L350`; RN-49 (a)). So this seat proposed the
  change two rounds ago, and I did not take that proposal's measurements on trust. I re-ran them.

  *Check 1 — whose seat.* **Mine, in the owner's seat.** The edit lands in `nfdr.md` QC-11 and
  nowhere else. It changes what the tail says about where the check stands. It does not change what
  the entry forbids. It binds no person and no outside party.

  *Check 2 — the draft, re-measured at `nozoki@566558b`.*
  - The script still lists the clause as not held: "QC-11's … 'only `git-reader` imports the libgit2
    binding' outside the three units' files" (`checks/structure.sh:L257-L258`).
  - `git log --oneline 8edec4f..HEAD -- checks/structure.sh` prints only `48308ff` and `0a095f9`,
    the probe change. The switch's change, `392177d`, did not touch the script.
  - `grep -rln git2 crates/nozoki-bridge` prints `Cargo.toml`, `tests/search_path.rs` and
    `src/machine_config.rs`. That matches the tail's three files, so the bound holds today by review.
  - The SDD sentence the item cites reads as quoted. In `see-git-status`'s *Reached when*, command
    half, `checks/structure.sh` finds the libgit2 import "in `git-reader` alone, with the one
    exception § 3 states" (`docs/SDD.md:L1779-L1781`).

  The draft states each of these correctly.

  *Why confirm, and not "name the rule as owed by `see-git-status`".* That override puts a delivery
  unit in the tail as the place the rule comes from. That is the form v37 had, and it went false the
  day the named change landed without the rule. The draft's wording is "the bound stays review until
  a change adds it, by the header's rule". The NFDR's header already states that rule for every
  script rule (`docs/nfdr.md:L36-L38`), and it does not depend on which change adds the rule. That
  matters on the stale path. If `see-git-status` is reached, or some other change lands, without
  adding the rule, the draft's tail stays true and the override's would be false again. The first
  override, leaving v37's wording, keeps a sentence that points a cold reader at a landed change, so
  it is worse than either.

  *Check 3 — against what is settled.* The tail agrees with QC-13, which says QC-11 keeps the binding
  out of the bridge "by name but for the search-path switch and its test" (`docs/nfdr.md:L420-L421`).
  It agrees with QC-17's switch file (`:L502-L503`) and with the SDD `core-bridge` row's "names the
  libgit2 binding in those calls and their test and nowhere else" (`docs/SDD.md:L335`). Nothing moves
  upstream.

  *Check 4 — the failure paths.* Stale: the three-file list is pinned to `nozoki@392177d`. A fourth
  bridge file that names `git2` is caught by review at `development-design` and not by a command, and
  the tail says the gate is review. Absent: if the rule never reaches the script, the entry still has
  a named gate. Concurrent: two changes in flight, one adding a `git2` file to the bridge before the
  rule lands, fall to the same review. No case the item reaches is left unnamed.

  *For the owner, and not this record's to fix.* `see-git-status`'s own bar expects the script to
  hold this rule (`docs/SDD.md:L1779-L1781`), and the script does not. So that slice cannot honestly
  be called reached on its command half until a change adds the rule to `checks/structure.sh`. That
  is delivery work. It reaches the PM through the slice's own bar, and this answer moves nothing
  there.

  *Close to a different verdict?* "Confirmed with addition", if the tail had to name `see-git-status`'s
  bar for a cold reader. It does not. The bar is the SDD's to state, it does, and naming it here
  would be the override.

### 2.2 — ADR-0013 names SM-4's list as nine, and SDD v30 makes it ten with `read_git`; the run drafted a superseding record, ADR-0021, rather than a correction in place

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** **Supersede. Accept ADR-0021, mark ADR-0013 superseded, and fix one wrong pointer in
  ADR-0021 on the way.**

  *Check 1 — whose seat.* **Mine, in the owner's seat.** The change lands in the decision log, which
  is this companion's document. The SDD's CTO seat already decided the ten-call list itself (RN-90,
  on the owner's route, `docs/trail/sdd/cycle-25.md` § 5.1). This item asks only what form the
  log's record of that decision takes. That binds the log's internal consistency and nobody outside
  it. I cannot name a ground I cannot see, and the log has answered this exact question in the
  owner's seat before (ADR-0020 over ADR-0016, `docs/trail/architecture/cycle-30.md` § 2.1, a
  `confirm, with one addition` at `:L57`).

  *Check 2 — the draft.* **The conclusion is right. The stated reason is incomplete.** The item says
  the choice is the owner's "because a wrong guess either loses the history or rewrites an accepted
  record". That frames three options as open. They are not open, because the log has already drawn
  the line, and I measured where:
  - **In-place, with a dated note**, the log fixes a fact, a pointer or a description that the
    record's rule does not rest on, even inside § Decision. ADR-0012's dated notes at `:L41-L57` sit
    in its § Decision (`:L30-L81`), and the record says what it fixes is "the gate, its two rules …
    and its place after the wall probe, not the frames" (`:L119-L121`). ADR-0016's note at `:L45-L49`
    corrects a reason clause in § Decision (`:L21-L51`). ADR-0010's note at `:L131` sits in
    § Consequences.
  - **Supersession** happens when the rule a later change is held to moves. ADR-0020 superseded
    ADR-0016 when the libgit2 import rule gained its exception.

  ADR-0013's "all nine from `v1.0.0`" and its nine names are that kind of rule
  (`docs/adr/0013-sandboxed-single-process-read-pipeline.md:L44-L47`). They say what may cross the
  seam and what C-I6's pin holds a release to from `v1.0.0` (`docs/SDD.md:L904-L917`: the pin fails
  "when … a pinned function is absent from the bridge's exports"). A dated correction there would
  rewrite a binding rule in an Accepted record. The owner's posture for this seat forbids that, and
  the log's own index says so: "a reversal is a new record that supersedes an old one, never an edit
  to it" (`docs/adr/README.md:L4-L5`). "No record" needs that same correction, so it fails the same
  way.

  I first wrote the slot saying in-place corrections sit only outside § Decision. That was false of
  ADR-0012 and ADR-0016, and I corrected the slot before committing. The line is about what the rule
  rests on, not which section a sentence sits in.

  *The significance gates, re-checked at their sources.* Hard to reverse: C-I6 reads the export set
  from `v1.0.0` (`docs/SDD.md:L904-L917`), so after that release dropping `read_git` costs a major.
  Surprising without context: SM-4's upward half still names `model_changed` (`docs/SDD.md:L426`),
  so a reader asks why Git state is pulled. A real trade-off: RC-4 *Stopped* gives two options up
  for stated reasons (`docs/SDD.md:L2658-L2661`). All three hold.

  *ADR-0021's evidence, re-measured at `nozoki@566558b`.* `nozoki_read_git` is at
  `crates/nozoki-bridge/src/exports.rs:L105`. The export test's admitted array is at
  `crates/nozoki-bridge/tests/exports.rs:L17-L23` and holds it. `grep -rn nozoki_read_git nozoki-mac`
  prints nothing. The three earlier exports sit at `:L55`, `:L73` and `:L90`. The read-once rule is
  at `crates/nozoki-bridge/src/session.rs:L649-L653`: the doc comment starts at `:L649` and the
  record cites `:L650-L653`, which is close enough to find it and is not worth a change.

  *The addition.* ADR-0021's *Traces to* cites this item as "`docs/architecture_open_issues.md`
  § 2.1, as this run wrote it"
  (`docs/adr/0021-sandboxed-single-process-read-pipeline-git-state-pulled-by-read-git.md:L176`). The
  item is § 2.2. § 2.1 is QC-11's. NFDR v38's header and RN-49 both say § 2.2 correctly
  (`docs/nfdr.md:L5`). The record is still Proposed, so the fold that accepts it may set that line
  right. It should point at this item's trail copy, § 2.2, as ADR-0013's own *Traces to* points at
  its accepting item's trail copy (`docs/adr/0013-sandboxed-single-process-read-pipeline.md:L130-L136`).

  *Check 3 — against what is settled.* No other record counts the list
  (`grep -n -i "nine\|ninth" docs/adr/*.md` matches it only in ADR-0013, ADR-0009's "nine parts" and
  ADR-0012's "ninth dated note"). The records that cite ADR-0013 as "the shape" (ADR-0014, ADR-0015,
  ADR-0017, ADR-0019, ADR-0020) stay as written. The log already leaves accepted records citing a
  superseded one, for example ADR-0015 citing ADR-0016 (`:L118`). QC-24 already names ten and
  ADR-0021 as proposed (`docs/nfdr.md:L600-L630`). On acceptance, the traces of the entries ADR-0013
  binds move to ADR-0021, as the item says and as RN-44 did for ADR-0020.

  *Check 4 — the failure paths.* Stale: ADR-0021's "no Swift source calls it" is dated to a commit,
  which is how a record states a measurement. The future case: the record's title counts "ten
  calls". When `follow-the-folder` raises the `model_changed` registration call, QC-24 calls it a
  "second plumbing export", beside the list like `nozoki_free`, so the count holds. If the SDD
  instead puts it on the list, the log owes another superseding record. That is the cost of recording
  a closed list as a decision, and the record makes it visible rather than hiding it. Concurrent:
  "which side orders two asks in flight" is left open in ADR-0021 § Consequences and in RC-4 *Still
  unresolved*, and is named there. Refused: if the owner overrides this later, the item's
  *If overridden* paths are coherent while ADR-0021 is Proposed. After acceptance, an override is
  itself a superseding record.

  *Close to a different verdict?* Only "confirmed", if the item's stated reason had been the log's
  line. It was not, and a later reader who inherits "a wrong guess either way" would think the next
  such choice is open too.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
