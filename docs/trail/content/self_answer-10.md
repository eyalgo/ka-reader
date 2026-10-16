# Self-answer report — `docs/CONTENT.md`

## Header

- **Companion:** `docs/CONTENT_open_issues.md`
- **Document:** `docs/CONTENT.md`
- **Decided by:** `companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-16
- **Sources re-read:** `system/experience/voice_restrictions.md` in kensaiapp-opensource, the instance
  whose verbal rules bind this product. Answer 3.1 rests on what it says about its own reach. Read in
  full on 2026-10-16: § 1 lists the surfaces as the README, the install and first-run text, `--help`
  *"and every other text a command emits"*, the output, the text a failure prints, and the prose a
  product addresses to a would-be contributor. Its entries `no-unestablished-state` and
  `failure-says-what-next` each reach *"every surface listed in § 1"*. It also says a product's own
  documents may tighten an entry and may not loosen one. `system/doctrine/writing_bar.md` was read for
  anything that scopes a document's reader; it says nothing on a build script's output.

## Items worked

### 3.1 — Whether the standard reaches the lines the `checks/` harness prints, which now carry a banned word

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the verbal language
- **Verdict:** answered
- **Why:** The harness's output is outside `CONTENT.md`, and *refused* on the six virtual-machine
  lines stands. The item had no draft, so this is answered from scratch. It cites its occurrences
  (six lines, plus two timeout lines, each with a path, line and commit), so the rule that a
  downstream item with no occurrence waits until it occurs does not apply.
  - **Check 1.** The item is this document's, in the owner's seat. The answer is one scope sentence in
    `CONTENT.md`, and nothing moves in another document. It commits no person, money or risk, and the
    answer holds whether or not the project invites contributors, so the CPO's call on that does not
    gate it. The item looks like two questions, scope and three consequences, but the three
    consequences hang on the scope answer, so it is one question with one seat and one slot.
  - **Check 2.** The item's framing is sound. It asks the right question and says what answer it needs.
    Its supporting text is accurate: the six refusal lines and the two timeout lines read at the cited
    places as described.
  - **Why outside.** (1) The standard binds the words KA-Reader writes to the person it was pointed at
    a folder for: `docs/CONTENT.md` § Voice limits the rules to the frame, "labels, status messages,
    failure text, the README, and any text a release carries". The app bundle carries none of the
    harness: `checks/bundle.sh` fails a bundle that holds a copy of any tracked file under `checks/`
    (`checks/bundle.sh:L274-L281`), and the app never shows these lines. (2) The grounds of the rules
    that would bite do not hold for this reader. *Refused* is banned because it describes the reader's
    own material by its failure to satisfy the machine, in a product that promises never to refuse a
    file (`docs/CONTENT.md` § Terminology, *Banned*; `docs/SRS.md` FR-29). On these lines the script
    describes its own decision about the host, in the word `docs/nfdr.md` QC-65 uses for the same act
    ("refuses", "the refusal"), and the suite is named for it (`checks/tests/test_vm_refusal.sh`). The
    reading bar's four sources cannot hold either: a message about `sysctl` and a virtual machine uses
    words that are none of README, folder, Git or § Terminology. (3) The reader is a contributor or a
    build log: QC-65 says "a contributor with no virtual machine runs every step but these".
  - **Where the line falls.** The test is where the text goes, not which directory holds it, so a line
    that ever reaches the bundle or the screen is in scope whatever file it came from. That is check
    4's *stale* case, where a harness string moves into the product. The scope sentence is written for
    scripts under `checks/` and their suites because those are the cited occurrences; text printed by
    anything else in the repository, such as `scripts/` or the workflow file, waits until it occurs.
  - **What check 3 found.** Nothing in `CONTENT.md` contradicts the answer. `docs/CONTENT.md` § Voice,
    RN-1 and RN-15 are consistent with it. The README mentions the harness once, in its Stack
    paragraph, as a claim about what it proves; it never tells a reader to run it, so no adopter-facing
    sentence points at harness output. The instance's voice restrictions are a separate matter: they
    reach "every other text a command emits" by their own § 1, they bind below `CONTENT.md`, and a
    product document may not loosen them. So the scope sentence is written to say what this document's
    rules do not reach and to leave the fence's reach to the fence. A sentence saying the harness is
    outside every rule would loosen it, and that is the one wrong shape here.
  - **The three forms that hang on it.** Identifiers (the app, `docs/nfdr.md QC-65`, the log path) need
    no rule; the fence's `failure-says-what-next` even counts a log's path as a next action. The `ci:`
    prefix on the two timeout lines, which also run by hand, and the absence of a next step there are
    not rules for this document. They are defects of the two scripts if the fence reaches them, and a
    script change is the PM's to carry through the journey, not a `CONTENT.md` fold. This answer does
    not decide that the fence reaches the harness; it says only that `CONTENT.md` does not stand in
    its way.
  - **Check 4.** *Empty*, *concurrent* and *refused* have nothing to attach to: the answer is a scope
    sentence. *Absent*: the fence file was reachable and read. *Stale* is covered above. One case is
    named and left uncovered: the app's own log (`ka-reader.log`), which `checks/launch.sh` reads. It is
    written by the app and not shown by it, and no item asks about it, so it waits until a string in it
    is in question.
  - **Close to a different verdict.** The nearest alternative was to bring the harness under
    `CONTENT.md` in part, the next-step and observed-state rules only. It lost because those two rules
    are the fence's entries already, and a copy in this document is a rule with two homes. What would
    tip it to "in scope": a README sentence telling an adopter to run a check as a step of installing
    or trying the tool, because then an adopter-facing path would pass through the harness.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/CONTENT.md`** — `/Users/eyalgolan/.kensaiapp/pins/20261016T211916Z-6zj7bz/core/launchers/skill/launcher.sh product-content ka-reader`
