# Self-answer report — SDD

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-30
- **Sources re-read:** [Git diff documentation](https://git-scm.com/docs/git-diff),
  DESCRIPTION and OPTIONS: two-commit diff compares endpoint trees; the two-dot spelling
  is equivalent; name/status output identifies changed files; `--no-renames` disables
  rename detection. [Git revision documentation](https://git-scm.com/docs/gitrevisions),
  SPECIFYING REVISIONS: `^1` names a commit's first parent and `^{commit}` resolves a
  commit object.

## Items worked

### 5.1 — The selector's isolation check includes the earlier diff and history work

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Replace the release-to-current comparison with recorded endpoints for each
  selector contribution. The question is correctly framed: S-8 adds diff presentation
  after the first release, S-9 adds history and commit diffs, and S-10 prefers to follow
  both (`docs/SDD.md:L2384-L2394`, `L2432-L2448`, `L2537-L2542`). Comparing the first
  release with the resulting tree therefore also measures those intervening surface
  changes; it cannot attribute them to the selector. This follows from Git's endpoint
  comparison semantics, not from a claim that the two-dot syntax walks each commit
  ([Git diff documentation](https://git-scm.com/docs/git-diff), DESCRIPTION).

  1. **Seat.** This is the CTO's command half of S-10, explicitly addressed to the CTO
     (`docs/SDD_open_issues.md:L25-L44`; `docs/SDD.md:L2505-L2516`). Correcting its
     measurement makes no commitment to an outside party and requires no reserved
     owner preference.
  2. **Framing.** The defect is the chosen before state, not the delivery order.
     The replacement records the destination immediately before each selector landing
     and the result of that landing. Earlier diff and history work is then common to
     both endpoints. The merge case uses the first parent as that before state
     ([Git revision documentation](https://git-scm.com/docs/gitrevisions),
     SPECIFYING REVISIONS). Keep the package-wide scope and inspect the name/status
     output as well as the summary, so the allowed-file rule is evaluated rather than
     built into a filter that conceals forbidden files.
  3. **Settled constraints.** The folder must remain an input whose replacement requires
     no viewing-surface rewrite (`docs/SRS.md:L363-L365`; `docs/fdr.md:L303`).
     S-10's existing prohibition on tree, Git-view and reading-panel changes therefore
     stays intact, as do its runtime and read-only checks
     (`docs/SDD.md:L2491-L2519`). Its preferred position still exercises the fullest
     surface (`docs/SDD.md:L2537-L2542`). The slice may yield several seeds, with its
     bar met only when all shares close, so evidence must cover every selector
     contribution, not just the final landing (`docs/SDD.md:L2666-L2691`).
     Ask the producer to record this correction under its existing rule for a bar that
     cannot be met as written (`docs/SDD.md:L2811-L2826`); no architectural reversal
     or order change is decided here.
  4. **Failure paths.** Require explicit, resolvable endpoint SHAs and successful
     commands; missing history or refused execution supplies no passing evidence.
     A changed candidate or destination invalidates its pre-landing comparison.
     Actual landing pairs include conflict resolutions; concurrent unrelated landings
     belong in each pair's before state, not in a release-to-current interval.
     A mixed selector/unrelated contribution cannot be made to pass by removing paths
     from its output. Deletions and moves involving a forbidden surface still fail.
     Empty output does not establish delivery; retain the rest of S-10's bar.
     These are conditions of this decision, not claims that selector verification
     has run.

  The NFDR consequence is already raised on `docs/architecture_open_issues.md` § 3.1,
  which asks its producer to re-derive QC-19 after this SDD decision. Leave that item
  and its Principal Architect answer slot untouched; no duplicate companion is owed.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/SDD.md** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`

