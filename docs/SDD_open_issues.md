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
> **§ 5 names a raiser from outside the run entirely** — a seat that never wrote the SDD, reading it
> long after it settled and finding something only the SDD can fix.

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-01 from the SDD's own
> companion template, while re-reading the route after `select_file` was first built, because `SDD.md`
> is Settled and with no companion on disk a `product-sdd` re-run reads it as done and has nothing to
> act on. Both items are in § 5; §§ 1–4 hold nothing.

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

### 5.1 C-R7 and C-I3 do not say what holds while a slice is built across several changes
- **Raised by:** PM — 2026-10-01
- **Tracked by:** `nozoki · nemawashi · 2026-10-01_a-file-reads-in-the-panel`
- **What it blocks:** nothing is blocked; two sentences read false on product `main` today and stay
  false until `read-a-file` is whole, so a reader checking the build against them finds a violation
  the design did not intend.
- **Where it shows:** § 4 C-R7 says "a function whose slice has not landed is never exported", and
  SM-4 says each function is "exported from the build in which a slice lands it and not before".
  `nozoki_select_file` is exported now (`crates/nozoki-bridge/tests/exports.rs` admits it; `cargo test
  --locked -p nozoki-bridge --test exports` passes, 10 tests), while § 6 S-2's highlighter and
  read-only bars are not yet met. § 4 C-I3 says `checks/read-only.sh` "exercises every command the build
  grants"; the walk it drives calls `list_tree` alone (`crates/nozoki-core/tests/walk.rs:L1-L6`), so
  `select_file` is granted and not exercised. The SDD should state which reading binds: that a slice's
  function is exported from the first change that builds it, with C-I3 naming what covers the read until
  the walk drives `select_file` (`cargo test --locked -p nozoki-bridge --test select_file` holds
  `checks/fixtures/text/` byte-identical today); or that the export waits for the slice whole.
- **If a document has to be written:** none — a sentence in C-R7, SM-4 and C-I3.
- **Answer:** <the owner fills this in>

### 5.2 § 3 gives `folder-model` the open file, and the built product holds it in `surfaces`
- **Raised by:** PM — 2026-10-01
- **Tracked by:** `nozoki · nemawashi · 2026-10-01_a-file-reads-in-the-panel`
- **What it blocks:** `follow-the-folder`, whose bar refreshes the open file and states its file-gone
  state, reads the open file where § 3 puts it — in the model the core keeps — and the core holds none.
- **Where it shows:** § 3 gives `folder-model` "the selection and expansion, the open file" and the
  open `FileView` (`docs/SDD.md:L325`, `:L435`, `:L443`). In the product, `select_file` in
  `crates/nozoki-core/src/folder_model.rs` reads and returns a verdict and keeps nothing; the selection
  and the shown file live in `nozoki-mac/Sources/Surfaces/WorkbenchView.swift:L75-L93`. The SDD should
  say whether the open file moves into `folder-model` with `follow-the-folder`, or whether § 3 should
  place it in `surfaces`.
- **If a document has to be written:** none — § 3's `folder-model` and `surfaces` rows, and
  `follow-the-folder`'s *Rests on*.
- **Answer:** <the owner fills this in>
