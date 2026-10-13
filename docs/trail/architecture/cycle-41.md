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
- **Answer:** Confirmed with addition, and one clause of the lean overridden. Fold § 9's
  Swift-packet bullet against `ka-reader@fcb2e2f`. (1) `:L1659-L1662` and `:L1701-L1705` name
  `macos-26` (`ci.yml:L18`), which selects no Xcode (`:L19`). Their `macos-14` words become dated
  notes, and the dated readings at `:L855`, `:L1680` and in the Review Notes stand. (2) **Overridden:
  the toolchain is not unread, and the Swift Testing flip does not wait.** The `Toolchain` step
  (`ci.yml:L23-L24`, from `ka-reader@d852457`) has printed it on every `main` build since GitHub
  Actions run 37845881070 on `ka-reader@fcc3d4f` (2026-10-08): Apple Swift 6.0.3, SDK 15.2, image
  `macos-14-arm64` 20260831.0302.1. Run 38449250910 on `ka-reader@8926052` prints the same. Swift 6
  toolchains include Swift Testing (swift.org, *Announcing Swift 6*, re-read 2026-10-13), so by the
  *Framework* clause's own rule the flip happened at run 37845881070, and new tests use Swift Testing
  from then on. No test file has been added under `ka-reader-mac/Tests/` since, so nothing has broken
  the rule. The *Toolchain* clause records that run as its first measurement: the Swift version, the
  run id and the image version together. Three phrases become dated notes: its "not yet measured",
  its "no `swift --version` step", and the *verified by*'s "no command reads which toolchain CI
  builds with". (3) The `macos-26` toolchain is a re-measurement, read from the first `main` log on
  that image. No such log exists yet: `main` is three commits ahead of `origin/main`, and no run on
  `macos-26` is listed. (4) **The tools-6.2 departure gets one trigger, `:L1711-L1718`'s:** the change
  that writes the `6.2` tools version adopts the six, with the dependency-gate clause beside them.
  These are the seven the *verified by* counts. That trigger replaces `:L1691-L1692`'s "until CI
  builds … on an image carrying a Swift 6.2" and `:L1707-L1710`'s "all six are adopted then /
  otherwise the change that moves CI …". The CI move landed without adopting any of them, as the
  review gate requires. That change's own CI build checks its ground: a toolchain below 6.2 refuses a
  `6.2` manifest, and the job goes red. Decided together with 3.2. Reasoning:
  `docs/trail/architecture/self_answer-46.md` § 3.1.

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
- **Answer:** Answered. **No image move and not the tools-6.2 change: the reading becomes standing,
  taken on every hosted build.** (1) QC-25 gains this document's own realization of its runner
  clause. On every CI build, the `Bundle probe suite` step's log carries the unentitled control's
  last report, `out-of-grant-read:` line included. It is read with
  `gh run view <run-id> --repo kensaiapp/ka-reader --log | awk -F'\t' '$2 == "Bundle probe suite" && /out-of-grant-read:/'`.
  That prints nothing today. `checks/bundle.sh:L382` prints the report, but the suite captures it
  (`test_bundle.sh:L144-L146`) and prints only `ok` on success (`:L1573-L1577`). (2) **Which change:**
  one of its own, scheduled by the PM, and not the tools-6.2 change. That change is a manifest change
  whose seven flips move together or not at all, and tying a harness reading to it makes the reading
  wait on the floor move. An owner named per image move has already lapsed once (`ka-reader@fcb2e2f`
  moved the image and re-measured nothing). The label moves on GitHub's schedule (SDD § 11 R-17), so
  only a per-build reading cannot lapse. Until that change lands, `development-design` reading QC-25
  is the gate on any change to `checks/bundle.sh`, `checks/tests/test_bundle.sh` or
  `.github/workflows/`. (3) **Meanwhile the narrowing is dated.** QC-25's runner clause names
  `macos-14`, run 35797893381 (SDD RN-48), and says the `macos-26` reading is not yet taken. The gap
  overclaims nothing. The narrowing only removes the read denial from the evidence, and the control
  passes on `sandboxed: no` alone. So a green `macos-26` build still shows the wall by the sandboxed
  report and the outbound denial. (4) **When the reading lands:** a `denied` reading leaves the
  narrowing standing, re-dated with the run id and the image version. An `allowed` reading means the
  read denial separates again on the runner. C-I3 is then restated by the CTO, and QC-25 follows.
  (5) At `:L1709-L1710`, "and re-measures QC-25's hosted-runner narrowing … on the new image" becomes
  a dated note pointing to QC-25. § 10's QC-25 row gains the log reading. No ADR is owed, because
  ADR-0010 dates its runner measurement (`:L131-L136`). C-I3 carries the same sentence with no image
  named, and that is raised on `docs/SDD_open_issues.md` § 2.1. Decided together with 3.1. Reasoning:
  `docs/trail/architecture/self_answer-46.md` § 3.2.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
