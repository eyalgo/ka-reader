# Architecture open issues — KA-Reader

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

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 QC-62's citations into `LaunchFlow.swift` and `checks/renderer.sh`, its frame count, and § 9's `LaunchFlow.swift` line, re-pointed and pinned to `ka-reader@7c7038f`
- **Lands in:** `nfdr.md` QC-62 (its body, its *verified by* and its trace) and § 9, the `ka-reader-mac`
  bullet's Swift 6 migration-cost sentence. No ADR.
- **Drafted into the records:** NFDR v21 re-points each citation and pins it to `ka-reader@7c7038f`,
  as `docs/SDD.md` § 4 C-I3 pins the same ones at v22. In QC-62: `LaunchFlow.swift:L35-L37` →
  `chooseFolder()` and `openAndList(_:through:)`, `:L54-L60` and `:L69`; the frame list
  `checks/renderer.sh:L44-L57` → header § *THE FRAMES*, the list at `:L53-L56`; the Mac reading
  `:L58-L61` → `:L57-L60`; the runner reading `:L62-L65` → `:L61-L64`. The five-frame match now
  reads as the list the script carried at `ka-reader@37a962d`. The entry also says the list has held
  four frames since `ka-reader@b75348f`, and carries C-I3's second runner reading of the four-frame list
  (run 36795836747, `ka-reader@702f7c4`). That reading is cited to the SDD and was not re-measured by
  this run. The trace now reads C-I3 at v22. In § 9: `LaunchFlow.swift:L53` → `:L60` at
  `ka-reader@7c7038f`, and `ReadRunning.swift:L28` stands. NFDR RN-32 logs the change.
- **Rationale:** Each old citation was false. Read at `ka-reader@a954a90`, where these files are
  byte-equal to `ka-reader@7c7038f`, `LaunchFlow.swift:L35-L37` is the lazy `statusGlyphs`
  property, not the call order QC-62 argues from. `ka-reader@b75348f` removed `LaunchFlow.run()` from
  the frame list. QC-62 traces to C-I3, and C-I3 re-pointed the same citations at SDD v22
  (`docs/SDD.md:L717-L748`; `docs/trail/sdd/cycle-17.md` § 2.1), so the change has a new upstream
  sentence behind it. No owner's answer stands behind it, and the item was raised by a
  `companion-self-answer` run, not by an authoring run (`docs/trail/architecture/self_answer-22.md`
  § Raised on this document; `docs/trail/architecture/cycle-18.md` § 2.1). ADR-0012 carries the same
  old citations and is Accepted, so it is not edited. QC-62 is where the current lines live.
- **If overridden:** QC-62 and § 9 return to the v20 citations. That sends a reader diagnosing a
  red `Renderer gate` to the wrong lines of two files and to a frame count the script no longer
  has, while the SDD it traces to says otherwise. No record supersedes and no other entry moves
  either way.
- **Confirm or override:** confirm, with two additions. This was decided in the owner's seat by a
  `companion-self-answer` run. QC-62 stands as drafted. Every citation in it, the frame count and
  run 36795836747 were re-read at their sources, and each holds. **(1) § 9 names the wrong
  closure.** The site measured at `LaunchFlow.swift:L53` (at `ka-reader@6e1d79f`) is the `listTree`
  closure, `{ Self.listing(at: path, through: bridge) }`. At `ka-reader@7c7038f` that closure is
  `:L107`, not `:L60`. `:L60` (the open closure) and `:L111` (the `selectFile` closure) were added
  after the measurement and fail the same way. So § 9 names all four sites at `ka-reader@7c7038f`:
  Swift 6 mode refuses `LaunchFlow.swift:L60`, `:L107` and `:L111` (each one `bridge`, an
  `any Bridging`, captured in a `@Sendable` closure), and `ReadRunning.swift:L28`, which stands.
  Measured 2026-10-01 in a copy of `ka-reader-mac` at `ka-reader@7c7038f` with Apple Swift 6.4:
  `swift build --target Shell -Xswiftc -swift-version -Xswiftc 6` fails at exactly those three
  `LaunchFlow.swift` lines. The original method (tools 5.9, `StrictConcurrency` on `Surfaces` and
  `Shell`) warns at the same three lines and at `ReadRunning.swift:L28`, each "an error in the
  Swift 6 language mode". **(2) ADR-0012 is pinned in place, not left as it is.** The draft's
  reason, that ADR-0012 is Accepted and so is not edited, does not hold. The owner ruled that
  repairing a citation reverses no decision, and that the repair is made in the ADR's own prose
  as a pin (`docs/trail/architecture/cycle-3.md` § 3.1, answers (1) and (3)). ADR-0012 already
  carries seven dated notes under that ruling. Four of its citations carry no pin:
  `LaunchFlow.swift:L35-L37` in § Decision, and `checks/renderer.sh:L58-L61`, `:L62-L65` and
  `:L44-L57` in § Consequences. Each is false at `HEAD`, and each reads as cited at
  `ka-reader@ab39502`. So each is pinned to `ka-reader@ab39502:` in a dated note made in place. The
  ADR's citations are pinned rather than re-pointed, because a pin is the form the ruling gives
  an ADR. QC-62 is where the current lines live. Reasoning:
  `docs/trail/architecture/self_answer-23.md` § 2.1.

## 3. Raised from downstream — an item from a seat that did not write these records

None.
