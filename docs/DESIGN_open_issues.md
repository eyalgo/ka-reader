# DESIGN open issues — Nozoki 覗き

> Companion to `DESIGN.md`. The CDO authored the design language non-interactively; this file
> holds the calls it made and wants your sign-off on — each with the reason behind it, and what
> moves underneath it if you override — plus the few things it genuinely could not settle, and,
> when a design run has produced output for this product, the pointer to it.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-design`. It folds your answers into `DESIGN.md` and drops the resolved
> items. When nothing is left open, `product-design` **deletes this file**: no file = the
> design language is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CDO folds them in, it first copies this
> file whole to `docs/design_trail/` — so what you decided, and why, stays readable and citable
> for good.

> **This companion was opened by the owner, not by a `product-design` run.** `DESIGN.md` is settled
> at v2 (`nozoki@95f1279`) and its companion was correctly deleted. It is re-opened deliberately
> because the **verbal-language** round that followed found three things in `DESIGN.md` that only a
> CDO run can fix, and the design loop has no other channel: with no companion on disk a
> `product-design` re-run reads the document as done and has nothing to act on.
>
> **The three are not equal.** § 1.1 arrives with the owner's ruling already recorded and is a fold.
> § 1.2 is a **factual defect** in a settled document, and the correction reaches back into a call
> the owner confirmed at `docs/design_trail/cycle-1.md` § 2.4 — so it carries a real question.
> § 1.3 is a stale cross-reference and needs no decision.

---

## 1. Open issues

### 1.1 The no-tooltip rule bans the tooltip the owner has since put in v1

- **Why it matters:** `docs/DESIGN.md:672-673`, § Do's and Don'ts — *"Don't draw a focus ring, a
  tooltip, a badge, a toast, or a notification — none exists in the product"* — and RN-11
  (`:790-792`), which carries its reason. The rule is settled: DESIGN v2 folded the owner's cycle-1
  answers, where they overrode the no-hover rule and the record states they overrode **hover alone**,
  with "no transition, no focus ring and no tooltip" left standing
  (`docs/design_trail/cycle-1.md` § 2.3). Everything a tooltip would carry — where it may appear,
  what it may say, how it is drawn, whether it animates — is unspecified, because the product was
  designed not to have one.
- **What was searched:** `docs/DESIGN.md` § Do's and Don'ts (`:672-673`) and RN-11 (`:790-792`);
  `docs/design_trail/cycle-1.md` § 2.3 for the scope of the owner's hover override;
  `docs/CONTENT_open_issues.md` § 1.2 (`nozoki@3692585`) for the ruling that reopens it.
  **RN-11's own stated reason is the thing that fails here.** It bans a tooltip *because* "a tooltip
  is a second surface for words the label already carries (UX-A4)". That reasoning holds wherever a
  control carries its own word — the rail entries, the chrome controls. It does **not** hold for a
  Git status letter, whose whole problem is that the label is a single character carrying no word at
  all. So the rule's rationale never covered this case; it was written without it in view.
- **Answer:** **Tooltips are in v1, and the Don't is lifted.** The owner's words, given while
  settling the Git status letters: *"i think that tooltips should be included in v1."* Recorded there
  as a **v1 decision, not a one-off exception for status letters**
  (`docs/CONTENT_open_issues.md` § 1.2, `nozoki@3692585`).

  The behaviour the owner described, and the thing the tooltip has to serve: *"in VS code, when you
  hover over an `M` for example, there's a short-time 'file and + Modified'."* So — pointer-driven,
  brief, showing the file and the expanded word.

  **What is not settled here, and is the CDO's to author:** every specification a tooltip needs and
  `DESIGN.md` has never carried. At minimum — which surfaces may show one and which may not; its
  token set (surface, ink, border, radius, shadow if any) in both themes against the contrast floor
  (ink ≥ 9:1, other text ≥ 4.5:1, § Colors); its delay and dismissal, which collide with the motion
  posture RN-11 also carries (motion dial 2, no transition); and its relationship to the hover fill
  the owner added in the same round (RN-22), since both are pointer-driven and a status letter sits
  inside a clickable row. RN-11 is rewritten rather than deleted: it still bans the focus ring, the
  badge, the toast and the notification, and it should record that the tooltip left the list by the
  owner's decision and why its original UX-A4 reasoning did not reach this case.

### 1.2 The status-letter mapping is wrong: `U` is not "added" and `C` is not "conflict"

- **Why it matters:** `docs/DESIGN.md:580-584`, § Components *"Status letters"*, is what the product
  draws beside every changed file, and — once § 1.1's tooltip exists — it is also what the tooltip
  will say in words. A tooltip built on this mapping would tell the reader the wrong thing about
  their own repository, which is the one failure a read-only truthful-state product cannot afford.
  It also feeds the four-hue-family grouping the owner confirmed at
  `docs/design_trail/cycle-1.md` § 2.4.
- **What was searched:** `docs/DESIGN.md:580-584` groups the letters as *"`A`, `U` (added); `M`
  (modified); `D`, `C` (deleted, conflict); `R` (renamed)"*, against four component tokens —
  `{components.status-added}`, `status-modified`, `status-deleted`, `status-renamed`.
  **Git's own porcelain status codes say otherwise:** `A` added, `M` modified, `D` deleted, `R`
  renamed, **`C` copied**, **`U` updated but unmerged**. So the document has `U` (a conflict state)
  filed under *added*, and `C` (a new file copied from another) filed under *deleted, conflict*.
  Note the parenthetical *"(deleted, conflict)"* shows the **intent was right and the letter was
  wrong**: the grouping meant to put the conflict state with deleted, and named `C` where it meant
  `U`. `docs/CONTENT.md` already carries the correct words — its § Accessibility of text expansion
  lists *copied* and *unmerged*.
- **Answer:** <the owner fills this in. The correction itself is not in doubt — `C` is copied and
  `U` is unmerged, and the document must say so. What needs your call is the **hue grouping**, which
  you confirmed at `docs/design_trail/cycle-1.md` § 2.4 on the strength of the wrong mapping.
  The minimal reading, which preserves both your four-family confirm and the grouping's evident
  intent, is a straight swap: **`A`, `C` (added, copied) green; `M` (modified) amber; `D`, `U`
  (deleted, unmerged) red; `R` (renamed) teal** — four families, four tokens, nothing else moves.
  The alternative is that an unmerged file is different enough from a deleted one to deserve its own
  treatment, which makes it a fifth family with a fifth token and a dark value, re-checked against
  `canvas`, `selection` and `hover`. Answer "the swap" or name the fifth family.>

### 1.3 A traceability row points at a companion that no longer exists

- **Why it matters:** it is a citation in `DESIGN.md`'s own traceability table, and it tells a reader
  that a record is pending when it has in fact landed. Small, but it is the kind of pointer a later
  run follows and finds nothing at.
- **What was searched:** `docs/DESIGN.md:898` reads — *"Theme control in the chrome (§ Components,
  RN-10 — placement added beyond the UXD and owner-confirmed; the UXD-side record is **pending** in
  `docs/UXD_open_issues.md` § 1.1)"*. That file does not exist: it was consumed and deleted when the
  UXD folded the answer (`nozoki@f4bc928`). The record is no longer pending — it landed. `UXD.md` is
  at v3 and carries the placement in § 4 (`UXD.md:87`, *"The theme control lives in the shell chrome,
  at its right end"*) with **RN-22** (`UXD.md:624-625`) holding the owner's basis, and its own
  traceability row (`UXD.md:415`) citing `docs/uxd_trail/cycle-2.md` § 1.1.
- **Answer:** **Repoint it — no decision needed.** The row should cite the settled UXD record rather
  than a deleted companion: `docs/UXD.md` § 4 and RN-22, with the owner's answer readable at
  `docs/uxd_trail/cycle-2.md` § 1.1. The word *pending* comes out; the placement is settled on both
  sides now, which is exactly what that round was for.

## 2. Choices to confirm

None. This companion was opened to carry three items the verbal-language round found, and the CDO
drafted nothing on this round.
