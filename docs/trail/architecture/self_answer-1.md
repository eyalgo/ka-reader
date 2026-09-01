# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** /Users/eyalgolan/products/nozoki/docs/architecture_open_issues.md
- **Document:** `adr/` and `nfdr.md` (`docs/adr/`, `docs/nfdr.md`)
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-01

## Items worked

### 1.1 — Whether a critical dependency vulnerability has a remediation window at all, given a support posture that promises no fix

- **Bucket:** 1. Open issues — questions with no answer yet
- **Verdict:** confirmed with addition
- **Why:** No window. The item sat in bucket 1 but carried a lean ("no window"), so it was weighed as
  a draft rather than answered from scratch, and the draft's conclusion holds — for a stronger reason
  than it gave. It rested on SRS C-7, which is about security *reports*, and conceded that C-7 does
  not reach advisories. The bar that does is the PRD's support posture, owner-confirmed
  (`docs/PRD.md` § Assumptions "Support posture"; `docs/trail/prd/cycle-7.md`), carried as SRS C-13
  and FDR PD-22: "no commitment to fix, and no commitment that a fix ever arrives". A fix for an
  advisory is a fix, so a stated window would promise in the NFDR what the PRD refuses — check 3
  kills the "window" answer on a settled decision, and the Principal Architect's own rule forbids
  writing a floor the SRS does not carry (`principal_architect_global.md` § Non-responsibilities).
  The doctrine floor's cost — "an obligation nobody is late against" (`quality_defaults.md` v1.1.0
  § Dependencies) — is accepted and is already what the posture tells adopters. Failure paths named:
  an advisory with no upstream fix blocks release indefinitely, which the posture permits; the audit
  databases are fetched by CI, not the product, so NFR-8 is untouched. Not the owner's: the answer
  adds no commitment to what they already decided, and no unseeable ground could be named. What would
  have tipped it: an owner wish for a window — which is a PRD revision, not an NFDR entry.

### 1.2 — The diagnostic log's size or retention bound

- **Bucket:** 1. Open issues — questions with no answer yet
- **Verdict:** raised upstream
- **Why:** The edit lands in the SRS, not here: the item and QC-40 both say the bound "lands in the
  SRS at NFR-11 by revision", the NFDR may state no number without a source (its own header), and
  the chain runs SRS → SDD C-I2 (mechanism) → NFDR QC-40 (the checkable number). So the answer was
  written on the SRS's companion — `docs/SRS_open_issues.md` § 2.1, opened by this run and landed at
  `63b5f39` before this slot was filled. The answer itself: one session's log, emptied at launch, so
  a file with no timestamp field (C-I2's line names the part, the operation and the error text) is
  readable as this session's or the last one's; plus a within-session cap at 1 MiB with
  emptied-and-continue, because the item's own scenario — one session over a folder an agent
  rewrites for a week — is not answered by "one session" alone, and the lean as offered missed
  that. The number is proposed on the size of a file a person opens in an editor, not measured, and
  the item says the CTO may replace it. Named as not covered: a session that crashes and is
  relaunched before its log is read loses those lines; the one-generation rotation that would cover
  it costs a second file QC-52 would have to name, and is stated in the item as the override. Not
  covered and not named further: two instances of the product writing one log — this run has no
  citation for macOS single-instance launch behaviour and does not assert it. Not the owner's:
  nothing here commits to an outside party, and the log's very existence was the CTO's design call
  (SDD C-I2), not an owner reservation.

### 2.1 — What the public contract is that semantic versioning binds from 1.0.0

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** The four-part content stands — the FDR's rules and decisions as behaviour, the install path,
  own-state readability, the macOS floor. The addition is the word the draft dropped: SRS C-6 binds
  a major version to a *breaking* change to the contract, and QC-59 says "a change to any of these",
  which read literally makes PD-9's floor growth (a seventh highlighted language) or a lowered macOS
  floor a major version — compatible additions the domain doctrine names as minor
  (`system/doctrine/kensaiapp_doctrine.md` § The version number is a contract with a stranger's
  automation, rule 7). The slot now states the breaking/additive split with three examples each
  way. Check 1 was close: the item says "C-6 in the SRS is where the definition lands by revision".
  This run disagrees and says why — the declaration is a constraint by lifecycle (a change could
  ship breaking as minor silently, and `development-specs` naming the parts touched is the check),
  so the NFDR is its home and the SRS's "the product's public contract" points at it; and the
  behaviour half is already the FDR itself, since three of the four parts are FDR rules (R-129,
  R-133) or the FDR whole. Reopening a settled SRS to duplicate a definition the NFDR carries would
  be a cycle for improvement no reader is missing. Not the owner's: the SemVer promise is theirs and
  already made (PRD § Assumptions "Versioning", owner-confirmed); its content follows from settled
  documents.

### 2.2 — What a later version does with an earlier version's own-state

- **Bucket:** 2. Choices to confirm
- **Verdict:** raised upstream
- **Why:** The item names its own seat: "its visible half — 'my remembered folders vanished' — is
  product". Product-visible behaviour on upgrade is the FDR's (`principal_architect_global.md`
  § Three seams — behaviour versus structure), and the FDR is silent on it: R-108 persists own state
  between *sessions*, not across *versions*. The FDR has a live companion, so the answer was
  appended to it as `docs/fdr_open_issues.md` § 2.9 — its § 1.2 (what the remembered list holds and
  how long) is adjacent but asks about retention inside a version, so a new item, cross-referenced,
  rather than a revision of that one — landed at `98df76b` before this slot was filled. The draft
  was taken with two additions from check 4. *Stale/downgrade:* an older `.dmg` installed over a
  newer own state — a rule about "a later version" cannot bind the older version after it shipped,
  so the rule is made symmetric: any version meeting own state it cannot read discards it whole,
  which every version carries from the first. *Refused:* an unreadable own state must not be a
  startup failure — FR-3's failure list is closed to the three folder cases (R-7) — so the product
  opens as on first run. "Read or discard whole", never partial, because a half-read state is one
  nobody can reason about. QC-60 keeps the enforceable half (`checks/own-state.sh --from
  <previous-tag>`) and traces to the FDR's rule once folded. Not the owner's: "discard after 1.0.0
  is breaking" is a derivation from PD-20, which they already decided, not a new commitment.

### 2.3 — § 3 Authentication & access control — the identity half declared not applicable

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** The declaration holds on its ground — no identity (SDD C-D1, SRS NFR-7, FDR PD-33) and
  authorization the operating system's (PD-14) — and the privilege half is bound, not declared away
  (QC-34 – QC-37). The addition is a correction to a bound the entry mis-states: QC-33 says the
  declaration "stops being true the day the product gains a hosted mode or a second folder". A
  second granted folder is a second user-selected grant, still the OS's, and creates no identity —
  it revokes nothing. The entry's own verified-by already has the right trigger ("a hosted mode, an
  account, or any identifier"), so the fold aligns the prose to it. Check 4: the security-scoped
  bookmark (beyond v1) identifies a folder, not a person or a device, and stays inside the
  declaration; WKWebView's cache lives in the container and carries no identity (SDD C-D2).

### 2.4 — § 7 — non-repudiation and accountability declared not applicable

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed
- **Why:** No action on the user's data and no user (FDR PD-1, PD-33; OOS-1, OOS-2), so there is
  nothing to attribute and no one to attribute it to; the revoking events — a write path or an
  identity — are permanently out of scope, and the entry names them. Check 4: the one thing the
  product does write, its own state, is the user's own reversible preference (R-110) and no
  accountability question attaches to a theme toggle; the diagnostic log records item failures, not
  actions (QC-39, QC-52), as the item says. Nothing to add.

### 2.5 — ADR-0009 — the physical module set, reconstructed

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed
- **Why:** ADR-0009 moves to Accepted with its *(Reconstructed …)* marking kept. The unit set is not
  invented: the SDD names the three deliverables and the harness and assigns every part a home
  (`docs/SDD.md` § 3, "Three deliverables …" and the parts table), and the crate split is pinned by
  facts the SDD states — the harness links `nozoki-core` without a window (C-I3) and the first slice
  links no `git-reader` (§ 6 S-1). What the SDD never wrote is the *weighing*, and the record marks
  its alternatives as this seat's readings; Accepted with that marking is the honest status, because
  the decision itself is settled upstream and only its argument is reconstructed. Check 1 was close:
  the CTO is the seat that decided, and the alternative was a finding to the CTO to write the
  weighing. Not taken, because the SDD § 12 authors no ADR and needs no change for the record to be
  true, and a cycle of a settled three-seat document to write reasons after the fact is the
  improvement-no-reader-is-missing case. What would tip it: the SDD being revised for another reason
  — then the CTO may state the weighing and a new record supersedes 0009 on argued ground. Check 4:
  a future unit — say `git-reader` split out for the installed-`git` adapter — is a new record
  superseding this one and a § 1.2 rewrite, which the record already says.

### 2.6 — QC-49 — the kill-mid-churn check added to the read-only harness

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed
- **Why:** NFR-4 binds the promises "during and after crashes and abnormal exits" and the SDD's
  harness hashes around a clean run only (C-I3), so the crash half had no enforcement surface, and
  giving every constraint one is this seat's own responsibility (`principal_architect_global.md`
  § Responsibilities 5). The NFDR's header already claims the right to name its own realizations and
  says so in RN-4; the SDD's C-I3 is extended, not contradicted, and the SDD designs no individual
  change (§ 12). Check 4, named and left where it belongs: a SIGKILL mid-write of *own state* can
  leave the container's file half-written — that is not NFR-4 (the viewed folder) but it is the case
  item 2.2's "discards it whole, never a startup failure" exists for, and the two checks meet there;
  and how many kills and at which points is the layer-5 test's realization when QA writes it, not
  the entry's. Not the owner's: naming a check that proves a settled requirement commits nothing
  new.

### 2.7 — The tools this document names where the SDD named none

- **Bucket:** 2. Choices to confirm
- **Verdict:** confirmed with addition
- **Why:** The tools stand and the seat is right — the entries name the obligation's command where
  the source named the obligation, which the NFDR's header permits, and any tool with an exit code
  satisfies the same entry. Two of the eight were checked against their own documentation and need
  correction on the fold. `gitleaks detect` has been deprecated since v8.19.0 — still available,
  hidden from `--help` — in favour of `gitleaks git` and `gitleaks dir`, exit 0 on no leak and 1 on
  a leak or an error (https://github.com/gitleaks/gitleaks/blob/master/README.md); QC-28 names the
  current command. `cargo audit` has no severity threshold — its only filter is `--ignore
  <RUSTSEC-id>` (https://github.com/rustsec/rustsec/blob/main/cargo-audit/README.md) — so "exit 0"
  gates on every advisory, stricter than QC-27's *critical*: a gate that can fail when the
  obligation is not broken. The addition makes that explicit and gives the release a recorded way
  through — an ignore by id, added and reasoned in the change that adds it, reviewed as code like
  the dependency allowlist (QC-26). `pnpm audit --audit-level=critical` is as documented
  (https://pnpm.io/cli/audit). Check 1: the item calls tool choice "the CTO's toolchain lane"; the
  edit lands in the NFDR's tails and § 10, nothing in the SDD moves, and the CTO overlay's half is
  *building* the checks, not naming them in the constraint set. One discrepancy found while reading
  for this item is another document's and is under *Companions opened*: the SDD's C-R6 says
  `npm ls`.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.8 — NFDR RN-2 miscounts the FDR companion — "eight items open" where the file holds thirteen

- **What the document is owed:** RN-2's count of the FDR companion's open items corrected — it reads
  eight; the file held thirteen (§ 1.1 – § 1.5, § 2.1 – § 2.8) when this run read it, and holds
  fourteen after this run's § 2.9.
- **Why it is worth a cycle:** `decide_companion_answers.md` § The items are not the whole of what a
  document is owed — "a fact in it is now false … a count". Measured: `git show 63b5f39:docs/fdr_open_issues.md | grep -c '^### '`
  prints `13` — the file as it stood before this run's append. It costs no extra cycle — it rides the fold this companion
  already owes — and it sits in the note that records which upstream was Draft, which a cold reader
  trusts. Appended as one item in choices to confirm, slot at its placeholder, with its provenance
  blockquote.

## Companions opened

- **/Users/eyalgolan/products/nozoki/docs/SRS_open_issues.md** — **opened** — companion to `SRS.md`,
  landed in commit `63b5f39`
- **/Users/eyalgolan/products/nozoki/docs/fdr_open_issues.md** — **appended** — companion to `fdr.md`,
  landed in commit `98df76b`
- **/Users/eyalgolan/products/nozoki/docs/SDD_open_issues.md** — **opened** — companion to `SDD.md`,
  landed in commit `bf04b86`

The SDD companion is the run's second kind of entry — a change found while reading, with no slot
waiting on it: `docs/SDD.md` § 4 C-R6 names `npm ls` where the NFDR realizes the TypeScript packet's
pnpm seventeen times (QC-3, QC-26, § 9; no package manifest exists in the repository yet to settle it
by fact), and RN-19 gates a sentence on `docs/SDD_open_issues.md` § 3.3, a file deleted at run 2 whose
answer closed that contingency the other way (RN-22). Raised with the doubt stated in the item: one
word and one stale sentence may not be worth a three-seat run on their own, and the round can wait
for the next SDD revision.

## Launchers owed

- **`adr/` and `nfdr.md`** — `<CORE>/launchers/product-architecture/launcher.sh nozoki [--dry-run] [--keep-awake]`
- **`SRS.md`** — `<CORE>/launchers/product-srs/launcher.sh nozoki [--dry-run]`
- **`fdr.md`** — `<CORE>/launchers/product-fdr/launcher.sh nozoki [--dry-run] [--keep-awake]`
- **`SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh nozoki [--dry-run] [--keep-awake]`
