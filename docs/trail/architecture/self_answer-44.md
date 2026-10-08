# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (one companion for both, by its header's pointer)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-07
- **Sources re-read:** None. No answer rests on a source outside this repository. Both answers rest
  on the tree at `ka-reader@772c63b`, read at the lines cited, and on `docs/SDD.md` v46. The libgit2
  facts the records repeat — the six members, the include and alternates depths, and the looked-up
  set — are the SDD's and the building change's measurements. They were not re-read at the
  libgit2 source, and neither answer turns on their exact values.

**What this run read.** The companion whole. ADR-0022 whole, and the decision log's index. In
`docs/nfdr.md` (453 KB, about 4,800 lines): the header and version line (`:L1-L40`), QC-6 whole
(`:L257-L330`), QC-15 whole (`:L502-L579`), QC-26 (`:L847-L856`), QC-30's ADR-0022 sentence
(`:L895-L915`) and QC-35 whole (`:L1035-L1098`). Beyond those, the NFDR was searched for
`gitmodules`, `ADR-0022` (22 lines), `unreadable Git directory`, `GitDirectoryUnreadable`,
`C-R6`, `lockfile`, `re-measure` and `pinned to`, and every entry line that printed was read.
**A sentence elsewhere in the NFDR that states the `.gitmodules` refusals as unbuilt in other
words was not seen; the fold reads for it.** In `docs/SDD.md` v46: the header, its version line,
and RN-106 whole, including *Surfaced for the Principal Architect to record*. The SDD's grep for
`GitmodulesUnreadable` and the config-named-path item was read at every line it printed. Also
read: `docs/trail/architecture/cycle-38.md` §§ 3.1 – 3.2 (the answers);
`<CORE>/templates/product-templates/adr_record_template.md` on supersession and status. At
`ka-reader@772c63b`: `crates/ka-reader-core/src/git_reader/libgit2.rs:L200-L360` and the walk's two
inspectors (`:L660-L700`); `git_reader.rs:L200-L260`; `git_state.rs:L2630-L2730` and the name of
every `.gitmodules` case; and `GitSentences.swift:L1-L60`.

**Measured.** `git -C ka-reader status --short` printed nothing at intake.
`git diff --stat 772c63b HEAD -- . ':!docs'` printed nothing at HEAD `63e48c1`, so every code
locator holds at HEAD. `git grep -c 'std::process' 772c63b -- 'crates/*/src'` printed nothing
and exited 1. `ls checks/fixtures` lists `gitmodules-names-outside` and its `.git.tar`.
`cargo test` was not run in this run, and no pass count here is this run's. The SDD's fold ran
`cargo test --workspace --locked` on a disposable copy at `ka-reader@1d5c3cf` (558 passed; SDD RN-106,
*Measured in this fold*). That tree is `772c63b`'s outside `docs/`.

## Items worked

### 3.1 — QC-6 and QC-35 name the `.gitmodules` section-path and submodule-map refusals as stated and not built, and both are built

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The PM is right on the facts, and the item proposes the change ("A change in `nfdr.md`
  QC-6 and QC-35"), so I read it as a draft and confirmed it. It is a correction, not a widening:
  a statement found false, so § *A widening item waits until it occurs* does not apply. The seat is
  this document's. The edit lands in the NFDR, and it binds only the record's agreement with the
  tree and with the Settled SDD.

  **Check 2 — the draft holds, and it answers a smaller question than the entries now owe.** At
  `ka-reader@772c63b`, `check_section_value` (`libgit2.rs:L330-L357`) does three things, all on
  `status()` alone. A value beginning `/` answers `ConfigNotLocated`. A value that spells outside
  the folder answers `ConfigNamesOutside`. A looked-up name whose value spells to another location
  answers `SubmoduleElsewhere`. Both condition variants exist (`git_reader.rs:L237`, `:L241`), and
  so do the cases (`git_state.rs:L2638`, `:L2680`, `:L2761`, `:L2776`, `:L3035`). The item was
  raised at `ccbe02a`, before the SDD's cycle-41 fold (`63e48c1`). That fold closed and removed the
  SDD's *Open Questions* config-named-path item (SDD RN-106 (7)), and both entries close their
  `.gitmodules` case on that item. The draft quotes that close as part of what is false, but it
  does not say the pointer itself now names nothing. That is addition (2).

  **Check 3 — what it rests on, and agreement with the record.** The authority is SDD v46,
  Settled. Its RN-106 rewrites § 11 R-16's known-defect paragraph as *Built, and the cases that
  hold it*. RN-106 also names the NFDR and ADR-0022 as downstream records that are the Principal
  Architect's. The answer agrees with `cycle-38.md` § 3.1, the last fold of the same shape for the
  alternates check: the same entries, the same dated-note discipline, and the same re-pinning of
  the FIFO cases.

  **Check 4 — the paths the happy case does not reach.**
  - *Stale:* the five FIFO locators are pinned at `66f428d` and stay true there.
    `git_state.rs` has since moved by about nine hundred lines (SDD RN-106 (d)), so the fold
    re-pins them by a fresh run rather than carrying them.
  - *Stale, across a version:* the submodule-map refusal is decided against the looked-up set
    (`SectionScope`, `libgit2.rs:L223-L230`). That set is pinned to `libgit2-sys` exactly as the six
    members are. If a later libgit2 looked up more paths, a section naming one of the extra paths
    would pass unchecked, and no case would see it. That is addition (5), which SDD RN-106
    surfaces to this seat ("a fact the NFDR's lockfile-review entry may want beside them").
  - *Concurrent:* a file rewritten between the check and libgit2's read stays uncovered, as both
    entries already say. The answer keeps it.
  - *Absent:* an absent `.gitmodules` is skipped (`libgit2.rs:L244`). That is not a gap, and no
    entry needs it.

  **Additions beyond the item, each named.**
  - (2) The closing pointer and the review bound are retired, because the SDD item is gone and the
    fourth case and its fixture are in the tree.
  - (3) The fourth case watches a FIFO at the outside `x`'s `.git/config`
    (`opener_seen_during_the_three_calls`, `git_state.rs:L2690-L2694`), which makes it a sixth
    FIFO case for QC-35's tail.
  - (4) QC-30's "does not yet hold" (`nfdr.md:L905`) loses its "yet".
  - (5) The looked-up set is named beside the six members.
  - (6) QC-15 needs no change. The walk along a section's name is a walk along a value the
    `.gitmodules` check locates, which `nfdr.md:L517-L518` already names. `inspect_for_section`
    reads metadata and link text at inside positions only, as the list says.

  **Close calls.**
  - I nearly left (5) out, as a widening with no occurrence. What tipped it is that the SDD names
    it to this seat by section (RN-106, *Surfaced for the Principal Architect to record*, "Two").
    That is the occurrence, and the Dependence lens asks every record to name the platform fact
    it rests on.
  - On (6), a reader who takes "value" to mean only a key's value would want the name added to the
    list. If the fold reads it that way, adding "and each section name the check spells" is a
    clarification, not a new read.

  Decided together with 3.2: every ADR-0022 trace in QC-6, QC-15, QC-30 and QC-35 moves to the
  record 3.2 writes.

### 3.2 — ADR-0022's *Decision* says a file the check cannot read answers the unreadable-Git-directory condition, and an unreadable `.gitmodules` answers a condition of its own

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** The item offers three forms and leans toward none of them ("is this seat's call"), so
  this answer starts from scratch. **A new record, ADR-0023, supersedes ADR-0022.** The seat is
  this one: the decision log is the Principal Architect's, and the CTO has already decided the
  substance in SDD v46 (RN-106 (1); § 11 R-16, *Not covered*). Recording it is Fidelity, not a
  decision.

  **Why the other two forms fail.**
  - *Amend in place.* An Accepted record is never rewritten. A reversal is a new record, and
    the superseded record's Status line is the only line in it that changes
    (`adr_record_template.md:L22-L23`; `docs/adr/README.md:L4-L5`). No status exists for a
    partial amendment (`adr_record_template.md:L66`).
  - *Leave it, with the SDD stating the exception.* The *Decision* line is a present-tense rule,
    and it is false of the product at `772c63b`. The delivery tier reads ADR-0022 as a fixed
    reference, so a later change could cite it to move `GitmodulesUnreadable` back to the
    unreadable-Git-directory condition, and the log would back that change. The log also ships
    with the tool, and its cold reader has no SDD session to correct it.

  **Why this does not contradict cycle-38 § 3.2 (check 3).** That answer declined to supersede
  ADR-0022 for two reasons that do not hold here. Its paragraph was pinned to `ka-reader@076eac2`
  and true there. And nothing had been decided anew: the check built was the check decided. Here
  the line is not pinned, and the condition is a new decision the CTO made and surfaced to this
  seat. The significance test passes, though not by much:
  - *Hard to reverse.* The condition crosses SM-2, SM-4 and SM-8 and carries a published sentence
    (`GitSentences.swift:L30-L33`), which ADR-0022's own *What undoing it costs* already calls
    the cost.
  - *Surprising without its context.* One file answering a condition the rest do not reads as an
    inconsistency until C-E4 is read.
  - *A real trade-off.* Reusing an existing condition means stating a cause that was not
    observed; adding one means a new condition and a new sentence.

  **Check 4 — what the new record must state, so that it reaches the failure paths.**
  - *Refused* (the read not permitted, a link, not a regular file, or over the size bound), at
    depth 0 of any level's `.gitmodules` walk, the repository's or a verified submodule's: it
    answers `GitmodulesUnreadable` (`libgit2.rs:L280-L290`).
  - *Refused*, in an included file: it keeps the unreadable-Git-directory condition, as SDD v46
    § 3 states.
  - *Absent*: skipped at any depth (`:L244`).
  - *Unparseable*: the read-failed condition (`:L250-L251`), unchanged from ADR-0022.
  - *Concurrent*: the two-reads race stays named as uncovered. A `.gitmodules` readable at the
    check and unreadable at libgit2's read is that race, not a new case.
  - *Stale*: *Built and not built* is re-pinned at the current tree, with every check built.
    ADR-0022's pinned paragraph stays as history under its new status.

  **Close call.** I came close to "left as is; the SDD carries the exception," on cycle-38's
  reasoning. What tipped it is that this line is a binding rule, not a pinned measurement, and an
  accepted record stating a false rule is exactly the drift the log exists to make impossible.

  Decided together with 3.1, whose traces move to ADR-0023 in the same fold.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run. SDD v46 already states everything both answers rest on (RN-106), and `docs/SDD.md`
is Settled with no companion. No other document was found owing a change.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
