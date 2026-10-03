# SDD open issues — Nozoki

> Companion to `SDD.md`. The CTO wrote the SDD; this file holds what that run could not settle from
> its inputs (the PRD, the SRS, the UXD, and any context or constraints), and the calls that are the
> CPO's or the CDO's to make. An item whose call is the CPO's or the CDO's carries that seat's
> `Seat:`; an item whose call is the CTO's carries `cto` or no `Seat:` field.
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time `product-sdd` folds them in, it first copies this
> file whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item may name the seat that answers it.** Any item in any section carries an optional
> `- **Seat:** <seat>` field beside its other fields. Its value is the name of the agent whose posture
> answers the item — `cto`, `cpo` or `cdo`. An item with no usable value, whether the field is absent,
> empty or still the `<seat>` placeholder, is answered in the seat of the skill that produced this file.
> The field names the *answering* seat. It is not the seat that raised the item (`Raised by:` /
> `Held by:`), and it is not the document an answer belongs to.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a
> disagreement is not something one seat asked, it is two positions held by different seats, and the
> answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the SDD's lanes entirely.** §§ 1–4 are all the SDD's own three
> lane seats; § 5 is a seat that never held a lane in it, reading it long after it settled and
> finding something only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's,
> which stay fixed to the three lane seats on purpose.

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-03 from the SDD's own companion
> template. `git-reader` now exists in the tree (`crates/nozoki-core/src/git_reader.rs`,
> `crates/nozoki-core/src/git_reader/libgit2.rs`, `nozoki@126ef75`) with the four Git fixture scenes beside
> it, and three statements of the SDD no longer match what landed: the `read-only-harness` row's pinned
> inventory, SM-2's owner cell, and C-R6's transport sentence. The SDD is Settled, and with no companion on
> disk a `product-sdd` re-run reads it as done and has nothing to act on. Its three items are in § 5.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 The `read-only-harness` row lists the four Git fixture scenes as owed; they are on disk
- **Raised by:** PM — 2026-10-03
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails; the row's inventory is pinned at `nozoki@7a125b4` and says itself
  that a file landing in `checks/` after that commit "is a re-measurement of this cell and not a
  contradiction of it, and it owes this row an item" (`docs/SDD.md:L332`).
- **Where it shows:** § 3, the `read-only-harness` row (`docs/SDD.md:L332`), lists `inside-a-repo`,
  `parent-of-two`, `linked-worktree` and `submodule` under "Owed by a slice and not on disk". At
  `nozoki@126ef75`, `ls checks/fixtures/` lists all four folders and their four archives
  (`inside-a-repo.git.tar`, `parent-of-two.git.tar`, `linked-worktree.git.tar`, `submodule.git.tar`). The
  likely fold: re-measure the cell at the current commit and move the four scenes, each with its archive,
  into the on-disk inventory.
- **If a document has to be written:** none. The § 3 row in `SDD.md`.
- **Answer:** <the owner fills this in>

### 5.2 SM-2 says the port is a trait the model owns; the trait and its outcome types live in `git-reader`
- **Raised by:** PM — 2026-10-03
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails today. Every later Git station reads SM-2 to decide where the port's
  methods (`state`, `status`) and their types are added, and the seam's text sends them to the model.
- **Where it shows:** § 3 SM-2's row, "The port is a trait the model owns", owner `folder-model` — "the
  port is its" (`docs/SDD.md:L416`). In the tree, `pub trait GitPort` is defined at
  `crates/nozoki-core/src/git_reader.rs:L33` with `RootFinding` and `ProbeCondition` beside it, and
  `crates/nozoki-core/src/folder_model.rs` names neither (`grep -n 'GitPort\|git_reader'` prints nothing).
  The placement keeps `docs/nfdr.md` QC-11's "must not import `folder-model`" for `git-reader`: a trait the
  model held would need that import. What still holds is that the model states the contract. The likely
  fold: SM-2 keeps `folder-model` as the owner of the contract and says the trait and its types are held
  in `git-reader`, as SM-1's owner cell already reads for `fs-reader` ("it states what a read must
  return; the reader implements it"). `docs/adr/0004-git-read-through-libgit2-behind-a-port.md` § Decision's
  "the Git port owned by the folder model" is the records' to match, raised on their companion.
- **If a document has to be written:** none. SM-2's row in `SDD.md`.
- **Answer:** <the owner fills this in>

### 5.3 C-R6 says no shipped unit links a network transport; the vendored libgit2 compiles its `git://` and `http://` transports unconditionally
- **Raised by:** PM — 2026-10-03
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the claim C-R6 makes has nothing that proves it. Its two halves differ. "libgit2 is
  built without its HTTPS and SSH transports" holds: `cargo tree --locked -p nozoki-core --prefix none |
  grep -Ei 'openssl|native-tls|rustls|libssh2|schannel|security-framework'` prints nothing at
  `nozoki@126ef75`. "No shipped unit links a network transport" has no check. The bridge's static
  library now carries libgit2: the `nozoki-mac/Package.swift` link entries landed for it at `nozoki@126ef75`.
- **Where it shows:** § 4 C-R6 (`docs/SDD.md:L600-L601`), and the `git-reader` row's "libgit2 linked
  without its HTTPS and SSH transports" (`docs/SDD.md:L323`). `libgit2-sys 0.18.8+1.9.7`, the version the
  lock resolves, compiles `libgit2/src/libgit2/transports` whatever its features ("These are activated by
  features, but they're all unconditionally always compiled", `build.rs:L152-L155` in the registry copy).
  Its transport table registers `git://` and `http://` with no `#ifdef` around them
  (`libgit2/src/libgit2/transport.c:L33-L34`); only SSH is conditional (`:L26-L27`, `:L38-L40`). `checks/deps.review.md`'s
  `libgit2-sys` row already records this exception. The likely fold is one of two. C-R6 states the
  transport claim at the level the build can hold: no TLS and no SSH, with the plain transports compiled in
  and never called. Or it names the link evidence that would prove no transport reaches the shipped
  executable, and where that evidence is checked. `docs/fdr.md` PD-27 and `docs/nfdr.md` QC-3 trace here.
- **If a document has to be written:** none. § 4 C-R6 and the `git-reader` row in `SDD.md`.
- **Answer:** <the owner fills this in>

