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
- **Answer:** Re-measure the bullet at `ka-reader@3fa227e` (its `checks/` tree unchanged at `ka-reader@03e10ee`): **seventeen** top-level suites, each the whole command of exactly one `run_step` line — the fifteen it names plus `test_tree_scene.sh` (*Tree scene helper suite*, `checks/gate.sh:L137`) and `test_offline_page.sh` (*Offline page suite*, `:L120`). The item names only the second; the tree-scene suite was already uncounted at `ka-reader@d6bc3a3` (sixteen there). Every per-suite locator is re-pinned at `3fa227e` (`:L57`, `:L75`, `:L88`, `:L90`, `:L93`, `:L95`, `:L105`, `:L116`, `:L118`, `:L120`, `:L126`, `:L127`, `:L128`, `:L134`, `:L135`, `:L136`, `:L137`), the bullet's own example (*Bundle probe suite*) moves to `:L93`, and the fifteen-suite reading at `33b8661` is kept as a dated reading like the ones before it. "Three of the fifteen" becomes "Three of the seventeen" — the two new suites pair with `checks/tree-scene.sh` and `checks/offline-page.sh` — and "all fifteen" becomes "all seventeen"; `ci.yml:L28` (`Test gate`) is unmoved. Reasoning: `docs/trail/architecture/self_answer-79.md` § 3.1.

### 3.2 QC-2's locator for the walk's dropped Git answer points at lines that no longer hold it
- **Raised by:** PM — 2026-11-07
- **Which record:** NFDR QC-2, the sentence "The walk drops the Git answer (`checks/walk.rs:L288-L292`)"
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the locator names no commit and resolves to other code.
- **Where it shows:** `docs/nfdr.md:L135`, `:L145` and `:L6324` cite `checks/walk.rs:L288-L292`. At `ka-reader@3fa227e` the drop and the comment above it are `checks/walk.rs:L1237-L1241` (`let _ = read_git(FolderModel::new(opened), &Libgit2);` at `:L1241`).
- **If a document has to be written:** none — the locator is re-pinned with its commit.
- **Answer:** Re-pin every *live* citation of the dropped Git answer with its commit: QC-2's tail (`docs/nfdr.md:L135`) reads `checks/walk.rs:L1237-L1241` at `ka-reader@3fa227e`, and QC-35's bound (2) (`:L1466`), which the item does not list, reads `checks/walk.rs:L1241` at the same commit for `read_git(…, &Libgit2)`. The old range held the drop from `ka-reader@ccc9e46` through `ka-reader@c915d52` and moved at `13074b3`, so the old locator is kept as a dated reading at `ka-reader@c915d52`. The quoted older tail (`:L145`) and the Review Notes that cite the old lines (`:L5850`, `:L6324`, `:L6345`) are records of their own readings and are not rewritten. QC-2's claim itself still holds: at `3fa227e` the walk still discards `read_git`'s answer (`let _ =`), so a case and not the walk still holds it. Reasoning: `docs/trail/architecture/self_answer-79.md` § 3.2.

### 3.3 No record states the check scripts' exit statuses, so their usage exit of 2 departs from the shell packet with nothing setting the packet line aside
- **Raised by:** PM — 2026-11-07
- **Which record:** NFDR § 9 (the harness), or wherever the NFDR states what a check script's exit means
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; every later change that writes a check script meets the same departure with no record to cite.
- **Where it shows:** the shell packet's `errors_logging.md` (`:L33`) reads "The corpus uses exactly two exit values, `exit 0` … and `exit 1` …. There is no third status". Two check scripts exit 2 on a wrong argument count: `checks/read-only.sh:L98` and `checks/offline-page.sh` (its header, `:L19`, "count is not one: exit 2"). `grep -n 'exit 2\|exit status' docs/nfdr.md` finds only gitleaks' `--exit-code 2` (`:L1253`), not a check script's own status. Neither `docs/fdr.md` nor an ADR states it.
- **If a document has to be written:** none — the NFDR states the check scripts' exit statuses (0 pass, 1 refusal, 2 a wrong invocation) as the product's own, setting the packet line aside, or says they exit 0 or 1 alone.
- **Answer:** The NFDR states the check scripts' exit statuses as the product's own, and does not narrow them to 0 or 1: **0** pass; **1** a refusal (a finding, or a precondition that failed); **2** a wrong invocation (a wrong argument count, with the usage line on stderr); **128 + n** when signal *n* ends the run through the script's own trap (`checks/read-only.sh:L215-L226`; `trap 'exit 130' INT` / `'exit 143' TERM` in `bundle.sh`, `renderer.sh` and `tree-scene.sh`); and a script whose job is to run one other check script exits with that script's status (`checks/own-state-step.sh:L61-L63`). No other status, and a pass is the only 0. It sets aside the shell packet's "exits 1 … no third status" line (`errors_logging.md:L33-L34`) for `checks/*.sh`, which the engineering doctrine's precedence lets the product's own records do (`languages/README.md` § Precedence), and it traces to SDD § 3's `read-only-harness` row, which already states `offline-page.sh`'s usage exit of 2. Narrowing to 0 or 1 would contradict that settled row and the four suite cases that assert 2 (`checks/tests/test_read_only.sh:L546`, `:L559`; `checks/tests/test_offline_page.sh:L327`, `:L332`). `checks/gate.sh`'s `run_step` reads only zero or non-zero, so no gate depends on which non-zero status a script returns. Verified by those suite cases and, for a new script, `development-design` reading the entry. Reasoning: `docs/trail/architecture/self_answer-79.md` § 3.3.
