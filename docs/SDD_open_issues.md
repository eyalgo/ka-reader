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

### 5.1 § 3's `read-only-harness` row, pinned at `66f28cb`, no longer enumerates the tree
- **Raised by:** PM — 2026-11-24
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; the row says a file landing in `checks/` after its pin "owes this row an item" (`docs/SDD.md:L549`), and two have, with four more changed.
- **Where it shows:** `git diff --name-status 66f28cb 35d5e02 -- checks .github` → `A checks/readme-badge.sh`, `A checks/tests/test_readme_badge.sh`, `M checks/gate.sh`, `M checks/readme-picture.sh`, `M checks/tests/test_readme.sh`, `M checks/tests/test_readme_picture.sh`; nothing under `.github/`. At `ka-reader@35d5e02`, the merge that gave the README its shared opening with six repository-local badge pictures: `checks/gate.sh` has 237 lines and 65 `run_step` lines, the two new fatal steps *README badge check* and *README badge check suite* at `:L209-L210`, directly after *README picture check suite*; `checks/readme-badge.sh` is a new check holding the release badge's drawn version to `Cargo.toml`'s and `Info.plist`'s; `checks/readme-picture.sh` admits a badge picture under `docs/readme/badges/` in condition (c) and gains a condition (g); 31 scripts match `checks/*.sh` and 33 suites `checks/tests/*.sh`. `git diff -U0 66f28cb 35d5e02 -- checks/gate.sh` → two hunks, two lines added after old `:L1` and seven after old `:L201`, so every `gate.sh` locator the row, § 4 C-I3 and § 6 S-7 read at the old pin after `:L1` moves.
- **If a document has to be written:** none; the row is re-measured from its own pin and re-pinned, as at its last fold.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
