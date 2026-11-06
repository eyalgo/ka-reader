# SDD open issues — ka-reader

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

### 1.1 The first public release no longer waits for the full v1 cut — PRD v17 moved it ahead of the Git view's live refresh
- **Raised by:** CPO — 2026-11-06
- **Seat:** cto
- **What moved upstream:** `docs/PRD.md` v17 (`ka-reader@ce9ba62`, folding `docs/trail/prd/cycle-15.md` § 3.1, the owner's answer of 2026-11-06): the first public release is a beta below 1.0.0. It comes once the tree and the open file follow the disk and Markdown reads rendered, and it does not wait for the Git view to follow the disk. In the beta the Git view and the changed-file markers say plainly that they show the Git state read when the folder was opened, and the README's known gaps say the same. The Git view's live refresh stays part of v1 and lands before 1.0.0.
- **What it contradicts here:** § 5 step 1 E-7 (`SDD.md` lines 1673–1682) places `first-public-release` "after the v1 cut", on the owner's quoted ruling "The first public release waits for the full v1 cut the PRD names" (RN-17); the slice whose *Why here in the order* reads "The owner's first-public-release placement still waits for this complete v1 cut" (line 2414). That ruling is withdrawn for the beta.
- **What it reaches:** `first-public-release`'s place in § 6 and § 7 (its edges now: after the tree-and-open-file slices and Markdown rendered; not after the Git half of `follow-the-folder`), its *Reached when* (the Git view's "read at open" statement and the README's known gap), and the beyond-v1 order. Whether `choose-a-theme` still precedes the release is not moved by this item.
- **Answer:** Move `first-public-release` ahead of the Git half of live refresh, as PRD v17 states: it follows the tree and the open file following the disk and Markdown rendered, and is a release below 1.0.0. Add to its bar that the Git view and the changed markers state they show the state read at open, and that the README's known gaps say so. Keep the Git view's live refresh before `promise-one-point-zero`. Record the owner's earlier ruling as withdrawn for the beta, with its old words kept beside it.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

None.
