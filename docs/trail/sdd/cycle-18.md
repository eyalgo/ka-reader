# SDD open issues — KA-Reader

> Companion to `SDD.md`. Three seats — the CTO, the CPO and the CDO — authored the SDD
> non-interactively in one run; this file holds what that run could not settle from its inputs (the
> PRD, the SRS, the UXD, and any context or constraints).
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-01 from the SDD's own
> companion template, while re-reading the route after the grammar engine was first built, because
> `SDD.md` is Settled and with no companion on disk a `product-sdd` re-run reads it as done and has
> nothing to act on. Its one item is in § 5. §§ 1–4 hold nothing. It pairs with
> `docs/architecture_open_issues.md` § 3.1, which asks the NFDR to record the same review.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override

### 2.1 § 12 names two debts to the NFDR and ADR-0016 as open, and both are paid

> **No producing run wrote this item.** The `companion-self-answer` run answering this file raised
> it on 2026-10-01, under `<CORE>/prompts/decide_companion_answers.md` § *The items are not the
> whole of what a document is owed*. That section covers this case as *the document you are
> answering*. It came from reading `SDD.md` whole to answer § 5.1, and it has nothing to do with
> that item. The note at the head of this file, "Its one item is in § 5. §§ 1–4 hold nothing", was
> written before this item was added. This item's slot is left at its placeholder: the reasoning is
> that run's, and the decision belongs to the next round. Reasoning:
> `docs/trail/sdd/self_answer-29.md`, § *Raised on this document*.

- **Raised by:** `companion-self-answer`, answering this file — 2026-10-01
- **Drafted into the SDD:** Nothing has been written into the SDD. As it stands, § 12's downstream
  boundary reads: "Two things of this document's are owed to that store on the cycle-12 fold, and
  both are already raised there rather than from here: C-R7 now admits `ka_reader_free` beside SM-4's
  list, and `docs/nfdr.md` QC-24 still holds the export set inside the list alone
  (`docs/architecture_open_issues.md` § 2.1); and § 3's Swift-frame paragraph now rests on the
  Swift packet, where `docs/nfdr.md` § 9 and ADR-0016 still say none exists and `ka-reader-mac`'s
  departures from it are that document's to record (`docs/architecture_open_issues.md` § 3.4)"
  (`docs/SDD.md:L2660-L2666`). Both debts are paid, and neither pointer opens on its item:
  - QC-24 holds the export set "inside the closed list `docs/SDD.md` § 3 `SM-4` names" and adds
    "and `ka_reader_free`, the seam's one release call beside the list and not on it"
    (`docs/nfdr.md:L368-L374`).
  - § 9 takes `ka-reader-mac`'s tooling "from the Swift packet", says "Through v12 this paragraph read
    that no Swift packet existed … true when written, and history", and records where `ka-reader-mac`
    departs from the packet (`docs/nfdr.md:L926-L936`, `:L1056`). ADR-0016 carries the same
    correction, dated 2026-09-23
    (`docs/adr/0016-physical-unit-set-core-bridge-mac-checks.md:L44-L49`).
  - `docs/architecture_open_issues.md` holds "None." under § 2 and has no § 3.4 today. The two
    items the sentence cites stand at `docs/trail/architecture/cycle-10.md` § 2.1 and § 3.4.

  The draft change: the sentence keeps its words and gains a dated parenthesis saying that both
  were folded and where each item now stands. That is the form RC-1, RC-2 and RC-3 took (RN-56,
  RN-61, RN-66).

  One more sentence of the same kind, and a weaker case. § 12's UXD boundary lists what the owner's
  exit moves in `docs/DESIGN.md` "in that document's own run, which may trail this one", and quotes
  that document's § Overview as "realised in plain CSS custom properties over the product's own
  markup" (`docs/SDD.md:L2620-L2625`). The quoted sentence is no longer in `docs/DESIGN.md`: `grep
  -n -i "plain CSS" docs/DESIGN.md` prints `:L855` and `:L1348`, and `:L855` reads "Revisions 1–10
  read *plain CSS custom properties* here". RN-75 records that DESIGN v11 made the move. The draft
  change is the same dated parenthesis. The other two things that clause names, the font-stack
  syntax and that document's RN-1, were not measured.
- **Rationale:** Each is a measurement, made on `main` at `ka-reader@0297c13`. The first sentence
  tells the Principal Architect that two things are owed which are done, and sends that reader to
  two companion items that are not there. It is the defect the PM raised against the NFDR's QC-3 on
  this same day: a record that "states as owed a review that is now on the tree"
  (`docs/architecture_open_issues.md` § 3.1). The review notes are left out on purpose. RN-66,
  RN-70 and RN-76 cite sections of the architecture companion as it stood on their day, and a note
  is dated history (RN-55). The doubt, stated: this document has given stale "still" sentences
  their dated parenthesis inside a fold with no item, as found-while-walking repairs (RN-56,
  RN-61). A reader could hold that the same route serves here. It is raised because this file is
  already open, so the item costs no round of its own, and no fold is certain to walk § 12.
- **If overridden:** Nothing outside those two sentences moves. Left as they are, a reader of § 12
  looks for a QC-24 that leaves `ka_reader_free` out and finds one that names it, and opens
  `docs/architecture_open_issues.md` § 2.1 and § 3.4 and finds neither item.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 The grammar-engine question is answered on the tree and still open in the SDD
- **Raised by:** PM — 2026-10-01
- **Tracked by:** `ka-reader · nemawashi · 2026-10-01_a-file-reads-in-the-panel`
- **What it blocks:** nothing is blocked. *Open Questions* asks which engine compiles the six floor
  grammars, and the SDD states as open a decision the product has made and recorded.
- **Where it shows:** *Open Questions* reads "[OPEN: Which grammar engine compiles the six floor
  grammars into `ka-reader-core` (§ 3 `highlighter`), and what it adds to `checks/deps.allow`. Settled in
  `read-a-file` by the dependency review that change carries under C-R6 …]" (`docs/SDD.md:L4521-L4524`).
  § 3's `highlighter` row (`:L327`) and § 6 S-2 (`:L1484`) point at it. `checks/deps.review.md`
  § *The engine chosen* answers it: tree-sitter, meaning the `tree-sitter` runtime, `tree-sitter-highlight`
  and one grammar crate per floor language, compiled from C into `ka-reader-core`. It also names the 20
  names that engine adds to `checks/deps.allow` (`ka-reader@85d9fa7`).
  `crates/ka-reader-core/src/highlighter.rs` is built on it, and `cargo test --locked -p ka-reader-core --test
  highlight` passes (18 passed). The item should close, citing the review record. The `highlighter`
  row and S-2 should then name the engine, or the record, in place of the open question.
- **If a document has to be written:** none. *Open Questions*, § 3 `highlighter`, and § 6 S-2's
  pointer.
- **Answer:** Confirmed, with three additions. The question closes, and the SDD names the engine
  and cites the record. **The engine is tree-sitter**: the `tree-sitter` runtime,
  `tree-sitter-highlight`, and one grammar crate for each of the six floor languages, compiled from
  C into `ka-reader-core` at build time, with ka-reader's own query files compiled in
  (`checks/deps.review.md` § *The engine chosen*). The decision was made where the question said it
  would be: in a change of `read-a-file`, by the dependency review C-R6 requires, landed in one
  commit with `checks/deps.allow` and `Cargo.lock` (`ka-reader@85d9fa7`). Re-read on `main` before
  answering: `crates/ka-reader-core/src/highlighter.rs` is built on it, `cargo test --locked -p
  ka-reader-core --test highlight` prints `18 passed; 0 failed`, and `bash checks/no-network.sh` prints
  `ok — 40 cargo names match checks/deps.allow`.

  **What the fold writes.** (1) *Open Questions*: the fourth item is closed and removed, the way
  RN-48 and RN-70 closed theirs, and six remain. (2) § 3 `highlighter`: the clause that calls the
  engine "a dependency decision under § 4 C-R6, made in the slice that lands it (*Open Questions*)"
  names tree-sitter and cites the record by file, section and commit. (3) § 6 S-2's command half:
  "the engine that compiles them is named in `checks/deps.allow` where it is a crate (C-R6; *Open
  Questions*)" drops the pointer and the condition. The engine is crates, they are on the list, and
  the record reviews each one. The item offered "the engine, or the record". The answer is both:
  the row names the engine, and the citation is to the record.

  **Additions.** (a) § 10 RC-3's *Still unresolved* points at this question too — "and which
  engine compiles the six grammars (*Open Questions*)" (`docs/SDD.md:L2444-L2445`) — and the item
  did not list it. It keeps its words and gains a dated parenthesis, the form RN-48 and RN-70 used,
  so its pointer does not lead to a question that is gone. (b) The SDD states no count and no
  version for the engine: not "20 names", not `0.27.0`. The names are `checks/deps.allow`'s and the
  versions are `Cargo.lock`'s, and a count copied here is false at the next dependency change.
  (c) The Review Note for the fold carries the why by citation. The alternatives weighed,
  hand-written lexers and `syntect`, are in the record, and the fold re-weighs nothing.

  **Checked and left alone.** "third item" (§ 5 step 4, E-3), "the third Open Question" (§ 6 S-3)
  and "the second Open Question" (§ 6 S-4) keep their ordinals: the removed item is the fourth, and
  the later items are cited by name. § 4 C-R1, C-R6 and C-I5 stand as written, and the tree meets
  them. § 10 gains no entry: no *Reached when* failed, and the question resolved downstream as it
  said it would.

  **Not covered, and named so it is not read as covered.** The SDD carries no § 11 risk for a C
  parser reading a hostile file inside the one process, and no § 9 row for what the engine costs: a
  C compile in the build and the names it adds to the tree. No failure is cited for either, so this
  answer asks for neither, and whether the fold adds one is the seat's call.
  `checks/deps.review.md:L14` cites `docs/SDD.md:L4521-L4524` with no commit, and those lines stop
  holding the question once the fold removes it. That file is the delivery tier's and is not
  repaired from this document.

  **Downstream.** The NFDR's QC-3 is raised at `docs/architecture_open_issues.md` § 3.1.
  `docs/fdr.md` RN-17 (`:L411`) lists this question as standing in a re-read dated 2026-09-23. It is
  a dated note and no FDR rule turns on it. Answered in the owner's seat by a `companion-self-answer`
  run, not by the owner in person. Reasoning: `docs/trail/sdd/self_answer-29.md` § 5.1.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
