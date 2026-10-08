# PRD open issues — KA-Reader

> Companion to `PRD.md`. The CPO authored the PRD non-interactively; this file holds
> what it could not settle from the inputs. **Answer inline** — fill each **Answer** /
> **Confirm-or-override** slot — **commit this file**, then re-run `product-prd`. It folds
> your answers into the PRD and drops the resolved items. When nothing is left unresolved,
> `product-prd` clears this file: no file = the PRD is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CPO folds them in, it first copies
> this file whole to `docs/trail/prd/` — so what you decided, and why, stays readable
> and citable for good.

> **Where this round came from.** The previous item — eight sentences that named the input
> *repository* where v11 made it a *folder* — was confirmed at `docs/trail/prd/cycle-12.md` § 2.1
> by a `companion-self-answer` run in the owner's seat (its reasoning:
> `docs/trail/prd/self_answer-2.md` § 2.1), and `PRD.md` v14 folds it: the eight markers now
> record the confirmation. The same self-answer run raised the one item below while reading the
> document whole; it wrote nothing into `PRD.md`, and this `product-prd` run has now drafted the
> change into the body, marked *awaiting confirmation* where it sits — the skill's shape for a
> choice to confirm. `Status:` is Draft while this file is open. One word; the slot is yours.

---

## 1. Open issues — product-defining questions with no answer yet

None.

## 2. Choices to confirm — the CPO drafted a best-effort answer; confirm or override

### 2.1 § UX Notes "The character" named the dominant surface the *editor panel*; drafted as the *reading panel* at v14, awaiting your confirmation

> **This item was raised by a `companion-self-answer` run, not by a `product-prd` run**
> (`docs/trail/prd/self_answer-2.md` § Raised on this document, carried here as § 2.2 of
> `docs/trail/prd/cycle-12.md`). The `product-prd` run that followed drafted it. The self-answer
> run's finding and its stated doubt are kept below as written; the CPO's own reading follows.

- **Drafted into the PRD (v14):** one sentence in § UX Notes "The character" — *"The editor panel
  is the dominant visual surface"* — now reads *"The reading panel is the dominant visual
  surface"*, with a marker where it sits: *(Reading panel, not editor panel: changed — the input's
  word is "editor area"; the document's own § Out of Scope and § Assumptions say reading panel,
  and `docs/CONTENT.md` § Terminology settles it as the one name; applied here awaiting
  confirmation)*. The version line records the change and its authorization. Nothing else moves.
- **Rationale (the self-answer run's, as raised):** the document names one surface two ways.
  § Out of Scope says what the input's experience notes carry — *"the reading panel dominant,
  text-first navigation, two themes — is carried in UX Notes"* — and § Assumptions says *"a file
  tree beside a reading panel"*; the UX Notes sentence § Out of Scope points at said *editor
  panel*. `docs/CONTENT.md` § Terminology settles the term as **reading panel** and rejects
  *editor*: *"there is no editor; the word implies a write path that does not exist"*. The
  instance's writing bar binds every document authored here to one name per term, and its check
  is the one this failed — *"take any concept named in two documents here; both use the same word
  for it"* (`system/doctrine/writing_bar.md` § 1.2). The sentence sits in the paragraph that
  states *"Read-only is the product's identity, not a mode"*, so the one word that implies a write
  path was in the sentence after the one denying it. Every other *editor* in the document stays:
  *"editor-style layout"*, *"workbench-style shell"*, *"looking like an editor"*, *"the full
  editor they already have"* name the alternative or the resemblance, which is what the word is
  right for, and § Success Metrics' *"the editor area"* quotes the input. **The doubt, as the
  self-answer run stated it:** this is one word, and the documents downstream — UXD, CONTENT,
  DESIGN — are already settled on *reading panel*, so no reader is misled today; it is raised
  because the document contradicts its own § Out of Scope sentence about what UX Notes carries,
  and the bar's check fails on it. If the CPO holds *editor panel* as the input's word kept on
  purpose, the override is to say so where the document records its reasons, so the residue reads
  as a decision.
- **The CPO's reading, added by the `product-prd` run:**
  - *On the relation to the input:* the input's word is *editor area* — *"a main editor area that
    is strictly read-only"* (`docs/proposal.md` § Overview) — so the rename is a departure from
    the input, not a repair of the document alone; that is why it wears the *changed* marker and
    is a choice to confirm rather than a fold on the document's own authority. The CPO takes the
    rename: the input's word names the component it recommends (Monaco, an editor in read-only
    mode — `docs/proposal.md` § Editor Choice), which this document keeps out as an
    implementation choice (§ Out of Scope, *"editor component"*); the product's word for the
    surface should not be borrowed from a stack recommendation it declines to carry.
  - *On the doubt:* the CPO does not hold *editor panel* as a deliberate keep. The one place the
    input's word is kept on purpose is § Success Metrics' *"the editor area"*, which is a quotation
    of the input inside a *changed* marker and stays a quotation. The four *editor* uses that name
    the alternative or the resemblance stay, as the self-answer run sorted them.
  - *What was checked and left alone:* `grep -n "editor panel\|reading panel" docs/PRD.md` at v13
    found one *editor panel* (the sentence drafted) and one *reading panel* (§ Out of Scope);
    § Assumptions' *"a file tree beside a reading panel"* is the third mention. No other sentence
    in the document names the surface.
  - *The fold, either way:* on **confirm**, the marker becomes *confirmed: trail/prd/cycle-13.md
    § 2.1* and the version line records the close. Nothing downstream waits on it — `docs/UXD.md`,
    `docs/CONTENT.md` and `docs/DESIGN.md` already say *reading panel*. On **override**, the
    sentence reverts to *editor panel* and the version line records it as the input's word kept
    on purpose, so the residue reads as a decision.
- **Confirm or override:** confirm — the sentence reads *reading panel*, on the reasoning the item
  carries: the document's own § Out of Scope and § Assumptions already say *reading panel*,
  `docs/CONTENT.md` § Terminology settles the term and rejects *editor* for it, and no other
  *editor* in v14 names the surface — each names the alternative, the resemblance, or the input
  quoted. Confirmed with one addition: the input's own phrase for this sentence is *"Make the
  editor panel the dominant visual surface"* (`docs/proposal.md` § Styling Guidance), verbatim —
  not § Overview's *"editor area"*, which the item and the v14 marker cite — so the *changed*
  marker on fold should point at § Styling Guidance, where the sentence departed from actually
  is. Decided by a `companion-self-answer` run in the owner's seat; reasoning at
  `docs/trail/prd/self_answer-3.md` § 2.1.

## 3. Directives — an external action the owner confirms as a gate

None.
