# SDD open issues — KA-Reader

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

> **Where this file stands.** The PM opened it on 2026-10-04 with four items in § 5. All four were
> answered in the CTO's seat, and `product-sdd` folded them into `docs/SDD.md` v39. The answered file
> is kept whole at `docs/trail/sdd/cycle-34.md`. One item is left, 2.1. It was raised by the run
> that answered the four, and its slot has not been filled.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

### 2.1 § 11 R-16 names `objects/info/alternates` as a third way Git's layout points outside the folder, uncovered until a check holds it
- **Raised by:** CTO
- **Seat:** cto
- **Drafted into the SDD:** two things, in v39. Both are marked as a draft in RN-99.
  - **The limit, named.** § 11 R-16, "A third way out, named in a draft"
    (`docs/SDD.md:L3061-L3070`), and § 4 C-D3's *Not covered* sentence (`:L994-L996`) say that a
    repository's `objects/info/alternates` file names object directories, that libgit2 adds each
    as an object store with no containment check
    (`libgit2-sys-0.18.8+1.9.7/libgit2/src/libgit2/odb.c:L761-L803`; an entry beginning `.` is
    joined to the objects directory at `:L794-L797`, and any other entry is taken as written),
    and that until a case holds it this read is a stated limit.
  - **The response, proposed.** R-16 says the drafted response is that the adapter's check before
    the open refuses a repository whose alternates file names a location outside the folder, with
    the condition the config refusal answers. R-16 also says nothing builds it until it is
    confirmed. It is written into no row of § 3.
- **Rationale:** before v39, R-16 called R-3 "the other way Git's own layout points outside the
  grant", and C-D3 named the config-named path as the one thing not covered. Both read as the
  whole list. The alternates file is a third way, it is not a config key, and R-16's rule does
  not reach it. The source was read and not run: no fixture carries an alternates file, and no
  read of an outside object directory has been measured. The same class may hold a link inside
  the Git directory that leads out, such as a linked `config` or `objects`; that was not checked
  in the source and is not drafted. The reasoning of the run that raised this is
  `docs/trail/sdd/self_answer-46.md`, *Raised on this document*.
- **If overridden:** the "A third way out" paragraph leaves R-16 and the second sentence leaves
  C-D3's *Not covered*, and the outside read through an alternates file goes back to being
  unnamed. In the bundle the sandbox still refuses it (§ 4 C-R2). In the harness nothing does, and
  § 4 C-D1's "any read outside the granted folder" is unheld there for a case no sentence names.
  A narrower override keeps the named limit and drops only the proposed refusal. No slice, edge
  or part moves under either. On a confirm, the refusal is written into § 3's `git-reader` row
  beside the config check, and a case for it joins the proof R-16 lists.
- **Confirm or override:** confirm — the limit stays named and the refusal is built, with five
  additions. The first replaces one clause of the draft.
  (1) **The refusal answers a condition of its own, not the config condition.** R-16's draft
  says "with the condition above". That condition reports that the repository's config names a
  path, and it carries a key. An alternates file is not config and has no key, so the message
  would be false. That is the ground on which the config refusal was given its own condition
  (`docs/trail/sdd/cycle-34.md` § 5.1). The alternates refusal says what was observed: the
  repository's object store names a location outside the folder. It carries the entry as the
  alternates file spells it, and the log line holds no path. It crosses SM-2, SM-4 and SM-8 as
  the config condition does. § 6 S-4's observable half gains one passage for it, in the Git
  view's failure slot, and the message's words are `docs/CONTENT.md`'s.
  (2) **Where the check runs, and what it reads.** It runs wherever the config check runs: on
  the probe, and before the open behind `state()` and `status()`. `git-reader` makes the read,
  with the spelling walk and the size bound the config check uses. It reads
  `objects/info/alternates` under the common directory. A link at `objects`, `info` or
  `alternates` whose spelling leaves the folder is refused without a read, so a linked `objects`
  directory that leads out is refused here. It then reads the `info/alternates` file of each
  alternate that spells inside the folder, because an inside alternate can name an outside one.
  libgit2 follows that chain to a depth of five
  (`libgit2-sys-0.18.8+1.9.7/libgit2/src/libgit2/odb.c:L27`, `:L770`, `:L800`). A chain deeper
  than five, a file over the size bound, or a link chain over the walk's bound is refused.
  (3) **The spellings follow libgit2's own rule** (`odb.c:L789-L802`). An empty line and a line
  beginning `#` are skipped. An entry beginning `.` is spelled from the objects directory that
  holds the file. An absolute entry is taken as written. Any other entry libgit2 hands to the
  operating system as written, which resolves it against the process's working directory and not
  against the folder, so it is refused as outside. Any one entry that spells outside refuses the
  repository.
  (4) **The cases that are not a refusal.** No alternates file, or one holding only empty lines
  and comments, passes. An entry that spells inside the folder with nothing there passes, because
  libgit2 skips it (`odb.c:L697-L700`). An alternates file the adapter cannot read answers the
  existing condition for an unreadable Git directory.
  (5) **Submodules, the proof, and what stays uncovered.** The verification of each submodule
  repository before the status read gains this check beside its two. The proof is one fixture
  whose alternates file names an objects directory outside the fixture, and one case showing that
  directory is not read. It is owed before `see-git-status` is reached, with R-16's other cases,
  and until it exists the read stays a stated limit. Two things stay uncovered and R-16's *Not
  covered* names both: the check and libgit2's read are two reads, so an alternates file
  rewritten between them is followed unchecked; and a link elsewhere inside the Git directory
  that leads out, such as a linked `HEAD`, `index` or `refs`, was not checked in the source.
  On the fold, the refusal is written into § 3's `git-reader` row beside the config check, and
  § 4 C-D3's second *Not covered* sentence names the refusal in place of "covered by nothing
  outside the sandbox". The reasoning is `docs/trail/sdd/self_answer-47.md`.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

None.
