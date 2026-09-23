# Self-answer report — docs/SDD.md

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v12, Draft)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-23
- **Sources re-read:** WebKit, through the GitHub API on 2026-09-23:
  - `Source/WebKit/Shared/EntryPointUtilities/Cocoa/XPCService/XPCServiceEntryPoint.mm`, read at
    the cited commit `bb75cbc0003033ea73c42ef02370767aa52d6ba6` and at `main`. `checkEntitlements()`
    is the same in both. A sandboxed host passes only if it holds
    `com.apple.security.network.client`, or if a `sandbox_check_by_audit_token(…, "mach-lookup",
    SANDBOX_FILTER_GLOBAL_NAME | SANDBOX_CHECK_NO_REPORT, "com.apple.nsurlsessiond")` returns 0.
    Otherwise it logs "Application does not have permission to communicate with network resources"
    and returns false. Both FIXMEs (`rdar://problem/54178641`) are still in place on `main`. The
    last commit to touch the file is `206bc9777c` (2026-01-29, "Reduce use of protected functions
    in Source/WTF").
  - `Source/WebKit/NetworkProcess/cocoa/NetworkProcessCocoa.mm:L90-L121` at the same commit.
    `blockNetworkAccessIfNeeded` returns early on macOS unless the linked-on-or-after check for
    `NetworkProcessInheritsNetworkAccessFromUIProcess` passes. It also returns early for a
    platform-binary host. Otherwise it sets `BlockNetworkAccess` when the host's
    `network-outbound` is denied. The file's history shows `cb7daacd43` (2026-08-22), "[macOS] The
    Networking process sandbox should inherit network access from the UI process", as the item
    says.

## Items worked

### 2.1 — C-I3 names ADR-0008 as its record, but ADR-0010 superseded ADR-0008 on 2026-09-19

- **Bucket:** 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override
- **Verdict:** confirmed
- **Why:** The draft holds, and it holds for the reason it gives.
  - **Check 1: this seat's.** The answer only keeps one citation in this document consistent. It
    commits nobody to anything, and the change lands in `SDD.md` alone.
  - **Check 2: the draft is sound.**
    - `docs/SDD.md:L620` now reads "The record is ADR-0010".
    - ADR-0008's status is "Superseded by ADR-0010"
      (`docs/adr/0008-harness-over-core-and-bundle-probe-from-first-build.md:L3`).
    - ADR-0010 is "Accepted — supersedes ADR-0008"
      (`docs/adr/0010-harness-over-core-and-bundle-probe-reads-the-os-sandbox-report.md:L3`).
    - The index agrees (`docs/adr/README.md`, the ADR-0008 and ADR-0010 rows).
    - RC-1's new dated parenthesis says QC-25 now reads the sandbox report. That is true:
      `docs/nfdr.md` QC-25 describes the `sandbox_check` ask on the launched pid, not the
      environment marker.
    - Leaving RN-11 and RN-45 alone follows the document's own rule that a note is dated history
      (RN-55).
  - **Check 3: it contradicts nothing.** ADR-0010 carries C-I3's bundle-probe observable. The
    renderer gate that C-I3 gained at v11 claims no record. That is the Principal Architect's
    question, and it is already open at `docs/architecture_open_issues.md` § 2.1. The draft does
    not pre-empt it.
  - **Check 4: failure paths.**
    - *Stale:* a later record might supersede ADR-0010 for the renderer gate. The draft's *If
      overridden* already says the citation then moves again at that fold.
    - *Refused:* if the owner takes (a) on § 1.1, C-I3's renderer gate is re-derived for a native
      view. ADR-0010's bundle probe is unaffected, so the citation still holds.
  - **What nearly changed the verdict.** § 12's downstream boundary says "The decision log already
    holds nine records written from the previous SDD (`docs/adr/README.md`, ADR-0001 – ADR-0009)",
    and the log now holds ten. I weighed adding this as a *confirmed with addition*. I did not,
    because the sentence counts the records written from the previous SDD, and that count is
    still nine. A tidier phrasing would help, but no reader is misled, and the prompt does not
    reopen a document for that. If the owner reads "already holds" as a claim about the whole log,
    it is one line for the CTO on the same fold.

## Left for the owner

### 1.1 — Under C-R2's rule the system WKWebView cannot start — so the renderer gives way, or the rule's reach does, and which is yours

- **Bucket:** 1. Open issues — questions with no answer yet. All three seats have written a
  position into it, (a) in every case, so this run treated it as a draft.
- **Verdict:** left for the owner
- **Why:** Every exit breaks a call the owner already made, so choosing one is the owner's.
  - Keeping WKWebView means reading down the owner's own ruling. "No network entitlement, ever"
    comes from `docs/trail/sdd/cycle-8.md` § 5.1, answer 1.
  - Leaving WKWebView reverses the runtime the owner confirmed
    (`nozoki@70a879a:docs/trail/sdd/cycle-1.md` § 2.2, cited at `docs/SDD.md` § 10 RC-2). It also
    reverses `docs/fdr.md` PD-29's "not replaceable inside the terminus".

  This run can name three grounds it cannot see:
  - **The release date.** Under (a), every later slice waits on a rewrite of `surfaces`. The CPO
    prices that as the first-release date moving out, and this run has no view of the owner's plan
    for that date.
  - **How the owner reads their own rule.** Answer 1 refuses network entitlements in spirit.
    Answer 2 admits "any other entitlement only with an ADR that names why it is needed, and only
    where the probe (C-I3) still finds … the outbound connection … denied". Read to the letter, (c)
    passes that test, because `checks/bundle.sh` asks only about the host pid, and the host stays
    denied under (c). Only the owner can say which reading they meant.
  - **Reversing a confirmation they gave.** The runtime was confirmed by the owner, not chosen by
    a seat.

  This run's earlier pass already left the item for the owner (`self_answer-19.md`). Its reasoning
  has since been folded into all three seats' positions (RN-56, RN-57, RN-58), and the grounds
  above have not moved. I ran all four checks again, and they reach the same answer.
- **The answer I would have given:** **(a). The renderer leaves WKWebView. I agree with all three
  seats and add one new measurement.**
  1. **(e) is still no exit, measured today.** `checkEntitlements` reads the same on WebKit
     `main` on 2026-09-23 as at the cited commit, with both FIXMEs still in place. Nothing has
     touched the file since 2026-01-29 (`XPCServiceEntryPoint.mm`, `206bc9777c`). So nothing
     suggests Apple is about to remove the check.
  2. **(c) fails on the owner's own ground, not only on its name.** Passing the check starts
     WebKit's Networking process. Its own sandbox profile allows outbound connections unless it
     inherits the host's block. That inheritance reached macOS in WebKit on 2026-08-22
     (`cb7daacd43`), and it also depends on which SDK the host was linked against
     (`NetworkProcessCocoa.mm:L90-L121`). On the macOS 14 floor (C-R5), the page would then sit
     behind a process the operating system lets connect. Only C-R7's CSP would hold it, which is
     "a promise the code keeps", the thing answer 1 rules out. C-I3's probe would stay green,
     because it reads the host pid, and so would `README.md:L50-L51`'s "proves the no-network
     promise on every build" (RN-58).
  3. **(b) and (d) are already refused by the owner.**

  **How (a) holds up on the failure paths:**
  - **Refused:** if the owner refuses (a) as well, only (e) is left. `open-a-folder` then has no
    end date, and the Agari's third condition cannot be reached.
  - **Stale:** if WebKit ever drops the check, WKWebView is back in contention. That is § 2's
    re-weighing when it happens, not a reason to wait now.
  - **Absent:** a single-process native view has no second process with its own network profile.
    The host's missing entitlement then covers the whole product, and C-I3's host-pid probe covers
    all of it.

  **What follows from (a), and is not decided here:**
  - Which native toolkit to use is § 2's (the CTO's).
  - `DESIGN.md`'s realisation sentence belongs to the CDO's own run.
  - `README.md:L48-L49` goes with the README (the CPO's).
  - Superseding ADR-0002 and reversing PD-29 belong to the Principal Architect and the Principal
    PM, once the owner has chosen.

  **If the owner reads the rule as leaving (c) open,** measure (c) before choosing it. Use a
  (c)-signed bundle on macOS 14, and try an outbound fetch from inside the page, with the CSP
  loosened in a throwaway build. It passes only if the operating system refuses the fetch.

## Skipped

None this run.

## Raised on this document

### 2.2 — § 10 RC-2 still gives the reason for refusing (c) that the CTO withdrew at run 11

- **What the document is owed:** RC-2's *Observed reality* sentence at `docs/SDD.md:L2053-L2055`
  keeps its words and gains a dated parenthesis. The parenthesis says the ground was withdrawn at
  run 11 and points at the corrected ground (RN-56; companion § 1.1). It takes the shape RC-1's
  *Changed* took at v12.
- **Why it is worth a cycle:** *A fact in it is now false.* It is a claim about a source outside
  this repository. The sentence says the `mach-lookup` exception is refused because "the service
  it opens is the one WebKit's own check treats as network access". WebKit's check opens nothing.
  It asks the sandbox with `SANDBOX_CHECK_NO_REPORT` whether the lookup is allowed
  (`XPCServiceEntryPoint.mm`, re-read today at the cited commit and at `main`), and the CTO
  withdrew this ground in the companion (RN-56). The CDO and the CPO have both moved their
  positions to the corrected ground (RN-57, RN-58), so RC-2 is the one place in the document that
  still carries the old one. It costs no extra cycle, because it rides the fold that § 2.1's
  answer already owes.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh nozoki`
