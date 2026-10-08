# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `adr/` and `nfdr.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-23
- **Sources re-read:** Two Apple facts that § 2.3's confirm relies on, read through Apple's
  documentation data endpoint on 2026-09-23. (1) `NSTextLayoutManager`
  (`https://developer.apple.com/tutorials/data/documentation/appkit/nstextlayoutmanager.json`):
  `introducedAt: 12.0` for macOS. That matches ADR-0014's "available from macOS 12.0", which is
  below the macOS 14 floor. (2) `UTType.webP`
  (`https://developer.apple.com/tutorials/data/documentation/uniformtypeidentifiers/uttype-swift.struct/webp.json`):
  "A type that represents a WebP image", `introducedAt: 11.0` for macOS. Neither that page nor
  `NSImage.imageTypes` (macOS 10.5) says in words that `NSImage` decodes WebP. `imageTypes` is a
  list the running system returns. So ADR-0015's four-format claim is supported at the level of the
  type, and the decode itself is what S-3's `swift test` case settles. That gap is named in § 2.3
  below. The WebKit sources behind ADR-0011 were not re-read, because no answer here relies on them.

## Items worked

### 1.1 — `docs/SDD.md` § 3 leaves unstated which unit invokes `markdown-renderer` and `highlighter` to fill a `FileView`, and QC-10 forbids `folder-model` from importing the renderer

- **Bucket:** 1. Open issues — questions with no answer yet
- **Verdict:** raised upstream
- **Why:** **Whose it is.** The change goes into `docs/SDD.md` § 3, a row and a paragraph of
  another document. The item says so itself: "the sentence that settles it is the SDD's, at § 3,
  through that document's own run". QC-10 only transcribes whatever the SDD decides. So the answer
  is written on the SDD's companion, as `docs/SDD_open_issues.md` § 2.4 (`ka-reader@5e6198c`). It
  goes in *choices to confirm* because this run has a lean. The answer binds no person and no risk
  the owner carries, only the internal consistency of two documents, so it is not the owner's
  alone.
  **The answer: reading (a).** `folder-model` calls `highlighter` and `markdown-renderer` to fill
  the open `FileView`. The item presents (a) and (b) as equally open. They are not, and one row of
  § 3 decides between them. `core-bridge`'s *Must not own* lists "Read logic — every function
  delegates and formats" and "Anything the harness could not exercise through SM-5"
  (`docs/SDD.md:L328`). SM-5 is `folder-model`'s API, which the harness calls in-process with no
  window (`:L411`; § 4 C-I3). If the bridge made the render call, the rendered document would sit
  outside what SM-5 carries, and the layer-3 harness could not reach it. Reading (b) therefore
  contradicts `core-bridge`'s own row, not only a loose reading of "delegates". The item's second
  argument against (b) also holds: it would put a parse of untrusted content in the one unit that
  holds `unsafe` (§ 11 R-13). Reading (a) contradicts nothing settled. `markdown-renderer` and
  `highlighter` do no I/O of their own (`:L325-L326`, "Reading the file itself", "Reading a
  file"), so `folder-model`'s "I/O of any kind" still holds. The units paragraph forbids the
  renderer and the highlighter from importing the model (`:L343-L345`). It does not forbid the
  reverse.
  **What the SDD owes with it.** `folder-model`'s *Must not own* says "Rendering", and under (a)
  the word it means is "Drawing". It also still says "The Tauri runtime", which RC-3 retired. NFDR
  RN-22 saw that and did not raise it. Both words are in the same cell, so the SDD item carries
  both and does not become a list.
  **Failure paths.** *Refused / error:* a hostile document that makes the parser fail must not
  panic the reducer (C-I1; DR-6). The SDD item states that a failed call is held as the item's
  `failed(condition)`. *Concurrent:* a watcher event on the open file re-reads it, and the reducer
  renders again. The reading position is preserved as FR-27 already requires, and nothing new
  arises. *Stale:* an image resolved at render time is checked again by `asset_bytes` on every
  call (SM-7), so a path that changes between the render and the fetch still reaches no byte
  outside the folder. *Empty:* an empty `.md` file is text (the text rule in the `fs-reader` row)
  and renders to a document with no blocks.
  **What the records do.** Nothing in `adr/` moves. ADR-0016 places every part involved inside
  `ka-reader-core` either way. When the SDD folds § 2.4, QC-10's may-import set gains
  `markdown-renderer` and `highlighter`, and its exclusion of `markdown-renderer` is retired. Its
  exclusions of `own-state`, the libgit2 binding and `git-reader`'s adapter stand. QC-11 does not
  move. **What would have tipped me** to (b): an SDD row giving the bridge a call that is not a
  thin wrapper, or a harness that reaches past SM-5. Neither exists.

### 2.3 — The SDD at v13 carries the replacement renderer (§ 10 RC-3): four records supersede ADR-0001, ADR-0002, ADR-0006 and ADR-0009, ADR-0012 is re-derived, and every entry written against the previous shape is re-derived — all drafted, none accepted

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** **Whose it is.** This seat's. The owner has already decided what the records carry:
  the renderer leaves WKWebView (`docs/trail/sdd/cycle-9.md` § 1.1). The owner left the choice of
  native technology to the SDD's § 2, and the SDD has made it at v13. The item asks whether these
  records carry that decision faithfully. I could not name any ground that is hidden from this
  run. Swift as a second language is a real cost, but it is the SDD's own weighing
  (`docs/SDD.md` § 2), not a call the owner reserved.
  **The drafts hold.** RC-3's *Changed* names the records it owes: ADR-0001, ADR-0002, ADR-0006
  and ADR-0009 (`docs/SDD.md:L2288-L2292`). The drafts supersede exactly those four. Each restates
  the whole record it supersedes, lands at Proposed, and supersedes only on acceptance. That is the
  form ADR-0011 took over ADR-0003, and it keeps the log append-only. The index shows the four
  superseded records still Accepted (`docs/adr/README.md`), so nothing is cited as in force that
  is not. The case for four records rather than one also holds: each decision has a different
  reversal cost (RN-22). The revision of ADR-0012 matches C-I3 at v13: the `idle-shell` control,
  the `open_folder` observable, the frames re-measured on the first native bundle, and the owner's
  addition in its § Decision. ADR-0012 stayed Proposed so that an accepted record would not take a
  mechanism sentence while this item was still open. Moving its acceptance into this item was the
  correct call.
  **Nothing settled is contradicted, with one exception, which is the addition.** I read each
  re-derived entry against §§ 2–4 at v13. Two entries were missed. QC-2's *verified by* still says
  `checks/read-only.sh` runs "after every IPC command" (`docs/nfdr.md:L68-L69`). QC-30's boundary
  set still lists "the renderer's IPC commands and asset requests" (`:L430-L432`), although RN-22
  counts QC-30 as re-derived. ADR-0013 binds both entries on acceptance, and ADR-0013 describes a
  product with no IPC. If this confirm were given without the addition, the NFDR would hold two
  obligations that name a seam the accepted shape does not have. The fold should use C-I3's own
  words: QC-2 runs "after every function the build exports, driven through SM-5", and QC-30's
  member reads "the `SM-4` functions the shell calls, `asset_bytes` among them". The NFDR also
  miscounts in two places. Its `Version:` line and RN-22 both say "three items await the owner",
  and the companion carries two.
  **Decided together with § 1.1.** The acceptance does not depend on § 1.1's answer. ADR-0016
  places `folder-model`, `markdown-renderer` and `highlighter` in `ka-reader-core` under either
  reading, and ADR-0015 does not say which unit calls the renderer. Accepting now forecloses
  nothing that § 2.4 on the SDD's companion might move.
  **Failure paths.** *Stale:* the records are accepted while `docs/SDD.md` is Draft. Its
  companion holds § 2.3, which is answered, and § 2.4, which this run raised. Neither moves § 2's
  shape, the unit set or the seams that these records fix, so the SDD's fold cannot make an
  accepted record false. Under `unsettled_inputs.md` the rule for a Draft input is to derive and
  record, and RN-22 records it. *Absent:* the tree still holds the previous shape, so every entry
  that names the new units stays red until the native shell lands. RN-22 says so once, and that
  red is correct. *Uncovered, and named:* ADR-0015's claim that `NSImage` decodes WebP is
  supported by Apple's pages only at the level of the type (Header). The decode itself is proved by
  S-3's `swift test` case. If WebP does not decode, the placeholder for "a format not decoded"
  already covers it, and no wall moves. *Refused:* if the owner later overrides one of these
  records, that is a superseding record, which is the lifecycle ADR-0013 – ADR-0016 already state.
  **What would have tipped me** to override: a draft admitting a web engine anywhere, an entry
  still binding the CSP or the capability file, or a superseded record's Status line moved before
  acceptance. None of these is the case.

## Left for the owner

None this run.

## Skipped

None this run. Both items carried a slot at its placeholder, and no item is addressed to another actor.

## Companions opened

- **`docs/SDD_open_issues.md`** — **appended** — companion to `SDD.md`, item 2.4 (§ 3 does not
  say which unit calls `markdown-renderer` and `highlighter` to fill a `FileView`, and
  `folder-model`'s *Must not own* still says "Rendering" and "The Tauri runtime"), landed in commit
  `5e6198c`. The builder stamped no `Skill-Version:` or `Prompt-Version:` on it, although both
  flags were passed. That is the known limit for a session whose `<CORE>` is a pin
  (`kensaiapp-opensource@27d7bd3`).

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
- **`docs/SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh ka-reader`
