# Self-answer report — SDD.md

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `decide_companion_answers.md` v1.1.0
- **Date:** 2026-09-03

## Items worked

None this run. The one open item is § 2.2, left for the owner below; the change this run found in
the document is § 2.4, raised rather than answered, and recorded under *Raised on this document*.

## Left for the owner

### 2.2 — What the 1.0.0 promise covers — the contract the version number starts

- **Bucket:** 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override
- **Verdict:** left for the owner
- **Why:** Theirs, for the fifth round, and this run re-derived the ground rather than inheriting
  it — four identical verdicts are exactly the pattern that ought to be re-tested rather than
  continued. It holds, and it holds on the owner's own words rather than on this run's reluctance.
  Check 1's three tests do not agree, and the second and third carry it. **Where the change lands**
  points *to* this run: the edit is `SDD.md` § 6 S-11 *Delivers* and RN-19, and no upstream document
  moves — § 12's SRS and UXD boundaries found no gap, and § 12 keeps the PRD gap here rather than
  sending it to the PRD. **What the answer commits, and to whom**, points away: a compatibility
  contract is a promise to strangers, and the instrument by which some future change costs a major
  version. **The ground this run cannot see is nameable**, and it is not the general possibility of
  being overruled: the owner has reserved this exact class in their own words — *"Park an item for
  the owner when the answer changes what the product **promises**, not when it changes how the work
  is divided"* (`git show 70a879a:docs/trail/sdd/cycle-1.md` § 3.1, re-read this run; bound on this
  companion by § 1.1). An item asking what the version number promises is the first clause of that
  rule literally, not by analogy. Behind it sits the thing the owner alone knows — what they are
  willing to keep paying for after 1.0.0 — against a PRD that already names maintenance a standing
  liability that is theirs (`docs/PRD.md` § Assumptions; § Risks).
  **What nearly tipped it, and is worth the owner's attention.** Most of the draft is no longer a
  fresh commitment, which is the strongest argument that the residue is small enough for the seats.
  Read-only, no-network and own state left the priced set at § 2.3 and are bound upstream at every
  version. The macOS floor's membership is *already decided in this document* and was never routed
  here — § 4 C-R5 says "Raising it after 1.0.0 is a breaking change under C-6", and § 9 TO-8 prices
  it the same way. The exclusions are forced: covering message wording or token values would make
  every `docs/CONTENT.md` and `docs/DESIGN.md` revision a major-version event. What is genuinely
  still open is narrow — the install path, and that removing a PRD-named surface costs a major
  version. **It stayed theirs anyway** because narrow is not the same as small: that residue is the
  whole of what an adopter is being asked to rely on, and the owner's rule is about the kind of
  question, not its size.
  Leaving it blocks nothing. S-11 is the last slice, its *Not in this slice* already routes the
  contract's content here, and § 2.1's answer refers to the contract as *drafted* rather than as
  settled.
- **The answer I would have given:** **Confirm the covered items and the exclusions, with six
  additions — the five that `docs/trail/sdd/self_answer-3.md` and `-4.md` reached, which this run
  re-derived and concurs with, and a sixth from the *refused* failure path that none of them
  reached.** The five, named so a pointer does not lose them: **(1)** say which way own state points
  — safety or continuity — because as drafted it buys the adopter nothing § 4 C-D4 did not already
  bind, and if continuity is meant the bundle identifier joins the priced set; **(2)** make an
  enumerated surface's membership the meaning of "present", so dropping one of FR-8's six floor
  languages, one of AC-6's four Git elements or one of C-D3's four image formats costs a major
  version while adding one costs a minor; **(3)** say that a forced change is still priced, so a
  maintainer meeting an Apple-forced floor bump or a retired GitHub Releases does not go looking for
  an exception the contract never wrote; **(4)** pin which PRD the contract reads — each release's
  contract covers the surfaces the PRD names *at that release*, so no earlier version is
  retroactively held to a promise it could not have made; **(5)** say that own state is guaranteed
  forward across upgrades only, and that running an older version after a newer one may reset it.
  **Sixth — say that the promise binds the releases that are made, and does not promise that one
  will be.** This is the *refused* path: the case where the maintainer, or Apple, or GitHub says no
  and stops. The PRD plans for it twice — *"a version that can no longer be maintained is archived
  visibly rather than left looking staffed"* (§ Assumptions, stated in two places) — and the SRS
  deliberately declined to carry it, recording the drop because it is "an act on the repository
  after maintenance ends, not a behavior of the system" (`docs/SRS.md` RN-24). So it lands in no
  requirement and in no slice, and the contract sentence is the last place before the README where
  the version number meets it. As drafted the contract says what a change *costs* and is silent on
  whether the promise can *end*; an adopter reading "1.0.0 is the moment the promise starts" beside
  a priced list can reasonably hear an undertaking that releases keep coming. One clause closes it:
  the number prices any release that is made, and no release is promised.
  **The doubt, stated rather than buried:** this sixth is the weakest of the six, and C-13 already
  puts the support posture — "no commitment to fix, no commitment that a fix ever arrives" — on the
  same README page, so a careful reader can compose the answer. It is offered because the contract
  is the sentence that invites the wrong reading, and one clause is cheaper than the composition.
  Everything else in the draft holds. The covered items are what an adopter demonstrably relies on
  between versions — the way in, the promises the product is for, their own remembered state, and
  the surface they came for — and the exclusions correctly keep the promise off wording and tokens.

## Skipped

- **1.1 — Do the owner's answers to the previous SDD bind this run?** — slot filled at
  `nozoki@59287c9`; a re-run leaves a decided item alone.
- **2.1 — An SVG inside the folder is not rendered in place** — slot filled at `nozoki@59287c9`,
  folded into § 4 C-D3 and RN-8 at `nozoki@f2b8a74`.
- **2.3 — S-11's *Delivers* states the contract as one list of four** — slot filled at
  `nozoki@d5c3d59`, folded into S-11 and RN-19 at `nozoki@f2b8a74`.
- **3.1 — `first-public-release` lands after the v1 cut, below 1.0.0** — slot filled at
  `nozoki@59287c9`.
- **5.1 — `sdd_template.md` § 3 gained a units table** — slot filled at `nozoki@59287c9`, folded at
  `nozoki@f2b8a74`.
- **5.2 — The re-author broke 38 citations in the decision log and the NFDR** — slot filled at
  `nozoki@caa3e0c`.
- **§ 4 Disagreements** — reads "None yet."; no item to work.

## Raised on this document

### 2.4 — The priced set carries "read-only" inside member (d) — an invariant no version prices

- **What the document is owed:** S-11 *Delivers* and RN-19 drop "and read-only" from the priced
  set's member (d), leaving *every surface the PRD names, present*; the unconditional set already
  carries read-only by `docs/SRS.md` C-2, so the fix is a deletion and no member of the contract is
  added or removed.
- **Why it is worth a cycle:** *It contradicts a document it must agree with* — and, inside one
  sentence, itself. The round-2 fold placed C-2 in the unconditional set and left the same invariant
  inside a priced member, so the two sets answer "what does making a surface writable cost?"
  differently: *a major version* from the priced set, and *it cannot happen at any version* from the
  unconditional set, which is what C-2 actually says — *"Viewer-only, permanently: no write path to
  the viewed folder exists in any version; adding one would be a different product"* (`docs/SRS.md`
  C-2, re-read this run; § 4 C-E5 the same). The closing clause is the measurement: it reaches
  removing a surface, raising the floor, adding a prerequisite and changing the install path, and it
  does not reach read-only, because no price exists to reach it with. This is precisely the harm
  § 2.3 was raised for and fixed at the list level; § 2.3 asked which of the four members the
  closing clause reaches, and (d) is one it does reach — for presence — so it passed as a member
  while carrying a second property that fails the same test one level down. Raised as an item rather
  than kept in this report because `product-sdd` folds the companion and not the trail, and § 2.2's
  slot stays at its placeholder, so an item is the only route by which this reaches the fold.

## Companions opened

None this run. The change this run found belongs to the document it was answering, so it was raised
on that document's own companion (above) rather than elsewhere. No gap was found in the PRD, the SRS
or the UXD beyond those already routed by RN-32 and RN-34 and recorded in § 5.2.

## Launchers owed

- **`docs/SDD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-sdd/launcher.sh nozoki`
