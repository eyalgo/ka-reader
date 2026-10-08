# SDD conversation — ka-reader, run 1

> The record of one `product-sdd` run: three seats — CTO, CPO, CDO — working one document together,
> and a runner that starts them, gives the turns and counts the rounds.
>
> **This file is the run's state, not a report about it.** It is appended after every round, never
> composed at the end. The runner holds the round, the moves, the recalls and the counters nowhere
> else, so a runner that dies without this file takes the run with it and leaves nothing that says
> why. A runner coming back reads § *Where the run stands* alone to know where it is.
>
> It records who said what. It is **not** where anything gets decided: what the seats settle goes
> into `SDD.md`, and what they cannot settle goes into `SDD_open_issues.md`, whose absence is the
> done signal. An item written here as well as there has two homes and only one of them ends.

---

## Where the run stands

- **Round:** 4 (closed) — all three seats hold `no_followup`, no recall outstanding. **Run ended.**
- **Seats, and the names they answer to:**
  - CTO — `sdd-ka-reader-run1-cto`
  - CPO — `sdd-ka-reader-run1-cpo`
  - CDO — `sdd-ka-reader-run1-cdo`
- **Standing declared move:** CTO `no_followup` · CPO `no_followup` · CDO `no_followup`
- **Recall outstanding:** none
- **Recalls spent:** none
- **Counters:** rounds `4/6` · no-change rounds `1/2` (round 4 changed nothing — the first, on a round that only confirmed closure) · rounds with no reply `0/1` · output tokens `under-counted — no per-turn output-token figure was reported by the harness with any reply or idle notice across this run; recorded per the skill's best-effort rule, cap fires late, never early`
- **Status of `SDD.md`:** Draft — *the runner's stamp; the seats never write it. `SDD_open_issues.md` still stands with § 2.2 open for the owner, so Settled does not apply.*

---

## Round 1

- **Opened:** 2026-09-03, run start
- **Turn order:** CPO, CTO, CDO — the standing order (no reason to vary)

### What each seat did

| Seat | Spoke | Changed | Declared |
|---|---|---|---|
| CPO | yes | § 1 (drafted whole); § 5 step 1 — applied list E-1 – E-11 and "Not on the list, with the reason"; companion `SDD_open_issues.md` created with § 1.1 (CPO) | MOVE: successor CDO — the observability read of E-1 – E-11 |
| CTO | yes | § 2 whole; § 3 parts table, seams table `SM-1`–`SM-7`, entities; § 4 C-R1–C-R7, C-I1–C-I5, C-D1–C-D4 (+ CDO's C-E left as a marked placeholder); § 5 step 3 and step 5 applied to the entries; § 9 TO-1–TO-10; § 11 R-1–R-11; § 12 SRS boundary, downstream boundary (+ CPO's and CDO's clauses left as marked placeholders); SDD Review Notes RN-1–RN-14; five Open Questions. Companion: no change. | MOVE: successor CPO — apply § 5 steps 2 and 4 to E-1 – E-11 and draw the § 6 slice blocks |
| CDO | yes | § 4 C-E1–C-E10 (replaces CTO's placeholder); § 5 step 1 — the CDO's observability clause, appended under CPO's list, all eleven entries pass; § 12 UXD boundary (replaces CTO's placeholder); SDD Review Notes RN-30–RN-33; companion § 2.1 added (CDO) | MOVE: successor CPO — apply § 5 steps 2 and 4 to E-1 – E-11 (observability read passed) and draw the § 6 slice blocks |

### What this round settled

- § 1 — What this design must achieve (CPO).
- § 2 — The shape, and what it was chosen over (CTO).
- § 3 — The parts, and the seams between them (CTO).
- § 4 — all four clauses: C-R/C-I/C-D (CTO) and C-E (CDO).
- § 5 step 1 — the entries (CPO) and the observability check (CDO): all eleven entries E-1 – E-11 pass; step 2 not yet run.
- § 5 step 3 and step 5, applied to the entries (CTO) — re-read onto slices once § 6 is drawn.
- § 9 Trade-offs taken (CTO).
- § 11 Technical risks (CTO).
- § 12 — SRS boundary, downstream boundary (CTO); UXD boundary (CDO). The PRD boundary clause (CPO) is not yet written.
- § 6 and § 7 are not settled — they wait on CPO's steps 2 and 4 drawing the actual slice blocks.

### What was disagreed, and who held what

None this round — no two seats held different positions on the same point.

### Spoke without an input it needed

None. (CTO noted, as a deliberate lane choice rather than a gap, that the prior SDD at commit `70a879a` was not read as an input — RN-1.)

---

## Round 2

- **Opened:** 2026-09-03, re-run whole after I-1 (the CTO's prior round-2 turn crashed on
  `API Error: 529 Overloaded` mid-§7 and never closed)
- **Turn order:** CPO, CTO, CDO — the standing order (no reason to vary)

### What each seat did

| Seat | Spoke | Changed | Declared |
|---|---|---|---|
| CPO | yes | § 6 S-11 *Delivers* (contract split into priced/unconditional, per companion § 2.3); RN-19 (rule added, *changed* marker with authorization). Verified own five § 6 fields (all eleven slices), § 5 steps 2/4, § 12 PRD clause and RN-15–19 stood unchanged from its earlier (crashed-run) turn; confirmed `sdd_template.md` v4.1.0's units-table move does not touch its own fields. Companion: no edit (§ 3.1 and § 1.1 read and found consistent with the cut; § 2.2 left open for the owner, by its own lens). | MOVE: successor CTO — § 7 whole, S-8's `Why here in the order`, the units table (companion § 5.1), RN-34 with its § 12 sentence (companion § 5.2), and C-D3/RN-8's clauses (companion § 2.1) |
| CTO | yes | § 6 S-8 `Why here in the order` (the field its crashed turn missed); § 7 whole (25 rows: 17 `depends_on`, 3 `validates`, 3 `hands_off_to`, 2 `supersedes`, plus a closing paragraph on the three order preferences and their owners); § 3 (units table added under the parts table, companion § 5.1); § 4 C-D3 and RN-8 (the narrowing clause and the reopening condition, companion § 2.1); RN-34 (added, the downstream-citation defect, companion § 5.2) with its paired § 12 sentence; RN-35 (added, two S-9 command-half values renumbered off the dead RN-21 citation); RN-36 (added, the units-table grounds); RN-14 (amended, one sentence on the two-half re-read across I-1). Companion: §§ 2.1, 5.1, 5.2 folded (items left in place — dropping resolved items is the skill's file loop); § 2.2 left open. | MOVE: successor CDO — the observable half of `Reached when` and the UXD clause of `Traces to` across S-1 – S-11 |
| CDO | yes | § 6, all eleven slices — `Reached when` observable half and the UXD clause of `Traces to`; RN-31 (amended — the fit with UX-I12's third case stated, per companion § 2.1's confirmation); companion § 2.1 "If overridden" (one clause corrected — C-R7 does not move, matching the CTO's RN-8). | MOVE: no_followup |

### What this round settled

- § 6 S-11 `Delivers` and RN-19 — the 1.0.0 contract's priced/unconditional split (CPO, folding companion § 2.3).
- § 6 S-8 `Why here in the order` — the one field the crash had left open (CTO).
- § 7 — The order, and why: whole (CTO).
- § 3 — the units table (CTO, folding companion § 5.1).
- § 4 C-D3, RN-8 — the SVG narrowing clause and reopening condition (CTO, folding companion § 2.1).
- § 12 downstream boundary — one sentence naming RN-34 (CTO, folding companion § 5.2).
- RN-14, RN-31, RN-34, RN-35, RN-36 (CTO and CDO, as tabled above).
- § 6, all eleven slices — the observable `Reached when` half and the UXD `Traces to` clause (CDO). `grep -c "<the CDO" docs/SDD.md` and `grep -c "<the CTO" docs/SDD.md` both now read 0 — every marked field in §§ 3, 4, 6, 7 is filled.
- Companion `SDD_open_issues.md` §§ 2.1, 5.1, 5.2 — folded into the SDD (items left on disk; the file's own loop drops a resolved item, not a seat's edit). § 2.2 remains open, for the owner.

### What was disagreed, and who held what

None this round — no two seats held different positions on the same point.

### Spoke without an input it needed

None.

---

## Round 3

- **Opened:** 2026-09-03
- **Turn order:** CPO, CTO — CDO sat out, sticky `no_followup` from round 2

### What each seat did

| Seat | Spoke | Changed | Declared |
|---|---|---|---|
| CPO | yes | Reviewed CTO's and CDO's round-2 work against its own lane — no conflicts found. Its own text had gone stale behind companion answers: § 6 S-3 `Not in this slice` (SVG placeholder now confirmed, not "the owner's to confirm"); § 5 step 4 E-7 bullet and RN-17 (`first-public-release`'s placement now recorded as the owner's decision, per § 3.1's answer bound through § 1.1); § 12 PRD boundary (one sentence); RN-37 (added — an S-1 fence's effect on the sidebar during intermediate builds, not previously recorded, closed the same way as RN-18). | MOVE: successor CTO — reword S-7 `Rests on`, S-7 `Why here in the order` and § 7's closing paragraph so the § 3.1 answer reads as a decided fact, not a raised preference; the choice of whether it becomes a `depends_on` row or a stated placement left to step 3 (CTO's) |
| CTO | yes | Made the step-3 call CPO left open: the owner's decided ordering (`first-public-release` after the v1 cut, RN-17) is a **stated placement**, not a `depends_on` row — building it earlier is possible, so a dependency row would misrepresent it as a build fact, and it is not a free-reordering preference either. Reworded § 6 S-7 `Rests on` and `Why here in the order`, and § 7's closing paragraph, to state this and separate it from the two remaining preferences by kind. Also, from reading § 1.1's answer: RN-5's contingency closed (the unsigned-release call binds through ADR-0007, not the trail) and RN-3 gained one sentence recording that § 1.1 moved nothing in C-R3, as RN-3 already said it would not. | MOVE: no_followup |

### What this round settled

- § 6 S-3 `Not in this slice`, § 5 step 4 (E-7), RN-17, § 12 PRD boundary, RN-37 (CPO) — the SVG and release-placement text brought current with the companion's answers.
- § 6 S-7 `Rests on` and `Why here in the order`, § 7's closing paragraph (CTO) — the owner-decided placement stated as a fact and typed (stated placement, not a dependency row).
- RN-3, RN-5 (CTO) — closed against § 1.1's answer.

### What was disagreed, and who held what

None this round.

### Spoke without an input it needed

None.

---

## Round 4

- **Opened:** 2026-09-03
- **Turn order:** CPO only — CTO and CDO sat out, sticky `no_followup` from earlier rounds

### What each seat did

| Seat | Spoke | Changed | Declared |
|---|---|---|---|
| CPO | yes | nothing — verified CTO's round-3 reword against its own lane and confirmed it reads right; confirmed `grep -c` for any seat's placeholder returns 0 across the document | MOVE: no_followup |

### What this round settled

Nothing new. This round confirmed the document complete in every seat's lane, closing the
conversation.

### What was disagreed, and who held what

None this round, and none across the run — no companion item 4 was ever opened.

### Spoke without an input it needed

None.

---

## Interruptions

### I-1 — 2026-09-03

- **Died at:** round 2, after CPO's turn closed. CTO's turn filled § 6's CTO-owned fields (`Rests
  on`, the SRS clause of `Traces to`) across the eleven slices but missed S-8's `Why here in the
  order`, then hit `API Error: 529 Overloaded` while starting § 7 — no reply arrived, and no move
  was declared. The runner (a different session from this one) waited and then stopped; per
  `ka-reader@c3eb937`'s commit message, it waited until 15:38 before giving up, and did not append a
  round-2 block, leaving this file's head reading "round 1 (closed) — round 2 opening" while
  `SDD.md` already carried round 2's unclosed work — write-as-you-go put that work in the SDD
  regardless of whether the round itself ever closed.
- **Found by the new runner:** at resume, `claude agents --json --all` showed all three seat names
  (`sdd-ka-reader-run1-cpo`, `-cto`, `-cdo`) still registered, idle, under process IDs distinct from
  the ones the crash commit describes (three prior generations of each name exist in the harness's
  own agent history — earlier restart attempts this record has no other trace of). None needed a
  fresh replacement: `sdd-ka-reader-run1-cpo` answered its round-2 turn from the current name with a
  reply that matches the SDD's on-disk state exactly (verifying `ka-reader@c3eb937`, the record's own
  gap, and its own five fields against disk before acting), so it is the same conversation, not a
  memory-less stand-in.
- **Retaken:** round 2 is being re-run whole, per the conduct body's rule that a seat may take a
  turn already taken again. CPO retook its turn (this time cleanly: confirmed its own § 6 fields
  and RN-15–19 stand, folded companion § 2.3's classification into S-11's `Delivers` and RN-19,
  left companion § 2.2 open for the owner per its own lens, and declared `successor CTO`). CTO's
  and CDO's round-2 turns are being given fresh, in the standing order, following this block.

---

## How this run ended

- **Ended because:** all three seats declared `no_followup` with no recall outstanding. Round 2
  was the interrupted round (I-1), re-run whole; rounds 3 and 4 settled two small items a
  companion-self-answer run had resolved while the conversation was down (§ 3.1's binding
  placement, and the reword it required) and then confirmed closure.
- **`SDD.md` left at:** Draft — *the runner's stamp.* Not Settled: `SDD_open_issues.md` still
  stands on disk with one item genuinely open (§ 2.2), which no seat's lens makes theirs to answer.
- **Companion:** `SDD_open_issues.md` stands, with one open item (§ 2.2) for the owner. Every other
  item across §§ 1, 2, 3 and 5 is folded into `SDD.md` with its authorization cited in the note
  that carries it (RN-3, RN-5, RN-8, RN-17, RN-19, RN-31, RN-34, RN-36, RN-37, § 6 S-3, § 3's units
  table, § 12's PRD and downstream-boundary sentences). § 4 (Disagreements) was never opened — no
  two seats held different positions on the same point across the run.
- **What a next run inherits:** nothing unfinished in the SDD conversation itself — the document is
  complete in every seat's lane and the run closed clean. What is still owed is outside this run:
  the owner answers `SDD_open_issues.md` § 2.2 (what the 1.0.0 promise covers) and commits the
  file, after which a re-run of `product-sdd` folds the answer, drops the resolved item, and — with
  nothing left in the companion — stamps `SDD.md` Settled.
