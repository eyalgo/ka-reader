# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** docs/SDD_open_issues.md
- **Document:** docs/SDD.md
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-23
- **Sources re-read:** None outside this repository's own records and the organisation's core. The
  answers rest on:
  - `docs/SDD.md`, read whole
  - the built tree: `crates/nozoki-bridge/src/exports.rs:L37`, `:L50`, `:L61`;
    `crates/nozoki-bridge/tests/exports.rs:L17`; `target/include/nozoki_bridge.h:L13-L15`;
    `nozoki-mac/` with `Package.swift`, `Sources/` and `Tests/`
  - `docs/nfdr.md` QC-24; ADR-0013 `:L44-L49` and ADR-0016 `:L28`
  - the Swift packet at `<CORE>/doctrine/engineering/languages/swift/`, landed at
    `kensaiapp-dev@3ab2e8553`, and its skeleton tree's README
  - `sdd_template.md` § 3's *Kind* rule
  - the project card at `kensaiapp-opensource@5b27023`

## Items worked

### 5.1 — C-R7 and S-1 admit only SM-4's list, and SM-4's list leaves out the `nozoki_free` that SM-4's own returns require

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item carries the PM's lean, so I weighed it as a draft (the prompt's rule for a
  lean found outside bucket 2). The lean is right: `nozoki_free` stands beside SM-4's list, not on
  it. The item's own reason already holds, and three facts strengthen it.
  - **It is a different kind of function.** SM-4's list is the set of *calls*, each staged by the
    slice that lands it (`SDD.md:L413`). `nozoki_free` is not staged. Every call's return needs
    it, so it is exported from the first build that exports anything.
  - **It is not a surface.** The priced contract reads "the surfaces' presence through SM-4"
    (C-I6, `:L744`). Adding a tenth function to the list would make "all nine from `v1.0.0`" false
    in SM-4, C-R7, S-11 and ADR-0013 (`adr/0013…:L47`).
  - **The records already place it beside the list.** ADR-0013 names it after the nine, as what
    every return is freed by (`:L48`). ADR-0016 lists it separately from SM-4's functions (`:L28`).
    So the lean agrees with the settled log, and no record has to move for it.

  *The addition.* The draft is narrower than the defect. It fixes C-R7 and S-1, but SM-4's own row
  says the same wrong thing twice. Its Down cell says "calls from this list and no other", and its
  last sentence says "Nothing else crosses in either direction" (`SDD.md:L413`). Yet the shell
  calls `nozoki_free` down the same seam. Fixing C-R7 alone would leave SM-4 contradicting C-R7.
  So the fold owes five edits:
  1. SM-4's Down cell and its closing sentence name `nozoki_free` as the one release call beside
     the list.
  2. C-R7's "From `v1.0.0` the set is SM-4's list whole" (`:L598-L599`) becomes the list whole and
     `nozoki_free`. Its *Violated by* line (`:L610`) reads "outside SM-4's list and
     `nozoki_free`".
  3. S-11's command half pins "SM-4's nine functions" (`:L1920`), and that pin becomes the nine and
     `nozoki_free`. C-I6's sentence (`:L738`) follows, since the pin reads the export set.
  4. The fold says that `nozoki_free` is not a command. `read-only.sh` exercises "every command the
     build grants" through SM-5 (C-I3, `:L637-L638`), and `nozoki_free` never reaches the model. So
     C-I3's "a slice that lands a command the harness does not exercise" does not reach it. Its
     misuse (a double free, a missing free) is § 11 R-13's case, which already runs the bridge's
     tests under the address sanitizer (`:L2395-L2402`).
  5. The case in the next paragraph is named in the fold.

  *Check 3.* Nothing settled moves. The PRD and SRS name no C symbol. ADR-0013 and ADR-0016 already
  read this way. The only other record carrying the flaw is `docs/nfdr.md` QC-24, whose "always
  inside the closed list" (`:L296-L303`) is transcribed from C-R7. That record is not this
  document's, so its change is raised on `docs/architecture_open_issues.md` § 2.1 (commit
  `a8b662e`) and not written here. QC-24 is already false against the built bridge, which exports
  `nozoki_free` (`exports.rs:L61`), and whose export test admits it (`tests/exports.rs:L17`).

  *Check 4.* Four cases:
  - **Absent:** a build that exports no release function fails SM-4's return rule. After the fold
    it also fails C-R7's set equality, which is what should happen.
  - **Stale:** `ADMITTED` in the export test is a hand-kept array. It lists the permitted set, not a
    copy of the exported set, so C-R7's "never a hand-kept copy" is still met.
  - **Concurrent:** the rule is untouched. A buffer is freed once, by its owner (R-13).
  - **Not covered, named:** only `nozoki_free` is admitted beside the list. SM-4 says
    `model_changed` crosses up to the shell, but it names no function for the shell to register
    the callback with. A slice that needs one has to export a second plumbing function, and this
    answer does not admit it. Under the prompt's rule that a widening waits until it occurs, that
    is raised when `follow-the-folder` needs it, and not before.

  *What would have tipped it.* The item's own doubt, that a tenth list member "would also work", is
  what I was closest to. Two things would have tipped me to it: a record already counting the
  function as a member, or a surface depending on it. Neither exists. ADR-0013 and ADR-0016 both
  count it outside, and it carries no surface.

### 5.2 — The Swift-frame paragraph says no Swift packet exists and that the card still owes Swift; both are now false

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** The item states two facts and then asks its real question: whether *Kind* and the
  frame's layout still hold with a packet behind them. Its "owed a re-read" restates that question
  and is not a draft, so I answered it from scratch. Both still hold. The paragraph around them is
  owed a correction, because it states two things that are now false.

  *The facts, checked at their source.* The registry carries `languages/swift/` with the six files
  the item names. Listed this run at the pinned core, the packet landed at
  `kensaiapp-dev@3ab2e8553` on 2026-09-23. The project card reads `Languages: Rust, Swift, Shell`,
  and its test command ends `swift test --package-path nozoki-mac` (`project.md:L7-L8`, moved at
  `kensaiapp-opensource@5b27023`). `nozoki-mac/` holds `Package.swift`, `Sources/` and `Tests/`,
  first added at `nozoki@3e470bd` by the developer, by hand. So `SDD.md:L397-L402` states two
  falsehoods. It says no packet exists, and it says the card is still owed a change it has already
  taken. That is the prompt's strongest ground for reopening a document, a fact now false, and it
  needs no further argument.

  *Kind.* The template says *Kind* takes "the word that language's own packet uses for a buildable
  unit" from its `layout.md` (`sdd_template.md` § 3). The Swift packet's `layout.md` names the
  unit a package throughout, starting with "SwiftPM finds a package's targets by directory". The
  Swift skeleton tree's README reads "When the product's SDD § 3 names this tree's unit as a
  `package` at some path, the launcher copies the tree to that path." So `package` is now the
  packet's word, not just SwiftPM's, and the cell stays.

  *The frame's layout.* The question has two layers, and only one is § 3's. § 3 says where the
  frame lands (`nozoki-mac/`) and that it holds `Package.swift`, `Sources/` and `Tests/`. The
  packet's tree matches that, and so does the built one. How the package is laid out *inside* is
  a different layer: its test framework, its link route for the bridge, its tools version, its
  test-target names and its warnings level. That belongs to the packet and to `docs/nfdr.md` § 9,
  because the project's precedence puts the records above a packet. The five departures are
  already raised at `docs/architecture_open_issues.md` § 3.4. So § 3 gains no layout sentence.
  Adding one would be a second home for what § 9 records.

  *What the fold owes.* Three sentences:
  1. **§ 3's paragraph.** Drop the "no Swift packet" sentence and cite the packet for *Kind*. The
     launcher clause becomes history: the frame was laid out by hand in `open-a-folder`. The
     card's "owed" clause becomes the fact that it carries `Swift` and `swift test`.
  2. **§ 10 RC-3's *Still unresolved*** (`:L2312-L2313`), which still names the card as owed. It
     keeps its words and gains a dated parenthesis, as RC-1 and RC-2 did.
  3. **RN-60's closing clause.** It is history and keeps its words, with a dated parenthesis in the
     shape RN-55 set.

  *Check 3.* No part, seam, slice or edge moves. `checks` stays `directory`, since the Shell packet
  still has no `layout.md`. `docs/nfdr.md` § 9 and ADR-0016 carry the same false premise, and that
  is raised on the architecture companion (§ 3.4). The SDD does not write it.

  *Check 4.* Stale is the case that matters here, and it is why the paragraph must stop stating a
  registry listing as a fact. A dated listing ("listed 2026-09-23") goes stale the day the registry
  moves, and this item is the proof. The fold cites the packet's path and the commit that landed
  it, which stay true.

  *What would have tipped it.* One thing would have made me change *Kind*: a different word in
  the packet's `layout.md`, such as "target" for a buildable unit. The packet uses "target" for
  what lives *inside* a package, so it did not.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

- **docs/architecture_open_issues.md** — **appended** — companion to `adr/` and `nfdr.md`, item
  `2.1` (QC-24 owed `nozoki_free` beside SM-4's list), landed in commit `a8b662e`

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
- **`docs/SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh nozoki`
