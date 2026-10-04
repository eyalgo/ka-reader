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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-04 from the SDD's own companion
> template. The bridge now has to hand the shell the open folder's Git item, and SM-4 and C-R7 as
> written leave no call that can carry it without changing an answer the shipped shell already
> decodes. The SDD is Settled, and with no companion on disk a `product-sdd` re-run reads it as done
> and has nothing to act on. Its one item is in § 5.

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

### 5.1 SM-4 and C-R7 admit no call that can bring the Git item to the shell; S-4 needs one now
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the shell cannot obtain the open folder's Git item — `pending`, observed `root`,
  observed `plain`, or `failed` with its condition — through the bridge's exported surface, with a
  `cargo test --locked -p nozoki-bridge` case proving each way it is delivered. Without that, § 6 S-4
  (`see-git-status`) has no route from `folder-model`'s Git state to the Git view it delivers.
- **Where it shows:**
  - **SM-4 closes the list.** Down, "calls from this list and no other": nine named calls, none of
    them Git-named, with `nozoki_free` beside the list; "Nothing else crosses in either direction"
    (`docs/SDD.md:L424`). C-R7 holds every build's export set "inside SM-4's list and `nozoki_free`"
    (`docs/SDD.md:L652-L656`), and says "No second plumbing export — a registration call for
    `model_changed`, or any other — is admitted by this sentence: one is raised, on this condition
    and SM-4, by the slice that needs it, and not before" (`docs/SDD.md:L667-L669`). The export test
    holds the built set to an admitted list of `nozoki_open_folder`, `nozoki_list_tree`,
    `nozoki_select_file` and `nozoki_free` (`crates/nozoki-bridge/tests/exports.rs:L17-L22`).
  - **S-4 already rests on the call SM-4 has not admitted.** S-4's *Rests on* names "`SM-4`
    (`model_changed` carrying Git state)" (`docs/SDD.md:L1747`). No registration call exists in the
    tree: `grep -rn model_changed crates/nozoki-bridge nozoki-mac/Sources` printed nothing (run
    2026-10-04 at `nozoki@b716c7b`).
  - **No existing call can carry it without breaking an answer.** A failed read "changes no other
    item" (§ 4 C-I1, `docs/SDD.md:L686-L688`), so listing the tree and selecting a file keep
    answering as they do today whatever state the Git item is in, a `failed` one included. That
    leaves `open_folder`'s return as the only existing carrier, and the
    shipped shell's decoder rejects an `opened` answer with any member besides `state`
    (`nozoki-mac/Sources/Shell/BridgePayload.swift:L49-L53`), as does the bridge's own check
    (`crates/nozoki-bridge/src/boundary.rs:L51`). A `git` member on that answer would make every
    folder open read as stopped until the shell's decoder changes with it.
  - **What is asked.** Amend SM-4 and C-R7 so they admit one call that delivers the Git item to the
    shell — either a Git-named call on SM-4's list, or the `model_changed` registration call S-4's
    *Rests on* already names. Either way the bridge adds an export, changes no existing answer, and
    the shell needs no change in the same build. Which of the two, its name, and whether it is on
    the list or beside it as `nozoki_free` is, are the SDD's call.
  - **The route the owner chose.** On 2026-10-04 the owner chose to amend the SDD first, over the two
    other routes: carrying the item on `open_folder`'s return with a shell-decoder change landing
    beside it, or holding the delivery back until the shell's Git view is built.
- **If a document has to be written:** none. SM-4's row (§ 3) and C-R7 (§ 4) in `SDD.md`, and
  S-4's *Rests on* if the call chosen is not the `model_changed` registration.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
