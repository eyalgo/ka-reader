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

### 2.1 § 5 does not say where the Git view's memory ceiling stands against QC-45

> A `companion-self-answer` run raised this item on 2026-11-14
> (`docs/trail/architecture/self_answer-96.md`, *Raised on this document*). No producing run wrote it.
> It came from reading the NFDR against the tree while answering § 3.1: the step that item names runs
> a suite asserting a memory number, and § 5 says the records assert none. Its slot is left for the
> next round.

- **Lands in:** `nfdr.md` § 5 (QC-45, or a sentence beside it). No ADR.
- **Drafted into the records:** nothing yet. The lean is that § 5 names the ceiling and says what it
  is. `ka-reader-mac/Tests/ShellTests/GitViewMemoryBoundTests.swift:L18` at `ka-reader@21f611f`
  asserts that the process's peak resident size rises by at most 154,000,000 bytes while the Git view
  is driven over a large repository, and the gate's *Git view memory bound* step holds it at every
  change (`checks/gate.sh:L104`). § 5 would state that this ceiling is a regression bound the
  delivery tier set from the owner's walk of a large repository. It is not a product requirement, it
  binds no change's bar beyond that suite, and making it one is the SRS's by revision, under QC-45's
  own rule. QC-45 names file-switch latency, refresh latency and a reference folder size, and no
  memory figure, so the ceiling breaks no rule as written. No obligation changes.
- **Rationale:** § 5 opens by saying the SRS leaves every number unset and that the section "asserts
  no number of its own" (`docs/nfdr.md:L1795-L1797` at v100; `:L1794-L1796` at v99). QC-45 opens "A performance number is measured,
  never asserted". No SRS, SDD or FDR revision carries the 154,000,000-byte figure. The SDD records
  it only as the suite's, in § 3's `read-only-harness` row (RN-175). So since `21f611f` a cold reader
  meets a gated, asserted capacity number that § 5 does not mention. That reader cannot tell whether
  the suite breaks QC-45 or the NFDR has not seen it. The run is unsure the gap is worth a cycle,
  because nothing in § 5 is false as worded. It is raised because §§ 3.1–3.2 already owe this file a
  fold, so naming the ceiling costs no extra run.
- **If overridden:** § 5 stays silent on the ceiling. The suite stays as it is, and QC-45's opening
  sentence keeps reading against a number it does not name.
- **Confirm or override:** confirm, with an addition. § 5 names the ceiling beside QC-45, as
  drafted, on a corrected reason: this item alone now keeps the companion open, so a round is owed
  whichever way it is answered and cost decides nothing; what decides it is the cold reader, who
  meets "asserts no number of its own" and "A performance number is measured, never asserted"
  beside a memory figure the gate asserts at every change. **Addition 1:** § 5 points at the figure
  and does not own it — it names `ka-reader-mac/Tests/ShellTests/GitViewMemoryBoundTests.swift:L18`
  (`riseBound`) and `checks/gate.sh:L104`, pinned at `ka-reader@21f611f`, and quotes
  154,000,000 bytes as a reading at that commit, so a later change to the constant leaves § 5
  dated and not false, and § 5 itself still asserts no number. **Addition 2:** the sentence says
  why the figure sits outside QC-45: QC-45's ban names three kinds of number — file-switch
  latency, refresh latency and a reference folder size — and a rise in resident memory is none of
  them; the figure guards the fix for the defect the suite's own comment names
  (`GitViewMemoryBoundTests.swift:L8-L13`), and its repository is that defect's reproduction, not
  a reference size. **Addition 3, a named uncovered case:** the sentence covers this suite's figure
  only; a later suite that asserts another memory or time figure is read by QC-45's existing review
  at `development-design`, and § 5 names it only on a later round. No obligation and no ADR
  changes. Reasoning: `docs/trail/architecture/self_answer-97.md`.

## 3. Raised from downstream — an item from a seat that did not write these records

None.
