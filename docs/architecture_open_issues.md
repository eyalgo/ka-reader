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

> **No `product-architecture` run wrote this file.** The owner opened it on 2026-10-16, in an
> interactive session, to carry one item met after `2026-10-14_the-model-holds-the-place` was sealed.
> The records are Settled, so without a companion it would reach no one.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 The structure rules are gated only at the CI build, so a change that breaks them is sealed first
- **Raised by:** Product (owner) — 2026-10-16
- **Which record:** `nfdr.md` § 10, the *Gated at* column of every row naming `checks/structure.sh`
  (QC-2, QC-7, QC-9 – QC-12 and QC-14, QC-63, and the rest of the script's scan table), and § 8, which
  states the card's test command as the change-time gate.
- **Tracked by:** no seed.
- **What it blocks:** nothing outright. But a change can now be sealed while it breaks a rule § 10
  holds at the CI build. The chain gates on the card's test command and never reads CI.
  - `2026-10-14_the-model-holds-the-place` added doc examples to `folder_model.rs` that wrote through
    `std::fs` (`ka-reader@f1280b6`). `checks/structure.sh` counts comments, so it drew 16 QC-2 and QC-15
    findings. CI failed at *Structure check* on the change branch (run 38673999031). The chain sealed
    and merged the change anyway (`ka-reader@21cfd34`), because the card's command was green.
  - The developer's review, the code-integrity run and the four audits all missed it. The developer's
    review read "no filesystem write" in the code and not in the doc comments.
  - Fixed on main in `ka-reader@527f030`. That repairs this instance, not the gap.
- **Where it shows:** the card's `Test command:` comment reads "The checks/*.sh harness gates CI and
  release, not this field (NFDR § 10)". Measured on the owner's Mac on 2026-10-16:
  `checks/structure.sh` takes 0.8 s; `checks/tests/test_structure.sh` takes 2 min 20 s; both run on
  macOS, as CI does.
- **The question:** should § 10 gate `checks/structure.sh` and its suite at the change as well as the
  CI build, so the card's test command runs both?
- **If a document has to be written:** none in these records beyond a fold into § 10 (the *Gated at*
  column) and § 8 (the card's command as quoted). The card itself is `product-card`'s, after the fold.
- **Answer:** Yes. The owner's call, 2026-10-16: the card's test command runs `checks/structure.sh`
  and `checks/tests/test_structure.sh`, both, on every change. The suite's 2 min 20 s is accepted, so
  a change that edits `checks/` is caught at the change too. The other `checks/*.sh` scripts stay
  where § 10 has them.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
