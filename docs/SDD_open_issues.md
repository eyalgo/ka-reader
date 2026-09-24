# SDD open issues — nozoki

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
> measuring the tree on `main` at `nozoki@153f5a1`, after `checks/renderer.sh` and its `idle-shell`
> control landed, and from that gate's first hosted-runner run. Each says what the SDD holds that
> the measurement answered.

---

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 C-I3 puts the renderer gate's observation "inside `open_folder`'s call", and the native shell calls `open_folder` only after the panel returns
- **Raised by:** PM — 2026-09-24
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing gates on it. C-I3 describes an observation the gate cannot make. While
  the panel is up, the launched main thread holds no bridge frame.
- **Where it shows:**
  - `SDD.md:L701-L703` (§ 4 C-I3) says the gate fails unless the main process "is observed
    **inside `open_folder`'s call**".
  - `nozoki-mac/Sources/Shell/LaunchFlow.swift:L35-L37` calls `panel.chooseFolder()` first and
    `bridge.openFolder(location:)` once it returns.
  - `checks/renderer.sh:L44-L57` reads the launched main thread's sample for the shell's launch
    frames, with the Open panel's modal run nested inside them. The header says
    `nozoki_open_folder` is not in the list for that reason.
- **If a document has to be written:** None. **The PM's lean:** C-I3's observable reads "parked in
  the Open panel's modal run, inside the shell's launch frames — the shell's first and only
  unconditional act". The frames are the ones `checks/renderer.sh`'s header records.
- **Answer:** <the owner fills this in>

### 5.2 The last *Open Questions* item is answered. The native shell's frames were measured, and they read the same on a hosted runner
- **Raised by:** PM — 2026-09-24
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
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
- **Answer:** <the owner fills this in>
