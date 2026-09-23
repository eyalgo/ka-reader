# ADR-0012: The shipped bundle's renderer run is proved beside the wall — observed from the process, never from a marker the product writes, with a control that must go red — on every build after the wall probe and never instead of it

**Status:** Proposed
**Date:** 2026-09-23

## Context

Every gate ADR-0010 fixed passed on the bundle CI built from `e7b2bcd` — the read-only harness,
the sandbox probe with its negative control, the allowlist diff — and the bundle opened one empty
window with no Open panel and no response to a right-click (`docs/trail/sdd/cycle-8.md` § 5.1;
`docs/SDD.md` § 10 RC-2). The wall stood; nothing ran behind it. `main.ts` never reached
`open_folder` — the renderer's first and only unconditional command, invoked at page load
(`nozoki-ui/src/main.ts:L14-L19`) and parked in the Open panel until someone answers it
(`crates/nozoki-app/src/main.rs:L17-L19`) — because WebKit's content process never got a network
process to pair with (RC-2). The owner ordered a gate (`docs/trail/sdd/cycle-8.md` § 5.1,
answer 4): the bundle CI ships must be shown to run its renderer under its shipped entitlements —
at the least, that the page reached `open_folder` — because the empty window got past every gate,
and this gate is what stops it happening again.

Two constraints already in force shape how such a gate may read. The rendered UI cannot be driven
in CI — Tauri has no WKWebView driver on macOS (ADR-0010 § Alternatives ruled out; `docs/SDD.md`
§ 9 TO-7) — so the gate cannot click. And the artifact under test may hold nothing for the test:
the environment marker RC-1 retired is the class of evidence a marker the product writes for a
check belongs to, and C-I2's log holds `failed` and `stopped` items and nothing else
(`docs/SDD.md` § SDD Review Notes RN-52).

## Decision

`checks/renderer.sh Nozoki.app` runs on every CI build **after `checks/bundle.sh` and never
instead of it**. It launches the bundle CI built, as a user launches it, takes the pid the way
`checks/bundle.sh` does, and within a bounded window of the same kind **fails unless the launched
main process is observed inside `open_folder`**. The observation is the operating system's or the
process's own report that the page ran far enough to call the host — never a marker the product
writes for the check, never an environment variable, never a code path that exists for the gate:
the shipped bundle is the artifact under test and holds nothing for the test. The script fixes which
mechanism it reads and the bound, as `checks/bundle.sh` fixes its window; the mechanism measured on
one Mac is a thread sample of the launched pid showing the command's frames — `pick_folder →
run_on_main` present exactly where the window drew and absent where it did not
(`docs/trail/sdd/cycle-8.md` § 5.1, the sample table).

**A negative control is part of the gate, not an accessory to it**: the same bundle with its
renderer build removed from `Contents/Resources` — the build `checks/bundle.sh` reads before launch
(its v1.3.0 line) — must go red. A page that never loads never reaches `open_folder`, and a gate
that cannot go red has not run.

The wall probe and this gate are one bar on one artifact (`docs/SDD.md` § 5 step 4, E-1): a wall
proven on a bundle whose window never draws proves nothing a person can use, and a window that
draws on a bundle the wall is not proven on is the shape § 2 rejected.

## Alternatives ruled out

- **A marker the product writes for the check** — a log line, a file, an environment variable set
  when the page loads. Rejected on two grounds: C-I2's log holds failures and nothing else, and a
  marker written for a check is what RC-1 stopped reading — a product that carries code for its own
  gate is testing the gate, not the product (`docs/SDD.md` RN-52).
- **A branch of `checks/bundle.sh`** — that script has one job and refuses to launch anything but
  C-R2's set (`checks/bundle.sh`, its header), and the wall gate must keep its meaning when the
  renderer gate is red: a red that could mean "no sandbox" or "no page" is a gate a reader cannot
  act on (RN-52).
- **Driving the rendered UI — an embedded-WebDriver harness** — no WKWebView driver on macOS;
  ADR-0010 declined it, and this gate does not reopen that (`docs/SDD.md` § 9 TO-7).
- **The human release walk alone** (`docs/SRS.md` § 8 AC-10) — it is what found the empty window,
  and it runs once per release; the owner's answer 4 is that a gate on every build is what stops
  the window shipping again. The walk stands as the whole-product check; this gate is not it.
- **Reading a running renderer off the wall probe's green** — the prior assumption RC-2 records as
  stopped: "no entitlement forbids it" is not evidence that a system process will start.

## Consequences

Easier: a bundle that passes CI is a bundle whose page ran; the wall's green stops being read as a
working product; the failure that cost this cycle — every gate green, one empty window — is caught
on the first build that reproduces it.

Harder: the suite launches the bundle twice more per CI run (the gate and its control). And the
observation is a process-level read of one renderer's call into the host, so it moves with the
renderer: the owner has answered the SDD's companion that the renderer leaves WKWebView
(`docs/SDD_open_issues.md` § 1.1 at `nozoki@a1d8f2c`), so the frames the sample shows, the
control's "renderer build removed", and possibly the observable's name are re-derived when the SDD
carries the replacement. What this record fixes is the gate, its two rules — observed from the
process and never from a marker; a control that must go red — and its place after the wall probe,
not the frames. Whether the observation reads the same on a GitHub-hosted runner is unmeasured
(`docs/SDD.md` § Open Questions, last item); a runner that cannot observe it is a re-cut trigger on
the mechanism, never on the gate.

What undoing it costs: dropping the gate is a CI edit — and a return to the state where the wall's
green was the only evidence a person could use the bundle. The owner ordered the gate, so a reversal
lands as a record superseding this one.

**What this rests on, and whose it stays.** The thread sample is the platform's (`sample`, macOS),
and the frames it shows are the renderer's and the host's own symbols; if either holder moves — the
sampling tool's output, or the renderer technology — the mechanism is re-derived and the gate
stands. `checks/renderer.sh` is not in the tree as this record is written (`ls checks/`,
2026-09-23: `bundle.sh`, `deps.allow`, `fixtures`, `no-network.sh`, `own-state.sh`,
`read-only.sh`, `sandbox_probe.rs`, `tests`); it becomes executable in the change that lands it,
and until then the gate is `development-design` reading `docs/nfdr.md` QC-62.

## Traces to

- `docs/SDD.md` at v12 (`nozoki@6ebdc42`, Draft) — § 4 C-I3, the renderer-gate clause ("The
  renderer's run is proved on the shipped bundle, beside the wall") and its *Violated by*; § 5
  step 4 E-1; § 6 S-1 *Reached when*, command half; § 10 RC-2 *Changed*; § Open Questions, last
  item; § SDD Review Notes RN-51, RN-52. C-I3 names ADR-0010 as its record and claims no record for
  this gate (RN-56); this record is the one it is owed, and C-I3's record line is the CTO's to
  extend.
- `docs/trail/sdd/cycle-8.md` § 5.1 — the owner's ruling, answer 4, and the sample table the
  mechanism was measured in.
- `docs/SDD_open_issues.md` § 1.1 at `nozoki@a1d8f2c` — the owner's answer that moves the renderer,
  under which the mechanism is re-derived.
- `nozoki-ui/src/main.ts:L14-L19`; `crates/nozoki-app/src/main.rs:L17-L19`; `checks/bundle.sh`
  header, its v1.3.0 line — each opened for this record on 2026-09-23.
- ADR-0010 — the wall probe this gate runs after; its decision is untouched.
- `docs/SRS.md` § 8 AC-10 — the manual walk this gate precedes and does not replace; § 4.7 NFR-13.
- `docs/architecture_open_issues.md` § 2.1 — the item that carries this record for the owner's
  confirm; the record is Proposed until that answer.

## Binds

QC-62.
