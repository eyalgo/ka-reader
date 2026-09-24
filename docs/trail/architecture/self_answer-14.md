# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The NFDR is Settled at v13. The PM opened the companion on 2026-09-24; no `product-architecture` run did.
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-24
- **Sources re-read:**
  - The Swift packet's `quality_gates.md` at `<CORE>/doctrine/engineering/languages/swift/`.
    `:L45` is the dependency gate:
    `select(.url != null or .type == "system")`, read through `jq`, with `test ! -e Package.resolved`
    in the working directory. (§ 3.6)
  - No web source. Every other answer rests on this repository's tree, measured at `HEAD` =
    `nozoki@7608edb` and at the commits named.

## Items worked

### 3.1 — § 1's opening paragraph says the tree holds both shapes, and it holds one

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The lean is right. `git ls-files nozoki-ui crates/nozoki-app | wc -l` prints `0` at
  `HEAD`. The Tauri build was removed in `nozoki@fad4e78` and merged at `0aca57e`. So
  `nfdr.md:L50-L56`'s "the tree holds both shapes" is now false. It is a correction, not a widening.
  **The addition is about which tool measures it.** The v13 sentence cites `ls`, and `ls` in this
  checkout still lists `nozoki-ui/` and `crates/nozoki-app/`. Git never tracked that build output:
  `node_modules/`, `dist/`, `gen/`, `permissions/`. It is still on disk because the `.gitignore`
  lines that hid it left in `fad4e78`, and the working copy now shows it as `??`. A correction that
  kept `ls` as its measure would bring back the false fact on any machine that built the old shape.
  So it cites `git ls-files`. The sentence "the same reading now for the old ones while they
  remain (RN-24)" goes too, because nothing old remains. The four scripts not yet in the tree are
  checked by `ls checks/`, which lists `bundle.sh`, `no-network.sh`, `own-state.sh` and
  `read-only.sh` and none of the four. They stay as the entries name them, under the header's own
  rule that a command "becomes executable in the change that lands its script".

### 3.2 — QC-3's tail still describes its one-time review as owed, and the list it describes is gone

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** overridden
- **Why:** The lean asked this seat to check one clause against the review record: whether every
  name now on the list has passed the review. The record says no. Three measurements show it:
  - `nozoki@6acfb65` generated the list: 218 cargo names by
    `awk` over `git show 6acfb65:checks/deps.allow`, and 163 pnpm names by its commit body. The body
    says the list was "read for the libgit2, TLS/SSH and logging-domain rules". That is a reading by
    name. QC-3's own second half says a name alone cannot answer the domain question. The review it
    asks for is `cargo tree -e features -i <crate>`, in the features the lockfile resolves
    (`nfdr.md:L91-L95`).
  - `nozoki@fad4e78` cut the list to 17 cargo names. Its body records only that `cargo tree`
    "names exactly the 17 names".
  - No later commit touches `checks/deps.allow` (`git log -- checks/deps.allow`).

  So the part of the lean that says the tail should read "realized at `nozoki@0aca57e` over the 17
  names" is **replaced**. At `0aca57e`, the pnpm section and 201 cargo names left with the Tauri
  build without a review, and none of them is shipped now. The 17 that stayed were never reviewed,
  so the one-time review is still owed over them. The rest of QC-3's tail stands.

  I was close to *confirmed with addition*. It would have been that if the lean had not asserted
  realization. Answering this seat's own check by writing "the half was realized" would have
  recorded a review nobody made. **Not for this document:** by reading the 17 names (`itoa`,
  `libc`, `log`, `memchr`, `proc-macro2`, `quote`, the `serde` family, `syn`, `thiserror`,
  `thiserror-impl`, `unicode-ident`, `zmij`, and the two product crates), I see none whose domain is
  a transport. That is exactly the name-level reading QC-3 says is not the review, so it is only
  noted here.

### 3.3 — QC-25 cites the expected entitlement set five lines high

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** `grep -n EXPECTED_ENTITLEMENTS checks/bundle.sh` prints `132:`, and `:L132-L133` hold the
  two entitlements. `nfdr.md:L348` cites `:L127-L128`. The lean offered two options. I took the
  current range, pinned: `nozoki@0aca57e:checks/bundle.sh:L132-L133`. This is the form § 3.7's
  answer uses, so the two answers agree. It fits the case here too: this script has grown twice
  already, and a pin fails by being old, not by being wrong. **Addition:** the same script's old
  ranges also appear in two Review Notes, `:L1772` (`:L127-L128`, "opened this run") and `:L1827`
  (`:L127-L187`). `git show 99e2bac:checks/bundle.sh` has the set at `:L127-L128`, so they were true
  when their folds read them. They are dated history, so this answer does not move them. What
  would have tipped me: if a live entry cited them. None does
  (`grep -on 'bundle\.sh:L[0-9-]*' docs/nfdr.md docs/adr/*.md`).

### 3.4 — § 9 says CI does not build `nozoki-mac`, and CI now builds it twice

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** `.github/workflows/ci.yml:L26` is
  `cargo test --workspace --locked && swift test --package-path nozoki-mac`, and `:L29` is
  `nozoki-mac/assemble.sh`. `git rev-parse --short origin/main` prints `a4ab8e6`, and
  `git rev-list --count origin/main..main` prints `13`, so no CI run on `main` has built it. The
  only remote branches besides `main` are `ci-sandbox-diagnostic` and
  `copilot/fix-wall-github-actions-job` (`git branch -r`). The lean's clause is right.
  **Addition 1 (the log may not name the version):** the workflow has no `swift --version` step
  (`ci.yml:L22-L29`), and I don't know whether `swift test`'s output names the toolchain. Running it
  with its log read would settle that. So the answer states what happens if the first log is
  silent: the line stays *not yet measured*, and the tail's review gate stands until a log names
  the toolchain. Today the tail says the gate is a review "because no command reads which toolchain
  CI builds with until CI builds `nozoki-mac`". That condition is now met, while the value is still
  unread. **Addition 2 (the value can go stale):** `macos-14` is a label whose default Xcode the
  runner-images project can change. So the recorded value carries the image version with the run
  id. A later reader can then tell a re-measurement from a contradiction.

### 3.5 — § 9 and a Review Note cite `release.yml:L18`, and no `release.yml` exists

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** `ls .github/workflows` prints `ci.yml`, and `ci.yml:L18` is `runs-on: macos-14`, so
  `ci.yml:L18` holds the image claim alone. **Addition:** `grep -n 'release\.yml'` finds a third
  site the item did not list. RN-24's source list at `nfdr.md:L2218` names
  `.github/workflows/ci.yml`, `release.yml` among the files it read.
  `git log --all --oneline -- .github/workflows/release.yml` prints nothing, so the file never
  existed on any branch, and the claim that it was read is false in the same way. It comes off the
  list. `:L454` is an obligation (a release builds from `release.yml`) and stands, as the item says.

### 3.6 — § 9 says every Swift packet rule it does not name is followed, and `checks/no-network.sh` departs from the packet's dependency gate

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item's measurements check out:
  - The packet's gate at `quality_gates.md:L45` rejects `.type == "system"`.
  - `nozoki-mac/Package.swift:L19` is `.systemLibrary(name: "CNozokiBridge")`.
  - `checks/no-network.sh:L31-L32` fails on two things only.

  A delivery reader who followed the § 9 bullet's "followed as written" would therefore write a gate
  that fails the tree. The lean's reason holds: the system library is a module map over
  `nozoki-bridge`'s generated header, that crate is this repository's own and is on
  `checks/deps.allow`, and the link brings nothing new in. **Addition 1:** the departure names that
  one clause, because `no-network.sh` holds the other two (`dependencies`, a target `url`). It holds
  `Package.resolved` at any depth, which is wider than the packet's working-directory `test`. A
  reader then knows the stand-in is stricter everywhere except the one clause. **Addition 2:** the
  clause departs only because of the system-library link. So it flips with the bullet's three
  departures, one of which replaces that link with the `.binaryTarget` artifact bundle. Then no
  target has `type == "system"` and the packet's gate is followed as written. Without this, the
  bullet's "flip together or not at all" would leave a fourth departure behind.

### 3.7 — Seven citations in these records point into files that no longer exist, with no pin

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** confirmed with addition
- **Why:** The item's grep, re-run, finds the listed sites plus `:L1588-L1590`, which is already pinned
  to `nozoki@bf99e8e`. I opened every cited line with `git show a4ab8e6:<path>`, and each reads as
  the records say:
  - `config.rs:L11`: `use std::fs;`
  - `config.rs:L17`, `:L181-L188`: the CSP assertions
  - `tauri.conf.json:L12`: the `csp` string
  - `log_writer.rs:L142`: `log::set_logger(writer)?;`
  - `log_writer.rs:L201`: `fs::write(...)`
  - `main.ts:L14-L19`: `start()` calling `runStartFlow(invoke)`
  - `main.rs:L17-L19`: `open_folder` with `pick_folder()`

  `git diff --quiet a4ab8e6 15e8790` holds for all five files, so `a4ab8e6` pins the same text
  every citation was read against. `a4ab8e6` is `origin/main`, so a reader of the public repository
  can open it. **Addition:** ADR-0012 is Accepted. Its pins are prose edits of the kind RN-16 folded
  on the owner's cycle-3 ruling: no record is superseded and the index does not move.
  `…/common/mod.rs:L11` at `nfdr.md:L1607` sits after a `crates/nozoki-core/tests/common/mod.rs`
  citation. That file stands, and its `:L11` is `use std::process;`, so it is out of this item.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture nozoki`
