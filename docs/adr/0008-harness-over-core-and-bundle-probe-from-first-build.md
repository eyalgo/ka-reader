# ADR-0008: The read-only proof runs against `ka-reader-core` and the IPC command list, not the rendered UI, and the bundle probe runs on every build from the first

**Status:** Superseded by ADR-0010
**Date:** 2026-09-01

## Context

The read-only, Git-state and zero-traffic bars are machine checks run at every release
(`docs/SRS.md` § 8 AC-1 – AC-3; § 4.3 NFR-9). Tauri's own WebDriver support has no WKWebView driver
on macOS (https://v2.tauri.app/develop/tests/webdriver/ — "macOS has no WKWebView driver tool"),
so a harness that drives the rendered UI cannot run in CI on the one platform the product ships on.
The release is ad-hoc signed (ADR-0007), and whether the App Sandbox is enforced under an ad-hoc
signature is unverified from documents (`docs/SDD.md` § Open Questions, fourth item); a sandbox
silently absent would leave every test green and the wall gone (`docs/SDD.md` § 11 R-8). The owner
accepted that the first public release lands after the whole v1 cut and asked that the bundle, the
entitlement list and the probe be proved on an unpublished artifact as soon as the runtime exists
(`ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 3.3).

## Decision

The **read-only harness exercises `ka-reader-core` and the closed IPC command list over fixture
folders — repositories, plain folders, a folder inside a repository, a parent of two, a linked
worktree, a submodule — not the rendered UI.** It runs on every CI build and before every release:
`checks/read-only.sh` hashes a fixture (`.git` included where there is one), exercises every command
through `ka-reader-core`, hashes again, and prints `unchanged` or the differing paths;
`checks/no-network.sh` diffs the dependency trees against the allowlist; and the **bundle probe**,
`checks/bundle.sh`, reads `codesign -d --entitlements :- KA-Reader.app` against the exact entitlement
list and launches the bundle, failing unless `APP_SANDBOX_CONTAINER_ID` is set in its environment.
**The probe runs on the bundle every CI build produces, from the first slice's first green build
on**, so the release gate has passed for four slices before the first release is due, and a
failure under the ad-hoc signature is found with one reader written (`docs/SDD.md` § 4 C-I3;
`ka-reader@70a879a:docs/SDD.md` § SDD Review Notes RN-15, RN-25). The rendered UI's whole-product check is the timed release walk
(`docs/SRS.md` § 8 AC-10).

## Alternatives ruled out

- **A harness that drives the rendered UI (an embedded-WebDriver harness)** — no WKWebView driver
  on macOS; adopted later, if ever, when one is worth its dependencies (`docs/SDD.md` § 9 TO-7).
  Accepted in its place: the renderer's actual command use is exercised only by the release walk —
  acceptable because the renderer holds no capability the harness could catch it using.
- **Proving the sandbox at release, when the first release is due** — rejected by the owner:
  publishing late does not require verifying late (`ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 3.3).
- **Trusting a signing chain to prove the sandbox** — not available; the release is ad-hoc signed
  (ADR-0007).

## Consequences

Easier: a proof that runs in CI on macOS with no UI driver; a release gate with a passing history
before it gates a release; the plain-folder criterion ("no `.git` and no entry of any kind
appeared") checked by the same hash (`docs/SRS.md` § 8 AC-24). Harder: the renderer's use of the
commands is exercised only by a human walk; and a probe that fails under ad-hoc signing on the
first slice is a re-cut trigger on the gate's *mechanism* — the command half of the first slice's
bar unmet — never on the signature (`docs/SDD.md` § 11 R-8; `ka-reader@70a879a:docs/SDD.md` § SDD Review Notes RN-25).

What undoing it costs: adopting an embedded-WebDriver harness when one is worth its dependencies
(`docs/SDD.md` § 9 TO-7).

**What this rests on, and whose it stays.** Tauri's WebDriver support on macOS is Tauri's; the
output format of `codesign -d --entitlements :-` is Apple's; and that a sandboxed process carries
`APP_SANDBOX_CONTAINER_ID` in its environment is an observed macOS behaviour the design holds
without a vendor locator — this record says so rather than supplying one. If that variable stops
being set, the probe's second half is un-made and the sandbox needs another observable signal; the
entitlement half stands.

## Traces to

- `docs/SDD.md` § 3, `read-only-harness` row; § 4 C-I3; § 9 TO-7; § 11 R-8; § Open Questions (fourth item); `ka-reader@70a879a:docs/SDD.md` § SDD Review Notes
  RN-15, RN-25.
- `ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 3.3 — the owner's mitigation.
- `docs/SRS.md` § 8 AC-1 – AC-3, AC-10, AC-13, AC-24, AC-25; § 4.3 NFR-9.
- Tauri's WebDriver page, cited above, as the SDD cites it.

## Binds

QC-14, QC-25, QC-46, QC-48, QC-49 — and the test-strategy realization in `docs/nfdr.md` § 9.
