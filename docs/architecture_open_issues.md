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

### 3.1 § 9 counts fourteen suites at `ka-reader@f25fdbb`; at `ka-reader@3431b7d` there are fifteen, and QC-53 names no check that holds its *Strings check* step in place

- **Raised by:** PM — 2026-10-28
- **Which record:** `nfdr.md` § 9, *The checks have suites* (`docs/nfdr.md:L2183-L2194`, the count's one
  home, and `:L2236-L2239`); § 7 QC-53, *verified by* and "The lint reaches the gate by two paths"
  (`:L1544-L1566`); § 10, QC-53's verification-map row (`:L2624`)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-03_no-internal-text-reaches-a-surface`
- **What it blocks:** nothing is blocked. § 9 says itself that a further suite "is a re-measurement of
  this sentence and not a contradiction of it" (`:L2237`), so the count is owed a refresh, not a fix.
- **Where it shows:** § 9 lists fourteen suites at `ka-reader@f25fdbb`, each a gate step. At
  `ka-reader@3431b7d`, `ls checks/tests/*.sh | wc -l` prints 15: the new one is
  `checks/tests/test_strings_step.sh` (version 1.0.0), the whole command of the gate's *Strings check
  step suite* step (`checks/gate.sh:L113`, directly after *Strings check suite* at `:L112`; the gate is
  version 1.6.0 at `:L2`). It pairs with no script: it reads `checks/gate.sh` and, on copies of it, fails
  when the *Strings check* line (`:L111`) is deleted, naming the step, or moved after *Strings check
  suite*, naming the order; on the unchanged tree it passes. QC-53 says the lint reaches the gate by two
  paths and that with both removed the tree half is checked nowhere; it names nothing that turns the gate
  red when the first path, the *Strings check* step, is removed or moved — and now something does.
  Measured in a disposable clone at `ka-reader@3431b7d` on the host: `27 of 27 passed`; with the line
  deleted, exit 1 naming the missing step; with it moved after its suite, exit 1 naming the order.
  `git diff --name-only 4e50fd1 3431b7d` lists `checks/gate.sh` and the new suite alone.
- **If a document has to be written:** none. The fold would re-measure § 9 at a named commit — fifteen
  suites, the new one named, its step and its unpaired role — and let QC-53, its § 10 row and § 10's
  QC-53 verifier name this suite as the check of the *Strings check* step's presence and order, beside
  the lint and its suite. The `f25fdbb` reading stays as a dated note.
- **Answer:** Confirm the proposed fold, with the verifier's scope made explicit. Re-measure § 9
  at a named commit: fifteen suites, each the whole command of its own gate step, with
  `checks/tests/test_strings_step.sh` as the third unpaired suite alongside `test_vm_refusal.sh`
  and `test_secret_scan_planted.sh` (measured at `ka-reader@f5eb32e3fc6b3eed96b3170924fe0b6aa767fb19`;
  `checks/gate.sh:L52-L119`). Add the new suite to QC-53's verifier and its § 10 row. It checks
  exactly one complete *Strings check* command before the first *Strings check suite* command;
  it checks presence and order, not adjacency or catalogue contents
  (`checks/tests/test_strings_step.sh:L113-L156`, `:L464-L467`). Keep the lint, its own suite and
  the existing Swift error-path cases as distinct verifiers. Update the two-path explanation:
  a remaining content-checking path does not make removal of the direct lint step acceptable,
  because the new suite's independent real-gate case then fails (`:L333-L338`). Carry the same
  re-measurement through § 8's gate paragraph: version 1.6.0, 33 steps
  (`checks/gate.sh:L2`, `:L51-L131`). Retain the `f25fdbb` readings as dated history. No ADR or
  new quality constraint is needed for this verifier refresh. Reasoning, checks and the review
  limit are in `docs/trail/architecture/self_answer-66.md`.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
