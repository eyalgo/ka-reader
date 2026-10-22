# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The one open item names `docs/nfdr.md` and touches no
  record.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-22
- **Sources re-read:** two sources outside this repository, both in the managing pipeline.
  - **The project card**, `system/projects/ka-reader/project.md` in `kensaiapp-opensource`, at its
    `HEAD`. Its `**Test command:**` line reads `checks/gate.sh` (`:L8`). Its comment cites "NFDR § 8,
    'Until the card runs the script'" by that heading's name. `git log` on the file shows the move at
    `1941f963` (2026-10-20 17:14:01 +0200, "product-card: ka-reader — the test command runs
    checks/gate.sh (NFDR v59 § 8)"), followed by `85264c69` (17:14:17, the comment). Nothing has
    moved the card since.
  - **The pipeline's gate tool**, `<CORE>/tools/gate_suite.py`. It still reads the card's
    `Test command:` line (`_CARD_LINE`, `:L621`) and refuses a project that has none (`:L1096`,
    `:L1304`). So § 8's sentence that the pipeline issues the card's test command and nothing else
    still holds at the source.
  - **What was read in this repository, at `ka-reader@de3eb1f`:** the NFDR's header (`:L1-L5`);
    § 8 from its opening paragraph through QC-65 (`docs/nfdr.md:L1496-L1824`); § 9's harness-suites
    bullet (`:L2045-L2060`) and its `ka-reader-mac` bullet (`:L2236-L2248`); and RN-6's opening
    (`:L2427-L2445`). The NFDR runs to 6,510 lines and was not read whole. Also read:
    `checks/gate.sh`, whose version line reads 1.1.0, where `grep -c '^run_step'` prints 28, and whose
    blob has not changed since `389adad`; this file's last report, `self_answer-56.md`; and the
    companion whole.
  - **Read as an input and not citable by the NFDR:** the managing instance's code-integrity record
    for the sanitizer change. Its gate-tool run reports `Environment: macos-guest — kensai-macos`,
    exit 0, and its run log ends at the gate's `Own state` step. That is a full `checks/gate.sh` run,
    issued at a change after the card moved.

## Items worked

### 2.1 — § 8 says the card's command does not run `checks/gate.sh` yet; it has run it since 2026-10-20

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The item is right, and the fold should do what it proposes. § 8 states the card as it read
  at `a4204e5b` and says the move to `checks/gate.sh` "is owed to `product-card`". Both are false
  since `1941f963`. The paragraph itself says it "goes false at the card's next move until RN-6 is
  extended". This is a correction of a stated fact. It is not a widening, so the "wait until it
  occurs" rule does not apply.
  - **Seat.** The Principal Architect's. The edit lands in `nfdr.md` § 8, § 9 and RN-6. It commits no
    person and no outside party, and no ADR moves.
  - **Check 2: the draft holds, for the reason it gives.** I re-measured it rather than taking it from
    the item. The card reads `checks/gate.sh`. The gate tool still runs the card's command and nothing
    else at the developer's closing run and at code-integrity. So "no run issues the script at a
    change" is false on the card's own terms. It is also false in practice: a code-integrity run
    after the move ran the whole script in the guest and exited 0. The draft's rule fits each
    passage: a gate the script now holds moves to the script, and a gate resting on some other ground
    stays and names that ground.
  - **The additions.**
    1. **The draft names one gate that stays; there are two.** QC-64's *nothing else* half stays,
       because no script holds it. QC-56's `.yaml` half stays too. QC-56 already says so in its own
       words ("that gate stays after the card's command runs the script, because the gap is in which
       files the check reads"). The fold should keep both, each with its ground. It should not sweep
       QC-56's review gate away with the run-gap sentence beside it.
    2. **QC-65 has two sentences the draft does not name.** "What holds meanwhile is that the card's
       command runs none of these steps" is now false. The card's command runs every guarded step on
       every change, so QC-65's refusal is now what keeps them off a physical Mac. The entry's named
       cost ("under the owner's-Mac option no change to this product can pass a gate") is now a
       current fact, not a future one. Its ordering rule (the refusal lands with or before the change
       that puts these steps on the card's command, never after) was met: `ka-reader@13e8d42` comes
       before `kensaiapp-opensource@1941f963`. The fold should record that as met and not leave it
       reading as an obligation.
    3. **What the fold may cite.** Its ground is the card at `1941f963` plus § 8's own sentence that
       the gate tool issues the card's test command. Those two together are enough. The guest run
       that shows it working is a change record under the managing instance's journey, and the
       definition set never names the journey. If the fold wants a measured run, it takes one in the
       product or through a trail copy, the way earlier cycles cite the PM's measurement. It should
       not invent a commit for one.
    4. **Check 3: the card points back at this paragraph by name.** The card's `Test command:`
       comment cites *Until the card runs the script*. If the fold renames or retires that heading
       (the paragraph's condition is now met), the card's pointer goes stale. Earlier cycles renamed
       headings and kept the old name in a "through vNN" note. Whatever the fold does with the
       heading, a changed name is a card move for `product-card`. The fold raises it on the card's
       own channel and does not edit the card (RN-24). This answer does not owe the card anything
       today: the field holds the right command, and the pointer is only at risk if the fold moves
       the heading.
  - **Check 4.**
    - *Stale:* the re-pin to `1941f963`/`85264c69` goes false at the card's next move. RN-6's
      extension carries that, as before.
    - *Absent:* if `.github/workflows/ci.yml` leaves the tree, the gate moves to the owner's Mac and
      QC-65 turns it red. That holds unchanged, and is now live.
    - *Refused:* the card's command fails on any physical Mac, the owner's included. That is QC-65's
      accepted cost, not a new one.
    - *Uncovered and named:* the guest-side cost QC-64 left unmeasured. The guest run above is one
      reading, but the NFDR cannot cite it as it stands.
  - **What would have tipped it.** A plain *confirmed* would have done if the draft had named QC-56's
    `.yaml` gate and QC-65's "meanwhile" sentence. An *override* would have been right if the gate
    tool had stopped reading the card's `Test command:` line. It has not.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
