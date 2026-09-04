# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** /Users/eyalgolan/products/nozoki/docs/architecture_open_issues.md
- **Document:** `adr/` and `nfdr.md` (`docs/adr/`, `docs/nfdr.md`) — the companion's own header names both
- **Decided by:** `decide_companion_answers.md` v1.1.0
- **Date:** 2026-09-04

## Items worked

### 2.1 — Thirteen more citations in the records the SDD's re-author moved, outside cycle 3's scope — pin them to `nozoki@70a879a:` the same way

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** **Confirmed, and a fourteenth citation joins the thirteen.** Check 1 — the edit lands in
  the decision log, this seat's; it commits nothing to a stranger (a citation repair changes no
  decision, and the records ship as they are); and the one ground that could have kept it from the
  owner — cycle 3's *"these 38 and nothing else"* — is a bound on that fold, stated as such
  (*"Scope, so the fold does not widen"*, `docs/trail/architecture/cycle-3.md` § 3.1), not a
  reservation of the class: the owner's answer gives three grounds and a rule that a citation repair
  is a prose edit needing no supersession, and this item applies that rule to more instances of the
  same breakage. Check 2 — the draft holds and for the reason it gives. The count is right: every
  one of the thirteen is at the line the item names (`grep -n` over `docs/adr/`, 2026-09-04 —
  ADR-0002 :46, :50, :54, :69 `§ 9 TO-1, TO-4` and :64 `Open Questions, fifth item`; ADR-0006 :66,
  :73; ADR-0005 :28, :39, :64 `the paragraph following/after the parts table`; ADR-0004 :64 `§ 11
  R-1, R-6`; ADR-0009 :15, :61 `§ 6 S-6`), and every move is as stated: `git show
  70a879a:docs/SDD.md` has TO-1 as *surfaces drawn in a WebView* and TO-4 as *a Rust host*, where
  `docs/SDD.md` v3 § 9 has TO-1 as *two processes and one serialized seam* and TO-4 as *a rendering
  engine that is Apple's*; the deleted § Open Questions' fifth item is the `img-src` origin form and
  the re-authored list's fifth is the fixture sizes, the origin form now third; the deleted R-6 is *a
  dependency brings a capability the product must not have* and the re-authored R-6 is *the reader's
  place is lost on a refresh*; the deleted S-6 is *Switch the viewed folder* and the re-authored S-6
  is the theme slice, the `nozoki-ui/src/…` paths now under S-10; the deleted § 3 paragraph after
  the parts table argues the root finding's placement in `git-reader`, the re-authored one is the
  four physical units. And the draft's claim that these are the only ones was tested rather than
  taken: the same records' other § 9 and § 11 citations — TO-2 (libgit2), TO-5 (the raw-source
  switch not built), TO-6 (the asset scheme), R-1 — carry the same subject in both SDDs and resolve.
  **The addition** is the case the draft named and set aside: ADR-0001 :14 cites `docs/SDD.md` § 1,
  last paragraph for the quoted *"if the code is careful"*. The deleted § 1 ends in three questions
  and that phrase; the re-authored § 1 ends in four questions without it, and the phrase sits in § 2's
  first table row (`docs/SDD.md:207`). The draft excludes it because the subject survives — but the
  record's claim is about *words its author read*, ground (b) exactly, and a quotation whose cited
  source no longer holds it misstates its source as surely as a moved note does; that the reader can
  find the phrase one section over makes the misdirection mild, not absent. Confirmed with that
  case added rather than overridden, because the rule the draft applies is right and the exclusion
  was the only defect. Check 3 — nothing settled moves: the ADR index's append-only rule scopes
  itself to reversals (`docs/adr/README.md:3-5`), the owner's (b) rejected re-pointing for the log
  and (c) named the pinned form as this repository's precedent, and `docs/nfdr.md` RN-16 already
  records that the fold stopped at 38 for scope, not for doubt. The item's *If overridden* was
  weighed: pinning every SDD citation in all nine records is one rule a reader can carry, but a
  citation that resolves to the same passage today is a live claim that the record and the SDD
  still agree, and freezing ~50 of them would hide the one signal a later re-author's reader has.
  Check 4 — *stale*: a pinned citation cannot go stale again, which is the point; *absent*:
  `70a879a` is in this repository's history and a clone without it loses the 37 already pinned the
  same way, a cost the owner accepted at cycle 3 and the domain doctrine's ship-with-the-tool rule
  makes real, so it is named here and not re-decided; *empty / concurrent / refused*: not reached by
  a citation edit. What would have tipped it to plain *confirmed*: a reading of ground (b) as
  "subject" rather than "what the author read" — the owner's own words are the latter.

## Left for the owner

### 1.1 — The SDD's confirmed 1.0.0 contract prices own-state readability nowhere; the FDR and QC-59 price it

- **Bucket:** 1. Open issues — questions with no answer yet
- **Verdict:** left for the owner
- **Why:** **The decision changes what the product promises in public, and the owner reserved that
  class in their own words.** Check 1's three tests do not agree and the second and third carry it.
  Where the edit lands depends on the answer — the SDD's § 6 S-11 under one reading, `docs/nfdr.md`
  QC-59/QC-60 and `docs/fdr.md` PD-39 under the other — so the first test does not settle a seat.
  What the answer commits: whether a discard of an adopter's own state after 1.0.0 costs a major
  version is a promise to strangers and the instrument that prices the maintainer's future changes;
  and the README at 1.0.0 states the contract in S-11's words (`docs/SDD.md` § 6 S-11 *Reached
  when*), so either answer changes a sentence a stranger reads. The nameable ground: *"Park an item
  for the owner when the answer changes what the product promises, not when it changes how the work
  is divided"* (`git show 70a879a:docs/trail/sdd/cycle-1.md`, line 210 — the owner's routing rule,
  which five `companion-self-answer` runs held the contract to before the owner confirmed it in
  person). This item is that rule's first clause literally. **One fact the owner should have before
  deciding, because the item calls both statements owner-confirmed and they are not equally so:**
  S-11's contract was confirmed by the owner in person (`docs/trail/sdd/cycle-2.md` § 2.2, *"i guess
  confirm"*, 2026-09-04); PD-39's pricing was confirmed in the owner's *seat* by a
  `companion-self-answer` run (`docs/trail/fdr/cycle-1.md` § 2.9 → `docs/trail/fdr/self_answer-1.md`
  § 2.9), and QC-59's third member likewise (`docs/trail/architecture/cycle-1.md` § 2.1 →
  `docs/trail/architecture/self_answer-1.md` § 2.1). The conflict was never put to the owner side by
  side: the SDD does not read the FDR (the FDR derives from the SDD, `docs/fdr.md` preamble), so
  S-11's silence is not a ruling against PD-39, and the SDD companion's § 2.2 did not name PD-39 or
  QC-59. **Not raised on the SDD's companion now**, though the change most likely lands there: the
  edit's home follows the decision, and a companion opened before it would ask the CPO seat — or the
  chain's next self-answer, which would leave it again — to make a call the owner reserved; the
  prompt names that as the failure of the upstream-only outcome. **Not split:** the two questions
  inside it (which document is right; where the sentence then lands) are one in two coats — the
  second presupposes the first. Leaving it costs the chain nothing: the NFDR is already Draft on this
  item, QC-59 and QC-60 stand on the FDR until it is answered (RN-16), and the FDR companion this run
  opened names the call as open here rather than reconciling on its own. **Routes, each way.** If the
  owner's answer is the first reading, their `companion-answer` walk opens `docs/SDD_open_issues.md`
  for the CPO's fold (S-11 *Delivers* gains the member; RN-19 records the authorization) and this
  item closes with nothing landing in these records — the slot can say so in one line. If the
  second, the slot's answer is what `product-architecture` folds — QC-59 drops its third member,
  QC-60's *"after 1.0.0 a discard is a breaking change under QC-59"* goes — and PD-39 becomes a
  second item on `docs/fdr_open_issues.md`, the Principal PM's, not drafted there because it is not
  decided.
- **The answer I would have given:** **The FDR is right and complete; S-11 is owed the member, a
  CPO fold through the SDD's own run; QC-59 and QC-60 stand as written and nothing in these records
  moves** — the item's own offered reading, reached here on three grounds it did not give and one it
  did. (1) The SDD's own rationale for the contract names *"their own remembered state"* as one of
  the four things an adopter demonstrably relies on between versions (`docs/trail/sdd/cycle-2.md`
  § 2.2 *Rationale*), and then places own state only under *what no version changes* as *read whole
  or discarded whole* — a safety guarantee, § 4 C-D4's, which buys the adopter nothing about
  continuity; `docs/trail/sdd/self_answer-5.md` § 2.2, addition (1), found the same hole and the
  owner declined the additions as a set without being shown PD-39. A contract that names the
  reliance and prices nothing for breaking it is the sentence that misleads a stranger. (2) The
  domain's public contract for a tool with no library surface includes its config fields
  (`system/loaders/principal_architect.md` § *The domain*, "The public contract is the other one");
  own state is the nearest thing Nozoki has to one, and C-D4 closes its field list, so pricing
  readability costs the maintainer a migration for a three-field file or a major version — small —
  while not pricing it puts the cost on strangers, which is the trade the domain doctrine says to
  refuse. (3) Dependency direction does not decide against the FDR: PD-39 traces to SRS C-6 and the
  PRD, not to the SDD, and was raised at the FDR's own altitude as a product decision. (4) The
  item's ground: the SDD's C-D4 already traces its discard clause to C-6, so the SDD half-says it.
  **Check 4, walked:** *stale* — QC-60's check reads only `--from <previous-tag>`, while "an earlier
  version's own state" is any earlier state inside the major, so an adopter skipping 1.1 → 1.3 is
  covered by the rule and by the check only if the writer's shape did not change in between; the
  sentence S-11 gains should say *from any earlier release of the same major*, and QC-60's
  verified-by is owed a note that the check proves one step and the rule binds the whole major — a
  gap named, not filled, because QC-60 moves only under an authorization. *Refused / downgrade* —
  an older version discarding newer state is not "an earlier version's own state"; R-168's symmetry
  is behaviour, PD-39's pricing is forward only, and S-11's sentence should say *forward*
  (self_answer-5's addition (5) reached the same). *Concurrent* — R-170 and QC-60 cover two
  instances sharing one state. *Empty / absent* — nothing to read, no discard, nothing broken.
  **What would tip it to the second reading:** the owner saying that confirming S-11 in person was
  meant to keep own state out of the priced set — then QC-59 and QC-60 lose the member and PD-39 is
  the Principal PM's to reconcile; the cost is that a 1.x release may silently reset a stranger's
  theme and remembered folders under a minor version, stated only in release notes (R-170).

## Skipped

- **§ 3 — Raised from downstream** — carries no item this round (`<None this round — cycle 3's
  § 3.1 is folded; docs/nfdr.md RN-16 records how.>`); nothing to work.

## Companions opened

- **/Users/eyalgolan/products/nozoki/docs/fdr_open_issues.md** — **opened** — companion to `fdr.md`, landed in commit `d0ce7b7`. Not routed by an item: opened under the prompt's *a fact in it is now false*, measured while reading the FDR as an input to § 1.1 — twelve trace tags (R-70, R-73, R-106, R-117, R-124, R-126, R-171, R-174, RN-1, RN-9, RN-21, RN-25) cite the deleted SDD's review notes RN-16, RN-19, RN-20 and RN-26, two of which carry other subjects in `docs/SDD.md` v3 and two of which it does not carry (`grep -c 'SDD § SDD Review Notes RN-\(16\|19\|20\|26\)' docs/fdr.md` → 12, 2026-09-04). `docs/nfdr.md` RN-16 had reported it as the Principal PM's and nothing routed to that run. One item in choices to confirm, slot at its placeholder, drafting the form under the owner's cycle-3 rule for a document revised in place and leaving the pointers to the FDR's run. The doubt: the same run could re-derive the whole FDR against the re-authored SDD, and this item asks only for the measured repair — the wider re-derivation is that run's to judge.

## Launchers owed

- **`adr/` and `nfdr.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-architecture/launcher.sh nozoki`
- **`fdr.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-fdr/launcher.sh nozoki`
