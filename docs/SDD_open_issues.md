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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-05 from the SDD's own
> companion template. The config check R-16 describes is now built (`nozoki@4a50e68`), and four SDD
> statements read differently from what was built and measured: the refusal's condition says
> "outside" for values the check does not locate, the `read-only-harness` row counts nine fixture
> folders where there are eleven, R-16's spelling sentence gives one base to every key, and C-I3's
> walk restores four scene fixtures as scenes other than the ones they name. The SDD is Settled, and
> with no companion on disk a `product-sdd` re-run reads it as done and has nothing to act on. Its
> four items are in § 5.

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

### 5.1 The config refusal says the path is outside the folder for values the check refuses without locating them
- **Raised by:** PM — 2026-10-05
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. A message the product ships can state something false.
- **Where it shows:** § 11 R-16 *The refusal and its condition* has the condition say "what it
  observed: the repository's config names a path outside the folder" (`docs/SDD.md:L3021-L3023`).
  *The spellings* then make two kinds of value outside by rule, never located: "A value beginning
  `~/` is outside" (`:L3031`), and a relative `core.excludesfile` or `core.attributesfile`, which
  libgit2 hands on with no base. The adapter implements both as `Placement::Outside`
  (`crates/nozoki-core/src/git_reader/config_scan.rs:L26-L28`, `HOME_PREFIX` at `:L61`). § 6 S-4
  *Reached when* has the Git view say "that the repository's config names a path outside the folder
  they opened" (`:L1830-L1832`), and the shipped sentence says so for every such refusal: "Nozoki
  found {key} set to {path}, outside the folder you opened, …"
  (`nozoki-mac/Sources/Surfaces/GitSentences.swift:L55`). Where the opened folder is under the home
  directory, `~/<path into the folder>` expands to a place inside it, and the sentence's claim is then
  false. The refusal itself still holds, because nothing reads `HOME`. What needs deciding is what
  the condition says it observed for a value the check does not locate. The likely fold: the
  condition, and § 6's clause, say that the config names a path Nozoki does not resolve inside the
  folder, or name the two unlocated forms apart. The words stay `docs/CONTENT.md`'s.
- **If a document has to be written:** none. A change in `SDD.md` § 11 R-16 and § 6 S-4, written by
  `product-sdd`. The CDO's clause in § 6 follows it, settled by `docs/UXD.md` § 6.
- **Answer:** <the owner fills this in>

### 5.2 The `read-only-harness` row counts nine fixture folders, and `checks/fixtures/` now holds eleven
- **Raised by:** PM — 2026-10-05
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. The row says a file that lands in `checks/` after its
  pinned commit "owes this row an item", and this is that item.
- **Where it shows:** § 3, the `read-only-harness` row, "nine fixture folders" measured at
  `nozoki@814a369` (`docs/SDD.md:L347`). `ls checks/fixtures` at `nozoki@fc14574` also lists
  `config-names-outside` and `submodule-config-names-outside`, each with its `.git.tar`. They are R-16's
  fixtures (*The proof*): a repository whose `.git/config` includes a path outside the fixture, and a
  superproject whose submodule's config does the same. The likely fold: the row re-measured at a
  current commit, with the two R-16 fixtures named beside the four root-finding scenes.
- **If a document has to be written:** none. A change in `SDD.md` § 3, written by `product-sdd`.
- **Answer:** <the owner fills this in>

### 5.3 R-16's spelling sentence gives every relative value the directory of its file, and only the include keys take it
- **Raised by:** PM — 2026-10-05
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. A later change that reads *The spellings* as written would
  spell `core.worktree` from the wrong base.
- **Where it shows:** § 11 R-16 *The spellings*, "A relative value is spelled from the directory of the
  file that carries it (`config_file.c:L573-L578`)" (`docs/SDD.md:L3030-L3031`). That holds for
  `include.path` and `includeIf.*.path`. libgit2 resolves `core.worktree` from the Git directory
  (`repository.c:L436`, which the same section cites at `:L3038`), and a relative
  `core.excludesfile` or `core.attributesfile` has no base at all. The adapter spells them that way:
  `config_scan.rs:L26-L30` gives `Placement::Outside` to the relative excludes and attributes files and
  `FromTheFile` to the rest. The same sentence in § 3's `git-reader` row follows. The likely fold: the
  sentence names the include keys, and two sentences beside it give `core.worktree` its Git-directory
  base and the excludes and attributes files their outside-by-rule placement.
- **If a document has to be written:** none. A change in `SDD.md` § 11 R-16, written by `product-sdd`.
- **Answer:** <the owner fills this in>

### 5.4 C-I3's six-fixture walk restores four scene fixtures as scenes other than the ones they name
- **Raised by:** PM — 2026-10-05
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. The walk prints `unchanged` on all six fixtures, but on two
  of the four scenes it does not reach the read the scene exists to exercise, and nothing says whether
  that is enough.
- **Where it shows:** `checks/read-only.sh` unpacks `<fixture>.git.tar` into the fixture folder when
  that folder has no `.git` (`checks/read-only.sh:L73-L76`). The scene archives hold the `.git`
  entries of scenes of their own, which `crates/nozoki-core/tests/root_finding.rs` builds elsewhere
  (§ 3, the `read-only-harness` row, `docs/SDD.md:L347`). `tar -tf checks/fixtures/inside-a-repo.git.tar`
  lists `.git/` at the archive's root, so after the walk `inside-a-repo` is a repository's root, not a
  folder inside one. `tar -tf checks/fixtures/linked-worktree.git.tar` lists
  `linked-worktree/.git` and `main-repo/.git/`, so the walked root has no `.git`, and `read_git` never
  reaches the outside-Git-directory refusal there. C-I3 says "which fixture a command needs is its
  slice's own bar (§ 6)" (`docs/SDD.md:L761-L763`) and names no fixture for these scenes. The choice
  is one of three: the restore builds each scene as `root_finding` does, which changes what the hash
  covers; the four scenes leave the walk, and S-4's bar names the fixtures that exercise `read_git` for
  them; or the walk stays as it is, and the scenes are proved by `root_finding` and `git_state` alone.
  The script's restore contract (`checks/read-only.sh:L22-L24`) and the archives the suites read stand
  on either side of that choice.
- **If a document has to be written:** none. A change in `SDD.md` § 4 C-I3, or § 6 S-4's bar, written
  by `product-sdd`.
- **Answer:** <the owner fills this in>
