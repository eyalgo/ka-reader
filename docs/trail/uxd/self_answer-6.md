# Self-answer report — UXD.md

## Header

- **Companion:** `docs/UXD_open_issues.md`
- **Document:** `docs/UXD.md` (v12, Settled; the companion was reopened by `docs/trail/sdd/self_answer-77.md` at `ka-reader@454eda2`, carrying one item under choices to confirm)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-06
- **Sources re-read:** None. No answer here rests on a source outside this repository. Read at the lines each entry names: the PRD (v18), the UXD (v12) whole, the SRS (v14: FR-20, FR-35, AC-26), the SDD (v68: § 6 S-4, S-7, S-8, S-9; § 5 E-7), `docs/CONTENT.md` (v14: § Message patterns *Error*, § Traceability), `docs/CONTENT_open_issues.md`, and the trail at `docs/trail/srs/cycle-12.md` § 2.1, `docs/trail/srs/self_answer-4.md` § 2.1 and `docs/trail/sdd/self_answer-77.md`.

## Items worked

### 2.1 — The beta's statement — "the Git state read when the folder was opened" — is a state of the Git view and of the tree's markers, and this document does not draw it

- **Bucket:** 2. Choices to confirm — the CDO drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** **Check 1: mine, in the owner's seat.** The edit lands in this document: UX-I4, the UX-S2 and UX-S3 rows, UX-F2, UX-F3, UX-I16 and UX-I17. What a surface's states are is the CDO's to draw, and the CDO loader's § *Output* says a state a component must carry cannot move late. The answer commits nothing beyond this document's consistency. The statement itself is the owner's, confirmed twice (`docs/trail/prd/cycle-15.md` § 3.1, `cycle-16.md` § 3.1), and the draft only gives it its place. I can name no ground I cannot see. Placement is a taste call, but it belongs to this seat, and the owner has reserved none of it.

  **Check 2: the draft holds, for the reason it gives.** Something upstream moved and this document has not seen it: `grep -c 'read when the folder was opened' docs/UXD.md` prints 0, and PRD v18 states the case in the rule sentence (`docs/PRD.md:L244-L246`), in its beta bullet (`:L260-L263`) and in § Scope (In) (`:L327-L329`). The draft's four parts are the right shape: the rule gains its case, the two rows gain a release-bound state, the bounds come from this document's own invariants, and the withdrawal is tied to `follow-the-folder`. The draft's lean on the wordless view is a real lean, so the item sits in the right bucket. The draft has one gap: its fourth class of the read-at-open state — failures observed at open — and two live sentences that it does not reach (additions 3 and 4).

  **Check 3: one new settled fact, and it agrees with the draft.** The SRS settled at v14 after the item was written (`ka-reader@c7440d7`). FR-35 and AC-26 (`docs/SRS.md:L255-L264`, `:L660-L667`) carry the statement as a system state and settle the case the item left for the drawing. In the read-at-open state, a repository created at the opened folder's root after opening is not followed, the view goes on presenting a plain folder with no statement, and the README's known gaps tell the user. The draft's lean matches it exactly, so the lean is confirmed with a second ground under it: the UXD may not draw the opposite of a settled requirement. Reading this document's own record turned up one sentence that seems to argue the other way. RN-28 says that if the live finding were narrowed to a start-time check, UX-I17's live sentence *"has nothing to move and stands as written: a transition that cannot occur is not a state this document draws differently"*. That was written for a narrowing that removes the transition from the product. The beta keeps the change on disk and drops only the following, which leaves a stale view, and FR-35 names that as a case. So addition 4 does not contradict RN-28. It is a case RN-28 did not consider, and the fold should say so where it touches RN-28. Theme came up too, because PRD v18 places choosing a theme after the beta and FR-20 is narrowed to match. It moves nothing in this item: the beta draws no theme control, and a missing control is not a state any surface must show.

  **Check 4: the failure paths, which produce three of the four additions.**
  - **Empty**, a clean repository (addition 2). The draft puts the tree's line "at the head of the tree's markers", and a clean tree has none. No markers in a repository is still the Git state read at open. In the beta, an agent's later edits reach the tree, because `follow-the-tree` and `follow-the-file` ship first, and they arrive with no marker. Without the line that reads as *unchanged*. That is UX-U2, the driving scenario, misled. So the line stands wherever the folder is a repository whose Git state has been read, clean included. It is absent only before the read (UX-I13), in a plain folder (UX-I17), and over the unexplained fault (UX-I16).
  - **Absent**, Git state unreadable at open (addition 3). UX-S3 Error recovers "on refresh", UX-F2's failure line "on a later refresh", and UX-I16 by "the next successful read". In the beta no later Git read exists (`docs/SRS.md` FR-35, "read once, when the folder is opened, and not followed"; `docs/SDD.md` § 6 S-4 *Not in this slice*; only S-8 re-runs the read). A lock observed at open would therefore stand all session under a message promising it will clear. `docs/CONTENT.md:L269-L270` says exactly that: *"There's nothing to do: the Git view shows the status as soon as KA-Reader can read it."* So the fold draws the beta's case on each of the three. The observation was made at open, the view's line stands over it, it lasts until the folder is opened again (in v1, starting KA-Reader again, UX-S4), and no recovery is promised. The route out stays the tree and the panel (UX-I10, UX-I14). This narrows the draft's bound (3), "never over a fault (UX-S3 Error, UX-I16)", to the unexplained fault, whose slot draws only that the work stopped. The words are CONTENT's, so that half went to its companion (§ *Companions opened*).
  - **Stale**, the live sentences (addition 4). UX-F3 has Git state follow the disk, and UX-I17's live finding has a repository appearing or leaving arrive "as every change does". In the beta neither holds (`docs/SDD.md` § 6 S-8 *Delivers*). Left as written, they contradict the state the fold is about to draw, so each gains the beta's bound. A repository *leaving* the root leaves the read-at-open view under its statement, which is true. One *appearing* is FR-35's uncovered case.
  - **Concurrent**: the Git state moving between open and view, or a repository mid-operation at open. Both are inside the statement as drafted: what is shown is the state read at open, said so. Nothing to add.
  - **Refused**: a linked worktree or submodule whose Git directory lies outside the folder (`docs/SDD.md` § 6 S-4). This is an observation at open that the beta does not change, and addition 3 covers it as one more item observed at open.
- **What was close to tipping it:** *confirmed* plain. The draft's placement, bounds and withdrawal are right, and the wordless-view lean turned out to be the settled requirement. What tipped it to *with addition* is that a seed built from the draft alone would ship a beta in which a clean repository's tree shows edited files unmarked with no line, and a lock at open says "nothing to do" for the whole session. Each meets every word of the draft and breaks the statement's point. *Overridden* was never close: nothing in the draft is wrong, it is short of the failure paths.

## Left for the owner

None this run.

## Skipped

None this run. The companion carries one item and no filled slots. Sections 1 and 3 read "None".

## Companions opened

- **`docs/CONTENT_open_issues.md`** — **appended** — companion to `CONTENT.md`, landed in commit `39e9229`. Item § 2.2, under choices to confirm, slot left at its placeholder. In the beta, nothing re-reads Git state after the folder is opened (`docs/SRS.md` FR-35; `docs/SDD.md` § 6 S-4, S-8). CONTENT's Git-view lock message (`docs/CONTENT.md:L269-L270`) and its Traceability row (`:L529`, "the nothing-to-do form, with the condition that ends the wait") promise a recovery the beta never makes. Proposed: in the read-at-open state the message takes the formula's *what you can do next* branch, names opening the folder again, and states the lock as observed at open, in the simple past. It is retired when the Git view follows the disk. Why it is worth the round: something upstream moved and the document has not seen it. The SRS fixed the read-at-open state at v14, after CONTENT settled at v14, and the message would otherwise ship a promise of a state the tool will not reach, which UX-I4 forbids. It is a separate item rather than a revision of § 2.1, because § 2.1 asks for a new standing sentence while this asks for an existing message's beta case. Both are open, so the next CONTENT round answers them together.

## Launchers owed

- **docs/UXD.md** — `<CORE>/launchers/skill/launcher.sh product-uxd ka-reader`
- **docs/CONTENT_open_issues.md** — `<CORE>/launchers/companion-self-answer/launcher.sh ka-reader CONTENT`
