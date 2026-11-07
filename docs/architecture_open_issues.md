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

### 2.1 QC-10's setting-aside narrows to building `FolderContainment`, the model's reads are held to SM-1's read seam, and QC-69 binds that seam's one fake and one contract suite as owed
> Raised by a `companion-self-answer` run on 2026-11-07, which answered the PM's item on QC-10's
> three lists and read SDD v74 (Settled) as QC-10's input. That item is folded at NFDR v82 and its
> answered file is `docs/trail/architecture/cycle-73.md`. This item was left unanswered, so the run
> that folded the other one drafted it into the records, as the item's own lean proposed.
- **Lands in:** `nfdr.md` QC-10 (the setting-aside paragraph, its three bounds, its review clause
  and its trace) and QC-69 (new)
- **Drafted into the records:** NFDR v82, RN-92.
  **QC-10.** `folder-model` now reaches `fs-reader` in two ways, bound differently. Its reads cross
  SM-1 in the form SDD v74 § 2 *One read seam beside the decline* states: a trait in `fs-reader`,
  with the real reader handed in from the composition roots. Which reads cross is SM-1's cell to
  name. The setting-aside of the Rust packet's "a unit is given its collaborators through a trait"
  now covers only the building of `FolderContainment`. Bound (1) names SM-1's trait beside SM-2's.
  Bound (3) watches both § 2 paragraphs. Until the trait is built, `development-design` fails a
  change that adds a direct read from `folder-model` into `fs-reader`, or has the model build a
  reader for itself. That review gate's downgrade is argued in the tail: the trait's name is the
  building change's, so no scan pattern exists yet.
  **QC-69.** The read seam has one production implementation, one fake and one contract suite.
  It is written as owed, the way QC-50 was. Its suite, its `impl` grep and
  `git grep '0o000' -- crates` printing nothing all hold once the seam is built, and none holds at
  `ka-reader@98aaa71` (37 `0o000` lines in 13 files). The building change names the suite and the
  grep pattern, and adds the § 10 row.
- **Rationale:** QC-10's bound (3) said the setting-aside "loses its ground and is re-opened" if
  the SDD's decline paragraph moved, and at v74 it moved. The decline now covers only the building
  of the walk, and SM-1's read seam stands beside it (SDD RN-154). The SDD names QC-10 as the one
  entry the move reaches and leaves the re-opening to this seat (`docs/SDD.md:L441-L444`). Every
  part of the draft is fixed by SDD v74 § 2 and SM-1, so it is derived rather than decided. It is
  here because it was raised as a choice and has not been answered.
- **If overridden:** QC-10 goes back to v81's setting-aside, and QC-69 is withdrawn: marked
  withdrawn in place, never deleted, and its number never reused. No record supersedes, because no
  ADR moved. QC-10 then rests on a paragraph SDD v74 no longer holds. The change that builds the
  read seam would meet an entry that still allows the free-function calls that change removes, and
  nothing would bind the seam's fake to a contract suite.
- **Confirm or override:** override: take QC-10 as drafted and QC-69 as drafted, except QC-69's
  third verifier. Replace "`git grep -n '0o000' -- crates` printing nothing" with "no case whose
  failed read crosses SM-1 forces it with a file mode", checked by a `git grep` over the files the
  building change names. At `98aaa71` those are 23 of the 37 lines, in 8 files. The other 14 lines,
  in 5 files, sit where SM-1 cannot reach: the Git adapter (12), the containment walk (1) and the
  bridge log writer's write (1). QC-69's trace names that the SDD sentence it narrows is raised at
  `docs/SDD_open_issues.md` § 2.1. Reasoning: `docs/trail/architecture/self_answer-77.md`.

## 3. Raised from downstream — an item from a seat that did not write these records

None.
