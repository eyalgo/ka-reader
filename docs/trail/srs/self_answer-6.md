# Self-answer report — `docs/SRS.md`

## Header

- **Companion:** `docs/SRS_open_issues.md`
- **Document:** `docs/SRS.md` (Settled, v15, derived against PRD v18)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-09
- **Sources re-read:** None. The answer rests only on documents in this repository: `docs/PRD.md`
  § Assumptions, "Public identity" (v19); `docs/trail/prd/cycle-17.md` § 3.1, the owner's answer;
  `docs/SRS.md` C-7, C-12, AC-14 and RN-38/RN-39; `docs/SDD_open_issues.md` § 5.1.

## Items worked

### 3.1 — C-12 and AC-14 still have the one repository made public; PRD v19 splits it into a private `ka-reader-dev` and a public repository that receives the main line's history

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the SRS
- **Verdict:** confirmed with addition
- **Why:** The fold the item proposes is right. It misses three things the PRD states, and those
  are added.

  *What I treated as the draft.* The item's "If a document has to be written" line says C-12 and
  AC-14 should describe the public repository as receiving the main line's history from the private
  one, with the check run over what it receives. That is a lean on what the fold should be, so I
  weighed it as a draft and did not answer from scratch.

  *Whose call this is (check 1).* The SRS takes the edit, so the item belongs to this document.
  The owner already made the product decision: `docs/trail/prd/cycle-17.md` § 3.1, *Answer*, which
  the PRD folded at v19. Folding it here commits the owner to nothing they have not decided, so
  I answered it in their seat. The item does not widen the SRS. C-12 states something that is now
  false: "the repository is made public with its own commit history". This is a correction, so
  § *A widening item waits until it occurs* does not apply.

  *Is the draft sound (check 2)? It answers a smaller question than the item asks.* PRD v19
  § Assumptions, "Public identity" (`docs/PRD.md:L420-L430`) states four things. The draft carries
  the first two: (a) the private `ka-reader-dev` keeps every branch, and (b) the public repository
  carries the main line's own history, as made, not a fresh copy and not a cut tree. It leaves out
  two that a release inspection can check:
  1. **No other branch.** "Work in progress, change branches, and anything not yet checked stay
     there", and the owner's answer says the public repository "receives no other branch". Added to
     C-12 and AC-14.
  2. **Never rewritten.** "Each later release adds to the public history and never rewrites it."
     The owner's answer adds "never force-pushed". Added to C-12. AC-14 checks it from the second
     release on: the public history the previous release left is still whole in the new one.
  3. **The check covers every arrival.** The PRD says the history reaches the public repository
     "only once exactly what it is to receive has been checked". That holds for every release, not
     just the first. The draft's "over what it receives" points this way without saying so, and
     AC-14's current wording ("before the repository was made public") says the opposite. Made
     explicit in C-12 and AC-14.

  *Does it contradict anything settled (check 3)?* No.
  - The handle, the address, and C-7's channel on that repository are unchanged in the PRD, so C-7
    and RN-38 stand.
  - RN-39 records why C-12 took the public history at v14. It stays as written, and the fold adds
    its own note, as RN-41 did for RN-24.
  - The PM's matching item on the SDD (`docs/SDD_open_issues.md` § 5.1) asks S-7 to check "the set
    the public repository receives". My answer gives C-12 the same set, so the SRS and the SDD
    companion do not disagree.
  - Where the tag build runs and that Actions is on in the public repository (owner's answer; SDD
    C-R4) are how the work is done, below this document. They land as no requirement here.
  - No card field is owed. `project.md` names no repository.

  *Does it hold on the failure paths (check 4)?*
  - **Empty:** the first push goes into a new, empty repository. "Exactly what it receives" is the
    main line's whole history, which is the case the check was written for.
  - **Stale:** main can move between the check and the push. The answer binds the check to exactly
    the commits sent: a commit that lands on the main line after the check is not sent until it has
    been checked itself.
  - **Concurrent, through visibility:** measured on the SDD companion, `eyalgo/ka-reader` exists
    today and is private. The answer makes the check come before the history arrives, whether or
    not the repository is visible yet. A push into a still-private repository that is later made
    public is therefore covered too.
  - **Refused:** if the check finds something private, nothing is sent. **One case is named and
    left uncovered.** The PRD wants the main line "as it was made" and also wants nothing private in
    it, and it names no remedy for a finding. The station's guardrail ("taken out before
    publication … not re-initialised") is delivery's, not a product statement. So the SRS says the
    push is blocked and does not pick a remedy. No finding exists, so this is not raised upstream
    now.
  - **Absent:** the private repository becoming unreachable changes nothing the public repository
    must hold. Nothing is added for it.

  *What would have tipped the verdict.* If the PRD had not named "no other branch" and "never
  rewrites" in its own words, I would have confirmed the draft as it stood, and adding them would
  have widened the SRS. They are in the PRD, so leaving them out would make the fold incomplete.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SRS.md`** — `<CORE>/launchers/skill/launcher.sh product-srs ka-reader`
