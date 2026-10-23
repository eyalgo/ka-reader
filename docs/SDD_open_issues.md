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

### 5.1 § 3's `read-only-harness` row counts eleven scripts, eleven suites and 27 gate steps; at `ka-reader@8235240` there are twelve, twelve and 29
- **Raised by:** PM — 2026-10-23
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-03_no-secret-reaches-the-repository`
- **What it blocks:** nothing. The row is pinned to `ka-reader@389adad` and is true of that tree; by
  its own rule a later change to `checks/` is a re-measurement the row is owed, not a contradiction.
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L369`), counts "eleven scripts,
  eleven suites, thirteen fixture folders" and calls `gate.sh` "the one ordered list of 27 steps"
  (`checks/gate.sh:L45-L100` at the pin, version 1.1.0). At `ka-reader@8235240`:
  `git diff --name-status 389adad 8235240 -- checks .github` lists two added files,
  `checks/secret-scan.sh` (version 1.0.0) and `checks/tests/test_secret_scan.sh`, and modifications
  to `.github/workflows/ci.yml`, `checks/gate.sh`, `checks/no-network.sh`, `checks/structure.sh`,
  `checks/tests/test_no_network.sh` and `checks/tests/test_structure.sh`. `checks/gate.sh` is at
  version 1.2.0 (`:L2`) and `grep -c '^run_step' checks/gate.sh` prints 30 — 29 steps and the
  `run_step()` definition. The two new steps are *Secret scan suite* (`:L48`, running
  `checks/tests/test_secret_scan.sh`) and *Secret scan* (`:L58`, running
  `checks/secret-scan.sh gitleaks git`), with the comment above it at `:L49-L57` naming gitleaks
  8.30.1 and how the step fetches it. Both sit between *Toolchain* (`:L47`) and *Build the workspace*
  (`:L59`), so every gate locator the row pins below `:L47` has moved. The workflow's checkout gained
  `with: fetch-depth: 0` (`.github/workflows/ci.yml:L22-L23`), so the row's `ci.yml` locators want the
  same re-read. No `.gitleaksignore` is in the tree (`ls .gitleaksignore` → no such file). The
  new script fetches a pinned release archive and checks its SHA-256 before running it; the fold
  decides whether the row's *Owns* cell names that, beside the scanner and its suite.
- **If a document has to be written:** none. The fold would add a dated reading of the 29-step gate,
  twelve scripts and twelve suites at a named commit, with its locators re-pinned, and keep the
  `389adad` reading as a dated note.
- **Answer:** confirmed with addition. Re-measure the row at `ka-reader@8235240`, the merge that
  landed the gate's twenty-eighth and twenty-ninth steps, and keep the `389adad` reading as a dated
  note, as the item leans — and move four locators the item does not name, state the two new steps
  by what they do, and record the four other `checks/` files that changed between the pins.
  Measured in the main checkout, read-only, at `ka-reader@914ceb3`, whose tree outside `docs/` is
  `8235240`'s (`git diff --stat 8235240 914ceb3 -- . ':!docs'` prints nothing). **The gate.**
  `checks/gate.sh` is at version 1.2.0 (`:L2-L3`; 1.1.0's line is now `:L4`); the dispatcher is
  `:L29-L36`; the list is 29 steps at `:L47-L113` (`grep -c '^run_step' checks/gate.sh` prints 30).
  The two new steps sit between *Toolchain* (`:L47`) and *Build the workspace* (`:L59`), before any
  build: *Secret scan suite* (`:L48`, `checks/tests/test_secret_scan.sh`) and *Secret scan* (`:L58`,
  `checks/secret-scan.sh gitleaks git`, its comment `:L49-L57`). Old `:L45` reads `:L47`, and every
  locator the row pins at or below old `:L46` reads thirteen higher: the sanitizer step `:L57` reads
  `:L70`, its comment `:L51-L56` reads `:L64-L69` and `:L54-L56` reads `:L67-L69`; *Test gate* `:L50`
  reads `:L63`; *Structure check* `:L58` reads `:L71`; the ten suite steps `:L59`, `:L61`, `:L64`,
  `:L66`, `:L76`, `:L80`, `:L82`, `:L83`, `:L87`, `:L88` read `:L72`, `:L74`, `:L77`, `:L79`, `:L89`,
  `:L93`, `:L95`, `:L96`, `:L100`, `:L101`; *VM refusal suite* `:L86` reads `:L99`; *Read-only,
  submodule* `:L79` reads `:L92`; *Launch the built bundle* `:L97` reads `:L110`; *Own state*
  `:L100` reads `:L113`. **Outside the row, in § 4 C-I3**, the same file moves three locators the
  item does not name: the dispatcher `checks/gate.sh:L27-L34` (`docs/SDD.md:L829`) reads
  `:L29-L36`, and the *Build KA-Reader.app* and *View check* steps `:L49`, `:L65`
  (`docs/SDD.md:L893-L894`) read `:L62`, `:L78`. **The workflow.** `.github/workflows/ci.yml` is 41
  lines: the checkout gained `with: fetch-depth: 0` (`:L22-L23`), so the row's *Test gate*
  `:L25-L26`, packaging `:L31-L32` and upload `:L34-L39` read `:L27-L28`, `:L33-L34`, `:L36-L41`,
  and C-I3's `ci.yml:L26` (`docs/SDD.md:L894`) reads `:L28`; `runs-on: macos-26` stays at `:L18`.
  The fetch depth is there because the scan refuses a shallow history. **What the scan step is**, as
  the row describes every other step by what it does: `checks/secret-scan.sh`, version 1.0.0
  (`:L2-L4`), takes the two fixed words and nothing else (`:L62-L67`); needs `git`, `uname`, `curl`,
  `tar`, `shasum` and `mktemp` on PATH (`:L71-L74`); takes the commit and its count from
  `git rev-parse` and `git rev-list --count` (`:L79-L80`); refuses a shallow checkout (`:L85-L87`);
  reads `.gitleaksignore` at the product root, absent meaning no exception (`:L95`), and refuses a
  line that is not one full-hash `commit:file:rule:line` fingerprint with a reason comment directly
  above it (`:L93-L94`, `:L111-L114`) — no `.gitleaksignore` is in the tree; fetches gitleaks
  8.30.1's release archive for Darwin arm64 or x86_64 **on every run** (`:L124-L138`,
  `:L147-L151`) and refuses any other host, checks the archive against the SHA-256 pinned at
  `:L42-L43` and the unpacked executable's reported version against 8.30.1 (`:L153-L155`,
  `:L171-L172`), and installs nothing; runs it with the default rules extended by nothing and no
  exclusion (`:L176-L183`), every `GITLEAKS_` variable cleared (`:L190-L193`), `--exit-code 2`, and
  `--log-opts "--full-history --diff-merges=first-parent <sha>"` over the whole history HEAD reaches
  (`:L194-L201`); prints a finding by commit, file, line, rule and fingerprint with its text
  redacted (`:L204-L211`); and exits 0 only on a clean scan with HEAD still the commit it started
  from (`:L213-L228`). The two pinned digests are the ones `gitleaks_8.30.1_checksums.txt`
  publishes for those two archives (read at the vendor's release on 2026-10-23). So this step
  reaches the network on every run, where the sanitizer step fetches its nightly on the first run
  alone and no other step fetches: a machine that cannot reach `github.com` ends the gate at
  *Secret scan*, named by the dispatcher, with "nothing was scanned". **What its suite is:**
  `checks/tests/test_secret_scan.sh`, version 1.0.0 (`:L2-L3`), drives the real script and the real
  `gate.sh` against disposable repositories with `uname`, `curl`, `shasum` and the unpacked gitleaks
  as stand-ins (`:L9-L20`), reaches no network (`:L24`), and by its own header proves the script's
  protocol and not the vendor's detection — the planted-secret control is not part of this change
  (`:L15-L18`). **The counts.** Twelve scripts — eleven checks with a `test_<name>.sh` each, and
  `gate.sh`, the runner, with none — and twelve suites; `test_vm_refusal.sh` reads the suites off the
  disk (`:L237`), so its every-suite-is-one-step check covers the new one, and the file did not
  change. Thirteen fixture folders and the six-line `fixtures/.gitignore` do not move
  (`git diff --name-status 389adad 8235240 -- checks .github` lists eight files, none under
  `fixtures/`). **The other four files in that diff** — `no-network.sh` 1.1.0 → 1.2.0 with
  `tests/test_no_network.sh` 1.2.0 → 1.3.0 (a Swift target of type `system` is refused, by name), and
  `structure.sh` 1.5.0 → 1.6.0 with `tests/test_structure.sh` 1.4.0 → 1.5.0 (QC-10's adapter clause,
  QC-11's `git_reader`, `watcher` and `markdown_renderer` subjects, QC-17's adapter construction) —
  move no locator: neither the row nor C-I3 pins a line in any of them, and the row names the
  scripts and not their rules. **Not changed by this answer:** § 6 `promise-one-point-zero`'s
  release-time `gitleaks git` (`docs/SDD.md:L2336`) — the gate now runs the same tool on every
  build, and the slice's command stands; `docs/nfdr.md` QC-28 and § 8's count, which are that
  record's own and already carried by `docs/architecture_open_issues.md` § 3.1; every locator inside
  an earlier dated note. GitHub Actions is still disabled on the repository
  (`gh api repos/eyalgo/ka-reader/actions/permissions` prints `enabled: false`, re-read 2026-10-23),
  and this run did not run the gate: the row says what is on disk and on which step, as it already
  does. Reasoning at `docs/trail/sdd/self_answer-64.md`.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
