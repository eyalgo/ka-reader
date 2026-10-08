# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** /Users/eyalgolan/products/ka-reader/docs/architecture_open_issues.md
- **Document:** `adr/` and `nfdr.md` (`docs/adr/`, `docs/nfdr.md`)
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-01

## Items worked

### 2.8 — NFDR RN-2 miscounts the FDR companion — "eight items open" where the file holds thirteen

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** Confirmed: the count is corrected, and the addition is that the whole note is now
  history rather than present state. The draft's fact holds and is pinned harder than the item
  pinned it — `git show a50718a:docs/fdr_open_issues.md | grep -c '^### '` prints `13`, where
  `a50718a` is the FDR's v1 commit (2026-09-01 02:51) and the NFDR's first commit `b23ed43`
  followed at 03:06, so "eight" was false at the moment of reading and not merely later. The draft
  answers a smaller question than the document now needs (check 2): between the run that raised
  this item and this one, the FDR folded twice — v2 at `0eb5c67`, v3 at `3325469`, Settled, the
  companion removed — so `docs/fdr_open_issues.md`, which RN-2 names as a live path, does not
  exist, and a note corrected to "thirteen items open" would be false again on the day it landed
  (check 4, *stale* and *absent*). The answer is therefore a note that stays true whatever the
  FDR does next: what v1 read, pinned to a commit — Draft at v1, thirteen items, `ka-reader@a50718a`
  — and where the FDR stands as of this fold, Settled at v3 (`ka-reader@3325469`), with the rounds
  at `docs/trail/fdr/cycle-1.md` and `cycle-2.md`; the `Inputs read:` header line carries the
  present status, which is the one form `<CORE>/doctrine/governance/unsettled_inputs.md` fixes
  and the producing run re-derives anyway. RN-2's two other sentences are read the same way:
  "none turns on an item that companion holds" was true of the thirteen (the prior run checked
  them) and the fourteenth — the NFDR's own QC-60 question — has come back as R-168 – R-170 and
  PD-39, which item 2.2's answer already routes into QC-60's trace; and the FR-13 contradiction
  RN-2 records ended at SRS v12, which carries both readings of the Git-view row (`docs/fdr.md`
  RN-25). Check 3: nothing settled moves, and the answer agrees with 1.2 (QC-40 takes the SRS's
  number — NFR-11 carries it since v9, `82c199a`) and 2.2 (QC-60 traces to the FDR's rule once
  folded — it is folded). Not the owner's: a review note's count and status commit nobody to
  anything. Not upstream: the edit is one note in this document. What would have tipped it to
  *overridden*: had the FDR's v2 or v3 moved a rule an NFDR trace turns on in a way the note's
  substantive claim could not survive — it did move two, which is item 2.9 below, but as entries,
  not as this note.

## Left for the owner

None this run.

## Skipped

- **1.1 — Whether a critical dependency vulnerability has a remediation window at all** — slot
  already filled by the prior run (`self_answer-1.md` § 1.1).
- **1.2 — The diagnostic log's size or retention bound** — slot already filled (raised upstream;
  the SRS has since folded the bound at v9, `82c199a`, and the FDR confirmed the bound stays the
  SRS's at v3, RN-27).
- **2.1 — What the public contract is that semantic versioning binds from 1.0.0** — slot already
  filled.
- **2.2 — What a later version does with an earlier version's own-state** — slot already filled
  (raised upstream; the FDR has since folded it as R-168 – R-170 and PD-39 at v2, `0eb5c67`).
- **2.3 — § 3 Authentication & access control — the identity half** — slot already filled.
- **2.4 — § 7 — non-repudiation and accountability** — slot already filled.
- **2.5 — ADR-0009 — the physical module set, reconstructed** — slot already filled.
- **2.6 — QC-49 — the kill-mid-churn check** — slot already filled.
- **2.7 — The tools this document names where the SDD named none** — slot already filled.

Nine filled slots, none re-weighed: a prior verdict binds this run as the owner's would.

## Raised on this document

### 2.9 — Two FDR moves under v2 that a constraint and two records cite have not been seen — QC-40's remembered-folder clause, and R-21 in ADR-0003 and ADR-0005

- **What the document is owed:** QC-40's "a remembered folder until its entry is removed" brought
  to the FDR's R-178 – R-182 and R-110 (no removal; ten by recency; an aged-out entry not
  restored), and the log's handling of ADR-0003 and ADR-0005's consequence sentences, which
  describe R-21 as it read at v1 — "a failure naming the folder to choose" — where v2 overrode it
  to name where the Git directory lies and offer no folder.
- **Why it is worth a cycle:** `decide_companion_answers.md` § The items are not the whole of what
  a document is owed — "something upstream moved and it has not seen it", and for QC-40 also "it
  contradicts a document it must agree with". Measured: `git show a50718a:docs/fdr.md` R-110 reads
  "each such change is reversible by the control that made it" and has no R-178 – R-182;
  `docs/fdr.md:197` (R-110), `:229-233` (R-178 – R-182) and `:62` (R-21, "changed — RN-7") are
  the v3 text; `docs/adr/0003-app-sandbox-wall-and-open-panel-grant.md:50-52` and
  `docs/adr/0005-root-finding-behind-the-git-port.md` § Consequences carry the v1 reading with
  the R-21 citation. It costs no extra cycle — it rides the fold this companion already owes.
  The doubt, stated in the item: the two records' decisions do not move, and a stale consequence
  under an accepted record may be something the log answers with a note rather than a
  superseding record; that is the producing run's call and the item does not prescribe it.
  Appended as one item in choices to confirm, slot at its placeholder, with its provenance
  blockquote.

## Companions opened

None this run.

## Launchers owed

- **`adr/` and `nfdr.md`** — `<CORE>/launchers/product-architecture/launcher.sh ka-reader`
