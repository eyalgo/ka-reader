# SDD open issues — nozoki

> Companion to `SDD.md`. Three seats — the CTO, the CPO and the CDO — authored the SDD
> non-interactively in one run; this file holds what that run could not settle from its inputs (the
> PRD, the SRS, the UXD, and any context or constraints).
>
> **Answer inline** — fill each **Answer** / **Confirm-or-override** / **Keep-or-recut** slot —
> **commit this file**, then re-run `product-sdd`. It folds your answers into the SDD and drops the
> resolved items. When nothing is left open, `product-sdd` **deletes this file**: no file = the SDD
> is done.
>
> Your answers are never thrown away. Each time the seats fold them in, they first copy this file
> whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a disagreement is not something one seat asked, it
> is something two seats answered differently, and the answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the run entirely.** §§ 1–4 are all the SDD's own three seats;
> § 5 is a seat that never wrote the SDD, reading it long after it settled and finding something
> only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's, which stay fixed
> to the three authoring seats on purpose.

---

## 1. Open issues — questions with no answer yet

### 1.1 Do the owner's answers to the previous SDD bind this run?
- **Raised by:** CPO
- **Why it matters:** The previous SDD (v4, Settled) and its whole trail were deleted on purpose
  immediately before this run, by `nozoki@9c91359` — "round 1: the SDD, its trail and its
  conversation are deleted for a fresh re-author" — whose body states the reason: "This is round 1
  of four in kensaiapp-dev's product-planning station prove-on-nozoki-over-four-rounds. The SDD is
  re-authored from the settled upstream set by chain-definition … The measurement is of kensaiapp's
  machinery; this product is the case it runs on." Nothing is lost: the parent `nozoki@70a879a`
  holds that SDD and its three answered companions (`git show 70a879a:docs/trail/sdd/cycle-1.md`,
  `cycle-2.md`, `cycle-3.md`), and `cycle-1.md` is byte-identical there to the `1e8bf3d` copy the
  UXD's RN-29 citations will be pinned to by the CDO's own repair (`git diff --quiet 1e8bf3d
  70a879a -- docs/trail/sdd/cycle-1.md`, 2026-09-03; `SDD.md` RN-32). What this run cannot settle
  from its inputs is whether those answers **bind** it. "Re-authored from the settled upstream set"
  reads as: the PRD, SRS and UXD bind, and every call the previous SDD made is argued afresh —
  which is what this run has done; this seat did not open the three companions, by its lens's rule
  that a file outside the input set is surfaced, never read quietly. Two things turn on your
  answer. The ad-hoc-signed, un-notarized release (`SDD.md` § 4 C-R4, § 9 TO-9) is carried from
  ADR-0007 § Context, which quotes the deleted trail — if nothing prior binds, that call is yours
  to re-give (RN-5), and it is the install path `first-public-release` (S-7) delivers. And any
  answer in `cycle-2.md` or `cycle-3.md` that this run did not re-derive on its own grounds would
  bind only if you say so here. Two things do not turn on it: the start mechanism (C-R3) stands on
  the sandbox argument alone (RN-3), and the in-folder image case is in the UXD's own body
  (UX-I12). If your answer is that the prior answers bind, name which — a bare "yes" would have
  three seats re-reading three files this run was told not to open.
- **Answer:** **They bind — and for most of them "binding" adds nothing, because they already
  reach this run through documents it was told to read.** Taking the three files apart so that no
  seat has to open them:
  1. **Carried by the settled upstream set, and binding through it rather than through the trail.**
     cycle-1 § 1.2 (a changed file's row opens the diff; one click target, the status letter a
     label) and § 1.3 (the history drawn in the sidebar beneath the changes list, a selected
     commit's diff taking the reading panel) are folded into `docs/UXD.md` v9 and carried by UX-F2
     and UX-S6 (its version line, RN-29). cycle-1 § 2.1 (the SDD follows the SRS on the raw-source
     switch) is carried by `docs/SRS.md` FR-31. **cycle-1 § 2.4 is the one to be careful with:**
     its text says an image inside the repository is *not* loaded, and that was overridden
     afterwards — `docs/UXD.md` UX-I12's first case now renders an in-folder image in place
     (RN-29 (6)). The UXD is the live statement; the cycle-1 text is superseded and binds nothing.
  2. **cycle-1 § 1.1 — unsigned, GitHub, one simple path — binds through the decision log, not
     through the trail, and is not yours to re-give.**
     `docs/adr/0007-ad-hoc-signed-dmg-on-a-github-release.md` is Accepted and was never deleted,
     and its § Context quotes the standing call verbatim, "Do not raise signing again" included.
     RN-5 already carries it from there rather than from the trail, so C-R4 and § 9 TO-9 stand as
     written and RN-5's contingency does not open. cycle-1 § 2.2 (Tauri 2) and § 2.3 (the
     Open-panel grant) are the same shape: ADR-0002 and ADR-0003 hold them, and RN-2 and RN-3
     re-derived them afresh in any case.
  3. **Two answers live only in the deleted trail, and they bind because this answer says so.**
     - **cycle-1 § 3.3 — the first public release waits for the full v1 cut.** The words were
       *"Re-cut — take the alternative. 'let's go with v1.' The first public release waits for the
       full v1 cut the PRD names, so the first thing a stranger meets is the product
       `docs/PRD.md` calls v1, not a partial."* This settles § 3.1 of this companion; see it.
     - **cycle-1 § 3.1 — the standing routing rule and the appetite.** *"this is a question that I
       think should not come to me"*; a cut-granularity call between two options that both pass the
       four tests is the seats'; the appetite is smaller rather than larger, but not too small;
       *"don't forget, the PPM will slice even more"*; and the rule itself — **park an item for the
       owner when the answer changes what the product promises, not when it changes how the work is
       divided.** This binds this companion's own routing, and § 2.2 is left open under it.
  4. **cycle-2 and cycle-3 bind nothing, and no seat should open them.** Their items are defects of
     the deleted SDD — an `npm ls` that should have read `pnpm ls`, 40 dead trail pointers, and a
     § 12 that cited no ADRs — and their answers were written by self-answer runs, not by you. The
     document they corrected no longer exists, and the re-authored § 12 cites the log throughout,
     which is what cycle-2 § 2.3 was about.
  Nothing above needs `cycle-1.md`, `cycle-2.md` or `cycle-3.md` opened: 1 and 2 route through
  documents already in the input set, and 3 states both answers in full. Reasoning:
  `docs/trail/sdd/self_answer-1.md` § 1.1.

## 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override

### 2.1 An SVG inside the folder is not rendered in place — it takes a stated placeholder
- **Raised by:** CDO
- **Drafted into the SDD:** `SDD.md` § 4 C-D3 serves in-folder images on the host's own scheme for
  PNG, JPEG, GIF and WebP only; an SVG inside the folder, referenced from rendered Markdown, is
  shown as a placeholder stating what was observed — the file's format, which the tool does not
  show — in the place the image would have been (§ 4 C-D3, RN-8, RN-31).
- **Rationale:** The CTO's, at RN-8: the scheme serves bytes the sanitizer never sees, and an SVG
  is a document, not a bitmap, so a document format is kept off it in v1. The UXD's
  in-folder image case — *"an image whose file is inside the folder renders in place"*
  (`docs/UXD.md` UX-I12) — names no format, so the draft decides something the UXD left open rather
  than contradicting it. It is raised because the consequence is one the owner sees: a README whose
  diagram or logo is an SVG shows a placeholder where every other image renders, and the owner set
  the in-folder case by override (`docs/UXD.md` RN-29 (6)).
- **If overridden:** `markdown-renderer` or the asset handler gains an SVG sanitizer, or SVG is
  served sanitized rather than as bytes — a CTO call on the mechanism; C-D3's format list, C-R7's
  `img-src` and RN-8 move; the slice that renders Markdown grows by that work and its bar gains an
  SVG fixture. UX-I12 does not move in either direction: it names no format now and would name none
  after. Confirming as drafted moves nothing in the SDD; the Content Editor adds the placeholder's
  sentence at their fold (RN-31).
- **Confirm or override:** **confirm** — the SVG exclusion stands, with two things added that the
  draft leaves implicit.
  (1) **State the fit with UX-I12's third case rather than assuming it.** That case is *"an image
  inside the folder whose file is missing, unreadable or **not an image**"*, and a well-formed SVG
  is none of the three in the ordinary sense: it *is* an image, and the placeholder is being
  justified by reading "not an image" as "not a bitmap the asset scheme serves". That reading is
  defensible and it is the SDD's to make — RN-31 already says the UXD left the format open — but a
  reader who follows the citation finds a case about broken files and an SVG that is not broken.
  C-D3 and RN-8 should carry the narrowing in a clause, so that the sentence the Content Editor
  adds at their fold describes a format the tool does not render rather than a file it could not
  read (RN-31; `docs/CONTENT.md` § *Message patterns* → *Partial*).
  (2) **Name the reopening condition, so this is a v1 cut and not a silent permanence.** Adding SVG
  later is additive — it removes no surface, raises no floor, adds no prerequisite and changes no
  install path — so under S-11's contract as drafted (itself still yours, § 2.2) it costs a minor
  version, not a major one. What would reopen it is evidence rather than taste: the timed release
  walk (AC-10) or an adopter report showing that an in-folder SVG is common enough in a README to
  be the first thing a stranger meets. Until then the conservative branch is right, for RN-8's own
  reason — the scheme serves bytes the sanitizer never sees, and C-D3's three walls are the
  product's whole claim. Worth noting on the cost side: the SVG most often seen in a README is a
  remote badge, and a remote reference is already the not-fetched placeholder under UX-I12's second
  case whatever this item decides.
  Neither addition moves a slice: C-D3 gains a clause, RN-8 gains the reopening condition, and
  `read-markdown`'s bar is unchanged. Reasoning: `docs/trail/sdd/self_answer-1.md` § 2.1.

### 2.2 What the 1.0.0 promise covers — the contract the version number starts
- **Raised by:** CPO
- **Drafted into the SDD:** `SDD.md` § 6 S-11 `promise-one-point-zero`, *Delivers*: from 1.0.0 the
  number covers (a) the one install path and the macOS floor; (b) the read-only and no-network
  promises; (c) own state — a later version reads what an earlier one wrote, or discards it whole
  without touching any folder; (d) every surface the PRD names, present and read-only. A breaking
  change — costing a major version — is removing a surface, raising the floor, adding a
  prerequisite, or changing the install path. Not covered: the exact wording of any message, any
  token value, the diagnostic log's lines, and anything the harness prints.
- **Rationale:** The PRD makes 1.0.0 "the moment the promise starts" and prices "a breaking change
  to what users rely on" (`docs/PRD.md` § Assumptions "Versioning"); the SRS binds "a breaking
  change to the product's public contract" (`docs/SRS.md` C-6). Neither says what an application
  with no flags, no library and no API has as its contract, and the declaration is this seat's to
  make (`SDD.md` RN-19). The four items are what an adopter demonstrably relies on between
  versions: the way in, the two promises the product is for, their own remembered state, and the
  surface they came for. The exclusions keep the promise from freezing wording and tokens, which
  the PRD leaves to documents that may move.
- **If overridden:** S-11's *Delivers* and RN-19 change; the README sentence the closing release
  carries changes with them; nothing in §§ 2–4 or in any other slice moves. Widening the contract
  to wording or tokens would make `docs/CONTENT.md` and `docs/DESIGN.md` revisions major-version
  events, which is the cost to weigh.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

<This section is the SDD's own, and has no twin in the upstream companions. The four tests in
`SDD.md` § 5 settle most cuts on their own; this section holds the ones they do not — a place where
two defensible cuts pass all four, and the choice between them is the owner's taste, appetite for
risk, or knowledge of what is coming next. A cut that fails one of the four tests is not an item
here. It is a defect, and it is fixed in the SDD rather than asked about.>

### 3.1 `first-public-release` lands after the v1 cut, below 1.0.0 — before diffs, history and switching
- **Raised by:** CPO
- **The cut as drafted:** `SDD.md` § 6 places `first-public-release` (S-7) after `open-a-folder`,
  `read-a-file`, `read-markdown`, `see-git-status`, `follow-the-folder` and `choose-a-theme` — the
  PRD's v1 cut — and before `read-a-diff`, `read-the-history` and `switch-the-folder`; it is a
  public release below 1.0.0, with the README saying so. The terminus's release is a separate
  slice, `promise-one-point-zero` (S-11), last.
- **The alternative cut:** no public release until the terminus is whole: S-7's README, channel
  and release walk fold into `promise-one-point-zero`, which becomes the first and only public
  release at 1.0.0, after `switch-the-folder`; the three beyond-v1 slices are built unpublished.
- **What changes if it moves:** § 7's rows from S-7 move to S-11; the time-to-first-success walk
  (AC-10) and the release inspection (AC-14) are first run at the end instead of after the v1 cut;
  the thesis the PRD calls unproven (`docs/PRD.md` § Assumptions "The familiarity thesis") is first
  tested on strangers after every slice is paid for rather than before; and no pre-1.0.0 version is
  ever offered, so C-6's "before 1.0.0 anything may change" is never exercised in public. What is
  provable earlier as drafted: whether a stranger reaches a viewed file in five minutes by the
  README alone, and whether the Gatekeeper step (§ 11 R-2) fits inside that clock.
- **Why it is yours to call:** both cuts pass the four tests and the CTO's step 3 finds no
  dependency either way (`SDD.md` § 5 step 3, E-7). What decides it is appetite: whether you want
  strangers on a v1 that will change, with issues and security reports arriving against the
  support posture before the surface is whole — or a quieter build to the terminus with one release
  at the end. The drafted cut is this seat's product call (RN-17); the other is defensible.
- **Keep or re-cut:** **keep** — and on firmer ground than the appetite this item offers: you have
  already decided it, and the drafted cut is your decision.
  At `docs/trail/sdd/cycle-1.md` § 3.3 (`nozoki@70a879a`) the same question was put — the first
  public release as soon as reading works, or after the full v1 cut — and the answer was *"Re-cut —
  take the alternative. 'let's go with v1.' The first public release waits for the **full v1 cut**
  the PRD names, so the first thing a stranger meets is the product `docs/PRD.md` calls v1, not a
  partial."* § 1.1 of this companion binds that answer. It settles this item twice over: it places
  the release **after** the v1 cut, which is where S-7 sits, and it places one **at** the v1 cut,
  which rules out the alternative offered here — waiting for the terminus, three slices further on.
  Two riders from that same answer, both already met and worth not rediscovering. The consequence
  accepted then was that the acquisition-path decision is proved late; the mitigation given with it
  — *"publishing late does not require verifying late"* — is exactly what § 4 C-I3 and RN-11 now
  carry, with the bundle, the entitlement list and R-8's probe green from the first slice's first
  build. The risk that made this a real question has already been retired, independently of where
  the release sits.
  **And it holds even if § 1.1 were answered the other way.** RN-17's own argument stands alone:
  the PRD names the familiarity thesis unproven and says that if it is false the product needs
  rethinking rather than tuning, so putting the v1 cut in strangers' hands before `read-a-diff`,
  `read-the-history` and `switch-the-folder` are paid for is the product reason; C-6 makes a
  pre-1.0.0 release honest about what it is; and S-7's *Delivers* already carries the caveat.
  Nothing in the SDD moves. Reasoning: `docs/trail/sdd/self_answer-1.md` § 3.1.

---

## 4. Disagreements — two seats hold different positions and neither yields

<Both positions are recorded. Neither is averaged. A middle written into the SDD is a position no
seat holds and no seat will defend when it turns out wrong. What goes into `SDD.md` is whichever
position you pick; what stays here until you pick is both.>

<None yet.>

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 `sdd_template.md` § 3 gained a units table — every distinct `Lives in` value owes a row
- **Raised by:** the skeleton launcher's own measurement, run from kensaiapp-dev — 2026-09-03
- **What moved:** § 3 carried two fixed tables, the parts and the seams. It now carries three: a
  **units** table, one row per *distinct* value in the parts table's `Lives in` column, each row
  giving that unit's **Language** (a value from the project card's `Languages:` line, or `none`) and
  its **Kind** (`crate`, `package`, `module root` or `directory` — the word that language's own
  packet at `<CORE>/doctrine/engineering/languages/<language>/layout.md` uses for a buildable unit).
  The `Lives in` prose also now states that parts sharing a value are *inside* that unit rather than
  directories beneath it.
- **Why it matters here:** `product-skeleton` reads § 3 to lay the product out before any code
  exists, and a path alone does not say what it is. Measured against this document on 2026-09-03,
  with only the four `Lives in` paths to read, the launcher made all four bare directories: the two
  crates this design names got no `Cargo.toml` and no `src/`, a third crate named by nothing here
  got a full one, the workspace excluded both real crates, and the TypeScript frame landed at the
  product root rather than in `nozoki-ui`. The card's own gate —
  `cargo test --workspace --locked && (cd nozoki-ui && pnpm exec vitest run)` — compiles nothing
  this design names and enters a directory holding one `.gitkeep`. **Nothing is wrong with this
  document.** What changed is what it is measured against.
- **What the re-cut owes, per row or per section:** one units table under the parts table, with
  exactly four rows — the four distinct values already in `Lives in`:
  `crates/nozoki-core`, `crates/nozoki-app`, `nozoki-ui`, `checks`. Each needs its Language and its
  Kind, read off the card's `Languages: Rust, TypeScript, Shell` and off each language's layout
  packet. Nothing else in § 3 is owed anything.
- **What it may leave alone:** **the parts table itself, entirely.** All nine rows, all nine slugs
  and all nine `Lives in` cells already satisfy the new shape — the two Rust units are under
  `crates/`, which `languages/rust/layout.md` § *A multi-crate product* requires and which the
  previous version of this document (v4) got wrong. The seams table, the entity table, the
  extension set and every other section of § 3 are untouched by this move, as is every section
  outside § 3. This is an addition, not a re-cut.
- **Answer:** **Add the units table exactly as this item scopes it — four rows, and nothing else in
  § 3 touched.** The rows:

  | Unit | Language | Kind |
  |---|---|---|
  | `crates/nozoki-core` | `Rust` | `crate` |
  | `crates/nozoki-app` | `Rust` | `crate` |
  | `nozoki-ui` | `TypeScript` | `package` |
  | `checks` | `Shell` | `directory` |

  Where each value comes from:
  - **The two Rust rows.** The card's `Languages: Rust, TypeScript, Shell` names Rust; `crate` is
    the Rust packet's own word, and its placement rule is already satisfied — *"Workspace members
    live under `crates/`, one directory per member"*
    (`<CORE>/doctrine/engineering/languages/rust/layout.md` § *A multi-crate product*), which is why
    this item finds the parts table owes nothing. Both rows get the Rust frame — a `Cargo.toml` and
    a `src/` — which is exactly what the measured run did not create for either of them.
  - **`nozoki-ui` — TypeScript, `package`.** The card names TypeScript; the unit is a `package`
    because what has to be created is a `package.json` and its config. **This row is the one that
    fixes the measured misplacement**, and the template says so in its own words: *"Where a
    language's frame lands is this table's to say."* The packet's tree is written for a product at
    the repository root — `index.html`, `package.json`, `vite.config.ts` at the top
    (`languages/typescript/layout.md` § *The tree*) — and here that frame lands **inside
    `nozoki-ui/`**, which is also where the card's own test command goes to find it
    (`cd nozoki-ui && pnpm exec vitest run`).
  - **`checks` — Shell, `directory`.** Shell because the card declares it, and declares it for this
    unit specifically: its own comment reads *"plus the `checks/*.sh` harness the NFDR names"*.
    Writing `none` would leave the card's third language attached to no unit at all and tell a
    reader that no packet governs those scripts, which is false — `languages/shell/conventions.md`,
    `testing.md` and `quality_gates.md` all bind them. `directory` because Shell ships **no
    `layout.md`**, so its packet has no word for a buildable unit, and `checks` builds nothing: it
    produces no artifact, and § 3 forbids it from being a dependency of any shipped unit. What it
    needs created is exactly itself, which is the template's own test for `directory`.
  **One tension named rather than papered over.** The template glosses `directory` as *"a unit with
  no language at all"*, and the `checks` row has a language. The gloss describes the common case;
  the load-bearing sentence beside it is about what gets created — *"a `crate` or `package` gets its
  language's frame, a `module root` gets nothing of its own, and a `directory` gets exactly
  itself"* — and `checks` is a `directory` on that test. No new Kind word is invented here. If that
  reading is wrong the fix is `sdd_template.md`'s, not this document's, and the row that changes is
  one cell.
  **Nothing else moves**, exactly as this item says: no part slug, no `Lives in` cell, no seams
  row, no entity, no extension-set line, and no section outside § 3. The table goes under the parts
  table and above the seams table, which is where `sdd_template.md` § 3 places it. Reasoning:
  `docs/trail/sdd/self_answer-1.md` § 5.1.

### 5.2 The re-author broke 38 citations in the decision log and the NFDR, and this document records the UXD's equivalent defect but not this one

> **No producing run wrote this item.** It was raised on 2026-09-03 by the `companion-self-answer`
> run that answered the items above, under `<CORE>/prompts/decide_companion_answers.md` § *The items
> are not the whole of what a document is owed*. What prompted it: reading the decision log as an
> input to § 1.1 — which turns on what survived the deletion of `docs/trail/sdd/` — and finding
> that RN-32 reports exactly this defect in the UXD and nothing reports the larger one in the
> records. Its slot is left at the placeholder: the reasoning is that run's, the decision is the
> next round's.

- **Raised by:** `companion-self-answer`, answering this file — 2026-09-03
- **Tracked by:** none. nozoki has no active 根回し Nemawashi seed and no open 宿場 Shukuba station
  (`system/projects/nozoki/journey/`, 2026-09-03); this was found while reading the log as an input
  to the items above, not while cutting work from this document.
- **What it blocks:** no slice is uncuttable and no § 8 field is unfillable. What is missing is a
  **Review Note**. RN-32 records that five of the UXD's RN-29 citations died with the trail and
  reports the defect rather than repairing it; the same run left the larger equivalent in
  `docs/adr/` and `docs/nfdr.md` unrecorded, so a reader takes RN-32's presence to mean the sweep
  was done and the rest of the chain is clean.
- **Where it shows:** § 12, *The downstream boundary*, which rests on the log — "the record is
  cited rather than re-surfaced" (RN-1) — without noting that the log's citations back into this
  document no longer resolve; and § SDD Review Notes, which carries RN-32 for the UXD and nothing
  for the records. Measured 2026-09-03 against `nozoki@c3eb937`: **14** citations of
  `docs/trail/sdd/cycle-1.md` across ADR-0002, ADR-0003, ADR-0006, ADR-0007 and ADR-0008, dead
  since `nozoki@9c91359`; **23** citations of this document's review notes by number across
  ADR-0001 – ADR-0008, all written against the deleted numbering, of which RN-24 and RN-25 have no
  note at all here and the eight that resolve now carry notes on other subjects (ADR-0002's RN-7,
  ADR-0004's RN-8 and ADR-0007's RN-17 checked one by one); and **1** in `docs/nfdr.md:385`,
  `SDD § 6 S-4`, which named live refresh and now names `see-git-status`.
- **If a document has to be written:** none, and **the repair is not this document's** — § 12 fixes
  that a defect found here is reported, never repaired from here. It is already routed:
  `docs/architecture_open_issues.md` § 3.1 carries it to the Principal Architect, opened at
  `nozoki@20b9a94`. What this document owes is one Review Note in RN-32's own shape, recording what
  was found, that it was reported rather than repaired, and where it went.
- **Answer:** **Write the Review Note, as this item scopes it — and two things it does not
  scope.** The note is the **CTO's**, `*(added)*`, because the boundary it corrects is the CTO's by
  the standing split (`SDD.md` § *Who holds what* — "§ 12 — the SRS boundary, and the downstream
  boundary | **CTO**"), where RN-32's is the CDO's for the same reason on the UXD side. Its content
  is what this item measured: 14 dead citations of `docs/trail/sdd/cycle-1.md` across ADR-0002,
  ADR-0003, ADR-0006, ADR-0007 and ADR-0008; the review-note citations across ADR-0001 – ADR-0008
  written against the deleted numbering; `docs/nfdr.md:385`'s `SDD § 6 S-4`; that the file stands at
  `nozoki@70a879a` and the repair is the records' own, not this document's (§ 12); and where it went
  — `docs/architecture_open_issues.md` § 3.1, opened at `nozoki@20b9a94`. Re-measured against
  `nozoki@59287c9`, 2026-09-03: the 14 and the `nfdr.md:385` line are unchanged, and the ADR
  citations still name RN-24 and RN-25, which this document does not have.

  **(1) The § 12 sentence goes with it, or the note fixes half the defect.** RN-32 is not a note
  alone: it is paired with one sentence in § 12's matching boundary clause — *"One defect in the UXD
  itself was found and is reported, not repaired from here: five citations in its RN-29 no longer
  resolve (RN-32)."* This item's own *Where it shows* names two places, § 12's downstream boundary
  and the Review Notes, and then asks for one Review Note. In RN-32's shape means both: the
  downstream boundary paragraph, which rests on the log and says the record is cited rather than
  re-surfaced (RN-1), gains the equivalent sentence naming the new note. Without it a reader of § 12
  still meets a boundary resting on a log whose pointers back into this document misdirect, with
  nothing said — and that is the half of the defect this item measured first.

  **(2) Number it after RN-33 — never into the 20–29 gap.** This document's notes run RN-1 – RN-19
  and RN-30 – RN-33; 20 – 29 are empty. They are also exactly where the dead citations point:
  ADR-0007 and ADR-0008 cite `SDD Review Notes RN-25` in three places between them, and ADR-0005
  cites RN-24 in two (measured 2026-09-03 against `nozoki@59287c9`). A note dropped into that gap turns a citation that visibly fails into one that silently
  resolves to the wrong subject, which is worse than the defect being recorded — RN-32's own
  finding, that a broken pointer at least announces itself, run in reverse. So the note is RN-34,
  and the gap stays empty until the records are repaired. The two rounds are otherwise independent
  and may run in either order: if `product-architecture` re-points those citations first the hazard
  is gone, and if it runs second the gap being empty is what keeps it gone in the meantime.

  **Nothing else moves.** No slice, no § 4 condition, no § 6 field, no other section of § 12, and no
  existing note — including RN-32, which stays exactly as written and is the model rather than the
  subject. Reasoning: `docs/trail/sdd/self_answer-2.md` § 5.2.
