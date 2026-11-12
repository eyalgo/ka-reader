# Self-answer report — `adr/` and `nfdr.md` (KA-Reader architecture records)

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The companion's one item bears on the NFDR (v95, Draft): QC-72, and QC-67's "a host tool QC-72 admits". No ADR moves.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-12
- **Sources re-read:** None. This run decided nothing, so no answer rests on any source.

Read for this run: the companion, whole, at `ka-reader@95b6a72`; the commit that filled its one slot,
`ka-reader@0c91610`; `self_answer-91.md`, the previous run's report on this companion; and NFDR v95's
version line and the places that name QC-72.

**The companion is already answered.** § 2.1 holds the owner's own answer: override, written
2026-11-12 and committed at `ka-reader@0c91610`. The owner withdraws the host-tools departure. The
check suites follow `testing_doctrine.md` § *A test reads nothing of the machine it runs on* as
written. The shell and its ordinary text tools count as the suite's own interpreter. The four suites
that run a real tool are known gaps until a change after the first public release moves them. QC-72
is withdrawn, not widened. §§ 1 and 3 read "None." So no slot is still at its placeholder, and this
run has nothing to write into the companion. The companion is unchanged.

## Items worked

None this run.

## Left for the owner

None this run. The one item the previous run left for the owner (`self_answer-91.md` § 2.1) is now
answered by the owner.

## Skipped

- **2.1 — Does your host-tools ruling also cover the shell and text tools a check script is written in?** — The slot is already filled with the owner's answer (override, 2026-11-12, `ka-reader@0c91610`). A filled slot is an answer already given, so this run left it exactly as written. 1 item skipped for this reason.

## Companions opened

None this run. The owner's answer lands in the NFDR alone: QC-72 is withdrawn, QC-67's "a host tool
QC-72 admits" and § 10's QC-72 row and review-gate entry follow it, and the four real-tool suites
become known gaps. No upstream document is owed a change. The SRS, SDD and FDR say nothing about which
tools a check suite may run. `testing_doctrine.md` is not changed either, because the owner's answer
keeps it as written.

This run also raises nothing on the records themselves. The one fact in them that is now out of date
is QC-72 and what points at it, and that is exactly what the owner's answer already asks the next
fold to change. A second item for it would ask the same question twice.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
