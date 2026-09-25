# DESIGN open issues — Nozoki

> Companion to `DESIGN.md`. The CDO authored the design language non-interactively; this file
> holds the calls it made and wants your sign-off on — each with the reason behind it, and what
> moves underneath it if you override — plus the few things it genuinely could not settle, and,
> when a design run has produced output for this product, the pointer to it.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-design`. It folds your answers into `DESIGN.md` and drops the resolved
> items. When nothing is left open, `product-design` **deletes this file**: no file = the
> design language is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CDO folds them in, it first copies this
> file whole to `docs/trail/design/` — so what you decided, and why, stays readable and citable
> for good.
>
> **§ 3 is not the CDO asking.** The design language is read by everything built after it, and a
> seat downstream can find a rule missing that the authoring run had no occasion to write. That item
> lands in § 3 and is folded by the same run.

> **No `product-design` run opened this companion.** A `companion-self-answer` run answering
> `docs/architecture_open_issues.md` § 3.1 opened it on 2026-09-25, in the Principal Architect's
> posture. `DESIGN.md` is Settled at v8 and had no companion on disk, so a `product-design` re-run
> would read the language as done and find nothing to act on. It holds one item, § 2.1: one line of
> § Do's that names a string `docs/CONTENT.md` owns and fixes differently — a collision CONTENT's
> RN-4 says it raised to the CDO, and that neither this document nor `docs/trail/design/` records
> receiving. The reasoning is `docs/trail/architecture/self_answer-18.md`.

---

## 1. Open issues

None.

## 2. Choices to confirm

### 2.1 § Do's says "show pending as the word *pending*", and the words are CONTENT's — which fixes a different sentence
- **Drafted into DESIGN.md:** the line as it stands — "Do draw an indicator — a status letter, a
  count, a 'nothing changed', a pending word — only after Nozoki has read the state it stands for,
  and show pending as the word *pending*, not as a bar or a spinner" (`docs/DESIGN.md:L745-L747`).
  The lean, for the seat that folds it: keep the rule and drop the string — "show pending as a
  word, in `docs/CONTENT.md`'s wording, not as a bar or a spinner" — which is what RN-14 already
  says of it ("Pending states carry a word and nothing that moves", `:L917-L918`).
- **Grounds:** `docs/DESIGN.md` § Components "Status messages" hands the words of every empty,
  pending and failure state to `docs/CONTENT.md` (`:L668-L674`, "only the words differ, and those
  are `docs/CONTENT.md`'s"). CONTENT § Message patterns *Loading* fixes *"Reading this folder."*
  for the pending folder (`docs/CONTENT.md:L314`), and its RN-4 records the collision with this
  line and says it "is raised to the CDO rather than applied silently" (`:L547-L554`). No Review
  Note here and no file under `docs/trail/design/` records that raise arriving:
  `grep -n 'ellipsis\|full stop\|Reading this' docs/DESIGN.md` finds one line, `:L471`, about a
  clipped row name, and `grep -ni pending docs/trail/design/*.md` finds only a record described as
  pending, never the word on a surface. The same string sits in `docs/fdr.md` R-94 and is raised
  on that document's companion (`docs/fdr_open_issues.md` § 2.1); the NFDR check that verified it
  is being corrected on `docs/architecture_open_issues.md` § 3.1.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write the design language

None.
