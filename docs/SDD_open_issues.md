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

> **No `product-sdd` run wrote this file.** The Principal Architect's `companion-self-answer` run
> opened it on 2026-10-06 from the SDD's own companion template, while answering
> `docs/architecture_open_issues.md` § 3.2 (QC-15's list of `git-reader`'s reads outside libgit2).
> Answering that item meant checking every read the adapter makes against SDD § 3's `git-reader`
> row, which QC-15 derives its list from. One read the adapter makes, `.gitmodules` and the files
> it includes, is not in that row. The NFDR cannot name a read the SDD does not own, so the change
> starts here. The SDD is Settled, and with no companion on disk a `product-sdd` re-run reads it as
> done and has nothing to act on. Its one item is in § 2. The run put it there and not in § 5
> because the skill that opened this file files every item it raises under *choices to confirm*:
> raising a change already carries a lean. Its **Confirm or override** slot is left for the CTO.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

### 2.1 The config check also reads `.gitmodules` and the files it includes, and the `git-reader` row neither owns that read nor makes an exception for it
- **Raised by:** Principal Architect, answering `docs/architecture_open_issues.md` § 3.2 in the
  owner's seat — 2026-10-06
- **Seat:** cto
- **Drafted into the SDD:** nothing. The run that raised this item writes no document. It proposes
  this change: § 3's `git-reader` row, under *Owns*, names `.gitmodules` in the working tree of the
  repository and of each submodule the adapter verifies. The row places it among the files the config
  check reads, with the check reading only its include keys. Under *Must not own*, the row adds
  `.gitmodules` and the files it includes inside the folder as a third exception, beside RN-99's and
  RN-100's. § 11 R-16 names `.gitmodules` among the config files its domain rule reaches.
- **Rationale:** libgit2 loads `.gitmodules` as a config file during the status read. The diff that
  status runs starts the submodule cache (`libgit2-sys 0.18.8+1.9.7`,
  `libgit2/src/libgit2/diff_generate.c:L759-L760`). That cache's map (`submodule.c:L294`, `:L634`)
  takes a snapshot of `$WORK_TREE/.gitmodules` (`:L665`). The snapshot opens the file with
  `git_config_open_ondisk` (`:L2243-L2260`), which reads it as a config file and follows its
  includes. That puts `.gitmodules`' include paths inside R-16's own domain rule: "every path
  libgit2 takes from a config file it loads for the repository, during the open, the state read and
  the status read" (`docs/SDD.md:L3041-L3043`). The built adapter already checks it.
  `verify_submodules` runs the config scan over `.gitmodules` in the repository's working tree and
  in each submodule's, before status opens any of them (`crates/nozoki-core/src/git_reader/libgit2.rs:L285-L302`
  at `nozoki@b25b407`; the file name at `:L29`). The scan follows include keys only there
  (`:L238`). The SDD does not state this read. The `git-reader` row's config check lists the
  `config`, `config.worktree` and the files those include (`docs/SDD.md:L338`). Its *Must not own*
  excepts "a config file inside the folder that the repository's config includes (RN-99), and the
  `info/alternates` file of an alternate object directory inside the folder (RN-100)" (same line).
  `.gitmodules` lies in the working tree, outside `.git`, and a file it includes is not one the
  repository's config includes. The SDD mentions `.gitmodules` only as a fixture's contents
  (`docs/SDD.md:L7023`). So the read is built and correct, and no SDD statement owns it.
- **If overridden:** if the read is not the adapter's to make, the adapter's `.gitmodules` check
  comes out. libgit2 then follows an include in `.gitmodules` that leads outside the folder during
  the status read, with no containment check, and R-16's domain rule names that path as one the
  product must not take. If `.gitmodules` already counts as part of "Git's own on-disk layout", the
  row still owes one sentence saying so. The files it includes are not part of that layout, and
  RN-99's exception does not cover them.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

None.
