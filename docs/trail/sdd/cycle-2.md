# SDD open issues — ka-reader

> Companion to `SDD.md`. Three seats — the CTO, the CPO and the CDO — authored the SDD
> non-interactively in one run; this file holds what that run could not settle from its inputs (the
> PRD, the SRS, the UXD, and any context or constraints).
>
> **Answer inline** — fill each **Answer** / **Confirm-or-override** / **Keep-or-recut** slot —
> **commit this file**, then re-run `product-sdd`. It folds your answers into the SDD and drops the
> resolved items. When nothing is left open, `product-sdd` **deletes this file**: no file = the SDD
> is done.
>
> Your answers are never thrown away. Each time the seats fold them in, they first copy this file
> whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a disagreement is not something one seat asked, it
> is something two seats answered differently, and the answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the run entirely.** §§ 1–4 are all the SDD's own three seats;
> § 5 is a seat that never wrote the SDD, reading it long after it settled and finding something
> only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's, which stay fixed
> to the three authoring seats on purpose.

---

## 1. Open issues — questions with no answer yet

<None open. § 1.1 — whether the previous SDD's answers bind this run — was answered *they bind*
and folded (`SDD.md` RN-3, RN-5, RN-17); its answer 3 carries the routing rule § 2.2 below is
left open under. It stands whole at `docs/trail/sdd/cycle-1.md` § 1.1.>

## 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override

*§ 2.1 — an SVG inside the folder is not rendered in place, it takes a stated placeholder — was
answered **confirm**, with two additions, and folded (`SDD.md` § 4 C-D3, RN-8, RN-31, § 6 S-3). It
stands whole at `docs/trail/sdd/cycle-1.md` § 2.1.*

### 2.2 What the 1.0.0 promise covers — the contract the version number starts
- **Raised by:** CPO
- **Drafted into the SDD:** `SDD.md` § 6 S-11 `promise-one-point-zero`, *Delivers*, as it stands
  on disk after §§ 2.3 and 2.4 classified it: from 1.0.0 the number covers four members, stated
  as two kinds — **what the number prices:** (a) the one install path and the macOS floor, (d)
  every surface the PRD names, present, so that removing a surface, raising the floor, adding a
  prerequisite or changing the install path costs a major version; **what no version changes:**
  (b) no write to the viewed folder (`docs/SRS.md` C-2), no telemetry (NFR-7), no network call
  during operation with NFR-8's own route named (a PRD revision first; until one lands, none), and
  (c) own state read whole or discarded whole, touching no folder (`SDD.md` § 4 C-D4). Not
  covered: the exact wording of any message, any token value, the diagnostic log's lines, and
  anything the harness prints. The members are the same four the first draft listed; the two
  classifying items added and removed none.
- **Rationale:** The PRD makes 1.0.0 "the moment the promise starts" and prices "a breaking change
  to what users rely on" (`docs/PRD.md` § Assumptions "Versioning"); the SRS binds "a breaking
  change to the product's public contract" (`docs/SRS.md` C-6). Neither says what an application
  with no flags, no library and no API has as its contract, and the declaration is this seat's to
  make (`SDD.md` RN-19). The four items are what an adopter demonstrably relies on between
  versions: the way in, the two promises the product is for, their own remembered state, and the
  surface they came for. The exclusions keep the promise from freezing wording and tokens, which
  the PRD leaves to documents that may move. What is genuinely still yours after the two
  classifications is narrow — the install path, and that removing a PRD-named surface costs a
  major version — and the answer the self-answer run would have given, with six additions it
  names, is at `docs/trail/sdd/self_answer-5.md` § 2.2; narrow is not small, because that residue
  is the whole of what an adopter is asked to rely on.
- **If overridden:** S-11's *Delivers* and RN-19 change; the README sentence the closing release
  carries changes with them; nothing in §§ 2–4 or in any other slice moves. Widening the contract
  to wording or tokens would make `docs/CONTENT.md` and `docs/DESIGN.md` revisions major-version
  events, which is the cost to weigh.
- **Confirm or override:** **confirm** — the owner's answer, 2026-09-04, given as "i guess
  confirm". The draft stands as it is: the four members in the two kinds §§ 2.3 and 2.4 left them,
  and the exclusions. **None of the six additions the walk offered was taken** — they were raised
  by the walking session and not by this item, so the answer is to the draft as it stands and the
  fold adds no clause and changes no member. The residue the walk named as genuinely still open —
  the install path, and that removing a PRD-named surface costs a major version — is confirmed as
  drafted.

*§ 2.3 — S-11's contract stated as two kinds of thing, not one list of four — was answered
**confirm** and folded (`SDD.md` § 6 S-11 *Delivers*, RN-19). It stands whole at
`docs/trail/sdd/cycle-1.md` § 2.3.*

### 2.4 The priced set carries "read-only" inside member (d) — an invariant no version prices

> **No producing run wrote this item.** It was raised on 2026-09-03 by the `companion-self-answer`
> run answering this file, under `<CORE>/prompts/decide_companion_answers.md` § *The items are not
> the whole of what a document is owed* — the case that section names as *the document you are
> answering*. It is not a split of § 2.2: § 2.2 asks which members the contract covers, and this
> asks which kind one member's own clause is, under the rule § 2.3 settled and RN-19 now carries.
> § 2.2's slot is untouched and its question is unchanged. This item's slot is left at its
> placeholder too: the reasoning is that run's, the decision is the next round's. Reasoning:
> `docs/trail/sdd/self_answer-5.md` § 2.4.

- **Raised by:** `companion-self-answer`, answering this file — 2026-09-03
- **Drafted into the SDD:** `SDD.md` § 6 S-11 *Delivers*, as the round-2 fold left it, states the
  priced set as *"the one install path and the macOS floor, and every surface the PRD names present
  **and read-only**, so that removing a surface, raising the floor, adding a prerequisite or
  changing the install path costs a major version"* — and states the unconditional set as beginning
  *"no write to the viewed folder ('no write path to the viewed folder exists in any version',
  `docs/SRS.md` C-2)"*.
- **Rationale:** A surface being read-only **is** C-2, and C-2 is already the first member of the
  unconditional set — so the same invariant is stated in both sets, and the two sets give a reader
  opposite answers. Asked what making a surface writable costs, the priced set answers *a major
  version*, because that is what the priced set means; the unconditional set answers *it cannot
  happen at any version*, which is right — `docs/SRS.md` C-2 reads *"Viewer-only, permanently: no
  write path to the viewed folder exists in any version; adding one would be a different product"*,
  and § 4 C-E5 makes read-only the identity rather than a mode. The closing clause is the tell: it
  reaches removing a surface, raising the floor, adding a prerequisite and changing the install
  path, and it does not reach read-only — because no price exists to reach it with.
  **Why § 2.3 did not catch it.** That item asked which of the four listed members the closing
  clause reaches, and (d) is one it does reach — for **presence**. So (d) passed as a member while
  carrying a second property that fails the same test, one level down. The defect pre-dates the
  fold; what the fold changed is that the two-kind structure now makes it visible and cheap to fix.
- **The change:** the priced set's member (d) reads *every surface the PRD names, present* — and
  nothing about read-only, which the unconditional set already carries by C-2. RN-19's worked
  example ("applied today the sets are…") drops the same two words. **This adds and removes no
  member of the contract:** read-only stays covered, in the set whose constraint actually places it,
  and the fix is a deletion of a restatement rather than an addition. Like § 2.3, it applies to
  whatever § 2.2 settles — including an override that drops (d) altogether, which moots it.
- **If overridden:** the sentence stands as folded, with read-only named in both sets, and a reader
  costing a change to it takes whichever answer they reach first. Nothing else moves either way — no
  slice, no § 4 condition, no other § 6 field, no section of § 12.
- **Confirm or override:** **confirm** — decided by the CPO seat in run 2, round 1 (2026-09-03),
  not by the owner, and the seat says why it may: under the routing rule § 1.1's answer bound
  (`docs/trail/sdd/cycle-1.md` § 1.1, answer 3), an item goes to the owner when its answer changes
  what the product promises, and this one changes only where a promise already made is stated.
  Read-only is C-2's and the unconditional set already carries it; the priced set's (d) drops the
  two words and reads *every surface the PRD names, present*. Folded: `SDD.md` § 6 S-11 *Delivers*,
  and RN-19 (changed, carrying this authorization). No member added or removed; it applies to
  whatever § 2.2 settles, and an override there that drops (d) moots it. Reasoning:
  `docs/trail/sdd/self_answer-5.md` § 2.4.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

<This section is the SDD's own, and has no twin in the upstream companions. The four tests in
`SDD.md` § 5 settle most cuts on their own; this section holds the ones they do not — a place where
two defensible cuts pass all four, and the choice between them is the owner's taste, appetite for
risk, or knowledge of what is coming next. A cut that fails one of the four tests is not an item
here. It is a defect, and it is fixed in the SDD rather than asked about.>

<None open. § 3.1 — `first-public-release` after the v1 cut, below 1.0.0 — was answered **keep**
on the owner's own prior ruling and folded (`SDD.md` § 5 step 4 E-7, § 6 S-7, § 7, RN-17). It
stands whole at `docs/trail/sdd/cycle-1.md` § 3.1.>

---

## 4. Disagreements — two seats hold different positions and neither yields

<Both positions are recorded. Neither is averaged. A middle written into the SDD is a position no
seat holds and no seat will defend when it turns out wrong. What goes into `SDD.md` is whichever
position you pick; what stays here until you pick is both.>

<None yet.>

## 5. Raised from downstream — an item from a seat that did not write the SDD

<None open. § 5.1 — the units table `sdd_template.md` v4.1.0 requires under § 3's parts table —
was answered *add it: four rows, nothing else in § 3 touched* in the owner's seat and folded
(`SDD.md` § 3, RN-36). § 5.2 — the 38 citations the re-author broke in the decision log and the
NFDR, reported and never repaired from here — was answered *write the Review Note, numbered after
RN-33* and folded (`SDD.md` RN-34, § 12 *The downstream boundary*). Both stand whole at
`docs/trail/sdd/cycle-1.md` § 5.1 and § 5.2.>
