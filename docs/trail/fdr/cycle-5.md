# FDR open issues — KA-Reader

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

> **How this companion came to exist.** No `product-fdr` run opened it. A `companion-self-answer`
> run opened it on 2026-09-23 (`ka-reader@f5cddef`) while it answered `docs/architecture_open_issues.md`
> § 2.2. `fdr.md` was Settled at v6 with no companion on disk, so without this file a `product-fdr`
> re-run would have read it as done. But the owner's answer on `docs/SDD_open_issues.md` § 1.1 had
> reversed one sentence of PD-29, and `docs/nfdr.md` QC-21 waits on PD-29 to move (NFDR RN-21). The
> item was proposed and not drafted. **The first `product-fdr` run after it — v7, 2026-09-23 —
> drafted § 2.1 into PD-29**: the SDD now carries the replacement (`docs/SDD.md` v13, § 2; § 10 RC-3),
> so the sentence says the view was replaced once and is not replaceable again, without naming the
> technology. **The same run raised § 2.2**, on the SDD's move beneath this document and its Draft
> status. Both slots are yours.

---

## 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override

### 2.1 PD-29 said the renderer technology is not replaceable inside the terminus; the owner ruled that it leaves WKWebView, and the SDD now carries the replacement
- **Drafted into the FDR:** PD-29's last sentence, which read "The renderer technology and the
  platform are not replaceable inside the terminus", now reads two sentences: "The platform is not
  replaceable inside the terminus. The view technology (the *renderer technology*, as v1 – v6 of this
  document named it) was replaced once, before any public release, and is not replaceable again
  inside the terminus." Its trace tag adds the owner's directive (`docs/trail/sdd/cycle-9.md` § 1.1)
  and RN-31, which records the move. The technology is not named in PD-29: which view draws the
  shell is the SDD's (`docs/SDD.md` § 2 — an AppKit shell in Swift, one process), and the altitude
  test keeps an engine's name out of a decision that has to survive a rewrite
  (`<CORE>/prompts/principal_pm_create_fdr.md` § *The altitude test*).
- **Rationale:** PD-29 derives from the SDD's § 2 force 4 and *Undoing it* and § 9 TO-4, which at v5
  priced the renderer as not replaceable. The owner's answer of 2026-09-23 — **(a), the renderer
  leaves WKWebView** (`docs/trail/sdd/cycle-9.md` § 1.1, *Answer*) — is an authorized decision that
  outranks the document, and the item it answered listed "`docs/fdr.md` PD-29's 'not replaceable
  inside the terminus' reversed" among (a)'s costs. The SDD has since folded it: § 2 force 4 reads
  "not the view technology *again* — it moved once, before any release"; *Undoing it* prices the
  replacement as "paid once, before any release (§ 10 RC-3) — and not foreseen again inside the
  terminus"; § 9 TO-4 reads "paid once already, from the WKWebView" (`docs/SDD.md` v13). So the v6
  sentence states something false about the product's plan, and two readers act on it: the PM
  validates a change request against the FDR (`<CORE>/roles/CROSS_ROLE.md` § 1) and would reject
  the replacement's changes as contradicting PD-29; and `docs/nfdr.md` QC-21 traces to PD-29 and is
  re-derived only when PD-29 moves (`docs/nfdr.md` RN-21). The delta is legitimate on both grounds
  the re-run rule admits — an owner directive and a change in an upstream document
  (`<CORE>/prompts/principal_pm_create_fdr.md` § *On a re-run*). The word *view technology* is the
  SDD's (§ 2 force 4); *renderer* is kept beside it because that is what v1 – v6 called it and what
  the SDD still calls the gate that proves the shell ran (§ 4 C-I3).
- **If overridden:** PD-29 keeps saying the view technology cannot be replaced while the SDD records
  that it was. A change request for any slice that lands the native shell then contradicts the FDR
  it is validated against, and QC-21 stays as written, because it waits on PD-29 (`docs/nfdr.md`
  RN-21). An override that names the technology in PD-29 — "AppKit" — pins an engine into the
  behavioural contract, so a later swap of the view under the same behaviour becomes a behaviour
  change to escalate rather than a design call the SDD makes; that is the cost RN-27 records for
  the log's bound, applied to the view. Nothing else in the FDR moves.
- **Confirm or override:** confirm, with one addition. The draft holds. `docs/SDD.md` v13 says what the new PD-29 says: § 2 force 4 reads "not the view technology *again* — it moved once, before any release", *Undoing it* prices the replacement "paid once, before any release (§ 10 RC-3) — and not foreseen again inside the terminus", and § 9 TO-4 reads "paid once already, from the WKWebView". "Before any public release" is true: the product repo has no tag and no GitHub Release (2026-09-23). Keeping "AppKit" out of PD-29 is right, because the SDD owns which view draws the shell. **Addition:** when this confirm folds, `docs/nfdr.md` QC-21 still says the renderer technology is "not replaceable inside the terminus". It traces to PD-29 and is re-derived only when PD-29 moves (NFDR RN-21), so this fold is what makes it out of date. That re-derivation is already raised: `docs/architecture_open_issues.md` § 2.3 names QC-21 among the entries owed, so no new companion is opened for it. If TextKit later cannot do the layout the SDD's open question asks about, a second swap becomes a change that contradicts PD-29 and goes to the owner, the same way this one did. That is what a product decision is for, so it is not a gap in the wording. Decided in the owner's seat by a `companion-self-answer` run, 2026-09-23. The reasoning is in `docs/trail/fdr/self_answer-5.md` § 2.1.

### 2.2 The SDD moved from v5 to v13 beneath this document and stands Draft; this run folded what the move reached and derived from the Draft rather than waiting for it to settle
- **Drafted into the FDR:** Beyond § 2.1, three things, none of them a rule's wording. PD-31's and
  OOS-23's trace tags are re-pointed from `§ 3 ipc-surface` — a part the re-cut retired — to
  `§ 3 mac-shell`, which carries the one window and *a second window* under what it must not own.
  The header gains `**Inputs read:** PRD Settled · SRS Settled · SDD Draft` — a line absent since
  v1 and required of every document in the chain by
  `<CORE>/doctrine/governance/unsettled_inputs.md` § *The rule*, added under
  `<CORE>/doctrine/governance/found_while_walking.md` clause 1. RN-14, RN-17 and RN-18 carry a v7
  re-read, and RN-31 records the move whole: what moved, the one entry it reaches (§ 2.1), the two
  locators, every SDD-sourced entry opened against v13 and holding, and what lands as no rule.
- **Rationale:** The re-run rule: "An upstream document that changed under a settled FDR is a
  legitimate source of a delta, and it is also a finding. Fold what the change requires, and surface
  the change itself with what it moved" (`<CORE>/prompts/principal_pm_create_fdr.md` § *On a re-run*).
  The SDD moved seven times, runs 6 – 12 (`git diff --stat 356b531 HEAD -- docs/SDD.md`: 1,379
  insertions, 254 deletions, 2026-09-23), and every section this document draws on was read as a
  diff; RN-31 lists each entry opened. **The Draft.** `docs/SDD.md` is Draft at v13 because
  `docs/SDD_open_issues.md` holds one item, § 2.3 — the wording of § 4 C-I3's entitlement check
  ("against the set C-R2's rule admits" where it read "C-R2's exact list") and the record lines of
  C-R2 and C-I3 — answered in the owner's seat (`ka-reader@18ad26d`) and awaiting `product-sdd`'s fold.
  The house rule is derive and record, never halt (`unsettled_inputs.md` § *The rule*; the prompt's
  § *Inputs you work from*). What turns on the Draft here: nothing. No FDR entry reads C-I3's check
  or either record line — RN-13 classes C-R2 and C-I3 as structure and process, and RN-31 re-walks
  both at v13 with the same result — and § 2.1's delta rests on § 2, § 9 and the owner's answer,
  which § 2.3 does not touch. The owner's own addition to § 2.3 says the SDD "may never have a next
  fold" after it (`docs/SDD_open_issues.md` § 2.3, *Confirm or override*), so a derivation that
  waited on a settled SDD could wait on nothing scheduled.
- **If overridden:** (a) *Wait for the SDD to settle* — v7's deltas stand as drafted and are re-read
  against the settled SDD at that fold; the cost is a companion that outlives its cause. (b) *A
  site the fold missed* — name it; RN-31 lists every entry opened, so a miss is one the walk did not
  reach, and it lands as a further delta under the same rule. Nothing else moves.
- **Confirm or override:** confirm, with one addition and one ground corrected. The draft holds. `§ 3 mac-shell` carries both clauses the locators need: the one window, and "A second window" under what it must not own (`docs/SDD.md` § 3, the parts table). The `Inputs read:` line is what `unsettled_inputs.md` § *The rule* requires of every revision. Deriving from the Draft SDD is right, and for the draft's first reason: `docs/SDD_open_issues.md` § 2.3 moves only C-I3's check wording and the record lines of C-R2 and C-I3, and no rule, product decision or exclusion here cites either condition (only RN-13, RN-18 and RN-31 do). **Ground corrected:** the draft's second reason does not hold. It reads the owner's "the SDD may never have a next fold" as saying the SDD's settling is not scheduled. The owner's sentence is about the fold *after* § 2.3's. § 2.3's own fold is owed, and it is the `product-sdd` run that takes the SDD to Settled. The reason not to wait is that nothing here turns on that fold, not that the fold never comes. **Addition, the stale case:** on this companion's fold, read the SDD's `Status:` again. If `product-sdd` has folded § 2.3 by then, the `Inputs read:` line reads `SDD Settled`, and RN-18 records the move and confirms it reached no entry here. If it has not, the line stays `SDD Draft`, which is true of what was read. Either way the fold does not wait. Decided in the owner's seat by a `companion-self-answer` run, 2026-09-23. The reasoning is in `docs/trail/fdr/self_answer-5.md` § 2.2.
