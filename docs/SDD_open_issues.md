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

> **No `product-sdd` run opened this companion. The PM opened it on 2026-09-23.** `SDD.md` is
> settled at v8 and had no companion on disk. Without one, a `product-sdd` re-run would read the SDD
> as done and find nothing to act on. The companion holds one item, § 5.1.

---

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 C-I3's "a red run says how long it waited" does not say whether it covers a run ended by a failed ask
- **Raised by:** PM — 2026-09-23
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing is waiting on it to be built. But one sentence can be read two ways,
  and `docs/nfdr.md` QC-25 copies it (`nfdr.md:L253-L254`). C-I3 says "the script prints the bound
  in the probe's output, so a red run says how long it waited" (`SDD.md:L537-L538`). The same
  clause names two failures that do not wait out the window. One is "a process gone before the pass
  is a failure" (`:L540-L541`). The other is `sandbox_check` returning "an error on any ask"
  (`:L556`). A reader cannot tell whether "a red run" includes these two.
- **Where it shows:** In `checks/bundle.sh` as it stands on `main` (`0877635`). When the window runs
  out, the red line states the bound: "no ask held all three within <N> asks, 0.25 s apart"
  (`:L375`). When an ask fails, the run ends at once with "the operating system's sandbox report for
  pid <pid> could not be read: …" (`:L338`). That line states no bound and does not say which ask
  failed. A gone process takes this path too, because the probe refuses a pid that names no
  process (`checks/sandbox_probe.rs:L103-L115`). The negative control's failed ask ends the same way
  (`bundle.sh:L303`).
- **If a document has to be written:** None. What is owed is one clause in C-I3 saying which red
  runs state the bound. **The PM's lean:** the sentence reaches only a run that ends when the window
  runs out. A failed ask ends the run at once and names what failed, and a run that did not wait has
  no wait to report. Stating this in C-I3 keeps the script as it stands and closes the question.
  **The doubt:** on a hosted runner, a gone process is the failure where knowing *when* matters most.
  An ask count on the failure line would say whether the process died at launch or late in the
  window. If the seat wants that, C-I3 should say "a red run says how long it waited, or on which
  ask it ended", and the script owes that line a change.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
