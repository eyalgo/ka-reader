# UXD open issues — Nozoki

> Companion to `UXD.md`. The CDO authored the UXD non-interactively; this file holds
> what it could not settle from the inputs (the PRD, the project's Agari and its doctrine, the
> SRS when present, and any context the owner handed over) — and, when a design run has produced
> output for this product, the pointer to it. **Answer inline** — fill each **Answer** / **Confirm-or-override**
> slot — **commit this file**, then re-run `product-uxd`. It folds your answers into the UXD
> and drops the resolved items. When nothing is left open, `product-uxd` **deletes this file**:
> no file = the UXD is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CDO folds them in, it first copies this
> file whole to `docs/trail/uxd/` — so what you decided, and why, stays readable and citable
> for good.
>
> **A third source of items, and it is not the CDO.** § 3 holds what a seat downstream of the UXD
> found missing while working from documents the UXD fed. It is answered here and folded by the same
> run, but it was never this run's question.


> **No `product-uxd` run wrote this file.** The CDO companion-self-answer run on
> `docs/DESIGN_open_issues.md` § 3.1 opened it on 2026-10-01 while reading `docs/UXD.md`.
> This is an independent finding from that input, rather than the path-line item's answer:
> § 4 still counts seven reference images while the reference's own inventory names eight
> (`docs/UXD.md:L68-L73`; `docs/ux_reference/README.md:L3-L19`). This companion carries
> that correction to the UXD's producing run without editing the UXD here.

---

## 2. Choices to confirm — the CDO drafted a best-effort answer; confirm or override

### 2.1 Bring the layout-reference inventory up to the reference's own count
- **Drafted into the UXD:** Nothing applied by this run. Proposed correction: § 4 names eight
  screenshots, four annotated and four described but not adjudicated. Preserve RN-13's earlier
  seven-image read as history and record the new inventory beside it, without treating the eighth
  image as approved design input or changing a flow, screen or interaction requirement.
- **Rationale:** § 4 currently names seven screenshots and three later unannotated images
  (`docs/UXD.md:L68-L73`). The inventory now names eight and explicitly distinguishes four
  annotated from four described-only images (`docs/ux_reference/README.md:L3-L19`). Its newest
  image, `vscode-commit-detail-pane.png`, has no read on record, and whether anything else in that
  pane is taken remains open (`docs/ux_reference/README.md:L206-L219`). Reasoning: correct the
  factual inventory without silently granting that image design authority; adjudicating it is a
  separate experience decision, not a prerequisite for stating what files exist.
- **If overridden:** State the grounds for a different inventory or annotation count in § 4 and
  its current-reference note. A changed count alone changes no experience requirement; historical
  RN-13 stays a record of its original read.
- **Confirm or override:** confirm
