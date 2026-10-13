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

> **How this companion came to exist.** No `product-architecture` run opened it. A PM run of
> `shukuba-refine` opened it on 2026-10-13, after `.github/workflows/ci.yml` moved its one job to
> `runs-on: macos-26` and dropped its `DEVELOPER_DIR` pin to Xcode 16.2 (`ka-reader@fcb2e2f`). `nfdr.md`
> is Settled at v47 and had no companion on disk, so without this file a `product-architecture` re-run
> would read the records as done and fold nothing. It holds two items in § 3. Neither edits a record;
> each is for this seat to fold.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 § 9's Swift-packet bullet still states, in the present tense, that CI runs on `macos-14` with Xcode 16.x selectable
- **Raised by:** PM — 2026-10-13
- **Which record:** `nfdr.md` § 9, the *`ka-reader-mac` against the Swift packet* bullet (`:L1652` onward)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_ka-reader-builds-and-proves-on-its-26-floor`
- **What it blocks:** nothing is blocked; two present-tense statements are false at `ka-reader@fcb2e2f`,
  and a delivery-tier reader takes them as the current image.
- **Where it shows:**
  - `:L1659-L1662` — "the current `macos-14` image carries Xcode 16.1 and 16.2 beside its 15.4 default,
    so a delivery-tier change can select a toolchain the image already holds". The workflow now names
    `macos-26` and selects no Xcode: `grep -nE 'DEVELOPER_DIR|macos-14' .github/workflows/ci.yml`
    prints nothing, and `ci.yml:L19` reads "The job builds with the image's own default Xcode; it
    selects none of its own."
  - `:L1701-L1705` — "the one image this product's CI runs on, `macos-14` (`ci.yml:L18`), offers
    Xcode 15.0.1 – 16.2". `ci.yml:L18` now reads `runs-on: macos-26`.
  - The lean: name `macos-26`, and keep the image reading apart from the tools-6.2 adoption, whose
    boundary `:L1711-L1718` already fixes. The toolchain it builds with is read from the first hosted
    `CI` log on `main` that builds `ka-reader-mac` on that image, not inferred from the label
    (`:L1678-L1684`; `swift/toolchain.md` § Toolchain version, the no-pin-file case). Until that log
    exists the toolchain is unread, and the Swift Testing flip at `:L1655-L1662` still waits on it.
    The dated `macos-14` readings elsewhere in the document (`:L855`, `:L1680`, the *NFDR Review Notes*) are
    history and stand.
- **If a document has to be written:** none — a re-derivation of § 9 by `product-architecture`.
- **Answer:** <the owner fills this in>

### 3.2 § 9 does not say which change re-measures QC-25's hosted-runner narrowing on the new image
- **Raised by:** PM — 2026-10-13
- **Which record:** `nfdr.md` § 9, the same bullet; QC-25 (`:L765`)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_ka-reader-builds-and-proves-on-its-26-floor`
- **What it blocks:** the re-measurement has no owner. One sentence ties it to the change "that moves
  CI to such an image" (`:L1709-L1710`). That change has landed and the narrowing was not re-measured:
  the workflow moved and no step, check or test changed. The v47 sentence that follows moves the six
  adoptions to "the change that writes the `6.2` tools version" (`:L1711-L1718`). It does not say
  whether the measurement moves with them.
- **Where it shows:** `:L1706-L1718`. On today's tree the hosted suite cannot show the reading
  unchanged. `checks/bundle.sh:L369-L389` prints the unentitled control's probe report before its
  summary (report fields `checks/sandbox_probe.rs:L143-L150`). `checks/tests/test_bundle.sh` captures
  that output (`:L144-L146`, `:L624-L635`) and prints only `ok` and the case name on success
  (`:L1573-L1577`). So a green CI run on `macos-26` does not show whether the control's out-of-grant
  read is still reported denied there (`docs/SDD.md` RN-48). The lean: say which change owns the
  measurement, whether that is the tools-6.2 change or a change of its own. Also say what it reads, as
  a command whose output shows the control's read result on the hosted image.
- **If a document has to be written:** none — a re-derivation of § 9 (and QC-25's *verified by*, if
  the measurement becomes a check) by `product-architecture`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
