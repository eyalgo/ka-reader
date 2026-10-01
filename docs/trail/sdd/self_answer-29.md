# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (Settled, v22)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-01
- **Sources re-read:** One source outside this repository: the Cargo registry copies of the eight
  crates the engine is taken in as (`~/.cargo/registry/src/*/<crate>-<version>/Cargo.toml`, the
  versions `Cargo.lock` resolves). Each one's `license` field reads `MIT`: `tree-sitter` 0.27.0,
  `tree-sitter-highlight` 0.27.0, `tree-sitter-python` 0.25.0, `tree-sitter-bash` 0.25.1,
  `tree-sitter-javascript` 0.25.0, `tree-sitter-json` 0.24.8, `tree-sitter-yaml` 0.7.2 and
  `tree-sitter-toml-ng` 0.7.0. That matches the licence column of `checks/deps.review.md` for those
  eight rows. No vendor page was needed for any answer here. Everything else was re-read in the tree
  on `main` at `nozoki@0297c13`: `checks/deps.review.md:L8-L16` (§ *The engine chosen*);
  `git show --stat 85d9fa7` (`Cargo.lock`, `checks/deps.allow`, `checks/deps.review.md` and
  `crates/nozoki-core/Cargo.toml` in one commit, the manifest gaining the eight crates above);
  `git diff 85d9fa7 HEAD -- checks/deps.review.md` (two table rows reworded, § *The engine chosen*
  untouched); `crates/nozoki-core/src/highlighter.rs:L1-L11` and `:L120-L166`; `cargo test --locked
  -p nozoki-core --test highlight` → `18 passed; 0 failed`; `bash checks/no-network.sh` → `ok — 40
  cargo names match checks/deps.allow`; `comm -3` between the allowlist's `cargo:` section and the
  record's first column prints nothing; `cargo tree --offline --locked -i cc` shows `cc` as a build
  dependency of `tree-sitter` and of each grammar crate.

## Items worked

### 5.1 — The grammar-engine question is answered on the tree and still open in the SDD

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The question closes, and the SDD names the engine and cites the record. The engine is
  tree-sitter. The item is a downstream one and carries no seat's draft, but it carries its own
  proposal: "The item should close, citing the review record. The `highlighter` row and S-2 should
  then name the engine, or the record". I treated that proposal as a draft and weighed it. It holds,
  and it is incomplete in three places, which are the additions.

  **The widening rule, first.** The item sits under the heading carrying *Raised from downstream*.
  It does not widen the SDD. *Open Questions* states that the engine is undecided
  (`docs/SDD.md:L4521-L4524`), and that statement is now false, so the item corrects a statement.
  It also cites its occurrence: a site in the product, `checks/deps.review.md` § *The engine chosen*
  and `crates/nozoki-core/src/highlighter.rs`, at `nozoki@85d9fa7`. Both were re-read and hold.

  **Check 1: the seat.** Every sentence the answer moves is in `docs/SDD.md`, in the CTO's lanes:
  *Open Questions*, the § 3 `highlighter` row, § 6 S-2's command half and § 10 RC-3. The answer
  binds no person, no outside party and no money. It changes nothing the product promises. The
  engine is a dependency, and the SDD already says who decides one: "Every dependency is a decision,
  and the tree is reviewed as code" (`docs/SDD.md` § 4 C-R6), with the allowlist change "reviewed in
  the same change". The open question itself handed the decision down: "Settled in `read-a-file` by
  the dependency review that change carries under C-R6". That review happened, in that slice, in one
  commit with the lockfile. So the decision was made by the seat the SDD named, and what is left is
  for the SDD to record it. I can name no ground I cannot see. The item is mine in the owner's
  seat, and the answer goes in the slot.

  **Check 2: the draft.** Every claim in the item's supporting text was re-read and is right: the
  quoted question, the two places that point at it (`:L327`, `:L1482-L1484`), the record's section,
  the commit, the 20 names the record marks "added by this change", and the 18 passing tests. The
  item holds two questions, whether the open question closes and what the two pointers say
  afterwards. Both have the same seat, so it is one item answered on both. The draft leaves the
  second one as a choice, "the engine, or the record". The answer is both, each in its place. The
  row names the engine because the question a reader brings to § 3 is "which engine", and § 3
  already works that way: the `git-reader` row names libgit2, and § 6 S-3 says the `surfaces` row
  "names the layout form found". The citation is to the record because the record owns the
  reasoning and the review, and the SDD does not copy either.

  **The three additions.**
  1. § 10 RC-3's *Still unresolved* points at this question as well: "How TextKit lays out UX-I12's
     two hard cells, and which engine compiles the six grammars (*Open Questions*)"
     (`docs/SDD.md:L2444-L2445`). The item lists three places and this is a fourth. It keeps its
     words and gains a dated parenthesis. That is what RN-48 did for RC-1 and RN-70 for RC-2 and
     RC-3 when their questions closed, and RN-70 gives the reason: the "pointer would otherwise
     lead a cold reader to nothing".
  2. The SDD states no count and no version for the engine. The item's text says the record "names
     the 20 names that engine adds", which is true of the record. Copied into the SDD it becomes a
     second home for a number that `checks/deps.allow` owns, and it is false at the next dependency
     change. The NFDR's QC-3 is on the architecture companion today for exactly that: a "17 names"
     that the tree outgrew (`docs/architecture_open_issues.md` § 3.1).
  3. The fold's Review Note carries the why by citation. The SDD's own rule is that everything the
     upstream documents did not settle carries its why in the Review Notes. The why exists already:
     the record says hand-written lexers "would put six grammars' worth of lexing in the core" and
     that `syntect` "needs vendored Sublime syntaxes for TOML" (`checks/deps.review.md:L14-L16`).
     The note points there, and the fold re-weighs nothing.

  **Check 3: against the settled record.**
  - `docs/PRD.md` § Core Features names the floor as Python, shell, JavaScript, JSON, YAML and
    TOML. The six grammar crates are those six. The PRD names no engine.
  - `docs/SRS.md` FR-8 and FR-29 name no engine. C-4 and C-5 bind the licence and the third-party
    notices. All eight engine crates are MIT, re-read at the registry (the header above).
    NFR-8 binds no network call: the record finds no transport in any of the 40 names, and
    `checks/no-network.sh` is green. NFR-16 binds that content is displayed and never executed: a
    parser reads the file as data, and `highlighter.rs:L4-L7` says the module reads no file, no
    environment variable and no network.
  - `docs/UXD.md` names no engine. § 9 holds syntax highlighting as a domain expectation.
  - `docs/SDD.md` § 3 `highlighter`: "the six grammars compiled into the library" and "A seventh
    grammar with no floor language behind it" in *Must not own*. Six grammars are compiled in.
  - § 3, the units paragraph: `crates/nozoki-core` "holds no `unsafe`". `highlighter.rs` holds none.
    The engine's own C and Rust are a dependency's, which is C-R6's subject and not that sentence's.
  - § 4 C-R6: the lockfile, the allowlist and the review landed in one commit. § 4 C-R1: "the six
    grammars compiled into the library" ships in the bundle. § 4 C-I5: the extension set is
    untouched. All three stand as written.
  - § 5 step 4 E-3's "third item", § 6 S-3's "the third Open Question" and § 6 S-4's "the second
    Open Question" keep their ordinals. The removed item is the fourth, and the three after it are
    cited by name or not at all. RN-70 made the same check when the seventh item went.
  - § 9 TO-2 calls libgit2 "A native C dependency". The engine is a second one, and it arrived
    first. Nothing in § 9 says libgit2 is the only one, so nothing is contradicted.
  - `docs/fdr.md` RN-17 (`:L411`) lists "which grammar engine compiles the six floor grammars"
    among the SDD's standing questions, in a re-read dated 2026-09-23. It is a dated note, it says
    "Each of those five is mechanism", and no FDR rule turns on it. The FDR is owed nothing.
  - `docs/nfdr.md` QC-3 is already raised at `docs/architecture_open_issues.md` § 3.1, a live
    companion. That item's slot is not mine to fill and nothing is appended there.
  - This run's raised item 2.1 and the companion it opened on the UXD touch other sections and
    another document. Neither bears on this answer.

  **Check 4: the failure paths.**
  - **Empty.** An empty text and a *plain* file give no spans (`highlighter.rs:L95-L103`). The
    answer says nothing those cases contradict.
  - **Absent.** A grammar's query that the engine refuses gives no spans and a log line, never a
    panic (`highlighter.rs:L72-L75`, `:L170-L181`). If `checks/deps.review.md` is later renamed, a
    citation by path alone dangles, which is why the fold cites it with its section and commit.
  - **Stale.** A version bump leaves the SDD true, because the SDD states no version. A swapped
    engine is a new dependency decision under C-R6 and moves the row at the SDD's next revision.
    That is the reason for addition 2.
  - **Concurrent.** `product-architecture` folds QC-3 from the same record, in either order. The
    two folds do not depend on each other: this answer moves no § 4 condition, so the NFDR
    re-derives nothing from it.
  - **Refused.** If the fold's seat wants a different engine, that is a change under C-R6, with its
    own review. The fold records what the tree holds.
  - **Not covered.** A hostile file fed to a C parser inside the one process. § 11 R-4 names the
    image decoder and the Markdown document, and its response, a crash "inside a process that
    cannot write or connect", reaches a parser by the same reasoning. The SDD does not say so. No
    crash is cited, and the highlighter's tests feed it deep nesting and every fixture as every
    language. So the answer asks for no § 11 row, and names the gap in the slot. The same holds for
    a § 9 row on what the engine costs. Either is the seat's to add at the fold.

  **What I did not measure.** Two other open questions name `open-a-folder`, a slice that has
  landed, as what settles them: the Dock-icon and *Open With* question, and the form
  `open_folder`'s argument crosses the bridge in (`docs/SDD.md:L4508-L4510`, `:L4525-L4530`).
  Whether either is answered on the tree was not checked. Each needs the built bundle tried by
  hand, and no record of that was looked for.

  **What was close.** Citing the record alone and leaving the engine's name out of § 3. That keeps
  one fact in one file, which this instance's single-source rule favours. What tipped it is § 3's
  own practice of naming the mechanism in the row, and that the question was "which engine": a
  reader who asked it in § 3 gets the answer there. The other close call was leaving the item for
  the owner, since the choice doubles the dependency list, from 20 names to 40. It stays with the
  seat because C-R6 and the open question both put it there, the licences are all permissive, and
  the review finds no transport. A copyleft licence among the names, or a crate that links a
  transport, would have made it the owner's.

## Left for the owner

None this run.

## Skipped

- **`checks/deps.review.md`** — a document with no companion template on disk, so nothing is
  opened on it. Its line 14 cites `docs/SDD.md:L4521-L4524` for the open question, with no commit.
  The citation is true at `nozoki@85d9fa7` (`git show 85d9fa7:docs/SDD.md | sed -n 4521,4524p`
  prints the question). It stops opening on the question once `product-sdd` removes the item. The
  file is the delivery tier's.

No slot was already filled when the run reached this file, and no item was addressed to another
actor.

## Raised on this document

### 2.1 — § 12 names two debts to the NFDR and ADR-0016 as open, and both are paid

- **What the document is owed:** A dated parenthesis on § 12's downstream-boundary sentence
  (`docs/SDD.md:L2660-L2666`), saying that both things it calls owed were folded and where the two
  companion items it cites now stand. The same on § 12's UXD-boundary sentence
  (`:L2620-L2625`), which quotes a `docs/DESIGN.md` sentence that document no longer has.
- **Why it is worth a cycle:** *A fact in it is now false* — a claim about another document
  (`decide_companion_answers.md` § *The items are not the whole of what a document is owed*). The
  measurements, on `main` at `nozoki@0297c13`:
  - § 12 says "`docs/nfdr.md` QC-24 still holds the export set inside the list alone". QC-24 reads
    "inside the closed list `docs/SDD.md` § 3 `SM-4` names … and `nozoki_free`, the seam's one
    release call beside the list and not on it" (`docs/nfdr.md:L368-L374`).
  - § 12 says "`docs/nfdr.md` § 9 and ADR-0016 still say none exists", of the Swift packet. § 9
    takes `nozoki-mac`'s tooling "from the Swift packet" and says "Through v12 this paragraph read
    that no Swift packet existed … true when written, and history" (`docs/nfdr.md:L926-L932`).
    ADR-0016 carries the same correction, dated 2026-09-23 (`:L44-L49` of that record).
  - § 12 cites `docs/architecture_open_issues.md` § 2.1 and § 3.4 for the two. That file holds
    "None." under § 2 today and has no § 3.4. The two items stand at
    `docs/trail/architecture/cycle-10.md` § 2.1 (`:L29`) and § 3.4 (`:L121`).
  - The UXD-boundary sentence quotes DESIGN's § Overview as "realised in plain CSS custom properties
    over the product's own markup". `grep -n -i "plain CSS" docs/DESIGN.md` prints `:L855` and
    `:L1348`, and `:L855` reads "Revisions 1–10 read *plain CSS custom properties* here". This half
    is the weaker case: the sentence says what the exit moves, which is still true, and RN-75
    already records the move. The font-stack syntax and DESIGN's RN-1, which the same clause
    names, were not measured.

  A reader of § 12 is the Principal Architect, and the first sentence tells that reader two things
  are owed which are done. The PM raised the same defect against the NFDR's QC-3 today.

  **The doubt, stated.** This document has repaired "still" sentences like these inside a fold with
  no item (RN-56, RN-61). A reader could hold that an item is more than the defect is worth. I
  raised it because the companion is already open, so the item costs no round of its own, and
  because no fold is certain to walk § 12. Its slot is at its placeholder, and the decision is the
  next round's.

## Companions opened

- **`docs/UXD_open_issues.md`** — **opened** — companion to `UXD.md`, item 2.1 (UX-U1 states the
  reader floor as "can find their way around a repository on GitHub … no Git knowledge beyond
  that", and the PRD section it traces to replaced that floor at v9), landed in commit `b811cc8`

  **Why it was opened.** The UXD is an input of the SDD, so it was read whole for § 5.1. No item
  routed there. The ground is *It contradicts a document it must agree with*, and *Something
  upstream moved and it has not seen it* (`decide_companion_answers.md` § *The items are not the
  whole of what a document is owed*). The measurements:
  - `docs/UXD.md:L49-L51`: "Expertise floor: can find their way around a repository on GitHub and
    follow a README — no editor experience, and no Git knowledge beyond that", traced to PRD
    § Goals "No learning curve".
  - `docs/PRD.md:L96-L103`: "anyone who works with Git and can follow a README can use Nozoki: the
    reader is assumed to know Git", marked as superseding the GitHub floor on the owner's answer at
    `docs/trail/prd/cycle-8.md` § 1.1. That answer quotes the owner: "Remember, users of nozoki most
    likely know how git works."
  - The PRD carried the new floor from v9 (`nozoki@a85bc24`, 2026-08-26), which is an ancestor of
    UXD v6 (`nozoki@dd08f2d`) and of UXD v10 (`nozoki@4d7b653`). No UXD review note records the
    floor being re-read.
  - `docs/SRS.md` NFR-15 (`:L383-L388`), `docs/fdr.md` R-144 (`:L261`) and `docs/CONTENT.md:L82`
    carry the new floor. `grep -n -i "works with Git" docs/UXD.md` prints nothing.

  The UXD was Settled with no companion, so it had no other channel. The item sits under
  *choices to confirm* with its slot at the placeholder. `UXD.md` itself is untouched.

  **The doubt, stated.** A round on the UXD costs a CDO run for one sentence, and the wording
  standard, `docs/CONTENT.md`, already carries the right floor. I opened it because the UXD is read
  cold by every change spec that touches a surface (`docs/UXD.md:L18-L21`), and UX-U1 is where such
  a spec takes its reader from. The owner replaced that floor in person.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh nozoki`
- **`docs/UXD.md`** — `<CORE>/launchers/skill/launcher.sh product-uxd nozoki`
