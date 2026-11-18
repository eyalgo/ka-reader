# Self-answer report — SDD

## Header

- **Companion:** `docs/SDD_open_issues.md` — live: its header names `SDD.md` as a bare filename and `docs/SDD.md` is its sibling on disk; tracked under that exact name (`git ls-files docs/ | grep -i open_issues` lists `docs/SDD_open_issues.md` and `docs/architecture_open_issues.md`), and clean in the working tree (`git status --short docs/` prints nothing). No line of the companion changed this run.
- **Document:** `docs/SDD.md` (v89, Settled). The companion was opened by the PM on 2026-11-18 at `ka-reader@60f82e7` with two items under § 5 *Raised from downstream*, both seated `cto`. The invocation listed no items.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-18
- **Sources re-read:** None. This run wrote no answer, so no answer rested on a source outside this repository. Read in this repository, at `aee7684` (`main`): the companion whole — its header's slot labels (**Answer** / **Confirm or override** / **Keep or re-cut** / **Your call**), its five `## ` sections, §§ 1–4 each reading "None.", and § 5's two items, whose `**Answer:**` slots at `:L47` and `:L56` each carry a written answer ending "Reasoning in `docs/trail/sdd/self_answer-98.md`"; a scan for an angle-bracket placeholder in the file finds none outside the two `<owner>/<repository>` platform names inside § 5.1's answer; `git show --stat aee7684`, the commit "SDD open issues answered — 2 of 2 items", which carries `docs/SDD_open_issues.md` and `docs/trail/sdd/self_answer-98.md` together; `docs/trail/sdd/self_answer-98.md` whole, the round that wrote both answers; `docs/SDD.md:L1-L12`, its status and version lines; `git log --oneline -5`, whose tip is `aee7684` and which lists no `product-sdd` fold after it. Observed and left as found: an untracked `features/` folder at the repository root (`git status --short` prints `?? features/`), outside this run's files; nothing was staged from it.

## Items worked

None this run.

## Left for the owner

None this run.

## Skipped

- **5.1 — § 3's `read-only-harness` row is behind the tree after the README picture's capture and check** — its **Answer** slot is already filled: *confirmed with addition*, written by the previous round (`docs/trail/sdd/self_answer-98.md`, commit `aee7684`, 2026-11-18). A filled slot is an answer already given and is left exactly as it stands; the answer waits on `product-sdd`'s fold, which has not run since.
- **5.2 — The SDD cites the README's stack and proof sentences by line numbers that hold other text** — its **Answer** slot is already filled: *answered*, written by the same previous round (`docs/trail/sdd/self_answer-98.md`, commit `aee7684`, 2026-11-18). Left exactly as it stands, for the same reason.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
