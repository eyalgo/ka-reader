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
- **Answer:** confirmed with addition. The sentence is wrong and is re-stated, but not in place. ADR-0025 is Accepted, and this log changes an Accepted record only by a new record that supersedes it (`docs/adr/README.md:L4-L5`), the way ADR-0025 itself superseded ADR-0015. So the item's "none" does not hold: one superseding record is owed. It also carries § 3.2's change to the same sentence; the two were decided together. It restates ADR-0025 whole and changes only the link sentence, to: a link node is *external* (inert, its destination readable) or *relative* (a contained file's path, which the shell sends as one `open_relative_link` call; the bridge checks the path again and, for a contained file, admits the selection through the model's `select_file` operation and opens the file, as a tree selection does). It traces to `docs/SDD.md` § 3 SM-4 and SM-5, not to § 9 TO-5. TO-5 still names the old call, and that is raised for the CTO at `docs/SDD_open_issues.md` § 2.1. No NFDR entry moves, because QC-24 already lists `open_relative_link`. Reasoning: `docs/trail/architecture/self_answer-78.md` § 3.1.

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
- **Answer:** confirmed with addition. The change lands in the same superseding record as § 3.1; the two were decided together. The link sentence takes the settled SDD's definition: *relative* is a contained **file's** path, and a link whose target the check reaches at a folder is an *external* node, inert with its destination readable, as a missing or escaping path already is (`docs/SDD.md:L738-L741`, v76). No node kind joins the closed set and no node gains a field. The six block kinds, the inline set, the three walls and the Binds stand as ADR-0025 states them. Two additions. (1) The record says when the kind is read: at render. A file replaced by a folder after the render answers `pending` when activated, because the check at activation still admits only a contained file (`crates/ka-reader-core/src/folder_model.rs:L305-L307`). (2) The record does not call the link form "as built". At `ka-reader@c29193b` the renderer still makes a *relative* node for a folder (`crates/ka-reader-core/src/markdown_renderer/references.rs:L95`), which the SDD names as a known defect until the renderer's change lands. The record follows the settled SDD, so that change is checked against an Accepted record that agrees with it. No NFDR entry moves, because QC-22's fixture link targets a file (`checks/fixtures/hostile.md:L38`). Reasoning: `docs/trail/architecture/self_answer-78.md` § 3.2.

### 3.3 ADR-0014 says the view rests on TextKit's `NSTextLayoutManager`; the Markdown page and the code view lay out with TextKit 1's `NSLayoutManager`
- **Raised by:** CTO — 2026-11-07
- **Which record:** `adr/0014-appkit-shell-in-swift-no-web-engine.md`, § *Consequences*, the paragraph "What this rests on, and whose it stays"
- **Tracked by:** `ka-reader · nemawashi · 2026-10-02_markdown-reads-rendered`
- **What it blocks:** nothing is blocked; the class the record names is not the one the shell uses, and the SDD clause it cites for it is being re-stated to the class used.
- **Where it shows:** `docs/adr/0014-appkit-shell-in-swift-no-web-engine.md:L94-L95`: "AppKit, TextKit (`NSTextLayoutManager`, available from macOS 12.0 — `docs/SDD.md` § 4 C-R5)". At `ka-reader@e95896f` the Markdown page builds an `NSLayoutManager` from construction, because the placeholder box is an `NSTextBlock`, which TextKit 2 does not lay out (`ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift:L15-L16`, `:L29-L36`), and the code view does the same so its gutter can read rows (`CodeView.swift:L14-L15`, `:L37`). The SDD's answer (`docs/trail/sdd/self_answer-84.md` § 5.2) re-states C-R5 to `NSLayoutManager`; the conclusion the parenthetical serves — the one dependency is the platform, and the floor is the maintainer's narrowing — stands, more easily, since TextKit 1 is the older of the two.
- **If a document has to be written:** none — whether a class name that is now false in an Accepted record's *rests on* paragraph takes a dated note or a superseding record is this log's call. The CTO's doubt is that the change is small; it is raised because the record will contradict the SDD clause it cites once the fold lands.
- **Answer:** answered. A superseding record is owed for ADR-0014. A dated note is not one of the log's two options: `product-architecture` changes only an Accepted record's Status line, and only to mark it superseded, so the choice the item leaves open has one answer. The new record restates ADR-0014 whole and corrects its *rests on* paragraph. The Markdown page and the code view lay out with TextKit 1's `NSLayoutManager` from construction (`ka-reader-mac/Sources/Surfaces/MarkdownPageView.swift:L15-L16`, `:L29-L36`; `CodeView.swift:L14-L15`, `:L37`), as SDD v76 § 4 C-R5 now states. `NSTextLayoutManager`, available from macOS 12.0, is not what the view uses. One addition. Being older makes TextKit 1 easier on the floor, not on dependence. Apple files `NSLayoutManager` under TextKit 1, the older of its two text systems, and the page uses it because TextKit 2 does not lay out the `NSTextBlock` the placeholder box is. So the paragraph also says what the decision becomes if Apple narrows TextKit 1: the page's layout moves (the placeholder box to a form TextKit 2 lays out), never the `MarkdownDocument`, the containment check or the view technology. That is R-11's re-cut, walked on the floor macOS before each release. While restating, the fold points the traces at the records in force (ADR-0021, ADR-0025 and ADR-0020, where ADR-0014 names ADR-0013, ADR-0015 and ADR-0016). It also re-reads the sentence "Unmeasured as this record is written", about the `macos-14` runner, against C-R5's `macos-26` rather than carrying it forward. No NFDR entry moves, because none names the TextKit class. Reasoning: `docs/trail/architecture/self_answer-78.md` § 3.3.
