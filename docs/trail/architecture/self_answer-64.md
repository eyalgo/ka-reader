# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The one open item names `docs/nfdr.md` QC-53 and
  §§ 8, 9 and 10. It touches no record.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-28
- **Sources re-read:** None outside this repository. No answer rests on a vendor statement. The
  lint's exit 0 (`Swift files read: 30; banned terms read: 49`), the planted-word run that ended at
  *Strings check*, and the guest's whole-gate exit 0 at `ka-reader@2ea9323` are the PM's
  measurements (item 3.1, *Where it shows*). This run did not repeat them. Everything else was read
  in this repository at `HEAD` `ka-reader@e4803c5`, whose `checks/` equals `f25fdbb`'s
  (`git diff --stat f25fdbb HEAD -- checks` prints nothing):
  - `checks/gate.sh` at `HEAD` and at `cd65c02`, side by side (`grep -n '^run_step'` on each, and
    `git diff cd65c02 f25fdbb -- checks/gate.sh`). The diff adds two things. One is the 1.5.0 version
    line at `:L2`. The other is a four-line comment (`:L106-L109`) and *Strings check*,
    `run_step 'Strings check' 'checks/strings.sh'` (`:L110`), between *No-network suite* (`:L105`)
    and *Strings check suite* (`:L111`). `grep -c '^run_step'` prints 33: 32 steps, `:L50` *Toolchain*
    through `:L129` *Own state*, and the definition at `:L32` (`:L31` at `cd65c02`). Every locator
    from old `:L2` to old `:L104` is one higher, and every one at or below old `:L105` is six
    higher. The order comment QC-64 pins is at `:L43-L45` (`:L42-L44` at `cd65c02`).
  - `git diff --name-status cd65c02 f25fdbb -- checks`: `M checks/gate.sh` alone.
    `ls checks/tests/*.sh | wc -l`: 14. `grep -nE 'curl|wget|https?://|git (clone|fetch)'
    checks/strings.sh` prints nothing, so the new step fetches nothing.
  - `docs/nfdr.md` v68. Read: the header; QC-28's two `gate.sh` locator sentences (`:L1079-L1090`);
    QC-53 (`:L1543-L1560`); § 8's opening paragraph and its structure-pair paragraph (`:L1570-L1645`);
    *Until the card runs the script* (`:L1690-L1760`); QC-64's order and secret-scan locators
    (`:L1877-L1890`); § 9's suites bullet (`:L2121-L2182`); § 10's QC-53 row (`:L2570`). Also
    `grep -n 'gate.sh'` over the body, to find every locator pinned at `cd65c02`. The NFDR runs to
    7,142 lines and was not read whole.
  - `grep -rln 'strings\.sh\|test_strings\|QC-53' docs/adr/` prints nothing.
  - `docs/SDD.md` v61, Settled, header line `:L9`. Its `read-only-harness` row was re-measured at
    `f25fdbb` and replaced its "No step runs `checks/strings.sh` itself" passage. It says a banned
    term now ends the gate at *Strings check*.

## Items worked

### 3.1 — QC-53, § 8, § 9 and § 10 say no gate step runs `checks/strings.sh` itself and count the gate at 31 steps; at `ka-reader@f25fdbb` the lint is a step of its own and the gate has 32

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** Fold it as the item proposes, with two additions.

  **Whose it is, and what was handed.** Every change the item calls for lands in `nfdr.md`, the
  document this companion belongs to. It binds nothing to a person or an outside party, and I can
  name no ground I cannot see. So check 1 puts it in the Principal Architect's seat, and I answered
  it in the owner's. The item's *If a document has to be written* line is a lean: add a dated 1.5.0
  reading, re-pin, say *Strings check* runs the lint, keep the old readings. I weighed it as a draft
  rather than answering from scratch. It is one question with a wide consequence, not two, so it
  does not split.

  **Not a widening.** It is a correction. Each sentence it moves was true at `cd65c02` and is false
  at `f25fdbb`: "No step of the gate runs `checks/strings.sh` itself", "31 steps", and "the lint
  reaches the gate through its suite". QC-53 already binds the tree. The item cites the occurrence,
  which is the step at `checks/gate.sh:L110`. The same fold shape was used at v66, v67 and v68
  (RN-77, RN-78, RN-79).

  **Check 2: the draft is right but incomplete in two places.**
  1. *The re-pin reaches past §§ 8 and 9.* The item says "every `gate.sh` locator these sections pin
     moved", and it names QC-53, § 8's *Until the card runs the script*, § 9's suites bullet and the
     § 10 row. Other places pin `gate.sh` lines at `cd65c02` too, and the new version line moved them
     all:
     - **QC-28, in § 2:** *Secret scan* `:L60`→`:L61`, its suite `:L50`→`:L51`, and *Planted secret
       suite* `:L68`→`:L69`.
     - **QC-64:** the order comment `:L42-L44`→`:L43-L45`, and its `:L50`, `:L60`.
     - **§ 8's opening paragraph and its structure-pair paragraph:** `:L61`, `:L68`, `:L71`, `:L72`
       and `:L79-L81`, each one higher.

     Re-pinning only the four places the item names would leave these one line off at the new pin.
     The item's "by five more after `:L105`" is right only in the new numbering. In the old numbering
     it is six more at or below old `:L105`, as SDD v61 says. I report this here and do not correct
     the item.
  2. *QC-53's last sentence must be re-said, not only struck.* "That one case is the lint's only
     path into the gate: with it removed, the tree half of this entry is checked nowhere" is now
     false. A banned term ends the gate at *Strings check*, the step named by the dispatcher, so
     *Strings check suite* runs only over a clean catalogue. The suite's
     `test_unchanged_catalogue_copy_passes` is now the second path. It is the one that still holds
     QC-53's tree half if the step is ever removed. QC-53 should say both paths and which one names
     a hit. Striking the sentence would lose the absent case it was guarding.

  **Check 3.** Nothing settled contradicts the answer, and one settled document requires it. SDD
  v61 is Settled and already says the lint is a step of its own and ends the gate on a hit. An NFDR
  that still says "no step runs `checks/strings.sh` itself" disagrees with it. § 8's sentence that
  the two steps reaching the network on every run are *Secret scan* and *Planted secret suite*
  stays true, because the lint fetches nothing. § 8 should count *Strings check* among the steps
  that fetch nothing, as v68 did for its suite. No ADR is owed: no record names the lint or its
  suite, and adding a step that verifies an existing obligation can be undone in one line, so it
  fails the significance test. No `QC` is added. My earlier answer, `self_answer-63.md`, said "Whether
  the lint should also get a step of its own is not asked here, and I do not raise it". That stayed
  true when written. This fold answers the case that answer left open, and does not contradict it.

  **Check 4.**
  - *Absent:* if *Strings check* is removed, the suite's case still runs the real lint over a copy
    of the tree, so the gate still goes red. If both are removed, the tree half is checked nowhere.
    Addition 2 is what keeps this visible.
  - *Refused:* if the lint exits non-zero, the gate stops at *Strings check*, and the dispatcher
    names it (`gate.sh: step failed: Strings check`, the PM's measurement).
  - *Stale:* the counts and locators stay dated pins. The next added step is a re-measurement, not a
    contradiction, as § 9 already says.
  - *Empty and concurrent:* not reached. The catalogue is not empty (`Swift files read: 30`), and the
    step adds no fetch, so it shares nothing with another run.

  **What would have tipped it.** I came close to a plain **confirmed**, treating the wider re-pin as
  the fold's own detail. What decided it is that the fold re-pins from the item's text, and the item
  lists four places. QC-28 is in § 2, which the item never mentions.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
