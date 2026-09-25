# SDD open issues — nozoki

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

> **No `product-sdd` run opened this companion. The PM opened it on 2026-09-25.** `SDD.md` is
> Settled at v18 and has no companion on disk, so a `product-sdd` re-run would read it as done and
> find nothing to act on. The companion holds one item, § 5.1. It comes from measuring the tree on
> `main` at `nozoki@46bb275` against the containment check § 3 defines. The measurement found one
> spelling of a path for which the check's definition and the product's answer disagree.

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

### 5.1 The containment check is defined on the canonical path, and a path that leaves the grant and names it again in another letter case cannot be canonicalized without touching outside it
- **Raised by:** PM — 2026-09-25
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** which mark the tree gives one form of link, and so what the link's row says.
  § 3 `fs-reader` defines the containment check as "a canonical path, symlinks resolved and
  percent-decoding applied, is inside the granted folder or it is refused" (`docs/SDD.md:L321`).
  QC-35 says the product reads nothing outside the granted folder (`docs/nfdr.md:L579-L580`). The
  reader meets both by walking a path lexically while it lies outside the grant and reading nothing
  there (`crates/nozoki-core/src/fs_reader.rs:L170-L177`). The two agree on every spelling but one.
  That spelling is a link inside the folder that steps out to the folder's parent and names the
  folder again in another letter case, `back → ../<FOLDER NAME IN CAPITALS>`. On this Mac's volume,
  and on CI's `macos-14`, that path's canonical form is the granted folder itself. The product
  answers `Outside`. Measured by a throwaway probe on `nozoki@46bb275`: `back → ../<NAME>` lists
  `Failed(Outside)` beside `same → ../<name>`, which lists `Failed(Cycle)`. So the row tells the
  reader that the link leads outside the folder when it leads to the folder itself, which UX-I4
  forbids. The FDR's R-152 would mark it a cycle.
- **Where it shows:** § 3's `fs-reader` row, the containment check's definition. The SDD does not
  say whether the check may compare spellings while a path lies outside the grant, or must reach the
  canonical form, and reaching it means asking the filesystem about a path outside the grant. How
  the reader answers this spelling follows from that choice.
- **If a document has to be written:** none. `SDD.md` § 3 states which of the two the check is,
  using `product-sdd`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
