# SDD conversation — nozoki, run 4

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

- **Round:** 3 (closed) — the run has ended
- **Seats, and the names they answer to:**
  - CTO — `sdd-nozoki-run4-cto`
  - CPO — `sdd-nozoki-run4-cpo`
  - CDO — `sdd-nozoki-run4-cdo`
- **Standing declared move:** CPO `no_followup` · CTO `no_followup` · CDO `no_followup`
- **Recall outstanding:** none
- **Recalls spent:** none
- **Counters:** rounds `3/6` · no-change rounds `1/2` (round 3 changed nothing) · rounds with no
  reply `0/1` · output tokens `unknown/600000 (best-effort — no per-turn output-token figure
  reported by the harness with any reply or idle notice this run; under-counted, so the cap can only
  fire late, never early)`
- **Status of `SDD.md`:** all three seats now hold `no_followup` with no recall outstanding — the
  run has ended on the seats' own close, not a cap. `**Status:**` stamped `Settled` at close (below).

---

## Round 1

- **Opened:** 2026-09-02, ~23:31, when the runner gave the CPO the first turn (intake: the
  reopened companion, retired whole to `docs/trail/sdd/cycle-3.md` before any seat touched it).
- **Turn order:** CPO, CTO, CDO — the standing order.

### What each seat did

| Seat | Spoke | Changed | Declared |
|---|---|---|---|
| CPO | yes — replied by `SendMessage` | `SDD.md` Version line (v3 → v4 head, CPO clause); § 5 step 1 E2, E6 ("outside the repository" → "outside the folder," against SRS FR-32/FR-21); RN-28 (§ 5.3 position), RN-29 (E2/E6 authorization) added; companion § 5.3 `Confirm-or-override` slot filled with the CPO's position | `successor CTO` — fold cycle-3 §§ 5.1–5.2 |
| CTO | yes — replied by `SendMessage` | `SDD.md` preamble loader citation; § 3 parts table (all nine `Lives in` cells, `fs-reader` *Owns* wording, `surfaces`/`read-only-harness` *Owns* leading clauses); § 3 seams re-cut to the `SM-1`–`SM-7` table; § 8 opening citation; Version line (CTO clause); RN-30, RN-31 added; companion §§ 5.1–5.2 dropped as folded, CTO position appended to § 5.3 | `successor CDO` — append its § 5.3 position and Version-line clause |
| CDO | yes — replied by `SendMessage` | `SDD.md` Version line (CDO clause); § 4 C-E3, C-E9; S-1, S-2, S-3, S-5, S-6, S-7, S-8 *Reached when* observable halves; S-1, S-2, S-3, S-6, S-7, S-8 *Traces to* UXD clauses; § 12 *The UXD boundary*; RN-18, RN-20, RN-26 closing clauses; RN-32, RN-33 added; companion § 5.3 dropped on three-way concurrence — no item remains | `successor CTO` — fold the UXD v9 move for UX-I12's third case in § 3/S-2 |

### What this round settled

- `SDD.md` Version line bumped from v3 to a v4 head carrying all three seats' clauses, run 3's v3
  text preserved parenthetically.
- § 5 step 1 E2, E6 — "repository" → "folder" (CPO, RN-29).
- Companion §§ 5.1–5.2 folded into `SDD.md`: § 3 re-cut to the 4.0.1 `Part | Lives in | Owns | Must
  not own` and `Seam | What crosses | Owner of the contract` tables (`SM-1`–`SM-7`), backticks
  stripped from `Lives in`, preamble and § 8 dead `principal_pm_global.md` section citations
  removed (CTO, RN-30).
- Companion § 5.3 (the `Status:` line question) settled by three-way concurrence — effect right
  (the legend already ties Settled to the companion's absence), actor wrong (the flip is the tool's
  that opens the companion and the runner's that clears it, never a seat's) — surfaced to the owner
  rather than set, and dropped from the live companion (CPO RN-28, CTO RN-31, CDO RN-33). The live
  companion now holds no item.
- CDO's UXD v7 → v10 fold: § 4 C-E3/C-E9, the observable halves and UXD *Traces to* of `read-a-folder`
  (S-1), `read-markdown` (S-2), `see-what-changed` (S-3), `watch-a-moving-tree`/S-5's repository
  source note, `switch-the-folder` (S-6), `read-the-diff` (S-7), `read-the-history` (S-8), and § 12
  *The UXD boundary*'s closing clauses (RN-32).

### What was disagreed, and who held what

None. All three seats concurred on companion § 5.3's position; no two seats held incompatible
positions this round.

### Spoke without an input it needed

None reported by any seat.

---

## Round 2

- **Opened:** 2026-09-02, ~23:52, when the runner gave the CPO the second turn.
- **Turn order:** CPO, CTO, CDO — the standing order (all three still held a non-`no_followup`
  standing move going into the round).

### What each seat did

| Seat | Spoke | Changed | Declared |
|---|---|---|---|
| CPO | yes — replied by `SendMessage` | nothing — verified every hunk from the CDO's round-1 fold sits in an observable half or a UXD *Traces to* clause, none touching a *Slug*/*Delivers*/*Moves toward*/*Not in this slice*/PRD clause; confirmed UXD v10 still carries UX-I15/UX-I17/§ 10 and now reads "fetches nothing from outside the folder," agreeing with E2's round-1 wording | `no_followup` |
| CTO | yes — replied by `SendMessage` | `SDD.md` § 3 `fs-reader`/`markdown-renderer`/`surfaces` *Owns* (the image-read/placeholder/second-wall-swap mechanism for UX-I12's third case); new § 3 "The image set" paragraph (PNG/JPEG/GIF/WebP; SVG excluded in v1, reason and cost named); § 4 C-R3 gains the dismissed-panel clause and a citation repair; S-2 command half gains five named fixture files and *Rests on*; RN-9, RN-11 repaired; RN-34 added; Version line (CTO round-2 clause) | `successor CDO` — match S-2's observable half to the five fixture names and the agreed wording |
| CDO | yes — replied by `SendMessage` | `SDD.md` S-2 *Reached when* observable half (the same five fixture files, "not there"/"not an image"/"could not be loaded" readings); S-2 *Traces to* UX-I12 clause extended; RN-32 (2) and its closing paragraph | `no_followup` |

### What this round settled

- CPO's round-1 fold confirmed final in its own lanes — no further change, closed `no_followup`.
- CTO folded UX-I12's third case (a missing, unreadable, or non-image in-folder reference; a file
  that vanishes after render) into § 3's parts and § 4 C-R3, and named § 3's image-format set with
  SVG excluded in v1 (RN-34).
- CDO matched its S-2 observable half to CTO's five fixture files and readings, closing the loop
  CDO's own round-1 successor opened (RN-32 (2)) — closed `no_followup`.
- **A correction to round 1's record, not a rewrite of it:** the CDO's round-2 turn flagged that
  round 1's "What this round settled" line above, "`watch-a-moving-tree`/S-5's repository source
  note," wrongly implies S-5 is `watch-a-moving-tree`. **S-5 is `pick-it-up-release`; the CDO did
  not touch S-4 `watch-a-moving-tree` in round 1.** That line is left as originally written per the
  record template's own rule (a round is answered by a later round, not rewritten); this entry is
  the answer.

### What was disagreed, and who held what

None.

### Spoke without an input it needed

None reported. (The CTO flagged, out of this turn's scope and asking nothing of anyone: S-2's
command half reads `cargo test -p nozoki-core --test markdown` without `--locked`, while
`docs/nfdr.md:185` and the project card's test command both carry it — a possible defect, not a
missing input, left for the owner or a later round.)

---

## Round 3

- **Opened:** 2026-09-03, ~00:03, when the runner gave the CTO the third turn — the only seat
  whose standing move was not yet `no_followup`.
- **Turn order:** CTO alone. CPO and CDO both held `no_followup` from round 2 and were skipped.

### What each seat did

| Seat | Spoke | Changed | Declared |
|---|---|---|---|
| CTO | yes — replied by `SendMessage` | nothing — verified the CDO's round-2 fold names all five fixture files with the agreed readings in both halves of S-2's bar; re-ran the lifted launcher parser over § 3, 9 rows / 0 refused; examined its own round-2 flag on `--locked` and closed it as no defect (all seven § 6 `cargo test` commands lack it by design, the stricter NFDR/card command already satisfies the SDD's floor, decided at `kensaiapp-opensource@3a960a7`) | `no_followup` |
| CPO | skipped — standing `no_followup` from round 2 | — | `no_followup` (unchanged) |
| CDO | skipped — standing `no_followup` from round 2 | — | `no_followup` (unchanged) |

### What this round settled

- Nothing new in `SDD.md`. Round 3 was a closing verification pass: the CTO confirmed its round-2
  successor request was met exactly, and closed its own `--locked` observation as not a defect
  (the SDD's `cargo test --workspace` floor is satisfied by the stricter `--locked` command the NFDR
  and the project card already carry — no duplication needed in seven already-settled slice
  commands).

### What was disagreed, and who held what

None.

### Spoke without an input it needed

None reported.

---

## How this run ended

- **Ended because:** all three seats declared `no_followup` with no recall outstanding — the seats'
  own close, not a cap. No recall was made this run.
- **`SDD.md` left at:** Settled — the runner's computed stamp: all three declared done, no recall
  outstanding, and `docs/SDD_open_issues.md` is removed this run (nothing unresolved and one existed
  at intake — its removal is the done signal; it held the reopened companion's §§ 5.1–5.3, all three
  folded or dropped by three-way concurrence across round 1). The on-disk `**Status:**` line already
  read `Settled` (unchanged from run 3 — no seat holds the pen on it) and is confirmed correct at
  close rather than rewritten.
- **Companion:** deleted. `docs/SDD_open_issues.md` carried three items raised by a
  `companion-self-answer` run (§§ 5.1–5.3, `docs/trail/sdd/cycle-3.md`), not by this run's own
  seats: § 5.1 (the § 3 re-cut to `sdd_template.md` 4.0.1's two fixed tables) and § 5.2 (two dead
  loader-section citations) were answered before this run started and folded by the CTO in round 1;
  § 5.3 (whether `Status:` should flip to `Draft` when a companion reopens a Settled document) was
  left for this run to decide and settled by three-way concurrence in round 1 — effect right (the
  legend already ties Settled to the companion's absence), actor wrong (the flip belongs to the tool
  that opens the companion and the runner that clears it, never a seat) — surfaced to the owner
  rather than set (RN-28, RN-31, RN-33). Its full content as found is preserved whole at
  `docs/trail/sdd/cycle-3.md`.
- **What a next run inherits:** nothing outstanding in `SDD.md` or its companion. Two items were
  raised and left for the owner rather than the SDD, both recorded in this run's round blocks and
  in `SDD.md`'s own review notes: (1) cycle-3 § 5.3's rule-going-forward — whether a companion
  reopened on a Settled document by a downstream reader should flip `Status:` to `Draft` while it
  stands — is a call about `<CORE>`'s own tooling (the `companion-self-answer` skill and the
  template's legend), not this document, and belongs to the owner. (2) The CTO's `--locked`
  observation on S-2's command half was examined and closed as not a defect this run (round 3); no
  further action is implied. `SDD.md` is Settled — ratifying it to Locked is the owner's, not a
  further `product-sdd` run's.
