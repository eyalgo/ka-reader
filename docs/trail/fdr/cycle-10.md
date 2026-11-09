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

---

## 1. Open issues — behavioural questions with no answer yet

None.

## 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override

### 2.1 The FDR now knows the beta: the theme rules wait for 1.0.0, and the read-at-open state has its own rules

> A `companion-self-answer` run raised this on 2026-11-09 as § 2.2 of the cycle now in
> `docs/trail/fdr/cycle-9.md`, with its reasoning at `docs/trail/fdr/self_answer-9.md` § 2.2. That
> item was unanswered. This `product-fdr` run made the fold it proposed, because an upstream change
> is a legitimate source of a delta, and brings the fold here for you to confirm. The record is
> `docs/fdr.md` RN-40.

- **Drafted into the FDR (v14):**
  1. **Themes.** R-105 takes `docs/SRS.md` FR-20's words: both themes and the kept choice are in place
     before 1.0.0, and a release below 1.0.0 is not held to them. R-27, R-106, R-107, R-108 and R-110
     now hold *where the release offers the theme choice*. R-107 adds that a release without the
     choice carries no theme control.
  2. **The read-at-open state** — where Git state is read once, when the folder is opened, and not
     followed. R-192: the Git view and the tree's markers say so, in the one wording
     `docs/CONTENT.md` § Terminology, *Standing sentences*, fixes in its beta row. The rule points at
     that row and quotes none of it. R-193: the statement is absent where Git state is followed and in
     a plain folder. R-194: a change to Git state after open changes nothing either surface shows, and
     a repository created at the root after open is not followed. R-195: a Git-view failure or fault
     seen at open stands until the folder is opened again, and nothing promises it will clear.
     R-18, R-72, R-74 and R-81 point at these rules. R-18 and R-74 say their Git half is in place
     before 1.0.0.
  3. **The release.** R-197: where a release reads Git state at open, the README's known gaps say
     so (SRS AC-14). R-198: the repository goes public with its own commit history, once that history
     is checked for anything private (SRS C-12).
  4. **From the SDD (v58 – v82).** R-196: a Markdown code block is highlighted only when it is
     fenced and its fence names a floor language by its first word. An indented block is plain.
  5. **Examples.** Two rows are added, one for the read-at-open state and one for a release without
     the theme choice. The `git init` row and the dark-appearance row each gain the condition they
     depend on.
- **Rationale:** R-105 was false. It promised both themes "from the first release", but the first
  public release is now a beta that SRS FR-20 does not hold to them. The SRS made FR-35 and AC-26 a
  state and not a release, so the FDR follows that and still names no delivery. That the beta comes
  first, and what it waits for, lands as no entry: SRS § 2 says "Which requirements a release meets
  is delivery, not this document's". R-195 is derived. In that state nothing reads Git state again,
  so "recovers on a later refresh" would be false. `docs/UXD.md` UX-S3 and UX-I16 draw the same. The
  UXD and CONTENT were read for collisions and none was found. The rest of the SDD moves are mechanism
  or route: the watcher's placement, live refresh cut in three, the harness rows. A link to a folder
  is now inert, and R-62 already covers that. RN-40 lists every source and commit.
- **If overridden:** for any part you reject, that part goes back to its v13 wording. If you reject
  part 1, R-105 again holds the beta to both themes, against SRS FR-20 and PRD v18. A change spec for
  the beta then comes back `fdr-update-needed`. If you reject part 2, the FDR says nothing about the
  beta's statement, and R-18, R-72 and R-74 forbid a build that reads Git state once. Parts 3 – 5 can
  each be dropped alone. R-196 is the one rule that does not come from the beta.
- **Confirm or override:** confirm, with three additions — decided in the owner's seat by a `companion-self-answer` run; reasoning at `docs/trail/fdr/self_answer-10.md` § 2.1. All five parts stand as drafted: each matches its source (SRS v15 FR-20, FR-35, AC-26, AC-14, C-12; CONTENT v15's beta row; UXD v13 UX-I9, UX-S2, UX-S3, UX-I16; SDD § 3 `markdown-renderer`). (1) R-197 says what the README's known gaps state but not in which words. CONTENT v15 says the known gaps carry the beta's standing sentence word for word, so R-197 points at that row, as R-192 does, and quotes none of it. Its second half, about a repository created after open, has no row, so it is written with the README to CONTENT's rules. (2) The example row "Version 0.4 is launched over own state written by version 0.5" still says "the theme follows the platform". Both versions are below 1.0.0, where FR-20 no longer promises both themes, so the row gains the condition "in a release that offers both themes", as the dark-appearance row did. (3) RN-40's "What is left for others: none found" is no longer true. The NFDR has not seen the beta. QC-44 lists six standing sentences, not CONTENT's seventh, and nothing checks AC-14's known-gaps line or C-12's history check. That is raised at `docs/architecture_open_issues.md` § 2.1 (`ka-reader@316e337`), and RN-40 says so.

## 3. Raised from downstream — an item raised against the FDR after it settled

None.
