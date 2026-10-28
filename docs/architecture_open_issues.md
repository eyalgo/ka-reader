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

### 3.1 QC-53, § 8, § 9 and § 10 say no gate step runs `checks/strings.sh` itself and count the gate at 31 steps; at `ka-reader@f25fdbb` the lint is a step of its own and the gate has 32

- **Raised by:** PM — 2026-10-28
- **Which record:** `nfdr.md` § 7 QC-53, *verified by* (`docs/nfdr.md:L1546-L1559`); § 8, the paragraph
  **Until the card runs the script**, its gate reading (`:L1725-L1742`); § 9, the bullet **The harness's own
  suites**, its gate locators and the sentence on `test_strings.sh` (`:L2138-L2147`); § 10, QC-53's
  verification-map row (`:L2570`)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-03_no-internal-text-reaches-a-surface`
- **What it blocks:** nothing is blocked. Each reading is pinned to `ka-reader@cd65c02` and true of it. But
  QC-53's tail says the suite's catalogue-copy case is "the lint's only path into the gate", and that is no
  longer so.
- **Where it shows:** QC-53 says "No step of the gate runs `checks/strings.sh` itself … so the lint reaches the
  CI build gate through its suite alone" and "That one case is the lint's only path into the gate"
  (`:L1549-L1555`). § 8 reads `checks/gate.sh` as version 1.4.0 with 31 steps, "and no step runs
  `checks/strings.sh` itself" (`:L1729-L1732`). § 9 says `test_strings.sh` pairs with "`checks/strings.sh`,
  which no step runs itself: the lint reaches the gate through its suite" (`:L2146-L2147`). The § 10 row
  says the lint reaches the gate through its suite (`:L2570`). At `ka-reader@f25fdbb`, `checks/gate.sh` is
  version 1.5.0 (`:L2`, "the message catalogue lint itself (NFDR QC-53) joins the list, before its suite";
  1.4.0 is now at `:L3`). `grep -c '^run_step' checks/gate.sh` prints 33: 32 steps, `:L50-L129`, and the
  `run_step()` definition at `:L32`. The new step is *Strings check*, `run_step 'Strings check'
  'checks/strings.sh'` at `:L110`, directly after *No-network suite* (`:L105`) and directly before *Strings
  check suite* (`:L111`). The comment at `:L106-L109` says why it comes first. *Own state suite* is now at
  `:L112`. Every `gate.sh` locator these sections pin moved: by one for the new version line, and by five
  more after `:L105` for the comment and the step. `git diff --name-status cd65c02 f25fdbb -- checks` lists
  `M checks/gate.sh` alone. The suite count is unchanged, with fourteen suites (`ls checks/tests/*.sh | wc -l`).
  The new step fetches nothing: it runs the same lint over `docs/CONTENT.md` and the `.swift` files under
  `ka-reader-mac/Sources/Surfaces/`. Measured in a disposable clone at `ka-reader@f25fdbb` on the host:
  `checks/strings.sh` exited 0 (`Swift files read: 30; banned terms read: 49`). With a banned word planted in a
  string literal of `GitSentences.swift`, the gate from *Strings check* onward exited 1. Its last stderr lines
  were a `QC-53` line naming the file and `"repo"`, then `gate.sh: step failed: Strings check`. The whole gate
  exited 0 in the macOS guest at `ka-reader@2ea9323`, whose tree `f25fdbb` carries unchanged
  (`git diff --stat 2ea9323 f25fdbb` prints nothing).
- **If a document has to be written:** none. The fold would add a dated 1.5.0 reading of the 32-step gate at a
  named commit, re-pin the `gate.sh` locators in §§ 8 and 9, and say in QC-53, § 9 and the § 10 row that
  *Strings check* runs the lint on the tree, beside the suite. It keeps the `cd65c02` readings as dated notes.
  The layer-5 error-path half of QC-53 is untouched.
- **Answer:**

**How it closes.** `product-architecture` folds it on its next run like any other item here.
