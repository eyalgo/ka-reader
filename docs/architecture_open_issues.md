# Architecture open issues — Nozoki

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

### 2.1 QC-62's citations into `LaunchFlow.swift` and `checks/renderer.sh`, its frame count, and § 9's `LaunchFlow.swift` line, re-pointed and pinned to `nozoki@7c7038f`
- **Lands in:** `nfdr.md` QC-62 (its body, its *verified by* and its trace) and § 9, the `nozoki-mac`
  bullet's Swift 6 migration-cost sentence. No ADR.
- **Drafted into the records:** NFDR v21 re-points each citation and pins it to `nozoki@7c7038f`,
  as `docs/SDD.md` § 4 C-I3 pins the same ones at v22. In QC-62: `LaunchFlow.swift:L35-L37` →
  `chooseFolder()` and `openAndList(_:through:)`, `:L54-L60` and `:L69`; the frame list
  `checks/renderer.sh:L44-L57` → header § *THE FRAMES*, the list at `:L53-L56`; the Mac reading
  `:L58-L61` → `:L57-L60`; the runner reading `:L62-L65` → `:L61-L64`. The five-frame match now
  reads as the list the script carried at `nozoki@37a962d`. The entry also says the list has held
  four frames since `nozoki@b75348f`, and carries C-I3's second runner reading of the four-frame list
  (run 36795836747, `nozoki@702f7c4`). That reading is cited to the SDD and was not re-measured by
  this run. The trace now reads C-I3 at v22. In § 9: `LaunchFlow.swift:L53` → `:L60` at
  `nozoki@7c7038f`, and `ReadRunning.swift:L28` stands. NFDR RN-32 logs the change.
- **Rationale:** Each old citation was false. Read at `nozoki@a954a90`, where these files are
  byte-equal to `nozoki@7c7038f`, `LaunchFlow.swift:L35-L37` is the lazy `statusGlyphs`
  property, not the call order QC-62 argues from. `nozoki@b75348f` removed `LaunchFlow.run()` from
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
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

None.
