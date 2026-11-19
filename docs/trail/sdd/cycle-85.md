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

### 5.1 § 3's `read-only-harness` row, pinned at `2777e89`, no longer enumerates the tree, and its red gate has gone green
- **Raised by:** PM — 2026-11-19
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; the row says a file landing in `checks/` after its pin "owes this row an item" (`docs/SDD.md:L548`), and two have. The row also says the gate on `main` ends red at *README picture check suite* "until the picture lands and the step joins"; both have happened, so that sentence now describes a state the main line has left.
- **Where it shows:** `git diff --name-status 2777e89 66f28cb -- checks .github` lists `checks/gate.sh` and `checks/tests/test_readme.sh` changed, nothing added, nothing under `.github/`. `checks/gate.sh` is Version 1.25.0 with 62 `run_step` lines (`grep -c '^run_step ' checks/gate.sh` → `62`; 61 at the pin): *README picture check*, the whole command of `checks/readme-picture.sh`, is a fatal step at `:L200`, directly before *README picture check suite* at `:L201`, under the comment above them that now says the check runs first so a stale or missing picture is named by its own step; *README picture capture suite* moves to `:L216`. `checks/tests/test_readme.sh` is Version 1.2.5, its pinned gate list gaining the matching line at `:L560`, so its locators from old `:L560` read one higher, and the file has 861 lines. `readme-picture.sh` therefore stops being a check that reaches the gate through its suite alone. The picture and its record landed outside `checks/`, at `docs/readme/shell.png` and `docs/readme/shell.record`. On a disposable clone at `66f28cb`, `checks/readme-picture.sh` exits 0 ("the README's opening shows docs/readme/shell.png, and it matches docs/readme/shell.record at version 0.1.0") and `checks/tests/test_readme_picture.sh` passes 16 of 16. Scripts stay thirty and suites thirty-two (`ls checks/*.sh | wc -l` → `30`; `git ls-tree --name-only main checks/tests/ | grep -c '/test_.*\.sh$'` → `32`). § 4 C-I3's three gate locators and § 6 S-7's one, read at the pin, may move with the four inserted lines. Re-measure at the current main line.
- **If a document has to be written:** none.
- **Answer:** Confirmed with addition. The item's reading is taken: § 3's `read-only-harness` row is re-measured from its own pin, `2777e89`, over `git diff --name-status 2777e89 66f28cb -- checks .github` — two entries, both `M`, nothing added, nothing under `.github/` — and re-pinned at `ka-reader@66f28cb` (2026-11-19), the merge that made *README picture check* a fatal gate step, with the `2777e89` reading kept as a dated note in the form every fold of this row has used; the fold re-verifies at its own tip that the tree outside `docs/` is `66f28cb`'s (`git diff --stat 66f28cb f3aa01f -- . ':!docs'` prints nothing today). No document is written. The additions, each measured at `f3aa01f`: (a) the shift is three lines net, not four — `gate.sh` gained four lines and lost one (`git diff --stat 2777e89 66f28cb -- checks/gate.sh`: `5 ++++-`): the 1.25.0 version line at `:L2`, the comment's old last line `:L197` rewritten as two (`:L198-L199`), and the step at `:L200` — so every `gate.sh` locator the row pinned from old `:L2` to old `:L196` reads one higher, old `:L197` reads `:L198-L199`, and every one from old `:L198` reads three higher: the version lines `:L4` to `:L27-L28` read `:L5` to `:L28-L29`, behind the new one; the list `:L77-L225` reads `:L78-L228`; the dispatcher `:L54-L66` reads `:L55-L67`, its subshell `:L57-L62` reads `:L58-L63` and its case `:L58-L60` reads `:L59-L61`; *Toolchain* `:L77` reads `:L78`; *Secret scan* `:L88` reads `:L89`; *Build KA-Reader.app* `:L99` reads `:L100`; *Git view memory bound* `:L106` reads `:L107`; *View check* `:L134` reads `:L135`; *README check* `:L178` reads `:L179`; *Git beta catalogue check* `:L180` reads `:L181`; the release block `:L187-L192` reads `:L188-L193` and its comment `:L182-L186` reads `:L183-L187`; the comment above the picture steps `:L193-L197` reads `:L194-L199`, six lines where there were five; *README picture check* is new at `:L200`, the whole command of `checks/readme-picture.sh`; *README picture check suite* `:L198` reads `:L201`; *Own state suite* `:L199` reads `:L202`; the comment above the launch-free suites `:L200-L206` reads `:L203-L209`; *VM refusal suite* `:L207` reads `:L210`; *Launch step suite* `:L208` reads `:L211`; *Own state step suite* `:L209` reads `:L212`; *Tree scene helper suite* `:L210` reads `:L213`; the two Git beta suites `:L211-L212` read `:L214-L215`; *README picture capture suite* `:L213` reads `:L216`; the log comment `:L214-L221` reads `:L217-L224`; *Launch the built bundle* `:L222` reads `:L225`; *Own state* `:L225` reads `:L228`; 62 `run_step` calls from `:L78` to `:L228` (`grep -c '^run_step '`), 228 lines. § 4 C-I3's three gate locators (`:L54-L66`, `:L99`, `:L134`) and § 6 S-7's one (`:L88`) read `:L55-L67`, `:L100`, `:L135` and `:L89`, each keeping its `2777e89` reading as a dated note, as RN-176 did for `21f611f`'s. (b) `test_readme.sh` is 1.2.5, 861 lines, thirty-nine cases unchanged (`grep -c '^test_[a-z_]*()'` prints 39 at both pins): one line at `:L2` and one at `:L560`, the pinned list's *README picture check*, so its locators read one higher from old `:L2` to old `:L558` and two higher from old `:L559` — *Test gate* `:L517` reads `:L518`, the two Git view memory steps `:L518-L519` read `:L519-L520`, the icon steps `:L526-L528` read `:L527-L529`, *README picture check suite* `:L559` reads `:L561`, the Git beta pair `:L565-L566` reads `:L567-L568`, *README picture capture suite* `:L567` reads `:L569`, and the `git-beta-inputs.sh` entry's `:L595`, `:L804` read `:L597`, `:L806`. (c) The gate's red end is a dated note now: the row's "until *README picture check* joins the list, every machine that reaches it ends the gate at *README picture check suite*" and "that suite ends 15 of 16" were true at `2777e89`; on a disposable clone at `66f28cb`, made with `mktemp -d` and `git clone`, run in a subshell and removed from outside, `checks/readme-picture.sh` exits 0 printing the line the item quotes and `checks/tests/test_readme_picture.sh` prints `16 of 16 passed`. So `readme-picture.sh` is a check whose own fatal step sits directly before its suite, as every other paired check's does; `test_readme_picture.sh` stops being "the first whose check's own step is not yet in the list" (dated); and the count of check scripts run by no gate step reads nine where it read ten, `readme-picture.sh` having left the set — `git-beta-scene.sh`, `git-beta-walk.sh`, `readme-capture.sh`, `release-absent.sh`, `release-pack.sh`, `release-sums.sh`, `release-version.sh`, `tree-scene.sh` and `tree-walk.sh`, by the row's own count, which excludes `gate.sh` and `own-state.sh`. The comment's new reason — the check runs first so a stale or missing picture is named by its own step, as with *Strings check* — is the row's to hold as it holds the others. (d) The picture's landing, the other case the row named as pending, has occurred: `docs/readme/shell.png` and `docs/readme/shell.record` exist since `db188e8` (2026-11-18), the record four lines — `picture: docs/readme/shell.png`, `version: 0.1.0`, a commit and a sha256 — so "`docs/readme/` does not exist at the pin" is dated; `README.md` gained its image paragraph at `:L5-L6`, so the row's known-gaps markers `README.md:L35`, `:L41` read `:L37`, `:L43`, as the row said they would. (e) What does not move: thirty scripts, thirty-two suites, nineteen reading the selector, eight sourcing the refusal helper, seventeen fixture folders, five folders under `checks/`, `.github/` byte for byte; `CHANGELOG.md` gained one line at `6bb35aa`, outside the row's unit. (f) The platform, re-read live and read-only on 2026-11-19: `<owner>/<repository>-dev` lists ten runs where the row names eight — the ninth at `db188e8` (`main`) and the tenth at `6bb35aa` (the change branch), both 2026-11-19, both `failure` with *Test gate* the one failed step of the one job; `2777e89` and `db188e8` are now on `origin/main` (`git branch -r --contains`), so the ninth run is the first hosted run of the tree this row enumerates at `2777e89` (`git diff --stat 2777e89 db188e8 -- . ':!docs'` is `README.md` alone); `66f28cb` and `f3aa01f` are on no remote branch, but the tenth run read `6bb35aa`, whose tree is byte for byte `66f28cb`'s (`git diff --stat 6bb35aa 66f28cb` prints nothing), so the new pin's tree has one hosted result, red at *Test gate*, before the picture steps are reached; `release.yml` has run on neither repository and the public one's last run is October's. (g) The current note's pointers to `docs/architecture_open_issues.md` §§ 3.1–3.4 name a file that no longer exists: those four items were answered and folded as NFDR v102, so the fold re-points them to `docs/trail/architecture/cycle-93.md` §§ 3.1–3.4 and `docs/nfdr.md` RN-112; earlier dated notes keep theirs. Not raised elsewhere: `docs/nfdr.md` § 9's suites bullet pins at `3463d17`, its count is unchanged at thirty-two and it names no check step, so no fact in it is false; no slice's command half moves — § 6 S-7's observable half already says the README's screenshot is the shell of the release, from the repository, which the check holds. The pin rule stands unchanged: a file landing in `checks/` or `.github/workflows/` after `66f28cb` is a re-measurement of the cell and owes this row an item. Reasoning in `docs/trail/sdd/self_answer-100.md`.
