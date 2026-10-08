# ADR-0017: The six floor grammars are compiled by tree-sitter — native C built from source into `ka-reader-core` on every build

**Status:** Accepted
**Date:** 2026-10-01

## Context

The reading panel colours a file in one of six floor languages, and a fenced block in a Markdown
file, into the five token classes `docs/DESIGN.md` § Colors names (`docs/SDD.md` § 3, the
`highlighter` row; `docs/SRS.md` FR-8, FR-29). The six grammars are compiled into the library, so
something has to turn each language's text into spans. The SDD left which engine does it as an
open question, to be settled by the dependency review of the change that lands it, under C-R6's
rule that every dependency is a decision and the tree is reviewed as code (`docs/SDD.md` § 4 C-R6).
That review settled it (`ka-reader@85d9fa7:checks/deps.review.md` § *The engine chosen*), and SDD v23
names the result in § 3 and states its cost as § 9 TO-11 and its risk as § 11 R-14.

Two facts make it more than a library pick. The core unit's own Rust source holds no `unsafe`
(ADR-0016), and the engine is C: whatever it does is done inside that unit, on bytes read from the
adopter's folder, which may be hostile (`docs/SRS.md` DR-6, NFR-16) and are often a file another
process is still writing (`docs/SRS.md` FR-16). And the C is not vendored as built objects. It is
compiled from source by the `cc` crate in each crate's build script, on every build.

## Decision

The six floor grammars are compiled by **tree-sitter**: its runtime (`tree-sitter`),
`tree-sitter-highlight`, and one grammar crate for each floor language (`tree-sitter-python`,
`tree-sitter-bash`, `tree-sitter-javascript`, `tree-sitter-json`, `tree-sitter-yaml`,
`tree-sitter-toml-ng`), built from C into `ka-reader-core` at build time, with ka-reader's own query files
compiled in. Only `highlighter` imports the engine, and the engine stands behind what `highlighter`
owns: text and a floor language in, spans in the five classes out (`docs/SDD.md` § 3, the
`highlighter` row; § 9 TO-11).

*No `unsafe`* remains a claim about each crate's own Rust source. The engine's C is linked beside
that source and is outside the claim. A fault in it is bounded by the App Sandbox around the one
process (ADR-0011, ADR-0013), not by the core's lint (`docs/SDD.md` § 3, the units paragraph; § 11
R-14).

## Alternatives ruled out

- **Hand-written lexers in the core** — no names added to the dependency list, and no C. Lost
  because it puts six grammars' worth of lexing in `ka-reader-core`, written and kept by this product
  for languages whose syntax it does not own (`ka-reader@85d9fa7:checks/deps.review.md` § *The engine
  chosen*; `docs/SDD.md` § 9 TO-11).
- **`syntect`** — Lost because it needs vendored Sublime syntaxes for TOML, and its default
  syntax dump holds far more than six grammars, so the bundle would carry grammars with no floor
  language behind them. The `highlighter` row forbids that: "A seventh grammar with no floor
  language behind it" is in its *Must not own* column (`ka-reader@85d9fa7:checks/deps.review.md`
  § *The engine chosen*; `docs/SDD.md` § 3).

## Consequences

Easier: no lexing for six languages is written or kept in the core, and the bundle holds the six
grammars and no others (`docs/SDD.md` § 9 TO-11). A parse the engine refuses or stops early "comes
back as data and is held by `folder-model`'s fill rule, never a panic" (`docs/SDD.md` § 11 R-14,
`:L2575-L2576`).

Harder: every build compiles C. The engine's names are on `checks/deps.allow` and owe notices in
`THIRD_PARTY_NOTICES.md` (QC-26; QC-41). Its build scripts read the environment at build time, so
QC-30's scan of the linked tree has to except a dependency's build script and say exactly which
file that is. C parses the folder's bytes inside a unit whose own source forbids `unsafe`, so that
claim has to be stated narrowly enough to stay true (QC-9). **Not covered, and named:** nothing runs
the engine's C under a sanitizer or against a hostile corpus for the six languages, and nothing
bounds how long a parse takes. The SDD names both as open (`docs/SDD.md` § 11 R-14) and states no
condition for either, so neither is an obligation here.

What undoing it costs: `highlighter` rewritten behind what it owns, with its query files, and the
engine's names taken off the list in the same change. No seam, no other part and no slice's bar
moves with it (`docs/SDD.md` § 9 TO-11). That is one part's rewrite, six languages' worth of
lexing or a second engine with vendored syntaxes, and the cost alone would not make this a record.
Two things do. The log already records the product's other body of native C in the core, libgit2,
and undoing that one is cheaper: "the installed-`git` adapter behind the port — the seam is already
drawn for it" (ADR-0004 § Consequences). Leaving this decision out would keep the cheaper case and
drop the more surprising one. And what a later reader cannot rebuild without this record is the
reason C parses the adopter's bytes inside the unit whose own source forbids `unsafe`, and why that
C is compiled from source on every build (§ Context). Without the record, that reasoning lives only
in the SDD, which is revised in place, and in a dependency review cited pinned to one commit because
its title goes stale at the next name added (QC-3). Neither is append-only. That is why this is a
record and not a note.

**What this rests on, and whose it stays.** Three platform facts, none of them this product's. The
runtime and four of the grammars (Python, Bash, JavaScript, JSON) name
`https://github.com/tree-sitter/` repositories. The YAML and TOML grammars name
`https://github.com/tree-sitter-grammars/` repositories (the `repository` field of each registry
copy's `Cargo.toml`, at the versions `Cargo.lock` resolves at `ka-reader@85d9fa7`). The third is a C
compiler at build time, reached through `cc`. The runtime loads only grammars whose language ABI
falls in a fixed range — 13 to 15 in `tree-sitter` 0.27.0 (`include/tree_sitter/api.h:L29`,
`:L35`; `binding_rust/lib.rs:L780` of that registry copy). So when a grammar's holder stops
answering, what goes is not that grammar. It stays at its locked version and keeps reading its
language. What goes is the runtime's freedom to move. A runtime release that drops the stalled
grammar's ABI forces a choice: hold the runtime back, or replace that one grammar inside
`highlighter`. The decision does not have to be undone either way. An abandoned grammar costs
one part's rewrite for one language, and the risk is followed in the lockfile reviewed as code
(`docs/SDD.md` § 4 C-R6), not discovered by an adopter.

## Traces to

- `docs/SDD.md` at v23 (`ka-reader@e81a386`, Settled) — § 3, the `highlighter` row (`:L327`) and the
  units paragraph (`:L339-L341`); § 4 C-R6; § 9 TO-11 (`:L2252-L2265`) and TO-2; § 11 R-14
  (`:L2566`); § SDD Review Notes RN-80.
- `ka-reader@85d9fa7:checks/deps.review.md` § *The engine chosen* — where the engine was chosen and
  the two alternatives were weighed. It landed with `Cargo.lock` and `checks/deps.allow` in one
  commit.
- `docs/SRS.md` FR-8, FR-16, FR-29; DR-6; NFR-16.
- ADR-0011, ADR-0013, ADR-0016.
- `docs/trail/architecture/cycle-21.md` § 2.2 — the owner's seat confirmed that this decision earns
  a record, with the two grounds for the reversal gate named above (reasoning at
  `docs/trail/architecture/self_answer-25.md` § 2.2). Accepted on that answer.

## Binds

QC-9, QC-26, QC-30.
