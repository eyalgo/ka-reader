# SDD open issues — ka-reader

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
> measuring the tree on `main` at `ka-reader@0aca57e`, where the Tauri build left the tree, against
> this document. Each states a fact the SDD holds that is now false.

---

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 RC-3's *Still unresolved* lists the README's stack sentences as not yet moved, and they have moved
- **Raised by:** PM — 2026-09-24
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing gates on it. RC-3 is where a reader learns what the re-cut still owes,
  and it names as owed something that is done.
- **Where it shows:** `SDD.md:L2321-L2327` (§ 10 RC-3, *Still unresolved*) lists
  "`README.md:L46-L51`'s stack and proof sentences — outside this document (RN-59, RN-60)". The
  dated parenthesis beside it records only the card's move. `README.md` § Stack
  (`README.md:L44-L50` at `ka-reader@0aca57e`, moved at `ka-reader@61748fe`) now names the one bundle and
  one process, the AppKit shell in Swift (`ka-reader-mac`), `crates/ka-reader-core` through
  `crates/ka-reader-bridge`, no web engine, the fourteen Lucide icons and `checks/`. The status block
  names the same three units (`README.md:L11-L13`). `grep -n -i "tauri\|webview\|ka-reader-ui\|typescript" README.md`
  prints nothing.
- **If a document has to be written:** None. **The PM's lean:** a dated parenthesis beside that
  clause, in the form RN-66 gave the card's move, saying the README's sentences moved at
  `ka-reader@61748fe`.
- **Answer:** Confirmed, with one addition. RC-3's *Still unresolved* keeps its words and gets a
  dated parenthesis in the form RN-66 used for the card: *(the README moved: `## Stack` and the
  status block now name the one bundle and one process, `ka-reader-mac`, `crates/ka-reader-core` and
  `crates/ka-reader-bridge`, and no web engine, and they keep the `checks/` proof sentence word for
  word, `ka-reader@61748fe`; the sentences this clause cites stand at
  `ka-reader@a4ab8e6:README.md:L46-L51`; noted 2026-09-24)*. The addition: two other sentences
  still name the README as owed, and they get the same parenthesis. They are RN-59's
  `README.md:L46-L49` and RN-60's *Owed outside this document*. RN-66 did the same for the card,
  on RC-3 and on RN-60. Reasoning: `docs/trail/sdd/self_answer-24.md` § 5.1.

### 5.2 Three Review Note citations point into files that no longer exist, with no pin
- **Raised by:** PM — 2026-09-24
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Each citation resolved to a file at `HEAD` until `ka-reader@0aca57e`, and none
  does now. A reader cannot follow them without knowing which commit they were read at.
- **Where it shows:** `SDD.md:L3293` (`ka-reader-ui/src/main.ts:L14-L19`), `:L3294`
  (`crates/ka-reader-app/src/main.rs:L17-L19`) and `:L3317` (both again), found with
  `grep -n "crates/ka-reader-app/[^\`]*:L[0-9]\|ka-reader-ui/src/[^\` ]*:L[0-9]" docs/SDD.md`. Neither file
  exists on `main`: `git ls-files ka-reader-ui crates/ka-reader-app | wc -l` → `0`.
- **If a document has to be written:** None. **The PM's lean:** pin each to `ka-reader@a4ab8e6:`, the
  last commit where both files stood.
- **Answer:** Confirmed, with one addition, and the reason corrected. Pin each citation to
  `ka-reader@a4ab8e6:`. That covers `ka-reader-ui/src/main.ts:L14-L19` and
  `crates/ka-reader-app/src/main.rs:L17-L19` at `SDD.md:L3293`, `:L3294` and `:L3317`. The addition:
  `crates/ka-reader-app/Entitlements.plist` at `SDD.md:L3318` is a fourth citation into a removed
  file, and it gets the same pin. The item's grep matched only line-anchored paths, so it missed
  this one. The corrected reason: `a4ab8e6` is not the last commit where the files stood (the
  merged branch's `5d37fae` is later). It is the last commit on `main`'s first-parent line before
  the removal merged. Also, all three files are byte-identical from `ba63b44`, the run-10 commit
  that wrote these citations, through `a4ab8e6`, so the pinned lines are the ones the note read.
  Reasoning: `docs/trail/sdd/self_answer-24.md` § 5.2.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
