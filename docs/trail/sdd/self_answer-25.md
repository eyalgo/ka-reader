# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (Settled, v17)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-24
- **Sources re-read:** GitHub Actions run 35988399477 on `kensaiapp/nozoki`, read with
  `gh run view 35988399477 --repo kensaiapp/nozoki --json headSha,...` and `--log` on
  2026-09-24:
  - The run succeeded on head `37a962d`, and its runner image is `macos-14-arm64` Version
    20260831.0302.1, with Operating System macOS 14.8.9 (23J631).
  - The `Bundle probe` step printed that the sandbox was observed on pid 18454.
  - The `Renderer gate` step printed "renderer.sh: pid 40437 — the main process was observed at
    the Open panel, inside the shell's launch, on observation 1 (bound: 30 observations, about 1 s
    each)".
  - It also printed "renderer.sh: control pid 40461 (idle-shell, one window and no panel) was not
    observed at the Open panel in any of 30 observations — the expected red".

  Repository facts were read directly:
  - `git diff --stat 37a962d 153f5a1 -- checks/renderer.sh nozoki-mac checks/fixtures/idle-shell`
    printed nothing.
  - `git diff --stat 153f5a1 HEAD -- nozoki-mac checks docs/SDD.md` printed nothing.
- **What was read:** the whole companion, the whole decision prompt, and `docs/SDD.md` line by
  line, all 3,952 lines. Also read:
  - `checks/renderer.sh:L1-L90`;
  - `nozoki-mac/Sources/Shell/LaunchFlow.swift`, `nozoki-mac/Sources/Nozoki/AppDelegate.swift`
    and `NativeBridge.swift`;
  - `docs/trail/sdd/cycle-8.md` § 5.1, the owner's answer 4;
  - `docs/architecture_open_issues.md`, header and § 3.2.

## Items worked

### 5.1 — C-I3 puts the renderer gate's observation "inside `open_folder`'s call", and the native shell calls `open_folder` only after the panel returns

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The PM's claim holds, and it is a correction rather than a widening. C-I3 names an
  observation that no build of this shape can produce.
  - `LaunchFlow.swift:L35-L37` presents the panel first and calls `bridge.openFolder` only after
    the panel returns.
  - `AppDelegate.swift` makes no bridge call before `flow.run()`.
  - `NativeBridge.swift:L13-L25` shows that `nozoki_open_folder` is the first C call and runs
    only after the panel.

  So while the panel is up, the main thread holds no `open_folder` frame. `renderer.sh` sends no
  input (header, "It sends no input"). C-I3 itself forbids "a code path that exists for the gate"
  (`SDD.md:L709-L711`). An observable literally "inside `open_folder`'s call" is therefore
  unmeetable by any gate the clause admits.

  The lean's wording, "parked in the Open panel's modal run, inside the shell's launch frames —
  the shell's first and only unconditional act", is what C-I3 already names as the substance
  (`SDD.md:L701-L705`: "presenting the Open panel at launch … the shell ran far enough to present
  the panel"). Only the label carried the previous renderer's order of acts. Citing the frames
  from the script's header rather than copying them keeps one home for the list. C-I3 already does
  this for the probe's bound ("the bound is the script's to fix and this document states no
  number"). The list also has a practical reason to live in one file: a Swift rename of
  `LaunchFlow.run()` or `OpenFolderPanel.chooseFolder()` would then move one file, not two.

  **The item is the SDD's, not the owner's, and this is the ground I weighed hardest.** The
  owner's cycle-8 answer 4 names a floor: "at the least, that the page reached `open_folder`"
  (`docs/trail/sdd/cycle-8.md` § 5.1). A literal reading makes the fix a change to the owner's
  ruling. It is not one, for three reasons:
  - The floor was written for a page whose `open_folder` call was the act that presented the panel
    (`nozoki@a4ab8e6:crates/nozoki-app/src/main.rs:L17-L19`, `open_folder` calling
    `pick_folder()`).
  - The ruling's stated purpose is "the empty window got past every gate". The `idle-shell`
    control, which has exactly the empty window's shape, goes red (run 35988399477).
  - C-I3 already carries the ruling into the native shape: "the ruling names no renderer, so it
    binds the native shell as it bound the page" (`SDD.md:L698-L699`).

  What would have tipped this to *left for the owner*: a way to observe `open_folder` being called
  without input and without a gate-only path. None exists in this shape.

  **Addition 1 — S-1's command half.** `SDD.md:L1308-L1310` says "inside `open_folder`'s call —
  the panel presented" in the same words, and it is the CTO's field under the same clause. It moves
  with C-I3. Left alone, it would be the next false sentence a builder reads.

  **Addition 2 — § 9 TO-7.** This is found by check 3 and is a consequence of the answer.
  TO-7's *costs* says "the shell's actual use of the bridge being exercised only by the renderer
  gate and the timed release walk" (`SDD.md:L2117-L2118`). Once the observable sits at the panel,
  the gate exercises no bridge call at all. The line now names the timed release walk (AC-10)
  alone. It also says what the gate shows instead: that the launched shell ran its launch flow as
  far as the panel. The trade-off's acceptance ("the shell holds no I/O the harness could catch it
  using", C-R7) still holds, so the trade-off itself does not move.

  **No § 10 entry.** S-1's bar read literally was unmet by every native build. Two things decide
  it anyway: the gate passed in substance on the built bundle, and RC-3's *Still unresolved*
  already records the native frames as open (`SDD.md:L2321`). This fold is the resolution RC-3
  anticipated, so it adds no entry. A reader who takes the other side would record RC-4 with
  *Changed* limited to the observable's name, and nothing else here would move.

  **Check 4.**
  - *Stale:* a symbol rename turns the gate red, and the fix is in the one header.
  - *Absent:* a macOS whose modal run shows other AppKit frames is 5.2's re-cut-trigger rule,
    carried into C-I3.
  - *Look-alike:* a generic `-[NSApplication runModalForWindow:]` alone, such as an alert, is not
    a match (`renderer.sh:L49-L51`). The observable therefore says "the Open panel's modal run",
    not "a modal".
  - *Uncovered, named:* a thread sample shows that the shell is in the panel's run. It does not
    show that the panel is on screen. That remains S-1's observable half, walked by a person on
    the CI bundle, as before.

  **Downstream.** The same false sentence in NFDR QC-62 and ADR-0012 is already raised at
  `docs/architecture_open_issues.md` § 3.2 with the same lean. This answer agrees with it, and
  nothing is opened there.

### 5.2 — The last *Open Questions* item is answered. The native shell's frames were measured, and they read the same on a hosted runner

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The PM's claim holds at its sources, which I re-read rather than relayed:
  - Run 35988399477's log carries both `Renderer gate` lines verbatim, on image `macos-14-arm64`
    20260831.0302.1.
  - The runner OS is macOS 14.8.9. That is inside the C-R5 floor's major, so the observation holds
    on the floor's macOS and on the Mac's 26.6.2 (`checks/renderer.sh:L58-L61`).
  - The run's head, `37a962d`, is byte-equal to `main`'s at `153f5a1` in `checks/renderer.sh`,
    `nozoki-mac` and `checks/fixtures/idle-shell` (`git diff --stat`, empty), and `main` has not
    moved them since.
  - The runner observed, so the item's re-cut trigger ("a runner that cannot observe it") did not
    fire.

  The question is closed the way RN-48 closed the probe's hosted-runner question, and the *Open
  Questions* item is removed.

  **One precision the SDD must keep.** The runner printed a *match* of the script's ordered
  five-frame list. The match is all five, nested in order, per `renderer.sh:L45-L52`. The runner
  did not print a full stack the way the Mac reading did. So "read the same on the runner" holds
  for the list the gate reads, and C-I3 says it that way rather than claiming a stack comparison
  nobody made.

  **Change of form.** The lean says to "close … C-I3's and RC-3's mentions". C-I3 is a live
  condition, and its sentence (`SDD.md:L718-L719`, "is unmeasured") is replaced. § 10 entries are
  dated history, so RC-3's *Still unresolved* keeps its words and gains a dated parenthesis. That
  is the form this document uses for every such close (RN-48 for RC-1, RN-66 and RN-68 for RC-3).

  **Additions** — places the item's list did not name:
  1. **RC-2's *Still unresolved*** (`SDD.md:L2265-L2266`) asks the same question, "Whether
     `checks/renderer.sh`'s observation reads the same on a GitHub-hosted runner (*Open
     Questions*)". It takes the same dated parenthesis. Otherwise its pointer leads a cold reader
     to nothing, which is the reason RN-48 gave RC-1 its pointer.
  2. **S-1's command half** (`SDD.md:L1310-L1311`) ends "the frames the gate reads are fixed by
     the script from this bundle (*Open Questions*)". The sentence stays true and the dead pointer
     goes. C-I3's "the frames a native shell shows are re-measured on the first slice's first
     built bundle" (`:L707-L709`) is future tense for a thing that has happened. It becomes a
     statement that they were measured, citing the header.
  3. **The Open Question's own rule survives it.** "A runner that cannot observe it is a re-cut
     trigger on the gate's mechanism, never on the gate" exists only in the item being removed.
     It moves into C-I3.

  **Check 4, stale.** This is one run on one runner image. A later image or macOS whose Open-panel
  frames differ turns the gate red on the next build, because the gate runs on every build. The
  rule in addition 3 then says what gives way: the mechanism. **Check 3.** RN-60's "the frames
  re-measured on the first native build" is note history and stays as written (RN-55's rule). No
  answer here contradicts 5.1's, and the two were decided in order: 5.2's C-I3 wording assumes
  5.1's observable.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run. The only other document owed a change by these answers is the NFDR/ADR pair (QC-62
and ADR-0012). It is already carried by `docs/architecture_open_issues.md` § 3.2, whose slot is at
its placeholder, with a lean this run agrees with.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh nozoki`
