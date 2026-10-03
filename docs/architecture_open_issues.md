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

### 2.1 QC-47's *verified by* says an unreadable entry leaves "`observed` on its siblings"; a sibling not yet read is `pending`

> **No `product-architecture` run raised this item.** A `companion-self-answer` run answering
> `docs/SDD_open_issues.md` § 2.1 in the CTO's seat appended it on 2026-10-04, under
> `<CORE>/prompts/decide_companion_answers.md` § *The items are not the whole of what a document is
> owed*. That run confirmed the same correction in the SDD's § 4 C-I1 and in `follow-the-folder`'s
> command half, which QC-47 repeats; the SDD takes it on `product-sdd`'s next fold. The draft below
> is that run's and nothing has been written into `nfdr.md`. Reasoning:
> `docs/trail/sdd/self_answer-36.md` § 2.1 and § *Companions opened*.

- **Lands in:** `nfdr.md` QC-47
- **Drafted into the records:** Nothing has been written into the records. As it stands, QC-47's
  *verified by* reads "an unreadable fixture entry yields `failed` on that item and `observed` on its
  siblings (layer 2)" (`docs/nfdr.md:L1009-L1010`). The draft change: the unreadable entry yields
  `failed` on that item and the failure changes no other item — each sibling holds the state its own
  read gave it. QC-47's statement, "degrades only that item", stays as written.
- **Rationale:** The wording cannot be met by a folder that holds a folder. `list_tree` reports a
  folder it has not expanded as `Pending` (`crates/nozoki-core/src/fs_reader.rs:L853`, at
  `nozoki@bc76311`), so an unreadable entry beside an unexpanded folder has a sibling that is not
  `observed`. The SDD says the same in its own § 3: `pending` is "a folder entry not yet read"
  (`docs/SDD.md:L456-L457`). QC-47's statement already says what the draft says, and so does the
  requirement it traces to, "degrades only that item's view" (`docs/SRS.md:L297-L298`). Only the
  *verified by* clause, which a change reads literally, carries the defect. `--test watch` is not
  built yet, so nothing fails today. The doubt: "`observed` on its siblings" may be read as shorthand
  for "its siblings are untouched", and then nothing is false.
- **If overridden:** QC-47 keeps its wording. Once `product-sdd` folds `docs/SDD_open_issues.md`
  § 2.1, the NFDR's clause then differs from the SDD condition it traces to (§ 4 C-I1). No ADR
  supersedes and no other obligation moves either way.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

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
