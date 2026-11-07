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
