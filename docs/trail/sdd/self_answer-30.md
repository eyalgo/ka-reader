# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-01
- **Sources re-read:** None. This run decided no item, so no answer rests on an outside source.

## Items worked

None this run. The companion on disk carries no item: each of its five sections reads "None."
(`docs/SDD_open_issues.md:L35`, `:L39-L41`, `:L45`, `:L51`, `:L55-L57`). No slot in the file is at
its placeholder, so there was nothing to decide and nothing was written into the companion.

## Left for the owner

None this run.

One thing here needs a person, and it is not a companion item. **`product-sdd` run 21 folded this
companion and never closed.** What is on disk:

- `git -C /Users/eyalgolan/products/nozoki status --short` prints ` M docs/SDD.md`,
  ` M docs/SDD_open_issues.md`, and `??` for `docs/trail/sdd/cycle-18.md`, `run-21.md` and
  `run-21.state.json`. The fold is in the working tree and in no commit. `HEAD` is `24d652b`.
- `docs/trail/sdd/run-21.state.json` reads `"ended": null`, `"round": 2`,
  `"companion_retired": false`, an empty `turn_log`, and 14 entries under `interruptions`. Its
  `pending_request.cto` opens "CTO, round 2 (turn given a fourteenth time) — no edit and no new
  checks. The run is still looping on the runner's helper".
- No runner is alive. `ps -Ao pid,etime,command | grep -E 'sddloop|sdd_run|sdd_seat|product-sdd-runner|sdd-nozoki'`
  at 15:38 CEST printed two `claude --print` sessions, this one (pid 9633) and a `senior-engineer`
  run (pid 77006), and no runner, helper or seat process. `/tmp/sddloop.sh` is still on disk.
- The cause and the recovery are recorded at
  `docs/findings/2026-10-01_sdd-runner-loop-resumes-every-pass.md` in the instance
  (`kensaiapp-opensource@dc7e8d2`): "stop the helper, then drive the loop from `next` without
  `resume`".

So `docs/SDD.md` holds the seats' round-1 edits uncommitted, its header still reads
`**Status:** Settled` and `**Version:** 22` (`docs/SDD.md:L3`, `:L9`), and the companion that lists
no item was not deleted. Closing run 21 is the runner's, and this run touched none of its files.

## Skipped

None this run. The file has no `###` entry to skip.

For the record, both items the committed companion held were folded by run 21's round 1
(`docs/trail/sdd/run-21.md:L46-L48`), and both stand whole at `docs/trail/sdd/cycle-18.md`:

- **5.1**, the grammar-engine question, carried the answer `self_answer-29.md` wrote (commit
  `d5b5f2e`).
- **2.1**, the two stale sentences in § 12, was raised by that same run and its **Confirm or
  override** slot was still at its placeholder when the seats folded it. The companion says so
  itself: "The item whole, with its slot unfilled, stands at `docs/trail/sdd/cycle-18.md` § 2.1"
  (`docs/SDD_open_issues.md:L41`). Nobody confirmed or overrode it. The seats took the draft
  change as written, as RN-80 and RN-81.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh nozoki`
