# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The NFDR is v21 and Draft, because one item waits
  for this confirm (`docs/nfdr.md:L3-L5`).
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-01
- **Sources re-read:** GitHub Actions run 36795836747 on `kensaiapp/nozoki`, read with
  `gh run view 36795836747 --repo kensaiapp/nozoki` and its `--log`. Head `702f7c4`, conclusion
  `success`, image `macos-14-arm64` version `20260831.0302.1`. The `Renderer gate` step printed
  "the main process was observed at the Open panel, inside the shell's launch, on observation 1
  (bound: 30 observations, about 1 s each)". It also printed that the `idle-shell` control "was
  not observed at the Open panel in any of 30 observations — the expected red". This is what QC-62
  cites from `docs/SDD.md` § 4 C-I3, and the run says it. Everything else was read in the product
  repository at `nozoki@c5f3a59`. `LaunchFlow.swift`, `ReadRunning.swift` and `checks/renderer.sh`
  are byte-equal there to `nozoki@7c7038f` (`git diff --quiet 7c7038f HEAD --` on each).

One item was open, § 2.1, and this run worked it. Nothing is left for the owner, and no companion
was opened elsewhere.

## Items worked

### 2.1 — QC-62's citations into `LaunchFlow.swift` and `checks/renderer.sh`, its frame count, and § 9's `LaunchFlow.swift` line, re-pointed and pinned to `nozoki@7c7038f`

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** **QC-62 is confirmed as drafted. Two parts of the draft do not hold, and each is
  corrected by an addition.**

  *Check 1, the seat.* The answer is this run's to give. Every change lands in this companion's
  own two records. It binds nothing but their accuracy: no person, no outside party and no risk
  anyone carries. Re-pointing a citation is the kind of change the owner has already ruled on
  (`docs/trail/architecture/cycle-3.md` § 3.1).

  *QC-62 holds, re-read line by line at `nozoki@7c7038f`.* `LaunchFlow.swift:L35-L37` is the lazy
  `statusGlyphs` property, so the old citation was false. `chooseFolder()` waits on the panel at
  `:L54` and hands off at `:L59-L60`, and `openAndList` calls `bridge.openFolder` at `:L69`. So
  "`:L54-L60` and `:L69`" carries QC-62's claim that `open_folder` runs only after the panel
  returns. `checks/renderer.sh` has its § *THE FRAMES* header at `:L44`, its four-frame list at
  `:L53-L56`, its Mac reading at `:L57-L60` and its runner reading at `:L61-L64`.
  `nozoki@37a962d` carried five frames, `LaunchFlow.run()` among them, at `:L53-L57`.
  `nozoki@b75348f` removed that frame from both the header and `FRAME_LIST`
  (`git show b75348f -- checks/renderer.sh`). Run 36795836747 says what the entry says it does
  (Header, *Sources re-read*), and at its head, `702f7c4`, the script lists four frames.
  `docs/SDD.md:L717-L748`, C-I3 at v22, pins the same lines at the same commit, and QC-62 traces
  to C-I3. So the entry agrees with its source. On check 4, every citation is pinned to a commit,
  so none can go stale the way the v20 lines did. A file moving under them leaves them true.

  *Addition 1. The draft re-pointed § 9 to the wrong closure.* The draft moves
  "`LaunchFlow.swift:L53` → `:L60`". At the measured commit, line 53 is the `listTree` closure,
  `reader.run({ Self.listing(at: path, through: bridge) }, deliver: answer)`
  (`git show f46269a:nozoki-mac/Sources/Shell/LaunchFlow.swift`, `:L52-L53`). The measurement
  itself was taken at `nozoki@6e1d79f`, whose `Shell` sources are byte-equal to `f46269a`'s
  (`docs/trail/architecture/cycle-17.md` § 3.2). At `nozoki@7c7038f` that closure is `:L107`.
  `:L60` is the closure `chooseFolder()` passes to `openAndList`, and the file at `f46269a` has no
  such closure, because it opened the folder in line (`:L42`). So the draft's `:L60` names a
  different site, one added after the measurement. The same mistake is in the item as raised:
  `self_answer-22.md` § *Raised on this document* reads "§ 9's `LaunchFlow.swift:L53` is now
  `:L60`".

  This run measured the sites itself, in a copy of `nozoki-mac` made with
  `git archive 7c7038f nozoki-mac` under `/private/tmp`, using Apple Swift 6.4.
  `swift build --target Shell -Xswiftc -swift-version -Xswiftc 6` fails with exactly three
  errors: "capture of 'bridge' with non-Sendable type 'any Bridging' in a '@Sendable' closure", at
  `LaunchFlow.swift:60:63`, `:107:58` and `:111:58`. `ReadRunning.swift:L28` is not among them:
  that build reports nothing for it. Why it does not is not known from this measurement. The
  method below does report it.

  The original method was then repeated: tools 5.9, with
  `.enableUpcomingFeature("StrictConcurrency")` on `Surfaces` and `Shell`. It warns at the same
  three `LaunchFlow.swift` lines and at `ReadRunning.swift:28:44`, "sending 'deliver' risks causing
  data races; this is an error in the Swift 6 language mode". The same method at `nozoki@6e1d79f`
  reproduces the original two sites, `LaunchFlow.swift:53:58` and `ReadRunning.swift:28:44`, and
  nothing else. So the method is the one cycle 17 used, and the three `LaunchFlow.swift` sites are
  real.

  The correction is that § 9 names `LaunchFlow.swift:L60`, `:L107` and `:L111` and
  `ReadRunning.swift:L28`, all at `nozoki@7c7038f`. The note says that the measured `:L53` is now
  `:L107`, and that `:L60` and `:L111` were added after the measurement and fail the same way. The
  draft's "plus any site added before the flip" already admits sites added later. But a cost
  sentence that names one of three identical sites, and calls it the measured one, misleads the
  change that has to clear all three.

  *Addition 2. The draft's reason for leaving ADR-0012 alone does not hold.* The draft says
  "ADR-0012 carries the same old citations and is Accepted, so it is not edited". The owner ruled
  otherwise on citations. "A citation repair reverses no decision, changes no context, alternative,
  consequence or trace, and leaves every record's Status at Accepted". For an ADR the repair is a
  pin to the commit the citation was read at, edited into the record's own prose with no
  superseding record (`docs/trail/architecture/cycle-3.md` § 3.1, answers (1) and (3)). The same
  record was pinned in place under that ruling at `cycle-11.md` § 3.7. ADR-0012 itself carries
  seven dated in-place notes, and its *Traces to* cites the ruling for them.

  Four of ADR-0012's citations carry no pin, and each is false at `HEAD`.
  `nozoki-mac/Sources/Shell/LaunchFlow.swift:L35-L37` (§ Decision, `adr/0012…:L39`) is
  `statusGlyphs` now. `checks/renderer.sh:L58-L61` (§ Consequences, `:L120` and `:L136`) now
  starts with the Mac reading's second line. `:L62-L65` (`:L133`) now starts with the runner
  reading's second line. `:L44-L57` (`:L136`) now runs one line past the list's end, into the Mac
  reading.

  At `nozoki@ab39502` all four read as ADR-0012 says. `:L35-L37` is
  `let location = panel.chooseFolder()` followed by `bridge.openFolder(location:)`. `:L44` is
  § *THE FRAMES* and `:L57` is the last frame, so `:L44-L57` spans the header and the list.
  `:L58-L61` is the Mac reading and `:L62-L65` is the runner reading
  (`git show ab39502:…`). `nozoki@ab39502` is the one commit at which all four hold, since the
  runner reading is not in the header at `nozoki@153f5a1`. So each citation is pinned to
  `nozoki@ab39502:` in a dated note made in place, the form `cycle-11.md` § 3.7 used on this
  record. They are pinned and not re-pointed because cycle 3's ruling gives a pin to an ADR and a
  re-point to the NFDR. That split is why QC-62 moves to `7c7038f` while ADR-0012 stays at the
  lines it read. The draft's conclusion that ADR-0012 is not superseded stands. Its premise, that
  ADR-0012 is not touched at all, does not.

  *What I was close to.* I nearly gave **overridden**, because Addition 1 replaces a line the draft
  chose instead of adding a case. It was not chosen because the item defines an override as
  "QC-62 and § 9 return to the v20 citations". A fold reading `override` could do that, and nobody
  argues for it: QC-62's re-point is right. Nothing in the companion's own form separates "confirm
  most, correct one line" from "confirm", so the slot says *confirm, with two additions*, the form
  this companion's earlier rounds used (`docs/trail/architecture/cycle-10.md` § 2.1). The
  correction is written out in the slot, so a fold that reads only the slot cannot miss it.

  *What this does not cover.* Earlier Review Notes that cite the old lines (RN-31; the SDD's
  RN-76) are dated accounts and stand as history. The Mac reading in `checks/renderer.sh`'s header
  now says "the four frames above". It was taken while the list held five, and `b75348f` changed
  its count word. That is the script's own text, and QC-62 cites the reading by line, not by
  wording, so no record moves for it.

## Left for the owner

None this run.

## Skipped

- **§ 1 and § 3 as the file stood.** Both read "None.", so there were no items to answer.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
