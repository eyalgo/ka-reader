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

### 2.1 § 11 R-16 names `objects/info/alternates` as a third way Git's layout points outside the folder, uncovered until a check holds it
> **No `product-sdd` run wrote this item.** The `companion-self-answer` run that answered § 5 on
> 2026-10-04 raised it, in the CTO's seat, while reading libgit2 for item 5.3. Nothing is drafted
> into `SDD.md`: the draft below is what that run would write. Its reasoning is
> `docs/trail/sdd/self_answer-46.md`, *Raised on this document*.

- **Raised by:** CTO
- **Seat:** cto
- **Drafted into the SDD:** nothing yet. The proposed text: § 11 R-16 and § 4 C-D3's *Not
  covered* sentence name a second uncovered read beside the config-named path. A repository's
  `objects/info/alternates` file names object directories, and libgit2 adds each as an object
  store with no containment check
  (`libgit2-sys-0.18.8+1.9.7/libgit2/src/libgit2/odb.c:L761-L803`; a relative entry is joined to
  the objects directory at `:L794-L797`, and any other entry is taken as written). The adapter's
  check before the open refuses a repository whose alternates file names a location outside the
  folder, with item 5.1's kind of condition. Until a case holds it, R-16 states it as a limit.
- **Rationale:** R-16 calls R-3 "the other way Git's own layout points outside the grant"
  (`docs/SDD.md:L2980-L2981`), and C-D3 names the config-named path as what is not covered
  (`:L989-L991`). Both read as the whole list. The alternates file is a third way, it is not
  config, and item 5.3's rule does not reach it. `grep -n -i alternates docs/SDD.md docs/nfdr.md
  crates/nozoki-core/src/git_reader/libgit2.rs` prints nothing at `nozoki@8b50506`. The source
  was read and not run: no fixture carries an alternates file, and no read of an outside object
  directory has been measured. The same class may hold a link inside the Git directory that
  leads out, such as a linked `config` or `objects`; that was not checked in the source.
- **If overridden:** R-16 and C-D3 stay as they are, and the outside read through an alternates
  file stays unnamed. In the bundle the sandbox still refuses it (§ 4 C-R2). In the harness
  nothing does, and § 4 C-D1's "any read outside the granted folder" is unheld there for a case
  no sentence names. No slice, edge or part moves either way.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

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
- **Answer:** A new condition that names the cause, on both the probe and the reads. Not
  `RepositoryReadFailed`.
  - **What it is.** The adapter refuses before libgit2 opens anything, and the condition says what
    it observed: the repository's config names a path outside the folder. It carries the key and
    the path as the config spells them, as `GitDirectoryOutside` carries its path
    (`crates/nozoki-core/src/git_reader.rs:L194-L197`; the bridge's
    `crates/nozoki-bridge/src/session.rs:L469-L475`). The log line still holds no path
    (`crates/nozoki-core/src/folder_model.rs:L194-L196`).
  - **Why not reuse.** `RepositoryReadFailed` says a read was tried and failed. Here no read is
    tried. `docs/CONTENT.md:L62` holds every message to "what Nozoki observed", and `:L331-L342`
    already fixes how anything outside the folder is said: it is "outside the folder you opened,
    so Nozoki doesn't read it". § 6 S-4 asks that a failed Git item show "what was observed"
    (`docs/SDD.md:L1815-L1816`). § 11 R-3 is the precedent: the outside Git directory has its own
    condition and shows where it lies (`:L2851-L2859`).
  - **The probe.** The probe's open loads the same config
    (`crates/nozoki-core/src/git_reader/libgit2.rs:L500-L508`), so the check runs before it and the
    probe answers a failed root finding with the same cause. The Git view then shows the fault in
    its slot, as `docs/UXD.md` UX-I16 already draws a stopped finding.
  - **What moves in `SDD.md`.** The `git-reader` row's *Owns* gains the check and the condition.
    § 11 R-16's *response* states the refusal and its condition. § 6 S-4's observable half gains
    the case beside the R-3 sentence. The words of the message are not the SDD's: the change
    publishes text, and the Content Editor writes it under `docs/CONTENT.md`'s standing rule.
  - **Cases the answer covers.** A config the adapter cannot read answers the existing
    `GitDirectoryUnreadable`. A config it cannot parse to the end as Git's syntax is refused with
    the existing `RepositoryReadFailed`, because it cannot prove what libgit2 would follow. The
    tree and the panel stand as before (§ 4 C-I1).
  - **Not covered, and named.** The check and libgit2's open are two reads. A config rewritten
    between them is followed by libgit2 unchecked. In the bundle the sandbox still refuses that
    read (§ 4 C-R2); in the harness nothing does. R-16 states this beside the refusal.

  Reasoning: `docs/trail/sdd/self_answer-46.md` § 5.1.

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
- **Answer:** The check reads every config file libgit2 would load for the repository, wherever
  inside the folder it lies, the working tree included. `git-reader` makes the read itself.
  - **Which files.** The repository's `config` in the common directory. `config.worktree` in the
    Git directory, which libgit2 loads where `extensions.worktreeConfig` is set
    (`libgit2-sys-0.18.8+1.9.7/libgit2/src/libgit2/repository.c:L1305-L1308`). And every file one
    of those includes, to libgit2's own depth of ten (`config_file.c:L25`, `:L848`), where the
    included path spells to a location inside the folder.
  - **Why an inside include is followed.** An include that stays inside the folder can itself
    name an outside path. A check that stops at the first file either misses that path or has to
    refuse every repository with an include. `git config --local include.path ../.gitconfig` is
    an ordinary setup, and refusing it would break CP-659's third bullet.
  - **Why it breaks no promise.** A file inside the folder is inside the grant (§ 4 C-D1,
    `docs/SDD.md:L959-L964`). `docs/fdr.md` R-101 (`:L188`) bounds reads to the viewed folder, and
    this read is in it.
  - **Which part reads.** `git-reader`, with the spelling walk it already locates the Git
    directory by (`crates/nozoki-core/src/git_reader/libgit2.rs:L162-L184`), run before any open
    and reading nothing at a position outside the folder. `fs-reader` *Must not own* "Git, in any
    form" (`docs/SDD.md:L335`), so the read is not its. *Open Questions*' "through `fs-reader`'s
    check" names the rule the walk follows, and the fold says so.
  - **The bounds.** Each file is read only for the keys of item 5.3. Each read has a size bound,
    as the adapter's `.git` file read has (`libgit2.rs:L28-L30`). A file over the bound, a depth
    over ten, or a link chain over the walk's bound is refused. Nothing the check reads reaches
    the model, the bridge or the log.
  - **What moves in `SDD.md`.** The `git-reader` row's *Owns* gains these reads. Its *Must not
    own* clause becomes: a file outside Git's own on-disk layout, other than a config file inside
    the folder that the repository's config includes. *Open Questions*' second form names
    `git-reader` as the part that reads.
  - **Downstream.** `docs/nfdr.md` QC-15's list (`:L455-L461`) goes false when this is folded. It
    is the Principal Architect's to re-derive from the new SDD version. No item is opened on the
    NFDR now, because it is true of the SDD as it stands.

  Reasoning: `docs/trail/sdd/self_answer-46.md` § 5.2.

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
- **Answer:** Both are in. R-16's domain is stated as a rule, and the keys are its measurement.
  - **The rule.** Every path libgit2 takes from a config file it loads for the repository, during
    the open, the state read and the status read.
  - **The members, measured at `libgit2-sys 0.18.8+1.9.7`.** `include.path`
    (`config_file.c:L826-L827`). `includeIf.<condition>.path` (`:L828-L830`). `core.worktree`
    (`repository.c:L406`, `:L436`). `core.excludesfile` and `core.attributesfile`
    (`attrcache.c:L424-L430`). A search of the library for other path-valued config reads found
    `init.templatedir` (`repository.c:L2576`) and the mailmap file (`mailmap.c:L370`). Neither is
    on the open, state or status path, so neither is a member.
  - **`includeIf`.** The check refuses any `includeIf` whose path spells outside the folder,
    whatever its condition, and does not evaluate the condition. That over-refuses a repository
    whose condition would not have matched. It is taken because it holds across a libgit2 version
    that adds a condition. One fact in the item is narrower than stated: only `onbranch` reads to
    match, and it reads `HEAD` inside the Git directory (`config_file.c:L661-L690`); the `gitdir`
    conditions compare strings (`:L600-L640`). The answer does not turn on it.
  - **`core.worktree`.** A value that spells outside the folder is refused before the open, with
    item 5.1's condition. libgit2 resolves the value during the open (`repository.c:L436`), which
    is a look at a position outside the grant, and § 4 C-D1 counts that as a read
    (`docs/SDD.md:L962-L964`). A value that spells inside the folder but is not the folder itself
    answers as it does today (`crates/nozoki-core/src/git_reader/libgit2.rs:L86-L92`).
  - **The spellings.** A relative value is spelled from the directory of the file that carries it
    (`config_file.c:L573-L578`). A value beginning `~/` is outside. A link met inside the folder
    is followed by the walk's own rule, and a spelling that leaves the folder is refused without
    a read. Where a key appears more than once, any occurrence that names an outside path refuses.
  - **A version change.** The member list is pinned to the libgit2 version. A `libgit2-sys`
    version change re-measures it, in the lockfile review § 4 C-R6 already requires.
  - **The proof.** The bar stays one fixture and one case for the property (*Open Questions*).
    No key is held by a case of its own. `core.attributesfile`, `includeIf` and `core.worktree`
    have been read in the source and not run (`change_spec.md`, *Verified Claims*), and R-16 says
    so beside the list.
  - **What moves in `SDD.md`.** § 11 R-16 states the rule, the five members and their pin. The
    `git-reader` row and the `core-bridge` row's *Not covered by the switch* sentence name the
    domain by the rule and stop listing three keys. § 4 C-D3's last sentence follows.
  - **Not in this domain.** A path that Git's layout names outside config, such as
    `objects/info/alternates`, is not a config key. It is raised as item 2.1.

  Reasoning: `docs/trail/sdd/self_answer-46.md` § 5.3.

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
- **Answer:** Yes, it is in the domain. The check covers every submodule repository the status
  read opens, and the status read keeps submodules on.
  - **Why it is in.** `docs/fdr.md` R-101 (`:L188`) and § 4 C-D1 bound what the product reads.
    Neither is limited to the top-level repository. The site is in the product: the status read
    sets no `exclude_submodules` (`crates/nozoki-core/src/git_reader/libgit2.rs:L346-L357`), and
    `checks/fixtures/submodule` is a repository with a submodule.
  - **Why not exclude submodules.** With them excluded, a submodule whose commit moved leaves the
    changed list, while `git status` lists it. `docs/SRS.md` FR-12 (`:L204-L207`) and
    `docs/fdr.md` R-65 and R-66 (`:L136-L137`) promise the repository's changed files in Git's own
    categories. That route moves a settled requirement, so it is not this document's to take.
  - **Why not name a top-level-only limit.** It would leave R-101 unheld for a case that occurs.
  - **The rule.** Before the status read, the adapter verifies each submodule repository that
    read can open: each gitlink entry of the index whose folder holds a `.git` entry, and each one
    nested under it, to a stated depth. Two checks run on each, both against the opened folder.
    The Git directory and the common directory are located by spelling (§ 11 R-3). The config is
    checked as items 5.2 and 5.3 state.
  - **What a failure does.** `status()` answers the condition that names what was observed: the
    outside Git directory, or item 5.1's condition. Status is not run with that submodule left
    out, because the list would then read as whole. The whole Git item is then `failed` with
    that condition, as § 3 `GitState` states for a failure of either read
    (`docs/SDD.md:L495-L497`). A depth past the bound is refused.
  - **The proof.** The submodule half is not held by the top-level case. It is held by a case of
    its own: a repository whose submodule's config, or whose submodule's `.git` file, names an
    outside path, and a status read that does not read it. Until that case exists, R-16 states
    the submodule half as a limit and not as a held property. The bound is the one *Open
    Questions* already sets: before `see-git-status` is reached. Which change carries it is not
    the SDD's to say.
  - **Not covered, and named.** The rule rests on which opens libgit2 makes during status
    (`libgit2/src/libgit2/diff_generate.c:L668-L671`, `:L881-L882`; `submodule.c:L1270`,
    `:L1878-L1884`, `:L1658`). These were read and not run. The case above is what shows it.
  - **What moves in `SDD.md`.** § 11 R-16 gains the submodule rule, its failure and its case. The
    `git-reader` row's *Owns* gains the verification before status. § 6 S-4's command half gains
    the case when it lands. `docs/SRS.md` and `docs/fdr.md` do not move: what a reader sees for a
    submodule entry is unchanged.

  Reasoning: `docs/trail/sdd/self_answer-46.md` § 5.4.

**How it closes.** `product-sdd` folds these on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
