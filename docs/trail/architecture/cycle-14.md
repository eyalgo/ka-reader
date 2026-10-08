# Architecture open issues — KA-Reader

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the SRS, the SDD
> and the FDR.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-architecture`. It folds your answers into the records and drops the resolved items.
> When nothing is left open, `product-architecture` **deletes this file**: no file = the records are
> done.
>
> Your answers are never thrown away. Each time the Principal Architect folds them in, it first copies
> this file whole to `docs/trail/architecture/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 is raised, not asked.** These records bind every later change, so the seats that live under
> them find gaps the authoring run could not. § 3 is where such a seat says so, against both records
> — an ADR's binding and an NFDR obligation reach the same file.

> **No `product-architecture` run opened this companion. The PM opened it on 2026-09-24.**
> `nfdr.md` is Settled at v16 and the records had no companion on disk, so a `product-architecture`
> re-run would read them as done and find nothing to act on. The companion holds five items,
> §§ 3.1 – 3.5. Each comes from measuring the tree on `main` at `ka-reader@ab39502` against these
> records, after `checks/renderer.sh`'s header took the hosted runner's reading and every suite
> under `checks/tests/` went onto a CI step of its own. §§ 3.1, 3.4 and 3.5 each state a fact the
> records hold that is now false. §§ 3.2 and 3.3 are rules § 9 wrote for a day that has now come.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 § 9 and § 10 say one of the six suites is on a CI step, and all six are
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` § 9, the `checks/tests/` bullet (`:L937-L943`), and § 10's preamble
  (`:L1033-L1037`)
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing is blocked. The bullet is § 9's only word on where the suites run, and
  it describes a tree that is gone, so a reader of § 9 believes five suites run on no gate.
- **Where it shows:**
  - `nfdr.md:L937-L940` says six suites are in the tree "and one is on a step, `test_bundle.sh`
    (2026-09-24)". `:L942-L943` says that "at `ka-reader@153f5a1` that suite fails one case,
    `test_header_names_the_runner_reading`". That is dated and still true of that commit, but it is
    the bullet's only word on the case.
  - `nfdr.md:L1035-L1037` says "one of six suites is on a step at `ka-reader@153f5a1`, and that
    bullet's tail is what fails while the rest are not".
  - At `ka-reader@ab39502`, each of the six is the whole `run` of one step:
    `.github/workflows/ci.yml:L35-L36` (`test_bundle.sh`), `:L41-L42` (`test_view.sh`), `:L52-L53`
    (`test_renderer.sh`), `:L61-L62` (`test_read_only.sh`), `:L67-L68` (`test_no_network.sh`),
    `:L70-L71` (`test_own_state.sh`). § 9's own check,
    `for s in checks/tests/*.sh; do grep -q "$s" .github/workflows/ci.yml || echo "$s"; done`,
    prints nothing.
  - `KA_READER_TEST_ONLY=test_header_names_the_runner_reading checks/tests/test_renderer.sh` prints
    `ok   test_header_names_the_runner_reading` and exits 0. The header carries the reading at
    `checks/renderer.sh:L62-L65`.
- **If a document has to be written:** None. **The PM's lean:** § 9's bullet and § 10's preamble
  say that all six are on steps from `ka-reader@ab39502`, each as the `run` of its own step. The
  `ka-reader@153f5a1` sentence stays as dated history, and a clause after it says the case passes once
  the header carries the runner reading.
- **Answer:** Confirmed with addition, decided together with § 3.3. § 9's bullet and § 10's
  preamble say that all six suites are on CI steps from `ka-reader@ab39502`, each the whole `run` of
  its own step (`ci.yml:L35-L36`, `:L41-L42`, `:L52-L53`, `:L61-L62`, `:L67-L68`, `:L70-L71`,
  re-measured this run). The `ka-reader@153f5a1` sentence stays as dated history. Three additions:
  (1) the ordering rule for `test_renderer.sh` is now history too, and it held. The header's
  runner reading landed in `2b83dce` and the suite's step in `66ba2e8`, both in the change merged
  at `ab39502`. The bullet says so in the past tense and does not keep it as a live rule.
  (2) § 10's preamble loses its clause saying "that bullet's tail is what fails while the rest are
  not". Once all six are on steps nothing fails, and § 3.3 decides what the tail says now.
  (3) The count is dated at `ka-reader@ab39502`, so a later suite reads as a re-measurement and not
  as a contradiction. Reasoning: `docs/trail/architecture/self_answer-17.md` § 3.1.

### 3.2 § 9 says the five suites join "as each is green on the hosted runner", and they joined before any hosted runner ran them
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` § 9, the `checks/tests/` bullet (`:L940-L947`)
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** The bullet's joining rule does not describe the tree, and the cost it was
  written to prevent is now possible. If one of the five fails on the hosted runner, every push is
  red until that suite moves to a Mac release step. § 9's joining condition exists to prevent that.
- **Where it shows:**
  - `nfdr.md:L940-L941`: "The five join as each is green on the hosted runner".
  - The five are fatal steps at `ka-reader@ab39502`. No step carries `if:` or `continue-on-error`
    (`grep -nE 'continue-on-error|^[[:space:]]+if:' .github/workflows/ci.yml` prints nothing).
  - No hosted runner has run them. The latest CI run is 35988399477 on `ka-reader@37a962d`, which had
    one suite step. `gh run list --repo kensaiapp/ka-reader --workflow ci.yml --limit 1` shows it, and
    `git rev-list --count origin/main..main` is `27`.
  - On a Mac, on `main` at `ka-reader@ab39502` with the bundle built, all six exit 0 with no `FAIL`:
    `test_bundle.sh` 77 `ok` lines, `test_view.sh` 19, `test_renderer.sh` 39, `test_read_only.sh`
    15, `test_no_network.sh` 20, `test_own_state.sh` 9. `git status --porcelain --ignored
    checks/fixtures` prints nothing after them. What the Mac cannot say is the hosted runner's
    answer.
  - `nfdr.md:L944-L947` already says what happens to a suite that cannot run there: it is recorded
    in this bullet with the measurement and runs as a named release step on the Mac.
- **If a document has to be written:** None. **The PM's lean:** § 9 states the order as it now is.
  A suite joins as a fatal step, and its first push is its hosted-runner reading. A suite red there
  moves to a named release step on the Mac, recorded in this bullet with the measurement (the rule
  `:L944-L947` already has). The other branch is that the tree is in breach of the rule as written,
  and the five come off CI until each is measured. That would take them off every gate and leave a
  red suite invisible, which is what the bullet was written to end.
- **Answer:** Confirmed with addition. § 9 states the order as it now is. A suite joins as a fatal
  step, and its first CI run is its hosted-runner reading. A suite that is red there moves to a
  named release step on the Mac, recorded in this bullet with the measurement (the rule
  `:L944-L947` already has). Three additions: (1) the bullet states where the five stand when the
  fold runs. At `ka-reader@ab39502`, `origin/main` is `c461b29` and no CI run has run the five
  (`gh run list --repo kensaiapp/ka-reader --workflow ci.yml` newest is 35988399477 on `37a962d`,
  re-read this run). The fold re-reads that list and records what it finds: the run id and each
  suite's result if a run exists, or "not yet run on the hosted runner" if none does. (2) The one
  ruled-out way to join is named: a suite may not join as a non-fatal step (`continue-on-error`,
  or an `if:` that skips it) while it waits for its reading. That is a gate that cannot go red,
  which ADR-0012 § Decision rules out ("a gate that cannot go red has not run"). (3) A red suite
  on `main` is fixed by the next change: that suite's move to a Mac release step, or its fix.
  The CI step is never quieted. Reasoning: `docs/trail/architecture/self_answer-17.md` § 3.2.

### 3.3 § 9's tail says the comparison becomes a `checks/` script "the day the five are on steps", and that day has come with no script
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` § 9, the `checks/tests/` bullet's *verified by* tail (`:L948-L954`)
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** The obligation that every suite has a step is checked only by a review gate
  at `development-design`. The tail's argument for that — "a CI step for it would be red on every
  build until the five land" — no longer holds, so the tail now gives a reason that is false.
- **Where it shows:**
  - `nfdr.md:L951-L954`: "the tree is measured short of the rule today, so a CI step for it would
    be red on every build until the five land; the day the five are on steps, the comparison
    becomes a `checks/` script and this tail names it".
  - The comparison prints nothing at `ka-reader@ab39502` (§ 3.1, *Where it shows*).
  - `ls checks/*.sh` lists `bundle.sh`, `no-network.sh`, `own-state.sh`, `read-only.sh`,
    `renderer.sh` and `view.sh`. None runs the comparison.
- **If a document has to be written:** None. **The PM's lean:** the tail says the five are on
  steps and the comparison's script is owed. It stays a review gate until that script lands, and
  the tail names the script then. The script itself is work, and it is on no route yet.
- **Answer:** Confirmed with addition, decided together with § 3.1. The tail loses its false
  argument ("red on every build until the five land"). In its place it says three things: the
  five are on steps from `ka-reader@ab39502`, the comparison prints nothing there (re-run this
  run), and the `checks/` script its own sentence promised for that day is now owed. The review
  gate at `development-design` stands until the script lands. Its only ground now is that the
  script does not exist yet. Two additions: (1) the tail states the shape of what is owed so the
  change that writes it has a bar: a `checks/` script that runs the comparison and exits non-zero
  when any suite under `checks/tests/` is named by no step of `ci.yml`, on a CI step of its own.
  If that script has a suite, the suite lands its own step in the same change, by the bullet's
  existing rule. (2) The day the script lands, the tail names it and drops the review gate, as
  the tail already promises. Routing that work is the PM's and not this record's. Reasoning:
  `docs/trail/architecture/self_answer-17.md` § 3.3.

### 3.4 QC-62 and ADR-0012 cite the runner reading "from the run because the header does not carry it yet", and the header carries it
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` QC-62, *verified by* (`:L430-L435`), and
  `adr/0012-renderer-run-proved-on-the-shipped-bundle-beside-the-wall.md` § Decision (`:L128-L130`)
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing is blocked. Both records send a reader to the CI run's log for a
  reading that now sits in the script, beside the Mac reading they already cite there.
- **Where it shows:**
  - `nfdr.md:L434-L435`: "cited from the run because the header does not carry the runner reading
    yet".
  - `adr/0012-…md:L129-L130`: "the runner reading is cited from the run because the script's
    header does not carry it yet".
  - `checks/renderer.sh:L62-L65` at `ka-reader@ab39502`: "Hosted runner reading: GitHub Actions run
    35988399477 on ka-reader@37a962d, image macos-14-arm64 20260831.0302.1, macOS 14.8.9", then the
    match on observation 1 of the bound of 30 and the control in none of the 30.
- **If a document has to be written:** None. **The PM's lean:** both cite the runner reading from
  `checks/renderer.sh:L62-L65`, as they cite the Mac reading from `:L58-L61`. ADR-0012 is corrected
  in place, the way its other dated notes are.
- **Answer:** Confirmed with addition, decided together with § 3.5, since both correct ADR-0012
  in the same fold. QC-62's *verified by* and ADR-0012 each cite the runner reading from
  `checks/renderer.sh:L62-L65`, as they cite the Mac reading from `:L58-L61`. Both ranges were
  re-read this run at `ka-reader@ab39502`, and the frame list at `:L44-L57` has not moved. The run id
  and image can stay in the sentence, since the header carries the same ones. One addition: the
  false clause in ADR-0012 (`:L129-L130`) sits inside the record's own 2026-09-24 *corrected in
  place* note. The fold adds a new dated note after that one, naming `2b83dce` (the commit that
  put the reading in the header), and leaves the earlier note as written. That note was true of
  the tree at the time. Reasoning: `docs/trail/architecture/self_answer-17.md` § 3.4.

### 3.5 QC-62 and ADR-0012 cite `Renderer gate` at `ci.yml:L43-L44`, and it is at `:L46-L47`
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` QC-62, *verified by* (`:L424-L426`), and
  `adr/0012-renderer-run-proved-on-the-shipped-bundle-beside-the-wall.md` (`:L74-L75`)
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing is blocked. The citation lands on the wrong lines: `:L43-L44` is now
  a blank line and the comment above `Renderer gate`.
- **Where it shows:**
  - `nfdr.md:L426` and `adr/0012-…md:L75` each give `Renderer gate` as
    `.github/workflows/ci.yml:L43-L44`.
  - At `ka-reader@ab39502` the step is `ci.yml:L46-L47` (`- name: Renderer gate`,
    `run: checks/renderer.sh target/release/bundle/macos/KA-Reader.app`). `View check suite` sits above
    it at `:L41-L42`. `Bundle probe`, cited beside it as `:L31-L32`, has not moved.
- **If a document has to be written:** None. **The PM's lean:** both cite `ci.yml:L46-L47`.
- **Answer:** Confirmed with addition, decided together with § 3.4. Both cite `Renderer gate` at
  `.github/workflows/ci.yml:L46-L47`. That was re-read this run at `ka-reader@ab39502`, where
  `Bundle probe` is still at `:L31-L32`. One addition: ADR-0012's `:L43-L44` sits in a dated
  parenthesis that begins "from `ka-reader@153f5a1`", and at that commit the step *was* at `:L43-L44`
  (`git show 153f5a1:.github/workflows/ci.yml`). So the ADR cite was true when written and has
  since gone stale. QC-62's cite reads as present tense, so it was false. The fold corrects
  QC-62 in place and dates the ADR's new line at `ka-reader@ab39502`, in the same new note § 3.4
  adds. The other `ci.yml` line cites in § 9 were re-read (`:L18`, `:L22-L29`, `:L26`, `:L29`,
  `:L35-L36`) and all still hold. The script § 3.3 makes owed will add a step and may move these
  lines again, and the change that lands it re-cites them. Reasoning:
  `docs/trail/architecture/self_answer-17.md` § 3.5.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
