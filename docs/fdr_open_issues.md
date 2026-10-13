# FDR open issues — KA-Reader

> Companion to `fdr.md`. The Principal PM authored the FDR non-interactively; this file holds what the
> run could not settle from its inputs — the PRD, the SRS and the SDD.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-fdr`. It folds your answers into the FDR and drops the resolved items. When nothing is
> left open, `product-fdr` **deletes this file**: no file = the FDR is done.
>
> Your answers are never thrown away. Each time the Principal PM folds them in, it first copies this
> file whole to `docs/trail/fdr/` — so what you decided, and why, stays readable and citable for good.
>
> **§ 3 is the odd one, and worth reading twice.** The Principal PM writes the FDR *and* is the seat
> most likely to raise an item against it later, cutting the same product's documents into seeds. The
> two are different acts at different times, and § 3 keeps the later one visible instead of letting
> it be quietly folded back into § 1 as though the authoring run had asked it.

> **How this companion came to exist.** No `product-fdr` run opened it. A `companion-self-answer`
> run answering `docs/SDD_open_issues.md` opened it on 2026-10-13, in the CTO's posture: `fdr.md`
> was Settled at v10 with no companion on disk, so without this file a `product-fdr` re-run would
> read it as done and fold nothing. What prompted it is `docs/SDD_open_issues.md` § 5.1, pinned at
> `ka-reader@821a163:docs/SDD_open_issues.md` because the SDD's fold removes that file: the owner
> raised KA-Reader's macOS floor from 14.0 to 26.0 and moved CI from the `macos-14` image to
> `macos-26`, answering the item in their own hand. `product-sdd` folds that into SDD § 4 C-R5 on its
> next run, and three entries here state the floor and trace to that passage. It held one item,
> § 2.1; the reasoning is `docs/trail/sdd/self_answer-55.md`. The SDD has since folded it (v48,
> `ka-reader@6eec80c`), and the `product-fdr` run that wrote FDR v11 on 2026-10-13 drafted § 2.1's lean into
> the FDR and added § 2.2, the rest of what moved in the SDD beneath the settled FDR.

---

## 1. Open issues — behavioural questions with no answer yet

None.

## 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override

### 2.1 R-133, PD-18 and one acceptance row state a macOS floor of 14, and the owner raised it to 26.0
- **Drafted into the FDR:** the lean this item carried, at v11, because `docs/SDD.md` v48 § 4 C-R5 now states the floor as
  26.0 (RN-36). R-133 reads *The product runs on macOS 26 or later, and the floor is stated wherever the install
  path is offered* (`docs/fdr.md:L257`); PD-18's middle clause reads *the minimum version is macOS 26* (`:L292`);
  and the example row reads *A stranger with a stock macOS 26 machine* (`:L398`). No release name rides beside the
  number, because C-R5 names none. The traces stand, each marked *upstream moved — RN-36*. PD-40 does not move
  (`:L314`). *(Until v11 this line read: "nothing — the run that raised this writes no document", followed by
  the same lean with the v10 locators `:L250`, `:L285`, `:L389` and `:L307`.)*
- **Rationale:** The owner's decision, and its cause outside the product. GitHub retires the
  `macos-14` runner image on 2026-11-02, and jobs on it fail during brownout windows before then —
  the next six are Oct 16, 19, 23, 26, 29 and 30, each 14:00 UTC to 00:00 UTC the next day
  (https://github.blog/changelog/2026-10-01-github-actions-macos-14-runner-image-retirement/, read
  2026-10-13). The replacements it names are `macos-15` and `macos-26` (as `macos-latest`); there is no
  macOS 14 image after that date, so CI could no longer run the app on a floor of 14. The owner chose
  to raise the floor to what CI and the maintainer's own Mac run — the `macos-26` image is macOS 26.6.2
  (25G83) (https://github.com/actions/runner-images/blob/main/images/macos/macos-26-arm64-Readme.md,
  read 2026-10-13), and `sw_vers` on the maintainer's Mac prints the same, 2026-10-13 — so the floor is
  26.0 and the walk runs on it (`ka-reader@821a163:docs/SDD_open_issues.md` § 5.1, *Why the floor
  moves with the runner*). KA-Reader is before 1.0.0, so the raise is not a breaking change under
  PD-40's own terms (`docs/fdr.md:L314`, "From 1.0.0 …") and SDD § 4 C-R5's ("Raising it after 1.0.0",
  `docs/SDD.md:L643-L644`). This item is raised before the SDD has folded, rather than after, because
  R-133 is the line a change request is validated against (`<CORE>/roles/CROSS_ROLE.md` § 1): a change
  that writes `26.0` into the bundle's plist, cut while R-133 still says 14, returns
  `fdr-update-needed` and waits on this seat — a round the retirement date leaves no room for.
- **If overridden:** If the three entries stay at 14, the FDR contradicts the SDD the moment the fold
  lands, and the change that moves CI off `macos-14` cannot be cut in scope: raising the floor is
  what makes CI's run a run on the floor, and the alternative — floor at 14, CI on `macos-15` or
  `macos-26` — was before the owner and not taken (the same § 5.1). If the owner's number were to
  change (15 rather than 26), the three entries move to that number and nothing else here changes.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

### 2.2 The SDD moved from v20 to v48 under the settled FDR, and v11 re-derives against it
- **Drafted into the FDR:** the fold `docs/fdr.md` RN-36 records, beyond § 2.1's floor. Seven rules are added and
  one is reworded; no other rule, product decision, exclusion or example changes its words.
  - **R-185** — a file is ignored, for R-153, only where an ignore rule inside the viewed folder ignores it. A file
    only the user's global ignore file hides is untracked: marked in the tree and listed in the Git view.
  - **R-186** — a repository another user of the machine owns is not read; the Git view presents a failure state.
  - **R-187** — a repository, or a submodule inside it, that names a location outside the folder in its
    configuration, an included configuration file, its alternate object stores or its submodule definitions is not
    read. The Git view says it names a location outside the folder, and nothing there is read.
  - **R-188** — where that location is in a form the product does not locate, the failure state says so and does
    not say *outside*.
  - **R-189** — submodule definitions that give a submodule path another location inside the folder stop the read,
    and the Git view says so.
  - **R-190** — submodule definitions that are present and cannot be read stop the read, and the Git view says so.
  - **R-191** — the Git view's four elements (R-65) come from one read or a failure state replaces them; never some
    beside a failure, never a list with a submodule's entries left out.
  - **R-38** — it read *"shows the file's name and the letter's meaning in words"*. It now reads *"while the
    product's window is the key window, shows the row's name — the file's or the folder's — and the letter's meaning
    in words"*.
  - Two example rows: a repository cloned with `git clone --shared` from outside the folder, and a file hidden only
    by the global ignore file.
  - **Left as written:** R-35 and R-37 say *file*, though a folder row carries a status letter for a submodule whose
    commit moved or a nested repository (`docs/CONTENT.md` RN-37). Git reports either as a changed entry, so R-35
    reaches them, and the words stay.
- **Rationale:** An upstream document that moved under a settled FDR is a source of a delta, and the delta is
  surfaced rather than only applied. Each rule is *from* `docs/SDD.md` v48, and RN-36 names the passage behind each.
  The global ignore file and the repository another user owns follow from § 3 `git-reader` and `core-bridge`.
  Those parts switch the machine-level Git configuration off, so neither is read. The SDD names both as following
  from R-101 and names R-153's *an ignored file* as this seat's to carry (`docs/SDD.md` RN-87). The refusals are
  § 3 `git-reader` and § 4 C-D3 (`docs/SDD.md` RN-99 – RN-103, RN-105, RN-106), and the whole-or-nothing Git view
  is § 3 entity `GitState`. The tooltip's row and key window are § 3 `surfaces` and § 4 C-E8 (`docs/SDD.md`
  RN-95, RN-98). Each SDD fold that built a refusal said *`docs/fdr.md` do not move*, because R-101 is what the
  checks hold. This run states them anyway, and that is reasoning: R-101 says what is not read, not what the reader
  then sees. A QA seat reading R-101 alone cannot tell that a repository `git status` reads in a terminal shows a
  failure state here. R-21 is the precedent for stating a Git-view failure state the SDD names. The rules state the
  input condition and what the Git view says it observed. They name no mechanism, and the sentences stay
  `docs/CONTENT.md`'s (R-88).
- **If overridden:** If the owner wants no rule beyond R-101 for the refusals, R-187 – R-191 and the `--shared`
  example row are removed; R-101, R-85 and R-88 then carry those cases unnamed. If the owner wants the global ignore
  file or another user's repository read, that is R-101 moving, and an owner call on the SDD first:
  `docs/SDD.md` RN-87 says the reads lie outside the grant. R-185 and R-186 would then be withdrawn, and R-153's
  example row would gain the global case. If R-38's key-window clause is judged design detail the FDR does not
  carry, it reads *"Resting the pointer on a status letter shows the row's name — the file's or the folder's — …"*,
  and `docs/DESIGN.md` § Components holds the window rule alone. If R-35 and R-37 are to say *row* rather than
  *file*, both are reworded and no other entry moves.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item raised against the FDR after it settled

None.
