# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (NFDR v18, Draft — its own RN-29 says Draft because
  the companion is on disk, not because anything derived is unsettled; the inputs the item names
  are SDD v20 Settled, FDR v10 Settled)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-25
- **Sources re-read:** None — no answer this run gave rests on a source outside this repository.
  The case-folding and volume-root conditions the check turns on are stated by the SDD and the FDR
  as facts the product reads from the folder itself, not as a vendor claim this run leaned on.
  Everything was measured on the tree at `ka-reader@88b237f` (HEAD, the NFDR v18 commit): `git diff
  --stat 69cc4b2 HEAD -- crates/` prints nothing, so the crates are the ones the item cites.

One item, in bucket 2, and it belongs to this document's seat. Nothing needed a call only the owner
can make: the definition QC-6 is re-derived on is already the owner's, decided at
`docs/trail/sdd/cycle-15.md` § 5.1 and folded settled into SDD v20 and FDR v10. No document read
this run was found owed a change no item raised.

## Items worked

### 2.1 — QC-6 is re-derived on SDD v20 § 3 `fs-reader` — the canonical form taken inside the grant only, names compared as spelled outside it, and three spellings refused although they may lead in

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** Confirmed, because the draft is what v18 already holds and it states its source
  faithfully. QC-6's obligation (`docs/nfdr.md:L135-L148`) matches SDD v20 § 3 `fs-reader`
  (`docs/SDD.md:L322`) clause for clause — percent-decoding first, the canonical form at every
  position inside the grant, nothing read at a position outside it, names compared there as
  spelled, re-entry only on the folder's own name met from its parent under the two conditions read
  from the folder itself, as spelled wherever it cannot be sure, and the three refused spellings.
  § 4 C-D1's *Violated by* names the canonicalizing `lstat` or `realpath` outside the grant as the
  forbidden read (`docs/SDD.md:L777-L782`), which is why v17's "on the canonical path, symlinks
  resolved" could not stand: read literally it asked for that read. FDR R-183 and R-184
  (`docs/fdr.md:L87-L88`) carry the same definition and the same three refusals, Settled at v10.
  The tree-state claims re-measure true: `crates/ka-reader-core/src/fs_reader.rs` `mod tests`
  (`:L370-L796`) holds the `..` and symlink-out cases and no test for any of the four spellings
  (`grep -n -i 'letter case\|case-fold\|normaliz\|volume' fs_reader.rs` hits only doc comments),
  and the walk answers `Outside` for a re-entry: at a position outside the root a name moves the
  position lexically and touches nothing (`:L211-L215`), and `strip_prefix(root)` fails at the end
  (`:L256-L262`). § 10's QC-6 row (`docs/nfdr.md:L1111`) names two commands and did not move.

  **The addition — the layer-1 list's source, not the obligation.** The *verified by* names "the
  four spellings `docs/fdr.md`'s example rows fix (`:L357-L358`)". The rows fix three. `:L357`
  holds `up → ../KA-READER/docs` (shown as a folder, expands into `docs` — R-183, R-34, R-151),
  `far → ../../projects/KA-READER/docs` (marked outside although it leads to `docs` — R-184's
  multi-level return) and `self → ../KA-READER` (a cycle — R-152); `:L358` holds `back → ../Work/notes.txt`
  under `/Volumes/Work` (R-184's volume root). No row exercises a Unicode-normalization difference;
  that refusal rests on R-184's second clause and SDD § 11 R-10 alone. Two consequences for the
  fold: the layer-1 case for normalization cites R-184 and § 11 R-10, not the rows; and the re-entry
  case has two forms the rows fix — `self`, ending `Cycle`, which the list names, and `up`,
  resolving inside and read as its target, which it does not. Both forms are `Outside` on the walk
  at `ka-reader@88b237f`, by the same lines — read from the code this pass, not run; the owner's
  measurement at `docs/trail/sdd/cycle-15.md` § 5.1 covered the `self` form on `ka-reader@46bb275`,
  and the crates are unchanged since (the stat in the header).

  **Failure paths.** *Empty:* none of the four layer-1 tests exists, and the entry says so and
  names which goes red — a QA seat reading it cold knows the bar and the gap. *Absent:* a volume
  whose case-sensitivity cannot be read is "as spelled wherever it cannot be sure", so the re-entry
  is refused and nothing is read — the obligation reaches it. *Stale:* the tree-state clause pins a
  commit and line ranges and names its own expiry ("until the change that builds the re-entry
  lands"); the fold after that change cuts it, and the item's own *If overridden* names the cut as
  a detail move at v19, not an override. Kept as it is: today it is the one sentence that tells the
  station's tree half what is red. *Concurrent:* two callers, one implementation — "the check has
  one implementation its two callers do not re-implement" (SM-7) — so `asset_bytes` and the tree
  cannot drift apart on a spelling. *Refused:* an owner overriding back to v17's wording is the
  item's own first *If overridden* branch and puts QC-6 back in contradiction with C-D1 and QC-35;
  nothing in this answer rests on it.

  **What would have tipped it.** *Confirmed* outright was one line away: the rows-fix-four sentence
  is a citation slip in the *verified by*, not a wrong bar. It stayed *confirmed with addition*
  because a QA seat deriving the normalization test from `:L357-L358` would find no row to derive
  it from, and the list is the NFDR's enforcement surface — a case with no source is a case that
  fades. Had the FDR carried a normalization example row, this would have been *confirmed*.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
