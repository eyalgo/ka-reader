# Architecture open issues — KA-Reader

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the SRS, the SDD
> and the FDR.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-architecture`. It folds your answers into the records and drops the resolved items.
> When nothing is left open, `product-architecture` **deletes this file**: no file = the records are
> done.
>
> Your answers are never thrown away. Each time the Principal Architect folds them in, it first copies
> this file whole to `docs/trail/architecture/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 is raised, not asked.** These records bind every later change, so the seats that live under
> them find gaps the authoring run could not. § 3 is where such a seat says so, against both records
> — an ADR's binding and an NFDR obligation reach the same file.

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-11-07, reading the
> settled records against the product at `ka-reader@e95896f`, where the shell first acts on a relative
> link. One item follows in § 3; neither record is edited.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 ADR-0025 says the shell turns a relative link into the existing `select_file` call; it makes an `open_relative_link` call
- **Raised by:** PM — 2026-11-07
- **Which record:** `adr/0025-markdown-as-a-typed-document-the-closed-node-set-as-built.md`, § *Decision*
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; read literally, the link sentence names the wrong export.
- **Where it shows:** § *Decision* (`docs/adr/0025-markdown-as-a-typed-document-the-closed-node-set-as-built.md:L53-L54`): "*relative* (a contained target path the shell turns into the existing `select_file` call)". At `ka-reader@e95896f` the shell makes one `open_relative_link` call for an activated relative link (`ka-reader-mac/Sources/Shell/LaunchFlow.swift:L206-L207`, `:L230`), and that export ends in the model's `select_file` operation (`docs/SDD.md` § 3 `SM-5`). The binding stands; only the call it names moved.
- **If a document has to be written:** none — the sentence reads "the shell turns into an `open_relative_link` call, which ends in the model's `select_file` operation", or the ADR's own wording of that.
- **Answer:** <the owner fills this in>

> **§ 3.2 and § 3.3 were not written by a `product-architecture` run, and not by the PM's open
> above.** A `companion-self-answer` run in the CTO's seat appended them on 2026-11-07 while answering
> `docs/SDD_open_issues.md` — § 3.2 from its item 5.4, whose answer moves the node set's link sentence,
> and § 3.3 from its item 5.2, whose answer re-states the SDD's § 4 C-R5 to the TextKit class the shell
> uses — because each record is owed the change and this companion is its channel. The reasoning is
> `docs/trail/sdd/self_answer-84.md` §§ 5.4 and 5.2; neither record is edited.

### 3.2 ADR-0025's *relative* link is "a contained target path"; the SDD now makes a contained folder an *external* node, so the set's link sentence moves
- **Raised by:** CTO — 2026-11-07
- **Which record:** `adr/0025-markdown-as-a-typed-document-the-closed-node-set-as-built.md`, § *Decision*
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; once `product-sdd` folds the SDD's answer, the record and the SDD define *relative* differently, and a delivery stage reads the record.
- **Where it shows:** § *Decision* (`docs/adr/0025-markdown-as-a-typed-document-the-closed-node-set-as-built.md:L53-L54`): "A link node is *external* (inert, its destination readable) or *relative* (a contained target path the shell turns into the existing `select_file` call)". The SDD's answer (`docs/SDD_open_issues.md` § 5.4; `docs/trail/sdd/self_answer-84.md` § 5.4): *relative* is a contained **file's** path; a contained entry that is not a file — a folder — is an *external* node, inert, its destination readable, as a missing or escaping path already is (`crates/ka-reader-core/src/markdown_renderer/references.rs:L94-L96`), because `docs/UXD.md` UX-I12 makes a link a control only where activating it does something and a folder opens nothing in the panel. No node kind joins the set and no node gains a field; the sentence that defines the two link forms is what moves — the same sentence § 3.1 asks to re-name the call in.
- **If a document has to be written:** none beyond what § 3.1 already owes this sentence — the two changes land in one re-statement, in whichever form this log takes for § 3.1 under its own rule for an Accepted record (`docs/adr/README.md:L4-L5`).
- **Answer:** <the owner fills this in>

### 3.3 ADR-0014 says the view rests on TextKit's `NSTextLayoutManager`; the Markdown page and the code view lay out with TextKit 1's `NSLayoutManager`
- **Raised by:** CTO — 2026-11-07
- **Which record:** `adr/0014-appkit-shell-in-swift-no-web-engine.md`, § *Consequences*, the paragraph "What this rests on, and whose it stays"
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the class the record names is not the one the shell uses, and the SDD clause it cites for it is being re-stated to the class used.
- **Where it shows:** `docs/adr/0014-appkit-shell-in-swift-no-web-engine.md:L94-L95`: "AppKit, TextKit (`NSTextLayoutManager`, available from macOS 12.0 — `docs/SDD.md` § 4 C-R5)". At `ka-reader@e95896f` the Markdown page builds an `NSLayoutManager` from construction, because the placeholder box is an `NSTextBlock`, which TextKit 2 does not lay out (`ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift:L15-L16`, `:L29-L36`), and the code view does the same so its gutter can read rows (`CodeView.swift:L14-L15`, `:L37`). The SDD's answer (`docs/trail/sdd/self_answer-84.md` § 5.2) re-states C-R5 to `NSLayoutManager`; the conclusion the parenthetical serves — the one dependency is the platform, and the floor is the maintainer's narrowing — stands, more easily, since TextKit 1 is the older of the two.
- **If a document has to be written:** none — whether a class name that is now false in an Accepted record's *rests on* paragraph takes a dated note or a superseding record is this log's call. The CTO's doubt is that the change is small; it is raised because the record will contradict the SDD clause it cites once the fold lands.
- **Answer:** <the owner fills this in>
