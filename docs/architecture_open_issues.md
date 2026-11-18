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

### 3.1 § 9 counts thirty top-level suites where the tree holds thirty-two
- **Raised by:** PM — 2026-11-18
- **Which record:** `nfdr.md` § 9, the suites bullet
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; the pinned count is a re-measurement behind the tree.
- **Where it shows:** the bullet counts thirty top-level shell suites at `ka-reader@21f611f` with `checks/gate.sh` 1.22.0 (`docs/nfdr.md:L3182-L3184`). At `ka-reader@2777e89` there are thirty-two (`git ls-tree --name-only 2777e89 checks/tests/ | grep -c '/test_.*\.sh$'` → `32`); the new ones are `checks/tests/test_readme_picture.sh`, the whole command of *README picture check suite* (`checks/gate.sh:L198`), and `checks/tests/test_readme_capture.sh`, the whole command of *README picture capture suite* (`:L213`), `checks/gate.sh` 1.24.0. Re-measure at the main line as it stands at the fold.
- **If a document has to be written:** none.
- **Answer:** Re-measure § 9's suites bullet at the main line as it stands at the fold, by the bullet's own method, and keep the thirty at `ka-reader@21f611f` as a dated reading. At `ka-reader@3463d17` (main; `git diff --stat 2777e89 3463d17 -- . ':!docs'` prints nothing, so it reads as `2777e89`) there are thirty-two suites, each the whole command of exactly one `run_step` line of `checks/gate.sh` 1.24.0, and every locator has moved — the two new ones are `test_readme_picture.sh` (`:L198`) and `test_readme_capture.sh` (`:L213`). The bullet's two dependent counts move with it: "Four of the thirty" becomes "Four of the thirty-two" — the same four, `test_assemble.sh`, `test_secret_scan_planted.sh`, `test_strings_step.sh` and `test_vm_refusal.sh` — and "all thirty" becomes "all thirty-two". If main moves again before the fold, the fold's own measurement governs. No obligation and no record changes. Reasoning: `docs/trail/architecture/self_answer-98.md` § 3.1.

### 3.2 QC-65's set of what starts the bundle does not name the README picture's capture
- **Raised by:** PM — 2026-11-18
- **Which record:** `nfdr.md` QC-65, "Today they are …" and the sentences that follow
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; the set QC-65 states is short of the tree.
- **Where it shows:** QC-65 names the bundle checks, the launch, the own-state step, the tree-scene and Git-beta scene helpers and the two host walks (`docs/nfdr.md:L2615-L2703`). At `ka-reader@2777e89` `checks/readme-capture.sh` also starts the bundle, with `open -n` (`checks/readme-capture.sh:L339`), and refuses off a macOS virtual machine before anything else (`:L69`, `uname -s` and `sysctl -n kern.hv_vmm_present`). It is a person's tool and no gate step. Its suite, `checks/tests/test_readme_capture.sh`, records `open` through a stand-in and so is outside the set, as the scene helpers' suites are; its refusal case is `test_off_a_vm_it_exits_non_zero_having_launched_nothing_and_read_nothing`.
- **If a document has to be written:** none.
- **Answer:** QC-65's set names `checks/readme-capture.sh` beside the two scene helpers, in their shape: it starts the bundle with `open -n` (`checks/readme-capture.sh:L339`) and refuses off a macOS virtual machine as its first work, before it opens, finds or reads anything (`:L69`); it is a person's tool and no gate step; its suite, `checks/tests/test_readme_capture.sh` (the gate's *README picture capture suite*, `checks/gate.sh:L213`), records `open`, `ps` and `kill` through stand-ins and launches nothing, so it is outside the set, as the other helpers' suites are. The *verified by* clause names `test_off_a_vm_it_exits_non_zero_having_launched_nothing_and_read_nothing` in that suite (`checks/tests/test_readme_capture.sh:L484`), and names no twin in `checks/tests/test_vm_refusal.sh`, because none exists and QC-65 requires none — the refusal suite is for suites that cannot run their own case. The script reads the account's name and home folder path only to keep them out of the picture's metadata, and reads no app container, so "the running machine's home" does not reach it on that ground. Pinned at `ka-reader@3463d17`. QC-65's own rule — a step that launches the bundle joins the set — is what makes this a correction and not a widening. § 10's QC-65 row follows. Reasoning: `docs/trail/architecture/self_answer-98.md` § 3.2.

### 3.3 QC-14's list of programs a check compiles at run time does not name the window probe
- **Raised by:** PM — 2026-11-18
- **Which record:** `nfdr.md` QC-14, the list of programs a check compiles into a temporary folder of its own
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; the dated list (at `ka-reader@03bb989`, `docs/nfdr.md:L736-L743`) is short of the tree.
- **Where it shows:** at `ka-reader@2777e89` `checks/readme-capture.sh` compiles `checks/window_probe/main.swift` with `swiftc` into its work folder (`checks/readme-capture.sh:L89`, `:L320`); the probe imports CoreGraphics, Foundation and ImageIO (`checks/window_probe/main.swift:L1-L3`) and never ships. QC-14's list should name it beside the idle-shell control, the icon probe and the sandbox probe.
- **If a document has to be written:** none.
- **Answer:** QC-14's list names the window probe beside the other three: Foundation, ImageIO and CoreGraphics (`checks/window_probe/main.swift:L1-L3`), compiled with `swiftc` by `checks/readme-capture.sh:L320` into its own work folder under `/tmp` (made at `:L226`); it never ships. Re-pin the list's other locators at the same commit, `ka-reader@3463d17`, and keep the `03bb989` reading as dated. With it the list is whole: a search of `checks/*.sh` for `swiftc` and `rustc` finds exactly these four programs compiled at run time. The existing verifiers hold it unchanged — `checks/bundle.sh` finds nothing of `checks/` under `Contents/`, and the imports stay `development-design`'s review. No record is owed. Reasoning: `docs/trail/architecture/self_answer-98.md` § 3.3.

### 3.4 The NFDR cites the README's stack and proof sentences by line numbers that hold other text
- **Raised by:** PM — 2026-11-18
- **Which record:** `nfdr.md`, the line citing `README.md:L46-L51` (`docs/nfdr.md:L4834`)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; a reader following the locator lands on the wrong paragraph.
- **Where it shows:** at `ka-reader@2777e89` `README.md:L44-L51` is the "inspection rather than authoring" paragraph and the start of its list; the stack sentence opens at `README.md:L60`. The README's opening is to gain an image paragraph after its description sentence, which moves every line below it by two. Re-point the locator, or cite the sentences by section rather than by line.
- **If a document has to be written:** none.
- **Answer:** Do not re-point the line in place. It sits in RN-22, the v11 review note, and was true when written: at `ka-reader@38aaa48`, the v11 commit, `README.md:L44` is `## Stack` and `:L46-L51` the stack and proof sentences. Pin it there instead — `ka-reader@38aaa48:README.md:L46-L51` — and add a dated note, in the form the SDD's own RN-68 note uses for the same clause, that both owed items landed: the README's `## Stack` section names the one bundle and process with no web engine and keeps the `checks/` proof sentence from `ka-reader@61748fe`, and the card's `Languages:` and test command moved at `kensaiapp-opensource@5b27023`. Cite today's sentences by section (`README.md` § *Stack*), not by line, because the planned image paragraph moves every line below it. Reasoning: `docs/trail/architecture/self_answer-98.md` § 3.4.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
