# Self-answer report — `docs/CONTENT.md`

## Header

- **Companion:** `docs/CONTENT_open_issues.md`
- **Document:** `docs/CONTENT.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-04
- **Sources re-read:** None. No answer this run gave rests on a source outside this repository. The
  letters' vocabulary (*modified*, *untracked*) is this repository's own, stated at
  `docs/DESIGN.md:L627-L643` and `docs/CONTENT.md:L422-L434`.

The companion held one open item, § 3.1, raised from downstream by the PM on 2026-10-04. §§ 1 and 2
read "None.". This run answered § 3.1 and raised nothing.

## Items worked

### 3.1 — The status letters and their words are stated for a changed file; the product draws them on folder rows too

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the verbal language
- **Verdict:** answered
- **Why:** Answered from scratch: the six words cover a folder row exactly as written, a folder takes
  no word of its own, and `CONTENT.md` says so in the two places that state the letters. The item
  arrives with a "likely fold" and no decision, so it is read as a question and not as a draft to
  confirm.

  *Is it widening, and does it cite an occurrence?* It widens the document: both statements of the
  letters (`docs/CONTENT.md:L145-L147`, `:L422-L424`) say "beside a changed file", and § Terminology
  defines **changed** for a file. The occurrence bar (`pm_shukuba_refine.md` § A gap is carried only
  where it occurs) is met by the item itself, and I re-read the sites. The production code sets a
  letter on every row by its path and not by its kind: `ka-reader-mac/Sources/Surfaces/RootItemsView.swift:L470`
  calls `markers.category(forRowPath: row.entry.path)`, and `TreeMarkers.swift:L31-L33` says the entry
  wins "whatever the row's kind (CP-574)". The tests show the two forms the item names:
  `ka-reader-mac/Tests/SurfacesTests/TreeMarkersTests.swift:L69-L77` marks a submodule `sub` as modified
  and a nested repository `inner/` as untracked, and
  `ka-reader-mac/Tests/SurfacesTests/WorkbenchTreeMarkerTests.swift:L110` and `:L168` carry the same two
  rows end to end as **M** and **U** in the file tree. So the item is taken for those two forms and
  not answered "not until it occurs".

  *Seat (check 1).* Ours. The edit lands in `CONTENT.md` and binds only its wording. Whether the
  product draws a letter on a folder row is not in question, since the code already does, so the item
  asks no product-meaning call of the CPO. It commits nothing to a person or an outside party. I did
  not split it: *whether the six words apply* and *which words a folder takes* are one question, since
  the second only exists if the first is answered no.

  *The answer, and what the fold writes.* The six words apply as written, because the letters mean
  the same thing on a folder row as on a file row. A submodule whose commit moved is **M**, and
  *modified* is what the reader's own tools call it. A repository nested in the folder you opened is
  **U**, and *untracked* is what they call that. A folder-specific word would be a seventh word for a
  distinction **M** and **U** already carry, and § Accessibility of text already says that wherever the
  product names these letters it uses these same six words (`docs/CONTENT.md:L433-L434`). The fold, for `product-content`:
  (1) § Grammar and mechanics' single-letter bullet and § Accessibility of text's letters bullet read
  "beside a changed file or a listed folder". (2) The expansion names the row, then the word, so for a
  folder row it names the folder and says *modified* or *untracked*. (3) § Terminology keeps
  **changed** for a file, and its Notes cell gains one sentence: a folder row's letter is worded by
  the six, and a folder is not called *changed*, because the term is defined for a file Git reports as
  different and a submodule's moved commit is not that.

  *Check 3.* The answer moves no settled sentence. It agrees with `docs/DESIGN.md:L627-L643`, which
  draws the letters and says the words are `docs/CONTENT.md`'s, and it keeps the "porcelain" ruling
  (`docs/CONTENT.md:L429-L434`): *untracked* for **U** is what the nested repository needs, and a
  porcelain reading would say the wrong thing about it. I read my own earlier answers: none in this
  round, since this is the only item. One narrowness found, not raised: `docs/DESIGN.md:L629-L630`
  says the letter trails "a changed file's name", and `:L646-L648` says the tooltip carries "the
  file's name". Both are true for a file and silent on a folder, and neither contradicts the fold,
  which makes the row's name the folder's. It is the CDO's text and the CDO's call, and it is not a
  fact now false, so it is not worth a cycle under the prompt's bar. What would tip it: a tooltip that
  needed words from `DESIGN.md` that the fold cannot supply.

  *Check 4, the failure paths.* **Empty:** a folder with no listed folder entry has no lettered folder
  row, and nothing is written. **Absent:** Git state not yet read gives no letter on any row
  (`RootItemsView.swift:L470-L476` clears it), so the six words never apply to an unread folder.
  **Stale:** the letter is whatever the last-read state lists for that path, as it is on a file row.
  **Concurrent:** a folder listed both changed and staged carries one letter, the changed one
  (`TreeMarkers.swift:L31-L33`, CP-577), so the tooltip has one word to say. **Beneath the folder:**
  the letter marks the listed row and nothing under it (`TreeMarkersTests.swift:L75-L76`, `inner/i.txt`
  and `inner/.git` unmarked), so the expansion speaks of the folder alone and never of the files
  inside it. **Not covered, named:** **A**, **D**, **R** and **C** on a folder row. The code would
  mark one (`TreeMarkers.swift:L31-L33`, whatever the row's kind), but no cited site shows one, so the fold states no word
  for those cases, and the rule "the six words, as written" is what a later site would fall under.
  That part of the item is answered "not until it occurs".

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/CONTENT.md`** — `/Users/eyalgolan/.kensaiapp/pins/20261004T144519Z-ahszka/core/launchers/skill/launcher.sh product-content ka-reader`
