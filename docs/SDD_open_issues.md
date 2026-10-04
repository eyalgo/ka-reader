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
> template. The bridge now runs the config search-path switch and exports `nozoki_read_git`
> (`nozoki@392177d`). Four statements of the SDD were true of the tree before that build and are not
> true of it now. The SDD is Settled, and with no companion on disk a `product-sdd` re-run reads it as
> done and has nothing to act on. Its four items are in § 5.

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

### 5.1 § 3 `GitState` says the model holds `HeadState` and nothing else; it now holds both lists
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. The Git view and the tree's markers read the entity to learn what
  the model holds, and the entity says the lists are not in it.
- **Where it shows:** § 3 *What the system holds*, `GitState` (`docs/SDD.md:L485-L487`): "it holds the
  port's `HeadState` and nothing else (`:L166-L168`); the changed and staged entries this entity lists
  are the design, and no landed change puts them in the model". In the tree, `pub struct GitState`
  holds `head: HeadState` and `status: StatusLists`, with a `status()` accessor beside `head()`
  (`crates/nozoki-core/src/folder_model.rs:L169-L181`, at `nozoki@392177d`). One read fills both. The
  likely fold: the model holds the port's `HeadState` and `StatusLists` from one read, re-pinned at
  that commit.
- **If a document has to be written:** none. The entity's sentence in `SDD.md`.
- **Answer:** <the owner fills this in>

### 5.2 § 4 C-I3 leaves the core suites' isolation to "the change that builds the switch"; that change built it and isolated nothing
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. A later Git change reads C-I3 to learn whether `nozoki-core`'s Git
  suites see the machine config, and the clause says that is still to be designed.
- **Where it shows:** § 4 C-I3 (`docs/SDD.md:L726-L731`): "How those suites are isolated is the design
  of the change that builds the switch". The switch is built (`crates/nozoki-bridge/src/machine_config.rs`;
  its read-back case `crates/nozoki-bridge/tests/search_path.rs:L36`, `cargo test --locked -p
  nozoki-bridge` green at `nozoki@392177d`). `nozoki-core`'s in-process Git suites still run with no
  switch, and the answers the bridge serves are proved in the bridge's suite after the switch has run.
  The likely fold: state that the core suites are not isolated, and that the shipped answers are
  proved after the switch in the bridge's suite.
- **If a document has to be written:** none. C-I3's sentence in `SDD.md`.
- **Answer:** <the owner fills this in>

### 5.3 § 4 C-I3 says the `nm` transport read is not in `checks/view.sh`; it is
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** nothing fails. The clause still reads "until that build the claim is stated and
  not proved", and the build it names has landed.
- **Where it shows:** § 4 C-I3 (`docs/SDD.md:L736-L740`): "The read is not in the script at
  `nozoki@814a369`. `see-git-status` owes it, with its suite case, no later than the build that first
  exports a function reaching `git-reader`". That build is here: `nozoki_read_git` is exported
  (`crates/nozoki-bridge/src/exports.rs:L105`; admitted at `crates/nozoki-bridge/tests/exports.rs:L21`).
  The read is in the script (`checks/view.sh:L379`, the `nm` presence check), with its suite cases in
  `checks/tests/test_view.sh`. One thing the read does not yet see: the release executable holds no
  `nozoki_read_git` symbol until a Swift caller links it, so the read has met only a build where the
  new export is dropped by the linker (the integrity pass on that build, `nm` on
  `nozoki-mac/assemble.sh`'s output). The likely fold: the read is in the script from that build, and
  the claim is proved for the linked export once the shell calls it.
- **If a document has to be written:** none. C-I3's sentence in `SDD.md`, and RC-4's *Still
  unresolved* list (`:L2630-L2634`), which names the same read among three things tied to this build.
- **Answer:** <the owner fills this in>

### 5.4 R-16's settling deadline has passed: the first export reaching `git-reader` shipped without it
- **Raised by:** PM — 2026-10-04
- **Seat:** cto
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the SDD's own order. *Open Questions*, last item (`docs/SDD.md:L5560-L5572`), says
  the config-named-path case is "Settled in `see-git-status`, no later than the build that first
  exports a function reaching `git-reader`". RC-4's *Still unresolved* (`:L2630-L2634`) ties the same
  item to that build, "which `nozoki_read_git` is". That build has landed (`nozoki@392177d`), and it
  does not settle the item. No fixture names an outside path in its config: `grep -rn
  'include.path\|excludesfile' checks/fixtures` prints nothing.
- **Where it shows:** *Open Questions*, last item, and § 10 RC-4 *Still unresolved*. Neither form the
  item names is chosen. The second form adds a condition a reader sees, and the item says it is
  written into `git-reader`'s row and § 11 R-16 before it is built.
- **If a document has to be written:** none. The SDD says which build the item is settled by now that
  the named one has passed: a later build of `see-git-status`, before the slice closes, or a stated
  move out of the slice. The form, where it is the second, also lands in `git-reader`'s row and R-16.
- **Answer:** <the owner fills this in>

**How it closes.** `product-sdd` folds these on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
