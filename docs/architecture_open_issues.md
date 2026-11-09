# Architecture open issues — KA-Reader

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the SRS, the SDD
> and the FDR.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-architecture`. It folds your answers into the records and drops the resolved items.
> When nothing is left open, `product-architecture` **deletes this file**: no file = the records are
> done.
>
> Your answers are never thrown away. Each time the Principal Architect folds them in, it first copies
> this file whole to `docs/trail/architecture/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 is raised, not asked.** These records bind every later change, so the seats that live under
> them find gaps the authoring run could not. § 3 is where such a seat says so, against both records
> — an ADR's binding and an NFDR obligation reach the same file.

> **No `product-architecture` run wrote this file.** The PM opened it on 2026-11-09, reading the
> settled NFDR (v90) against the product at `ka-reader@75fe66c`, where `checks/notices.sh` reads each
> resolved package's licence files and fails on a copyright line the notices lack, and against the
> settled PRD v19. Two items follow in § 3; neither record is edited.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-41 says no check holds the copyright lines; `checks/notices.sh` and its suite now hold them at every change and at a tag
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR QC-41, its *verified by:* tail; its § 10 row; and § 10's list of review gates
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; QC-41 names `development-design` reading the entry as the copyright lines' gate "until it lands", and the check has landed, so the record states a gate the product no longer relies on and leaves unnamed the one it does.
- **Where it shows:** `docs/nfdr.md:L1632-L1637` ("One rule is owed to a check and held by none at `ka-reader@b503b6d`: the copyright lines, owed to `checks/notices.sh` … Until it lands, `development-design` reading this entry is that rule's gate"); the § 10 row, `:L3353` ("`checks/notices.sh` extended to the copyright lines — not held at `ka-reader@b503b6d`"; *Gated at* "`development-design` reading the entry (the copyright lines, until its check holds them)"); and the review-gate list, `:L3377` ("QC-41 (the copyright lines, until its check holds them)"). At `ka-reader@75fe66c`, `checks/notices.sh` 1.1.0 reads each resolved package's licence files and fails on a copyright line the notices lack, run by the gate's *Notices check* and *Notices check suite* steps (`checks/gate.sh:L129-L130`) and so by the release workflow's *Test gate*; `checks/notices.sh` exits 0 on that tree and its suite passes. What the check does not read stays with review and release inspection: the libraries' and the icon set's copyright lines, any `NOTICE` file whole, and the sentences saying a component has no licence file or no copyright line.
- **If a document has to be written:** none — QC-41's tail, its § 10 row and § 10's review-gate list name the extended check as holding the crates' copyright lines, and keep review for the parts it does not read.
- **Answer:** Confirmed, with additions. QC-41's copyright-lines rule is held by a check now, so its tail, its § 10 row and § 10's review-gate list stop naming `development-design` reading the entry as that rule's gate. (1) The tail names `checks/notices.sh` 1.1.0 and its suite `checks/tests/test_notices.sh` as holding two rules — every name `cargo tree` reports, and every copyright line the licence files of each package in that name set state, carried in that component's entry — run by the gate's *Notices check* and *Notices check suite* steps (`checks/gate.sh:L129-L130` at `ka-reader@75fe66c`) at every change and, through the release workflow's *Test gate*, at a tag; the "One rule is owed to a check and held by none at `ka-reader@b503b6d`" sentence becomes a dated reading in the entry's usual *(through v90 …)* form. (2) What the check does not read stays named, at release inspection, as the script's own header states it (`checks/notices.sh`, *WHAT IT HOLDS, AND WHAT IT DOES NOT*): the libraries' and the icon set's copyright lines (a licence file below a package's root is not read), any `NOTICE` file whole, the sentences saying a component has no licence file or no copyright line, and each licence as the component declares it. (3) The § 10 row drops "`checks/notices.sh` extended to the copyright lines — not held at `ka-reader@b503b6d`" and its *Gated at* drops the `development-design` clause and keeps release inspection for that residue; § 10's list reads QC-41 (the libraries' and the icon set's copyright lines, `NOTICE` files, the no-licence-file and no-copyright-line sentences, and each licence as declared). Measured this run on a clean clone at `ka-reader@2ee1ef7`, whose tree outside `docs/` is `75fe66c`'s: `checks/notices.sh` exits 0, its suite exits 0 with 42 cases `ok`, and with one copyright line deleted from `THIRD_PARTY_NOTICES.md` the check exits 1 naming the line; § 9's suite count, twenty-three, is unchanged. Reasoning: `docs/trail/architecture/self_answer-85.md` § 3.1.

### 3.2 QC-71 checks every ref of one repository made public; PRD v19 publishes only the main line's history from a private `ka-reader-dev` into the public repository
- **Raised by:** PM — 2026-11-09
- **Which record:** NFDR QC-71, and its § 10 row
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** QC-71's check set is the private repository's refs: measured today, `origin` is `<owner>/<repository>-dev` and `git ls-remote --heads --tags origin` lists 11 refs, the branches v19 keeps private; and the public repository is to receive the main line by a push, not be made public.
- **Where it shows:** `docs/nfdr.md:L1691-L1700` (QC-71: "made public with its own commit history … every ref the public remote will hold — the set `git ls-remote --heads --tags origin` lists") and `:L3356` (its § 10 row), against `docs/PRD.md:L420-L430` (v19 § Assumptions **Public identity**) and `docs/trail/prd/cycle-17.md` § 3.1, which names QC-71 and QC-28 among what the split reaches.
- **If a document has to be written:** none — QC-71 names the set the public repository receives, the main line's history at its first push, and the root-commit comparison against it.
- **Answer:** Confirmed, with additions. QC-71 and its § 10 row move to the two repositories that PRD v19, SRS v16 C-12 and AC-14, FDR v16 R-198 – R-203 and SDD v85 § 6 S-7 now all state; the entry still reads one repository made public, and its check set, `git ls-remote --heads --tags origin`, is today the private repository's 11 refs (`origin` is `<owner>/<repository>-dev`, measured this run). The PM's proposal — the set the public repository receives, the main line at its first push, the root-commit comparison — is right and covers the first release alone; QC-71 traces to AC-14, whose v16 clauses it would otherwise drop, so it carries all of S-7's checkable form: (1) **The set** is exactly the commits the public repository is to receive — the whole of `ka-reader-dev`'s `main` at first publication, `<public main>..<dev main>` at each later release — and never the private repository's refs. (2) **The secrets half** is QC-28's *Secret scan* as built (`checks/secret-scan.sh gitleaks git`, `checks/gate.sh:L71`), run at the commit to be sent and re-proved by `release.yml`'s *Test gate* at the tag in the public repository; the set and that step's reach are one history, so the "whether that step widens … is the delivery tier's" sentence closes with nothing widened, and QC-28 does not move. (3) **No other branch**, read on the public repository itself: before it is made public, `git ls-remote --heads --tags` on it lists `refs/heads/main` alone, and `main` moves there by a fast-forward push only — it is not empty today (SDD S-7: ten branches, a `main` behind the private one). (4) **The private half** stays a review gate — a person's read of `git log -p` over the commits to be sent, written on the release page naming the commit reached; that commit is the public `main`'s `HEAD`, and a commit landing on the private `main` after the read is not sent until read itself. (5) **A finding**: in a commit not yet public it is taken out in `ka-reader-dev`, the read repeated, and nothing is sent until it passes (R-202); the public history is never rewritten, and a finding in a commit already public is revoked and removed by a later commit. (6) **Never rewritten**: the public `main` refuses a force push and a deletion (`gh api repos/<owner>/<repository>/branches/main/protection` printing `false` twice, or the ruleset form), set after the visibility flip and before the first tag; from the second release on, `git merge-base --is-ancestor <previous release's tag> HEAD` exits 0 on a fresh clone. (7) The root-commit comparison stays as it is. Each command is the SDD's; QC-71 adds none. Reasoning: `docs/trail/architecture/self_answer-85.md` § 3.2.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
