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
> **An item may name the seat that answers it.** Any item in any section carries an optional
> `- **Seat:** <seat>` field beside its other fields. Its value is the name of the agent whose posture
> answers the item — `cto`, `cpo` or `cdo`. An item with no usable value, whether the field is absent,
> empty or still the `<seat>` placeholder, is answered in the seat of the skill that produced this file.
> The field names the *answering* seat. It is not the seat that raised the item (`Raised by:` /
> `Held by:`), and it is not the document an answer belongs to.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a
> disagreement is not something one seat asked, it is two positions held by different seats, and the
> answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the SDD's lanes entirely.** §§ 1–4 are all the SDD's own three
> lane seats; § 5 is a seat that never held a lane in it, reading it long after it settled and
> finding something only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's,
> which stay fixed to the three lane seats on purpose.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 § 3's `read-only-harness` row, pinned at `2777e89`, no longer enumerates the tree, and its red gate has gone green
- **Raised by:** PM — 2026-11-19
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; the row says a file landing in `checks/` after its pin "owes this row an item" (`docs/SDD.md:L548`), and two have. The row also says the gate on `main` ends red at *README picture check suite* "until the picture lands and the step joins"; both have happened, so that sentence now describes a state the main line has left.
- **Where it shows:** `git diff --name-status 2777e89 66f28cb -- checks .github` lists `checks/gate.sh` and `checks/tests/test_readme.sh` changed, nothing added, nothing under `.github/`. `checks/gate.sh` is Version 1.25.0 with 62 `run_step` lines (`grep -c '^run_step ' checks/gate.sh` → `62`; 61 at the pin): *README picture check*, the whole command of `checks/readme-picture.sh`, is a fatal step at `:L200`, directly before *README picture check suite* at `:L201`, under the comment above them that now says the check runs first so a stale or missing picture is named by its own step; *README picture capture suite* moves to `:L216`. `checks/tests/test_readme.sh` is Version 1.2.5, its pinned gate list gaining the matching line at `:L560`, so its locators from old `:L560` read one higher, and the file has 861 lines. `readme-picture.sh` therefore stops being a check that reaches the gate through its suite alone. The picture and its record landed outside `checks/`, at `docs/readme/shell.png` and `docs/readme/shell.record`. On a disposable clone at `66f28cb`, `checks/readme-picture.sh` exits 0 ("the README's opening shows docs/readme/shell.png, and it matches docs/readme/shell.record at version 0.1.0") and `checks/tests/test_readme_picture.sh` passes 16 of 16. Scripts stay thirty and suites thirty-two (`ls checks/*.sh | wc -l` → `30`; `git ls-tree --name-only main checks/tests/ | grep -c '/test_.*\.sh$'` → `32`). § 4 C-I3's three gate locators and § 6 S-7's one, read at the pin, may move with the four inserted lines. Re-measure at the current main line.
- **If a document has to be written:** none.
- **Answer:**
