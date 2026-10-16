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

> **No `product-sdd` run wrote this file.** The owner opened it on 2026-10-16, in an interactive
> session, after `PRD.md` v16 (`ka-reader@74ca793`) and `SRS.md` v13 (`ka-reader@3a6e021`) moved the
> public identity to `github.com/eyalgo/ka-reader`. The SDD is Settled, so without a companion the
> upstream move would reach no one.

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

### 5.1 The SDD names `github.com/kensaiapp/ka-reader`; the PRD and SRS now name `github.com/eyalgo/ka-reader`
- **Raised by:** Product (owner) — 2026-10-16
- **Seat:** cto
- **Tracked by:** no seed.
- **What it blocks:** nothing outright. The owner transferred the repository from the `kensaiapp`
  organisation to the personal account `eyalgo` on 2026-10-16; it is still private, and its
  visibility and CI billing are to be settled later. GitHub redirects the old address, but the SDD
  now states one the PRD (§ *Public identity*, v16) and the SRS (C-12, v13) no longer do.
- **Where it shows:** the release channel (line 628, C-12), E-7 (line 1285), and that slice's
  *Delivers* and acceptance (lines 2257, 2265, 2280, 2286 and 2288 — the address a stranger opens,
  the Release, and the `gh api repos/…/private-vulnerability-reporting` and advisory commands).
  Measured at `ka-reader@3a6e021`.
- **Not to change:** the CI evidence lines 8236, 8306, 8353 and 8364
  (`gh run … --repo kensaiapp/ka-reader`) record runs made at the old address and stay as written.
- **If a document has to be written:** none. A fold into `SDD.md`. ADR-0007 names the same address
  and is the Principal Architect's, raised separately.
- **Answer:** Follow the PRD and SRS: every forward-looking mention reads `github.com/eyalgo/ka-reader`
  (and `eyalgo/ka-reader` in commands). The run records stay as they are.
