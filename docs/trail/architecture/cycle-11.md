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

> **No `product-architecture` run opened this companion. The PM opened it on 2026-09-24.**
> `nfdr.md` is Settled at v13 and the records had no companion on disk, so a `product-architecture`
> re-run would read them as done and find nothing to act on. The companion holds seven items,
> §§ 3.1 – 3.7. Each was found by measuring the tree on `main` at `nozoki@0aca57e`, where the Tauri
> build left the tree, against these records. Each states a fact the records hold that is now false.

---

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 § 1's opening paragraph says the tree holds both shapes, and it holds one
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` § 1, the opening paragraph
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing gates on it. It is a false statement of what the tree holds, and every
  entry reads its units off this paragraph.
- **Where it shows:** `nfdr.md:L50-L56` says "**The tree holds both shapes** … `crates/nozoki-app`
  and `nozoki-ui` still stand beside them (`ls`, 2026-09-23) until the change that removes the
  Tauri build". Both left at `nozoki@0aca57e`: `git ls-files nozoki-ui crates/nozoki-app | wc -l`
  → `0`. The tree holds exactly ADR-0016's four units.
- **If a document has to be written:** None. **The PM's lean:** a dated in-place correction, in the
  form v13 used for this same paragraph, saying the tree holds ADR-0016's four units from
  `nozoki@0aca57e`. The scripts not yet in the tree (`view.sh`, `renderer.sh`, `structure.sh`,
  `entry-points.sh`) stay as the entries name them.
- **Answer:** Confirmed, with one addition. Make a dated in-place correction in v13's form: from
  `nozoki@0aca57e` the tree holds ADR-0016's four units and nothing else (`git ls-files nozoki-ui
  crates/nozoki-app | wc -l` → `0`). The paragraph's closing clause, "the same reading now for the
  old ones while they remain", goes with it, because nothing old remains. **Addition:** measure with
  `git ls-files`, not `ls`, the tool the v13 sentence used. A working copy can still list
  `nozoki-ui/` and `crates/nozoki-app/` as untracked build output. This checkout does, on
  2026-09-24: `node_modules/`, `dist/`, `gen/`, `permissions/`. An `ls` there would bring back the
  false fact. The four scripts not yet in the tree stay as the entries name them. Reasoning:
  `docs/trail/architecture/self_answer-14.md` § 3.1.

### 3.2 QC-3's tail still describes its one-time review as owed, and the list it describes is gone
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` QC-3, the tail of its second half
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** A reader cannot tell from QC-3 whether any name on `checks/deps.allow` still
  lacks the review. That is the question the second half exists to close.
- **Where it shows:** `nfdr.md:L96-L101` says the names on the list, "218 cargo and 163 pnpm", were
  never reviewed, and that "the change that first realizes this half reviews them once". At
  `nozoki@0aca57e` the list is one `cargo:` section of 17 names (`checks/deps.allow:L18` onward;
  `awk '/^cargo:/{p=1;next} p && !/^#/ && NF' checks/deps.allow | wc -l` → `17`), the pnpm section
  is gone, and `checks/no-network.sh` reads only that section. The file's own header states what
  review of it checks (`checks/deps.allow:L12-L16`).
- **If a document has to be written:** None. **The PM's lean:** the tail says the half was realized
  at `nozoki@0aca57e` over the 17 names the list kept, that the names that left with the Tauri build
  left unreviewed, and whether every name now on the list has passed the review. The seat checks
  that last clause against the review record rather than taking it from here.
- **Answer:** Overridden in one clause. The half was **not** realized at `nozoki@0aca57e`, and the
  tail must not say it was. The tail should say this: at `nozoki@0aca57e` the list is one `cargo:`
  section of 17 names (`checks/deps.allow:L18` onward). The `pnpm:` section (163 names) and 201 of
  the 218 cargo names left with the Tauri build (`nozoki@fad4e78`), unreviewed, and none of them is
  shipped now. The 17 that stayed were among the 218 that were never reviewed. So the one-time
  review is still owed, over those 17, by the change that first realizes this half, and the rest of
  the tail stands as written. No record shows that review. `nozoki@6acfb65` generated the list and
  "read" the names against the header's rules. That is a reading by name, and QC-3 itself says a
  name alone cannot answer the question. `nozoki@fad4e78` records only that the tree equals the
  list. Reasoning: `docs/trail/architecture/self_answer-14.md` § 3.2.

### 3.3 QC-25 cites the expected entitlement set five lines high
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` QC-25, the tail of its first half
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** A reader following the citation lands on the wrong lines of `checks/bundle.sh`.
- **Where it shows:** `nfdr.md:L348` cites `checks/bundle.sh:L127-L128`. On `main`,
  `grep -n EXPECTED_ENTITLEMENTS checks/bundle.sh` → `132:`. The set is `:L132-L133`, because the
  contents block above it grew.
- **If a document has to be written:** None. **The PM's lean:** cite `:L132-L133` as read at
  `nozoki@0aca57e`, or pin the old range to the commit it was read at.
- **Answer:** Confirmed, with one addition. Of the two options, take the first: QC-25 cites
  `nozoki@0aca57e:checks/bundle.sh:L132-L133`, the current range pinned to the commit it was read
  at. That is the form § 3.7 uses. If the contents block grows again, the citation still opens to the
  right lines instead of silently pointing at the wrong ones. **Addition:** two Review Notes also
  cite this script's old ranges: `nfdr.md:L1772` (`:L127-L128`, "opened this run") and `:L1827`
  (`:L127-L187`). Both are dated history, read at their own fold, and were true when read. This
  answer does not move them. Only QC-25 is a live entry. Reasoning:
  `docs/trail/architecture/self_answer-14.md` § 3.3.

### 3.4 § 9 says CI does not build `nozoki-mac`, and CI now builds it twice
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` § 9, the toolchain clause of the `nozoki-mac`-against-the-Swift-packet bullet
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** The recorded Swift toolchain version, which the packet has this document hold
  where no `.swift-version` pin exists, and the flip of the bullet's three departures, which waits on
  that version being 6.2 or later.
- **Where it shows:** `nfdr.md:L899-L903` says "CI does not build `nozoki-mac` (`.github/workflows/ci.yml`
  at `nozoki@99e2bac` builds the Tauri shape …) … has no value yet". On `main`, `ci.yml:L26` runs
  `swift test --package-path nozoki-mac` in `Test gate`, and `:L29` runs `nozoki-mac/assemble.sh`.
  The value is still unread: `origin/main` is at `a4ab8e6`, so no CI run has yet built `nozoki-mac`
  (`git rev-list --count origin/main..main` → `9` on 2026-09-24).
- **If a document has to be written:** None. **The PM's lean:** the clause says CI builds
  `nozoki-mac` from `nozoki@0aca57e` in two steps, and takes the Swift version and the run id from
  the first CI log on `main` that runs them. If that version is 6.2 or later, the same bullet's
  "adopted then" clause comes due.
- **Answer:** Confirmed, with two additions. The clause should say that from `nozoki@0aca57e`, CI
  builds `nozoki-mac` in two steps: `ci.yml:L26` runs `swift test` in `Test gate`, and `:L29` runs
  `nozoki-mac/assemble.sh`. It should also say the value is still unread, because no CI run on
  `main` has built it yet (`origin/main` is at `a4ab8e6` on 2026-09-24). If the first log shows 6.2
  or later, the "adopted then" clause comes due, as the lean says. **Addition 1, if the log says
  nothing:** `ci.yml` has no `swift --version` step (`:L22-L29`), and this run does not know whether
  `swift test`'s output names the toolchain. If the first log does not name it, the toolchain line
  stays *not yet measured* and says what it is waiting for. The tail's review gate then stands
  until a log names the toolchain. Today the tail says "until CI builds `nozoki-mac`", and that
  condition is now met. **Addition 2, if the value goes stale:** `macos-14`'s default Xcode can
  move under the same label. So the line records the runner image version beside the run id and
  the Swift version. Reasoning: `docs/trail/architecture/self_answer-14.md` § 3.4.

### 3.5 § 9 and a Review Note cite `release.yml:L18`, and no `release.yml` exists
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` § 9 (the same bullet as § 3.4) and the Review Note at `:L2141`
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** The image claim rests on two citations, and one resolves to nothing.
- **Where it shows:** `nfdr.md:L910` and `:L2141` cite `release.yml:L18` beside `ci.yml:L18`.
  `ls .github/workflows` → `ci.yml`. `ci.yml:L18` is `runs-on: macos-14` and holds on its own.
  (`:L454` names `release.yml` as the file a release builds from, which is an obligation, not a
  citation, and is not this item.)
- **If a document has to be written:** None. **The PM's lean:** cite `ci.yml:L18` alone until a
  `release.yml` exists.
- **Answer:** Confirmed, with one addition. `:L910` and the Review Note at `:L2141` cite
  `ci.yml:L18` alone. **Addition:** RN-24's source list at `nfdr.md:L2218` also names `release.yml`
  as a file it read. `git log --all --oneline -- .github/workflows/release.yml` prints nothing,
  2026-09-24. The file has never existed in this repository, so the name comes off that list as well.
  `:L454` stands: it states an obligation, not a citation. Reasoning:
  `docs/trail/architecture/self_answer-14.md` § 3.5.

### 3.6 § 9 says every Swift packet rule it does not name is followed, and `checks/no-network.sh` departs from the packet's dependency gate
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` § 9, the `nozoki-mac`-against-the-Swift-packet bullet
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** A delivery reader holding § 9 and the packet would write the packet's gate,
  and it fails the tree as built.
- **Where it shows:** The bullet says "a rule of it not named here is followed as written"
  (`nfdr.md:L889-L890`). The packet's dependency gate also refuses any target whose `type` is
  `"system"` (`<CORE>/doctrine/engineering/languages/swift/quality_gates.md:L45`, `… select(.url !=
  null or .type == "system") …`). `nozoki-mac` links the bridge through
  `.systemLibrary(name: "CNozokiBridge")` (`nozoki-mac/Package.swift:L19`), so that gate would fail
  it. `checks/no-network.sh` fails on two things only, a non-empty `dependencies` array and a target
  carrying a `url` (`checks/no-network.sh:L31-L32`), and reads the dump with `plutil`, not `jq`.
  The bullet already records the system-library link as a departure. It does not record what that
  link does to the packet's gate.
- **If a document has to be written:** None. **The PM's lean:** the bullet names the gate's
  `type == "system"` clause as departed from, with the same reason as the link (a system library
  target brings nothing into the tree), and names `checks/no-network.sh` as the gate that stands in
  its place.
- **Answer:** Confirmed, with two additions. The bullet names the packet gate's
  `type == "system"` clause as departed from, for the same reason as the system-library link. The
  bridge's module is this repository's own `nozoki-bridge`, which is on `checks/deps.allow`, so the
  link brings nothing new into the tree. The bullet names `checks/no-network.sh` as the gate that
  stands in its place. **Addition 1, what the stand-in covers:** the departure is that one clause
  and nothing else. `checks/no-network.sh` holds the packet's other two conditions, a non-empty
  `dependencies` array and a target with a `url` (`:L31-L32`). It also holds `Package.resolved`
  more widely than the packet does: at any depth, not only in the working directory. It reads the
  dump with `plutil`, not `jq`. **Addition 2, when the departure ends:** the clause departs only
  because `.systemLibrary(name: "CNozokiBridge")` exists (`Package.swift:L19`). So it flips
  together with the three departures this bullet already names. When the artifact-bundle link
  replaces the system library, no target has `type == "system"`, and the packet's gate is followed
  as written. Reasoning: `docs/trail/architecture/self_answer-14.md` § 3.6.

### 3.7 Seven citations in these records point into files that no longer exist, with no pin
- **Raised by:** PM — 2026-09-24
- **Which record:** `nfdr.md` § NFDR Review Notes; `adr/0012-renderer-run-proved-on-the-shipped-bundle-beside-the-wall.md`
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Each citation resolved to a file at `HEAD` until `nozoki@0aca57e`, and none
  does now. A reader cannot follow them without knowing which commit they were read at.
- **Where it shows:**
  - `nfdr.md:L1495` (`crates/nozoki-app/tests/config.rs:L17`, `:L181-L188`; `tauri.conf.json:L12`)
  - `nfdr.md:L1603` (`crates/nozoki-app/src/log_writer.rs:L142`)
  - `nfdr.md:L1607` (`crates/nozoki-app/tests/config.rs:L11`)
  - `nfdr.md:L1622` (`crates/nozoki-app/src/log_writer.rs:L201`)
  - `adr/0012-…md:L13-L14` and `:L132` (`nozoki-ui/src/main.ts:L14-L19`; `crates/nozoki-app/src/main.rs:L17-L19`)

  Found with `grep -n "crates/nozoki-app/[^\`]*:L[0-9]\|nozoki-ui/src/[^\` ]*:L[0-9]" docs/nfdr.md docs/adr/*.md`,
  less the lines already pinned (`nfdr.md:L1588-L1590` are pinned to `nozoki@bf99e8e` in their own
  sentence). ADR-0012 is Accepted.
- **If a document has to be written:** None. **The PM's lean:** pin each to `nozoki@a4ab8e6:`, the
  form RN-16 and RN-17 used when an earlier move orphaned citations.
- **Answer:** Confirmed, with one addition. Pin every one to `nozoki@a4ab8e6:`, giving the full path
  (for example `nozoki@a4ab8e6:crates/nozoki-app/tauri.conf.json:L12`). This run opened each cited
  line at `a4ab8e6`, and each reads as the records say: `config.rs:L11` `use std::fs;`, `:L17` and
  `:L181-L188` the CSP assertions, `tauri.conf.json:L12` the `csp` line, `log_writer.rs:L142`
  `log::set_logger`, `:L201` `fs::write`, `main.ts:L14-L19` `start()` calling `runStartFlow`, and
  `main.rs:L17-L19` `open_folder` with `pick_folder()`. None of these files changed between
  `a4ab8e6` and `15e8790`, the last commit before their removal. `a4ab8e6` is on `origin/main`, so a
  reader of the public repository can open the pin. **Addition:** ADR-0012 is Accepted. Its pins at
  `:L13-L14` and `:L132` are prose edits on the owner's cycle-3 ruling, the form RN-16 took. No
  record is superseded and the index does not move. `…/common/mod.rs:L11` at `nfdr.md:L1607` is
  `nozoki-core`'s file, which still stands, so it is out of scope. Reasoning:
  `docs/trail/architecture/self_answer-14.md` § 3.7.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
