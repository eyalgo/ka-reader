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

> **No `product-sdd` run opened this companion. The PM opened it on 2026-09-24.** `SDD.md` is
> Settled at v16 and has no companion on disk, so a `product-sdd` re-run would read it as done and
> find nothing to act on. The companion holds two items, § 5.1 and § 5.2. Each was found by
> measuring the tree on `main` at `nozoki@0aca57e`, where the Tauri build left the tree, against
> this document. Each states a fact the SDD holds that is now false.

---

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 RC-3's *Still unresolved* lists the README's stack sentences as not yet moved, and they have moved
- **Raised by:** PM — 2026-09-24
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing gates on it. RC-3 is where a reader learns what the re-cut still owes,
  and it names as owed something that is done.
- **Where it shows:** `SDD.md:L2321-L2327` (§ 10 RC-3, *Still unresolved*) lists
  "`README.md:L46-L51`'s stack and proof sentences — outside this document (RN-59, RN-60)". The
  dated parenthesis beside it records only the card's move. `README.md` § Stack
  (`README.md:L44-L50` at `nozoki@0aca57e`, moved at `nozoki@61748fe`) now names the one bundle and
  one process, the AppKit shell in Swift (`nozoki-mac`), `crates/nozoki-core` through
  `crates/nozoki-bridge`, no web engine, the fourteen Lucide icons and `checks/`. The status block
  names the same three units (`README.md:L11-L13`). `grep -n -i "tauri\|webview\|nozoki-ui\|typescript" README.md`
  prints nothing.
- **If a document has to be written:** None. **The PM's lean:** a dated parenthesis beside that
  clause, in the form RN-66 gave the card's move, saying the README's sentences moved at
  `nozoki@61748fe`.
- **Answer:** <the owner fills this in>

### 5.2 Three Review Note citations point into files that no longer exist, with no pin
- **Raised by:** PM — 2026-09-24
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Each citation resolved to a file at `HEAD` until `nozoki@0aca57e`, and none
  does now. A reader cannot follow them without knowing which commit they were read at.
- **Where it shows:** `SDD.md:L3293` (`nozoki-ui/src/main.ts:L14-L19`), `:L3294`
  (`crates/nozoki-app/src/main.rs:L17-L19`) and `:L3317` (both again), found with
  `grep -n "crates/nozoki-app/[^\`]*:L[0-9]\|nozoki-ui/src/[^\` ]*:L[0-9]" docs/SDD.md`. Neither file
  exists on `main`: `git ls-files nozoki-ui crates/nozoki-app | wc -l` → `0`.
- **If a document has to be written:** None. **The PM's lean:** pin each to `nozoki@a4ab8e6:`, the
  last commit where both files stood.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
