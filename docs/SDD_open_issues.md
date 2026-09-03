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
- **Answer:** <the owner fills this in>

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
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

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
- **Keep or re-cut:** <"keep", or "re-cut: <the shape to take instead>">

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
- **Answer:** <the owner fills this in>
