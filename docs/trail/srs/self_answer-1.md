# Self-answer report — SRS.md

## Header

- **Companion:** `docs/SRS_open_issues.md`
- **Document:** `docs/SRS.md` (Settled, v8)
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-01

## Items worked

### 2.1 — The diagnostic log holds one session's lines and is capped within a session — a bound NFR-11 does not state

- **Bucket:** 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The draft is taken as it stands — one session's lines, emptied at launch, 1 MiB within a
  session with emptied-and-continue — and the number is decided here rather than left to the CTO to
  replace, because this run is the CTO's seat: the SRS is the CTO's outright
  (`<CORE>/roles/loaders/cto_global.md` § What you own), NFR-11 is where QC-40 says the bound lands
  (`docs/nfdr.md:294-297`), and nothing in the item binds a person, an outside party or a risk the
  owner carries — the log's existence was a design call (`docs/SDD.md` § 4 C-I2, `:357-361`), not an
  owner reservation. Yours, in the owner's seat.

  **Check 2 — the reasoning holds for the reason it gives.** The chain the item states is on disk:
  NFR-11 keeps diagnostics with own state (`docs/SRS.md:340-343`); C-I2 writes one line per `failed`
  or `stopped` item naming the part, the operation and the error text — no timestamp field
  (`docs/SDD.md:357-361`); QC-40 says the bound is undecided and names NFR-11 (`docs/nfdr.md:294-297`);
  QC-52 says `nozoki.log` "and nowhere else" (`docs/nfdr.md:383-387`). So "one session, because the
  file has no timestamps" carries its weight, and the within-session cap answers the item's own
  scenario, which "one session" alone did not.

  **Check 3 — the nearest settled rule is RN-4, and it does not reach this.** The owner ruled that
  *"A threshold invented before there is a build to measure is noise"* (`docs/trail/prd/cycle-1.md`
  § 2.4), and RN-4 applies it to NFR-1, NFR-2 and NFR-10 (`docs/SRS.md:621-625`). Those are measured
  properties — a latency, a reference size — that a build produces a value for. A log cap is not
  produced by a build; nothing measured would set it, and leaving it unset is the exact hazard the
  item names — a builder picking one silently. I was close to writing "TBD by revision" under RN-4's
  rule; what tipped it is that QC-40 needs a checkable number now and RN-4's own reason (a build will
  measure it) is absent here. 1 MiB is on the order of ten thousand lines of C-I2's shape, which is
  more than a person reads; a line count would be closer to what a reader counts, but bytes are what
  "grows without bound" measures and what `checks/own-state.sh` can assert with a size. Against
  NFR-3: a failure "recovers on a subsequent refresh once the item is readable again"
  (`docs/SRS.md:290-292`), which is what makes the previous session's lines low-value — a persistent
  failure re-logs itself on the next session's first refresh. Against FR-21 / DR-5: the log is own
  state under the container and holds no content of the folder (QC-39), so create-or-truncate at
  launch is a write the SRS already permits.

  **Check 4 — three additions, each a path the draft did not reach.**
  - *Concurrent:* two instances of the product writing one file. Reachable — `man open` documents
    `-n, --new` as *"Open a new instance of the application even if one is already running"*, which
    is also the citation that the default launch path yields one instance. With the cap stated as a
    property of the **file on disk** rather than of what one process wrote, each writer empties the
    file when it sees it at the cap and the bound holds with two writers; the second launch's
    truncation discarding the first's lines is accepted, not prevented. The architecture run named
    this case as uncovered for want of a citation (`docs/trail/architecture/self_answer-1.md` § 1.2);
    this run has the citation and covers it.
  - *Refused / absent:* the container path unwritable, the disk full. NFR-11's first clause — "a
    failure the user must know about is visible in the UI itself" — could be read as reaching the
    log's own write failure. It must not: the log is diagnostics, not a promise, and the UXD holds
    that no surface reveals or copies a fault's detail (`docs/UXD.md` UX-I16, version line `:5`) and
    the SDD forbids a message carrying the log line (`docs/SDD.md:423-425`). So a failed log write
    surfaces nowhere, stops no item's presentation, and is not retried — the line is dropped.
  - *Empty:* first launch, no file yet. "Emptied at launch" is stated as create-or-truncate so the
    first launch is inside the rule and not a special case.
  - *Stale, named and declined:* a session that crashed before its log was read loses those lines.
    The item offers a one-generation rotation as the override. Declined, with the reason: C-I2's log
    records item failures, not crashes of the host — a host crash writes nothing to it — so the lines
    lost are item failures, and a persisting one is reproduced by the next session (NFR-3). The
    rotation would cost QC-52's "nowhere else" and C-I2 a second file for that. What would tip it:
    the SDD later logging host-level faults to the same file.

  **Where the mechanism goes:** the SRS states the bound; C-I2 carries the mechanism by its own
  revision and QC-40 the number and the test, as the item says. This run writes neither — the SDD is
  a three-seat run and the NFDR the Principal Architect's, and both already name the SRS as the
  source they wait on.

### 2.2 — Every trail pointer in this document is dead — the folders moved and the citations did not

- **Bucket:** 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The drafted rule is right and its count is right; what it misses is that three of the 80
  must not go through it, and one of those three would come out pointing at the wrong file. Check 1:
  the edit lands in `docs/SRS.md`, the CTO's document, and binds nobody outside it — yours, in the
  owner's seat. The item's closing sentence leaves *how* the repair is done to the owner; the slot
  decides whether the SRS's pointers are repaired and to what, not the mechanism, which is the same
  reading the PRD run took (`docs/trail/prd/self_answer-1.md` § 2.1).

  **Check 2 — the measurement, re-done on this document.** `grep -o 'docs/[a-z]*_trail/'` gives 80;
  `grep -o '[a-z]*_trail/'` gives 80 — so unlike the PRD there is no bare-form citation the
  `docs/`-prefixed pattern misses; `grep -oE '@[0-9a-f]{6,}:'` gives 0 — no pinned form to protect.
  Every one of the 16 distinct `docs/prd_trail/cycle-N.md` and `docs/srs_trail/cycle-N.md` files
  cited exists at `docs/trail/<x>/cycle-N.md`, checked file by file. The item's cross-document
  figures are stale and are reported rather than edited: the repo-wide total was 295 once the PRD's
  bare form was counted, and the PRD's 62 are repaired at `nozoki@2d8c99d`, so the live count today
  is 233 across five documents (SRS 80, UXD 71 of which 4 pinned, SDD 40, DESIGN 30, CONTENT 12).

  **Check 4 — the case the rule does not reach, and it is the one that would have written a false
  citation.** The SRS's three `docs/uxd_trail/` mentions all sit in Review Notes about a UXD that was
  removed at `9017ae2` ("the UXD comes out, to be authored again"; the commit names `1d5c553` as the
  restore point) and re-authored afterwards. Two are statements of that history (`docs/SRS.md:724`,
  `:742`): "were removed from the product repository at `9017ae2`". Rewriting the path inside them
  makes the sentence false — `docs/trail/uxd/` exists and was never removed. The third
  (`docs/SRS.md:712`) is FR-18's authorization: "owner-confirmed: `docs/uxd_trail/cycle-2.md` §2.1".
  `git show 1d5c553:docs/uxd_trail/cycle-2.md` has § 2.1 "The history view's branch topology — the
  drafted experience statement", confirmed by the owner with the branch-set refinement — the thing
  FR-18 rests on. `docs/trail/uxd/cycle-2.md` today has one item, § 1.1 "Where does the theme
  override control that UX-I9 requires actually live?" — the re-authored UXD's cycle 2, a different
  file under the same name. The mechanical rule would send a reader checking FR-18's authorization to
  a theme-control answer. The repair for that one is the pinned form the item already protects for
  the UXD's four — `nozoki@1d5c553:docs/uxd_trail/cycle-2.md` § 2.1 — which resolves and is honest
  about being history.

  **Check 3.** Nothing the SRS states changes; the answer agrees with the UXD companion's filled
  § 2.1 (same rule, same pinned exception) and with the PRD's fold. It also agrees with this run's
  § 2.1: neither touches the other's lines. One consequence is left where it belongs: the pointers
  went dead because a folder moved and the citing documents were not in the sweep; a citation form
  that survives a second move is a convention for the seat that owns `kensaiapp_structure.md` § *A
  trail is not the document's sibling*, not an SRS item — named, not covered, as the PRD run also
  found. *Concurrent:* an owner sweep that runs before the fold with the drafted rule alone would
  rewrite the three `uxd_trail` lines wrongly — the exclusion in the slot is what a sweep has to
  carry, and the pattern is "every `docs/<x>_trail/` except `uxd_trail`, then the one pinned repair
  by hand".

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.3 — RN-35's sibling sentence — "`docs/UXD.md` UX-S4 still makes a non-repository a startup failure" — describes a state that ended at UXD v6

- **What the document is owed:** RN-35's sibling sentence recording that the divergence it describes
  closed at UXD v6 — UX-S4 now opens a plain folder (`docs/UXD.md:229`, RN-25), and UXD RN-28 read
  SRS v8 and found no collision (`docs/UXD.md:817-820`).
- **Why it is worth a cycle:** `decide_companion_answers.md` § The items are not the whole of what a
  document is owed — "a fact in it is now false … a claim about another document". Measured:
  `docs/SRS.md:938-941` says UX-S4 "still makes a non-repository a startup failure";
  `docs/UXD.md:229` says "A folder that is not a Git repository is not on this list: it opens".
  Order: SRS v8 at `e4ed5fe`, UXD v6 at `dd08f2d`, both 2026-08-26, and UXD RN-28 names SRS v8 as
  what it read — so the sentence was true when written and is false now. It costs no extra cycle: it
  rides the fold § 2.1 and § 2.2 already owe. Not raised, and named so the next reader does not
  search: RN-19 and RN-20 describe the UXD as removed, which is true as history and which RN-35's
  own reference to `docs/UXD.md` already shows the SRS knows has ended; and FR-18's wording authority
  (UX-S6) exists again in the re-authored UXD (`docs/UXD.md:231`, RN-14) — an improvement no reader is
  missing, since FR-18 stands on the owner's cycle-3 answer, which is on disk.

## Companions opened

None this run.

## Launchers owed

- **`docs/SRS.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-srs/launcher.sh nozoki`
