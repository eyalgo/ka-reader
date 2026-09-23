# SDD open issues — Nozoki

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

> **The cycle-9 items this file carried are folded and on the trail** (`docs/trail/sdd/cycle-9.md`):
> § 1.1, the owner's answer that the renderer leaves WKWebView — folded as `SDD.md` § 2, § 3, § 4
> C-R1, C-R7, C-D3, § 10 RC-3 and RN-60; § 2.1 and § 2.2, both confirmed — folded at `SDD.md` § 4
> C-I3 (RN-56) and § 10 RC-2 (RN-61). **The cycle-10 item is folded too**
> (`docs/trail/sdd/cycle-10.md` § 2.3): the C-I3 wording and the two record lines, confirmed with
> the owner's addition that the lines carry no status word — folded at `SDD.md` § 4 C-R2, C-I3,
> § 12 the downstream boundary and RN-64. **One item remains, § 2.4 below**: the CTO drafted it
> into `SDD.md` at run 13, round 1 (RN-64), and its slot is the owner's.

---

## 1. Open issues — questions with no answer yet

*None open.* The one item this section carried — § 1.1, the renderer that could not start under
C-R2's rule — was answered by the owner on 2026-09-23 and is folded; the answer and the three
seats' positions are on the trail (`docs/trail/sdd/cycle-9.md` § 1.1), and the fold is `SDD.md`
§ 2, § 3, § 4 C-R1, C-R7, C-D3, § 10 RC-3 and RN-60.

## 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override

> **No `product-sdd` run raised this item. A `companion-self-answer` run raised it on
> 2026-09-23** while it answered `docs/architecture_open_issues.md` § 1.1. That item was raised by
> the `product-architecture` run that wrote NFDR v11 (RN-22), and it names a gap only this
> document can close: § 3 at v13 does not say which unit calls `markdown-renderer` and
> `highlighter` to fill a `FileView`. The architecture item routes the sentence here, so this is
> where it is raised. **The CTO drafted the reading it proposes into `SDD.md` at run 13,
> round 1** (`SDD.md` RN-64); the slot below is the owner's. (§ 2.3, which this file carried
> beside it, was confirmed by the owner with one addition and is folded —
> `docs/trail/sdd/cycle-10.md` § 2.3; `SDD.md` § 4 C-R2, C-I3, RN-64.)

### 2.4 § 3 does not say which unit calls `markdown-renderer` and `highlighter` to fill a `FileView`, and `folder-model`'s "Must not own" still says "Rendering" and "The Tauri runtime"
- **Raised by:** the `companion-self-answer` run, 2026-09-23 — not one of the SDD's three seats
- **Drafted into the SDD:** Reading (a), as the raising run proposed it — three edits in § 3, at
  run 13, round 1 (RN-64), with the reason each was made the CTO's own and recorded there.
  1. **`folder-model`'s *Owns*** gains a clause after the reducer — "**the fill of the open
     `FileView`** — the model calls `highlighter` for a text file in a floor language and
     `markdown-renderer` for a Markdown file, on the bytes `fs-reader` returned, and holds a call
     that fails as that item's `failed(condition)`, never a panic" (§ 4 C-I1; `docs/SRS.md` FR-8,
     FR-30, DR-6).
  2. **`folder-model`'s *Must not own*** reads "I/O of any kind. Any Apple framework. Own state.
     Drawing" where it read "I/O of any kind. The Tauri runtime. Own state. Rendering". "Rendering"
     becomes "Drawing" because drawing is what the model must never do: that is `surfaces`'. "The
     Tauri runtime" goes because RC-3 retired that runtime. "Any Apple framework" takes its place
     because that is the boundary `nozoki-core` now holds (§ 3, the units paragraph).
  3. **The units paragraph's edges** gain one sentence: the model calls down to
     `markdown-renderer` and `highlighter` to fill a `FileView`, and neither of them imports the
     model. That keeps "import neither the model nor one another" true as written.
  What the draft does not touch, named so the confirm is read at its size: no seam (SM-5's
  contract is the model's API, and the call sits behind it), no slice, no § 7 edge and no
  *Reached when*; `docs/nfdr.md` QC-10's import set follows by transcription once this slot is
  filled, in that document's own run (`SDD.md` § 12, the downstream boundary).
- **Rationale:** At v13, `folder-model` owns the open `FileView` (§ 3 `folder-model` row). The
  `FileView` entity holds either `highlighter`'s spans or a `MarkdownDocument` (§ 3, *What the
  system holds*). But no row says who produces them. Two readings are possible, and the row for
  `core-bridge` settles which one holds. `core-bridge` must not own "Read logic — every function
  delegates and formats", and must not own "Anything the harness could not exercise through SM-5"
  (§ 3 `core-bridge` row). SM-5 is `folder-model`'s API (§ 3 SM-5), and the harness drives it
  in-process with no window (§ 4 C-I3). So if the bridge rendered, rendering would be outside what
  the harness can reach. That would also put a parse of untrusted content in the one unit that
  holds `unsafe` (§ 11 R-13). Under reading (a), the value is built in the unit that holds it,
  and the harness reaches it through SM-5. `markdown-renderer` and `highlighter` do no I/O of
  their own (their *Must not own*: "Reading the file itself"; "Reading a file"), so the model's
  "I/O of any kind" still holds. Two things would have tipped this the other way: a row giving the
  bridge a call that is not a thin wrapper, or the harness reaching past SM-5. Neither exists.
  `docs/nfdr.md` QC-10 currently forbids `folder-model` from importing `markdown-renderer`. That
  exclusion was written against v12, and QC-10 follows this answer by transcription (NFDR RN-22;
  `docs/architecture_open_issues.md` § 1.1). The full reasoning is in
  `docs/trail/architecture/self_answer-12.md` § 1.1.
- **If overridden:** With reading (b), `core-bridge` calls both on `select_file`. Its *Owns*
  would then need to state that call, and "every function delegates and formats" would need to say
  it covers that call. The harness would then need a path to rendering outside SM-5, or the
  rendered document would go untested at layer 3. QC-10's exclusion stands and QC-13 widens. If
  nothing is chosen, two architects reading § 3 will keep placing the call in different units.
- **Confirm or override:** confirm, with one addition. Keep reading (a) as drafted: the three edits to § 3, and QC-10 following by transcription in the NFDR's own run. `core-bridge`'s row still rules out reading (b). **Addition:** one of the draft's reasons does not hold as worded, and it should be fixed on the fold, in RN-64's *because*. RN-64 says the model's "I/O of any kind" still holds because "neither callee reads anything". But `markdown-renderer` calls `fs-reader`'s containment check for every image reference (§ 3, the units paragraph; SM-7). That check resolves symlinks on disk (§ 3 `fs-reader` row). So filling a Markdown `FileView` does touch the filesystem. The bar holds for a different reason: the model already reaches the filesystem only through `fs-reader`, over SM-1 ("Down: a path to list or read"). The renderer's containment call goes through that same unit, over SM-7. Read this way, "I/O of any kind" means I/O the model performs itself, and every filesystem touch belongs to `fs-reader`. No § 3 text changes; only the stated reason does. Decided in the owner's seat by a `companion-self-answer` run, 2026-09-23. The reasoning is in `docs/trail/sdd/self_answer-22.md` § 2.4.
