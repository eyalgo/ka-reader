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

> **No `product-sdd` run wrote this file.** A `companion-self-answer` run opened it on 2026-10-03
> from the SDD's own companion template, while answering `docs/architecture_open_issues.md` § 3.5 in
> the owner's seat. That item, which the PM raised, found that libgit2's repository open reads Git
> configuration outside the granted folder, and that the rules as written leave no unit that may
> switch the reads off. Where the switch may live is a sentence of this document's § 3, so the change
> is raised here and not in the NFDR, which derives from it. The SDD is Settled at v26, and with no
> companion on disk a `product-sdd` re-run reads it as done and has nothing to act on. Its one item is
> in § 2, the bucket a raised item takes because the run that raises it already holds a lean.
> **Nothing is drafted into the SDD**: this run writes no document, and the slot below is the next
> round's. The run's reasoning is `docs/trail/architecture/self_answer-33.md` § 3.5.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

### 2.1 libgit2's repository open reads the user's global and the system Git config outside the grant, and the rules as written leave no unit that may switch it off
- **Raised by:** the `companion-self-answer` run, 2026-10-03 — not one of the SDD's three seats. It
  answered `docs/architecture_open_issues.md` § 3.5, which the PM raised after `git-reader` landed
  (`nozoki@126ef75`).
- **Seat:** cto
- **Drafted into the SDD:** Nothing yet. The run proposes one reading: keep C-D1 and `docs/fdr.md`
  R-101 as written, and switch the reads off at the Rust-side composition root. Three edits:
  1. **`core-bridge`'s *Owns*** (`SDD.md:L330`) gains a clause: at the composition root, before the
     libgit2 adapter is wired and before any thread can reach libgit2, the one call that sets
     libgit2's configuration search path to empty for the system, global, XDG and programdata
     levels. A repository open then reads the repository's own config, inside the grant, and no
     other.
  2. **The units paragraph's** "Only `git-reader` imports the libgit2 binding" (`SDD.md:L347`) gains
     its one exception: `core-bridge` names the binding for that call and for nothing else.
     `nozoki-core` still "holds no `unsafe`" (`:L336`).
  3. **The evidence**, where C-I3 places it: a bridge test asserting that each of the four levels'
     search path is empty once the composition root has run; and *Open Questions*' second item,
     settled on the built bundle, showing the open answering `root` with those reads gone.
- **Rationale:** The facts, read for this item in the registry copies of the crates the lock
  resolves (`libgit2-sys 0.18.8+1.9.7`, `git2 0.21.0`):
  - The adapter opens with `Repository::open_ext` (`crates/nozoki-core/src/git_reader/libgit2.rs:L52`).
    Every open takes a config snapshot (`libgit2/src/libgit2/repository.c:L997`) that adds the
    global (`:L1318`), XDG (`:L1324`), system (`:L1330`) and programdata (`:L1336`) levels.
  - Under the App Sandbox, libgit2 takes the global level's home from the password entry and not
    from `HOME`, so that it reaches the user's real `~/.gitconfig`
    (`libgit2/src/libgit2/sysdir.c:L347`, `:L356-L359`). The system level is `/etc`
    (`sysdir.c:L282`). Both lie outside the granted folder and outside the container, so C-D1's
    *Violated by* — "any read outside the granted folder and the app's own container"
    (`SDD.md:L854-L857`) — names them. In the harness's in-process cases there is no sandbox, and
    they are real reads of the machine's config.
  - Whether the open survives the sandbox refusing them has not been run. libgit2 treats a config
    file it may not read as absent, "particularly important for sandboxed applications on macOS"
    (`libgit2/src/libgit2/config_file.c:L117-L123`). But a `stat` refused with anything but `ENOENT`
    or `ENOTDIR` fails before that point (`libgit2/src/libgit2/config.c:L143-L147`), and a failed
    snapshot fails the open (`repository.c:L998-L999`). That is *Open Questions*' second item, met
    from a side it does not name.
  - The one switch is `git2::opts::set_search_path`, an `unsafe fn`, because it mutates global state
    with no thread safety (`git2-0.21.0/src/opts.rs:L20-L23`). A level whose search path is empty is
    skipped before any file is touched (`sysdir.c:L559-L560`).
  - The rules leave no unit that may make the call. `nozoki-core` holds no `unsafe` (`SDD.md:L336`),
    and only `git-reader` imports the binding (`:L347`), so the bridge, which holds `unsafe`, may not
    name it.

  **Why the bridge.** It is already the Rust-side composition root, the one unit that holds `unsafe`,
  and the one place the libgit2 adapter is wired to the Git port (`SDD.md:L330`). Process-global
  setup made once before first use is a composition root's job. Keeping `unsafe` out of `nozoki-core`
  keeps the property the units paragraph is built on: the harness links a core with no `unsafe`.

  **Not covered, and named.** (1) libgit2 still reads `HOME`, `XDG_CONFIG_HOME` and
  `APP_SANDBOX_CONTAINER_ID` at init, because every level is guessed then (`sysdir.c:L458-L459`) and
  `set_search_path` initialises the library first (`opts.rs:L27`). Those reads open no file, and they
  are raised against the NFDR's boundary set at `docs/architecture_open_issues.md` § 2.2. (2) The call
  lives in the bridge, so `nozoki-core`'s own in-process cases still read the machine's config. An
  answer there that changes with a developer's config is a fault of the test environment, not
  product behaviour, and the bundle run is what proves the product. (3) The call is not thread-safe,
  which its place at startup, before the adapter is wired, meets.
- **If overridden:** Three other readings, and what each moves.
  - **`unsafe` in `git-reader` for this one call:** moves the units paragraph's "holds no `unsafe`"
    (`:L336`) and NFDR QC-9, and the harness would then link a core that holds `unsafe`.
  - **Accept the reads and state them:** lowers `docs/fdr.md` R-101, "The product reads nothing
    outside the viewed folder except its own data location on the machine" (`docs/fdr.md:L188`),
    and C-D1's *Violated by*. That is a product promise and the owner's to lower, not this seat's.
    It also leaves the open's survival under the sandbox to be proved, per `config.c:L143-L147`
    above.
  - **Patch the vendored build:** the cost § 11 R-15 already names for the transports, carried a
    second time.

  Downstream, NFDR QC-9, QC-11, QC-13, QC-17 and QC-35 re-derive from whichever reading is taken.
  `docs/architecture_open_issues.md` § 2.1 holds the NFDR open meanwhile.
- **Confirm or override:** confirm, with six additions the fold carries. The reading is taken:
  C-D1 and `docs/fdr.md` R-101 stand as written, and `core-bridge`, the Rust-side composition root,
  empties the system, global, XDG and programdata search paths before the libgit2 adapter is wired.
  1. **The clause does not say "and no other".** The switch stops the four machine levels. It does
     not stop a path the repository's own config names: libgit2 follows `include.path`
     (`libgit2/src/libgit2/config_file.c:L564`), `core.excludesfile` (`ignore.c:L362-L364`) and
     `core.attributesfile` (`attr.c:L413`), and none passes `fs-reader`'s containment check. The
     fold names these as an uncovered case where it writes edit 1 and as a risk in § 11 beside
     R-3. In the bundle the sandbox is their only bound; in the in-process harness nothing bounds
     them. Closing it is not decided here.
  2. **It fails closed, and runs once.** `set_search_path` returns a `Result`
     (`git2-0.21.0/src/opts.rs:L23`). If any of the four calls fails, the adapter is not wired and
     the Git item is `failed`; a repository is never opened with the reads on. The four calls run
     once per process, and a second arrival at the composition root repeats nothing.
  3. **The bridge's manifest names the binding with its default features off**, as
     `crates/nozoki-core/Cargo.toml:L9` does. A `git2` line with defaults on would turn HTTPS and
     SSH on for the whole build through feature unification, against § 4 C-R6.
  4. **Every statement of the import rule moves together.** Edit 2 names `SDD.md:L347`. The same
     rule is § 6 S-4's command clause, "the libgit2 import in `git-reader` alone" (`:L1698`), and
     it takes the same one exception: the bridge names the binding in the composition root's
     search-path call and its test, and nowhere else.
  5. **What the reader sees changes in two places, and the fold says so in `git-reader`'s row.**
     With the global and XDG levels off, the user's global ignore file is not applied
     (`attrcache.c:L345`), so a file it hides from `git status` is listed here as untracked.
     And a repository not owned by the current user fails to open, because the `safe.directory`
     entry that would allow it is read from those same levels (`repository.c:L629-L634`,
     `:L1172-L1173`); it is a `failed` Git item. Both follow from R-101 as it stands. Honouring
     either would mean reading outside the grant, which is the owner's to allow.
  6. **§ 4 C-I3 names what the evidence does not reach.** The bridge test proves the four paths
     are empty; it observes no read. `nozoki-core`'s in-process Git suites run with the reads on,
     so an answer there can differ from the bundle's on a machine with a global ignore file. This
     joins C-I3's "things no check holds". How those suites are isolated is the design of the
     change that builds the switch.

  The reasoning is `docs/trail/sdd/self_answer-34.md` § 2.1.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

None.
