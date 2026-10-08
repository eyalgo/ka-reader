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

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 Accept ADR-0022: `git-reader` refuses a repository whose Git config, `.gitmodules` or alternates file names a location outside the folder, by a check of its own
- **Lands in:** both — `adr/0022-git-reader-refuses-a-repository-whose-config-names-a-location-outside-the-folder.md`,
  and `nfdr.md` QC-6, QC-15, QC-30 and QC-35, which trace to it marked *Proposed*.
- **Drafted into the records:** ADR-0022, written at **Proposed**. It records one decision the SDD
  settled between v39 and v42 in the CTO's seat (SDD RN-99 – RN-102), which ADR-0020 left to the
  SDD's *Open Questions*. Four of its parts were surfaced for this seat to record:
  - the adapter reads every file in § 11 R-16's domain itself, inside the folder, and refuses
    rather than follows;
  - a value in a form it does not locate (`~/`, a relative excludes or attributes file, a
    `.gitmodules` section path beginning `/`) refuses as *not located*, and locating it through the
    home directory was not taken;
  - `submodule.<name>.path` in `.gitmodules` is a member of the domain;
  - a section that would make the status read open or report another location refuses the read,
    and verifying that location was not taken.

  Eight alternatives are ruled out, each the SDD's own. The record does not supersede ADR-0020,
  whose switch stands. The NFDR entries are written from the SDD whichever way this item is
  answered (`nfdr.md` RN-53). Only their trace to the record is marked *Proposed*.
- **Rationale:** the decision clears all three gates.
  - **Hard to reverse.** The refusals cross SM-2, SM-4 and SM-8 with sentences `docs/CONTENT.md`
    publishes, and undoing the check reopens `docs/fdr.md` R-101 in the in-process harness.
  - **Surprising without context.** A repository that `git status` reads in a terminal shows a
    failed Git item here, and the adapter parses Git's config syntax beside libgit2.
  - **A real trade-off.** The record names what a reader pays and what is not built at
    `ka-reader@076eac2`: the alternates check, the section-path refusals and the refusal on the
    submodule map.

  This seat records the decision and does not make it. What is put to you is whether the log
  carries it as Accepted.
- **If overridden:** ADR-0022 stays Proposed, or is revised while still Proposed, and the four
  NFDR traces to it go with it. No entry's obligation moves, because each derives from SDD v42 and
  not from the record. If you judge the decision itself wrong, it is the CTO's lane, and the route
  is an item on `docs/SDD_open_issues.md`, not an edit here.
- **Confirm or override:** confirm, with one addition. Accept ADR-0022 as it stands, with two
  sentences of its *Decision* scoped to what `docs/SDD.md` v42 says before the status moves.
  ADR-0022 is still Proposed, so this costs nothing now, and an accepted record can never be edited.
  (a) ADR-0022 `:L52`, "An `includeIf` path refuses whatever its condition", should cover only an
  `includeIf` path that spells outside the folder or is in a form the adapter does not locate.
  That is how SDD § 11 R-16 scopes it (`docs/SDD.md:L3163-L3165`), and an inside `includeIf` is
  followed. (b) ADR-0022 `:L55-L56`, "never the read-failed condition", should cover a refusal of a value.
  The sentence should also say that a file the check cannot read answers the existing condition
  for an unreadable Git directory, and that a config it cannot parse to the end answers the
  read-failed condition. SDD § 3's `git-reader` row and § 11 R-16 (`docs/SDD.md:L3114-L3116`) state both.
  Neither change moves a decision, an alternative or an NFDR obligation. Reasoning:
  `docs/trail/architecture/self_answer-42.md`.

## 3. Raised from downstream — an item from a seat that did not write these records

None.
