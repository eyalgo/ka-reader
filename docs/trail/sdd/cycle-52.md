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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-22, from a `shukuba-refine`
> review on the seed `ka-reader · nemawashi · 2026-10-01_the-bridge-runs-under-the-sanitizer`,
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

### 5.1 § 3's `read-only-harness` row counts the gate at 26 steps; at `ka-reader@389adad` it has 27
- **Raised by:** PM — 2026-10-22
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-01_the-bridge-runs-under-the-sanitizer`
- **What it blocks:** nothing. The row is pinned to `ka-reader@8b93322` and is true of that tree; by
  its own rule a later change to `checks/` is a re-measurement the row is owed, not a contradiction.
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L368`), calls `gate.sh` "the one
  ordered list of the gate's 26 steps" (`checks/gate.sh:L43-L91` at the pin). At `ka-reader@389adad`
  `grep -c '^run_step' checks/gate.sh` prints 28 — 27 steps and the `run_step()` definition (`:L27`);
  at `8b93322` it prints 27. The added step is *Bridge tests under the address sanitizer*
  (`checks/gate.sh:L57`), between *Test gate* (`:L50`) and *Structure check* (`:L58`), so the row's
  locators below that step are not where the row pins them. No script, suite or fixture was added,
  removed or renamed: `git diff --name-status --diff-filter=ADR 8b93322 389adad -- checks` prints
  nothing, so the eleven scripts, eleven suites and thirteen fixture folders do not move. Other files
  in `checks/` did change in that range (comments re-wrapped at `ae72bdc`), so the row's other
  locators want the same re-read; the step itself is `checks/gate.sh`'s only change since `eb50e87`
  (`git diff --stat eb50e87 389adad -- checks`: `checks/gate.sh`, 8 lines added).
- **If a document has to be written:** none. The fold would add a dated reading of the 27-step gate
  at a named commit, with its locators re-pinned, and keep the `8b93322` inventory as a dated note.
- **Answer:** Confirmed with addition. Re-measure the row at `ka-reader@389adad`, the merge that landed the step, and re-pin it there: 27 top-level `run_step` calls (`grep -c '^run_step' checks/gate.sh` → 28), the list at `checks/gate.sh:L45-L100`, the dispatcher at `:L27-L34`, the script at version 1.1.0 (`:L2`); the new step *Bridge tests under the address sanitizer* at `:L57`, its comment at `:L51-L56`, after *Test gate* (`:L50`) and before *Structure check* (`:L58`) — `cargo test --locked -p ka-reader-bridge` on `nightly-2026-10-21`, named inside the command and nowhere else (`rust-toolchain.toml` stays `stable` for every other step), with `-Zsanitizer=address` and `-Cllvm-args=-asan-globals=0` as rustflags scoped to the host target, and `RUSTUP_AUTO_INSTALL=1`, so a machine without that nightly fetches it on the step's first run; whether the globals flag meets `docs/nfdr.md` QC-13 is the Principal Architect's (`docs/architecture_open_issues.md` § 3.2), and the row states the flag, not a ruling. The step is paired with no script and no suite of the row's, so the counts stand — eleven scripts, eleven suites, thirteen fixture folders, `fixtures/.gitignore` six lines: `git diff --name-status --diff-filter=ADR 8b93322 389adad -- checks` prints nothing, and the same range over `.github/workflows` and `crates/ka-reader-core/tests` prints nothing, so `ci.yml:L25-L26`, `:L31-L32`, `:L34-L39` and every `root_finding.rs` and `git_state.rs` locator hold. Keep the `8b93322` reading as a dated note, as the row keeps `13e8d42`'s. Three additions the item does not carry. (1) The gate's locators also stand outside the row, and the same fold re-pins them: § 4 C-I3's `checks/gate.sh:L26-L33` (`docs/SDD.md:L824`) reads `:L27-L34`, and C-I3's `:L47`, `:L56` (`docs/SDD.md:L882`) read `:L49`, `:L65`. (2) `ae72bdc` (merged at `eb50e87`, inside the range) re-wrapped comments in 21 files under `checks/`, so most of the row's other locators moved under it; each was found again by its content with nothing it names changed, and reads at `389adad`: the gate's suite steps `:L50`, `:L52`, `:L55`, `:L57`, `:L67`, `:L71`, `:L73`, `:L74`, `:L78`, `:L79` read `:L59`, `:L61`, `:L64`, `:L66`, `:L76`, `:L80`, `:L82`, `:L83`, `:L87`, `:L88`; *VM refusal suite* `:L77` reads `:L86`, *Launch the built bundle* `:L88` reads `:L97`, *Own state* `:L91` reads `:L100`, *Read-only, submodule* `:L70` reads `:L79` and the three walk steps `:L68-L70` read `:L77-L79`; `checks/bundle.sh:L338`, `:L341` read `:L347`, `:L350`; `checks/launch.sh:L42-L44`, `:L50-L71` read `:L45-L47`, `:L53-L74`; `checks/own-state-step.sh:L22-L26`, `:L41-L62` read `:L23-L27`, `:L42-L63`; `checks/tests/test_vm_refusal.sh:L35-L36`, `:L39`, `:L5-L18`, `:L62-L76`, `:L193-L237`, `:L211-L223`, `:L239-L243`, `:L245-L251` read `:L36-L37`, `:L40`, `:L5-L19`, `:L63-L77`, `:L199-L243`, `:L217-L229`, `:L245-L249`, `:L251-L258`, and its `:L2` does not move; of the sourcing lines, `test_bundle.sh:L53`, `test_launch.sh:L41`, `test_own_state_step.sh:L39` read `:L57`, `:L43`, `:L40`, and `test_renderer.sh:L52`, `test_own_state.sh:L29` do not move; `checks/tests/support/vm_refusal.sh:L43-L46`, `:L11-L12` read `:L53-L56`, `:L12-L13`; `checks/own-state.sh:L118`, `:L28`, `:L23-L27` read `:L121`, `:L30`, `:L25-L29`; `checks/tests/test_own_state.sh:L217`, `:L227`, `:L238` do not move; `checks/read-only.sh` gained one line at `:L6` (its usage line wrapped), so every locator into it above that line reads one higher — the row's `:L179-L180` reads `:L180-L181`, and C-I3's `:L210-L252`, `:L24-L29`, `:L212-L215`, `:L217-L223`, `:L238-L249`, `:L245`, `:L368`, `:L389`, `:L19-L22`, `:L45-L65`, `:L286-L318`, `:L326-L349`, `:L179-L204`, `:L352-L357`, `:L339-L347`, `:L311-L317`, `:L347`, `:L73-L76` read `:L211-L253`, `:L25-L30`, `:L213-L216`, `:L218-L224`, `:L239-L250`, `:L246`, `:L369`, `:L390`, `:L20-L23`, `:L46-L66`, `:L287-L319`, `:L327-L350`, `:L180-L205`, `:L353-L358`, `:L340-L348`, `:L312-L318`, `:L348`, `:L74-L77` — while `:L2-L3`, `checks/tests/test_read_only.sh:L922` and `checks/fixtures/.gitignore:L1-L6` do not move. A locator inside a dated note stays as history. (3) GitHub Actions is still disabled on the repository (`gh api repos/eyalgo/ka-reader/actions/permissions` → `enabled: false`, re-read 2026-10-22), so the step's hosted result is unread; its one run is the station's, in the guest, and the row says what is on disk and on which step, not that a step is green. `docs/nfdr.md` § 8's own 26-step sentence is the Principal Architect's, carried by `docs/architecture_open_issues.md` § 3.1, and is not pre-empted here. Reasoning: `docs/trail/sdd/self_answer-63.md`.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
