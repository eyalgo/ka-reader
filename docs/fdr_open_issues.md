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

> **This round.** The file was opened on 2026-09-04 by a `companion-self-answer` run
> (`docs/trail/architecture/self_answer-6.md`) with one item, § 2.1, after the SDD this FDR derives
> from was deleted (`nozoki@9c91359`) and re-authored (Settled at v3, `nozoki@827aa1c`). The
> `product-fdr` run of 2026-09-04 re-derived `docs/fdr.md` against the re-authored SDD, took it from v3
> to v4, applied § 2.1's drafted form, and found the re-author had moved more than the twelve citations
> § 2.1 counted and had changed four things a rule carries. Every delta is applied to the FDR and
> listed below as a choice to confirm — `docs/fdr.md` RN-28 is the record, RN-29 the two findings.
> Nothing here is a question the authoring round could not answer from its inputs; each item is a
> best-effort call under an upstream change, awaiting the owner's word.

---

## 1. Open issues — behavioural questions with no answer yet

<None this round — every item the re-authored SDD raised is a choice the run could draft; see § 2.>

## 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override

### 2.1 Twelve trace tags cite the deleted SDD's review notes RN-16, RN-19, RN-20 and RN-26, which the re-authored SDD does not carry — repair them under the rule the owner set for a document revised in place
- **Drafted into the FDR:** applied at v4, in the form this item drafted when it was opened — the
  owner's own from `docs/trail/architecture/cycle-3.md` § 3.1, answer (2): a document that is updated
  in place carries trace tags that name *where a fact lives now*. **Re-pointed**, where the
  re-authored SDD carries the subject: R-106 → `§ 4 C-E9` (the initial theme); R-117, R-171 and
  R-174 → `§ SDD Review Notes RN-35` (the default branch set and the window); R-73 → § 3 `surfaces`
  (the history beneath the changes list); R-124 → § 3 `folder-model` replace-whole and
  `§ 4 C-E6`; R-126 → `§ 4 C-R3`. **Pinned** to `nozoki@70a879a:docs/SDD.md § SDD Review Notes RN-n`,
  where it does not: R-70 (RN-20 — beside `docs/SRS.md` § SRS Review Notes RN-37, which now carries
  the owner's words), R-124, R-126 and R-181 (RN-26, for the clauses no live section carries), and
  this document's own RN-1, RN-9, RN-21 and RN-25, each of which records what the SDD said when a
  rule was derived. Where a rule takes both forms the live section leads and the pin follows.
  `docs/fdr.md` RN-28 lists every site.
- **Rationale:** measured 2026-09-04 against `docs/fdr.md` v3 and both SDDs:
  `grep -c 'SDD § SDD Review Notes RN-\(16\|19\|20\|26\)' docs/fdr.md` → **12**. What each number
  meant in the SDD the FDR read (`git show 70a879a:docs/SDD.md`) and what it means in `docs/SDD.md`
  v3: **RN-16** — the history's default branch set (CTO) → `promise-one-point-zero`'s placement as a
  slice (CPO); **RN-19** — `read-a-folder`'s rail carrying the *Files* entry alone (CDO) → the content
  of the 1.0.0 contract (CPO); **RN-20** — two UXD gaps, the owner's answers folded (CDO) → **no
  note**; **RN-26** — the CDO lane following UXD v6 → **no note**. Two of the four numbers resolved
  to notes on other subjects — a pointer that lands somewhere plausible and says something else, with
  no signal to the reader — which the owner judged the worse of the two failures
  (`docs/trail/architecture/cycle-3.md` § 3.1). The repair form follows the document's revision rule
  and not the log's: the FDR revises in place, so a live pointer is right where a successor exists,
  and the log's pin is right only where none does. After the repair, `grep -c` on the same pattern,
  excluding the `nozoki@70a879a:` prefix, → **0**.
- **If overridden:** *pin all twelve* to `nozoki@70a879a:` — one rule, twelve edits, at the cost of a
  document that revises in place carrying pointers to a document no working tree holds, which is the
  form the owner rejected for the NFDR's one citation; or *leave them*, which restores eight rules and
  four review notes pointing at notes on other subjects or at nothing, in a document the Product
  Owner and the QA seat read cold. Either way no rule, product decision or exclusion changes its
  meaning.
- **Confirm or override:** confirm — the re-pointed / pinned split stands as drafted, under the owner's rule for a document revised in place (`docs/trail/architecture/cycle-3.md` § 3.1, answer (2)). Every re-pointed target was opened this run and carries its subject: `docs/SDD.md` § 4 C-E9 states the initial theme, light where no signal can be read (R-106); RN-35 states the default tip set and the window (R-117, R-171, R-174); § 3 `surfaces` reads *"the history beneath its changes list"* (R-73); § 3 `folder-model` reads *replace-whole* and § 4 C-E6 the plain folder's state (R-124); § 4 C-R3 carries the path that cannot be read (R-126). The pinned trail resolves (`git cat-file -e 70a879a:docs/trail/sdd/cycle-1.md`), and `grep -c 'SDD § SDD Review Notes RN-\(16\|19\|20\|26\)'` on `docs/fdr.md`, the `nozoki@70a879a:` prefix excluded, prints 0 (2026-09-04). Not taken: pinning all twelve — a pointer that resolves live is the one signal a later reader has that this document and the SDD still agree, and freezing it hides that. Decided in the owner's seat by a `companion-self-answer` run, 2026-09-04. Reasoning: `docs/trail/fdr/self_answer-3.md` § 2.1.

### 2.2 The re-author moved further citations outside § 2.1's count — the experience conditions re-lettered, sections moved, the deleted trail — and they take the same two forms
- **Drafted into the FDR:** the rule of § 2.1 applied to every other `docs/SDD.md` citation the
  FDR carries, each opened against the re-authored SDD on 2026-09-04. **Re-pointed:** the experience
  conditions were re-lettered by the re-author — the failure conditions `C-E2` → `C-E3` (R-20, R-33,
  R-51, R-86, R-87, R-91, R-92, R-152, OOS-22, PD-38) and, for the two message rules, `C-E2` → `C-E4`
  (R-88, R-89); `C-E3` → `C-E5` (R-49); `C-E4` → `C-E2` (R-78, R-82, R-83); `C-E5` → `C-E7` (R-103,
  R-140, PD-28); `C-E6` → `C-E8` (R-37, R-38, R-39, R-67, R-104, R-114, PD-25); `C-E7` → `C-E8`
  (PD-24) and `C-E10` (R-139); the extension set from `§ 3` to `§ 4 C-I5` (R-43, R-44, PD-10, RN-2);
  the renderer's cost from `§ 9 TO-1` to `§ 9 TO-4` and § 2 *Undoing it* (PD-29); the unexplained-fault
  class from RN-4 and RN-14 to `§ 4 C-E3, C-I1` (PD-38); the loaded window from `§ Open Questions` to
  `§ SDD Review Notes RN-35` (R-120, R-176, RN-11, RN-17, RN-21); and two quoted GitState phrases
  follow the re-authored wording (R-66, R-161). **Pinned** to `nozoki@70a879a:docs/SDD.md`, beside the
  live section that carries the rest of the claim: `§ 4 C-E9` — one shell, two chrome controls and no
  third, one path line over every treatment, no settings or onboarding surface — which the
  re-authored SDD states nowhere as one condition (R-27, R-41, R-63, R-113, R-121, PD-31, OOS-23);
  `§ 4 C-E6`'s tooltip clause (R-38); `§ 3` entity Diff's three kinds (R-112); RN-4, RN-11 and RN-14
  (PD-38, RN-10); and the two citations of `docs/trail/sdd/cycle-1.md` § 1.2 and § 2.4 (RN-1, RN-10)
  — the file at that path today is the re-authored SDD's own cycle 1, whose § 1.2 does not exist and
  whose § 2.4 is another subject. Three tags gain a live source the re-authored SDD now states
  upstream of an owner answer: R-146 (C-R3 carries the dismissed panel), R-168 and R-170 (C-D4
  carries read-whole-or-discard-whole).
- **Rationale:** the same defect as § 2.1 in more places — the self-answer that opened this file
  counted only the four review-note numbers and said in terms that the wider re-derivation was this
  run's to judge (`docs/trail/architecture/self_answer-6.md` § Companions opened). Every one of
  these landed on another subject or on nothing: `C-E2` in the re-authored SDD is the reader's place
  surviving a refresh, not the failure slot; `C-E6` is the plain folder as a working state, not hue;
  `C-E9` is the two themes, not the shell; `TO-1` is the two-process seam, not the WebView. The
  authoring prompt's provenance gate makes a tag naming a section that does not carry the claim a
  fabricated assurance, and its re-run rule makes an upstream change both a legitimate delta and a
  finding (`<CORE>/prompts/principal_pm_create_fdr.md` § The finish walk, § On a re-run). The NFDR's
  v5 revision applied the same two forms to its own tags (`docs/nfdr.md` RN-16). Measured after the
  repair, 2026-09-04: 73 entries of `docs/fdr.md` changed between v3 and v4
  (`git diff -U0 3325469 HEAD -- docs/fdr.md | grep -c '^-- \*\*'`), 32 citations carry the pin
  (`grep -o 'nozoki@70a879a' docs/fdr.md | wc -l`), and the document cites the SDD 135 times in the
  `SDD § ` form (`grep -o 'SDD § ' docs/fdr.md | wc -l`).
- **If overridden:** *pin every SDD citation* rather than re-point — one rule, all 135 `SDD § `
  citations edited, at the cost of a document that revises in place pointing at a document no
  working tree holds; or *leave them*, which keeps the tags RN-28 lists landing on other subjects. No rule, product decision or
  exclusion changes its meaning under either.
- **Confirm or override:** confirm — the same rule over the wider set, with the re-lettering map checked condition by condition against `docs/SDD.md` v3 § 4 and the deleted SDD's § 4 (`git show 70a879a:docs/SDD.md`, C-E1 – C-E10 in each): every arrow lands on the condition that carries the subject — C-E3 a failure scoped to its item with its route out, C-E4 the three-part message, C-E5 no editing affordance, C-E2 the reader's place, C-E7 rendering whole offline, C-E8 hue and the accessibility posture, C-E10 the README's posture sentence — and the pins are exactly the claims no live condition states: one shell with two chrome controls and no third, the tooltip clause, Diff's three kinds, the deleted trail's § 1.2 and § 2.4. The four measurements reproduce (73 entries changed, 32 pins, 135 `SDD § ` citations, 0 unpinned notes), and the three tags given a live source were opened: § 4 C-R3 carries the panel dismissed and § 4 C-D4 read-whole-or-discard-whole. Not taken: pinning all 135, for the reason § 2.1 gives. Decided in the owner's seat by a `companion-self-answer` run, 2026-09-04. Reasoning: `docs/trail/fdr/self_answer-3.md` § 2.2.

### 2.3 R-44 drops `.jsonc`: the re-authored SDD's extension set names `.json` alone for JSON
- **Drafted into the FDR:** R-44 reads *JSON `.json`*, so a `.jsonc` file is plain text under R-45
  — never refused, never highlighted as JSON. No other extension moved; the Examples row for R-43 –
  R-45 has no `.jsonc` case and does not change.
- **Rationale:** an upstream change, folded on the stability rule's permitted branch. The set is the
  SDD's by delegation — `docs/SRS.md` § 3.3 FR-29: *"the full extension set fixed in the SDD"* — and
  the deleted SDD's § 3 set carried `.jsonc` (`git show 70a879a:docs/SDD.md`, line 251) where the
  re-authored `docs/SDD.md` § 4 C-I5 reads *JSON — `.json`*. R-44 carries the set verbatim so that
  the one product-visible fact of R-42 lives at this altitude (RN-2), and a verbatim copy follows
  its source. The re-author gives no reason for the drop (its RN-7 says the set is *"deliberately
  modest"*), and this document does not supply one.
- **If overridden:** keeping `.jsonc` makes R-44 depart from its source — a *changed* relation, a
  review note, and a sentence the CTO's SDD run is owed, since FR-29 puts the set there and not here.
  A `.jsonc` file would then highlight as JSON in a build that follows this document and as plain
  text in one that follows the SDD, which is the disagreement the delegation exists to prevent.
- **Confirm or override:** confirm — R-44 reads `.json` alone and a `.jsonc` file is plain text under R-45. The set is the SDD's by FR-29's delegation and R-44 is a verbatim copy of it (RN-2); this document does not carry a value its source dropped. One fact stated for the record rather than acted on: the re-author did not read the deleted SDD's set (`docs/SDD.md` § SDD Review Notes RN-1), so the drop is an independent derivation under RN-7's rule — *an extension on the list must have a floor language behind it* — and not a considered reversal. Weighed for raising on the SDD and not raised: RN-7 states the CTO's own rule for the set, FR-29's *"every extension in common use"* is that seat's judgment by delegation, and nothing the SRS binds is contradicted; whether `.jsonc` returns is the CTO's on their own run. Decided in the owner's seat by a `companion-self-answer` run, 2026-09-04. Reasoning: `docs/trail/fdr/self_answer-3.md` § 2.3.

### 2.4 An in-folder image renders in place when it is PNG, JPEG, GIF or WebP, and an in-folder SVG takes a placeholder naming its format as one the product does not render
- **Drafted into the FDR:** R-58 names the four formats; R-160 gains the SVG case — a placeholder
  stating that the format is one the product does not render, never a broken-image glyph and never
  the not-fetched sentence; PD-12 states that an SVG inside the folder is not rendered in v1, that
  evidence reopens the cut, and that adding a format is never a breaking change; the Markdown
  example row gains `img/d.svg`.
- **Rationale:** an upstream change. The re-authored `docs/SDD.md` § 4 C-D3 reads *"In-folder images
  are served for PNG, JPEG, GIF and WebP; SVG is excluded from the scheme in v1 because it is a
  document, not a bitmap"*, its RN-8 states the reopening condition and that adding SVG later costs
  a minor version, and the owner confirmed the placeholder at `docs/trail/sdd/cycle-1.md` § 2.1 —
  the re-authored SDD's own trail. R-58 at v3 promised every in-folder image in place and R-160's
  *not an image the platform renders* would be false of an SVG, which the platform renders and the
  product does not; both are now false against the SDD, so both move. The format set is carried
  for the reason R-44 carries the extension set: which images render is the one product-visible
  fact, and a contract that pointed at the SDD for it would leave R-58 unreadable alone.
- **If overridden:** if the formats stay the SDD's alone, R-58 and PD-12 return to *an image inside
  the folder* and R-160 to *not an image the platform renders* — and a reader of this document alone
  believes an in-folder SVG renders, which the build will not do. If SVG is wanted in place, that is
  the SDD's reopening condition and reaches this document by that document's revision (SDD RN-8),
  never from here.
- **Confirm or override:** confirm, with one correction to the ground that the fold should carry into RN-28 (2): the format set is not new with the re-author. The deleted SDD already fixed it — `nozoki@70a879a:docs/SDD.md` § 3 *The image set*: PNG, JPEG, GIF, WebP, *"SVG is outside the set in v1"*, an in-folder `.svg` taking *"the not-an-image placeholder"* (its RN-34) — so R-58's *every in-folder image* and R-160's *not an image the platform renders* were already out of step with the SDD this document read at v2 and v3, a hole this document's own cycle-1 § 2.8 answer opened. The delta is legitimate on both grounds the re-run rule admits — the re-authored SDD is a new document stating the set as a § 4 condition (C-D3), and the exclusion was confirmed at `docs/trail/sdd/cycle-1.md` § 2.1 — and R-58, R-160, PD-12 and the Markdown example row stand as v4 wrote them. Decided in the owner's seat by a `companion-self-answer` run, 2026-09-04. Reasoning: `docs/trail/fdr/self_answer-3.md` § 2.4.

### 2.5 R-120 no longer says the history's window is undecided — the re-authored SDD fixes it at 1,000 commits as a design bound — and this document does not carry the number
- **Drafted into the FDR:** R-120 reads *The window's size is not this contract's: the SDD carries
  it as a design bound and revisits it from measurement alongside R-84's reference sizes, and a
  change to it is behaviour-preserving against this document*, tracing to
  `docs/SDD.md` § SDD Review Notes RN-35. R-174 – R-177 — what the reader sees at the window's end
  — stand as the owner answered them; RN-11 and RN-17 record the move.
- **Rationale:** v3's R-120 said *"The window's size is undecided; the CTO fixes it in the SDD from
  measurement"* on the deleted SDD's open question. The re-authored SDD's RN-35 fixes it — *"the
  port's window is 1,000 commits from the requested tips"* — and says of the number that it *"is an
  invented value with no measurement behind it: it is a design bound, not a performance bar, and is
  revisited when `checks/latency.sh` prints figures"*. So *undecided* is false and R-120 moves. The
  number is not carried, on the altitude test this document already applied to the log's bound
  (RN-27): a value the SDD states it will revisit, pinned here, makes every revisit a behaviour change
  to escalate, and nothing a person relies on rides on it — R-175 states the window's end on the
  surface whatever the number is, so the view never lies either way.
- **If overridden:** carrying the number adds *1,000 commits* to R-120 with RN-35 as its source and
  a review note saying it is a design bound; the example row for R-174 – R-176 gains the figure; and
  the SDD's own revisit becomes a change this document has to follow by revision.
- **Confirm or override:** confirm — R-120 names the window as the SDD's design bound and does not carry the number. RN-35 says of the value that it *"is an invented value with no measurement behind it … revisited when `checks/latency.sh` prints figures"*, which is the shape RN-27 kept out of R-93 and PD-30 keeps out of every bar; a number carried here would make each revisit a behaviour change to escalate, and nothing a person relies on rides on it. What a person can rely on is stated whatever the number: every chosen tip lies inside the window (R-174), the end is stated where older commits exist (R-175), and no control loads more (R-176). Checked: a history shorter than the window states nothing (R-175), and a revisit that moves the number changes no example row — the 20 000-commit row names no size. Decided in the owner's seat by a `companion-self-answer` run, 2026-09-04. Reasoning: `docs/trail/fdr/self_answer-3.md` § 2.5.

### 2.6 PD-40 states the 1.0.0 contract's priced members — the install path, the macOS floor, every surface present, and own-state readability by PD-39 — and what no version changes
- **Drafted into the FDR:** PD-40, after PD-39: from 1.0.0 the contract R-142 names prices the one
  install path (R-128 – R-131), the macOS floor (R-133) and the presence of every surface the PRD
  names, so that changing the install path, raising the floor or removing a surface takes a major
  version; and, by PD-39, the readability of an earlier version's own state. What no version changes
  — R-95 – R-98 and own state read whole or discarded whole — is not priced, because it is never on
  offer; and nothing the contract does not name is inside it — a message's wording, a token value,
  the log's lines, what the release checks print.
- **Rationale:** derivable, and a product decision of the kind the completeness lens sends to this
  section — a compatibility promise. The re-authored `docs/SDD.md` § 4 C-I6 reads the priced set as
  *"C-R4, C-R5, and the surfaces' presence through SM-4"*, C-R5 says *"Raising it after 1.0.0 is a
  breaking change under C-6"*, and its RN-19 states the rule that sorts a member — priced when a
  change to it is on offer, unconditional when an upstream constraint forbids it at every version —
  with the four exclusions; the owner confirmed the contract at `docs/trail/sdd/cycle-2.md` § 2.2.
  None of the three documents carried this when v1 – v3 were written, and a later change that
  removes a surface under a minor version would otherwise meet no decision here. **The fourth
  member is this document's and not the SDD's:** PD-39 prices own-state readability, the SDD's
  contract lists it nowhere, and which document is owed the sentence is open at
  `docs/architecture_open_issues.md` § 1.1. PD-40 names PD-39 for it and decides nothing about that
  item — it states the contract as this document holds it, consistent with PD-39 until the owner
  rules there.
- **If overridden:** dropping PD-40 leaves the priced set in the SDD's § 6 alone, which this
  document may not cite (the slices are the route), so a change removing a surface reaches the
  Product Owner with no product decision to check it against. If the owner's answer at
  `docs/architecture_open_issues.md` § 1.1 is that own-state readability is not priced, PD-39 and
  PD-40's fourth member move together by that answer, through this document's next run.
- **Confirm or override:** confirm, with one clause added so that PD-40 names what S-11 names: *adding a prerequisite* takes a major version. The SDD's *Delivers* prices four moves by name — *"removing a surface, raising the floor, adding a prerequisite or changing the install path costs a major version"* (`docs/SDD.md` § 6 S-11, confirmed at `docs/trail/sdd/cycle-2.md` § 2.2) — and PD-40 lists three; a prerequisite added does break R-131 inside the priced range, but the Product Owner checking a change reads the named list and not the range. The fourth member stands as the item states it — by PD-39, until `docs/architecture_open_issues.md` § 1.1 is answered, where the run that opened this file left the answer it would have given (`docs/trail/architecture/self_answer-6.md` § 1.1). PD-40 adds no member to either confirmed statement and prices nothing new, which is why it is this seat's to confirm and not the owner's. Decided in the owner's seat by a `companion-self-answer` run, 2026-09-04. Reasoning: `docs/trail/fdr/self_answer-3.md` § 2.6.

### 2.7 Two owner-confirmed rules the re-authored SDD contradicts stand — R-46's UTF-16 clause and R-21's failure state — and the SDD is owed two sentences through its own run
- **Drafted into the FDR:** nothing moves. R-46 keeps *a file whose bytes begin with a UTF-16
  byte-order mark and decode as UTF-16 is text* and R-21 keeps the failure state that names where the
  Git directory lies and offers no folder to choose; RN-29 records both findings.
- **Rationale:** the re-authored `docs/SDD.md` § 3 `fs-reader` states the text rule as *"bytes
  decode as UTF-8 or the file is cannot-display-as-text"* — a sentence the deleted SDD did not have
  (RN-3) — and its § 11 R-3 still has the Git view *"naming the folder to choose instead"*, the
  wording the owner overrode at `docs/trail/fdr/cycle-1.md` § 2.7. A value the owner set is
  authorized and contradicting it needs a fresh authorization, not a redraft
  (`<CORE>/prompts/principal_pm_create_fdr.md` § Inputs you work from — the trails); the SDD does not
  read this document, so its silence on UTF-16 and its unrevised R-3 are gaps in it, not rulings
  against the owner. RN-7 recorded that the R-3 wording would be met at the SDD's next revision; the
  re-author read the deleted SDD only at its § 4 C-R3 (SDD RN-1) and did not meet it. Both are the
  CTO's to fold through the SDD's own run.
- **If overridden:** if the SDD's reading wins on the text rule, R-46 loses its UTF-16 clause, R-154
  narrows to UTF-8, and the example row's UTF-16 case moves to the cannot-be-shown column — reversing
  the owner's cycle-1 § 2.4 answer, which this document may not do on its own. If it wins on R-3,
  R-21 returns to the draft the owner overrode at cycle-1 § 2.7, and R-15's example row changes with
  it. Confirming changes nothing here and leaves the two sentences to the SDD's companion.
- **Confirm or override:** confirm — R-46 and R-21 stand, nothing moves here, and the two sentences are now carried where the seat that folds them will meet them: `docs/SDD_open_issues.md` § 5.1, opened by this run and landed in commit `bc34996`. Both rules are owner answers (`docs/trail/fdr/cycle-1.md` § 2.4, § 2.7), and the SDD does not read this document, so its UTF-8-only sentence and its unrevised R-3 are gaps in it and not rulings against the owner; RN-7 had already recorded the owner's call that R-3's wording be met at the SDD's next revision. The item lands in that companion's § 5 — the section its own header gives to a seat that did not write the SDD — with the answer this run would give offered there and its slot left for the next round. Neither *If overridden* path is taken: each would reverse a cycle-1 answer this document may not undo on its own reading. Decided in the owner's seat by a `companion-self-answer` run, 2026-09-04. Reasoning: `docs/trail/fdr/self_answer-3.md` § 2.7.

## 3. Raised from downstream — an item raised against the FDR after it settled

<None this round.>
