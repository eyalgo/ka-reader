# Self-answer report — UXD.md

This report records the CDO's decision for the owner and the next `product-uxd` run.

## Header

- **Companion:** docs/UXD_open_issues.md
- **Document:** docs/UXD.md
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-02
- **Sources re-read:** None outside the product repository underpin this inventory decision; its sources are `docs/ux_reference/README.md:L3-L19`, `docs/ux_reference/README.md:L206-L219`, and `docs/UXD.md:L68-L74` and `docs/UXD.md:L626-L650`.
- **Inputs read:** UXD Settled · PRD Settled · SRS Settled · reference README no status field · project Agari no status field · project domain doctrine stub · project AI responsibility doctrine stub · instance writing bar Draft. These are the fields read, not new status decisions.

## Items worked

### 2.1 — Bring the layout-reference inventory up to the reference's own count

- **Bucket:** 2. Choices to confirm — the CDO drafted a best-effort answer; confirm or override
- **Verdict:** confirmed
- **Why:** Confirm the proposed inventory correction: § 4 says seven images and three later unannotated images, while the reference owner states eight, split into four annotated and four described-only images (`docs/UXD.md:L68-L74`; `docs/ux_reference/README.md:L3-L19`). The on-disk check agrees: `rg --files /Users/eyalgolan/products/ka-reader/docs/ux_reference -g '*.png' | wc -l` returned `8` on 2026-10-02. Reasoning: this is the UXD's factual accounting, so the CDO can settle it without making an owner's taste, risk or external commitment decision.

  Preserve RN-13's seven-image read as history and add the current inventory beside it, as proposed; RN-13 explicitly records what that revision opened and why those three additions moved no entry (`docs/UXD.md:L626-L650`). Reasoning: changing its historical count would falsely claim that revision read the eighth image. The new inventory grants that image no design authority: the reference explicitly leaves its adoption open (`docs/ux_reference/README.md:L214-L219`). The existing flow and screen requirements therefore take no change from this answer (`docs/UXD.md:L175-L199` and `docs/UXD.md:L240-L241`). No split or upstream companion is needed: inventory and image adoption are separable, and this item proposes only the former (`docs/UXD_open_issues.md:L36-L49`).

  Failure-path reasoning: the count is a dated observation, not a permanently fixed set. If an image or annotation changes before the fold, re-count against the reference owner rather than carrying this measurement forward unexamined; if the directory or README is absent or unreadable, report that missing evidence rather than substituting zero. An unadjudicated or subsequently rejected image remains an inventory member while its file exists, without becoming an accepted requirement; that distinction follows the reference's explicit annotation rule (`docs/ux_reference/README.md:L10-L19`). The correction introduces no runtime empty, error or concurrent state because it changes only the reference accounting proposed in § 2.1 (`docs/UXD_open_issues.md:L36-L49`).

## Left for the owner

None this run.

## Skipped

None this run. Zero filled slots and zero items addressed to another actor were skipped (`docs/UXD_open_issues.md:L33-L50`).

## Companions opened

None this run.

## Launchers owed

- **docs/UXD.md** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/skill/launcher.sh product-uxd ka-reader`
