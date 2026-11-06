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

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 The displayed-file scene's two gate steps are not yet recorded in § 9 or § 8
> Raised by a `companion-self-answer` run on 2026-11-06. No producing run wrote it. That run answered
> § 3.1 and read the gate at `ka-reader@d6bc3a3`, the same gate change that moved § 3.1's locator.
> It found two more facts the NFDR has not taken in, and it raises them here.
> Reasoning: `docs/trail/architecture/self_answer-73.md` § *Raised on this document*.
- **Lands in:** `nfdr.md` § 9 (the paragraph on the three scenes) and § 8 (the dated gate readings)
- **Drafted into the records:** nothing yet. The fold would make two changes. (a) § 9 says "The three scene commands and their regression cases each enter the product gate under QC-64 when their slice delivers", then lists only the tree scene's steps. It should list the displayed-file scene's steps too: *Displayed-file scene* (`cargo test --locked -p ka-reader-bridge --test open_file_scene`) and *Read-only, displayed-file scene* (`checks/read-only.sh checks/fixtures/open-file-scene`), at `checks/gate.sh:L112-L113` at `ka-reader@d6bc3a3`. The tree scene's steps keep their 2529a42 locators and gain the d6bc3a3 ones: `:L107-L108`, `:L133`. (b) § 8's dated readings stop at gate 1.8.0. They should gain the 1.9.0 reading in the same form: at `ka-reader@d6bc3a3` the gate is version 1.9.0 (`checks/gate.sh:L2`; 1.8.0's line is `:L3`) with 38 top-level `run_step` calls (`:L54-L145`). The two new steps sit after *Read-only, tree scene, killed* (`:L108`) and before *Read-only suite* (`:L114`). This is a source measurement, not a passing-gate claim.
- **Rationale:** `follow-the-file` (SDD § 6 S-6) was merged at `ka-reader@d6bc3a3`, and its scene's steps are now in `checks/gate.sh`. § 9 says each scene enters the gate when its slice delivers, and its list stops at the tree scene. A delivery-tier reader would take the displayed-file scene as not yet in the gate. The SDD's newer v70 moves no slice, edge, seam or part, so nothing upstream changes what § 9 should say. Only the gate moved.
- **If overridden:** nothing supersedes and no obligation changes. § 9 stays a reading of the gate at `ka-reader@2529a42`, and the next re-measurement picks the steps up.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 An unpinned `checks/gate.sh` line locator in the NFDR now names a different line
- **Raised by:** PM — 2026-11-06
- **Which record:** `nfdr.md`, the passage at its line 2297 (the *Tree scene helper suite* locator)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-13_the-tree-and-the-open-file-follow-the-disk`
- **What it blocks:** nothing is blocked; a reader following the locator lands on the wrong step.
- **Where it shows:** "the gate's *Tree scene helper suite* step, `checks/gate.sh:L127`" names no commit. At `ka-reader@d6bc3a3` the gate holds two displayed-file steps after *Read-only, tree scene, killed* (`checks/gate.sh:L112-L113`), and the step is at `checks/gate.sh:L133`; `:L127` is now a comment line. Re-pin it at a commit, or name the step alone.
- **If a document has to be written:** none.
- **Answer:** Re-pin it, and keep the step's name. The locator was pinned, but not where a reader looks: the sentence ends "all at `ka-reader@2529a42`", and at that commit `:L127` is the *Tree scene helper suite* step. The "all at" comes after the second parenthesis, so it reads as covering only the `test_vm_refusal.sh` lines. Naming the step alone would break v77's rule that every `checks/gate.sh` locator carries its commit. So the fold puts the commit on the locator itself, in the form § 8 already uses: (the gate's *Tree scene helper suite* step, `checks/gate.sh:L133` at `ka-reader@d6bc3a3`; `:L127` at `ka-reader@2529a42` — RN-87). The rest of the sentence still holds at `ka-reader@d6bc3a3`: the test it names is still in `checks/tests/test_tree_scene.sh`, and `checks/tests/test_vm_refusal.sh` is unchanged since `ka-reader@2529a42`. The two other places that cite these steps (`docs/nfdr.md:L1676` and `:L2371`) carry their commit inline and are true at it, so this item does not move them. Item 2.1 re-measures the `:L2371` sentence. Reasoning: `docs/trail/architecture/self_answer-73.md` § 3.1.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
