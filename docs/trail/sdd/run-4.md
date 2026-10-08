# SDD conversation — ka-reader, run 4

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

- **Round:** 2 (closed) — run ended
- **Seats, and the names they answer to:**
  - CTO — `sdd-ka-reader-run4-cto`
  - CPO — `sdd-ka-reader-run4-cpo`
  - CDO — `sdd-ka-reader-run4-cdo`
- **Standing declared move:** CPO `no_followup` · CTO `no_followup` · CDO `no_followup`
- **Recall outstanding:** none
- **Recalls spent:** none
- **Counters:** rounds `2/6` · no-change rounds `0/2` (both rounds changed `SDD.md`) · rounds with
  no reply `0/1` · output tokens under-counted — no per-turn output-token figure was reported by the
  harness with any reply or idle notice this run; the cap never visibly fired and stays open per the
  skill's own rule that this cap fires late rather than early.
- **Status of `SDD.md`:** Draft — *the runner's stamp.* All three declared done and no recall is
  outstanding, but `docs/SDD_open_issues.md` still stands on disk (§ 5.1, unconsumed — see intake
  note above), so the Settled condition ("no `SDD_open_issues.md` stands on disk") is not met.

**Run intake note:** `docs/SDD_open_issues.md` stands on disk (opened 2026-09-04 by a
`companion-self-answer` run answering `docs/fdr_open_issues.md` § 2.7, not by a `product-sdd` run —
see its own header note). Its one item, § 5.1, carries **no filled answer slot** (`**Answer:** <the
owner fills this in>`) — per this skill's own rule ("a companion with no filled answer slot is not
consumed"), it is **not** consumed at this run's intake and is not copied to `trail/sdd/cycle-3.md`.
It stays on disk, untouched by the runner, for the owner to answer later. This run therefore opens
with no companion to fold — the standing SDD inputs (SRS, UXD, PRD, agari, doctrine) are what it
works from.

---

## Round 1

- **Opened:** 2026-09-04, immediately after the runner's intake (no companion consumed).
- **Turn order:** CPO, CTO, CDO — the standing order.

### What each seat did

| Seat | Spoke | Changed | Declared |
|---|---|---|---|
| CPO | yes | nothing — verified its lane against the current PRD (v15, `7c89e19`) and Agari (`ee561fb`), both unchanged since `SDD.md` settled at `827aa1c`; nothing to strike, resize, re-fence or re-trace | `no_followup` |
| CTO | yes | `SDD.md` § 3 `fs-reader` *Owns* cell (text rule widened: UTF-8 with/without BOM, UTF-16 with BOM, explicit boundary); § 6 S-2 *Reached when* command half (fixture set updated to match); § 11 R-3 *response* (states an observed condition with nothing to do next, no folder offered); SDD Review Notes RN-41, RN-42 (new) | `successor CDO` — confirm § 4 C-E4 (via `docs/CONTENT.md` L62's terminal form) carries the message shape R-3's `failed` item now takes, or name the terminal form in C-E4 if it does not |
| CDO | yes | § 4 C-E4 (terminal form named — CTO's request answered "not as written"; C-E4 as it stood was narrower than `docs/CONTENT.md`'s own *Error* formula and would have pointed a builder at the wording the owner overrode); one *Violated by* item added; § 6 S-4 *Reached when* observable half (new sentence for the linked-worktree/submodule case, citing R-3, UX-I10, UX-I14, C-E4); RN-43 (new) | `no_followup` |

### What this round settled

- CTO's two folds are authorized by the owner's confirmed FDR-trail answers (`docs/trail/fdr/cycle-1.md`
  §§ 2.4, 2.7), not by this SDD's own companion — `docs/SDD_open_issues.md` § 5.1's Answer slot stayed
  unfilled and untouched throughout. CTO read two files outside this run's resolved input set to do
  this (`docs/trail/fdr/cycle-1.md`, `docs/fdr.md`) and surfaced that explicitly in its turn; the
  runner did not authorize or judge the reading, only records that it happened.
- CTO's `successor CDO` request was fulfilled inside this same round: CDO's C-E4 edit and new S-4
  sentence directly answer it, with the reasoning above. CTO has not yet had the ordinary turn to
  confirm the fulfillment against its own lane — carried into Round 2 per the standing-move rule
  (a `successor` declaration is not sticky the way `no_followup` is).
- No companion item was added, resolved, or touched. `SDD_open_issues.md` § 5.1 stands exactly as it
  did at intake.

### What was disagreed, and who held what

None. CDO's "not as written" is not a disagreement with CTO — CTO asked CDO to judge whether C-E4
already carried the shape or needed to name it; CDO judged the latter and made the edit itself, inside
its own lane, which is answering the request, not opposing CTO's lane.

### Spoke without an input it needed

None — all three seats' resolved input lists were reported present except the two conditional
absences already noted in each turn message (`definition_brief.md`, `design_system/`), neither of
which any seat flagged as needed. (CTO's reads of `docs/trail/fdr/cycle-1.md` and `docs/fdr.md` were
not inputs it needed and lacked — they were reads it chose to make outside the input set, disclosed in
its turn; see *What this round settled* above.)

---

## Round 2

- **Opened:** 2026-09-04, immediately after Round 1 closed.
- **Turn order:** CTO only — CPO's and CDO's ordinary turns were skipped (their Round 1
  `no_followup` is sticky; no recall was issued).

### What each seat did

| Seat | Spoke | Changed | Declared |
|---|---|---|---|
| CPO | skipped (Round 1 `no_followup`, sticky, no recall) | — | — |
| CTO | yes | `SDD.md` § 6 S-4 *Reached when*, command half — one reducer case added (`--test git_state`, a port double whose `probe` answers `root` and whose `state()` returns the outside-Git-directory error, held as `failed(condition)` with every tree item `observed`); SDD Review Notes RN-44 (new) | `no_followup` |
| CDO | skipped (Round 1 `no_followup`, sticky, no recall) | — | — |

### What this round settled

- CTO's Round 1 `successor CDO` request verified fulfilled: CDO's C-E4 terminal-form edit and new
  S-4 observable sentence both hold against CTO's R-3, with no gap.
- One found-while-walking defect fixed in place, in CTO's own lane: S-4's observable half (added by
  CDO in Round 1) asserted a behaviour the command half's existing fixtures never exercised — the
  `linked-worktree`/`submodule` fixtures cannot produce R-3's failure on their own (the harness drives
  `ka-reader-core` in-process under no sandbox grant; the failure exists only under the bundle's grant).
  CTO added the missing reducer case rather than leaving the assertion unbacked.
- No item remains open anywhere in the (unconsumed) companion — it was not touched this run.

### What was disagreed, and who held what

None.

### Spoke without an input it needed

None.

---

## Interruptions

<None — this run had none.>

---

## How this run ended

- **Ended because:** all three seats declared `no_followup` with no recall outstanding (CPO and CDO
  at the close of Round 1; CTO at the close of Round 2, once its `successor CDO` request — fulfilled
  within Round 1 — was verified and its own one found-while-walking gap, S-4's unbacked observable
  assertion, was fixed).
- **`SDD.md` left at:** Draft — *the runner's stamp.* All three declared done and no recall is
  outstanding, but `docs/SDD_open_issues.md` still stands on disk with its one item (§ 5.1) unanswered
  — the Settled condition requires no companion on disk, and this run neither consumed nor cleared it
  (its Answer slot was unfilled at intake, so the skill's own rule left it untouched throughout).
- **Companion:** `SDD_open_issues.md` stands with 1 item — § 5.1 ("Raised from downstream," Principal
  PM, 2026-09-04), Answer slot unfilled. Unrelated to this run's content: CTO folded the two sentences
  § 5.1 discusses under the owner's own confirmed FDR-trail answers (`docs/trail/fdr/cycle-1.md`
  §§ 2.4, 2.7), not under this companion — § 5.1 itself was never touched and its Answer slot is
  still the owner's to fill.
- **What a next run inherits:** the standing `SDD_open_issues.md` § 5.1, exactly as it stood at this
  run's intake — the owner still needs to fill its Answer slot (or a `companion-self-answer` run can
  answer it) before a future `product-sdd` run would consume it. Everything else this run touched (§ 3
  `fs-reader`, § 6 S-2/S-4, § 4 C-E4, § 11 R-3, RN-41–RN-44) is closed with no open thread. A future
  run starts fresh from Round 1 with no unfinished round of its own.
