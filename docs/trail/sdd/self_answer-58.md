# Self-answer report — `docs/SDD.md`

The record of one unattended run that met `docs/SDD_open_issues.md` in the CTO's seat on 2026-10-14
and decided its two items. It is for the owner, who reads it to learn what was decided and on what,
and for the `product-sdd` run that folds the answers.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v50, `Status:` Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-14
- **Sources re-read:** GitHub Actions on `kensaiapp/ka-reader`, read with `gh`, because both answers
  rest on what a hosted run's log holds. (1) `gh run view 38577309118 --json
  headSha,headBranch,createdAt,conclusion,jobs`: `main`, `f3570082…`, created 2026-10-14T14:04:45Z,
  `success`; its *Bundle probe suite* and *Renderer gate* steps each `success`. Its log's *Set up
  job* prints `Image: macos-26-arm64`, `Version: 20260907.0351.1`, `26.6.2`, `25G83`. QC-25's
  standing command on that log (`awk -F'\t' '$2 == "Bundle probe suite" && /out-of-grant-read:/'`)
  prints exactly one line, `out-of-grant-read: denied`, stamped 2026-10-14T14:15:35Z. Its
  *Renderer gate* lines: "pid 69518 — the main process was observed at the Open panel, inside the
  shell's launch, on observation 1 (bound: 30 observations, about 1 s each)" and "control pid 69815
  (idle-shell, one window and no panel) was not observed at the Open panel in any of 30
  observations — the expected red". (2) `gh run view 38501500758 --json …`: `main`, `3f7a68d7…`,
  created 2026-10-14T02:31:44Z, `success`; *Bundle probe suite* and *Renderer gate* each `success`.
  Its log prints `Image: macos-26-arm64`, `Version: 20260907.0351.1`; QC-25's command on it prints
  nothing; its renderer lines read "pid 59529 … on observation 1" and "control pid 59797 … not
  observed … in any of 30 observations — the expected red", as the item quotes them. (3) `gh run
  list --limit 20` across all branches: between 38463966607 (`4601cd9`, `failure`, 2026-10-13T20:35Z)
  and 38501500758 the only run is 38496422879 on branch
  `2026-10-14_the-drag-test-passes-on-the-hosted-image` (`1ea3595`, `failure`), so no run reached
  the gate on `macos-26` before 38501500758; after it, 38549778886 (`47e8e6b`, `failure`),
  38551538187 (`24be581`, `success`) and 38577309118 (`f357008`, `success`). (4) In the clone:
  `git merge-base --is-ancestor 970ad65 f357008` holds; `… 970ad65 3f7a68d` does not. Nothing else
  outside this repository was relied on.
- **What was read of the document:** `docs/SDD.md` is 8,370 lines and was not read whole. This run
  read the header (`:L1-L40`), § *Who decides what* (`:L99-L130`), § 4 C-I3 whole from the probe
  passage through the renderer passage and *Violated by* (`:L880-L1000`), RN-108 whole
  (`:L8086-…`), RN-110 whole (`:L8232-L8300`), and every line `grep -n` prints for `35988399477`,
  `36795836747` and `RN-108`. Of the SDD's neighbours: `docs/architecture_open_issues.md` whole;
  `docs/nfdr.md` QC-62 whole (`:L883-L942`), the QC-25 passages its § 3.1 item cites, and every
  line printing `macos-26` or `Renderer gate`; `docs/adr/0012-…` at its hosted-reading lines
  (`:L123`, `:L136`, `:L194`). The journey was read as an input and is cited nowhere in an answer:
  `system/projects/ka-reader/journey/shukuba/` holds no open station.

## Items worked

### 5.1 — C-I3's first `macos-26` bundle-probe reading has been taken, and the clause still says it has not

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Answered from scratch — the item carries no draft, and it is the CTO's: the edit lands in
  § 4 C-I3's probe half, the CTO's column of § *Who decides what*, and it commits nothing to anyone
  outside the document. It is one question — record the reading the clause says is untaken — and
  not a widening: C-I3 already states the rule for this exact event ("A `denied` reading leaves this
  narrowing standing, re-dated with the run id and the image version; an `allowed` reading lifts
  it") and names the run that takes the reading ("the first hosted run on `main` that holds
  `970ad65` and concludes with *Bundle probe suite* `success`"), so the item cites an occurrence and
  the clause pre-decided what it means. **The fact is now false**: run 38577309118 is that run —
  `main`, holds `970ad65`, step `success` — and QC-25's command on its log prints `denied`, read at
  the source this run (header). So the answer is the clause's own branch taken: the narrowing
  stands, re-dated to run 38577309118 and image `macos-26-arm64` 20260907.0351.1, and "has not
  been taken" with its two-run ground becomes a dated account, the way v49's ground did at v50. I
  checked the answer against the SDD's settled record: it moves no *Reached when*, no seam, no
  part, and no bar failed as written, so § 10 gains no entry and no ADR is owed — the same "not
  moved" reasoning RN-110 recorded for its fold; RN-48's `macos-14` reading stands as a dated
  account. **The two stores**: `docs/nfdr.md` QC-25 traces to C-I3 and says the same reading on its
  own side; that is the Principal Architect's, already carried by `docs/architecture_open_issues.md`
  § 3.1 (read whole — it names the same run, the same image and the same `denied`), so this answer
  reaches into neither, and nothing is appended there. **Failure paths named:** *stale* — a later
  image version is a new reading, which C-I3 already handles ("the first reading on each image
  version is the one recorded here"); *absent* — `gh` unreachable would have left the item
  unanswered on the record, not answered; *refused/allowed* — had the line read `allowed` the
  answer would have been the clause's other branch, lifting the narrowing, and nothing in the
  log supports it; *empty* — a green run on `main` holding `970ad65` whose log carries no line is
  impossible by construction from `970ad65` (the suite goes red), which is why one reading on one
  run settles it. I was not close to another verdict. What would have tipped it to *left for the
  owner* is if recording the reading had to decide something about the floor or CI's image — it
  does not; both are C-R5's and were set at v48 by the owner.

### 5.2 — C-I3's first `macos-26` renderer-gate reading exists, and RN-110 says it is owed an item of its own

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Answered from scratch — no draft, and the CTO's: the edit lands in § 4 C-I3's renderer
  half, the CTO's column, and the item was RN-110's own request for an item ("owed to an item of
  its own"), which this one is. One question, and not a widening: the clause already says "the
  first hosted reading on `macos-26` is the first hosted run that reaches this gate on that image",
  so the item asks the SDD to name a run the clause defined, and it cites one. **Which run is
  first** is the part worth checking rather than copying: `gh run list` across every branch shows
  no run reached the gate on `macos-26` between 38463966607 (ended at *Test gate*, RN-109) and
  38501500758 — the one branch run between them failed — so 38501500758 is the first, as the item
  says. **What it read** I took from the log, not from the item: observation 1 for the product,
  the control unmatched on all 30 — the same shape as both `macos-14` readings C-I3 records (runs
  35988399477 and 36795836747), on the four-frame list the script has carried since `b75348f`.
  Run 38577309118 reads the same and is recorded as corroboration, not a second reading, because
  the clause records the first per image. **Against the settled record:** the gate's re-cut rule
  (a differing image turns it red) is untouched; the frame list stays cited from the script's
  header, as C-I3 and QC-62 both insist; the reading is inside the 26.0 floor, which closes the
  dated-readings-below-the-floor state RN-108 left the clause in. ADR-0012 cites the `macos-14`
  run as the reading at its date; an ADR is a record and is superseded, never rewritten, and a
  reading on a new image changes no decision, so none is owed. **QC-62 was weighed and not
  raised:** it cites its two hosted readings as dated facts with no "not yet" clause and traces to
  C-I3 by version, so nothing in it is false today; whether the Principal Architect re-dates it is
  that seat's, and its companion already carries § 3.1, whose fold re-reads C-I3. I record the
  doubt here rather than spend a cycle on it. **Failure paths named:** *stale* — a new image
  version whose frames differ turns the gate red and re-cuts the mechanism, the clause's own rule;
  *absent* — `gh` unreachable leaves the clause as written; *concurrent* — two runs on the same
  image reading the same is the ordinary case and the first is recorded; *refused* — a run where
  the control matched would have been a red build, not a reading. Not close to another verdict.
  What would have tipped it to *raised upstream* is a false sentence in QC-62 or ADR-0012; I found
  none.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
