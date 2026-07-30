# SRS open issues — nozoki

> Companion to `SRS.md`. The CTO authored the SRS non-interactively; this file holds
> what it could not settle from the inputs (the PRD and any context/constraints).
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this
> file**, then re-run `product-srs`. It folds your answers into the SRS and drops the
> resolved items. When nothing is left open, `product-srs` **deletes this file**: no file =
> the SRS is done.
>
> Your answers are never thrown away. Each time the CTO folds them in, it first copies this
> file whole to `docs/srs_trail/` — so what you decided, and why, stays readable and citable
> for good.

---

## 1. Open issues — technical questions with no answer yet

None this cycle — every unsettled call carried a defensible lean, so each is listed under §2 as
a choice to confirm.

## 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override

### 2.1 The acquisition path must not require building from source — and may presume at most one prerequisite

- **Drafted into the SRS:** C-3 — the single acquisition-and-start path requires no clone of the
  source repository and no build from source; it may presume at most one widely-available
  prerequisite, named on the README's first screen; the ≤ 5-minute time-to-first-success clock
  (NFR-13, AC-10) includes installing that prerequisite when it is absent. The concrete channel
  (package runner, installer, prebuilt binary, …) is deliberately left to the SDD, where the
  runtime is chosen (RN-7).
- **Rationale:** the PRD's product property is one path, simple, and cycle 1 itself flagged the
  tension: a clone-and-run shape asks for a toolchain, a clone, a dependency install, and a run —
  straining both the ≤ 5-minute bar and "no setup step of any kind"
  (`docs/prd_trail/cycle-1.md` §2.2, the note for the SRS). Ruling out build-from-source is the
  requirement-level resolution of that tension; bounding the presumed prerequisites at one keeps
  "simple" measurable and keeps the README's first screen honest. What this choice does **not**
  decide is the channel itself — that is stack-coupled and lands in the SDD.
- **If overridden** (build-from-source allowed, or prerequisites unbounded): C-3 loses its two
  bounds; NFR-13 / AC-10 stay and become the only guard on the path's simplicity — the tension
  the owner flagged in cycle 1 returns and must survive the timed per-release check on evidence;
  C-9's "one install path" line on the README first screen widens to carry toolchain steps.
- **Confirm or override:**

### 2.2 The minimal diff and commit-history surface (beyond v1, inside the terminus)

- **Drafted into the SRS:** FR-17 — for any file the Git view reports as changed, the difference
  between its working state and its last committed state, read-only. FR-18 — the repository's
  commit history as a list (identifier, message, author, date), read-only. Both inside the same
  shell; both exercised by AC-12 at the closing release.
- **Rationale:** the Agari places diffs and commit history inside done, but the PRD names them
  only as deferred features with no content — so some reading had to be drafted for the SRS to
  cover the terminus. The minimal reading was taken deliberately: working-vs-committed is the
  one diff the v1 Git view already implies (it marks exactly those files), and a flat commit
  list is the smallest history that is a history. What these views *show* is product-visible, so
  the cut is yours to confirm, not mine to settle.
- **If overridden** (richer surfaces — staged-vs-unstaged diffs, per-commit diffs, history
  filtering): FR-17 / FR-18 reword accordingly and AC-12 widens; nothing else in the SRS depends
  on the cut.
- **Confirm or override:**

### 2.3 Files that cannot be rendered as text are presented, not rendered

- **Drafted into the SRS:** FR-10 — a binary or undecodable file is shown as a clear placeholder
  stating why the content is not rendered; the shell stays fully usable; the file is untouched.
- **Rationale:** the PRD promises read-only viewing of *any* file with syntax highlighting, and a
  repository will contain files that have no text rendering. Something must be on screen when
  one is selected; a placeholder is the smallest behavior that keeps "browse anything" true
  without inventing a hex viewer or an image preview the PRD never asked for. Product-visible,
  so yours to confirm.
- **If overridden** (e.g. render images, or hide binary files from selection): FR-10 rewords;
  AC-5's read path gains the chosen behavior; hiding files from selection would also touch FR-5
  (the tree presents the repository's files) and needs a stated exclusion rule.
- **Confirm or override:**

### 2.4 Semantic versioning from 1.0.0 as a stated constraint

- **Drafted into the SRS:** C-6 — from the first 1.0.0 release, releases are semantically
  versioned and a breaking change to the product's public contract requires a major version;
  before 1.0.0, the fact that anything may change is stated plainly. Checked by AC-14.
- **Rationale:** the Agari's third condition gates done on "version 1.0.0 or later — the
  semantic-versioning promise in force, so a breaking change is no longer free"
  (`system/projects/nozoki/agari.md`). But the Agari bounds the SRS; it does not supply
  requirements — and the PRD carries no versioning statement at all. So this is a missing
  product statement being surfaced: the constraint is drafted here so the closing condition has
  an SRS realization, and it is yours to confirm (and, if you want it upstream, to fold into the
  PRD through its own correction path — not mine to write there).
- **If overridden** (no versioning promise in the SRS): C-6 drops and AC-14 narrows; the Agari's
  closing condition would then have no realization in the technical definition, which I would
  record as an open gap rather than paper over.
- **Confirm or override:**

### 2.5 A private vulnerability-reporting channel and SECURITY.md before the first public release

- **Drafted into the SRS:** C-7 — before the first public release, private vulnerability
  reporting is enabled on the public repository, and a SECURITY.md names where to report and
  what response to expect, consistent with the README's stated support posture. Checked by
  AC-14.
- **Rationale:** the PRD's maintenance risk names security reports arriving against finite
  maintainer time, with "a stated support posture in the README" as a mitigation — but a
  security report is the one kind the reporter should be able to make *privately*: GitHub's
  private reporting is opt-in per repository, and until it is enabled a stranger's only channel
  is a public issue, which turns a report into a disclosure. The channel cannot be built after
  the first report needs it. This goes beyond the PRD's literal text, so it is drafted as a
  constraint for your sign-off rather than asserted.
- **If overridden:** C-7 drops and AC-14 narrows; the maintenance-risk mitigation stays
  README-only, and the first vulnerability report may arrive as a public disclosure — accepted
  knowingly rather than by omission.
- **Confirm or override:**
