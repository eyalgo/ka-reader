# Architecture open issues — Nozoki

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the SRS, the SDD
> and the FDR.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-architecture`. It folds your answers into the records and drops the resolved items.
> When nothing is left open, `product-architecture` **deletes this file**: no file = the records are
> done.
>
> Your answers are never thrown away. Each time the Principal Architect folds them in, it first copies
> this file whole to `docs/trail/architecture/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 is raised, not asked.** These records bind every later change, so the seats that live under
> them find gaps the authoring run could not. § 3 is where such a seat says so, against both records
> — an ADR's binding and an NFDR obligation reach the same file.

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-05 from the records'
> own companion template. From `nozoki@4a50e68`, `checks/structure.sh` holds QC-11's libgit2-import
> clause over the whole shipped scope, and `git-reader` reads Git's config files itself before libgit2
> opens. QC-11's *verified by* tail still says the clause is held by review, and QC-15's list of
> `git-reader`'s reads outside libgit2 names no config read. The records are Settled, and with no
> companion on disk a `product-architecture` re-run reads them as done and has nothing to act on. Its
> two items are in § 3.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 QC-6, QC-30 and QC-35 still call config-named paths uncovered, though SDD v39 – v41 now has `git-reader` refuse them before libgit2 opens
> **No `product-architecture` run wrote this item.** The Principal Architect's `companion-self-answer`
> run added it on 2026-10-06 while answering § 3 of this file. To answer § 3.2 it read
> `docs/SDD.md` § 4 C-D3, § 11 R-16 and *Open Questions* at v41. These entries were last
> re-derived on SDD v33 (`Version:` 41), and those SDD sections have moved since then. The
> skill files an item it raises under *choices to confirm*, with its slot left for the next round.
- **Lands in:** `nfdr.md` QC-6, QC-30 and QC-35
- **Drafted into the records:** nothing. The run that raised this item writes no record. It
  proposes a re-derivation of three sentences on SDD v41. QC-6's *Not covered* sentence
  (`docs/nfdr.md:L255-L268`) and QC-35's uncovered case (1) (`:L953-L958`) would state:
  - `git-reader` refuses a repository whose config names a path that spells outside the folder,
    or a path it does not locate, before libgit2 opens anything, under § 11 R-16's rule;
  - the domain is that rule, which § 11 R-16 measures as five keys, not the three these entries
    list;
  - the *Open Questions* item stays open only on the alternates case, the one case whose proof is
    not built.
  QC-30's pointer at the same read (`:L820-L822`) would follow.
- **Rationale:** something upstream moved, and these entries have not seen it.
  - QC-6 and QC-35 say that libgit2 follows such a path "with no containment check", that the
    sandbox alone bounds it in the bundle, and that the open question closes it. They list three
    keys.
  - SDD § 4 C-D3 now says `git-reader` refuses such a repository before libgit2 opens anything
    (`docs/SDD.md:L1009-L1016`).
  - § 11 R-16 measures five keys (`:L3041-L3047`).
  - The *Open Questions* item records the second form as the one found, with the top-level fixture
    and the submodule-config fixture and their cases in the tree. It stays open only on the
    alternates case (`:L7138-L7160`).
  - The check is built: `check_config` and `verify_submodules`
    (`crates/nozoki-core/src/git_reader/libgit2.rs:L191`, `:L285`), merged at `nozoki@fc14574`.
  Two architects reading SDD v41 would write the same sentences, as RN-51 found for the SDD v32
  bound. One thing stays uncovered and should be named as uncovered, not as covered: the
  `objects/info/alternates` read. C-D3 names it as a second read that libgit2 takes with no
  containment check. The refusal for it is stated but not built (§ 3.2's answer). This item asks
  the entries to say that, not to list the read as owned.
- **If overridden:** QC-6, QC-30 and QC-35 keep calling a built refusal uncovered. A reviewer at
  `development-design` then reads the config-named path as open with nothing bounding it outside
  the sandbox, while the SDD says the adapter refuses it. Their three-key list also leaves out
  `includeIf.<condition>.path` and `core.worktree`, which R-16's measurement names.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">


## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-11's tail says the libgit2-import bound is review, and the script now holds it by file
- **Raised by:** PM — 2026-10-05
- **Which record:** `nfdr.md` QC-11
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. A reviewer at `development-design` is told to hold by hand
  a rule the script already holds, and the one part the script does not hold is not named.
- **Where it shows:** QC-11's *verified by* says "The exception's bound — the switch and its test, and
  nowhere else in the bridge — is review at `development-design`: the script does not hold the import
  rule outside the three units' files it reads (`checks/structure.sh:L257-L258` at `nozoki@392177d`)",
  and that the bound "stays review until a change adds it" (`docs/nfdr.md:L357-L362`). That change has
  landed. The script's header now carries the clause over "every file of the shipped scope in any
  crate", with two exemptions, every file of the `git_reader` unit and
  `crates/nozoki-bridge/src/machine_config.rs` (`checks/structure.sh:L130-L142`, the exempting `case`
  at `:L1186`). At `nozoki@fc14574` it exits 0: "16 Rust files in 2 crates read — nothing found". The
  switch's test lies under `tests/`, outside the shipped scope. What the script holds is a file, not
  the switch: a second `git2` use added inside `machine_config.rs` draws no finding, while QC-11
  allows the binding "in the composition root's config search-path switch and that switch's test,
  and nowhere else" (`docs/nfdr.md:L355-L356`). The likely fold: the tail names the script as the
  check for the clause over the shipped scope, and keeps review only for the bound inside
  `machine_config.rs`, which is that file being the switch alone.
- **If a document has to be written:** none. A change in `nfdr.md` QC-11, written by
  `product-architecture`.
- **Answer:** confirm the likely fold, with one addition. QC-11's *verified by* names
  `checks/structure.sh` as the check that holds the libgit2-binding clause across the whole shipped
  scope of every crate. That is the header's QC-11 *libgit2 binding* row
  (`checks/structure.sh:L130-L142`, with the exempting `case` at `:L1186`), on `main` since
  `nozoki@fc14574`. At `nozoki@b25b407` the script exits 0 with "16 Rust files in 2 crates read —
  nothing found". Review at `development-design` still holds two parts of the exception's bound,
  not one:
  (1) inside `crates/nozoki-bridge/src/machine_config.rs`, the binding is named only for the switch.
  The script exempts the whole file, and that file also holds the adapter's constructor
  (`:L138-L139`).
  (2) under `crates/nozoki-bridge/tests/`, the binding is named only in the switch's own test. The
  script reads `tests/` for the layer-5 rule alone (`checks/structure.sh:L41-L42`), so a second
  bridge test that names `git2` draws no finding.
  The fold re-measures the sentence that names the bridge files that name `git2` at its own commit.
  At `nozoki@b25b407` they are still `machine_config.rs`, `tests/search_path.rs` and the manifest.
  It keeps "for the clauses its header holds", because the header still lists QC-11's clauses whose
  subject is `git-reader`, `watcher` or `markdown-renderer` as not held (`:L270`). Reasoning:
  `docs/trail/architecture/self_answer-41.md` § 3.1.

### 3.2 QC-15's list of `git-reader`'s reads outside libgit2 names no config read
- **Raised by:** PM — 2026-10-05
- **Which record:** `nfdr.md` QC-15
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. QC-15 fixes I/O ownership by list, and a read the list
  does not name reads as a read nobody owns.
- **Where it shows:** QC-15 gives `git-reader` "reads bounded to the opened folder": the folder's own
  metadata, its `.git` entry's metadata, an entry inside a `.git` folder, a `.git` file's content, the
  positions along the spelled paths, and the `commondir` file (`docs/nfdr.md:L455-L461`). The adapter
  now also reads, before libgit2 opens: the repository's `config`; `config.worktree` where
  `extensions.worktreeConfig` is set; each config file those include that spells inside the folder,
  the working tree included; and, before the status read, the same files and the `.git` entry,
  `.git` file, spelled positions and `commondir` of each submodule it verifies
  (`crates/nozoki-core/src/git_reader/libgit2.rs:L190-L250`, `:L289-L320`). `docs/SDD.md` § 3's
  `git-reader` row already owns these reads (`docs/SDD.md:L338`, RN-99). Its alternates read (RN-100) is
  not built yet. The likely fold: QC-15's list gains the config reads and the submodule reads in those
  terms, and, once built, the alternates file.
- **If a document has to be written:** none. A change in `nfdr.md` QC-15, written by
  `product-architecture`.
- **Answer:** confirm the likely fold for the reads SDD § 3's `git-reader` row owns, with two
  additions. QC-15's list, in the row's terms (`docs/SDD.md:L338`), gains:
  - the config check's reads before libgit2 opens: the `config` in the common directory;
    `config.worktree` in the Git directory where `extensions.worktreeConfig` is set; and each file
    those include whose path spells to a location inside the folder, the working tree included;
  - the metadata, and a link's own text, at each position inside the folder along the spelled path
    of every config value the check locates, not only along the paths to the Git directory and the
    common directory. `follow` spells each value with the same walk
    (`crates/nozoki-core/src/git_reader/libgit2.rs:L252-L280` at `nozoki@b25b407`), which the
    item's text does not name;
  - for each submodule verified before the status read, its `.git` entry's metadata, the location
    reads above for its Git directory and common directory, and its config check
    (`:L285-L340`).
  Addition one: the alternates read (SDD RN-100) is not built. `grep -n alternates` over the
  adapter prints nothing at `nozoki@b25b407`. So it is not until it occurs, and the change that
  builds it owes QC-15 that read, through review at `development-design`.
  Addition two: the adapter also reads `.gitmodules` in the working tree of the repository and of
  each submodule, and follows its include keys (`:L292-L303`, `:L238`), because libgit2 loads that
  file as a config file during the status read. SDD § 3's row does not own that read, so QC-15
  does not name it until the SDD does. That change is carried at `docs/SDD_open_issues.md` § 2.1
  (`nozoki@ed6e634`). Reasoning: `docs/trail/architecture/self_answer-41.md` § 3.2.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
