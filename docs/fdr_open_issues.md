# FDR open issues — Nozoki 覗き

> Companion to `fdr.md`. The Principal PM authored the FDR non-interactively; this file holds what the
> run could not settle from its inputs — the PRD, the SRS and the SDD.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-fdr`. It folds your answers into the FDR and drops the resolved items. When nothing is
> left open, `product-fdr` **deletes this file**: no file = the FDR is done.
>
> Your answers are never thrown away. Each time the Principal PM folds them in, it first copies this
> file whole to `docs/trail/fdr/` — so what you decided, and why, stays readable and citable for good.

---

## 1. Open issues — behavioural questions with no answer yet

None this cycle. The five questions cycle 1 carried are answered and folded (`docs/trail/fdr/cycle-1.md` § 1.1 – § 1.5; `fdr.md` RN-19 – RN-24).

## 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override

### 2.1 Whether R-93 carries the diagnostic log's bound the SRS gained at v9

> **This item was § 2.10 of cycle 1**, raised there by a `companion-self-answer` run reading
> `fdr.md` against the documents it cites (`docs/trail/fdr/self_answer-1.md` § Raised on this
> document). Its other half — RN-14, RN-15 and RN-18 carrying versions and states that had gone
> false — is folded this cycle as an upstream-change delta and needs no answer (`fdr.md` RN-14,
> RN-15, RN-18, RN-25). What remains is the half that is a call.

- **Drafted into the FDR:** nothing — R-93 stands as v1 wrote it: *"Any diagnostic the product keeps lives with its own state on the machine — never inside the viewed folder, never transmitted, and never holding file content."* The bound `docs/SRS.md` § 4.5 NFR-11 states from v9 — one session's lines, the file created or truncated at launch, at most 1 MiB on disk, a failed write surfacing nowhere — is not carried into a rule.
- **Rationale:** cycle 1 proposed folding the bound into R-93 on the ground that the log is the one thing in own state a person might open, so what survives a launch is behaviour of R-108's kind. This run reads the altitude test the other way, and the reading is the authoring prompt's own: a change may alter *"Logs, latency, internal file layout, and on-disk format internals"* silently and stay behaviour-preserving, and *"the fence is contract + public API — nothing finer"* (`<CORE>/doctrine/flow/change_classification.md` § Behaviour-preserving — definition, quoted at `<CORE>/prompts/principal_pm_create_fdr.md` § The altitude test). A rule pinning the log's size makes every later change to the log a behaviour change that has to be escalated; nothing a person relies on rides on it — the log is diagnostics, not a promise (`docs/SRS.md` § SRS Review Notes RN-36, *"the log is diagnostics, not a promise"*). The bound has a home already: the SRS states it, AC-13 inspects it, and the NFDR's QC-40 names NFR-11 as where it lands (`docs/nfdr.md` QC-40). What the FDR does promise about the log is R-93 as written — where it lives, that it is never transmitted, that it never holds file content — and R-109, that own state holds nothing personal.
- **If overridden:** R-93 gains a companion rule stating the bound in the SRS's terms — one session's lines, at most 1 MiB, nothing from an earlier session surviving a launch, a failed write surfacing nowhere — tracing to SRS § 4.5 NFR-11 and § 8 AC-13, with an example row; and every later change to the log's shape becomes a behaviour change against this document.
- **Confirm or override:**

### 2.2 Three upstream documents moved under the settled FDR; what each moved, and that nothing else did

- **Drafted into the FDR:** `fdr.md` RN-25 records the three moves; R-70's trace now reads *from* SRS § 3.4 FR-13 with RN-1 recording that the v1 contradiction closed at SRS v12; R-166 is added from FR-13's new clause — *"The row never falls back: a diff that cannot be produced degrades that item's view under NFR-3, and the file stays readable from the tree"* (`docs/SRS.md` § 3.4 FR-13). No other rule, product decision, exclusion or example moved for an upstream change.
- **Rationale:** the authoring prompt makes an upstream change under a settled FDR both a legitimate delta and a finding to surface, so the owner sees the foundation shifted rather than only its consequence (`<CORE>/prompts/principal_pm_create_fdr.md` § On a re-run). Measured 2026-09-01 by `git diff` on each source between the commit v1 read and HEAD: `docs/SRS.md` v8 → v12 changed FR-13, AC-6, AC-12 (`nozoki@5c9dda7`), NFR-11 and AC-13 (`nozoki@82c199a`), and closed RN-35 (`nozoki@2d66230`); `docs/PRD.md` v11 → v15 changed wording in eight sentences and one heading's subject — *folder* for *repository*, *reading panel* for *editor panel* — and no fact (`nozoki@0a5226a`, `af2a33e`, `7c89e19`); `docs/SDD.md` v2 → v3 repaired citations, spelled `pnpm ls` in C-R6, closed RN-19's contingency and pointed RN-6 – RN-8 at their ADRs (`nozoki@5c776aa`). R-166 is the one behaviour among them that no rule carried; NFR-11's bound is § 2.1; the rest moves nothing because no rule here quotes a changed sentence and the Description already named the *reading panel*.
- **If overridden:** if R-166 is not wanted as a rule of this document, it is removed and FR-13's clause stays the SRS's alone — the row's behaviour on a diff that cannot be produced then reaches a builder through the SRS and not through this contract. If a move listed here is judged to have changed a rule this run did not touch, name it and the next run folds it.
- **Confirm or override:**

### 2.3 What R-110's reversibility clause binds, now that the remembered-folders list ages entries out

- **Drafted into the FDR:** nothing — R-110 stands as v1 wrote it, because your cycle-1 answer said it holds as written (`docs/trail/fdr/cycle-1.md` § 1.2). The tension is recorded at `fdr.md` RN-26 and put here. Proposed, not applied: R-110 reads *The only state a user can change is the product's own remembered state; a choice the user makes deliberately — the theme — is reversible by the control that made it; the remembered-folders list changes only by viewing a folder (R-182) and is not undone.*
- **Rationale:** R-110 says each change to own state *"is reversible by the control that made it"*, and cycle 1's answer settles a list where viewing an eleventh folder removes the oldest for good (R-178) and no control removes or restores an entry (R-182). Viewing a folder again does not bring the aged-out entry back, so the list's changes are not reversible by the control that made them. The two rules bind the same state differently, which the finish walk's across check refuses to leave standing. The reading drafted above is the one the UXD's UX-I7 already carries — *"The only state the user can change is the tool's own preferences, each reversible by the same control that set it"* (`docs/UXD.md` UX-I7) — where *preferences* names the theme and the list is not one. The call is yours because R-110 is settled text and you said it holds; a re-run does not reword settled content on its own reading.
- **If overridden:** keeping R-110 exactly as written means the list must be reversible too, so R-182 gains a control that removes an entry and R-178's aging-out either stops or becomes undoable — a treatment `docs/DESIGN.md` does not draw and the UXD's UX-S7 rules out (*"no control removes an entry or clears the list"*), so both siblings would be owed a revision. Confirming applies the proposed wording to R-110 and drops RN-26's open clause.
- **Confirm or override:**
