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

### 2.1 § 8 says the card's command does not run `checks/gate.sh` yet; it has run it since 2026-10-20

> **No `product-architecture` run wrote this item.** A `companion-self-answer` run raised it on
> 2026-10-22, in the Principal Architect's seat, while answering § 3.1 and § 3.2 of this file. No item
> asked for it. Reading § 8 whole to answer § 3.1, the run found the paragraph that § 3.1's sentence
> sits in describing a project card that has since moved. The reasoning is at
> `docs/trail/architecture/self_answer-56.md` § Raised on this document.

- **Lands in:** `nfdr.md` § 8 — the opening paragraph's quote of the card's test command and its pin
  (`docs/nfdr.md:L1498-L1524`), and *Until the card runs the script* (`:L1598-L1619`) — and every
  sentence that reads under that paragraph: QC-56 (`:L1641-L1643`), QC-64 (`:L1754-L1757`), QC-65
  (`:L1812-L1815`), § 9's harness-suites bullet (`:L2052-L2055`), § 9's `ka-reader-mac` bullet
  (`:L2242-L2244`), and RN-6, which the opening paragraph says is extended when the card moves.
  *(Line locators re-measured at NFDR v61, whose fold of §§ 3.1 and 3.2 inserted text above them; the
  passages themselves are unchanged. Those two items, which this one was raised beside, are answered
  and folded — `docs/trail/architecture/cycle-54.md`, NFDR RN-72. The v61 fold added a 27-step
  reading of the gate inside *Until the card runs the script*; it sits under this item like the rest
  of that paragraph.)*
- **Drafted into the records:** nothing yet. The change is proposed here, and only the fold may write
  it.
- **Rationale:** the paragraph is false now. § 8 quotes the card's test command as `cargo test
  --workspace --locked && ka-reader-mac/assemble.sh && swift test --package-path ka-reader-mac &&
  checks/structure.sh && checks/tests/test_structure.sh`, pinned at `kensaiapp-opensource@a4204e5b`.
  It also says the card's move to `checks/gate.sh` "is owed to `product-card`". The move landed at
  `kensaiapp-opensource@1941f963` (2026-10-20 17:14, "product-card: ka-reader — the test command runs
  checks/gate.sh (NFDR v59 § 8)"). The comment beside it landed at `85264c69`. The card's
  `**Test command:**` line now reads `checks/gate.sh` (`system/projects/ka-reader/project.md:L8` in
  the managing instance). Both commits landed two minutes after NFDR v59 (`ka-reader@2baeecf`, 17:12),
  and v60 (`ka-reader@435bb4e`) did not fold them. The paragraph says itself that it "goes false at the
  card's next move until RN-6 is extended". That move has happened. The consequence matters more than
  the quote. Five passages make `development-design` the gate for a rule because "no run issues" the
  script at a change. At `1941f963`, the card's command is the script, so a run does issue it. The
  fold would re-read the card, re-pin § 8 to it, extend RN-6, and re-derive each "until" against the
  card as it stands. A gate the script now holds moves to the script. A gate that rests on something
  else stays and names that ground; QC-64's *nothing else* half is one of these. Each pinned reading
  of an earlier tree stays as a dated record.
- **If overridden:** § 8 keeps describing a card that does not exist. Five entries keep naming a
  review as the only gate for rules a run now holds at every change. A contributor who reads them
  waits on a review that is no longer the only thing protecting them. Nothing supersedes and no ADR
  moves.
- **Confirm or override:** confirm — with four additions: QC-56's `.yaml` half keeps its review gate beside QC-64's *nothing else* half; QC-65's "the card's command runs none of these steps" and its owner's-Mac cost are re-read as live, and its refusal-first ordering recorded as met (`ka-reader@13e8d42` before `kensaiapp-opensource@1941f963`); the ground is the card plus § 8's own gate-tool sentence, citing no change record; and the card's `Test command:` comment points at *Until the card runs the script* by name, so a renamed heading is a card move to raise, not to make. Reasoning: `docs/trail/architecture/self_answer-57.md`.

## 3. Raised from downstream — an item from a seat that did not write these records

None.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
