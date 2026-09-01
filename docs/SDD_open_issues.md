# SDD open issues — Nozoki 覗き

> Companion to `SDD.md`. Three seats — the CTO, the CPO and the CDO — authored the SDD
> non-interactively in one run; this file holds what that run could not settle from its inputs (the
> PRD, the SRS, the UXD, and any context or constraints).
>
> **Answer inline** — fill each **Answer** / **Confirm-or-override** / **Keep-or-recut** slot —
> **commit this file**, then re-run `product-sdd`. It folds your answers into the SDD and drops the
> resolved items. When nothing is left open, `product-sdd` **deletes this file**: no file = the SDD
> is done.
>
> Your answers are never thrown away. Each time the seats fold them in, they first copy this file
> whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a disagreement is not something one seat asked, it
> is something two seats answered differently, and the answer that settles it picks between them.

> **This companion was opened by a `companion-self-answer` run, not by a `product-sdd` run.**
> `SDD.md` is Settled at v2 and its companion was correctly removed at run 2. It is opened because a
> run answering the architecture companion (`docs/architecture_open_issues.md`, recorded in
> `docs/trail/architecture/self_answer-1.md` § Companions opened) read the SDD whole and found one
> sentence that contradicts the constraint set derived from it and one that points at a file that
> no longer exists. With no companion on disk a `product-sdd` re-run reads the SDD as done and has
> nothing to act on. The one item below arrives with the run's proposal and its doubt; the decision
> is the next round's.

---

## 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override

### 2.1 § 4 C-R6 names `npm ls` where the renderer's package manager is pnpm — and RN-19 points at a companion item that no longer exists
- **Raised by:** none of the three seats — a `companion-self-answer` run (the note above). C-R6 is
  the CTO's column and RN-19 the CDO's; the fold assigns each half to its seat.
- **Drafted into the SDD:** § 4 C-R6 reads "`cargo tree` and `npm ls` are diffed against it in CI"
  (`docs/SDD.md` line 336). RN-19 reads "If the owner moves `pick-it-up-release` ahead of
  `see-what-changed` (`docs/SDD_open_issues.md` § 3.3) the first public release ships a one-entry
  rail, and its README says so under `pick-it-up-release`'s fence."
- **Rationale:** the renderer resolves to the organisation's TypeScript packet, which fixes pnpm
  (`docs/nfdr.md` § 9 and RN-7; QC-3 `pnpm ls`; QC-26 `pnpm-lock.yaml` and
  `pnpm install --frozen-lockfile`) — seventeen `pnpm` mentions in the NFDR against one `npm ls` in
  the SDD, and no package manifest or lockfile exists in the repository yet to settle it by fact. A
  delivery session opens both documents as fixed references and meets two package managers; the
  NFDR's is the doctrine's. Proposed: C-R6 reads `pnpm ls`. RN-19's contingency closed when the
  owner answered § 3.3 the other way — the release lands after the whole v1 cut (RN-22) — and the
  file it cites was deleted at run 2; proposed: the sentence is struck, or reworded as the closed
  contingency it is. **Doubt, stated:** one word and one stale sentence may not be worth a
  three-seat run on their own. They are raised because a settled document with no companion has no
  other channel, and the round can stay unrun until the SDD is next revised for another reason.
- **If overridden:** if npm is the intended package manager, the NFDR's QC-3, QC-26 and § 9 move to
  it by the Principal Architect's own revision, and the departure from the TypeScript packet's pnpm
  rule is recorded there with its reason.
- **Confirm or override:** **confirm — both halves stand, with the argument replaced on one and the choice made on the other.** (1) **`npm ls` becomes `pnpm ls`, but not for the reason given.** The item argues from seventeen `pnpm` mentions against one `npm ls`, and a tally taken in a downstream document cannot overrule its source: the NFDR derives from this SDD and says so ("never invented here"). The reason that does carry the weight is that the derivation is already explicit — `docs/nfdr.md` QC-3 *traces to* `SDD § 4 C-R6` and writes the very clause as "`cargo tree` and `pnpm ls` diffed against the allowlist", so the document that must realize C-R6 already reads it as pnpm and the two cannot both be right; QC-26 traces to C-R6 as well and pins `pnpm-lock.yaml` and `pnpm install --frozen-lockfile`. Nor is pnpm the NFDR's own invention: it arrives through the language resolution chain from the organisation's TypeScript packet (`docs/nfdr.md` RN-7, § 9), which this document never deliberately contradicted — and `docs/adr/0009-physical-module-set.md`, reconstructed from § 3, names "the TypeScript packet's `pnpm` and Vite" in the same voice. Against all that, `npm ls` is the only package-manager mention anywhere in this document (checked across the whole file, 2026-09-01), so it carries no design decision: the clause's substance is that the dependency tree is diffed against `checks/deps.allow` in CI, and the command's spelling is incidental to it. What the change does **not** settle, and should not: the flags `checks/no-network.sh` passes, which neither this document nor QC-3 fixes and which the slice that writes the script settles. (2) **RN-19's sentence is reworded, not struck** — the item offered both and chose neither, so the choice is made here. This product's own settled practice for a Review Note whose claim has closed is to record the closure rather than erase the sentence: `docs/SRS.md` RN-35 records the end of RN-29's claim, and the SRS's own companion draws the rule from it in those words — "the same way RN-35 itself records the end of RN-29's ... rather than rewriting RN-29" (`docs/SRS_open_issues.md` § 2.1). So RN-19 keeps its wording as history and gains a closing clause: the contingency closed at run 2, when the owner placed `pick-it-up-release` after the whole v1 cut (RN-22), and § 7 now carries `pick-it-up-release depends_on see-what-changed` as a dependency edge — the branch the sentence conditions on cannot be taken at all. Nothing turns on it downstream: the three citations of RN-19 in this document (§ 3, and S-1's observable bar twice) and `docs/fdr.md` R-106 all rest on the rail and polarity clauses, never on the contingency. (3) **The dead citation inside RN-19 is this item's to repair, not § 2.2's.** RN-19 points at `docs/SDD_open_issues.md` § 3.3; § 2.2's sweep rewrites the `docs/sdd_trail/` form and does not reach this one. It is worse than dead: a file of that name exists again — this companion — and has no § 3.3, so a reader resolves the pointer against the file in front of them and lands on the wrong item. What it means is `docs/trail/sdd/cycle-1.md` § 3.3. (4) **The stated doubt is answered rather than carried forward.** "Not worth a three-seat run on their own" would hold if these were the only items; § 2.2 sits on the same companion and needs the same fold, so the marginal cost of both halves of this one is nil. Reasoning: `docs/trail/sdd/self_answer-1.md` § 2.1.

### 2.2 Every trail pointer in this document is dead — the folders moved and the citations did not

> **Raised by a `companion-self-answer` run answering `docs/UXD_open_issues.md`, not by a run of this
> document's own producing skill.** No item on this companion asked for it. It is raised because the
> same defect was measured across every document in `docs/` while answering that companion's § 2.1,
> and this document carries **40** of it. The full measurement is `docs/trail/uxd/self_answer-1.md`.

- **Raised by:** the run above — not one of this document's own seats.
- **What this document says:** **40** citations of the form `docs/<x>_trail/…` (`docs/sdd_trail/`).
- **What is true:** none of those folders exists. The retired cycles live at `docs/trail/<x>/`, moved by
  `nozoki@1e8bf3d` ("the six answer-trails move under `docs/trail/`"), which did not update the documents citing them. Every one is a pointer a cold reader follows and finds nothing, and these are mostly
  **authorization** pointers — the owner answer a Review Note rests on cannot be opened to check it.
- **Drafted:** each `docs/<x>_trail/` becomes `docs/trail/<x>/`. Nothing the document says changes;
  only where it points. A pointer repair, not a revision.
- **One exception, and it is not hypothetical.** A citation pinned to a commit — the form
  `nozoki@<sha>:docs/<x>_trail/…` — must be left exactly as it is: it resolves at a commit where that
  path did exist (verified — `git show 1d5c553:docs/uxd_trail/cycle-1.md` returns the file), so
  rewriting it breaks a citation that currently works. This document carries **0** pinned citations; `docs/UXD.md` carries 4. A sweep that does not exclude the
  pinned form is wrong.
- **Scale, so this is not read as a local slip:** **235** dead pointers across six documents — PRD 2,
  SRS 80, SDD 40, UXD 71, DESIGN 30, CONTENT 12; 231 of them unpinned. The cheapest repair is plainly
  one mechanical sweep across all six rather than six document cycles, and which way it is done is the
  owner's call. This item exists so the defect is not invisible if no cycle is ever spent on it.
- **Confirm or override:** **confirm — and on this document it is the clean case none of its siblings was.** (1) **The measurement, re-run here on 2026-09-01.** 40 by `docs/sdd_trail/`, and 40 by the bare `sdd_trail/` pattern too, so the bare-form trap that hid 60 of the PRD's pointers (`docs/trail/prd/self_answer-1.md` § 2.1) does not reach this document; 0 commit-pinned, re-checked for any `@<sha>:` form across the whole file, so the exception the item protects is inert and the drafted rule applies to all 40. All 40 cite one file, `docs/sdd_trail/cycle-1.md`, and `nozoki@1e8bf3d` moved it as `R100 docs/sdd_trail/cycle-1.md -> docs/trail/sdd/cycle-1.md` — a rename with identical content, so the re-authoring hazard that held three SRS citations out of that document's sweep (`docs/trail/srs/cycle-8.md` § 2.2) has no counterpart here. Every anchor cited resolves at the new path: § 1.1, § 1.2, § 1.3, § 2.1, § 2.2, § 2.3, § 2.4, § 3.1, § 3.2 and § 3.3 are all present as headings in the moved file, checked one by one. (2) **The SRS's second exclusion does not carry over**: this document holds no `uxd_trail` citation and makes no historical "was removed" claim, so nothing is held back and no citation needs the pinned form. (3) **The scale paragraph is stale — reported, not edited.** 235-across-six was already wrong when it was written (the PRD carried 62, not 2 — `docs/trail/prd/self_answer-1.md` § 2.1), and PRD v12, SRS v9, UXD v7, DESIGN v6 and CONTENT v5 have each since been repaired; the census on 2026-09-01 leaves this document's 40 as the last unrepaired set of the six, everything remaining elsewhere being version-line prose about the repair itself or the commit-pinned `nozoki@1d5c553:` citations the rule preserves. That closes the choice the item left to the owner — one mechanical sweep versus six document cycles — because five of the six cycles are already spent and the sixth is this round, which § 2.1 owes in any case. (4) **The version line records the change and its reason**, `nozoki@1e8bf3d`, as the five sibling folds did. Nothing this document says moves: a pointer repair, not a revision. Reasoning: `docs/trail/sdd/self_answer-1.md` § 2.2.

### 2.3 § 12 promises to reference the ADRs "once they exist" — nine now exist, eight Accepted, and this document cites none

> **Raised by this `companion-self-answer` run, not by a `product-sdd` run.** No item on this
> companion asked for it. It is raised because answering §§ 2.1 and 2.2 meant reading this document
> whole, and that is where a condition the document set on itself turned out to have fired. The
> reasoning is `docs/trail/sdd/self_answer-1.md` § Raised on this document.

- **Raised by:** the run above — not one of this document's own seats. The affected text is the CTO's
  column throughout: § 12's downstream boundary, and RN-6, RN-7 and RN-8.
- **What this document says:** § 12, *The downstream boundary*: "This document authors no ADR. Three
  decisions are surfaced for the Principal Architect to record, in § 2, § 4 and their notes: the
  capability-split shape and its sandbox (RN-6), the runtime — Tauri 2, a Rust host, WKWebView
  (RN-7) — and Git read through libgit2 behind a port (RN-8). **Once recorded, this document
  references those ADRs and does not restate them.**" § 12's own preamble says it a second time, and
  RN-6, RN-7 and RN-8 each still close on "Surfaced for an ADR".
- **What is true:** all three records exist and are **Accepted** —
  `docs/adr/0001-capability-split-read-pipeline.md` (traces to `docs/SDD.md` § 1),
  `docs/adr/0002-tauri-2-rust-host-wkwebview-renderer.md` (§ 4 C-R1) and
  `docs/adr/0004-git-read-through-libgit2-behind-a-port.md` (§ 2, force 2) — beside six more:
  0003 and 0005 – 0008 Accepted, 0009 Proposed. This document names no ADR by number anywhere; its
  eight `ADR` mentions are all the forward promise. The condition the sentence set has fired and its
  consequence has not been folded.
- **Why it is worth a cycle, beyond being stale:** a cold reader of RN-6, RN-7 or RN-8 meets a
  decision still awaiting a record and has no way to reach the record that now holds it, while
  `docs/nfdr.md` cites all nine as settled trace tags. This SDD is the one document in the chain
  that does not know its own decisions were ratified. The sentence's second half — "and does not
  restate them" — is unmet too: § 2's candidate table and RN-6 – RN-8's reasoning now stand beside
  the records with no pointer in either direction, which is the two-homes shape the sentence was
  written to prevent.
- **Drafted:** RN-6, RN-7 and RN-8 each name the ADR that records them, by number and path, in place
  of "Surfaced for an ADR"; § 12's downstream boundary states that the three are recorded and names
  them, so the sentence reads as satisfied rather than pending. Which of § 2's and § 4's text is
  thinned under "does not restate them", and whether any of the six further records earns a
  reference here, are the CTO's calls on the fold — this item raises the gap, not the edit. Not yet
  in the SDD: it lands on confirmation.
- **If overridden:** § 12 keeps a promise this document made about itself and has not met, with nine
  records on disk that a reader of the SDD alone cannot find.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">
