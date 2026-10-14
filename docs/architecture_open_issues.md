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

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 § 9 said the tools-6.2 adoption was the tree's and not yet CI's; CI has built it since run 38549778886

> A `companion-self-answer` run raised this item on 2026-10-14
> (`docs/trail/architecture/self_answer-50.md`, *Raised on this document* § 2.1) and left its slot
> for the next round. The NFDR v52 run drafted it into the records, as below.

- **Lands in:** `nfdr.md` § 9, the `ka-reader-mac` bullet's *Adopted* passage. No ADR.
- **Drafted into the records:** § 9's *Adopted* passage, at NFDR v52. "The adoption is the tree's,
  not yet CI's" becomes "The adoption is CI's as well as the tree's". `ka-reader@f0f1e5f` is on
  `origin/main`. The first hosted build of the `6.2` manifest is GitHub Actions run 38549778886 on
  `ka-reader@47e8e6b`. The manifest loaded on Swift 6.3.3, and the run went red at
  `Build KA-Reader.app` in a source compile, where `.strictMemorySafety()` met a spelling 6.3.3
  rejects. `ka-reader@24be581` fixed the source, and run 38551538187 is the first green hosted build
  of the manifest. The v49 words stand whole in a dated note. That note says the red came from the
  source, not the manifest, so it did not contradict the clause. The passage points at the
  *Toolchain* clause's two-compiler pair, which the same run folded from cycle-45 § 3.1 (RN-63).
- **Rationale:** A fact in the document was false, and it was measured at the source for this run.
  `git merge-base --is-ancestor f0f1e5f origin/main` holds. `gh run view 38549778886` gives head
  `47e8e6b`, conclusion `failure` at `Build KA-Reader.app`, and its failed log prints
  `NativeBridge.swift:24:9` and `:28:9`. `gh run view 38551538187` gives head `24be581`, conclusion
  `success`. The draft follows the item's lean as raised and adds only the pointer to the pair.
- **If overridden:** § 9 goes back to its v51 words. A cold reader would then be told that no
  hosted run has built a manifest CI has built on every push since 2026-10-14, and the record would
  leave open whether that first red broke the clause. No record moves either way.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

None.
