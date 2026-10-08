# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (Draft, v4 — `ka-reader@683db69`)
- **Decided by:** `decide_companion_answers.md` v1.1.0
- **Date:** 2026-09-04

## Items worked

### 5.1 — Two sentences of this SDD cannot hold beside rules the owner confirmed on the FDR — `fs-reader`'s text rule omits UTF-16, and § 11 R-3's response names a folder to choose

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** Confirm — and the document has already done it. The item asked for two prose edits, each
  under a review note naming `docs/trail/fdr/cycle-1.md` as its authorization. `product-sdd`'s run 4
  made exactly those, at v4 (`ka-reader@683db69`): § 3 `fs-reader`'s text rule now admits a file
  beginning with a UTF-16 byte-order mark and decoding as UTF-16 beside UTF-8 with or without its
  mark, and states its own boundary — no detection from content, no third encoding, one undecodable
  sequence is not text, an empty file is text (`docs/SDD.md:262`, RN-41); § 11 R-3's response now
  names where the Git directory lies as what was observed, says this folder's Git state is therefore
  not read, offers no folder to choose, and leaves the tree and the reading panel unaffected
  (`docs/SDD.md:1867`, RN-42). I checked the fold against the owner's own answers rather than
  against the notes reporting it — the SDD now matches `docs/trail/fdr/cycle-1.md` §§ 2.4 and 2.7
  clause by clause and agrees word for word with FDR R-46, R-154, R-155 and R-21
  (`docs/fdr.md:101`, `:102`, `:103`, `:62`). Check 3 found no contradiction upstream: SRS FR-10
  names "binary or undecodable content" and fixes no encoding (`docs/SRS.md:189`), so widening the
  rule contradicts nothing the SDD derives from, and FR-29's "never refused" is what the widening
  serves. Check 4 walked the fold rather than the item: the empty file and the torn-mid-sequence
  file are both named in the rule and both fixtured in § 6 S-2's command half; the linked-worktree
  and submodule cases have a reducer case in § 6 S-4's command half (RN-44), because the harness
  runs in-process under no grant and cannot produce the real failure; and no residual v3 wording
  survives anywhere in the document — a grep for the old text rule returns nothing, and the two
  remaining "folder to choose" hits are the negation inside R-3 and RN-42's record of the removal.
  **The addition is in two parts, and it is why this is not a plain confirm.** (1) The fold reached
  further than the item's "two sentences, and no part, seam, slice, edge or place in the order
  moves". A *condition* moved and two *reached-whens* gained clauses: § 4 C-E4 was widened to name
  the terminal form a message's third part may take (RN-43), because R-3's rewritten response has no
  next step and C-E4 as written required one — a builder holding C-E4 alone would have written back
  the wording the owner overrode; § 6 S-2's command half gained the UTF-16, empty-file and
  neither-decodes fixtures (RN-41); § 6 S-4 gained the observable sentence for the case (RN-43) and
  the reducer case behind it (RN-44). The item's prediction held for parts, seams, slices, edges and
  the order, and not for conditions or reached-whens. That is the fold being right and the item
  having under-read its own blast radius, not the fold overreaching. (2) The item's supporting text
  is now stale, and I reported it rather than corrected it, per the prompt's § *The order you take
  them in*: its two locators (`docs/SDD.md:250`, `:1838`) and both quoted sentences are v3's.
  Nothing turns on the staleness — it is the item having been answered by the document itself
  between the run that opened it and this one.
  **What I was close to instead:** *confirmed*, plain. What tipped it is (1) — a reader taking the
  item's "nothing else moves" as settled would meet C-E4's change and RN-43's argument with no
  record of why, and the whole point of that change is that a condition read alone would have undone
  the owner's override.
  **The consequence for the round:** nothing remains for `product-sdd` to fold on this item's
  account. It may drop § 5.1 as resolved, which leaves the companion with no open item — and by the
  document's own version note (`docs/SDD.md:9-13`) the standing companion is the one thing holding
  `SDD.md` at Draft rather than Settled after three seats closed run 4 clean. What that means for
  the Status stamp is `product-sdd`'s own rule, not this run's to set.
  **On whether `docs/SDD.md` is owed a change no item raised:** it is not, and this was examined
  rather than skipped. Read whole, no fact in it is now false — its version note's account of run 4
  and of the standing companion is accurate as written, and RN-41's "the companion's § 5.1 … keeps
  its Answer slot for the owner, untouched by this run" describes run 4's own behaviour and stays
  true of it. Nothing upstream has moved since v4 that it has not seen, and it contradicts no
  document it must agree with — the check that would have found one is the same clause-by-clause
  comparison against the FDR that this verdict rests on.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

- **`docs/fdr_open_issues.md`** — **appended** — companion to `docs/fdr.md`, landed in commit
  `d347a63`

Why that raise was made, since no item asked for it. `docs/fdr.md` records the SDD contradiction as
live in three places that the SDD's v4 fold has closed: the version note's present-tense sentence
(`docs/fdr.md:5`), RN-7's present-tense claim about the SDD's wording against a live unpinned path
(`docs/fdr.md:396`), and R-21's *changed* / R-46's *added* relation marks to their SDD source
(`docs/fdr.md:62`, `:101`). RN-7 also carries the owner's call that R-3's wording be met at the SDD's
next revision, which has now been met with nothing there recording it. Two of the prompt's grounds,
and neither is taste — *a fact in it is now false*, RN-7 stating in the present tense that "the SDD's
response has the failure state 'naming the folder that would need granting'" against a path that no
longer reads that way at `docs/SDD.md:1867`; and *something upstream moved and it has not seen it*,
`docs/SDD.md` being R-21's and R-46's cited source and having gone v3 → v4 at `ka-reader@683db69`. The
consequence, not just the change: the FDR's traceability marks a departure from a source that has
caught up, so a builder or QA seat chasing it finds nothing at the other end and cannot tell a
resolved departure from an unrecorded one. The cycle it costs is one already owed — that companion
was standing with seven answered items and a `product-fdr` fold due before this run touched it. It
went in as § 3.1, the section that companion's own template gives to a seat reading the FDR after it
settled, with its Answer slot left at its placeholder. I did not revise § 2.7, which asks the
adjacent question: its slot is filled, and a filled slot is an answer somebody gave.

One departure from the skill's default worth naming, so it can be overturned. `SKILL.md` § *When a
change belongs to another document* fixes the bucket for a raised item as *choices to confirm*. This
companion carries a purpose-built third section — § 3, "Raised from downstream — an item raised
against the FDR after it settled", whose template fields are `Raised by:` and `Tracked by:` — and
the item is exactly that act. The skill's rule argues bucket 2 over bucket 1, on the ground that a
run raising an item already holds a lean; § 3 is not bucket 1, so that reason does not reach it. The
precedent is in this product: the previous `companion-self-answer` run placed its raise in
`docs/SDD_open_issues.md` § 5, the same purpose-built section, and said so in
`docs/fdr_open_issues.md` § 2.7's answer. If that reading is wrong, the repair is to move § 3.1 into
§ 2 as § 2.8; nothing else about the item changes.

## Launchers owed

- **`docs/SDD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-sdd/launcher.sh ka-reader`
- **`docs/fdr.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-fdr/launcher.sh ka-reader`
