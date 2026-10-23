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

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 § 9 says the `type == "system"` clause has no check behind it; `checks/no-network.sh` now refuses a system target

- **Raised by:** PM — 2026-10-23
- **Which record:** `nfdr.md` § 9, the Swift-packet bullet — the passage "**The `type == "system"`
  clause holds with no check behind it.**" (`docs/nfdr.md:L2285-L2292` at `ka-reader@c904f8d`) and
  the same bullet's *verified by* tail (`:L2300-L2313`)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-22_the-harness-holds-the-rules-the-code-already-keeps`
- **What it blocks:** nothing is blocked; the obligation is now verified by a script, and the record
  says no script holds it. A reader of § 9 is told a `.systemLibrary` target "would pass every gate in
  the tree" and that the clause waits on review at `development-design`, when the gate already fails
  on one.
- **Where it shows:** the passage says `checks/no-network.sh` "refuses only a non-empty
  `dependencies` array and a target carrying a `url`" and that a refusal of any target of type
  `system` "is owed"; the tail lists the script's conditions as `dependencies` and `url` only, and
  says "no script in the tree reads the dump … for a `system` target (the refusal owed above)". At
  `ka-reader@c904f8d` `checks/no-network.sh` is at version 1.2.0, whose top line says "a Swift target
  of type system is refused, by name" (`checks/no-network.sh:L2`), and refuses a target whose dump
  `type` is exactly the string `system` (`:L159-L164`); its suite `checks/tests/test_no_network.sh`
  (version 1.3.0) registers `test_system_target_fails` (`:L64`, `:L512`). Measured in a disposable
  clone at that commit: the suite exits 0 with 21 `ok` lines, and with only the refusal removed it
  exits 1 with `FAIL test_system_target_fails` and the other 20 green. The tail already names what
  follows — "the day `checks/no-network.sh` refuses a `system` target, that clause's gate is the
  script" — so the sentence would name the script and its case as the clause's gate, list the
  system-target refusal among the script's conditions, and drop only the system-target gap from the
  review rationale, keeping the `development-design` reviews for the seven tools-6.2 items and for an
  added test's framework. The script locators the passage cites (`:L31-L32`, `:L131-L138`, `:L149`)
  name no commit and read against the older script.
- **If a document has to be written:** none — sentences of `nfdr.md`, folded by `product-architecture`.
- **Answer:** Fold it as the item proposes, with four additions. The `type == "system"` clause's gate is now `checks/no-network.sh` (v1.2.0, the refusal at `:L159-L164` at `ka-reader@825bfcd`) with its case `test_system_target_fails` in `checks/tests/test_no_network.sh` (`:L64`, `:L512`); the tail lists the system-target refusal among the script's conditions beside `dependencies` and `url`; "would pass every gate in the tree", "is owed" and "(the refusal owed above)" go, each old reading kept in a dated *(through v64 …)* note as this document does. (1) Re-pin every script locator the passage cites at `ka-reader@825bfcd`, the unpinned `:L31-L32`, `:L131-L138` and `:L149` kept in that note. (2) The `development-design` review on `Package.swift` stays for the six tools-6.2 items no script reads and for an added test's framework; only the system-target ground leaves its rationale. (3) Say what each half holds: the suite drives the script on stubbed dumps, so it holds the refusal's logic, and the gate run reads the real dump on every change; the script fails closed when `swift` or `plutil` is missing or the dump cannot be read (`:L120-L133`). (4) No ADR and no `QC` is owed: a check landing reverses no decision. The Review Notes that state the old gap are history and stay. Reasoning: `docs/trail/architecture/self_answer-60.md`.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
