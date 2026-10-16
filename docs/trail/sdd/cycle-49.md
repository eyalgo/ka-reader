# SDD open issues — KA-Reader

> Companion to `SDD.md`. The CTO wrote the SDD; this file holds what that run could not settle from
> its inputs (the PRD, the SRS, the UXD, and any context or constraints), and the calls that are the
> CPO's or the CDO's to make. An item whose call is the CPO's or the CDO's carries that seat's
> `Seat:`; an item whose call is the CTO's carries `cto` or no `Seat:` field.
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time `product-sdd` folds them in, it first copies this
> file whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item may name the seat that answers it.** Any item in any section carries an optional
> `- **Seat:** <seat>` field beside its other fields. Its value is the name of the agent whose posture
> answers the item — `cto`, `cpo` or `cdo`. An item with no usable value, whether the field is absent,
> empty or still the `<seat>` placeholder, is answered in the seat of the skill that produced this file.
> The field names the *answering* seat. It is not the seat that raised the item (`Raised by:` /
> `Held by:`), and it is not the document an answer belongs to.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a
> disagreement is not something one seat asked, it is two positions held by different seats, and the
> answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the SDD's lanes entirely.** §§ 1–4 are all the SDD's own three
> lane seats; § 5 is a seat that never held a lane in it, reading it long after it settled and
> finding something only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's,
> which stay fixed to the three lane seats on purpose.

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-16, from a `shukuba-refine`
> review on the seed `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`,
> to carry item 5.1 below. The SDD is Settled, so without a companion it would reach no one.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 The `read-only-harness` row's inventory misses six files that landed in `checks/`
- **Raised by:** PM — 2026-10-16
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`
- **What it blocks:** nothing. The row's own rule says each of these "owes this row an item": its
  enumeration is pinned at `ka-reader@b12e48c`, and a file landing in `checks/` after that is a
  re-measurement.
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L365`). `git log --diff-filter=A
  --name-only b12e48c..13e8d42 -- checks` lists six files the row does not name. Two are new entry points:
  `checks/launch.sh`, which launches the built bundle and waits for its log on a fixed tick count, and
  `checks/own-state-step.sh`, which runs `checks/own-state.sh` against the machine's home on the same
  timer. One is a sourced helper, `checks/tests/support/vm_refusal.sh`, the shared assertion for the
  refusal off a virtual machine (`docs/nfdr.md` QC-65). Three are suites: `checks/tests/test_launch.sh`,
  `checks/tests/test_own_state_step.sh` and `checks/tests/test_vm_refusal.sh`.
- **If a document has to be written:** none. The fold re-measures the cell at a named commit, and keeps
  the `b12e48c` inventory as history.
- **Answer:** Confirmed, with additions. Re-measure the cell at `ka-reader@13e8d42`, the merge that
  landed the six files, and keep the `b12e48c` inventory as a dated note beside it; `ee80fc9`'s tree
  outside `docs/` is `13e8d42`'s (`git diff --stat 13e8d42 ee80fc9 -- . ':!docs'` prints nothing), so the
  pin names the tree the fold reads. The six files take the cell's own categories. **Two scripts,
  each the whole `run` of its own CI step:** `launch.sh`, the *Launch the built bundle* step
  (`.github/workflows/ci.yml:L112-L113`), which asks the host whether it is a macOS virtual machine
  before any other work (`docs/nfdr.md` QC-65), opens the built bundle once and waits a fixed 240
  ticks of 0.25 s for the app's log, looking in a child so a consent prompt cannot stop the count;
  and `own-state-step.sh`, the *Own state* step (`:L117-L118`), which runs `own-state.sh` as a child
  under the same bound and has no admission of its own — the child's refusal is the only output off
  a virtual machine. **Three suites, each the whole `run` of its own step:** `tests/test_launch.sh`
  (*Launch step suite*, `:L98-L99`), `tests/test_own_state_step.sh` (*Own state step suite*,
  `:L101-L102`) and `tests/test_vm_refusal.sh` (*VM refusal suite*, `:L95-L96`), the last paired with
  no script of its own — it runs `test_bundle.sh` and `test_renderer.sh` as subjects, because a
  suite that refuses cannot hold its own refusal case, and holds the workflow's shape. **One sourced
  helper, not a suite:** `tests/support/vm_refusal.sh`, the shared refusal assertion for QC-65, sourced
  by six suites (`test_bundle.sh:L53`, `test_renderer.sh:L52`, `test_own_state.sh:L29`,
  `test_launch.sh:L41`, `test_own_state_step.sh:L39`, `test_vm_refusal.sh:L36`) and placed under
  `support/` so that no loop over `checks/tests/*.sh` and no workflow step takes it for a suite
  (`checks/tests/support/vm_refusal.sh:L11-L12`). So the suite sentence is re-counted: ten scripts,
  eleven suites — one `test_<name>.sh` for each of the ten and `test_vm_refusal.sh` beside them; the
  fixture-folder count stays thirteen (`git log --diff-filter=A --name-only b12e48c..13e8d42 --
  checks/fixtures` prints nothing) and `fixtures/.gitignore` is still six lines. The cell's own
  locators moved under it and are re-pinned at `13e8d42`: `checks/bundle.sh:L321-L322` reads
  `:L338`, `:L341`; `checks/own-state.sh:L21` reads `:L118` (the comment at `:L28`), and `:L16-L20`,
  `:L64-L68` read `:L24-L28`, `:L59-L68` with the calls at `:L77`, `:L84`;
  `checks/tests/test_own_state.sh:L212`, `:L222`, `:L233` read `:L217`, `:L227`, `:L238`;
  `.github/workflows/ci.yml:L73-L74` reads `:L79-L80` and `:L116` reads `:L117-L118`, the *Own state*
  step now running `own-state-step.sh`, so the order the `.gitignore` sentence rests on still holds;
  the six `git_state.rs` locators read `:L1347-L1348`, `:L1363-L1367`, `:L1900-L1904`,
  `:L2130-L2134`, `:L2147-L2151` and `:L2811-L2815`; `root_finding.rs:L55`, `:L63` and
  `tests/walk.rs:L6` do not move. What each names is unchanged. The slice-owed list does not move:
  none of `churn.sh`, `latency.sh`, `contract.sh`, `fixtures/hostile.md`, `fixtures/history` or
  `fixtures/scale-*` is in the tree. Two things this answer does not write: the admission's rule,
  which is `docs/nfdr.md` QC-65's and reaches the row only as the description of what `launch.sh`
  does first; and `docs/nfdr.md` § 9's suite count, which that record's own companion carries
  (`docs/architecture_open_issues.md` § 3.3) and this fold does not pre-empt. Bound: the three new
  steps' hosted result is unread, Actions being off; the row says what is on disk and not that a
  step is green. Reasoning at `docs/trail/sdd/self_answer-60.md`.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
