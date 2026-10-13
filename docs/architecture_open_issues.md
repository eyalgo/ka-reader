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

> **How this companion came to exist.** No `product-architecture` run opened it. A
> `companion-self-answer` run answering `docs/SDD_open_issues.md` opened it on 2026-10-13, in the
> CTO's posture: `docs/nfdr.md` was Settled at v46 and the decision log had no companion on disk, so
> without this file a `product-architecture` re-run would read both records as done and fold nothing.
> What prompted it is `docs/SDD_open_issues.md` § 5.1, pinned at
> `ka-reader@821a163:docs/SDD_open_issues.md` because the SDD's fold removes that file: the owner
> raised KA-Reader's macOS floor from 14.0 to 26.0 and moved CI from the `macos-14` image to
> `macos-26`, answering the item in their own hand. `product-sdd` folds that into SDD § 4 C-R5 on its
> next run; QC-56 binds the floor and traces to that passage. It holds one item, § 2.1; the
> reasoning is `docs/trail/sdd/self_answer-55.md`.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 QC-56 binds the macOS floor at 14.0, and the owner raised it to 26.0 — the obligation moves, and whether the log is owed a record is this seat's
- **Lands in:** `nfdr.md` QC-56 (`:L1379-L1384`) and its § 10 row (`:L1807`); `adr/` only if this seat
  judges a record owed — the lean is that none is.
- **Drafted into the records:** nothing — the run that raised this writes no document. The lean, for
  the seat that folds it. **QC-56** reads *The minimum macOS version is 26: the bundle's
  `LSMinimumSystemVersion` is `26.0`, and the floor is stated wherever the install path is offered*,
  its *verified by* reading `prints 26.0`; its traces stand (SDD § 4 C-R5; § 9 TO-8; SRS C-11; FDR
  R-133, PD-18; ADR-0007), because every one of them is a passage that moves with the floor or names
  no number. **The log:** ADR-0011 names "the macOS 14 floor" once (`:L99`), inside the dated account
  of why the mach-lookup exception was refused — what WebKit's Networking process could do on the floor
  as it stood on 2026-09-23. That sentence was true when recorded and the log is append-only
  (`docs/adr/README.md`, "a reversal is a new record that supersedes an old one, never an edit to
  it"), so it stays as written; ADR-0011's decision rests on no floor. No record is owed for the floor
  itself: the floor has never been a record of its own — QC-56 traces to SDD C-R5 and ADR-0007, not
  to a floor decision — and the SDD's ground for the value does not change in kind, only in value and
  cause: it stays the maintainer's narrowing, now to the one macOS the hosted runner and the
  maintainer's Mac both run. **The `macos-14` readings** beside QC-56 are the fold's to re-read, and
  the lean is that none moves by this item: the Swift-toolchain departure (`:L1645-L1700`) holds
  "until CI builds `ka-reader-mac` on an image carrying a Swift 6.2 or later toolchain", and names the
  first CI log on the new image as what reads the toolchain — that rule is unchanged by the image's
  name, and the `macos-26` image's default Xcode is 26.6 (the runner-images readme below), whose Swift
  that log prints; the departure's own promise that "the change that moves CI to such an image …
  re-measures QC-25's hosted-runner narrowing, taken on `macos-14` (`docs/SDD.md` RN-48), on the new
  image" (`:L1697-L1699`) now has a date it is owed by; and the dated readings of runs 35968105480 and
  35988399477 on `macos-14-arm64` (`:L855`, `:L1669`, `:L3311`) are history and stand.
- **Rationale:** The owner's decision, and its cause outside the product. GitHub retires the
  `macos-14` runner image on 2026-11-02, and jobs on it fail during brownout windows before then —
  the next six are Oct 16, 19, 23, 26, 29 and 30, each 14:00 UTC to 00:00 UTC the next day
  (https://github.blog/changelog/2026-10-01-github-actions-macos-14-runner-image-retirement/, read
  2026-10-13). The replacements it names are `macos-15` and `macos-26` (as `macos-latest`); there is no
  macOS 14 image after that date. The owner chose to raise the floor to what CI and the maintainer's
  own Mac run — the `macos-26` image is macOS 26.6.2 (25G83), default Xcode 26.6
  (https://github.com/actions/runner-images/blob/main/images/macos/macos-26-arm64-Readme.md, read
  2026-10-13), and `sw_vers` on the maintainer's Mac prints 26.6.2 (25G83), 2026-10-13 — so the floor
  is 26.0 (`ka-reader@821a163:docs/SDD_open_issues.md` § 5.1, *Why the floor moves with the runner*).
  KA-Reader is before 1.0.0, so the raise is not a breaking change under SDD § 4 C-R5's own words
  (`docs/SDD.md:L643-L644`). The item is raised before the SDD has folded, rather than after, because
  QC-56 is verified *at the release* (`:L1807`): a release built at `26.0` against a QC-56 that reads
  `14.0` fails its own check, and the retirement date leaves no slack for a second round. One
  measured fact for the fold's re-read of the departure paragraph: `.macOS(.v26)` is "First available
  in PackageDescription 6.2"
  (https://developer.apple.com/documentation/packagedescription/supportedplatform/macosversion/v26,
  read 2026-10-13), so the manifest's `swift-tools-version:5.9` line (`ka-reader-mac/Package.swift:L1`)
  cannot carry the new floor — the tools-6.2 flip the departure already names arrives with the floor,
  not after it.
- **If overridden:** If QC-56 stays at 14.0, the NFDR contradicts the SDD the moment the fold lands,
  and the first release after the change fails QC-56's own verification. If this seat judges a record
  owed, it is a new file in `adr/` naming the floor's cause — the runner image's retirement — and
  QC-56's trace gains it; nothing else here changes. If the owner's number were to change (15 rather
  than 26), QC-56 moves to that number and nothing else here changes.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

None.
