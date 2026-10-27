# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The one open item names `docs/nfdr.md` § 8 and § 9.
  Its answer also reaches QC-28, QC-64 and § 10's QC-28 row. It touches no record.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-27
- **Sources re-read:** None outside this repository. The answer leans on no vendor statement. That
  the pinned gitleaks reports the planted string is a measurement, not a claim taken from a README:
  the PM ran the suite in a disposable clone at `ka-reader@1b32500` (item 3.1, *Where it shows*),
  and this run did not run it again. Everything else was read in this repository at `HEAD`
  `ka-reader@9b5ef78`, whose `checks/` and `.github/` equal `1b32500`'s
  (`git diff --quiet 1b32500 HEAD -- checks .github` exits 0):
  - `checks/gate.sh`. Version 1.3.0 at `:L2`. `grep -n '^run_step'` lists the definition at `:L30`
    and 30 calls: *Toolchain* `:L48`, *Secret scan suite* `:L49`, *Secret scan* `:L59`, *Build the
    workspace* `:L60`, *Planted secret suite* `:L67` (its comment `:L61-L66`), *Build KA-Reader.app*
    `:L70`, *Test gate* `:L71`, the sanitizer `:L78`, the structure pair `:L79-L80`. The suites sit
    at `:L49`, `:L67`, `:L80`, `:L82`, `:L85`, `:L87`, `:L97`, `:L101`, `:L103`, `:L104`, `:L107`,
    `:L108` and `:L109`. The order rule is at `:L41-L43`.
  - `git ls-tree --name-only 1b32500 checks/tests/` lists thirteen `test_*.sh` and `support`.
    QC-64's loop, `for s in checks/tests/*.sh; do grep -q "$s" checks/gate.sh || echo "$s"; done`,
    prints nothing.
  - `checks/tests/test_secret_scan_planted.sh`, its header: version 1.0.0; *WHY THIS EXISTS* (the
    control, and its bound to one planted string); *USAGE* (two fetches per run, no way to skip).
  - Which steps fetch: `grep -rln 'curl\|wget' checks/*.sh checks/tests/*.sh` names
    `checks/secret-scan.sh`, which fetches at `:L148-L151`, and `checks/tests/test_secret_scan.sh`,
    whose `curl` is a stand-in on `PATH` (`:L124`, `:L136`). The planted suite fetches through the
    real `secret-scan.sh`. The shallow refusal is `checks/secret-scan.sh:L85-L86`.
  - `.github/workflows/ci.yml`: `fetch-depth: 0` at `:L23`, *Test gate* at `:L27-L28`.
  - `docs/nfdr.md` v66. Read: the header (`:L1-L45`), QC-28 (`:L1077-L1101`), all of § 8
    (`:L1544-L1931`), § 9 through the suites bullet (`:L1933-L2142`), § 10 whole (`:L2406-L2501`),
    RN-3 and RN-77. A `grep` for the stale count and for every `gate.sh` locator pinned at `8235240`
    found them only in §§ 8 and 9, QC-28 and QC-64. The NFDR runs to 6,940 lines and was not read
    whole.
  - `docs/adr/0010-…` § the negative control (`:L61`) and `docs/adr/0012-…` § Decision (`:L59-L63`).
    `grep -rn 'gitleaks\|secret-scan' docs/adr/` prints nothing.
  - `docs/SDD.md` v59, Settled, its `read-only-harness` row (`:L371`). It already re-measures the
    same step at `1b32500` and calls the suite the scan's negative control.
  - The *Occurrence* definition, `<CORE>/../skills/pm/.claude/skills/shukuba-refine/prompts/rich.md`
    § *A gap is carried only where it occurs*.

## Items worked

### 3.1 — §§ 8 and 9 count the gate at 29 steps and the harness at twelve suites, with one step reaching the network; at `ka-reader@1b32500` the gate has 30 steps, thirteen suites, and two steps that fetch on every run

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** Fold it, and answer the fold's open question yes: QC-28 and § 10 name the planted-secret
  suite as the scan's negative control.

  **Whose it is.** Every change lands in `nfdr.md`, the document this companion belongs to. The answer
  commits nothing to a person or an outside party, and no ground is hidden from this run. Check 1
  puts it in the Principal Architect's seat. The item hands the fold no draft, only a fact and one
  open question, so this run answered it from scratch, on both halves. The halves share a seat, so
  this is not a split.

  **Why it is a correction, not a widening.** §§ 8 and 9 are pinned at `8235240` and true at that
  pin. `1b32500` moved the count, the locators and one unpinned sentence: "the scan step is the one
  step that reaches the network on every run". That sentence is now false, because the planted suite
  fetches gitleaks twice on every run. § 9 itself calls an added suite "a re-measurement of this
  sentence". The QC-28 half does widen the entry, but the item cites its occurrence: the step at
  `checks/gate.sh:L67` and the suite file. So § *A widening item waits until it occurs* does not
  hold it back.

  **Check 2, the question.** It hid a second question, "should QC-28 name the control?", which the
  item left to the fold. Leaving it there would let the fold settle a binding choice with no reasoning
  behind it. So this run answers it. **Yes**, for three reasons:
  1. QC-28's *verified by* names a scan whose suite (`test_secret_scan.sh`) uses a stand-in gitleaks.
     Until `1b32500`, nothing showed that the real scan could ever go red.
  2. ADR-0012 § Decision and ADR-0010 both say "a negative control is part of the gate, not an
     accessory to it", and ADR-0012 adds "a gate that cannot go red has not run".
  3. QC-62's § 10 row already names its control, `checks/fixtures/idle-shell`. Naming this one
     follows the document's own precedent.

  The bound goes in with it. The suite proves that one planted string of GitHub-token shape is
  reported, and nothing about other kinds of secret (its header). Without that line, "the scan can
  go red" would be read as "the scan catches secrets".

  **Check 3.** Nothing settled contradicts the answer:
  - SDD v59 (Settled) already describes the step at `1b32500` the same way, and leaves the NFDR's
    count to the NFDR.
  - No ADR mentions gitleaks or the scan. A check that makes an existing obligation falsifiable fails
    the significance test, because undoing it is one line of the gate. So no record is owed.
  - § 9 says it is the one place the count lives, and § 10 must not repeat it. Naming the suite on a
    row is not counting, so the two do not clash.
  - § 8's first paragraph orders the steps as build, assembly, test gate, then "every other rule"
    after them. The planted suite now sits between the build and the assembly, so the answer has the
    paragraph say where it sits. RN-77's departure (3) made the same fix for the scan.

  **Check 4.**
  - *Absent:* if the network is down, or the gitleaks maintainers stop serving the archive, the gate
    is already red at *Secret scan*, before the planted step runs. And because the suite runs the
    real `checks/secret-scan.sh`, moving the one pin moves both steps. So the new step adds no new
    platform dependence and no failure path, which is why the answer says so rather than adding a
    third clause to QC-28's tail.
  - *Stale:* a later gitleaks pin that stops reporting this string shape turns the suite red. That is
    the control working, so the bound sentence should say which rule the string targets.
  - *Concurrent:* three fetches per run, and the gate runs at two points per change, so six per
    change. Their cost and any download throttling are unmeasured. That is named here as a gap, not
    an obligation.
  - *Refused:* the shallow-checkout refusal does not reach the suite, which builds its own
    repository.
  - *Empty:* does not apply. The clean repository has one commit by construction.

  **What would have tipped it the other way.** I came close to answering the QC-28 half "§ 9 only":
  the suite is just one more step under § 9's rule. What decided it is that QC-28's *verified by* is
  where a reader checks whether the tree half can fail, and today that tail cannot answer. Without
  the ADR-0012 rule I would have left it to § 9.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
