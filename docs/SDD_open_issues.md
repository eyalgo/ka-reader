# SDD open issues — KA-Reader

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

> **How this companion came to exist.** No `product-sdd` run opened it. A `companion-self-answer`
> run opened it on 2026-10-13, in the Principal Architect's seat, while it answered
> `docs/architecture_open_issues.md` § 3.2. That item asks which change re-measures QC-25's
> hosted-runner narrowing now that CI runs on `macos-26`. QC-25 states that narrowing because § 4
> C-I3 states it, and C-I3's sentence names no image. `SDD.md` is Settled at v48 and had no
> companion on disk. Without this file, a `product-sdd` re-run would read the SDD as done and fold
> nothing. The file holds one item, § 2.1. It is in *choices to confirm* because the run that raised
> it has a lean, and its slot is left for the next round. The run's reasoning is
> `docs/trail/architecture/self_answer-46.md`.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

### 2.1 C-I3's hosted-runner narrowing of the probe names no image, though v48 dated the renderer gate's hosted readings beside it and moved CI off the image the narrowing was measured on
- **Raised by:** Principal Architect, in a `companion-self-answer` run — 2026-10-13
- **Seat:** cto
- **Drafted into the SDD:** Nothing. The run that raised this writes no document. **The proposed
  change, for the fold:**
  - C-I3's sentence "On a GitHub-hosted macOS runner that holds of the outbound half only: there the
    out-of-grant read is reported denied for the unentitled control on every ask as well …"
    (`SDD.md:L889-L894`) names the image it was measured on: `macos-14`, GitHub Actions run
    35797893381 (RN-48).
  - It says that the `macos-26` reading has not been taken.
  - It uses the dated-parenthesis form that v48 gave the renderer gate's hosted readings in the same
    clause (`:L945-L949`).

  On the NFDR's side, the answer at `docs/architecture_open_issues.md` § 3.2 makes this reading
  visible on every hosted build: the unentitled control's `out-of-grant-read:` line goes into the
  log of the `Bundle probe suite` step. If the CTO takes that, C-I3 can name where the reading is
  taken. Whether C-I3 names it is the CTO's call.
- **Rationale:** v48 moved CI from `macos-14` to `macos-26`. It folded that move into C-I3's
  renderer-gate half: "below the floor from v48 … dated readings on an image CI leaves, and the first
  hosted reading on `macos-26` is the one the change that moves CI takes". It did not fold the move
  into the probe half a few lines above, which still reads as true of any GitHub-hosted runner.
  RN-108 lists "RN-48's probe run" among the dated readings that stand, but the C-I3 sentence itself
  names no image. No `macos-26` reading exists yet: the change that moved CI (`ka-reader@fcb2e2f`)
  is on no remote branch, and `gh run list` shows no run on that image. The narrowing is
  conservative, because it removes the read denial from what the probe is taken to evidence. So the
  gap overclaims nothing. But a cold reader of C-I3 takes it as measured on the image CI now runs on.
  NFDR QC-25 traces to C-I3 under § 4's rule that the § 4 statement wins. The NFDR can therefore
  date its own copy from RN-48, but it cannot make C-I3 say so.
- **If overridden:** C-I3's probe sentence stays general, while QC-25 dates its copy to `macos-14`
  from RN-48. The NFDR then reads narrower than its source, and the next Principal Architect fold
  would have to reconcile the two or raise this again. No slice, edge, seam or *Reached when* moves
  either way. If the `macos-26` reading later shows the control's read `allowed`, the narrowing no
  longer holds on the runner, and C-I3 is restated then, whichever way this item goes.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

None.
