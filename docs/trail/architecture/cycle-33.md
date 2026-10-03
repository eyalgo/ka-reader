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

> **What this file holds now.** The PM opened it on 2026-10-04 with § 3.1. A `companion-self-answer`
> run appended § 2.1 the same day. The `product-architecture` run that wrote NFDR v36 closed § 2.1
> unanswered: SDD v29 now states the change it drafted, so QC-47 was re-derived from the SDD and no
> choice was left (`nfdr.md` RN-47). § 3.1 is carried below exactly as the PM raised it.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-15's list of `git-reader`'s reads outside libgit2 omits two kinds the adapter makes
- **Raised by:** PM — 2026-10-04
- **Which record:** `nfdr.md` § 1.3, QC-15
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. The scan passes (`checks/structure.sh` exit 0 at `nozoki@6a0725c`),
  because it holds `git-reader`'s file as an owner and does not check which reads that owner makes. What
  is missing is the statement: a later change to the read bound reads QC-15 to learn what the adapter
  may read outside libgit2, and the list it finds is shorter than what the adapter reads.
- **Where it shows:** QC-15 (`docs/nfdr.md:L413-L418`) gives `git-reader`'s reads outside libgit2 as
  "the folder's own metadata, its `.git` entry's metadata without following a link, an entry inside a
  `.git` folder, and a `.git` file's own content". The adapter reads two more kinds, each inside the
  folder:
  - the metadata, and a link's own text, at each position along the spelled path of the Git directory
    and of the common directory (`crates/nozoki-core/src/git_reader/libgit2.rs:L163`, `:L166`);
  - the content of the `commondir` file in the Git directory (`:L115`, read through
    `read_spelling_file` at `:L275`). When the Git directory is named by a `.git` file, it need not
    be a `.git` folder, so "an entry inside a `.git` folder" does not cover this read.
  The likely fold: name both kinds in the list, and keep "never a path past the folder and never a link
  followed out of it".
- **If a document has to be written:** none. QC-15's statement in `nfdr.md`.
- **Answer:** answered — QC-15's `git-reader` list names both kinds, and its bound does not move.
  The list becomes: the folder's own metadata; its `.git` entry's metadata without following a
  link; an entry inside a `.git` folder; a `.git` file's own content; the metadata, and a link's
  own text, at each position inside the folder along the spelled path to the Git directory and to
  the common directory; and the content of the `commondir` file in a Git directory that lies inside
  the folder — "never a path past the folder and never a link followed out of it" stays as written.
  Both kinds are measured inside that bound at `nozoki@6a0725c` (`libgit2.rs:L200` skips every
  position outside; `:L138-L142` refuses an outside location; `:L276-L279` opens `commondir` with
  `O_NOFOLLOW`). The tail's list of `Path`-method reads gains `:L163`, re-pinned at that commit.
  ADR-0018 does not move: its list is scoped to `probe`, which still makes only those four reads,
  and it hands the `commondir` case to `state()`. Reasoning:
  `docs/trail/architecture/self_answer-37.md` § 3.1.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
