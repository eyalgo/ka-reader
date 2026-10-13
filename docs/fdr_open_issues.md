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
> next run, and three entries here state the floor and trace to that passage. It holds one item,
> § 2.1; the reasoning is `docs/trail/sdd/self_answer-55.md`.

---

## 1. Open issues — behavioural questions with no answer yet

None.

## 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override

### 2.1 R-133, PD-18 and one acceptance row state a macOS floor of 14, and the owner raised it to 26.0
- **Drafted into the FDR:** nothing — the run that raised this writes no document. The lean, for the
  seat that folds it: R-133 reads *The product runs on macOS 26 or later, and the floor is stated
  wherever the install path is offered* (`docs/fdr.md:L250`, now "macOS 14 (Sonoma) or later");
  PD-18's middle clause reads *the minimum version is macOS 26* (`:L285`); and the acceptance row
  that begins *A stranger with a stock macOS 14 machine* reads *a stock macOS 26 machine* (`:L389`).
  Whether a release name rides beside the number is the fold's call; this run cites none. The traces
  on all three stand — SDD § 4 C-R5 and SRS § 7 C-11 — because C-11 names no number
  (`docs/SRS.md:L490`, "v1 runs on macOS and promises no other platform") and C-R5 is the passage
  the SDD's fold moves. PD-40 does not move: it prices the floor by naming R-133, not by its value
  (`:L307`). Nothing else in the FDR names the floor or the runner (`grep -n -E 'macOS 1[0-9]|14\.0|
  Sonoma|macos-14' docs/fdr.md` prints the three lines above and the v1 clause of the header's
  history, 2026-10-13).
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
  PD-40's own terms (`:L307`, "From 1.0.0 …") and SDD § 4 C-R5's ("Raising it after 1.0.0",
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

## 3. Raised from downstream — an item raised against the FDR after it settled

None.
