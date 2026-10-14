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

> **No `product-architecture` run wrote this file.** The owner opened it on 2026-10-14, in an
> interactive session, to carry two items met while walking ka-reader that day. The records are
> Settled, so without a companion they would reach no one.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 § 9 says the tools-6.2 adoption is the tree's and not yet CI's, and CI has built it since run 38549778886

> **No `product-architecture` run wrote this item.** A `companion-self-answer` run raised it on
> 2026-10-14, while answering § 3.1. It read § 9's *Adopted* passage beside the runs § 3.1 cites, and
> found that a fact in it is now false. No item asked about it. The reasoning is
> `docs/trail/architecture/self_answer-50.md` § *Raised on this document*.

- **Lands in:** `nfdr.md` § 9, the `ka-reader-mac` bullet's *Adopted* passage, the sentences from "The
  adoption is the tree's, not yet CI's." to "a red there contradicts this clause and is not noise"
  (lines 1845–1849 at `ka-reader@20a15ed`). No ADR.
- **Drafted into the records:** nothing. The run that raised this writes no document. The lean, for
  the seat that folds it: those sentences become a dated account. `ka-reader@f0f1e5f` is on
  `origin/main`. The first hosted build of the `6.2` manifest is GitHub Actions run 38549778886 on
  `ka-reader@47e8e6b` (2026-10-14). It went red at `Build KA-Reader.app` with "expression uses unsafe
  constructs but is not marked with 'unsafe'" at `NativeBridge.swift:24:9` and `:28:9`. The manifest
  loaded, and the source failed to compile. As the clause said, that red was not noise: it was the
  adopted `.strictMemorySafety()` setting meeting Swift 6.3.3. `ka-reader@24be581` fixed it, and run
  38551538187 on that commit is the first green hosted build of the manifest. The v49 words stand in a
  dated note.
- **Rationale:** A fact in the document is now false, measured at the source on 2026-10-14.
  `git merge-base --is-ancestor f0f1e5f origin/main` holds. `gh run view 38549778886` gives head
  `47e8e6b`, step `Build KA-Reader.app` failed, and its log prints both `NativeBridge.swift` errors.
  `gh run view 38551538187` gives head `24be581`, job `wall` success. § 3.1's fold touches the same
  bullet's *Toolchain* clause and cites the same run, so the cheapest place to make this change is
  that fold. But § 3.1 does not ask about this passage, and an answer is not the place to carry a
  separate defect.
- **If overridden:** § 9 keeps telling a cold reader that no hosted run has built a manifest that CI
  has built on every push since 2026-10-14. It also leaves open whether that first red broke the
  clause. Nothing else moves.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 The records name CI's toolchain, but not the toolchain or environment the change-time gate runs in
- **Raised by:** Product (owner) — 2026-10-14
- **Which record:** `nfdr.md` § 8 (the card's test command as the change-time gate, lines 1436–1447)
  and § 9's *Toolchain* clause (lines 1795–1810), which records the Swift CI builds with.
- **Tracked by:** no seed. The instance finding
  `kensaiapp-opensource/docs/findings/2026-10-14_product-tests-run-on-the-owners-machine.md` carries
  the pipeline side, which is where gates run by default.
- **What it blocks:** nothing outright. But on 2026-10-14 the change-time gate gave two verdicts that CI
  or a re-run contradicted, because it runs wherever the delivery tier runs. Today that is the owner's
  Mac:
  - Swift 6.4 (Xcode 27, SDK 27.0) passed `ka-reader@47e8e6b` at every stage. CI's Swift 6.3.3 then
    failed it at `Build KA-Reader.app`, run 38549778886: `NativeBridge.swift:24:9` and `:28:9`, "expression
    uses unsafe constructs but is not marked with 'unsafe'". The two compilers reject each other's
    spelling under `.strictMemorySafety()` with warnings as errors. The tree now carries
    `#if compiler(>=6.4)` in `NativeBridge.swift` (`ka-reader@24be581`) so both build.
  - With the Mac's screen locked, `LaunchWindowLayoutTests`' two drag tests timed out. The window
    server held the window at 90% of its frame. The chain halted `red-suite` on a correct change.
- **Where it shows:** § 9 states the CI toolchain as a record "because a label's default Xcode can
  move", but the gate that decides a change lands runs on an unrecorded toolchain. A tart guest on
  `ghcr.io/cirruslabs/macos-tahoe-xcode:26.5` (Swift 6.3.2, SDK 26.5) reproduced CI's failure at
  `47e8e6b`. It ran the full gate green at `ka-reader@da79dcc` and kept the window tests green while
  the host was locked.
- **The question:** should the records state the environment the change-time gate runs in, and its
  toolchain, against CI's? And should a gate run on a different toolchain be named as one that cannot
  stand in for CI? Also, is `NativeBridge.swift`'s two-compiler branch to be recorded as a supported
  pair (6.3 and 6.4), or as a stop-gap until the gate's toolchain is CI's?
- **If a document has to be written:** possibly an ADR, if the gate's environment becomes a binding.
  Otherwise a fold into § 8 and § 9.
- **Answer:** Fold into `nfdr.md` §§ 8 and 9; no ADR. (1) **Yes, as a reading rule, not as an
  environment.** § 9's *Toolchain* clause names the toolchain it records — CI's, today Apple Swift
  6.3.3 on SDK 26.5 — as the reference for every verdict that depends on the compiler. A change-time
  verdict stands in for CI only when the Swift version and SDK the run printed are that toolchain. A
  run on any other toolchain, a patch release included, or a run that names none, proves the change on
  what it ran on and nothing more; the CI build on `main` is the reading. Where the gate runs — the
  owner's Mac, a guest VM — stays the project card's and the pipeline's (§ 8's first sentence; the
  instance finding this item names), and the records name no VM. (2) **Yes, and the window server
  gets the same rule.** § 9's runner paragraph states a second precondition beside the bridge's
  assembly: a layer-4 test that places a window needs a session in which the window server places
  windows. A run whose window tests fail with *the window server did not place the window* in a locked
  session has not read the change either way. It is re-run where windows are placed, and never
  skipped or quieted. (3) **A supported pair, bounded.** The `#else` arm builds on the toolchain § 9
  records, and CI holds it on every build. The `compiler(>=6.4)` arm is held by no hosted check, only
  by change-time runs on 6.4, and the records say so. The `#else` arm is owed removal from the first
  CI log that prints Swift 6.4 or later, because from then nothing builds it. Reasoning:
  `docs/trail/architecture/self_answer-50.md` § 3.1.

### 3.2 § 8 says the card's test command does not assemble the bridge, and the card now does
- **Raised by:** Product (owner) — 2026-10-14
- **Which record:** `nfdr.md` § 8, "The card's Swift half needs the bridge assembled first, and the card
  does not say so yet" (lines 1451–1460), and the card's command as § 8 quotes it (line 1438).
- **Tracked by:** no seed. This is the move § 8 named as owed, now made.
- **What it blocks:** nothing. But § 8 now states the card falsely. `product-card` re-derived the card
  at `kensaiapp-opensource@d5005730`, and its `Test command:` reads
  `cargo test --workspace --locked && ka-reader-mac/assemble.sh && swift test --package-path ka-reader-mac`.
- **Where it shows:** § 8 lines 1438 and 1451–1460, measured at `ka-reader@0e3ad5e`.
- **If a document has to be written:** none. This is a fold into `nfdr.md` § 8.
- **Answer:** Fold into `nfdr.md` § 8; no record. The card moved at `kensaiapp-opensource@d5005730`,
  and its `Test command:` reads `cargo test --workspace --locked && ka-reader-mac/assemble.sh && swift
  test --package-path ka-reader-mac` (re-read 2026-10-14). § 8 quotes the card at that commit. The
  paragraph *The card's Swift half needs the bridge assembled first, and the card does not say so yet*
  becomes a dated note, because the move it named as owed is made. RN-6 is extended with the pin. § 9's
  runner paragraph stays the precondition's one home and does not move. Reasoning:
  `docs/trail/architecture/self_answer-50.md` § 3.2.

**How it closes.** `product-architecture` folds both on its next run like any other item here.
