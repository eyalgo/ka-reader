# Self-answer report — UXD.md

## Header

- **Companion:** `docs/UXD_open_issues.md`
- **Document:** `docs/UXD.md` (Settled, v6)
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-01

## Items worked

### 2.1 — Every trail pointer in the UXD is dead — the folder moved and the citations did not

- **Bucket:** 2. Choices to confirm — drafted best-effort; confirm or override
- **Verdict:** confirmed with addition
- **Why:** The draft's repair is right; its measurement counted four citations where the document carries 71.
  `docs/uxd_trail/` genuinely does not exist — all seven answer-trail folders moved to
  `docs/trail/<x>/` at `nozoki@1e8bf3d`, which updated no citing document — so the repair
  (`docs/<x>_trail/` → `docs/trail/<x>/`) stands as drafted. Two additions, and each changes what a
  person doing the repair must actually do.

  **First, the scale.** The item said the version line cites four cycles. `docs/UXD.md` carries
  **71** citations of that form across **four** dead folders — `uxd_trail`, `prd_trail`,
  `srs_trail`, `content_trail` — not one. And the defect is not the UXD's: **235** across six
  documents (PRD 2, SRS 80, SDD 40, UXD 71, DESIGN 30, CONTENT 12), one cause. Reading the document
  whole is what produced this; the item was written from a grep of its version line.

  **Second, and this is the one that would have caused a new defect: four of the UXD's 71 must not
  be touched.** RN-8, RN-15, RN-16 and RN-17 cite the *commit-pinned* form
  `nozoki@1d5c553:docs/uxd_trail/cycle-1.md`, which resolves — verified, `git show
  1d5c553:docs/uxd_trail/cycle-1.md` returns the file — because at that commit the path existed.
  Rewriting a pinned citation breaks one that currently works, and the four sit in Review Notes
  recording owner authorizations, which are exactly the citations a cold reader opens to check a
  decision. Only the 67 unpinned ones move. The draft, applied literally as "each
  `docs/uxd_trail/` becomes `docs/trail/uxd/`", would have broken all four.

  **Third, the item's own handling of its siblings did not survive check 1.** It named the dead
  paths in `DESIGN.md` and `SRS.md` and repaired neither, calling that "surfaced not fixed". The
  prompt is explicit that this is not a verdict: *"Naming the other document without writing there
  is not this verdict; it is the item going nowhere."* So the change is now carried — raised on all
  five sibling documents, listed under `## Companions opened`. Its counts for those two — six in `DESIGN.md`, three in
  `SRS.md` — were **accurate for `uxd_trail` alone**, which is what it measured; what it did not see
  is that the same defect reaches three more folders in those documents, taking them to 30 and 80.

  **What I was close to deciding differently:** whether five sibling companions is proportionate,
  given that three of them reopen settled documents for what is mechanically one `sed`. What tipped
  it is the prompt's own tiebreak — *"an unnecessary cycle costs a run; a fact left false costs
  every reader after it"* — plus the character of these particular pointers: they are authorization
  citations, so a reader who cannot open one cannot verify the decision resting on it. Each raised
  item says plainly that one sweep across all six documents may be cheaper than six cycles, so
  nothing here forces six runs.

## Left for the owner

None this run.

## Skipped

- **1.1 — Three more layout references landed; does the UXD change?** — its **Answer** slot was
  already filled when this run reached it, carrying the owner's standing directive of 2026-09-01
  (*the CDO decides; re-write if and only if it judges the UXD changes*). A filled slot is an answer
  already given and is never rewritten, so this run did not revisit, re-weigh or improve it.

  One observation recorded rather than acted on, because acting would have meant re-answering a
  finished item: the document already carries entries the two new Git-graph references bear on
  directly. UX-F4 and UX-S6 specify a history view showing *"which commits belong to which, and
  where they diverge and merge — never a flat list"*, drawn against a chosen branch set
  (`docs/UXD.md:174-177`, `:231`), and RN-14 cites `vscode-branch-filter.png` as *"one control among
  several that would serve"*. `vscode-git-graph-merge-lanes.png` and
  `vscode-branch-filter-many-branches.png` are pictures of exactly those two things. Whether that
  changes anything remains the CDO's call under 1.1 — this note only saves the next run the search.

## Raised on this document

None beyond the items already on it — the trail-pointer defect was already § 2.1, so raising a
second item would have been the near-duplicate the skill forbids.

## Companions opened

- **`docs/SRS_open_issues.md`** — **appended** — companion to `SRS.md`, landed in commit `c76ed6d`
- **`docs/SDD_open_issues.md`** — **appended** — companion to `SDD.md`, landed in commit `7dbdf9a`
- **`docs/PRD_open_issues.md`** — **opened** — companion to `PRD.md`, landed in commit `99b9fe0`
- **`docs/CONTENT_open_issues.md`** — **opened** — companion to `CONTENT.md`, landed in commit `95ac0d7`
- **`docs/DESIGN_open_issues.md`** — **opened** — companion to `DESIGN.md`, landed in commit `7296ed4`

## Launchers owed

- **`docs/UXD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-uxd/launcher.sh nozoki`
- **`docs/SRS.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-srs/launcher.sh nozoki`
- **`docs/SDD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-sdd/launcher.sh nozoki`
- **`docs/PRD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/launch-product-prd/launcher.sh nozoki`
- **`docs/CONTENT.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-content/launcher.sh nozoki`
- **`docs/DESIGN.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-design/launcher.sh nozoki`
