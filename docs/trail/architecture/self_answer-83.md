# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `adr/` and `nfdr.md` (NFDR v88, Settled)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-09
- **Sources re-read:**
  - The MIT licence, at `https://opensource.org/license/mit`. Its condition: "The above copyright
    notice and this permission notice shall be included in all copies or substantial portions of the
    Software." 3.4 and 3.5 rest on it.
  - The Apache License 2.0, at `https://www.apache.org/licenses/LICENSE-2.0`, § 4. Redistribution
    "in Source or Object form" is allowed on conditions: (a) give any other recipients a copy of the
    licence; (c) keep the notices in the *Source* form only; (d) carry the attribution notices of a
    `NOTICE` file. 3.4 and 3.5 rest on it.
  - The LGPL-2.1, § 6. The run could not reach it at `gnu.org` (HTTP 429). It was read instead in the
    full text `THIRD_PARTY_NOTICES.md` carries for LibXDiff: "You must give prominent notice with
    each copy of the work that the Library is used in it … You must supply a copy of this License."
    3.4 rests on it.

The companion holds five items, all in § 3, all raised by the PM on 2026-11-09 against
`ka-reader@06e4a34`, and none answered. The run decided all five in the owner's seat. Every
measurement below was taken at `06e4a34`. `checks/`, `ka-reader-mac/`, `.github/`, `LICENSE` and
`THIRD_PARTY_NOTICES.md` are byte-identical there and at `HEAD` (`3a4aeef`), so the readings hold at
both.

Each item carries an *If a document has to be written* line, which is the PM's draft of the change.
The run weighed that line as a draft. 3.1–3.3 put forward a change, and each is confirmed with what
the same measurement also owes. 3.4 and 3.5 restate their question ("QC-41 states which …"), so
each was answered from scratch.

## Items worked

### 3.1 — QC-41 says the notices check runs at the release only; it now runs at every change, with a suite

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item is right. QC-41's tail ends "(the release)", and its § 10 row says the check runs
  over "the release" and is gated at "release". At `06e4a34`, `checks/gate.sh:L129` runs *Notices
  check* (`checks/notices.sh`) and `:L130` runs *Notices check suite*
  (`checks/tests/test_notices.sh`), both through the fatal `run_step`. `ci.yml` runs the gate on
  every push, and `release.yml`'s *Test gate* step runs it at a tag. So the record understates where
  the check holds. This is a correction, not a widening.
  The addition is the map's own wording. The PM's draft row put `the change` under *Runs over*.
  But this check reads the tree: `cargo tree` and the notices file, not a change's diff. Every other
  gate-run tree check reads `the tree | CI build`, and QC-49, which also runs at the release, reads
  `the tree | CI build; release`. § 10's preamble already reads `CI build` as
  `development-implementation` as well. So the row is `checks/notices.sh` (suite `test_notices.sh`) |
  the tree | CI build; release. The tail follows QC-53's form (`docs/nfdr.md:L1972`): "(the tree), run
  by the gate's … step". It also names the suite, because § 10's preamble ties the suite tag to a
  script that has one.
  Check 4: once Actions is off, `CI build` still reads `development-implementation`, by the
  preamble's rule, so the change-time gate does not lapse. `checks/notices.sh`'s own refusals
  (unreadable file, `cargo tree` failing or empty) each end 1, so the check cannot pass on a
  comparison it did not make.
  Decided together with 3.4, which adds the bundle's half to the same tail and row.

### 3.2 — § 9's harness-suites bullet counts twenty-two suites; the tree holds twenty-three

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The fact is false, and the measurement is what settles it. At `06e4a34`,
  `git ls-tree --name-only 06e4a34 checks/tests/` lists 23 top-level `.sh` suites. Each is the
  whole command of exactly one `run_step` line of `checks/gate.sh`, matched as a whole line, and the
  gate's header reads `# Version: 1.12.0`.
  The addition has two parts:
  1. **Every locator moved, not only the count.** The new block at `:L123-L130` pushed every later
     line down, so all 23 are re-pinned. The answer slot lists them.
  2. **The bullet's own pairing sentence moves with the count.** "Three of the twenty-two have no
     `checks/<name>.sh` of their own name" (`docs/nfdr.md:L2868`) becomes "Three of the
     twenty-three". `test_notices.sh` pairs by name with `checks/notices.sh`, so the three without a
     pair are the same three as before.

  The twenty-two at `2d7c4f9` are kept as a dated reading, as v87 kept the seventeen. The bullet's
  rule, that a script landing with a suite lands it as a gate step in the same change, held for this
  merge, so nothing about the rule moves.

### 3.3 — QC-70's dated reading of the statuses the tree holds names none of `checks/notices.sh`'s

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item is right. `checks/notices.sh` has `exit 2` on a wrong count (`:L48`) and
  `trap 'exit 130' INT` / `trap 'exit 143' TERM` (`:L39-L40`). QC-70's reading at `2d7c4f9` names
  neither. All of them are inside QC-70's five statuses, so the obligation does not move; only the
  reading of where each status occurs does.
  Three additions, all from the same measurement:
  1. **The script's own header names a second signal path.** A signal landing inside a command
     substitution may end the script with 1 (`checks/notices.sh:L18-L19`). That is inside QC-70's
     "or 1 on a signal" and never 0. The suite holds it: `test_a_signal_never_ends_with_zero`
     (`checks/tests/test_notices.sh:L283`) accepts 143 or 1 and nothing else. QC-70's
     "may map a signal to 1" names scripts that do so through a trap. This is a different path, so
     the reading names it rather than listing the script among the mappers.
  2. **`run_step` moved.** It is at `checks/gate.sh:L42-L49` at `06e4a34`. QC-70 pins it at
     `:L40-L47` at `2d7c4f9`, which becomes its dated reading.
  3. **The *verified by:* list gains a suite.** It names the suites that assert the 2 "where a script
     refuses a wrong invocation today". `checks/tests/test_notices.sh` now does too:
     `test_wrong_argument_count_is_a_usage_error` (`:L264`).

  Re-measured as well: each of the fifteen script locators the `2d7c4f9` and `3fa227e` readings name
  holds the same line at `06e4a34`. The literal scan, `grep -ohE 'exit [0-9]+' checks/*.sh`, still
  finds only 0, 1, 2, 130 and 143.
  Check 4: QC-70's review gate, `development-design` holding a new script's statuses, is what should
  have caught this at the notices change. The suite case asserting each status exists, so that
  change met the entry, and only the dated reading is stale.

### 3.4 — QC-41's "every release carries `LICENSE` … and a `THIRD_PARTY_NOTICES.md`" does not say whether the disk image carries them

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** Both files go in the disk image as well as the tagged source, and inside the app bundle.
  - **The seat is this one.** The change lands in QC-41, so it lands in this document. It commits
    the owner to nothing they have not already decided: when the owner confirmed MIT, they recorded
    "whatever ka-reader ships as, it will bundle third-party components whose licences ride along —
    the release has to carry their notices" (`docs/trail/prd/cycle-1.md` § 2.5). SRS C-5 says the
    same about "the third-party components it ships". The question is which artifact that sentence
    means. Of the two readings, the stricter one takes on less legal risk, not more. I can name no
    ground I cannot see. What would have tipped this to the owner: an answer that met the licences
    less fully than their text asks, because that is a risk only the owner can take on.
  - **Why the image.** The licences bind the copy a stranger receives, and that copy is the image.
    The source archive beside it is a separate download most installers never open. MIT asks for its
    notices in "all copies or substantial portions of the Software". The binary statically links
    MIT-only crates (`pulldown-cmark`, the `tree-sitter` family). Apache-2.0 § 4 allows Object-form
    redistribution on the condition (a) that recipients get a copy of the licence. The LGPL-2.1 text
    the notices carry for LibXDiff, which `libgit2-sys` compiles in, asks in § 6 for notice "with
    each copy of the work" and a copy of the licence.
  - **Why inside the bundle.** `checks/release-pack.sh` holds the volume to one item, KA-Reader.app,
    with "no other file". A file on the volume beside the app would break that rule, and it would be
    left behind when the app is dragged to Applications. Inside `KA-Reader.app` the files travel with
    every copy. There is already a precedent: the bundle carries the icon set's licence at
    `Contents/Resources/LICENSE` (`ka-reader-mac/assemble.sh:L111`).
  - **Verified by:** `checks/bundle.sh` and its suite. It fails when the built bundle lacks either
    file, or holds one that differs from the tree's: the tree; CI build; release. Release inspection
    runs it on the downloaded bundle too (SDD S-7's command list already runs `checks/bundle.sh`
    there). Until `bundle.sh` holds the rule, `development-design` reading QC-41 is its gate, by the
    NFDR header's per-rule executability rule.
  - **Check 4.**
    - *Absent:* `assemble.sh` already refuses to build when the icon licence is missing (its
      `required` loop, `:L44`). The two files belong in that loop, so a checkout without them
      builds no bundle.
    - *Stale:* the byte-identity check catches a bundle copied from an older notices file.
    - *Two files, one name:* the product's `LICENSE` cannot take `Contents/Resources/LICENSE`, which the icon
      licence already holds. It needs its own name inside the bundle, and choosing it is the delivery
      tier's.
    - *Refused:* a file added after `codesign` breaks the seal (`assemble.sh` step 5's own comment),
      so both files are copied in step 4.
  - **The SDD is not owed a change.** C-R2's "two entries" are entitlements, not bundle contents, and
    nothing the SDD states becomes false.
  - Decided together with 3.1, whose tail and row this extends.

### 3.5 — QC-41's notices list each crate "with its licence"; the licences' own terms also ask for each component's copyright line

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** Yes. Each entry carries its component's copyright lines as well as its licence.
  - **The seat.** The PM wrote that "the owner may answer it". That is permission, not a
    reservation, and it names no ground the run cannot see. The answer chooses the reading that
    meets the licences' own text. It binds no party and takes on no risk beyond the owner's recorded
    decision that the release carries the notices the licences require, so it is answered in the
    owner's seat. What would have tipped it to the owner: choosing to carry *less* than the text asks
    (names and licences only) to save effort, because that is a legal risk the owner carries.
  - **The measurement.** At `06e4a34`, `THIRD_PARTY_NOTICES.md` gives each crate's licence
    expression and each licence's text once, and no crate's copyright line. Its entries for the
    libraries the crates compile already carry theirs: PCRE2 at `:L1281-L1300`, the IETF Trust at
    `:L1354`, Unicode at `:L339`. So the crates are the inconsistent half. The PM counted 35 of 52
    packages with a `Copyright` line in their licence file. The run re-read two MIT-only crates the
    bundle links: `pulldown-cmark` 0.13.6, "Copyright 2015 Google Inc. All rights reserved.", and
    `tree-sitter` 0.27.0, "Copyright (c) 2018 Max Brunsfeld".
  - **The grounds.** MIT asks for "the above copyright notice and this permission notice". The
    licence text alone, without the line above it, meets half of that condition. Apache-2.0 alone
    would not ask for the line in Object form: § 4(c) binds Source form only, and § 4(d) binds a
    `NOTICE` file, of which none ships.
  - **Why one rule and not an election per crate.** For a crate under `MIT OR Apache-2.0`, electing
    Apache would avoid the line. But the notices name each licence "as the crate declares it" and
    elect nothing. An election per crate would be a second record, beside the lockfile, that has to
    be kept true on every dependency change. One rule is simpler and holds under any licence a reader
    takes: carry every copyright line the component's own licence file states.
  - **Check 4.**
    - *Absent:* a package that ships no licence file, or one with no copyright line, is named as such
      in its entry rather than passed silently.
    - *Stale:* an update that changes a crate's line fails the same check, because the check reads
      the version `Cargo.lock` resolves.
    - *The first of its kind:* a component with a `NOTICE` file would carry it whole under § 4(d). None does today,
      and the rule covers the first one that does.
  - **Verified by:** `checks/notices.sh`, extended to read each resolved package's licence file and
    fail on a copyright line the notices lack: the tree; CI build; release. It reads the offline
    registry sources, as the check already runs offline. How it reads them is the delivery tier's.
    Until the extension lands, `development-design` reading QC-41 is the gate, and release
    inspection reads the lines before the first tag.
  - Close to *left for the owner*, because it is a licence-terms judgement. Not left, because both
    readings were weighed against the licence texts themselves, and only the stricter one meets MIT
    as written.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
