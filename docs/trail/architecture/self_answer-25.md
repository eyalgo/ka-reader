# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The NFDR is v23 and Draft (`docs/nfdr.md:L3-L5`).
  ADR-0017 is Proposed (`docs/adr/0017-floor-grammars-compiled-by-tree-sitter-native-c-in-the-core.md:L3`).
  The companion was written by the cycle-20 fold at `ka-reader@d7f31fa`, with two drafts in § 2.
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-01
- **Sources re-read:** Both answers rest on sources outside this repository, and each was read where
  it lives on this machine. (1) The registry copy of `tree-sitter` 0.27.0, at the version
  `Cargo.lock` resolves: `include/tree_sitter/api.h:L29` reads `#define
  TREE_SITTER_LANGUAGE_VERSION 15` and `:L35` reads `#define
  TREE_SITTER_MIN_COMPATIBLE_LANGUAGE_VERSION 13`. `binding_rust/lib.rs:L780` reads `if
  (MIN_COMPATIBLE_LANGUAGE_VERSION..=LANGUAGE_VERSION).contains(&version)`. (2) The `repository`
  field of each grammar's registry copy: Python, Bash, JavaScript and JSON name
  `https://github.com/tree-sitter/…`, and YAML and TOML name `https://github.com/tree-sitter-grammars/…`.
  The runtime names `https://github.com/tree-sitter/tree-sitter`. (3) Cargo itself, by running
  `cargo tree -p ka-reader-bridge --target aarch64-apple-darwin -e normal --locked --offline`. These
  are local copies of published sources, not a vendor's published documentation. No answer this run
  rests on a vendor web page.

## Items worked

### 2.1 — QC-30 half (2) scans only crates from outside the workspace, and skips the product's own two crates by membership

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The draft is right, and it leaves one crate uncovered.

  *Seat.* The change lands in QC-30's *verified by* tail, in `nfdr.md`. That is this companion's
  document. It binds only how a check is written, not a person, money or risk, so it is answered
  in the owner's seat. The cycle-20 fold sent it to the owner "because it changes what the check
  does". That is a reason to have it confirmed, not a ground only the owner can see.

  *Is the draft sound?* Yes, and I re-measured it rather than taking it from RN-34. The command half
  (2) names, run this round with `--offline`, prints `ka-reader-bridge v0.0.0
  (/Users/eyalgolan/products/ka-reader/crates/ka-reader-bridge)` at the root and `ka-reader-core v0.0.0
  (…/crates/ka-reader-core)` under it. `ls -d ~/.cargo/registry/src/*/ka-reader-*` matches nothing. So a
  script written to v22's words ("every crate the `cargo tree` command above names") fails on every
  build before it reads a dependency. That is the draft's ground, and it holds. The draft gives two
  reasons. One is weak: the heading "**(2) The linked dependency tree**" does not by itself leave out
  `ka-reader-core`, which *is* linked into the bridge. The real reason is the second one. Half (1)
  already holds both crates to a stricter rule than half (2) could: they read no argument, no
  environment variable and no config file at all (`docs/nfdr.md:L569-L571`). Half (2) would only
  have checked their reads against a list. Scanning them there adds nothing and blocks the build.

  *Does it contradict anything settled?* No. SDD C-R3's *Violated by* states the rule by what a
  slice reads, not by crate (`docs/SDD.md:L558-L560`). QC-58 follows QC-30's halves
  (`docs/nfdr.md:L894-L901`), and § 10's two QC-30 rows still describe the halves correctly
  (`:L1212-L1213`). The cycle-20 run that raised the item proposed the same change
  (`docs/trail/architecture/cycle-20.md` § 2.1), so this answer does not reverse it.

  *Failure paths — the addition.* **Stale:** the workspace's members are a glob, `members =
  ["crates/*"]` (`Cargo.toml:L8`), so a directory created under `crates/` becomes a member with no
  edit to the manifest. Half (2) would skip that crate by membership, as drafted. Half (1) names
  its crates: "`ka-reader-core`, `ka-reader-bridge` and `ka-reader-mac`" (`docs/nfdr.md:L569-L570`). So a third
  member would be in neither half. Today the two sets are equal only by coincidence. The fold should
  make the halves split on one test: half (2) skips a member because half (1)'s rule reads every
  workspace member's sources. § 9 already scopes `checks/structure.sh` to "the product crates'
  sources outside `crates/*/tests/`" (`:L994-L995`), which is that set, so the rule needs to say so
  and not grow. The gap is not silent today: `checks/deps.allow` names both members
  (`:L31-L32`), so a new member fails `checks/no-network.sh` until the list change is reviewed at
  `development-design` (QC-26). A new member is also a change to ADR-0016's unit set, and § 1 holds
  the tree to that set (`docs/nfdr.md:L50`). But that review asks QC-3's question, about a network
  transport, not QC-30's, so it does not make the gap disappear. **Absent:** a crate with no
  registry copy that is not a member, such as a path or git dependency from outside the workspace,
  still fails the build. The draft keeps that, and it is the right way to fail. **Empty,
  concurrent, refused:** they do not apply to a scan over a locked tree.

  *What would have tipped it.* If half (1)'s rule could only ever read the three named units, I
  would have overridden the draft so that the skip goes only to members half (1) names. That fails
  closed, but it puts back the list of names the draft avoided. § 9's existing scope makes the
  cheaper fix, saying so, enough.

### 2.2 — The tree-sitter grammar engine earns a record — ADR-0017, written at Proposed

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** ADR-0017 is a record. The draft reaches the right answer, but it carries the third gate
  on the weaker of the grounds available.

  *Seat.* Whether a decision earns a record is the significance test. That test is how this
  document's own seat reads a decision, and the answer binds only the shape of the decision log. The
  cycle-20 fold sent it to the owner because "two architects could read [the reversibility gate]
  differently". Disagreement between architects is not a ground the owner holds and this run
  cannot see, so it is answered in the owner's seat.

  *Is what was handed over sound?* Everything ADR-0017 cites was re-read at its source and holds.
  The SDD lines it pins are right: the `highlighter` row at `docs/SDD.md:L327`, the units
  paragraph's *no `unsafe`* sentences at `:L339-L341`, TO-11 at `:L2252-L2265`, R-14 at `:L2566`,
  and the quoted "comes back as data" at `:L2575-L2576`. The ABI range 13 to 15 and the
  `set_language` check match the registry copy (§ Header). The six grammar repositories split
  between the two organisations as the record says. `ka-reader@85d9fa7:checks/deps.review.md`
  § *The engine chosen* weighs hand-written lexers and `syntect` in the words the record uses.

  Two gates are clear, as the draft says. The decision is surprising without its context: C reads
  the adopter's bytes inside a unit whose own Rust source forbids `unsafe`. And it was a real
  trade-off, with two alternatives weighed. On the third gate, how hard it is to reverse, the draft
  rests on "six languages' worth of lexing". TO-11 rightly calls that one part's rewrite with no
  seam moving (`docs/SDD.md:L2261-L2265`). Two stronger grounds carry the gate, and the draft names
  neither:

  1. **The log has already ruled on this kind of decision.** ADR-0004 records libgit2, the
     product's other body of native C in the core, and its undo is *cheaper* than this one: "the
     installed-`git` adapter behind the port — the seam is already drawn for it"
     (`docs/adr/0004-git-read-through-libgit2-behind-a-port.md:L50-L51`). The draft points at
     ADR-0004 but not at this fact, which is the one that decides the question. Leaving ADR-0017
     out would record the cheaper case and drop the more surprising one.
  2. **Without the record, the reasoning has no append-only home.** What a later reader cannot
     reconstruct is *why* C parses the folder's bytes in the no-`unsafe` core, and why that C is
     compiled from source by `cc` on every build. ADR-0017 § Context states both. Without the
     record, that reasoning lives in the SDD, which is revised in place, and in
     `checks/deps.review.md`, which QC-3 cites pinned to `ka-reader@85d9fa7` because its own title
     stops being true at the next name added (`docs/nfdr.md:L126-L127`). I checked whether TO-11's
     "The weighing is the record's" (`docs/SDD.md:L2265`) means an ADR. It does not: SDD RN-80 says
     the row "cites the record for what was weighed", meaning the dependency review. So TO-11 does
     not depend on ADR-0017, and this answer does not lean on it.

  *The addition.* The fold should replace "that is why this is a record and not a note" (ADR-0017
  § Consequences, `:L68-L69`), which currently rests on rewrite cost alone. It should name the two
  grounds above, using facts the record's § Context already states, and add no new claim. The
  record is still Proposed, so that edit happens before acceptance and does not break the
  append-only rule.

  *Does it contradict anything settled?* No. QC-9's limit traces to SDD § 3 and § 11 R-14 either
  way, as the draft says. QC-26's and QC-30's trace tags gain ADR-0017, which the cycle-20 fold
  already wrote. The index row is already in place (`docs/adr/README.md:L34`).

  *Failure paths.* **Stale:** when `git-reader` links libgit2, QC-9's limit already names it
  ("libgit2 when `git-reader` links it", `docs/nfdr.md:L219`). Nothing in ADR-0017 goes false then.
  **Refused, by a grammar's holder:** the record's own § *What this rests on* covers it. The grammar
  stays at its locked version, and what is lost is the runtime's freedom to move. **Refused, by the
  owner, later:** once this round folds, ADR-0017 is Accepted. "If overridden: ADR-0017 is deleted"
  stops being available, and a reversal becomes a superseding record. That is the ordinary cost of
  confirming and is named here so it is not a surprise. **Not covered, and named:** no sanitizer
  run, no hostile corpus and no parse bound for the engine. The record already names all three as
  open in SDD R-14, with no condition attached, and I agree that none of them is an obligation for
  this document.

  *What would have tipped it.* If ADR-0004 had been recorded for a reason that does not apply here,
  such as its port or a transport question, the precedent would not carry and I would have weighed
  an override more seriously. Its record names native C and the undo cost, the same two things at
  issue here.

## Left for the owner

None this run.

## Skipped

None this run. Both items' slots were at their placeholders, and § 1 and § 3 read "None."

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
