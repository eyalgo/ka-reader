# FDR open issues — Nozoki 覗き

> Companion to `fdr.md`. The Principal PM authored the FDR non-interactively; this file holds what the
> run could not settle from its inputs — the PRD, the SRS and the SDD.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-fdr`. It folds your answers into the FDR and drops the resolved items. When nothing is
> left open, `product-fdr` **deletes this file**: no file = the FDR is done.
>
> Your answers are never thrown away. Each time the Principal PM folds them in, it first copies this
> file whole to `docs/trail/fdr/` — so what you decided, and why, stays readable and citable for good.
>
> **§ 3 is the odd one, and worth reading twice.** The Principal PM writes the FDR *and* is the seat
> most likely to raise an item against it later, cutting the same product's documents into seeds. The
> two are different acts at different times, and § 3 keeps the later one visible instead of letting
> it be quietly folded back into § 1 as though the authoring run had asked it.

> **No `product-fdr` run wrote this file.** It was opened on 2026-09-04 by a `companion-self-answer`
> run answering `docs/architecture_open_issues.md` (its report:
> `docs/trail/architecture/self_answer-6.md`), under
> `<CORE>/prompts/decide_companion_answers.md` § *The items are not the whole of what a document is
> owed* — the case that section names first, *a fact in it is now false*. `docs/fdr.md` closed
> Settled at v3 (its own `Version:` line) and its companion was correctly removed; after that close
> the SDD it derives from was deleted (`nozoki@9c91359`) and re-authored (Settled at v3,
> `nozoki@827aa1c`), and twelve of the FDR's trace tags now name review notes that carry other
> subjects or no note at all. With no companion on disk a `product-fdr` re-run reads the FDR as done
> and has nothing to act on, which is why this file exists. §§ 1 and 3 are empty because no authoring
> run drafted anything; § 2 carries the one item, in the bucket the answering skill fixes for a
> change a run raised with its reasoning.

---

## 1. Open issues — behavioural questions with no answer yet

<None — see the note above.>

## 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override

### 2.1 Twelve trace tags cite the deleted SDD's review notes RN-16, RN-19, RN-20 and RN-26, which the re-authored SDD does not carry — repair them under the rule the owner set for a document revised in place
- **Drafted into the FDR:** nothing — deliberately; the run that opened this file may not write the
  FDR. The draft is the **form**, and it is the owner's own from
  `docs/trail/architecture/cycle-3.md` § 3.1, answer (2): a document that "is updated in place with
  versioning" (`docs/fdr.md` preamble, the same words as `docs/nfdr.md`'s) carries trace tags that
  name *where a fact lives now*, so each of the twelve is **re-pointed** to the passage of
  `docs/SDD.md` v3 that carries its subject; where the re-authored SDD carries no successor for a
  subject, the tag is **pinned** to `nozoki@70a879a:docs/SDD.md` § SDD Review Notes RN-n — the form
  answer (1) fixed for the log, the last commit that held the deleted SDD whole. Which of the twelve
  take which form is the Principal PM's to find through the FDR's own run; this item measures the
  breakage and drafts the rule, not the pointers.
- **Rationale:** Measured 2026-09-04 against `docs/fdr.md` v3 and both SDDs. `grep -c 'SDD § SDD
  Review Notes RN-\(16\|19\|20\|26\)' docs/fdr.md` → **12**, on R-70, R-73, R-106, R-117, R-124,
  R-126, R-171, R-174 and the FDR's own RN-1, RN-9, RN-21, RN-25. What each number meant in the SDD
  the FDR read (`git show 70a879a:docs/SDD.md`) and what it means in `docs/SDD.md` v3: **RN-16** —
  the history's default branch set (CTO) → `promise-one-point-zero`'s placement as a slice (CPO);
  **RN-19** — `read-a-folder`'s rail carrying the *Files* entry alone (CDO) → the content of the
  1.0.0 contract (CPO); **RN-20** — two UXD gaps, the owner's answers folded (CDO) → **no note**;
  **RN-26** — the CDO lane following UXD v6 → **no note** (the re-authored document carries
  RN-1 – RN-19 and RN-30 – RN-33; `docs/nfdr.md` RN-16 measured the same). The FDR's three
  citations of RN-10 are not in the count: both SDDs carry the same subject there (the two build-cost
  judgments FR-31 and FR-32 delegate) and they resolve. Two of the four numbers now resolve to
  notes on other subjects — a pointer that lands somewhere plausible and says something else, with no
  signal to the reader — which `docs/trail/architecture/cycle-3.md` § 3.1 names as the worse of the
  two failures and the owner judged worth a round for the decision log. This is the same defect in
  the document downstream of it, reported at `docs/nfdr.md` RN-16 as "the Principal PM's, through the
  FDR's own run" — and nothing routed to that run until this file. The repair form follows the
  document's revision rule and not the log's: the FDR revises in place, so a live pointer is right
  where a successor exists, and the log's pin is right only where none does.
  *Not drafted here, and not this item's:* `docs/fdr.md` PD-39 prices own-state readability inside
  the 1.0.0 contract and the re-authored SDD's owner-confirmed § 6 S-11 does not — which document
  moves is the owner's call, open at `docs/architecture_open_issues.md` § 1.1 with the answering
  run's own answer at `docs/trail/architecture/self_answer-6.md` § 1.1. A `product-fdr` run that
  meets PD-39 against S-11 reads the decision there rather than reconciling on its own.
- **If overridden:** *pin all twelve* to `nozoki@70a879a:` — one rule, twelve edits, at the cost of a
  document that revises in place carrying pointers to a document no working tree holds, which is the
  form the owner rejected for the NFDR's one citation; or *leave them*, which keeps eight rules and
  four review notes pointing at notes on other subjects or at nothing, in a Settled document the
  Product Owner and the QA seat read cold. Either way the FDR takes a version bump, as it does for
  any in-place edit, and no rule, product decision or exclusion changes its meaning.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item raised against the FDR after it settled

<None — see the note above.>
