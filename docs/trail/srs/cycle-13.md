# SRS open issues — KA-Reader

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

> **No `product-srs` run wrote this companion.** A `companion-self-answer` run opened it on 2026-11-09
> while reading `docs/architecture_open_issues.md` § 3.1, which the owner had already answered.
> `SRS.md` is Settled at v14 and had no companion, so nothing else could carry the change to it. That
> answer says the SRS's C-7 and C-13 are "brought to that wording by their own seats, citing the
> CONTENT row, not the PRD's sentence". With no companion on disk, a `product-srs` re-run would find
> the SRS done and do nothing. The item below carries the answer to this document. The reasoning is in
> `docs/trail/architecture/self_answer-82.md`.

---

## 1. Open issues — technical questions with no answer yet

None.

## 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override

### 2.1 C-7 and C-13 require the support posture in `docs/CONTENT.md`'s one wording, not "in the PRD's terms"
- **Drafted into the SRS:** nothing yet, because the run that raised this writes no document. The
  proposal: C-7 requires `SECURITY.md` to state the posture in the wording `docs/CONTENT.md`
  § Terminology, *Standing sentences*, support-posture row fixes, and to promise nothing the PRD does
  not. The same change goes to C-13 for the README. Each cites the CONTENT row in place of quoting
  `docs/PRD.md` § Assumptions, "Support posture", as the wording to carry. The PRD stays each
  constraint's trace and the limit of what is promised. RN-24 and RN-16 record why C-7 and C-13 quote
  the PRD, so they are revised to say the wording is now CONTENT's. AC-14 inspects the README's
  "support posture in the PRD's terms", so it moves with C-13.
- **Rationale:** the owner decided this at `docs/architecture_open_issues.md` § 3.1, *Answer*
  (2026-11-09, committed `ka-reader@3363a86`). C-7 asks for the posture "in those terms", meaning the
  PRD's sentence *"Security reports have a private channel and are read, with no acknowledgement or
  response time promised"*. C-13 asks for the PRD's issues sentence. `docs/CONTENT.md` § Standing
  sentences gives the posture one different wording, and it allows "no paraphrase, no shortened
  version". `docs/nfdr.md` QC-44 checks that wording against `README.md` and `SECURITY.md` with
  `grep -F`. As the SRS reads now, no `SECURITY.md` or README meets both C-7 / C-13 and QC-44. The
  owner chose the CONTENT wording. The PRD's sentence stays the posture's meaning, held by
  `docs/nfdr.md` QC-42 as the limit nothing is promised beyond. That keeps "promising nothing the PRD
  does not" in C-7 true as written. Only the clause naming which words appear on the surface moves.
- **If overridden:** C-7 and C-13 stand as written, and `docs/architecture_open_issues.md` § 3.1's
  answer has to be reopened by the owner. Without that, `SECURITY.md` and the README stay unwritable
  under both C-7 / C-13 and `docs/nfdr.md` QC-44. `docs/fdr.md` R-143, R-138 and PD-22 trace to C-7
  and C-13 and carry the same split, and `docs/fdr_open_issues.md` § 2.1 carries it there. The two
  should be answered the same way.
- **Confirm or override:** confirm, with four additions. (1) `SECURITY.md` and the README each carry
  the CONTENT support-posture row **whole**, all three sentences, not the half that fits the surface:
  the row allows "no shortened version", so C-13's README gains the security sentence and C-7's
  `SECURITY.md` the issues sentences. (2) C-7 and C-13 name the CONTENT row as the one home of the
  wording. Any words they quote are the row's, verbatim, so a later change to the row cannot leave
  the SRS holding a stale copy. (3) C-7's "promising nothing the PRD does not" and C-13's "promises
  nothing beyond it" stay, now against the PRD's sentence as meaning. That keeps "no acknowledgement
  promised" binding as a limit, which the CONTENT row does not say in words. AC-14's README clause
  moves to the CONTENT wording, and its `SECURITY.md` clause stands. (4) RN-24 and RN-16 stay as
  written, by this document's own rule for settled notes (RN-20, RN-35). A new note records the move
  and the owner's decision behind it (`ka-reader@3363a86`). Reasoning:
  `docs/trail/srs/self_answer-5.md` § 2.1.

## 3. Raised from downstream — an item from a seat that did not write the SRS

None.
