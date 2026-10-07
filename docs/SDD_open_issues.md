
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
> companion template. The alternates condition's second observation is now built (`nozoki@0909fe0`),
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
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. A reader of § 3, S-4 or R-16 is told that the adapter
  answers one condition for an alternates entry it does not locate, and that the Git view says
  *outside* for it. That is no longer true.
- **Where it shows:** three passages, each measured at `nozoki@66f428d`. § 3, the `git-reader`
  row, "The alternates check": "one condition for both observations, which § 11 R-16 states as a
  known defect until a change lands" (`docs/SDD.md:L347`). § 6 S-4 *Reached when*, observable
  half, the second alternates passage: "At `nozoki@66f428d` the shipped sentence says "outside the
  folder you opened" for both observations … which § 11 R-16 names as a known defect until a change
  lands" (`:L1895-L1898`). § 11 R-16 "A third way out", *The condition*, *A known defect, until a
  change lands*: the adapter answers one condition for both observations, the `relative/objects`
  case asserts it, and the shipped sentence and the model's phrase say *outside* (`:L3432-L3444`).
  At `nozoki@0909fe0` the adapter answers `ObjectStoreNotLocated` for an entry beginning with
  neither `.` nor `/`, before anything is spelled
  (`crates/nozoki-core/src/git_reader/libgit2.rs:L350-L353`), and keeps `ObjectStoreNamesOutside`
  for an entry spelled outside (`:L358-L360`). The probe maps it at `:L495-L496`. The log line has
  its own phrase, "the object store names a location the reader does not locate"
  (`crates/nozoki-core/src/folder_model.rs:L210-L211`, `:L230-L231`, `:L252-L253`). The wire value
  is `object_store_not_located` (`crates/nozoki-bridge/src/session.rs:L379`, `:L437`) and the
  shell decodes it (`nozoki-mac/Sources/Shell/BridgePayload.swift:L388-L389`). The Git view draws
  "Nozoki found a Git object store that names {path}. Nozoki doesn't work out where that path
  leads, so it doesn't read the folder's Git status. The file tree and the reading panel are
  unaffected." (`nozoki-mac/Sources/Surfaces/GitSentences.swift:L68-L72`), and
  `grep -i -c outside` over those lines prints `0`. The outside sentence is unchanged (`:L63-L67`).
  The `relative/objects` case now asserts the second condition
  (`crates/nozoki-core/tests/git_state.rs:L2046`), and a submodule's not-located entry fails the
  status read alone (`:L2453`). `cargo test --workspace --locked` passes (517 tests, 0 failed), and
  so does `swift test --package-path nozoki-mac` (140 tests, 0 failures). The likely fold: the three
  passages re-measured at a current commit, with the known-defect sentences replaced by what is
  built, in the form of *The refusal and its condition*, *Built, and the cases that hold it*
  (`:L3165`).
- **If a document has to be written:** none. A change in `SDD.md` § 3, § 6 S-4 and § 11 R-16,
  written by `product-sdd`.
- **Answer:** <the owner fills this in>

### 5.2 R-16 leaves open whether the alternates condition's observation is a field or a second condition, and it is a second condition
- **Raised by:** PM — 2026-10-07
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. The sentence assigns the choice to a build that has
  already made it.
- **Where it shows:** § 11 R-16 "A third way out", *The condition*: "Whether the observation is a
  field on the one condition or a second condition is the design of the change that builds it"
  (`docs/SDD.md:L3424-L3426`). At `nozoki@0909fe0` it is a second condition.
  It is `ObjectStoreNotLocated(String)` on the read and on the probe, beside
  `ObjectStoreNamesOutside` (`crates/nozoki-core/src/git_reader.rs:L233`, `:L328`). On the wire it
  is its own value, `object_store_not_located` (`crates/nozoki-bridge/src/session.rs:L379`),
  carrying the same members as `object_store_names_outside` (`:L485-L486`). In the shell it is
  `GitFailure.objectStoreNotLocated(path:)` (`nozoki-mac/Sources/Surfaces/GitItem.swift:L92`). The
  config condition's matching sentence was folded the same way (§ 11 R-16, *The refusal and its
  condition*, `:L3141`). The likely fold: the alternates sentence states the second condition as
  built, at SM-2, SM-4 and SM-8, with the locator at each seam.
- **If a document has to be written:** none. A change in `SDD.md` § 11 R-16, written by
  `product-sdd`.
- **Answer:** <the owner fills this in>
