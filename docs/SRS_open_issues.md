# SRS open issues — ka-reader

> Companion to `SRS.md`. The CTO authored the SRS non-interactively; this file holds
> what it could not settle from the inputs (the PRD and any context/constraints).
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this
> file**, then re-run `product-srs`. It folds your answers into the SRS and drops the
> resolved items. When nothing is left open, `product-srs` **deletes this file**: no file =
> the SRS is done.
>
> Your answers are never thrown away. Each time the CTO folds them in, it first copies this
> file whole to `docs/trail/srs/` — so what you decided, and why, stays readable and citable
> for good.
>
> **§§ 1–2 are the CTO's own questions; § 3 is somebody else's.** A seat reading the SRS long after
> it settled can find a gap the authoring run had no way to see, and § 3 is where it says so.

> **No `product-srs` run wrote this file.** A `companion-self-answer` run opened it on 2026-11-06,
> in the CTO's seat, while answering `docs/SDD_open_issues.md` item 2.5 — the SDD at v68 follows
> PRD v18 past a first-release clause the SRS still states. `SRS.md` is Settled at v13 and its
> companion was correctly deleted; it is re-opened because the PRD reached v17 and v18
> (`ka-reader@ce9ba62`, `ka-reader@d1ea3ac`) after v13 was authored against PRD v16, and the SRS
> has no other channel: with no companion on disk a `product-srs` re-run reads the document as
> done and has nothing to act on. The reasoning is in `docs/trail/sdd/self_answer-75.md`
> § *Companions opened* and § 2.5.

---

## 1. Open issues — technical questions with no answer yet

None.

## 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override

### 2.1 FR-20 and AC-11 say "from the first release"; PRD v18 places the theme after the first public release, a beta — the SRS has not seen PRD v17 – v18
- **Drafted into the SRS:** nothing — this run writes no document. Proposed, for the `product-srs`
  run that folds this item, reading PRD v18 whole: (1) FR-20 drops "from the first release" and
  reads that both themes are in place before 1.0.0 — the PRD keeps "dark and light themes from the
  start" in § UX Notes and qualifies it in § Scope (In): the first public release is a beta below
  1.0.0 that "waits for nothing else ... not for choosing a theme and keeping that choice", and the
  theme is "in place before 1.0.0"; AC-11 follows — both themes present and usable at 1.0.0 and at
  every release from the one that ships them, and C-6's pre-1.0.0 statement covers a beta that
  ships without them. (2) The header's *Inputs read* and the Version line say the SRS has read PRD
  v18; C-4 ("MIT at first release"), C-7 and AC-14 ("before the first public release") stand —
  the beta is the first public release for all three. (3) The `product-srs` run decides, in the
  same fold, whether the beta's statement — "the Git view and the tree's changed-file markers say
  plainly that they show the Git state read when the folder was opened, and the README's known
  gaps say the same" (PRD v18 § Scope (In), *The first public release — a beta*; § UX Notes "the
  view never lies", the beta's case) — is a requirement this document carries (a clause on FR-14's
  Git half with an acceptance criterion, traced to those two PRD sites) or a release condition left
  to the SDD, which carries it at § 6 S-7. This run's lean: carry it — it is a behaviour a shipped
  surface shows, with a PRD source, and § 2's rule keeps delivery *timing* out of this document,
  not a behaviour the PRD names for a named release.
- **Rationale:** `docs/SRS.md` v13 FR-20 (`:L278-L279`, "from the first release") and AC-11
  (`:L552`, "from the first release") trace to PRD § UX Notes "dark and light themes from the
  start", read at PRD v16. PRD v17 (`ka-reader@ce9ba62`) and v18 (`ka-reader@d1ea3ac`,
  owner-confirmed at `docs/trail/prd/cycle-16.md` § 3.1) add § Scope (In) *The first public
  release — a beta*: the first public release comes once the tree and the open file follow the
  disk and Markdown reads rendered, and not after the theme. The SRS's "first release" and the
  PRD's are no longer the same release, and the SRS derives from the PRD. The SDD at v68 already
  takes the PRD's word: its § 7 edge `first-public-release` → `choose-a-theme` is withdrawn and
  FR-20 and AC-11 are cited "as v13 states them", their first-release clause recorded as
  contradicted (`docs/SDD.md` § 10 RC-8; § 12, the SRS boundary — "the first SRS gap this document
  has raised"). No other SRS site says "first release" in a way the beta moves: C-4 and C-7 bind
  the first public release, which the beta is.
- **If overridden:** FR-20 and AC-11 keep "from the first release" and the SRS contradicts the PRD
  it derives from; the SDD keeps citing them as contradicted, and the seed cut from
  `first-public-release` is held to a theme the PRD says the beta does not wait for. An override
  that keeps the clause is a PRD change — the CPO's run, not this document's.
- **Confirm or override:** confirm — with four additions for the fold. (1) **FR-20 is narrowed,
  not emptied.** What PRD v18 moves past the beta is *choosing a theme and keeping that choice*
  (§ Scope (In); the owner's words at `docs/trail/prd/cycle-16.md` § 3.1: "theme choice ... come
  after it"), while § UX Notes still says "dark and light themes from the start". So FR-20 drops
  "from the first release", keeps its trace to "from the start", and says that the user's choice
  between the two themes, kept between sessions (FR-21), is in place before 1.0.0. The beta is not
  held to the themes at all: cycle-62 § 1.1 says nothing but the tree and the open file following
  the disk and Markdown reading rendered comes before it. AC-11 follows, as drafted. The basis for
  the beta shipping without them is § Scope (In) itself. The draft's appeal to C-6 does not carry
  that weight, because C-6 says only that anything may change before 1.0.0. (2) **Carry the beta's
  statement**, as the draft leans, and word it as a system state rather than a release, the way
  RN-37 worded FR-13: where Git state is read once, when the folder is opened, and not followed,
  the Git view and the tree's changed-file markers say plainly that they show the Git state read
  at open. Trace it to § UX Notes, "the view never lies" (the rule sentence and its beta bullet),
  and to § Scope (In). Give it its own acceptance criterion. Put the README's known-gaps line in
  AC-14's release inspection, with C-9. The criterion is bounded by FR-34: in a plain folder the
  Git view stays empty, and the statement does not appear there. One case is named and left
  uncovered on the surface: in that read-at-open state, a repository created at the folder's root
  after it is opened is not followed (FR-33's live clause). Only the README's known gaps tell the
  user about it. FR-14's Git half, FR-33's live clause and AC-7's Git clauses remain v1
  requirements, met before 1.0.0. (3) **The draft answers a smaller question than its heading.**
  PRD v17 – v18 also adds § Assumptions "Public identity": the repository goes public with its own
  commit history, and only after that history has been checked for anything private. The fold
  carries this as a C-12 clause with an AC-14 inspection, on C-7's footing, because both bind the
  repository before the first public release and both can be checked at release. The beta's
  "to be used and shown" purpose produces no requirement. (4) The header, the Version line and a
  reverse walk of PRD v16 → v18 record all of the above. C-4, C-7 and AC-14's existing clauses stand
  as drafted. Reasoning: `docs/trail/srs/self_answer-4.md` § 2.1.

## 3. Raised from downstream — an item from a seat that did not write the SRS

None.
