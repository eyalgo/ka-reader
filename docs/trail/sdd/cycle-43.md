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

> **No `product-sdd` run wrote this file.** It was opened by hand on 2026-10-13 from the SDD's own
> companion template, to carry a decision the owner made that day: KA-Reader's macOS floor rises from
> 14.0 to 26.0, and CI moves from the `macos-14` image to `macos-26`. The cause is outside the SDD:
> GitHub retires the macOS 14 runner image on 2026-11-02, with brownouts that fail jobs on it before
> then (https://github.blog/changelog/2026-10-01-github-actions-macos-14-runner-image-retirement/).
> The SDD is Settled, and with no companion on disk a `product-sdd` re-run reads it as done and has
> nothing to act on. Its one item is in § 5, with the owner's answer already in it.

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

### 5.1 The macOS floor rises from 14.0 to 26.0, and CI runs on `macos-26`
- **Raised by:** Product (the owner) — 2026-10-13
- **Seat:** cto
- **Tracked by:** none — no seed is cut for it yet.
- **What it blocks:** CI. The workflow runs on `runs-on: macos-14` (`.github/workflows/ci.yml:L18`).
  GitHub retires that image on 2026-11-02. Before then, jobs on it fail during eight brownout windows,
  each 14:00 UTC to 00:00 UTC the next day. Six of them are still ahead: Oct 16, 19, 23, 26, 29 and 30
  (the changelog linked above). After 2026-11-02 no CI run can start, so no station whose
  *Reached when* reads a hosted run can close.
- **Why the floor moves with the runner:** GitHub names `macos-15` and `macos-26` as the
  replacements, and offers no macOS 14 image. With the floor at 14.0, CI would no longer run the app
  on its floor. The owner chose to close that gap by raising the floor to the macOS CI runs and the
  maintainer's own Mac runs: macOS 26.6.2, build 25G83, on both
  (https://github.com/actions/runner-images/blob/main/images/macos/macos-26-arm64-Readme.md;
  `sw_vers` on the maintainer's Mac, 2026-10-13). This is the floor C-R5 calls "the maintainer's
  narrowing", narrowed further. KA-Reader is before 1.0.0, so under C-R5's own words the raise is
  not yet a breaking change (`docs/SDD.md:L643-L644`).
- **What it costs:** every adopter on macOS 14 or 15, on top of TO-8's "every adopter on 12 or 13"
  (`docs/SDD.md:L2623-L2626`).
- **Where it shows in the SDD:**
  - § 4 C-R5, the floor itself: "The minimum macOS version is **14.0** (Sonoma)" and its reasons
    (`docs/SDD.md:L635-L645`).
  - § 9 TO-8, the trade-off it buys and costs (`docs/SDD.md:L2623-L2626`).
  - The release check that reads the floor: `LSMinimumSystemVersion` "prints `14.0`"
    (`docs/SDD.md:L2191`).
  - Two passages that name the `macos-14` runner as a measurement: the renderer frame list "inside
    the C-R5 floor's major" (`docs/SDD.md:L926-L927`) and the hosted `submodule` walk
    (`docs/SDD.md:L1996-L1997`). With the floor at 26, the first no longer reads as a run on the floor,
    and the renderer gate's hosted reading may need re-taking on `macos-26`.
- **Where it shows in the code**, for the change that follows the SDD (none of it moves in this file):
  - `ka-reader-mac/Info.plist:L13-L14` and `checks/fixtures/idle-shell/Info.plist:L11-L12`:
    `LSMinimumSystemVersion` `14.0`.
  - `ka-reader-mac/Package.swift:L1`, `:L5`, `:L14`: `swift-tools-version:5.9`, chosen as "the
    lowest that has `.macOS(.v14)`", and `platforms: [.macOS(.v14)]`. Which tools version first has
    `.macOS(.v26)` is not read here.
  - `ka-reader-mac/assemble.sh:L19-L20`, `:L43`: `MACOSX_DEPLOYMENT_TARGET=14.0`.
  - `ka-reader-mac/Tests/ShellTests/BundleManifestTests.swift:L34`: asserts `"14.0"`.
  - `ka-reader-mac/Sources/Surfaces/CodeView.swift:L144` and
    `ka-reader-mac/Tests/SurfacesTests/ReadingPanelTests.swift:L2891`: `#available(macOS 15.2, *)`,
    always true on a 26 floor.
  - `.github/workflows/ci.yml:L18-L23`: `runs-on: macos-14` and `DEVELOPER_DIR` set to Xcode 16.2,
    whose comment says the pin exists only to reach a macOS 15.2 SDK. The `macos-26` image carries
    no Xcode 16.2; its default is Xcode 26.6 (readme linked above).
  - Comments that describe macOS 14 behaviour or the `macos-14` runner:
    `LaunchWindowStartupTests.swift:L357`, `LaunchWindowSupport.swift:L335`,
    `crates/ka-reader-core/tests/tree_links.rs:L342`, `checks/renderer.sh:L61-L62`.
- **If a document has to be written:** the SDD change here, by `product-sdd`. Downstream of it,
  documents this file does not own also state the floor or the runner: `docs/fdr.md` R-133, PD-18 and
  the acceptance row at `:L389` (Principal PM); `docs/nfdr.md` QC-56 (`:L1379`) and the `macos-14`
  readings at `:L1649`, `:L1691`, `:L2970` (Principal Architect); and ADR 0011 (`:L99`), which an ADR
  log changes only by a new record.
- **Answer:** Raise the floor to macOS 26.0 and move CI to `macos-26`. — the owner, 2026-10-13
