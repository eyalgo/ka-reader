# Architecture open issues — Nozoki

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

> **Where this file stands.** Its previous round is on the trail whole at
> `docs/trail/architecture/cycle-8.md`: § 2.1 and § 2.2 were answered in the owner's seat and are
> folded at NFDR v11 (`docs/nfdr.md` RN-22) — ADR-0011 is Accepted and supersedes ADR-0003, and
> QC-62 carries the owner's addition. § 2.3 was raised proposed and not drafted; **the
> `product-architecture` run of 2026-09-23 (NFDR v11) drafted it into the records** — four
> superseding records at Proposed, ADR-0012 revised at Proposed, and the constraint set re-derived
> — and its slot is yours. § 1.1 is new, raised by the same run.

---

## 1. Open issues — questions with no answer yet

### 1.1 `docs/SDD.md` § 3 leaves unstated which unit invokes `markdown-renderer` and `highlighter` to fill a `FileView`, and QC-10 forbids `folder-model` from importing the renderer
- **Lands in:** `nfdr.md` QC-10 (and QC-11's edges); no record — the unit set is ADR-0016's and
  does not move on the answer. The sentence that settles it is the SDD's, at § 3, through that
  document's own run.
- **Why it matters:** at v13 `folder-model` owns the open `FileView`, whose content carries
  `highlighter`'s spans for a text file and a `MarkdownDocument` for a Markdown one (§ 3
  `folder-model` row; the `FileView` entity), and `core-bridge` "must not own read logic — every
  function delegates and formats" (§ 3 `core-bridge` row). So something between the reducer and
  the bridge calls `markdown-renderer` and `highlighter`, and § 3 names it nowhere: `folder-model`'s
  "Must not own" still says "Rendering" (and "The Tauri runtime", a stale word), and QC-10 — derived
  from the previous SDD, where `ipc-surface` did the calling — forbids `folder-model` from importing
  `markdown-renderer`. Two readings are open and two architects would take different ones: (a)
  `folder-model` invokes both, so "Rendering" in its Must-not-own means drawing and QC-10's
  exclusion of `markdown-renderer` is retired (its exclusion of `own-state` and the libgit2
  binding stands); or (b) `core-bridge` invokes both on `select_file`, which makes "delegates and
  formats" wider than it reads and puts a parse of untrusted content in the one unit that holds
  `unsafe`. This run took neither: QC-10 stands as written with the gap named in the entry, and
  QC-11's two stated edges (`markdown-renderer` → `fs-reader`'s check, `markdown-renderer` →
  `highlighter`) are the SDD's own words. Whichever the SDD's seat states, QC-10 and § 1.3's
  ownership follow by transcription.
- **Answer:** <the owner fills this in>

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.3 The SDD at v13 carries the replacement renderer (§ 10 RC-3): four records supersede ADR-0001, ADR-0002, ADR-0006 and ADR-0009, ADR-0012 is re-derived, and every entry written against the previous shape is re-derived — all drafted, none accepted
- **Lands in:** both. `adr/` — ADR-0013, ADR-0014, ADR-0015, ADR-0016 at Proposed, each restating
  whole the record it supersedes and superseding it **on acceptance**; ADR-0012 at Proposed,
  revised against C-I3 at v13. `nfdr.md` — § 1's module set and QC-1, QC-8, QC-9, QC-11, QC-13 –
  QC-17, QC-19, QC-20, QC-21, § 2's trust boundaries, QC-22, QC-23, QC-24, QC-26, QC-27, QC-30,
  QC-34, QC-36, QC-37, QC-40, QC-41, QC-47, QC-51, QC-53, QC-55, QC-58, QC-59, QC-61, QC-62, § 8,
  § 9 and § 10 (`docs/nfdr.md` RN-22 lists each with what moved in it).
- **Drafted into the records:**
  1. **ADR-0013, Proposed — supersedes ADR-0001 on acceptance.** The sandboxed single-process read
     pipeline: one process under the App Sandbox, the Rust core reached across `SM-4`'s C-ABI
     function list, the promise held by the process's entitlements (ADR-0011) and *read* at the
     seam — the shell's "no I/O of its own" a source scan and a link check (C-R7), not a process
     boundary. Alternatives from § 2's table: the capability-split shape (rejected on RC-2 and on
     the fact that a view which executes nothing has nothing to wall off), hexagonal, layered, the
     local server.
  2. **ADR-0014, Proposed — supersedes ADR-0002 on acceptance.** AppKit in Swift, in the one
     process, no web engine of any kind; TextKit lays out Markdown from a `MarkdownDocument`;
     `Package.swift` declares nothing. Alternatives from § 2: keeping WKWebView by granting what it
     needs (refused, ADR-0011), a Rust-native toolkit, an in-process web engine, AppKit through
     `objc2`, SwiftUI, Electron. Its undo — every surface — is recorded as paid once already, and
     PD-29 at v8 as what forbids a second swap.
  3. **ADR-0015, Proposed — supersedes ADR-0006 on acceptance.** `markdown-renderer` emits a closed
     `MarkdownDocument` and no HTML; the three walls are the containment check, the document as
     data, and `NSImage` fed by `asset_bytes` for a contained path in four formats; SVG excluded
     in v1 with RN-8's reopening condition; the owner's image override carried forward.
  4. **ADR-0016, Proposed — supersedes ADR-0009 on acceptance.** `nozoki-core` (no `unsafe`, no
     Apple framework), `nozoki-bridge` (the C ABI, the one `unsafe` unit, the Rust-side root),
     `nozoki-mac` (Swift, no dependency, the only AppKit importer, the app's root), `checks/`;
     the reconstructed marking kept for the two readings the SDD does not weigh.
  5. **ADR-0012, revised at Proposed.** The control is `checks/fixtures/idle-shell`, the observable
     `open_folder`'s call with the panel presented, the frames re-measured on the first native
     bundle; the owner's § 2.1 addition (red by construction until the native shell lands) is in
     its § Decision. Your § 2.1 confirm accepted it as drafted; your later addition on the SDD's
     companion said it "may also move under the RC-3 re-derivation" — it has — so its acceptance
     rides this item rather than landing on a mechanism sentence this item is still open on.
  6. **The constraint set, re-derived** from §§ 2–4 at v13 under the SDD's rule that the § 4
     statement wins, each entry tracing to the Proposed record *and* the accepted one it
     supersedes; § 9's table on `swift test --package-path nozoki-mac`, `checks/view.sh` and
     `--test exports`, Vitest and the TypeScript packet leaving with `nozoki-ui`; § 10 following.
     Five symbol-level realizations this run added beyond the SDD's words are marked in their
     entries and listed in RN-22 (view.sh's three environment/argument names; the
     surfaces-never-call-`SM-4` rule; the dialog symbols; bundle.sh's no-second-executable and
     no-font reads; view.sh's `Sources/`-only scope).
- **Rationale:** RC-3's *Changed* says in terms that the entry "moves § 2's shape and § 3's seams,
  so it owes the decision log superseding records" for the four, "and the enforcement store a
  re-derivation of every entry written against the previous shape" — "both are the Principal
  Architect's" (`docs/SDD.md` § 10 RC-3; § 12, the downstream boundary; RN-60). Your § 2.2 answer
  named the SDD carrying the replacement as the moment a superseding record lands, and the FDR has
  since confirmed PD-29's move (`docs/trail/fdr/cycle-5.md` § 2.1). A record that reverses an
  accepted one lands at Proposed and supersedes on the owner's confirm — the shape ADR-0011 took
  over ADR-0003 — so the four accepted records, their index rows and the entries that cite them
  keep citing the records in force until you confirm; the entries carry both traces so nothing is
  cited that is not in force. **Inputs:** `docs/SDD.md` is Draft at v13 while its companion's
  answered § 2.3 (C-I3's wording, two record lines) awaits `product-sdd`; nothing here turns on
  that item, and the house rule for a Draft input is derive and record
  (`<CORE>/doctrine/governance/unsettled_inputs.md`). The tree still holds the previous shape, so
  every re-derived entry is red against it until the native shell lands — RN-22 says so once, as
  RN-18 did for QC-25 against `checks/bundle.sh` at v7.
- **If overridden:** *Fewer records* — merging the four into one or two is a rewrite at Proposed
  and costs nothing accepted; the reason for four is four reversal costs (RN-22). *Hold the entries
  at the previous shape until acceptance* — the constraint set would then contradict `docs/SDD.md`
  § 4 as it reads, against that document's rule and this one's practice since v5; a delivery reader
  would be checked against a CSP, a capability file and a `nozoki-ui` the SDD no longer designs.
  *Accept ADR-0012 now, apart from the four* — a one-line Status move and an index row; nothing
  else moves. *Reject a record's alternative or consequence* — say which; it is revised at Proposed.
  The four superseded records do not move under any override until a superseding record is
  accepted.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">
