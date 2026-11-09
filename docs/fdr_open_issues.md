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

> **No `product-fdr` run wrote this companion.** A `companion-self-answer` run opened it on 2026-11-09
> while reading `docs/architecture_open_issues.md` § 3.1, which the owner had already answered.
> `fdr.md` is Settled at v13 and had no companion, so nothing else could carry the change to it. That
> answer says the FDR's PD-22, R-143 and R-138 are "brought to that wording by their own seats, citing
> the CONTENT row, not the PRD's sentence". With no companion on disk, a `product-fdr` re-run would
> find the FDR done and do nothing. The item below carries the answer to this document. The reasoning
> is in `docs/trail/architecture/self_answer-82.md`.

---

## 1. Open issues — behavioural questions with no answer yet

None.

## 2. Choices to confirm — the Principal PM drafted a best-effort answer; confirm or override

### 2.1 The support posture on `SECURITY.md` and the README takes `docs/CONTENT.md`'s one wording, not the PRD's sentence
- **Drafted into the FDR:** nothing yet, because the run that raised this writes no document. The
  proposal: R-143 requires `SECURITY.md` to state the posture in the wording `docs/CONTENT.md`
  § Terminology, *Standing sentences*, support-posture row fixes. R-138 requires the same of the
  README. Each quotes that row whole, *"Issues and questions are welcome and are read when there is
  time. There is no response time, no commitment to fix, and no promise that a fix arrives. Security
  reports have a private channel and are read on the same terms."*, and cites the CONTENT row. Both
  surfaces carry all three sentences: the row allows "no paraphrase, no shortened version", and the
  owner's answer binds `SECURITY.md` and the README alike to that one wording, verbatim. So the README
  carries the security sentence too, and `SECURITY.md` the issues sentences. *(Revised 2026-11-09 by
  the `companion-self-answer` run on `docs/SRS_open_issues.md`, which took out "or the half of it that
  applies to its surface"; its reasoning is `docs/trail/srs/self_answer-5.md` § 2.1.)* PD-22's "in the PRD's own words" becomes "in the one wording
  `docs/CONTENT.md` § Standing sentences fixes". The PRD's sentence stays what the posture *means*: it
  is the limit R-143 and R-138 promise nothing beyond. RN-16 explains why these rules quote the PRD,
  so it is revised or superseded to say why they now quote the CONTENT row.
- **Rationale:** the owner decided this at `docs/architecture_open_issues.md` § 3.1, *Answer*
  (2026-11-09, committed `ka-reader@3363a86`). `docs/CONTENT.md` § Standing sentences requires every
  surface that states a standing sentence to carry its one wording, "no paraphrase, no shortened
  version". `docs/nfdr.md` QC-44 checks exactly that against `README.md` and `SECURITY.md` with
  `grep -F`. As the FDR reads now, R-143 quotes *"Security reports have a private channel and are read,
  with no acknowledgement or response time promised"* and R-138 quotes the PRD's issues sentence. Both
  are `docs/PRD.md` § Assumptions, "Support posture", and both differ from the CONTENT row, so no
  `SECURITY.md` or README can satisfy both R-143 / R-138 and QC-44. The owner chose the CONTENT wording.
  The PRD stays the source of what is promised, and that limit is not lost: `docs/nfdr.md` QC-42 still
  holds `SECURITY.md` to promising nothing beyond the PRD's sentence. One gap to handle in the fold:
  the CONTENT row does not say in words that no acknowledgement is promised. "Read on the same terms"
  carries it, and the owner accepted that. The fold should keep "promises nothing beyond" the PRD's
  sentence in R-143, so the missing acknowledgement promise still binds as a limit.
- **If overridden:** R-143, R-138 and PD-22 stand as written, and `docs/architecture_open_issues.md`
  § 3.1's answer has to be reopened by the owner. Without that, `SECURITY.md` and the README stay
  unwritable under both R-143 / R-138 and `docs/nfdr.md` QC-44. `docs/SRS.md` C-7 and C-13 carry the
  same split, and `docs/SRS_open_issues.md` § 2.1 carries it there. The two should be answered the same
  way.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item raised against the FDR after it settled

None.
