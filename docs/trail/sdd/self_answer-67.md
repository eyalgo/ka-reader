# Self-answer report — `docs/SDD.md`

The record of one unattended run that met `docs/SDD_open_issues.md` in the CTO's seat on 2026-10-28
and decided its one item. It is for the owner, who reads it to learn what was decided and on what,
and for the `product-sdd` run that folds the answer.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v60, `Status:` Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-28
- **Sources re-read:** One. The row's sentence that GitHub Actions is disabled on the repository
  rests on the platform, and the answer repeats it as current, so it was re-read at the source:
  `gh api repos/eyalgo/ka-reader/actions/permissions` → `{"enabled":false,"sha_pinning_required":false}`
  on 2026-10-28; it still holds. The two pinned gitleaks digests are the row's other outside fact and
  the answer does not rest on them (nothing about `secret-scan.sh` moves); they were read at the vendor
  on 2026-10-23 (`docs/trail/sdd/self_answer-64.md` § Header) and not re-read here. Every other claim
  is a file in this repository, read at its own locator in the main checkout, read-only, at
  `ka-reader@eba1d83`, whose tree outside `docs/` is `f25fdbb`'s (`git diff --stat f25fdbb eba1d83
  -- . ':!docs'` prints nothing; `git diff --stat 2ea9323 f25fdbb` prints nothing too). Measured:
  `git diff --name-status cd65c02 f25fdbb -- checks` → `M checks/gate.sh`; `git diff cd65c02 f25fdbb
  -- checks/gate.sh` → one line added at `:L2` and five at `:L106-L110`; `cat -n checks/gate.sh`
  whole (129 lines), giving the line map; `grep -n '^run_step' checks/gate.sh` → the definition at
  `:L32` and 32 calls, `:L50` to `:L129`; `grep -c '^run_step'` → 33; `ls checks/*.sh | wc -l` → 13;
  `ls checks/tests/*.sh | wc -l` → 14; `ls -d checks/fixtures/*/ | wc -l` → 13; `wc -l
  checks/fixtures/.gitignore` → 6; `wc -l .github/workflows/ci.yml` → 41, with `:L18-L41` read;
  `git ls-files -s checks/gate.sh` → `100755`; `checks/strings.sh:L1-L40` and `grep -n -E
  'curl|wget|http' checks/strings.sh` → nothing; `checks/tests/test_vm_refusal.sh:L2`, `:L6-L7`,
  `:L37`, `:L63-L97`, `:L230-L250`; `docs/nfdr.md:L1545-L1549`; `docs/SDD.md:L1-L16`, `:L372` whole
  (read folded, 263 lines), `:L826-L834`, `:L890-L903`, the Review Notes headings `:L8696-L9149`
  and `:L9156`, `:L9206`, `:L9237`, `:L9245`; `grep -n -o -E 'gate\.sh:L[0-9]+(-L[0-9]+)?'
  docs/SDD.md` over the whole file → outside the row, only `:L832` and `:L896` are live (the rest sit
  in dated notes, the header's version notes, or RN-115 to RN-120); `grep -n` over the whole file for
  `strings.sh`, `QC-53`, `31 steps`, `thirty-first`, `test_strings`, `1.4.0`, `32 steps`,
  `thirty-second`, `in no step of its own` and `No step runs` → nothing outside the row, the header's
  dated version notes and RN-120's record, so no other sentence of the SDD goes false with this one;
  the same four phrases over `docs/SRS.md`, `PRD.md`, `fdr.md`, `acceptance_fdr.md`, `UXD.md`,
  `what_left.md`, `CONTENT.md`, `DESIGN.md`, `proposal.md` and `build_cost.md` → nothing, so no
  other settled document is owed a change by this step. The document was not read end to end (9,330
  lines, ~965 KB); the whole-file greps above are what stood in for that, and they are scoped to what
  this answer could contradict. In a disposable clone (`git clone` to `mktemp -d`, checked out at
  `f25fdbb`, run in a subshell, removed from outside), `checks/strings.sh` → exit 0, `Swift files
  read: 30; banned terms read: 49`, the item's own figures. `docs/trail/sdd/self_answer-66.md` whole
  and `docs/trail/sdd/cycle-55.md` § 5.1's answer slot, for the previous round's shape; of the inputs,
  `docs/architecture_open_issues.md` whole (the NFDR's counts and QC-53's "only path" sentence are
  carried there, § 3.1) and the seed this item's `Tracked by:` names, read as inputs and cited in the
  answer nowhere.

## Items worked

### 5.1 — § 3's `read-only-harness` row says `strings.sh` is in no step of its own and counts a 31-step gate; at `ka-reader@f25fdbb` the lint is a step and the gate has 32

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's lean holds — a dated reading at a named commit of `gate.sh` 1.5.0, 32 steps,
  the moved locators, every check script a step of the gate and *Strings check* named directly before
  its suite, with the `cd65c02` reading kept as a dated note — and it stops short of what the fold
  has to move and say, so it is confirmed with the rest measured and added.

  *Check 1.* The edit lands in `docs/SDD.md` § 3's `read-only-harness` row and in two § 4 C-I3
  clauses, the same file. The item carries `Seat: cto`, this run's posture. The answer binds nothing
  but the document's agreement with the tree: no person, no outside party, no risk the owner carries,
  and no ground I cannot name. Mine, in the CTO's seat.

  *Check 2.* The item sits under *Raised from downstream*, cites its occurrence (`f25fdbb`), and
  corrects a count, a version and locators found false — the row's own rule calls a later `checks/`
  change a re-measurement, not a contradiction — so it widens nothing and "not until it occurs" does
  not apply. Its supporting text is right: every measurement it gives reproduces (one file in the
  diff, version 1.5.0 at `:L2` with 1.4.0 at `:L3`, 33 `run_step` lines with the definition at `:L32`,
  the step at `:L110` between `:L105` and `:L111`, the comment at `:L106-L109`, 13 and 14, the lint's
  exit 0 with 30 files and 49 terms). Its sentence on the shift — one for the version line and five
  more after `:L105` — is right read against the new numbering, and the answer states it as the row
  does, by old line: one higher through old `:L104`, six higher from old `:L105` on. The lean reaches
  the right conclusion and is incomplete in eight places, each added. (1) Which sentences of the row
  go false, by their words: not one but three — the workflow sentence's "every check script but one",
  the "No step runs `checks/strings.sh` itself" passage with its promise to record the step, and the
  script entry's "in no step of its own" — and what each reads instead; plus the one sentence that
  stays (the suite's catalogue-copy case) and why it is no longer the only step a banned term turns
  red. (2) What the step's comment says, not only that it exists: the suite would go red on the same
  word, so placed after it the lint step would never be the one that names the hit — which is what
  makes the order a design and the item's planted-word measurement (`gate.sh: step failed: Strings
  check`) the consequence. (3) The whole line map, every pinned locator by old and new line, the
  three sentences that pin *Own state* at `:L123` included, each checked against the tip. (4) Two
  § 4 C-I3 locator sets outside the row (`docs/SDD.md:L832`, `:L896`) that move with the file; a fold
  of the row alone leaves them stale, as every fold since RN-118 has found. (5) The fetch sentence:
  the new step fetches nothing, and the offline failure point stays *Secret scan*, now `:L61`. (6)
  What does not move, said rather than left to inference: the five counts, every locator into a
  `checks/` file other than `gate.sh`, and `test_vm_refusal.sh` — with the reason it needs no change
  read from its code: its step reader skips comments and takes top-level calls, and its suite loop
  reads the disk. (7) The platform, re-read rather than copied forward, and the line between the
  item's measurements and the fold's: the lint run reproduced here, the planted-word run and the guest
  pass left as the station's, never as a hosted result. (8) The failure paths that changed step
  (check 4, below). The item is one question with one landing and one seat; it does not split. The
  NFDR's QC-53, §§ 8–10 are another record's and already on `docs/architecture_open_issues.md`
  § 3.1 — the answer names that and raises nothing there.

  *Check 3.* Nothing settled moves. The row's pin rule is what the answer applies. `docs/SRS.md`
  NFR-8 binds the product during operation; the lint runs in the harness and reaches no network, so
  the row's fetch sentence and the NFR are untouched. `docs/nfdr.md` QC-53's *verified by* names
  `checks/strings.sh` (`:L1546`) and the row names the script, not the rule — the same seam the row
  keeps for QC-28, QC-30, QC-64 and QC-65; QC-53's own "only path" sentence and its `:L105` pin are
  the NFDR's to move, and are already raised there. The SDD says nothing else about the lint, QC-53
  or the step count outside this row, the header's dated notes and RN-120's record (whole-file
  greps), and no other settled document names any of it, so no second sentence has to agree. The
  previous answer (`self_answer-66.md`), folded at v60, is the record this one extends: same row,
  same rule, the next pin; its line map is carried forward as history and not re-derived — and its
  own sentence that the row records the lint's step "when it lands" is what this item cashes. The
  station that landed the step and the seed it belongs to are inputs here and the answer cites
  neither; the answer names nothing under `system/`.

  *Check 4.* **Stale** — the answer is pinned to `f25fdbb`, the merge; the tip read, `eba1d83`,
  differs from it under `docs/` alone, and a `checks/` change landing before the fold is, by the row's
  rule, one more item. **Absent** — no network: the gate still ends at *Secret scan* (`:L61`) with
  "nothing was scanned" before the new step is reached, so it adds no earlier failure; a tree with no
  catalogue folder, no `.swift` file, no `docs/CONTENT.md`, no banned table or no term under its
  *Never* column now ends the gate at *Strings check*, named by the dispatcher, with the lint's own
  line saying which (`strings.sh:L439-L464`) — before the suite's cases for the same conditions are
  reached — so an empty input is never a pass and the step that names it moved; the answer says so.
  **Refused** — an unreadable `.swift` file is reported by path and fails the lint (`:L496-L503`), now
  at *Strings check* itself; a `mktemp -d` the suite cannot create still ends the suite at exit 1
  naming the directory, one step later. **Concurrent** — the lint reads and writes nothing in the
  checkout, and the suite builds its copies under its own `mktemp -d`, so two runs at once, or the
  lint and its suite in sequence, leave *Own state*'s clean-tree condition unreached by either; a
  step run twice is not a case the row has to state. **Empty** — the catalogue with no literal in it
  passes the lint, and the suite's planted cases are what prove the lint can fail; the comment's
  reason is the same fact seen from the gate's side, and the answer carries it.

  *Close to a different verdict.* Plain *confirmed* was close: the item's lean is right as far as it
  goes, its measurements all reproduce, and its two-shift sentence is correct. What tipped it is (1)
  — three sentences of the row go false and the lean names the fold's result without naming them,
  so a fold following the lean alone could leave the script entry's "in no step of its own" standing
  under a row that says the opposite — and (4), the two § 4 C-I3 locators outside the row, which the
  lean does not reach and which every previous round had to add.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/SDD.md** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
