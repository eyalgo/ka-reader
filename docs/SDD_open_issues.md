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

### 5.1 § 3's `read-only-harness` row says `strings.sh` is in no step of its own and counts a 31-step gate; at `ka-reader@f25fdbb` the lint is a step and the gate has 32
- **Raised by:** PM — 2026-10-28
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-03_no-internal-text-reaches-a-surface`
- **What it blocks:** nothing. The row is pinned to `ka-reader@cd65c02` and is true of that tree. It also says
  that "a step whose whole command is `checks/strings.sh` is not in the list, and by this row's own rule the
  row records one when it lands", and a file landing in `checks/` "owes this row an item" (`docs/SDD.md:L372`).
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L372`). It calls `gate.sh` version 1.4.0, "the
  one ordered list of the gate's 31 steps" (`checks/gate.sh:L49-L123`; `grep -c '^run_step'` prints 32). It says
  "every check script but one run as steps of the gate, and the one, `strings.sh`, is in no step of its own",
  and "No step runs `checks/strings.sh` itself". At `ka-reader@f25fdbb`, `checks/gate.sh` is version 1.5.0
  (`:L2`; 1.4.0 at `:L3`). `grep -c '^run_step' checks/gate.sh` prints 33: 32 steps, `:L50-L129`, and the
  `run_step()` definition at `:L32`. The new step is *Strings check*, `run_step 'Strings check'
  'checks/strings.sh'` (`:L110`), directly after *No-network suite* (`:L105`) and directly before *Strings
  check suite* (`:L111`), with a four-line comment at `:L106-L109` saying why it comes first.
  `git diff --name-status cd65c02 f25fdbb -- checks` lists `M checks/gate.sh` alone, so the counts of
  scripts and suites are unchanged: `ls checks/*.sh | wc -l` prints 13 and `ls checks/tests/*.sh | wc -l`
  prints 14. Every `gate.sh` locator the row pins moved: by one for the new version line, and by five more
  after `:L105`. Measured in a disposable clone at `ka-reader@f25fdbb` on the host: `checks/strings.sh` exited
  0 (`Swift files read: 30; banned terms read: 49`). With a banned word planted in a string literal, the gate
  from *Strings check* onward exited 1 with `gate.sh: step failed: Strings check`. The whole gate exited 0 in
  the macOS guest at `ka-reader@2ea9323`, whose tree `f25fdbb` carries unchanged.
- **If a document has to be written:** none. The fold would re-measure the cell at a named commit: version
  1.5.0, 32 steps, the moved locators, every check script a step of the gate, and *Strings check* named
  directly before *Strings check suite*. It keeps the `cd65c02` reading as a dated note.
- **Answer:** Confirmed with addition (`docs/trail/sdd/self_answer-67.md`). The lean holds — the row re-measured
  at a named commit: `gate.sh` at 1.5.0, 32 steps, the moved locators, every check script a step of
  the gate, *Strings check* named directly before *Strings check suite*, and the `cd65c02` reading
  kept as a dated note — and it stops short of what the fold has to move and say, so it is confirmed
  with the rest measured and added. The pin is `ka-reader@f25fdbb` (2026-10-28), the merge that
  landed the gate's thirty-second step; the tip this answer read, `ka-reader@eba1d83`, holds its
  tree outside `docs/` (`git diff --stat f25fdbb eba1d83 -- . ':!docs'` prints nothing). `git diff
  --name-status cd65c02 f25fdbb -- checks` lists `M checks/gate.sh` alone, and the same range over
  `.github` and `checks/fixtures` prints nothing. What the fold writes, in eight parts: **(1) The
  gate.** `gate.sh` at version 1.5.0 (`checks/gate.sh:L2`; 1.4.0's line now at `:L3`, 1.3.0's at
  `:L4`, 1.2.0's at `:L5-L6`) — the one ordered list of the gate's 32 steps at `:L50-L129` (`grep -c
  '^run_step' checks/gate.sh` prints 33, the 32 calls and the definition), the dispatcher at
  `:L32-L39`. The step added since `cd65c02` is *Strings check* (`:L110`; its comment `:L106-L109`),
  directly after *No-network suite* (`:L105`) and before *Strings check suite* (`:L111`): the whole
  command of `checks/strings.sh`, named below, and what it does is said at that file. The comment
  says why it sits before its suite and never after it: the suite's cases run the real lint over a
  copy of this tree's own catalogue, so a banned word in a literal turns the suite red too, and
  placed after the suite this step would never be the one that names the hit (`:L106-L109`). So a
  banned term in the catalogue now ends the gate at *Strings check*, named by the dispatcher, with
  the lint's own `QC-53` line above it, and *Strings check suite* is reached only over a clean
  catalogue; `grep -c "checks/strings.sh'" checks/gate.sh` prints 1. Three sentences of the row
  written for the `cd65c02` pin go false and are replaced, each keeping its old words in the dated
  note: the workflow sentence's "every check script but one … and the one, `strings.sh`, is in no
  step of its own and reaches the gate through its suite" reads again, unqualified, that every suite
  and every check script named below runs as a step of the gate; "No step runs `checks/strings.sh`
  itself … a step whose whole command is `checks/strings.sh` is not in the list, and by this row's
  own rule the row records one when it lands" is replaced by the step, landed; and the script
  entry's "in no step of its own, reached by the gate through `tests/test_strings.sh`" reads "the
  whole command of the gate's *Strings check* step (`checks/gate.sh:L110`), directly before its
  suite". The suite's sentence that its case `test_unchanged_catalogue_copy_passes`
  (`checks/tests/test_strings.sh:L541-L545`) runs the real lint over a copy of the tree's own
  catalogue stays true and stays, with one word moved: a banned term now turns *Strings check* red
  first, and the suite second. *Strings check suite* keeps "carrying no comment of its own": the
  four-line comment is above *Strings check*. **(2) The line map.** `gate.sh` gained one line at
  `:L2`, the version line, and five at `:L106-L110`, the comment and the step, so every `gate.sh`
  locator this cell pinned from old `:L2` to old `:L104` reads one higher and every one from old
  `:L105` on reads six higher: the version lines — 1.4.0 `:L2` reads `:L3`, 1.3.0 `:L3` reads `:L4`,
  1.2.0 `:L4-L5` reads `:L5-L6`; the list `:L49-L123` reads `:L50-L129`; the dispatcher `:L31-L38`
  reads `:L32-L39`; *Toolchain* `:L49` reads `:L50`; *Secret scan suite* `:L50` reads `:L51`, its
  comment `:L51-L59` reads `:L52-L60`; *Secret scan* `:L60` reads `:L61`; *Build the workspace*
  `:L61` reads `:L62`; *Planted secret suite* `:L68` reads `:L69`, its comment `:L62-L67` reads
  `:L63-L68` and `:L62-L65` reads `:L63-L66`; *Build KA-Reader.app* `:L71` reads `:L72`; *Test gate*
  `:L72` reads `:L73`; the sanitizer step `:L79` reads `:L80`, its comment `:L73-L78` reads
  `:L74-L79` and `:L76-L78` reads `:L77-L79`; *Structure check* `:L80` reads `:L81`; *View check*
  `:L87` reads `:L88`; the twelve paired suite steps `:L50`, `:L81`, `:L83`, `:L86`, `:L88`, `:L98`,
  `:L102`, `:L104`, `:L105`, `:L106`, `:L110`, `:L111` read `:L51`, `:L82`, `:L84`, `:L87`, `:L89`,
  `:L99`, `:L103`, `:L105`, `:L111`, `:L112`, `:L116`, `:L117`; *Read-only, submodule* `:L101` reads
  `:L102`; *VM refusal suite* `:L109` reads `:L115`; *Launch the built bundle* `:L120` reads
  `:L126`; *Own state* `:L123` reads `:L129`, in the `launch.sh`, `own-state-step.sh` and
  `.gitignore` sentences alike. Each was checked against `grep -n '^run_step' checks/gate.sh` at
  `f25fdbb`. A locator inside an earlier dated note stays as history. **(3) Outside the row.** Two §
  4 C-I3 clauses pin `gate.sh` lines and move with it, taking the same "until version N — RN"
  history clause they already carry: the dispatcher `checks/gate.sh:L31-L38` (`docs/SDD.md:L832`)
  reads `:L32-L39`, and the *Build KA-Reader.app* and *View check* pair `checks/gate.sh:L71`, `:L87`
  (`docs/SDD.md:L896`) reads `:L72`, `:L88`; `ci.yml:L28` does not move. No other live locator into
  `gate.sh` stands outside the row: `grep -n -o -E 'gate\.sh:L[0-9]+' docs/SDD.md` finds the rest
  inside dated notes, the header's version notes, or Review Notes RN-115 to RN-120, which are
  history. **(4) The fetch sentence.** *Strings check* joins the steps that fetch nothing: the lint
  reads `docs/CONTENT.md` and the `.swift` files under the catalogue folder and no other file
  (`checks/strings.sh:L14-L23`), two awk programs held in the file (`:L43-L49`), no network — so the
  gate still reaches the network in two steps, three fetches, and a machine that cannot reach
  `github.com` still ends at *Secret scan* (`:L61`), before the new step. **(5) What does not
  move.** Thirteen scripts, fourteen suites, thirteen fixture folders, `fixtures/.gitignore` six
  lines, the workflow 41 lines (`ls checks/*.sh | wc -l` prints 13, `ls checks/tests/*.sh | wc -l`
  14, `ls -d checks/fixtures/*/ | wc -l` 13, `wc -l` 6 and 41); `gate.sh` is the one file in
  `checks/` that changed, so every `ci.yml` locator and every locator into another `checks/` file
  stands as pinned at `cd65c02`, `strings.sh` and `test_strings.sh` at version 1.0.0 among them.
  `test_vm_refusal.sh` is identical at `389adad`, `8235240`, `1b32500`, `cd65c02` and `f25fdbb`: its
  step reader takes top-level `run_step` lines and skips comments (`:L63-L77`), which the new step
  and its comment are, and its CP-803 case reads suites off the disk (`:L237`), which
  `checks/strings.sh` is not, so nothing in it changes. **(6) The platform.** GitHub Actions is
  still disabled: `gh api repos/eyalgo/ka-reader/actions/permissions` prints `enabled: false`,
  re-read at the platform on 2026-10-28 by this answer. The fold does not run the gate and the row
  keeps saying what is on disk and on which step, not that a step is green. The item's own
  measurements are the station's and not the fold's: this answer reproduced one of them — in a
  disposable clone at `f25fdbb`, `checks/strings.sh` exited 0 with `Swift files read: 30; banned
  terms read: 49` — and the planted-word run and the guest's whole-gate pass at `2ea9323` (whose
  tree `f25fdbb` carries unchanged) are the item's, citable through this companion's trail copy and
  never as a hosted result. **(7) The dated note.** The `cd65c02` reading kept in the shape of the
  ones before it: `gate.sh` at 1.4.0, 31 steps, the list at `:L49-L123` and the dispatcher at
  `:L31-L38`, no step running `checks/strings.sh` itself, the lint reaching the gate through its
  suite alone, the "every check script but one" qualification; `git diff --name-status cd65c02
  f25fdbb -- checks` listing `M checks/gate.sh` alone; `f25fdbb` as the merge that landed the gate's
  thirty-second step; the line map of (2); and `docs/nfdr.md` QC-53's *verified by*, § 8's step
  count, § 9's suite enumeration and the § 10 row as that record's own, carried by
  `docs/architecture_open_issues.md` § 3.1 and not pre-empted here. **(8) The failure paths that
  moved a step.** A tree with no `.swift` file under the catalogue folder, no `docs/CONTENT.md`, no
  table under its title or no term in its *Never* column, or an unreadable `.swift` file, now ends
  the gate at *Strings check* with the lint's own line naming which (`checks/strings.sh:L439-L464`,
  `:L496-L503`), before the suite's cases for the same conditions are reached; the row already
  states those exits, and what moves is the step that names them.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
