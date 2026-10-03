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

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-10-04 from the records'
> own companion template. `git-reader`'s adapter now reads a root's Git state (`state` and `status`,
> `nozoki@6a0725c`). Before libgit2 opens anything, it reads two kinds of file outside libgit2 that
> QC-15's list of permitted reads does not name. The records are Settled, and with no companion on disk
> a `product-architecture` re-run reads them as done and has nothing to act on. Its one item is in § 3.

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
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
