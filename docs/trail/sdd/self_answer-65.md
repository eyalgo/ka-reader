# Self-answer report — `docs/SDD.md`

The record of one unattended run that met `docs/SDD_open_issues.md` in the CTO's seat on 2026-10-27
and decided its one item. It is for the owner, who reads it to learn what was decided and on what,
and for the `product-sdd` run that folds the answer.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v58, `Status:` Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-27
- **Sources re-read:** None. Every claim the answer rests on is a file in this repository, read at
  its own locator in the main checkout, read-only, at `ka-reader@33581f3`, whose tree outside
  `docs/` differs from `1b32500`'s in `README.md` alone (`git diff --stat 1b32500 33581f3 -- .
  ':!docs'` → `README.md | 6 ++++++`), and whose `checks/` and `.github/` trees are `1b32500`'s
  (`git diff --name-status 1b32500 33581f3 -- checks .github` prints nothing). The one outside
  fact the row carries — that the two pinned digests are the vendor's published checksums — is not
  what this answer rests on; it was re-read at the vendor on 2026-10-23
  (`docs/trail/sdd/self_answer-64.md` § Header) and the answer repeats it nowhere. Measured:
  `git diff --name-status 8235240 1b32500 -- checks` → `M checks/gate.sh`,
  `A checks/tests/test_secret_scan_planted.sh`; the same range over `.github` → nothing;
  `git diff 8235240 1b32500 -- checks/gate.sh` → one line added at `:L2` and seven at `:L61-L67`;
  `grep -n '^run_step' checks/gate.sh` at both commits, giving the line map in the answer;
  `grep -c '^run_step' checks/gate.sh` → 31 at the tip; `wc -l checks/gate.sh` → 121;
  `ls checks/*.sh` → twelve; `ls checks/tests/test_*.sh` → thirteen; `ls -d checks/fixtures/*/` →
  thirteen; `wc -l checks/fixtures/.gitignore` → 6; `checks/tests/test_secret_scan_planted.sh:L1-L60`
  (565 lines; the header whole) and its `:L258`, `:L426`; `checks/tests/test_secret_scan.sh:L8-L24`;
  `checks/tests/test_vm_refusal.sh:L5-L19`, `:L237`; `checks/secret-scan.sh:L39-L44`, `:L69-L74`,
  `:L122-L155`; `docs/SDD.md:L1-L14`, `:L370` whole, `:L826-L834`, `:L890-L900`, `:L8957`
  (RN-118), and `grep -n -o -E '(checks/[A-Za-z_./-]+|ci\.yml):L[0-9]+(-L[0-9]+)?' docs/SDD.md`
  below `:L4000` → of the locators into a changed file and outside a dated note, only `gate.sh`'s;
  `docs/trail/sdd/self_answer-64.md` whole; of the inputs, `docs/architecture_open_issues.md` § 3.1
  whole (the NFDR's count is carried there) and the station's own record
  (`system/projects/ka-reader/journey/nemawashi/2026-10-03_no-secret-reaches-the-repository/2026-10-23_a-planted-secret-fails-it_report.md`),
  read as an input and cited in the answer nowhere.

## Items worked

### 5.1 — § 3's `read-only-harness` row counts twelve suites and 29 gate steps, and says one step fetches; at `ka-reader@1b32500` there are thirteen suites and 30 steps, and two steps fetch

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's lean holds — a dated reading of the 30-step gate and thirteen suites at a
  named commit, its locators re-pinned, the new suite named, the `8235240` reading kept as a dated
  note — and it stops short of what the fold has to move and say, so it is confirmed with the rest
  measured and added.

  *Check 1.* The edit lands in `docs/SDD.md` § 3's `read-only-harness` row and in two § 4 C-I3
  clauses, into the same file. The item carries `Seat: cto`, this run's posture. The answer binds
  nothing but the document's agreement with the tree: no person, no outside party, no risk the
  owner carries, and no ground I cannot name. Mine, in the CTO's seat.

  *Check 2.* The item sits under *Raised from downstream*, cites its occurrence (`1b32500`), and
  corrects a count and a sentence found false — the row's own rule calls a later `checks/` change
  a re-measurement, not a contradiction — so it widens nothing and "not until it occurs" does not
  apply. Its supporting text is right: I reproduced every measurement it gives (31 `run_step`
  lines, the new step at `:L67` after `:L60` with its comment at `:L61-L66`, *Secret scan suite*
  at `:L49`, *Secret scan* at `:L59`, two files in the diff, the suite's two fetches). The lean
  reaches the right conclusion and is incomplete in six places, each added. (a) The whole line
  map: the item gives the two moved secret-scan locators and leaves the rest to the fold; `gate.sh`
  gained one line at `:L2` and seven at `:L61-L67`, so every locator from old `:L2` to `:L60`
  reads one higher and every one at or below old `:L61` eight higher — I mapped each of the row's
  `gate.sh` locators, checked against `grep -n '^run_step'` at both commits, so the fold pins
  rather than searches. (b) Three § 4 C-I3 locators into `gate.sh` stand outside the row
  (`docs/SDD.md:L830`, `:L894`) and move with it; a fold of the row alone leaves them pointing at
  the wrong lines, as RN-118's fold found for the previous step. (c) What the suite is, as the row
  describes every other step by what it does — read whole from its header: the real script and
  the real gitleaks, twice over one disposable repository, clean then planted, passing only on
  both outcomes and both pin-matched lines; no machine Git configuration read; nothing written
  into the checkout and HEAD not moved. (d) The fetch sentence: the row says no step but *Secret
  scan* fetches on every run, and that is now false — the suite's header says each run downloads
  the archive twice. The answer states the new count (three fetches in two steps) and that the
  offline failure point does not move, because *Secret scan* at `:L59` is reached first. (e) The
  row's sentence that "the planted-secret control is not part of the change that landed
  `test_secret_scan.sh`" is true of that change and now reads as if no control exists; the fold
  names the file that carries it. `test_secret_scan.sh`'s header at `:L14-L16` still says so and
  did not change between the pins — product code, which the station's report records as owed
  outside the change; the answer does not quote it as current. (f) `test_vm_refusal.sh` is
  unchanged and reads suites off the disk (`:L237`), so the new suite is covered by it with no
  change — the sentence the row carries for `test_secret_scan.sh`, extended. The item is one
  question with one landing and one seat; it does not split. The NFDR's § 8 count and § 9
  enumeration are another document's and already on `docs/architecture_open_issues.md` § 3.1;
  the answer names that and raises nothing there.

  *Check 3.* Nothing settled moves. The row's pin rule is what the answer applies. `docs/SRS.md`
  NFR-8 binds the product during operation and the row already says the fetch is the harness's;
  a second fetching step changes nothing there. § 6 S-7's release-time `gitleaks git`, § 11 R-13
  and the sanitizer sentence do not move. The workflow is untouched between the pins, so the
  `fetch-depth: 0` sentence and every `ci.yml` locator stand. The previous answer
  (`self_answer-64.md`), folded at v58, is the record this one extends: same row, same rule, the
  next pin. The station that landed the step is reached and its close is the Scrum Master's
  (`journey/shukuba/` holds no open station); its report is an input here and the answer cites it
  nowhere.

  *Check 4.* **Stale** — the answer is pinned to `1b32500`, the merge; the tip read, `33581f3`,
  holds its `checks/` tree, and a `checks/` change landing before the fold is, by the row's rule,
  one more item. **Absent** — no network: the gate ends at *Secret scan* (`:L59`) with "nothing
  was scanned" before the planted step is reached, so the new step adds no earlier failure; a
  network that drops between the two steps ends the gate at *Planted secret suite*, named by the
  dispatcher, with the suite's own line saying the clean run did not show the real scanner ran
  (`test_secret_scan_planted.sh:L102`). **Refused** — a digest that does not match on either
  fetch ends `secret-scan.sh` before any scan and so fails the suite's run; a pinned gitleaks that
  no longer reports the planted string's shape makes the planted run exit 0, and the suite fails
  with the line at `:L110` naming that cause; both named in the answer by the suite's own
  guarantees. **Concurrent** — two gates at once: each suite run builds its repository and the
  scanner's working files under its own `mktemp -d` and removes it on exit (`:L41-L45`), and
  writes nothing to the checkout, so *Own state*'s clean-tree condition is not reached by it;
  not a case the row has to state. **Empty** — the clean repository holds one commit, which is
  the control's own first case; not a case of the row.

  *Close to a different verdict.* Plain *confirmed* was close: the item's lean is right as far as
  it goes and its measurements all reproduce. What tipped it is (b) — three C-I3 locators a fold
  of the row alone would leave stale — and (d) and (e) — two sentences in the row that are now
  false rather than merely incomplete, which the lean's "the new suite named" does not reach.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/SDD.md** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
