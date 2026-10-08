# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-23
- **Sources re-read:** GitHub Actions run logs, read with `gh run view <id> --log` on 2026-09-23.
  Run 35797893381 (`ci-sandbox-diagnostic`, `247b5ed`, conclusion `failure`, failing step
  *Bundle probe*): its asks match the item exactly. Ask 1 on the real bundle reads `sandboxed: no`
  with the outbound connection allowed, and asks 2–5 read `yes` with both denied. The unentitled copy
  reads `no` on all five, and every one of its asks reports `out-of-grant-read: denied`. The
  *Bundle probe* step reads pid 18980 `sandboxed: no`, `outbound-connection: allowed`. Run
  35794012057: the diagnostic step answers `sandboxed: yes` on 60 of 60 asks. No vendor page was
  leaned on. C-I3's Apple citation is not what this answer rests on.

## Items worked

### 5.1 — The hosted runner is measured: the bundle is reported sandboxed, but not on the first ask — and C-I3 says nothing about when the probe reads

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** confirmed with addition
- **Why:** The item is in bucket 5, but it carries a lean, so I weighed it as a draft. The lean is to
  close the fourth *Open Questions* item as "the sandbox holds on a hosted runner, and the probe
  read too early", and to name a bounded window in C-I3 without a number.

  *Seat (check 1).* The edit lands in `SDD.md` itself: the Open Questions item at `SDD.md:L2648-L2652`,
  C-I3 at `L525-L553`, and R-8 at `L1966-L1971`. It binds only the SDD's own account of its probe, and
  no ground I can name is hidden from me, so the call is mine to make in the owner's seat. It is
  not the owner's alone, because it relaxes no promise. The wall C-R2 promises is still required to be
  reported, and the control is made stricter, not looser. The item's ADR-0010/QC-25 half is already
  its own question at `docs/architecture_open_issues.md` § 3.2, raised by the same PM. It does not
  split off from this item, because it was never part of it.

  *Widening.* The item asks C-I3 and R-8 to state something they do not state now, which is when the
  report is read. It cites an occurrence: the red *Bundle probe* runs, and run 35797893381 above. So
  "not until it occurs" does not apply.

  *Soundness (check 2).* The lean's conclusion holds, and the measurement supports it. The same bundle
  reads `no` and then `yes` a quarter-second apart. The unentitled copy reads `no` throughout. The
  owner's Mac shows the same first-ask `no`, which I take from the item's record and did not measure.
  A read-once probe is racing the process's own sandbox initialisation, and the wall stands. ADR-0010
  § Consequences already calls that case "a probe that fails while the wall stands redraws the probe
  and no slice". The lean is incomplete in four places, and those four are the additions.

  1. **The bound has to be visible.** "No number in the SDD" is right, because the number is the
     script's and it would go stale in the SDD. But the SDD should require that the script fixes the
     bound and prints it. Otherwise a red run cannot tell "waited long enough and the wall is absent"
     from "gave up early".
  2. **The pass condition and the absent case (check 4).** With a window, the probe asks many times,
     and so the probe's own guard against a dead pid carries weight on every ask.
     `checks/sandbox_probe.rs:L103-L115` records that `sandbox_check` reports "sandboxed, everything
     denied" for a pid that names no process. A launched app that crashes inside the window would
     read as a held wall on every later ask, unless every ask re-checks that the pid still names a
     process. So C-I3 says the pass is the first ask on which all three answers hold, on a pid that
     still exists, and that a process gone before the pass is a failure. `require_running` already
     does this on each invocation of the probe. The addition makes the SDD say what the script
     relies on.
  3. **The control holds for the whole window.** This is the PM's own stricter rule, and I confirm
     it. A control that passes on one `no` passes on the first-ask race by itself, which is exactly
     the reading the runs showed an entitled bundle can give.
  4. **One of the three readings separates nothing on the runner.** Re-reading run 35797893381, the
     unentitled copy reports `out-of-grant-read: denied` on every ask while it reports
     `sandboxed: no`. So does the real bundle's unsandboxed first ask. `sandbox_probe.rs:L76-L81`
     prints `denied` for any non-zero result, so this is `sandbox_check`'s own answer and not the
     script's reading of it. On the hosted runner, then, the read denial appears with the wall and
     without it. C-I3's sentence "the two denials test the wall C-R2 promises rather than a proxy
     for it" is true there of the outbound half only. The control still goes red on the runner,
     through `sandboxed` and the outbound connection. It does not check the read half, because
     `bundle.sh` asks the control only whether it is *not sandboxed*. I don't know why the runner
     reports this. `gh run view 35797893381 --log` shows it, and nothing I read explains it. So the
     closed Open Questions item records it, and C-I3's sentence is narrowed. The same claim stands in
     ADR-0010 § Consequences, which is not the SDD's to edit, so it is raised at
     `docs/architecture_open_issues.md` § 3.3 (commit `f119550`).

  *Settled record (check 3).* The window reads the same observable RC-1 settled, which is
  `sandbox_check` on the launched main process. It moves neither § 2's shape nor § 3's seams, so
  § 10's rule owes the decision log no superseding record on the SDD's side. It is also not a
  § 10 re-cut. § 10's triggers are a slice's *Reached when* failing as written, a fragment, no
  startable slice, or an upstream change. `open-a-folder`'s *Command* bar states the observable,
  not the read timing, and what failed is a script behaviour the SDD never stated. I came close to
  recording an RC-2 on the grounds that every red run so far reads, literally, as R-8. What tipped
  it: RC-1 exists because the *observable* was wrong, and here the observable is right and only
  the moment it is read was wrong. A reader who takes the other side would record RC-2 with
  *Changed:* limited to C-I3's timing clause, and nothing else in this answer would move. The
  closed Open Questions item needs a home for its measurement. It goes into C-I3's own text or a
  review note, whichever `product-sdd` chooses. The Open Questions section's own rule is to omit
  settled items.

  *Failure paths (check 4).* **Absent**: a process gone mid-window fails, per addition 2. **Stale**:
  a report that turns back to `no` after the pass is not read. No run has shown it, since every
  observed sequence is monotone `no`→`yes`, and it is named as an uncovered case rather than
  guarded. **Concurrent**: the existing "exactly one pid" rule (`checks/bundle.sh:L266`) stands and
  is unaffected. **Refused**: `sandbox_check` erroring on any ask fails the run, as C-I3 already
  requires. **Empty**: the window running out with no passing ask is the ordinary red, and that is
  R-8. With these, R-8 reads "not reported sandboxed, or either denial not reported, within the
  bounded window", and a red run is R-8 again rather than a probe artefact.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

- **`docs/architecture_open_issues.md`** — **appended** — companion to `adr/` and `nfdr.md`, item
  `3.3`, landed in commit `f119550`

## Launchers owed

- **`docs/SDD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-sdd/launcher.sh ka-reader`
- **`docs/adr/` and `docs/nfdr.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/skill/launcher.sh product-architecture ka-reader`
