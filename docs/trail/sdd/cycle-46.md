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

> **No `product-sdd` run wrote this file.** The Principal PM opened it on 2026-10-14, from the
> `nemawashi-refine` run answering the retired seed
> `ka-reader · nemawashi · 2026-10-14_the-hosted-suite-prints-the-sandbox-control`, to carry items
> 5.1 and 5.2 below. § 4 C-I3 says the first `macos-26` readings are "recorded here when read, by a
> later item", and both have now been read. The SDD is Settled, so without a companion they would
> reach no one.

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

### 5.1 C-I3's first `macos-26` bundle-probe reading has been taken, and the clause still says it has not
- **Raised by:** Principal PM — 2026-10-14
- **Seat:** cto
- **Tracked by:** no seed. It was raised while answering the retired seed
  `ka-reader · nemawashi · 2026-10-14_the-hosted-suite-prints-the-sandbox-control`, whose walk produced the reading.
- **What it blocks:** nothing. But the clause now describes a not-yet that no longer holds. § 4 C-I3
  (lines 896–905) says "the `macos-26` reading has not been taken". It also says "the first `macos-26`
  reading is that line in the log of the first hosted run on `main` that holds `970ad65` and concludes
  with *Bundle probe suite* `success`… it is recorded here when read, by a later item". That run
  exists. GitHub Actions run 38577309118 on `main` at `ka-reader@f357008` was created
  2026-10-14T14:04:45Z. Its image is `macos-26-arm64` 20260907.0351.1 on macOS 26.6.2 (25G83). It
  holds `970ad65` (`git merge-base --is-ancestor 970ad65 f357008` → true), and its *Bundle probe
  suite* step concluded `success`. On that run, `docs/nfdr.md` QC-25's command
  `gh run view 38577309118 --repo kensaiapp/ka-reader --log | awk -F'\t' '$2 == "Bundle probe suite" && /out-of-grant-read:/'`
  prints `out-of-grant-read: denied`.
- **Where it shows:** § 4 C-I3, the probe half, lines 896–905: the ground for the untaken
  `macos-26` reading, and its "recorded here when read" sentence. Measured at `ka-reader@f357008`.
- **If a document has to be written:** none. This is a fold into `SDD.md`. The NFDR's QC-25 records
  the same reading on its own side. That is raised separately in `docs/architecture_open_issues.md`
  § 3.1, because what QC-25 says belongs to the Principal Architect.
- **Answer:** Record it. The first `macos-26` reading of the probe half is taken: GitHub Actions run
  38577309118 on `main` at `ka-reader@f357008`, created 2026-10-14T14:04:45Z, image `macos-26-arm64`
  20260907.0351.1 (macOS 26.6.2, 25G83), the first hosted run on `main` that holds `ka-reader@970ad65`
  and concludes *Bundle probe suite* `success`; QC-25's command on its log prints exactly one line,
  `out-of-grant-read: denied`. So the clause's "has not been taken" sentence and its ground become a
  dated account, and the reading is recorded in C-I3 under the clause's own rule: a `denied` reading
  leaves the hosted-runner narrowing standing, re-dated with the run id and the image version — the
  runner's wall is evidenced by the sandboxed report and the outbound denial, and the read denial
  separates nothing there, now on `macos-26` as it did on `macos-14` (RN-48). Nothing is lifted and
  no part moves. Per § 4's two-stores rule, what QC-25 says of the same reading is the Principal
  Architect's, carried by `docs/architecture_open_issues.md` § 3.1 — this answer does not reach into
  it. Reasoning: `docs/trail/sdd/self_answer-58.md` § 5.1.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.

### 5.2 C-I3's first `macos-26` renderer-gate reading exists, and RN-110 says it is owed an item of its own
- **Raised by:** Principal PM — 2026-10-14
- **Seat:** cto
- **Tracked by:** no seed. It was raised while answering the retired seed
  `ka-reader · nemawashi · 2026-10-14_the-hosted-suite-prints-the-sandbox-control`.
- **What it blocks:** nothing. RN-110 (lines 8287–8291) records that "the first hosted renderer-gate
  reading on that image… now exists in run 38501500758's log and is not read by this fold… it is
  owed to an item of its own". No item carries it, so this is that item. § 4 C-I3's renderer half
  (lines 981–983) says "the first hosted reading on `macos-26` is the first hosted run that reaches
  this gate on that image". That run is GitHub Actions run 38501500758 on `main` at
  `ka-reader@3f7a68d`, created 2026-10-14T02:31:44Z, on image `macos-26-arm64` 20260907.0351.1. Its
  *Renderer gate* log reads: "renderer.sh: pid 59529 — the main process was observed at the Open
  panel, inside the shell's launch, on observation 1 (bound: 30 observations, about 1 s each)". It
  also reads: "renderer.sh: control pid 59797 (idle-shell, one window and no panel) was not observed
  at the Open panel in any of 30 observations — the expected red". The later run 38577309118
  (`ka-reader@f357008`, same image) reads the same: observation 1, and the control unmatched on any
  of 30.
- **Where it shows:** § 4 C-I3's renderer half, lines 978–990, and RN-110, lines 8287–8291, at
  `ka-reader@f357008`.
- **If a document has to be written:** none. This is a fold into `SDD.md`.
- **Answer:** Record it. The first hosted renderer-gate reading on `macos-26` is GitHub Actions run
  38501500758 on `main` at `ka-reader@3f7a68d`, created 2026-10-14T02:31:44Z, image `macos-26-arm64`
  20260907.0351.1 — the first hosted run to reach the gate on that image, after run 38463966607
  ended at *Test gate* and no branch run on the image reached it between. Its *Renderer gate* step
  concluded `success`; the product matched the script's four-frame list on observation 1 and the
  `idle-shell` control was not matched on any of 30 — the same shape as both `macos-14` readings,
  now on the image CI runs and inside the floor C-R5 set at v48. Run 38577309118 on `ka-reader@f357008`
  (same image) reads the same and is corroboration, not a second recorded reading. So the renderer
  half's "the first hosted reading on `macos-26` is the first hosted run that reaches this gate on
  that image" is discharged by this run and becomes dated; the gate's rule — an image whose frames
  read differently turns it red on the next build — does not move, the frame list stays the script's
  header's and is not copied, and RN-110's "owed to an item of its own" is discharged by this item.
  No slice, seam or part moves; no ADR is owed; ADR-0012 stands as a dated record. Reasoning:
  `docs/trail/sdd/self_answer-58.md` § 5.2.
