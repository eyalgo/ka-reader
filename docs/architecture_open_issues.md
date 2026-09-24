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
- **Answer:** <the owner fills this in>

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
- **Answer:** <the owner fills this in>

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
- **Answer:** <the owner fills this in>

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
- **Answer:** <the owner fills this in>

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
- **Answer:** <the owner fills this in>

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
- **Answer:** <the owner fills this in>

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
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
