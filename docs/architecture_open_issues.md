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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-11-07, reading the
> settled NFDR against the product at `ka-reader@3fa227e`, where the read-only harness gained the
> offline-page check. Three items follow in § 3; neither record is edited.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 § 9's harness-suites bullet counts fifteen suites; the tree holds seventeen
- **Raised by:** PM — 2026-11-07
- **Which record:** NFDR § 9, the bullet "The harness's own suites, `checks/tests/`, run as steps of `checks/gate.sh`"
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the bullet's count and its "all fifteen" are two short.
- **Where it shows:** `docs/nfdr.md:L2654`, its count at `:L2709` ("Three of the fifteen") and `:L2730` ("all fifteen"), last measured at `ka-reader@33b8661`. At `ka-reader@3fa227e`, `ls checks/tests/*.sh | wc -l` → `17`, `test_offline_page.sh` among them, the whole command of the gate step *Offline page suite* (`checks/gate.sh:L120`); each suite is the whole command of one `run_step` line.
- **If a document has to be written:** none — the bullet is re-measured at the current tree.
- **Answer:** <the owner fills this in>

### 3.2 QC-2's locator for the walk's dropped Git answer points at lines that no longer hold it
- **Raised by:** PM — 2026-11-07
- **Which record:** NFDR QC-2, the sentence "The walk drops the Git answer (`checks/walk.rs:L288-L292`)"
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the locator names no commit and resolves to other code.
- **Where it shows:** `docs/nfdr.md:L135`, `:L145` and `:L6324` cite `checks/walk.rs:L288-L292`. At `ka-reader@3fa227e` the drop and the comment above it are `checks/walk.rs:L1237-L1241` (`let _ = read_git(FolderModel::new(opened), &Libgit2);` at `:L1241`).
- **If a document has to be written:** none — the locator is re-pinned with its commit.
- **Answer:** <the owner fills this in>

### 3.3 No record states the check scripts' exit statuses, so their usage exit of 2 departs from the shell packet with nothing setting the packet line aside
- **Raised by:** PM — 2026-11-07
- **Which record:** NFDR § 9 (the harness), or wherever the NFDR states what a check script's exit means
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; every later change that writes a check script meets the same departure with no record to cite.
- **Where it shows:** the shell packet's `errors_logging.md` (`:L33`) reads "The corpus uses exactly two exit values, `exit 0` … and `exit 1` …. There is no third status". Two check scripts exit 2 on a wrong argument count: `checks/read-only.sh:L98` and `checks/offline-page.sh` (its header, `:L19`, "count is not one: exit 2"). `grep -n 'exit 2\|exit status' docs/nfdr.md` finds only gitleaks' `--exit-code 2` (`:L1253`), not a check script's own status. Neither `docs/fdr.md` nor an ADR states it.
- **If a document has to be written:** none — the NFDR states the check scripts' exit statuses (0 pass, 1 refusal, 2 a wrong invocation) as the product's own, setting the packet line aside, or says they exit 0 or 1 alone.
- **Answer:** <the owner fills this in>
