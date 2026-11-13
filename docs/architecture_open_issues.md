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

> **No `product-architecture` run wrote this file.** It was opened on 2026-11-13 from
> `<CORE>/templates/product-templates/architecture_open_issues_template.md`, on the owner's direction
> relayed from the host's QA-step work, to carry one § 3 item. The records are settled, and with no
> companion on disk a re-run reads them as done and has nothing to act on.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 The NFDR records no Behave call and no way in for QA's scenarios
- **Raised by:** owner, through the host's QA-step session — 2026-11-13
- **Which record:** `nfdr.md` § 9
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** every behaviour-changing change's QA step. The change walk now runs QA's
  `red-behaviour` step after specs for a behaviour-changing change on a card that reads
  `**Behave:** behave`. ka-reader's project card does, and the product carries `.behave/`, but
  `docs/nfdr.md` has no `**Behave:**` line and no `**Behave way in:**` line, so the walk halts before
  QA launches ("docs/nfdr.md has no **Behave:** line … the product's architecture run
  (product-architecture) records the way in"). The change walking now,
  `ka-reader · tobiishi · 2026-11-13_git-on-a-large-repository-stays-bounded`, is the first to reach it.
- **Where it shows:** `docs/nfdr.md` § 9 carries neither line. The NFDR template's § 9 now carries
  `**Behave:** behave | none — <reason>` and `**Behave way in:** command | server | browser`, and
  `product-architecture`'s prompt (`prompts/rich.md`, the Behave way-in paragraph) has the run make
  the call and pick exactly one way in — `command`, `server` or `browser`, as
  `<CORE>/templates/behave-starter/README.md` § *The three ways in* describes them.
- **If a document has to be written:** none. The two lines go into `docs/nfdr.md` § 9.
- **Answer:** **Behave:** behave · **Behave way in:** command. *Behave:* ka-reader is a product we own, with code, that a person uses — the first of the owner's 2026-11-10 criteria — and its card's test command is `checks/gate.sh`, not `none`. *Way in:* `command` is the one of the three that reaches this product. `browser` reaches nothing: the renderer left with `ka-reader-ui` (§ 9, RN-22) and the product serves no page. `server` reaches nothing: the product has no HTTP surface and links no network (QC-3; `docs/fdr.md` PD-26). `command` reaches it the way the product's own harness already does — a step runs a program and reads its exit status and output: the in-process driver over `SM-4` through `SM-5` (`crates/ka-reader-core/tests/walk.rs`, run by `checks/read-only.sh`, layer 3), and the built bundle through the `checks/` scripts (layer 5). Four bounds for the fold to carry into § 9 beside the two lines: (1) the program a scenario runs is a test host or a `checks/` script, never the shipped app given an argument — the app has no command-line surface and takes no launch argument (`docs/fdr.md` PD-26, OOS-19), so a scenario that would need one is a finding for the change's design step, not a new product surface; (2) the views are not driven from outside the process (`docs/SDD.md` § 4 C-I3, § 9 TO-7), so a scenario asserts what the core and the bridge answer — the projection a view is drawn from — while the drawing stays layer 4 and `docs/SRS.md` AC-10 stays a manual walk; (3) a scenario that runs the built bundle reads under § 9's existing preconditions — the bridge assembled from this checkout first, and a session in which windows are placed — and an environment refusal (a VM admission refusal, a window the window server did not place) is a run that did not read the change, never a red; (4) the layer-7 row, which reads *until a QA seat writes the layer*, now names QA's scenarios under `.behave/features/`, run with `uv run --locked behave` from `.behave/`, through the command way in. Whether `.behave/` joins `checks/gate.sh` as a step is not this item's. Reasoning: `docs/trail/architecture/self_answer-95.md`.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
