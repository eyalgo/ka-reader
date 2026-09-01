# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (Settled, v2 — the header's own "the companion is empty and removed
  this run" is stale while this companion stands; that is `product-sdd`'s bookkeeping and it
  self-heals on the fold, so it is not raised)
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-01

## Items worked

### 2.1 — § 4 C-R6 names `npm ls` where the renderer's package manager is pnpm — and RN-19 points at a companion item that no longer exists

- **Bucket:** 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** Both conclusions are right and neither was decided as handed, so each half is taken with
  something added.

  **The package manager.** The item's argument is a count — seventeen `pnpm` mentions in the NFDR
  against one `npm ls` here — and that argument does not carry the weight put on it: the NFDR is
  derived from this SDD and says so in its own header ("never invented here"), so a tally taken
  downstream cannot overrule its source. Confirmed on the reason that does hold. `docs/nfdr.md`
  QC-3 *traces to* `SDD § 4 C-R6` and writes the same clause as "`cargo tree` and `pnpm ls` diffed
  against the allowlist"; QC-26 traces to C-R6 too and pins `pnpm-lock.yaml` and `pnpm install
  --frozen-lockfile`. That is not two documents disagreeing at large — it is the document that must
  realize C-R6 reading C-R6 differently from how C-R6 is written, and only one of the two can
  stand. Nor is pnpm the NFDR's own choice: it reaches it through the language resolution chain
  from the organisation's TypeScript packet (`docs/nfdr.md` RN-7, § 9), and
  `docs/adr/0009-physical-module-set.md`, reconstructed from § 3, names "the TypeScript packet's
  `pnpm` and Vite" in the same voice. Meanwhile `npm ls` is the *only* package-manager mention
  anywhere in this SDD — checked across the whole file — so it encodes no decision this document
  ever made; C-R6's substance is that the dependency tree is diffed against `checks/deps.allow` in
  CI, and the command's spelling is incidental to that.

  **Failure paths, walked.** *Absent* — no manifest or lockfile exists in the repository yet
  (checked: `docs/`, `scripts/design-check.mjs`, `third_party/lucide/`, `README.md`, and no product
  code), so nothing on disk contradicts either spelling today; the answer rests on the packet rule
  rather than on repository state, which is why the absence does not weaken it. The first delivery
  session that creates `nozoki-ui` is where the fact becomes checkable, and a `package-lock.json`
  appearing there is a C-R6 violation to catch then, not a reason to hedge now. *Stale* — if npm
  ever becomes the intended manager, QC-3, QC-26, § 9, ADR-0009 and C-R6 all move together, which
  is the path the item's own *If overridden* already names. **One case deliberately not covered:**
  the flags `checks/no-network.sh` passes. Neither this document nor QC-3 fixes them, and the slice
  that writes the script settles them; naming the command is not naming its invocation.

  **RN-19.** The draft offered "struck, or reworded" and chose neither, which decides nothing, so
  the choice is made: **reworded**. This product's settled practice for a Review Note whose claim
  has closed is to record the closure rather than erase the sentence — `docs/SRS.md` RN-35 records
  the end of RN-29's claim, and the SRS's own companion states the rule in those words ("the same
  way RN-35 itself records the end of RN-29's ... rather than rewriting RN-29",
  `docs/SRS_open_issues.md` § 2.1). RN-19's wording stands as history and gains a closing clause:
  the contingency closed at run 2 when the owner placed `pick-it-up-release` after the whole v1 cut
  (RN-22), and § 7 now carries `pick-it-up-release depends_on see-what-changed` as a dependency
  edge, so the branch the sentence conditions on cannot be taken at all. Checked before deciding
  that nothing rests on it: the three citations of RN-19 inside this document (§ 3 at the root
  finding, and S-1's observable bar twice) and `docs/fdr.md` R-106 all rest on the rail and
  polarity clauses, never on the contingency.

  **The addition the item did not see.** RN-19's citation is `docs/SDD_open_issues.md` § 3.3, not
  a `docs/sdd_trail/` pointer — so § 2.2's sweep does not reach it, and a fold that assumes it does
  will leave it. It is also worse than dead: a file of that name exists again, this companion, and
  has no § 3.3. A reader resolves it against the file in front of them and lands on a different
  item. The target is `docs/trail/sdd/cycle-1.md` § 3.3.

  **The doubt is answered, not carried.** "One word and one stale sentence may not be worth a
  three-seat run" would hold if this were the only item; § 2.2 sits on the same companion and needs
  the same fold, so the marginal cost of this one is nil. Close call, and what would have tipped it:
  had § 2.2 been absent or already folded, this would still be confirmed — a false command in a
  fixed reference a delivery session reads is a fact now false, the prompt's strongest ground — but
  the doubt would have been worth carrying into the answer rather than dismissed.

### 2.2 — Every trail pointer in this document is dead — the folders moved and the citations did not

- **Bucket:** 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The drafted rule — `docs/sdd_trail/` becomes `docs/trail/sdd/` — is right and applies to
  all 40 with no exclusion. That is the addition: on this document the two carve-outs its siblings
  needed are both inert, and saying so is what lets the sweep run without the case-by-case pass the
  SRS's fold required.

  **The measurement, re-run here rather than inherited.** 40 by `docs/sdd_trail/`, and 40 by the
  bare `sdd_trail/` pattern too — so the bare-form trap that hid 60 of the PRD's pointers
  (`docs/trail/prd/self_answer-1.md` § 2.1) does not reach this document. 0 commit-pinned,
  re-checked for any `@<sha>:` form across the whole file, so the exception the item protects
  matches nothing. All 40 cite a single file, `docs/sdd_trail/cycle-1.md`, and `nozoki@1e8bf3d`
  moved it as `R100 docs/sdd_trail/cycle-1.md -> docs/trail/sdd/cycle-1.md` — a rename with
  identical content, which is why the re-authoring hazard that held three SRS citations back
  (`docs/trail/srs/cycle-8.md` § 2.2, where the file at the new path was a *different* cycle 2)
  has no counterpart here. Every anchor resolves at the new path: §§ 1.1, 1.2, 1.3, 2.1, 2.2, 2.3,
  2.4, 3.1, 3.2 and 3.3 are all present as headings in the moved file, checked one by one.

  **The second exclusion does not carry over.** This document holds no `uxd_trail` citation and
  makes no historical "was removed from the product repository" claim, so nothing is held back and
  no citation needs converting to the pinned form.

  **The item's scale paragraph is wrong now — reported, not corrected.** 235-across-six was already
  understated when written (the PRD carried 62, not 2 — `docs/trail/prd/self_answer-1.md` § 2.1),
  and PRD v12, SRS v9, UXD v7, DESIGN v6 and CONTENT v5 have each since been repaired. The census
  on 2026-09-01 leaves this document's 40 as the last unrepaired set of the six; everything
  remaining in the other five is version-line prose describing the repair itself, or the
  commit-pinned `nozoki@1d5c553:` citations the rule preserves. That closes the one clause of this
  item that read as the owner's — "which way it is done is the owner's call", one mechanical sweep
  against six document cycles. Five cycles are spent and the sixth is this round, which § 2.1 owes
  anyway, so there is no sweep left to choose and no call left to put to them.

  **Failure paths.** *Absent* — the target file and every anchor were opened at the new path before
  confirming, so the sweep cannot turn a dead pointer into a false one, which is the failure mode
  that produced the SRS's exclusions. *Stale* — nothing else moves the trail folders again inside
  this round. The version line records the change and its reason, `nozoki@1e8bf3d`, as the five
  sibling folds did.

## Left for the owner

None this run. Neither item binds a person, an outside party, money, a legal position or a risk the
owner carries, and neither is a taste they reserved. The one clause that read as theirs — § 2.2's
choice between one sweep and six cycles — has been closed by facts on the ground rather than
decided over their head: five of the six cycles are already spent, so the option a sweep represented
no longer exists to choose.

## Skipped

None this run. Both items carried a **Confirm-or-override** slot still at its placeholder, and both
were worked. No slot on this companion was already filled and none is addressed to `product-sdd`
rather than to this seat.

## Raised on this document

### 2.3 — § 12 promises to reference the ADRs "once they exist" — nine now exist, eight Accepted, and this document cites none

- **What the document is owed:** RN-6, RN-7 and RN-8 each name the ADR that now records them, and
  § 12's downstream boundary states that the three are recorded rather than pending — the condition
  it set on itself having fired.
- **Why it is worth a cycle:** *Something upstream moved and it has not seen it*
  (`decide_companion_answers.md` § The items are not the whole of what a document is owed). The
  change: `docs/adr/0001-capability-split-read-pipeline.md` (traces to `docs/SDD.md` § 1),
  `docs/adr/0002-tauri-2-rust-host-wkwebview-renderer.md` (§ 4 C-R1) and
  `docs/adr/0004-git-read-through-libgit2-behind-a-port.md` (§ 2, force 2) exist and are
  **Accepted**, beside six more (0003 and 0005 – 0008 Accepted, 0009 Proposed). The consequence,
  which is the half that makes it worth a run: this document names no ADR by number anywhere — its
  eight `ADR` mentions are all the forward promise — so a cold reader of RN-6, RN-7 or RN-8 meets a
  decision still awaiting a record and cannot reach the record that holds it, while `docs/nfdr.md`
  cites all nine as settled trace tags. This SDD is the one document in the chain that does not
  know its own decisions were ratified. The sentence's second half is unmet too: "and does not
  restate them" leaves § 2's candidate table and RN-6 – RN-8's reasoning standing beside the
  records with no pointer either way, which is the two-homes shape the sentence was written to
  prevent. The item's slot is left at its placeholder — the reasoning is this run's and the
  decision is the next round's — and the edit's extent under "does not restate them" is named as
  the CTO's on the fold rather than drafted here.

  **One defect examined and deliberately not raised:** `docs/SDD.md`'s header reads `**Status:**
  Settled` and its version line says "the companion is empty and removed this run" while this
  companion stands. That is `product-sdd`'s own bookkeeping and it self-heals on the fold, which is
  the same call the CONTENT self-answer made on the same shape.

## Companions opened

None this run. Both items and the one raised land in `docs/SDD.md`, the document this companion
belongs to, so nothing routed elsewhere. Two documents were read far enough to check a claim and
neither was judged owed a change: `docs/nfdr.md` already reads `pnpm` throughout and needs no move
if § 2.1 is confirmed, and `docs/SRS.md`'s one remaining live-looking `docs/uxd_trail/cycle-2.md`
citation (`:734`) is the historical statement its own owner-seat answer deliberately excluded from
the sweep — true as written, and false once rewritten.

## Launchers owed

- **`docs/SDD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-sdd/launcher.sh nozoki`
