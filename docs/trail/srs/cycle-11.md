# SRS open issues — KA-Reader

> Companion to `SRS.md`. The CTO authored the SRS non-interactively; this file holds
> what it could not settle from the inputs (the PRD and any context/constraints).
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this
> file**, then re-run `product-srs`. It folds your answers into the SRS and drops the
> resolved items. When nothing is left open, `product-srs` **deletes this file**: no file =
> the SRS is done.
>
> Your answers are never thrown away. Each time the CTO folds them in, it first copies this
> file whole to `docs/trail/srs/` — so what you decided, and why, stays readable and citable
> for good.

> **No `product-srs` run wrote this file.** The owner opened it on 2026-10-16, in an interactive
> session, after `PRD.md` v16 moved the public identity (`ka-reader@74ca793`). The SRS is Settled,
> so without a companion the upstream move would reach no one.

---

## 1. Open issues — technical questions with no answer yet

### 1.1 C-12 names `github.com/kensaiapp/ka-reader`; the PRD now names `github.com/eyalgo/ka-reader`
- **Raised by:** Product (owner) — 2026-10-16
- **Which requirement:** C-12 (`SRS.md` lines 496–499), the public identity, tracing to PRD
  Assumptions "Public identity".
- **What moved upstream:** `PRD.md` v16 § *Public identity* reads: KA-Reader lives at
  `github.com/eyalgo/ka-reader`, under the maintainer's personal handle `eyalgo`, which is the
  public face. The owner transferred the repository there on 2026-10-16; it is still private, and
  its visibility and CI billing are to be settled later.
- **What it reaches:** C-12's wording ("the `kensaiapp` GitHub organisation", the address). C-7's
  channel and the releases live at whatever C-12 names. RN-24 is a review note recording why C-12
  was added and stays as written.
- **Answer:** C-12 follows the PRD: the product is published from `github.com/eyalgo/ka-reader`,
  under the maintainer's personal handle, and that repository is where C-7's channel is enabled and
  where releases are offered.

## 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override

None.
