# SRS open issues — Nozoki 覗き

> Companion to `SRS.md`. **Answer inline** — fill each **Confirm-or-override** slot —
> **commit this file**, then re-run `product-srs`. It folds your answers into the SRS and
> drops the resolved items. When nothing is left open, `product-srs` **deletes this file**:
> no file = the SRS is done.
>
> **This cycle was opened by the owner, not by the CTO.** The SRS settled at v2 with no
> companion; the single entry below is a decision already made, not a question.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops that
> run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CTO folds them in, it first copies this
> file whole to `docs/srs_trail/` — so what you decided, and why, stays readable and citable
> for good.

---

## 1. Open issues — technical questions with no answer yet

None — the one item this cycle is an owner decision already made.

## 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override

### 2.1 The PRD moved beneath this SRS — `## UX Notes` re-authored, and v1's accessibility posture settled

- **Drafted into the SRS:** nothing. SRS v2 derives from `PRD.md` at **v4**. The PRD is now
  **v6**, over two cycles: `346b004` re-authored `## UX Notes` whole — 15 lines to 79
  (`docs/PRD.md:129-207`) — and `7d222e1` settled v1's accessibility posture, that v1 makes no
  assistive-technology promise and its accessibility surface is what the product already carries.
- **Rationale:** the re-authored section states the product's experience, and the SRS is not its
  reader — the UXD is. The accessibility posture is a different kind of statement and may reach
  the SRS differently. Which of the two carries technical consequence, and how far, is the CTO's
  judgment, not something this file should make for it.
- **Confirm or override:** **Confirm — derive from the PRD as it now reads.**
  - The *stability rule* is **not** lifted and does not need to be: it already permits a delta
    that traces to a change in the upstream PRD. Settled SRS content whose PRD source did not
    move stands exactly as written.
  - What the re-authored section changes in the SRS — if anything — is yours to determine.
  - **A section that produces no requirement delta is a valid outcome.** Say so plainly rather
    than manufacturing a requirement to show movement.
  - Anything the section demands that the PRD has no basis to settle is an **open issue** next
    round, not a guess.
