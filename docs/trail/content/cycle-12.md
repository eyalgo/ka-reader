# CONTENT open issues — KA-Reader

> Companion to `CONTENT.md`. The Content Manager authored the verbal language non-interactively;
> this file holds the calls it made and wants your sign-off on — each with the reason behind it,
> and what moves underneath it if you override — plus the few things it genuinely could not
> settle.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**,
> then re-run `product-content`. It folds your answers into `CONTENT.md` and drops the resolved
> items. When nothing is left open, `product-content` **deletes this file**: no file = the verbal
> language is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git refuses
> to remove a file with uncommitted edits in it — so an uncommitted answer stops that run before
> it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the Content Manager folds them in, it first copies
> this file whole to `docs/trail/content/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 comes from outside this run.** The verbal language is read by everyone who writes a string,
> and a seat downstream can find a pattern it has no rule for. It is recorded there, answered here,
> and folded by the same run.

> **No `product-content` run wrote this file.** The PM opened it on 2026-10-16, from a
> `shukuba-refine` review on the seed `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`,
> to carry item 3.1 below. `CONTENT.md` is Settled, so without a companion it would reach no one.

---

## 1. Open issues

None.

## 2. Choices to confirm

None.

## 3. Raised from downstream — an item from a seat that did not write the verbal language

### 3.1 Whether the standard reaches the lines the `checks/` harness prints, which now carry a banned word
- **Raised by:** PM — 2026-10-16
- **Tracked by:** `ka-reader · nemawashi · 2026-10-16_every-ci-rule-is-held-at-the-change`
- **What it blocks:** nothing is blocked. But § Terminology's *Banned in anything a person sees* bans
  *refused* (`docs/CONTENT.md:L192`), and six lines a person reads in a terminal or a CI log now open
  with it: `<script>: refused: this host does not read as a macOS virtual machine. …` (`checks/bundle.sh:L66`,
  `checks/renderer.sh:L90`, `checks/own-state.sh:L43`, `checks/launch.sh:L44`,
  `checks/tests/test_bundle.sh:L48`, `checks/tests/test_renderer.sh:L47`, at `ka-reader@13e8d42`). The
  harness is not the shipped frame, and nothing in `CONTENT.md` says whether its output is in scope. So
  the word was placed on a reading of scope that the standard never states.
- **Where it shows:** the harness's own messages. Three other forms hang on the same answer, at the same
  commit. The lines name files and identifiers (`KA-Reader.app`, `docs/nfdr.md QC-65`, the log path). The
  two timeout lines open with `ci:` (`checks/launch.sh:L68`, `checks/own-state-step.sh:L55`), though
  each script also runs by hand. And neither timeout line says what to do next.
- **If a document has to be written:** none. The answer is a scope sentence in `CONTENT.md`: either the
  harness's output is under the standard (and the banned table, identifiers and the next-step rule then
  bind it), or it is outside it, with the reason.
- **Answer:** Outside this document. The text the `checks/` scripts and their suites print is not under `CONTENT.md`, and *refused* on the six virtual-machine lines stands. Add one scope sentence to § Voice, beside the paragraph that limits the rules to the words KA-Reader writes: *"The text the project's own checks print, the scripts under `checks/` and their suites, is outside these rules: it is not in the app bundle, the app never shows it, and its reader is a contributor or a build log, not the person KA-Reader was pointed at a folder for. Text that reaches the bundle or the app's screen is in scope whichever file it came from."* The test is where the text goes, not which directory holds it. If the fold finds the banned table's heading, *Banned in anything a person sees*, reads wider than that sentence, narrow the heading rather than add an exception. Two limits. This document does not scope the instance's voice restrictions: `system/experience/voice_restrictions.md` § 1 reaches "every other text a command emits" by its own words, and this document neither narrows nor restates it. And the app's own log is not decided here; it waits until a string in it is in question. The three forms that hang on this need nothing from `CONTENT.md`: the identifiers and the log path in the lines help a contributor and need no rule; the `ci:` prefix on the two timeout lines and the missing next step there are changes to the scripts, not rules for this document, and the instance's `failure-says-what-next` and `no-unestablished-state` entries are what such a change is checked against. Reasoning: `docs/trail/content/self_answer-10.md`.

**How it closes.** `product-content` folds it on its next run exactly as it folds §§ 1–2.
