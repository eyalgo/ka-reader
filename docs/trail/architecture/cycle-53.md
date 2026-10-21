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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-21, from a
> `shukuba-refine` review on the seed `ka-reader · nemawashi · 2026-10-01_ci-and-harness-to-their-bar`,
> to carry item 3.1 below. The NFDR is Settled, so without a companion it would reach no one.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-2's three locators into `checks/read-only.sh` no longer name what they cite
- **Raised by:** PM — 2026-10-21
- **Which record:** `nfdr.md` QC-2, the walk-fixture sentence (`docs/nfdr.md:L100-L102`).
- **Tracked by:** `ka-reader · nemawashi · 2026-10-01_ci-and-harness-to-their-bar`
- **What it blocks:** nothing. A reader following the locators lands on the wrong lines.
- **Where it shows:** QC-2 cites the in-place restore at `checks/read-only.sh:L73-L76`, and what is
  hashed at `:L17-L20` and `:L84`. None of the three is pinned to a commit. At `ka-reader@c268945`
  `:L73-L76` is the usage refusal, the hashing header is at `:L19-L22`, the restore is `restore()` at
  `:L210` with its header at `:L24-L29`, and the first hash is at `:L368`. The restore now unpacks the
  archive in scratch space, copies in only the entries the fixture lacks, and removes them once the
  verdict is taken (`:L31-L36`). So it still builds a walk fixture whole for the walk, and QC-2's
  sentence still holds. Only its locators moved.
- **If a document has to be written:** none. The fold would pin the three locators to a named commit.
  The sentence's claim does not change.
- **Answer:** Confirmed, with additions. Fold the three locators pinned to `ka-reader@c268945`, the merge that
  landed the restore change; the tree outside `docs/` has not moved since (`git diff --stat c268945 b5c8042 -- . ':!docs'`
  prints nothing). (1) The locators: the restore is `restore()` (`checks/read-only.sh:L210-L252`, its header
  `:L24-L29`), and what it lays down is removed once the verdict is taken (`:L31-L36`); what is hashed is
  every entry under the fixture and nothing above it (`:L19-L22`; `manifest()` at `:L45-L65`), once after
  the restore (`:L368`) and once after the walk (`:L389`). (2) The label, which the item did not raise:
  QC-2 calls it "the script's in-place restore" twice, in the walk-fixture sentence (`docs/nfdr.md:L101`)
  and in the `git_state.rs:L787` sentence (`:L116`). Drop "in-place" from both. The SDD, whose C-I3 QC-2
  traces to, dropped the same label on the same facts at v56 (`docs/SDD.md:L824-L829`, `:L2103`;
  `docs/trail/sdd/cycle-51.md` § 5.1), because the archive is now unpacked in scratch space and only the
  entries the fixture lacks are copied in. Keeping it would leave the NFDR naming the mechanism one way and
  its input another. The sentence's claim stands: the restore still builds the walk fixture whole before
  the first hash, so a scene whose Git directory lies outside the folder is still not a walk fixture. No
  ADR is written, and no `QC` is added or renumbered. Reasoning: `docs/trail/architecture/self_answer-55.md`.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
