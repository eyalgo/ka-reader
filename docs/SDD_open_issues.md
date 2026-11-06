# SDD open issues — ka-reader

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

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

### 2.2 The SDD's first public release has not seen PRD v18 — the repository goes public with its own history, after a privacy check

> **No `product-sdd` run raised this item.** A `companion-self-answer` run raised it on 2026-11-06,
> while reading `docs/PRD.md` (v18, `ka-reader@d1ea3ac`) against `SDD.md`. Its reasoning is in
> `docs/trail/sdd/self_answer-74.md` § *Raised on this document*. The `product-sdd` run of
> 2026-11-06 (SDD v68) drafted the proposal into the SDD and left this slot open; the item as it
> stood before that run is at `docs/trail/sdd/cycle-62.md` § 2.2.

- **Raised by:** CTO — 2026-11-06
- **Seat:** cto
- **Drafted into the SDD:** at v68, § 6 S-7 `first-public-release`: *Delivers* says the repository
  is public with its own commit history, checked for anything private first; *Reached when*'s
  command half names the check as a release condition in two halves — `gitleaks git` exits 0 as
  the secrets half, and a person's read of `git log -p` over every commit HEAD reaches as the
  "anything private" half, its result written on the release page as text a reviewer reads before
  the repository is made public — and names the publication form: `git rev-list --max-parents=0
  HEAD` on a fresh clone of the public repository prints the same root commit as the private
  checkout; *Traces to* adds § Assumptions "Public identity", the history clause (v18). § 12's PRD
  boundary pins the PRD at v18. RN-129 records the draft.
- **Rationale:** *something upstream moved and the SDD had not seen it.* PRD v18 adds the clause
  after item 1.1 was written (`ka-reader@d1ea3ac`; the item's last edit `ka-reader@cb25715`), and
  the clause is owner-confirmed (`docs/trail/prd/cycle-16.md` § 3.1). A `first-public-release`
  seed cut from S-7 without it would not know that the repository's history is published and
  must be read first. The mechanism already in S-7's bar — `gitleaks git` over the full history —
  shows the SDD half-anticipated it; what was missing was the publication form and the check as a
  stated condition, and v68 states both. The person's read is a release condition and not a
  command because no command finds a private name, path or message.
- **If overridden:** the two clauses leave S-7; the bar keeps `gitleaks git` alone and says
  nothing of the history being published or read; the seed cut from it inherits the gap.
- **Confirm or override:** confirm — with three additions for the fold, all on S-7's command half: (1) the
  person's read and the `gitleaks git` scan cover every ref the public remote will hold, not only the
  commits `main`'s HEAD reaches — `git ls-remote --heads --tags origin` lists ten branches beside `main`
  today, and a repository made public publishes all of them — or those refs are deleted before
  publication and the release page says which; (2) the release page names the commit the read reached,
  and the public repository's `HEAD` at publication is that commit, so a commit landing after the read
  reopens the condition; (3) a finding is taken out of the history before publication, the read is
  repeated on the rewritten history, and the root-commit comparison is made against the checkout that
  repeated read passed on. The reasoning is in `docs/trail/sdd/self_answer-75.md` § 2.2.

### 2.3 Live refresh is three slices — `follow-the-file` is cut from `follow-the-folder` — and the CPO's fields of both are drafted
- **Raised by:** CTO — 2026-11-06
- **Seat:** cpo
- **Drafted into the SDD:** § 6 S-6 `follow-the-file` (new): *Delivers* — the open file's content
  follows the disk in place with the reading position kept, a deleted file is said to be gone with
  its name kept and none of its content shown as current, and a readable file again replaces the
  gone state without ceremony; *Not in this slice* — Git state following the disk, the markers,
  the row-order migration, `git init` and `.git` removal, the full churn scene, the first latency
  measurement and the built-bundle retention proof, all `follow-the-folder`; *Moves toward* — the
  first condition's live refresh, open-file half, and the beta's own condition. § 6 S-8
  `follow-the-folder` narrowed: *Delivers* — Git state following the disk, the Git view and the
  markers, and the beta's statement withdrawn from both surfaces and from the README's known gaps;
  *Not in this slice* — the open file's own refresh, re-walked as regression and not delivered
  there. § 5 step 4's E-5 sizing and § 10 RC-8 record the cut; § 7 carries three new `depends_on`
  rows and one `supersedes` row for it.
- **Rationale:** your answer at `docs/trail/sdd/cycle-62.md` § 1.1 places the beta "ahead of the
  Git half of live refresh", and PRD v18 places it once "the tree and the open file follow the
  disk" (§ Scope (In)). The slice that owned the open file and Git together (RC-7's
  `follow-the-folder`) could land on neither side of a release that waits for one and not the
  other — step 4's too-broad case — so the cut is forced by the placement; what is yours is the
  slicing itself (step 4) and the fields the table gives the CPO. The Git half keeps the slug
  because every obligation recorded against `follow-the-folder` downstream (`docs/nfdr.md`, twelve
  references at v77) is Git's — the marker and row-order migration, the churn and retention proofs.
  No alternative cut passes the four tests and the PRD: keeping one slice puts the beta after Git
  follows the disk, which v18 rules out.
- **If overridden:** the two blocks merge back into one `follow-the-folder` owning the open file and
  Git, and `first-public-release` then waits for the Git view to follow the disk — a PRD change,
  which is the CPO's own run to make, not this document's.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

### 2.4 The beta's statement — "the Git state read when the folder was opened" — on the Git view and the tree's markers: S-7's observable half is drafted, and the UXD does not yet draw it
- **Raised by:** CTO — 2026-11-06
- **Seat:** cdo
- **Drafted into the SDD:** § 6 S-7 `first-public-release`, *Reached when*, the observable half:
  switching the sidebar to Git, the view and the tree's changed-file markers say plainly — in words
  on the surface, not by colour or a tooltip alone (UX-A2) — that they show the Git state read
  when the folder was opened, and the README's known gaps say the same; where the statement sits
  is left to the UXD and its words to `docs/CONTENT.md`. § 6 S-8 `follow-the-folder` withdraws it:
  no surface says so once the Git view follows the disk. *Traces to* on S-7 names UX-I4 and
  UX-I13 as the invariants the statement keeps true.
- **Rationale:** PRD v18 requires the statement ("In the beta, the Git view and the tree's
  changed-file markers say plainly that they show the Git state read when the folder was opened,
  and the README's known gaps say the same", § Scope (In); the beta's case under § UX Notes "the
  view never lies"). `docs/UXD.md` v12 carries no such case: UX-I4 (`:L259-L261`) says stale
  content is never presented as current, UX-I13 (`:L309-L314`) that no indicator is drawn before
  its state is observed, and the UX-S3 row draws the Git view's cells with no "read at open"
  state. A UXD revision is your own run (`product-uxd`), never this document's; this item asks
  only whether the bar as drafted is the one S-7's seed closes against until the UXD draws the
  statement.
- **If overridden:** S-7's observable half drops the sentence and the beta's statement has no bar
  in this document until the UXD carries it; the `supersedes` row on S-8 goes with it.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

### 2.5 The SRS's FR-20 and AC-11 say "from the first release"; PRD v18 places the theme after the first release — the SDD follows the PRD, and the SRS is owed a revision
- **Raised by:** CTO — 2026-11-06
- **Seat:** cto
- **Drafted into the SDD:** the § 7 edge `first-public-release` → `choose-a-theme` ("Both themes
  are a first-release requirement (FR-20, AC-11)") is removed; § 5 step 3's E-7 bullet, step 4's
  E-1 and E-6 entries, S-7's *Why here in the order* and S-9's *Traces to* and *Why here in the
  order* each say that FR-20 and AC-11 are cited as v13 states them and that their first-release
  clause is contradicted by PRD v18; § 12's SRS boundary records it as the first SRS gap this
  document has raised. Nothing else that traces to FR-20 or AC-11 moves.
- **Rationale:** `docs/SRS.md` v13 FR-20 (`:L278-L279`) — "The system offers a dark and a light
  theme from the first release" — traces to PRD UX Notes "dark and light themes from the start",
  and AC-11 (`:L552`) covers it. PRD v18 keeps that UX Notes sentence and adds, in § Scope (In),
  that the first public release "waits for nothing else: not for the Git view to follow the disk,
  and not for choosing a theme and keeping that choice" — so the SRS's "first release" and the
  PRD's are no longer the same release. The SRS derives from the PRD, and the SDD takes the PRD's
  word over a derived clause the PRD has since moved past; the repair is a `product-srs` run
  folding v18 — FR-20 and AC-11 re-said as in place before 1.0.0, with C-6's pre-1.0.0 statement
  covering the beta's missing theme. C-4 ("MIT at first release") and C-7 ("before the first public
  release") are unaffected: the beta is the first public release for both.
- **If overridden:** the edge returns and the beta waits for the theme, contradicting PRD v18 — an
  override here means the PRD moves, which is the CPO's.
- **Confirm or override:** confirm — the SDD follows the PRD, and the SRS half is now raised rather than
  named: `docs/SRS_open_issues.md` § 2.1, opened by this run at `ka-reader@dfc3607`, carries FR-20 and
  AC-11 re-said as in place before 1.0.0, with C-6 covering the beta, for a `product-srs` fold reading
  PRD v18. One correction to this item's text, for the fold and not for the slot: step 4's E-6 entry
  does not carry the sentence the item says it does; E-1's does. The reasoning is in
  `docs/trail/sdd/self_answer-75.md` § 2.5.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

None.
