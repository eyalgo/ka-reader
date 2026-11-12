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

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-14 does not admit the platform frameworks the icon probe imports
- **Raised by:** PM — 2026-11-12
- **Which record:** `nfdr.md` § 1.2, QC-14
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; QC-14 says `checks/` "may import `ka-reader-core`" (`docs/nfdr.md:L732`), which under § 1.2's opening is the whole allowed set, and a check now imports more, so the record is short of the tree.
- **Where it shows:** `checks/icon_probe/main.swift` on `main` at `ka-reader@03bb989` imports Foundation, ImageIO and CoreGraphics (`checks/icon_probe/main.swift:L1-L3`; `grep -c -i imageio docs/nfdr.md` → `0`). It is compiled by `checks/app-icon.sh` into a temporary folder at run time, never ships, and is no dependency of a shipped unit; the idle-shell control already stands the same way with AppKit (`checks/fixtures/idle-shell/main.swift:L1`). QC-14 should say that `checks/` may import `ka-reader-core` and, in a program a check compiles into its own temporary folder at run time, the platform's own frameworks — AppKit for the idle-shell control, Foundation, ImageIO and CoreGraphics for the icon probe — such a program never shipping and never a dependency of a shipped unit.
- **If a document has to be written:** none.
- **Answer:** confirmed with addition — QC-14 takes the item's wording, widened to the probe it leaves out: `checks/` may import `ka-reader-core`, and a program a check compiles into a temporary folder of its own at run time may also use the platform's own frameworks and system library — AppKit for the idle-shell control (`checks/renderer.sh:L331`), Foundation, ImageIO and CoreGraphics for the icon probe (`checks/icon_probe/main.swift:L1-L3`, compiled by `checks/app-icon.sh` into its `mktemp` folder), and the system library's `dlsym` and `kill`, which `checks/sandbox_probe.rs` declares (`:L54-L57`) and `checks/bundle.sh` compiles with `rustc` into its own work folder (`:L433-L434`) — such a program never shipping and never a dependency of a shipped unit. The third probe was outside QC-14 before this item and would stay outside it under the item's list. No record is owed: ADR-0020's "`checks/` may import `ka-reader-core`" (`docs/adr/0020-physical-unit-set-the-bridge-switches-off-libgit2-machine-config-reads.md:L55`) is an edge between units, and it was written while the AppKit control already stood in `checks/`. No check reads what these programs import, so the new clause's gate is `development-design` reading the entry, said in its tail. Reasoning: `docs/trail/architecture/self_answer-94.md` § 3.1.

### 3.2 § 9 names neither the application icon nor its check, and counts twenty-seven suites where the tree holds twenty-nine
- **Raised by:** PM — 2026-11-12
- **Which record:** `nfdr.md` § 9, the layer table's row *5 — End-to-end* and the suites bullet
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; a reader of § 9 cannot find what holds the application icon, and the pinned suite count is a re-measurement behind the tree.
- **Where it shows:** row 5 (`docs/nfdr.md:L3015`) names no icon (`sed -n 3015p docs/nfdr.md | grep -c app-icon` → `0`). At `ka-reader@03bb989` `checks/app-icon.sh` runs on the built bundle as the gate step *Application icon check*, with its control over `checks/fixtures/stand-in-icon.icns` (`checks/gate.sh:L114`). Its *what* cell should add "the application icon: one file the bundle names, the seven sizes, no second appearance, the drawing's colours", and its *by* cell `checks/app-icon.sh`. The suites bullet counts twenty-seven at `ka-reader@528c152` with `checks/gate.sh` 1.17.0 (`docs/nfdr.md:L3128-L3130`); at `ka-reader@03bb989` it is twenty-nine (`git ls-tree --name-only main checks/tests/ | grep -c '/test_.*\.sh$'` → `29`), the two new being `test_app_icon.sh` and `test_assemble.sh` (`checks/gate.sh:L115`, `:L119`, Version 1.20.0).
- **If a document has to be written:** none.
- **Answer:** confirmed with addition — row 5 takes the item's *what* clause, "the application icon: one file the bundle names, the seven sizes, no second appearance, the drawing's colours" (`checks/gate.sh:L108-L110`), and its *by* cell names `checks/app-icon.sh` with `checks/fixtures/stand-in-icon.icns`, its control, the way the row names `checks/renderer.sh` with `checks/fixtures/idle-shell` (the gate's own comment: a run without the control has not run the check). The suites bullet is re-measured at `ka-reader@03bb989`: twenty-nine suites, `checks/gate.sh` 1.20.0, with `test_app_icon.sh` (`:L115`) and `test_assemble.sh` (`:L119`) added, and the twenty-seven at `528c152` kept as a dated reading. Every other locator in that bullet moves as well, not only the count: the four at or above old `:L104` read three higher (`:L74`, `:L92`, `:L105`, `:L107`), and the rest read fifteen higher, from `test_bundle.sh` at `:L122` through `test_git_beta_walk.sh` at `:L194`. § 10 takes no row, because no `QC` binds the icon: its rule is DESIGN's, and writing a new obligation for it is not this item's. Reasoning: `docs/trail/architecture/self_answer-94.md` § 3.2.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
