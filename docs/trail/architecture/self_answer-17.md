# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (NFDR v16, Settled; ADR-0012 Accepted)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-24
- **Sources re-read:** GitHub Actions, `kensaiapp/ka-reader`, workflow `ci.yml`, re-read this run
  with `gh run list --repo kensaiapp/ka-reader --workflow ci.yml --limit 3`. The newest run is
  35988399477 on `37a962d` (branch `2026-09-24_the-shell-is-seen-at-the-panel`, `success`), and
  then 35968105480 on `c461b29` (`main`). No run exists on any commit that carries the five new
  suite steps. `git rev-list --count origin/main..main` → `28` (`origin/main` = `c461b29`), so
  nothing has been pushed since. § 3.2 depends on this.

Everything else was measured on the tree at `ka-reader@ab39502`. The only commit after it on `main`,
`1a84367`, touches this companion alone (`git diff --stat ab39502 HEAD`). All five items are
corrections to these records and none widens them, so § *A widening item waits until it occurs*
does not apply. All five belong to this document's seat. None needs a call only the owner can
make, and none belongs to another document: `docs/SDD.md` v18 cites `checks/renderer.sh:L44-L57`,
`:L53-L61` and `:L58-L61`, which all still hold, and it states no suite count and no
`Renderer gate` line (`grep -n 'checks/tests\|L43-L44' docs/SDD.md` finds neither).

## Items worked

### 3.1 — § 9 and § 10 say one of the six suites is on a CI step, and all six are

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** Confirmed, because the fact is false as the item says. At `ka-reader@ab39502` each of the
  six suites is the whole `run` of its own step: `.github/workflows/ci.yml:L35-L36`, `:L41-L42`,
  `:L52-L53`, `:L61-L62`, `:L67-L68`, `:L70-L71`. § 9's own comparison
  (`for s in checks/tests/*.sh; do grep -q "$s" .github/workflows/ci.yml || echo "$s"; done`)
  prints nothing, and `nfdr.md:L937-L943` and `:L1035-L1037` still say one of six. The PM's lean
  holds for the reason it gives. The run adds three things the lean left out. First, the bullet's
  ordering rule for `test_renderer.sh` (`:L941-L944`) described a day that has now passed, and
  the rule was kept: `2b83dce` put the runner reading in the header before `66ba2e8` landed the
  suite's step, both in the change merged at `ab39502`. Left in the present tense, the rule would
  read as still waiting. Second, § 10's preamble ends with "that bullet's tail is what fails while
  the rest are not". With all six on steps that clause has nothing to point at, and § 3.3 decides
  what the tail now says. The two items were decided together so the preamble and the tail agree.
  Third, stale case: the count is dated at `ka-reader@ab39502`, so a seventh suite later reads as a
  re-measurement and not as a contradiction. The case of a new suite is already covered by the
  bullet's rule that "a script that lands with a suite lands the suite's CI step in the same
  change".

### 3.2 — § 9 says the five suites join "as each is green on the hosted runner", and they joined before any hosted runner ran them

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** Confirmed. The rule as written (`nfdr.md:L940-L941`) does not describe the tree, and of
  the two ways to make them agree, changing the rule is right and changing the tree is not. The
  facts, re-read this run: all five are fatal steps (`grep -nE 'continue-on-error|^[[:space:]]+if:'
  .github/workflows/ci.yml` prints nothing), and no hosted run has run them (see *Sources
  re-read*). The PM's argument holds. Taking the five off CI until each is measured would take
  them off every gate, and "green on the hosted runner" cannot be measured without running them
  there, and running them is the join. So the rule's precondition could only ever be met by the
  act it guarded. The bullet's existing clause at `:L944-L947` already says what happens to a
  suite that cannot run there. This is not widening: the case of a red suite is already stated,
  and only the overtaken precondition changes. The run considered leaving the item for the owner,
  on the grounds that a red CI costs the owner's pushes. It did not, because it could name no
  ground it cannot see: the rule came from an earlier answer in the owner's seat
  (`docs/trail/architecture/cycle-12.md` § 3.5), and restating it in the owner's seat binds only
  the records.
  **Additions.** (1) *Stale.* The bullet records where the five stand when the fold runs, not
  when this run did. The owner may push between the two, so the fold re-reads the run list and
  records either the first run's id with each suite's result, or "not yet run on the hosted
  runner". (2) *A third route the lean did not name.* One more way to join would be a non-fatal
  step (`continue-on-error`, or an `if:`) while a suite waits for its reading. It sounds like a
  middle path, but it is a gate that cannot go red, which ADR-0012 § Decision rules out ("a gate
  that cannot go red has not run"). The bullet names it as ruled out so the next change does not
  reach for it. (3) *Refused.* If a suite is red on the hosted runner, `main` is red until the
  next change moves that suite to a Mac release step or fixes it. The step is never quieted. That
  cost is real and it is the one the old rule tried to avoid. The run accepts it because the
  alternative is a red suite nobody sees. What would have tipped this to *overridden*: a hosted
  run existing, when the fold runs, in which a suite is red. The bullet would then record that
  suite's move and not the general rule. Addition (1) covers that case.

### 3.3 — § 9's tail says the comparison becomes a `checks/` script "the day the five are on steps", and that day has come with no script

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** Confirmed. The tail's argument for staying a review gate (`nfdr.md:L951-L953`, "a CI
  step for it would be red on every build until the five land") is false at `ka-reader@ab39502`. The
  comparison prints nothing there, and `ls checks/*.sh` lists `bundle.sh`, `no-network.sh`,
  `own-state.sh`, `read-only.sh`, `renderer.sh`, `view.sh`, none of which runs it. The tail's own
  next clause said "the day the five are on steps, the comparison becomes a `checks/` script and
  this tail names it", so by this record's own words the script is owed now. The lean keeps the
  review gate until the script lands, and that holds. Dropping the gate before any script exists
  would leave the obligation unchecked. The ground for the gate changes from "it would be red"
  to "the script is not written yet", and the tail should say exactly that.
  **Additions.** (1) The tail describes what is owed, so the change that writes it has something
  to meet: a `checks/` script that runs the comparison and exits non-zero when a suite under
  `checks/tests/` appears in no step of `ci.yml`, run as its own CI step. If that script has a
  suite, the suite's step lands in the same change, by the bullet's existing rule. (2) *Absent
  and concurrent.* Until the script lands, a suite added without a step is caught only at
  `development-design`. A step naming a suite that was deleted fails the job on its own, because
  running a missing file exits non-zero. So the gap is one-sided, and the tail can name the side
  it covers. Routing the script is the PM's work. The PM's own item says "it is on no route yet",
  so the run raised nothing about routing and records it here for the owner.

### 3.4 — QC-62 and ADR-0012 cite the runner reading "from the run because the header does not carry it yet", and the header carries it

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** Confirmed. `checks/renderer.sh:L62-L65` at `ka-reader@ab39502` holds "Hosted runner
  reading: GitHub Actions run 35988399477 on ka-reader@37a962d, image macos-14-arm64
  20260831.0302.1, macOS 14.8.9", with the match on observation 1 of 30 and the control in none.
  It was added by `2b83dce` (`git diff 153f5a1 ab39502 -- checks/renderer.sh` shows exactly those
  four lines). `nfdr.md:L434-L435` and `adr/0012-…md:L129-L130` both still say the header does
  not carry it. The lean holds: cite the header, as the Mac reading is cited from `:L58-L61`.
  Neighbouring cites were re-read and have not moved: the frame list at `:L44-L57`, and the Mac
  reading at `:L58-L61`. The same lines are cited by `docs/SDD.md:L707` and `:L724`, which
  therefore owe nothing. Decided together with § 3.5, because both correct ADR-0012 in the same
  fold.
  **Addition.** In ADR-0012 the false clause is inside the record's own *corrected in place
  2026-09-24* note, which was true of the tree when it was written. The fold adds a second dated
  note after it, naming `2b83dce`, and leaves the first as written. Rewriting the earlier note
  would erase the record of what the tree was. This is the ADR's own practice for its other dated
  notes (`:L72`, `:L114`, `:L127`, `:L144`).

### 3.5 — QC-62 and ADR-0012 cite `Renderer gate` at `ci.yml:L43-L44`, and it is at `:L46-L47`

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** Confirmed. `.github/workflows/ci.yml:L46-L47` at `ka-reader@ab39502` is
  `- name: Renderer gate` and `run: checks/renderer.sh target/release/bundle/macos/KA-Reader.app`,
  and `:L43` is blank and `:L44` a comment. `Bundle probe` is still at `:L31-L32`.
  **Addition.** The two cites are not equally wrong. ADR-0012's `:L75` sits in a parenthesis that
  begins "from `ka-reader@153f5a1`", and at that commit `Renderer gate` was at `:L43`
  (`git show 153f5a1:.github/workflows/ci.yml | grep -n 'name:'`). So it went stale. QC-62's
  `nfdr.md:L426` is in the present tense ("run on every CI build as `Renderer gate`"), so it is
  false. The fold corrects QC-62 in place and dates ADR-0012's new line at `ka-reader@ab39502`, in the
  same new note as § 3.4. *Stale, and why a count was taken:* the run re-read every other
  `ci.yml` line cite in the records outside the Review Notes: `nfdr.md` `:L18`, `:L22-L29`,
  `:L26`, `:L29`, `:L35-L36`, and `:L31-L32` twice. All hold, so this item is the whole of the
  drift. The Review Notes' cites (`nfdr.md:L2499`, `:L2615`) are measurements dated to their fold
  and are left alone. The script § 3.3 makes owed adds a CI step, and the change that lands it
  re-cites whatever lines it moves.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
