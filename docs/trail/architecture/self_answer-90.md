# Self-answer report — `adr/` and `nfdr.md` (KA-Reader architecture records)

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. Both answered items bear on the NFDR (v94, Draft), and no ADR moves.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-11
- **Sources re-read:** None. This run decided no item, so no answer rests on a source.

The companion is already answered. Both of its open items have their slots filled, and nothing is
left for this run to write. Read for this run: the companion, whole; `self_answer-89.md`, whole,
which answered § 2.1; `self_answer-87.md` § *Left for the owner*, which holds the bounded answer the
owner adopted for § 3.1. Measured at `ka-reader@58bbaea`: § 2.1's slot was filled by
`ka-reader@4b62c29` (`self_answer-89.md`), and § 3.1's slot was filled by the owner in
`ka-reader@58bbaea`.

## Items worked

None this run.

## Left for the owner

None this run.

## Skipped

- **2.1 — QC-67 states the two ways a suite builds a check script's `PATH` and requires neither: whether every suite must build it from an empty environment is open** — slot already filled (`override: …`, by `self_answer-89.md`). An answered item is finished, so it was left exactly as it stands.
- **3.1 — The harness suites run the host's own `git` and `tar`, and QC-67 admits no seam for them** — slot already filled, by the owner (2026-11-11). Left exactly as it stands.

One thing the fold meets when it takes both answers together. It is recorded here and not raised
as an item, because both items are answered and this run decides nothing on an answered file. The
owner adopted the **three-part** bound from `self_answer-87.md`. Its part (3) says "every other
process the script starts stays a stand-in". Read literally, that also covers the host's shell and
its ordinary text and file tools. Today the suites link those in by name
(`checks/tests/support/vm_refusal.sh:L64` lists 37, and `test_git_beta_walk.sh:L53` lists 26).
§ 2.1's answer lets a suite link them too: "every tool on it, real or stand-in, linked in by name".
The later drafts (`self_answer-88.md`, `self_answer-89.md`) covered these tools with a separate
part 1, "the script's own language". The owner's ruling does not include that part. So the fold
must decide which reading the ruling carries:

- part (3) means every process *other than* the host `git`, `tar` and `cargo`, which would make
  every suite fake its own shell, or
- part (3) means the processes the case's subject reaches, and leaves the script's own language
  alone.

The ruling and § 2.1 agree on the second reading and disagree on the first. If the fold cannot tell
which reading the owner meant from the ruling's own words, that is an item for the owner on the
fold's next companion. It is not a reading for the fold to pick.

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
