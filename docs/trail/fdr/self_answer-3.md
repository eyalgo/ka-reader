# Self-answer report — fdr.md

## Header

- **Companion:** /Users/eyalgolan/products/ka-reader/docs/fdr_open_issues.md
- **Document:** `docs/fdr.md` — the FDR, Draft at v4
- **Decided by:** `decide_companion_answers.md` v1.1.0
- **Date:** 2026-09-04

Read whole before any item was decided: the companion; `docs/fdr.md` (v4, 418 lines); the FDR's
own trail (`docs/trail/fdr/cycle-1.md` § 2.4, § 2.7, § 2.8, § 2.9; `cycle-2.md`;
`self_answer-2.md`); the run that opened this file (`docs/trail/architecture/self_answer-6.md`)
and the owner's rule it applied (`docs/trail/architecture/cycle-3.md` § 3.1, answer (2)); and, as
the items name them, `docs/SDD.md` v3 § 3 (`fs-reader`, `folder-model`, `surfaces`), § 4 (C-R3,
C-R5, C-I5, C-I6, C-D3, C-D4, C-E1 – C-E10), § 6 S-11, § 9 TO-4, § 11 R-3, RN-1, RN-7, RN-8,
RN-19, RN-35; the deleted SDD at `git show 70a879a:docs/SDD.md` (§ 3's extension and image sets,
§ 4 C-E1 – C-E10, RN-34); `docs/trail/sdd/cycle-1.md` § 2.1 and `cycle-2.md` § 2.2;
`docs/SRS.md` FR-10, FR-29, RN-37; `docs/architecture_open_issues.md` § 1.1;
`<CORE>/prompts/principal_pm_create_fdr.md` § Inputs you work from, § The finish walk, § On a
re-run. Every measurement the items state was re-run rather than taken on trust; the results are
under each item.

## Items worked

### 2.1 — Twelve trace tags cite the deleted SDD's review notes RN-16, RN-19, RN-20 and RN-26, which the re-authored SDD does not carry — repair them under the rule the owner set for a document revised in place

- **Bucket:** 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override
- **Verdict:** confirmed
- **Why:** **Confirmed as drafted.** Check 1: the edit lands in this document, binds no person and
  no outside party, and the rule it applies is the owner's own — cycle-3 § 3.1's answer (2) says a
  document revised in place carries pointers to where a fact lives now, and (1) reserves the pin
  for the append-only log; nothing here is a call the owner kept. Check 2: the draft holds for the
  reason it gives, and the reason was tested rather than read. Each re-pointed target was opened
  in `docs/SDD.md` v3: § 4 C-E9 carries *"the initial theme follows the platform's appearance,
  light where no signal can be read"* (R-106); RN-35 carries the default tip set and the window
  (R-117, R-171, R-174); § 3 `surfaces` reads *"the history beneath its changes list"* verbatim
  (R-73); § 3 `folder-model` reads *replace-whole* and § 4 C-E6 the plain folder's working state
  (R-124); § 4 C-R3 carries the path that does not exist or cannot be read (R-126). The pins were
  checked the other way — the deleted RN-20 and RN-26 have no successor note, so R-70, R-181 and
  the four review notes had nothing live to point at. `git cat-file -e
  70a879a:docs/trail/sdd/cycle-1.md` → exists; `grep -c 'SDD § SDD Review Notes
  RN-\(16\|19\|20\|26\)' docs/fdr.md` with the `ka-reader@70a879a:` prefix excluded → 0 (2026-09-04).
  Check 3: nothing settled moves — RN-28 records every site, and the NFDR's v5 applied the same two
  forms to its own tags (`docs/nfdr.md` RN-16), so the two downstream documents now agree on the
  form. Check 4 — *absent*: a clone lacking `70a879a` loses the pins, a cost the owner accepted at
  cycle 3 for the log's 37 and the same cost here; *stale*: a live pointer goes stale if the SDD is
  re-lettered again, which is the price of the owner's rule and the reason the rule exists — a
  pointer that resolves is a live claim of agreement. The *If overridden* paths were weighed: pin
  all twelve freezes that signal; leave them keeps eight rules pointing at notes on other subjects.
  What would have tipped it: the owner's (2) reading "pin" for every document — their words say
  the opposite.

### 2.2 — The re-author moved further citations outside § 2.1's count — the experience conditions re-lettered, sections moved, the deleted trail — and they take the same two forms

- **Bucket:** 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override
- **Verdict:** confirmed
- **Why:** **Confirmed as drafted; the same rule, the same test, more sites.** Check 2 was the
  whole of the work: the re-lettering map was checked condition by condition against
  `docs/SDD.md` v3 § 4 and `git show 70a879a:docs/SDD.md` § 4. Deleted → re-authored: C-E1
  indicator-before-observed → C-E1 *nothing drawn before observed*; C-E2 failure-in-its-slot →
  C-E3 *a failure scoped to its item*; C-E8 one-sentence-messages / C-E2's message clause → C-E4
  *what the tool did, observed, what next*; C-E3 no-editing-affordance → C-E5 *read-only is the
  identity*; C-E4 the reader's place → C-E2; C-E5 assets ship with the tool → C-E7 *renders whole,
  offline*; C-E6 hue → C-E8; C-E7 the accessibility posture → C-E8 (which now carries *"UX-A1's
  stated posture — mouse-driven, no keyboard model"*) and, for the README's posture sentence, C-E10
  (*"the posture UX-A1 states appears in the README, not on its first screen"*); C-E9 one shell →
  no successor, pinned; C-E10 public picture → C-E10. Every arrow in the item lands on the
  condition that carries the subject. The other moves: § 9 TO-4 reads *"undoing it costs every
  surface rewritten (§ 2, 'Undoing it')"* (PD-29); § 4 C-I5 is the extension set (R-43, R-44,
  PD-10); C-R3 carries the panel dismissed and C-D4 read-whole-or-discard-whole (R-146, R-168,
  R-170). The four counts reproduce: `git diff -U0 3325469 HEAD -- docs/fdr.md | grep -c '^-- \*\*'`
  → 73; `grep -o 'ka-reader@70a879a' docs/fdr.md | wc -l` → 32; `grep -o 'SDD § ' docs/fdr.md | wc
  -l` → 135; unpinned dead notes → 0. No unpinned `docs/trail/sdd/cycle-1.md` citation survives.
  Checks 1, 3 and 4 as § 2.1 — the same seat, the same settled record, the same two failure paths.
  Not confirmed with addition, because nothing pinned was found that could have been re-pointed
  and nothing re-pointed was found landing on another subject; the item's list was complete as
  measured.

### 2.3 — R-44 drops `.jsonc`: the re-authored SDD's extension set names `.json` alone for JSON

- **Bucket:** 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override
- **Verdict:** confirmed
- **Why:** **Confirmed: R-44 follows its source, and a `.jsonc` file is plain text under R-45.**
  Check 1: the value is the SDD's by delegation — `docs/SRS.md` FR-29, *"with the full extension
  set fixed in the SDD"* — and R-44 is a verbatim copy (RN-2), so the edit here is a copy
  following its original; it commits nothing to anyone. Check 2: the draft holds, and one fact it
  did not state was found and weighed. `docs/SDD.md` RN-1 says the re-author did not read the
  deleted SDD beyond § 4 C-R3, so the drop is not a considered reversal of the deleted § 3 set
  (`git show 70a879a:docs/SDD.md`: *JSON `.json` `.jsonc`*) but an independent derivation under
  RN-7's rule — *"an extension on the list must have a floor language behind it"*, the set
  *"deliberately modest"*. That was weighed for raising on the SDD and refused: RN-7 states the
  CTO's own rule for the set, FR-29's *"every extension in common use"* is that seat's judgment by
  delegation, and nothing the SRS binds is contradicted — so the ground would be *I would have
  decided differently*, which the prompt names as not worth a cycle. The doubt is recorded here,
  and the SDD's companion is open this round on other grounds (§ 2.7), so the CTO's next run is a
  place the question can be put if the owner wants it put. Check 3: the example row for R-43 –
  R-45 has no `.jsonc` case and nothing else cites the extension. Check 4 — *refused*: a `.jsonc`
  file is never refused, only unhighlighted, which is the cheaper of the two failures FR-29 names;
  *stale*: if the CTO restores it, R-44 follows by the same verbatim rule at this document's next
  run. What would have tipped it to raising: an SRS sentence naming `.jsonc`, or an AC exercising
  it — there is neither.

### 2.4 — An in-folder image renders in place when it is PNG, JPEG, GIF or WebP, and an in-folder SVG takes a placeholder naming its format as one the product does not render

- **Bucket:** 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** **The conclusion is right and the argument is short one fact, which the fold should
  carry into RN-28 (2).** The item and RN-28 present the format set as new with the re-author —
  *"an upstream change"*, R-58 and R-160 *"now false against the SDD"*. Measured: the deleted SDD
  already fixed it. `git show 70a879a:docs/SDD.md` § 3, *The image set*: *"PNG, JPEG, GIF, WebP.
  SVG is outside the set in v1"*, with an in-folder `.svg` taking *"the not-an-image placeholder"*,
  and its `fs-reader` row deciding *failed(not an image)* on the bytes' signature — its RN-34,
  written when the UXD's third case arrived. So R-58's *every in-folder image* and R-160's *not an
  image the platform renders* were already out of step with the SDD this document read at v2 and
  v3; the hole was opened by this document's own cycle-1 § 2.8 answer, which named *the platform*
  where the source said *the product*. That is a defect in the item's supporting text and in
  RN-28's, reported here and not corrected, since the words are the producing skill's. It does not
  change the verdict: the delta is legitimate on both grounds the re-run rule admits — the
  re-authored SDD is a new document that states the set as a § 4 condition (C-D3), where the
  deleted one held it in a § 3 paragraph, and the exclusion was confirmed at
  `docs/trail/sdd/cycle-1.md` § 2.1 with the reopening condition RN-8 states. Check 1: the visible
  consequence — a README's SVG diagram shows a placeholder — was put to the owner on the SDD's
  round and confirmed there; this document restates it and prices nothing new. Check 3: PD-12's
  *adding a format is never a breaking change* agrees with SDD RN-8's *a minor version*; R-160's
  sentence is the observed-condition placeholder, never R-57's not-fetched one; the Markdown
  example row gains `img/d.svg`. Check 4 — *empty*: a zero-byte `.png` has no signature and is
  R-160's *unreadable or outside the four*, stated as what was observed; *stale*: an SVG admitted
  later reaches R-58 by the SDD's revision (RN-8), never from here; *concurrent*: a file that
  vanishes between render and request is the SDD's could-not-be-loaded swap, inside R-160's
  *missing*. The *If overridden* path — formats the SDD's alone — was refused for the item's own
  reason: a reader of this document alone would believe an in-folder SVG renders.

### 2.5 — R-120 no longer says the history's window is undecided — the re-authored SDD fixes it at 1,000 commits as a design bound — and this document does not carry the number

- **Bucket:** 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override
- **Verdict:** confirmed
- **Why:** **Confirmed: the window is the SDD's design bound, and the number stays there.** Check
  2: the draft holds for the reason it gives, and the reason is the document's own practice, not
  a new reading. `docs/SDD.md` RN-35 says of the value that it *"is an invented value with no
  measurement behind it: it is a design bound, not a performance bar, and is revisited when
  `checks/latency.sh` prints figures"* — the shape RN-27 kept out of R-93 for the log's bound, and
  PD-30 keeps out of every bar. A number carried here would make each revisit a behaviour change
  to escalate (`<CORE>/prompts/principal_pm_create_fdr.md` § The altitude test), and nothing a
  person relies on rides on it. Check 3: what a person *can* rely on is stated whatever the number
  — R-174 every chosen tip inside the window, R-175 the end stated where older commits exist, R-176
  no control loads more, R-177 a rail without its join; R-117 and R-171 name *the loaded window*
  as a thing without a size, which is consistent. RN-11 already lists R-120 among the rules that
  name their decider. Check 4 — *empty*: a history shorter than the window states nothing (R-175);
  *stale*: a revisit that moves the number changes no rule and no example — the 20 000-commit row
  names no size; *concurrent*: a branch set whose tips outrun each other is R-174's, the window
  holding the most recent commits of the *set*. The *If overridden* path — carry *1,000* with RN-35
  as its source — was refused because it buys a reader nothing R-175 does not already show them,
  and costs a revision here at every measurement.

### 2.6 — PD-40 states the 1.0.0 contract's priced members — the install path, the macOS floor, every surface present, and own-state readability by PD-39 — and what no version changes

- **Bucket:** 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** **Confirmed, with one clause added: *adding a prerequisite* takes a major version.**
  Check 1 first, because the 1.0.0 contract is a class the owner reserved — *"park an item for the
  owner when the answer changes what the product promises"* (the routing rule
  `docs/trail/architecture/self_answer-6.md` § 1.1 cites). PD-40 changes nothing the product
  promises: three of its members restate S-11's *Delivers*, which the owner confirmed in person
  (`docs/trail/sdd/cycle-2.md` § 2.2), and the fourth is PD-39 as it stands, confirmed at
  `docs/trail/fdr/cycle-1.md` § 2.9 and contested at `docs/architecture_open_issues.md` § 1.1 —
  which PD-40 names as open and defers to. A product decision that consolidates two confirmed
  statements at this document's altitude, so a change removing a surface meets a decision here,
  is this seat's to confirm. Check 2: the draft holds, and is incomplete by one clause. S-11 prices
  four moves by name — *"removing a surface, raising the floor, adding a prerequisite or changing
  the install path costs a major version"* — and PD-40 lists three. A prerequisite added does
  break R-131 inside the priced range R-128 – R-131, so the omission is not a hole in the contract;
  it is a hole for the Product Owner, who checks a change against the named list and not the
  range, and the clause costs four words. That is the addition. Check 3: PD-40 traces to § 4 C-I6
  and RN-19, not to § 6, which this document may not cite; C-I6's check reads *"the priced set —
  C-R4, C-R5, and the surfaces' presence through SM-4"*, the same three. The exclusions match
  S-11's four. Own state *read whole or discarded whole* sits under *what no version changes* in
  both. Check 4 — *stale*: if § 1.1 is answered against PD-39, PD-39 and PD-40's fourth member
  move together by that answer, which the item already states; *refused / downgrade*: an older
  version meeting newer state is R-168's symmetry and not a priced member, forward only — PD-39's
  reading, unchanged here. What would have tipped it to *left for the owner*: PD-40 adding a
  member neither confirmed statement carries. It adds none.

### 2.7 — Two owner-confirmed rules the re-authored SDD contradicts stand — R-46's UTF-16 clause and R-21's failure state — and the SDD is owed two sentences through its own run

- **Bucket:** 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override
- **Verdict:** raised upstream
- **Why:** **The FDR half is confirmed as drafted — nothing moves — and the change the item calls
  for lands on the SDD, so it was written there.** Check 1: the item's edit is not in this
  document at all. Both rules are owner answers (`docs/trail/fdr/cycle-1.md` § 2.4 added the UTF-16
  clause; § 2.7 overrode R-3's wording), and *"a value the owner set there is settled, and
  contradicting it needs a fresh authorization, not a redraft"*
  (`<CORE>/prompts/principal_pm_create_fdr.md` § Inputs you work from). The SDD does not read the
  FDR, so its UTF-8-only sentence (`docs/SDD.md:250`) and its unrevised R-3 (`docs/SDD.md:1838`)
  are gaps in it, not rulings against the owner — RN-1 says the re-author read the deleted SDD only
  at C-R3, and the deleted SDD had no text rule at all (RN-3), so neither sentence was ever put
  beside the owner's answer. Not left for the owner: the owner has already decided both values;
  what is left is the CTO's fold, and asking the owner again would hand back a question they
  answered. Not split: the item is one question with one answer, whose consequence lands in another
  document. Check 2: the draft holds — RN-7 had recorded the owner's own call that R-3's wording be
  met at the SDD's next revision, and the re-author did not meet it. Check 3: nothing here moves;
  RN-29 records both. Check 4 — *stale*: until the SDD folds, a builder reading the SDD alone builds
  UTF-8-only and a Git view naming a folder to choose, two builds that disagree with the contract
  the QA seat reads — the cost the SDD item names; *refused*: if the CTO refuses the UTF-16 clause
  on mechanism, that is a fresh finding for the owner through the SDD's companion, and R-46 stands
  until then. **Where it landed:** `docs/SDD_open_issues.md` § 5.1, opened from
  `<CORE>/templates/product-templates/sdd_open_issues_template.md`, committed at `bc34996` and
  checked with `git show --stat` before this item's slot was written. **One departure, said in
  terms:** the skill's rule places a raised item in *choices to confirm*, and this one sits in the
  SDD companion's **§ 5** instead, because that template's own header fixes §§ 1–3's raiser to the
  three authoring seats — *"which stay fixed to the three authoring seats on purpose"* — and gives
  § 5 to *"a seat that never wrote the SDD … the Principal PM"*, with an `Answer` slot in place of
  confirm-or-override. The template in front of the run decides its sections; the answer this run
  would give is offered inside the item and the slot is left at its placeholder.

## Left for the owner

None this run. Every item was answerable in the owner's seat: five apply a rule the owner set or a
value the owner confirmed, one follows a delegated source, and one carries an owner answer to the
document that has not seen it.

## Skipped

None this run. Section 1 and section 3 hold no item this cycle, and no item in section 2 carries a
slot addressed to another actor. One supporting-text defect is reported under § 2.4 rather than
skipped: the item and `docs/fdr.md` RN-28 (2) present the image-format set as new with the
re-author, and the deleted SDD's § 3 carried it (RN-34); the item was answered as the document
needs it, and the words are the producing skill's to correct on the fold.

## Companions opened

- **/Users/eyalgolan/products/ka-reader/docs/SDD_open_issues.md** — **opened** — companion to `SDD.md`, landed in commit `bc34996`. Routed by § 2.7. One item, § 5.1, in the section the template's own header gives to a seat that did not write the SDD: § 3 `fs-reader`'s text rule gains the UTF-16 byte-order-mark clause the owner added at `docs/trail/fdr/cycle-1.md` § 2.4, and § 11 R-3's response takes the wording the owner set at § 2.7 — a failed Git item naming where the Git directory lies, stating that Git state is not read and the tree and reading work, offering no folder to choose. Provenance blockquote under the header; the `Answer` slot at its placeholder with the run's own reading offered in the item.

## Launchers owed

- **`fdr.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-fdr/launcher.sh ka-reader`
- **`SDD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-sdd/launcher.sh ka-reader`
