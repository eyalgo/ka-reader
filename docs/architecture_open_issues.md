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

### 2.1 QC-56 says its workflow runner check is held by no script, and a suite has held it since `ka-reader@13e8d42`

> A `companion-self-answer` run raised this item on 2026-10-20, while it answered the three § 3 items
> of the last cycle (`docs/trail/architecture/self_answer-53.md` § *Raised on this document*). The
> `product-architecture` run at NFDR v58 drafted it into the records.

- **Lands in:** `nfdr.md` QC-56, its *verified by* tail (`docs/nfdr.md:L1595-L1609`), and § 10's QC-56
  row (`:L2299`). No ADR.
- **Drafted into the records:** at v58 (RN-69), QC-56's tail names
  `checks/tests/test_vm_refusal.sh`'s `test_every_runner_names_macos_26` as the suite that runs its
  runner comparison, a step of the gate (`checks/gate.sh:L77` at `ka-reader@8b93322`). The case runs the
  tail's own `grep -h -E '^[[:space:]]*runs-on:'` over `.github/workflows/*.yml`, with the same
  `macos-26` pattern, and also fails when no workflow names a runner, which the command does not. The
  gate stays `development-design` until the card's command runs the script (§ 8, *Until the card runs
  the script*). Its ground moves from "held by no script" to that run gap. Release inspection keeps its
  reading. § 10's row names the case beside the command, marked as drafted. The entry carries the v57
  words in a dated note.
- **Rationale:** a fact in the NFDR was false. The case is in the suite at `ka-reader@13e8d42`
  (`:L211-L216`), and v57 pinned the guarded set at that commit. It is unchanged at `8b93322`. In a
  disposable clone of `8b93322`, re-run for v58, the suite passed 9 of 9. With `runs-on: macos-26`
  changed to `macos-latest`, it failed that one case with "a runner other than macos-26", 8 of 9. It
  derives from SDD § 4 C-R5's workflow case, as the entry already traces. It is drafted rather than left
  out because v58 folds the same correction into QC-64 and § 9 on the owner's seat's answers. Left out,
  QC-56 alone would deny a check that two other entries name.
- **If overridden:** QC-56's tail and § 10's row go back to their v57 words, "held by no script". A
  contributor then reads the gate as review-only when a suite holds it. A change that drops the case
  from the suite goes unnoticed, because the NFDR does not name the case as the check. No record moves
  either way.
- **Confirm or override:** confirm, with two additions. (1) The tail's check and the suite case both read only `.github/workflows/*.yml`. GitHub runs a workflow file ending `.yaml` as well, so a second workflow such as `release.yaml` with `runs-on: macos-latest` passes both while breaking QC-56. The tail says so, and names `development-design` reading the entry as the gate for a workflow file ending `.yaml`. That gate stays even after the card's command runs the script, because the gap is in what the case reads, not in whether a run issues it. (2) The sentence after the tail, "At `ka-reader@d6405e2` the tree meets neither half … prints `runs-on: macos-14`", is re-measured at `ka-reader@8b93322`, where the tree meets both halves: `ka-reader-mac/Info.plist` holds `26.0`, `Package.swift` names `.macOS(.v26)`, the workflow's one runner is `macos-26` (`ci.yml:L18`), and the suite passes 9 of 9. The `d6405e2` words go into a dated note. Reasoning in `docs/trail/architecture/self_answer-54.md`.

## 3. Raised from downstream — an item from a seat that did not write these records

None.
