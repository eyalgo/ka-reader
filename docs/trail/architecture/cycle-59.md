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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-23, from a
> `shukuba-refine` review, to carry item 3.1 below: the records stand with no companion beside them,
> so without this file their producing skill would find nothing to act on.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 §§ 8 and 9 count the gate at 27 steps and the harness at eleven suites; at `ka-reader@8235240` the gate has 29 steps, twelve suites, and `gitleaks git` is one of its steps

- **Raised by:** PM — 2026-10-23
- **Which record:** `nfdr.md` § 8, the paragraph **Until the card runs the script**
  (`docs/nfdr.md:L1644-L1660`, its gate count and locators), and § 9, the bullet **The harness's own
  suites** (`:L2021` onward, its suite enumeration and locators)
- **Tracked by:** `ka-reader · nemawashi · 2026-10-03_no-secret-reaches-the-repository`
- **What it blocks:** nothing is blocked; both passages are pinned to a commit and true of it, and by
  § 9's own wording a step added to the gate is a re-measurement of those sentences.
- **Where it shows:** § 8 says the script is version 1.1.0 with 27 steps at `ka-reader@389adad`
  (`:L1650-L1653`); § 9 says "Eleven suites are in the tree" and lists them with their `gate.sh`
  lines at `ka-reader@8b93322`. At `ka-reader@8235240`, `checks/gate.sh` is version 1.2.0 (`:L2`,
  "the scan of the whole history for a secret, and its suite, join the list (NFDR QC-28)") and
  `grep -c '^run_step' checks/gate.sh` prints 30 — 29 steps and the `run_step()` definition. The two
  new steps are *Secret scan suite* (`:L48`, `checks/tests/test_secret_scan.sh`) and *Secret scan*
  (`:L58`, `checks/secret-scan.sh gitleaks git`), both before *Build the workspace* (`:L59`), so the
  gate locators both passages cite below `:L47` have moved. `git ls-tree --name-only 8235240
  checks/tests/` lists twelve suites, the eleven § 9 names and `test_secret_scan.sh`, which pairs with
  the new script `checks/secret-scan.sh`. The scan step is QC-28's tree half realized at the gate:
  it runs gitleaks 8.30.1, fetched and checked against a pinned SHA-256 on every run (the comment at
  `checks/gate.sh:L49-L57`). It passes `--exit-code 2` to the tool (`checks/secret-scan.sh:L195`),
  so a finding and a tool error exit differently, where QC-28's tail states the vendor default
  (`docs/nfdr.md:L1078`, "exit 1 on a leak or an error"). The whole gate exited 0 in the macOS
  guest at `ka-reader@38158f4`, the scan printing `commits scanned: 1279`, and
  `git diff --stat 38158f4 8235240` prints nothing. The workflow's checkout gained `fetch-depth: 0`
  (`.github/workflows/ci.yml:L22-L23`).
- **If a document has to be written:** none — sentences of `nfdr.md`, folded by
  `product-architecture`. Whether QC-28's *verified by* or § 10's row should now name the gate step,
  and whether the exit-code note belongs in QC-28's tail, is the fold's call.
- **Answer:** Yes — fold it, as a re-measurement at `ka-reader@8235240` (checked by this run at source: `grep -c '^run_step' checks/gate.sh` prints 30, `checks/gate.sh:L2` is 1.2.0, `:L48` and `:L58` are the two new steps, `git ls-tree --name-only 8235240 checks/tests/` lists twelve suites, and `git diff --stat 38158f4 8235240` prints nothing; SDD v58 already carries 29 steps and twelve suites in its `read-only-harness` row and left these sentences to this file, RN-118). Five moves, every old reading kept in a dated note: (1) § 8 *Until the card runs the script* gains the 1.2.0 reading — 29 steps, the secret-scan suite and scan at `:L48` and `:L58` before *Build the workspace* (`:L59`), and the guest's exit 0 at `38158f4`; § 8's first and structure-pair paragraphs re-pin their `gate.sh` locators (`:L59`, `:L62`, `:L63`, `:L70`, `:L71-L72` at `8235240`). (2) § 9's suites bullet counts twelve, adds `test_secret_scan.sh` (`:L48`), which pairs with `checks/secret-scan.sh`, and re-pins every suite locator (`:L72`, `:L74`, `:L77`, `:L79`, `:L89`, `:L93`, `:L95`, `:L96`, `:L99`, `:L100`, `:L101`). (3) QC-28's *verified by* names the gate step: `checks/secret-scan.sh gitleaks git` exits 0 over every commit HEAD reaches, at every change (§ 8). Its tail states the script's own contract, not the vendor default: the script passes `--exit-code 2` (`checks/secret-scan.sh:L195`), so a finding exits 2 and a tool error 1, and either fails the step; RN-3's vendor sentence stays, because it is still true of bare `gitleaks git` (the README re-read 2026-10-23). The tail also says that a finding passes only by a fingerprint line in `.gitleaksignore` with its reason, reviewed as code in the same change, as `checks/deps.allow` is for QC-26 (`checks/secret-scan.sh` header, *.GITLEAKSIGNORE*). Without that sentence, "exits 0" reads as unconditional. (4) § 10's QC-28 row names `checks/secret-scan.sh gitleaks git` (suite `test_secret_scan.sh`), by § 10's own suite rule, gated at the change. (5) QC-64's order sentence — "the toolchain print first, then the workspace build … and every `checks/*.sh` script, suite and step after them" — is false at `8235240`, where a `checks/*.sh` script and its suite run before the build. That order was this document's own wording for the steps moved from the workflow, not an owner requirement (`docs/trail/architecture/cycle-49.md` § 3.1 names none). It is re-worded: the moved steps keep the workflow's order, and a step added to the script later is placed where its comment in `checks/gate.sh` says. No `QC` is added, renumbered or reused, and no ADR is owed: the step realizes QC-28 at the change and moves no structure. Name two failure paths as consequences, not as new obligations. (a) The step fetches gitleaks 8.30.1's release archive from GitHub on every run, against a pinned SHA-256. If that archive stops being served, the step fails closed and every change is red until the pin moves. That is the platform fact the step rests on, held by the gitleaks maintainers. (b) A shallow checkout is refused, so `fetch-depth: 0` in `ci.yml` is what lets the hosted run pass; removing it turns that run red, never green. The reasoning is in `docs/trail/architecture/self_answer-61.md`.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
