# Architecture open issues — Nozoki

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the SRS, the SDD
> and the FDR.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-architecture`. It folds your answers into the records and drops the resolved items.
> When nothing is left open, `product-architecture` **deletes this file**: no file = the records are
> done.
>
> Your answers are never thrown away. Each time the Principal Architect folds them in, it first copies
> this file whole to `docs/trail/architecture/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 is raised, not asked.** These records bind every later change, so the seats that live under
> them find gaps the authoring run could not. § 3 is where such a seat says so, against both records
> — an ADR's binding and an NFDR obligation reach the same file.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 QC-11 handed its exception's check to "the change that builds the switch"; that change landed and left `checks/structure.sh` as it was

- **Lands in:** `nfdr.md` QC-11
- **Drafted into the records:** QC-11's *verified by* tail at v38 (`docs/nfdr.md:L340-L350`). The
  exception's bound — the switch and its test, and nowhere else in the bridge — stays review at
  `development-design`. The tail now says the change that built the switch (`nozoki@392177d`) did not
  add the rule to the script, so the bound stays review until a change adds it, by the header's rule.
  It re-pins the script to `checks/structure.sh:L257-L258` and names the bridge files that name
  `git2` at that commit: `src/machine_config.rs`, `tests/search_path.rs` and the manifest. The old
  wording stays in the tail as a dated parenthetical (RN-49).
- **Rationale:** The item was raised in the owner's seat by the `companion-self-answer` run that
  answered cycle 34 (`docs/trail/architecture/self_answer-38.md`, § Raised on this document), with a
  proposal and no draft. This run drafted it, as RN-45 did for a § 2 item raised the same way. Through
  v37, QC-11 named "the design of the change that builds the switch (SDD RN-87)" as where the
  script's rule would come from. A cold reader takes that change to be pending, but it has landed.
  `git log --oneline 8edec4f..392177d -- checks/structure.sh` lists only the probe change. The script
  still lists the clause under *WHAT IS NOT HELD* (`checks/structure.sh:L257-L258`). And
  `grep -rln git2 crates/nozoki-bridge` prints the manifest, `src/machine_config.rs` and
  `tests/search_path.rs`, re-run by this run at `nozoki@2aed844`, so the bound holds today by
  review. This is the same correction cycle 34 made to QC-3 and QC-17. One thing the draft does not
  decide: SDD § 6 `see-git-status`, *Reached when*, command half, has `checks/structure.sh` finding
  the libgit2 import "in `git-reader` alone, with the one exception § 3 states"
  (`docs/SDD.md:L1779-L1781`). So that slice's own bar expects the script to hold the rule, and adding
  it is delivery work, not this record's.
- **If overridden:** With "override: leave QC-11 as it read at v37", the tail goes back to the
  wording that points at a landed change as the place its check will come from, and the next change
  that touches the bridge inherits no owner for the rule. With "override: name the rule as owed by
  `see-git-status`", the tail names that slice's bar as where the rule lands. The gate is still
  review until the script holds it, and nothing else moves. Adding the rule to `checks/structure.sh`
  now is a change to the script and goes through the delivery tier, not this record.
- **Confirm or override:** confirm. The draft is right, and it is right over the second override for a
  reason the item does not state. "Until a change adds it, by the header's rule" stays true however
  many changes land without the rule. Naming a delivery unit as the rule's source is the form that went
  false at v37, when the named change landed without it. Re-measured at `nozoki@566558b`: the
  script's *WHAT IS NOT HELD* still names the clause (`checks/structure.sh:L257-L258`), only the probe
  change touched the script after `8edec4f`, and `grep -rln git2 crates/nozoki-bridge` prints the
  three files the tail names. Reasoning: `docs/trail/architecture/self_answer-39.md` § 2.1.

### 2.2 ADR-0013 names SM-4's list as nine, and SDD v30 makes it ten with `read_git`; the run drafted a superseding record, ADR-0021, rather than a correction in place

- **Lands in:** `adr/0021-sandboxed-single-process-read-pipeline-git-state-pulled-by-read-git.md` and
  `adr/0013-sandboxed-single-process-read-pipeline.md`. On acceptance, the traces of the entries
  ADR-0013 binds also move: QC-1, QC-2, QC-8, QC-9, QC-15, QC-16, QC-24, QC-30, QC-32 and QC-34.
- **Drafted into the records:** ADR-0021, at **Proposed — supersedes ADR-0013 on acceptance**. It
  restates ADR-0013's decision whole and changes two things. SM-4's closed list has ten calls, with
  `read_git` between `open_relative_link` and `set_theme`, all ten exported from `v1.0.0`. Git state
  is pulled by `read_git`, not pushed on `model_changed`, and the registration call stays unadmitted
  until `follow-the-folder` raises it. Its alternatives are RC-4's *Stopped* two — carrying the Git
  item on `open_folder`'s return, and admitting the registration call now — and the owner's route
  over holding the delivery back, beside ADR-0013's own four. ADR-0013 stays Accepted, with nothing in
  it edited, until you answer. The NFDR does not wait: QC-24 already names ten and traces to SDD § 3
  SM-4 at v30, which is its authorization (RN-49). It names ADR-0021 as proposed.
- **Rationale:** ADR-0013 § Decision quotes the nine names and "all nine from `v1.0.0`"
  (`docs/adr/0013-sandboxed-single-process-read-pipeline.md:L44-L47`). SDD § 10 RC-4 *Changed* says
  that "the decision log is owed a record on that ground" and leaves it to this seat (RN-90). A rule
  inside the decision moved, and this log's mechanic for a moved decision is a superseding record,
  which is the choice you confirmed for ADR-0020 over ADR-0016
  (`docs/trail/architecture/cycle-30.md` § 2.1). The change clears the three gates on its own. It is
  hard to reverse: from `v1.0.0`, C-I6's pin reads the export set, so dropping `read_git` inside a
  major fails it. It is surprising without context: SM-4's upward half names a `model_changed`
  callback, so a reader asks why Git state is pulled. And it is a real trade-off, with two options
  given up for stated reasons. Choosing between superseding, correcting in place and no record is
  yours, because a wrong guess either loses the history or rewrites an accepted record.
- **If overridden:** With "override: correct ADR-0013 in place", ADR-0013 takes a dated correction
  of its list sentence, and ADR-0021 is rewritten as a record of the pull call alone, superseding
  nothing; the index changes to match. With "override: no record", ADR-0021 is deleted while it is
  still Proposed, ADR-0013 takes the dated correction, and the pull call's *why* lives only in SDD
  § 10 RC-4 and RN-90. QC-24's list of ten does not move in any case. Only its ADR-0021 trace drops
  or is re-pointed.
- **Confirm or override:** confirm, with one addition. A superseding record is the right form, and the
  log's own practice settles it rather than leaving a three-way guess. This log corrects in place, with
  a dated note, a fact, a pointer or a description that the record's rule does not rest on, even
  inside § Decision (`docs/adr/0012-renderer-run-proved-on-the-shipped-bundle-beside-the-wall.md:L41-L57`,
  where the record says what it fixes is "the gate, its two rules", `:L119-L120`;
  `docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md:L45-L49`, a reason clause). It
  supersedes when the rule a later change is held to moves, which is what happened when ADR-0020
  superseded ADR-0016. The closed list is that kind of rule: what may cross the seam, and what C-I6's
  pin holds from `v1.0.0`. The nine names and "all nine from `v1.0.0`" are that rule in ADR-0013's
  § Decision (`docs/adr/0013-sandboxed-single-process-read-pipeline.md:L44-L47`), and no other record
  counts the list. **The addition:** ADR-0021's *Traces to* cites this item as
  "`docs/architecture_open_issues.md` § 2.1"
  (`docs/adr/0021-sandboxed-single-process-read-pipeline-git-state-pulled-by-read-git.md:L176`), but
  the item is § 2.2. The fold that accepts the record should point that line at this item's trail
  copy, § 2.2. Reasoning: `docs/trail/architecture/self_answer-39.md` § 2.2.

## 3. Raised from downstream — an item from a seat that did not write these records

None.
