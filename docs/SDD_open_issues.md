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
- **Confirm or override:** <"confirm", or "override: <what to do instead>">
