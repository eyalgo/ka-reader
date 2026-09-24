# Architecture open issues — Nozoki

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
> §§ 3.1 – 3.5. Each comes from measuring the tree on `main` at `nozoki@ab39502` against these
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
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing is blocked. The bullet is § 9's only word on where the suites run, and
  it describes a tree that is gone, so a reader of § 9 believes five suites run on no gate.
- **Where it shows:**
  - `nfdr.md:L937-L940` says six suites are in the tree "and one is on a step, `test_bundle.sh`
    (2026-09-24)". `:L942-L943` says that "at `nozoki@153f5a1` that suite fails one case,
    `test_header_names_the_runner_reading`". That is dated and still true of that commit, but it is
    the bullet's only word on the case.
  - `nfdr.md:L1035-L1037` says "one of six suites is on a step at `nozoki@153f5a1`, and that
    bullet's tail is what fails while the rest are not".
  - At `nozoki@ab39502`, each of the six is the whole `run` of one step:
    `.github/workflows/ci.yml:L35-L36` (`test_bundle.sh`), `:L41-L42` (`test_view.sh`), `:L52-L53`
    (`test_renderer.sh`), `:L61-L62` (`test_read_only.sh`), `:L67-L68` (`test_no_network.sh`),
    `:L70-L71` (`test_own_state.sh`). § 9's own check,
    `for s in checks/tests/*.sh; do grep -q "$s" .github/workflows/ci.yml || echo "$s"; done`,
    prints nothing.
  - `NOZOKI_TEST_ONLY=test_header_names_the_runner_reading checks/tests/test_renderer.sh` prints
    `ok   test_header_names_the_runner_reading` and exits 0. The header carries the reading at
    `checks/renderer.sh:L62-L65`.
- **If a document has to be written:** None. **The PM's lean:** § 9's bullet and § 10's preamble
  say that all six are on steps from `nozoki@ab39502`, each as the `run` of its own step. The
  `nozoki@153f5a1` sentence stays as dated history, and a clause after it says the case passes once
  the header carries the runner reading.
- **Answer:** <the owner fills this in>

### 3.2 § 9 says the five suites join "as each is green on the hosted runner", and they joined before any hosted runner ran them
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` § 9, the `checks/tests/` bullet (`:L940-L947`)
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** The bullet's joining rule does not describe the tree, and the cost it was
  written to prevent is now possible. If one of the five fails on the hosted runner, every push is
  red until that suite moves to a Mac release step. § 9's joining condition exists to prevent that.
- **Where it shows:**
  - `nfdr.md:L940-L941`: "The five join as each is green on the hosted runner".
  - The five are fatal steps at `nozoki@ab39502`. No step carries `if:` or `continue-on-error`
    (`grep -nE 'continue-on-error|^[[:space:]]+if:' .github/workflows/ci.yml` prints nothing).
  - No hosted runner has run them. The latest CI run is 35988399477 on `nozoki@37a962d`, which had
    one suite step. `gh run list --repo kensaiapp/nozoki --workflow ci.yml --limit 1` shows it, and
    `git rev-list --count origin/main..main` is `27`.
  - On a Mac, on `main` at `nozoki@ab39502` with the bundle built, all six exit 0 with no `FAIL`:
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
- **Answer:** <the owner fills this in>

### 3.3 § 9's tail says the comparison becomes a `checks/` script "the day the five are on steps", and that day has come with no script
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` § 9, the `checks/tests/` bullet's *verified by* tail (`:L948-L954`)
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** The obligation that every suite has a step is checked only by a review gate
  at `development-design`. The tail's argument for that — "a CI step for it would be red on every
  build until the five land" — no longer holds, so the tail now gives a reason that is false.
- **Where it shows:**
  - `nfdr.md:L951-L954`: "the tree is measured short of the rule today, so a CI step for it would
    be red on every build until the five land; the day the five are on steps, the comparison
    becomes a `checks/` script and this tail names it".
  - The comparison prints nothing at `nozoki@ab39502` (§ 3.1, *Where it shows*).
  - `ls checks/*.sh` lists `bundle.sh`, `no-network.sh`, `own-state.sh`, `read-only.sh`,
    `renderer.sh` and `view.sh`. None runs the comparison.
- **If a document has to be written:** None. **The PM's lean:** the tail says the five are on
  steps and the comparison's script is owed. It stays a review gate until that script lands, and
  the tail names the script then. The script itself is work, and it is on no route yet.
- **Answer:** <the owner fills this in>

### 3.4 QC-62 and ADR-0012 cite the runner reading "from the run because the header does not carry it yet", and the header carries it
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` QC-62, *verified by* (`:L430-L435`), and
  `adr/0012-renderer-run-proved-on-the-shipped-bundle-beside-the-wall.md` § Decision (`:L128-L130`)
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing is blocked. Both records send a reader to the CI run's log for a
  reading that now sits in the script, beside the Mac reading they already cite there.
- **Where it shows:**
  - `nfdr.md:L434-L435`: "cited from the run because the header does not carry the runner reading
    yet".
  - `adr/0012-…md:L129-L130`: "the runner reading is cited from the run because the script's
    header does not carry it yet".
  - `checks/renderer.sh:L62-L65` at `nozoki@ab39502`: "Hosted runner reading: GitHub Actions run
    35988399477 on nozoki@37a962d, image macos-14-arm64 20260831.0302.1, macOS 14.8.9", then the
    match on observation 1 of the bound of 30 and the control in none of the 30.
- **If a document has to be written:** None. **The PM's lean:** both cite the runner reading from
  `checks/renderer.sh:L62-L65`, as they cite the Mac reading from `:L58-L61`. ADR-0012 is corrected
  in place, the way its other dated notes are.
- **Answer:** <the owner fills this in>

### 3.5 QC-62 and ADR-0012 cite `Renderer gate` at `ci.yml:L43-L44`, and it is at `:L46-L47`
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` QC-62, *verified by* (`:L424-L426`), and
  `adr/0012-renderer-run-proved-on-the-shipped-bundle-beside-the-wall.md` (`:L74-L75`)
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing is blocked. The citation lands on the wrong lines: `:L43-L44` is now
  a blank line and the comment above `Renderer gate`.
- **Where it shows:**
  - `nfdr.md:L426` and `adr/0012-…md:L75` each give `Renderer gate` as
    `.github/workflows/ci.yml:L43-L44`.
  - At `nozoki@ab39502` the step is `ci.yml:L46-L47` (`- name: Renderer gate`,
    `run: checks/renderer.sh target/release/bundle/macos/Nozoki.app`). `View check suite` sits above
    it at `:L41-L42`. `Bundle probe`, cited beside it as `:L31-L32`, has not moved.
- **If a document has to be written:** None. **The PM's lean:** both cite `ci.yml:L46-L47`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
