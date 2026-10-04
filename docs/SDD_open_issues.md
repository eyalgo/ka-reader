# SDD open issues — Nozoki

> Companion to `SDD.md`. The CTO wrote the SDD; this file holds what that run could not settle from
> its inputs (the PRD, the SRS, the UXD, and any context or constraints), and the calls that are the
> CPO's or the CDO's to make. An item whose call is the CPO's or the CDO's carries that seat's
> `Seat:`; an item whose call is the CTO's carries `cto` or no `Seat:` field.
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time `product-sdd` folds them in, it first copies this
> file whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item may name the seat that answers it.** Any item in any section carries an optional
> `- **Seat:** <seat>` field beside its other fields. Its value is the name of the agent whose posture
> answers the item — `cto`, `cpo` or `cdo`. An item with no usable value, whether the field is absent,
> empty or still the `<seat>` placeholder, is answered in the seat of the skill that produced this file.
> The field names the *answering* seat. It is not the seat that raised the item (`Raised by:` /
> `Held by:`), and it is not the document an answer belongs to.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a
> disagreement is not something one seat asked, it is two positions held by different seats, and the
> answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the SDD's lanes entirely.** §§ 1–4 are all the SDD's own three
> lane seats; § 5 is a seat that never held a lane in it, reading it long after it settled and
> finding something only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's,
> which stay fixed to the three lane seats on purpose.

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-04 from the SDD's own companion
> template. The config-named-path item's bound falls on the build in which `mac-shell` first calls
> `nozoki_read_git`, and the owner has chosen to move that bound rather than settle the item in that
> build. The SDD is Settled, and with no companion on disk a `product-sdd` re-run reads it as done
> and has nothing to act on. Its one item is in § 5.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 The config-named-path item's bound falls on the first build that calls `nozoki_read_git`; move it to a later build of `see-git-status`
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the build in which `mac-shell` first calls `nozoki_read_git`, which is the
  build that gives the shell its Git view. *Open Questions*, the config-named-path item, says the
  item is "Settled in `see-git-status`, no later than the build in which `mac-shell` first calls
  `nozoki_read_git`", and that the bound "is held by review of the change that makes the shell call
  the export" (`docs/SDD.md:L5696-L5701`). That build does not carry the fixture or its case, so its
  review cannot pass it as the item reads now.
- **Where it shows:**
  - **Three places state the bound.** *Open Questions*, the config-named-path item
    (`docs/SDD.md:L5696-L5701`); § 11 R-16 (`docs/SDD.md:L2825-L2826`); and § 10 RC-4 *Still
    unresolved*, its dated parenthesis (`docs/SDD.md:L2675-L2677`). RN-91 moved it to this build on
    2026-10-04 (`docs/SDD.md:L5576-L5583`), from "no later than the build that first exports a
    function reaching `git-reader`" (`docs/SDD.md:L5704-L5705`).
  - **Neither half of the item is in the tree yet.** The shell calls the export nowhere:
    `grep -rn 'nozoki_read_git\|read_git\|readGit' nozoki-mac/Sources` printed nothing. No fixture
    names an outside path: `grep -rn 'include.path\|excludesfile\|attributesfile' checks/fixtures`
    printed nothing. Both were run on 2026-10-04 at `nozoki@d2dd1f2`.
  - **What holds in the meantime.** R-16's own response: in the shipped bundle "the sandbox refuses
    the read", the wall is C-R2's, "so no byte outside the grant is read there". Whether libgit2's
    open or status read survives that refusal "has not been run" (`docs/SDD.md:L2821-L2823`). If it
    does not survive, the Git view shows a failed read.
  - **What is asked.** Move the bound off the build in which `mac-shell` first calls
    `nozoki_read_git`, to a later build of `see-git-status`. The item's other half, "in every case
    before the slice is reached" (`docs/SDD.md:L5698`), is not asked to move. Neither is the rest
    of the item: which of the two forms closes it, what settles it (a fixture repository whose config
    names an outside path, and a case showing that path is not read), and the rule that the second
    form is written into `git-reader`'s row and § 11 R-16 before it is built
    (`docs/SDD.md:L5698-L5703`). How the new bound is worded is the SDD's call.
  - **The NFDR repeats the bound.** QC-6 (`docs/nfdr.md:L248-L249`) and QC-35
    (`docs/nfdr.md:L938-L940`) state it as the SDD gives it. Once this item is folded, the Principal
    Architect owes the matching update to both. That update is not asked of the SDD.
  - **The route the owner chose.** On 2026-10-04 the owner chose to move the bound. The two routes
    not chosen were to settle the item in or before the build that first calls the export, and to
    waive the bound at that build's review.
- **If a document has to be written:** none. In `SDD.md`, the *Open Questions* item, § 11 R-16 and
  § 10 RC-4's parenthesis. After the fold, the Principal Architect updates QC-6 and QC-35 in
  `docs/nfdr.md`.
- **Answer:** Move it. The new bound is the half the item already carries: the config-named-path
  item is settled in `see-git-status` before the slice is reached, and no build inside the slice
  bounds it any longer. Answered in the CTO's seat by an unattended run, on the route the owner
  chose on 2026-10-04.
  - **What comes out.** The clause "no later than the build in which `mac-shell` first calls
    `nozoki_read_git`, which is the first build whose release executable links that export, and in
    every case" in *Open Questions*; the matching clause in § 11 R-16; and "It is held by review of
    the change that makes the shell call the export". § 10 RC-4's parenthesis is a dated record, so
    its words stay and it gains a second dated sentence saying the bound moved again.
  - **Why no later build is named in its place.** A third named build would be a third deadline
    that can pass unmet, and the first two both did. "Before the slice is reached" cannot pass
    unmet without the slice staying unreached, so it is the last bound there is. If the fixture and
    its case are missing when the slice's *Reached when* is claimed, the slice is not reached. The
    bound does not move a third time.
  - **Who holds it.** Still no check. It is held by review of the change after which
    `see-git-status`'s *Reached when* is claimed whole. The item says so in those words.
  - **What the item must now say about the meantime.** From the first build in which the shell
    calls the export until the item is settled, the bundle opens a reader's own repositories with
    the item open. R-16's response stands for those builds: the sandbox is the only bound (§ 4
    C-R2), and whether libgit2's open or status read survives its refusal has not been run. A
    repository whose config names an outside path may therefore show a failed Git item, which
    S-4's observable half already draws. The 2026-10-04 note "Until the shell calls the export the
    bundle opens no repository" stays as a dated record and gains a dated sentence after it, so it
    is not read as the current state.
  - **What does not move.** Which of the two forms closes the item, what settles it (the fixture
    and its case), and the rule that the second form is written into `git-reader`'s row and § 11
    R-16 before it is built. No slice's *Reached when*, *Delivers*, § 7 edge or order moves, so
    this is a dated correction and not a § 10 re-cut.
  - **The NFDR.** QC-6 and QC-35 are carried at `docs/architecture_open_issues.md` § 2.1
    (`nozoki@250fc6e`), for the Principal Architect. Nothing is asked of the SDD there.

  Reasoning: `docs/trail/sdd/self_answer-39.md`.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
