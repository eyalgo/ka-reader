# SDD open issues — KA-Reader

> Companion to `SDD.md`. Three seats — the CTO, the CPO and the CDO — authored the SDD
> non-interactively in one run; this file holds what that run could not settle from its inputs (the
> PRD, the SRS, the UXD, and any context or constraints).
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time the seats fold them in, they first copy this file
> whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a disagreement is not something one seat asked, it
> is something two seats answered differently, and the answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the run entirely.** §§ 1–4 are all the SDD's own three seats;
> § 5 is a seat that never wrote the SDD, reading it long after it settled and finding something
> only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's, which stay fixed
> to the three authoring seats on purpose.

> **No `product-sdd` run opened this companion. The PM opened it on 2026-09-23, from the first CI
> runs on a GitHub-hosted runner.** `SDD.md` is settled at v7 and had no companion on disk. Without
> one, a `product-sdd` re-run would read the SDD as done and find nothing to act on. The companion
> holds a single item, § 5.1: the measurement *Open Questions* waits for, which reads as neither of
> the two outcomes that item names.

---

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 The hosted runner is measured: the bundle is reported sandboxed, but not on the first ask — and C-I3 says nothing about when the probe reads
- **Raised by:** PM — 2026-09-23
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`; the fix to the probe is the change
  unit `ka-reader · tobiishi · 2026-09-23_the-probe-waits-for-the-sandbox`
  (`kensaiapp-opensource@1523865`)
- **What it blocks:** Nothing in the SDD is waiting on it to be built, but two sentences no longer
  say one thing. *Open Questions*' fourth item (`SDD.md:L2648-L2652`) is "settled by the probe's
  first CI run", and names two outcomes — "a control that does not fail there, or a bundle not
  reported sandboxed, is R-8". The runs gave a third: the bundle is reported sandboxed, a fraction
  of a second after the first ask. And R-8's *shows up as* (`SDD.md:L1966-L1971`) is
  "`checks/bundle.sh` finding the launched main process not reported sandboxed", with no word on when
  it asks. Read literally, every red CI run so far is R-8 — a re-cut trigger — while the wall stood.
- **Where it shows:**
  - The measurement. A temporary CI diagnostic (product branch `ci-sandbox-diagnostic`, `247b5ed`)
    launched a bundle and asked `checks/sandbox_probe.rs` five times, 0.25 s apart. Run 35797893381,
    `macos-14`, SIP disabled: the real bundle `sandboxed: no` with outbound `allowed` on ask 1, then
    `sandboxed: yes` with both denials on asks 2–5; an unentitled copy `sandboxed: no` on all five;
    the real bundle again `yes` on all five; a copy re-signed with the real entitlements `no` on ask
    1, `yes` on asks 2–5. The same run's `Bundle probe` step asked once and failed: pid 18980,
    `sandboxed: no`, `outbound-connection: allowed`. The run before it, 35794012057, answered `yes`
    on all 60 asks of three launches.
  - It is not the runner's alone. On the owner's Mac (SIP enabled, 2026-09-23) the same diagnostic's
    re-signed copy answered `sandboxed: no` on ask 1 and `yes` on asks 2–5.
  - § 4 C-I3 (`SDD.md:L533-L543`) fixes what the operating system must report and the negative
    control, and says nothing about when the report is read. `checks/bundle.sh:L273` reads it once,
    as soon as the pid is found.
  - ADR-0010's Consequences already separate the two meanings: "a probe that fails while the wall
    stands redraws the probe and no slice". The change unit above redraws the probe that way — a
    bounded wait for the first `sandboxed: yes`, and a negative control that must answer `no` for
    the whole window — and edits no document.
- **If a document has to be written:** none. What is owed is the fourth *Open Questions* item closed
  on this measurement, and one clause in C-I3 and R-8's *shows up as* saying the report is read
  within a bounded window after launch, with the negative control held for the same window. The PM's
  lean is to close the item as "the sandbox holds on a hosted runner; the probe read too early", and
  to name the window in C-I3 without a number, leaving the number to the script. Doubt: a window
  could be read as a probe bent to pass. The measured `no` for the whole window on the unentitled
  copy is what answers that, and the stricter control is what keeps it answered.
- **Answer:** confirm the PM's lean, with four additions. Close the fourth *Open Questions* item as
  "the sandbox holds on a hosted runner, and the probe read too early". Add a clause to C-I3 and to
  R-8's *shows up as* saying the report is read within a bounded window after launch, and state no
  number in the SDD. (1) C-I3 says the bound is fixed in the script and printed in the probe's output,
  so a failing run says how long it waited. (2) The pass is the first ask on which all three answers
  hold at once: sandboxed, the read denied, and the outbound connection denied. Every ask checks
  first that the launched pid still names a process, because `sandbox_check` reports "sandboxed,
  everything denied" for a pid that names none (`checks/sandbox_probe.rs:L103-L115`). A process gone
  before the pass is a failure. (3) The negative control answers `sandboxed: no` on every ask for the
  whole window. (4) On the hosted runner the unentitled copy reports the out-of-grant read *denied*
  on every ask (run 35797893381), so there that denial separates nothing. The closed item says so,
  and C-I3's "the two denials test the wall … rather than a proxy for it" is narrowed to where it
  holds. The ADR side of (4) is `docs/architecture_open_issues.md` § 3.3. C-I3 names one case the
  probe does not cover: a report that turns from `yes` back to `no` after the pass is never read.
  No § 10 entry is owed, because no slice's *Reached when* failed as written. The reasoning is in
  `docs/trail/sdd/self_answer-12.md`.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
