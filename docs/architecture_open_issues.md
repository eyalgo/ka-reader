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
> `nfdr.md` is Settled at v14 and the records had no companion on disk, so a `product-architecture`
> re-run would read them as done and find nothing to act on. The companion holds five items,
> §§ 3.1 – 3.5. Each one comes from measuring the tree on `main` at `nozoki@153f5a1` against these
> records, after `checks/view.sh`, `checks/renderer.sh` and `checks/fixtures/idle-shell` landed.
> §§ 3.1 – 3.4 each state a fact the records hold that is now false. § 3.5 is something the records
> never state, found through a suite that is red on `main`.

---

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

> **No `product-architecture` run wrote this section or its item.** A `companion-self-answer` run
> added it on 2026-09-24 while answering §§ 3.1 – 3.5 (`docs/trail/architecture/self_answer-15.md`,
> § Raised on this document). It was found by reading `nfdr.md` § 9 whole against the CI runs on
> `main`, not raised by any item. It sits in this bucket because the run holds a lean, and its slot
> is the next round's.

### 2.1 § 9 says no CI run on `main` has built `nozoki-mac`. Run 35968105480 on `main` did, and its log names no Swift toolchain
- **Lands in:** `nfdr.md` § 9, the `nozoki-mac` bullet's *Toolchain — not yet measured* clause, and
  that bullet's *verified by* tail
- **Drafted into the records:** Nothing. No producing run wrote this; the run that raised it writes no
  record. The change it proposes: the clause records GitHub Actions run 35968105480 on
  `nozoki@c461b29`. That is the first run on `main` whose `Test gate` ran `swift test --package-path
  nozoki-mac` (`c461b29:.github/workflows/ci.yml:L25-L26`), and it succeeded. Its image was
  `macos-14-arm64` 20260831.0302.1, on macOS 14.8.9, and its log prints no Swift version: the one
  `swift-version` line is a build file name, `Write swift-version-76B232A4806BA581.txt`. So, by the
  bullet's own rule ("if the first log names none, this line stays *not yet measured* and says it
  waits for a log that does"), the line stays not yet measured and says it waits for a log that
  names the toolchain. "No CI run on `main` has built it (`origin/main` at `a4ab8e6`, 2026-09-24)"
  becomes dated history.
- **Rationale:** A fact in the record has moved past the trigger the record itself names. The bullet
  says the first CI log on `main` that runs those steps supplies the value and "this line takes it".
  That log exists (`gh run view 35968105480` → `success`, `headSha` `c461b29`), and the line has not
  taken it. The line is what the review of any `ci.yml` or `Package.swift` change is checked against,
  so a stale reading there misleads the one gate that reads it. Nothing else in the bullet moves. The
  review gate still stands until a log names the toolchain, and the four departures still flip
  together. Whether to add a `swift --version` step to `ci.yml` is the delivery tier's; the bullet
  already notes there is none (`:L22-L29`).
- **If overridden:** The clause keeps reading as if no `main` run had built `nozoki-mac`. A reviewer
  checking a CI change against it would wait for a first run that has already happened, and would
  not know its log was silent on the toolchain.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-62 says the renderer gate and its control are not in the tree, and that the gate is red until the native shell lands. Both are in the tree, and the gate passes
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` QC-62, the rule's red-by-construction sentence and the *verified by* tail
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing gates on it. A reader of QC-62 is told the gate cannot run yet, and the
  gate runs on every CI build.
- **Where it shows:**
  - `nfdr.md:L413-L416`: "Until the native shell lands, this gate is red by construction".
  - `nfdr.md:L422-L424`: "Neither the script nor the control is in the tree yet (`ls checks/`,
    2026-09-23)".
  - `:L425`: the hosted runner's reading is named as not covered.
  - At `nozoki@153f5a1`, `ls checks checks/fixtures` lists `renderer.sh` and `idle-shell`, and
    `.github/workflows/ci.yml:L43-L44` runs the gate as `Renderer gate`.
  - The Mac reading is in `checks/renderer.sh:L58-L61`: macOS 26.6.2, the five frames of
    `:L53-L57`.
  - The hosted runner's reading is CI run 35988399477 on `nozoki@37a962d`. Its `renderer.sh` is
    byte-equal to `main`'s: `git diff --stat 37a962d 153f5a1` lists no `renderer.sh`. The run's
    image was `macos-14-arm64` 20260831.0302.1. It printed "the main process was observed at the
    Open panel, inside the shell's launch, on observation 1", and it printed the control "was not
    observed at the Open panel in any of 30 observations — the expected red".
- **If a document has to be written:** None. **The PM's lean:** a dated in-place correction. It says
  the script and control have been in the tree since `nozoki@153f5a1` and run in `Renderer gate`, and
  that the frames were measured on a Mac (the script's header) and on a hosted runner (run
  35988399477). The not-covered clause closes. The red-by-construction sentence becomes history.
- **Answer:** confirmed with addition. QC-62 takes a dated in-place correction. `checks/renderer.sh`
  and `checks/fixtures/idle-shell` have been in the tree since `nozoki@153f5a1`. They run on every CI
  build as `Renderer gate` (`.github/workflows/ci.yml:L43-L44`), after `Bundle probe`. The frames
  were measured on a Mac (`checks/renderer.sh:L53-L61`, macOS 26.6.2). They were also measured on a
  GitHub-hosted runner: run 35988399477, image `macos-14-arm64` 20260831.0302.1, macOS 14.8.9. There
  the product matched the five-frame list on observation 1, and the control matched on none of 30.
  The red-by-construction sentence and the *not in the tree yet* sentence become dated history. The
  owner's cycle-8 addition stays as what it was: a rule for the tree before the native shell.
  **Additions.** (1) The not-covered clause is replaced, not just removed. In its place goes the rule
  `docs/SDD.md` § 4 C-I3 carries at v18 (SDD RN-70): a runner image or macOS whose Open-panel frames
  read differently turns the gate red on the next build. That is a re-cut trigger on the gate's
  mechanism, never on the gate. The one half the gate does not cover is also named, so it is not read
  as coverage: a thread sample shows the shell in the panel's modal run, not that the panel is on
  screen (SDD RN-70, S-1's observable half). (2) QC-62's pointers to `SDD § Open Questions, last
  item` move to C-I3 at v18 and SDD RN-70. SDD v18 removed that item, so the pointer now lands on
  another question. (3) ADR-0012 carries the same false sentences and takes the same dated in-place
  corrections: § Consequences' "is unmeasured", its Open Questions pointer, and § Decision's
  red-by-construction paragraph. That is the form ADR-0010 took at v9 and ADR-0016 at v13. No
  decision reverses, and no record is superseded, because the record says it fixes the gate and not
  the frames (ADR-0012 § Consequences). (4) The runner reading is cited from the run, not from the
  script's header. The header does not carry it yet: that is task 6 of the change that landed the
  gate, and it was deferred. Decided together with § 3.2. The reasoning is in
  `docs/trail/architecture/self_answer-15.md` § 3.1.

### 3.2 QC-62 and ADR-0012 put the observation "inside `open_folder`'s call", and the native shell calls `open_folder` only after the panel returns
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` QC-62, the rule; `adr/0012-renderer-run-proved-on-the-shipped-bundle-beside-the-wall.md`
  § Decision and § Consequences
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing gates on it. The records describe an observation the gate does not
  make, and a gate built to their letter would look for a bridge frame that is never there while
  the panel is up.
- **Where it shows:**
  - `nfdr.md:L407` and `adr/0012-…md:L35` say "observed inside `open_folder`'s call".
  - `adr/0012-…md:L97-L98` says "a process-level read of the shell's call into the bridge".
  - `nozoki-mac/Sources/Shell/LaunchFlow.swift:L35-L37` calls `panel.chooseFolder()` first and
    `bridge.openFolder(location:)` after it returns.
  - The gate reads a thread sample of the launched main thread. Its frame list
    (`checks/renderer.sh:L44-L57`) is `AppDelegate.applicationDidFinishLaunching(_:)`,
    `LaunchFlow.run()`, `OpenFolderPanel.chooseFolder()`, `-[NSSavePanel runModal]` and
    `-[NSApplication runModalForWindow:]`. The header says `nozoki_open_folder` is not in the list
    because the shell calls it only after the panel returns.
- **If a document has to be written:** None. **The PM's lean:** the observable reads "parked in the
  Open panel's modal run, inside the shell's launch frames", which is the shell's first and only
  unconditional act. § Consequences reads "a thread sample of the launched main thread: the shell's
  launch symbols with AppKit's Open-panel modal run nested inside them, and no bridge frame".
- **Answer:** confirmed with addition. QC-62's rule and ADR-0012 § Decision read that the launched
  main process is observed **parked in the Open panel's modal run, inside the shell's launch
  frames**, which is the shell's first and only unconditional act. ADR-0012 § Consequences reads that
  the observation is a thread sample of the launched main thread: the shell's launch symbols with
  AppKit's Open-panel modal run nested inside them, and no bridge frame. **Additions.** (1) This is
  transcription, not a new call. `docs/SDD.md` § 4 C-I3 already reads these words at v18 (SDD RN-70),
  and this document's rule is that the § 4 statement wins and the entry is re-derived. (2) The frame
  list is cited, not copied: `checks/renderer.sh:L44-L57`, the script's header, the way C-I3 cites
  it. The next re-measurement then moves one file. (3) QC-62's *verified by* says the frames "are
  re-measured on the first slice's first native bundle". They were, and the tail reads that they are
  recorded in the script's header (`:L53-L61`). (4) ADR-0012 takes this as a dated in-place
  correction, not a superseding record. The gate stands, as do its two rules and its place after the
  wall probe, and the record already says the frames are not what it fixes. Decided together with
  § 3.1. The reasoning is in `docs/trail/architecture/self_answer-15.md` § 3.2.

### 3.3 QC-51's *verified by* says there is no modal presentation in `nozoki-mac/Sources`, and the Open panel's is there
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` QC-51, *verified by*
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing gates on it. Read as written, the check contradicts C-R3, which
  requires the panel at launch.
- **Where it shows:** `nfdr.md:L686-L688` says "no modal presentation in `nozoki-mac/Sources`".
  `nozoki-mac/Sources/Shell/OpenFolderPanel.swift:L14` holds `panel.runModal()`. `checks/view.sh`
  admits exactly that one: "the one no-argument `.runModal()` of the Open panel's own file (F13)"
  (`checks/view.sh:L116`).
- **If a document has to be written:** None. **The PM's lean:** "no modal presentation other than
  the Open panel's own presentation, which C-R3 requires".
- **Answer:** confirmed with addition. QC-51's *verified by* reads: `checks/view.sh` finds no
  `NSAlert`, no user-notification API, and no modal presentation in `nozoki-mac/Sources` other than
  the Open panel's own presentation, which C-R3 requires. That is exactly one `.runModal()` with no
  argument, in `nozoki-mac/Sources/Shell/OpenFolderPanel.swift`. **Addition.** The exception is
  stated as that bound (one call, in that file, with no argument), not only as "the Open panel's
  presentation", because that is what the scan admits (`checks/view.sh:L80-L86`, F13). A looser
  wording would read a second panel, a sheet, or a modal elsewhere in `Shell/` as admitted, and each
  of those stays a violation the scan reports. The rule sentence above the tail does not move: the
  Open panel carries no failure, so "no modal … carries a failure" was never false. The entry's trace
  gains SDD § 4 C-R3. The reasoning is in `docs/trail/architecture/self_answer-15.md` § 3.3.

### 3.4 QC-34's *verified by* gives its forbidden set as the whole scan, and `checks/view.sh` scans thirteen families
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` QC-34, *verified by*, and QC-1 and QC-23, which point at the same scan
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing gates on it. A reader takes QC-34's list as what the scan refuses. The
  scan refuses more, and the list is not where to find out what.
- **Where it shows:**
  - `nfdr.md:L541-L548` lists fourteen names as "the forbidden set", beside `otool -L`.
  - `checks/view.sh:L39-L82` holds F1–F13. Each family names its source, and several are marked
    "design addition" under QC-34's own same-change clause (`nfdr.md:L546-L548`).
  - QC-1 (`nfdr.md:L71-L72`) and QC-23 (`:L315-L316`) cite the same scan.
- **If a document has to be written:** None. **The PM's lean:** name the thirteen families, or
  point at `checks/view.sh`'s header as the list and keep C-R7's set as the floor.
- **Answer:** confirmed with addition, taking the lean's second branch. QC-34's *verified by* names
  `checks/view.sh`'s header as the list of what the scan refuses: its families F1–F13, in the scan
  table at `checks/view.sh:L33-L87`. The fourteen names QC-34 lists now stay, as C-R7's set and the
  scan's floor: the script may refuse more, never less. The script's header already states that
  relation: "QC-34's, QC-1's and QC-23's lists point here: this header is the list, and C-R7's set is
  its floor" (`checks/view.sh:L87`). So the record and the script say the same thing. **Not the first
  branch** (naming the thirteen families here). That would be a second copy of a list this repository
  already keeps in one place. It would drift the next time QC-34's own same-change clause adds a
  family. **Addition.** QC-1 and QC-23 need no text of their own. QC-1 already points at QC-34, and
  QC-23's *verified by* names the scan without a list; each follows QC-34's tail. The same-change
  clause stands: a shell API the scan does not name is caught at `development-design` and added to
  the header in the same change. The reasoning is in `docs/trail/architecture/self_answer-15.md`
  § 3.4.

### 3.5 No record says where the harness's own suites run, and one is red on `main` while every gate is green
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` § 10, the verification map
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** The suites under `checks/tests/` are what prove each `checks/*.sh` script
  reads what its entry says it reads. Only one of the six runs on any gate, so a script can regress
  unseen.
- **Where it shows:**
  - `ls checks/tests` lists six suites: `test_bundle.sh`, `test_no_network.sh`,
    `test_own_state.sh`, `test_read_only.sh`, `test_renderer.sh` and `test_view.sh`.
  - `grep -n 'checks/tests' docs/nfdr.md docs/SDD.md` prints nothing.
  - CI runs one suite, `test_bundle.sh`, as `Bundle probe suite` (`.github/workflows/ci.yml:L34-L36`).
  - The project's test command is `cargo test --workspace --locked && swift test --package-path
    nozoki-mac`, which runs none of them.
  - On `main` at `nozoki@153f5a1`, `checks/tests/test_renderer.sh` prints `FAIL
    test_header_names_the_runner_reading` and `1 case(s) failed`. CI run 35988399477, on a tree
    whose `renderer.sh` is byte-equal to `main`'s, is green.
- **If a document has to be written:** None. **The PM's lean:** § 10 states where each
  `checks/tests/*.sh` suite runs. That can be a CI step per suite, the way `Bundle probe suite`
  runs `test_bundle.sh`, or a named release step. Or § 10 states that they are owner-run and gate
  nothing. Either way, a red suite is no longer invisible to every gate.
- **Answer:** confirmed with addition, taking the lean's first branch and striking its third. § 9
  gains a bullet beside the ones stating `checks/structure.sh`'s and `checks/view.sh`'s scope. It
  states that every suite under `checks/tests/` runs as its own CI step on every build, the way
  `Bundle probe suite` runs `test_bundle.sh` (`.github/workflows/ci.yml:L35-L36`). § 10's row for
  each script names its suite beside it. A script that lands with a suite lands the suite's CI step
  in the same change. **Not the third branch** (owner-run, gating nothing). It leaves a red suite
  invisible to every gate, which is the very thing the lean says it cures, and the case is on `main`
  now: `test_renderer.sh` prints `1 case(s) failed` while CI is green. **Additions.** (1) Ordering.
  The red case is `test_header_names_the_runner_reading`, the test of task 6 of the change that
  landed the gate: the runner reading in `checks/renderer.sh`'s header, which was deferred. So
  `test_renderer.sh`'s step lands with that task or after it, never by skipping or deleting the
  failing case. The other five suites join as soon as each is green on the runner. (2) Whether each
  of the six can run on the hosted runner is not known until it is tried there. A suite that cannot
  is recorded in § 9 with the measurement and runs as a named release step on the Mac instead; it is
  never left silent. (3) The one ground this run could not see is the cost. `kensaiapp/nozoki` is a
  private repository (`gh repo view`, 2026-09-24), so each added macOS step spends the account's
  included minutes, and past them it costs $0.062 a minute
  (https://docs.github.com/en/billing/concepts/product-billing/github-actions, read 2026-09-24). If
  that bill is the constraint, the fallback is the lean's second branch: the suites as one named
  release step. An override here is how to take it. The reasoning is in
  `docs/trail/architecture/self_answer-15.md` § 3.5.
