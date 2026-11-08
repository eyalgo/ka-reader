# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `adr/` and `nfdr.md` (NFDR v85, Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-08
- **Sources re-read:** None. The answer rests on the product's own script, suite and records, read at
  `ka-reader@8823057`, and on no source outside this repository.

The companion holds one item, under § 3, opened by the Principal PM. Its *If a document has to be
written* line proposes what the fold would write, and this run read that line as a draft. Measured at
`ka-reader@60adca4`, whose only change from `8823057` is the companion itself
(`git diff --stat 8823057 HEAD` lists only `docs/architecture_open_issues.md`). `checks/offline-page.sh`
and `checks/tests/test_offline_page.sh` are unchanged since `3fa227e`, the commit QC-70 is pinned at
(`git diff --stat 3fa227e 8823057` on both prints nothing).

## Items worked

### 3.1 — The offline-page check can end 0 and print `same` when its comparison failed, and QC-70 records no such gap

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** QC-70 gains a known-gap sentence, dated at its commit, and its `verified by:` names the
  check the fix owes. The draft is right, but it leaves out three things.

  1. **Seat (check 1).** The edit lands in QC-70 of the NFDR, the document being answered. It
     commits no person, outside party or risk. The NFDR already records known gaps this way, in
     QC-67's "Three defects stand at that commit, each a known gap until a change lands". So the
     call is this seat's, and the answer goes in the slot.
  2. **Widening, with an occurrence.** The item asks QC-70 to state a gap it does not state now,
     which makes it a widening. It cites a site in the product as it stands:
     `checks/offline-page.sh:L216-L220` at `8823057`. Read there, the comparison is
     `differing="$(diff … | sed … | cut -f 1 | LC_ALL=C sort -u || true)"`, under
     `set -euo pipefail` at `:L39`. An empty `differing` then sets `verdict="same"` and
     `exit_status=0` (`:L222-L224`). The occurrence is real, so the widening is taken.
  3. **Check 2: the gap is wider than `diff`.** `|| true` applies to the whole pipeline, and
     `pipefail` gives the pipeline the status of its last failing stage. So any non-zero status in
     the pipeline is turned into 0, not only `diff`'s 2. A failing `sed`, `cut` or `sort` is
     swallowed the same way, and `same` follows whenever the output came back empty. The comment at
     `:L216-L218` explains the `|| true` only by `diff`'s exit 1. That is why the draft names `diff`
     alone. The answer names the pipeline, with `diff`'s 2 as the measured case.
  4. **Check 3: what it breaks, and what the record may cite.** The defect breaks QC-70's "only a
     pass is 0" and ADR-0012's "a gate that cannot go red has not run". ADR-0012 is the trace QC-70
     already gives for that clause. QC-70's dated reading (`docs/nfdr.md:L2518-L2527`) lists
     statuses and no gap. Its literal scan cannot see this case, because the 0 is computed
     (`exit "$exit_status"`), which QC-70 itself says no literal scan reads. The item's evidence
     includes the unit's code-integrity report, which sits under the project's `journey/`. A
     definition document never names the journey
     (`<CORE>/doctrine/setup/setting_up_a_project.md` § *The definition set never names the
     journey*). So the gap sentence cites the script at its commit, as QC-67 cites its own, and
     names neither the unit nor the report. The item's *Tracked by* line, "the cut from the product's
     documents", stays out of the record for the same reason. The NFDR names no change.
  5. **Check 4: the failure paths.**
     - *Absent:* the case itself is a read failure on the script's own scratch captures. Both
       captures are tested non-empty first (`:L209`, `:L212`), so the window is narrow, but it is real.
     - *Refused:* a failed comparison is a precondition that failed, so the fix ends 1 (QC-70's
       refusal) and never 0. How the script tells `diff`'s 1 from its 2 is the delivery tier's, the
       way QC-67 leaves to it how the gate holds its steps.
     - *Stale:* the sentence is dated at `8823057`. Once the fix lands, it becomes a dated reading,
       as QC-67's do.
     - *Concurrent:* none applies, because the captures sit in the script's own `mktemp -d` folder.
     - *Empty:* this is the very output that reads as `same`, and the answer covers it.
  6. **Enforcement.** `checks/tests/test_offline_page.sh` at `8823057` has no case for a failed
     comparison. Its fourteen cases, listed at `:L36-L49`, cover the same and differing pages, the
     denial, the missing and failed renders, usage, the argument, the folder left as found and the
     environment, and none of them fails the comparison itself. So `verified by:` gains the case the fix owes: make the
     comparison fail, then require a non-zero end with no `same` on stdout. The script finds its
     programs through `PATH` (header, `:L32`), so a suite can supply a stand-in. That is a seam the
     platform provides, which QC-67 allows. Until the fix lands, `development-design` reading QC-70
     is its gate.

  **What could have tipped it:** if the occurrence had been only the report's prose, with no line in
  the product, the verdict would have been "not until it occurs". The script lines are what carry
  the widening.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
