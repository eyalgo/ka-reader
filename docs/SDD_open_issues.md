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
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

None.
