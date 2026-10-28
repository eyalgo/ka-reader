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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-28, from a `shukuba-refine`
> review, to carry item 5.1 below: the SDD is Settled with no companion beside it, so without this
> file its own producing skill would find nothing to act on.

---

## 1. Open issues — questions with no answer yet

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

## 4. Disagreements — two seats hold different positions and neither yields

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 § 3's `read-only-harness` row counts twelve scripts, thirteen suites and a 30-step gate; at `ka-reader@cd65c02` there are thirteen scripts, fourteen suites and 31 steps
- **Raised by:** PM — 2026-10-28
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-03_no-internal-text-reaches-a-surface`
- **What it blocks:** nothing. The row is pinned to `ka-reader@1b32500` and is true of that tree; by
  its own rule "a file landing in `checks/` after that commit is a re-measurement of this cell and
  not a contradiction of it, and it owes this row an item" (`docs/SDD.md:L371`).
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L371`), calls `gate.sh` "the one
  ordered list of the gate's 30 steps" at version 1.3.0 (`checks/gate.sh:L48-L121` at the pin), counts
  "twelve scripts — eleven checks with a `test_<name>.sh` each, and `gate.sh`" and "thirteen suites",
  and names no `strings.sh`. At `ka-reader@cd65c02`: `git diff --name-status 1b32500 cd65c02 -- checks`
  lists `M checks/gate.sh`, `A checks/strings.sh` and `A checks/tests/test_strings.sh`, and nothing
  else. `checks/strings.sh` is a new check: a lint over the string literals of the `.swift` files under
  `ka-reader-mac/Sources/Surfaces/` for the terms in the *Never* column of `docs/CONTENT.md`
  § Terminology's banned table, read from that file at run time, non-zero with a `QC-53` line per file
  and term on a hit. `checks/tests/test_strings.sh` is its suite. `ls checks/*.sh | wc -l` prints 13
  and `ls checks/tests/*.sh | wc -l` prints 14. `checks/gate.sh` is version 1.4.0 (`:L2`) and
  `grep -c '^run_step' checks/gate.sh` prints 32 — 31 steps, `:L49-L123`, and the `run_step()`
  definition at `:L31`. The new step is *Strings check suite* (`:L105`), directly after *No-network
  suite* (`:L104`); no step runs `checks/strings.sh` itself (`grep -c "checks/strings.sh'"
  checks/gate.sh` prints 0). The new files add no fixture folder and reach no network. Measured in a
  disposable clone at `ka-reader@cd65c02` on the host: `checks/strings.sh` exited 0 with `Swift files
  read: 30; banned terms read: 49`, and the suite exited 0, `50 of 50 passed`.
- **If a document has to be written:** none. The fold would add a dated reading of thirteen scripts,
  fourteen suites and the 31-step gate at a named commit, with the gate locators re-pinned and the new
  script and suite named, and keep the `1b32500` reading as a dated note.
- **Answer:** Confirmed with addition (`docs/trail/sdd/self_answer-66.md`). The lean holds — a dated
  reading of thirteen scripts, fourteen suites and the 31-step gate at a named commit, the gate
  locators re-pinned, the new script and suite named, and the `1b32500` reading kept as a dated note in
  the shape of the ones before it — and it stops short of what the fold has to move and say, so it is
  confirmed with the rest measured and added. The pin is `ka-reader@cd65c02` (2026-10-28), the merge
  that landed the lint, its suite and the gate's thirty-first step; the tip this answer read,
  `ka-reader@28d255d`, holds its tree outside `docs/` (`git diff --stat cd65c02 28d255d -- . ':!docs'`
  prints nothing). `git diff --name-status 1b32500 cd65c02 -- checks` lists `M checks/gate.sh`,
  `A checks/strings.sh`, `A checks/tests/test_strings.sh` and nothing else, and the same range over
  `.github` and `checks/fixtures` prints nothing. What the fold writes, in seven parts:
  **(1) The gate.** `gate.sh` at version 1.4.0 (`checks/gate.sh:L2`; 1.3.0's line now at `:L3`,
  1.2.0's at `:L4-L5`) — the one ordered list of the gate's 31 steps at `:L49-L123` (`grep -c
  '^run_step' checks/gate.sh` prints 32, the 31 calls and the definition), the dispatcher at
  `:L31-L38`. The step added since `1b32500` is *Strings check suite* (`:L105`), directly after
  *No-network suite* (`:L104`) and before *Own state suite* (`:L106`), carrying no comment of its own:
  the whole command of `tests/test_strings.sh`, named below. No step runs `checks/strings.sh` itself
  (`grep -c "checks/strings.sh'" checks/gate.sh` prints 0). At this pin the lint reaches the gate
  through its suite: the case `test_unchanged_catalogue_copy_passes`
  (`checks/tests/test_strings.sh:L541-L545`) runs the real lint over a copy of the tree's own
  catalogue and `docs/CONTENT.md` (`:L121-L127`) and fails on a non-zero exit or a `QC-53` line
  (`:L183-L196`), so a banned term in the catalogue turns *Strings check suite* red. A step whose whole
  command is `checks/strings.sh` is not in the list, and by this row's own rule the row records it when
  it lands. The row's sentence that "every script and suite named below runs as a step of the gate and
  not as a step of the workflow" is qualified: `strings.sh` is the one check script in no step of its
  own, and nothing named below runs as a step of the workflow.
  **(2) The line map.** `gate.sh` gained one line at `:L2`, the version line, and one at `:L105`, the
  step, so every `gate.sh` locator this cell pinned from old `:L2` to old `:L103` reads one higher and
  every one at or below old `:L104` reads two higher: the version line `:L2` reads `:L3` for 1.3.0 and
  `:L3-L4` reads `:L4-L5` for 1.2.0; the list `:L48-L121` reads `:L49-L123`; the dispatcher `:L30-L37`
  reads `:L31-L38`; *Toolchain* `:L48` reads `:L49`; *Secret scan suite* `:L49` reads `:L50`, its
  comment `:L50-L58` reads `:L51-L59`; *Secret scan* `:L59` reads `:L60`; *Build the workspace* `:L60`
  reads `:L61`; *Planted secret suite* `:L67` reads `:L68`, its comment `:L61-L66` reads `:L62-L67` and
  `:L61-L64` reads `:L62-L65`; *Build KA-Reader.app* `:L70` reads `:L71`; *Test gate* `:L71` reads
  `:L72`; the sanitizer step `:L78` reads `:L79`, its comment `:L72-L77` reads `:L73-L78` and `:L75-L77`
  reads `:L76-L78`; *Structure check* `:L79` reads `:L80`; *View check* `:L86` reads `:L87`; the ten
  suite steps `:L80`, `:L82`, `:L85`, `:L87`, `:L97`, `:L101`, `:L103`, `:L104`, `:L108`, `:L109` read
  `:L81`, `:L83`, `:L86`, `:L88`, `:L98`, `:L102`, `:L104`, `:L106`, `:L110`, `:L111`; *Read-only,
  submodule* `:L100` reads `:L101`; *VM refusal suite* `:L107` reads `:L109`; *Launch the built bundle*
  `:L118` reads `:L120`; *Own state* `:L121` reads `:L123`. Each was checked against `grep -n
  '^run_step' checks/gate.sh` at `cd65c02`. A locator inside an earlier dated note stays as history.
  **(3) Outside the row.** Two § 4 C-I3 clauses pin `gate.sh` lines and move with it, taking the same
  "until version N — RN" history clause they already carry: the dispatcher `checks/gate.sh:L30-L37`
  (`docs/SDD.md:L831`) reads `:L31-L38`, and the *Build KA-Reader.app* and *View check* pair
  `checks/gate.sh:L70`, `:L86` (`docs/SDD.md:L895-L896`) reads `:L71`, `:L87`. No other live locator
  into `gate.sh` stands outside the row: `grep -n -o -E 'gate\.sh:L[0-9]+' docs/SDD.md` finds the rest
  inside dated notes or the header's version notes, which stay as history.
  **(4) The lint, by what it does.** `strings.sh`, at version 1.0.0 (`checks/strings.sh:L2-L3`), mode
  100755 — the lint `docs/nfdr.md` QC-53's *verified by* names (`docs/nfdr.md:L1545`), and this row
  names the script and not QC-53's rule: it takes no argument or one, the product root (`:L14-L23`,
  `:L424-L435`); when it runs it reads the *Never* cells of the table that follows the line "Banned in
  the words KA-Reader writes" in `docs/CONTENT.md` (`docs/CONTENT.md:L190`), a gloss in parentheses cut
  and each cell split at its commas, every term plain text and never a pattern (`:L25-L29`,
  `:L62-L115`); it reads the text of string literals alone in every `.swift` file at any depth under
  `ka-reader-mac/Sources/Surfaces/` — identifiers, comments, regex literals, backticked names and the
  code inside an interpolation skipped, escapes cut and never decoded, a hit a whole word in any ASCII
  letter case (`:L31-L41`, `:L119-L420`); it prints one `<path>: QC-53: …` line on stderr per file and
  term pair and exits 1 (`:L484-L494`); it exits 0 with one line counting the files and terms it read,
  and never passes on reading nothing — no `.swift` file, no `docs/CONTENT.md`, no table, no term, or an
  unreadable file is exit 1 with a line naming it (`:L439-L464`, `:L496-L503`); the scan is two awk
  programs held in the file, so nothing is installed, fetched or compiled (`:L43-L49`), and it reaches
  no network.
  **(5) The suite, by what it does.** `test_strings.sh` (*Strings check suite*, `checks/gate.sh:L105`),
  at version 1.0.0 (`checks/tests/test_strings.sh:L2-L4`): fifty cases (`:L55-L106`) that drive the
  real `checks/strings.sh` — never a copy of its logic — against temporary copies of the catalogue and
  of `docs/CONTENT.md` under one `mktemp -d` outside the product tree, removed by a trap on exit
  (`:L30-L33`, `:L1105-L1112`); a banned word planted in a literal must fail and the same word in an
  identifier or a comment must pass; the every-term case reads the table with code that shares nothing
  with the lint and plants each term alone; three cases run the suite against a lint altered to miss a
  finding and require it to turn red (`:L8-L16`); its last case compares `git status --porcelain` and
  the bytes of the product tree before and after (`:L1080-L1099`), so the suite writes nothing into the
  checkout; no `set -e` — each case returns its own status and the runner counts them, exiting 0 only
  when every case ran and passed (`:L26-L28`, `:L1122-L1139`); two variables exist for the altered-lint
  cases and a person sets neither (`:L21-L24`); it launches nothing, sources no helper, and reaches no
  network.
  **(6) The counts.** Thirteen scripts — twelve checks with a `test_<name>.sh` each, and `gate.sh`, the
  runner, with none — and fourteen suites, the twelve paired ones and the two beside them;
  `tests/support/vm_refusal.sh` is still sourced by the same six suites and by no seventh (`grep -n
  'support/vm_refusal.sh' checks/tests/*.sh`); thirteen fixture folders and the six-line
  `fixtures/.gitignore` unchanged; the workflow unchanged at 41 lines, so every `ci.yml` locator
  stands; every locator into any other `checks/` file stands as pinned at `1b32500`.
  **(7) What does not move, said so.** The fetch sentence holds: the new step reaches no network, so
  the gate still reaches it three times in two steps on every run, the sanitizer step on the first run
  alone and no other step, and a machine that cannot reach `github.com` still ends the gate at *Secret
  scan*, now `:L60`. `test_vm_refusal.sh` is unchanged between the pins and reads the suites off the
  disk (`checks/tests/test_vm_refusal.sh:L237`), so `test_strings.sh` is covered with no change to that
  file — the row's "identical at `389adad`, `8235240` and `1b32500`" extends to `cd65c02`. GitHub
  Actions is still disabled on the repository (`gh api repos/eyalgo/ka-reader/actions/permissions`
  prints `enabled: false`, re-read 2026-10-28), so no step's hosted result is read, and this answer did
  not run the gate: the two exit-0 readings in this item's *Where it shows* are the raiser's, taken in a
  disposable clone, and the row keeps saying what is on disk and on which step, not that a step is
  green. `docs/nfdr.md` § 8's step count, § 9's suite enumeration, and QC-53's *verified by* and § 10
  row are that record's own, carried by `docs/architecture_open_issues.md` § 3.1 and not pre-empted
  here. The four checks, the failure paths and what was close to a different verdict:
  `docs/trail/sdd/self_answer-66.md`.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
