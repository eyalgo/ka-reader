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
- **Answer:** Confirmed, with additions. Fold both corrections, pinned to `ka-reader@c268945`, the merge that landed the change; the tip this run read, `ka-reader@060fc76`, holds its tree outside `docs/` (`git diff --stat c268945 060fc76 -- . ':!docs'` prints nothing), and `git diff --name-status 8b93322 c268945 -- checks` lists `read-only.sh`, `tests/test_read_only.sh` and `tests/test_entry_points.sh`, changed, and no file added or removed, so the row's enumeration, its counts and every other locator it carries stand. (1) § 4 C-I3, the restore and its three locators: the restore is `restore()` (`checks/read-only.sh:L210-L252`; its header `:L24-L29`). Where `<fixture>.git.tar` sits beside the fixture and the fixture holds no `.git` of any kind, a dangling link included (`:L212-L215`), the archive is extracted into scratch space (`:L217-L223`) and only the entries the fixture lacks are copied in, never over or through an entry already there (`:L238-L249`), each written to a ledger before it is made (`:L245`). The first hash is taken after the restore (`:L368`) and the second after the walk (`:L389`), both of every entry under the fixture and nothing above it (`:L19-L22`; `manifest()` at `:L45-L65`). Once the verdict is taken, the one finalizer removes what the ledger names, deepest first and never recursively, keeping an entry the walk created together with the restored folders it needs (`:L286-L318`; `finish()` at `:L326-L349`), on every exit the script can act on — a failed step, the end of the run, or any signal a process can catch (`:L179-L204`, `:L352-L357`) — and `unchanged` is printed last, only over a tree left as it was found (`:L339-L347`). The rule's sentence stands — a walk fixture is a folder the restore builds whole, and a scene whose Git directory lies outside the opened folder is not one — with "in-place" dropped from the mechanism's label: here, in § 3's row where the four root-finding scenes are named, and in § 6 S-4 (`docs/SDD.md:L2077`, `:L2081`), which names the same mechanism by the same label. RN-101's `:L73-L76` is a dated measurement and stays as history. (2) § 3, the `read-only-harness` row, the `fixtures/.gitignore` sentence: the file is on disk at the pin, six lines, two patterns anchored to its folder, `/submodule/.gitmodules` and `/submodule/submodule/` — the two members of `submodule.git.tar` that unpack outside `.git` (`tar -tf checks/fixtures/submodule.git.tar | grep -v '^\.git/'` → `.gitmodules`, `submodule/.git`). Since `c268945` a completed walk removes both once the verdict is taken, so after the gate's *Read-only, submodule* step (`checks/gate.sh:L70`) they match nothing: the PM's fresh-clone measurement, two passes over all thirteen folders, `unchanged` thirteen times each and `git status --porcelain --ignored checks/fixtures` empty after each (not re-run by this run; the suite's case `test_signal_during_restore_walk_and_teardown_cleans_up`, `checks/tests/test_read_only.sh:L922`, holds the same property on every catchable signal at the restore, the walk and the teardown). The reason the row gives — that condition 3 holds after an in-place restore — and the reason the file's own comment gives (`checks/fixtures/.gitignore:L1-L4`) no longer describe the script. The design gives the file no reason: the clean tree is C-I3's teardown, not an ignore pattern, and `own-state.sh`'s condition 2 names ignored entries precisely so that nothing under the fixtures hides (`checks/own-state.sh:L23-L27`). What the two patterns still do is keep out of `git status` the residue of a walk that ended without its finalizer, which only KILL and STOP reach (`checks/read-only.sh:L179-L180`), for this one fixture — three other archives also hold members outside `.git`, `linked-worktree.git.tar` 38, `parent-of-two.git.tar` 46 and `submodule-config-names-outside.git.tar` 4, and none has a pattern — and inside the gate a killed step ends the run before *Own state* (`checks/gate.sh:L26-L33`, `:L91`), so there the file does nothing at all. So the row says: `fixtures/.gitignore`, harness data on disk at the pin, its two patterns and what they name, the reason it was written for historical since `c268945`, and no design reason remaining; its removal, and the file's stale comment with it, is a change to `checks/` and not this document's to make — the row records it when it lands, by its own rule that a file leaving `checks/` after the pin is a re-measurement of the cell. QC-49's `--kill` is the host killed mid-churn, a different promise, carried where the item says it is; this answer does not touch it. (3) RN-116 and the version entry. Reasoning: `docs/trail/sdd/self_answer-62.md`.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
