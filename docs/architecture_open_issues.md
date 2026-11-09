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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-11-09, reading the
> settled NFDR against the product at `ka-reader@06e4a34`, where the tree gained `LICENSE`,
> `SECURITY.md`, `THIRD_PARTY_NOTICES.md`, `checks/notices.sh` and its suite
> `checks/tests/test_notices.sh`, and `checks/gate.sh` 1.12.0 runs both as fatal steps. Five items
> follow in § 3; neither record is edited.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-41 says the notices check runs at the release only; it now runs at every change, with a suite
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR QC-41, its *verified by:* tail, and its § 10 row
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; QC-41 reads false against the tree, and the release's later work cites it.
- **Where it shows:** `docs/nfdr.md:L1598-L1600` ends the *verified by:* "(the release)", and the § 10 row at `:L3286` reads `checks/notices.sh` | the release | release, with no suite. At `ka-reader@06e4a34`, `checks/gate.sh:L129` runs *Notices check* (`checks/notices.sh`) and `:L130` *Notices check suite* (`checks/tests/test_notices.sh`), both fatal, so the check runs at the change through the gate and at the release through the release workflow's gate step.
- **If a document has to be written:** none — QC-41's tail names the change as well as the release, and its row reads `checks/notices.sh` (suite `test_notices.sh`) | the tree | the change (the gate's *Notices check* step); the release.
- **Answer:** <the owner fills this in>

### 3.2 § 9's harness-suites bullet counts twenty-two suites; the tree holds twenty-three
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR § 9, the bullet "The harness's own suites, `checks/tests/`, run as steps of `checks/gate.sh`"
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; the bullet's count is one short and names `gate.sh` at 1.11.0.
- **Where it shows:** `docs/nfdr.md:L2805-L2806` ("Twenty-two top-level shell suites are in the tree at `ka-reader@2d7c4f9`, each the whole command of one `run_step` line of `checks/gate.sh` (1.11.0)"). At `ka-reader@06e4a34`, `ls checks/tests/*.sh | wc -l` → `23`; the new one is `test_notices.sh`, the whole command of `checks/gate.sh:L130`, and `checks/gate.sh:L2` reads `# Version: 1.12.0`.
- **If a document has to be written:** none — the bullet is re-measured at the current tree.
- **Answer:** <the owner fills this in>

### 3.3 QC-70's dated reading of the statuses the tree holds names none of `checks/notices.sh`'s
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR QC-70, the sentence "At `ka-reader@2d7c4f9` the tree holds the `3fa227e` reading below … and adds: …"
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; the statuses are within QC-70's five, but its reading of where each occurs is out of date.
- **Where it shows:** `docs/nfdr.md:L2588-L2596`. At `ka-reader@06e4a34`, `checks/notices.sh` exits 2 on a wrong count (`:L48`) and traps `trap 'exit 130' INT` and `trap 'exit 143' TERM` (`:L39-L40`).
- **If a document has to be written:** none — the reading is re-measured at the current tree.
- **Answer:** <the owner fills this in>

### 3.4 QC-41's "every release carries `LICENSE` … and a `THIRD_PARTY_NOTICES.md`" does not say whether the disk image carries them
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR QC-41, its statement (traces to SRS C-5)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** the release's packing and its check: whether `KA-Reader-<version>.dmg` must hold the two files decides whether `ka-reader-mac/assemble.sh` and `checks/bundle.sh` change before the first tag.
- **Where it shows:** `docs/nfdr.md:L1596-L1597`. At `ka-reader@06e4a34` both files are at the repository root, so the release's source at its tag carries them; the bundle carries only the icon set's licence, `cp "$GLYPH_LICENSE" "$APP/Contents/Resources/LICENSE"` (`ka-reader-mac/assemble.sh:L111`), and no copy of the product's `LICENSE` or of `THIRD_PARTY_NOTICES.md`.
- **If a document has to be written:** none — QC-41 states which artifact "carries" means: the tagged source alone, or the disk image as well.
- **Answer:** <the owner fills this in>

### 3.5 QC-41's notices list each crate "with its licence"; the licences' own terms also ask for each component's copyright line
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR QC-41, its statement (traces to SRS C-4, C-5)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked today; how far the notices meet the MIT and Apache-2.0 attribution terms is a call no product record makes, and `checks/notices.sh` checks names only.
- **Where it shows:** `docs/nfdr.md:L1596-L1597`. At `ka-reader@06e4a34`, `THIRD_PARTY_NOTICES.md` gives each crate's licence expression and each licence's text once, and no crate's own copyright line. Of the 52 registry packages `cargo metadata --locked --offline` resolves, 35 carry a `Copyright` line in their licence file (aho-corasick, bitflags, cc, cfg-if, equivalent, errno, … ). None ships a `NOTICE` file.
- **If a document has to be written:** none — QC-41 states whether a notice entry carries the component's copyright line as well as its licence. This is a judgement on the licences' terms, and the owner may answer it.
- **Answer:** <the owner fills this in>
