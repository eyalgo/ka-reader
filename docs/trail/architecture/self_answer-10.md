# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `adr/` and `nfdr.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-23
- **Sources re-read:** GitHub Actions run 35797893381, re-read with `gh run view 35797893381 --log`
  on 2026-09-23. The log holds four five-ask blocks. Two answered `sandboxed: no` with the
  outbound connection `allowed` on ask 1, then `sandboxed: yes` with both operations `denied` on
  asks 2–5. One answered `yes`, both `denied`, on all five asks. One — the unentitled copy, as
  RN-48 labels it — answered `sandboxed: no`, `out-of-grant-read: denied`,
  `outbound-connection: allowed` on all five asks. The one-ask *Bundle probe* step answered
  `sandboxed: no` and failed. This is the same record `docs/SDD.md` RN-48 and § 3.3 cite. No vendor
  page was re-read: no answer here rests on Apple's or Tauri's published text beyond what ADR-0010
  already records.

## Items worked

### 3.1 — QC-3 closes over itself: the allowlist is what the check compares against, so nothing proves the allowlist is transport-free

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The PM's lean holds, and it holds for the reason given. `checks/no-network.sh` proves
  that the tree equals the list and cannot fail on the thing QC-3 states. I measured the item's own
  case at `nozoki@9b36a42`: the script exits 0 with `tokio` (`checks/deps.allow:L204`) and
  `crypto-common` (`:L51`) on the list. Naming QC-26's same-change review as the second half makes
  QC-3 point at what `docs/SDD.md` § 4 C-R6 already says: the allowlist change "is reviewed in the
  same change", and "no shipped unit links a network transport". So this re-derives QC-3 from its
  upstream and does not move it. **It is a correction, not a widening.** The NFDR's own preamble
  says an entry with no nameable verification is not yet an entry, and QC-3's domain half has none.
  It also cites an occurrence, the measured run above. **Addition one: the review has to be told
  its question, and the question reaches features.** QC-26 says only that the change is
  "deliberate". That review, pointed at unchanged, would admit a transport that was added on
  purpose. So QC-3's second half says the review judges each added name against QC-3's domain, in
  the features the lockfile resolves. A name alone cannot answer that. `cargo tree --offline
  --locked -e features -i tokio` at `nozoki@9b36a42` resolves `bytes, default, fs, io-util, rt,
  rt-multi-thread, sync` and no `net`, so `tokio` links no socket today, and the name says nothing
  either way. QC-3's own first clause — libgit2 without its HTTPS and SSH transports — is purely a
  feature condition. C-R6 names "a transport-bearing build of libgit2" as a violation, and the name
  diff cannot see it once `git2` lands. (No `git2` is in `crates/*/Cargo.toml` today; a grep found
  none.) **Addition two, check 4's stale case, named:** the 381 names already on the list
  (218 cargo, 163 pnpm, from the script's own output) passed the diff but carry no record of being
  reviewed against the domain. A review that runs only on additions never reaches them. So the
  entry requires that review once, recorded in the change that realizes the new tail. After that,
  every name on the list has passed one review or the other. § 10's QC-3 row gains the review
  beside the script. **What would have tipped it the other way:** if QC-26's review already stated
  a transport criterion, this would have been a bare *confirmed*. It does not
  (`docs/nfdr.md:L244-L250`).

### 3.2 — ADR-0010 and QC-25 fix what the probe must read, not when — and the first CI runs read too early

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** Decided together with § 3.3, because both land on the same two records. **Seat:**
  this is the Principal Architect's call, and the item says so. It is not the owner's: it commits
  nothing to a person or an outside party, and it binds only how the records agree with the SDD.
  **The lean holds — no superseding record.** ADR-0010 fixed the observable (`sandbox_check` on the
  launched main process's pid), its three answers and a negative control. None of that has moved.
  `docs/SDD.md` § 4 C-I3 at v8 says "the bound is the script's to fix and this document states no
  number" (`docs/SDD.md:L537`). So the window is a parameter the SDD hands to the script, and a
  decision record is not where it lives. ADR-0010's own cost line for another record is
  "replacing the observable", and that has not happened. The ADR's words still hold under the
  window: "fails unless the operating system reports that pid as sandboxed" is true of the first
  ask where all three hold, and "requires it to fail" is true of a control that must answer `no`
  on every ask. I came close to a new record over the control, since the control got stricter. It
  still "fails", so I did not; had the ADR fixed a one-ask read in its § Decision, I would have
  written one. **Addition one: QC-25 is re-derived now, not "maybe".** The item hedged on whether
  QC-25 was owed a change once the SDD folded § 5.1. The SDD has folded it (v8, RN-48, `nozoki@9b36a42`),
  and under the SDD's own rule the § 4 statement wins and the NFDR entry is re-derived. QC-25's
  *verified by* takes these sentences from C-I3 at v8:
  - one ask inside a bounded window, with the pass on the first ask where all three hold;
  - the bound fixed and printed by the script;
  - a check before every ask that the pid still names a process, and a process gone before the
    pass fails;
  - the control answering `sandboxed: no` on every ask for the whole window;
  - `sandbox_check` missing or erroring on any ask fails;
  - the uncovered `yes` → `no` case, named.

  **Addition two: two sentences are now false.**
  - QC-25's "asserts nothing about a GitHub-hosted runner … settled by the probe's first CI run"
    (`docs/nfdr.md:L227-L243`) is false, because the run happened.
  - ADR-0010's closing paragraph, "One case is unmeasured … open in `docs/SDD.md` § Open
    Questions" (`docs/adr/0010-…:L121`), points at an Open Questions item SDD v8 closed and
    removed.

  Both are corrections of a fact measured false. The ADR paragraph is corrected in place to a
  dated note pointing at SDD RN-48, the same kind of prose correction the log took in NFDR v5 and
  v6 without a superseding record. The § 10 row does not move, since `checks/bundle.sh` is still
  the command. **Supporting text that is now wrong, reported and not edited:** the item points
  twice at `docs/SDD_open_issues.md` § 5.1. That file is gone; the SDD removed it at v8, and
  the item now sits whole at `docs/trail/sdd/cycle-6.md` § 5.1. The fold should cite the trail.

### 3.3 — On a hosted runner the out-of-grant read is reported denied for an unsandboxed process too — ADR-0010's "not a correlate" holds for the network half only there

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** Decided together with § 3.2. **The measurement holds at its source.** I re-read run
  35797893381 (see Header). The unentitled copy's `out-of-grant-read: denied` appears on all five
  asks, and so does the real bundle's unsandboxed first ask. `checks/sandbox_probe.rs:L76-L81`
  reads any non-zero `sandbox_check` result as denied. So on that runner the read denial does not
  tell the wall from its absence. **The lean holds — a correction, not a new record.** The
  observable, the mechanism and the pass condition all stay the same. The probe still requires
  all three answers, which does no harm, because on the runner the read is denied either way. Only
  the claim about what the read proves gets narrower. `docs/SDD.md` § 4 C-I3 at v8 already carries
  the narrowed sentence and says the Mac's reading for the control is not recorded, so the records
  follow their upstream. **Addition: the claim is in § Decision too.** The item names only
  § Consequences. But ADR-0010 § Decision says "the two denials test the wall itself rather than
  a proxy for it" (`docs/adr/0010-…:L53`), and a correction that leaves it standing would leave the
  record contradicting itself. Both sentences are corrected, and QC-25 takes C-I3's sentence when
  it is re-derived under § 3.2. **Named uncovered case (check 4, absent):** why the runner reports
  it this way, and what the owner's Mac reports for the control's read, are both unknown. The
  corrected sentences say so, as C-I3 does, rather than claim the Mac separates the two.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`adr/` and `nfdr.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/skill/launcher.sh product-architecture nozoki`
