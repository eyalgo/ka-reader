# Self-answer report — CONTENT.md

## Header

- **Companion:** `docs/CONTENT_open_issues.md`
- **Document:** `docs/CONTENT.md` (Settled, v6)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-25
- **Sources re-read:** None. No answer this run rests on a source outside this repository. Every claim
  it leans on is in the product on disk: `docs/CONTENT.md`, `docs/fdr.md`, `docs/SDD.md`,
  `docs/UXD.md`, `docs/DESIGN.md`, `README.md`, `nozoki-mac/Sources/Surfaces/ConditionSentences.swift`
  and `crates/nozoki-core/src/fs_reader.rs`, read at `nozoki@4c59262`.

## Items worked

### 3.1 — A tree row for a link that cannot be followed has no sentence in the verbal language

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the verbal language
- **Verdict:** answered
- **Why:** The verbal language takes all four cases. Two keep the shell's sentence and two are
  replaced. The item hands over the four sentences the shell ships without proposing them as the
  answer (*"Whether these are the product's words is the verbal language's call, and it has not made
  it"*). So nothing arrived as a draft to confirm, and the verdict is *answered*. I weighed the
  shell's sentences as material, one at a time, against the rules `docs/CONTENT.md` already states.

  **It is not held as "not until it occurs".** The item widens the document, because it asks for cases
  § Message patterns does not state. It also cites an occurrence, which is a site in the product as it
  stands: `nozoki-mac/Sources/Surfaces/ConditionSentences.swift:L18-L25` on `main`. I checked the site
  at `nozoki@46bb275`. All four conditions come from the core's `Condition` enum
  (`crates/nozoki-core/src/fs_reader.rs:L21-L34`), and each one is exercised by a test
  (`crates/nozoki-core/tests/tree_links.rs`). The prompt's bar is met, so the item is answered on its
  merits.

  **Check 1: mine, in the owner's seat.** The edit lands in `docs/CONTENT.md` § Message patterns,
  § Terminology, § Accessibility of text and § Traceability, all of which are this document's own.
  The answer binds no person, money, legal position or outside party. The owner has reserved no taste
  over tree-row wording, and I can name no ground I cannot see. `docs/fdr.md` R-33 already says the
  row is *"marked with what the product observed"*, so the product decision is made, and only the
  words are open. They are this document's.

  **Check 2, sentence by sentence.**
  - *Loops*: *"This link loops back on itself, so Nozoki can't read it."* **Taken as written.** It
    states what fs-reader observed, which is the `Cycle` condition. Its *can't read* matches R-152's
    *"an entry that cannot be read"*. It uses a contraction, ends in a full stop, and contains no
    banned word.
  - *Missing target*: *"This link leads to something that isn't there."* **Taken as written.** It is
    a fact about the folder rather than about Nozoki, the same shape as *"This file is no longer in the
    folder."* It ends at the observation, which is where the § Voice guidance tells a sentence to end.
  - *Outside*: **replaced** with *"This link leads outside the folder you opened, so Nozoki doesn't
    read it."* The shell's sentence fails on two grounds:
    - *This folder* is ambiguous on this surface. The Partial example on the same tree row,
      *"Nozoki can't read this folder."*, uses *this folder* for the row itself. The outside sentence
      uses it for the opened folder. A sub-folder's link can leave its parent and still stay inside
      the opened folder, and R-34 reads that link as its target. So *this folder* is exactly the
      distinction the reader needs made. *The folder you opened* names the reader's own act: the
      folder is chosen in the Open panel.
    - *"Nozoki reads nothing outside it"* is wider than true. Nozoki reads its own remembered state,
      which lives *"in the tool's own state — never in the folder"* (`docs/UXD.md` UX-I9), from
      outside the folder. That is the RN-16 failure shape: a sentence about the tool that claims more
      than holds. *Doesn't read it* is scoped to the link. It matches R-34's *"presented as an entry
      that cannot be read"*, and it is honest that this is Nozoki's rule rather than an inability. For
      that reason it says *doesn't*, not *can't*.
  - *Too many links*: **replaced** with *"This link leads through more links than Nozoki follows."*
    *"Too many other links"* judges the reader's own links by the tool's limit. The *Strict* row of
    § Voice forbids describing the reader's material by its failure to satisfy the tool. The
    replacement puts the limit on Nozoki, where it belongs. It states no number, for two reasons. No
    document fixes the bound: `docs/SDD.md`, `docs/fdr.md` and `docs/nfdr.md` carry no hop count, and
    the 32 is the constant `MAX_LINK_HOPS` at `crates/nozoki-core/src/fs_reader.rs:L56`. And § Grammar
    and mechanics, *Numbers*, holds that every number the product shows is counted from the folder,
    which this one is not. It ends without *"so Nozoki can't read it"*. The row's failure mark already
    carries that, and adding the clause would put *Nozoki* in the sentence twice.

  **The item hides a second question with the same seat, so both are answered in the one slot.**
  Taking these sentences brings the word *link* into the product. The reading bar in § Accessibility
  of text admits only three sources: a word `README.md` uses, a name from the reader's folder, or a
  word Git uses for the state being reported. *Link* is in none of them. `README.md` contains *link*,
  *links*, *loop*, *leads*, *follow* and *many* zero times (`grep -o -i -w` on 2026-09-25). And the
  state reported is how the filesystem resolves a link, not Git's state. The document's own settled
  Partial example has the same problem: *image*, *loaded* and *fetches* each appear zero times in
  `README.md`. So the bar as written already contradicts its own example, and the fold cannot take
  these sentences without resolving that. The answer:
  - § Terminology gains **link**. *Symlink* is rejected as an abbreviation the product never expands,
    the same ground as *repo*. *Alias* is rejected because on macOS it names Finder's own, different
    thing.
  - The bar gains a fourth source, *a word § Terminology fixes*. That keeps it checkable against one
    string plus this document, which is RN-11's test.
  - The Partial examples are checked against the widened bar in the same pass.

  I weighed whether to split this out as a separate item. It is not a split, because both halves are
  this seat's, and the prompt's *"A second question with the same seat"* answers both in the one slot.
  It is also not a separate *Raised on this document* item, because the sentences this item asks for
  are what force the change. I was closest to raising the image-example contradiction on its own. What
  tipped it into this answer is that the fold edits the bar anyway, and a second item would send the
  same rule through the round twice.

  **Check 3, against what is settled.**
  - `docs/SDD.md` § 4 C-E4 requires every message to carry what to do next, or to say that the route
    out is the surface's own, *"named in the sentence only where it is not already on screen"*. On a
    tree row the rest of the tree is on screen, so none of the four names a next step. That is also
    the precedent the existing *"Nozoki can't read this folder."* sets.
  - `docs/fdr.md` R-33, R-34 and R-152 fix the state. The words state the observation R-33 asks for
    and add nothing to it. The too-many-links case has no FDR rule of its own, and R-33 covers it
    generally, so `docs/fdr.md` is owed nothing.
  - `docs/DESIGN.md` § Components "Status messages" lists *an unreadable entry* as a failure status
    message led by `circle-alert`, and the words are this document's. Nothing there moves.
  - Localization: each is one whole sentence, with no placeholder and no English-only grammar.
  - Grammar and mechanics: sentence case, contractions, a full stop, and no exclamation mark.
  - § Terminology *Banned*: none of the listed words appears.
  - There were no earlier answers this round to contradict.

  **Check 4, on the failure paths.**
  - *Stale*: a link that is fixed, retargeted or removed while the folder is open is re-read by live
    refresh. Its row sentence then changes to the new condition or disappears, and nothing announces
    it (§ Message patterns *Recovered*). Covered.
  - *Refused*: an outside link whose target the operating system would also refuse still reads
    *outside*. fs-reader never asks the operating system (`fs_reader.rs`, `OUTSIDE_TEXT`), so the
    sentence stays true. Covered.
  - *Concurrent*: two conditions on one chain, for example a loop that also passes the hop bound. The
    core reports one `Condition`, and the sentence follows it. Covered by construction.
  - *Empty* and *absent*: the root's own empty and failed lines are separate strings
    (`ConditionSentences.failedRoot`, `emptyRoot`). They are not this item's. Not reached, and not
    owed.
  - **Named and not covered:** `docs/DESIGN.md` says a tree row *"never wraps; it clips at its end"*
    (`:L593`), while this document says a status message is *"never text in a row that clips"*
    (§ Localization). Whether the shell's condition label clips on a narrow sidebar is the design
    language's and the shell's question, not this item's. The four sentences lead with what was
    observed, so a clipped end loses the least. The contradiction is between two documents about
    drawing, and the tree-row example predates this item. I did not raise it.

  **Supporting text.** The item's text checks out. The four quoted sentences match `:L18-L25`, the doc
  comment calling them provisional is at `:L4-L5`, and the cited `docs/CONTENT.md` lines match. Nothing
  was misstated.

## Left for the owner

None this run.

## Skipped

None this run. The companion carried one item, and its slot was at its placeholder. Sections 1 and 2
read "None."

## Companions opened

None this run. Every change this answer calls for lands in `docs/CONTENT.md`, and `docs/fdr.md` is
owed nothing (Check 3 above).

## Launchers owed

- **`docs/CONTENT.md`** — `<CORE>/launchers/skill/launcher.sh product-content nozoki`
