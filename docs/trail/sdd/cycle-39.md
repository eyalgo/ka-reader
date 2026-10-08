
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
> companion template. The config condition's second observation is now built (`ka-reader@c25201a`),
> and the SDD still reads it as unbuilt in three places: § 6 S-4 and § 11 R-16 call the one
> condition a known defect until a change lands, and R-16 leaves open whether the observation is a
> field or a second condition. The SDD is Settled, and with no companion on disk a `product-sdd`
> re-run reads it as done and has nothing to act on. Its two items are in § 5.

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

### 5.1 § 6 S-4 and § 11 R-16 call the config condition's one condition a known defect, and both observations are built
- **Raised by:** PM — 2026-10-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. A reader of S-4 or R-16 is told that the Git view says
  *outside* for a value the adapter does not locate. That is no longer true.
- **Where it shows:** two passages, each measured at `ka-reader@fc14574`. § 6 S-4 *Reached when*,
  observable half: "At `ka-reader@fc14574` the shipped sentence says "outside the folder you opened"
  for both observations, which § 11 R-16 names as a known defect until a change lands"
  (`docs/SDD.md:L1870-L1872`). § 11 R-16 *The refusal and its condition*, *A known defect, until a
  change lands*: the adapter answers one condition for both observations, and the shipped sentence
  says "outside the folder you opened" for both (`:L3144-L3150`). At `ka-reader@c25201a` the adapter
  answers `ConfigNotLocated` for a value in one of the two not-located forms
  (`crates/ka-reader-core/src/git_reader/libgit2.rs:L274`) and keeps `ConfigNamesOutside` for a
  value spelled outside. The probe maps it at `:L486`, and the log line has its own phrase
  (`crates/ka-reader-core/src/folder_model.rs:L206`, `:L223`). The wire value is `config_not_located`
  (`crates/ka-reader-bridge/src/session.rs:L378`, `:L434`) and the shell decodes it
  (`ka-reader-mac/Sources/Shell/BridgePayload.swift:L383-L384`). The Git view draws "KA-Reader found {key}
  set to {path} and doesn't work out where that path leads, so it doesn't read the folder's Git
  status." (`ka-reader-mac/Sources/Surfaces/GitSentences.swift:L58-L62`), and
  `grep -i -c outside` over those lines prints `0`. The outside sentence is unchanged (`:L53-L57`).
  `cargo test --workspace --locked` passes (511 tests, 0 failed), and so does
  `swift test --package-path ka-reader-mac` (136 tests, 0 failures). The likely fold: both passages
  re-measured at a current commit, with the known-defect sentences replaced by what is built, the
  way cycle-38 § 5.1 treated the alternates check.
- **If a document has to be written:** none. A change in `SDD.md` § 6 S-4 and § 11 R-16, written
  by `product-sdd`.
- **Answer:** Confirmed, with two additions. Both passages are re-measured at a current commit, and
  each known-defect sentence is replaced by what is built, the way cycle-38 § 5.1 treated the
  alternates check. *Measured in this run* at `ka-reader@d7f79c7`, whose tree outside `docs/` is
  `ka-reader@c25201a`'s (`git diff --stat c25201a HEAD -- . ':!docs'` prints nothing): the adapter
  answers `ConfigNotLocated` for a value in either not-located form
  (`crates/ka-reader-core/src/git_reader/libgit2.rs:L274`; the two forms at
  `crates/ka-reader-core/src/git_reader/config_scan.rs:L178`, `:L182`), on the probe (`libgit2.rs:L486`),
  on both reads and for a submodule's config; the wire value is `config_not_located`
  (`crates/ka-reader-bridge/src/session.rs:L362`, `:L378`, asserted at `:L1576`); the shell decodes it
  (`ka-reader-mac/Sources/Shell/BridgePayload.swift:L383-L384`) and draws "KA-Reader found {key} set to
  {path} and doesn't work out where that path leads, so it doesn't read the folder's Git status. The
  file tree and the reading panel are unaffected." (`ka-reader-mac/Sources/Surfaces/GitSentences.swift:L58-L62`);
  the outside sentence is unchanged (`:L53-L57`). `cargo test --workspace --locked` printed 511
  passed, 0 failed; `swift test --package-path ka-reader-mac` printed 136 tests, 0 failures.
  *Addition one — the passages name the cases that hold it*, as RN-103's *The proof* names the
  alternates case: `test_a_tilde_slash_value_is_refused_as_not_located_on_all_three_calls`
  (`crates/ka-reader-core/tests/git_state.rs:L1534`), `test_a_relative_excludesfile_is_refused_as_not_located`
  (`:L1556`), `test_a_tilde_slash_value_in_a_submodules_config_is_not_located_on_status_alone`
  (`:L1543`), the log case, one `warn` and no path
  (`crates/ka-reader-core/tests/git_state_log.rs:L214`), and the shell's sentence case
  (`ka-reader-mac/Tests/SurfacesTests/GitSentencesTests.swift:L222-L226`). A passage that says
  "built" in this document carries its case.
  *Addition two — the fold stops at the five keys named first.* The sixth key's not-located form, a
  `.gitmodules` section path beginning `/`, which R-16 says "answers this second observation"
  (`docs/SDD.md:L3116-L3118`), is not built: at `ka-reader@c25201a` the adapter still skips every key
  of `.gitmodules` but the include keys (`libgit2.rs:L247-L248`), so the `.gitmodules` known defect
  (`:L3290-L3296`), § 4 C-D3's sentence on it (`:L1017-L1018`) and § 6 S-4's (`:L1903-L1906`) stand
  as they are. The CDO's clause in § 6 S-4 does not move: the second-observation sentence was
  settled by `docs/UXD.md` UX-S3 Error and `docs/CONTENT.md:L62` at RN-101, and only the
  build-state sentence after it changes. Reasoning: `docs/trail/sdd/self_answer-51.md` § 5.1.

### 5.2 R-16 leaves open whether the config condition's observation is a field or a second condition, and it is a second condition
- **Raised by:** PM — 2026-10-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing is cut by it. The sentence assigns the choice to a build that has
  already made it.
- **Where it shows:** § 11 R-16 *The refusal and its condition*: "Whether that is a field on the
  one condition or a second condition is the design of the change that builds it"
  (`docs/SDD.md:L3120-L3121`). At `ka-reader@c25201a` it is a second condition. It is
  `ConfigNotLocated(ConfigNamedPath)` on the read and on the probe, beside `ConfigNamesOutside`
  (`crates/ka-reader-core/src/git_reader.rs:L221`, `:L314`). On the wire it is its own value,
  `config_not_located` (`crates/ka-reader-bridge/src/session.rs:L378`), carrying the same four members
  as `config_names_outside`. The matching sentence for the alternates condition (§ 11 R-16, "A
  third way out", *The condition*, `:L3378-L3380`) is not built either way and stays open. The
  likely fold: the config sentence states the second condition as built, and the alternates
  sentence is left as it stands.
- **If a document has to be written:** none. A change in `SDD.md` § 11 R-16, written by
  `product-sdd`.
- **Answer:** Confirmed. It is a second condition, at every seam the sentence names.
  `ConfigNotLocated(ConfigNamedPath)` is its own variant of `GitReadCondition`
  (`crates/ka-reader-core/src/git_reader.rs:L221`) and of `ProbeCondition` (`:L314`), beside
  `ConfigNamesOutside`; on the wire it is its own value, `config_not_located`
  (`crates/ka-reader-bridge/src/session.rs:L378`, under `rename_all = "snake_case"` at `:L362`), with
  the same members as `config_names_outside` (`:L280`); the shell decodes it as its own case
  (`ka-reader-mac/Sources/Shell/BridgePayload.swift:L383-L384`); the model gives it its own phrase
  (`crates/ka-reader-core/src/folder_model.rs:L237`). No function joined SM-4:
  `git diff 218e250 c25201a -- crates/ka-reader-bridge` adds no export, so RN-101's "no seam moved"
  still holds with the fact a condition rather than a field. The sentence at `docs/SDD.md:L3120-L3121`
  states that, pinned at a current commit, with its old words in the fold's dated note. The
  alternates sentence (`:L3378-L3380`) stays as it stands: `GitReadCondition` has no not-located
  variant for the object store (`git_reader.rs:L227` is `ObjectStoreNamesOutside(String)` alone,
  and `ProbeCondition`'s at `:L318`). RN-101's copy of the sentence (`:L7227-L7228`) is a record
  of v41 and does not move. Reasoning: `docs/trail/sdd/self_answer-51.md` § 5.2.
