# ADR-0012: The shipped bundle's shell run is proved beside the wall — observed from the process, never from a marker the product writes, with a control that must go red — on every build after the wall probe and never instead of it

**Status:** Accepted
**Date:** 2026-09-23

## Context

Every gate ADR-0010 fixed passed on the bundle CI built from `e7b2bcd` — the read-only harness,
the sandbox probe with its negative control, the allowlist diff — and the bundle opened one empty
window with no Open panel and no response to a right-click (`docs/trail/sdd/cycle-8.md` § 5.1;
`docs/SDD.md` § 10 RC-2). The wall stood; nothing ran behind it. That bundle's page never reached
`open_folder` — the renderer's first and only unconditional command, invoked at page load
(`nozoki@a4ab8e6:nozoki-ui/src/main.ts:L14-L19`) and parked in the Open panel until someone
answers it (`nozoki@a4ab8e6:crates/nozoki-app/src/main.rs:L17-L19`) — because WebKit's content
process never got a network process to pair with (RC-2). The owner ordered a gate
(`docs/trail/sdd/cycle-8.md` § 5.1,
answer 4): the bundle CI ships must be shown to run its view under its shipped entitlements —
at the least, that the view reached `open_folder` — because the empty window got past every gate,
and this gate is what stops it happening again. The ruling names no renderer, so it binds the
native shell as it bound the page (`docs/SDD.md` § 4 C-I3).

Two constraints already in force shape how such a gate may read. The rendered UI cannot be driven
in CI — no harness drives the AppKit views: driving them from outside the process runs through the
accessibility surface UX-A1 disclaims, and an XCUITest target needs an Xcode project this product
does not keep (`docs/SDD.md` § 4 C-I3; § 9 TO-7) — so the gate cannot click. And the artifact under
test may hold nothing for the test: the environment marker RC-1 retired is the class of evidence a
marker the product writes for a check belongs to, and C-I2's log holds `failed` and `stopped` items
and nothing else (`docs/SDD.md` § SDD Review Notes RN-52).

## Decision

`checks/renderer.sh Nozoki.app` runs on every CI build **after `checks/bundle.sh` and never
instead of it**. It launches the bundle CI built, as a user launches it, takes the pid the way
`checks/bundle.sh` does, and within a bounded window of the same kind **fails unless the launched
main process is observed inside `open_folder`'s call** — the shell's first and only unconditional
act, presenting the Open panel at launch (`docs/SDD.md` § 4 C-R3) and parked in it until someone
answers. The observation is the operating system's or the process's own report that the shell ran
far enough to present the panel — never a marker the product writes for the check, never an
environment variable, never a code path that exists for the gate: the shipped bundle is the
artifact under test and holds nothing for the test. The script fixes which mechanism it reads and
the bound, as `checks/bundle.sh` fixes its window. The mechanism measured on one Mac, for the
previous renderer, was a thread sample of the launched pid showing the command's frames —
`pick_folder → run_on_main` present exactly where the window drew and absent where it did not
(`docs/trail/sdd/cycle-8.md` § 5.1, the sample table); the frames the native shell shows are
re-measured on the first slice's first built bundle, and the script fixes them from that bundle
(`docs/SDD.md` § 4 C-I3; § Open Questions, last item).

**A negative control is part of the gate, not an accessory to it**, and it is a bundle the harness
owns, not a build removed from the product — a single-process shell has no renderer build to
remove: `checks/fixtures/idle-shell`, an AppKit executable that opens one window and never presents
the panel, signed and entitled as the product is — the shape the empty window took — **must go
red**. A gate that cannot go red has not run.

The wall probe and this gate are one bar on one artifact (`docs/SDD.md` § 5 step 4, E-1): a wall
proven on a bundle whose window never draws proves nothing a person can use, and a window that
draws on a bundle the wall is not proven on is the shape § 2 rejected.

**Until the native shell lands, this gate is red by construction, and that red is the gate
working.** Under the rule (ADR-0011) no bundle built from the previous shape — the tree as this
record is written, `crates/nozoki-app` over `nozoki-ui` — reaches `open_folder` (`docs/SDD.md`
§ 10 RC-2). The red is never cleared by granting an entitlement or by skipping the script;
`checks/renderer.sh` and `checks/fixtures/idle-shell` land with the native shell or after it (the
owner's addition, `docs/trail/architecture/cycle-8.md` § 2.1).

## Alternatives ruled out

- **A marker the product writes for the check** — a log line, a file, an environment variable set
  when the panel is presented. Rejected on two grounds: C-I2's log holds failures and nothing else,
  and a marker written for a check is what RC-1 stopped reading — a product that carries code for
  its own gate is testing the gate, not the product (`docs/SDD.md` RN-52).
- **A branch of `checks/bundle.sh`** — that script has one job and refuses to launch anything but
  C-R2's set (`checks/bundle.sh`, its header), and the wall gate must keep its meaning when the
  shell gate is red: a red that could mean "no sandbox" or "no panel" is a gate a reader cannot act
  on (RN-52).
- **The product's own build with its view removed, as the control** — the control this record
  first drafted, against the WKWebView renderer: a bundle with its renderer build removed from
  `Contents/Resources`. A single-process shell has no renderer build to remove, so the control is a
  bundle the harness owns instead (`docs/SDD.md` § 4 C-I3 at v13).
- **Driving the rendered UI — an embedded-WebDriver or XCUITest harness** — no WKWebView driver on
  macOS for the previous renderer (ADR-0010), and for the native shell an Xcode project this
  product does not keep and an accessibility surface it disclaims; this gate does not reopen that
  (`docs/SDD.md` § 9 TO-7).
- **The human release walk alone** (`docs/SRS.md` § 8 AC-10) — it is what found the empty window,
  and it runs once per release; the owner's answer 4 is that a gate on every build is what stops
  the window shipping again. The walk stands as the whole-product check; this gate is not it.
- **Reading a running shell off the wall probe's green** — the prior assumption RC-2 records as
  stopped: "no entitlement forbids it" is not evidence that a window will draw.

## Consequences

Easier: a bundle that passes CI is a bundle whose shell presented the panel; the wall's green stops
being read as a working product; the failure that cost this cycle — every gate green, one empty
window — is caught on the first build that reproduces it.

Harder: the suite launches two bundles more per CI run (the gate and its `idle-shell` control), and
the harness owns a second signed and entitled executable that must be kept in step with the
product's entitlements. The observation is a process-level read of the shell's call into the
bridge, so the frames it reads are the shell's own symbols and the script fixes them from the first
native bundle. What this record fixes is the gate, its two rules — observed from the process and
never from a marker; a control that must go red — and its place after the wall probe, not the
frames. Whether the observation reads the same on a GitHub-hosted runner is unmeasured
(`docs/SDD.md` § Open Questions, last item); a runner that cannot observe it is a re-cut trigger on
the mechanism, never on the gate.

What undoing it costs: dropping the gate is a CI edit — and a return to the state where the wall's
green was the only evidence a person could use the bundle. The owner ordered the gate, so a reversal
lands as a record superseding this one.

**What this rests on, and whose it stays.** The thread sample is the platform's (`sample`, macOS),
and the frames it shows are the shell's and the bridge's own symbols; if either holder moves — the
sampling tool's output, or the view technology — the mechanism is re-derived and the gate stands.
`checks/renderer.sh` and `checks/fixtures/idle-shell` are not in the tree as this record is written
(`ls checks/`, 2026-09-23: `bundle.sh`, `deps.allow`, `fixtures`, `no-network.sh`, `own-state.sh`,
`read-only.sh`, `sandbox_probe.rs`, `tests`); they become executable in the change that lands them
with the native shell, and until then the gate is `development-design` reading `docs/nfdr.md` QC-62.

## Traces to

- `docs/SDD.md` at v13 (`nozoki@b236e7b`, Draft) — § 4 C-I3, "The shell's run is proved on the
  shipped bundle, beside the wall" and its *Violated by*; § 3 `read-only-harness` (`renderer.sh`
  and `idle-shell` among the harness's parts); § 5 step 4 E-1; § 6 S-1 *Reached when*, command
  half; § 10 RC-2 *Changed*, RC-3 *Retained* and *Still unresolved*; § Open Questions, last item;
  § SDD Review Notes RN-51, RN-52, RN-60, RN-61. C-I3 names ADR-0010 as its record and this record
  as the gate's — "whose mechanism, control and observable's name are re-derived from this clause
  as it now reads" — which is what this revision does. The record was first drafted against
  `docs/SDD.md` at v12 (`nozoki@6ebdc42`), where the control was the product's own renderer build
  removed; the SDD's own companion carried the record line's move, confirmed by the owner
  (`docs/trail/sdd/cycle-9.md` § 2.3; `nozoki@18ad26d`).
- `docs/trail/sdd/cycle-8.md` § 5.1 — the owner's ruling, answer 4, and the sample table the
  mechanism was first measured in.
- `docs/trail/sdd/cycle-9.md` § 1.1 — the owner's answer that moves the renderer, under which the
  mechanism, the control and the observable's name were re-derived at v13.
- `nozoki@a4ab8e6:nozoki-ui/src/main.ts:L14-L19`;
  `nozoki@a4ab8e6:crates/nozoki-app/src/main.rs:L17-L19`; `checks/bundle.sh` header, its v1.3.0
  line — each opened on 2026-09-23 for the measurement this record's § Context reports, which was
  taken on the previous shape's bundle. The two source citations were pinned on 2026-09-24 to the
  last commit on `main` before those files left the tree, on the owner's ruling that a citation
  repair reverses no decision (`docs/trail/architecture/cycle-3.md` § 3.1;
  `docs/trail/architecture/cycle-11.md` § 3.7).
- ADR-0010 — the wall probe this gate runs after; its decision is untouched. ADR-0011 — the rule
  under which the previous renderer's bundle cannot reach `open_folder`. ADR-0013, ADR-0014 — the
  shape and the view the gate now proves ran.
- `docs/SRS.md` § 8 AC-10 — the manual walk this gate precedes and does not replace; § 4.7 NFR-13.
- `docs/trail/architecture/cycle-8.md` § 2.1 — the owner's confirm with one addition (the gate red
  by construction until the replacement lands, never cleared by an entitlement or by skipping;
  `checks/renderer.sh` landing with the replacement or after it), given in the owner's seat by a
  `companion-self-answer` run, its reasoning `docs/trail/architecture/self_answer-11.md` § 2.1.
  The record stayed Proposed by that same seat's later reading that it "may also move under the
  RC-3 re-derivation" (`docs/trail/sdd/cycle-9.md` § 2.3, the owner's addition) — it did, in the
  revision against C-I3 at v13 — and it is Accepted on the owner's confirm at
  `docs/trail/architecture/cycle-9.md` § 2.3, with the four records RC-3 owes (the reasoning,
  `docs/trail/architecture/self_answer-12.md` § 2.3). Accepted with `docs/SDD.md` at v14
  (`nozoki@2739007`, Draft), where C-I3's record line names this record and states no status word
  (SDD RN-64) — the index row is where its status is read.

## Binds

QC-62.
