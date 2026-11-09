# SDD open issues — KA-Reader

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

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-11-09, reading the settled SDD
> (v84) against the settled PRD v19 and the repositories as they stand. One item follows in § 5; the
> SDD is not edited.

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

### 5.1 S-7's history check runs over every ref of one repository made public; PRD v19 publishes only the main line's history from a private `ka-reader-dev` into a public repository
- **Raised by:** PM — 2026-11-09
- **Seat:** cto
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** S-7's history check and publication step cannot be walked as the PRD now states them. Measured today, `origin` is `<owner>/<repository>-dev` (private, created 2026-11-09) and `git ls-remote --heads --tags origin` lists 11 refs, so the set S-7 names is the private repository's branches, which v19 keeps private; and `<owner>/<repository>` is still private (`gh api repos/<owner>/<repository> --jq .visibility` → `private`), to receive the main line by a push rather than be made public.
- **Where it shows:** S-7 *Reached when*, command half, `docs/SDD.md:L2745-L2763` ("every ref the public remote will hold — the set `git ls-remote --heads --tags origin` lists", "the repository is made public with that history and not re-initialised", citing "PRD v18 § Assumptions"), against `docs/PRD.md:L420-L430` (v19 § Assumptions **Public identity**). What v19 reaches downstream, including where the tag build runs, is `docs/trail/prd/cycle-17.md` § 3.1.
- **If a document has to be written:** none — S-7's history check names the set the public repository receives (the main line's history, by its first push) and its root-commit comparison against that push.
- **Answer:** Confirm, with additions, all on S-7's command half. **The set.** The history check runs over exactly the commits the public repository is to receive — at first publication the whole of the main line's history as `ka-reader-dev`'s `main` holds it, and at each later release the commits of that `main` not yet in the public `main` — never over the private repository's refs; `git ls-remote --heads --tags origin` is dropped as the set's definition and the 2026-11-06 count stays as dated history. **The target is not empty.** Measured on 2026-11-09, `<owner>/<repository>` — the address C-12 names, still private — holds the same ten branches as `<owner>/<repository>-dev` and a `main` 46 commits behind it, an ancestor of it; so "no other branch" is a condition read on the public repository itself, not assumed from a first push: before it is made public, `git ls-remote --heads --tags` on it lists `refs/heads/main` and nothing else, and `main` moves there by a fast-forward push. **The secrets half** is the gate's *Secret scan* as built — `checks/secret-scan.sh gitleaks git` over every commit `HEAD` reaches — run at the commit to be sent; the fork RN-131 left open closes, nothing widens, and the release workflow's *Test gate* on the tag re-proves it on the public repository, whose history is the set. **The private half** is a person's `git log -p` read over the commits to be sent, its result on the release page naming the commit it reached; the public `main`'s `HEAD` is that commit, and a commit landing on `-dev`'s `main` after the read is not sent until read itself. **A finding** in a commit not yet public is taken out in `ka-reader-dev` before anything is sent, the read repeated, and `git rev-list --max-parents=0 HEAD` on a fresh clone of the public repository prints the root commit of the checkout the repeated read passed on; the public history is never rewritten for a finding, so one in a commit already public is revoked and removed by a later commit, and whether "never" yields to a leaked secret is the owner's, raised only if it occurs. **Never rewritten is held structurally:** once public, the repository's `main` refuses a force push and a deletion — `gh api repos/<owner>/<repository>/branches/main/protection --jq '.allow_force_pushes.enabled, .allow_deletions.enabled'` prints `false` twice, or the ruleset form of the same two rules — and from the second release on, the previous release's tag is an ancestor of `HEAD` on a fresh clone. **The tag build runs in the public repository:** the tag is pushed there, on a commit its `main` holds, and `release.yml` runs there with Actions on — the owner's act S-7 already orders after the history check. The citations move with it: "PRD v18 § Assumptions" reads v19, `C-12 (the public history, v14)` and `AC-14 (the history check, v14)` read v16, and § 12's PRD boundary reads v19. QC-71 and R-198 stay their seats' (`docs/architecture_open_issues.md` § 3.2, `docs/fdr_open_issues.md` § 3.1). The reasoning is `docs/trail/sdd/self_answer-93.md` § 5.1.
