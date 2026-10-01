---
version: "1.0.0"
---
<!-- The version above is template-file metadata; it is not copied into the instantiated document. -->

# SDD conversation — nozoki, run run-20

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

- **Round:** 2
- **Seats, and the names they answer to:**
  - CTO — `sdd-nozoki-run20-cto`
  - CPO — `sdd-nozoki-run20-cpo`
  - CDO — `sdd-nozoki-run20-cdo`
- **Standing declared move:** CTO `no_followup` · CPO `no_followup` · CDO `no_followup`
- **Recall outstanding:** none
- **Recalls spent:** CDO → CPO
- **Counters:** rounds `2/6` · no-change rounds `0/2` · rounds with no reply `0/1` · output tokens `0/600000` (under-counted)
- **Status of `SDD.md`:** Draft

---

## Round 1

- **Opened:** 2026-10-01T09:47:42.094267+00:00
- **Turn order:** CPO → CTO → CDO

### What each seat did

| Seat | Spoke | Changed | Declared |
|---|---|---|---|
| CTO | yes | § 3 SM-4 (what crosses; owner cell); § 4 C-R7 (export grain — three sentences, plus what *built* means and why); § 4 C-I3 (unit-is-the-build sentence, two uncovered cases, five citations re-pointed and pinned, frame count with the second runner reading, *Violated by*); § 6 `open-a-folder` *Reached when* command half (one citation); § 6 `follow-the-folder` *Rests on* (held-state clause); § 10 RC-3 *Still unresolved* (citation pinned, second dated parenthesis); SDD Review Notes RN-76 (new); `docs/SDD_open_issues.md` §§ 2.1, 5.1, 5.2 removed as folded — the file lists no item. Companion items added: none. | successor CPO — re-read `follow-the-folder`'s *Rests on* clause ("from this slice at the latest") against § 5 step 4 E-5's sizing and `read-a-file`'s *Not in this slice*, and the C-R7/SM-4 change-grain wording against § 8's *Delivers* row, then close |
| CPO | yes | nothing | successor CTO — fold cycle-17 § 5.1 into § 4 C-R7, § 3 SM-4 and § 4 C-I3, and § 5.2's clause into § 6 `follow-the-folder` *Rests on*; settle § 2.1's citations and frame count in C-I3 and `open-a-folder`'s command half; retire the resolved items from `docs/SDD_open_issues.md` |
| CDO | yes | nothing | successor CTO — say how the reader's scroll and a collapse reach the model inside SM-4's closed nine-call list, or name it as a case the fold does not cover (§ 6 `follow-the-folder` *Rests on*; RN-76) |

### What this round settled

CTO: § 3 SM-4 (what crosses; owner cell); § 4 C-R7 (export grain — three sentences, plus what *built* means and why); § 4 C-I3 (unit-is-the-build sentence, two uncovered cases, five citations re-pointed and pinned, frame count with the second runner reading, *Violated by*); § 6 `open-a-folder` *Reached when* command half (one citation); § 6 `follow-the-folder` *Rests on* (held-state clause); § 10 RC-3 *Still unresolved* (citation pinned, second dated parenthesis); SDD Review Notes RN-76 (new); `docs/SDD_open_issues.md` §§ 2.1, 5.1, 5.2 removed as folded — the file lists no item. Companion items added: none.

### What was disagreed, and who held what

none

### Spoke without an input it needed

none

---

## Round 2

- **Opened:** 2026-10-01T10:04:12.871278+00:00
- **Turn order:** CPO → CTO → CDO → CPO (recall)

### What each seat did

| Seat | Spoke | Changed | Declared |
|---|---|---|---|
| CTO | yes | *Open Questions* (seventh item added — how a collapse and a scroll reach the model across SM-4); § 6 `follow-the-folder` *Rests on* (pointer to that item); SDD Review Notes RN-77 (new) and RN-76 (one clause, the *Open Questions* sentence). Companion items added: none. | no_followup |
| CPO | yes | nothing | no_followup |
| CDO | yes | § 6 `follow-the-folder` *Reached when* (observable half — the setup, the collapsed node, the panel not returning to the top); § 6 `see-git-status` *Reached when* (observable half — the scroll before switching back); § 4 C-E2 (*Violated by* — one case added); SDD Review Notes RN-78 (new). Companion items added: none. | no_followup |

### What this round settled

CTO: *Open Questions* (seventh item added — how a collapse and a scroll reach the model across SM-4); § 6 `follow-the-folder` *Rests on* (pointer to that item); SDD Review Notes RN-77 (new) and RN-76 (one clause, the *Open Questions* sentence). Companion items added: none.
CDO: § 6 `follow-the-folder` *Reached when* (observable half — the setup, the collapsed node, the panel not returning to the top); § 6 `see-git-status` *Reached when* (observable half — the scroll before switching back); § 4 C-E2 (*Violated by* — one case added); SDD Review Notes RN-78 (new). Companion items added: none.
CPO: § 5 step 4 (E-4 and E-5 — one dated re-read each, sizing stands); SDD Review Notes RN-79 (new). Companion items added: none.

### What was disagreed, and who held what

none

### Spoke without an input it needed

none

---

## How this run ended

- **Ended because:** all three declared no_followup with no recall outstanding
- **`SDD.md` left at:** Settled — the runner's stamp, computed.
- **Companion:** deleted — it stood empty at the close, nothing left unresolved.
- **What a next run inherits:** nothing — the seats closed the conversation.
