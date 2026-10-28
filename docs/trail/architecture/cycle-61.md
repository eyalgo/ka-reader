# Architecture open issues — KA-Reader

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the SRS, the SDD
> and the FDR.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-architecture`. It folds your answers into the records and drops the resolved items.
> When nothing is left open, `product-architecture` **deletes this file**: no file = the records are
> done.
>
> Your answers are never thrown away. Each time the Principal Architect folds them in, it first copies
> this file whole to `docs/trail/architecture/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 is raised, not asked.** These records bind every later change, so the seats that live under
> them find gaps the authoring run could not. § 3 is where such a seat says so, against both records
> — an ADR's binding and an NFDR obligation reach the same file.

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-28, from a
> `shukuba-refine` review, to carry item 3.1 below: the NFDR is Settled with no companion beside it,
> so without this file its own producing skill would find nothing to act on.

---

## 1. Open issues — questions with no answer yet

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 §§ 8 and 9 count the gate at 30 steps and the harness at thirteen suites, and § 10's QC-53 row names no suite; at `ka-reader@cd65c02` the gate has 31 steps, fourteen suites, and `checks/strings.sh` has its suite

- **Raised by:** PM — 2026-10-28
- **Which record:** `nfdr.md` § 8, the paragraph **Until the card runs the script** (`docs/nfdr.md:L1678`
  onward; its gate reading at `:L1702-L1712`); § 9, the bullet **The harness's own suites**
  (`:L2092` onward; its suite count and locators at `:L2105-L2122`); and § 10, QC-53's *verified by*
  (`:L1545-L1549`) and its verification-map row (`:L2533`)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-03_no-internal-text-reaches-a-surface`
- **What it blocks:** nothing is blocked. §§ 8 and 9 are pinned to `ka-reader@1b32500` and true of it,
  and by § 9's own wording a suite added to the gate is a re-measurement of those sentences, not a
  contradiction of them.
- **Where it shows:** § 8 says the script is version 1.3.0 with 30 steps at `ka-reader@1b32500`
  (`:L1702`). § 9 says "Thirteen suites are in the tree" and "all thirteen are steps of the gate"
  (`:L2105-L2109`). At `ka-reader@cd65c02`: `git diff --name-status 1b32500 cd65c02 -- checks` lists
  `M checks/gate.sh`, `A checks/strings.sh` and `A checks/tests/test_strings.sh`, and nothing else.
  `checks/gate.sh` is version 1.4.0 (`:L2`, "the suite of the message catalogue lint (NFDR QC-53)
  joins the list") and `grep -c '^run_step' checks/gate.sh` prints 32 — 31 steps and the `run_step()`
  definition at `:L31`. The new step is *Strings check suite* (`:L105`,
  `checks/tests/test_strings.sh`), directly after *No-network suite* (`:L104`), so every gate locator
  after `:L104` that § 9 pins has moved by one. `ls checks/tests/*.sh` lists fourteen suites, the
  thirteen § 9 names and `test_strings.sh`, which pairs with the new script `checks/strings.sh`. No
  step runs `checks/strings.sh` itself yet (`grep -c "checks/strings.sh'" checks/gate.sh` prints 0).
  QC-53's *verified by* and its § 10 row name `checks/strings.sh` and the layer-5 error-path tests, and
  neither names the lint's suite, where § 10's QC-28 row names `test_secret_scan_planted.sh` beside
  its scan. The new step reaches no network: the lint reads `docs/CONTENT.md` and the `.swift` files
  under `ka-reader-mac/Sources/Surfaces/` and nothing else. Measured in a disposable clone at
  `ka-reader@cd65c02` on the host: `checks/strings.sh` exited 0 with `Swift files read: 30; banned
  terms read: 49`, and `checks/tests/test_strings.sh` exited 0, `50 of 50 passed`. The whole gate
  exited 0 in the macOS guest on the tree of `ka-reader@49d0165`, which the merge to `cd65c02`
  carries unchanged.
- **If a document has to be written:** none. The fold would add a dated reading of the 31-step gate and
  fourteen suites at a named commit, with § 9's locators re-pinned and the new suite named, name the
  suite in QC-53's *verified by* and § 10 row as QC-28's are, and keep the `1b32500` readings as dated
  notes.
- **Answer:** Confirmed with two additions — fold it as the item proposes. Add a dated 1.4.0 reading of `checks/gate.sh` at `ka-reader@cd65c02` (31 steps; `grep -c '^run_step'` prints 32, the definition now at `:L31`); count fourteen suites in § 9 with `test_strings.sh` (step `:L105`) paired with `checks/strings.sh`; name `checks/tests/test_strings.sh` in QC-53's *verified by* and its § 10 row as QC-28's rows name their suites; keep every `1b32500` reading as a dated note. **Addition 1 — the locator shift is wider than stated.** The new version line at `:L2` moved every `gate.sh` locator by one, not only those after `:L104`; those after the new step moved by two (`:L49`→`:L50`, `:L59`→`:L60`, `:L60`→`:L61`, `:L61-L66`→`:L62-L67`, `:L67`→`:L68`, `:L85`→`:L86`, `:L104`→`:L106`, `:L107`-`:L109`→`:L109`-`:L111`). Re-pin all of them in § 8 and § 9, not only the ones after `:L104`. **Addition 2 — say how the lint reaches the gate.** No step runs `checks/strings.sh` itself, so QC-53's "CI build" gate holds only through the suite: its case `test_unchanged_catalogue_copy_passes` (`checks/tests/test_strings.sh:L541-L545`) runs the real lint over a copy of the tree's own catalogue and `docs/CONTENT.md`, and fails on a non-zero exit or a `QC-53` line. QC-53's tail says so, matching SDD v60's `read-only-harness` row. § 8's network sentence names *Strings check suite* as a step that fetches nothing, so "two steps reach the network" stays true with it counted. No ADR is owed and no `QC` is added. The reasoning: `docs/trail/architecture/self_answer-63.md`.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
