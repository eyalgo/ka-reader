# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-14
- **Sources re-read:** None outside this repository. The answer rests on the product's own tree,
  re-read at `main` for this run: `docs/nfdr.md` v100 § 5 (`:L1793-L1817`),
  `ka-reader-mac/Tests/ShellTests/GitViewMemoryBoundTests.swift:L8-L18`, `checks/gate.sh:L98-L105`,
  the header of `checks/git-view-memory.sh`, `docs/SRS.md` NFR-1, NFR-2, NFR-10 and a search of it
  for "memory", and `docs/SDD.md` RN-175. `git diff --stat 21f611f HEAD -- . ':!docs'` prints
  nothing, so every locator read at `main` is also its reading at `ka-reader@21f611f`.

## Items worked

### 2.1 — § 5 does not say where the Git view's memory ceiling stands against QC-45

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** **§ 5 should name the Git view's memory ceiling beside QC-45, as a regression bound and
  not a requirement. It should point at the suite's constant, not own the number, and it should say
  why the figure is outside QC-45's ban.** The previous run of this skill raised the item on this
  file, so this run weighed its own colleague's draft. It did not take the draft on trust.

  *Seat.* The edit lands in `nfdr.md` § 5, this companion's own document. The answer commits no
  person and no promise. It reports what the SRS already holds — no memory figure (a search of
  `docs/SRS.md` for "memory" finds only `:L459`, a data model "held in memory, never persisted") —
  and it leaves making one a requirement to the SRS by revision, under QC-45's own rule. I
  considered whether calling the figure "not a requirement" says something to the tool's public
  readers that only the owner may say. It does not: the sentence describes the requirements
  document as it stands, and it neither adds nor withdraws a promise. So the item is answered in
  the owner's seat.

  *Is the draft sound?* Its conclusion holds. One of its two reasons no longer does. The draft says
  the item "costs no extra run" because §§ 3.1–3.2 already owed the file a fold. That fold has now
  happened (NFDR v100, RN-110), and this item is the only thing keeping the companion open. A
  `product-architecture` round is owed whichever way it is answered: confirm, and the round writes
  the sentence; override, and the round still has to clear the item and remove the companion. So
  cost decides nothing either way. The reason that carries the weight is the draft's other one, the
  cold reader. § 5 says it "asserts no number of its own" (`docs/nfdr.md:L1795-L1797`), and QC-45
  opens "A performance number is measured, never asserted" (`:L1799`). Meanwhile
  `GitViewMemoryBoundTests.swift:L18` holds `riseBound = 154_000_000`, and the gate's *Git view
  memory bound* step (`checks/gate.sh:L104`) holds it at every change. A reader who meets both
  cannot tell whether the suite breaks QC-45 or the NFDR has not noticed it. The tool ships with
  this NFDR, so that reader is a stranger, and they get no one to ask.

  *Check 3 — what it must agree with.* The draft's claim that the figure "breaks no rule as
  written" holds, and it holds on a narrow reading of QC-45. QC-45's lead clause reads as general,
  but its colon clause names exactly three kinds of number: file-switch latency, refresh latency,
  and a reference folder size. A rise in resident memory is none of them. The delivery tier read
  QC-45 the same narrow way when it wrote the figure, and it checked the change against QC-45 by
  name. No SRS, SDD or FDR revision carries 154,000,000. The SDD records it only as the suite's
  (§ 3 `read-only-harness`, RN-175). So the sentence has to state the narrow reading out loud.
  Otherwise the next reader has to rebuild it. That is **addition 2**. The repository the suite
  drives is the defect's reproduction, as the suite's own comment says
  (`GitViewMemoryBoundTests.swift:L8-L13`). It is not a reference size under NFR-10. Without that
  clause, QC-45's third named kind looks like it applies.

  *Check 4 — failure paths.* **Stale:** the constant is the delivery tier's and will move if the
  fix is retuned. If § 5 restates the number as its own, the NFDR gets a second copy of the figure,
  and that copy goes false the day the constant changes. So § 5 points at the constant by locator,
  pinned at `ka-reader@21f611f`, and quotes the figure as a reading at that commit. This is how the
  NFDR treats every other measured locator, and it keeps § 5's own "asserts no number" true. That is
  **addition 1**. **Concurrent:** a second suite may later assert another memory or time figure.
  The sentence does not reach it, and I am leaving that case out on purpose rather than widening § 5
  for a case that has not happened. QC-45's existing review at `development-design` already reads
  any new figure. That is **addition 3**, stated as a named uncovered case. **Refused:** if the SRS
  later carries a memory number, QC-45 takes it by its own rule, and this sentence is superseded in
  that round. **Empty** and **absent** add nothing here, because the sentence describes a figure
  and runs nothing.

  No obligation changes, no `QC` is added, and no ADR is owed. A sentence describing where a test's
  constant stands involves no trade-off this product made. I was close to plain *confirmed*. What
  tipped it was the stale case. A § 5 that owns the number would make the NFDR the figure's second
  home, and that is the drift this item exists to prevent.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
