# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (v51, Settled). Both items reach `docs/nfdr.md` only.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-14
- **Sources re-read:** GitHub Actions, at the source and not taken from the items:
  `gh run view 38549778886 --repo kensaiapp/ka-reader` gives `headSha`
  `47e8e6b1ff246e4abb4b9a31d5773e9337b60bf2`, and job `wall` fails at step `Build KA-Reader.app`. Its
  `--log-failed` output prints `NativeBridge.swift:24:9: error: expression uses unsafe constructs but
  is not marked with 'unsafe' [#StrictMemorySafety]` and the same error at `:28:9`.
  `gh run view 38551538187` gives `headSha` `24be581344cee53ca7741c5b66a9a9bae0623c4b`, and job `wall`
  succeeds. `gh run list --workflow ci.yml --limit 4` lists 38577309118 (`success`), 38551538187
  (`success`), 38549778886 (`failure`) and 38501500758 (`success`). The project card in the managing
  instance, `system/projects/ka-reader/project.md:8`, was read as it stands, and it was last moved at
  `kensaiapp-opensource@d5005730`. On the owner's Mac, `swift --version` prints `Apple Swift version
  6.4 (swiftlang-6.4.0.34.1 …)`. In the repository, `f0f1e5f`, `47e8e6b`, `24be581` and `da79dcc`
  are all ancestors of `origin/main` (`f357008`). The tart-guest measurements this run relies on are
  the instance finding's (`kensaiapp-opensource/docs/findings/2026-10-14_product-tests-run-on-the-owners-machine.md`).
  This run did not re-take them.

## Items worked

### 3.1 — The records name CI's toolchain, but not the toolchain or environment the change-time gate runs in

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** **Fold it into `nfdr.md` §§ 8 and 9, with no ADR. The records state what a change-time
  verdict is worth against CI's recorded toolchain. They also state the window server as a second
  runner precondition, and record the two-compiler branch as a bounded supported pair. They do not
  name where the gate runs.**

  *Check 1, the seat.* The item asks three things, and I asked check 1 of each one separately.
  (a) *Should the records state the environment and its toolchain?* The answer splits along the line
  § 8 already draws. § 8's first sentence says the execution context is the project card's and is
  not restated here (`docs/nfdr.md:1436-1437`). Which machine or guest runs the gate is therefore
  the card's and the pipeline's to decide, and the instance finding the item names is already where
  that is being worked (its *Repair target* and its packet suggestion). What a verdict from that
  environment is worth against CI is a test-strategy statement. That belongs to this seat (§ 9 is
  the test-strategy realization), so (a) is mine. I answer it in a form that names no environment.
  This is not a split: the environment half is not a second question the item asks of this
  document. It is the reason the answer stays narrow. (b) *Should a gate on a different toolchain be
  named as one that cannot stand in for CI?* This is a reading rule on § 9's own recorded toolchain,
  so it is mine. (c) *Is the branch a supported pair or a stop-gap?* This binds only which compilers
  the tree is held to build on, so it is mine. None of the three commits money, a person or an
  outside party. Requiring a VM would commit the owner to infrastructure (an image of about 88 GB,
  an Apple ID to install Xcode 26.6, and Apple's limit of two guests per host, all in the finding).
  That is exactly why the answer requires none.

  *Check 2, the question.* The item has no draft. Its last line leans toward "possibly an ADR, if
  the gate's environment becomes a binding". Under this answer the gate's environment does not
  become a binding in the product's records, so the ADR the line conditions on is not owed. The
  significance test agrees. The reading rule and the precondition are cheap to reverse (a revert of
  one fold) and involve no structural trade-off. The one choice here that is hard to reverse and has
  a real trade-off is which environment the gate runs in, and that choice is the pipeline's. Item
  3.1 is not a widening without an occurrence. It cites two: run 38549778886, and the `red-suite`
  halt with the screen locked.

  *Check 3, the settled record and the sources.* (a)/(b): § 9's *Toolchain* clause already records
  CI's Swift "because a label's default Xcode can move under the same name"
  (`docs/nfdr.md:1804-1806`). A reading rule that ties a change-time verdict to that recorded value
  follows the same ground. It contradicts nothing: RN-7 makes `cargo test --workspace --locked` the
  change-time run because of where layer 5 lives, not because of where the run happens, and QC-56's
  `runs-on` rule binds CI only. The rule is set at the strict reading, the same Swift version and SDK
  as printed. Only a minor-version difference has been measured to matter (6.3 against 6.4), but the
  tart guest's 6.3.2 has not been checked against 6.3.3 on this tree beyond the one reproduction, and
  a rule that admitted patch differences would rest on that one reading. The cost is named: until a
  guest carries Xcode 26.6, no change-time run stands in for CI. The precondition in (2) has the same
  shape as the bridge-assembly precondition § 9's runner paragraph already holds (`:1562-1574`). The
  message it names is the test helper's own (`ka-reader-mac/Tests/ShellTests/LaunchWindowSupport.swift:331`).
  (c): `NativeBridge.swift` at `24be581` carries the two arms and its comment cites § 9 for CI's
  6.3.3. CI built the `#else` arm green (run 38551538187), and this Mac's Swift is 6.4. Calling it a
  stop-gap until the gate's toolchain is CI's would tie the source to how the delivery tier runs. But
  § 9's reference toolchain is itself the image's moving default, and this document names "any
  contributor who arrives with a change and no one to ask" among its readers (`docs/nfdr.md:23`).
  A stranger's Xcode is not CI's. So the pair is held for the product's sake, not the pipeline's.

  *Check 4, failure paths.* **Absent:** a run that prints no toolchain is read as not CI-equivalent,
  so it cannot pass for CI by silence. **Stale:** when the hosted image's default Swift reaches 6.4,
  the *Toolchain* clause is re-measured, and from that CI log the `#else` arm is built by nothing and
  is owed removal. That is the pair's end, stated in advance. A Swift 6.5 that disagrees again is a
  new red on whichever toolchain meets it first. **Concurrent:** green on one toolchain and red on the
  other is a red on the change for the arm that failed. CI's reading governs the recorded toolchain,
  and the 6.4 arm is honestly named as held by no hosted check. **Refused:** a window server that
  will not place windows produces a run that has read nothing. It is re-run, never counted as a pass
  and never quieted. **Not covered, named:** whether a guest VM survives a long host lock after the
  display sleeps is unmeasured (the finding says the short lock did not reproduce the morning's
  failure). The precondition does not depend on that answer, because it names the session property
  and not the remedy.

  *Close call.* I nearly answered (a) with "state the environment too". What tipped it was § 8's
  own sentence giving the execution context to the card, together with the finding's open design: a
  NFDR line naming a VM today would bind the pipeline to a remedy it has not chosen.

### 3.2 — § 8 says the card's test command does not assemble the bridge, and the card now does

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** **Fold it into `nfdr.md` § 8, with no record. § 8 quotes the card at
  `kensaiapp-opensource@d5005730`, its "does not say so yet" paragraph becomes a dated note, and RN-6
  is extended with the pin.** *Check 1:* the edit lands in § 8 and RN-6, which this seat writes, and it
  commits nobody to anything. *Check 2:* this is a correction, not a widening. § 8 states something
  that was true when written and is false now. The item's "a fold into § 8" holds. *Check 3:* I re-read
  the card at its source (`system/projects/ka-reader/project.md:8`), and its `Test command:` is exactly
  the one the item quotes. § 8's own mechanism for this case is RN-6's: it states the card as it reads
  at a pinned commit, goes false at the card's next move, and is re-pinned. § 9's runner paragraph is
  the precondition's home (`docs/nfdr.md:1562-1574`) and is still true, so it does not move. CI's order
  is untouched. No ADR is involved. *Check 4:* **Stale:** the card's next move makes § 8 false again,
  which is RN-6's accepted cost. **Empty, a fresh checkout:** the card's command now assembles the
  bridge before the Swift half, so the passage "the card's command fails on a fresh checkout" goes
  into the dated note with the rest.
  *Seen while reading, not raised:* the card's own comment on that line still says "ADR-0016, which
  superseded ADR-0009", but ADR-0020 supersedes ADR-0016. It also still says "The Swift half fails
  until the change that creates ka-reader-mac lands", and that change landed long ago. The card is
  `product-card`'s, in the managing instance, and no companion template covers it, so this run writes
  nothing there.

## Left for the owner

None this run.

## Skipped

None this run.

## Raised on this document

### 2.1 — § 9 says the tools-6.2 adoption is the tree's and not yet CI's, and CI has built it since run 38549778886

- **What the document is owed:** § 9's *Adopted* passage, "The adoption is the tree's, not yet
  CI's … a red there contradicts this clause and is not noise" (`docs/nfdr.md:1845-1849`), becomes a
  dated account. The first hosted build of the `6.2` manifest was run 38549778886, red at a source
  compile (not at the manifest load), and fixed at `24be581`. Run 38551538187 is the first green
  hosted build. The v49 words stand in a dated note.
- **Why it is worth a cycle:** the prompt's ground *A fact in it is now false*
  (`<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` § The items are
  not the whole of what a document is owed). The passage says `ka-reader@f0f1e5f` "is not on
  `origin/main`" and that "no hosted run has built the `6.2` manifest". `git merge-base
  --is-ancestor f0f1e5f origin/main` holds, and the runs above have built it. The item was appended
  under § 2, replacing that section's "None." line; the section and every other item stand as they
  were.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
