# Self-answer report — `docs/SDD.md`

This is the record of one unattended run that met `docs/SDD_open_issues.md` in the CTO's seat on
2026-10-13 and found its one item already answered by the owner. It is for the owner, who reads it
to learn what the run checked and what it opened elsewhere, and for the `product-sdd` run that folds
the owner's answer.

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v47, `Status:` Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-13
- **Sources re-read:** Four, each at its source, because the two companions this run opened rest on
  them. (1) GitHub's changelog
  https://github.blog/changelog/2026-10-01-github-actions-macos-14-runner-image-retirement/ — "The
  macOS 14 runner image will be retired on November 2, 2026"; eight brownout windows, each 14:00 UTC
  to 00:00 UTC the next day, on Oct 5, 12, 16, 19, 23, 26, 29 and 30, so the six the item lists are
  the six still ahead of today; the replacement labels are `macos-latest` (macos-26), `macos-15`,
  `macos-latest-xlarge` and `macos-15-xlarge`. (2) The `macos-26` image readme
  https://github.com/actions/runner-images/blob/main/images/macos/macos-26-arm64-Readme.md — "OS
  Version: macOS 26.6.2 (25G83)", Xcode "26.6 (default)" with 26.0.1 – 26.5 beside it, and no Xcode
  16.2, as the item says. (3) Apple's reference for `NSTextLayoutManager`,
  https://developer.apple.com/documentation/appkit/nstextlayoutmanager — macOS `introducedAt` `12.0`,
  which C-R5 cites (`docs/SDD.md:L638-L639`) and TO-8 does not match (below). (4) Apple's reference for
  `SupportedPlatform.MacOSVersion.v26`,
  https://developer.apple.com/documentation/packagedescription/supportedplatform/macosversion/v26 —
  "First available in PackageDescription 6.2", the fact the item left unread. Inside the machine:
  `sw_vers` on the maintainer's Mac prints `26.6.2` / `25G83`, matching the item.
- **What was read of the document:** `docs/SDD.md` is 8,066 lines and was not read whole. This run
  read the header's status and owner lines (`:L3-L4`, `:L12-L34`), the heading map (`grep -n '^#'`),
  every line `grep -n -E 'macos-14|macos-15|macos-26|macOS 14|macOS 15|macOS 26|Sonoma|Sequoia|14\.0|
  15\.2|\.v14|Xcode 16|MACOSX_DEPLOYMENT_TARGET|LSMinimumSystemVersion'` prints (sixteen lines), and
  around each: § 4 C-R5 whole (`:L635-L645`), the renderer-gate reading (`:L920-L930`), the
  `submodule` clause (`:L1990-L2000`), S-7's command half (`:L2185-L2195`), S-11's command half
  (`:L2428-L2432`), § 9 TO-8 (`:L2623-L2626`), § 11 R-11 (`:L3045-L3050`) and RN-6 (`:L3813-L3818`).
  Of the SDD's inputs, `docs/SRS.md` C-11 (`:L490`) was read for whether it names a number — it does
  not — and the PRD and UXD were grepped for the floor and name none. Downstream, `docs/fdr.md`
  R-133, PD-18, PD-40 and the acceptance row (`:L250`, `:L285`, `:L307`, `:L389`), `docs/nfdr.md`
  QC-56 and its § 10 row (`:L1379-L1384`, `:L1807`), the Swift-toolchain departure (`:L1645-L1700`)
  and its RN (`:L2966-L2984`), and ADR-0011 `:L92-L104` were read, because the item names them as
  stating the floor or the runner. The code the item cites was read at each line it names
  (`Info.plist:L13-L14`, the fixture plist `:L11-L12`, `Package.swift:L1`, `:L5`, `:L14`,
  `assemble.sh:L19-L20`, `:L43`, `BundleManifestTests.swift:L34`, `CodeView.swift:L144`,
  `ReadingPanelTests.swift:L2891`, `ci.yml:L18-L23`) and every one says what the item says it says.
- **The tree:** `ka-reader@821a163`, the commit that opened the companion; `git status --short`
  printed nothing before this run wrote. No check was run: the run answered no item and built nothing
  a check would read.

## Items worked

None this run.

## Left for the owner

None this run.

## Skipped

- **5.1 — The macOS floor rises from 14.0 to 26.0, and CI runs on `macos-26`** — its one slot,
  **Answer**, is filled: "Raise the floor to macOS 26.0 and move CI to `macos-26`. — the owner,
  2026-10-13". A filled slot is an answer already given and is left exactly as it stands (SKILL.md
  § Step 3), so the companion is answered and this run wrote nothing into it. What the run did with
  the item anyway, for the fold that consumes it: every fact the item rests on was re-read at its
  source or at its line (§ Header), and all of them hold. Four things the fold meets that the item
  does not state, none of them a change the item did not raise — they are the same change, so no
  item is appended here: **(1)** one more SDD passage names the floor's value — S-11
  `promise-one-point-zero`'s command half, "the floor `14.0`" in the enumeration `checks/contract/1`
  is written from (`docs/SDD.md:L2430`), beside the four passages the item lists at `:L635-L645`,
  `:L926-L927`, `:L1996-L1997` and `:L2191`; the remaining `14.0` and `macos-14` lines (`:L3813`,
  `:L4096`, `:L4310`, `:L5112-L5114`, `:L5414`, `:L7970`) sit in Review Notes and the trail of
  Open Questions, dated records that stand. **(2)** TO-8 reads "where nothing in the stack forces one
  above 11" (`:L2623`) while C-R5 says TextKit 2's `NSTextLayoutManager` is available from 12.0
  (`:L638-L639`), which Apple's page confirms; TO-8 is rewritten by the fold in any case, and the
  rewrite can take C-R5's number. **(3)** `.macOS(.v26)` is first available in PackageDescription
  6.2, so `Package.swift`'s `swift-tools-version:5.9` line moves with the floor — the tools-6.2 flip
  `docs/nfdr.md`'s departure paragraph already names (`:L1680-L1700`); the SDD names no tools
  version, so this is for the change, not the fold. **(4)** The label to pin is `macos-26`, as the
  owner wrote it, and not `macos-latest`, which the changelog gives as that image's alias — the NFDR's
  own argument for a pinned image, "a label whose default Xcode can move under the same name"
  (`:L1673`), applies to an alias that will one day point at macOS 27. The brownout that ran
  2026-10-12 14:00 UTC to 2026-10-13 00:00 UTC has passed; CI's latest run on `main` concluded
  `success` on `macos-14` at 2026-10-13T15:54Z (`gh run list --limit 1`, run 38426030432), outside a
  window.

## Companions opened

- **`docs/fdr_open_issues.md`** — **opened** — companion to `fdr.md`, landed in commit `2629164`
- **`docs/architecture_open_issues.md`** — **opened** — companion to `adr/` and `nfdr.md`, landed
  in commit `55c04de`

Both were opened on the prompt's second ground — something upstream moved and the document has not
seen it: the owner's decision at `ka-reader@821a163:docs/SDD_open_issues.md` § 5.1 moves SDD § 4
C-R5, and `fdr.md` R-133, PD-18 and the row at `:L389`, and `nfdr.md` QC-56 with its § 10 row, trace
to C-R5 and state 14. Each was opened before the SDD has folded rather than after, and the item in
each says why: R-133 is what a change request is validated against (`<CORE>/roles/CROSS_ROLE.md`
§ 1), so a floor change cut against it returns `fdr-update-needed`; QC-56 is verified at the release
(`docs/nfdr.md:L1807`), so a release at `26.0` against it fails its own check; and the retirement
date, 2026-11-02, leaves no round to spare. Each item carries the lean and leaves its slot at the
placeholder, so the deciding is the next round's in each seat. Where this run was unsure — whether
the log is owed a record for the floor — the doubt is in the architecture item's *Lands in* line.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
- **`docs/fdr.md`** — `<CORE>/launchers/skill/launcher.sh product-fdr ka-reader`
- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
