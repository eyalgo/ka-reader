# SDD open issues — Nozoki

> Companion to `SDD.md`. Three seats — the CTO, the CPO and the CDO — authored the SDD
> non-interactively in one run; this file holds what that run could not settle from its inputs (the
> PRD, the SRS, the UXD, and any context or constraints).
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time the seats fold them in, they first copy this file
> whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a disagreement is not something one seat asked, it
> is something two seats answered differently, and the answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the run entirely.** §§ 1–4 are all the SDD's own three seats;
> § 5 is a seat that never wrote the SDD, reading it long after it settled and finding something
> only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's, which stay fixed
> to the three authoring seats on purpose.

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-01 from the SDD's own
> companion template, while re-reading the route after the grammar engine was first built, because
> `SDD.md` is Settled and with no companion on disk a `product-sdd` re-run reads it as done and has
> nothing to act on. Its one item is in § 5. §§ 1–4 hold nothing. It pairs with
> `docs/architecture_open_issues.md` § 3.1, which asks the NFDR to record the same review.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 The grammar-engine question is answered on the tree and still open in the SDD
- **Raised by:** PM — 2026-10-01
- **Tracked by:** `nozoki · nemawashi · 2026-10-01_a-file-reads-in-the-panel`
- **What it blocks:** nothing is blocked. *Open Questions* asks which engine compiles the six floor
  grammars, and the SDD states as open a decision the product has made and recorded.
- **Where it shows:** *Open Questions* reads "[OPEN: Which grammar engine compiles the six floor
  grammars into `nozoki-core` (§ 3 `highlighter`), and what it adds to `checks/deps.allow`. Settled in
  `read-a-file` by the dependency review that change carries under C-R6 …]" (`docs/SDD.md:L4521-L4524`).
  § 3's `highlighter` row (`:L327`) and § 6 S-2 (`:L1484`) point at it. `checks/deps.review.md`
  § *The engine chosen* answers it: tree-sitter, meaning the `tree-sitter` runtime, `tree-sitter-highlight`
  and one grammar crate per floor language, compiled from C into `nozoki-core`. It also names the 20
  names that engine adds to `checks/deps.allow` (`nozoki@85d9fa7`).
  `crates/nozoki-core/src/highlighter.rs` is built on it, and `cargo test --locked -p nozoki-core --test
  highlight` passes (18 passed). The item should close, citing the review record. The `highlighter`
  row and S-2 should then name the engine, or the record, in place of the open question.
- **If a document has to be written:** none. *Open Questions*, § 3 `highlighter`, and § 6 S-2's
  pointer.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
