# Architecture open issues — Nozoki

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
>
> **§ 3 is raised, not asked.** These records bind every later change, so the seats that live under
> them find gaps the authoring run could not. § 3 is where such a seat says so, against both records
> — an ADR's binding and an NFDR obligation reach the same file.

> **No `product-architecture` run opened this companion. The PM opened it on 2026-09-20, from a
> post-build review.** Both records are Settled at NFDR v8 and had no companion on disk. Without one,
> a `product-architecture` re-run would read them as done and find nothing to act on. The companion
> holds one § 3 item: QC-3 states a domain — no network transport — and is verified by a check that
> compares the tree to the allowlist, which proves nothing about the allowlist's own membership.
> The PM added § 3.2 on 2026-09-23, from the first CI runs on a GitHub-hosted runner: ADR-0010 and
> QC-25 fix what the sandbox probe reads and not when, and the first runs read it too early.

---

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-3 closes over itself: the allowlist is what the check compares against, so nothing proves the allowlist is transport-free
- **Raised by:** PM — 2026-09-20
- **Which record:** NFDR § 1 QC-3 and its § 10 row
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing fails today, and that is the point — the check cannot fail on the thing
  QC-3 is about. QC-3 states a domain ("No shipped unit links a network transport") and is *verified
  by* `checks/no-network.sh` diffing `cargo tree` and `pnpm ls` against `checks/deps.allow`
  (`nfdr.md:L60-L63`). That diff proves the tree and the list agree. It says nothing about whether a
  name **on the list** is a transport, so the domain half of QC-3 is verified by nothing the § 10 row
  names.
- **Where it shows:**
  - QC-3 (`nfdr.md:L60-L63`) and its § 10 row (`nfdr.md:L665`) — both name `checks/no-network.sh`
    and no second gate.
  - Measured on the tree at `nozoki@92a76c4`: `bash checks/no-network.sh` → `ok — 218 cargo names and
    163 pnpm names match checks/deps.allow`, exit 0, while `checks/deps.allow:L51` holds
    `crypto-common` and `:L204` holds `tokio`. Neither is a transport by name, and nothing in the
    harness or in either record traces what admitted them.
  - QC-26 (`nfdr.md:L244-L250`) **is** the record that carries the human half — "fails the build
    until the allowlist change is reviewed as code in the same change" — but QC-3's *verified by*
    does not point at it, so a seat implementing QC-3 alone builds a diff and stops.
- **If a document has to be written:** none. What is owed is QC-3's *verified by* stating both halves
  — the diff that proves tree-equals-list, and the review that admits a name to the list at all. The
  PM's lean is to name QC-26's same-change code review as the closing half, so the domain is
  enforced by a gate the records point at rather than by the reader's assumption.
- **Answer:** Answered in the owner's seat by a `companion-self-answer` run, 2026-09-23. **Yes —
  QC-3's *verified by* states two halves, and the second is QC-26's same-change review, told what
  question to ask.** (1) *The tree equals the list*: `checks/no-network.sh`, as now. (2) *The list
  holds no transport*: the allowlist change reviewed as code in the same change (QC-26, at
  `development-design`), and that review judges each added name against QC-3's domain — does it,
  **in the features the lockfile resolves**, link a network transport — not only whether it is
  deliberate. The features clause is needed because a name alone cannot answer QC-3. `tokio` is on
  the list (`checks/deps.allow:L204`), and at `nozoki@9b36a42` `cargo tree --offline --locked -e
  features -i tokio` resolves `bytes, default, fs, io-util, rt, rt-multi-thread, sync` and no
  `net`, so today it links no socket. And QC-3's own first clause, "libgit2 is built without its
  HTTPS and SSH transports", is a feature condition that a name diff cannot see at all once `git2`
  lands. That is the transport-bearing libgit2 build `docs/SDD.md` § 4 C-R6 names under *Violated
  by*. The upstream already carries this half: C-R6 says the allowlist change "is reviewed in the
  same change" and that "no shipped unit links a network transport", so this makes QC-3 point at
  what C-R6 states. It is a correction, not a widening: the NFDR's own preamble says an entry with
  no nameable verification is not yet an entry, and QC-3's domain half has none. **One case the
  review does not reach, named:** the 381 names already on the list (218 cargo, 163 pnpm, `bash
  checks/no-network.sh` at `nozoki@9b36a42`) went through the diff but were never recorded as
  reviewed against the domain. The entry should require that review once, recorded in the change
  that realizes the new tail. § 10's QC-3 row gains the review beside the script. Reasoning:
  `docs/trail/architecture/self_answer-10.md` § Items worked, 3.1.

### 3.2 ADR-0010 and QC-25 fix what the probe must read, not when — and the first CI runs read too early
- **Raised by:** PM — 2026-09-23
- **Which record:** ADR-0010 § Decision and § Consequences; NFDR § 1 QC-25 and its § 10 row
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`; the fix to the probe is the change
  unit `nozoki · tobiishi · 2026-09-23_the-probe-waits-for-the-sandbox`
  (`kensaiapp-opensource@1523865`); the SDD side is `docs/SDD_open_issues.md` § 5.1
- **What it blocks:** Nothing waits on it to be built. The change unit makes `checks/bundle.sh` wait,
  bounded, for the first `sandboxed: yes`, and makes the negative control answer `no` for the whole
  window. Both records say "fails unless the operating system reports that pid as sandboxed" and
  neither says when the report is read, so the change fits the words as they stand. What is
  owed from this side is a ruling that it does — or a record that says otherwise.
- **Where it shows:**
  - ADR-0010 § Decision: the probe "fails unless the operating system reports that pid as sandboxed
    and reports two operations denied for it"; QC-25 (`nfdr.md:L227-L233`) states the same. No
    timing in either.
  - ADR-0010 § Consequences: "a probe that fails while the wall stands redraws the probe and no
    slice"; and replacing the *observable* costs "a superseding record here". The change reads the
    same observable, `sandbox_check`, and changes only when it is read.
  - ADR-0010 closes on "One case is unmeasured": the hosted runner, "settled by the probe's first CI
    run". Measured: run 35797893381 (`macos-14`, SIP disabled) reported the real bundle
    `sandboxed: no` on ask 1 and `sandboxed: yes`, both denied, on asks 2–5, 0.25 s apart; an
    unentitled copy `no` on all five. The same first-ask `no` shows on the owner's Mac for a freshly
    re-signed copy. Full table: `docs/SDD_open_issues.md` § 5.1.
  - The negative control as recorded — "requires it to fail" — passes on one `no`, and one early
    `no` is what an entitled launch can report too. The change makes it stricter; that sentence of
    ADR-0010 is where a reader would look for the rule.
- **If a document has to be written:** none, on the PM's lean. The log is append-only, and the
  observable has not moved, so no superseding record is owed. What may be owed is QC-25's *verified
  by* naming the bounded window and the control's whole-window rule, re-derived from C-I3 once the
  SDD's § 5.1 is folded. Doubt: if the window is read as part of the mechanism ADR-0010 fixed, it is
  a new record superseding it, and that is this seat's call, not the PM's.
- **Answer:** Answered in the owner's seat by a `companion-self-answer` run, 2026-09-23, decided
  together with § 3.3. **The window is a correction, not a new record. ADR-0010 is not superseded,
  and QC-25 is re-derived from `docs/SDD.md` § 4 C-I3 as it reads at SDD v8.** The mechanism
  ADR-0010 fixed has not moved: the same observable (`sandbox_check` on the launched main
  process's pid), the same three answers, and a negative control. C-I3 at v8 says "the bound is
  the script's to fix and this document states no number" (`docs/SDD.md:L537`), so the
  window is a parameter the SDD hands to the script, and no record decides it. ADR-0010's
  "requires it to fail" is still true of a control that must answer `sandboxed: no` on every ask.
  The line ADR-0010 draws for another record is "replacing the observable", and that has not
  happened. **QC-25's *verified by* takes C-I3's v8 sentences.** They are: one ask inside a
  bounded window after launch, with the pass on the first ask where all three hold; the bound
  fixed and printed by the script; a check before every ask that the pid still names a process,
  and a process gone before the pass fails; the control answering `sandboxed: no` on every ask
  for the whole window; `sandbox_check` missing or erroring on any ask fails; and the uncovered
  case named, a report that turns `yes` → `no` after the pass. **Two sentences are now false and
  get corrected.** QC-25's "asserts nothing about a GitHub-hosted runner … settled by the probe's
  first CI run" is false because the run has happened (SDD RN-48). ADR-0010's closing paragraph,
  "One case is unmeasured … open in `docs/SDD.md` § Open Questions", points at an Open Questions
  item SDD v8 closed and removed. That paragraph is corrected in place to a dated note pointing at
  SDD RN-48, the kind of prose correction this log has taken before without a superseding record
  (NFDR v5 and v6 pins). The § 10 row does not move, since the command is the same. Reasoning:
  `docs/trail/architecture/self_answer-10.md` § Items worked, 3.2.

**How it closes.** `product-architecture` folds it on its next run like any other item here.

### 3.3 On a hosted runner the out-of-grant read is reported denied for an unsandboxed process too — ADR-0010's "not a correlate" holds for the network half only there

> **No `product-architecture` run wrote this item.** A `companion-self-answer` run answering
> `docs/SDD_open_issues.md` § 5.1 raised it on 2026-09-23, while re-reading the CI run that item
> cites. The report is `docs/trail/sdd/self_answer-12.md` § Items worked, 5.1. It is a separate
> question from § 3.2, which asks *when* the probe reads; this one asks whether one of the three
> answers it reads tells anything apart on the runner.

- **Raised by:** companion-self-answer, answering `docs/SDD_open_issues.md` § 5.1 — 2026-09-23
- **Which record:** ADR-0010 § Consequences ("a sandbox probe that tests the two denials the wall
  promises, so its green means the wall and not a correlate of it"); NFDR § 1 QC-25
- **Where it shows:** run 35797893381 (`macos-14`, step *Sandbox diagnostic (temporary)*,
  `gh run view 35797893381 --log`, read 2026-09-23). The unentitled copy answered
  `sandboxed: no`, `out-of-grant-read: denied`, `outbound-connection: allowed` on all five asks, and
  the real bundle's unsandboxed first ask answered the same. `checks/sandbox_probe.rs:L76-L81` prints
  `denied` for any non-zero `sandbox_check` result, so `sandbox_check` said *denied* for a read of
  `~/.zshrc` by a process it also called unsandboxed. On the runner, then, that denial is reported
  with the wall and without it. The control still goes red there, on `sandboxed` and on the outbound
  connection. But the control as `checks/bundle.sh` runs it asks only whether the copy is *not
  sandboxed*, so nothing checks that the read half separates anything. Why the runner reports it
  that way is not known. Whether the owner's Mac reports the read *allowed* for the unentitled
  copy is not recorded anywhere this run read.
- **What it blocks:** Nothing is waiting on it to be built. The wall is still proved on the runner by
  the two answers that do separate the builds. What is wrong is the claim that the two denials are
  both the wall and not a correlate. On a hosted runner that is true of one of them.
- **The lean:** ADR-0010's § Consequences (and QC-25's *verified by*, when it is re-derived from
  C-I3) should say that on a GitHub-hosted runner the out-of-grant read is reported denied for the
  unentitled control too, so there the wall is evidenced by `sandboxed` and the outbound denial.
  The SDD's § 5.1 answer carries the same addition into C-I3. Whether that sentence is a correction to
  the record or a new record superseding it is this seat's call, as § 3.2 already asks about the
  window. The lean is that it is a correction: the observable and the mechanism stay the same, and
  one of its three readings turns out to separate nothing on one host.
- **Confirm or override:** confirm — with one addition: the claim is not only in § Consequences.
  ADR-0010's **§ Decision** also says "the two denials test the wall itself rather than a proxy for
  it", so the correction reaches that sentence too. It stays a correction, because the probe still
  requires all three answers and only the claim's scope narrows. It follows `docs/SDD.md` § 4 C-I3
  at v8, which already says this, and QC-25 takes the same sentence when it is re-derived (§ 3.2,
  decided together). Reasoning: `docs/trail/architecture/self_answer-10.md` § Items worked, 3.3.
