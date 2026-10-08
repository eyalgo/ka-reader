# Self-answer report — `docs/adr/` and `docs/nfdr.md`

This report records one unattended run that answered `docs/architecture_open_issues.md` in the
owner's seat. It is written for the owner, who reads it to learn what was decided and why. It is also
written for the `product-architecture` run that folds the answer.

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-04
- **Sources re-read:** None. The answer rests on the adapter's code and on documents in this
  repository. It leans on no vendor documentation and no claim about how libgit2 behaves.

## Items worked

### 3.1 — QC-15's list of `git-reader`'s reads outside libgit2 omits two kinds the adapter makes

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write these records
- **Verdict:** answered
- **Why:** **QC-15's list should name both kinds. Its bound should not change.** The list as it
  stands (`docs/nfdr.md:L417-L421`) gives `git-reader`'s reads outside libgit2 as four kinds. The
  adapter makes two more, and both lie inside the bound the same sentence states.

  *The PM's claims, re-measured.* `crates/` has not changed since the commit the PM cited
  (`git diff --stat 6a0725c HEAD -- crates checks` prints nothing), so all citations below are at
  `ka-reader@6a0725c`.
  - `state()` and `status()` both go through `open_verified` (`libgit2.rs:L67-L73`). That calls
    `verified_locations` (`:L102-L127`), which walks the spelled path to the Git directory and to the
    common directory. At each position it calls `symlink_metadata`, and at a link it calls
    `read_link` (`:L162-L172`). The walk inspects nothing at a position outside the folder or at the
    folder itself (`:L200-L202`). A location that ends outside is refused, with its spelled path
    (`:L138-L142`).
  - The `commondir` file is read at `:L115`, through `read_spelling_file` (`:L275-L291`). That opens
    the file with `O_NOFOLLOW | O_NONBLOCK`, checks it is a regular file, and holds at most 1 MiB. The
    file sits in a Git directory that has already been verified to lie inside the folder
    (`:L109-L112`). When a `.git` file names that directory, it need not be a `.git` folder, so "an
    entry inside a `.git` folder" does not cover this read. The PM's reading holds.
  - Every other read the adapter makes outside libgit2 is already on the list. `probe` makes four:
    the folder's metadata (`:L54`), the `.git` entry's `symlink_metadata` (`:L58`, and `:L103` in
    `verified_locations`), `.git/HEAD`'s `symlink_metadata` (`:L513`), and the `.git` file's open
    and handle metadata (`:L439-L446`). `verified_locations` also reads the `.git` file's content
    (`:L110`, `:L243`). A `grep` for `std::fs`, `metadata`, `read_link` and `open(` across the file
    turns up nothing else.

  *Check 1 — whose seat.* **This one is mine to decide, in the owner's seat.** The edit lands in
  `nfdr.md` QC-15 and nowhere else. ADR-0018 says the same four-kind list, but only about `probe`:
  "**`probe` reads only inside the opened folder.** It reads the folder's own metadata, …"
  (`docs/adr/0018-…-inside-the-folder.md:L55-L58`). `probe` still makes exactly those four reads. The
  record also gives the `commondir` case to `state()` (`:L97-L99`), so ADR-0018 is still true and
  needs no new record superseding it. The answer commits no person or outside party. It also does not
  widen the read-only promise. The promise's bound, "never a path past the folder and never a link
  followed out of it", stays as written. The list's members were set in this same seat before, by a
  `companion-self-answer` run (`docs/trail/architecture/cycle-29.md` § 3.3; reasoning at
  `self_answer-33.md` § 3.3). That precedent is the list whose length is in question here. RN-47
  left this item for the owner because "Widening the list, or narrowing the reads, is a call on the
  read-only promise's bound" (`docs/nfdr.md`, RN-47). This run reads it differently, for two reasons:
  - Naming two more kinds of read that sit inside the bound corrects the list. It does not move the
    bound.
  - Narrowing the reads is not open to this seat. The Settled SDD requires the adapter to locate "the
    Git directory and the common directory by spelling before libgit2 opens anything"
    (`docs/SDD.md:L1735-L1738`). Narrowing would mean changing the SDD, which the CTO owns.

  I cannot name a ground I am missing. So the item is not left for the owner.

  *Check 2 — the question.* The item has no draft, only a "likely fold", and that fold is right. It
  is one question with one seat, so it does not split.

  *A widening item waits until it occurs.* Two reasons this does not apply. First, the item corrects
  a list that reads as complete and is not, and correcting a false statement is not widening. Second,
  it cites its occurrences (`libgit2.rs:L115`, `:L163`, `:L166`, `:L275`).

  *Check 3 — the settled record.* The `git-reader` row in the SDD has a "Must not own" clause: "A file
  outside Git's own on-disk layout" (`docs/SDD.md:L327`). Both new kinds stay inside Git's layout.
  `commondir` is a Git file. The walk reads only metadata and link text, never a file's content, and
  only at positions that a Git pointer (`gitdir:` or `commondir`) spells out. QC-15's existing "the
  folder's own metadata" is the same kind of read. QC-35 says nothing is read outside the grant
  (`docs/nfdr.md:L890`), and the answer keeps that true. QC-15's tail cites the `Path`-method reads at
  `ka-reader@48308ff` (`:L38`, `:L42`, `:L136`, `:L62`, `:L69`). Each line still holds at that commit
  (`git show 48308ff:…/libgit2.rs`). The fold should add the walk's `symlink_metadata` (`:L163`) to
  that list, re-pinned at `6a0725c`. `read_link` (`:L166`) is a `std::fs` call, and the owner-file
  exemption already admits those.

  *Check 4 — failure paths.*
  - **Empty:** with no `commondir` file, the open finds nothing and the common directory is the Git
    directory (`:L120`). Nothing else is read.
  - **Absent or unreadable:** a position missing or unreadable along the walk stops it with a
    condition (`:L204-L205`). It never reads past that position.
  - **Refused:** a location outside the folder is refused without looking there (`:L200`,
    `:L141`).
  - **Concurrent — not covered, and named.** `O_NOFOLLOW` guards only the last part of the
    `commondir` path. If a folder already walked is swapped for a link after the walk and before the
    open, that link is followed. libgit2's own open follows it too. The after-open comparison
    (`:L86-L88`) checks the spelled paths, not where they resolve. The read-only promise still holds
    in that case because of the App Sandbox wall (ADR-0011), not because of anything in this list.
    QC-15 already gives this half of the bound to review at `development-design`: "which read the
    adapter makes inside its owner file" (`docs/nfdr.md`, QC-15's tail). So the answer adds no
    clause for it.

  *What would have tipped it.* I would have left this for the owner if the SDD's "Must not own"
  clause read as ruling out metadata reads of folder entries that are not Git files. That reading
  would make the walk itself a question for the CTO's seat. As written, the clause is about files
  outside Git's layout, and the walk reads only metadata and link text at positions a Git pointer
  names.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/adr/` and `docs/nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
