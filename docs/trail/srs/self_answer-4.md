# Self-answer report — SRS.md

## Header

- **Companion:** docs/SRS_open_issues.md
- **Document:** docs/SRS.md
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-06
- **Sources re-read:** None. No answer rested on a source outside this repository.

## Items worked

### 2.1 — FR-20 and AC-11 say "from the first release"; PRD v18 places the theme after the first public release, a beta — the SRS has not seen PRD v17 – v18

- **Bucket:** 2. Choices to confirm — the CTO drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The draft is right that FR-20 and AC-11 now contradict the PRD they derive from. PRD
  v18 § Scope (In) says the beta "waits for nothing else ... not for choosing a theme and keeping
  that choice", and the SDD at v68 already follows the PRD (§ 6 S-9, § 12). The fix is this
  document's own. It is the CTO's, and the owner holds no ground on it that I could name.
  Four additions:
  1. **What moves is the choosing and the keeping, not the themes.** The PRD keeps "dark and
     light themes from the start" in § UX Notes, and the owner's words at
     `docs/trail/prd/cycle-16.md` § 3.1 are "Choosing and keeping a theme waits for after the
     beta" and "theme choice ... come after it". The draft reads § Scope (In) as qualifying the
     UX Notes line in full. Read that way, "from the start" says nothing. So FR-20 keeps its
     trace to "from the start", drops "from the first release", and says that the user's choice
     between the two themes, kept between sessions, is in place before 1.0.0. I was close to the
     stronger reading: both themes present in the beta, following the platform's appearance. At
     HEAD the shell's colours already resolve per appearance (`ka-reader-mac/Sources/Surfaces/CodeTokens.swift:L31-L32`).
     What ruled it out is check 3. A beta condition on themes would contradict
     `docs/trail/sdd/cycle-62.md` § 1.1, which says nothing but the tree and the open file
     following the disk and Markdown reading rendered comes before the beta. So the beta is not
     held to the themes. The draft also gave the wrong basis for that. C-6 says only that anything
     may change before 1.0.0, which does not make a missing theme acceptable. The basis is § Scope
     (In) itself.
  2. **Carry the beta's statement, worded as a system state.** It is a behaviour a shipped
     surface shows. The PRD now writes it into the rule sentence of § UX Notes, "the view never
     lies" ("or, in the beta's Git view, as read when the folder was opened"), and into that
     section's beta bullet. A reverse walk of PRD v18 must land that unit somewhere. The SRS
     already carries the rule in parts (FR-27, FR-28), so this is one more part of it. Worded as
     "where Git state is read at open and not followed", it names no release, which keeps § 2's
     rule that delivery timing stays out of this document. RN-37 worded FR-13 the same way.
     Failure paths:
     - **Plain folder (empty case).** FR-34 forbids any message in the Git view, so the
       statement must not appear there, and the criterion says so.
     - **Stale case.** A repository created at the folder's root after it is opened is not
       followed in that state. Nothing on the surface can say so without breaking FR-34, so this
       case is named and left uncovered there; the README's known gaps are the only place it is
       told.
     FR-14's Git half, FR-33's live clause and AC-7's Git clauses stay v1 requirements. The PRD
     says the Git view following the disk "stays part of what v1 means" and is in place before
     1.0.0.
  3. **The draft answers a smaller question than its heading.** The heading says the SRS has not
     seen PRD v17 – v18. Those versions also add § Assumptions "Public identity": the repository
     goes public with its own history, after that history has been checked for anything private.
     The draft does not place that. I carry it as a C-12 clause with an AC-14 inspection. C-7 is
     the precedent: a repository obligation, checkable at release, that binds before the first
     public release. RN-24's "archived visibly" landed as no requirement because it describes an
     act after maintenance ends, which this does not. The SDD's S-7 command half already makes the
     check concrete. The beta's "used and shown" purpose produces no requirement.
  4. The draft's header, Version-line and reverse-walk clause stands, and it records all of the
     above. C-4, C-7 and AC-14's existing clauses stand. The beta is the first public release for
     all three.

  One error in the item's text is reported, not corrected. The provenance block says the SRS v13
  "was authored against PRD v16". The header's *Inputs read* line reads "PRD Settled" and names no
  version, so v16 rests on the Version line's C-12 trace. The claim holds, but the header does not
  state it.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SRS.md`** — `<CORE>/launchers/skill/launcher.sh product-srs ka-reader`
