# SRS open issues — Nozoki 覗き

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

> **This companion was opened by a `companion-self-answer` run, not by a `product-srs` run.**
> `SRS.md` is Settled at v8 and its companion was correctly deleted. It is opened because the
> Principal Architect's constraint set could not bound the diagnostic log without a source —
> `docs/nfdr.md` QC-40 says the bound is undecided and names NFR-11 as where it lands — and the
> run answering that companion (`docs/architecture_open_issues.md` § 1.2, recorded in
> `docs/trail/architecture/self_answer-1.md` § 1.2) judged the change belongs here. With no
> companion on disk a `product-srs` re-run reads the SRS as done and has nothing to act on. The
> one item below arrives with the run's lean and its reasoning; the decision is the next round's.

---

## 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override

### 2.1 The diagnostic log holds one session's lines and is capped within a session — a bound NFR-11 does not state
- **Drafted into the SRS:** nothing yet — this item was raised by a `companion-self-answer` run
  on the architecture companion, not by a `product-srs` run. Proposed for NFR-11 by revision: *the
  diagnostic log holds at most the current session's lines — nothing from an earlier session
  survives a launch — and within a session it is bounded to 1 MiB, past which it is emptied and
  writing continues, so the most recent lines are always the ones present and the file never grows
  without bound.*
- **Rationale:** NFR-11 keeps diagnostics with the tool's own state, and the SDD has the host write
  one line per `failed` or `stopped` item to a log in the app's container (`docs/SDD.md` § 4 C-I2).
  Nothing bounds the file: a session over a folder an agent rewrites for a week grows a line per
  transient failure indefinitely, and a builder would pick a bound silently. The NFDR cannot state
  one without a source (`docs/nfdr.md` QC-40). *One session's log*, because every line in the file
  is then this session's or the last one's — which is what makes a log with no timestamp field
  (C-I2 names the part, the operation and the error text) readable at all. *A within-session cap*,
  because "one session" alone does not answer the week-long session that raised the question.
  *Emptied-and-continue* rather than stop-writing, so the newest failures — the ones a reader opens
  the file for — are the ones kept. *1 MiB*, because the file is text a person opens in an editor,
  and a megabyte is on the order of ten thousand lines of C-I2's shape — more failures than anyone
  reads; the number is proposed, not measured, and is the CTO's to replace.
- **If overridden:** keeping the previous session as well — a one-generation rotation to
  `nozoki.log.1` at launch — covers the case this draft does not: a session that crashed and was
  relaunched before its log was read loses those lines. It costs a second file, which the NFDR's
  QC-52 ("written to … `nozoki.log` and nowhere else") and the SDD's C-I2 would then have to name.
  A different cap changes one number. Whatever lands, the SDD's C-I2 carries the mechanism by its
  own revision, and the NFDR's QC-40 carries the checkable number and the test that reads it.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">
