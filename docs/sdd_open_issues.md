# SDD open issues — KA-Reader

> Companion to `SDD.md`. The CTO wrote the SDD; this file holds what that run could not settle from
> its inputs (the PRD, the SRS, the UXD, and any context or constraints), and the calls that are the
> CPO's or the CDO's to make. An item whose call is the CPO's or the CDO's carries that seat's
> `Seat:`; an item whose call is the CTO's carries `cto` or no `Seat:` field.
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time `product-sdd` folds them in, it first copies this
> file whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **§ 5 names a raiser from outside the SDD's lanes entirely.** §§ 1–4 are all the SDD's own three
> lane seats; § 5 is a seat that never held a lane in it, reading it long after it settled and
> finding something only the SDD can fix.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 § 3's `read-only-harness` row is behind the tree after the README picture's capture and check
- **Raised by:** PM — 2026-11-18
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; by the row's own rule a file landing in `checks/` after its pin owes it an item, and the row's counts and line map are re-measurements behind the main line.
- **Where it shows:** the row is pinned at `ka-reader@21f611f` with `checks/gate.sh` 1.22.0, 59 steps, twenty-eight scripts and thirty suites. At `ka-reader@2777e89` `checks/gate.sh` is 1.24.0 with 61 steps (`grep -c '^run_step ' checks/gate.sh` → `61`): *README picture check suite* (`checks/tests/test_readme_picture.sh`, `:L198`) and *README picture capture suite* (`checks/tests/test_readme_capture.sh`, `:L213`) are new. `git ls-tree --name-only 2777e89 checks/ | grep -c '\.sh$'` → `30`: the new scripts are `checks/readme-picture.sh` 1.0.0, the check that holds the README's picture to its record, which no gate step runs yet, and `checks/readme-capture.sh` 1.0.0, a person's tool that builds the bundle at `HEAD`, launches it with `open -n` and refuses off a macOS virtual machine, which no gate step runs. `git ls-tree --name-only 2777e89 checks/tests/ | grep -c '/test_.*\.sh$'` → `32`. Also new and unlisted: `checks/window_probe/main.swift`, which the capture compiles into its work folder and which never ships, and the two reply folders `checks/tests/support/readme_capture_git_replies/` and `checks/tests/support/readme_picture_git_replies/`. `checks/tests/test_readme.sh` is 1.2.4, its pinned list two lines longer, so its line map has moved. A third step, *README picture check* (`checks/readme-picture.sh`), is to join the gate directly before its suite; the re-measure reads the main line as it stands at the fold.
- **If a document has to be written:** none.
- **Answer:**

### 5.2 The SDD cites the README's stack and proof sentences by line numbers that hold other text
- **Raised by:** PM — 2026-11-18
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; a reader following the locator lands on the wrong paragraph.
- **Where it shows:** `docs/SDD.md:L3709`, `:L3715` cite `README.md:L46-L51`, and `:L5574`, `:L5579`, `:L5582`, `:L5600`, `:L5665`, `:L5667`, `:L5672` cite `README.md:L48-L49`, for the stack and proof sentences. At `ka-reader@2777e89` `README.md:L44-L51` is the "inspection rather than authoring" paragraph and the start of its list; the stack sentence opens at `README.md:L60`. The README's opening is to gain an image paragraph after its description sentence, which moves every line below it by two. Re-point the locators, or cite the sentences by section rather than by line.
- **If a document has to be written:** none.
- **Answer:**

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
