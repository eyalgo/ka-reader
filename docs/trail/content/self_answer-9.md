# Self-answer report — `docs/CONTENT.md`

## Header

- **Companion:** `docs/CONTENT_open_issues.md`
- **Document:** `docs/CONTENT.md`
- **Decided by:** `companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-04
- **Sources re-read:** `system/experience/voice_restrictions.md`, `system/experience/voice_direction.md`
  and `system/doctrine/writing_bar.md` in kensaiapp-opensource, the instance whose verbal rules bind
  this product. Answer 3.1 rests on there being no rule against a dash or about punctuation marks in
  them. Searching all three for *dash*, *em-dash*, *punctuation* and `—` as a mark found no rule: the only `—`
  hits in `voice_restrictions.md` are in its own prose (`:L56`, `:L112`). No source outside those three
  was needed.

The companion held two open items, §§ 3.1 and 3.2, both raised from downstream by the PM on
2026-10-04. §§ 1 and 2 read "None.". This run answered both and raised nothing.

## Items worked

### 3.1 — No rule for the mark that joins a name to a word in a label that is not a sentence

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the verbal language
- **Verdict:** answered
- **Why:** Answered from scratch: a space, U+2014 and a space, the name first and the word last,
  confirming what ships. The item arrives with a "likely fold" and no decision, so it is read as a
  question and not as a draft to confirm.

  *Is it widening, and does it cite an occurrence?* It widens the document, since § Grammar and
  mechanics states no joining mark (`docs/CONTENT.md:L113-L127`). It cites its occurrence: six shipped
  strings, `"\(name) \u{2014} <word>"` at `ka-reader-mac/Sources/Surfaces/GitSentences.swift:L114-L119`.
  I re-read them. So it is taken for that shape. The item's "any later label that joins a name to a
  word" reaches further than anything cited, so a label of another shape (the word first, two words,
  a count beside the name) is answered "not until it occurs".

  *Seat (check 1).* Ours. The edit lands in `CONTENT.md` and binds only its wording. It commits
  nothing to a person or an outside party, and no ground I cannot see is in play. `docs/DESIGN.md:L661`
  already says "the joining mark and the letter's word are always drawn whole" and names no mark, so
  the answer completes a sentence the design language left to this document and moves nothing there.
  I did not split it: *which mark* and *which labels it governs* are one question with one seat.

  *The answer, and what the fold writes.* One line in § Grammar and mechanics: where a label puts a
  name taken from the folder before a word KA-Reader writes, the name is the row's own text, unchanged,
  then a space, U+2014 and a space, then the word, and the label carries no full stop. A label carries
  none already (`docs/CONTENT.md:L113-L115`), and the tooltip is a label, not a sentence, which is why
  § Localization's "one whole sentence" does not apply to it and "six whole strings with one
  placeholder each" (`GitSentences.swift:L110-L111`) does. Why this mark and not another: it is the
  one dash KA-Reader's own writing already uses (`ConditionSentences.swift:L23`;
  `docs/CONTENT.md:L287-L288`), so it adds no second mark. Names in this repository already carry
  hyphens (`ka-reader-mac`, `self_answer-8.md`), so a hyphen or an en dash would not read as a join. A
  colon after a path is how tools print one, and I judged the reader would read it that way. A bare
  space and parentheses do not separate a name from a word at a glance. A verb is out for the item's
  own reason: *conflict* is a noun and the other five words are participles
  (`GitSentences.swift:L100-L105`).

  *Check 3.* Nothing settled moves. § Grammar and mechanics' full-stop, ellipsis and exclamation
  rules do not mention a dash, and the instance's voice and writing-bar files hold no rule against
  one (see **Sources re-read**). I read my own answer to § 3.2 alongside it: the name is drawn in the
  design language's one type and never quoted, so the line is "name, mark, word" in one font, and the
  two were decided together. One detail for the fold: the Git view's row prints a folder-relative path
  and the tree row prints a name (`GitView.swift:L111`, `RootItemsView.swift:L212`), so the rule says
  "the row's own text" and not "the file's name".

  *Check 4, the failure paths.* **Empty:** a row always has a name, so no label is empty. **Long:**
  the tooltip narrows and the name loses its start while the mark and the word stay whole, and that
  is the design language's (`docs/DESIGN.md:L655-L661`). **Concurrent:** a path listed twice gives
  each row its own label (`GitView.swift:L100-L102`), so the rule has one name and one word per label.
  **Absent and stale:** the label is built from the row's current state when it is raised, as the
  six strings are, so the rule adds no case. **Not covered, named:** a name holding a right-to-left
  script beside the Latin word, where how the mark sits is the platform's drawing and not a wording
  matter; no cited site shows one. A name that itself contains a spaced U+2014 reads correctly
  because the word is always last.

### 3.2 — Whether "a name from the folder is set in the path type" reaches into the tooltip

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the verbal language
- **Verdict:** answered
- **Why:** Answered from scratch: it does not reach the tooltip, and the clause is narrowed so this
  document names no type for a name. The item states a "likely fold" and no decision, so it is read as
  a question.

  *Is it widening?* No: it asks whether an existing rule reaches a case, and the answer corrects a
  statement the document makes, which is not widening. Its occurrence is the tooltip's own name
  (`LetterTooltip.swift:L48`, `:L64`).

  *Seat (check 1).* Ours. What the verbal standard owes is whether its own rule reaches here. The
  type itself stays the design language's, and the answer does not change it. Had the answer been
  that the name owes the path type, a `DESIGN.md` item would have followed. It is not, so none is
  raised.

  *The answer, and what the fold writes.* `docs/CONTENT.md:L126-L127` says a name from the folder "is
  set in the path type rather than quoted". That states a type on surfaces where the design language
  draws another. The tooltip is `{typography.ui}` whole (`docs/DESIGN.md:L649`); tree rows, Git rows
  and status messages are `{typography.ui}` (`:L461-L462`, `:L760`); `{typography.path}` is the open
  file's path line, a link's destination, commit identifiers and branch chips (`:L468-L470`). The
  shell draws the tooltip in one font (`LetterTooltip.swift:L48`, `:L64`), and names inside
  `ConditionSentences.swift`'s sentences sit in the status message's one type the same way. So the
  clause is narrowed, not given a carve-out for the tooltip: a name taken from the folder is never put
  in quotation marks, and the type it is drawn in is `docs/DESIGN.md`'s (§ Typography). That removes a
  value this document copied from the design language and got wrong, which the Content Manager loader
  names as a defect of whichever document copied it. The quotation-mark half is kept, because that is
  the half that is this document's.

  *Check 3.* It agrees with `docs/DESIGN.md:L468-L470` and `:L649`, and with the rule that bars a
  quotation mark around a name nowhere. It keeps `docs/CONTENT.md:L41-L45`: the name is the reader's
  text and KA-Reader neither corrects nor restyles it. Decided with § 3.1.

  *Check 4, the failure paths.* **Stale:** if the design language later draws a name in the path type
  somewhere, this document stays true, because it names no type. **Long name:** the cut at the start
  is the design language's, and the type does not change it. **A name holding quotation marks:** it is
  shown as it is, per `docs/CONTENT.md:L41-L45`. **Not covered, named:** whether the file tree's names
  should be drawn in the path type is a design question this item does not ask, and no cited site
  asks it.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/CONTENT.md`** — `/Users/eyalgolan/.kensaiapp/pins/20261004T163836Z-cntntx/core/launchers/skill/launcher.sh product-content ka-reader`
