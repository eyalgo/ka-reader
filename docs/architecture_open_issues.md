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

### 2.1 Four NFDR passages were written by a delivery-tier commit, outside any NFDR revision, and carry no trace

> A `companion-self-answer` run raised this item on 2026-11-11
> (`docs/trail/architecture/self_answer-86.md`, *Raised on this document*). No producing run wrote it.
> It came from reading the NFDR whole while answering § 3.1: the passages that item revises were not
> written by any NFDR revision. Its slot is left for the next round.

- **Lands in:** `nfdr.md` QC-44 (its *Local README realization* paragraph), QC-70 (its *README command status reading* paragraph), § 9 (*Additional measurement at `ka-reader@1ee6ba1`*) and § 10's QC-44 row. No ADR.
- **Drafted into the records:** nothing yet. The lean is that the revision folding § 3.1 also takes these four passages in as its own. Its version line names them, and an RN records that `ka-reader@5c1a640` (a `development-implementation` run, 2026-11-10) wrote them inside v91 with no version and no RN. Each passage gains a trace to that RN. A measurement still true is kept as measured, and where § 3.1's answer re-pins a passage at `7a88215`, the `1ee6ba1` reading is kept dated. No obligation changes.
- **Rationale:** The NFDR's header promises that every entry carries an inline trace tag, and that `Inputs read:` and the version line say what each revision did. v91's line names only the cycle-82 fold. The four passages carry no `traces to`, no RN and no version. A cold reader cannot tell them from a settled revision, or find what authorized them. The SDD took the same commit's edit to its § 3 into its own revision at v86 (RN-172), so the two records disagree on whether that commit's text is settled. The measurements themselves hold, so the fix is provenance, not content.
- **If overridden:** the four passages stay as they are, with no trace, and the next revision touching QC-44, QC-70, § 9 or § 10 meets text no revision wrote. § 3.1's fold rewrites three of the four regardless, so overriding loses only the record of where they came from.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-44 still says no script checks the beta wording or the catalogue, and § 9 and § 10 do not name the one that now does
- **Raised by:** PM — 2026-11-10
- **Which record:** `nfdr.md` § 4 QC-44 (its local realization paragraph), § 9 *The harness's own suites*, and § 10's QC-44 row
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; QC-44's verification reads as not built for an obligation the gate now checks, and the release inspection would re-do work a gate step does.
- **Where it shows:** QC-44 (`docs/nfdr.md:L1693-L1712`) records that at `ka-reader@b46d896` no script runs the catalogue `grep`. Its local realization at `ka-reader@1ee6ba1` leaves "the beta wording and its catalogue/surface checks" outside the local subset. § 10's QC-44 row (`:L3420`) names only `checks/readme.sh` and its suite. At `ka-reader@7a88215`, `checks/git-beta.sh` checks the beta row's wording against the Swift catalogue and `GitReadPolicy`, in `atOpen` and `followed` modes. `checks/readme.sh` checks the README's known-gaps beta block between its delimiters. The gate runs both scripts and their suites (`checks/gate.sh:L143-L144`, `:L152-L153`), and both exit 0 in a clean clone at that commit. Rendered placement and meaning, release-note wording and the downloaded-release proof are still outside any script. `grep -n 'git-beta' docs/nfdr.md` prints nothing.
- **If a document has to be written:** none. QC-44's realization, § 9's suite list and § 10's row name the delivered wording checks. The remaining release-inspection obligations stay distinct, and the dated measurements are kept.
- **Answer:** Take the change as the item states it, with four additions. (1) **Locators at `ka-reader@7a88215`** (`checks/gate.sh` 1.15.0): *README check* and its suite are `:L150-L151`. The item's `:L143-L144` is the `1ee6ba1` reading, kept dated. The beta pair is `:L152-L153`. (2) **What each script holds, named.** `checks/git-beta.sh` 1.0.0 reads `GitReadPolicy.build`. On `atOpen` it runs QC-44's catalogue `grep -rF` over `ka-reader-mac/Sources/Surfaces`. In both modes it requires the `GitSentences.swift` notice to agree with CONTENT's beta row. `checks/readme.sh` 1.1.0 holds the README half in both modes. On `atOpen` the known gaps hold one delimited beta block carrying the whole wording. On `followed` there is no block, and the notice's wording appears nowhere in the displayed prose. So QC-44's README `grep` is held at every change, not only at the release. Both scripts read the shared `checks/support/git-beta-inputs.sh`. (3) **§ 9:** there are twenty-five suites at `7a88215`. The added one is `test_git_beta.sh` (`:L153`), and each suite is still the whole command of one gate step. The twenty-four at `1ee6ba1` stays as a dated reading. (4) **QC-70:** `git-beta.sh`'s statuses are 0 on a pass, 1 on a finding, refusal or signal, and 2 on usage. They sit inside QC-70's set. Record them as the README script's were, held by `test_catalogue_statuses_signals_and_inputs_are_preserved`. **What stays outside any script,** with release inspection or `development-design` as now: release-note wordings, the uncovered-case line, the rendered four items, where and when each surface draws the statement (FDR R-192 – R-195, SRS AC-26), and any downloaded-release proof. The passages this revises were written outside an architecture revision; § 2.1 asks the fold to record that. Reasoning: `docs/trail/architecture/self_answer-86.md`.

### 3.2 § 9 leaves the Swift packet's "`@testable import` is for layer 1 only" in force, and 34 of the 54 Swift test files depart from it
- **Raised by:** PM — 2026-11-10
- **Which record:** `nfdr.md` § 9, *`ka-reader-mac` against the Swift packet* ("a rule of it not named here is followed as written")
- **Tracked by:** `ka-reader · nemawashi · 2026-11-08_the-swift-test-targets-wear-the-packets-names`
- **What it blocks:** the Swift test-target split cannot tell whether its moved files must also drop `@testable` in layers above 1. Doing that raises internal view parts such as `StatusMessageView` and `GitReadNotice` to `package`, which is an interface change.
- **Where it shows:** the Swift packet's `testing.md` ("`@testable import` is for layer 1 only"). At `ka-reader@7a88215`, `grep -rl '@testable import' ka-reader-mac/Tests` lists 34 of 54 Swift test files, among them the layer-4 view cases `Tests/SurfacesTests/GitBetaNoticeTests.swift:L4` and `Tests/SurfacesTests/WorkbenchViewTests.swift:L4`. `grep -in testable docs/nfdr.md` prints nothing.
- **If a document has to be written:** none. § 9 either names the departure with its reason, or states that the rule binds and that layer-4 cases reach views through `package` access.
- **Answer:** The rule binds. § 9 names no departure, and its Swift bullet states the rule in one sentence. `@testable import` stands only in a layer-1 (`…UnitTests`) target. A file the test-target split places in a layer 2–4 target uses a plain `import`. Where a case there reaches an `internal` declaration, it reaches that declaration through the `package` one production reaches it by, or the change raises the declaration to `package`. Which of the two, case by case, is the delivery tier's choice. Raising to `package` does not touch the tool's public surface. `ka-reader-mac` declares no `products:`, and `package` is invisible outside the SwiftPM package. It adds no target edge either, so § 1's import graph and SM-4's call rule stand. **The departure is smaller than 34 files.** I made every `@testable` a plain import on a scratch copy of `ka-reader@7a88215`, with the bridge and app target taken out of the manifest, on Swift 6.4.2. 16 of the 34 files built unchanged, `WorkbenchViewTests` among them. The other 18 reach about a dozen internal declarations. One is `BridgePayload`, reached by 4 `ShellTests` files. Three of them, the `BridgePayload…Tests`, test decoding, so they are layer-1 candidates where `@testable` stays. The rest are `BarRowView`, `CodeView`, `CodeGutterView`, `CodeType`, `CodeSpacing`, `LetterTooltipView`, `StatusMessageView`, `RowHover`'s initializer, and the `currentPosition`, `refresh` and `forget` members. No test reached `GitReadNotice`. **The entry's tail gains a gate.** Until the targets carry layer words, `development-design` reviews each moved or added test file against the rule. Once they do, a file outside a `…UnitTests` directory listed by `grep -rl '@testable import' ka-reader-mac/Tests` is the violation, and that check is owed to the delivery tier. Today's files predate the split and are owed the rule by it, as `SurfacesTests` and `ShellTests` are owed the packet's names. Reasoning: `docs/trail/architecture/self_answer-86.md`.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
