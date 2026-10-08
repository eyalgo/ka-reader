# Self-answer report — DESIGN.md

This records the unattended CDO decisions for the owner and the producing runs that consume them.

## Header

- **Companion:** docs/DESIGN_open_issues.md
- **Document:** docs/DESIGN.md
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-10-01
- **Sources re-read:** None. No answer rests on a source outside the product repository.

## Items worked

### 3.1 — Whether the reading panel's path line shows while a selected file is still being read

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the design language
- **Verdict:** answered
- **Why:** Choose (a): a selected file still being read has its loading message and no path line. The path line begins the content or outcome presentation, including an empty text file and every file-specific failure. DESIGN's unqualified first-row rule leaves the pending case ambiguous (`docs/DESIGN.md:L657-L661`), while the UXD puts the path with content and separately names the loading state (`docs/UXD.md:L101-L103`, `L236-L236`). The answer clarifies DESIGN; it requires no upstream experience change or reserved owner decision. The item cites an occurrence, the pending implementation at `ka-reader-mac/Sources/Surfaces/ReadingPanelView.swift:L101-L109`, so it is a concrete downstream case rather than a proposed widening with no occurrence.
- **Reasoning:** The pending selection is already marked before the read is requested (`ka-reader-mac/Sources/Surfaces/WorkbenchView.swift:L80-L87`). DESIGN's tie-breaker for two valid treatments is fewer elements (`docs/DESIGN.md:L358-L362`). That supports the loading message alone; the existing implementation is evidence of the case, not authority for the decision. A known selected path would not falsely claim progress either, so (b) is defensible on that narrow ground. It would be preferable if an upstream rule required the panel to repeat the pending target, but the UXD's current path rule says with content and its loading cell does not require that second row (`docs/UXD.md:L101-L103`, `L236-L236`).
- **The framing checked:** CONTENT does not ban a reader's path because it contains numerals or an ellipsis; it scopes its grammar to KA-Reader's own writing and exempts the reader's names (`docs/CONTENT.md:L41-L45`). Loading's no-progress and no-ellipsis rules bind the loading message (`docs/CONTENT.md:L306-L310`). Neither choice would need a new CONTENT exception. The item's supporting text is left unchanged; this distinction is recorded here for the producing run.
- **Failure paths:** Empty — no selection remains the prompt alone; a successfully read empty file is still a result and keeps its path (`docs/UXD.md:L236-L236`; `ka-reader-mac/Sources/Surfaces/ReadingPanelView.swift:L91-L97`, `L123-L149`). Absent or refused — a vanished or unreadable file keeps its identity in the failure presentation, with the tree enabled (`docs/UXD.md:L236-L236`). Stale or concurrent — a replacement selection removes the former path and content from the pending drawing, and a reply from an older selection cannot restore them; the present sink guard already rejects that reply (`ka-reader-mac/Sources/Surfaces/ReadingPanelView.swift:L101-L109`, `L166-L170`; `ka-reader-mac/Sources/Surfaces/WorkbenchView.swift:L80-L98`). Stopped — the unexplained fault replaces loading and identifies its file under the path (`docs/UXD.md:L322-L331`; `ka-reader-mac/Sources/Surfaces/ReadingPanelView.swift:L114-L119`). This answer concerns the selected-file pending presentation; it does not prescribe blanking an established reading position on live refresh, which UX-I3 preserves (`docs/UXD.md:L253-L255`).
- **Verification scope:** Source inspection grounds those implementation observations; no running-window behavior was measured. No implementation or test file is changed by this decision.

## Left for the owner

None this run.

## Skipped

None this run. Already filled slots: 0. Items addressed to another actor: 0.

## Companions opened

- **docs/UXD_open_issues.md** — **opened** — companion to `docs/UXD.md`, landed in commit `2064b249876840295bc41aa12ce3a7ea09005aea`; source locators corrected in `57c1d332cac2facba83fd5c437dda82d9808d373`

The independent finding is the layout-reference inventory: UXD § 4 names seven images and three later unannotated images (`docs/UXD.md:L68-L73`), while the reference inventory names eight, four annotated and four described-only (`docs/ux_reference/README.md:L3-L19`). The opened choice proposes correcting that inventory, preserving RN-13's earlier read as history and keeping the latest image unadjudicated (`docs/ux_reference/README.md:L206-L219`). Its confirm-or-override slot remains at the template's placeholder; this run does not answer the newly raised item.

## Launchers owed

- **docs/UXD.md** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/skill/launcher.sh product-uxd ka-reader`
- **docs/DESIGN.md** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/skill/launcher.sh product-design ka-reader`
