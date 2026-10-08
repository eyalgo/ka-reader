# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (NFDR v28, Settled)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-03
- **Sources re-read:** None. Every answer rests on files in this repository at `ka-reader@bf9b90c`:
  `docs/nfdr.md`, `docs/SDD.md`, `docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md`,
  `crates/ka-reader-core/src/` and `checks/structure.sh`.

## Items worked

### 3.1 — QC-11 forbids `fs-reader` importing `folder-model`, but SM-1 makes `folder-model` the owner of what a read returns

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** Reading (a). QC-11 stands and the edge goes. The question is not widening: it asks which
  of two settled statements governs an edge that exists, and the item cites where the edge is
  (`crates/ka-reader-core/src/fs_reader.rs:L14`).

  *Whose it is (check 1).* It belongs to the constraint set, so it is this seat's to answer in the
  owner's place. Nothing in the answer commits a person or carries a risk. It only keeps the NFDR,
  the SDD and the tree consistent with each other.

  *Is the question sound (check 2).* There is no draft; the item offers two readings and a lean
  toward neither. Its framing makes one assumption that does not hold: that SM-1 "makes
  `folder-model` the owner" of the types that cross it. SM-1's owner cell says the model *states*
  what a read must return, and that the reader implements it (`docs/SDD.md:L415`). It does not say
  the model defines the types. SM-2's cell, on the next line, does say that: "The port is a trait the
  model owns" (`:L416`). That is the difference the item notices ("SM-1 has no such separate
  thing"), and it points to reading (a), not (b). The tree already reads SM-1 that way. Five of the
  types that cross SM-1 — `EntryKind`/`Entry`, `Condition`, `ItemState`, `FileContent` and
  `CannotDisplayReason` — are defined in `fs_reader.rs` (`:L93-L149`). The model imports them
  (`folder_model.rs:L6`), which QC-10 allows (`docs/nfdr.md:L236`). `OpenFailure`
  (`folder_model.rs:L38`) is the only SM-1 type defined on the model's side. It is a three-variant
  map from `io::ErrorKind`, built in `fs_reader.rs:L24-L43`: the "condition observed" that the
  SDD's `fs-reader` row says that part returns (`docs/SDD.md:L322`, "each returning its outcome as
  data (bytes, or the condition observed)").

  *Does it contradict something settled (check 3).* Reading (b) does. QC-11 transcribes the SDD's
  units paragraph: "the readers, the watcher, the highlighter and the renderer import neither the
  model nor one another" (`docs/SDD.md:L347-L348`). The SDD is Settled, so an NFDR edge from
  `fs-reader` into the model would contradict it. Granting (b) would therefore need the SDD to
  change first, which is the CTO's call, and nothing in SM-1 asks for that. ADR-0016 binds only the
  four units and the cross-crate rules (`docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md:L32-L41`),
  not edges inside `ka-reader-core`, so no record has to be superseded. Reading (a) contradicts nothing.

  *Where the type goes.* The item's (a) suggests a module of no part, as `language` is. I answer
  with `fs-reader` instead. That home needs no new rule, matches where the other five SM-1 types
  live, and matches the SDD's ownership of "the condition observed". A module of no part is not yet
  a home § 1.2 allows; that is the separate item this run raised, § 2.1 (below). The Rust module
  spelling remains the developer's (`docs/nfdr.md:L56-L57`). The constraint the answer sets is "not
  in `folder-model`, and somewhere `fs-reader` may import".

  *Failure paths (check 4).* **Absent:** the bridge imports `ka_reader_core::OpenFailure`
  (`crates/ka-reader-bridge/src/session.rs:L9`). The move keeps `lib.rs`'s `pub use` path, so the
  bridge does not change and SM-4's returns do not change. **Stale:** until the change that moves
  the type lands, `checks/structure.sh` keeps listing the clause as not held (`:L157-L161`), and
  its gate stays the `development-design` review, as the NFDR's header rule says
  (`docs/nfdr.md:L36-L44`). **Concurrent:** a second reader-to-model edge added in that window is
  caught only by that review. That case is not covered, and it closes when the clause enters the
  scan. **Refused:** if the move turned out not to preserve behaviour, it would be a different
  change, not this one. Nothing in `OpenFailure` depends on the model: it has no fields, and outside
  tests and doc examples (`folder_model.rs:L58`, `:L167`, `:L171`) its values are made only in
  `fs_reader.rs:L24-L43`.

  *What the fold does.* QC-11's text does not change. Its trace should record the SM-1 reading — a
  type that crosses SM-1 is defined where `fs-reader` may import it, never in `folder-model` — and
  that `checks/structure.sh` holds the clause from the change that moves the type. The item's
  suggested SM-1 sentence in the SDD is not owed. Under this reading SM-1 already says what is
  true, and the tree's five types show it. An SDD change would only make it clearer, which
  `decide_companion_answers.md` § *The items are not the whole of what a document is owed* puts on
  its list of reasons that are not enough. I came close to raising one anyway, because the
  ambiguity did block a rule. What would have tipped it: a second seat reading SM-1 as type
  ownership. The NFDR trace written by the fold is where the next reader will find the reading.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.1 — § 1.2 says "may import" is the whole allowed set, but every part in the core imports `language`, a module of no part, and only the script says that is allowed

- **What the document is owed:** a § 1.2 entry stating that a value module of `ka-reader-core` that is
  no SDD part may be imported by any part without that being an edge, and that such a module imports
  no part. `checks/structure.sh` would gain the matching finding.
- **Why it is worth a cycle:** *It contradicts a document it must agree with* — here the record and
  the tree it governs, plus the script that cites the record. § 1.2 says "'May import' is the whole
  allowed set … never inferred" (`docs/nfdr.md:L208-L209`). `folder_model.rs:L8`, `fs_reader.rs:L15`
  and `highlighter.rs:L13` import `crate::language`, which no allowed set names. The permission
  exists only in `checks/structure.sh:L97-L98`, a rule the NFDR never stated. That rule also makes a
  no-unit file "never a subject", so such a file can import a part with no finding. That is a route
  around the graph that no check names, and an enforceability gap in the constraint set. Found while
  deciding § 3.1. It is not § 3.1's split half: § 3.1 is decided without it.

  The companion's header blockquote ends "Its one item is in § 3" (`docs/architecture_open_issues.md:L23`).
  That sentence is no longer true now that § 2.1 sits beside § 3.1. The header is not this run's to
  edit; it is for the fold to correct. The "None." under § 2 was replaced by § 2.1 and its provenance
  blockquote, as the cycle-12 round did (`docs/trail/architecture/cycle-12.md:L28-L37`).

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
