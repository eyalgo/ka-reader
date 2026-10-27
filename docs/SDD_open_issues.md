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
> answers the item — `cto`, `cpo` or `cdo`. An item with no usable value is answered in the seat of
> the skill that produced this file.
>
> **§ 5 names a raiser from outside the SDD's lanes entirely.**

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-23, from a `shukuba-refine`
> review, to carry item 5.1 below: the SDD is Settled with no companion beside it, so without this
> file its own producing skill would find nothing to act on.

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

### 5.1 § 3's `read-only-harness` row counts twelve suites and 29 gate steps, and says one step fetches; at `ka-reader@1b32500` there are thirteen suites and 30 steps, and two steps fetch
- **Raised by:** PM — 2026-10-23
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-03_no-secret-reaches-the-repository`
- **What it blocks:** nothing. The row is pinned to `ka-reader@8235240` and is true of that tree; by
  its own rule a file landing in `checks/` after that commit is a re-measurement the row is owed, not
  a contradiction.
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L370`), calls `gate.sh` "the
  one ordered list of the gate's 29 steps" at version 1.2.0 (`checks/gate.sh:L47-L113` at the pin),
  counts twelve suites, and says the *Secret scan* step "reaches the network on every run … and no
  other step fetches" except the sanitizer step's first run. At `ka-reader@1b32500`:
  `git diff --name-status 8235240 1b32500 -- checks` lists `A checks/tests/test_secret_scan_planted.sh`
  and `M checks/gate.sh`, and nothing else under `checks/`. `checks/gate.sh` is at version 1.3.0
  (`:L2`) and `grep -c '^run_step' checks/gate.sh` prints 31 — 30 steps and the `run_step()`
  definition. The new step is *Planted secret suite* (`:L67`), directly after *Build the workspace*
  (`:L60`), with its ordering comment at `:L61-L66`; *Secret scan suite* is now at `:L49` and
  *Secret scan* at `:L59`, so every gate locator the row pins has moved. The new suite is a negative
  control for `secret-scan.sh`: it runs the real script twice over a disposable repository it builds,
  clean and then with one commit holding a secret-shaped string built at run time, and passes only
  when the clean run exits 0 and the planted run exits non-zero with a finding at the planted commit.
  It pairs with no new script, so the script count does not grow, and it adds no fixture folder. Each
  of its two runs fetches gitleaks 8.30.1's archive and checks the pinned SHA-256, so the row's
  sentence that no step but *Secret scan* fetches on every run no longer holds. Measured in a
  disposable clone at `ka-reader@1b32500` on the host: the suite exited 0, `19 of 19 passed`, and
  `checks/secret-scan.sh gitleaks git` printed `ok` with `commits scanned: 1291`.
- **If a document has to be written:** none. The fold would add a dated reading of the 30-step gate
  and thirteen suites at a named commit, with its locators re-pinned and the new suite named, and
  keep the `8235240` reading as a dated note.
- **Answer:** Confirmed, with the rest of the fold measured and added. Re-measure § 3's `read-only-harness` row at `ka-reader@1b32500`, the merge that landed the gate's thirtieth step, and re-pin the row to it; keep the `8235240` reading as a dated note, as the row keeps `389adad`'s. What the fold writes, all of it read in the main checkout at `ka-reader@33581f3`, whose tree outside `docs/` differs from `1b32500`'s in `README.md` alone (`git diff --stat 1b32500 33581f3 -- . ':!docs'`): (1) `gate.sh` at version 1.3.0 (`checks/gate.sh:L2`; the 1.2.0 line now `:L3-L4`), 121 lines, the one ordered list of 30 steps at `:L48-L121`, the dispatcher at `:L30-L37`, and `grep -c '^run_step'` printing 31. (2) The one step added since `8235240` is *Planted secret suite* (`:L67`; its comment `:L61-L66`), the whole command of `checks/tests/test_secret_scan_planted.sh`, directly after *Build the workspace* (`:L60`) and before *Build KA-Reader.app* (`:L70`); the comment says why it cannot sit earlier — *Secret scan suite* runs the gate in a fixture whose *Build the workspace* is the step meant to stop it. (3) What the step does, as the row says of every other step: the suite, at version 1.0.0 (`checks/tests/test_secret_scan_planted.sh:L2-L3`), is the negative control of `secret-scan.sh` — it runs the real script, with the real gitleaks fetched and checked against the pinned SHA-256 exactly as *Secret scan* fetches it, twice over one disposable repository it builds under `mktemp`: once over a clean commit, which must exit 0, and once after a commit adding a secret-shaped string joined from fragments at run time, which must exit non-zero with a finding at that commit (`:L8-L26`); it passes only when both runs printed the line saying the archive matched its pin (`:L47-L53`); it reads none of the machine's Git configuration, prints the planted string never, writes nothing into the product's checkout and does not move its HEAD (`:L34-L45`). It pairs with no new script and adds no fixture folder. (4) The fetch sentence moves: *Secret scan* is no longer the only step that reaches the network on every run — *Planted secret suite* fetches the archive twice per run, once per scan, and its header says so (`:L48-L50`); so the gate fetches three times on every run, in two steps, and a machine that cannot reach `github.com` still ends at *Secret scan* (`:L59`), the earlier of the two. The sanitizer sentence (its nightly on the first run alone) stands. (5) The sentence on `test_secret_scan.sh` that "the planted-secret control is not part of the change that landed it" is now history: the control landed at `1b32500` as `test_secret_scan_planted.sh`; `test_secret_scan.sh`'s own header still reads so at `:L14-L16` and did not change between the pins, and the row says which file carries the control rather than quoting a header that predates it. (6) `test_vm_refusal.sh` is unchanged between the pins and reads the suites off the disk (`:L237`), so the new suite is checked as the entire command of one gate step with no change to that file — the same sentence the row already carries for `test_secret_scan.sh`, extended. (7) The counts: twelve scripts, unchanged (`ls checks/*.sh`); **thirteen suites** — one `test_<name>.sh` for each of the eleven checks, `test_vm_refusal.sh`, and `test_secret_scan_planted.sh`, the second suite paired with no script of its own; thirteen fixture folders and the six-line `fixtures/.gitignore`, unchanged — `git diff --name-status 8235240 1b32500 -- checks .github` lists `M checks/gate.sh` and `A checks/tests/test_secret_scan_planted.sh` and nothing else, so the workflow's 41 lines and every `ci.yml` locator stand. (8) The line map, read at both pins: `gate.sh` gained one line at `:L2` and seven at `:L61-L67`, so every `gate.sh` locator the row pins at old `:L2` through `:L60` reads one higher and every one at or below old `:L61` reads eight higher — *Toolchain* `:L47` → `:L48`; *Secret scan suite* `:L48` → `:L49`, its comment `:L49-L57` → `:L50-L58`; *Secret scan* `:L58` → `:L59`; *Build the workspace* `:L59` → `:L60`; *Test gate* `:L63` → `:L71`; the sanitizer step `:L70` → `:L78`, its comment `:L64-L69` → `:L72-L77` and `:L67-L69` → `:L75-L77`; *Structure check* `:L71` → `:L79`; the ten suite steps `:L72`, `:L74`, `:L77`, `:L79`, `:L89`, `:L93`, `:L95`, `:L96`, `:L100`, `:L101` → `:L80`, `:L82`, `:L85`, `:L87`, `:L97`, `:L101`, `:L103`, `:L104`, `:L108`, `:L109`; *VM refusal suite* `:L99` → `:L107`; *Read-only, submodule* `:L92` → `:L100`; *Launch the built bundle* `:L110` → `:L118`; *Own state* `:L113` → `:L121`; the dispatcher `:L29-L36` → `:L30-L37`. A locator inside an earlier dated note stays as history. (9) Outside the row, three § 4 C-I3 locators into `gate.sh` move with it and the fold re-pins them, each old reading kept in its sentence as RN-118 did: the dispatcher `:L29-L36` (`docs/SDD.md:L830`) → `:L30-L37`; *Build KA-Reader.app* `:L62` and *View check* `:L78` (`:L894`) → `:L70`, `:L86`; their `ci.yml:L28` stands. No other locator into `checks/` or `ci.yml` below the review notes is in a changed file. (10) What stands: the row's pin rule; `docs/SRS.md` NFR-8 binds the product, not the harness, so a second fetching step changes nothing there; § 6 S-7's release-time `gitleaks git` and § 11 R-13 do not move; the NFDR's § 8 count and § 9 enumeration are `docs/architecture_open_issues.md` § 3.1's and are not pre-empted here. The gate was not run in this answer; the suite's `19 of 19 passed` and the gate's exit 0 in the guest are the station's record, read as an input and cited by the row nowhere. A review note records the fold. Reasoning at `docs/trail/sdd/self_answer-65.md`.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
