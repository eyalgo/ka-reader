# Architecture open issues — nozoki

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
> these records and not to the SDD. The architecture round closed clean at `nozoki@7cdc857` and its
> companion was removed; the finding below arrived afterwards, from the SDD re-author at
> `nozoki@9c91359`, and a settled record set with nothing beside it has no other channel to the seat
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
- **Tracked by:** none. No 根回し Nemawashi seed watches this; nozoki has no active seed and no open
  station (`system/projects/nozoki/journey/`, 2026-09-03). It was found while reading the log as an
  input, not while cutting work from it.
- **What it blocks:** nothing, and that is the reason it is worth a round rather than a reason to
  leave it. No cut stalls and no gate fails on a citation. What it costs is silent: a reader who
  follows one of these pointers lands somewhere plausible that says something else, and has no
  signal that they were misdirected.
- **Where it shows:** three sets, measured on 2026-09-03 against `nozoki@c3eb937`.
  - **14 citations of `docs/trail/sdd/cycle-1.md`** — ADR-0002 (2), ADR-0003 (3), ADR-0006 (3),
    ADR-0007 (3), ADR-0008 (3) — dead since `nozoki@9c91359` deleted `docs/trail/sdd/` whole for the
    SDD's re-author. The file itself is intact at `nozoki@70a879a:docs/trail/sdd/cycle-1.md`, and is
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
  `nozoki@70a879a:` and to the deleted SDD's commit, keeping the record a faithful account of what
  its author read — the form `docs/UXD.md` RN-8, RN-15, RN-16 and RN-17 already use for
  `nozoki@1d5c553` — or re-point each at the equivalent passage in the re-authored SDD, which reads
  cleanly and quietly changes what the record says it rested on. The log is append-only, so whether
  a citation repair is an edit to a record's own prose or something that needs a superseding record
  is this seat's to say, and this run does not presume it.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
