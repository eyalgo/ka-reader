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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-06 from the SDD's own
> companion template. The alternates check R-16 describes is now built (`nozoki@66f428d`), and the
> SDD reads differently from what was built and measured in three places: R-16 and the *Open
> Questions* item still say the alternates check and its case are not built and are owed, the
> `read-only-harness` row counts eleven fixture folders where there are twelve, and the alternates
> condition says *outside* for an entry the adapter does not locate, which RN-101 ruled out for the
> config condition's matching case. The SDD is Settled, and with no companion on disk a
> `product-sdd` re-run reads it as done and has nothing to act on. Its three items are in § 5.

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

### 5.1 R-16 and the *Open Questions* item say the alternates check and its case are not built, and both are in the tree
- **Raised by:** PM — 2026-10-06
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. A reader of R-16 is told the alternates read is a stated
  limit with nothing bounding it in the harness, and that is no longer true.
- **Where it shows:** four passages, each measured at `nozoki@2d7692c` or `nozoki@3b6754d`.
  § 11 R-16, the paragraph before *Not covered*: "A third case holds the alternates check … and it
  is still owed" (`docs/SDD.md:L3316-L3319`). *The proof*: "No fixture carries an alternates file
  … Until the case exists this read is a stated limit and not a held property" (`:L3392-L3396`).
  *Until the checks are built*: "The alternates check is not built … No build inside the slice
  bounds the alternates read before that check lands" (`:L3404-L3409`). *Open Questions*, the
  config-named-path item: "the sandbox stays the only bound on the alternates read" (`:L7478-L7479`).
  At `nozoki@66f428d` the check is `check_alternates`
  (`crates/nozoki-core/src/git_reader/libgit2.rs:L303`), called before the open behind `state()` and
  `status()` (`:L114`), on each verified submodule (`:L449`) and on the probe (`:L475`). The fixture
  is `checks/fixtures/alternates-names-outside` with its `.git.tar`, whose
  `.git/objects/info/alternates` is the one line `../../../elsewhere/objects`, and
  `crates/nozoki-core/tests/git_state.rs` holds the case over it. `cargo test --workspace --locked`
  passes, 499 tests, 0 failed. The case runs the adapter in-process. No case runs the check on the
  built bundle. The likely fold: the four passages re-measured at a current commit, with the
  *Open Questions* item left open on its `.gitmodules` case alone.
- **If a document has to be written:** none. A change in `SDD.md` § 11 and *Open Questions*,
  written by `product-sdd`.
- **Answer:** <the owner fills this in>

### 5.2 The `read-only-harness` row counts eleven fixture folders, and `checks/fixtures/` now holds twelve
- **Raised by:** PM — 2026-10-06
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. The row says a file that lands in `checks/` after its
  pinned commit owes this row an item, and this is that item.
- **Where it shows:** § 3, the `read-only-harness` row, "eleven fixture folders" measured at
  `nozoki@2d7692c` (`docs/SDD.md:L354`). `ls checks/fixtures` at `nozoki@66f428d` also lists
  `alternates-names-outside` and `alternates-names-outside.git.tar`, R-16's alternates fixture: a
  repository whose `objects/info/alternates` names an objects directory outside the fixture.
  `git_state.rs` unpacks it and `root_finding.rs` does not. The likely fold: the row re-measured at
  a current commit, with the alternates fixture named beside the two config fixtures.
- **If a document has to be written:** none. A change in `SDD.md` § 3, written by `product-sdd`.
- **Answer:** <the owner fills this in>

### 5.3 The alternates condition says *outside* for an entry the adapter does not locate, which the config condition does not
- **Raised by:** PM — 2026-10-06
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the Git view's sentence for an alternates entry that begins with neither `.`
  nor `/`. Nothing can be written for it that is true in every case until the SDD says what the
  adapter observed there.
- **Where it shows:** R-16 *The spellings follow libgit2's own rule* says such an entry is passed on
  as written, so "the operating system resolves it against the process's working directory and not
  against the folder, and it is refused as outside" (`docs/SDD.md:L3369-L3372`). § 6 S-4 *Reached
  when*, the alternates passage, then has the item say the object store "names a location outside
  the folder they opened" for every refusal (`:L1870-L1876`), and § 3's `git-reader` row gives one
  condition with no observation beside it (`:L345`). For the config check's matching case, a
  relative `core.excludesfile` or `core.attributesfile` that "has no base" (`:L3145-L3147`), the
  same document says the item "does not say the path is outside the folder, because the tool did not
  observe that" (`:L1855-L1863`; RN-101). The two passages disagree on one kind of value. In the
  product: such an entry is classed `Outside` with no location found
  (`crates/nozoki-core/src/git_reader/alternates_scan.rs:L12-L14`, `:L47`); the case for
  `relative/objects` answers the alternates condition (`crates/nozoki-core/tests/git_state.rs:L1781-L1787`);
  and the shipped sentence says "Nozoki found a Git object store that names {path}, outside the
  folder you opened" for it (`nozoki-mac/Sources/Surfaces/GitSentences.swift:L58-L61`). If the
  process's working directory were the opened folder, the entry would lead inside it and the
  sentence would be false. The § 6 passage is the CDO's clause, so its wording follows the CTO's
  answer on what is observed. The likely fold: either the alternates condition gains the config
  condition's second observation for this kind of entry, or R-16 states why *outside* is observed
  here and not for a relative excludes file.
- **If a document has to be written:** none. A change in `SDD.md` § 3, § 6 S-4 and § 11 R-16,
  written by `product-sdd`; the sentence itself is then `docs/CONTENT.md`'s.
- **Answer:** <the owner fills this in>
