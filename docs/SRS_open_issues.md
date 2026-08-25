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

> **This round is the re-authoring pass you instructed** (`docs/srs_trail/cycle-4.md` §2.1). The
> four PRD v8 facts are derived in at SRS v5, RN-3 is repaired, the carriers' rules are applied,
> and the wording repairs that move no technical fact are made. What follows is every
> product-visible call the derivation met that the PRD does not make — each drafted into the
> SRS best-effort, as the instruction asked, and waiting for you here.

---

## 1. Open issues — technical questions with no answer yet

None — every call the pass met carried a defensible lean, so each is under §2 as a choice to
confirm.

## 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override

### 2.1 How a file is recognized as one of the six floor languages — and what an unrecognized file gets

- **Drafted into the SRS:** FR-29 — a text file the system does not recognize as a floor language
  is displayed as plain text, never refused and never with another language's highlighting. The
  recognition itself is drafted as **by file extension**, with the extension set the SDD's; a file
  with no extension, or an extension outside the set, is plain text. So an extension-less shell
  script (`#!/bin/sh` at the top, no `.sh`), a `Makefile`, or a `.yml` file all read as plain text
  unless the SDD's extension set includes them.
- **Rationale:** the PRD promises the floor by language, and your own measurement named the
  languages by extension — Python (`.py`), shell (`.sh`), JavaScript (`.mjs` / `.js`)
  (`docs/prd_trail/cycle-7.md` §2.5). Extension-based recognition is the reading that keeps
  "never mis-highlighted" cheap to hold: content sniffing (reading a shebang, guessing from
  syntax) is what mis-highlights. But what a reader sees for an extension-less script is
  product-visible, so the call is yours, however confidently drafted. The PRD does not say.
- **If overridden** (shebang / content recognition allowed, or a named extension set fixed here):
  FR-29 gains the recognition rule in its own text; AC-5 adds the extension-less case to its
  walk; the SDD's latitude narrows to match. Nothing else moves.
- **Confirm or override:** confirm — recognition is by file extension, as drafted.
  On the extension set, asked separately and answered separately: *"yes. we should cover
  the options."* Each floor language is recognized by all of its common extensions, not
  one apiece.

### 2.2 What a link inside a rendered Markdown file does when activated

- **Drafted into the SRS:** FR-32 — rendering fetches nothing from outside the repository and
  **the system follows no link** the document contains: an external link is shown as a link and
  does nothing when activated; a relative link to a file in the repository does nothing either.
  AC-23 checks that activating an external link produces no outbound traffic.
- **Rationale:** the no-fetch half is not a choice — loading a remote image is a network call
  during operation and NFR-8 forbids it absolutely — so it is derived, not routed (SRS RN-23).
  The link half is: handing an external link to the system browser makes Nozoki the initiator of
  a network call even though another process makes it, which sits badly against a promise Way 2
  says is kept absolutely; and opening a relative link in the reading panel is in-document
  navigation, a feature the PRD never names and the Agari never places inside done. The lean
  is the one that adds nothing: links are displayed, not followed. What a reader gets when they
  click is product-visible, so it is yours.
- **If overridden** — two independent halves: (a) *relative links open the target file in the
  reading panel* — FR-32 gains that behavior, AC-22 adds a walk for it, and the tree selection
  (FR-7) and the Git-view opening path (FR-13) become the pattern it follows; (b) *external links
  are handed to the system browser* — FR-32's "follows no link" narrows to "makes no call
  itself", AC-23's link check narrows to the same, and RN-23 records that the initiation is
  accepted. Either half alone is possible.
- **Confirm or override:** in the owner's words, first on the item as a whole: *"link only
  if it costs *nothing*, otherwise, it's not important for v1."* The two halves were then
  put separately — external links handed to the system browser, relative links opening the
  target in the reading panel — and the owner answered: *"per each, if it costs nothing,
  do it."*

  So the condition is build cost, applied to each half on its own. Neither half is required
  for v1 and neither is refused; whether a half meets the condition is not settled here.

  <!-- Session facts, NOT owner statements, recorded so the fold does not have to infer them.
       (a) Neither pre-written branch above matches: the answer is a permission conditional on
       cost, not a wholesale confirm or override, and the owner used neither word.
       (b) Before answering, the owner was told that cost is not the axis the external half
       turns on — this item's own rationale leans on Way 2's promise, and handing a URL to the
       system browser makes Nozoki the initiator of a call another process makes. The answer
       above came after that was said. The owner did not say the trade is accepted, and no
       acceptance is recorded here. -->

### 2.3 Whether the Markdown raw-source switch is inside the terminus

- **Drafted into the SRS:** FR-31 carries the PRD's fallback as a permission — v1 may ship
  rendered-only, the switch following in a later release — and AC-12 exercises the switch **at
  the closing release**, placing it inside done.
- **Rationale:** the Agari (`system/projects/nozoki/agari.md`) predates PRD v7/v8 and draws the
  dock as the v1 cut "as drawn" — file tree, reading with highlighting, Git status, live refresh —
  plus three named beyond-v1 features. Markdown rendering and its switch appear in neither list,
  because they did not exist when the dock was drawn. The lean reads "reading with highlighting"
  as the whole reading surface the PRD now draws, switch included: the PRD calls the toggle a
  feature that *follows*, not one that is dropped, and a closing release that renders Markdown
  with no way to see the source is a reading surface with a hole in it. But the terminus is the
  CPO's declaration, not this document's to extend, so the reading is yours to confirm.
- **If overridden** (the switch is outside done): AC-12 drops the FR-31 clause; FR-31 stays as
  the PRD's stated feature with no closing-release criterion; RN-23 records the placement. The
  Agari itself is untouched either way — this item asks how to read it, not to change it.
- **Confirm or override:** override — the switch is outside the terminus. *"The switch came
  as a compromise/proposal. From my point of view, render is what i need."* And on whether
  it is built at all: *"add the toggle if it costs nothing."*

### 2.4 Whether a second platform is outside the terminus

- **Drafted into the SRS:** §2 lists Linux and Windows under "deliberately outside this SRS,
  with the terminus as the reason": v1 promises macOS only (C-11), and the Agari names no
  platform, so a second platform is read as outside done as the Agari stands.
- **Rationale:** the PRD states Linux and Windows as *beyond v1* — an exclusion, not a permanent
  one (`docs/PRD.md` § Out of Scope, "Linux and Windows"). The Agari's first condition
  enumerates exactly which beyond-v1 features are inside done — diffs, history, repository
  switching — and platform is not among them, which is the lean. The alternative reading —
  that the dock's "a stranger can pick up a public release" is platform-agnostic and a second
  platform rides in whenever it is added — is not unreasonable, and only you can say which the
  dock means. This item does not ask whether Linux or Windows *will* be built; it asks whether
  Nozoki is done without them.
- **If overridden** (a second platform is inside done): §2's bullet moves the platform into the
  covered set; C-11 gains the second platform with its own minimum-version placement; NFR-13
  and AC-10 run the time-to-first-success check on each platform promised, as the PRD's own
  metric says it would; RN-21 records the reading.
- **Confirm or override:** confirm

## 3. Directives — an external action the owner confirms as a gate

None.
