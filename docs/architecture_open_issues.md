# Architecture open issues — Nozoki

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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-04 from the records'
> own companion template. From `nozoki@129586e` the shell calls `nozoki_read_git`, and the `nm` read
> passes on the executable that links it. QC-3 still says no such build has been read, and two NFDR
> sentences pin `nozoki-mac/Package.swift` test-target lines that have moved. The records are Settled,
> and with no companion on disk a `product-architecture` re-run reads them as done and has nothing to
> act on. Its two items are in § 3.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-3 half (3) says the `nm` read has not met an executable that links `nozoki_read_git`; it has, and it passes
- **Raised by:** PM — 2026-10-04
- **Which record:** `nfdr.md` § 1.1, QC-3
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. A later change reads QC-3 to learn what the transport read has
  proved, and finds the linked export unproved.
- **Where it shows:** QC-3 (`docs/nfdr.md:L164-L167`): "It has not met one that links the
  `nozoki_read_git` export (`crates/nozoki-bridge/src/exports.rs:L105`), which no Swift source calls."
  At `nozoki@129586e`, `nozoki-mac/Sources/Nozoki/NativeBridge.swift:L26` calls it. Measured
  2026-10-04 at that commit: `nozoki-mac/assemble.sh` exits 0, `nm` on the release executable holds
  `_nozoki_read_git`, and `checks/view.sh` exits 0 ("carries no Git transport — nothing found"). The
  SDD's own sentence (§ 4 C-I3) is raised on `docs/SDD_open_issues.md` § 5.1; QC-3 re-derives from it.
- **If a document has to be written:** none. QC-3's sentence in `nfdr.md`.
- **Answer:** <the owner fills this in>

### 3.2 Two NFDR sentences pin the test targets at `nozoki-mac/Package.swift:L34-L35`; they are at `:L39-L40`
- **Raised by:** PM — 2026-10-04
- **Which record:** `nfdr.md` § 9, the Swift-packet bullet's *Test targets* clause, and its echo in item (4)
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. A reader following the pin lands on the bridge's link flags.
- **Where it shows:** `docs/nfdr.md:L1463` and `:L2793` both cite `nozoki-mac/Package.swift:L34-L35`
  for `SurfacesTests` and `ShellTests`, with no commit pinned. At `nozoki@129586e` those lines are
  `.linkedLibrary("z")` and a comment; the two `.testTarget` lines are at `:L39-L40`. The likely fold:
  cite `:L39-L40`, or pin the old lines to the commit they were read at.
- **If a document has to be written:** none. The two citations in `nfdr.md`.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
