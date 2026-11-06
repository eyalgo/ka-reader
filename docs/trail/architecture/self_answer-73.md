# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (NFDR v78, Settled; reopened by the companion the PM opened at `ka-reader@444ad6a`)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-06
- **Sources re-read:** None. Every answer rests on this repository alone: `checks/gate.sh`, `checks/tests/test_tree_scene.sh` and `checks/tests/test_vm_refusal.sh` at `ka-reader@2529a42` and `ka-reader@d6bc3a3`, `docs/nfdr.md` v78, and `docs/SDD.md` v70.
- **Liveness check:** the header names `adr/` and `nfdr.md` as bare names, and both sit beside the companion on disk. Live.
- **What was read:** the whole companion. From NFDR v78: its header and version lines, the QC-65 passage around `:L2297`, § 8's dated gate readings (`:L2030-L2045`), § 9's opening paragraph (`:L2358-L2373`), every line that `grep -n 'gate.sh:L'` prints, and QC-24's SM-4 list. From the SDD: § 6 S-6, and the v70 commit (`ka-reader@14d4c89`), the one SDD change since NFDR v78 (`ka-reader@605822c`). `checks/gate.sh` was read at both commits. Which ADRs were opened: none. The item and the gap both sit in the NFDR's locators. SDD v70 moves no slice, edge, seam or part (its commit body says so), so no record is touched.
- **Scope:** one item, § 3.1, with an **Answer** slot. No item list was given, so it was this run's. It is the Principal Architect's: the edit lands in `docs/nfdr.md` and binds only how accurate its locators are. It commits nothing to a person or an outside party.

## Items worked

### 3.1 — An unpinned `checks/gate.sh` line locator in the NFDR now names a different line

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** Re-pin the locator at a commit, inline, and keep the step's name. The item has no draft, so this answers it from scratch. It is a correction, not a widening: it asks the NFDR to fix a locator, not to state a new case.

  **Check 2: the item's premise is half right.** The locator is not unpinned. The sentence ends "all at `ka-reader@2529a42`", and at that commit `checks/gate.sh:L127` is exactly `run_step 'Tree scene helper suite' 'checks/tests/test_tree_scene.sh'`. Read with that clause, the record is true. The real defect is where the pin sits. "All at" follows the second parenthesis, (`:L191-L204`) on `test_vm_refusal.sh`, so a reader takes it to cover that parenthesis and reads `:L127` as bare. The PM's measurements hold. At `ka-reader@d6bc3a3` the gate is 1.9.0, with *Displayed-file scene* and *Read-only, displayed-file scene* at `:L112-L113`. The helper suite is at `:L133`, and `:L127` is a comment line.

  **Check 3: of the item's two options, one breaks a settled rule.** "Name the step alone" would break NFDR v77's own rule: "every `checks/gate.sh` locator carries its commit" (the v77 version line, RN-87). So the answer is re-pin, in the form § 8 already uses for a moved gate line: the current pin first, then the earlier pin as history. Concretely: (the gate's *Tree scene helper suite* step, `checks/gate.sh:L133` at `ka-reader@d6bc3a3`; `:L127` at `ka-reader@2529a42` — RN-87). The rest of the sentence still holds at d6bc3a3. `test_off_a_vm_it_exits_non_zero_having_launched_nothing_and_copied_nothing` is still in `checks/tests/test_tree_scene.sh` (`:L242`), even though the suite changed in two commits. `checks/tests/test_vm_refusal.sh` is unchanged since 2529a42, so `:L191-L204` and the trailing "all at" still hold for what they cover.

  **Check 4: the stale case is the item itself.** A pinned locator stays true at its commit forever. The added d6bc3a3 pin will go stale against `HEAD` the next time the gate gains a step, as every pin in this document does. The document accepts that by design, since a pin is read at its commit. Two other places cite the same steps, `docs/nfdr.md:L1676` (`:L106-L107` at 2529a42) and `:L2371` (`:L106-L107`, `:L127` at 2529a42). Both carry their commit inline and are true at it, so this item does not move them. `:L2371`'s sentence is re-measured by item 2.1, raised below. I nearly answered "name the step alone", which is the sturdier form. The v77 rule tipped it. Overriding a rule the owner's seat set one cycle ago, on a one-line locator, is not this item's call.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.1 — The displayed-file scene's two gate steps are not yet recorded in § 9 or § 8

- **What the document is owed:** § 9 should list the displayed-file scene's two steps, *Displayed-file scene* and *Read-only, displayed-file scene* (`checks/gate.sh:L112-L113` at `ka-reader@d6bc3a3`), beside the tree scene's, with d6bc3a3 pins added to the tree scene's locators. § 8 should gain the dated gate 1.9.0 reading: 38 top-level `run_step` calls at `:L54-L145`.
- **Why it is worth a cycle:** the ground is *Something upstream moved and it has not seen it*, from `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` § The items are not the whole of what a document is owed. Strictly, what moved is the code the NFDR measures. `follow-the-file` (SDD § 6 S-6) was merged at `ka-reader@d6bc3a3` (`merge: 2026-11-06_the-open-file-follows-the-disk → main`). The gate there is 1.9.0 (`checks/gate.sh:L2`), and its two new steps run the displayed-file scene and its read-only walk (`:L112`, `:L113`). § 9 says each scene's commands "enter the product gate under QC-64 when their slice delivers", then names only the tree scene's (`docs/nfdr.md:L2367-L2371`). So a reader concludes the displayed-file scene is not yet gated, and that is false at d6bc3a3. Nothing upstream changes the answer. SDD v70 (`ka-reader@14d4c89`) is the only SDD change since NFDR v78, and it says "No slice, edge, seam, part, condition or place in the order moves". QC-24's SM-4 list names `select_file` by name only, so v70's new parameters do not touch it. One doubt: the station for this slice is still open. The PM's last commit says the selection-order case and gate steps still stand before it is reached. So the steps may grow again. I raised it anyway, because both readings are dated measurements that stay true at their commit, and the companion is already open.

  **One edit outside the raise:** § 2 read "None." before this item. The run replaced that line with the item, because leaving "None." above an item would be false. Nothing else in the companion changed apart from § 3.1's slot.

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
