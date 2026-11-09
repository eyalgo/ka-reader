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
- **Confirm or override:** override: the owner's call stands as drafted, and one part of the draft is replaced. R-143 and R-138 *point at* `docs/CONTENT.md` § Terminology, *Standing sentences*, support-posture row and quote none of its words, the way R-139 already points at the accessibility row and `docs/SRS.md` v15 C-7 and C-13 point at this one: "states the support posture in the one wording `docs/CONTENT.md` § Terminology, *Standing sentences*, fixes in its support-posture row, carried whole, every sentence of it". A copy of the row in the FDR is the stale copy the row exists to prevent. Each keeps its limit, quoted from the PRD as now: R-143 "promising nothing beyond" the PRD's posture, with its security sentence quoted; R-138 "promises nothing beyond" it, quoting both PRD sentences, issues and security, as C-13 now does, because the README carries the security sentence too. Both trace tags gain *upstream moved — RN-39*. PD-22 reads "in the one wording `docs/CONTENT.md` § Standing sentences fixes" in place of "in the PRD's own words". RN-16 stands as the record of why these rules first quoted the PRD, marked superseded by RN-39. RN-39 records the move: the owner's answer (`docs/architecture_open_issues.md` § 3.1, `ka-reader@3363a86`), the SRS v15 fold (`ka-reader@86802c6`), why it points and does not quote, and that the PRD limit keeps the "no acknowledgement" promise binding where the row says only "read on the same terms". Reasoning: `docs/trail/fdr/self_answer-9.md` § 2.1.

### 2.2 The FDR has not seen the beta: the PRD, the SRS, the UXD and CONTENT moved to it after v13 settled

> **No `product-fdr` run wrote this item.** The `companion-self-answer` run that answered § 2.1 on
> 2026-11-09 raised it. That run read the FDR whole, and the documents above it, to answer § 2.1,
> and found that the FDR was derived against PRD v16 and SRS v13. The PRD is now at v18, the SRS at
> v15, the UXD at v13 and `docs/CONTENT.md` at v15. Together they make the first public release a
> beta that this document never mentions. Reasoning: `docs/trail/fdr/self_answer-9.md` § 2.2.

- **Drafted into the FDR:** nothing yet, because the run that raised this writes no document. The
  proposal: the fold re-derives against the documents as they now read, and at the least makes
  three moves. (1) **R-105 is now false.** It promises a dark and a light theme "from the first
  release". `docs/SRS.md` FR-20 now says both themes and the kept choice are "in place before
  1.0.0, and a release below 1.0.0 is not held to them". The beta (`docs/PRD.md` § Scope (In),
  "The first public release — a beta") is that release. R-105 takes FR-20's bound, and every rule
  that names the theme choice follows it: R-106 – R-108, R-110 and R-27's theme control. (2) **A
  rule carries `docs/SRS.md` FR-35.** Where Git state is read once, when the folder is opened, the
  Git view and the tree's changed-file markers say they show the state read then, in the wording
  `docs/CONTENT.md` § Terminology, *Standing sentences* fixes in its beta row. The statement is
  absent where Git state is followed, and absent in a plain folder (R-23). A repository created at
  the folder's root after it is opened is not followed, and the README's known gaps say so. The
  rule is conditioned on a state, not on a release, the way RN-12 conditions every rule. So R-18,
  R-74 and R-81 keep their Git half, met before 1.0.0 (FR-14, FR-33). (3) **The README rules take
  `docs/SRS.md` AC-14's known-gaps line.** The fold also reads whether C-12's history check —
  the repository goes public only once its history has been checked for anything private — is
  behaviour at this document's altitude.
- **Rationale:** the strongest case: a fact in the document is now false (R-105), and the move that
  made it false came from upstream. `git log 9ce336b..HEAD -- docs/PRD.md docs/SRS.md docs/SDD.md
  docs/CONTENT.md docs/UXD.md` lists PRD v17 and v18 (`ka-reader@ce9ba62`, `ka-reader@d1ea3ac`),
  SRS v14 and v15 (`ka-reader@c7440d7`, `ka-reader@86802c6`), UXD v13 (`ka-reader@5a1fc70`),
  CONTENT v15 (`ka-reader@1c3ca12`) and SDD v68 – v82, all after FDR v13 (`ka-reader@9ce336b`).
  A search of `docs/fdr.md` for `FR-35`, `read-at-open` and `beta` finds nothing. It matters now:
  the beta is the release being walked toward. The Product Owner checks every change against this
  document (`<CORE>/roles/CROSS_ROLE.md` § 9, *FDR gate*), so a change for the beta's README or
  its Git-view statement meets an FDR that forbids it (R-105) or does not know it exists (FR-35).
  § 2.1 reaches R-138 too, so one fold takes both.
- **If overridden:** the FDR stays derived against PRD v16 and SRS v13. R-105 then holds the beta
  to both themes, against SRS FR-20 and PRD v18, and the first change spec that touches the beta
  comes back `fdr-update-needed`.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item raised against the FDR after it settled

None.
