# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** /Users/eyalgolan/products/ka-reader/docs/architecture_open_issues.md
- **Document:** `adr/` and `nfdr.md` (`docs/adr/`, `docs/nfdr.md`) — the companion's own header names both
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-19
- **Sources re-read:**
  - Apple, *Protecting user data with App Sandbox*
    (https://developer.apple.com/documentation/security/protecting-user-data-with-app-sandbox), read
    2026-09-19 through Apple's own JSON for the page
    (`https://developer.apple.com/tutorials/data/documentation/security/protecting-user-data-with-app-sandbox.json`),
    because the HTML page is script-rendered and a plain fetch returns its title only. It says: "Find
    your app in Activity Monitor's process list, and verify that the value in the Sandbox column is
    Yes". A search of that JSON for `APP_SANDBOX_CONTAINER_ID` and for `sandbox_check` finds neither
    (0 matches each). Item 3.1 rests on this.
  - `tauri-runtime-wry` 2.11.4, `src/lib.rs:4792`, `:4803`, `:5375`; `wry` 0.55.1,
    `src/web_context.rs:87-112`; `tauri-utils` 2.9.3, `src/lib.rs:282`. Each was read in the Cargo
    registry at the version `Cargo.lock` resolves. Item 3.3 rests on these, and its entry says what
    each line does.

## Items worked

### 3.1 — QC-25 and ADR-0008 prove the sandbox with an observable a sandboxed app's own process does not carry

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** QC-25 is re-derived from the SDD's C-I3 as it reads now, and ADR-0008 is superseded by a
  new record rather than edited. The item arrived with no draft, so this is an answer from scratch.

  *Whose it is.* Both edits land in `docs/nfdr.md` and `docs/adr/`, which are this companion's own
  records, and the answer binds nothing but their agreement with the SDD. No person, outside party
  or reserved taste is involved, so it is answered in the owner's seat.

  *The item waited on an SDD item, and that item is closed.* The companion was written at 16:58 on
  2026-09-19 (`ka-reader@d9cbefc`). The SDD item was answered at 17:03 (`ka-reader@9b4bfde`) and folded
  by SDD run 6 at 19:37 (`ka-reader@b3439e8`). `docs/SDD.md` is Settled at v6, and C-I3
  (`docs/SDD.md:L510-L538`) now states the observable: the operating system's report that the
  launched main process is sandboxed, with an out-of-grant read and an outbound connection denied,
  plus a no-entitlement control that must fail. § 10 RC-1 (`docs/SDD.md:L1871-L1908`) records the
  measurement, and says ADR-0008 and QC-25 "are the Principal Architect's to bring into line".

  *Why QC-25 is a derivation and not a call.* The SDD fixes the relation between the two stores:
  "the § 4 statement wins and the NFDR entry is re-derived" (`docs/SDD.md:L408`). Two architects
  reading C-I3 at v6 write the same tail, so nothing here is decided by this run. The answer copies
  C-I3's failure conditions into the tail because each one is a way the check goes red, and a tail
  that left one out would describe a weaker check than the one the SDD requires.

  *Why ADR-0008 is superseded.* The record's § Decision says the probe fails "unless
  `APP_SANDBOX_CONTAINER_ID` is set in its environment" (`docs/adr/0008-…:L28`). Its last paragraph
  names that marker as the platform fact the record rests on (`:L59-L62`). Both are now false as a
  description of the design. The producing skill's rule is that an answer contradicting an accepted
  record "produces a superseding record, never an edit"
  (`product-architecture/SKILL.md:L92`), and the status vocabulary has only `Superseded by
  ADR-NNNN`, with no partial form (`adr_record_template.md:L66`). So the new record restates the
  whole decision, which has not changed, with the observable corrected. The part of the new record
  that matters most is what it rests on. `sandbox_check` has no vendor page, so the record has to
  say what happens when Apple changes or removes it: a missing function fails the build, and the
  negative control catches a function that still exists and no longer tells the two cases apart.

  *What nearly tipped it the other way.* `docs/nfdr.md` RN-12 handled a stale sentence in ADR-0003
  and ADR-0005 by leaving both records as written and recording the move in a review note, because
  "no decision reversed". That route was open here. It was not taken because RN-12's sentence sat
  in § Consequences and quoted another document's behaviour, while this one sits in § Decision and
  in the record's own dependence paragraph. The delivery tier reads a record's decision as fixed,
  so a developer who opened ADR-0008 alone would build the marker probe. If the owner reads the
  observable as a mechanism below the decision, RN-12's route is the alternative, and it costs one
  review note and no new record.

  *Checked against the settled record.* RC-1 says the re-cut "owes the decision log no superseding
  record on that ground", and the ground it names is that § 2's shape and § 3's seams did not move
  (`docs/SDD.md:L1898-L1899`). It rules out one reason for a record and leaves the others open, and
  the next sentence hands both records to this seat. Apple's sentence was re-read at its source
  this run (see *Sources re-read*), and it matches what C-I3 quotes.

  *Failure paths.* A hosted CI runner has not been measured (`docs/SDD.md:L2595-L2599`). QC-25
  gates "on every CI build", so the answer says QC-25 asserts nothing about that runner and leaves
  the question where the SDD holds it. Two instances at once is covered by C-I3's pid-count rule. A
  stale container directory is covered by C-I3's last clause. A function that changes meaning is
  covered by the control.

  *One consequence outside these records, not raised.* `docs/SDD.md:L536` says "The record is
  ADR-0008". After the fold that pointer reaches a superseded record whose Status line forwards the
  reader to ADR-0010. The sentence is not false today, and it still resolves after the fold, so no
  companion is opened on the SDD for it.

  *Two things in the item's supporting text are out of date, reported and not corrected.* It cites
  `SDD_open_issues.md` § 5.1, which SDD run 6 moved to `docs/trail/sdd/cycle-4.md` § 5.1. It lists
  `nfdr.md:L595`, the § 10 row, among the places the marker shows; that row reads "entitlements;
  sandbox present | `checks/bundle.sh`" and does not name the marker, so it needs no change.

### 3.2 — QC-23's string-equality check cannot pass until the `<asset-scheme>` form is settled

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** QC-23's check is restated in two states, keyed on whether the SDD's C-R7 still carries
  the `<asset-scheme>` placeholder. The item arrived with no draft, so this is an answer from
  scratch.

  *Whose it is.* The edit lands in QC-23's *verified by*, in `docs/nfdr.md`. It was checked
  whether the gap is the SDD's instead, because C-R7 (`docs/SDD.md:L483-L488`) carries the same
  placeholder. It is not. The SDD is coherent on this: C-R7 states the target policy, and the
  slice bar that proves it by string equality sits in the first Markdown slice, "with the
  `ka-reader-asset` origin form found" (`docs/SDD.md:L1185-L1188`). The NFDR is the document that
  promised a check which "fails when the obligation is broken" and then stated one no build can
  run. So the answer is this document's, in the owner's seat.

  *This is not a widening answered "not until it occurs".* The item cites an occurrence: the first
  build's test asserts equality with the string minus the scheme
  (`crates/ka-reader-app/tests/config.rs:L17`, `:L181-L183`), and `tauri.conf.json:L12` declares that
  string. Both were opened this run and read as the item says.

  *Why the interim string is derived and not chosen.* C-R7's *Violated by* is "any widening of
  either list". A policy whose `img-src` is `'self' data:` admits strictly less than one that adds
  an asset origin, so it cannot violate C-R7. Nothing needs the asset source before the Markdown
  slice, because the asset handler arrives with that slice. Any other interim string would either
  guess the origin form, which is the open question itself (`docs/SDD.md:L2591-L2594`), or admit a
  source C-R7 does not list.

  *Why the entry is keyed on C-R7's state.* The delivery tier does not edit this document. If the
  entry said "until this document is revised", the slice that finds the form would land a test
  that contradicts QC-23 until the next architecture run. Keyed on C-R7, the check in force moves
  the moment the SDD writes the form in, which the SDD says happens inside that slice
  (`docs/SDD.md:L1187-L1188`). The first state then becomes dead text, and the next revision here
  removes it. That is the stale path, and the answer names it.

  *Other failure paths.* A change that adds an asset source early fails the first state's
  equality, which is correct: the source enters with the slice that settles its form. WKWebView
  accepting no form without a plugin is not covered. It is the SDD's R-11 and would collide with
  QC-24's *no plugin*, and the answer says so rather than guess at it.

  *No record moves.* ADR-0006 quotes the policy with the placeholder and its last paragraph
  already says the form is open until the first Markdown slice
  (`docs/adr/0006-markdown-sanitized-on-the-host-three-walls.md:L63-L66`).

  *Checked against 3.1.* Nothing in this answer touches QC-25 or ADR-0008.

### 3.3 — QC-30 forbids environment variables, and the Tauri runtime the product links reads one

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** Yes, the boundary set covers reads made by linked dependencies, and the entry is restated
  in two halves: the product's own crates, checked as now, and the dependency tree, checked by a
  scan against a reviewed list. The item arrived with no draft, so this is an answer from scratch.
  It asks two things, whether the set covers these reads and what verifies them. Both have the same
  seat, so both are answered in the one slot.

  *The cited occurrence is real.* `Cargo.lock:L3209-L3210` resolves `tauri-runtime-wry` 2.11.4, and
  its `src/lib.rs:4792` reads `std::env::var("TAURI_WEBVIEW_AUTOMATION")`. Both were opened this
  run. So this is not a widening to be answered "not until it occurs", and it is closer to a
  correction: QC-30 says the product has "no environment variable" entry point
  (`docs/nfdr.md:L238-L241`), and the process an adopter runs reads one.

  *Whose it is.* The edits land in QC-30, QC-58, QC-61 and § 10, all in `docs/nfdr.md`. It was
  checked whether the absolute claim is upstream's, which would make this another seat's. It is
  not: `docs/fdr.md:L37` (R-2) and `docs/SRS.md:L84-L86` (FR-1) both say "the only input the
  product requires", and a grep of the SDD, SRS, FDR and PRD for an environment-variable claim
  finds none. The absolute wording came from this document's reading of the doctrine floor. It was
  also weighed whether this is the owner's alone, as a security trade-off. It is not, for a
  specific reason: the answer accepts no read. It makes the entry true and puts every read on a
  list that is reviewed as code, which is the pattern the owner already confirmed for
  `checks/deps.allow` (`docs/nfdr.md` QC-26, RN-3). Whether a given read is acceptable is decided
  at that review, by a person, in the change that adds the line.

  *Why the set covers dependencies.* The floor says "the set of points at which data or control
  enters the product from outside is named where a reader can open it, and the product has no
  entry point outside that set", and gives "its environment" as a member of a CLI's set
  (`quality_defaults.md:L84-L87`). Its subject is the product. A variable that changes what the
  process does is a point where control enters, whichever crate holds the line that reads it. The
  other reading, that the set covers only the product's own source, would let QC-30 stay literally
  true while saying nothing about the process, and these records ship to readers who will take the
  sentence at its word.

  *Why a machine check and not a review gate.* The floor's own test is whether the primitives are
  enumerable. They are. Measured this run: `cargo tree -p ka-reader-app --target aarch64-apple-darwin
  -e normal --locked` resolves 216 crates, and a grep of their `src/` for `env::var`, `var_os`,
  `vars`, `args` and `args_os`, leaving out `build.rs`, hits 17 of them. That count is textual. It
  includes test modules, code gated to other platforms, and proc-macro crates that run at build
  time, so the list the fold writes will be shorter than 17. A reviewed list of that size is the
  same shape as `checks/deps.allow`. A review gate on every lockfile bump across 216 crates would
  not be carried out by anyone.

  *What the cited variable does, as read at the source.* `tauri-runtime-wry` passes the flag to
  wry's `set_allows_automation` (`src/lib.rs:4803`). wry 0.55.1 documents that setter as "currently
  only enforced on Linux", and off GTK its implementation is an empty function
  (`src/web_context.rs:87-112`). The flag also sets the webview's `context_key` to `None`
  (`src/lib.rs:5375`). That is what the lines say. This run did not measure the running product
  with the variable set, and draws no security conclusion from the reading.

  *One more read, seen in passing and handed to the fold.* `tauri-utils` 2.9.3 `Env::default()`
  collects `std::env::args_os()` (`src/lib.rs:282`), so QC-30's "no argument vector" has the same
  defect. The item did not cite it. It is in the answer because the scan would report it on its
  first run in any case. The answer claims no complete enumeration, and says so.

  *Checked against the settled record and the earlier answers.* QC-61 rests part of its argument on
  "QC-30 and QC-58 forbid `std::env::var` in any shipped crate" (`docs/nfdr.md:L431-L433`). Under
  the item's own reading a logger crate is a dependency and `checks/structure.sh` never scanned it,
  so that sentence needs re-pointing. Its conclusion holds by two routes: the new scan, and
  `checks/deps.allow`, which QC-61's tail already names. ADR-0001 binds QC-30 and its decision
  does not move. Nothing here touches 3.1 or 3.2.

  *Failure paths.* A dependency bump that adds a read fails the build until the list is reviewed.
  A crate absent from the local registry cannot be scanned, and the check has to fail on that
  rather than pass. Reads by the operating system's frameworks inside the process are not covered:
  no lockfile names them, and the answer has the entry say so and point at the sandbox (QC-25).
  The owner refusing a listed read is the case the list exists for. The read then has to be
  engineered out, which is a design change and the CTO's, raised when it happens.

  *What would have tipped this to "left for the owner".* If "no environment variable" were one of
  the standing sentences the product states to adopters, narrowing it would be the owner's. It is
  not among the six QC-44 names (`docs/nfdr.md:L351-L355`).

## Left for the owner

None this run.

## Skipped

None this run. The companion carries three items, all under § 3, all with an **Answer** slot at its
placeholder when this run reached it (`grep -c '<the owner fills this in>'` printed 3 before the
first write and 0 after the last). No slot was already filled, and no item is addressed to another
actor.

**Seen in the document and not raised.** `docs/nfdr.md:L33-L36` says every command it names is
"one the SDD names for a product that has no code yet". The product has code since
`ka-reader@00e1bf1`. The clause that a reader acts on still holds: a command becomes executable in
the change that lands its script, and until then the gate is `development-design` reading the
entry. `checks/` holds `bundle.sh` and `tests` and no `structure.sh` today. No item was raised for
this, for two reasons. An item raised by this run keeps its slot empty, so it would hold the
companion open for one more full round, and that is a high price for a provenance phrase no
reader acts on wrongly. And this companion has no *choices to confirm* section to append to, while
the skill forbids changing which sections a file has. The fold revises the NFDR in place this
round and reads it whole, so the phrase is in front of it. If the owner wants it as an item, it is
one line on the next companion.

## Companions opened

None this run. No answer moves a sentence in another document. The SDD, the one upstream document
these items touch, already states 3.1's observable at v6, and 3.2 and 3.3 rest on it as it stands.

## Launchers owed

- **`adr/` and `nfdr.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/skill/launcher.sh product-architecture ka-reader`
