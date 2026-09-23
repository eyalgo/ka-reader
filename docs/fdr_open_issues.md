# FDR open issues — Nozoki 覗き

> Companion to `fdr.md`. The Principal PM authored the FDR non-interactively; this file holds what the
> run could not settle from its inputs — the PRD, the SRS and the SDD.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-fdr`. It folds your answers into the FDR and drops the resolved items. When nothing is
> left open, `product-fdr` **deletes this file**: no file = the FDR is done.
>
> Your answers are never thrown away. Each time the Principal PM folds them in, it first copies this
> file whole to `docs/trail/fdr/` — so what you decided, and why, stays readable and citable for good.
>
> **§ 3 is the odd one, and worth reading twice.** The Principal PM writes the FDR *and* is the seat
> most likely to raise an item against it later, cutting the same product's documents into seeds. The
> two are different acts at different times, and § 3 keeps the later one visible instead of letting
> it be quietly folded back into § 1 as though the authoring run had asked it.

> **How this companion came to exist.** No `product-fdr` run opened it. A `companion-self-answer`
> run opened it on 2026-09-23 while it answered `docs/architecture_open_issues.md` § 2.2. `fdr.md` is
> Settled at v6 with no companion on disk, so without this file a `product-fdr` re-run would read it
> as done. But the owner's answer on `docs/SDD_open_issues.md` § 1.1 has since reversed one sentence
> of PD-29, and `docs/nfdr.md` QC-21 waits on PD-29 to move (NFDR RN-21). The one item below is
> proposed and not drafted. Its slot is left for the next round.

---

## 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override

### 2.1 PD-29 says the renderer technology is not replaceable inside the terminus; the owner has ruled that it leaves WKWebView
- **Drafted into the FDR:** Nothing yet. The proposed change is to PD-29's last sentence, "The
  renderer technology and the platform are not replaceable inside the terminus"
  (`docs/fdr.md:L293`). It keeps its words for the platform. For the renderer it says the technology
  is being replaced once, on the owner's ruling (`docs/SDD_open_issues.md` § 1.1, *Answer*, at
  `nozoki@a1d8f2c`: "(a) — the renderer leaves WKWebView"). What replaces it is the SDD's § 2 to
  weigh. Apart from that one replacement it stays not replaceable inside the terminus. PD-29's
  replacement is named when the SDD carries it, and that is a later round, not this one.
- **Rationale:** PD-29 derives from the SDD's § 2 "Undoing it" and § 9 TO-4, which priced the
  renderer as not replaceable. The owner's answer is an authorized decision that outranks both, and
  it names PD-29 as something it reverses: option (a) in that companion lists "`docs/fdr.md` PD-29's
  'not replaceable inside the terminus' reversed" among its costs. After that answer, PD-29 states
  something false about the product's plan. Two readers act on it. The PM validates a change request
  against the FDR, and would reject the renderer replacement as contradicting PD-29. The Principal
  Architect's QC-21 traces to PD-29 and is re-derived only when PD-29 moves (`docs/nfdr.md` RN-21,
  "What is not done, and why"). The FDR had no companion, so nothing would carry the change to it.
  The sentence proposed here holds whatever the SDD later picks, so it can fold before the SDD
  settles its replacement. Naming the replacement is what has to wait.
- **If overridden:** PD-29 keeps saying the renderer cannot be replaced while the product is
  replacing it. A change request for the replacement then contradicts the FDR it is validated
  against. QC-21 stays as written, because it waits on PD-29. Nothing else in the FDR moves.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">
