# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `adr/` and `nfdr.md` (the companion names both; the item lands in `nfdr.md` QC-67)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-12
- **Sources re-read:** None. The answer rests on the owner's answer in
  `docs/trail/architecture/cycle-87.md` § 2.1, on QC-67 at NFDR v96, and on the suites under
  `checks/tests/` at `ka-reader@528c152`, all inside this repository. No `checks/` file has changed
  since that commit (`git log 528c152..HEAD -- checks/` is empty).

## Items worked

### 2.1 — Eleven more suites run the host's `git`, `tar` or `cargo`. Do they wait until after the first public release too, like the four you named?

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** Yes, the eleven wait until after the first public release on the same terms as the four,
  and none of them holds it.

  1. **Whose call this is.** The change lands in this document, in QC-67's host-tools paragraph. The
     draft sent it back because the seat that folds the records may not widen an owner's ruling. This
     run sits in the owner's seat, so check 1 asks something else: is there a ground only the owner
     can see? None can be named. The owner's answer (`cycle-87.md` § 2.1) describes what it covers as
     "the four suites that run a real tool today". That phrase is a description, not a pick of
     four from a longer list. The number four came from a count that missed eleven suites, and the
     description covers them too. Applying a rule to what it already describes does not widen it.
     I came close to leaving this for the owner. What would have tipped it: anything in the answer
     suggesting the four were chosen for what they test, not because they were the ones known.
     Nothing in it does.
  2. **The draft's reasoning.** Its conclusion holds. One step is weaker than it reads. The
     owner's reason for waiting was that what the real tools make of a state is already proven by
     the walk on the Mac and the release build. For most of the eleven that reason does not quite
     apply, because they assert nothing about the tool's output at all. Seven use the tool only to
     build a throwaway fixture (`git init` in `test_secret_scan.sh`, `test_secret_scan_planted.sh`
     and `test_structure.sh`; `tar -xf` in `test_own_state.sh` and `test_read_only.sh`) or to check
     the suite left the tree as it found it (`git -C "$ROOT" status` in `test_notices.sh`,
     `test_renderer.sh`, `test_strings.sh` and `test_structure.sh`). Three run `cargo` on the
     product's own tree (`cargo metadata` in `test_release_version.sh`; `cargo test` in
     `test_read_only.sh`, `:L1116`; `test_offline_page.sh` requires `cargo` before it runs). That is
     the same kind of use as the four, and the release build runs `cargo` on that same tree.
     `test_readme.sh` looks up the real `git` to wrap it. So the real reason is stronger than the
     draft's: this is test hygiene with no shipped code behind it. Moving it is a change of the same
     size and kind as moving the four, and the owner put that change after the release.
  3. **What is already settled.** This contradicts nothing. QC-67 already says the scan for a host
     `git`, `tar` or `cargo` "joins the gate with the change that moves the last of them". So the
     fifteen gaps cannot turn the gate red before the release under this answer. The count was
     checked again: a search of `checks/tests/` for the three tool names finds five other files.
     In each the hit is a stand-in or text, not a run (`test_bundle.sh`'s `make_stub git`,
     `test_git_beta.sh`'s refusal stand-ins, `test_release_shape.sh`'s workflow text,
     `support/vm_refusal.sh`'s marker list, and `test_strings_step.sh` in comments only). So
     eleven is the full count.
  4. **Where the answer did not reach.** Two cases, so the answer gains two additions:
     - **Stale or new:** the allowance covers only the fifteen measured at `ka-reader@528c152`. A
       suite written or changed after this answer that runs or looks up one of the three tools
       follows the testing doctrine as written. Until the scan lands, `development-design` holds
       it to that, as QC-67 already says. Without this bound, "known gap until after the release"
       would let new gaps in under the old ruling.
     - **Absent:** in a copy of the source that is not a git checkout, such as a release's
       source archive, the `git -C "$ROOT" status` checks get no answer from `git`. They can then
       pass without checking anything. `test_strings.sh` (`:L297`) throws away `git`'s error and
       compares two empty outputs. `test_structure.sh` (`:L55`, `:L511`) compares the same error
       text captured before and after. `test_renderer.sh` (`:L932`) treats empty output as clean.
       QC-67 should name this as an uncovered case, a known gap that does not hold the release. It
       is the same fix that moves the suites off the host's `git`. `test_notices.sh` (`:L1074`) was
       not traced as far as how it ends in that case.
  - **Defect in the supporting text:** none found. The draft's suite list and locators match the
    tree at `528c152` wherever they were spot-checked (`test_read_only.sh:L1116`,
    `test_release_version.sh:L165`, `:L183`, `test_offline_page.sh:L391`, `test_secret_scan.sh:L97`,
    `test_strings.sh:L297`).

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
