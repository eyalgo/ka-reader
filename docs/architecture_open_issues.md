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

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 The NFDR has not seen the beta: QC-44's list misses the beta's standing sentence, and nothing checks the read-at-open release

> A `companion-self-answer` run opened this item on 2026-11-09, while answering
> `docs/fdr_open_issues.md` § 2.1 (the FDR's beta fold). No `product-architecture` run wrote it. It
> exists because the beta moved the SRS (v14, `ka-reader@c7440d7`) and CONTENT (v15,
> `ka-reader@1c3ca12`) after the NFDR last read them, and the NFDR carries none of it. The reasoning
> is at `docs/trail/fdr/self_answer-10.md` § *Companions opened*.

- **Lands in:** `nfdr.md` QC-44, and a new QC or a widened one beside it
- **Drafted into the records:** nothing yet. The proposed change:
  1. QC-44 names every standing sentence by list: the read-only promise, the network statement, the
     pre-1.0.0 statement, the support posture, the archiving sentence and the accessibility posture.
     `docs/CONTENT.md` v15 added a seventh row, the beta's Git-view statement, and says the Git view,
     the tree's markers and the README's known gaps all carry it word for word. QC-44's list gains it,
     with its condition: it is checked on a release that reads Git state once, at open, and its
     absence is checked on a release that follows Git state (`docs/SRS.md` AC-14, AC-26).
  2. The release checks gain what SRS v14 added to AC-14 and C-12: the README's known gaps carry the
     line about a repository created after open only on a read-at-open release, and the repository's
     own commit history is checked for anything private before it is made public.
  3. Whether the in-app statement (SRS FR-35, AC-26; FDR R-192 – R-195 as drafted in FDR v14) needs a
     QC of its own, or stays with acceptance by inspection, is the Principal Architect's call.
- **Rationale:** a search of `docs/nfdr.md` for `FR-35`, `AC-26`, `read once` and the beta's
  sentence finds nothing, and none of `commit history` or `anything private` either. QC-44 promises
  "every standing sentence", then lists six of what are now seven, so `checks/readme.sh` as QC-44
  binds it would pass a README that drops the beta's sentence. The NFDR's header reads SRS and CONTENT
  Settled, but at versions before the beta. This is upstream moving under a settled record, not a new
  requirement.
- **If overridden:** the NFDR stays as it is. The beta's README line and its history check are then
  held only by release inspection under SRS AC-14, and `checks/readme.sh` does not check them.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 `SECURITY.md` is held to two wordings of the support posture, and no file can carry both
- **Raised by:** Product Owner — 2026-11-09
- **Which record:** `nfdr.md` § 4, QC-44
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** writing `SECURITY.md`. The wording QC-44 binds it to and the wording the FDR
  binds it to are different sentences, so no `SECURITY.md` meets both.
- **Where it shows:** QC-44 requires every standing sentence, the support posture among them, to
  appear on `SECURITY.md` verbatim "in the one wording `docs/CONTENT.md` § Standing sentences fixes".
  That wording's security half reads "Security reports have a private channel and are read on the
  same terms." (`docs/CONTENT.md` § Terminology, *Standing sentences*, the support-posture row), and
  the same section says every surface that states a standing sentence carries that wording — "no
  paraphrase, no shortened version". `docs/fdr.md` PD-22 requires the posture "in `SECURITY.md` in
  the PRD's own words", and R-143 quotes them: "Security reports have a private channel and are read,
  with no acknowledgement or response time promised" (`docs/PRD.md` § Assumptions, "Support
  posture"). `docs/SRS.md` C-7 asks for the posture "in those terms". The two sentences differ, and
  the CONTENT one does not say that no acknowledgement is promised. A `SECURITY.md` holding only the
  CONTENT wording falls short of PD-22. One that also holds the PRD's sentence states the posture in a
  second wording, which `docs/CONTENT.md` § Standing sentences forbids and QC-44 exists to prevent.
  QC-42, beside it, binds no wording, only that `SECURITY.md` promise nothing beyond the PRD's
  sentence, and either wording meets that. The README has the same split (`docs/fdr.md` R-138 and
  `docs/SRS.md` C-13 against the same CONTENT row). That one does not block `SECURITY.md`, and it is
  named here so that one answer settles both.
- **If a document has to be written:** none. The records have to agree on which wording binds
  `SECURITY.md`: either QC-44 says so, or the FDR's and CONTENT's statements are brought to one
  wording by their own seats and QC-44 follows them.
- **Answer:** (owner, 2026-11-09) **`docs/CONTENT.md`'s wording binds.** `SECURITY.md` and the README
  carry the support posture verbatim in the one wording `docs/CONTENT.md` § Standing sentences fixes —
  "Security reports have a private channel and are read on the same terms." — and nothing else. QC-44
  stands as written. The FDR's PD-22, R-143 and R-138 and the SRS's C-7 and C-13 are brought to that
  wording by their own seats, citing the CONTENT row, not the PRD's sentence. The PRD's sentence stays
  the posture's meaning (nothing is promised beyond it, QC-42), not a second wording on any surface.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
