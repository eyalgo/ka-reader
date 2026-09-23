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
> C-I3 (RN-56) and § 10 RC-2 (RN-61). **One item remains, § 2.3 below**: the CTO drafted it into
> `SDD.md` at run 12, round 1 (RN-61), and its slot is the owner's.

---

## 1. Open issues — questions with no answer yet

*None open.* The one item this section carried — § 1.1, the renderer that could not start under
C-R2's rule — was answered by the owner on 2026-09-23 and is folded; the answer and the three
seats' positions are on the trail (`docs/trail/sdd/cycle-9.md` § 1.1), and the fold is `SDD.md`
§ 2, § 3, § 4 C-R1, C-R7, C-D3, § 10 RC-3 and RN-60.

## 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override

> **No `product-sdd` run wrote this item. A `companion-self-answer` run raised it on
> 2026-09-23** while it answered `docs/architecture_open_issues.md` §§ 2.1 and 2.2. That run read
> `SDD.md` § 4 C-R2 and C-I3 at v12 and found C-I3 still naming the list C-R2 retired. It also found
> the two conditions' record lines now point at records that the architecture companion carries
> forward. No item asked about either. **The CTO drafted both changes into `SDD.md` at run 12,
> round 1** (`SDD.md` RN-61), inside the fold of the owner's § 1.1 answer; the slot below is the
> owner's. (§ 2.1 and § 2.2, which this file carried beside it, were confirmed by the owner and are
> folded — `docs/trail/sdd/cycle-9.md` §§ 2.1, 2.2; `SDD.md` RN-56, RN-61.)

### 2.3 C-I3 still checks the bundle "against C-R2's exact list", and C-R2 and C-I3 name records that ADR-0011 and ADR-0012 now carry
- **Raised by:** the `companion-self-answer` run, 2026-09-23 — not one of the SDD's three seats
- **Drafted into the SDD:** Both changes, in § 4, at run 12, round 1 (RN-61).
  1. **C-I3's wording.** "`checks/bundle.sh` reads `codesign -d --entitlements :- Nozoki.app`
     against C-R2's exact list" now reads "against the set C-R2's rule admits, as the script's
     expected set records it — set equality, the expected set widened only by a change reviewed
     against the rule" (`SDD.md` § 4 C-I3, its third sentence). That is the form `docs/nfdr.md`
     QC-25 took at v10.
  2. **The record lines.** C-R2's record line reads "The record is ADR-0011 — Proposed, superseding
     ADR-0003 on acceptance (`docs/adr/README.md`, its row) — which restates the wall under this
     rule; until it is Accepted, ADR-0003 is the record in force and this condition departs from it
     on the one word *exactly* (RN-52)". C-I3's reads "The record is ADR-0010; the renderer gate's
     own record is ADR-0012 — Proposed — whose mechanism, control and observable's name are
     re-derived from this clause as it now reads". Each names the status the index shows on
     2026-09-23; when the `product-architecture` fold that takes
     `docs/architecture_open_issues.md` § 2.1's confirm lands, the two words *Proposed* are the
     CTO's to move to *Accepted* on the next fold here. One thing the draft adds that the item did
     not ask: under the owner's § 1.1 answer the renderer left WKWebView (`SDD.md` § 10 RC-3), so
     C-I3's line says ADR-0012's mechanism and control are re-derived from C-I3 — the record's own
     § Consequences already says so of itself.
- **Rationale:** C-R2 at v12 says the entitlement set is "bound by a **rule**, not held as a list"
  and that the rule "replaced 'exactly these entitlements'" (`docs/SDD.md:L434-L448`). Further down
  § 4, C-I3 still checks the bundle against "C-R2's exact list" (`:L554`). So the document
  contradicts itself. A delivery reader who takes C-I3 at its word fails a bundle carrying
  `com.apple.security.files.bookmarks.app-scope`, which C-R2 names as a member from the
  folder-selector slice. The record lines follow from the same ruling. ADR-0011 restates ADR-0003
  whole with the rule in place of the list and supersedes it on acceptance
  (`docs/adr/0011-app-sandbox-wall-under-a-rule-no-network-entitlement-ever.md`). ADR-0012 is the
  renderer gate's own record, which C-I3 claims none for (RN-56;
  `docs/adr/0012-renderer-run-proved-on-the-shipped-bundle-beside-the-wall.md`). NFDR RN-21
  reports the C-I3 record line as the CTO's at this fold but raised it nowhere, and this item is
  where it is raised. It costs no extra cycle, because it rides the fold § 1.1's answer already
  owes.
- **If overridden:** C-I3 keeps checking against a list C-R2 no longer holds, and the two
  conditions keep citing ADR-0003 after it is superseded and no record for the renderer gate.
  Nothing the SDD decides moves either way: the rule, the gate and the probe stand as written.
- **Confirm or override:** confirm, with one addition. Both drafts hold. C-I3 now checks the bundle against the set C-R2's rule admits, in the form `docs/nfdr.md` QC-25 took at v10, and the record lines name ADR-0011 and ADR-0012, which is what `docs/adr/README.md` shows on 2026-09-23. **Addition:** the two record lines should not carry the status word *Proposed*. For the status, they should point at the index row they already cite. The draft moves the word "on the next fold here", but this item is the file's last. After this fold the companion is removed, so the SDD may never have a next fold. `docs/architecture_open_issues.md` § 2.1 is already confirmed, so the fold that turns both records to Accepted is the next `product-architecture` run, and the SDD would then misstate their status with nothing left to correct it. C-R2's conditional, "until it is Accepted, ADR-0003 is the record in force", stays true in both states and stays as written. ADR-0012 may also move under the RC-3 re-derivation, now raised at `docs/architecture_open_issues.md` § 2.3 (`nozoki@c2cb01c`), and the index row follows it wherever it goes. Decided in the owner's seat by a `companion-self-answer` run, 2026-09-23. The reasoning is in `docs/trail/sdd/self_answer-21.md` § 2.3.

> **No `product-sdd` run wrote this item. A `companion-self-answer` run raised it on
> 2026-09-23** while it answered `docs/architecture_open_issues.md` § 1.1. That item was raised by
> the `product-architecture` run that wrote NFDR v11 (RN-22), and it names a gap only this
> document can close: § 3 at v13 does not say which unit calls `markdown-renderer` and
> `highlighter` to fill a `FileView`. The architecture item routes the sentence here, so this is
> where it is raised. **Nothing is drafted into the SDD.** This run writes no document. The slot
> below is the owner's, and the change is the CTO's to draft on the fold.

### 2.4 § 3 does not say which unit calls `markdown-renderer` and `highlighter` to fill a `FileView`, and `folder-model`'s "Must not own" still says "Rendering" and "The Tauri runtime"
- **Raised by:** the `companion-self-answer` run, 2026-09-23 — not one of the SDD's three seats
- **Drafted into the SDD:** Nothing yet. The run proposes one reading, reading (a), with three
  edits in § 3.
  1. **`folder-model`'s *Owns*** gains a clause after the reducer: the model calls `highlighter`
     for a text file in a floor language and `markdown-renderer` for a Markdown file, on the bytes
     `fs-reader` returned, to fill the open `FileView`'s content. A call that fails is held as that
     item's `failed(condition)` and never a panic (C-I1; DR-6).
  2. **`folder-model`'s *Must not own*** changes from "I/O of any kind. The Tauri runtime. Own
     state. Rendering" to "I/O of any kind. Any Apple framework. Own state. Drawing". "Rendering"
     becomes "Drawing" because drawing is what the model must never do: that is `surfaces`'. "The
     Tauri runtime" goes because RC-3 retired that runtime. "Any Apple framework" takes its place
     because that is the boundary `nozoki-core` now holds (§ 3, the units paragraph).
  3. **The units paragraph's edges** gain one sentence: `folder-model` calls `markdown-renderer`
     and `highlighter`, and neither of them imports the model. That keeps "import neither the model
     nor one another" true as written.
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
- **Confirm or override:** <"confirm", or "override: <what to do instead>">
