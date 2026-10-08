# Self-answer report — SDD.md

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `decide_companion_answers.md` v1.1.0
- **Date:** 2026-09-03

## Items worked

None this run. One item is open on the companion — § 2.2 — and it is left for the owner below.
The one change this run judged the document might be owed was tested and rejected before it was
raised; § *Skipped*'s last bullet records it and why.

## Left for the owner

### 2.2 — What the 1.0.0 promise covers — the contract the version number starts

- **Bucket:** 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override
- **Verdict:** left for the owner
- **Why:** Theirs, for the sixth round. Five identical verdicts is the pattern most worth
  distrusting, so this run re-derived the ground from the owner's own words on disk rather than
  from the four reports that reached it before. It survives, and it survives on something
  stronger than the previous rounds cited: **the settled record already routes this item, in
  terms.** The companion's § 1.1 answer — decided at `docs/trail/sdd/cycle-1.md` § 1.1, answer 3,
  quoting the owner verbatim from the previous SDD's trail — states the rule (*"park an item for
  the owner when the answer changes what the product promises, not when it changes how the work
  is divided"*) and then names its first application in the same breath: *"This binds this
  companion's own routing, and § 2.2 is left open under it."* That is a decided item, and a
  re-run does not re-decide one. Check 1's own three tests agree with it and do not need it.
  **Where the change lands** points at this run — the edit is `SDD.md` § 6 S-11 *Delivers* and
  RN-19, and no upstream document moves. **What the answer commits, and to whom** points away: a
  compatibility contract is a promise to strangers, and the instrument by which some future change
  costs a major version. **The ground this run cannot see is nameable, and it is not the general
  possibility of being overruled**: it is what the owner is willing to keep paying for after
  1.0.0, against a PRD that names maintenance a standing liability that is theirs and plans twice
  for a version that can no longer be maintained (`docs/PRD.md` § Assumptions).
  **Whether it splits, asked and answered *no*.** The item does hide a second question — which
  members the contract *covers* against what it *excludes* (message wording, token values, the
  log's lines, what the harness prints) — and the two are separable: an override that drops
  member (d) leaves the exclusion set untouched. But the split rule's second condition fails.
  Run check 1 over the exclusion half and it lands in the same seat: telling an adopter that the
  wording of a message is outside the promise is itself a statement about what the product
  promises, and it binds the same strangers. Both halves the owner's means the item stays whole,
  which is the complete outcome and not a failure to split.
  **What nearly tipped it, and is worth the owner's attention.** The residue is now genuinely
  narrow, and narrower than it was when this question was first asked. Read-only, no-telemetry,
  no-network and own-state safety left the priced set at § 2.3 and are bound upstream at every
  version. Read-only left member (d) at § 2.4, decided by the CPO seat in run 2 and folded
  (`SDD.md` § 6 S-11 *Delivers*, RN-19). The macOS floor's membership is *already decided in this
  document* and was never routed here at all — § 4 C-R5 reads "Raising it after 1.0.0 is a
  breaking change under C-6", and § 9 TO-8 prices it identically. The exclusions are close to
  forced: covering message wording or token values would make every `docs/CONTENT.md` and
  `docs/DESIGN.md` revision a major-version event. What is left genuinely open is two clauses —
  the install path, and that removing a PRD-named surface costs a major version. **It stayed
  theirs anyway**, and not out of caution: those two clauses are the whole of what an adopter is
  being asked to rely on, and the owner's rule sorts by the kind of question, not its size.
  Leaving it blocks nothing. S-11 is the last slice; its *Not in this slice* already routes the
  contract's content here.
- **The answer I would have given:** **Confirm the covered members and the exclusions as they
  stand after §§ 2.3 and 2.4, with six additions.** Five are the ones
  `docs/trail/sdd/self_answer-3.md` and `-4.md` reached and `-5.md` re-derived; this run walked
  the four failure paths again from the *current* draft rather than inheriting them, concurs with
  all five, and sharpens the fifth. The sixth is `-5.md`'s, and it stands.
  **(1) Say which way own state points — safety or continuity.** As drafted, member (c) sits in
  the unconditional set as *read whole or discarded whole, touching no folder*, which buys the
  adopter nothing § 4 C-D4 did not already bind. **The document itself has already chosen, in the
  other direction, and the contract has not caught up:** S-11's *Reached when* tests continuity —
  *"They launch 1.0.0 over the state a previous release left: their theme, their window and their
  remembered folders are as they were"* — while *Delivers* promises only safety. So the slice can
  pass its own bar on something its contract is silent about. If continuity is meant, say so, and
  the bundle identifier `com.kensaiapp.ka-reader` (§ 4 C-R1) joins the priced set, because changing
  it orphans every adopter's container. This is the strongest of the six and the one this run
  would press hardest; it is also, on its own, the reason not to confirm the draft unchanged.
  **(2) Make an enumerated surface's membership the meaning of "present".** *Every surface the
  PRD names, present* does not say at what grain. Fix it: dropping one of FR-8's six floor
  languages (Python, shell, JavaScript, JSON, YAML, TOML), one of AC-6's four Git elements
  (changed files, staged files, branch, status) or one of § 4 C-D3's four image formats (PNG,
  JPEG, GIF, WebP) costs a major version, while adding one costs a minor. The document already
  leans on exactly this asymmetry without stating it: RN-8 rules that adding SVG later *"removes
  no surface, raises no floor, adds no prerequisite, changes no install path — so it costs a minor
  version, never a major one."* This addition is what makes RN-8 true rather than assumed.
  **(3) Say that a forced change is still priced.** An Apple-forced floor bump (§ 11 R-2) or a
  retired GitHub Releases costs a major version like any other; no force-majeure exception exists.
  Without the clause a maintainer meeting one goes looking for an exception the contract never
  wrote. It is consistent with what the document already does: R-2's response routes a failed
  clock to the SRS's C-3 as a companion item, never to an escape hatch.
  **(4) Pin which PRD the contract reads.** Each release's contract covers the surfaces the PRD
  names *at that release* — `docs/PRD.md` v15 for 1.0.0. Unpinned, a later PRD revision that adds
  a surface retroactively puts every shipped release out of compliance with a promise it could not
  have made.
  **(5) Say that own state is guaranteed forward across upgrades only** — running an older version
  after a newer one may reset it, by § 4 C-D4's own read-whole-or-discard-whole rule. **Sharpened
  this run, from the *concurrent* path none of the four earlier runs walked:** the guarantee is
  about version *order*, not about two copies at once. Two bundles share one container by bundle
  identifier (§ 4 C-R1), so a second running copy's write replaces the first's state whole. That
  breaks no promise the contract makes — safety holds, no folder is touched — but an adopter
  reading "your state survives an upgrade" will hear more than that. One clause covering both
  cases is cheaper than two.
  **(6) Say that the promise binds the releases that are made, and does not promise that one will
  be.** The *refused* path. The PRD plans for it twice — *"a version that can no longer be
  maintained is archived visibly rather than left looking staffed"* (§ Assumptions) — and the SRS
  deliberately declined to carry it, recording the drop because it is an act on the repository
  after maintenance ends rather than a behavior of the system (`docs/SRS.md` RN-24). So it lands
  in no requirement and in no slice, and the contract sentence is the last place before the README
  where the version number meets it. As drafted the contract says what a change *costs* and is
  silent on whether the promise can *end*; an adopter reading "1.0.0 is the moment the promise
  starts" beside a priced list can reasonably hear an undertaking that releases keep coming. Its
  doubt, stated rather than buried: C-13 already puts the support posture — *"no commitment to
  fix, no commitment that a fix ever arrives"* — on the same README page, so a careful reader can
  compose the answer; one clause is offered as cheaper than the composition.
  **A seventh was reached and rejected, and the rejection is worth more to you than the
  addition.** This run asked whether § 4 C-E8's cross-surface guarantees — no meaning by hue
  alone, no control by glyph alone — belong in the *unconditional* set. Structurally they qualify
  under RN-19's own rule: an upstream constraint forbids the change at every version, and the
  member would name it. It fails check 3 outright. `docs/UXD.md` UX-A2 says in its own words that
  the rule is *"a design-quality rule inside the settled posture, **not** an assistive-technology
  promise"*, and UX-A1 states that v1 *"makes no assistive-technology promise"* and claims no
  standard. Putting it in the contract would convert a rule the UXD deliberately declines to
  promise into a promise to strangers — a change to a settled document, not an addition to this
  one. Recorded here so the next round does not re-reach it and stop one step earlier.
  Everything else in the draft holds. The covered members are what an adopter demonstrably relies
  on between versions — the way in, the promises the product is for, their own remembered state,
  and the surface they came for — and the exclusions correctly keep the promise off wording and
  tokens.

## Skipped

- **§ 1 Open issues** — no item on the file; § 1.1 stands behind a one-line pointer to
  `docs/trail/sdd/cycle-1.md` § 1.1, folded into `SDD.md` RN-3, RN-5 and RN-17.
- **§ 2.1 — an SVG inside the folder takes a stated placeholder** — dropped behind a pointer to
  `docs/trail/sdd/cycle-1.md` § 2.1 at `ka-reader@635f77f`; answered and folded.
- **§ 2.3 — S-11's contract stated as two kinds, not one list of four** — dropped behind a pointer
  to `docs/trail/sdd/cycle-1.md` § 2.3 at `ka-reader@635f77f`; answered and folded.
- **§ 2.4 — the priced set carries "read-only" inside member (d)** — slot **filled**: decided
  *confirm* by the CPO seat in run 2, round 1 and folded into `SDD.md` § 6 S-11 *Delivers* and
  RN-19 (`docs/trail/sdd/run-2.md`; `ka-reader@635f77f`). A filled slot is an answer somebody gave;
  a re-run leaves it alone. Raised by this skill's run 5, and this run's own check that the fold
  landed as the item asked: `SDD.md` § 6 S-11 *Delivers* now reads *every surface the PRD names,
  present*, and RN-19's worked example drops the same two words.
- **§ 3 Cut calls, § 4 Disagreements, § 5 Raised from downstream** — no items open; § 3.1, § 5.1
  and § 5.2 stand behind pointers to `docs/trail/sdd/cycle-1.md`, and § 4 reads "None yet."
- **A defect in § 2.2's own supporting text — reported, not corrected.** Its *Drafted into the
  SDD* bullet attributes the exclusion clause (*"Not covered: the exact wording of any message,
  any token value, the diagnostic log's lines, and anything the harness prints"*) to `SDD.md`
  § 6 S-11 *Delivers*. *Delivers* carries no exclusion clause. S-11's *Reached when* carries three
  of the four — message, token, log line — and *anything the harness prints* appears nowhere in
  S-11. Correcting it would mean writing `product-sdd`'s words for it, so it is reported here and
  answered as the item the document actually needs. It changes nothing above: the exclusions are
  confirmed either way, and where they are *stated* is part of what § 2.2 settles.
- **A change this document might be owed, tested and not raised.** The safety-versus-continuity
  gap inside S-11 — *Reached when* testing continuity while *Delivers* promises only safety — is
  a real internal disagreement and meets the prompt's third ground. It is **not** raised as an
  item, because it is addition (1) of § 2.2's own answer: raising it separately would put half of
  § 2.2 on the file under a second number, and the split rule refuses that where both halves are
  the owner's. It reaches the fold through § 2.2, which is the only route it needs.

## Companions opened

None this run. No gap was found in the PRD, the SRS or the UXD that is not already routed — the
UXD's broken RN-29 citations by `SDD.md` RN-32, and the decision log's and NFDR's 38 by RN-34 into
`docs/architecture_open_issues.md` § 3.1. The rejected seventh addition above would have been a
change to the UXD, and it was rejected rather than routed: it is this run declining to widen a
promise, not the UXD owing a repair.

## Launchers owed

- **`docs/SDD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-sdd/launcher.sh ka-reader`
