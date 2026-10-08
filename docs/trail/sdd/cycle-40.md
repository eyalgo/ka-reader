
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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-07 from the SDD's own
> companion template. The alternates condition's second observation is now built (`ka-reader@0909fe0`),
> and the SDD still reads it as unbuilt in four places: § 3's `git-reader` row, § 6 S-4 and § 11 R-16
> call the one condition a known defect until a change lands, and R-16 leaves open whether the
> observation is a field or a second condition. The SDD is Settled, and with no companion on disk a
> `product-sdd` re-run reads it as done and has nothing to act on. Its two items are in § 5.

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

### 5.1 § 3, § 6 S-4 and § 11 R-16 call the alternates condition's one condition a known defect, and both observations are built
- **Raised by:** PM — 2026-10-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. A reader of § 3, S-4 or R-16 is told that the adapter
  answers one condition for an alternates entry it does not locate, and that the Git view says
  *outside* for it. That is no longer true.
- **Where it shows:** three passages, each measured at `ka-reader@66f428d`. § 3, the `git-reader`
  row, "The alternates check": "one condition for both observations, which § 11 R-16 states as a
  known defect until a change lands" (`docs/SDD.md:L347`). § 6 S-4 *Reached when*, observable
  half, the second alternates passage: "At `ka-reader@66f428d` the shipped sentence says "outside the
  folder you opened" for both observations … which § 11 R-16 names as a known defect until a change
  lands" (`:L1895-L1898`). § 11 R-16 "A third way out", *The condition*, *A known defect, until a
  change lands*: the adapter answers one condition for both observations, the `relative/objects`
  case asserts it, and the shipped sentence and the model's phrase say *outside* (`:L3432-L3444`).
  At `ka-reader@0909fe0` the adapter answers `ObjectStoreNotLocated` for an entry beginning with
  neither `.` nor `/`, before anything is spelled
  (`crates/ka-reader-core/src/git_reader/libgit2.rs:L350-L353`), and keeps `ObjectStoreNamesOutside`
  for an entry spelled outside (`:L358-L360`). The probe maps it at `:L495-L496`. The log line has
  its own phrase, "the object store names a location the reader does not locate"
  (`crates/ka-reader-core/src/folder_model.rs:L210-L211`, `:L230-L231`, `:L252-L253`). The wire value
  is `object_store_not_located` (`crates/ka-reader-bridge/src/session.rs:L379`, `:L437`) and the
  shell decodes it (`ka-reader-mac/Sources/Shell/BridgePayload.swift:L388-L389`). The Git view draws
  "KA-Reader found a Git object store that names {path}. KA-Reader doesn't work out where that path
  leads, so it doesn't read the folder's Git status. The file tree and the reading panel are
  unaffected." (`ka-reader-mac/Sources/Surfaces/GitSentences.swift:L68-L72`), and
  `grep -i -c outside` over those lines prints `0`. The outside sentence is unchanged (`:L63-L67`).
  The `relative/objects` case now asserts the second condition
  (`crates/ka-reader-core/tests/git_state.rs:L2046`), and a submodule's not-located entry fails the
  status read alone (`:L2453`). `cargo test --workspace --locked` passes (517 tests, 0 failed), and
  so does `swift test --package-path ka-reader-mac` (140 tests, 0 failures). The likely fold: the three
  passages re-measured at a current commit, with the known-defect sentences replaced by what is
  built, in the form of *The refusal and its condition*, *Built, and the cases that hold it*
  (`:L3165`).
- **If a document has to be written:** none. A change in `SDD.md` § 3, § 6 S-4 and § 11 R-16,
  written by `product-sdd`.
- **Answer:** Confirmed, with two additions. The three passages are re-measured at a current
  commit, and each known-defect sentence is replaced by what is built, in the form of *Built, and
  the cases that hold it* (`docs/SDD.md:L3165`), with the old words kept in a dated note beside it.
  *Measured in this run* at `ka-reader@a6add8f`, whose tree outside `docs/` is `ka-reader@0909fe0`'s
  (`git diff --stat 0909fe0 HEAD -- . ':!docs'` prints nothing; `git merge-base --is-ancestor
  0909fe0 HEAD` exits 0): the adapter answers `ObjectStoreNotLocated` for an entry whose class is
  not-located, before anything is spelled (`crates/ka-reader-core/src/git_reader/libgit2.rs:L350-L353`),
  and `ObjectStoreNamesOutside` for an entry spelled outside (`:L358-L360`) and for a link at
  `objects`, `info` or `alternates` that leaves the folder (`:L394-L396`); the probe maps it
  (`:L495-L496`); the model's phrase is "the object store names a location the reader does not
  locate" (`crates/ka-reader-core/src/folder_model.rs:L252-L253`); the wire value is
  `object_store_not_located` (`crates/ka-reader-bridge/src/session.rs:L379`, asserted at `:L1582` and
  `:L1707-L1728`); the shell decodes it (`ka-reader-mac/Sources/Shell/BridgePayload.swift:L388-L389`)
  and draws the sentence the item quotes (`ka-reader-mac/Sources/Surfaces/GitSentences.swift:L68-L72`;
  `grep -i -c outside` over those lines prints `0`); the outside sentence is unchanged
  (`:L63-L67`). `cargo test --workspace --locked` printed 517 passed, 0 failed, summed over its
  `test result` lines; `swift test --package-path ka-reader-mac` printed "Executed 140 tests, with 0
  failures". Both ran in this run. *Addition one — the passages name the cases that hold it*, as
  RN-104's *Built, and the cases that hold it* names the config cases:
  `test_a_bare_relative_entry_is_refused_as_not_located_and_carried_as_written`
  (`crates/ka-reader-core/tests/git_state.rs:L2046`),
  `test_every_entry_beginning_with_neither_dot_nor_slash_is_refused_as_not_located_as_written`
  (`:L2058`), `test_an_own_outside_entry_is_met_before_a_level_one_not_located_entry` (`:L2097`),
  `test_a_submodules_not_located_alternates_entry_fails_status_alone` (`:L2453`), the log case
  `test_failed_git_item_with_the_object_store_not_located_condition_logs_one_warn_without_the_entry`
  (`crates/ka-reader-core/tests/git_state_log.rs:L325`), the shell's decode case
  (`ka-reader-mac/Tests/ShellTests/BridgePayloadGitTests.swift:L95-L97`) and its sentence cases
  `test_theObjectStoreNotLocatedMessageReadsAsChangeTextWritesIt` and
  `test_theObjectStoreNotLocatedMessageNeverSaysOutsideOrAForbiddenWord`
  (`ka-reader-mac/Tests/SurfacesTests/GitSentencesTests.swift:L321`, `:L338`). *Addition two — the
  re-measurement reaches *The condition*'s own locators, not only the known-defect sentences.* The
  change moved the lines R-16 *The condition* cites against `ka-reader@66f428d`
  (`git diff --stat c25201a 0909fe0 -- . ':!docs'` lists `libgit2.rs` and `alternates_scan.rs`
  among seventeen files): the not-located refusal is at `libgit2.rs:L350-L353`, the spelled-outside
  arm at `:L358-L360`, the link arm at `:L394-L396`, the class rule at
  `alternates_scan.rs:L44-L50`, and the first-refused-entry rule at `libgit2.rs:L291-L297`. What
  each names is unchanged. The fold stops there: the three `.gitmodules` known-defect passages
  (`docs/SDD.md:L1018-L1019`, `:L1915`, `:L3336`) stand, because the station's diff touches no
  `.gitmodules` check (`libgit2.rs:L247-L248` still skips every key but the include keys); the
  config condition's *Built* paragraph (`:L3165`) stands; and the CDO's sentence in § 6 S-4
  (`:L1887-L1892`) does not move — RN-103 settled it from `docs/UXD.md` UX-S3 Error
  (`docs/UXD.md:L241`) and `docs/CONTENT.md:L62`, and only the build-state sentence after it
  (`:L1895-L1898`) changes. Reasoning: `docs/trail/sdd/self_answer-52.md` § 5.1.

### 5.2 R-16 leaves open whether the alternates condition's observation is a field or a second condition, and it is a second condition
- **Raised by:** PM — 2026-10-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. The sentence assigns the choice to a build that has
  already made it.
- **Where it shows:** § 11 R-16 "A third way out", *The condition*: "Whether the observation is a
  field on the one condition or a second condition is the design of the change that builds it"
  (`docs/SDD.md:L3424-L3426`). At `ka-reader@0909fe0` it is a second condition.
  It is `ObjectStoreNotLocated(String)` on the read and on the probe, beside
  `ObjectStoreNamesOutside` (`crates/ka-reader-core/src/git_reader.rs:L233`, `:L328`). On the wire it
  is its own value, `object_store_not_located` (`crates/ka-reader-bridge/src/session.rs:L379`),
  carrying the same members as `object_store_names_outside` (`:L485-L486`). In the shell it is
  `GitFailure.objectStoreNotLocated(path:)` (`ka-reader-mac/Sources/Surfaces/GitItem.swift:L92`). The
  config condition's matching sentence was folded the same way (§ 11 R-16, *The refusal and its
  condition*, `:L3141`). The likely fold: the alternates sentence states the second condition as
  built, at SM-2, SM-4 and SM-8, with the locator at each seam.
- **If a document has to be written:** none. A change in `SDD.md` § 11 R-16, written by
  `product-sdd`.
- **Answer:** Confirmed. It is a second condition, at every seam the sentence names, at
  `ka-reader@a6add8f`, whose tree outside `docs/` is `ka-reader@0909fe0`'s. `ObjectStoreNotLocated(String)`
  is its own variant of `GitReadCondition` (`crates/ka-reader-core/src/git_reader.rs:L233`) and of
  `ProbeCondition` (`:L328`), beside `ObjectStoreNamesOutside` (`:L227`, `:L324`); on the wire it is
  its own value, `object_store_not_located` (`crates/ka-reader-bridge/src/session.rs:L379`, under
  `rename_all = "snake_case"` at `:L362`), carrying the same members as
  `object_store_names_outside` through the one constructor both use (`:L480-L486`); the shell
  decodes it as a case of its own (`ka-reader-mac/Sources/Shell/BridgePayload.swift:L388-L389`;
  `GitFailure.objectStoreNotLocated(path:)` at `ka-reader-mac/Sources/Surfaces/GitItem.swift:L92`);
  the model gives it a phrase of its own (`crates/ka-reader-core/src/folder_model.rs:L252-L253`). No
  function joined SM-4: `git diff c25201a 0909fe0 -- crates/ka-reader-bridge` touches `src/session.rs`
  alone and adds no line carrying `no_mangle`, `extern "C"` or `pub extern`, so *The condition*'s
  "crosses SM-2, SM-4 and SM-8 as the config condition does" holds, with the fact a condition
  rather than a field. The sentence at `docs/SDD.md:L3424-L3426` states that, pinned at a current
  commit, in the form *The refusal and its condition* took for the config condition
  (`:L3130-L3141`), with its old words in the fold's dated note. RN-103's and RN-104's copies of
  the sentence (`:L7527`, `:L7619-L7623`) are records of v43 and v44 and do not move. Reasoning:
  `docs/trail/sdd/self_answer-52.md` § 5.2.
