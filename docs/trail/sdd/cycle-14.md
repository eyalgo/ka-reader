# SDD open issues — ka-reader

> Companion to `SDD.md`. Three seats — the CTO, the CPO and the CDO — authored the SDD
> non-interactively in one run; this file holds what that run could not settle from its inputs (the
> PRD, the SRS, the UXD, and any context or constraints).
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time the seats fold them in, they first copy this file
> whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a disagreement is not something one seat asked, it
> is something two seats answered differently, and the answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the run entirely.** §§ 1–4 are all the SDD's own three seats;
> § 5 is a seat that never wrote the SDD, reading it long after it settled and finding something
> only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's, which stay fixed
> to the three authoring seats on purpose.

> **No `product-sdd` run opened this companion. The PM opened it on 2026-09-24.** `SDD.md` is
> Settled at v17 and has no companion on disk, so a `product-sdd` re-run would read it as done and
> find nothing to act on. The companion holds two items, § 5.1 and § 5.2. Each one comes from
> measuring the tree on `main` at `ka-reader@153f5a1`, after `checks/renderer.sh` and its `idle-shell`
> control landed, and from that gate's first hosted-runner run. Each says what the SDD holds that
> the measurement answered.

---

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 C-I3 puts the renderer gate's observation "inside `open_folder`'s call", and the native shell calls `open_folder` only after the panel returns
- **Raised by:** PM — 2026-09-24
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing gates on it. C-I3 describes an observation the gate cannot make. While
  the panel is up, the launched main thread holds no bridge frame.
- **Where it shows:**
  - `SDD.md:L701-L703` (§ 4 C-I3) says the gate fails unless the main process "is observed
    **inside `open_folder`'s call**".
  - `ka-reader-mac/Sources/Shell/LaunchFlow.swift:L35-L37` calls `panel.chooseFolder()` first and
    `bridge.openFolder(location:)` once it returns.
  - `checks/renderer.sh:L44-L57` reads the launched main thread's sample for the shell's launch
    frames, with the Open panel's modal run nested inside them. The header says
    `ka_reader_open_folder` is not in the list for that reason.
- **If a document has to be written:** None. **The PM's lean:** C-I3's observable reads "parked in
  the Open panel's modal run, inside the shell's launch frames — the shell's first and only
  unconditional act". The frames are the ones `checks/renderer.sh`'s header records.
- **Answer:** Confirmed, with two additions. C-I3's observable reads as the PM's lean has it:
  the launched main process is observed parked in the Open panel's modal run, inside the shell's
  launch frames, which is the shell's first and only unconditional act. The frame list is cited
  from `checks/renderer.sh`'s header (`:L44-L61`) and not copied into the SDD, so the script stays
  the list's one home, the way the probe's bound is the script's. The first addition is
  `open-a-folder`'s command half. `SDD.md:L1308-L1310` says the same "inside `open_folder`'s
  call — the panel presented", and it moves with C-I3 in the same words. The second addition is
  § 9 TO-7. Its *costs* line says the shell's actual use of the bridge is "exercised only by the
  renderer gate and the timed release walk" (`SDD.md:L2117-L2118`). With the corrected
  observable, that is false. The shell makes no bridge call before the panel returns
  (`ka-reader-mac/Sources/KAReader/AppDelegate.swift`, `LaunchFlow.swift:L35-L37`,
  `NativeBridge.swift:L13-L25`), so the gate exercises none. The line now names the timed release
  walk alone. The gate shows that the launched shell ran its launch flow as far as the panel.
  No § 10 entry is needed: RC-3's *Still unresolved* already recorded the native gate's reading as
  open, and this answer closes it. It is not a new contradiction. The owner's cycle-8 floor,
  "at the least, that the page reached `open_folder`", was written for a page whose `open_folder`
  call presented the panel. In the native shell `open_folder` is reachable only after someone
  answers the panel. The gate sends no input, and C-I3 forbids a code path that exists for the
  gate. Reasoning: `docs/trail/sdd/self_answer-25.md` § 5.1.

### 5.2 The last *Open Questions* item is answered. The native shell's frames were measured, and they read the same on a hosted runner
- **Raised by:** PM — 2026-09-24
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing gates on it. The SDD still presents as open a question the gate's first
  runs settled, and it names that settlement as the question's trigger.
- **Where it shows:**
  - `SDD.md:L3947-L3952` is the last *Open Questions* item: "Which frames the native shell shows
    … and whether they read the same on a GitHub-hosted macOS runner … Settled by the gate's first
    run on the first slice's first native bundle, on that Mac and on the runner".
  - The same question stands in C-I3 (`SDD.md:L718-L719`, "is unmeasured") and in § 10 RC-3's
    *Still unresolved* (`:L2321-L2322`).
  - On the Mac, `checks/renderer.sh:L58-L61` records macOS 26.6.2 and the five frames of
    `:L53-L57`, nested in that order.
  - On the runner, CI run 35988399477 ran on image `macos-14-arm64` 20260831.0302.1 against a
    `renderer.sh` byte-equal to `main`'s (`git diff --stat 37a962d 153f5a1` lists no
    `renderer.sh`). `Renderer gate` printed "the main process was observed at the Open panel,
    inside the shell's launch, on observation 1". It printed the `idle-shell` control "was not
    observed at the Open panel in any of 30 observations — the expected red".
  - The runner observed, so the item's re-cut trigger ("a runner that cannot observe it") did not
    fire.
- **If a document has to be written:** None. **The PM's lean:** close the item, and C-I3's and
  RC-3's mentions of it, the way RN-48 closed the probe's hosted-runner question. The frames are the
  ones the script's header records. The runner's reading is run 35988399477.
- **Answer:** Confirmed, with three additions and one change of form. Close the last *Open
  Questions* item (`SDD.md:L3947-L3952`) and remove it, as RN-48 removed the probe's.
  - **C-I3.** `:L718-L719` is a live condition, so its sentence is replaced. It now says the gate
    was measured on the Mac (`checks/renderer.sh:L58-L61`, macOS 26.6.2) and on a GitHub-hosted
    runner (run 35988399477, image `macos-14-arm64` 20260831.0302.1, macOS 14.8.9, which is the
    C-R5 floor's major).
  - **Change of form, § 10.** The two § 10 mentions are dated history, so each keeps its words and
    gains a dated parenthesis, the form RN-48, RN-66 and RN-68 used. They are not deleted.
  - **Addition 1.** RC-2's *Still unresolved* (`SDD.md:L2265-L2266`) carries the same question, and
    the item did not name it. It takes the same parenthesis as RC-3's, so a pointer to *Open
    Questions* does not lead a cold reader to nothing (RN-48's reason for RC-1).
  - **Addition 2.** `open-a-folder`'s command half ends "the frames the gate reads are fixed by
    the script from this bundle (*Open Questions*)" (`SDD.md:L1310-L1311`). It keeps the sentence
    and drops the pointer. C-I3 `:L707-L709` ("the frames a native shell shows are re-measured on
    the first slice's first built bundle") becomes a statement that they were measured, citing the
    script's header.
  - **Addition 3.** The Open Question's own rule, that a runner which cannot observe the frames is
    a re-cut trigger on the gate's mechanism and never on the gate, moves into C-I3. The item
    leaves, and that rule still binds the next runner image or macOS that reads differently. The
    gate runs on every build, so such a change shows up as a red gate.
  - **Wording.** The runner printed a match of the script's five-frame list, not the frames
    themselves. "Read the same" holds for the list the gate reads, and the SDD says it that way.

  Reasoning: `docs/trail/sdd/self_answer-25.md` § 5.2.
