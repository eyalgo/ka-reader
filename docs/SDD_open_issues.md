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


> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-04, on the owner's direction
> in an interactive session, from the SDD's own companion template. `development-design` for
> `nozoki · tobiishi · 2026-10-04_the-promise-holds-over-git` halted with `form-two-unwritten`: the
> R-16 fix can only be built in *Open Questions*' second form, and that form must be written into
> the `git-reader` row and § 11 R-16 before it is built. The halt report is the instance's
> `system/projects/nozoki/journey/tobiishi/2026-10-04_the-promise-holds-over-git/halt_report.md`,
> on the instance branch of that name at commit `e414dc2`; its *What the owner is asked* list
> (`:L46-L82`) is the source of the four items here. The SDD is Settled, and with no companion on
> disk a `product-sdd` re-run reads it as done and has nothing to act on. Its four items are in § 5.

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

### 5.1 R-16's second form: which condition does the refusal answer — `RepositoryReadFailed`, or a new one that names the cause?
- **Raised by:** PM — 2026-10-04, on the owner's word, from the `development-design` halt of
  `nozoki · tobiishi · 2026-10-04_the-promise-holds-over-git`
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the change's design, and with it the whole change. The first form does not
  exist in libgit2 (halt report `:L16-L34`), so the second is the only fix for R-16, and the
  change's spec forbids building it unwritten (CP-659, the change's `change_spec.md:L77-L84`, same
  folder and commit as the halt report).
- **Where it shows:** the second form, *Open Questions*, config-named-path item
  (`docs/SDD.md:L6529-L6531`, and `:L6543-L6545`, "adds a condition under which a repository's
  Git state is not shown, which a reader sees"); § 11 R-16 (`:L2974-L2997`); the `git-reader` row
  (`:L336`). The two answers and the parts each one reaches are halt report `:L50-L55`. The code
  today: the adapter answers `RepositoryReadFailed` for a failed open (`crates/nozoki-core/src/git_reader/libgit2.rs:L81-L92`);
  a new condition reaches `folder-model`'s text (`crates/nozoki-core/src/folder_model.rs:L204-L214`),
  `core-bridge` (`crates/nozoki-bridge/src/session.rs:L360-L366`) and
  `nozoki-mac/Sources/Surfaces/GitItem.swift`. Reuse keeps the change `Publishes text: no`; a new
  condition makes it publish text.
- **If a document has to be written:** the `git-reader` row and § 11 R-16 in `SDD.md`, through
  `product-sdd`.
- **Answer:** <the owner fills this in>

### 5.2 What may the second form's check read beyond libgit2: an *inside* include that sits in the working tree?
- **Raised by:** PM — 2026-10-04, on the owner's word, from the same halt
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the same design. CP-659's third bullet — "A repository whose config names no
  outside path answers exactly as it does today" (`change_spec.md:L84`) — means the check follows
  an include that stays inside the folder, and that file can be in the working tree (halt report
  `:L56-L62`).
- **Where it shows:** two records refuse that read as written:
  - the `git-reader` row's *Must not own*, "A file outside Git's own on-disk layout"
    (`docs/SDD.md:L336`, last cell);
  - `docs/nfdr.md` QC-15's list of the reads `git-reader` makes outside libgit2
    (`docs/nfdr.md:L455-L461`), which names no config content.

  *Open Questions*' second form says the adapter reads the config "through `fs-reader`'s check"
  (`docs/SDD.md:L6529-L6530`), and does not say which part does that read.
- **If a document has to be written:** the `git-reader` row in `SDD.md`, through `product-sdd`.
  QC-15 is `docs/nfdr.md`'s, whose owner is the Principal Architect (`docs/nfdr.md:L4`); if the SDD
  widens the reads, QC-15's list goes false and is that seat's to move.
- **Answer:** <the owner fills this in>

### 5.3 Which paths are in R-16's domain beyond its three keys: `includeIf.<condition>.path`, and `core.worktree`?
- **Raised by:** PM — 2026-10-04, on the owner's word, from the same halt
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the same design. The spec leaves the domain open above a floor of three keys
  and names `includeIf` a candidate (CP-658, `change_spec.md:L76`; Gap 6, `:L163`).
- **Where it shows:** R-16 and *Open Questions* name three keys (`docs/SDD.md:L2976-L2978`,
  `:L6525-L6526`). The halt report found two more paths libgit2 follows during the open (`:L63-L70`):
  - `includeIf.<condition>.path` (`libgit2-sys-0.18.8+1.9.7/libgit2/src/libgit2/config_file.c:L826-L829`).
    Matching its condition is a read of its own, so the check would refuse any `includeIf` naming
    an outside path, whatever its condition.
  - `core.worktree`, resolved with `realpath` during the open (`repository.c:L406`, `:L436`), so
    before `open_verified`'s check after the open (`crates/nozoki-core/src/git_reader/libgit2.rs:L86-L92`)
    can refuse it.
- **If a document has to be written:** § 11 R-16 and the `git-reader` row in `SDD.md`, through
  `product-sdd`.
- **Answer:** <the owner fills this in>

### 5.4 Is a submodule's repository in R-16's domain, which `status()` opens?
- **Raised by:** PM — 2026-10-04, on the owner's word, from the same halt
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the same design. CP-658 promises no outside path a repository's own config
  names is read (`change_spec.md:L76`), and does not say which repositories.
- **Where it shows:** the adapter's status read leaves submodules on
  (`crates/nozoki-core/src/git_reader/libgit2.rs:L346-L357`), so libgit2 opens each submodule's
  repository during `status()`, follows its includes, and follows its `.git` file, which can name
  a Git directory outside the folder (halt report `:L72-L82`, with the libgit2 lines). The three
  routes are halt report `:L77-L82`: the check covers every submodule repository status opens;
  status excludes submodules, which changes the answer for any repository that has one; or R-16
  names the top-level-only limit. No upstream document states what the Git view shows for a
  submodule entry: `grep -n -i submodule` over `docs/PRD.md`, `docs/SRS.md` and `docs/fdr.md`
  finds only root finding (`docs/fdr.md:L57`, `:L63`; `docs/SRS.md:L106`, `:L613`, `:L911-L913`).
- **If a document has to be written:** § 11 R-16 and the `git-reader` row in `SDD.md`, through
  `product-sdd`. If excluding submodules changes what a reader sees, whether that reaches the SRS
  or the FDR is for this seat to name.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds these on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
