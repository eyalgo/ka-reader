# SDD open issues — Nozoki 覗き

> Companion to `SDD.md`. Three seats — the CTO, the CPO and the CDO — authored the SDD
> non-interactively in one run; this file holds what that run could not settle from its inputs (the
> PRD, the SRS, the UXD, and any context or constraints).
>
> **Answer inline** — fill each **Answer** / **Confirm-or-override** / **Keep-or-recut** slot —
> **commit this file**, then re-run `product-sdd`. It folds your answers into the SDD and drops the
> resolved items. When nothing is left open, `product-sdd` **deletes this file**: no file = the SDD
> is done.
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

> **This companion was opened by a downstream reader, not by a `product-sdd` run — and both items
> below ask for the same thing: a re-run that rewrites the SDD.** `SDD.md` is Settled at v3 and its
> companion was correctly removed at run 3. It is opened because `sdd_template.md` moved underneath
> this document on 2026-09-02, after run 3 was written: `version: "3.1.0"` → `version: "4.0.1"`, a
> major bump (kensaiapp-dev@8f5105cb → @f5d070b9). Nothing is missing from the SDD; what changed is
> what the SDD is measured against, and one half of the move is now enforced by a tool that refuses
> this document as it stands. With no companion on disk a `product-sdd` re-run reads the SDD as done
> and has nothing to act on, so the finding is filed here — the shape the template's own § 5.2
> provides for exactly this case, added in the same move (`sdd_open_issues_template.md` 1.2.0 →
> 1.3.0, kensaiapp-dev@2c771d73, "a companion item for when the template moved, not when the
> document is missing something").
>
> **Only this document's template moved.** Of the definition spine's seven documents, the SDD's is
> the only one whose template changed after its document was written — PRD 2026-08-12, Agari
> 2026-08-27, SRS 2026-08-26, UXD 2026-08-30, FDR 2026-08-28 are all older than the documents that
> instantiate them. No sibling document is owed a re-cut on this ground.

---

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 § 3 must be re-cut into the two tables the template now fixes — and three of its `Lives in` cells are refused by the tool that reads them
- **Raised by:** Principal PM — 2026-09-02 — the seat whose `product-skeleton` launcher and
  `seeds-from-product-docs` cut both read § 3.
- **What moved:** `sdd_template.md` § 3. At 3.1.0 it asked for the parts and the seams and left the
  seams' shape to the run; at 4.0.1 it fixes **two tables** and says "Leave both tables as written"
  — a **parts** table (`Part | Lives in | Owns | Must not own`) and a **seams** table
  (`Seam | What crosses | Owner of the contract`) — and it fixes the form of two columns that were
  free text before. `Part` is now "lowercase letters and digits, single hyphens between them, and
  nothing else". `Lives in` is now "a bare path and nothing else … One value, relative to the
  product root, no leading `/` and no `..` in it. Not a sentence, not two options, no backticks, no
  bold, no trailing clause", with the explanation of a part's placement moved into *Owns*. What the
  system holds moves to "prose below the tables". The authoring lens moved with it
  (`<CORE>/prompts/cto_create_sdd.md` 1.1.1 → 1.2.0: "You fill two tables, and the template fixes
  their shape … Do not write this section as prose: it is read by a tool as well as by a person").
- **Why it matters here:** `<CORE>/launchers/product-skeleton/launcher.sh` creates one directory per
  part before any code exists, by parsing this § 3 (`parse_parts_table`, launcher.sh:183-225) and
  joining `Lives in` to the part's slug (`rel_dir = f"{lives_sub}/{slug}"`). It validates both
  columns and **refuses the run** rather than reading past a bad cell (`PART_SLUG_RE`,
  launcher.sh:306-318; `LIVES_IN_RE = ^[A-Za-z0-9._-]+(?:/[A-Za-z0-9._-]+)*$`, launcher.sh:337-352,
  whose own comment cites a cell of exactly this document's shape). Run against `docs/SDD.md` as it
  stands (checked 2026-09-02, all nine rows parsed), **three `Lives in` cells fail** — so no
  skeleton can be built for this product until § 3 is re-cut. The three, as the parser is left with
  them after it strips one matched pair of backticks:
  - `git-reader` → `` nozoki-core`, behind the **Git port** ``
  - `surfaces` → `` nozoki-ui` (HTML / CSS / TypeScript, every asset bundled) ``
  - `read-only-harness` → `` checks/` (build-time, not shipped) ``
- **What the re-cut owes, per row or per section:**
  1. **Those three cells become bare paths** — `nozoki-core`, `nozoki-ui`, and for the harness a
     path with no trailing slash (`checks/` fails the same check; `checks` passes). Each trailing
     clause moves into *Owns*, where 4.0.1 puts it. "behind the **Git port**" is already carried by
     seam 2 and need not be restated; "build-time, not shipped" and the renderer's language list are
     facts *Owns* does not state today.
  2. **The seams become the second table.** § 3's seven seams are a numbered prose list; they become
     rows of `Seam | What crosses | Owner of the contract`, each a short id and `<part> ↔ <part>`.
     Two need a decision as they are rewritten rather than a transcription: seam 1's left side is
     the OS filesystem, which is not a part, and seam 4 names the packages `nozoki-app` and
     `nozoki-ui` where the parts either side are `ipc-surface` and `surfaces`.
  3. **Choose each cell for what it makes on disk, not for what reads well.** `checks` joined to
     `read-only-harness` makes the directory `checks/read-only-harness`, and the harness this
     product describes is `checks/*.sh` (`system/projects/nozoki/project.md`, Test command note;
     NFDR § 10). Whether that row's cell is `checks`, something else, or empty — 4.0.1 leaves it
     empty for a part at the product root — is the re-cut's call.
  4. **Decide where the entity table goes.** "What the system holds" is an eight-row table; 4.0.1
     places that content "in prose below the tables". Either form is safe from the parser, which
     identifies the parts table by a header carrying both `Part` and `Lives in` (launcher.sh:199)
     and this one carries neither — so this is a conformance call, not a defect.
  5. **Minor, named so it is decided rather than swept up:** 4.0.1 says `Lives in` carries no
     backticks, and all nine cells are written in them. The launcher strips one matched pair, so the
     six well-formed cells pass today (verified 2026-09-02). Stripping them changes presentation and
     nothing else.
- **What it may leave alone:**
  - **All nine part slugs already satisfy the new shape** — `fs-reader`, `git-reader`, `watcher`,
    `folder-model`, `own-state`, `markdown-renderer`, `ipc-surface`, `surfaces`,
    `read-only-harness`. Nine of nine pass `PART_SLUG_RE` (verified 2026-09-02), and none names a
    position in the list — the half no tool can check.
  - **No part slug collides with a slice slug.** § 6's eight are `read-a-folder`, `read-markdown`,
    `see-what-changed`, `watch-a-moving-tree`, `pick-it-up-release`, `switch-the-folder`,
    `read-the-diff`, `read-the-history`; no string is in both sets, so § 8's map stays keyed
    unambiguously.
  - **The parts table's four columns, their order, and every *Owns* / *Must not own* cell** — the
    move touched none of them.
  - **The substance of § 3**: the nine parts, the seven seams and what crosses each, the entities
    with their DR traces, and the floor-language extension set. This is a re-shaping of one section
    against a moved template, not a redesign — no slice, trade-off, risk or review note changes
    because of it, and no other section of the SDD is measured differently at 4.0.1 than at 3.1.0
    except as § 5.2 below states. A re-cut that reaches past this list is the cost this slot exists
    to bound.
- **Answer:** <the owner fills this in>

### 5.2 The preamble and § 8 cite two `principal_pm_global.md` sections that no longer exist
- **Raised by:** Principal PM — 2026-09-02 — the seat whose own loader is being cited.
- **What moved:** the same bump dropped both citations from the template's own boilerplate
  (kensaiapp-dev@02d19689, "the SDD template stops citing deleted loader sections"). At 3.1.0 the
  preamble read "…are all `<CORE>/roles/loaders/principal_pm_global.md`'s — § *The loop* and § *Where
  a seed's stations reach*", and § 8's opening read "…§ *The loop* owns the round". At 4.0.1 both
  cite the loader whole and name no section. `docs/SDD.md` carries the 3.1.0 wording verbatim at
  both sites — the preamble blockquote (line 18) and § 8's opening guidance (line 1275), the only
  two occurrences in the file (checked 2026-09-02).
- **Why it matters here:** `<CORE>/roles/loaders/principal_pm_global.md` has neither section. Its
  headings are *What you own*, *The FDR*, *Cutting seeds from an idea*, *Cutting seeds from a
  product's documents*, *Inputs you expect*, *Responsibilities*, *Non-responsibilities
  (boundaries)*, *Who you are most easily confused with — the PM*, *Three seams — CTO/CPO, PM, the
  owner*, *Skills toolbox (reminder)*, *Hand-off triggers* (read 2026-09-02). Both citations are
  load-bearing: they are what this document offers *instead of* stating how many seeds a slice
  yields and when one is drawn, so a reader following either lands on nothing at the point where the
  SDD has deliberately said nothing itself.
- **What the re-cut owes, per row or per section:** two sentences, and it is a copy rather than a
  judgment — 4.0.1 already carries the replacement wording. Preamble: drop "— § *The loop* and
  § *Where a seed's stations reach*", leaving the loader cited whole. § 8: "…are that seat's —
  `<CORE>/roles/loaders/principal_pm_global.md` owns the round, and this section neither restates it
  nor constrains it."
- **What it may leave alone:** the whole of § 8 besides that one clause — the slice-field → seed-
  section map and its three-way *Across the seeds* column, the stations paragraph and the owner's
  2026-08-26 call, and the two closing rules — is identical at 4.0.1 and 3.1.0. The preamble is
  otherwise unchanged too, except for what § 5.1 above already covers.
- **Answer:** <the owner fills this in>

<!-- add 5.3, 5.4, … as needed -->
