# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (NFDR v29, Draft)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-03
- **Sources re-read:** None. The one answer rests only on files in this repository at
  `nozoki@a3caabd`: `docs/nfdr.md` (read whole), `docs/SDD.md` § 3,
  `docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md`, `crates/nozoki-core/src/` and
  `checks/structure.sh`. `git diff --stat 803b599 a3caabd -- crates checks .github` prints
  nothing, so the tree is the one v29 measured.

## Items worked

### 2.1 — § 1.2 says "may import" is the whole allowed set, but every part in the core imports `language`, a module of no part, and only the script says that is allowed

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** QC-63 stands as v29 drafted it. One clause gains a named gate, and one stated reason
  is corrected.

  *Check 1 — whose.* The edit lands in `docs/nfdr.md` § 1.2 and § 10, so it is this document's. It
  binds only how this document's import graph reads its own tree, and nobody outside carries it. It
  does not need the SDD to move, for the reason given under check 3. No ground I cannot see bears on
  it, so the item is mine to answer in the owner's seat.

  *Check 2 — is the draft sound.* Mostly, yes, and it is true of the tree. `language.rs:L30-L39` is
  one `enum Language` with derives. `error.rs:L4-L9` is a variantless `enum Error` that no part
  imports and only `lib.rs:L9` re-exports. That fits the entry's "exposed through the crate's public
  surface". The only crate-relative lines in either file are `language.rs:L43` `use crate::Language;`
  and `error.rs:L26` `use super::Error;`, both inside `#[cfg(test)] mod tests` and both naming their
  own type. Under the script's own definition of importing a unit (`checks/structure.sh:L102-L107`),
  neither imports a part. So the one new rule raises nothing today, as RN-40 says. `lib.rs:L9-L15`
  re-exports from all five modules, which is why naming `lib.rs` as neither a part nor a value module
  is needed and correct.

  The gap is that **"holds types and values only" has no verification**, and the NFDR's preamble
  (`docs/nfdr.md:L15-L16`) says "An entry with no nameable verification is not yet an entry".
  QC-63's *verified by* covers the import half (the new script rule) and the no-I/O half (QC-15),
  and nothing covers this one. It is not idle. It is what tells a value module from a part's logic
  sitting outside the part. The case is concrete. SDD § 3 gives "the extension map that names a
  floor language or *plain*" to `fs-reader` (`docs/SDD.md:L322`) and lists "Naming the language —
  that is `fs-reader`'s extension map" under `highlighter`'s *Must not own* (`:L327`). A natural
  refactor moves that map into `language.rs` as `Language::from_extension`. It imports no part and
  does no I/O, so it passes the new rule and QC-15, and it moves owned behaviour out of its part with
  no finding. No grep can tell a type from a behaviour, so the honest gate is review. The addition is
  that QC-63's *verified by* names review at `development-design` for this half. It takes the form
  QC-13 already uses for its delegation half: "what counts as logic is not greppable"
  (`docs/nfdr.md:L302-L303`). The question the review asks is whether the module holds anything a
  part's *Owns* cell in SDD § 3 names. § 10's closing list, "Entries with no row are review gates"
  (`docs/nfdr.md:L1345-L1346`), then names "QC-63 (the types-and-values half)" beside "QC-13 (the
  delegation half)". QC-63's § 10 row stays: it is the machine half.

  *A stated reason that does not hold, so it is corrected.* The draft's rationale says "Neither SDD
  § 3 nor ADR-0016 names a module of no part, so both readings of the tree are open". RN-40 says
  "this is a derivation an SDD reader could make another way: move `language` into a part, and name
  the import the move needs" (`docs/nfdr.md:L3558-L3560`). That alternative is not open at this
  document's altitude:
  - `Language` crosses SM-1 upward: "the bytes with the text rule applied and the floor language
    named" (`docs/SDD.md:L415`). Cycle 26's reading, now in QC-11's trace (`docs/nfdr.md:L259-L262`),
    says a type that crosses SM-1 is defined where `fs-reader` may import it, never in `folder-model`.
  - `fs-reader` names the language, and `highlighter` takes it as input (`:L322`, `:L327`). The units
    paragraph says the readers and the highlighter "import neither the model nor one another, with
    two stated edges" (`:L347-L349`). Neither edge runs between `fs-reader` and `highlighter`.

  So no part can hold `Language` without an edge the SDD does not state. Naming that import would be
  a change to SDD § 3, which is the CTO's, not this document's. The positive ground is also in the
  SDD: "**What the system holds.** Design-level; the physical layout is the developer's" (`:L433`).
  ADR-0016 hands the module boundaries to § 1.2: "the module boundaries this record fixes are the
  ones `docs/nfdr.md` § 1.2 binds" (`docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md:L83-L84`).
  So QC-63 is the reading the settled SDD leaves room for, and the override's first branch is an
  upstream change, not a sibling reading. Nothing in QC-63's obligation moves for this. Its trace
  should cite SDD § 3 `:L433` and SM-1 as the ground, so a cold reader does not inherit "both
  readings are open". RN-40 is a dated note, and the fold records the correction in its own note
  rather than rewriting RN-40.

  *Check 3 — does it contradict anything settled.* No. QC-10 and QC-11 do not name the value modules
  and do not need to. ADR-0016's units table lists parts under "Holds" (`:L27`), and a value module
  is not a part. ADR-0016 hands module boundaries to § 1.2, where QC-63 sits. QC-63 also agrees with
  cycle 26's answer, the one earlier answer this round sits beside: it gives `Language` the home that
  answer's rule requires. No source outside this repository is relied on.

  *Check 4 — failure paths.* **Empty:** a core with no value module makes the rule vacuous, and it
  reads correctly. **Absent:** until the change that adds the script rule lands, the gate is
  `development-design` reading the entry, which the entry says by the header's per-rule clause.
  **Stale:** a value module that grows a part's behaviour is the case the addition covers. One that
  later imports a part, directly or through an item `lib.rs` re-exports from one (`crate::OpenFailure`),
  is caught: the script reads re-exported names as imports of the unit (`checks/structure.sh:L104-L107`).
  A value module made a directory, with files under `src/language/`, is still "a file of no unit" and
  stays a subject. **Concurrent:** one value module importing another is not an edge, and it cannot
  route a forbidden edge, because neither may import a part. **Covered, and fails closed:** a value
  module whose inline `#[cfg(test)]` module imports a part for a test would be a finding. § 9's scope
  keeps inline test modules inside every rule (`docs/nfdr.md:L1060-L1062`). That is consistent and
  costs a test-only import nothing that a part's own test module cannot do. **Not covered, and named:**
  a value module holding runtime wiring, such as a trait object that one part calls and another
  implements, is not an import and is outside this graph. The review half above is where it would be
  read.

  I came close to *confirmed* with no addition. What tipped it is the preamble's rule that each
  obligation names its verification. A clause with no gate is exactly what this document's § 10
  closing list exists to name.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
