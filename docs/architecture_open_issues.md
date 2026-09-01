# Architecture open issues — Nozoki 覗き

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the SRS, the SDD
> and the FDR.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-architecture`. It folds your answers into the records and drops the resolved items.
> When nothing is left open, `product-architecture` **deletes this file**: no file = the records are
> done.
>
> Your answers are never thrown away. Each time the Principal Architect folds them in, it first copies
> this file whole to `docs/trail/architecture/` — so what you decided, and why, stays readable and
> citable for good.

---

## 1. Open issues — questions with no answer yet

### 1.1 Whether a critical dependency vulnerability has a remediation window at all, given a support posture that promises no fix
- **Lands in:** `nfdr.md` QC-27
- **Why it matters:** the organisation's quality floor says a known critical vulnerability has a
  stated remediation window, starting when the advisory is published, and that "a product that names
  no window has an obligation nobody is late against" (`quality_defaults.md` v1.1.0 § Dependencies).
  Nozoki's support posture, quoted from the PRD into the SRS and the FDR, promises "no commitment to
  fix, and no commitment that a fix ever arrives" and, for security reports, "no acknowledgement or
  response time promised" (`docs/SRS.md` § 7 C-7, C-13; `docs/fdr.md` PD-22). Where the SRS states a
  bar, the SRS wins over the floor — but C-7 is about reports, not advisories, and an NFDR that
  stated a window would promise what the PRD refuses. QC-27 currently binds only that a critical
  advisory blocks the *next* release, and says the window is undecided. My reading, offered and not
  drafted: no window, consistent with the posture; the cost is that an adopter has no date to hold
  the project to, which is what the posture already tells them. If you want a window, it belongs in
  the SRS at C-7 by revision, with who watches the advisory feed.
- **Answer:** No window. QC-27 binds what it now binds — a known critical vulnerability blocks the
  next release, checked by the audit commands as a release gate — and states that no remediation
  window exists, not that one is undecided; the undecided sentence and the pointer to this file go.
  Ground: the PRD's owner-confirmed support posture promises "no commitment to fix, and no
  commitment that a fix ever arrives" (`docs/PRD.md` § Assumptions "Support posture", carried as
  SRS C-13 and FDR PD-22); a fix for an advisory is a fix, so C-13 — not only C-7's reports clause
  — is the SRS bar that outranks the doctrine floor, and a stated window would promise in the NFDR
  what the PRD refuses. The floor's cost — "an obligation nobody is late against" — is accepted and
  is already what the posture tells adopters. Two edges the entry reads as covered: an advisory
  with no upstream fix blocks release until the dependency is replaced or removed, for as long as
  that takes; and the audit databases are fetched by CI, never by the product, so NFR-8 is
  untouched. Reasoning: `docs/trail/architecture/self_answer-1.md` § 1.1.

### 1.2 The diagnostic log's size or retention bound
- **Lands in:** `nfdr.md` QC-40, QC-52
- **Why it matters:** the SDD has the host write one line per failed or stopped item to a log in
  the app's container (`docs/SDD.md` § 4 C-I2), and the SRS keeps diagnostics with the tool's own
  state (`docs/SRS.md` § 4.5 NFR-11). No document bounds the log: a folder an agent rewrites for a
  week produces a line per transient failure indefinitely. Two architects would bound it
  differently — truncate per session, rotate at a size, cap the line count — so it is a decision,
  not a derivation, and it is product-adjacent: the log is the one thing in the container a person
  might open. Whatever you choose lands in the SRS at NFR-11 by revision and here as QC-40's
  number. My lean: truncate at launch, so the log is always one session's and never grows.
- **Answer:** Carried upstream: the bound is raised on the SRS as `docs/SRS_open_issues.md` § 2.1
  (commit `63b5f39`), with this run's lean — one session's log, emptied at launch, capped at 1 MiB
  within a session and emptied-and-continue past the cap — its reasoning, and the
  crash-then-relaunch case it does not cover. QC-40 and QC-52 change nothing until the SRS's NFR-11
  carries the bound by revision; then QC-40 takes the number, and its verified-by becomes a layer-1
  test on the writer plus `checks/own-state.sh` reading the file's size after `checks/churn.sh`. The
  pointer to this file goes from QC-40. Reasoning: `docs/trail/architecture/self_answer-1.md`
  § 1.2.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 What the public contract is that semantic versioning binds from 1.0.0
- **Lands in:** `nfdr.md` QC-59
- **Drafted into the records:** the contract is four things — every rule and product decision in
  `docs/fdr.md` as observable behaviour; the install path (QC-57); the readability of an earlier
  version's own-state (QC-60); and the macOS floor (QC-56). A change to any of them after 1.0.0 is a
  major version.
- **Rationale:** the SRS binds a major version to "a breaking change to the product's public
  contract" and defines the contract nowhere (`docs/SRS.md` § 7 C-6); the FDR carries the same
  promise (PD-20). For a library the contract is its API; Nozoki has none (PD-26), so what a stranger
  relies on is what they can see and what survives an upgrade. The organisation's domain doctrine
  says the declaration is one "someone must make" and, for a tool with no library surface, names
  flags, exit codes, output formats and config schema — Nozoki has none of those either, which is why
  the draft names behaviour, the install path, own-state and the floor.
- **If overridden:** narrowing to behaviour alone makes an own-state discard or a raised floor a
  minor version, which QC-60 would then have to say; widening to "anything a screenshot shows"
  makes every design-language change major. Either way C-6 in the SRS is where the definition lands
  by revision, through the CTO's own skill; confirming here fixes only this document's entry.
- **Confirm or override:** confirm, with one addition to QC-59's wording. The four-part content
  stands. The sentence "A change to any of these is a major version after 1.0.0" reads: "A
  *breaking* change to any of these — a behaviour the FDR states that no longer holds, an install
  path or a floor that an adopter on the old one loses, an own-state a later version can no longer
  read — is a major version after 1.0.0; an added behaviour that leaves every stated rule holding
  — a seventh highlighted language, a new read surface, a lowered floor — is a minor version." SRS
  C-6 already says *breaking*; the draft dropped the word, and read literally it would make PD-9's
  floor growth a major version. No SRS revision is needed for the definition to bind: the
  declaration is a constraint — a change could ship breaking as minor silently, and a check names
  it — so it lives here, and C-6's "the product's public contract" points at it. Reasoning:
  `docs/trail/architecture/self_answer-1.md` § 2.1.

### 2.2 What a later version does with an earlier version's own-state
- **Lands in:** `nfdr.md` QC-60
- **Drafted into the records:** a later version reads the earlier own-state or discards it whole,
  and in neither case touches the viewed folder; before 1.0.0 a discard is permitted and stated
  where the release is offered; after 1.0.0 a discard is a breaking change under QC-59.
- **Rationale:** own-state holds the theme, the window frame and, later, the remembered folders
  (`docs/SRS.md` § 6 DR-5; `docs/fdr.md` R-108) — the one thing a stranger accumulates across
  releases. No document says whether an upgrade keeps it. A migration rule is architecture-adjacent
  but its visible half — "my remembered folders vanished" — is product, so it is yours. The draft
  takes the smallest rule that keeps the read-only promise whole under upgrade and lets a pre-1.0.0
  release change its own storage freely, which the PRD's pre-1.0.0 statement already permits.
- **If overridden:** requiring migration always adds a layer-5 check per release from the first
  release on and a migration path in `own-state`; permitting discard always removes own-state from
  QC-59's contract.
- **Confirm or override:** override: the behavioural half is carried upstream — raised on the FDR as
  `docs/fdr_open_issues.md` § 2.9 (commit `98df76b`), the rule to confirm there, with two
  additions to this draft: the rule is *symmetric* — any version meeting own-state it cannot read,
  earlier or later, discards it whole, which is the only way the downgrade case is covered — and an
  unreadable own-state is *never a startup failure* (FR-3's list is closed): the product opens as
  on first run. QC-60 keeps its check and its trace, states the same symmetric rule with the
  first-run clause, and traces to the FDR's rule once that fold lands; its "drafted, awaiting
  confirmation" marking and the pointer to this file go. Reasoning:
  `docs/trail/architecture/self_answer-1.md` § 2.2.

### 2.3 § 3 Authentication & access control — the identity half declared not applicable
- **Lands in:** `nfdr.md` § 3, QC-33
- **Reason it does not apply:** no identity exists — no account, no user record, no device
  identifier (`docs/SDD.md` § 4 C-D1; `docs/SRS.md` § 4.3 NFR-7; `docs/fdr.md` PD-33) — and
  authorization is the operating system's: the sandbox grant to the folder chosen in the Open panel
  is the product's whole authority (`docs/fdr.md` PD-14). The boundary that makes this true is
  stated in the entry: a hosted mode or a second folder, both out of scope (OOS-11, OOS-12), would
  revoke it. The privilege half of § 3 is *not* declared away: QC-34 – QC-37 bind what each part may
  reach.
- **Confirm or override:** confirm, with one correction on the fold: QC-33's revocation sentence
  names "a hosted mode or a second folder"; a second granted folder is still the operating system's
  grant and creates no identity, so it revokes nothing — drop it, or keep it only as a re-review
  trigger, which is what the entry's verified-by already says (a change adding "a hosted mode, an
  account, or any identifier"). The declaration and its ground stand. Reasoning:
  `docs/trail/architecture/self_answer-1.md` § 2.3.

### 2.4 § 7 — non-repudiation and accountability declared not applicable
- **Lands in:** `nfdr.md` QC-54
- **Reason it does not apply:** the product performs no action on the user's data and knows no user
  (`docs/fdr.md` PD-1, PD-33; OOS-1, OOS-2), so there is no action to record and no one to attribute
  it to. The entry names what would revoke it — a write path or an identity, both permanently out of
  scope. The diagnostic log (QC-52) records failures, not actions, and is not an accountability
  record.
- **Confirm or override:** confirm. Reasoning: `docs/trail/architecture/self_answer-1.md` § 2.4.

### 2.5 ADR-0009 — the physical module set, reconstructed
- **Lands in:** `adr/0009-physical-module-set.md`; `nfdr.md` § 1.2 – § 1.3
- **Drafted into the records:** four units — `nozoki-core` as a library both the host and the
  harness link; `nozoki-app` as the only Tauri-aware unit and the composition root; `nozoki-ui` as a
  capability-free bundle; `checks/` outside the bundle — with the part-to-unit map and the import
  graph § 1.2 binds. The record is **Proposed**, because its decision is read off the design rather
  than argued in it.
- **Rationale:** the SDD names the three deliverables and the harness and assigns every part
  (`docs/SDD.md` § 3), and its bars show core linked without the app (§ 4 C-I3; § 6 S-1), but none
  of its three decision surfaces weighs the crate split. A reconstructed record is honest; a silent
  decision left unrecorded is the gap the log exists to close. The alternatives in the record are
  this seat's readings, marked as such.
- **If overridden:** a different unit map rewrites § 1.2 and § 1.3 and the record moves to a new
  number superseding this one; confirming it moves ADR-0009 to Accepted on the fold.
- **Confirm or override:** confirm — ADR-0009 moves to Accepted, and the *(Reconstructed …)* marking on
  its alternatives stays, because it is the record's true context and not a hedge. The unit set
  itself is settled SDD content — § 3 names the three deliverables and the harness and gives every
  part a home — so what is reconstructed is the weighing alone, and the marking says exactly that.
  Reasoning: `docs/trail/architecture/self_answer-1.md` § 2.5.

### 2.6 QC-49 — the kill-mid-churn check added to the read-only harness
- **Lands in:** `nfdr.md` QC-49
- **Drafted into the records:** `checks/read-only.sh --kill` sends SIGKILL to the host during the
  churn script and re-hashes the fixture, so NFR-4's "during and after crashes and abnormal exits"
  is a machine check rather than an inference from the sandbox.
- **Rationale:** the SRS binds the promises through abnormal exit (`docs/SRS.md` § 4.2 NFR-4) and
  the SDD's harness hashes around a clean run only (`docs/SDD.md` § 4 C-I3); the sandbox is what
  makes the property true by construction (ADR-0003), and a check that proves it costs one flag on a
  script the SDD already names. It extends an SDD check, so it is put to you rather than added
  silently.
- **If overridden:** QC-49 keeps its trace to NFR-4 and downgrades to the sandbox probe (QC-25) as
  its verification, which proves the wall exists and not that a crash leaves the fixture whole.
- **Confirm or override:** confirm. Reasoning: `docs/trail/architecture/self_answer-1.md` § 2.6.

### 2.7 The tools this document names where the SDD named none
- **Lands in:** `nfdr.md` QC-27, QC-28, QC-41, QC-44, QC-53, and the `checks/structure.sh` rows of
  § 1 and § 3
- **Drafted into the records:** `cargo audit` and `pnpm audit --audit-level=critical` for the
  vulnerability gate; `gitleaks detect` for the secrets scan; `checks/structure.sh` as the grep-based
  layer-6 check over the Rust workspace; `checks/notices.sh`, `checks/readme.sh` and
  `checks/strings.sh` for the release inspections that mechanize; `cargo test -p nozoki-app --test
  config` for the CSP, capability-file and plugin assertions.
- **Rationale:** each obligation's source names the obligation and not the command — the
  organisation's floors for secrets and dependencies, the SDD's config and wording bars — and an
  entry with no command is a review gate the pipeline cannot run. Picking a tool is the CTO's
  toolchain lane, which is why the names reach you here rather than standing as settled; any tool
  with an exit code satisfies the same entry.
- **If overridden:** the entries keep their obligations and traces and swap the command in their
  tails and in § 10; nothing else moves.
- **Confirm or override:** confirm, with two corrections. (1) `gitleaks detect` is deprecated since
  gitleaks v8.19.0 — still available, hidden from `--help` — and the current commands are
  `gitleaks git` (a repository) and `gitleaks dir` (files), exit 0 on no leak and 1 on a leak or an
  error (https://github.com/gitleaks/gitleaks/blob/master/README.md); QC-28 and § 10 name
  `gitleaks git`. (2) `cargo audit` has no severity threshold — its only filter is
  `--ignore <RUSTSEC-id>` (https://github.com/rustsec/rustsec/blob/main/cargo-audit/README.md) —
  so "exit 0" gates on every advisory, stricter than QC-27's *critical*; the entry says so, and a
  non-critical advisory a release carries is ignored by id in the command, the ignore and its
  reason added in the change that adds it and reviewed as code the way `checks/deps.allow` is
  (QC-26). `pnpm audit --audit-level=critical` is as documented (https://pnpm.io/cli/audit). The
  other tools stand. Reasoning: `docs/trail/architecture/self_answer-1.md` § 2.7.

### 2.8 NFDR RN-2 miscounts the FDR companion — "eight items open" where the file holds thirteen

> **This item was raised by a `companion-self-answer` run answering this companion, not by a
> `product-architecture` run.** It came from reading `docs/nfdr.md` whole against
> `docs/fdr_open_issues.md`: a count in the review notes is false
> (`docs/trail/architecture/self_answer-1.md` § Raised on this document).

- **Lands in:** `nfdr.md` RN-2
- **Drafted into the records:** RN-2 reads "`docs/fdr.md` is Draft at v1 with eight companion items
  open (`docs/fdr_open_issues.md`)".
- **Rationale:** the FDR companion held thirteen items when this run read it — five open issues
  (§ 1.1 – § 1.5) and eight choices to confirm (§ 2.1 – § 2.8) — and this run appended a
  fourteenth (§ 2.9, raised from item 2.2 above; commit `98df76b`). "Eight" is the second bucket
  alone. A count in the note that records which upstream was Draft is a fact a cold reader trusts,
  and it is wrong.
- **If overridden:** nothing else moves. The note's substantive claim — that no NFDR trace turns on
  an item that companion holds — was read against all thirteen by this run and was not found false;
  the fourteenth is the NFDR's own question sent upstream, and QC-60 will trace to its answer.
- **Confirm or override:**
