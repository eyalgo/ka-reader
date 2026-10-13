# Self-answer report — `docs/SDD.md`

The record of one unattended run that met `docs/SDD_open_issues.md` in the CTO's seat on 2026-10-13
and decided its one item. It is for the owner, who reads it to learn what was decided and on what,
and for the `product-sdd` run that folds the answer.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v48, `Status:` Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-13
- **Sources re-read:** Two GitHub Actions runs on `kensaiapp/ka-reader`, read with `gh run view`
  because the answer rests on what each ran on and how far it got. (1) Run 35797893381, the one RN-48
  cites: branch `ci-sandbox-diagnostic`, `ka-reader@247b5ed`, created 2026-09-22T23:32Z, its *Set up
  job* log printing `Image: macos-14-arm64` and `Version: 20260831.0302.1` — the image the item says
  the narrowing was measured on, confirmed at the source. (2) Run 38463966607, on `main` at
  `ka-reader@4601cd9`, created 2026-10-13T20:35Z: `Image: macos-26-arm64`, `Version: 20260907.0351.1`;
  steps *Set up job* through *Build the workspace* passed, *Test gate* failed, and every later step —
  *Bundle probe* and *Bundle probe suite* among them — was skipped. QC-25's standing-reading command
  (`gh run view 38463966607 --repo kensaiapp/ka-reader --log | awk -F'\t' '$2 == "Bundle probe suite"
  && /out-of-grant-read:/'`) prints nothing for that run. Nothing else outside this repository was
  relied on.
- **What was read of the document:** `docs/SDD.md` is 8,201 lines and was not read whole. This run
  read the header (`:L1-L40`), § *Who decides what* whole (`:L99-L158`), the heading map, § 4 C-I3's
  probe and renderer-gate passages whole (`:L870-L960`), RN-48 (`:L4346-L4376`), RN-108
  (`:L8048-L8125`), and every line `grep -n -E 'macos-14|macos-26|35797893381'` prints. Of the SDD's
  downstream, `docs/nfdr.md` v48's header, QC-25 whole (`:L765-L830`) and its § 10 row (`:L1855`);
  `docs/trail/architecture/self_answer-46.md` whole, the run that opened this companion. In the tree
  at `ka-reader@4601cd9`: `.github/workflows/ci.yml` whole, `checks/bundle.sh:L380-L383`,
  `checks/tests/test_bundle.sh:L1570-L1578`, and `checks/sandbox_probe.rs:L146`. `git status --short`
  printed nothing before this run wrote; `fcb2e2f` is an ancestor of `origin/main`.

## Items worked

### 2.1 — C-I3's hosted-runner narrowing of the probe names no image, though v48 dated the renderer gate's hosted readings beside it and moved CI off the image the narrowing was measured on

- **Bucket:** 2. Choices to confirm — a best-effort answer was drafted; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The lean holds — date the probe sentence to `macos-14` and run 35797893381, say the
  `macos-26` reading is not taken, in v48's dated-parenthesis form — and three things are added: one
  because a ground the rationale gave has moved, one because the item left a call to this seat, and
  one because the same clause carries a second sentence the same facts overtook.

  *Check 1, the seat.* The change lands in `docs/SDD.md` § 4 C-I3, the probe half: instrumentation
  and failure visibility, the CTO's column (§ *Who decides what*, the § 4 row). The item carries
  `Seat: cto`. The answer commits nothing to a person or an outside party — it dates a measurement
  and names where the next one is read — and no ground is unseeable: the runs, the scripts and the
  NFDR entry were all in reach. Mine, in the owner's seat; the answer goes into the slot.

  *Check 2, the draft.* The conclusion is right and one reason under it no longer carries. The
  rationale said no `macos-26` reading exists because the moving change is on no remote branch and
  no run on that image exists. Both were true when the item was raised at `b1679d5` and neither is
  now: `fcb2e2f` reached `origin/main`, and run 38463966607 ran on `macos-26-arm64` 20260907.0351.1
  — and failed at *Test gate*, before *Bundle probe suite*, so the probe never ran there. The
  conclusion "not taken" stands on a different fact, and addition **(1)** states that fact rather
  than letting the fold inherit a reason that is false. The rest of the lean I re-read against the
  document: v48 dated the renderer gate's two hosted readings (`:L945-L949`) and left the probe
  sentence general (`:L889-L894`); RN-48 names run 35797893381 and `macos-14` (`:L4361`); the image
  version is the run's own log, and macOS 14.8.9 is what the SDD records for that same image version
  at `:L946`. The draft's form — the dated parenthesis — is the right one, because the two halves of
  one clause should carry their readings the same way.

  The item left one call open: whether C-I3 names where the reading is taken, now that the NFDR has
  made it standing. I take it, as addition **(2)**, on § 4's own rule. QC-25 at v48 requires that
  "every hosted CI build shows, in its own log, whether the unentitled control's out-of-grant read
  was reported denied" and holds the command that reads it (`docs/nfdr.md:L811`). QC-25 traces to
  C-I3, and § 4's rule is that the § 4 statement wins and the NFDR entry is re-derived from it. So
  the requirement that the suite's log carry the line has to exist in C-I3, or the NFDR is wider
  than its source and the next Principal Architect fold reconciles it downward. C-I3 already fixes
  what the suite does — the control, `sandboxed: no` on every ask, red when it cannot tell the two
  apart — so one more sentence about what the suite prints is in its lane. It is stated as owed at
  `ka-reader@4601cd9`, where the suite prints `ok` and the case name on success
  (`checks/tests/test_bundle.sh:L1573-L1577`) and swallows the report `checks/bundle.sh:L382`
  prints, the way S-4's command half states a step's result as unread at a pinned revision. Naming
  which change carries it would be scheduling, the PM's; the answer names none. Where I was close
  to the other call: leaving C-I3 general and letting QC-25 carry the surface alone costs nothing
  today, but it leaves a § 4-traced entry requiring something § 4 does not say, which is the shape
  § 4's rule exists to prevent.

  Addition **(3)** is the second question inside the same clause, with the same seat: the
  renderer-gate parenthesis says "the first hosted reading on `macos-26` is the one the change that
  moves CI takes". That change is `fcb2e2f`; its first hosted run reached neither gate. The clause
  is event-bound in the way the NFDR's § 9 sentence was, and that sentence was retired at
  `docs/trail/architecture/self_answer-46.md` § 3.2 for the same failure. One slot, both halves: a
  hosted reading is the first hosted run that reaches the gate on that image. Not a split — same
  seat, same clause, one fold.

  *Check 3, against what is settled.* The owner's directive stands untouched — floor 26.0, CI on
  `macos-26` (RN-108). The NFDR's QC-25 already dates the narrowing to `macos-14` and run
  35797893381, makes the reading standing, and says an `allowed` reading means "C-I3 is restated by
  the CTO, and this entry follows"; the answer says the same from the SDD's side, so the two stores
  agree and the NFDR entry's trace becomes clean. Nothing in C-I3 forbids the suite printing the
  control's report: its red/green rule is about what the control answers, not about what the log
  shows. The renderer gate's rule — a differing image turns it red on the next build — is unchanged.
  No settled requirement moves; this is a dating and a named surface, not a widening of C-R2's wall.
  Both external facts the answer rests on were re-read at their source (§ Header), not from the
  record.

  *Check 4, the failure paths.*
  - **Empty:** the awk prints nothing until the suite prints the line. The answer makes that empty
    read the measurable *not yet* in C-I3's own words, so a green `macos-26` build with no line is
    not read as a `denied`.
  - **Absent:** a run's log expires under retention. The dated parenthesis carries run id, image
    label, image version and the reading, as the renderer gate's does, so the record outlives the
    log; a reader who cannot reach the run still has the measurement.
  - **Stale:** the label's image version moves under the same name. A per-build reading re-takes
    on every build, and the first reading per image version is what gets recorded, so a moved image
    produces a new dated reading rather than a contradiction.
  - **Refused:** `allowed` on `macos-26` lifts the narrowing — C-I3's general clause then holds on
    the runner too, and the sentence is restated; `denied` leaves it standing, re-dated. In the
    interim nothing is overclaimed: the narrowing only removes the read denial from the evidence,
    and the control passes on `sandboxed: no` alone.
  - **Concurrent:** one control per build; does not apply.

  *What this answer does not cover.* Run 38463966607 failed at *Test gate*, in a Swift layout test,
  on the first `macos-26` build. That is a hosted-image regression and, by this seat's own
  instinct, a signal until explained — but it is the tree's, not C-I3's, and it is not this item's
  to carry; the answer records only that the run reached neither gate.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
