# CONTENT open issues — ka-reader

> Companion to `CONTENT.md`. The Content Manager authored the verbal language non-interactively;
> this file holds the calls it made and wants your sign-off on — each with the reason behind it,
> and what moves underneath it if you override — plus the few things it genuinely could not
> settle.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**,
> then re-run `product-content`. It folds your answers into `CONTENT.md` and drops the resolved
> items. When nothing is left open, `product-content` **deletes this file**: no file = the verbal
> language is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git refuses
> to remove a file with uncommitted edits in it — so an uncommitted answer stops that run before
> it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the Content Manager folds them in, it first copies
> this file whole to `docs/trail/content/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 comes from outside this run.** The verbal language is read by everyone who writes a string,
> and a seat downstream can find a pattern it has no rule for. It is recorded there, answered here,
> and folded by the same run.

> **No `product-content` run wrote this file.** A `companion-self-answer` run opened it on
> 2026-11-06, in the CDO's seat, while answering `docs/SDD_open_issues.md` item 2.4 — the PRD at
> v17 – v18 requires that in the beta the Git view, the tree's changed-file markers and the README's
> known gaps say plainly that they show the Git state read when the folder was opened, and the SDD
> at v68 (§ 6 S-7, S-8) closes on "the sentence `docs/CONTENT.md` fixes" for it. `CONTENT.md` is
> Settled at v14 and fixes none; its companion was correctly deleted, and it is re-opened because
> the PRD moved after v14 was authored and the document has no other channel: with no companion on
> disk a `product-content` re-run reads it as done and has nothing to act on. The reasoning is in
> `docs/trail/sdd/self_answer-77.md` § 2.4 and § *Companions opened*.

---

## 1. Open issues

None.

## 2. Choices to confirm

### 2.1 The beta's statement — the Git view and the tree's markers show the Git state read when the folder was opened — is a stated limit on three surfaces, and this document fixes no wording for it
- **Written into CONTENT.md:** nothing — this run writes no document. Proposed, for the
  `product-content` run that folds this item, reading `docs/PRD.md` at v18 (`ka-reader@d1ea3ac`)
  and `docs/UXD.md` at the version that draws the statement (`docs/UXD_open_issues.md` § 2.1,
  opened by the same run): one row in § *Standing sentences* — the beta's Git view
  (`docs/PRD.md` § Scope (In), *The first public release — a beta*) — with one wording that the Git
  view, the tree's markers and the README's known gaps all carry verbatim, and a retirement clause
  like the before-1.0.0 row's: retired the day the Git view follows the disk
  (`docs/SDD.md` § 6 S-8), with nothing written in its place. A § *Traceability* row for the beta
  state of UX-S3 and UX-S2 follows once the UXD names it. The wording is this seat's; the rules it
  meets are already this document's — *KA-Reader* as the subject of what the tool did, simple past
  for what it observed (*read when you opened the folder* is an observation), present for what is
  true now, no future tense and no softening, sentence case (§ Grammar and mechanics). A draft to
  write against, not to copy: *"The Git view and the changed-file markers show the Git state
  KA-Reader read when you opened the folder. They do not follow later changes."*
- **Grounds:** the PRD's requirement (`docs/PRD.md:L327-L329`; `:L261-L263`; owner-confirmed at
  `docs/trail/prd/cycle-15.md` § 3.1) and the SDD's bar on it: S-7's command half closes on "a
  `grep` of `README.md` for the sentence `docs/CONTENT.md` fixes", and S-8's on "the entry
  `docs/CONTENT.md` names for the beta's statement, once it names one" (`docs/SDD.md` § 6 S-7, S-8
  *Reached when*). `grep -c 'read when the folder was opened' docs/CONTENT.md` prints 0 at
  `ka-reader@796f7df`. § *Standing sentences* is the table for exactly this — "a promise or a stated
  limit that appears on more than one surface", with one wording — and this limit appears on three.
- **What moves if you override:** no sentence exists for the README's known gaps or for the two
  surfaces, so the beta's seed either writes one at the change — a published string with no
  standard behind it, which the Developer may not write (`<CORE>/roles/CROSS_ROLE.md` § 2) — or
  S-7 cannot close. Nothing else in the document derives from the row.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write the verbal language

None.
