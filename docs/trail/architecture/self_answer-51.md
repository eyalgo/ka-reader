# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (v52, Draft). The one open item reaches `docs/nfdr.md` § 9 only.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-14
- **Sources re-read:** GitHub Actions and the repository's own history, read at the source and not
  taken from the item. `gh run list --repo kensaiapp/ka-reader --workflow ci.yml --limit 25` lists
  every run since 2026-10-02. The only runs created after `f0f1e5f` was committed (2026-10-14T10:06Z)
  are 38549778886 (`47e8e6b`, `failure`), 38551538187 (`24be581`, `success`) and 38577309118
  (`f357008`, `success`). The heads of the runs before them — `3f7a68d`, `1ea3595` (a branch run) and
  `4601cd9` — do not carry `f0f1e5f` (`git merge-base --is-ancestor f0f1e5f <head>` exits 1), and
  each has `// swift-tools-version:5.9` at `ka-reader-mac/Package.swift:L1`. `gh run view 38549778886
  --json headSha,conclusion,jobs` gives head `47e8e6b` and conclusion `failure`. Its steps are
  `Toolchain` success, `Build the workspace` success, `Build KA-Reader.app` failure, and every step
  after that skipped. Its `--log-failed` output prints `NativeBridge.swift:24:9` and `:28:9`, both
  `error: expression uses unsafe constructs but is not marked with 'unsafe' [#StrictMemorySafety]`.
  Its `Toolchain` log prints `Apple Swift version 6.3.3 (swiftlang-6.3.3.1.3 …)`, `Target:
  arm64-apple-macosx26.0` and SDK `26.5`. `gh run view 38551538187` gives head `24be581…` and
  conclusion `success`. `git diff --stat 47e8e6b 24be581 -- ka-reader-mac crates .github` lists
  `ka-reader-mac/Sources/KAReader/NativeBridge.swift` alone. `f0f1e5f`, `47e8e6b`, `24be581` and
  `f357008` are all ancestors of `origin/main`, which is at `f357008`.

## Items worked

### 2.1 — § 9 said the tools-6.2 adoption was the tree's and not yet CI's; CI has built it since run 38549778886

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed
- **Why:** I took the draft as it stands. Every claim in it held when I read it at the source.
  **Check 1 — seat:** this is mine to answer in the owner's seat. The change is a sentence in
  `docs/nfdr.md` § 9's *Adopted* passage, and the passage is already drafted there at v52. It
  commits nobody to anything. It only makes the document agree with hosted CI and the tree, which
  is the ground RN-54 to RN-63 rest on. No other document owes a change: the SDD mentions the
  tools-6.2 departure only as history (`docs/SDD.md:8181`), and the FDR and SRS do not mention it.
  **Check 2 — is the draft sound, and for the reason it gives:** yes. The old words, "the adoption
  is the tree's, not yet CI's", are false now. `f0f1e5f` is on `origin/main`, and three hosted runs
  have built the `6.2` manifest. The draft says 38549778886 is the *first* of them, and that is the
  one claim the item did not measure itself. I checked it: no earlier run's head carries `f0f1e5f`,
  and each of those heads still has the 5.9 tools line (Sources re-read). The draft also argues that
  the first run's red did not contradict v49's "a red there contradicts this clause", and that holds
  for the reason it gives. v49's clause was about the manifest loading on the hosted Swift. The run
  got past manifest resolution and the Rust build, and failed while compiling a Swift source file.
  The fix, `24be581`, touched that one source file and no manifest. So the adopted
  `.strictMemorySafety()` setting was doing its job, catching a spelling that 6.3.3 rejects. The
  adoption was never wrong. I was close to *confirmed with addition*, for one point: run
  38577309118 being green too. The document already says that (`docs/nfdr.md:L1890`), even though
  the item's own summary leaves it out, so there is nothing to add.
  **Check 3 — does it contradict anything settled:** no. The passage agrees with the *Toolchain*
  clause's two-compiler pair (`docs/nfdr.md:L1853-L1866`), which cites the same run, step and lines.
  It agrees with the runner paragraph and with RN-63's measured account. No ADR names a compiler
  version, which RN-63 records, so no record moves.
  **Check 4 — failure paths:** *stale*. "Is on `origin/main`" and "first hosted build" are dated
  facts about history, and history only changes if someone rewrites `main`. *Absent*: GitHub keeps
  Actions logs for a limited time, so the run ids may stop opening one day. The passage does not
  depend on that, because it quotes the head, the step and the error lines in its own words, so a
  later reader still has the facts without the log. I'm naming this as a case the passage does not
  cover, not raising it as a change: the whole document cites runs this way, and nothing requires a
  different convention. *Concurrent / refused*: nothing here applies, because the item records past
  runs and nothing acts on its answer.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
