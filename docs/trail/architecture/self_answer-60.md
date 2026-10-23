# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The one open item names `docs/nfdr.md` § 9, the
  Swift-packet bullet. It touches no record.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-23
- **Sources re-read:** the Swift packet's `quality_gates.md` v1.1.0 (engineering doctrine, outside
  this repository), `:L45`. It still reads
  `select(.url != null or .type == "system")` beside `test ! -e Package.resolved`, the gate the NFDR
  header cites at the same version. Everything else the answer rests on is in this repository,
  measured at `HEAD` `ka-reader@825bfcd`:
  - `checks/no-network.sh` v1.2.0, last changed at `73f4819`. `:L2` gives the version line. `:L34`
    is *THE SWIFT HALF*, which names three failing conditions. `:L159-L164` refuses a target whose
    `type` is exactly the string `system`, and names it. `:L120-L133` fails when `swift` or `plutil`
    is missing or the dump cannot be read. `:L181` exits non-zero when anything failed.
  - `checks/tests/test_no_network.sh` v1.3.0. `:L64` registers `test_system_target_fails` and `:L512`
    defines it. The case drives the script with stubbed `dump-package` output.
  - The suite, run in a disposable clone at `825bfcd`, exits 0 and prints 21 `ok` lines,
    `ok   test_system_target_fails` among them. The removal half of the PM's measurement was not
    repeated: that the case goes red once the refusal is taken out is the item's reading, not this run's.
  - `swift package --package-path ka-reader-mac dump-package` at `HEAD` names no target of type
    `system`.
  - `docs/nfdr.md` v64: the header and its citing rule (`:L1-L45`), § 9's Swift-packet bullet
    (`:L2240-L2332`), QC-8 and QC-9 (`:L389-L412`), and every line that names `no-network.sh`, a
    `system` target or `systemLibrary` (`grep -n`). The Review Notes hits are at `:L3774-L3790`,
    `:L5829-L5851` and `:L5917-L5947`. The NFDR runs to 6,760 lines and was not read whole.
  - `docs/adr/`: `grep` for `systemLibrary`, `"system"` and `type system` finds nothing, so no
    record states the gap.

## Items worked

### 3.1 — § 9 says the `type == "system"` clause has no check behind it; `checks/no-network.sh` now refuses a system target

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item is right, and the fold should make the change it proposes. The script now
  refuses a system target, so § 9's sentence saying no check stands behind that clause is false.
  This is a correction, not a widening: the item asks the NFDR to stop saying something untrue, and
  the bullet's own tail already says what it becomes: "the day `checks/no-network.sh` refuses a
  `system` target, that clause's gate is the script". It is this document's own question, so check 1
  puts it in the Principal Architect's seat. The item sits under *Raised from downstream*, but it
  carries a full proposed edit, so this run weighed that edit as a draft instead of answering from
  scratch.

  Check 2: the proposal holds, for the reason it gives. I re-read the refusal in the script
  (`:L159-L164`) and re-ran the suite in a clean clone at `825bfcd`: 21 of 21 `ok`, the system-target
  case among them.

  Check 3: the script's three Swift conditions are the packet's gate as written, re-read at its
  source (`quality_gates.md` v1.1.0 `:L45`). The one difference is `plutil` in place of `jq`, which
  § 9 already records. So naming the script as the clause's gate contradicts no settled source. No
  ADR states the gap, so no record is owed. A check landing reverses no decision, and no `QC` is
  added or moved.

  The additions:
  1. **Re-pin the locators.** The script locators the passage cites (`:L31-L32`, `:L131-L138`,
     `:L149`) name no commit and point at the older script. Re-pin every one at
     `ka-reader@825bfcd`, and keep the old readings in a dated *(through v64 …)* note, as the NFDR
     does everywhere else.
  2. **Keep the review for what it still covers.** The `development-design` review on any change to
     `Package.swift` stays for the six tools-6.2 items that no script reads, and for an added test's
     framework. Only the system-target ground leaves its rationale. The item says this too; this
     names the count.
  3. **Say what each half holds.** This is check 4. The suite drives the script on stubbed dumps,
     so it holds the refusal's logic, not the real manifest. The real dump is read by the gate run on
     every change. On the *absent* path the script fails closed: a missing `swift` or `plutil`, or a
     dump it cannot read, is a failure (`:L120-L133`, exiting at `:L181`), not a silent pass. On the
     *stale* path, a change that drops the refusal turns the suite's case red. The *empty*,
     *concurrent* and *refused* paths do not apply: a package with no targets declares no system
     target, and the check is a read with no second actor.
  4. **Leave the history alone.** The Review Notes that state the old gap (`:L3774-L3790`,
     `:L5829-L5851`, `:L5917-L5947`) are history and stay as they are.

  One thing would have tipped this to *overridden*: the refusal not matching the packet's
  `type == "system"` exactly, for example by matching a substring. It does not. It compares the
  string kind and the exact value (`:L159-L161`).

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
