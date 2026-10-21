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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-21, from a `shukuba-refine`
> review on the seed `ka-reader · nemawashi · 2026-10-01_ci-and-harness-to-their-bar`,
> to carry item 5.1 below. The SDD is Settled, so without a companion it would reach no one.

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

### 5.1 § 4 C-I3 says the walk's restore unpacks into the fixture folder, and § 3 gives `fixtures/.gitignore` a reason that no longer holds
- **Raised by:** PM — 2026-10-21
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-01_ci-and-harness-to-their-bar`
- **What it blocks:** nothing. Two statements about `checks/read-only.sh` are now false, and the
  SDD is Settled, so nothing else carries them.
- **Where it shows:**
  - § 4 C-I3 (`docs/SDD.md:L802-L805`) says the script "unpacks `<fixture>.git.tar` into the fixture
    folder where that folder holds no `.git` (`checks/read-only.sh:L73-L76`)" and hashes
    "(`:L17-L20`, `:L84`)". None of the three locators is pinned. At `ka-reader@c268945` the script
    unpacks the archive in scratch space, copies in only the entries the fixture lacks, writes each
    to a ledger first, and removes what it laid down once the verdict is taken, keeping an entry the
    walk created with the restored folders it needs (`checks/read-only.sh:L24-L36`, `restore()` at
    `:L210`, the first hash at `:L368`). `:L73-L76` now holds the usage refusal, and the hashing header that
    `:L17-L20` named sits at `:L19-L22`.
  - § 3, the `read-only-harness` row (`docs/SDD.md:L367`), says `fixtures/.gitignore` exists so that
    `own-state.sh`'s condition 3 "holds after the gate's *Read-only, submodule* step's in-place
    restore". That restore no longer leaves those two members behind. In a fresh clone at
    `ka-reader@c268945`, walking all thirteen fixture folders twice gave `unchanged` thirteen times
    each pass, and after each pass `git status --porcelain --ignored checks/fixtures` printed nothing.
    So the patterns now ignore nothing after a walk. The file's own comment
    (`checks/fixtures/.gitignore:L1-L4`) gives the same reason. `checks/own-state.sh` lists the
    archive (`:L81`) and does not unpack it.
- **If a document has to be written:** none. The fold would restate C-I3's restore as staged
  extraction, then the missing entries only, removed after the verdict, with its locators pinned to
  a named commit. It would also say whether `fixtures/.gitignore` still has a reason to exist. The
  PM's lean is that it has none and can go in a later change to `checks/`. The doubt: the patterns
  still cover a walk that is killed before its cleanup runs. The NFDR states no promise for that
  case beyond QC-49's `--kill`, which no script runs yet.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
