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
> re-run would read them as done and find nothing to act on. The companion holds four items,
> §§ 3.1 – 3.4. Each one comes from measuring the tree on `main` at `nozoki@153f5a1` against these
> records, after `checks/view.sh`, `checks/renderer.sh` and `checks/fixtures/idle-shell` landed. Each
> states a fact the records hold that is now false.

---

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
- **Answer:** <the owner fills this in>

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
- **Answer:** <the owner fills this in>

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
- **Answer:** <the owner fills this in>

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
- **Answer:** <the owner fills this in>
