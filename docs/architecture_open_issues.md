# Architecture open issues — Nozoki 覗き

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

> **Written by the `product-architecture` run of 2026-09-04 that folded cycle 3**
> (`docs/trail/architecture/cycle-3.md` — the owner's answer on the 38 citations the SDD's re-author
> broke). Both items below were found while folding it, read against the re-authored SDD
> (`docs/SDD.md` v3, `nozoki@827aa1c`); neither was asked by that answer, and the fold did not widen
> for them. What that run did move is `docs/nfdr.md` RN-16.

---

## 1. Open issues — questions with no answer yet

### 1.1 The SDD's confirmed 1.0.0 contract prices own-state readability nowhere; the FDR and QC-59 price it
- **Lands in:** `nfdr.md` QC-59, QC-60 — where the answer moves one of them. Where it moves the
  SDD instead, nothing lands here: the sentence owed is `docs/SDD.md` § 6 S-11's, the CPO's, through
  the SDD's own run.
- **Why it matters:** two owner-confirmed statements of the 1.0.0 contract disagree on one member.
  `docs/fdr.md` PD-39 — *"From 1.0.0 the readability of an earlier version's own state is inside the
  public contract: a discard is a breaking change and takes a major version"* — was confirmed at
  `docs/trail/fdr/cycle-1.md` § 2.9, and QC-59 carries it as the contract's third member, with QC-60
  binding the discard. The re-authored SDD's § 6 S-11 *Delivers*, confirmed as drafted at
  `docs/trail/sdd/cycle-2.md` § 2.2, states what the number prices as *"the one install path and the
  macOS floor, and every surface the PRD names present"*, places *"own state read whole or discarded
  whole, touching no folder (§ 4 C-D4)"* in the set no version changes, and names four exclusions;
  readability across versions is in none of the three, and C-I6's pin — the floor, the asset names,
  the command list — does not read it. A reader of S-11 alone concludes a discard costs no version; a
  reader of PD-39 concludes it costs a major. The README at 1.0.0 states the contract in S-11's words
  (S-11 *Reached when*), so the gap reaches a stranger, not only a trace. My reading, offered and not
  drafted: the FDR is right and complete — PD-39 was answered with its reasoning, and the SDD's own
  C-D4 already traces its discard clause to C-6 — so QC-59 and QC-60 stand as written, and S-11 is
  owed the member, a CPO fold; nothing in these records moves either way. If instead S-11 is the
  whole contract, QC-59 drops its third member, QC-60's *"after 1.0.0 a discard is a breaking change"*
  goes with it, and PD-39 is the FDR's to reconcile — the Principal PM's, not this seat's.
- **Answer:**

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 Thirteen more citations in the records the SDD's re-author moved, outside cycle 3's scope — pin them to `nozoki@70a879a:` the same way
- **Lands in:** `adr/0002-tauri-2-rust-host-wkwebview-renderer.md`,
  `adr/0004-git-read-through-libgit2-behind-a-port.md`,
  `adr/0005-root-finding-behind-the-git-port.md`,
  `adr/0006-markdown-sanitized-on-the-host-three-walls.md`, `adr/0009-physical-module-set.md`
- **Drafted into the records:** nothing — deliberately. The draft is the owner's own form from
  cycle 3 § 3.1 (1): each citation reads `nozoki@70a879a:docs/SDD.md` § …, a prose edit, no record
  superseded. It is not applied because that answer bounded its fold — *"these 38 and nothing else"*
  — and an accepted record is edited only under an authorization that reaches it. The thirteen,
  measured 2026-09-04 against `docs/SDD.md` v3 (`nozoki@827aa1c`) and `nozoki@70a879a:docs/SDD.md`:
  - **ADR-0002 (5).** `§ 9 TO-1, TO-4`, four times (§ Consequences ×3, § Traces to): in the deleted
    SDD, TO-1 was the surfaces drawn in a WebView and TO-4 the Rust host — the notes the record's
    *memory safety* and *host language* sentences rest on; in the re-authored § 9, TO-1 is the
    two-process seam and TO-4 is Apple's rendering engine, and no note carries the Rust-host half.
    `§ Open Questions, fifth item` (§ Consequences): the CSP origin form, now the **third** item;
    the fifth is the fixture sizes.
  - **ADR-0006 (2).** `§ Open Questions, fifth item` (§ Consequences) and `(fifth item)` (§ Traces
    to) — the same move.
  - **ADR-0005 (3).** *"the paragraph following the parts table"* (§ Decision, § Alternatives ruled
    out) and *"the paragraph after the parts table"* (§ Traces to): the deleted SDD's paragraph
    argued the root finding's placement in `git-reader`; the re-authored one is the four physical
    units, and that argument now sits in the `git-reader` row and RN-9.
  - **ADR-0004 (1).** `§ 11 R-1, R-6` (§ Traces to): the deleted R-6 was a dependency bringing a
    capability the product must not have; the re-authored R-6 is the reader's place lost on a
    refresh.
  - **ADR-0009 (2).** `§ 6 S-6` (§ Context, § Traces to): the deleted S-6 was `switch-the-folder`,
    whose bar names the three `nozoki-ui/src/…` paths; that slice is S-10 now, and S-6 is
    `choose-a-theme`.

  One more is reworded rather than moved and is not in the count: ADR-0001's `§ 1, last
  paragraph` — three questions ending *"if the code is careful"* in the deleted SDD, four questions
  in the re-authored one, the quoted phrase now in § 2's first row.
- **Rationale:** the ground is the owner's own at cycle 3 § 3.1 (1) — (a) re-pointing is not
  available for all of them (the Rust-host half of ADR-0002's `TO-4` has no successor note), (b) the
  log is append-only so a record stays a faithful account of what its author read, (c) the pinned
  form is this repository's precedent. Every `docs/SDD.md` citation in the nine records was written
  against `nozoki@70a879a`'s SDD; these thirteen are the ones that now land on another subject, so a
  reader following one is misdirected with no signal — the cost that answer named as the worse of
  the two.
- **If overridden:** *pin every `docs/SDD.md` citation in ADR-0001 – ADR-0009*, not only the
  thirteen — one rule a reader can carry (a record cites the SDD its author read), at the cost of
  some fifty further edits and of citations that resolve correctly today reading as frozen; or
  *re-point the thirteen* to the re-authored passages, which the owner's (b) rejected for the log;
  or *leave them*, which keeps five records in the state cycle 3 was opened to end.
- **Confirm or override:** confirm, with one addition — a fourteenth: ADR-0001's `docs/SDD.md`
  § 1, last paragraph (§ Context, `adr/0001-capability-split-read-pipeline.md:14`) takes the same
  pin. The thirteen are confirmed as counted — each measured this run at the line the item names
  (ADR-0002 :46, :50, :54, :69 and :64; ADR-0006 :66, :73; ADR-0005 :28, :39, :64; ADR-0004 :64;
  ADR-0009 :15, :61), and the other § 9 and § 11 citations those records carry — TO-2, TO-5, TO-6,
  R-1 — keep their subject across the two SDDs and are not pinned. The addition: ADR-0001 quotes
  "if the code is careful" from a paragraph that no longer holds the words — the re-authored § 1
  ends in four questions without the phrase, which now sits in § 2's first row — so the record
  misstates what its author read by the same ground (b) that governs the thirteen, and a quoted
  phrase is the strongest form of that claim; that the subject survives one section over is a
  reason the misdirection is mild, not a reason it is absent. Not taken: pinning every `docs/SDD.md`
  citation in the nine records, because a citation that resolves to the same passage today is a
  live claim that the record and the SDD still agree, and freezing it would hide that. Prose edits
  on the owner's cycle-3 ruling (3): no record's Status, date, decision, alternative or consequence
  moves, no superseding record is written, the index is untouched. Decided in the owner's seat by a
  `companion-self-answer` run, 2026-09-04. Reasoning: `docs/trail/architecture/self_answer-6.md`
  § 2.1.

## 3. Raised from downstream — an item from a seat that did not write these records

<None this round — cycle 3's § 3.1 is folded; `docs/nfdr.md` RN-16 records how.>
