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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-17, from a `shukuba-refine`
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

### 5.1 The `read-only-harness` row does not name `checks/gate.sh`, and it puts each script and suite on a workflow step of its own
- **Raised by:** PM — 2026-10-17
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`
- **What it blocks:** nothing. The row's own rule says a file that lands in `checks/` after its pin
  (`ka-reader@13e8d42`) owes it an item.
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L366`).
  `git diff --name-status 13e8d42 8b93322 -- checks` lists one new file, `checks/gate.sh`, and one changed
  file, `checks/tests/test_vm_refusal.sh`. The new file is the one ordered list of every rule the workflow
  held, each step fatal. The suite now checks the gate's list, not the workflow's shape. The row calls
  `launch.sh` and `own-state-step.sh` "the whole `run`" of their own workflow steps, and calls each of the
  eleven suites "the whole `run` of its own CI step". At `8b93322` the workflow's one rule step runs
  `checks/gate.sh` (`.github/workflows/ci.yml:L26`), and each of those is a step of the gate.
- **If a document has to be written:** none. The fold would re-measure the cell at a named commit. It would
  add `gate.sh`, say the workflow calls the gate, and keep the `13e8d42` inventory as history. The eleven
  suites, the sourced helper and the thirteen fixture folders do not change.
- **Answer:** Confirmed, with additions. Re-measure the cell at `ka-reader@8b93322`, the merge that
  landed `checks/gate.sh`, and keep the `13e8d42` inventory as a dated note beside it, as the cell
  keeps `b12e48c`'s; `e602658`'s tree outside `docs/` is `8b93322`'s (`git diff --stat 8b93322 e602658
  -- . ':!docs'` prints nothing), so the pin names the tree the fold reads. `git diff --name-status
  13e8d42 8b93322 -- checks` lists `checks/gate.sh`, added, and `checks/tests/test_vm_refusal.sh`,
  changed, and nothing else; the same range over `.github/workflows` lists `ci.yml`, changed. **One
  new script, the runner:** `gate.sh`, mode `100755`, the one ordered list of the gate's 26 steps,
  each the whole command of one `run_step` call (`checks/gate.sh:L43-L91`), run in order in a child
  shell, the first non-zero status ending the run with the failed step's name (`:L26-L33`) — the
  script `docs/nfdr.md` QC-64 asks for, and this row names the script and not QC-64's rule. **The
  workflow now holds one rule step:** *Test gate*, whose whole `run` is `checks/gate.sh`
  (`.github/workflows/ci.yml:L25-L26`), followed by packaging and upload of the bundle (`:L31-L32`,
  `:L34-L39`); the file is 39 lines, so every `ci.yml` step locator the cell carries — `:L79-L80`,
  `:L95-L96`, `:L98-L99`, `:L101-L102`, `:L112-L113`, `:L117-L118` — names a line that is not there,
  and each moves to the gate. So three of the cell's sentences are re-said: `launch.sh` is the whole
  command of the gate's *Launch the built bundle* step (`checks/gate.sh:L88`) and `own-state-step.sh`
  of its *Own state* step (`:L91`), the last; `tests/`, eleven suites, each the whole command of its
  own step of `checks/gate.sh` — `test_structure.sh` `:L50`, `test_entry_points.sh` `:L52`,
  `test_bundle.sh` `:L55`, `test_view.sh` `:L57`, `test_renderer.sh` `:L67`, `test_read_only.sh`
  `:L71`, `test_no_network.sh` `:L73`, `test_own_state.sh` `:L74`, `test_vm_refusal.sh` `:L77`,
  `test_launch.sh` `:L78`, `test_own_state_step.sh` `:L79` — which the workflow runs through *Test
  gate*; and the `.gitignore` sentence's order holds inside the gate: *Read-only, submodule* (`:L70`)
  runs before *Own state* (`:L91`). **The script count moves and the suite count does not:** eleven
  scripts, of which ten are checks with a `test_<name>.sh` each, and `gate.sh`, the runner, paired
  with no suite of its own; eleven suites, `test_vm_refusal.sh` still beside the ten.
  **`test_vm_refusal.sh` no longer holds the workflow's shape; it reads the gate's list:** version
  1.1.0 (`checks/tests/test_vm_refusal.sh:L2`) says it proves that the workflow runs the refusal and
  step suites (`:L5-L6`), binds `GATE` beside `WORKFLOW` (`:L35-L36`), and reads the steps off
  `gate.sh`'s top-level `run_step` lines, taking a list with anything else between them as no list
  (`:L61-L76`); its step cases — the moved steps as single-line commands in the gate's order, every
  top-level suite an entire fatal step — read that list (`:L193-L238`), and the workflow is read only
  for its one gate step and its packaging step (`:L211-L220`), for the absence of a conditional or
  non-fatal step (`:L240-L243`), and for every runner naming `macos-26` (`:L245-L250`). Its `source`
  of the helper moved from `:L36` to `:L39`; the other
  five sourcing lines, `test_bundle.sh:L53`, `test_renderer.sh:L52`, `test_own_state.sh:L29`,
  `test_launch.sh:L41` and `test_own_state_step.sh:L39`, do not move. The fixture-folder count stays
  thirteen and `fixtures/.gitignore` six lines (the diff over `checks/fixtures` prints nothing); the
  slice-owed list does not move. Two things this answer does not write: QC-65's admission rule, which
  reaches the row only as what `launch.sh` does first; and `docs/nfdr.md` § 9's suite-as-step rule,
  which that record's own companion carries (`docs/architecture_open_issues.md` § 3.3, open at this
  answer) and this fold does not pre-empt. Bound: GitHub Actions is still disabled on the repository
  (`gh api repos/eyalgo/ka-reader/actions/permissions` → `enabled: false`, re-read 2026-10-20), so
  the gate's hosted result is unread; the row says what is on disk and on which step of the gate,
  not that a step is green. **One addition outside the row, the same landing's consequence in this
  document:** § 4 C-I3's sentence "CI runs the same script after `assemble.sh` on every push
  (`.github/workflows/ci.yml:L41`, `:L51`)" (`docs/SDD.md:L857`) names two lines the 39-line workflow
  no longer has; the fact holds, and the locators move to `checks/gate.sh:L47` (*Build
  KA-Reader.app*) and `:L56` (*View check*), called from `ci.yml:L26`. § 6 S-1's
  "`.github/workflows/ci.yml` builds `KA-Reader.app` and runs every script below on every push"
  (`:L1720`) stays true through the gate and is owed no word. Reasoning at
  `docs/trail/sdd/self_answer-61.md`.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
