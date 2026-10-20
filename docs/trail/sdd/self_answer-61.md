# Self-answer report — `docs/SDD.md`

The record of one unattended run that met `docs/SDD_open_issues.md` in the CTO's seat on 2026-10-20
and decided its one item. It is for the owner, who reads it to learn what was decided and on what,
and for the `product-sdd` run that folds the answer.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v54, `Status:` Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-20
- **Sources re-read:** one. GitHub Actions' state on the repository — the row's bound rests on it —
  re-read at its source: `gh api repos/eyalgo/ka-reader/actions/permissions` →
  `{"enabled":false,"sha_pinning_required":false}` on 2026-10-20. Every other claim is inside this
  repository and was read at its own locator at `ka-reader@e602658`, whose tree outside `docs/` is
  `8b93322`'s (`git diff --stat 8b93322 e602658 -- . ':!docs'` prints nothing). Measured in the main
  checkout, read-only: `git diff --name-status 13e8d42 8b93322 -- checks` → `A checks/gate.sh`,
  `M checks/tests/test_vm_refusal.sh`; the same range over `.github/workflows` → `M ci.yml`;
  `git ls-files -s checks/gate.sh` → mode `100755`; `grep -c '^run_step ' checks/gate.sh` → 26;
  `wc -l .github/workflows/ci.yml` → 39; `grep -n 'checks/gate.sh' .github/workflows/ci.yml` →
  `:L26`; `grep -c 'gate\.sh' docs/SDD.md` → 0; `grep -n 'support/vm_refusal.sh' checks/tests/*.sh`
  → the six sourcing lines, `test_vm_refusal.sh`'s at `:L39`.

## Items worked

### 5.1 — The `read-only-harness` row does not name `checks/gate.sh`, and it puts each script and suite on a workflow step of its own

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item's lean holds — add `gate.sh`, say the workflow calls the gate, keep the
  `13e8d42` inventory as history — and it is incomplete, so it is confirmed with what it left out.

  *Check 1.* The edit lands in `docs/SDD.md` § 3, the `read-only-harness` row; the answer binds
  nothing but the row's agreement with the tree; there is no ground I cannot see. The item carries
  `Seat: cto`, which is this run's posture. Mine, in the CTO's seat.

  *Check 2.* The item sits under *Raised from downstream* and carries a lean, so the lean is weighed
  as a draft. It is not a widening: the row's own rule says a file that lands in `checks/` after its
  pin "owes this row an item", and the item cites the occurrence, `checks/gate.sh` at `8b93322`.
  The lean reaches the right conclusion and under-counts what the landing moved. It names the row's
  step sentences and `gate.sh`; it does not name that the changed suite, `test_vm_refusal.sh`, no
  longer "holds the workflow's shape" as the row says at `:L4-L17` — version 1.1.0 reads the gate's
  `run_step` list (`checks/tests/test_vm_refusal.sh:L61-L76`, cases `:L193-L238`) and reads the
  workflow only for its single gate step, for the absence of a conditional step and for its runner
  image (`:L211-L220`, `:L240-L243`, `:L245-L250`); that one of the six helper-sourcing locators
  moved (`:L36` → `:L39`); that the
  script count moves to eleven while the suite count stays eleven, because the runner has no
  `test_gate.sh`; or that every `ci.yml` locator in the cell now names a line past the end of a
  39-line file. Each of those is added. The item is one question — one cell, one landing — and it
  does not split.

  *Check 3.* Nothing settled moves. `docs/nfdr.md` QC-64 asks for exactly this script and says the
  workflow holds no rule of its own; the re-said row agrees with it and still names the script, not
  the rule. The row's existing sentence that § 9's suite count is the NFDR's — carried by
  `docs/architecture_open_issues.md` § 3.3 — still resolves: that companion's § 3.3, open today, is
  § 9's suites-as-steps item. The one source outside the repository the answer leans on, Actions
  being off, was re-read today and still holds. The row's convention of keeping an earlier pin as
  a dated note is kept, so the `13e8d42` inventory becomes history exactly as `b12e48c`'s did.

  *Check 4.* **Stale** — the re-measurement is pinned to `8b93322`, the merge that landed the
  script, and the tip read holds its tree outside `docs/`. **Absent** — Actions is disabled, so the
  gate's hosted result is unread; the row says what is on disk and on which step, not that a step
  is green, and the guest run at `726a234` is the NFDR companion's reading (§ 3.2), not this row's.
  **Concurrent** — the NFDR's § 9 rule is moving under its own companion at the same time; the row
  states disk and gate shape and leaves the rule to that record, so the two cannot contradict.
  **Empty / Refused** — not reached by a measurement of files on disk.

  *The addition outside the row, and why it is not a raised item.* Reading the SDD whole for this
  answer found one other live sentence the same landing made false: § 4 C-I3's
  "CI runs the same script after `assemble.sh` on every push (`.github/workflows/ci.yml:L41`,
  `:L51`)" at `docs/SDD.md:L857` — two lines a 39-line file does not have. Every other `ci.yml` line
  locator in the SDD is either pinned to a named commit in the text around it (§ 6 S-4 at `:L2086`,
  `:L2089`, `:L2102`), or sits in the Review Notes or the version log, which are history. § 6 S-1's
  "`ci.yml` builds `KA-Reader.app` and runs every script below on every push" (`:L1720`) stays true
  through the gate. I was close to raising the C-I3 locators as a § 2 item under *The items are not
  the whole of what a document is owed*. I did not, because it is the same cause, the same seat and
  the same fold as the item being answered, and a raised item's slot stays at its placeholder, which
  would hold one sentence's re-pin back a whole round for nothing a reader gains. It is named in the
  slot as an addition the fold makes in the same pass; if the fold reads it as beyond the item, the
  cost is that one sentence, and the owner has this paragraph.

  *Not written into the slot.* The project card's `Test command:` does not run `checks/gate.sh`
  yet — the seed's third piece, and `docs/architecture_open_issues.md` § 3.2's gap. The row does not
  speak of the card and the answer does not either; it is `product-card`'s, by the seed's own
  routing, and no field of the card is owed anything by this answer.

  *A reading corrected before this was committed.* A first pass of this run read the suite's
  `CASES` list as naming a function the file did not define, `test_every_runner_names_macos_26`;
  the pattern used to list functions left out names with digits. The function is at
  `checks/tests/test_vm_refusal.sh:L245-L250` and reads every workflow's `runs-on:`. Nothing is
  owed to `checks/` from this run.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/SDD.md** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
