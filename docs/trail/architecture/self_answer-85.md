# Self-answer report — `adr/` and `nfdr.md` (KA-Reader architecture records)

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` — both items bear on the NFDR (v90, Settled); no ADR moves
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-09
- **Sources re-read:** the product's git remote, read with `git ls-remote --heads --tags origin`
  from the product's checkout: `origin` is `<owner>/<repository>-dev` and lists 11 refs, as item
  3.2 says; a second remote, `old-public`, is `<owner>/<repository>`. No other source outside this
  repository is leaned on.

Read whole for this run: the companion; NFDR QC-41, QC-44, QC-71 and § 10, which the items name, the
rest of the NFDR read at its header (it runs to 8,959 lines, and neither item reaches past these
entries — a grep for `made public`, `ls-remote`, `ka-reader-dev` and `visibility` finds the one-repository
form in QC-71 and its § 10 row alone, the other hits being dated review notes); PRD v19 § Assumptions
*Public identity*; SRS v16 C-12 and AC-14; FDR v16 R-198 – R-203; SDD v85 § 6 S-7 and RN-171;
`checks/notices.sh` 1.1.0's header and `checks/gate.sh`'s notices steps at `ka-reader@75fe66c`.

## Items worked

### 3.1 — QC-41 says no check holds the copyright lines; `checks/notices.sh` and its suite now hold them at every change and at a tag

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** QC-41 states something that is now false. Its tail says one rule, the crates' copyright
  lines, "is owed to a check and held by none", and makes `development-design` reading the entry that
  rule's gate until the check lands (`docs/nfdr.md:L1632-L1637`); its § 10 row and § 10's
  review-gate list say the same (`:L3353`, `:L3377`). The check has landed. At `ka-reader@75fe66c`
  `checks/notices.sh` is version 1.1.0, whose header states the second rule — every copyright line
  the licence files of each package in the `cargo tree` name set state must stand in that
  component's entry — and the gate runs it and its suite as *Notices check* and *Notices check suite*
  (`checks/gate.sh:L129-L130`). The item is a correction, not a widening, so § *A widening item waits
  until it occurs* does not apply.

  I took the item's proposed change, which arrives as its *If a document has to be written* line, as
  a draft, and confirmed it. I checked its claims myself rather than taking the item's word, on a
  fresh clone at `ka-reader@2ee1ef7`, whose tree outside `docs/` is `75fe66c`'s
  (`git diff --stat 75fe66c 2ee1ef7 -- . ':!docs'` prints nothing). `checks/notices.sh` exits 0
  ("48 names in cargo tree, each in THIRD_PARTY_NOTICES.md"). `checks/tests/test_notices.sh` exits 0
  with 42 cases `ok`. With line 20 of `THIRD_PARTY_NOTICES.md` (`Copyright (c) 2015 Andrew Gallant`,
  under `aho-corasick`) deleted, the check exits 1 and names the line, the component and its
  `LICENSE-MIT`. So the rule is really held, and a crate update that changes its line fails the same
  check. That is the *stale* case QC-41 itself named.

  **What the answer adds.**
  - **The residue, named in full.** The draft keeps review for "the parts it does not read" and lists
    three. The script's own header (*WHAT IT HOLDS, AND WHAT IT DOES NOT*) names a fourth: the
    licences themselves, which QC-41 also requires ("the component's licence as the component
    declares it"). So the review list carries four items: the libraries' and the icon set's copyright
    lines, `NOTICE` files whole, the no-licence-file and no-copyright-line sentences, and each licence
    as declared. The libraries' lines stay with review because the check reads only licence files at
    a package's root, so a vendored C library's licence file deeper in its crate is not read. That is
    the *absent* case: a line the check cannot see is not a line it passed. Without the fourth item, a
    reader of the revised § 10 list would conclude the licences are machine-held, and they are not.
  - **The locators are re-pinned.** `checks/gate.sh:L129-L130` is now cited at `ka-reader@75fe66c`,
    in the entry's usual dated-reading form, and the "held by none" sentence is kept as a *(through
    v90 …)* reading.

  **Checked against the settled record (check 3).** SDD v85 § 6 S-7 already says the lines are "held
  by `checks/notices.sh` once it reads each resolved package's licence file … and, until that
  extension is in the tree at the tag, by release inspection" (`docs/SDD.md:L2741-L2746`). The answer
  is the branch the SDD foresaw, so no upstream document is owed a change. § 9's suite count is still
  twenty-three: `git ls-files checks/tests` lists 23 `test_*.sh`, because the extension added no new
  suite.

  **Failure paths (check 4).** If a package cannot be located, or a licence file cannot be read, the
  check refuses and exits 1 (its header, and the suite's `test_packages_not_located_is_a_refusal` and
  `test_the_first_unreadable_licence_file_in_byte_order_is_named`). The check stays non-zero when it
  could not compare, so it never passes silently. The *empty* case is a component with no licence
  file. Its "named as such" sentence is in the review residue, because the check does not read it.

  **One loose end, not owed.** The check's success line counts only names. It does not count the
  copyright lines it compared, so a passing run's output does not show that the second rule ran.
  Nothing in QC-41 needs that output, so this is recorded and not raised.

  **The verdict was close to "confirmed".** The fourth review item is what tipped it to "with
  addition".

### 3.2 — QC-71 checks every ref of one repository made public; PRD v19 publishes only the main line's history from a private `ka-reader-dev` into the public repository

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** QC-71 is still written for v18's single repository: the one repository is made public with
  its own history, and every ref of `origin` is checked (`docs/nfdr.md:L1691-L1711`, and the § 10 row
  at `:L3356`). Everything upstream has since moved to two repositories: PRD v19 § Assumptions
  *Public identity* (`docs/PRD.md:L420-L430`), SRS v16 C-12 and AC-14 (`docs/SRS.md:L530-L546`,
  `:L621-L638`), FDR v16 R-198 – R-203, and SDD v85 § 6 S-7 (`docs/SDD.md:L2750-L2784`, folded in
  its RN-171). SDD RN-171 even names QC-71 as "still in the v18 form and the Principal Architect's".
  I measured the remote this run, and QC-71's check set is now the private repository's: `origin` is
  `<owner>/<repository>-dev`, with 11 refs. So the entry's fact is false, and its upstream moved
  without it following. That is a correction, and the widening rule does not apply.

  The item's proposed change is the set the public repository receives, the main line at its first
  push, and the root-commit comparison. It is right, but it answers a smaller question than the item
  asks (check 2's third failure). It covers the first release only. QC-71 traces to AC-14, and AC-14
  at v16 has three clauses: the received commits were checked, the public repository holds no branch
  but the main line, and from the second release on the previous public history is still whole.
  Carrying only the first would leave QC-71 tracing to a criterion whose other two clauses it drops.
  So the answer carries all of S-7's checkable form. QC-71 adds no command of its own, because each
  one is the SDD's. That keeps the entry inside its source.

  **What the answer adds, item by item, with where each comes from:**
  - **The set** is the commits the public repository is to receive: the whole private `main` at
    first publication, and `<public main>..<dev main>` at each later release. It is never the
    private repository's refs (S-7, `:L2750-L2754`).
  - **The secrets half** is QC-28's *Secret scan* as built (`checks/gate.sh:L71`). It runs at the
    commit to be sent and is re-proved by `release.yml`'s *Test gate* at the tag in the public
    repository (S-7, `:L2760-L2765`). QC-71's sentence leaving "widens or runs beside it" to the
    delivery tier now closes, with nothing widened. QC-28 does not move: the history HEAD reaches is
    the set.
  - **No other branch** is read on the public repository itself: `git ls-remote --heads --tags` on it
    lists `refs/heads/main` alone, and `main` moves by fast-forward push only. This answers check 4's
    *empty* case. The public repository is not empty: S-7 records ten branches and a `main` 46
    commits behind the private one on 2026-11-09. I did not query it myself; the `old-public` remote
    exists, and that measurement is the SDD's.
  - **The private half** stays a review gate. The read's commit is the public `main`'s `HEAD`, and a
    commit landing on the private `main` after the read is not sent until it has been read itself.
    That is the *stale* and *concurrent* case (R-201).
  - **A finding** in a commit not yet public is taken out in the private repository, the read is
    repeated, and nothing is sent until it passes. This is the *refused* case (R-202). The public
    history is never rewritten: a finding in a commit already public is revoked and removed by a
    later commit (S-7, `:L2774-L2776`). S-7 leaves to the owner whether "never" yields to a leaked
    secret, raised only if it occurs, and this answer leaves it there.
  - **Never rewritten** is held by structure. The public `main` refuses a force push and a deletion,
    read through `gh api …/branches/main/protection` printing `false` twice, or the ruleset form. It
    is set after the visibility flip and before the first tag, because a private repository answers
    403 (S-7, `:L2776-L2782`). This is the *absent* case: the rule cannot be read before
    publication. From the second release on, `git merge-base --is-ancestor <previous release's tag>
    HEAD` exits 0 on a fresh clone (S-7, `:L2783-L2784`; R-203). At the first release there is no
    previous tag, and the clause does not apply.
  - **The root-commit comparison** is unchanged.

  **Checked against my own earlier answer (check 3).** The 3.1 answer touches QC-41 alone, and the two
  share no sentence.

  **The verdict was close to "confirmed" as the item proposed.** Narrowing to the first release would
  have kept the fold smaller. What tipped it is that AC-14 and S-7 are both settled and state the
  other clauses as checkable conditions now, and an NFDR entry tracing to them that omits them would
  be the next round's item. If the owner would rather keep QC-71 to the first release and give
  never-rewritten an entry of its own, that is a choice of form for the fold, and the content above
  does not change.

## Left for the owner

None this run.

## Skipped

None this run. Both open items had owner slots at their placeholder, and the invocation listed no
items, so both were this run's.

## Companions opened

None this run. Every upstream document — PRD v19, SRS v16, FDR v16, SDD v85 — already states the
two repositories and the notices check's branch, so no other document is owed a change.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
