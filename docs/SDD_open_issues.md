# SDD open issues — Nozoki

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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-07 from the SDD's own
> companion template. The two limits § 6 S-4's promise clause states beside the `submodule` walk are
> closed at `nozoki@b12e48c`: CI walks `submodule` beside `plain` and `repo`, and a case asserts
> `read_git`'s answer on the fixture as the restore builds it. A file has also landed in `checks/`
> after the commit § 3's `read-only-harness` row is pinned to. The SDD is Settled, and with no
> companion on disk a `product-sdd` re-run reads it as done and has nothing to act on. Its two items
> are in § 5.

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

### 5.1 § 6 S-4's promise clause says two limits stand beside the `submodule` walk until a change closes them, and both are closed
- **Raised by:** PM — 2026-10-07
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. A reader of the clause is told that no case asserts
  what `read_git` answers on the restored `submodule`, and that the `submodule` walk is made by hand
  because CI runs it on `plain` and `repo` alone. Neither is true at `nozoki@b12e48c`, so the clause
  under-states what § 4 C-I3's "on every build" now holds.
- **Where it shows:** § 6 `see-git-status` *Reached when*, command half, *the promise clause*:
  "Two limits stand beside the `submodule` run until a change closes them. The walk drops the Git
  answer (`checks/walk.rs:L288-L292`), so no case asserts that `read_git` answers `root` with a
  status on the restored `submodule` … And CI runs the walk on `plain` and `repo` alone
  (`.github/workflows/ci.yml:L67-L71` at `nozoki@2d7692c`), so the `submodule` run is made by hand
  until it joins those two" (`docs/SDD.md:L1981-L1988`). At `nozoki@b12e48c`:
  - CI has the step `Read-only, submodule`, running `checks/read-only.sh checks/fixtures/submodule`
    after `Read-only, repository` and before `Read-only suite` (`.github/workflows/ci.yml:L73-L74`).
  - `crates/nozoki-core/tests/git_state.rs` builds the fixture as the script's in-place restore
    builds it, in a disposable copy, and asserts `read_git`'s whole answer. That answer is
    `root`, HEAD on `main` in the normal state, staged empty, and changed = {`submodule`
    modified, `README.md` untracked} (`:L787`). It also asserts the scene the restore lays down
    (`:L771`) and three layouts in which the answer moves: checked out, without its `.git`
    file, and the archive unpacked above the folder, which answers `GitDirectoryOutside`
    (`:L802`, `:L815`, `:L828`).
  - `checks/own-state.sh` and `checks/fixtures/.gitignore` treat that in-place restore as the
    folder's own. After it, `git status --porcelain -- checks/fixtures` prints nothing and
    condition 2 still names a stray (`checks/tests/test_own_state.sh:L212`, `:L222`, `:L233`).

  Measured on a disposable copy of `nozoki@b12e48c`:
  - `checks/read-only.sh` on `plain`, `repo` and `submodule` each printed `unchanged`.
  - `cargo test --workspace --locked` printed 23 `test result: ok` lines and no `FAILED`.
  - `--test git_state submodule` passed 17 cases.

  The walk itself still drops the Git answer (`checks/walk.rs` is unchanged since `nozoki@275e179`).
  What closes the first limit is the case, not the walk. The CI step's result on the hosted
  `macos-14` runner has not been read: `origin/main` is at `nozoki@799c3d6`. The likely fold is
  the two limits restated as closed, naming the step and the case, with the clause's old words in
  a dated note.
- **If a document has to be written:** none. A change in `SDD.md` § 6 S-4, written by
  `product-sdd`.
- **Answer:** Confirmed with addition. Fold the clause at `nozoki@b12e48c`: both limits are closed. The step `Read-only, submodule` runs `checks/read-only.sh checks/fixtures/submodule` beside the `plain` and `repo` steps (`.github/workflows/ci.yml:L73-L74`), and `crates/nozoki-core/tests/git_state.rs:L787` asserts `read_git`'s whole answer on the fixture as the restore builds it, in a disposable copy — `root`, HEAD on `main`, staged empty, changed = {`submodule` modified, `README.md` untracked} — with the scene at `:L771` and the three layouts in which the answer moves at `:L802`, `:L815` and `:L828`. Three additions the draft does not state. (1) The walk still drops the Git answer (`checks/walk.rs:L288-L292`; `git diff 275e179 b12e48c -- checks/walk.rs` prints nothing), so that sentence stays and only its consequence goes false; and the clause's "read from the restored folder's layout and from `git status --porcelain` on a copy of it … not run through the adapter" goes false too — the case calls `read_git` on the model (`git_state.rs:L734`) — so it goes into the dated note with the clause's old words. (2) The CI half is bounded: the step is in the workflow at `b12e48c`, and its result on the hosted `macos-14` runner is unread — `b12e48c` is on no remote branch and `origin/main` is at `nozoki@799c3d6`, 29 commits behind — so the clause says the step is in the workflow and does not say it is green; a red run there is § 4 C-I3 doing its job, not this clause going false. (3) The pin moves from `nozoki@2d7692c` (`ci.yml:L67-L71`) to `nozoki@b12e48c` (`:L67-L74`); § 4 C-I3's rule for a walk fixture does not move, and `docs/nfdr.md` QC-2's matching tail is `docs/architecture_open_issues.md` § 3.1's, not this fold's. Measured on a disposable copy of `b12e48c`: the three walks printed `unchanged`, and `cargo test --locked -p nozoki-core --test git_state submodule` passed 17 cases. `docs/trail/sdd/self_answer-54.md` § 5.1.

### 5.2 § 3's `read-only-harness` row is pinned at `nozoki@1d5c3cf`, and `checks/fixtures/.gitignore` has landed since
- **Raised by:** PM — 2026-10-07
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. The row says that a file landing in `checks/` after
  its pin "is a re-measurement of this cell and not a contradiction of it, and it owes this row an
  item". This is that item.
- **Where it shows:** § 3, the `read-only-harness` row, *Owns* (`docs/SDD.md:L358`). Its
  enumeration is measured at `nozoki@1d5c3cf` and names no `.gitignore` under `checks/`.
  `git -C <product> diff --stat 1d5c3cf b12e48c -- checks` lists `checks/fixtures/.gitignore`
  (new), `checks/own-state.sh` and `checks/tests/test_own_state.sh`. The new file is harness
  data. It holds two patterns anchored to its folder, `/submodule/.gitmodules` and
  `/submodule/submodule/`, which are the archive's two members that unpack outside `.git`. They
  keep an in-place restore of `submodule` out of git's view, while `checks/own-state.sh` condition 2
  still names anything else there because it walks ignored entries too
  (`checks/fixtures/.gitignore:L1-L6`). The same diff also shows that `own-state.sh`'s condition 2 now passes the
  archive's listing through the implied-folder pass. The row names `own-state.sh` without
  describing its conditions, so no other word in it goes false. The likely fold is the cell
  re-measured at a current commit, naming the file and what it keeps out of git's view.
- **If a document has to be written:** none. A change in `SDD.md` § 3, written by `product-sdd`.
- **Answer:** Confirmed with addition. Re-measure the cell at `nozoki@b12e48c` and re-pin it there: `git diff --stat 1d5c3cf b12e48c -- checks` lists `checks/fixtures/.gitignore` (new, six lines), `checks/own-state.sh` and `checks/tests/test_own_state.sh`, and nothing else. Name the new file under **On disk at that commit**, beside `own-state.sh`: harness data, two patterns anchored to its folder, `/submodule/.gitmodules` and `/submodule/submodule/` — the archive's two members that unpack outside `.git` — so that `own-state.sh`'s condition 3, `git status --porcelain checks/fixtures` prints nothing, holds after the `Read-only, submodule` step's in-place restore (`.github/workflows/ci.yml:L73-L74`, which runs before `Own state` at `:L116`), while condition 2 still names anything else there because it walks ignored entries too (`checks/fixtures/.gitignore:L1-L6`; `checks/tests/test_own_state.sh:L212`, `:L222`, `:L233`). Two additions the draft does not state. (1) The cell's six locators into `crates/nozoki-core/tests/git_state.rs` have moved under it again — the station's 125 inserted lines (`git diff --stat 1d5c3cf b12e48c -- crates/nozoki-core/tests`) all sit above them — and are re-pinned at `b12e48c`: `:L1214-L1215` reads `:L1339-L1340`; `:L1230-L1234` reads `:L1355-L1359`; `:L1767-L1771` reads `:L1892-L1896`; `:L1997-L2001` reads `:L2122-L2126`; `:L2014-L2018` reads `:L2139-L2143`; `:L2682-L2686` reads `:L2807-L2811`; what each names is unchanged, and `root_finding.rs:L55` and `:L63` do not move. (2) The counts do not move: thirteen fixture folders, eight scripts and one suite each — the `.gitignore` is a file and not a folder, and no suite file landed, so `docs/nfdr.md` § 9's suite count is owed nothing. The implied-folder pass in condition 2 changes no word of the row, which names `own-state.sh` and not its conditions. The old words go into a dated note, as the v46 note did for `5331b85` → `1d5c3cf`. `docs/trail/sdd/self_answer-54.md` § 5.2.
