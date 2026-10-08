# Architecture open issues — ka-reader

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

> **No `product-architecture` run wrote this file.** It was opened on 2026-09-03 by a
> `companion-self-answer` run answering `docs/SDD_open_issues.md`, to carry one item that belongs to
> these records and not to the SDD. The architecture round closed clean at `ka-reader@7cdc857` and its
> companion was removed; the finding below arrived afterwards, from the SDD re-author at
> `ka-reader@9c91359`, and a settled record set with nothing beside it has no other channel to the seat
> that can act on it. §§ 1 and 2 are empty because no authoring run drafted anything — that is what
> this file's presence means here, and not that a run left questions behind.

---

## 1. Open issues — questions with no answer yet

<None — see the note above.>

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

<None — see the note above.>

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 The SDD re-author broke 38 citations in the records — a deleted trail file, a re-numbered review-note set, and one moved slice
- **Raised by:** `companion-self-answer`, answering `docs/SDD_open_issues.md` — 2026-09-03
- **Which record:** `adr/0001` – `adr/0008` (all but `adr/0009`), and `nfdr.md` § 8's QC row at
  `docs/nfdr.md:385`
- **Tracked by:** none. No 根回し Nemawashi seed watches this; ka-reader has no active seed and no open
  station (`system/projects/ka-reader/journey/`, 2026-09-03). It was found while reading the log as an
  input, not while cutting work from it.
- **What it blocks:** nothing, and that is the reason it is worth a round rather than a reason to
  leave it. No cut stalls and no gate fails on a citation. What it costs is silent: a reader who
  follows one of these pointers lands somewhere plausible that says something else, and has no
  signal that they were misdirected.
- **Where it shows:** three sets, measured on 2026-09-03 against `ka-reader@c3eb937`.
  - **14 citations of `docs/trail/sdd/cycle-1.md`** — ADR-0002 (2), ADR-0003 (3), ADR-0006 (3),
    ADR-0007 (3), ADR-0008 (3) — dead since `ka-reader@9c91359` deleted `docs/trail/sdd/` whole for the
    SDD's re-author. The file itself is intact at `ka-reader@70a879a:docs/trail/sdd/cycle-1.md`, and is
    byte-identical there to the `1e8bf3d` copy that moved it (`git diff --quiet 1e8bf3d 70a879a --
    docs/trail/sdd/cycle-1.md`). These carry the owner's own answers, ADR-0007's standing
    no-signing call among them, so what is dead is the provenance of the log's most load-bearing
    records.
  - **23 citations of `docs/SDD.md` § SDD Review Notes** — ADR-0001 (1), ADR-0002 (2), ADR-0003 (1),
    ADR-0004 (3), ADR-0005 (2), ADR-0006 (4), ADR-0007 (5), ADR-0008 (5) — every one written against
    the deleted SDD's numbering. The re-authored document carries RN-1 – RN-19 and RN-30 – RN-33, so
    **RN-24 and RN-25 have no note at all**, and the eight numbers that do resolve now carry notes on
    other subjects. Three checked one by one: ADR-0002's RN-7 (cited for "the dependency tree is
    allowlisted") now reads the floor's extension set; ADR-0004's RN-8 (cited for the libgit2
    grounds) now reads the SVG exclusion from the asset scheme; ADR-0007's RN-17 (cited three times,
    for the channel, the `.zip` and the `xattr` line) now reads `first-public-release`'s placement in
    the order. **This is the worse of the two sets:** a dead path announces itself, and a pointer that
    resolves to the wrong note does not.
  - **1 citation in `nfdr.md:385`** — `SDD § 6 S-4`, beside FR-16, NFR-3, NFR-4 and AC-8, which are
    the live-refresh requirements. The re-authored S-4 is `see-git-status`; live refresh is S-5
    `follow-the-folder`. The NFDR's other SDD citation, `SDD § 6 S-1` at `docs/nfdr.md:685`, still
    resolves correctly and needs nothing.
- **If a document has to be written:** none. Every repair is inside a record that already exists.
  Two shapes are available and the choice between them is what this item asks: pin each citation to
  `ka-reader@70a879a:` and to the deleted SDD's commit, keeping the record a faithful account of what
  its author read — the form `docs/UXD.md` RN-8, RN-15, RN-16 and RN-17 already use for
  `ka-reader@1d5c553` — or re-point each at the equivalent passage in the re-authored SDD, which reads
  cleanly and quietly changes what the record says it rested on. The log is append-only, so whether
  a citation repair is an edit to a record's own prose or something that needs a superseding record
  is this seat's to say, and this run does not presume it.
- **Answer:** Repair all 38, and **split the form by which record holds the citation** — the two
  shapes the item names are both right, each for one record. The owner's answer, 2026-09-04, taking
  the walk's recommendation whole.

  **(1) The 37 in `adr/0001` – `adr/0008`: pin, to `ka-reader@70a879a:`.** Both sets — the 14 of
  `docs/trail/sdd/cycle-1.md` and the 23 of `docs/SDD.md` § SDD Review Notes — take the same commit,
  because one commit holds both: `ka-reader@70a879a` is the last commit that touched `docs/SDD.md`
  before `ka-reader@9c91359` deleted it, and its `docs/SDD.md` carries RN-1 – RN-34, RN-24 and RN-25
  included (measured 2026-09-04: `git log 70a879a..9c91359 -- docs/SDD.md` returns only the
  deletion). So a cycle-1 citation reads `ka-reader@70a879a:docs/trail/sdd/cycle-1.md` and a review-note
  citation reads `ka-reader@70a879a:docs/SDD.md` RN-n, with no note re-numbered and no passage
  re-identified. Three grounds, strongest first. **(a) Re-pointing is not available for all of them:**
  RN-24 and RN-25 have no successor note in the re-authored SDD, so at least two of the 23 have
  nothing to point at, and a repair that works for 21 of 23 is not a repair. **(b) The log is
  append-only so that a record stays a faithful account of what its author decided and on what
  (`docs/adr/README.md:2-4`);** re-pointing would quietly change what the record says it rested on,
  which is the class of thing that rule exists to prevent. **(c) The pinned form is this repository's
  own precedent:** `docs/UXD.md` RN-8, RN-15, RN-16 and RN-17 pin `ka-reader@1d5c553:docs/uxd_trail/…`
  (`docs/UXD.md:578,677,692,703`), and UXD v7 repaired that document's unpinned citations while
  leaving the pinned ones standing as written.

  **(2) The 1 in `docs/nfdr.md:385`: re-point, `SDD § 6 S-4` → `SDD § 6 S-5`.** Not pinned, and the
  difference is the document's own rule: the NFDR "is updated in place with versioning (unlike the
  ADRs, which supersede)" (`docs/nfdr.md` § preamble), so its trace tags name where a fact lives now
  rather than what a past author read. QC-48's trace is to live refresh, which the re-authored SDD
  carries at S-5 `follow-the-folder`. `docs/nfdr.md:685`'s `SDD § 6 S-1` resolves correctly and is
  not touched.

  **(3) Both are edits to the records' own prose. No superseding ADR is written, and none is needed.**
  `docs/adr/README.md:2-4` scopes append-only to reversals — "a reversal is a new record that
  supersedes an old one, never an edit to it" — and a citation repair reverses no decision, changes no
  context, alternative, consequence or trace, and leaves every record's Status at Accepted. Eight
  superseding records about no decision at all would cost the log more than the broken pointers do.
  `adr/0009` is untouched, and so is the index's projection.

  **The cost of (1), stated rather than left for a reader to find:** a pinned ADR then cites an SDD
  that no working tree holds, and says nothing about whether today's SDD still agrees. That is the
  price of the record being faithful, and it is the price `docs/UXD.md` already chose to pay. The
  third shape — pin *and* name the current equivalent beside it — was considered and rejected: 23
  lookups, and it puts a live pointer next to a frozen one in the same citation.

  **Scope, so the fold does not widen:** these 38 and nothing else. No obligation is added, removed or
  renumbered; no QC id moves; no ADR changes its decision, its Status or its date; the NFDR takes a
  version bump for (2) as it does for any in-place edit.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
