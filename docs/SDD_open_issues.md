# SDD open issues — Nozoki

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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-04 from the SDD's own
> companion template. `DESIGN.md` gives every clickable row a hover fill, the shell draws none, and no
> slice delivers one. The SDD is Settled, and with no companion on disk a `product-sdd` re-run reads it
> as done and has nothing to act on. Its one item is in § 5.

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

### 5.1 No slice delivers the clickable row's hover fill that `DESIGN.md` draws
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** a seed for the hover fill. Seeds are cut from slices, and no slice's *Delivers*
  or *Reached when* names it, so nothing on any route builds it.
- **Where it shows:** `docs/DESIGN.md:L617-L624` — "A clickable row has a hover state and an inert row
  has none": a tree row, a Git-view file row, a commit row and a menu item take a `{colors.hover}` fill
  edge to edge while the pointer is over them, and selection outranks it. `docs/DESIGN.md:L653-L654`
  stacks the status letter's tooltip over that fill. The shell draws no hover at all:
  `grep -rn -i hover nozoki-mac/Sources | wc -l` → `0` at `nozoki@6040dc1`, where the tree and the Git
  view are both built. `docs/SDD.md` names no hover in any slice (`grep -n -i hover docs/SDD.md` →
  nothing), and neither does `docs/UXD.md` (same `grep` → nothing), so the fill is the design language's
  alone. The likely fold: the fill placed in the *Delivers* and *Reached when* of the slice that owns
  each row it covers, or in one slice of its own, before the release the Agari closes on.
- **If a document has to be written:** none. A change in `SDD.md` § 6, written by `product-sdd`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
