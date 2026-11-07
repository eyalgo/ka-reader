# SDD open issues — ka-reader

> Companion to `SDD.md`. The CTO wrote the SDD; this file holds what that run could not settle from
> its inputs (the PRD, the SRS, the UXD, and any context or constraints), and the calls that are the
> CPO's or the CDO's to make. An item whose call is the CPO's or the CDO's carries that seat's
> `Seat:`; an item whose call is the CTO's carries `cto` or no `Seat:` field.
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time `product-sdd` folds them in, it first copies this
> file whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **§ 5 names a raiser from outside the SDD's lanes entirely.** §§ 1–4 are all the SDD's own three
> lane seats; § 5 is a seat that never held a lane in it, reading it long after it settled and
> finding something only the SDD can fix.

> **No `product-sdd` run wrote this file.** The Product Owner opened it on 2026-11-07, reading the
> settled SDD (v78) against `docs/DESIGN.md` and the product at `ka-reader@be1d368`. One item
> follows in § 5; the SDD is not edited.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 The `surfaces` row names an `NSTextBlock` as the code cell's form, and inline code cannot be one and stay inside its line
- **Raised by:** Product Owner — 2026-11-07
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** the code cell's drawing for inline code. *The Markdown page's layout form*
  names fenced code and inline code as both missing the canvas surface, then names one form for
  the cell: "an `NSTextBlock` carrying the canvas background and the padding and no border, under
  the same manager — named here as the design". A delivery stage reads a Settled form as fixed, and
  reads it here for inline code as well. For fenced code the form holds. For inline code it cannot
  hold beside `docs/DESIGN.md`, which places inline code inside a line (§ Shapes, `:L565`, "things
  that sit *inside* a row or a line: … inline code"; `{typography.prose-code}`, "inline and
  fenced", `:L483-L484`), nor beside this document's own `MarkdownDocument`, where code is an inline
  node that a heading or a paragraph holds (`docs/SDD.md:L738`).
- **Where it shows:** § 3, the `surfaces` row, *The Markdown page's layout form*
  (`docs/SDD.md:L535`), at `ka-reader@be1d368`. Under TextKit 1 a text block is a paragraph
  attribute (`NSParagraphStyle.textBlocks`), and the text storage holds one paragraph style across
  a paragraph. Measured on macOS 26.6 with an `NSLayoutManager` over an `NSTextStorage` at the
  704-point measure: a block set on a code run in the middle of a paragraph is dropped — "before
  code after" lays out as one line fragment, and none of its three runs carries a text block — and a
  block set on a code run that opens its paragraph spreads to the whole paragraph, the prose after
  it included. So this form either draws no surface for inline code, draws the surface under the
  whole paragraph, or takes the code out of its line. Each of those contradicts one of the
  statements above. The drawing at the pin is as the row says: inline code is the code font and
  nothing else (`ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift:L262-L264`).
- **Read beside it, in the same sentence:** the form names the canvas background, the padding and
  no border, and `{components.prose-code}` also gives `{rounded.sm}` (`docs/DESIGN.md:L272-L277`,
  which the row quotes). The row does not say whether the surface carries that radius. This is not
  a second defect. It is the same sentence's subject, so an answer that restates the form can
  settle it at the same time.
- **If a document has to be written:** none. The row states which form draws inline code on the
  canvas surface inside its line, for example the text block for fenced code alone and an
  in-line form for inline code. Its known-defect sentence keeps naming the drawing at the pin.
- **Answer:** <the owner fills this in>
