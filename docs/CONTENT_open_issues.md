# CONTENT open issues — Nozoki 覗き

> Companion to `CONTENT.md`. The Content Editor authored the verbal language non-interactively;
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
> Your answers are never thrown away. Each time the Content Editor folds them in, it first copies
> this file whole to `docs/content_trail/` — so what you decided, and why, stays readable and
> citable for good.

---

## 1. Open issues

### 1.1 Nozoki's network promise is stronger than the instance's fenced wording — which sentence does it carry?

- **Why it matters:** `CONTENT.md` § Terminology, *Standing sentences* — the network row, and
  through it every surface that states the promise (the README, the release page, and the
  not-loaded placeholder in rendered Markdown).
- **What was searched:** `system/experience/voice_restrictions.md` § `one-wording-per-promise`
  fixes one sentence for every product holding this instance's no-telemetry default: *"This tool
  sends no telemetry and makes no network call except the ones the job you asked for requires."*
  Nozoki's own promise is stronger and differently shaped: *"v1 makes no network call at all
  during operation; acquiring the tool uses the network, operating it does not"* (`docs/PRD.md`
  § Data & Privacy), backed by `docs/SRS.md` NFR-8 (*"none, not merely no telemetry"*). Carrying
  the fenced sentence verbatim would understate what Nozoki does — its job requires no call, so
  *"except the ones the job you asked for requires"* reads as headroom the product does not use.
  The fence permits a product to tighten an entry and not to loosen one, but its wording clause
  says the sentence is carried *in those words*, and this run cannot tell whether a stronger
  product-specific sentence counts as tightening it or as replacing it.
  Also in scope of your answer: `docs/PRD.md` § Data & Privacy deliberately keeps the word
  *non-essential* as headroom for a possible future update or version check. The drafted sentence
  states v1's truth and says nothing about later versions, which keeps that headroom without
  advertising it.
- **What was drafted meanwhile:** *"Nozoki sends no telemetry, and it makes no network call while
  it runs — downloading it uses the network; using it does not."*
- **Answer:**

### 1.2 Git's status letters are shown with nothing that expands them — the view, or the README?

- **Why it matters:** `CONTENT.md` § Accessibility of text, second rule; and § Traceability's row
  for UX-S2's success state.
- **What was searched:** `docs/DESIGN.md` § Components ("Status letters") sets a single capital
  letter beside a changed file — `A`, `U`, `M`, `D`, `C`, `R` — and § Do's and Don'ts rules out a
  tooltip and a hover state, so the product has no surface on which a letter could be expanded on
  demand. `docs/UXD.md` UX-A2 permits a letter as the cue that survives without colour, which is
  a different question and is not being reopened: the question here is whether a reader at the
  product's stated expertise floor (`docs/PRD.md` § Goals, "No learning curve" — someone who can
  follow a README, with no Git knowledge beyond finding their way around a repository on a
  hosting site) can read the letter at all. Nothing in the product's documents expands them.
  Two ways to fix it, and they belong to two different seats: the Git view names the state in
  words beside or above the rows, which is the CDO's; or the README lists the six letters, which
  is the CPO's surface. A third possibility — dropping the letters and showing the word in the
  row — is a design change with a width cost, and is the CDO's alone.
  One detail worth checking with the answer: `docs/DESIGN.md` groups the letters as "A and U
  (added); M (modified); D and C (deleted, conflict); R (renamed)", while Git's own porcelain
  reports `C` as copied and `U` as unmerged. If that grouping is what ships, the expansion has to
  match what the letters actually mean, which is a question for whoever owns the mapping.
- **What was drafted meanwhile:** the README carries the expansion — *added*, *modified*,
  *deleted*, *renamed*, *copied*, *unmerged* — and `CONTENT.md` says so as the interim rule, so no
  release ships with the letters unexplained while this is open.
- **Answer:**

### 1.3 The README promises three things the Agari places permanently outside done, and calls Nozoki a web app

- **Why it matters:** the README is the corpus this document was derived from and the surface this
  instance's own doctrine treats as where adoption is decided. Its claims are the CPO's, so this
  run raised them rather than editing them. `CONTENT.md` does not repeat any of them.
- **What was searched:** `README.md` § Roadmap, phase 3: *"pane resizing, keyboard navigation,
  diff/commit-preview, sidebar search"*. `system/projects/nozoki/agari.md` places sidebar search /
  filter, pane resizing, and keyboard navigation **outside** the dock — *"nozoki is done without
  them"* — and states the keyboard absence is permanent, not deferred; `docs/UXD.md` UX-I8 and
  UX-A1 carry the same. So the README currently promises a stranger three things the product has
  settled it will not build, on the surface where the first failed claim ends the adoption.
  Separately, `README.md` § What it is calls Nozoki a *"stripped-down, VS Code-like web app"*,
  while `docs/SRS.md` C-11 promises macOS only and `docs/PRD.md` § Out of Scope rules out *"any
  hosted operation of the tool itself"*. Whether *web app* is accurate for the shipped shape is
  the CTO's; whether the README should say it is the CPO's.
  Note the README also carries *"Status: proposal — not yet implemented"*, which is true today and
  is not part of this item.
- **Answer:**

## 2. Choices to confirm

### 2.1 The voice, and the ruling that Nozoki is conversational but not casual

- **Written into CONTENT.md:** § Voice — the opening paragraph (Nozoki speaks as itself, names
  what it observed and stops; the reader's own text is not Nozoki's writing and no rule applies to
  it), the conversational-not-casual ruling, and the seven behaviours in the table.
- **Grounds:** `docs/PRD.md` § UX Notes "The character" (*"calm, truthful, still"*), § Target
  Users (the reader is watching a tree an agent is changing), and `docs/UXD.md` UX-I2 (updates
  arrive with no notification and no attention bid). The *not casual* ruling is this seat's call
  on those grounds: the sentences a reader meets most in this product are the ones that appear
  when something failed, and that is the moment they decide whether the tool can be trusted with
  a repository.
- **What moves if you override:** everything below it. The tone maps, the ban on exclamation marks
  and on *sorry* / *don't worry*, the three-sentence ceiling on a failure, and the Recovered
  pattern's *no message at all* are all derived from this paragraph.
- **Confirm or override:**

### 2.2 Five standing sentences, each with one fixed wording

- **Written into CONTENT.md:** § Terminology, *Standing sentences* — the read-only promise, the
  pre-1.0.0 statement, the support posture, the archiving statement, and (separately, at 2.4) the
  accessibility posture. Each is carried in those words on every surface that states it, with no
  paraphrase and no softening.
- **Grounds:** each states something `docs/PRD.md` already decided — § Success Metrics
  ("Read-only integrity"), § Assumptions ("Versioning", "Support posture", archiving). What the
  product promises is the CPO's and is not touched; only the wording is this document's. The
  one-wording rule itself is the instance's (`system/experience/voice_restrictions.md`
  § `one-wording-per-promise`).
- **What moves if you override:** a changed wording changes every surface that carries it, and the
  read-only sentence in particular is the one the whole voice is built around — § Voice's third
  behaviour (no screen reassures the reader) only holds because the promise is stated properly
  somewhere else.
- **Confirm or override:**

### 2.3 A failure never apologises, and a recovery says nothing at all

- **Written into CONTENT.md:** § Tone (the lifecycle map's *Failure* and *Recovery* rows),
  § Message patterns *Error* (three sentences at most; no cause, no apology) and *Recovered* (the
  failure sentence disappears and the state takes its place; no message marks the transition).
- **Grounds:** `docs/UXD.md` UX-I2 — updates arrive without ceremony, no notification, no
  attention bid — read across from an ordinary update to a recovery, which is this seat's
  reasoning and not a line the UXD states. The no-apology half is the instance's inherited line
  that a message does not tell the reader how to feel.
- **What moves if you override:** if a recovery should say something, the Recovered pattern gains
  a formula and examples, and § Voice's fourth behaviour (nothing asks for attention) needs a
  stated exception — because a recovery message is by definition unrequested.
- **Confirm or override:**

### 2.4 The accessibility posture sentence for the README

- **Written into CONTENT.md:** § Terminology, *Standing sentences*, last row —
  **"Nozoki is used with a mouse. It has no keyboard navigation, and it makes no promise about
  screen readers or other assistive technology. Neither is planned: keyboard navigation is outside
  what Nozoki is built to become."**
- **Grounds:** `docs/UXD.md` UX-A3 asks this document for the wording and fixes the placement (the
  README, below its first screen, stating the fact and not apologising for it); UX-A1 fixes what
  may be claimed. The permanence in the third sentence comes from
  `system/projects/nozoki/agari.md`, which places keyboard navigation outside the dock. It lands
  on the README, which is a surface the CPO owns, which is why it is here rather than simply
  written.
- **What moves if you override:** the wording is the whole item; UX-A3's requirement that the
  sentence exists, and where, is settled and does not move.
- **Confirm or override:**

### 2.5 One word for the repository — a rename of three words the README ships today

- **Today the product says:** `README.md` uses *code workspace viewer*, *a project's files*,
  *codebase* and *repository status* for one thing, in one file. The running product has no
  strings yet (*"Status: proposal — not yet implemented"*), so the README is the whole corpus.
- **This document says:** **repository**, everywhere. *repo* is rejected as an abbreviation the
  product never expands; *project* because it also means a unit of work Nozoki has no concept of;
  *workspace* because in the editor this product resembles it names a saved multi-folder
  configuration Nozoki has not got; *codebase* because it names the code and half of what Nozoki
  shows is Git state. Separately, the sidebar's list is **file tree** and never *tree* alone,
  because `docs/PRD.md` uses "the tree" for both that list and the files on disk.
- **What it costs:** a revision of `README.md` — four phrases — and nothing else, because no
  string, no help text and no released version exists yet. This is the cheapest this decision will
  ever be; after a release the same rename is paid for by strangers whose automation reads the
  words.
- **Confirm or override:**
