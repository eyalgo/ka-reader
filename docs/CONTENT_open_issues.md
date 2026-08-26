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
- **Answer:** **Nozoki carries its own stronger sentence — the drafted one**, in these words:
  *"Nozoki sends no telemetry, and it makes no network call while it runs — downloading it uses the
  network; using it does not."* It does **not** carry the instance's fenced sentence verbatim. That
  wording becomes the standing sentence for the network row, on every surface that states the
  promise (the README, the release page, the not-loaded placeholder in rendered Markdown).

  The owner's words: "i agree with you." Their agreement was to the reading put to them, which is
  the session's and is recorded here because the fold needs the grounds, not just the verdict:
  (1) the fence's prohibition is directional — it bars paraphrasing, shortening or softening a
  promise (`system/experience/voice_restrictions.md:94-96`), and a stronger sentence does none of
  those; (2) the fence asks for exactly this shape — *"where a promise has a real exception, that
  exception is inside the one wording"* (`:96-97`), and the draft puts the acquisition exception
  inside the sentence rather than footnoting it on the surface that needs it; (3) the doctrine
  settles the direction — *"The norms above are the floor if that default is ever departed from,
  never the ceiling"* (`system/doctrine/kensaiapp_doctrine.md:107-110`), and the fence already
  contemplates departure in the weaker direction (`voice_restrictions.md:102-104`), so a departure
  upward is the easier case.

  So this is read as **tightening** the fenced entry, not replacing it. The PRD's *non-essential*
  headroom is preserved and not advertised: the sentence states v1's truth ("while it runs") and
  says nothing about later versions.

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
- **Answer:** **A hover tooltip on the row, as VS Code does it** — hovering a status letter shows,
  briefly, the file and the expanded word ("Modified"). The owner's words: *"in VS code, when you
  hover over an `M` for example, there's a short-time 'file and + Modified'. I think that this is
  enough. Remember, users of nozoki most likely know how git works."*

  So the expansion lives **in the view, on demand** — not as a permanent legend in the Git view, and
  not as a README list. The README expansion the run drafted as the interim rule is **not** the
  answer; whether it is still worth carrying as a second, static home is not something the owner
  spoke to and is left to the fold to raise if it wants it.

  **Two collisions this answer creates, neither of which this companion can settle. Both were put
  to the owner.**

  1. **`DESIGN.md` § Do's and Don'ts rules out a tooltip**, and that Don't is *settled* — DESIGN v2
     (`nozoki@95f1279`) with no companion on disk. When the owner overrode the no-hover rule at
     `DESIGN_open_issues.md` § 2.3 they overrode hover **alone**; the record there states that "no
     transition, no focus ring and no tooltip ... stand as drafted". **The owner has since ruled
     on this directly: *"i think that tooltips should be included in v1."*** So the tooltip is in
     scope for v1 and DESIGN's no-tooltip Don't is to be lifted — as a v1 decision, not as a
     one-off exception for status letters. That edit is the CDO's, needs DESIGN re-opened, and is
     not made here.
  2. **The stated expertise floor says the opposite about Git knowledge.** `docs/PRD.md` § Goals,
     "No learning curve", puts the audience at *no Git knowledge beyond finding their way around a
     repository on a hosting site*. The owner's reason here — that Nozoki's users most likely know
     how Git works — is a different audience assumption, and the PRD is the CPO's settled document.
     A tooltip is a weaker fix than a legend for a reader who does **not** know Git, because it
     must be discovered by hovering. The owner made the call knowing this, and answered the
     mismatch itself: *"we can add another open issue file to prd to set that up"* — so the PRD's
     audience line is to be revisited through its own companion, by the CPO, and is not settled
     here.

  **Unchanged and still true regardless of the above:** `docs/DESIGN.md` groups the letters as
  "A and U (added); M (modified); D and C (deleted, conflict); R (renamed)", while Git's porcelain
  reports `C` as *copied* and `U` as *unmerged*. Whatever the tooltip says has to say the right
  word, so the mapping defect below must be fixed before the tooltip text is written.

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
- **Answer:** **Both claims are wrong and both are to be fixed — through the PRD's companion, by
  the CPO, not here.** The owner's words: *"it's not a webapp, so it needs to be changed. need to
  fix the roadmap. i guess it should be written in the prd companion."*

  1. ***"web app"* is inaccurate and is to be changed.** The owner ruled on the substance directly:
     Nozoki is not a web app. `docs/SRS.md` C-11 (macOS only) and `docs/PRD.md` § Out of Scope
     (*"any hosted operation of the tool itself"*) are what it collides with. The replacement
     wording is the CPO's to write and is **not** drafted here; the session's observation, offered
     but not ruled on, was that the misleading word is *web* rather than the *VS Code-like*
     comparison, which is doing real work in the sentence.
  2. **The roadmap is to be fixed.** `README.md` § Roadmap phase 3 promises *pane resizing,
     keyboard navigation, sidebar search* — three things `system/projects/nozoki/agari.md` places
     permanently outside the dock (*"nozoki is done without them"*, the keyboard absence stated as
     permanent, not deferred; `docs/UXD.md` UX-I8 and UX-A1 carry the same). What replaces them is
     the CPO's call and is not settled here.

  **Routing, as the owner set it:** both go into the PRD's open-issues companion, alongside the
  audience/Git-knowledge line from § 1.2. That companion does not exist yet — the PRD is settled at
  v8 with no companion on disk — so it has to be opened deliberately for the CPO to have anything
  to act on, exactly as the UXD's was at `nozoki@ee8abcf`.

  **`CONTENT.md` itself carries none of these claims** and needs no change from this item; the
  run raised them rather than editing them because the README's claims are the CPO's.

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
- **Confirm or override:** confirm — § Voice stands as written: Nozoki speaks as itself, names what
  it observed and stops; the reader's own text is not Nozoki's writing and no rule applies to it;
  the voice is conversational but not casual; the seven behaviours in the table stand. Everything
  derived from it stands with it — the tone maps, the ban on exclamation marks and on *sorry* /
  *don't worry*, the three-sentence ceiling on a failure, and the Recovered pattern's *no message
  at all*. The owner said "confirm" and nothing more; the argument put to them — that the sentences
  a reader meets most are the failure ones, so that is where the voice is actually judged, and that
  *conversational but not casual* is a narrow band better checked against real strings later than
  re-decided now — is the session's.

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
- **Confirm or override:** **override — one amendment to the read-only sentence; the other five
  stand as written.** The owner read the table and ruled: *"they look ok"*, then took the session's
  proposed fix — *"add your fix to the content companion."*

  **The amendment.** The read-only row's wording becomes:

  > **"Nozoki never changes the repository you point it at. It writes no file in it, and it runs no
  > Git command that alters your repository's state."**

  The change is two words — *no file* becomes *no file in it*. Everything else in the row is
  unchanged, and every surface carrying this sentence carries the amended wording.

  **Why.** The first sentence is scoped to *the repository you point it at*; the second was not, and
  as an absolute it is false. Nozoki does write files: `docs/UXD.md` UX-I9 remembers the theme
  choice *"in the tool's own state — never in the repository"*, and UX-F5's selector remembers
  repositories across sessions. Both live on disk somewhere outside the repository. A stranger who
  reads *"it writes no file"* and then finds a preferences file has caught the product's defining
  promise being false — which is exactly what `system/experience/voice_restrictions.md`
  § `one-wording-per-promise` exists to prevent, and this is the sentence the whole voice rests on
  (§ Voice's third behaviour holds only because this promise is stated properly). The scoped wording
  is also the *stronger* claim to a reader: it is about their repository, rather than a claim about
  the whole filesystem that invites a counterexample.

  **The other five rows are confirmed as written** — the network sentence (settled at § 1.1 above),
  the pre-1.0.0 statement, the support posture, archiving, and the accessibility posture (whose own
  confirm is § 2.4). Two that were checked against their sources and hold: the support posture
  declines to promise acknowledgement on security reports, matching what the owner settled in the
  PRD round; the accessibility sentence states the absence as permanent rather than deferred,
  matching `system/projects/nozoki/agari.md`.

  **One accounting note for the fold, not a call:** this item is titled *"Five standing sentences"*
  but § Terminology's table has **six** rows — the owner counted them. The sixth is the
  accessibility posture, whose wording is confirmed at § 2.4 rather than here. The title reads as a
  miscount unless it says so.

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
- **Confirm or override:** confirm — both halves stand. A failure carries no apology and at most
  three sentences (§ Message patterns *Error*); a recovery says nothing at all — the failure
  sentence disappears, the state takes its place, and no message marks the transition
  (§ Message patterns *Recovered*, § Tone's lifecycle map).

  **One thing the session checked before the owner answered, recorded because the item's summary
  invited the wrong reading.** "No cause" was queried: read alone it could forbid naming a cause the
  reader could act on, which would collide with § Voice's own commitment to name what it observed
  and stop. The pattern's actual text answers it — the formula's second clause is *"what it
  observed, naming the file, path or state"* (`docs/CONTENT.md:211-214`), and both examples name
  why: *"looked for a Git repository at `/Users/you/code/app` and didn't find one"*, and
  *"can't read this repository's Git status while `.git/index.lock` is there"*. So **"no cause"
  means no mechanical cause — no error code, no library name — not "never say why"**. The owner
  confirmed after reading the pattern, not the summary.

  Also noted while reading it, and not a call: the third clause requires a failure that offers no
  action to say *what ends the wait* rather than leaving the reader staring at it. That is
  load-bearing and worth keeping if the pattern is ever revised.

  **The owner qualified the confirm, and this part IS a call on the document.** Their words:
  *"there's a difference between `file not found` (an example like your set of examples) and a
  system error."* Both examples in the pattern — and both quoted above — are **expected
  conditions**: a path with no repository at it, an `.git/index.lock` that is present. Each has a
  clean *what it observed* to name, which is what makes the formula work and what makes "no cause"
  costless. A **system error** is the other class: an unexpected fault with no observable repository
  state behind it — a permissions failure, an exhausted resource, an unhandled exception. There the
  formula's second clause has nothing to name, and "no cause" would leave the reader with a message
  that says a thing went wrong and nothing else.

  **The pattern as written does not distinguish the two classes, and the owner has said it should.**
  What the second class's formula is — whether it names a mechanical cause after all, offers a way
  to report it, or says something else entirely — is not settled here; the owner stated the
  distinction, not the remedy. It is `product-content`'s to author on the fold, and it should not be
  folded as a silent confirm of the single existing formula.

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
- **Confirm or override:** confirm — the accessibility sentence stands exactly as written:
  **"Nozoki is used with a mouse. It has no keyboard navigation, and it makes no promise about
  screen readers or other assistive technology. Neither is planned: keyboard navigation is outside
  what Nozoki is built to become."** UX-A3's placement (the README, below its first screen) was
  already settled by the owner and does not move.

  The owner said "confirm" and nothing more. The reading put to them, which is the session's: it
  states the limit as a fact rather than a failing, so it does not apologise; it separates a definite
  absence (no keyboard navigation) from an untested one (no promise about assistive technology),
  which is the honest split; and *"Neither is planned"* lets a reader who needs keyboard access stop
  waiting, matching `system/projects/nozoki/agari.md`'s permanent-not-deferred placement. One
  preference was offered and **not** taken up, so the drafted wording stands: that *"outside what
  Nozoki is built to become"* could read plainer as *"not something Nozoki will add"*.

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
- **Confirm or override:** confirm — **repository**, everywhere, and the four README phrases
  (*code workspace viewer*, *a project's files*, *codebase*, *repository status*) are renamed to it.
  The rejections stand as written: *repo*, *project*, *workspace*, *codebase*. The sidebar's list is
  **file tree** and never *tree* alone.

  The owner said "confirm" and nothing more; the argument put to them — that *repository* is Git's
  own word and the only one of the four covering both halves of what Nozoki shows, and that
  *codebase* fails that test by naming only the code when half the product is Git state — is the
  session's.

  **One sequencing note for whoever revises the README, not a call:** this rename touches
  `README.md`, and so do two fixes the owner routed to the PRD's companion at § 1.3 — the roadmap's
  three permanently-out-of-scope promises, and the *"web app"* description. All three want to land
  in one pass rather than three.
