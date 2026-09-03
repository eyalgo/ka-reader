# Self-answer report — SDD.md

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `decide_companion_answers.md` v1.1.0
- **Date:** 2026-09-03

## Items worked

### 2.3 — S-11's *Delivers* states the contract as one list of four — two of its members are invariants no version can buy

- **Bucket:** 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The finding holds and the fix is right: *Delivers* names four covered items and closes on
  four breaking changes — removing a surface, raising the floor, adding a prerequisite, changing the
  install path — which reach (a) and (d) and nothing else, so a reader asking what a change to (b)
  or (c) costs infers a major version for a change that is not on offer at any price
  (`docs/SDD.md` § 6 S-11). Stating the priced set and the unconditional set separately, each naming
  the constraint that binds it, is what makes the sentence answer that reader. This item was raised
  by `docs/trail/sdd/self_answer-3.md` § 2.3 with its slot deliberately left for this round; the
  slot is the decision and this is it.
  **Two additions, and the first is a correction to a citation the item rests on.** The item groups
  (b) as one member unconditional by C-2, NFR-7 and NFR-8. C-2 and NFR-7 carry that weight — C-2
  reads *"no write path to the viewed folder exists in any version; adding one would be a different
  product"* (`docs/SRS.md` C-2) and NFR-7 excludes telemetry, accounts, identity and behavioural
  data outright. NFR-8 does not. Its own entry names the route by which a network call could
  arrive: *"The PRD keeps the phrase 'no non-essential network call' as headroom for a possible
  future update or version check; such a feature enters the PRD as a stated feature before it
  exists, and reaches this SRS by revision — until then, none"* (`docs/SRS.md` NFR-8, re-read
  2026-09-03). The item's conclusion survives — no version bump buys a network call — but the
  reason it gives does not, and a *Delivers* sentence that says *"what no version changes"* over
  the no-network member would assert something its own input contradicts. So the unconditional set
  names that route as part of the member: the change starts upstream with a PRD revision, not with
  a version bump. This is the prompt's *stale* path — true when written, and the clause is what
  keeps it true after the PRD moves. Without it the correction trades one misreading for another,
  which is why it is an addition and not a confirmation as it stood.
  The second addition is the fold order. § 2.2 is still open and `product-sdd` folds this companion
  in one pass, so a sentence that hard-names *(c) by § 4 C-D4* in the unconditional set can be
  contradicted by the owner's next answer: as drafted (c) promises safety, which § 4 C-D4 already
  binds at every version, but if the owner means continuity the bundle identifier joins what the
  number prices and (c) moves. Stating the classification as a rule — priced when a change is on
  offer and the closing clause reaches it, unconditional when an upstream constraint forbids it at
  every version, each member naming its constraint — makes the placements derivable from whatever
  § 2.2 settles, with no second decision owed. The item already says its classification applies to
  whatever § 2.2 settles; writing that as a rule in the document is what makes it true of the
  document rather than of this companion.
  **Checked against the settled record and against this run's other item.** Nothing here moves
  C-2, C-6, NFR-7, NFR-8 or § 4 C-D4, and no member of the list is added or removed. § 2.1's
  answer stands on adding in-folder SVG later costing a minor version, which is a (d) question and
  untouched. § 2.2 stays the owner's and stays whole: this addition constrains how its answer is
  written down, never what it says.
  **Close to a different verdict:** plain *confirmed*. What tipped it is NFR-8's second sentence —
  confirming as it stood would have folded a citation that does not say what the item says it says,
  and `decide_companion_answers.md` § *What check 2 is actually asking* puts that case in
  *confirmed with addition* rather than in confirmation.

## Left for the owner

### 2.2 — What the 1.0.0 promise covers — the contract the version number starts

- **Bucket:** 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override
- **Verdict:** left for the owner
- **Why:** Theirs, for the fourth round, and the ground is the same one that has held each time
  rather than a habit of leaving it. What the item asks after § 2.3 took the classification half
  away is the content of a public promise to strangers: which changes nozoki will be held to, and
  for how long. The owner's own standing routing rule, bound by § 1.1 of this companion, reserves
  exactly that class in their words — *park an item for the owner when the answer changes what the
  product promises, not when it changes how the work is divided*
  (`docs/trail/sdd/cycle-1.md` § 3.1). The ground this run cannot see is nameable: what the owner
  is willing to keep paying for after 1.0.0. A compatibility contract is the instrument that makes
  a future change cost a major version, and `docs/PRD.md` § Risks already names maintenance a
  standing liability that is theirs alone.
  Leaving it blocks nothing. S-11 is the last slice; its *Not in this slice* already routes the
  contract's content here (`docs/SDD.md` § 6 S-11), and § 2.1's answer refers to the contract as
  *drafted* rather than as settled. **What would tip it:** the owner saying the declaration is the
  seats' to make, which RN-19 argues is where the CPO's posture already puts it.
  **Not split again.** The two additions below narrow the owner's choice without making it, which
  is `decide_companion_answers.md` § *An item with two seats splits* → *What is not a split* → *A
  premise of a call that stays the owner's*. They belong in this answer, not in a new item.
- **The answer I would have given:** **Confirm the four covered items and the exclusions, with
  five additions — the three `docs/trail/sdd/self_answer-3.md` § 2.2 reached, which this run
  re-derived and concurs with rather than restating, and two more from the failure paths.**
  Self_answer-3's three, by name so they are not lost in a pointer: say which way (c) points —
  safety or continuity; make an enumerated surface's membership the meaning of "present", so
  dropping one of FR-8's six languages costs a major version and adding one costs a minor; and say
  that a forced change is still priced, so a maintainer meeting an Apple-forced floor bump does not
  go looking for an exception. All three still hold on re-reading.

  **Fourth — pin which PRD the contract reads.** *"Every surface the PRD names, present and
  read-only"* points at a document that is still being revised. Read one way, a surface added to
  the PRD in 2027 is retroactively covered by the 1.0.0 promise a 2026 release made; read the
  other, the promise never grows and a surface added after 1.0.0 is covered by nothing. Neither is
  what the draft means. The line worth writing is that **each release's contract covers the
  surfaces the PRD names at that release** — so adding a surface is additive, costs a minor
  version, and is covered from that release onward, and no earlier version is retroactively held to
  a promise it could not have made. This is the *stale* class in the prompt's check 4: the answer
  is right at the moment it is computed, and the PRD moves afterwards. It is also the case where
  the exclusion list gives no cover — wording and tokens are excluded, but the *set of surfaces* is
  the contract's own subject.

  **Fifth — say that (c) points forward only, and that a downgrade is not covered.** *"A later
  version reads what an earlier one wrote"* is a one-way promise, and the *concurrent* path is the
  one it does not reach: two installed versions alternating over one container. The newer writes a
  field the older cannot read, C-D4 has the older discard the container whole and open at first-run
  state, and the adopter loses their theme — and, beyond v1, their ten remembered folders — on
  every switch, with the product behaving exactly as `docs/SDD.md` § 4 C-D4 requires each time.
  Nothing is broken; the contract simply says nothing. Say that own state is guaranteed **forward
  across upgrades only**, and that running an older version after a newer one may reset it. A named
  uncovered case is an answer; leaving it unnamed is a hole with a promise sitting on top of it.

  Everything else in the draft holds. The four items are what an adopter demonstrably relies on
  between versions — the way in, the promises the product is for, their own remembered state, and
  the surface they came for — and the exclusions correctly keep the promise off wording and token
  values, which would otherwise make every `docs/CONTENT.md` and `docs/DESIGN.md` revision a
  major-version event.

## Skipped

- **1.1 — Do the owner's answers to the previous SDD bind this run?** — answered at
  `nozoki@59287c9`; a re-run leaves a decided item alone.
- **2.1 — An SVG inside the folder is not rendered in place** — answered at `nozoki@59287c9`.
- **3.1 — `first-public-release` lands after the v1 cut, below 1.0.0** — answered at `nozoki@59287c9`.
- **5.1 — `sdd_template.md` § 3 gained a units table** — answered at `nozoki@59287c9`.
- **5.2 — The re-author broke 38 citations in the decision log and the NFDR** — answered at
  `nozoki@caa3e0c`.
- **§ 4 Disagreements** — reads "None yet."; no item to work.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-sdd/launcher.sh nozoki`
