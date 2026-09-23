# ADR-0011: The App Sandbox is the write-and-network wall, held by a rule and not by a list — no network entitlement ever, a read-only grant on the chosen folder, any other entitlement only with a record — and the folder is granted through the Open panel and never typed

**Status:** Proposed — supersedes ADR-0003 on acceptance
**Date:** 2026-09-23

## Context

ADR-0003 decided two things: the App Sandbox is the write-and-network wall, and the folder is
granted through the Open panel and never typed. Neither moved. What moved is the form of the
entitlement set that record's § Decision fixed — "**exactly these entitlements**", held as named
members.

The first bundle a person launched showed why a list is the wrong object. The bundle CI built from
`e7b2bcd` carried exactly the two v1 entitlements, passed every gate — reported sandboxed, the
out-of-grant read and the outbound connection both denied — and opened one empty window with no
Open panel and no response to a right-click (`docs/trail/sdd/cycle-8.md` § 5.1, the sample table;
`docs/SDD.md` § 10 RC-2). Re-signed with `com.apple.security.network.client` added, the window
drew. The mechanism is WebKit's and not this product's: every WebKit XPC service checks the *host's*
entitlements at its own start, and a sandboxed host without the network-client entitlement passes
only if its sandbox allows a `mach-lookup` of `com.apple.nsurlsessiond`
(`Source/WebKit/Shared/EntryPointUtilities/Cocoa/XPCService/XPCServiceEntryPoint.mm`,
`checkEntitlements`, at WebKit `bb75cbc0003033ea73c42ef02370767aa52d6ba6`; WebKit's own comment
beside it, "This requirement is too strict, it should be possible to load file:// resources without
network access", `rdar://problem/54178641`, open since 2019). No Tauri key, no WebKit setting and
no line of this product's reaches that check (`docs/SDD.md` § SDD Review Notes RN-52).

So the question the list had never asked was put to the owner: is the promise the list, or the
refusal? The ruling (`docs/trail/sdd/cycle-8.md` § 5.1, answers 1 and 2): the no-network promise
is **the operating system refusing an outgoing connection — never the list, and never the code
declining** — so `com.apple.security.network.client` is never granted although it is proven to make
the window draw, and "exactly these entitlements" gives way to a rule.

The forces ADR-0003 recorded stand unchanged and are restated so this record reads alone. The
read-only promises must hold during and after crashes and abnormal exits (`docs/SRS.md` § 4.2
NFR-4), and convention cannot promise that where an operating-system sandbox can (`docs/SDD.md`
§ 2, force 5). Under Apple's App Sandbox a folder is readable only when the user selected it — the
read-only entitlement grants "read-only access to files the user has selected using an Open or Save
dialog" (https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.security.files.user-selected.read-only)
— and outgoing connections are what a separate network entitlement enables
(https://developer.apple.com/documentation/bundleresources/security-entitlements). So the wall and
the start mechanism are one decision.

## Decision

The bundle runs under the App Sandbox, and its entitlement set is bound by a **rule**, not held as
a list:

1. **No network entitlement, ever** — not `com.apple.security.network.client`, not
   `com.apple.security.network.server`, and no exception entitlement that reaches the network under
   another name. The one WebKit's check would take —
   `com.apple.security.temporary-exception.mach-lookup.global-name` naming
   `com.apple.nsurlsessiond` — is named here so that its refusal is recorded and not assumed.
2. **A read-only grant on the chosen folder** — `com.apple.security.files.user-selected.read-only`
   under `com.apple.security.app-sandbox`.
3. **Any other entitlement only with a record in this log that names why it is needed**, and only
   where the bundle probe (ADR-0010) still finds the launched process sandboxed with the
   out-of-grant read and the outbound connection both denied.

The v1 set under that rule is the two entitlements in (2), and — from the slice that adds the
folder selector — `com.apple.security.files.bookmarks.app-scope`, whose need this record carries
forward from ADR-0003: a remembered folder is a security-scoped bookmark. No write under the granted
folder is possible because the grant is read-only; the wall holds through a crash because it is not
the process's to lower (`docs/SDD.md` § 4 C-R2).

The folder is **granted, never typed** — unchanged from ADR-0003 and restated whole: the host
presents the system Open panel, the grant is made once per folder, and a remembered folder is a
security-scoped bookmark re-opened without asking. Once the selector exists, launch restores the
last-viewed folder from its bookmark and presents the panel only when nothing is remembered or the
bookmark no longer resolves. A path that does not exist, is not a folder, or cannot be read is
reported in the app's window, never on a terminal (`docs/SDD.md` § 4 C-R3; owner-confirmed with the
per-folder reconciliation, `nozoki@70a879a:docs/trail/sdd/cycle-1.md` § 2.3).

**What the rule is known to cost.** Under it the system WKWebView does not start in this bundle
(`docs/SDD.md` § 10 RC-2). Which gives way — the renderer ADR-0002 names, or nothing — was the
owner's, and the owner has answered it on the SDD's companion: the renderer leaves WKWebView
(`docs/SDD_open_issues.md` § 1.1, *Answer*, at `nozoki@a1d8f2c`). That answer is not folded into
the SDD as this record is written — § 4 C-R1 still renders in WKWebView — and what replaces the
renderer is the SDD's § 2 to weigh. It is recorded here as the cost the rule was chosen with, and
it lands in this log as its own record when the SDD carries the replacement (§ Consequences).

## Alternatives ruled out

- **Exactly the list** — ADR-0003's form. A list names members and cannot say what makes a member
  acceptable: it forbade an entitlement with a recorded need, which the rule admits, and it could
  not name the one thing the owner refused — a network entitlement — as different in kind from a
  bookmark entitlement. Retired on the owner's ruling (`docs/trail/sdd/cycle-8.md` § 5.1, answer 2).
- **The sandbox with `com.apple.security.network.client`** — proven to make the shipped window
  draw (the sample table's third row) and refused by the owner (answer 1): granting it makes "no
  network" a promise the code keeps, which is the thing the wall exists to rule out. ADR-0003 ruled
  it out on a weaker ground — nothing needs a connection (`docs/SRS.md` § 4.3 NFR-8) — that no
  longer holds: something does need it, and it is refused all the same.
- **The mach-lookup exception alone** — `com.apple.security.temporary-exception.mach-lookup.global-name`
  for `com.apple.nsurlsessiond`, which passes WebKit's check with no network entitlement by name.
  Refused for what passing the check starts, not for the service's name: WebKit's Networking
  process, whose own sandbox profile allows outbound TCP and UDP unless it inherits the host's block
  — an inheritance that reached macOS in WebKit on 2026-08-22 and depends on the SDK the host is
  linked against — so on the macOS 14 floor the page would sit behind a process the operating system
  lets connect, with only the CSP between it and the network; and the bundle probe, which asks about
  the host's pid, would stay green without seeing it (`docs/SDD.md` RN-56;
  `docs/trail/sdd/self_answer-19.md`; the CTO's corrected ground in `docs/SDD_open_issues.md`
  § 1.1). The CPO's product ground stands beside it: an entitlement naming the network daemon on
  the file a reviewer reads, and a README proof sentence the harness could not back
  (`docs/SDD.md` RN-58).
- **No sandbox, with a typed path or a launch argument as the start** — ADR-0003's first
  alternative, not taken at `nozoki@70a879a:docs/trail/sdd/cycle-1.md` § 2.3 and refused again as
  exit (d) on the SDD's companion: the read-only entitlement goes and the OS wall goes with it.
- **Waiting for Apple to drop the check** — WebKit's own FIXME says the check goes "once WebKit can
  work without network access"; the radar is from 2019, the file is unchanged since 2026-01-29, and
  the Agari's third condition cannot wait on a date nobody has given (`docs/SDD_open_issues.md`
  § 1.1, exit (e); `docs/trail/sdd/self_answer-20.md`).

## Consequences

Easier: everything ADR-0003 made easier stands — no write and no connection because the operating
system refuses, not because the code declines; the read-only, Git-state and zero-traffic checks
(`docs/SRS.md` § 8 AC-1 – AC-3) hold structurally. And the wall is now stated in the form a
reviewer can hold any future bundle to: a fourth entitlement is either recorded in this log or is
a violation, and a network entitlement is a violation whatever record claims it.

Harder: the Open panel is the start, which can read as a setup step to a stranger (`docs/SDD.md`
§ 11 R-9); remembering a folder needs bookmarks; a linked worktree or a submodule whose Git
directory lies outside the granted folder cannot be read past the grant (`docs/SDD.md` § 11 R-3;
`docs/fdr.md` R-21) — unchanged from ADR-0003. New: the renderer ADR-0002 names cannot start under
this rule, so the runtime decision is reopened by the owner's answer, and until the SDD carries the
replacement no build meets `open-a-folder`'s command bar (`docs/SDD.md` § 6 S-1) and every later
slice waits on it (§ 7). And the wall gate's green is no longer read as a bundle a person can use —
that is ADR-0012's gate, which runs beside this wall's probe.

What undoing it costs: one entitlements file — and the wall (`docs/SDD.md` § 9 TO-3); and now a
reversal of the owner's ruling, which lands as a record superseding this one, never as an edit to
`crates/nozoki-app/Entitlements.plist` alone.

**What this rests on, and whose it stays.** The App Sandbox, its entitlement semantics and the
Open-panel grant are Apple's and move with macOS on Apple's schedule, as ADR-0003 said. The rule
also rests on a second platform fact it collides with rather than uses: WebKit's entitlement check
in its XPC services' launch path — Apple's, undated, and the reason the renderer question was
opened. If Apple drops the check, nothing here moves — the rule is about the wall, not the renderer
— and WKWebView returns to the SDD's § 2 as a candidate. If Apple narrows what a user-selected grant
covers, what is un-made is the start mechanism (C-R3) and the bookmark path, not the shape
(ADR-0001), whose renderer still holds nothing. Of the two things ADR-0003 held unverified from
documents, one has since been measured — the sandbox is enforced under an ad-hoc signature
(ADR-0010; `docs/SDD.md` § 10 RC-1) — and the drop / Open-With grant stays an SDD Open Question.

## Traces to

- `docs/SDD.md` at v12 (`nozoki@6ebdc42`, Draft) — § 1, the read-only bullet; § 4 C-R2 (the rule,
  and "departs from ADR-0003 on the one word *exactly*"), C-R3; § 10 RC-2; § 12, the downstream
  boundary; § SDD Review Notes RN-51, RN-52, RN-56, RN-58.
- `docs/trail/sdd/cycle-8.md` § 5.1 — the owner's ruling: answers 1 and 2 (the rule), answer 3
  (the mechanism owed, and found at RC-2).
- `docs/SDD_open_issues.md` § 1.1 at `nozoki@a1d8f2c` — the owner's answer that the renderer leaves
  WKWebView, and the three seats' priced exits; `docs/trail/sdd/self_answer-19.md`,
  `self_answer-20.md`.
- ADR-0003 — the record this one supersedes; its decision is restated here whole, so nothing in
  this record depends on that one being open. Its traces stand under this record:
  `nozoki@70a879a:docs/trail/sdd/cycle-1.md` § 2.3; `docs/SRS.md` § 4.2 NFR-4, § 4.3 NFR-5, NFR-8,
  NFR-9, § 3.1 FR-2, FR-3; `docs/fdr.md` R-3, R-4, R-5, R-7, R-8, R-21, R-98, PD-7, PD-14, OOS-19.
- Apple's two entitlement pages, cited above as ADR-0003 and C-R2 cite them. The WebKit sources —
  `XPCServiceEntryPoint.mm` at `bb75cbc0003033ea73c42ef02370767aa52d6ba6`,
  `NetworkProcessCocoa.mm:L90-L121` and `com.apple.WebKit.NetworkProcess.sb.in:L492-L496,
  L563-L568` at the same commit — were read at those locators by the SDD's seats and the
  self-answer runs named above; this record transcribes their reading and re-read none of them.
- `docs/architecture_open_issues.md` § 2.1 — the item that carries this record for the owner's
  confirm; the record is Proposed until that answer, and ADR-0003 stays in force until then.

## Binds

QC-25. On acceptance, the entries ADR-0003 binds move here with it: QC-2, QC-32, QC-33, QC-35,
QC-49, QC-58.
