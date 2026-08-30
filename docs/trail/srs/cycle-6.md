# SRS open issues — Nozoki 覗き

> Companion to `SRS.md`. The CTO authored the SRS non-interactively; this file holds
> what it could not settle from the inputs (the PRD and any context/constraints).
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this
> file**, then re-run `product-srs`. It folds your answers into the SRS and drops the
> resolved items. When nothing is left open, `product-srs` **deletes this file**: no file =
> the SRS is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CTO folds them in, it first copies this
> file whole to `docs/srs_trail/` — so what you decided, and why, stays readable and citable
> for good.

> **This round folds your cycle-5 answers** (`docs/srs_trail/cycle-5.md`) into SRS v6. Three of
> the four items are settled and gone — floor recognition (RN-27), the raw-source switch outside
> the terminus (RN-29), a second platform outside the terminus (RN-30). The fourth, links in a
> rendered Markdown file, settled its relative-link half (RN-28) and left one residue, which is
> the single item below. It is a fresh item with an empty slot, not the old one carried over.

---

## 1. Open issues — technical questions with no answer yet

None — the one item this round leaves carries a drafted lean, so it is under §2 as a choice to
confirm.

## 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override

### 2.1 Whether an external link in a rendered Markdown file may be handed to the system browser, against NFR-8

- **Drafted into the SRS:** FR-32 — an external link is displayed and not followed: the system
  neither opens it nor hands it to another program. That is the default the SRS keeps; the
  permission your cycle-5 answer gave ("per each, if it costs nothing, do it") is folded for the
  relative-link half only. The external half is *not* folded as a permission — it stays refused
  until this item is answered (RN-28).
- **Rationale:** your answer conditioned each half on build cost. For the relative-link half that
  condition is the whole question, and it is folded. For the external half, cost is not the axis
  the requirement turns on — you were told so before answering (`docs/srs_trail/cycle-5.md`
  §2.2, the session note beneath the answer), and the answer records no acceptance of the trade
  that note names. The trade is this: NFR-8 says "the system makes no network call during
  operation — none", and AC-3 checks it as "network monitoring across a full session shows zero
  outbound traffic". A URL handed to the system browser at the user's click is a call another
  process makes, but the system initiated it, and a machine-level monitor sees the traffic. Way 2
  (`one-job-whole`) says a promise is kept absolutely, and the SRS cannot decide on its own that
  an initiated-but-delegated call sits inside "none". The lean is the reading that costs
  nothing and qualifies nothing: the link is shown, the reader can see where it points, and the
  system opens no path off the machine. Nothing in v1 or in the terminus needs the other
  reading. This is product-visible — what happens when a reader clicks — so it is yours.
- **If overridden** (an external link may be handed to the system browser, on the same cost
  condition as the relative half): FR-32's external-link sentence becomes the same permission
  the relative half carries — permitted, not required, built only if it costs nothing, the SDD's
  judgment. NFR-8 gains one sentence in its own text: a call another process makes when the user
  activates a link is not a call the system makes, and that delegation is accepted. AC-3 scopes
  its monitor to the system's own outbound traffic, and AC-23's external-link check narrows to
  the same — the browser's traffic is out of scope, the system's stays at zero. RN-28 records the
  acceptance in your words. The Agari's second condition ("no non-essential network call") is
  unchanged either way; whether an opened browser page is *essential* is the reading this answer
  settles.
- **Confirm or override:** confirm

## 3. Directives — an external action the owner confirms as a gate

None.
