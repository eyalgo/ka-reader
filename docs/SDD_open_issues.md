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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-11-09, reading the settled SDD
> against the product at `ka-reader@2d7c4f9`. One item follows in § 5; the SDD is not edited.

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

### 5.1 § 3's `read-only-harness` row is pinned at `3fa227e` and names none of the release workflow, its five scripts or their five suites
- **Raised by:** PM — 2026-11-09
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; the row's enumeration, counts and `gate.sh` locators read an older tree, and S-7's later work reads this row.
- **Where it shows:** `docs/SDD.md:L539`, measured at `ka-reader@3fa227e` (sixteen scripts, seventeen suites, 40 gate steps, `gate.sh` at 1.10.0, one workflow). At `ka-reader@2d7c4f9` the tree adds `checks/release-version.sh`, `checks/release-pack.sh`, `checks/release-sums.sh`, `checks/release-absent.sh` and `checks/release-shape.sh`, their suites `checks/tests/test_release_{version,pack,sums,absent,shape}.sh`, and a second workflow, `.github/workflows/release.yml`; `checks/gate.sh` is at 1.11.0 with 46 steps (`grep -cE "^run_step '" checks/gate.sh` → `46`).
- **If a document has to be written:** none — the row is re-measured and re-pinned at the current tree.
- **Answer:** <the owner fills this in>
