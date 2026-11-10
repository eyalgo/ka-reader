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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-11-10, reading the settled SDD
> (v85) against the product at `ka-reader@7a88215`. One item follows in § 5; the SDD is not edited.

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

### 5.1 § 3's `read-only-harness` inventory does not name the beta catalogue check, its helper, its suite or its two gate steps
- **Raised by:** PM — 2026-11-10
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; a reader taking § 3 as the harness's measured inventory misses one check and one helper folder, and reads the wrong gate size.
- **Where it shows:** § 3's `read-only-harness` row and its additional measurement at `ka-reader@1ee6ba1` (`docs/SDD.md:L543-L558`) record 50 `run_step` calls and name `checks/readme.sh` as the README check. At `ka-reader@7a88215`, `grep -c '^run_step ' checks/gate.sh` prints 52. The two new steps are *Git beta catalogue check* (`checks/gate.sh:L152`, the whole `checks/git-beta.sh`) and *Git beta catalogue check suite* (`:L153`, `checks/tests/test_git_beta.sh`). The dispatcher clears `KA_READER_TEST_ONLY` for that suite and the README check suite (`:L50`). `checks/support/git-beta-inputs.sh`, a new `checks/support/` folder, is the helper both `git-beta.sh` and `readme.sh` source, and `GitReadPolicy.swift` is one of `git-beta.sh`'s inputs. `grep -n 'git-beta' docs/SDD.md` prints nothing.
- **If a document has to be written:** none. The row is re-measured at the new commit, and the `1ee6ba1` reading is kept as dated evidence.
- **Answer:** <the owner fills this in>
