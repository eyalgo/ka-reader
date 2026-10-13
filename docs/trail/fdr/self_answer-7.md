# Self-answer report — `docs/fdr.md`

## Header

- **Companion:** `docs/fdr_open_issues.md`
- **Document:** `docs/fdr.md` (v11, Draft)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-10-13
- **Sources re-read:**
  - https://github.blog/changelog/2026-10-01-github-actions-macos-14-runner-image-retirement/. It says "The
    macOS 14 runner image will be retired on November 2, 2026". It gives eight brownout windows, each 14:00 UTC
    to 00:00 UTC the next day: Oct 5, 12, 16, 19, 23, 26, 29 and 30. Its replacement labels are `macos-latest`
    (`macos-26`), `macos-15`, `macos-latest-xlarge` (`macos-26-xlarge`) and `macos-15-xlarge`.
  - https://github.com/actions/runner-images/blob/main/images/macos/macos-26-arm64-Readme.md. It says "OS
    Version: macOS 26.6.2 (25G83)", with Xcode "26.6 (default)".
  - `gh release list -R kensaiapp/ka-reader` printed nothing, and `git -C <product> tag` printed nothing
    (2026-10-13).

## Items worked

### 2.1 — R-133, PD-18 and one acceptance row state a macOS floor of 14, and the owner raised it to 26.0

- **Bucket:** 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** Confirm. The three entries now read what the SDD reads, and the cause holds at its source.
  - **Seat.** The question is whether this document follows a value the owner already set, and that binds
    only this document's consistency, so it is mine to answer. The value itself is the owner's: they gave it
    at `docs/trail/sdd/cycle-43.md` § 5.1, and it is not reopened here.
  - **Check 2: the draft.** It holds for the reasons it gives.
    - `docs/SDD.md` § 4 C-R5 states "**26.0**" and names no release (`:L636`), so "no release name rides
      beside the number" is accurate.
    - R-133's "macOS 26 or later" and PD-18's "the minimum version is macOS 26" say the same as C-R5's 26.0.
    - The rationale's claim that R-133 is the line a change request is validated against holds:
      `<CORE>/roles/CROSS_ROLE.md` § 1 has the PM validate each request "against the scope locked in
      `fdr.md`".
    - The rationale's "raised before the SDD has folded" is now history: the SDD folded at v48
      (`ka-reader@6eec80c`). The item's own *Drafted* line already says so.
  - **Check 3: the settled record.**
    - SRS § 7 C-11 fixes no number. It places the floor in the SDD "with the runtime" and requires it stated
      wherever the install path is offered (`docs/SRS.md:L490-L492`). The PRD states no floor (searched).
    - PD-40 prices raising the floor only from 1.0.0. No tag or release exists (§ Header), so this raise is
      inside R-142's "anything may change", and PD-40 does not move.
    - The outside cause, re-read at its source, matches the item's account (§ Header). The retirement date,
      the replacements, the six brownouts still ahead and the image's OS are all as stated.
    - `docs/nfdr.md` QC-56 still reads 14.0 (`:L1379-L1380`). It is already raised at
      `docs/architecture_open_issues.md` § 2.1, so this run opens no second item for it. The two folds land in
      either order and converge.
    - Two other sites read 14 and do not move. The FDR header's v1 parenthesis and RN-31 are dated history.
      `README.md` states no floor yet, which R-133 holds at release and QC-56's release inspection reads.
  - **Check 4: failure paths.**
    - Refused: a stranger on macOS 15 or earlier meets R-133's statement before installing. Past that, the
      platform declines to launch the bundle. That is the platform's behaviour and needs no product rule.
    - Stale: the floor is now tied to a runner image's lifetime (`docs/SDD.md` § 9 TO-8; § 11 R-17). When
      GitHub retires `macos-26`, the same move comes back, and after 1.0.0 PD-40 makes it a major version.
      That is a cost of this answer, not a gap in a rule, so I add no rule. I ask the fold's note to name it.
  - **Addition (1), a correction found while reading.** RN-36 (1) says R-133, PD-18 and the example row read
    26 "their traces unchanged". But each one gained *upstream moved — RN-36* at v11: the v10 text at
    `ka-reader@69cc4b2:docs/fdr.md` L250, L285 and L389 has no such mark. The fold should say their sources
    are unchanged and each is marked.
  - **Addition (2).** The stale case above, named in the fold's note.
  - **What would have tipped it.** An upstream document stating a different number. None does.

### 2.2 — The SDD moved from v20 to v48 under the settled FDR, and v11 re-derives against it

- **Bucket:** 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override
- **Verdict:** overridden
- **Why:** Override, in one clause only. Everything the fold adds is confirmed as drafted: R-185 – R-191,
  R-38's new wording and both example rows. What is replaced is the *Left as written* clause. R-35 and R-37
  are reworded to name the row.
  - **What it was.** R-35 and R-37 keep the word *file*, because Git reports a submodule whose commit moved,
    or a nested repository, "as a changed entry, so R-35 reaches them".
  - **What replaces it.** R-35 marks each file Git reports as changed, and each folder row Git reports as one
    entry: a submodule whose commit moved, or a repository nested in the folder. R-37's status letter sits
    beside the row's name. Neither rule calls the folder *changed*. No other entry moves. R-24 and R-36 keep
    *changed-file marker* as the marker's name, because what they say (none in a plain folder, none before
    Git state is observed) holds for any row, and renaming the term would spread into the Examples and the
    notes with no reader gaining from it.
  - **Seat.** The wording of this document's rules is mine. No person, outside party or risk is committed,
    and the behaviour is already settled elsewhere (below).
  - **Check 2: each added rule, read against the passage it cites in `docs/SDD.md` v48.**
    - **R-185.** The `git-reader` row, "With the machine-level config off": the global ignore file is not
      applied, so a file it hides is listed as untracked (`:L351`). The `core-bridge` row's switch empties
      all four machine-level search paths (`:L357`). `.git/info/exclude` lies inside the viewed folder, so
      *an ignore rule inside the viewed folder* still covers it. A repository config whose `core.excludesFile`
      points outside the folder is refused under R-187, so the two rules meet without a gap.
    - **R-186.** Same row: a repository the current user does not own "is a `failed` Git item". R-186 says
      *a failure state* and names no cause, which keeps it inside R-89.
    - **R-187 and R-188.** The config, alternates and `.gitmodules` checks, each with its two observations
      (outside, or not located). The adapter answers `ConfigNotLocated` for a section path beginning `/`, and
      `ObjectStoreNotLocated` for an entry beginning with neither `.` nor `/` (`:L351`). These run on the
      repository and on each verified submodule.
    - **R-189.** `SubmoduleElsewhere` (`:L351`). Where the other location spells outside the folder, R-187
      catches it instead, so R-189's restriction to *inside* is the right cut.
    - **R-190.** `GitmodulesUnreadable`, "for any reason but its absence" (`:L351`). R-190 says *present*,
      so an absent `.gitmodules` passes, as the SDD says. A file `.gitmodules` includes that cannot be read
      keeps the unreadable-Git-directory condition. R-190 does not name it, and the Git view still fails
      whole, by R-191.
    - **R-191.** Entity `GitState`: "one read, which asks `state` and then `status`… A failure of either makes
      the whole Git item `failed`" (`:L508-L512`). The `git-reader` row adds "Status is never run with that
      submodule left out" (`:L351`).
    - **R-38.** The `surfaces` row: the tooltip is drawn only while the window is the key window (`:L359`).
      "The row's name" is the SDD's wording at `:L1843` and `:L1858` (RN-95).
    - **R-101 and R-21.** The draft's reason for stating these refusals at all holds. R-101 says what is not
      read, not what the reader then sees, and R-21 is this document's precedent for a Git-view failure state
      the SDD names.
    - **Altitude.** The rules state the input condition and the observation, with no mechanism. `.gitmodules`
      is named the way R-29 names `.git`.
  - **Check 2: the clause I override.** It reaches the right question with an argument that does not carry.
    R-35 says *file Git reports as changed*, not *entry*. The wording standard R-88 names says the opposite
    of the draft's reading: *changed* "is for a file … and a folder is not called *changed*"
    (`docs/CONTENT.md:L170`). Meanwhile the product draws **M** on a submodule row and **U** on a nested
    repository (`docs/CONTENT.md` RN-37, `:L904-L912`), and v11's own R-38 now distinguishes "the file's or
    the folder's" row. Read cold, then, R-35 marks files, R-38 admits folder rows, and no rule says which
    folder rows are marked. That is the reading the prompt's bar asks of a document's own reader, not a
    matter of taste.
  - **Cost.** No extra cycle: `product-fdr` folds this companion in any case, and the reword rides that fold.
  - **Check 3.** No settled document moves. CONTENT RN-37 is settled and already states the folder rows'
    letters. SDD RN-95 already says *the row's name*. The draft's own *If overridden* names exactly this
    reword, with "no other entry moves".
  - **Check 4: failure paths.**
    - Concurrent: an agent edits `.gitmodules` mid-session. Each status read re-runs the checks, so the next
      refresh fails or recovers whole (R-74, R-83, R-191).
    - Refused: under R-186 – R-190 the tree and the reading panel stay the route out (R-86).
    - Empty: a repository with no submodules and no alternates passes every check, and R-185 – R-191 say
      nothing about it.
    - Not covered by this answer: **A**, **D**, **R** or **C** on a folder row. CONTENT RN-37 leaves those
      unstated "until a site shows one", so the reworded R-35 names only the two folder sites known now.
  - **What would have tipped it to a confirm.** A rule elsewhere in this document saying which folder rows
    carry a letter. None does.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/fdr.md`** — `<CORE>/launchers/skill/launcher.sh product-fdr ka-reader`
