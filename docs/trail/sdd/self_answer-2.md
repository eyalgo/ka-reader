# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `/Users/eyalgolan/products/nozoki/docs/sdd_open_issues.md`
- **Document:** `docs/SDD.md` — nozoki 覗き, Settled at v3
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-02

## Items worked

### 5.1 — § 3 must be re-cut into the two tables the template now fixes — and three of its `Lives in` cells are refused by the tool that reads them

- **Bucket:** `## 5. Raised from downstream — an item from a seat that did not write the SDD`
- **Verdict:** confirmed with addition
- **Why:** The item's scope is right and its measurement is right, so it is confirmed; the addition
  is the four sub-calls it deliberately left open, plus one defect inside § 3 it did not see.

  The measurement was re-run rather than trusted, because the whole item turns on it. Lifting
  `parse_parts_table` out of `<CORE>/launchers/product-skeleton/launcher.sh` and running it against
  `docs/SDD.md` returns nine rows; all nine slugs pass `PART_SLUG_RE`; exactly three `Lives in`
  cells fail `LIVES_IN_RE` — `git-reader`, `surfaces` and `read-only-harness` — and they are the
  three the item names, character for character. `sdd_template.md` is at 4.0.1 and its § 3 fixes
  both tables and both column forms as quoted. So the launcher genuinely refuses this product today,
  and that is not a matter of taste about conformance: no skeleton can be built until § 3 is re-cut.

  The four sub-calls, decided:

  **`read-only-harness` → `checks`, not empty.** This is the only one where both available answers
  are wrong and the job is to pick the smaller wrong. `rel_dir = f"{lives_sub}/{slug}" if lives_sub
  else slug`, so `checks` makes `checks/read-only-harness/` and creates `checks/` as an ancestor,
  while empty makes `read-only-harness/` at the product root and creates no `checks/` at all. The
  product's harness really is `checks/*.sh` (§ 4 C-I3 names five of those scripts by path), so
  `checks` builds the directory the design already names and costs one empty subdirectory beside the
  scripts. Empty costs a top-level directory the product does not have and skips the one it does.

  **The seams table keeps the existing numbers as `SM-1` – `SM-7`.** This was the closest call to
  going the other way. Renumbering or re-ordering would read better in a table, but "seam 1", "seam
  2", "seam 4", "seam 5" and "seam 7" are cited from § 3's own prose, from *Rests on* on five slices
  in § 6, from § 9 TO-2 and TO-6, § 11 R-10, RN-11 and RN-24, and all of those resolve by number. A
  re-cut that renumbered would silently invalidate every one of them, and the item's own fence says
  the re-cut does not reach outside § 3. What would have tipped it: if the citations had used names
  rather than numbers, the ids would be free.

  `SM-1` keeps the OS on its left rather than being dropped for not being part-to-part, because the
  template's `<part> ↔ <part>` is an example form, no tool reads this table (the launcher finds the
  parts table by a header carrying both `Part` and `Lives in`, which this one carries neither of),
  and the row carries the sandbox fence that is § 2's entire argument. `SM-4` is written as
  `ipc-surface ↔ surfaces` rather than as the two packages, because each package is already that
  part's own `Lives in` cell, so nothing is lost by naming the parts.

  **The entity table stays a table, moved below the two.** 4.0.1 says "in prose below the tables",
  and that phrase is doing two jobs. The placement half binds and is satisfied by the move. The
  shape half is not read as binding: the template fixes the first two tables *because a tool reads
  them* and says so, and nothing reads this one, while its eight rows carry key fields,
  relationships and a `DR-n` trace each — column-scanned data that prose loses. Reopening settled
  content to flatten it leaves no reader better off, which is the bar for not doing it. If the CTO
  on the fold reads 4.0.1 as requiring prose outright, that reading is defensible; it is not the one
  taken here, and this sentence is why.

  **Backticks are stripped from `Lives in` and kept on `Part`**, following 4.0.1's explicit words
  for each. The launcher strips them either way, so this costs nothing and settles a presentation
  question the fold would otherwise re-open.

  **The one defect found while reading § 3 that no item raised:** `fs-reader`'s *Owns* reads
  "recognizing a floor language or Markdown by extension (**the table below**)", and the
  floor-language extension set below the tables is prose, not a table. It goes into the same pass
  rather than becoming an item of its own, because it sits inside the section already being
  rewritten and costs the fold one word.

  **Failure paths walked.** *Absent* — an empty `Lives in` is legal and means the product root; that
  is what made the `read-only-harness` call a real choice rather than a typo fix. *Refused* — the
  launcher dies on a bad cell rather than reading past it, so a partial re-cut leaves the product
  exactly as blocked as before; the three cells must land together. *Stale* — the launcher itself
  moved on 2026-09-02 (`kensaiapp-dev@f5d070b9`), so the parse above was run against the version on
  disk today, not reasoned from the comments. *Concurrent* and *empty* do not reach this item.

### 5.2 — The preamble and § 8 cite two `principal_pm_global.md` sections that no longer exist

- **Bucket:** `## 5. Raised from downstream — an item from a seat that did not write the SDD`
- **Verdict:** confirmed with addition
- **Why:** The draft is complete and correct, so it is taken as it stood; the addition is one case
  it does not cover, and covering it is what stops a fold from over-reaching.

  Verified: `<CORE>/roles/loaders/principal_pm_global.md` carries eleven `##` headings and one
  `###`, and neither *The loop* nor *Where a seed's stations reach* is among them or anywhere else
  in the file. `sdd_template.md` dropped both citations at `kensaiapp-dev@02d19689`, and the
  replacement wording at 4.0.1 is exactly what the item quotes. In `docs/SDD.md` the two sites are
  lines 18–19 and line 1275, and they are the only two occurrences of either section name. Both
  edits are pure deletions — the preamble loses its trailing clause and re-wraps one line shorter,
  § 8's opening loses two words — so there is no judgment left in the edit itself.

  **The addition.** The document carries a *third* citation to that loader, in § 5's *Six cuts that
  look like slices and are not*: "The first five are the Principal PM's, at
  `<CORE>/roles/loaders/principal_pm_global.md` § *You are not a scheduler*". It is weak twice over —
  the loader carries that phrase as bold prose at line 14, not as a section, and the passage names
  four defects where the sentence claims five. It is nevertheless **left alone**, because the whole
  block is template boilerplate and 4.0.1 carries it verbatim: the document conforms, and repairing
  it here would put the SDD out of step with the template it is measured against. Saying so in the
  slot is the point of the addition — a fold that read this item as "repair the dead loader
  citations" would have swept it in, and the sweep would have been wrong.

  **Failure paths walked.** *Absent* — after the edit a reader following the citation lands on the
  loader whole, which does carry the substance in § *Cutting seeds from a product's documents* and
  § *What you own*, so it is not a dead pointer. *Stale* — if the loader ever grows a § *The loop*
  again, citing it whole stays true, so the edit is robust in the direction that matters. Nothing in
  the document rests on either section name beyond those two sites, so *concurrent* and *refused* do
  not reach it.

## Left for the owner

None this run. Neither item commits anything to a person, an outside party, money, a legal position
or a risk anyone carries; both are conformance calls inside the CTO's own § 3 and § 8 lanes, with a
tool's refusal standing as the evidence. No ground was named that this run could not see.

## Skipped

- **No item was skipped** — both items on the file were open, and both were worked.

Three findings this run met that belong to no item and had nowhere to be raised. Each names a file
under `<CORE>` or the companion's own filename, and neither is a product document with a companion
template on disk, so per the skill's rule they are recorded here and nothing was written:

- **`<CORE>/templates/product-templates/sdd_template.md` — its § 3 row placeholder contradicts its
  own prose.** The prose says `Lives in` carries "no backticks"; the illustrative row writes it as
  `` `<the module, package or crate this part belongs to>` ``, in backticks. The launcher strips
  them, so nothing breaks — but a run stamping from the row and a run reading the prose write the
  column differently, which is the shape of drift this template exists to prevent.
- **`<CORE>/templates/product-templates/sdd_template.md` — its *Six cuts* block cites a loader
  section that is not one, and over-counts.** "The first five are the Principal PM's, at
  `<CORE>/roles/loaders/principal_pm_global.md` § *You are not a scheduler*": that phrase is bold
  prose at the loader's line 14, not a heading, and the passage names four defects — dependency
  stated as preference, a seed whose only value is a later seed, a seed no Agari claims, a seed with
  no owning project — where the sentence claims five. Every SDD stamped from this template inherits
  both, `docs/SDD.md` included (its line 727), which is why § 5.2's answer leaves that line alone.
- **This companion's filename is `sdd_open_issues.md`, and `product-sdd` reads
  `SDD_open_issues.md`.** `<CORE>/launchers/product-sdd/launcher.sh:188` sets
  `open_issues="$product_path/docs/SDD_open_issues.md"`, and `docs/SDD.md` cites the capitalised
  name at three places in § 12 and once in *Open Questions*. Git tracks the file as
  `docs/sdd_open_issues.md` (`git ls-files`). This machine's volume is case-insensitive APFS, so the
  launcher's `-f` test passes today and the round works; on a case-sensitive checkout the launcher
  would report "absent (SDD done)" and this whole round would be invisible — and a companion's
  absence is the done signal. It was **not** renamed here, because renaming the companion a run is
  answering is outside what this skill may do to it. One command fixes it, from the product root:
  `git mv docs/sdd_open_issues.md docs/SDD_open_issues.md`.

## Raised on this document

### 5.3 — `**Status:** Settled` no longer describes this document — a tool refuses its § 3, and a companion beside it holds an unfolded re-cut

- **What the document is owed:** its `**Status:**` line reconciled with the legend directly beneath
  it, and a standing answer to whether a companion opened on a Settled document by a downstream
  reader flips that document to `Draft` while it stands.
- **Why it is worth a cycle:** it meets `decide_companion_answers.md` § *The items are not the whole
  of what a document is owed*'s first and strongest ground — **a fact in it is now false** — and the
  measurement is the document's own legend. That legend sets three conditions for Settled: "nothing
  left for the owner to answer", "no open technical question", and "the open-issues file is gone".
  `docs/sdd_open_issues.md` is on disk, so the third is false; `product-skeleton` refuses § 3
  (§ 5.1), so the second is false; only the first holds, and only because this run answered §§ 5.1
  and 5.2. The consequence is not cosmetic — a downstream reader or gate taking `Status:` at face
  value reads this SDD as finished while no skeleton can be built from it. It costs no extra cycle:
  the fold that takes §§ 5.1 and 5.2 takes this with them. The doubt, recorded: the seat that opened
  this companion saw the same Settled line and chose to leave it, saying so in the header, so this
  may be a settled convention rather than an oversight — which is why the item asks the question
  rather than asserting the answer, and why its slot is left at its placeholder.

  **A previous self-answer run examined this exact finding and declined to raise it**, recording in
  its commit that "Status Settled beside a live companion is `product-sdd`'s bookkeeping and
  self-heals on the fold" (the commit carrying `docs/trail/sdd/self_answer-1.md`, 2026-09-01). That
  call is not being re-litigated, and it was right for its round: the items open then were a
  package-manager spelling and a set of dead trail pointers, so the document was whole while it
  waited and only the status line was behind. What has changed is the second of the legend's three
  conditions. `product-skeleton` now refuses § 3 outright, so "no open technical question" is false
  as well, and the document is not one waiting on bookkeeping — it is one nothing can be built from.
  Raising it on that ground is a different item, not the same one asked twice.

## Companions opened

None this run. Neither item routed to another document, and no document read while answering — the
PRD, SRS, UXD, the ADR log's index, the loader, the two templates and the two launchers — was judged
owed a change that belongs on a companion. The two template findings and the filename hazard are
under `## Skipped`, because no companion template on disk names a `<CORE>` file.

## Launchers owed

- **`docs/SDD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-sdd/launcher.sh nozoki`
