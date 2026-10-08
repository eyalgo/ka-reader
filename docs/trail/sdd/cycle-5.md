# SDD open issues — KA-Reader

> Companion to `SDD.md`. Three seats — the CTO, the CPO and the CDO — authored the SDD
> non-interactively in one run; this file holds what that run could not settle from its inputs (the
> PRD, the SRS, the UXD, and any context or constraints).
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time the seats fold them in, they first copy this file
> whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a disagreement is not something one seat asked, it
> is something two seats answered differently, and the answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the run entirely.** §§ 1–4 are all the SDD's own three seats;
> § 5 is a seat that never wrote the SDD, reading it long after it settled and finding something
> only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's, which stay fixed
> to the three authoring seats on purpose.

> **No `product-sdd` run opened this companion. The PM opened it on 2026-09-19, from a post-build
> review.** `SDD.md` is settled at v6 and had no companion on disk. Without one, a `product-sdd`
> re-run would read the SDD as done and find nothing to act on. The companion holds a single item,
> § 5.1. The built tree now grants the renderer its commands one slice at a time, and C-R7 and SM-4
> say the grant is the whole list from the start.

---

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 C-R7 and SM-4 state the whole command list as the grant, while the slices grant it one command at a time
- **Raised by:** PM — 2026-09-19
- **Tracked by:** `ka-reader · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing yet fails. But no build before the last slice meets C-R7 as written,
  and every downstream reader that holds a build to it has to choose, alone, which list is in
  force.
- **Where it shows:**
  - § 4 C-R7 (`SDD.md:L486-L488`): "The host's capability file grants the renderer exactly SM-4's
    command list and the asset scheme, and no plugin". *Violated by:* "any widening of either list".
  - § 3 SM-4 (`SDD.md:L352`): "exactly the commands `open_folder`, `list_tree`, `select_file`,
    `open_relative_link`, `set_theme`, and — where built — `open_diff`, `walk_history`,
    `switch_folder`; and asset requests on the `ka-reader-asset` scheme". Only the last three are
    conditioned on being built.
  - § 6 S-2's *Command* bar (`SDD.md:L1117`): "`select_file` is on `SM-4`'s list and in the
    capability file". So the SDD's own slices add a command to the grant in the slice that builds
    it. That contradicts C-R7 and SM-4 read as a rule for every build.
  - § 4 C-I3 (`SDD.md:L512`): `read-only.sh` "exercises every command on SM-4's list". On the S-1
    tree, three of the five unconditional commands do not exist to exercise.
  - The tree at `ka-reader@1741429`: `crates/ka-reader-app/capabilities/main.json:L5` grants
    `allow-open-folder` and `allow-list-tree` and nothing else. `crates/ka-reader-app/tests/config.rs:L231`
    holds set equality against those two. No asset scheme is granted, and its origin form is still
    open (*Open Questions*, third item).
  - The CSP half of C-R7 already has a staged statement downstream. NFDR QC-23 keys its check on
    C-R7's state: "While C-R7 carries the `<asset-scheme>` placeholder" (`nfdr.md:L191-L192`). The
    command half of C-R7 has no such statement.
- **If a document has to be written:** none. What is owed is one sentence in C-R7, and SM-4's list
  to match, saying which list binds a given build. The PM's lean is: the commands the slices built
  so far have registered, plus the asset scheme once its form is settled, and never a command no
  slice has built. NFDR QC-24 states the same list, and the architecture companion carries that
  side. Doubt: an "exactly the whole list" reading may be intended only for the 1.0.0
  release. If so, the fix is to say that, and not to stage the list.
- **Answer:** Confirm the PM's lean, with three additions. The SDD's own slices already stage the
  grant. S-2, S-3 and S-6 put their command "on SM-4's list and in the capability file" in the slice
  that builds it. S-8, S-9 and S-10 say theirs "joins" the list. S-11 checks for "SM-4's eight
  commands" at `v1.0.0` (`SDD.md:L1117`, `L1185`, `L1368`, `L1487`, `L1540`, `L1591`, `L1663`). So
  C-R7 and SM-4 are the sentences that are wrong, not the slices. The fold states the grant once, in
  C-R7, with SM-4 matching. **A build grants exactly the commands its landed slices register. That
  set is always inside SM-4's list, and no command is granted before a slice registers it. From
  `v1.0.0`, the set is SM-4's list whole (S-11, C-I6).** The asset scheme enters the grant in the
  slice that settles its form (S-3), keyed on C-R7's state, as QC-23 already keys the CSP half. The
  "only for 1.0.0" doubt is the same sentence: before 1.0.0 the grant follows the slices, and from
  1.0.0 it is the whole list. The additions: (1) C-I3's "every command on SM-4's list" (`L512`)
  takes the same staging and becomes "every command the build grants". The item cites it, but its
  "what is owed" names only C-R7 and SM-4. (2) Set equality is against the commands the host
  registers, with that set checked to be inside SM-4's list. It is not against a hand-kept copy.
  Then a deferred task's command, which is never registered, is never granted, and two slices landing
  commands on separate branches meet at one set when they merge. (3) Named uncovered case: before
  `v1.0.0`, a later change that stops registering a built command passes the staged check. Nothing
  but that slice's own bar holds it until C-I6's pin exists. That fits C-6's pre-1.0.0 half, and it
  is stated here so it is not mistaken for coverage. NFDR QC-24 re-derives from this sentence
  through `architecture_open_issues.md` § 3.1, which is unchanged. Reasoning:
  `docs/trail/sdd/self_answer-11.md`.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
