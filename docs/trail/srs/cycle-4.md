# SRS open issues — Nozoki 覗き

> Companion to `SRS.md`. The CTO authored the SRS non-interactively; this file holds
> what it could not settle from the inputs (the PRD and any context/constraints).
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this
> file**, then re-run `product-srs`. It folds your answers into the SRS and drops the
> resolved items. When nothing is left open, `product-srs` **deletes this file**: no file =
> the SRS is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CTO folds them in, it first copies this
> file whole to `docs/srs_trail/` — so what you decided, and why, stays readable and citable
> for good.

> **This companion was opened by the owner, not by a CTO run.** The SRS reached Settled at v4
> on 2026-08-03 and has had no companion beside it since. It is reopened to hand in one
> instruction — already answered below, so the next `product-srs` run is a fold rather than a
> fresh round. Anything the fold cannot settle goes back into a rewritten companion as usual.

---

## 1. Open issues — technical questions with no answer yet

None — the one item this companion carries is a decided instruction, in §2.

## 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override

### 2.1 Whether this SRS is re-authored against the PRD and the machinery as they stand today

- **Drafted into the SRS:** nothing. `SRS.md` is v4, Settled, written 2026-08-03 (`3fc595b`)
  against **PRD v6** and against the carriers as they were that day.
- **Rationale:** two things have moved under it, and one input has gone.

  **(a) The upstream PRD — v6 → v8.** The SRS's own header states the rule: *"every delta in a
  revision traces to an owner answer/directive or a change in the upstream PRD."* The PRD has had
  two revisions since this SRS was settled — v7 (`00b5398`, the re-authoring pass) and v8
  (`ea8e727`, the owner's cycle-7 answers). Four of those facts are product facts the SRS predates
  and does not carry:

  - **Platform: macOS only.** PRD v8, Scope: *"v1 runs on macOS, and promises nothing else"*, with
    Linux and Windows a stated Out of Scope exclusion. `SRS.md` names **no platform at all** — a
    grep for `macos|platform|windows|linux` over the document returns nothing.
  - **Syntax highlighting has a promised floor.** PRD v8, Core Features: highlighting is promised
    for Python, shell, JavaScript, JSON, YAML and TOML; outside that floor a file is shown as plain
    text, *never refused and never mis-highlighted*; the floor grows when the maintainer needs a
    language. `SRS.md` FR-8 (`SRS.md:94-96`) promises "syntax highlighting" with no floor, no
    fallback state, and no refusal bar.
  - **Markdown is rendered.** PRD v8, Core Features: Markdown is rendered by default with a toggle
    to the raw source, and if the toggle proves too costly for v1, v1 ships rendered-only and the
    toggle follows — a stated fallback, not an open question. `SRS.md` has **no Markdown
    requirement of any kind**.
  - **Public identity and support posture.** PRD v8, Assumptions: published under the `kensaiapp`
    GitHub organisation and maintained under that name; and a support posture in which *nothing is
    promised* — no response time, no commitment to fix, no promised acknowledgement on security
    reports. Whether either reaches a system-level requirement is the CTO's call; that they are now
    stated product facts is not.

  One related note, not a gap: **NFR-8** (`SRS.md:212`) already says the system makes *"no network
  call during operation — none, not merely no non-essential"*, and **RN-3** (`SRS.md:422-424`)
  records that as the SRS tightening beyond the PRD. PRD v8 now says it in its own voice
  (*"v1 makes no network call at all during operation"*) while keeping *"no non-essential"* as the
  wording, deliberately, so that a future update/version-check feature has headroom
  (`prd_trail/cycle-7.md`, §2.3). NFR-8's substance is right; **RN-3's rationale is stale** — it
  explains a divergence that no longer exists.

  **(b) The carriers.** Both have moved since 2026-08-03:

  - `<CORE>/templates/product-templates/srs_template.md` **1.8.0 → 1.9.0** (`81d244f0`,
    2026-08-19): `## Open Questions` was rewritten. Anything awaiting the owner now lives in this
    companion **alone** — the section is not a copy of it — because the companion's absence is the
    done signal, and an item in both homes lets the document read settled while the list still
    stands open. What belongs in the section is the other kind: a question the SRS cannot close and
    is *not* asking the owner to close, one resolving downstream in the SDD or a spike. And the
    section is **omitted entirely when empty**. `SRS.md` carries an `## Open Questions` section
    (`SRS.md:529`) whose body is *"None — ..."* followed by four lines of prose explaining why —
    a section that is empty of questions and still standing.
  - `<CORE>/prompts/cto_create_srs.md` **3.4.0 → 3.6.0**, across four commits: `0578e654`,
    `e9e0673a` and `6007d560` walk the writing-bar pointer from the instance's `CLAUDE.md` style
    section to `register.md`, to core's `writing_bar.md`, and finally to **the instance's own**
    `system/doctrine/writing_bar.md` (3.4.2 → 3.5.0); and `4b017952` — landed by merge `d5d9f260`,
    which carried the 3.5.0 → 3.6.0 bump — says the **SDD is worked as one run with the CPO and the
    CDO**: three seats, not two.
  - `product-srs/SKILL.md` is **byte-identical** since 2026-08-03 (no commits touch
    `.claude/skills/product-srs/` in that window), so the skill's own shape has not drifted.

  **(c) One input is gone.** `docs/UXD.md` was removed at `9017ae2`, to be authored again by a skill
  that has been measured. The prompt reads the UXD as a sibling input; SRS v4's own Version line and
  FR-18's trace (`SRS.md:161`) both cite `UXD.md` UX-S6 / RN-14, and that file is not on disk.

- **Confirm or override:** **OVERRIDE — make this run a re-authoring pass over the whole SRS,
  against the PRD, the template and the prompt as they stand today.** Owner's instruction,
  2026-08-25.

  - *The technical product does not change here by fiat.* No requirement, scope bound, NFR or
    acceptance criterion is reopened by this instruction on its own. Every value the owner has
    already confirmed in `docs/srs_trail/` stays authorized and stays as written; this instruction
    is not the fresh authorization that would be needed to move one.
  - *What the pass derives in.* The four PRD deltas in (a) are **derivation, not new decisions** —
    they are already owner-confirmed upstream (`prd_trail/cycle-7.md`), and the SRS owes them
    requirements: a platform constraint, a highlighting floor with its plain-text fallback and its
    never-refuse/never-mis-highlight bar, a Markdown rendering requirement with its raw-source
    toggle and the rendered-only fallback, and whatever the identity and support posture imply at
    system level, if anything. Each traces to its PRD source, as every requirement here must.
  - *And a correction the pass owes.* RN-3 explains a divergence from the PRD that no longer
    exists. Repair the note; NFR-8 itself stands.
  - *And a read of the whole document against the current bar.* Walk `SRS.md` under the prompt as
    it reads today (3.6.0) and the template's section shape at 1.9.0 — not as they read on
    2026-08-03 — including the instance's own writing bar at `system/doctrine/writing_bar.md`, and
    the SDD's three seats wherever the SRS names who reads it.
  - *`## Open Questions` under the new rule.* The section at `SRS.md:529` holds no questions —
    only a "None" and its explanation — and 1.9.0 says an empty section is omitted, because an
    empty heading reads as an unanswered question. Omit it, unless the pass surfaces a real
    downstream question to put in it. If the pass surfaces something awaiting the **owner**, that
    goes in this companion, never in that section — the two homes are what 1.9.0 exists to stop.
  - *The missing UXD is not to be invented.* Do not re-derive it, and do not silently drop the
    requirements that were traced to it — FR-18's branch-topology shape is owner-confirmed in
    `srs_trail/cycle-3.md` and stands on that authority regardless of the file's absence. If the
    pass finds something it genuinely cannot settle without the UXD, that is a **choice to confirm
    in the rewritten companion**, not a silent call and not a reason to stall the pass.
  - *Surface, never silently edit.* Where the current bar, or PRD v8, would not settle something
    the way the SRS on disk settles it, and the change is not plain derivation from an
    owner-confirmed PRD fact, that is a **choice to confirm in the rewritten companion** — with
    what the SRS says now and what the bar would say instead. A wording repair that moves no
    technical fact is yours to make; anything that moves a requirement is the owner's.
  - *The version line.* Bump `Version:` on any run that changes the SRS's content, and say in the
    line what moved and why.

## 3. Directives — an external action the owner confirms as a gate

None.
