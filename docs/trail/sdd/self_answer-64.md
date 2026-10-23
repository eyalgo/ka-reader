# Self-answer report — `docs/SDD.md`

The record of one unattended run that met `docs/SDD_open_issues.md` in the CTO's seat on 2026-10-23
and decided its one item. It is for the owner, who reads it to learn what was decided and on what,
and for the `product-sdd` run that folds the answer.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v57, `Status:` Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-23
- **Sources re-read:** three. GitHub Actions' state on the repository — the row's "hosted result is
  unread" sentence rests on it — re-read at its source: `gh api repos/eyalgo/ka-reader/actions/permissions`
  → `{"enabled":false,"sha_pinning_required":false}` on 2026-10-23. The two SHA-256 digests
  `checks/secret-scan.sh:L42-L43` pins — the answer says they are the release's — re-read at the
  vendor: `gitleaks_8.30.1_checksums.txt` from `github.com/gitleaks/gitleaks/releases/download/v8.30.1/`
  lists `b40ab0ae…b6a5` for `gitleaks_8.30.1_darwin_arm64.tar.gz` and `dfe101a4…2709` for
  `gitleaks_8.30.1_darwin_x64.tar.gz`, both equal to the pins. The runner image's software list the
  new gate comment cites (`checks/gate.sh:L49-L57`) — `actions/runner-images`,
  `images/macos/macos-26-Readme.md` at `main` — re-read 2026-10-23: `grep -ic gitleaks` prints 0, so
  the comment's "names no gitleaks" still holds; the answer does not restate it. Every other claim
  is inside this repository and was read at its own locator in the main checkout, read-only, at
  `ka-reader@914ceb3`, whose tree outside `docs/` is `8235240`'s (`git diff --stat 8235240 914ceb3
  -- . ':!docs'` prints nothing). Measured: `git diff --name-status 389adad 8235240 -- checks
  .github` → eight files, two added (`checks/secret-scan.sh`, `checks/tests/test_secret_scan.sh`)
  and six modified (`.github/workflows/ci.yml`, `checks/gate.sh`, `checks/no-network.sh`,
  `checks/structure.sh`, `checks/tests/test_no_network.sh`, `checks/tests/test_structure.sh`), none
  under `fixtures/`; `grep -c '^run_step' checks/gate.sh` → 30 at the tip, 28 at `389adad`;
  `grep -n '^run_step'` at both commits, giving the line map in the answer (old `:L45` → `:L47`; old
  `:L46` and below → thirteen higher); `wc -l checks/gate.sh` → 113 (100 at the pin);
  `cat -n .github/workflows/ci.yml` → 41 lines, `fetch-depth: 0` at `:L22-L23`, *Test gate*
  `:L27-L28`, packaging `:L33-L34`, upload `:L36-L41`, `runs-on: macos-26` `:L18`; `ls checks/*.sh`
  → twelve; `ls checks/tests/` → twelve `test_*.sh` and `support/`; `ls -d checks/fixtures/*/` →
  thirteen; `ls .gitleaksignore` → no such file; `checks/secret-scan.sh` read whole (229 lines),
  every locator in the answer read at its line; `checks/tests/test_secret_scan.sh:L1-L40` and
  `:L237` of `checks/tests/test_vm_refusal.sh` (`for suite in "$ROOT"/checks/tests/*.sh`); the
  version lines of `no-network.sh`, `structure.sh`, `test_no_network.sh` and `test_structure.sh` at
  both commits; `grep -n -o -E '(checks/[A-Za-z_./-]+|ci\.yml):L[0-9]+(-L[0-9]+)?' docs/SDD.md`
  below `:L4000` (the review notes start at `:L3902`) → every product locator the row and § 4 carry,
  of which only `gate.sh`'s and `ci.yml`'s are in a changed file and outside a dated note;
  `grep -n -i -E 'offline|QC-28|gitleaks|secret scan|system target|adapter construction|QC-17'
  docs/SDD.md` below `:L4000` → `:L2336` (§ 6, `gitleaks git` as a release command) and nothing
  the two modified scripts falsify; `docs/SDD.md:L1-L12`, `:L369` whole, `:L792-L835`,
  `:L886-L900`, `:L2325-L2345`, the section map, and `docs/trail/sdd/self_answer-63.md` whole; of
  the inputs, `docs/architecture_open_issues.md` whole (§ 3.1 already carries the NFDR's count and
  QC-28) and `docs/nfdr.md` QC-28 (`:L1077`, `:L2427`).

## Items worked

### 5.1 — § 3's `read-only-harness` row counts eleven scripts, eleven suites and 27 gate steps; at `ka-reader@8235240` there are twelve, twelve and 29

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's lean holds — a dated reading of the 29-step gate, twelve scripts and twelve
  suites at a named commit, its locators re-pinned, the `389adad` reading kept as a dated note — and
  it stops short of what the fold has to move and say, so it is confirmed with the rest measured
  and added.

  *Check 1.* The edit lands in `docs/SDD.md` § 3's `read-only-harness` row and in three § 4 C-I3
  locators into the same two files. The item carries `Seat: cto`, this run's posture. The answer
  binds nothing but the document's agreement with the tree: no person, no outside party, no risk
  the owner carries, and no ground I cannot name. Mine, in the CTO's seat.

  *Check 2.* The item sits under *Raised from downstream*, cites its occurrence (`8235240`), and
  corrects counts and locators found false — the row's own rule calls a later `checks/` change a
  re-measurement, not a contradiction — so it widens nothing and "not until it occurs" does not
  apply. The lean reaches the right conclusion and is incomplete in four places, each added.
  (a) `gate.sh` and `ci.yml` locators stand outside the row too — C-I3's dispatcher locator at
  `docs/SDD.md:L829`, its *Build KA-Reader.app* / *View check* locators and its `ci.yml:L26` at
  `:L893-L894` — and a fold that re-pins the row alone leaves four stale. (b) The item gives the
  line map for the two new steps and leaves the rest to the fold; I did it, for every `gate.sh`
  locator the row carries and for the three `ci.yml` ones, so the fold pins rather than searches.
  (c) What the two steps are, as the row describes every other step by what it does: the script's
  protocol, read whole, and the one property no other step has — it reaches the network on every
  run, not on the first run as the sanitizer step does, so the gate can no longer pass on a machine
  that cannot reach `github.com`. The answer says that plainly because the row is where a reader
  learns what the gate needs. The suite's own header says it proves protocol, not detection, and
  that the planted-secret control is not part of this change; the answer carries that bound rather
  than letting "its suite" read as a detection test. (d) The item lists the four other modified
  files and says nothing of them; I read their version lines and every SDD claim about them below
  the review notes, and found no locator and no sentence they falsify — the row names the scripts
  and not their rules, and C-R6's "declares a dependency or a `Package.resolved` exists"
  (`docs/SDD.md:L865`) states when the rule is violated, which a third refusal in the script does
  not make false. The answer records the four so the fold's dated note is a complete diff of the
  interval, as every earlier note is. The item is one question with one landing and one seat; it
  does not split. The NFDR's count and QC-28's *verified by* are another document's and already on
  `docs/architecture_open_issues.md` § 3.1; the answer names that and raises nothing there.

  *Check 3.* Nothing settled moves. The row's pin rule is what the answer applies. § 6
  `promise-one-point-zero` names `gitleaks git` exiting 0 as a release-time command
  (`docs/SDD.md:L2336`); the gate running the same tool on every build is consistent with it and
  the answer does not touch § 6. § 11 R-13 and the sanitizer sentences do not move. The station
  that landed the steps is reached (`system/projects/ka-reader/journey/shukuba/trail/2026-10-23_the-gate-scans-the-history-clean.md`),
  read as an input and cited nowhere in the answer; the gate exiting 0 in the guest is that
  station's record, and the answer says this run did not run the gate. The three outside sources
  the answer or the row leans on were re-read today and agree with the record (Header).

  *Check 4.* **Stale** — the answer is pinned to `8235240`, the merge; the tip read, `914ceb3`,
  holds its tree outside `docs/`, and a `checks/` change landing before the fold is, by the row's
  rule, one more item. **Absent** — no network: the step fails on every run, not only the first, and
  says "nothing was scanned"; the answer states it, because every other step either runs offline or
  fetches once. A gitleaks absent from PATH changes nothing — the step uses only the one it
  unpacks. **Concurrent** — two gates at once each unpack into their own `mktemp -d`; a HEAD that
  moves during a scan ends the step without a count (`checks/secret-scan.sh:L221-L223`); named in
  the answer by its locator. **Refused** — a finding ends the step red naming commit, file, line and
  rule and never the value; a malformed `.gitleaksignore` line, a digest that does not match, a
  version that does not match, or a host that is not Darwin arm64 / x86_64 each end it before any
  scan; all in the answer. **Empty** — a one-commit history scans one commit; not reached by the
  row and not a case it has to state.

  *Close to a different verdict.* Plain *confirmed* was close: the item's lean is right as far as
  it goes. What tipped it is (a) — four C-I3 locators a fold of the row alone would leave pointing
  at the wrong lines — and (c) — a gate step that needs the network on every run, which the row
  would otherwise not say.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/SDD.md** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
