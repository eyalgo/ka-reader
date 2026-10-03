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

> **Where this file stands.** The PM opened it on 2026-10-04 with four items in § 5, after
> `git-reader` answered `state` and `status` (`nozoki@6a0725c`). A `companion-self-answer` run
> answered the four the same day and raised § 2.1 below. The `product-sdd` run that wrote SDD
> version 28 folded the four answers and dropped their items; the file as answered is kept whole at
> `docs/trail/sdd/cycle-23.md`, and the fold's record is `docs/SDD.md` RN-88. One item is left,
> § 2.1, and its slot is empty.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

### 2.1 § 4 C-I1 and S-5's command half say a failed read leaves "`observed` on its siblings"; a sibling not yet read is `pending`

> **No `product-sdd` run raised this item.** The `companion-self-answer` run that answered this
> file's § 5 raised it on 2026-10-04, under `<CORE>/prompts/decide_companion_answers.md` § *The
> items are not the whole of what a document is owed*, which covers the document being answered. It
> came from answering § 5.4 (`docs/trail/sdd/cycle-23.md` § 5.4): the wording that answer corrects
> in S-4 and RN-44 is quoted from C-I1, and C-I1 and S-5 still carry it. The `product-sdd` run that
> folded § 5.4 carried this item over unanswered and re-pinned its line locators to SDD version 28;
> it wrote nothing into the slot and changed neither sentence, because no answer authorizes the
> change. Reasoning: `docs/trail/sdd/self_answer-35.md` § *Raised on this document*.

- **Raised by:** `companion-self-answer`, answering this file in the CTO's seat — 2026-10-04
- **Seat:** cto
- **Drafted into the SDD:** Nothing has been written into the SDD. As it stands, § 4 C-I1 reads "a
  failure to read one file, one entry or one part of Git state yields `failed` or `stopped` on that
  item and `observed` on its siblings" (`docs/SDD.md:L686-L687`), and S-5's *Command* reads "an
  unreadable entry yields `failed` on that item and `observed` on its siblings"
  (`docs/SDD.md:L1794-L1795`). The draft change: both say the failure is held on that item and its
  siblings stand as they were — `observed` where read, `pending` where not yet read, `failed` where
  an earlier read failed. RN-44's parenthesis, which quotes C-I1 (`docs/SDD.md:L3333`), follows.
- **Rationale:** The wording cannot be met by any folder that holds a folder. `list_tree` reports a
  folder it has not expanded as `Pending` (`crates/nozoki-core/src/fs_reader.rs:L137`, `:L853`), so
  a failed entry beside an unexpanded folder has a sibling that is not `observed`. S-4 carried the
  same defect and SDD version 28 corrected it there (`docs/SDD.md` RN-88, (4)): its reducer case
  had to choose a tree of files only. S-5 has not been built, and its `--test watch` case would
  meet it again. The requirement C-I1 cites says what the draft says: `docs/SRS.md` NFR-3,
  "degrades only that item's view" (`docs/SRS.md:L297-L298`). The doubt: a reader may take
  "`observed` on its siblings" as shorthand for "its siblings are untouched", and then nothing is
  false. It is raised because S-5's clause is a command bar, and a bar is read literally by the
  change that has to pass it.
- **If overridden:** C-I1 and S-5 keep their wording, and S-4 goes on saying "as they were" where
  the condition it cites says "`observed`". No part, seam, slice, edge or place in the order moves
  either way. `docs/nfdr.md:L1009-L1010` repeats the wording and re-derives from whichever the SDD
  holds.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

None.
