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
- **Answer:** The condition states what the adapter observed, and for a value the check refuses
  without locating, it does not say *outside*. Every value refused today stays refused.
  The adapter makes two observations under this condition. For a value it spells from a base, it
  observes that the path spells to a location outside the folder. That statement stands, and so
  does its sentence, because `docs/CONTENT.md:L331-L337` fixes how anything that leads outside the
  folder is said. For two forms it locates nothing: a value beginning `~/` under any member key,
  and a relative `core.excludesfile` or `core.attributesfile`
  (`crates/nozoki-core/src/git_reader/config_scan.rs:L26-L28`, `:L175-L186`). There it observes
  the form alone: the config names a path the adapter does not locate. § 11 R-16 *The refusal and
  its condition* states both. The condition carries which of the two was observed, beside the key
  and the path as the config spells them, on the probe, on both reads and for a submodule's
  config, and it crosses SM-2, SM-4 and SM-8 with them. Whether that is a field on the one
  condition or a second condition is the design of the change that builds it. *The spellings*
  reads "A value beginning `~/` is refused without being located" in place of "is outside", and
  gives the reason: libgit2 expands such a value from the home directory (`libgit2-sys
  0.18.8+1.9.7`, `libgit2/src/libgit2/config_file.c:L526-L527`, `attrcache.c:L338-L339`), and
  `git-reader` reads no home directory. Locating the value was not taken. It needs a home
  directory, the crate's own source reads none
  (`grep -rn 'env::var\|HOME' crates/nozoki-core/src` prints only the `~/` prefix at
  `config_scan.rs:L61` and `:L178`), and which directory libgit2 takes as home inside the
  sandboxed bundle was not read. § 6 S-4 *Reached when*, observable half, gains the second
  observation beside the first; that clause is the CDO's and follows from `docs/UXD.md` UX-S3's
  Error cell (`:L241`). The refusal is also stated in § 3's `git-reader` row
  (`docs/SDD.md:L338`), § 3's `core-bridge` row (`:L344`) and *Open Questions* (`:L6871-L6873`),
  and each follows. § 4 C-E4's precedent does not reach these two forms. It lets the outside
  sentence stand for three spellings because telling them from a true outside takes a read
  outside the grant (`:L1051-L1060`), and these two are told apart by the scanner with no read.
  **A stated limit until a change lands:** at `nozoki@fc14574` the shipped sentence says "outside
  the folder you opened" for both forms
  (`nozoki-mac/Sources/Surfaces/GitSentences.swift:L53-L57`), and R-16 names that beside the
  claim. The second sentence's words are `docs/CONTENT.md`'s (`:L62`). Decided together with
  answer 5.3. Reasoning: `docs/trail/sdd/self_answer-48.md` § 5.1.

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
- **Answer:** The row is re-measured and re-pinned at a current commit. `ls checks/fixtures` at
  `nozoki@d3f9e6a` lists eleven folders. The two the row does not count are
  `config-names-outside` and `submodule-config-names-outside`, each with its `<name>.git.tar`.
  They are § 11 R-16's fixtures, and `crates/nozoki-core/tests/git_state.rs` unpacks them
  (`:L1204-L1205`, `:L1220-L1224`), not `root_finding.rs`. The row names them beside the four
  root-finding scenes and says which suite reads them.
  `git diff --name-status 814a369 d3f9e6a -- checks` shows four added paths, the two folders'
  `README.md` files and the two archives, and no other added file, so nothing else joins the
  enumeration. The row's line citations are re-read at the new pin: at `nozoki@d3f9e6a` the
  scenes' unpack is at `root_finding.rs:L57`, and `:L49` unpacks `repo.git.tar`.
  **One addition, from the same landing.** § 11 R-16 still says "No such fixture is in the tree"
  (`docs/SDD.md:L3013-L3015`), that all three cases are owed (`:L3058-L3068`) and that no build
  bounds the config-named read before the check lands (`:L3140-L3148`), and *Open Questions*
  says "What stays open is the proof" (`:L6878`). Two of the three cases now exist:
  `test_no_answer_reads_the_path_the_config_names_outside` (`git_state.rs:L1202`) and
  `test_no_status_read_opens_what_a_submodules_config_includes_outside` (`:L1218`).
  `cargo test --locked -p nozoki-core --test git_state` printed `ok` for both at
  `nozoki@d3f9e6a`. The alternates case is still owed:
  `grep -rl alternates checks crates nozoki-mac/Sources` prints nothing. The fold re-reads those
  four places against the tree and states what is held and what is owed. Whether the *Open
  Questions* item closes is the fold's reading of that item's own bound. Reasoning:
  `docs/trail/sdd/self_answer-48.md` § 5.2.

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
- **Answer:** The sentence names the keys it is true of, and two sentences beside it give the
  other three keys their own base. A relative `include.path` or `includeIf.<condition>.path`
  value is spelled from the directory of the file that carries it (`libgit2-sys 0.18.8+1.9.7`,
  `libgit2/src/libgit2/config_file.c:L573-L578`; a conditional include reaches the same function
  at `:L755`). A relative `core.worktree` value is spelled from the Git directory
  (`repository.c:L436-L437`). A relative `core.excludesfile` or `core.attributesfile` value has
  no base: libgit2 keeps it as written (`attrcache.c:L341-L342`) and loads the excludes file
  with a null base (`ignore.c:L362-L368`). The adapter refuses it without locating it, in the
  words answer 5.1 fixes. The adapter already spells all five keys this way
  (`crates/nozoki-core/src/git_reader/config_scan.rs:L175-L186`, `libgit2.rs:L264-L268`), so no
  code moves. **One case the section does not state, and now states.** libgit2 expands `~/` for
  the include keys and for the excludes and attributes files. It does not for `core.worktree`,
  where it joins the value to the Git directory like any other relative value
  (`repository.c:L436-L437`, `libgit2/src/util/fs_path.c:L387-L391`). The adapter refuses `~/`
  under all five keys (`config_scan.rs:L178`). For `core.worktree` that refuses a value libgit2
  would have resolved under the Git directory, and the refusal is kept. The repository would not
  have opened as the folder's own either way, because the adapter requires the opened working
  tree to be the folder (`libgit2.rs:L116-L123`), and the config condition names the key where
  the conditions that open answers name none. § 3's `git-reader` row needs no edit for this
  item: `grep -n 'spelled from the directory' docs/SDD.md` prints `:L3030` and nothing in the
  row. Decided together with answer 5.1. Reasoning: `docs/trail/sdd/self_answer-48.md` § 5.3.

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
- **Answer:** Three of the four scenes leave the walk, and the fourth stays under the name of
  what the walk builds. § 6 S-4's promise clause reads: `checks/read-only.sh` prints `unchanged`
  on `plain`, on `repo`, and on `submodule`, which the script's restore builds as a superproject
  with its submodule's Git directory inside the folder. The clause names `inside-a-repo`,
  `parent-of-two` and `linked-worktree` as proved by the suites and not by the walk. The script,
  its restore contract and the archives do not change.
  **What the restore builds.** Measured by unpacking each archive into a copy of its fixture in
  a temporary folder, as `checks/read-only.sh:L73-L76` does. `inside-a-repo` has a `.git` folder
  at its root and is a repository's root. `submodule` has a `.git` folder, `.gitmodules` and
  `submodule/.git`, and is the superproject. `linked-worktree` has no `.git` at its root.
  `parent-of-two` has none either, and its two repositories sit one folder further down. None of
  the four is the scene it names.
  **Why three leave.** The walk hashes the fixture folder and nothing above it
  (`checks/read-only.sh:L17-L20`, `:L84`). `inside-a-repo` and `linked-worktree` are defined by a
  Git directory outside the opened folder, so a hash of the folder cannot show that nothing was
  written there. The suites snapshot the whole scene root: `crates/nozoki-core/tests/root_finding.rs:L38-L43`
  around the probe (`:L104-L121` for `inside-a-repo` and `parent-of-two`), and
  `crates/nozoki-core/tests/git_state.rs:L146-L155` around `state` and `status` (`:L719-L738`
  for `linked-worktree` and `submodule`). On `inside-a-repo` and `parent-of-two` the probe
  answers plain, and the walk's `read_git` asks nothing after a plain answer
  (`checks/walk.rs:L5-L7`), so those runs add nothing to the run on `plain`.
  **Why `submodule` stays.** As restored it is the one fixture where the status read meets a
  submodule. Its index holds the gitlink `submodule`, `submodule/.git` reads
  `gitdir: ../.git/modules/submodule`, and `git status --porcelain` on the copy printed
  ` M submodule`. § 11 R-16 puts submodule repositories in the domain, and the hash covers both
  Git directories because both lie inside the folder.
  **§ 4 C-I3 gains a rule** beside "which fixture a command needs is its slice's own bar": a
  walk fixture is a folder the script's in-place restore builds whole, and a scene whose Git
  directory lies outside the opened folder is not one. § 3's `read-only-harness` row says, where
  it lists the four scene archives, that they are laid out for a scene's root and not for the
  fixture folder.
  **The two other routes.** Building each scene in the script was not taken. The `inside-a-repo`
  and `submodule` archives both carry `.git/` at their root (`tar -tf`), so unpacked at the
  fixtures' parent they collide, and avoiding that means a second scene builder beside
  `crates/nozoki-core/tests/common/mod.rs:L121-L133`. Leaving the walk as it is was not taken
  either: it keeps runs whose fixture name says a scene the run does not walk.
  **Not held, and named.** The walk drops the Git answer (`checks/walk.rs:L288-L292`), so no
  case asserts that `read_git` answers root with a status on the restored `submodule`. That it
  does is read from the layout and from `git status`, and was not run through the adapter. CI
  runs the walk on `plain` and `repo` alone (`.github/workflows/ci.yml:L68`, `:L71`). § 4 C-I3
  proves the promises on every build, so the `submodule` run belongs in CI beside those two, and
  S-4 names both limits beside the clause until a change closes them. Whether the changed clause
  is a § 10 entry is the fold's reading of the template's own rule. Reasoning:
  `docs/trail/sdd/self_answer-48.md` § 5.4.
