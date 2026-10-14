# Self-answer report — `docs/SDD.md`

The record of one unattended run that met `docs/SDD_open_issues.md` in the CTO's seat on 2026-10-14
and decided its one item. It is for the owner, who reads it to learn what was decided and on what,
and for the `product-sdd` run that folds the answer.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v49, `Status:` Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-14
- **Sources re-read:** GitHub Actions on `kensaiapp/ka-reader`, read with `gh` because the answer
  rests on whether a hosted run holds the change. (1) `gh run list --branch main --limit 4`: the
  newest run on `main` is 38551538187 on `ka-reader@24be581`, created 2026-10-14T10:43:17Z,
  `success`; before it 38549778886 (`47e8e6b`, `failure`), 38501500758 (`3f7a68d`, `success`) and
  38463966607 (`4601cd9`, `failure`). (2) `gh run view 38551538187 --json jobs`: every step
  `success`, *Bundle probe* and *Bundle probe suite* among them. (3) `docs/nfdr.md` QC-25's standing
  command on that run's log (`awk -F'\t' '$2 == "Bundle probe suite" && /out-of-grant-read:/'`)
  prints nothing. (4) `git ls-remote origin refs/heads/main` → `24be581`. Nothing else outside this
  repository was relied on.
- **What was read of the document:** `docs/SDD.md` is 8,281 lines and was not read whole. This run
  read the header (`:L1-L30`), § *Who decides what* (`:L99-L130`), § 4 C-I3's probe passage
  (`:L878-L925`), its renderer-gate passage (`:L960-L975`), its *Violated by* (`:L982-L988`), RN-109
  whole (`:L8150-L8215`), and every line `grep -n` prints for `bundle.sh:L38`, `out-of-grant-read:`
  and `L1573`. Of the SDD's neighbours: `docs/architecture_open_issues.md` whole, the companion the
  same review opened on `docs/nfdr.md`. In the tree: `checks/bundle.sh` at each of the four commits
  the item names, and `checks/tests/test_bundle.sh:L629-L642` and `:L1706-L1711` at `ka-reader@970ad65`.
  The journey was read as an input and is cited nowhere in the answer: the station
  `2026-10-14_the-hosted-suite-prints-the-control-line` and the seed's refine report, for what the
  change unit left and what it fenced off.

## Items worked

### 5.1 — C-I3 and RN-109 cite `checks/bundle.sh:L382` for the control's report, and the line is `:L383`

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Answered from scratch — the item carries no draft, and it is the CTO's: the edit lands in
  § 4 C-I3 and RN-109, both in the CTO's column of § *Who decides what*, and it commits nothing to
  anyone outside the document. It asks two things, and both have the same seat, so it is one item
  answered on both and not a split. **The locator** is a fact that is false: `printf '%s\n'
  "$probe_output"` is line 383 of `checks/bundle.sh` at `4601cd9`, `fcb2e2f`, `24be581` and
  `970ad65` — measured by `git show <sha>:checks/bundle.sh | grep -n probe_output` at each — and the
  SDD's own RN-56 passage (`:L4398`) already cites `:L383`, so the correction makes the document
  agree with itself. RN-109 is a dated record, and it says the locator was "read at source by this
  fold"; it was mis-read on the day, so the fold corrects it as a false measurement and the new
  revision note says so, rather than leaving a locator the SDD's reader follows to the wrong line.
  **The clause** is a dated fact that moved: C-I3 states the line as owed at `4601cd9`, and at
  `970ad65` the suite validates the control's report — exactly one `out-of-grant-read:` line, in
  the exact form, else the case fails (`checks/tests/test_bundle.sh:L629-L661`) — and forwards that
  one line after the control's `ok` (`:L1710`). That is an occurrence, cited, so this is not a
  widening answered "not until it occurs"; it is the sentence C-I3 already carries, dated to the
  commit that discharges it. The addition that matters to this seat: the *Violated by* case C-I3
  added at v49 "once the suite prints it" is live from `970ad65`, and it is enforced structurally —
  a missing line turns the suite red — which is the only way a "the log carries the reading" claim
  can be held, and what keeps § 4's two-stores rule: `docs/architecture_open_issues.md` § 3.1 asks
  QC-25 to state the same validated reading, and C-I3 is the sentence QC-25 traces to. **The
  reading** stays not taken, and the ground C-I3 gives for that is now wrong in the other direction
  — it says no hosted run reached the probe on `macos-26`, and run 38551538187 did, with
  *Bundle probe suite* `success` and QC-25's command printing nothing because `24be581` holds no
  line to print. So the fold restates the ground: the image reaches the suite, and no run on `main`
  holds `970ad65` (`origin/main` is `24be581`). The first `macos-26` reading is then the first
  hosted run on `main` holding `970ad65` that concludes with that step `success`, on whatever later
  commit; it is recorded when read, by a later item, and the fold does not wait on it, because the
  push is the owner's act and a Settled document does not hold its status open for an event.
  Failure paths named: a run on `main` with `970ad65` whose suite log carries no line is a red
  build, the violation self-reported, and QC-25's command printing nothing on a green run is then
  impossible rather than a not-yet; `gh` unreachable leaves the reading untaken and C-I3 unchanged;
  the locator will drift again when `checks/bundle.sh` changes above line 383, which is why each
  citation carries its commit. I was not close to another verdict. What would have tipped it to
  *left for the owner* is if the answer had to say whether to push `main` — it does not; the SDD
  states what is true at a commit and names what is not yet read.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
