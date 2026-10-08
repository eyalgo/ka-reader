# Self-answer report — SDD.md

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-03

## Items worked

### 1.1 — Do the owner's answers to the previous SDD bind this run?

- **Bucket:** 1. Open issues — questions with no answer yet
- **Verdict:** answered
- **Why:** They bind. The item refuses a bare "yes", so the answer names which, and the useful
  finding is that most of them do not need this answer at all — they already reach the run through
  documents it was told to read. cycle-1 § 1.2 and § 1.3 are folded into `docs/UXD.md` v9 and carried
  by UX-F2 and UX-S6 (RN-29); § 2.1 is carried by `docs/SRS.md` FR-31; § 2.2 and § 2.3 are held by
  ADR-0002 and ADR-0003 and were re-derived afresh at RN-2 and RN-3. The one the item says turns on
  the answer — the ad-hoc-signed release — turns out not to: ADR-0007 is Accepted, was never
  deleted, and its § Context quotes the standing call verbatim, "Do not raise signing again"
  included, which is what RN-5 already carries it from. So RN-5's contingency does not open and the
  call is not the owner's to re-give. Two answers do live only in the deleted trail and bind because
  this answer says so: cycle-1 § 3.3 (the first public release waits for the full v1 cut) and
  cycle-1 § 3.1 (the routing rule and the appetite — cut-granularity is the seats', smaller rather
  than larger but not too small, and park an item for the owner when the answer changes what the
  product promises). cycle-2 and cycle-3 bind nothing: their items are defects of the deleted SDD
  and their answers were written by self-answer runs, not by the owner. One correction is
  load-bearing enough to be in the slot: cycle-1 § 2.4 says an in-folder image is *not* loaded, and
  that was overridden afterwards — UX-I12's first case now renders it in place (RN-29 (6)), so the
  cycle-1 text is superseded and must not be read as binding. **Close to a different verdict:** this
  could have been read as the owner's own, since it is about their prior decisions. It is not,
  because nothing here is unseeable — the answers are on disk at `ka-reader@70a879a`, the upstream
  documents carry most of them, and the money call carries an explicit instruction not to raise it
  again. What would have tipped it: a prior answer that lived only in the trail *and* committed
  something outward-facing. § 3.3 lives only in the trail but commits nothing new — it re-states a
  release order this document had already drafted.

### 2.1 — An SVG inside the folder is not rendered in place — it takes a stated placeholder

- **Bucket:** 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The draft is right and the exclusion stands: the asset scheme serves bytes the sanitizer
  never sees (RN-8), so admitting a document format to it in v1 would put a hole in the one wall
  C-D3 is built to be. Confirming adds no risk; only the override branch would, which is what makes
  this the run's to decide rather than a security trade-off the owner has to carry. Two additions.
  The first is a check-2 finding: the draft sends an SVG to UX-I12's third case, which is *"missing,
  unreadable or not an image"*, and a well-formed SVG is none of those in the ordinary sense — the
  case fits only by reading "not an image" as "not a bitmap the asset scheme serves". That reading
  is the SDD's to make and RN-31 already says the UXD left the format open, but it should be said
  out loud in C-D3 and RN-8, or a reader who follows the citation lands on a case about broken files
  and an SVG that is not broken — and the Content Editor's sentence at their fold would describe a
  file the tool could not read instead of a format it does not render. The second is the bound the
  draft never states: what would reopen this, and what reopening costs. Adding SVG later removes no
  surface, raises no floor, adds no prerequisite and changes no install path, so under S-11's
  drafted contract it is a minor version; and the trigger is evidence — the timed walk (AC-10) or an
  adopter report — not taste. **Failure paths walked:** the *absent* case is UX-I12's own second
  case and is unaffected (a remote SVG, which is what a README badge usually is, is already the
  not-fetched placeholder whatever this decides); the *refused* case is an in-folder SVG that is
  also unreadable, which takes the same placeholder by a different route and needs no separate rule.
  Neither addition moves a slice.

### 3.1 — `first-public-release` lands after the v1 cut, below 1.0.0

- **Bucket:** 3. Cut calls to confirm — where the slicing could reasonably have gone another way
- **Verdict:** confirmed with addition
- **Why:** Keep, and the addition is the ground: this is not a fresh appetite call, it is the
  owner's own decision restated. At `docs/trail/sdd/cycle-1.md` § 3.3 the same question was put and
  answered *"let's go with v1"* — the first public release waits for the full v1 cut the PRD names.
  That settles the current item from both sides: it puts the release **after** the v1 cut, where S-7
  sits, and it puts one **at** the v1 cut, which excludes the alternative offered here (nothing
  public until the terminus, three slices further on). § 1.1 binds that answer, and check 3 runs
  both ways: 1.1 and 3.1 were decided together and each rests on the other. The rider is worth
  carrying forward too — the consequence accepted then was that the acquisition path is proved late,
  and the mitigation given with it, *"publishing late does not require verifying late"*, is now
  structurally true at C-I3 and RN-11, so the risk that made this a live question is already
  retired. **Close to a different verdict:** left for the owner, since a public pre-1.0.0 release is
  the kind of promise their own routing rule reserves to them. What tipped it is that they have
  already exercised that reservation on this exact question; asking again would be handing back a
  decision they made. And the answer is robust if § 1.1 is overturned — RN-17's own argument (the
  familiarity thesis is unproven, and if false the product needs rethinking rather than tuning)
  reaches the same place with no trail at all.

### 5.1 — `sdd_template.md` § 3 gained a units table — every distinct `Lives in` value owes a row

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** The item scopes the work precisely and hands no draft of the values, so the answer is the
  four rows and their derivation. `crates/ka-reader-core` and `crates/ka-reader-app` are Rust `crate`s —
  the card names Rust, and the Rust packet's *"Workspace members live under `crates/`, one directory
  per member"* is already satisfied, which is why the parts table owes nothing. `ka-reader-ui` is a
  TypeScript `package`, and this is the row that repairs the measured misplacement: the packet's
  tree is written for a product at the repository root, and the units table is what says the frame
  lands inside `ka-reader-ui/` instead — the template's own *"Where a language's frame lands is this
  table's to say"*, and where the card's test command already goes looking. `checks` is the one row
  with a real choice in it. It reads `Shell` / `directory`: Shell because the card declares Shell for
  exactly this unit ("plus the `checks/*.sh` harness the NFDR names"), and writing `none` would leave
  the card's third language attached to no unit and imply no packet governs those scripts, which is
  false; `directory` because Shell ships no `layout.md` — its packet has no word for a buildable unit
  — and `checks` builds nothing and may not be a dependency of any shipped unit, so what gets created
  is exactly itself, the template's own test. **Close to a different verdict:** `none` / `directory`,
  because the template's gloss for `directory` reads *"a unit with no language at all"* and names "a
  shell harness" among its `none` examples. What tipped it is that the gloss describes the common
  case while the sentence beside it decides on what gets created, and that the card's Shell
  declaration would otherwise point at nothing. The tension is named in the answer rather than
  papered over, and the fix — if the reading is wrong — is one cell and belongs to `sdd_template.md`,
  not to this document.

## Left for the owner

### 2.2 — What the 1.0.0 promise covers — the contract the version number starts

- **Bucket:** 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override
- **Verdict:** left for the owner
- **Why:** This is the definition of a public promise to strangers, and the owner's own standing
  routing rule — which § 1.1 of this run binds — says in their words: *park an item for the owner
  when the answer changes what the product promises, not when it changes how the work is divided*
  (`docs/trail/sdd/cycle-1.md` § 3.1). Nothing on this companion changes what the product promises
  more directly. The ground the run cannot see is what the owner is willing to be held to after
  1.0.0 and to keep paying for: the PRD names maintenance a standing liability and prices a breaking
  change as an event, and a compatibility contract is exactly the instrument that makes some future
  change cost a major version. That is a liability only they carry. Leaving it costs the chain
  nothing — S-11 is the last slice, no other item turns on it, and § 2.1's answer cross-references
  the contract as *drafted* rather than as settled.
- **The answer I would have given:** **Confirm the four covered items and the exclusions, with one
  correction and two additions.**
  *The correction.* Item (b) — the read-only and no-network promises — does not belong in a list of
  things a major version could buy the right to break. C-2 makes a single read-only violation
  release-blocking and C-1/NFR-7/NFR-8 exclude writes and connections permanently, so breaking them
  is not a priced major-version event, it is a defect that stops the release. The drafted breaking
  list is already right to omit them; the *Delivers* list should say so, i.e. that (b) is
  unconditional and is not purchasable at any version. As drafted the two halves disagree with each
  other.
  *First addition — say which way (c) points.* "Own state — a later version reads what an earlier one
  wrote, or discards it whole" promises **safety**, not **continuity**: a version that changed the
  bundle identifier would silently start from an empty container and satisfy the letter of (c), and
  what a reader loses is their theme and, beyond v1, their ten remembered folders. If continuity is
  meant, `com.kensaiapp.ka-reader` belongs in the covered list; if only safety is meant, say that
  losing own state is permitted so nobody reads the promise as more than it is.
  *Second addition — decide the floor language set.* An adopter relies on their `.py` file being
  highlighted, and FR-8 makes the floor grow only by PRD revision. Dropping a floor language is not
  obviously "removing a surface" under the drafted wording, so it is currently uncovered by
  accident. I would name it in the breaking list: removing a floor language costs a major version;
  the extension set within a language (C-I5) does not, because it grows and never shrinks.
  Everything else in the draft holds. The four items are what an adopter demonstrably relies on
  between versions — the way in, the promises the product is for, their own remembered state, and
  the surface they came for — and the exclusions correctly keep the promise off wording and tokens,
  which would otherwise make every `docs/CONTENT.md` and `docs/DESIGN.md` revision a major-version
  event.

## Skipped

None this run.

## Raised on this document

### 5.2 — The re-author broke 38 citations in the decision log and the NFDR, and this document records the UXD's equivalent defect but not this one

- **What the document is owed:** one Review Note, in RN-32's own shape, recording that the SDD's
  re-author broke the decision log's and the NFDR's citations into it, that the defect is reported
  rather than repaired from here (§ 12), and where it was routed.
- **Why it is worth a cycle:** *A fact in it is now false* — the strongest of the three grounds
  `decide_companion_answers.md` § *The items are not the whole of what a document is owed* names,
  and the one it says needs no argument beyond the measurement. Measured 2026-09-03 against
  `ka-reader@c3eb937`: 14 citations of `docs/trail/sdd/cycle-1.md` across five ADRs, dead since
  `ka-reader@9c91359`; 23 citations of this document's review notes by number across ADR-0001 –
  ADR-0008, all against the deleted numbering, of which RN-24 and RN-25 no longer exist and the
  eight that resolve now carry notes on other subjects (ADR-0002's RN-7, ADR-0004's RN-8 and
  ADR-0007's RN-17 each checked); and `docs/nfdr.md:385`'s `SDD § 6 S-4`, which named live refresh
  and now names `see-git-status`. The second ground applies too — *it contradicts a document it must
  agree with* — since § 12 rests on the log while the log's pointers back into § 12's own document
  misdirect. What makes it this document's business rather than only the log's is the asymmetry:
  RN-32 reports the same defect in the UXD, so its presence tells a reader the sweep was done.

## Companions opened

- **`docs/architecture_open_issues.md`** — **opened** — companion to `adr/` and `nfdr.md`, landed in
  commit `20b9a94`

## Launchers owed

- **`docs/SDD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-sdd/launcher.sh ka-reader`
- **`docs/adr/` and `docs/nfdr.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-architecture/launcher.sh ka-reader`
