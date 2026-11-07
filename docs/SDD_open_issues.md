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
> **§ 5 names a raiser from outside the SDD's lanes entirely.** §§ 1–4 are all the SDD's own three
> lane seats; § 5 is a seat that never held a lane in it, reading it long after it settled and
> finding something only the SDD can fix.

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-11-07, reading the settled SDD
> against the product at `ka-reader@3fa227e`, where the read-only harness gained the offline-page
> check. One item follows in § 5; the SDD is not edited.

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

### 5.1 The `read-only-harness` row's inventory, pinned at `ka-reader@e95896f`, has no entry for the offline-page check
- **Raised by:** PM — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the row's on-disk inventory and its counts are one script, one suite and one fixture page short.
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L535`), which counts "sixteen suites"; `grep -c 'offline-page' docs/SDD.md` → `0`. At `ka-reader@3fa227e`: `checks/offline-page.sh` (new), whose comparison of a render with the network allowed and one denied is the whole command of the gate step *Offline page, repository* (`checks/gate.sh:L119`), and its suite `checks/tests/test_offline_page.sh`, the whole command of *Offline page suite* (`:L120`) — `ls checks/tests/*.sh | wc -l` → `17`; `checks/fixtures/repo/guide.md` with an in-folder and a remote image reference (`:L5`, `:L7`) and `checks/fixtures/repo/diagram.png`, with `checks/fixtures/repo.git.tar` re-cut; `checks/walk.rs` asking `asset_bytes` for every image node and holding a pages mode; `checks/gate.sh` at version 1.10.0.
- **If a document has to be written:** none — the row is re-measured and re-pinned, naming `offline-page.sh` as a gate step's whole script beside `read-only.sh`.
- **Answer:** <the owner fills this in>
