# Self-answer report — SDD.md

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `decide_companion_answers.md` v1.1.0
- **Date:** 2026-09-03

## Items worked

### 2.3 — S-11's *Delivers* states the contract as one list of four — two of its members are invariants no version can buy

- **Bucket:** 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override
- **Verdict:** answered
- **Why:** This is the half of § 2.2 that is not the owner's, reached by asking check 1 again of
  each question inside it. § 2.2 asks **what** the 1.0.0 promise covers — a promise to strangers,
  and left for the owner for the third round running (below). Underneath it sits a second question
  it never separates: whether the *Delivers* sentence may present its members as **one kind of
  thing**. That one binds nobody outside, commits no maintenance, and is settled by reading
  documents already on disk, so under check 1's second test — *an answer that binds only this
  document's internal consistency is yours* — it is this document's.
  **The finding.** *Delivers* names four covered items and closes on four breaking changes:
  removing a surface, raising the floor, adding a prerequisite, changing the install path. Those
  reach (a) the install path and the floor, and (d) the PRD-named surfaces. They reach (b) the
  read-only and no-network promises and (c) own state not at all — and the reason is not an
  omission in the closing clause. Neither is purchasable at any price. `docs/SRS.md` C-2 reads
  *"Viewer-only, permanently: no write path to the viewed folder exists in any version; adding one
  would be a different product"*; NFR-7 and NFR-8 exclude telemetry and network calls outright
  rather than by default; and this document's own § 4 C-D4 binds own state to read-whole-or-discard-
  whole, touching no folder, at every version (all re-read 2026-09-03). So the list mixes what the
  number **prices** with what nothing buys, and a reader asking what a change to (b) or (c) costs
  infers a major version, which is wrong — the change is not on offer.
  **Why it split rather than riding § 2.2's answer.** All three of the prompt's conditions hold.
  *Separable:* the classification is read off C-2, NFR-7, NFR-8 and C-D4, not off anything the owner
  decides, and it applies to whatever membership § 2.2 settles — an override that drops a member
  included. *Different seats:* § 2.2 commits the owner to a public promise and to the maintenance
  liability the PRD already names as theirs; this commits nothing that is not already bound
  upstream. *Already reached:* the answer is above and stands without § 2.2's. The decisive test was
  the first of check 1's three — **a bare "confirm" on § 2.2 does not fix this.** It folds the draft
  as it stands and the ambiguity survives, which is what tells you it is a separate question rather
  than a premise of theirs; and because the folding run reads the companion and not this report, an
  item on the companion is the only route by which the fix reaches the fold.
  **What the moved half is not.** It adds and removes no member of the list. It also leaves the
  slot at its placeholder, so the round still costs one confirmation — the run's reasoning, the next
  round's decision.
  **Close to a different verdict:** *left for the owner*, with § 2.2, which is where the two
  previous runs put the whole item. What tipped it is that the correction survives every branch of
  the owner's decision, so leaving it with them buys nothing and costs a second round of a document
  that misstates its own contract.

## Left for the owner

### 2.2 — What the 1.0.0 promise covers — the contract the version number starts

- **Bucket:** 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override
- **Verdict:** left for the owner
- **Why:** Re-examined this run, narrower than before, and still theirs. What is left of the item
  after the split above is the question the item's heading actually asks: **what the promise
  covers**, and whether the owner is willing to be held to it. That is the content of a public
  commitment to strangers, and their own standing routing rule — bound by § 1.1 of this companion —
  reserves that class in their words: *park an item for the owner when the answer changes what the
  product promises, not when it changes how the work is divided* (`docs/trail/sdd/cycle-1.md`
  § 3.1). The ground this run cannot see is nameable rather than gestured at: what the owner is
  willing to keep paying for after 1.0.0. A compatibility contract is the instrument that makes some
  future change cost a major version, and `docs/PRD.md` § Risks already names maintenance a standing
  liability that is theirs alone. **The other half of this item is § 2.3 of this companion**, above:
  answered, and waiting on a confirmation rather than on them.
  Leaving it still costs the chain nothing — S-11 is the last slice, and § 2.1's answer refers to
  the contract as *drafted* rather than as settled. **What would tip it:** the owner saying the
  declaration is the seats' to make, which RN-19 argues is where the CPO's posture already puts it.
- **The answer I would have given:** **Confirm the four covered items and the exclusions, with
  three additions.** The correction the previous two runs carried here — that (b) does not belong in
  a list of things a major version could buy — is no longer part of this answer: it is § 2.3, on the
  companion, where the fold will reach it. What remains is content, and it is yours.
  *First — say which way (c) points, and § 2.3 makes the question sharper rather than answering it.*
  "Own state — a later version reads what an earlier one wrote, or discards it whole" promises
  **safety**, not **continuity**: a version that changed the bundle identifier would start from an
  empty container, satisfy the letter of (c), and cost a reader their theme and, beyond v1, their
  ten remembered folders. As drafted, (c) buys the adopter nothing the product was not already bound
  to by § 4 C-D4 — which is exactly why § 2.3 classifies it as unconditional. If **continuity** is
  meant, that is a different promise and it has to be named: the bundle identifier joins the priced
  set, and changing it costs a major version. If only safety is meant, say that losing own state is
  permitted, so nobody reads the promise as more than it is.
  *Second — decide what "present" means for a PRD-named surface, because the enumerated sets are
  where it bites.* An adopter relies on their `.py` file being highlighted. `docs/SRS.md` FR-8 names
  the floor — Python, shell, JavaScript, JSON, YAML, TOML — and says the floor grows only by a PRD
  revision. Dropping one is not obviously "removing a surface" under the drafted wording, so it is
  uncovered by accident; and it is not the only such set — AC-6's four Git elements (changed files,
  staged files, branch, status) and § 4 C-D3's four image formats have the same shape. The line
  worth drawing is the class, not the instance: **where an upstream document enumerates a surface's
  contents, the enumeration is what "present" means**, so removing a member costs a major version
  while adding one is additive and costs a minor. Unenumerated presentation — how the history is
  drawn, what a marker looks like — stays outside, which is what the exclusions on wording and token
  values already say. This reading is what § 2.1's answer is already standing on: adding in-folder
  SVG later removes no member and costs a minor version.
  *Third — say that a forced change is still priced.* Neither prior run reached this and the draft
  does not close it. Apple withdrawing support for a macOS version, a dependency bump that raises
  `LSMinimumSystemVersion`, GitHub retiring Releases, or the `kensaiapp` organisation moving
  (`docs/PRD.md` § Assumptions "Public identity"; § 4 C-R4) all produce a raised floor or a changed
  install path that nobody chose. Under the draft they cost a major version, and they should — the
  adopter's cost is identical whoever forced it — but a maintainer meeting a forced bump will look
  for an exception, and the contract should have closed that door before they get there rather than
  after.
  Everything else in the draft holds. The four items are what an adopter demonstrably relies on
  between versions — the way in, the promises the product is for, their own remembered state, and
  the surface they came for — and the exclusions correctly keep the promise off wording and tokens,
  which would otherwise make every `docs/CONTENT.md` and `docs/DESIGN.md` revision a major-version
  event.

## Skipped

- **1.1 — Do the owner's answers to the previous SDD bind this run?** — answered at
  `ka-reader@59287c9`; a re-run leaves a decided item alone.
- **2.1 — An SVG inside the folder is not rendered in place** — answered at `ka-reader@59287c9`.
- **3.1 — `first-public-release` lands after the v1 cut, below 1.0.0** — answered at `ka-reader@59287c9`.
- **5.1 — `sdd_template.md` § 3 gained a units table** — answered at `ka-reader@59287c9`.
- **5.2 — The re-author broke 38 citations in the decision log and the NFDR** — answered at
  `ka-reader@caa3e0c`.
- **§ 4 Disagreements** — reads "None yet."; no item to work.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-sdd/launcher.sh ka-reader`
