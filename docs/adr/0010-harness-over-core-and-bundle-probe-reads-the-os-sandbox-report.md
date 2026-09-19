# ADR-0010: The read-only proof runs against `nozoki-core` and the IPC command list, not the rendered UI, and the bundle probe — on every build from the first — reads the operating system's own report that the launched process is sandboxed

**Status:** Accepted — supersedes ADR-0008
**Date:** 2026-09-19

## Context

ADR-0008 decided two things: the read-only harness drives `nozoki-core` and the closed IPC command
list rather than the rendered UI, and the bundle probe runs on every CI build from the first. Neither
moved. What moved is the observable that record's § Decision fixed for the probe's second half — that
the launched bundle carries `APP_SANDBOX_CONTAINER_ID` in its environment — which ADR-0008 held
"without a vendor locator" and named as the platform fact it rested on.

The first built bundle answered it, and not the way the probe expected. Ad-hoc signed, with both
entitlements `true`, the bundle fails the marker probe under four launch routes **while its sandbox
holds**: for the same process the operating system reports a read outside the grant and an outbound
network connection denied. The same binary built with no entitlements is unsandboxed and also shows
no marker, and a team-signed sandboxed third-party app carries no marker in its main process. So the
marker is absent from a sandboxed main process under either signature and does not separate a
sandboxed bundle from an unsandboxed one (`docs/SDD.md` § 10 RC-1, citing `nozoki@ccb58d8` and
`docs/trail/sdd/cycle-4.md` § 5.1; macOS 26.6.2, arm64). The wall stands; the observable failed.
That the finding arrived with one reader written is what running the probe from the first build was
for.

The forces ADR-0008 recorded stand unchanged and are restated so this record reads alone. The
read-only, Git-state and zero-traffic bars are machine checks run at every release (`docs/SRS.md`
§ 8 AC-1 – AC-3; § 4.3 NFR-9). Tauri's WebDriver support has no WKWebView driver on macOS
(https://v2.tauri.app/develop/tests/webdriver/ — "macOS has no WKWebView driver tool"), so a harness
that drives the rendered UI cannot run in CI on the one platform the product ships on. The release is
ad-hoc signed (ADR-0007), so no signing chain vouches for the sandbox, and a sandbox silently absent
would leave every test green and the wall gone (`docs/SDD.md` § 11 R-8). The owner accepted that the
first public release lands after the whole v1 cut and asked that the bundle, the entitlement list and
the probe be proved on an unpublished artifact as soon as the runtime exists
(`nozoki@70a879a:docs/trail/sdd/cycle-1.md` § 3.3).

## Decision

The **read-only harness exercises `nozoki-core` and the closed IPC command list over fixture
folders — repositories, plain folders, a folder inside a repository, a parent of two, a linked
worktree, a submodule — not the rendered UI.** It runs on every CI build and before every release:
`checks/read-only.sh` hashes a fixture (`.git` included where there is one), exercises every command
through `nozoki-core`, hashes again, and prints `unchanged` or the differing paths;
`checks/no-network.sh` diffs the dependency trees against the allowlist. The rendered UI's
whole-product check is the timed release walk (`docs/SRS.md` § 8 AC-10).

The **bundle probe**, `checks/bundle.sh`, reads `codesign -d --entitlements :- Nozoki.app` against
the exact entitlement list, then launches the bundle and takes the pid of the main process that run
started — found by its absolute executable path, with no instance of it running beforehand. **It
fails unless the operating system reports that pid as sandboxed and reports two operations denied
for it: a file read outside the grant, and an outbound network connection.** That is the state Apple
names as the verification — "verify that the value in the Sandbox column is Yes"
(https://developer.apple.com/documentation/security/protecting-user-data-with-app-sandbox) — and the
two denials test the wall itself rather than a proxy for it. The probe reads that state through
libSystem's `sandbox_check`.

**A negative control is part of the probe, not an accessory to it.** The probe's suite runs it on
the same binary built with no entitlements and requires it to fail; a probe that cannot tell the two
apart goes red instead of green. The build also fails when `sandbox_check` is missing or returns an
error, when no pid is found, or when more than one is.

**The probe runs on the bundle every CI build produces, from the first slice's first green build
on**, so the release gate has a passing history before the first release is due (`docs/SDD.md` § 4
C-I3; `nozoki@70a879a:docs/SDD.md` § SDD Review Notes RN-15, RN-25).

## Alternatives ruled out

- **The environment marker `APP_SANDBOX_CONTAINER_ID`** — ADR-0008's observable. Measured absent
  from a sandboxed main process under an ad-hoc signature and under a team signature, and absent
  from an unsandboxed one: it does not separate the two cases, so a probe reading it is red while the
  wall stands and could never go green for the right reason (`docs/SDD.md` § 10 RC-1). No
  environment variable is read as evidence of the sandbox.
- **The container directory `~/Library/Containers/com.kensaiapp.nozoki` existing** — it is created
  at first launch and survives from an earlier one, so a stale directory would pass an unsandboxed
  rebuild (`docs/SDD.md` § 10 RC-1, *Stopped*). A container directory that already exists is never
  evidence.
- **Reading Activity Monitor's Sandbox column, the verification Apple documents** — it is a window,
  not a command with an exit code, and the gate runs unattended on every build. The probe reads the
  same state programmatically instead, and pays for that with the undocumented function named below.
- **A harness that drives the rendered UI (an embedded-WebDriver harness)** — no WKWebView driver on
  macOS; adopted later, if ever, when one is worth its dependencies (`docs/SDD.md` § 9 TO-7).
  Accepted in its place: the renderer's actual command use is exercised only by the release walk —
  acceptable because the renderer holds no capability the harness could catch it using.
- **Proving the sandbox at release, when the first release is due** — rejected by the owner:
  publishing late does not require verifying late (`nozoki@70a879a:docs/trail/sdd/cycle-1.md`
  § 3.3). The first built bundle is where the marker's failure was found; a release-time probe would
  have found it with the whole v1 cut written.
- **Trusting a signing chain to prove the sandbox** — not available; the release is ad-hoc signed
  (ADR-0007).

## Consequences

Easier: a proof that runs in CI on macOS with no UI driver; a release gate with a passing history
before it gates a release; the plain-folder criterion ("no `.git` and no entry of any kind
appeared") checked by the same hash (`docs/SRS.md` § 8 AC-24); and a sandbox probe that tests the
two denials the wall promises, so its green means the wall and not a correlate of it.

Harder: the renderer's use of the commands is exercised only by a human walk. The probe's suite
builds the binary twice — once with no entitlements — because the control is the only thing that
keeps an undocumented function honest. And a probe failure now has two meanings a reader must tell
apart: the probe finding the wall absent is a re-cut trigger on every later slice, never on the
signature (`docs/SDD.md` § 11 R-8); a probe that fails while the wall stands redraws the probe and
no slice, which is what happened here (`docs/SDD.md` § 5 step 4, E-1; § 10 RC-1).

What undoing it costs: adopting an embedded-WebDriver harness when one is worth its dependencies
(`docs/SDD.md` § 9 TO-7). Replacing the observable again costs what this record cost — a re-cut
entry in the SDD, a superseding record here, and the constraint entry re-derived.

**What this rests on, and whose it stays.** Tauri's WebDriver support on macOS is Tauri's. The
output format of `codesign -d --entitlements :-` is Apple's. And `sandbox_check` is Apple's, held
here as **undocumented**: libSystem exports it and the SDK's `sandbox.h` does not declare it — in
the macOS SDK read on 2026-09-19 that header declares `sandbox_init` and `sandbox_free_error` only,
while `usr/lib/libSystem.B.tbd` and `usr/lib/system/libsystem_sandbox.tbd` list `_sandbox_check` —
and Apple's App Sandbox page, read the same day, names neither it nor the marker. No one owes this
product that function's stability, and nothing here assumes anyone will say when it changes. What
the decision becomes on that day is fixed in advance: a function that is gone or errors fails the
build by the rule above, and a function that still exists but no longer tells a sandboxed process
from an unsandboxed one is caught by the negative control, which goes red. Either way the change is
a red build, never a silent green, and the sandbox then needs another observable — this record
superseded in its turn. The entitlement half stands through all of it.

**One case is unmeasured, and this record does not cover it.** Every measurement above was taken on
one Mac (macOS 26.6.2, arm64). Whether the probe reads the same on a GitHub-hosted macOS runner is
open in `docs/SDD.md` § Open Questions and is settled by the probe's first CI run; a control that
does not fail there, or a bundle not reported sandboxed, is R-8.

## Traces to

- `docs/SDD.md` at v6 (`nozoki@b3439e8`) — § 4 C-I3, the observable and its *Violated by*; § 10
  RC-1, the re-cut and its measurement; § SDD Review Notes RN-45; § 11 R-8; § 5 step 4 (E-1) with
  RN-46; § Open Questions, the hosted-runner item; § 3, `read-only-harness` row; § 9 TO-7.
- `docs/trail/sdd/cycle-4.md` § 5.1 — the item as raised and answered on the SDD.
- `docs/trail/architecture/cycle-5.md` § 3.1 — the answer, given in the owner's seat, that this is
  a reversal of ADR-0008's mechanism landing as a new record and not a correction edited into it;
  its reasoning is `docs/trail/architecture/self_answer-8.md` § 3.1.
- `nozoki@ccb58d8` — the first built bundle's measurement, as the SDD cites it.
- ADR-0008 — the record this one supersedes; its decision is restated here whole, so nothing in
  this record depends on that one being open.
- `nozoki@70a879a:docs/trail/sdd/cycle-1.md` § 3.3 — the owner's mitigation;
  `nozoki@70a879a:docs/SDD.md` § SDD Review Notes RN-15, RN-25.
- `docs/SRS.md` § 8 AC-1 – AC-3, AC-10, AC-13, AC-24, AC-25; § 4.3 NFR-9.
- Tauri's WebDriver page and Apple's App Sandbox page, cited above, each as the SDD cites it; the
  Apple page and the SDK's `sandbox.h` and `.tbd` stubs were re-read for this record on 2026-09-19.

## Binds

QC-14, QC-25, QC-46, QC-48, QC-49 — and the test-strategy realization in `docs/nfdr.md` § 9.
