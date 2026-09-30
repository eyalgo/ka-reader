# DESIGN open issues — nozoki

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

> **No `product-design` run opened this companion. A `companion-self-answer` run answering
> `docs/SDD_open_issues.md` § 5.1 opened it on 2026-09-30** (its report:
> `docs/trail/sdd/self_answer-27.md`). `DESIGN.md` is Settled at v10 and had no companion on disk,
> so a `product-design` re-run would read it as done and find nothing to act on. The one item, § 2.1,
> is a fact in this document that is now false: § Overview says the language is realised in CSS
> custom properties over the product's own markup, and the shell it dresses has been one AppKit
> process with no web engine and no markup since `docs/SDD.md` v13 (§ 10 RC-3, 2026-09-23). The SDD
> is not one of this document's inputs (`docs/DESIGN.md:L303`), so no design run has seen that
> change, and this file is the only channel through which it can.

---

## 1. Open issues

None.

## 2. Choices to confirm

### 2.1 § Overview says the language is realised in CSS custom properties over the product's own markup, and the shell it dresses draws no markup
- **Drafted into DESIGN.md:** nothing yet — the run that raised this edits no document. The change
  owed: § Overview's realisation sentence — "It is realised in plain CSS custom properties over the
  product's own markup on a macOS window (`docs/SRS.md` C-11; `README.md` § Planned stack)"
  (`docs/DESIGN.md:L331-L333`) — and RN-1's "every value here is a CSS value and holds in either"
  (`docs/DESIGN.md:L786-L787`) say what the SDD now draws: one AppKit shell in Swift, one process, no
  web engine, no HTML and no CSS anywhere in the product (`docs/SDD.md` § 2 "The view is AppKit, and
  its language is Swift"; § 4 C-R1; § 10 RC-3). No token value moves: every value this document
  fixes is a number or a colour a native view draws directly, which is the SDD's own reading of what
  survives (`docs/SDD.md` § 12, the UXD boundary; its RN-53, RN-62). Whether § Typography's and the
  frontmatter's `fontFamily:` CSS font-stack syntax (`docs/DESIGN.md:L29-L66`) also moves is the
  CDO's call at the fold — the SDD names it as the third of three sentences and this item does not
  decide it.
- **Grounds:** the sentence was true when written and is false now. `docs/DESIGN.md`'s inputs are
  the UXD, the PRD and CONTENT (`docs/DESIGN.md:L303`), never the SDD, so revisions 8 to 10 could not
  have seen RC-3; the SDD has carried the sentence as owed to this document's own run since v13
  (`docs/SDD.md` RN-53, 2026-09-23) and re-checked it at RN-69 on 2026-09-24 — "`docs/DESIGN.md:L330`
  still reads 'realised in plain CSS custom properties'"; this document then reached v10 on
  2026-09-25 (`nozoki@da88347`) with the sentence unchanged (`grep -n -i 'css\|markup'
  docs/DESIGN.md`, 2026-09-30: lines 331–332, 780–786, and nothing else). The README the sentence
  cites no longer says it: `grep -n -i 'css\|markup\|planned stack' README.md` exits 1 on `main` at
  `nozoki@8e738b7`. The reader this costs: `docs/SDD.md` § 6 S-1's observable half is about to hold
  § Layout and § Components for the surfaces it draws (`docs/SDD_open_issues.md` § 5.1, answered
  2026-09-30), and a builder opening this document to meet that bar meets a realisation the product
  cannot have.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write the design language

None.
