---
version: alpha
name: Nozoki
description: The visual language of Nozoki — its one window (the shell, the sidebar, the reading panel, and every state they show) in both themes, and its application icon
colors:
  # Light-theme values. The dark-theme value of every token is in § Colors, "The two themes".
  primary: "#1E1F22"
  ink-muted: "#5B5D63"
  gutter: "#6F7177"
  surface: "#FBFBFA"
  canvas: "#F2F2F0"
  rail: "#EAEAE7"
  line: "#D8D8D4"
  selection: "#E2E3DF"
  hover: "#EBEBE8"
  git-added: "#166A34"
  git-modified: "#8F5400"
  git-deleted: "#B3261E"
  git-renamed: "#0E6B8C"
  code-keyword: "#7A2E8F"
  code-string: "#1A6B3A"
  code-number: "#9A4B00"
  code-comment: "#6A6C72"
  code-name: "#0F5A9A"
  diff-added: "#E4F4E8"
  diff-removed: "#FAE3E0"
typography:
  ui:
    fontFamily: -apple-system, system-ui, sans-serif
    fontSize: 13px
    fontWeight: 400
    lineHeight: 1.4
  label:
    fontFamily: -apple-system, system-ui, sans-serif
    fontSize: 11px
    fontWeight: 600
    lineHeight: 1.2
    letterSpacing: 0.06em
  rail-label:
    fontFamily: -apple-system, system-ui, sans-serif
    fontSize: 10px
    fontWeight: 500
    lineHeight: 1.2
    letterSpacing: 0.02em
  path:
    fontFamily: ui-monospace, "SF Mono", Menlo, monospace
    fontSize: 12px
    fontWeight: 400
    lineHeight: 1.5
  code:
    fontFamily: ui-monospace, "SF Mono", Menlo, monospace
    fontSize: 13px
    fontWeight: 400
    lineHeight: 1.55
  prose-body:
    fontFamily: -apple-system, system-ui, sans-serif
    fontSize: 15px
    fontWeight: 400
    lineHeight: 1.6
  prose-h1:
    fontFamily: -apple-system, system-ui, sans-serif
    fontSize: 24px
    fontWeight: 600
    lineHeight: 1.25
  prose-h2:
    fontFamily: -apple-system, system-ui, sans-serif
    fontSize: 20px
    fontWeight: 600
    lineHeight: 1.3
  prose-h3:
    fontFamily: -apple-system, system-ui, sans-serif
    fontSize: 17px
    fontWeight: 600
    lineHeight: 1.35
  prose-code:
    fontFamily: ui-monospace, "SF Mono", Menlo, monospace
    fontSize: 13px
    fontWeight: 400
    lineHeight: 1.55
rounded:
  none: 0px
  sm: 3px
  md: 6px
spacing:
  xs: 4px
  sm: 8px
  md: 12px
  lg: 16px
  xl: 24px
  row: 24px
  indent: 12px
  chrome-height: 36px
  rail-width: 48px
  rail-entry: 48px
  sidebar-width: 260px
  prose-measure: 44rem
  icon: 16px
  rail-icon: 20px
  hairline: 1px
components:
  chrome:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.primary}"
    typography: "{typography.ui}"
    height: "{spacing.chrome-height}"
    padding: "{spacing.sm}"
  control:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.primary}"
    typography: "{typography.ui}"
    rounded: "{rounded.sm}"
    height: "{spacing.row}"
    padding: "{spacing.xs}"
  control-open:
    backgroundColor: "{colors.selection}"
    textColor: "{colors.primary}"
  menu:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary}"
    typography: "{typography.ui}"
    rounded: "{rounded.md}"
    padding: "{spacing.xs}"
  menu-item:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary}"
    typography: "{typography.ui}"
    height: "{spacing.row}"
    padding: "{spacing.sm}"
  menu-item-hover:
    backgroundColor: "{colors.hover}"
    textColor: "{colors.primary}"
  separator:
    backgroundColor: "{colors.line}"
    height: "{spacing.hairline}"
  rail:
    backgroundColor: "{colors.rail}"
    width: "{spacing.rail-width}"
  rail-entry:
    backgroundColor: "{colors.rail}"
    textColor: "{colors.ink-muted}"
    typography: "{typography.rail-label}"
    height: "{spacing.rail-entry}"
    rounded: "{rounded.none}"
  rail-entry-active:
    backgroundColor: "{colors.rail}"
    textColor: "{colors.primary}"
  rail-icon:
    size: "{spacing.rail-icon}"
  icon:
    size: "{spacing.icon}"
  sidebar:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.primary}"
    width: "{spacing.sidebar-width}"
  section-header:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink-muted}"
    typography: "{typography.label}"
    height: "{spacing.row}"
    padding: "{spacing.sm}"
  tree-row:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.primary}"
    typography: "{typography.ui}"
    height: "{spacing.row}"
    rounded: "{rounded.none}"
    padding: "{spacing.xs}"
  tree-row-selected:
    backgroundColor: "{colors.selection}"
    textColor: "{colors.primary}"
  tree-row-hover:
    backgroundColor: "{colors.hover}"
    textColor: "{colors.primary}"
  tree-row-indent:
    width: "{spacing.indent}"
  status-added:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.git-added}"
    typography: "{typography.ui}"
  status-modified:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.git-modified}"
    typography: "{typography.ui}"
  status-deleted:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.git-deleted}"
    typography: "{typography.ui}"
  status-renamed:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.git-renamed}"
    typography: "{typography.ui}"
  tooltip:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary}"
    typography: "{typography.ui}"
    rounded: "{rounded.sm}"
    padding: "{spacing.xs}"
  branch-chip:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.primary}"
    typography: "{typography.path}"
    rounded: "{rounded.sm}"
    padding: "{spacing.xs}"
  reading-panel:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary}"
  path-line:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink-muted}"
    typography: "{typography.path}"
    height: "{spacing.row}"
    padding: "{spacing.lg}"
  code-surface:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary}"
    typography: "{typography.code}"
    padding: "{spacing.lg}"
  code-gutter:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.gutter}"
    typography: "{typography.code}"
    padding: "{spacing.sm}"
  code-keyword:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.code-keyword}"
  code-string:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.code-string}"
  code-number:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.code-number}"
  code-comment:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.code-comment}"
  code-name:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.code-name}"
  diff-line-added:
    backgroundColor: "{colors.diff-added}"
    textColor: "{colors.primary}"
    typography: "{typography.code}"
  diff-line-removed:
    backgroundColor: "{colors.diff-removed}"
    textColor: "{colors.primary}"
    typography: "{typography.code}"
  diff-sign-added:
    backgroundColor: "{colors.diff-added}"
    textColor: "{colors.ink-muted}"
    typography: "{typography.code}"
  diff-sign-removed:
    backgroundColor: "{colors.diff-removed}"
    textColor: "{colors.ink-muted}"
    typography: "{typography.code}"
  prose:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary}"
    typography: "{typography.prose-body}"
    width: "{spacing.prose-measure}"
    padding: "{spacing.xl}"
  prose-h1:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary}"
    typography: "{typography.prose-h1}"
  prose-h2:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary}"
    typography: "{typography.prose-h2}"
  prose-h3:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary}"
    typography: "{typography.prose-h3}"
  prose-code:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.primary}"
    typography: "{typography.prose-code}"
    rounded: "{rounded.sm}"
    padding: "{spacing.xs}"
  link-text:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary}"
    typography: "{typography.prose-body}"
  link-destination:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink-muted}"
    typography: "{typography.path}"
  image-placeholder:
    backgroundColor: "{colors.canvas}"
    textColor: "{colors.ink-muted}"
    typography: "{typography.ui}"
    rounded: "{rounded.sm}"
    padding: "{spacing.md}"
  status-message:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink-muted}"
    typography: "{typography.ui}"
    padding: "{spacing.xl}"
---

# DESIGN — Nozoki 覗き

**Status:** Settled
**Owner:** CDO
**Version:** 17 — the close: the cycle-13 answer places the status letter's tooltip at its surface's two edges. Where the visible surface ends less than the tooltip's height below the letter, the tooltip goes above it. Where the room left of the letter runs out, the tooltip narrows, the start of the name is cut, and the joining mark and the word stay whole. § Typography names the tooltip as the one place a name loses its start (RN-38; `docs/trail/design/cycle-13.md:L61-L78`). No token value moves. `docs/DESIGN_open_issues.md` is removed and `Status:` is Settled. The machine gate on this revision — the same pinned `lint`, run 2026-10-04 — reported 0 errors, 0 warnings and 1 info, `token-summary` with the counts RN-21 records unchanged (20 colours, 10 typography levels, 3 rounding levels, 15 spacing tokens, 46 components); no diagnostic is accepted or routed. Prior revision: 16 — the cycle-12 answer fixes vertical centring of the path-text line within its own row, with the hairline outside that calculation (RN-37; `docs/trail/design/cycle-12.md:L51-L51`). Prior revision: 15 — the cycle-11 answer scopes the reading panel’s path line to content and outcomes, with distinct no-file, pending and fault treatments (RN-36; `docs/trail/design/cycle-11.md:L55-L55`). Prior revision: 14 — the cycle-10 gutter-padding answer folded into `{components.code-gutter}`, Code and the shared-column Diff treatment (RN-35; `docs/trail/design/cycle-10.md:L52-L52`). No existing token value changes. Prior revision: 13 — the close: the owner's cycle-9 answer folded (`docs/trail/design/cycle-9.md` § 2.1 — decided in the owner's seat by a `companion-self-answer` run, its reasoning at `docs/trail/design/self_answer-5.md` § 2.1; RN-34). **The application icon is one drawing:** Nozoki supplies one drawing, at the light values, and makes no second, for any of the system's icon appearances — default, dark, clear or tinted. The answer confirmed the choice and changed the proposed sentence in three ways, each folded: the clause *it is shown as it is under every system appearance* is not written, because how macOS shows the icon is the platform's; the rule covers every icon appearance and not only dark; and the icon's contract binds the drawing Nozoki supplies, not a variant the platform generates or tints from it. It lands in § Components "The application icon", whose last sentence it replaces, and in one Don't. Named and not covered: what macOS draws from an icon the bundle names as a single `.icns` file, which is looked at when the drawn icon exists. No token, colour, type, spacing or radius value moves, no component enters or leaves, and the frontmatter is revision 12's, byte for byte. `docs/DESIGN_open_issues.md` is removed and `Status:` is Settled. The machine gate on this revision — the same pinned `lint`, run 2026-09-30 — reported 0 errors, 0 warnings and 1 info, `token-summary` with the counts RN-21 records unchanged (20 colours, 10 typography levels, 3 rounding levels, 15 spacing tokens, 46 components); no diagnostic is accepted or routed. (v12: the owner's cycle-8 answers folded (`docs/trail/design/cycle-8.md` — each decided in the owner's seat by a `companion-self-answer` run, its reasoning at `docs/trail/design/self_answer-4.md`; RN-32, RN-33). **The title bar** (§ 2.2 there): the window keeps the platform's own title bar, with the platform's three window buttons and no drawn title; the window's title is the string the chrome names the folder with, and the product's name only on the startup surface; the bar is shown in the theme the window shows, and its ground is the one plane in the window not drawn from a token — § Layout, § Components "The chrome and its controls" and "The startup surface", three Do's, the wordmark Don't, and three Traceability rows. **The application icon** (§ 1.1 there): it is this document's and Nozoki's own — one figure in `{colors.primary}` on `{colors.surface}` at their light values, no hue, no lettering — and a release carries the drawn icon or the bundle names none; what the figure depicts is drawn separately and returns for sign-off — § Overview, § Components "The application icon", one Do and one Don't, and the frontmatter's `description:`, which no longer says the language covers only the window. **Revision 11's AppKit wording** (§ 2.1 there) is confirmed as applied, and nothing in it moves. No token, colour, type, spacing or radius value moves, and no component enters or leaves. One thing the icon's answer named and left uncovered — a second drawing for a dark system appearance — is raised as a fresh item (`docs/DESIGN_open_issues.md` § 2.1) and applied nowhere, so a companion is on disk and `Status:` reads Draft. The machine gate on this revision — the same pinned `lint`, run 2026-09-30 — reported 0 errors, 0 warnings and 1 info, `token-summary` with the counts RN-21 records unchanged (20 colours, 10 typography levels, 3 rounding levels, 15 spacing tokens, 46 components); no diagnostic is accepted or routed. (v11: the realisation, read from the product as it now stands *(evidence change — RN-31)*. § Overview says what the language is realised in — AppKit views drawn by the product's own Swift package, in one process, with no web engine, no markup and no stylesheet (`README.md` § Stack; `nozoki-mac/`) — where revisions 1–10 said plain CSS custom properties over the product's own markup, and it gains *How the values are read*: a `px` is one point, an `em` its level's own font size, the `rem` sixteen points, a hex colour an sRGB value, and a token defined once in the shell's source. The sentences that spoke CSS or markup are re-said with it: § Typography's naming of the two families and its clipped-row clause, § Layout's measure, § Elevation & Depth's shadow, § Components "Icons", the first Do, RN-1 and RN-19. No token, colour, type, spacing or radius value moves — the frontmatter is revision 10's, byte for byte — and no component enters or leaves. **This revision folds no owner answer:** the companion's one item (`docs/DESIGN_open_issues.md` § 2.1, opened by a `companion-self-answer` run on 2026-09-30, `nozoki@a047914`) arrived with an empty slot, so no trail cycle is retired; the change is made on the *change in the evidence* authorization, and the item is kept, rewritten as the owner's sign-off on what this revision applied. Two things found reading the product's source are raised beside it and applied nowhere in this document: the window's title bar (the companion's § 2.2) and the application's icon (its § 1.1). `Status:` reads Draft because a companion is on disk, and this document is Settled only when none is. The machine gate on this revision — the same pinned `lint`, run 2026-09-30 — reported 0 errors, 0 warnings and 1 info, `token-summary` with the counts RN-21 records unchanged (20 colours, 10 typography levels, 3 rounding levels, 15 spacing tokens, 46 components); no diagnostic is accepted or routed. (v10: the close: the owner's cycle-7 answer folded (`docs/trail/design/cycle-7.md` § 2.1 — decided in the owner's seat by a `companion-self-answer` run, its reasoning at `docs/trail/design/self_answer-3.md` § 2.1; RN-30). The two sentences that fixed the word *pending* as what a pending state shows — the Do's line, and § Components "Status messages", the line `docs/CONTENT.md` RN-4 actually cites — keep their rule and hand the string to `docs/CONTENT.md`: pending is shown as a word in that document's wording, never as a bar or a spinner. RN-30 is the record of CONTENT RN-4's raise arriving, which no earlier note and no file under `docs/trail/design/` held. No token, colour, type, spacing or radius value moves; no component enters or leaves; the UX-I13 Traceability row stands as written. `docs/DESIGN_open_issues.md` is removed and `Status:` is Settled. The machine gate on this revision — the same pinned `lint`, run 2026-09-25 — reported 0 errors, 0 warnings and 1 info, `token-summary` with the counts RN-21 records unchanged (20 colours, 10 typography levels, 3 rounding levels, 15 spacing tokens, 46 components); no diagnostic is accepted or routed. (v9: the UXD v10 fold, and the header's `Inputs read:` line. `docs/UXD.md` reached v10 after revision 8 was authored (`nozoki@4d7b653`; its RN-30 folds the owner's cycle-7 answer, `docs/trail/uxd/cycle-7.md` § 2.2), and the two phrases revision 8 kept as quotations of § 2 and § 4 *as they read at v9* now read as the UXD does: § Overview's *Density is the folder's* and `{components.path-line}`'s *folder-relative path* (RN-29) — the *upstream UXD change* authorization, not an owner answer. Nothing else moves, by the UXD's own rule that *repository* stays where Git's own state is what the sentence is about. The header gains the **Inputs read:** line `<CORE>/doctrine/governance/unsettled_inputs.md` requires of every revision, which revisions 1–8 did not carry. Read and moving nothing: the layout reference's README at eight images (RN-29), and the product's own source, which holds no visual value. **This revision folds no owner answer:** the companion's one item (`docs/DESIGN_open_issues.md` § 2.1 — the Do's line that names the word *pending*, opened by a `companion-self-answer` run on 2026-09-25) arrived with an empty slot, so no trail cycle is retired and the item stays for the owner; `Status:` reads Draft because a companion is on disk, and this document is Settled only when none is. No token, colour, type, spacing or radius value moves; no component enters or leaves. The machine gate on this revision — the same pinned `lint`, run 2026-09-25 — reported 0 errors, 0 warnings and 1 info, `token-summary` with the counts RN-21 records unchanged (20 colours, 10 typography levels, 3 rounding levels, 15 spacing tokens, 46 components); no diagnostic is accepted or routed. (v8: the close, and the UXD v9 fold. The owner's cycle-6 answer is folded (`docs/trail/design/cycle-6.md` § 2.1 — a self-answer in the owner's seat, its reasoning at `docs/trail/design/self_answer-2.md` § 2.1): the *folder* / *folder selector* rename v7 applied stands as applied, RN-27 records the confirmation, `docs/DESIGN_open_issues.md` is removed and `Status:` is Settled. On the same revision the upstream UXD change since v7 is folded — `docs/UXD.md` v9 (`nozoki@b8010dd`, its RN-29), read on disk and recorded at RN-28: the **startup surface** (UX-S4) gains its empty state and its drawing, and *startup failure* reads *the startup surface's failure*; the **history** is drawn where the UXD now places it — the Git view's `clock` entry, commit rows beneath the changes list, the selected commit's diff in the reading panel — with its **stated end** as one inert muted row; the selector's list follows UX-S7's bound and order, and the current entry's mark is the leading bar this document already draws; an **in-folder image** renders in place and the placeholder covers the two cases that do not; the **branch chip** carries the commit's identifier on a detached HEAD; UX-F2's one-click-target rule is recorded as already held; and the terminal Don't, RN-16 and its Traceability row retire, because UX-S4 renders in the app's window and no surface of this product prints to a terminal. Two kept phrases stand until the UXD folds its own answered item (`docs/UXD_open_issues.md` § 2.2): *Density is the repository's* and *repository-relative path* quote `docs/UXD.md` § 2 and § 4 as they read at v9 (RN-27). No token, colour, type, spacing or radius value moves; no component enters or leaves. The machine gate on this revision — the same pinned `lint`, run 2026-09-01 — reported 0 errors, 0 warnings and 1 info, `token-summary` with the counts RN-21 records unchanged; no diagnostic is accepted or routed. (v7: *(upstream UXD change)* the viewed input and the chrome's control are renamed with the UXD: every place this document said *repository* where it meant the **viewed folder** or named the **selector** now reads *folder* / **folder selector** — § Overview (two sentences), § Layout (the sidebar's width reason and the chrome line), § Elevation & Depth (the menu), § Components "The chrome and its controls" and "The menu", the wordmark Don't, RN-9, RN-10, RN-20 and the UX-F5 Traceability row — and "The menu"'s *by name* is disambiguated to *each shown by its name*. Authorized by `docs/UXD.md` v6 RN-25, which renamed the control with PRD v11's input: the prompt's *upstream UXD change* delta, not an owner answer — the companion's one item (`docs/DESIGN_open_issues.md` § 2.1) is unanswered, so no answer is folded and no trail cycle is retired, and the item stays as the owner's sign-off on what this revision applied (RN-27). `Status:` reads Draft because a companion is on disk, and this document is Settled only when none is. No token, colour, type, spacing or radius value moves. The machine gate on this revision — the same pinned `lint`, run 2026-09-01 — reported 0 errors, 0 warnings and 1 info, `token-summary` with the counts RN-21 records unchanged; no diagnostic is accepted or routed. (v6: nothing about the design language changes: the 30 unpinned `docs/<x>_trail/` citations this document rests on (21 `design_trail/`, 6 `uxd_trail/`, 3 `prd_trail/`) are repaired to `docs/trail/<x>/`, the answer-trails having moved at `nozoki@1e8bf3d` without the citing documents. This document carries no commit-pinned citation, so none is excluded; and the six `uxd_trail/` citations are to the re-authored UXD's trail — the sections they cite exist only there — so the mechanical rule is safe on all six. No token, colour, type, spacing or radius value moves, and the companion is gone again. Authorized by the owner's cycle-5 answer (`docs/trail/design/cycle-5.md` § 2.1). The machine gate on this revision — the same pinned `lint`, run 2026-09-01 — reported 0 errors, 0 warnings and 1 info, `token-summary` with the counts RN-21 records unchanged; no diagnostic is accepted or routed. (v5: the owner's cycle-4 answers folded (`docs/trail/design/cycle-4.md`): `{components.status-message}` states its one exception — the **observed plain folder's Git view** (`docs/UXD.md` UX-I17) carries no message and so holds no instance of the component, while the Git view's reading and fault appearances stay inside it — and the Traceability table gains the UX-I17 row, satisfied by drawing nothing (RN-26). No token, colour, type, spacing or radius value moves; the companion is gone again. (v4: the owner's cycle-3 answers folded (`docs/trail/design/cycle-3.md`): `{components.status-message}` names the **unexplained fault** (`docs/UXD.md` UX-I16) as the second class of every failure state it covers — same treatment, same slot, same route out — and the Traceability table gains the UX-I16 row (RN-25). No token, colour, type, spacing or radius value moves; the companion is gone again. (v3: the owner's cycle-2 answers folded (`docs/trail/design/cycle-2.md`): the no-tooltip Don't is lifted on the owner's v1 decision and a tooltip contract enters — one surface, the status letter, as `{components.tooltip}` drawn from existing tokens (RN-11, RN-23); the status letters' VS Code vocabulary is stated rather than left implicit, with the porcelain collision recorded (RN-24); and the UX-I9 traceability row and RN-10 are repointed at the settled UXD record. No colour, type, spacing or radius value moves; the companion is gone again. (v2: the owner's cycle-1 answers folded — `docs/trail/design/cycle-1.md`.))))))))))
**Inputs read:** UXD Settled · PRD Settled · CONTENT Settled · SRS Settled · SDD Settled · FDR Settled · NFDR Settled · Writing bar Draft · Visual direction Settled · Visual restrictions Settled

> The design language is the visual source of truth: the tokens are normative, the prose says
> how to apply them. It is authored off the UXD's § Design-System Direction — that section names
> the system and the constraints; **this document holds every value**. A token value that also
> appears in the UXD is a defect of whichever document copied it. Unlike the UXD, this document
> may legitimately trail the SDD: structural UX must be settled before the architecture locks,
> visual language iterates. Updated in place with versioning (bump the line above whenever a value
> or the prose changes); on a revision it is **stable by
> default** — every changed value traces to an owner answer, a brand change, or an upstream UXD
> change, never a silent re-derivation. Evidence binds where it exists (the product's own
> source, its brand assets, the UXD's direction); where it is silent the value is the CDO's call,
> written here with a stated reason, and the load-bearing calls go to the companion file for
> sign-off. Declare a genuinely inapplicable category in `omitted:` rather than leaving it
> silently absent.

---

## Overview

Nozoki is a read-only viewer for one local folder — a Git repository or not — for a developer
who must not disturb the tree they are looking at — above all a tree that a coding agent is changing while they watch
(`docs/PRD.md` § Purpose, § Target Users). Its character is set upstream and this document only
dresses it: **calm, truthful, still** (`docs/PRD.md` § UX Notes "The character"; `docs/UXD.md`
§ 2 — variance 2, motion 2, density 6, typography 2).

**The one system is a restrained code-workbench built from primitives** — no established
component design system, no component library, no imported aesthetic (`docs/UXD.md` § 9,
owner-confirmed at `docs/trail/uxd/cycle-1.md` § 2.1). It is realised in AppKit views drawn by the
product's own Swift package, in one macOS window and one process, with no web engine, no markup
and no stylesheet (`README.md` § Stack; `nozoki-mac/`; `docs/SRS.md` C-11; RN-31), and it starts
from what a stock Mac already draws: the platform's own fonts, its own text sizes, its own flat
list rows. Nothing the window draws is shipped that the machine does not already have, except
fourteen vendored line icons (§ Components). One thing of Nozoki's is drawn outside the window,
the application icon, and it is drawn in the same ink on the same surface (§ Components, "The
application icon").

**How the values are read.** The token format writes a value the way a stylesheet would, and the
shell has none, so each unit is fixed here once. A `px` is one point of the window's own
coordinate space. An `em` is the font size of the level it is written on: `{typography.label}`'s
`0.06em` is 0.66 of a point. The `rem` is sixteen points, so `{spacing.prose-measure}` is 704. A
line height with no unit multiplies its level's font size. A hex colour is an sRGB value, the
space the contrast floor was measured in (RN-6, RN-31). And a token is defined once in the shell's
source, under its token's name, and read from there wherever a surface is drawn (§ Do's and
Don'ts).

**What it should feel like.** A quiet instrument that shows a folder and adds nothing of its
own. The shell is achromatic — grey on grey, in either theme — and **colour belongs to the
repository, not to the tool**: the only hues on screen are the ones that report Git state and
syntax. When the tree is clean and no file is open, the window has no colour in it at all, and
that stillness is the design. Density is the folder's: rows are tight and code sits at
code-reading size, but the chrome is one strip and the sidebar is one column, so a busy screen is
busy with the user's files, never with Nozoki.

**When no token or rule below covers a case**, decide in this order: show only what the job puts
on the surface; draw it the way macOS would draw it by default; show uncertainty as uncertainty
(pending, unknown) rather than resolving it; and of two treatments that both satisfy the above,
take the one with fewer elements on the surface.

## Colors

Twenty colour tokens, in four roles. Every value in the frontmatter is the **light** theme; the
dark value of each token is in the table below, and the two are one system with one rule per
token — never two palettes with two rules.

- **Ink — `{colors.primary}` and `{colors.ink-muted}`.** The product's primary colour is its text.
  `{colors.primary}` is every word the user reads as content or label — file names, code, chrome,
  menu items. `{colors.ink-muted}` is every word that *describes* rather than *is*: the open
  file's path, section headers, status messages, link destinations, the `+`/`−` signs in a diff.
  `{colors.gutter}` is line numbers only, and appears nowhere else.
- **Surfaces — `{colors.surface}`, `{colors.canvas}`, `{colors.rail}`, `{colors.line}`,
  `{colors.selection}`.** Three stepped greys and one hairline. `{colors.surface}` is the reading
  panel and whatever floats over the shell — the menu and the tooltip (§ Components) — the brightest (light) or darkest (dark) plane, because
  it carries the content. `{colors.canvas}` is the sidebar and the chrome, one step back.
  `{colors.rail}` is the Files/Git rail, one step further. `{colors.line}` is every separator.
  `{colors.selection}` is the selected row and an open control, and nothing else.
  `{colors.hover}` is the row under the pointer — only a row that can be clicked, and only while
  the pointer is over it (§ Components, *Rows*); it sits one step between `canvas` and `selection`
  so that rest, hovered and selected read as a sequence in one direction.
- **Git state — `{colors.git-added}`, `{colors.git-modified}`, `{colors.git-deleted}`,
  `{colors.git-renamed}`.** Four hue families for the six status letters: **A** and **U** are
  green (something is here that was not), **M** is amber (something changed), **D** and **C** are
  red (something is gone, or in conflict), **R** is teal (something moved). The letter carries
  the meaning and the hue only repeats it (`docs/UXD.md` UX-A2), so two letters sharing a hue
  lose nothing. These four are the only chroma in the shell. They are used for status letters,
  changed-file names in the tree and Git view, and nothing else — never for a control, never for
  emphasis, never for a heading.
- **Code — `{colors.code-keyword}`, `{colors.code-string}`, `{colors.code-number}`,
  `{colors.code-comment}`, `{colors.code-name}`.** Five syntax roles for the six floor languages
  (`docs/PRD.md` § Core Features): keywords, strings, numbers, comments, and names (functions,
  keys, tags). Punctuation, operators and everything else are `{colors.primary}`. Five roles, not
  fifteen, because the floor is six data-and-scripting languages whose tokens map onto these
  five, and every extra role is one more colour asking for attention in a still surface. Syntax
  colour appears only in the code view: a diff is drawn in ink, with `{colors.diff-added}` and
  `{colors.diff-removed}` as the only tint, so that in a diff the *change* is the one thing
  colour points at.

**The signal-less default is light.** The initial theme follows the platform's appearance
setting; where no signal can be read, the initial theme is light (`docs/UXD.md` UX-I9, RN-7,
owner-confirmed at `docs/trail/uxd/cycle-1.md` § 2.5). This document carries that default as the
frontmatter's polarity: the light values are the token values, and the dark values below are the
alternate. The reason is the UXD's own — dark text on a light ground is the more widely evidenced
legibility default for reading text, held as reasoning — and this document adds nothing to it.

**The two themes.** One token, two values; every rule above holds in both.

| Token | Light (frontmatter) | Dark |
|---|---|---|
| `primary` | `#1E1F22` | `#E7E7E4` |
| `ink-muted` | `#5B5D63` | `#ABACB0` |
| `gutter` | `#6F7177` | `#8E8F94` |
| `surface` | `#FBFBFA` | `#1B1C1E` |
| `canvas` | `#F2F2F0` | `#232427` |
| `rail` | `#EAEAE7` | `#2A2B2F` |
| `line` | `#D8D8D4` | `#3B3C41` |
| `selection` | `#E2E3DF` | `#34363B` |
| `hover` | `#EBEBE8` | `#2C2D31` |
| `git-added` | `#166A34` | `#6FCB80` |
| `git-modified` | `#8F5400` | `#E6B45B` |
| `git-deleted` | `#B3261E` | `#F28B82` |
| `git-renamed` | `#0E6B8C` | `#72C5E1` |
| `code-keyword` | `#7A2E8F` | `#D0A2E6` |
| `code-string` | `#1A6B3A` | `#8FD6A4` |
| `code-number` | `#9A4B00` | `#F0B47A` |
| `code-comment` | `#6A6C72` | `#9A9BA0` |
| `code-name` | `#0F5A9A` | `#8CC4F5` |
| `diff-added` | `#E4F4E8` | `#1E3627` |
| `diff-removed` | `#FAE3E0` | `#442528` |

**The contrast floor, as a number** (`docs/UXD.md` § 8 "Minimum contrast"; § 9 third constraint):
`{colors.primary}` holds **at least 9:1** against every surface it is drawn on — `surface`,
`canvas`, `rail`, `selection`, `hover`, `diff-added`, `diff-removed` — in both themes; **every other text
token holds at least 4.5:1** against every surface this document specifies it for, in both themes.
The specification is the contract: `ink-muted` on `surface`, `canvas`, `selection`, `hover` and the
two diff tints; `gutter` on `surface` only; the four Git tokens on `canvas`, `selection` and `hover`;
the five code tokens on `surface` only. Drawing a text token on a surface outside its specification is a
contrast defect even if the pair happens to pass. The measured minima are recorded in RN-6.

**Neither theme is ever pure.** No `#000000`, no `#FFFFFF`: the extremes are reserved so that
nothing the product draws can be mistaken for a missing style, and so that a dark reading panel
is a plane and not a void.

## Typography

Two families, neither shipped: the platform's own sans (`-apple-system, system-ui` — SF Pro on
every macOS this product runs on) and the platform's own monospace (`ui-monospace, "SF Mono",
Menlo`). Each stack is how the token format names a platform family, and the two were confirmed
in those words (`docs/trail/design/cycle-1.md` § 2.2); the shell asks the platform for its system
font and its monospaced system font at each level's size and weight, and looks up no family by
name. Nothing is downloaded and nothing is bundled, so every surface renders whole on a stock
Mac with the network off (`docs/UXD.md` UX-I15, § 9 fourth constraint), and the type is the type
the user already reads their system in — the no-learning-curve goal, at the level of letterforms.
Two weights only, 400 and 600; 500 appears once, on the rail label, where 400 at 10px loses the
stroke.

Ten levels, each with one job:

- **`{typography.ui}`** — 13px, the macOS control size. Tree rows, Git rows, menu items, the
  chrome, controls, status messages, placeholders. The shell speaks at one size.
- **`{typography.label}`** — 11px, 600, uppercase, tracked. Section headers only: *Changes*,
  *Staged*, *Branches*, and the history view's group headings. Uppercase because a header must
  read as furniture beside 13px file names, and weight alone at 11px does not separate them.
- **`{typography.rail-label}`** — 10px, 500, the word beneath each rail glyph (*Files*, *Git*).
  The only place 10px appears.
- **`{typography.path}`** — 12px mono. The open file's path line, a link's destination in
  rendered Markdown, commit identifiers, branch names in chips. Mono because these are strings
  the reader may compare character by character; 12 rather than 13 because they describe the
  content rather than being it.
- **`{typography.code}`** — 13px mono, line-height 1.55 (≈20px). The code view, raw Markdown,
  and diffs. 13/20 is the size at which the six floor languages read comfortably on a Retina
  Mac without zoom, and it matches `{typography.ui}` so a file name in the tree and the same
  name in the code are the same size.
- **`{typography.prose-body}`**, **`prose-h1`**, **`prose-h2`**, **`prose-h3`** — rendered
  Markdown: 15px body at 1.6, headings 24/20/17 at 600. Three heading levels are drawn distinct;
  h4–h6 are rendered at `prose-h3`'s size with `{colors.ink-muted}`, because a README that
  needs six levels is rarer than a reader who cannot tell 15px from 14px. The scale steps
  15 → 17 → 20 → 24 rather than a geometric ratio: each step is the smallest one that reads as a
  level change at reading distance.
- **`{typography.prose-code}`** — 13px mono inside rendered Markdown, inline and fenced, on
  `{colors.canvas}` so code stands off the prose without a border.

Rules that change an implementation choice: no text is ever smaller than 10px or lighter than
400; no italic anywhere except where Markdown source asks for it; file names are never truncated
with an ellipsis in the middle — the row clips at its end, and the text the row holds is the whole
name; the tooltip is not a row, and it is the one place a name loses its start instead of its end
(§ Components "The tooltip", RN-38);
numerals in the path level and code level are tabular (`tnum`) only if the platform font
provides it, and the implementation never substitutes a font to get them.

## Layout

One window, one shell: **rail · sidebar · reading panel**, left to right, at a fixed proportion
(`docs/UXD.md` § 4; the layout reference is `docs/ux_reference/`, layout not style).

- **The rail** is `{spacing.rail-width}` (48px) wide, full height under the chrome, holding the
  two entries — Files and Git — each `{spacing.rail-entry}` (48px) tall: a 20px glyph above a
  10px label. Nothing else is ever placed on the rail.
- **The sidebar** is `{spacing.sidebar-width}` (260px) wide and does not resize (pane resizing
  is outside the product's done — `docs/UXD.md` § 10). 260 holds a five-level path at 13px with
  the status letter beside it before clipping; wider costs the reading panel, narrower clips
  ordinary folders.
- **The reading panel** takes every remaining pixel. It is the dominant surface at any window
  size the product allows; the window's minimum width is 720px (48 + 260 + 412 of code), below
  which the panel stops being dominant and the product stops being what the PRD says it is.
- **The title bar** is the platform's own, and sits above everything this document draws. It
  carries the platform's three window buttons and draws no title. The window still has a title —
  the string the system shows in its own window lists — and it is the string the chrome names
  the folder with, changing whenever that string does; on the startup surface, where no folder
  is viewed, it is the product's name, drawn there no more than anywhere else. The bar draws no
  title *because* the chrome beneath it names the folder on the same surface: a window whose bar
  draws no title and whose chrome names no folder is a defect. The bar is shown in the theme the
  window shows — the user's own choice included, never the system's alone — and its ground is
  the platform's, the one plane in the window that is not drawn from a token. Nothing is drawn
  between the bar and the chrome. The three buttons are the platform's controls, not Nozoki's
  (RN-32).
- **The chrome** is one strip across the top of the window's content, directly beneath the title
  bar, `{spacing.chrome-height}` (36px), on `{colors.canvas}`, carrying the folder selector on
  the left and the theme control on the right, and nothing between them.

**Spacing rhythm is a 4px base**: `{spacing.xs}` 4, `{spacing.sm}` 8, `{spacing.md}` 12,
`{spacing.lg}` 16, `{spacing.xl}` 24. Rows are `{spacing.row}` (24px) tall — every row in the
product: tree rows, Git rows, menu items, section headers, commit rows, the path line. Tree
depth indents by `{spacing.indent}` (12px) per level. Code and the path line are inset
`{spacing.lg}` from the panel's left edge; rendered Markdown is inset `{spacing.xl}` and measured
at `{spacing.prose-measure}` (44rem — 704 points, § Overview) so a README does not run to the
width of a wide window.

**Responsive commitments:** none beyond the minimum width. The product runs in one window on
one platform; it has no breakpoints and no mobile layout, and does not adapt its structure to
window size.

## Elevation & Depth

**Nothing in the shell casts a shadow.** Hierarchy is carried by three stepped surface tones —
`{colors.surface}` for content, `{colors.canvas}` one step back, `{colors.rail}` one step
further — and by `{colors.line}` hairlines (`{spacing.hairline}`, 1px) between the chrome and
the shell, the rail and the sidebar, the sidebar and the reading panel, and the path line and
the content beneath it. A surface is never elevated; it is set back or brought forward by tone.

One exception, and it is the only shadow in the product: a **floating menu** (the folder
selector's list, the history view's branch-set control) sits on `{colors.surface}` with a
`{colors.line}` hairline border and one shadow — `0 4px 12px` at 16% black in light, 48% black
in dark: no sideways offset, 4 downward, a blur of 12 — because a menu that opens over content
must read as *over*, and tone alone cannot say that when the menu and the reading panel share a
surface. Nothing else may use it.

The **tooltip** (§ Components) floats too, and carries no shadow: its ground is the sidebar's
`{colors.canvas}`, one tone from its own `{colors.surface}`, and a `{colors.line}` hairline bounds
it — so tone and line say *over* in exactly the case the menu's shadow exists for the absence of,
and the count of shadows in the product stays at one (RN-23).

Focus rings: none are designed. The product has no keyboard model (`docs/UXD.md` UX-I8), so no
element ever receives keyboard focus, and drawing a ring for a state that cannot arise would be
an indicator of something the tool never established.

## Shapes

Three radii, each with one home. **`{rounded.none}`** (0px) for every row — tree rows, Git rows,
commit rows, menu items, section headers, rail entries: a row runs edge to edge and its
selection fill runs with it, the way a Finder list row does. **`{rounded.sm}`** (3px) for
things that sit *inside* a row or a line: the chrome controls, branch chips, inline code,
image placeholders, and the tooltip, which is sized to a row. **`{rounded.md}`** (6px) for the one floating menu. No larger radius exists,
and nothing is a pill or a circle.

Borders: `{colors.line}` at 1px, solid, and only where § Elevation & Depth places them plus one
more — the branch chip, the image placeholder and the tooltip carry a hairline border so they
read as bounded objects in a surface that otherwise has no boxes. No other element has a border, and no
border is ever thicker than 1px or any colour but `{colors.line}`.

**Selection is a fill and a bar.** The selected tree row is `{colors.selection}` edge to edge,
with a 2px bar of `{colors.primary}` down its left edge. The bar is the cue that survives
without colour (`docs/UXD.md` UX-A2): a fill alone is a tone difference a reader may miss; the
bar is a shape at a position.

## Components

Only components with a contract used on two or more surfaces. Each names the rule that governs
it and its tokens by `{path}`.

**The chrome and its controls.** `{components.chrome}` is the top strip. It holds two
`{components.control}`s: the **folder selector** on the left — the current folder's name
as both label and control (`docs/UXD.md` UX-F5, RN-15, RN-25), a `chevron-down` glyph after the
name — and the **theme control** on the right — a `sun` or `moon` glyph (the one that names the
theme the user would switch *to*) with the word *Light* or *Dark* beside it. A control is text
with a glyph on `{colors.canvas}`; it has no border and no fill until it is open, when it takes
`{components.control-open}`. Both controls are the whole set: nothing else is ever placed in
the chrome. The chrome names the folder, not the product — there is no wordmark, no logo,
and no product name in the shell (RN-9) — and the title bar above it draws no title for the same
reason (§ Layout, RN-32).

**The menu.** `{components.menu}` is the floating list under an open control, on
`{colors.surface}` with the one shadow (§ Elevation & Depth). `{components.menu-item}` rows
are `{spacing.row}` tall; the current item carries a leading `{colors.primary}` bar like a
selected tree row, never a checkmark glyph; the item under the pointer is
`{components.menu-item-hover}`, since every menu item is clickable. The selector's menu lists the remembered
folders — how many, in what order, and for how long is UX-S7's, and this document sets none of
it — each shown by its name; the current folder is among them, and its mark is the leading bar
above — UX-S7 hands this document the mark, and the bar is it: no checkmark glyph, no second
ink. Its last item is *Browse…*, and before any folder has been viewed it holds only *Browse…*
(RN-27, RN-28).

**The rail.** `{components.rail}` holds two `{components.rail-entry}`s. Each is a
`{components.rail-icon}` (20px) over its `{typography.rail-label}`: `folder` over *Files*,
`git-branch` over *Git*. The active entry is `{components.rail-entry-active}` — `{colors.primary}`
for glyph and label where the inactive entry is `{colors.ink-muted}` — plus the same 2px
`{colors.primary}` bar down its left edge that marks a selected row. The bar, not the tone, is
what a reader without colour reads.

**Rows.** `{components.tree-row}` is every list row in the product: the file tree, the Git
view's changed and staged files, the history view's commits, and menu items share its height,
padding and type. A row is `{spacing.row}` tall, `{typography.ui}`, on `{colors.canvas}`, and
indents by one `{components.tree-row-indent}` per level. A folder row leads with `chevron-right`
(closed) or `chevron-down` (open) then `folder` or `folder-open`; a file row leads with `file`,
or `file-code` when the file is in one of the six floor languages. The selected row is
`{components.tree-row-selected}` with the left bar (§ Shapes). **A clickable row has a hover
state and an inert row has none:** while the pointer is over a row that selection or opening
acts on — a tree row, a Git-view file row, a commit row, a menu item — the row is
`{components.tree-row-hover}`, a `{colors.hover}` fill edge to edge and nothing else: no bar, no
change of ink, no glyph. A row that nothing acts on — a section header, a status message, the
path line, a diff line — never takes it, because a hover fill promises an action, and on those
rows there is none. The selected row keeps `{colors.selection}` and its bar under the pointer;
selection outranks hover. The fill appears and leaves without transition (§ Do's and Don'ts). A
row never wraps; it clips at its end.

**Status letters.** `{components.status-added}`, `{components.status-modified}`,
`{components.status-deleted}`, `{components.status-renamed}` set the single capital letter that
trails a changed file's name — `A`, `U` (added); `M` (modified); `D`, `C` (deleted, conflict);
`R` (renamed) — in the family's hue, right-aligned in the row. The file name itself takes the
same hue in the tree and the Git view, so a changed file is visible at a glance and the letter
says which way. In the Git view the same rows sit under `{components.section-header}`s —
*Changes* and *Staged* — and the staged/unstaged distinction is the heading a row sits under,
never a hue (`docs/UXD.md` UX-A2). A count after a header (*Changes 3*) is `{colors.ink-muted}`
and is drawn only after the Git state has been read. **The letters are VS Code's badge
vocabulary, not Git porcelain's**: `U` is *untracked* and `C` is *conflict*, which is why `U`
sits with `A` and `C` with `D`. Git's own `--porcelain` output uses the same two letters for
*updated but unmerged* and *copied*, so a reader who checks this grouping against porcelain will
conclude it is wrong; it is not. The product is modelled on VS Code (`README.md` § What it is;
`docs/ux_reference/`) and the letters exist to be recognised from there (RN-24). One VS Code
behaviour is not copied: a renamed file is `R`, never `U`. The word each letter stands for is
`docs/CONTENT.md`'s to write, in this vocabulary; the tooltip (next) is where the product says it.

**The tooltip.** `{components.tooltip}` is the one floating word in the product, and it has one
home: a status letter, wherever one is drawn — the tree and the Git view. While the pointer rests
on the letter — the letter, not the row — the tooltip appears below it, its right edge on the
letter's right edge so it never runs past the sidebar, carrying the file's name and the letter's
word, in that order; the words are `docs/CONTENT.md`'s. It is `{typography.ui}` in
`{colors.primary}` on `{colors.surface}`, `{spacing.xs}` padding, `{rounded.sm}`, a
`{colors.line}` hairline and no shadow (§ Elevation & Depth); one line, never wrapped. Two edges
of the surface drawing the letter move it, each by its own rule. The rules apply independently, so
a letter on the last visible row with a long name takes both. **The bottom edge:** where the
visible part of that surface ends less than the tooltip's height below the letter, the tooltip
goes above the letter instead, its bottom edge on the letter's top edge and its right edge still on
the letter's right edge. Where there is no such room above either, it stays below and is cut by the
surface's edge there. **The left edge:** the tooltip's right edge never leaves the letter's right
edge, so where room runs out it narrows instead. It is never wider than the space from the visible
left edge of its surface to the letter's right edge. Its line is right-aligned inside it, so a line
too long for that width loses the start of the name, cut at the tooltip's left edge inside its
`{spacing.xs}` padding, with no ellipsis. The joining mark and the letter's word are always drawn
whole. Where the tooltip sits and how wide it is are decided when it appears, and neither changes
while it is shown (RN-38). It appears
after the pointer has rested on the letter for 500ms, and leaves the moment the pointer leaves the
letter or a refresh changes the row's state — appearing and leaving in place, with no transition.
It stacks with the row's hover fill, which is the row's and not the letter's: the row shows
`{colors.hover}` and the tooltip sits over it. No other surface raises a tooltip: the rail
entries, the chrome controls and every status glyph already carry their word beside them, and a
tooltip there would be a second surface for words the label already carries (RN-11, RN-23).

**The reading panel.** `{components.reading-panel}` is the content surface. Its first row is
`{components.path-line}` when it shows the selected file's content or outcome: text, including
an empty text file; cannot-display; an observed failed read, including a file gone or unreadable;
or an unexplained fault. The line carries the file's folder-relative path in `{typography.path}`
and `{colors.ink-muted}`, a hairline beneath it. The no-file prompt carries no path line.

The single path-text line is centred vertically in its own `{components.path-line}` row,
using `{typography.path}`'s line height: the space above and below the line box is equal.
The hairline sits beneath the row, outside the centring calculation. This placement holds
in both themes and in code, rendered Markdown, raw source and diff, wherever the panel's
state rule shows a path, including above empty text, cannot-display, failed-read and fault
outcomes. A long path stays one line and keeps that vertical placement when clipped.
The row's height, type and horizontal inset come from their existing tokens (RN-37).

While a selected file is still being read, the panel shows only `{components.status-message}`
in `docs/CONTENT.md`'s Loading wording, without a path line. On a replacement selection,
the earlier file's path and content leave the panel before the new pending message appears;
an obsolete reply restores neither. A fault replaces pending with the failure under the current
selection's path; the tree stays enabled as the route out. These selection states do not change
the reading-position rule for a live refresh (UX-I3; RN-36).

The path line is the same in the code view, the rendered Markdown view, the raw view and a diff
(`docs/UXD.md` § 9 last constraint); where a release ships the raw-source switch, it is one
`{components.control}` at the path line's right end, labelled *Rendered* or *Source* for the
state it would switch to.

**Code.** `{components.code-surface}` is the code view: `{typography.code}` on
`{colors.surface}`, inset `{spacing.lg}`, with `{components.code-gutter}` line numbers in
`{colors.gutter}`. The gutter column is `{spacing.xl}` wide plus the width of the digits the
current file needs. Its `padding` token applies at the **right edge only**: reserve
`{spacing.sm}` inside that width, right-align each number to the start of the padding, and
begin the code at the column's outer right edge. The separation is included in the column's
width. Keep `{spacing.lg}` before the column and the code's existing insets. The padding
stays with the fixed gutter, outside horizontally scrolling content; scrolling cannot erase
the separation or draw code over the numbers. This geometry holds in both themes and for
plain text, highlighted code and raw Markdown. A change in digit count changes the digit
allowance, not the padding; empty content invents no number. (RN-35.)
Syntax roles are `{components.code-keyword}`, `{components.code-string}`,
`{components.code-number}`, `{components.code-comment}`, `{components.code-name}`; everything
else is `{colors.primary}`. No current-line highlight, no bracket colouring, no minimap, no
indent guides — each is an element the reading panel would carry that the file does not.

**Diff.** A diff reuses `{components.code-surface}` with two line variants:
`{components.diff-line-added}` on `{colors.diff-added}` and `{components.diff-line-removed}` on
`{colors.diff-removed}`, each led by `{components.diff-sign-added}` / `{components.diff-sign-removed}`
— a `+` or `−` in `{colors.ink-muted}` in the gutter column — so the sign carries the meaning and
the tint repeats it. The shared column keeps the code gutter's right padding inside its width:
right-align the sign to the start of that padding and begin the diff text at the column's
outer right edge. The padding stays outside horizontally scrolling content, as in Code;
this changes no diff content or numbering rule. (RN-35.)
Diff text is `{colors.primary}` throughout: no syntax colour in a diff.
Staged and unstaged hunks are separated by a `{components.section-header}` (*Staged*,
*Unstaged*), never by hue.

**Rendered Markdown.** `{components.prose}` at `{spacing.prose-measure}`, with
`{components.prose-h1}`–`{components.prose-h3}` and `{components.prose-code}` for inline and
fenced code. A link is `{components.link-text}` — the link's own text, underlined with a 1px
`{colors.ink-muted}` underline — followed by `{components.link-destination}`: its destination in
`{typography.path}` and `{colors.ink-muted}`, in parentheses, on the same line. The destination
is always shown; the text is a control only in a release that opens relative links, and then
only for a relative link (`docs/UXD.md` UX-I12) — and even then it is drawn no differently, since
it looks the way it looks because of what it is, not because of what it does. An image has three
cases (`docs/UXD.md` UX-I12). An image whose file is inside the folder **renders in place**, at its
own size and no wider than `{spacing.prose-measure}`, with no border, no radius and no caption the
source did not write — it is the reader's content, and the tool adds nothing to it. An image
referenced outside the folder — a remote address, or a path that escapes it — and an in-folder
image whose file is missing, unreadable or not an image are both `{components.image-placeholder}`:
a bordered box on `{colors.canvas}` where the image would be, holding the image's alt text and,
beneath it, its source in `{typography.path}`, and stating what was observed — content outside the
folder is not fetched, or this file is not shown — in `docs/CONTENT.md`'s words; never a
broken-image glyph (RN-13, RN-28).

**Status messages.** `{components.status-message}` is every empty, pending, and failure state
the UXD names (`docs/UXD.md` § 6): the empty reading panel, the empty tree, the clean Git view,
a cannot-display placeholder, a vanished file, an unreadable entry, the startup surface in both
its states (below) — and, in every failure slot, the second class § 6 gives each of them, the **unexplained fault** (UX-I16):
the surface's work stopped and nothing read accounts for it, drawn in the same slot, at the same
scope, with the same route out as the observed condition it sits beside; only the words differ,
and those are `docs/CONTENT.md`'s. **One state § 6 names is not this component:** the Git view of an
**observed plain folder** (UX-I17) shows nothing — no message, no label, no glyph, no control — and
so holds no instance of `{components.status-message}`; it carries no words because the two things
a Git-less folder would otherwise be offered, initialising a repository and publishing it, are
writes this product can never offer, so there is no truthful next step to state (the owner's
decision, `docs/trail/prd/cycle-10.md` § 2.2). The exception is exactly that wide: the Git view
**before** the tool has found whether the folder is a repository is a pending status message
(UX-I13), and a Git view whose finding-out **stopped** is the unexplained fault, a failure status
message (UX-I16) — never nothing. A clean repository and a plain folder are told apart by what the
clean view carries — the branch and its stated "nothing changed" — against nothing at all; the
shell adds no other cue (UXD RN-27). It is
`{typography.ui}` in `{colors.ink-muted}` on `{colors.surface}`, inset `{spacing.xl}`,
left-aligned at the top of its surface — never centred in the void, because a centred message
is a watermark and the product has none. It leads with `info` for an empty or pending state and
`circle-alert` for a failure, and the glyph never stands alone: the sentence beside it is the
state. A pending state carries no spinner and no bar; the word says the state is pending, in
`docs/CONTENT.md`'s wording, and nothing moves.
A failure message is followed on the same surface by its route out — the tree beside it, the
selector, or a way back — and where the failure is the startup surface's, the message names what
to change and the surface carries the way to leave.

**The startup surface.** UX-S4 is one plane of `{colors.surface}` filling the window beneath the
platform's title bar (§ Layout) — no chrome,
no rail, no sidebar, because each of those names or holds a folder's content and there is none
yet; what loads next is the workbench, not this surface — carrying one `{components.status-message}`
at its top-left and, beneath it in the same column, its routes as `{components.control}`s: text
alone, `{typography.ui}` in `{colors.primary}`, one to a `{spacing.row}`, no glyph, because the
fourteen-glyph inventory holds no glyph for *leave* and a glyph on one route and none on the other
would rank them. Its **empty** state — the Open panel dismissed before any folder is chosen — leads
with `info`, carries no failure sentence, and its two routes are to choose a folder and to leave;
its **failure** state — a path that does not exist, is not a folder, or cannot be read — leads with
`circle-alert`, and its route is to change the path and start again, with the way to leave beside
it. Beyond v1 the route to a folder is the selector's browse entry (UX-S7). The surface renders in
the app's window and nowhere else — no surface of this product prints to a terminal
(`docs/UXD.md` UX-S4, RN-29; RN-28).

**The history.** The Git view carries one row for the commit history — a `{components.tree-row}`
led by `clock` — and opening it draws the history **in the sidebar**: the commit rows follow
beneath the changes list, under their own `{components.section-header}`, each a
`{components.tree-row}` led by `git-commit-horizontal` (or `git-merge` for a merge commit) with the
rails and dots below in its indent column; the selected commit's row is
`{components.tree-row-selected}`, and its diff takes the reading panel exactly as "Diff" draws
it. Where the loaded history stops short of the repository's, the list ends in one **inert** row —
`{typography.ui}` in `{colors.ink-muted}` on `{colors.canvas}`, `{spacing.row}` tall, indented as
a commit row, no glyph, no hover fill, no control — stating that older commits are not shown, in
`docs/CONTENT.md`'s words; where the whole history fits, no such row is drawn (`docs/UXD.md` § 4,
UX-S6; RN-28).

**The branch chip.** `{components.branch-chip}` names a branch at its tip commit in the history
view and in the Git view's header — on a detached HEAD the Git view's chip carries the commit's
identifier in the branch's place (`docs/UXD.md` UX-S3), in the same level, which is the one commit
identifiers already take (RN-28): `{typography.path}` on `{colors.canvas}`, hairline border,
`{rounded.sm}`, with `git-branch` leading. Graph rails and commit dots in the history view are
`{colors.ink-muted}` lines and `{colors.primary}` dots at `{spacing.icon}` — no per-branch
colour; the chips name the branches, and colour would be a code the reader has to learn.

**Icons.** `{components.icon}` is 16px, `{components.rail-icon}` 20px, both drawn from the
fourteen Lucide glyphs vendored at `third_party/lucide/icons/` (ISC, `third_party/lucide/LICENSE`):
`chevron-right`, `chevron-down`, `folder`, `folder-open`, `file`, `file-code`, `git-branch`,
`git-commit-horizontal`, `git-merge`, `clock`, `info`, `circle-alert`, `sun`, `moon`. Each file
strokes in `currentColor` at the set's own 2px, and a native view has no current colour to hand
it: the shell draws every glyph in the ink of the text beside it, so a glyph is always the colour
of that text.
This set is the whole inventory: a surface that needs a fifteenth glyph vendors it with the
notice, and never draws it from an icon font or a remote origin. `git-commit-horizontal` marks
a commit row, `git-merge` a merge commit, `clock` the history entry in the Git view.

**The application icon.** The one thing of Nozoki's that is drawn outside the window: macOS
shows it in the Dock, the application switcher and Finder, and on the disk image a release is
offered as. It is Nozoki's own icon: **one drawn figure in `{colors.primary}` on a ground of
`{colors.surface}`**, both at their light values, which is the polarity the frontmatter carries
(§ Colors). No other colour appears in it — no hue, and neither pure black nor pure white — so
the shell's signature holds where the shell is not. The figure is not lettering: no letter, no
word and no kanji; the product's name and 覗き stay on the README (RN-9). The three radii of
§ Shapes do not bind it, because the icon's outline is the platform's application-icon shape and
not one of this document's. What the figure depicts is not fixed here: it is drawn separately
and recorded in this paragraph once the owner has signed it off, and until then this contract is
the whole rule. **No stand-in ships.** A release carries the drawn icon, or the bundle names no
icon file and macOS draws its generic application icon; the uniform blue square at
`nozoki-mac/icon.icns` is a leftover of an earlier host and is never a decided value. The icon
is a fixed file, so it is the one place a token's value is copied and not read: when the light
value of `{colors.primary}` or `{colors.surface}` moves, the icon is redrawn. **Nozoki supplies
one drawing, at the light values, and makes no second.** No variant is drawn for any of the
system's icon appearances: default, dark, clear or tinted. How macOS shows the icon under one of
those appearances is the platform's, and this document promises nothing about it. A variant the
system generates or tints from the drawing is the platform's rendering, as the title bar's ground
is (§ Layout). So every rule of this paragraph binds the drawing Nozoki supplies and not that
rendering: the two tokens, no hue, and neither pure black nor pure white (RN-33, RN-34).

## Do's and Don'ts

- Do read every colour and size from a token, defined once in the shell's source; a literal hex
  or point value written where a surface is drawn is a second source and a defect. Two things
  sit outside this rule and nothing else does: the title bar's ground, which is the platform's,
  and the application icon, a fixed file that is redrawn when either of its two tokens moves.
- Do give every state distinction a cue that is not a hue — a letter, a word, a bar, a heading —
  and treat the hue as the repeat.
- Do draw every text token only on the surfaces § Colors specifies it for; a pair outside that
  specification is a contrast defect even when it passes.
- Do draw an indicator — a status letter, a count, a "nothing changed", a pending word — only
  after Nozoki has read the state it stands for, and show pending as a word, in
  `docs/CONTENT.md`'s wording, not as a bar or a spinner.
- Do leave every failure surface with an enabled route out on that same surface: the tree, the
  selector, or a way back to the state before.
- Do keep every asset inside the installed product: the two families are the platform's, the
  fourteen glyphs are vendored, and a surface renders whole with the network unavailable.
- Do keep the chrome to two controls and the rail to two entries; the three window buttons in the
  title bar are the platform's and are not counted.
- Do keep the platform's own title bar and draw no title in it; title the window with the string
  the chrome names the folder with, retitle it whenever that string changes, and show the bar in
  the theme the window shows, the user's own choice included.
- Do draw the hover fill only on a row that a click acts on, and never on a row that nothing
  acts on; the hover is a promise of an action, and a promise with nothing behind it is a lie.
- Do show a status letter's word in the tooltip the letter itself raises, and raise a tooltip
  nowhere else — every other glyph and control already carries its word beside it.
- Don't animate. No transition on selection, hover, tooltip, theme, mode switch or content
  update; a change
  appears in place, and nothing moves that did not change.
- Don't draw a focus ring, a badge, a toast, or a notification — none exists in the product;
  don't raise a tooltip on anything but a status letter; and don't draw the hover fill on anything
  that is not a clickable row.
- Don't draw an editing affordance, enabled or disabled, or any control that writes: no cursor
  caret in the code view, no commit box, no refresh button.
- Don't fetch a font, an icon, an image or a stylesheet from any origin at runtime; a remote image
  in Markdown is a placeholder, never a request.
- Don't use pure black or pure white, a shadow outside the one floating menu, a radius above
  6px, a weight other than 400/600 (500 on the rail label only), or a Git hue for anything that
  is not Git state.
- Don't put a wordmark, a logo, or the product's name in the shell; the chrome names the
  folder, and the title bar draws no title. Where macOS itself shows the product's name — the
  menu bar, the Dock, the application switcher, and the window's title while no folder is
  viewed — it is the platform's to show, and this rule does not reach it.
- Don't ship a stand-in application icon: a release carries the drawn icon, or the bundle names
  no icon file. Don't put a hue, a letter, pure black or pure white in the icon. Don't draw a
  second icon for a dark, clear or tinted system appearance: Nozoki supplies one drawing, and
  what macOS generates from it for those appearances is the platform's and is not held to these
  rules.
- Don't design a keyboard model, a search field, a resize handle, or a second platform's
  controls; each is outside the product's done.

---

## DESIGN Review Notes

- **RN-1:** *(changed at revision 11 — evidence change, RN-31)* The one system is a workbench
  from primitives, realised in AppKit on macOS, with the platform's own look as the starting
  point — *because* the UXD's direction names a workbench from primitives and the platform's own
  controls and appearance as the start (`docs/UXD.md` § 9, owner-confirmed
  `docs/trail/uxd/cycle-1.md` § 2.1), the product is macOS-only (`docs/SRS.md` C-11), the
  instance's direction starts every product from its platform's defaults, and the product's own
  source is one AppKit shell in Swift with no web engine in it (`README.md` § Stack;
  `nozoki-mac/`). Revisions 1–10 read *plain CSS custom properties* here, on the proposal's word
  and the README's as it then stood (`docs/proposal.md` § Styling; `README.md` § Planned stack, a
  heading that file no longer has), and held that every value was a CSS value, good in a browser
  tab or a native window alike, the runtime being the SDD's to choose. The SDD chose the native
  window (`docs/SDD.md` § 2), and no value moved when it did (RN-31). *(re: § Overview; source:
  UXD § 9; `README.md`; `nozoki-mac/`)*
- **RN-2:** **The shell is achromatic and colour is the repository's** — the signature, and the
  one aesthetic risk this document takes: a workbench with no accent can read as unstyled.
  *Because* the product presents state and acts on nothing (`docs/PRD.md` § UX Notes "The
  character"); the only meanings the surface carries that are not the user's own content are Git
  state and syntax; and the UXD already frames density as the repository's, not the shell's
  (`docs/UXD.md` § 2). An accent for interaction would colour a product whose interactions are
  choosing what to look at. The risk is held by the left bar on selection and the rail (§ Shapes)
  — the structural cue that makes an achromatic selected state unambiguous. Stated design reason;
  no evidence pins a palette (the instance carries none). The alternative rejected is a single
  accent for selection and controls, which is the default a workbench reaches for. **Confirmed by
  the owner** — "confirm", and the argument as put to them is recorded there
  (`docs/trail/design/cycle-1.md` § 2.1). *(re: § Colors, `{colors.selection}`,
  `{colors.primary}`; source: design reason; owner answer)*
- **RN-3:** The neutral scale is three steps and one hairline per theme, cool-neutral, and never
  pure black or white — *because* the surfaces the product has are exactly three (content,
  sidebar/chrome, rail) and a scale with more steps than surfaces invents surfaces; the extremes
  are reserved so a missing style is never mistaken for a designed one (§ Colors). The values
  are chosen, not found; the light set sits slightly warm of neutral grey and the dark set slightly
  cool, each the direction that keeps the platform's own text rendering looking like itself on
  that ground. *(re: `{colors.surface}`, `{colors.canvas}`, `{colors.rail}`, `{colors.line}`,
  `{colors.selection}`; source: design reason)*
- **RN-4:** Git state is four hue families for six status letters, and diffs carry no syntax
  colour — *because* the letter is the meaning (`docs/UXD.md` UX-A2; the reference's own lesson,
  `docs/ux_reference/README.md` § `vscode-git-view.png`), so a hue per letter would be six codes
  to learn where four families say *here / changed / gone / moved*; and in a diff the change is
  the one thing to see, so the added/removed tint is the only colour. The hues are chosen; the
  green/amber/red/teal assignment follows the near-universal convention for add/modify/delete so
  that the repeat is one the reader already has. **Both calls confirmed by the owner**, on the
  stated understanding that a diff already carries colour in its two tints and the syntax layer
  would be a further one on top, not the diff's only colour (`docs/trail/design/cycle-1.md`
  § 2.4). *(re: `{colors.git-*}`, `{colors.diff-*}`; source: design reason; owner answer)*
- **RN-5:** Five syntax roles, not more — *because* the highlighting promise is six
  data-and-scripting languages (`docs/PRD.md` § Core Features) whose grammars map onto keyword,
  string, number, comment and name, and each further role is one more hue in a still surface.
  Highlighting itself is held as a domain expectation, never claimed as a comprehension benefit
  (`docs/UXD.md` § 9, RN-18). *(re: `{colors.code-*}`; source: design reason; UXD § 9)*
- **RN-6:** The contrast floor is stated as two numbers — ink ≥ 9:1, every other text token
  ≥ 4.5:1, each against the surfaces it is specified for — *because* the UXD asks for the floor
  as a number and makes it the product's floor from the moment it is written (`docs/UXD.md` § 8,
  § 9). Measured with the WCAG 2.x relative-luminance formula on this run, the minima are: ink on
  selection 12.78 (light) and 9.76 (dark); `ink-muted` on selection 5.10 (light); `gutter` on
  surface 4.71 (light); `git-renamed` on selection 4.65 (light) — the lowest Git pair; `git-deleted`
  on selection 5.06 (dark); `code-comment` on surface 5.07 (light). 9:1 rather than 7:1 for ink
  because the palette clears it with margin and a stated number should be the one the values
  hold, not a threshold they happen to exceed. The machine gate checks only the frontmatter's
  light pairs; the dark pairs are this document's own check, recorded here. **Confirmed by the
  owner** at the two drafted numbers (`docs/trail/design/cycle-1.md` § 2.7). Revision 2 adds
  `hover` to the surfaces `primary`, `ink-muted` and the four Git tokens are specified for; its
  minima are in RN-22. *(re: § Colors "The contrast floor"; source: computed on this run, UXD
  § 8; owner answer)*
- **RN-7:** Type is the platform's own two families, nothing shipped — *because* every asset
  must ship with the tool or already be on the machine (`docs/UXD.md` UX-I15, § 9), the product is
  macOS-only where SF Pro and SF Mono are stock (`docs/SRS.md` C-11), the instance's direction
  starts from the platform default, and the UXD's typography dial is 2 with the reason that
  character in the type would be the one decorative element (`docs/UXD.md` § 2). Shipping a
  face would be a design choice the brief argues against. The sizes are the platform's: 13px is
  macOS's regular control size, and the scale is built from it rather than from a ratio.
  `scripts/design-check.mjs` says "fonts are self-hosted"; this document ships none, which
  satisfies the check by having nothing to host. **Confirmed by the owner** — no typeface is
  shipped (`docs/trail/design/cycle-1.md` § 2.2). *(re: `{typography.*}`; source: UXD § 2, § 9;
  `docs/SRS.md` C-11; `scripts/design-check.mjs`; owner answer)*
- **RN-8:** Widths — rail 48, sidebar 260, chrome 36, minimum window 720, rows 24, indent 12 —
  *because* the proposal's 240–280 sidebar is input and 260 is the midpoint that holds a
  five-level path at 13px (`docs/proposal.md` § UI Shape, carried as visual design the PRD
  explicitly leaves downstream, `docs/PRD.md` § Out of Scope); a 48px rail is the smallest square
  that holds a 20px glyph over a 10px label with the row rhythm's 4px margins; 24px rows are the
  platform's list row height at 13px text; and 720 is the width below which the reading panel
  stops dominating. Pane resizing is outside done, so the sidebar width is a value, not a range.
  **Every measurement confirmed by the owner** as drafted (`docs/trail/design/cycle-1.md` § 2.3).
  *(re: `{spacing.*}`; source: design reason; `docs/proposal.md`; UXD § 10; owner answer)*
- **RN-9:** No wordmark, logo or product name in the shell — *because* the one job is what is on
  the surface and the chrome's element is the folder's identity (`docs/UXD.md` § 4, RN-2), the
  instance carries no shared mark, and a product name in the chrome would be the one thing on
  screen that is Nozoki's rather than the folder's. The product's name and its kanji live on
  the README, which is the CPO's. **Confirmed by the owner** (`docs/trail/design/cycle-1.md`
  § 2.6). *(re: § Components "The chrome"; source: UXD § 4; design reason; owner answer)*
- **RN-10:** The theme control is in the chrome, right end, glyph plus word — *because* the UXD
  requires that the user may override the theme (UX-I9) and that every preference is reversible
  by the control that set it (UX-I7), but places the control nowhere; the chrome is the one
  surface reachable in every mode, and the rail and sidebar are the folder's. This is a
  structural placement the UXD does not make, so it went to the owner, who **confirmed it**
  knowing the confirmation carried a UXD amendment with it (`docs/trail/design/cycle-1.md`
  § 2.5). The UXD half was not this document's to write: the owner re-opened the UXD's companion
  with that one already-answered item (`nozoki@ee8abcf`) and `product-uxd` folded it — `docs/UXD.md`
  § 4 now records the chrome as the control's home, its RN-22 carries the basis, and the owner's
  answer is readable at `docs/trail/uxd/cycle-2.md` § 1.1 (`nozoki@f4bc928`). The two documents
  state one placement between them; revision 3 updates this note's tense and the Traceability row
  on the owner's cycle-2 answer (`docs/trail/design/cycle-2.md` § 1.3). The glyph names the theme the control switches *to*, so the control reads as an action
  rather than a status. *(re: § Components "The chrome"; source: UXD UX-I9, UX-I7; design reason;
  owner answer; **changed** — placement added beyond the UXD, confirmed)*
- **RN-11:** No focus ring and no transition — *because* the motion dial is 2 with "only what
  actually changed changes" (`docs/UXD.md` § 2, UX-I2) and the product has no keyboard model to
  focus (UX-I8); each absence is a count of elements removed, which is the tie-breaker the
  instance's direction hands a design run. Revision 1 drafted two further absences, and the owner
  has since overridden both; this note records each. **Hover** — *"hovering is something that
  developers use"* (`docs/trail/design/cycle-1.md` § 2.3): a hover state enters, scoped as the
  owner stated it to rows that are actually clickable, never to an inert row where a fill would
  promise an action that is not there (§ Components "Rows", RN-22). **Tooltip** — *"i think that
  tooltips should be included in v1"*, given while settling the status letters and recorded as a
  v1 decision rather than a one-off exception (`docs/trail/design/cycle-2.md` § 1.1; the ruling's
  own record is `docs/CONTENT_open_issues.md` § 1.2 at `nozoki@3692585`). Revision 1's reason for
  the ban — that a tooltip is a second surface for words the label already carries (UX-A4) — holds
  wherever a control carries its own word, the rail entries and the chrome controls, and it is why
  those still raise none; it never covered a status letter, a single character carrying no word at
  all, which is the one case the rule was written without in view. The tooltip's contract is
  RN-23. The no-transition rule and the absent focus ring were not spoken to and stand. *(re:
  § Components "Rows", "The tooltip", § Elevation & Depth, § Do's and Don'ts; source: UXD § 2,
  UX-I2, UX-I8; design reason; owner answers — **changed**)*
- **RN-12:** The Lucide set on disk is the icon inventory, and the rail carries `folder` and
  `git-branch` — *because* the fourteen glyphs are the product's own vendored source
  (`third_party/lucide/icons/`, ISC notice at `third_party/lucide/LICENSE`, committed at
  `c4fb333`), the proposal names Lucide (`docs/proposal.md` § Core stack), and the UXD hands the
  choice of rail icons to this document (`docs/UXD.md` RN-16). Which glyph does which job is this
  document's assignment; the rail pair, the fourteen-glyph inventory and the theme control's
  placement were **confirmed by the owner together** — "confirm all three"
  (`docs/trail/design/cycle-1.md` § 2.5). The set is treated as a fence: a fifteenth glyph is
  vendored, never fetched. *(re: § Components "Icons", "The rail"; source: `third_party/lucide/`,
  `docs/proposal.md`, UXD RN-16; owner answer)*
- **RN-13:** Links in rendered Markdown are text plus a readable destination, and an image the
  render does not show — referenced outside the folder, or broken inside it — is a bordered
  placeholder with alt text and source, while an in-folder image renders in place (the three cases
  since revision 8, RN-28) — *because* the UXD settles the behaviour (UX-I12, owner-confirmed
  `docs/trail/uxd/cycle-1.md` § 2.6; the three image cases `docs/trail/uxd/cycle-6.md` § 2.1) and
  this document only says what it looks like: a muted underline rather than a link colour, since the shell has no link colour and
  a colour would promise a control; the destination in the path level because it is a string the
  reader may copy. *(re: § Components "Rendered Markdown"; source: UXD UX-I12)*
- **RN-14:** Status messages are top-left, muted, glyph-led and never centred — *because* the
  UXD forbids a watermark and a shortcut list in the empty panel (UX-S1) and the reference
  excludes VS Code's centred empty-state content (`docs/ux_reference/README.md`); a top-left
  sentence is where the eye goes for the next thing to read, and a centred one is decoration.
  Pending states carry a word and nothing that moves, so no progress is ever implied that was
  not observed (UX-I13). *(re: § Components "Status messages"; source: UXD UX-S1, UX-I13; design
  reason)*
- **RN-15:** The one shadow, on floating menus — *because* a menu over a reading panel of the
  same surface tone cannot be told apart by tone, and a hairline alone reads as a box in the page
  rather than over it; every other surface is separated by tone and hairline, so the shadow's
  rarity is what makes it legible. *(re: § Elevation & Depth; source: design reason)*
- **RN-16:** *(retired at revision 8 — upstream UXD change)* Revisions 1–7 carried a terminal
  Don't — no colour or control sequence from any surface that prints to a terminal under
  `NO_COLOR` or when not a TTY, and no printed failure cleared before control returns — *because*
  where the startup failure rendered was open until the SDD fixed the start mechanism
  (`docs/UXD.md` v7 § Open Questions), and the rule was written to hold for whichever answer came.
  The answer came: UX-S4 renders in the app's window, never as text printed where the tool was
  started (`docs/UXD.md` v9 UX-S4, RN-29; the system Open panel, `docs/SDD.md` § 4 C-R3), the UXD's
  § Open Questions is gone, and its RN-11 records that `terminal-no-color-no-tty` reaches no surface
  this product has. A Don't binding a surface the product does not have changes no implementation
  choice, so it is removed rather than kept as a hedge; the instance's fence still binds any
  terminal surface a later product has, and this document is not where that fence lives. The
  Traceability row that cited § Open Questions goes with it (RN-28). *(re: § Do's and Don'ts;
  source: upstream UXD change, `docs/UXD.md` v9 UX-S4, RN-11, RN-29)*
- **RN-17:** The frontmatter carries the light values and the dark values sit in a table —
  *because* the format has one value per token and no mode schema (its own spec, read on this
  run), and the product's signal-less default is light (UX-I9), so the polarity the schema
  carries is the one the product falls back to. *(re: § Colors "The two themes"; source: UXD
  UX-I9; the vendor's `spec --rules` at 0.4.0)*
- **RN-18:** An earlier token set for this product exists in the repository's history — a design
  reference with nine token files, twenty specimens and a wordmark treatment, added at `c4fb333`
  and removed at `1d5c553` ("comes out of the repo for the instance-pointing experiment"). It is
  **not** read as evidence here: it is not on disk, it was produced by a design run rather than
  by the product's own code, and a design-run output enters this document only through a pointer
  item the owner writes into the companion. Every value here is derived fresh. **The owner
  closed the question: this draft is the baseline** — *"i prefer not to use the old
  information"* (`docs/trail/design/cycle-1.md` § 1.1). The earlier set is not folded, no
  pointer item is written for it, and the restore command `1d5c553` records is deliberately not
  used; its values stay history. *(re: whole document; source: `git log` of the product
  repository; owner answer)*
- **RN-19:** The SRS was read as a sibling and no collision was found: FR-20 (two themes), FR-21
  (own state outside the repository), FR-24 (no editing affordance), FR-29–FR-32 (plain text
  outside the floor, Markdown rendered, the optional switch, nothing fetched) and NFR-8 are each
  satisfied by a rule above without a value derived from any of them. C-3 leaves the runtime to
  the SDD, which has since chosen it; RN-1 and RN-31 record that no value here moved when it did.
  *(re: whole document; source: `docs/SRS.md`)*
- **RN-20:** The Agari was walked: diffs, history and the folder selector are inside done and
  have contracts here; search, resizing, keyboard navigation and a second platform are outside
  done and have none, and § Do's and Don'ts says so rather than leaving room for them. Motion has
  no token category in the format, so its policy is prose (§ Do's and Don'ts, RN-11); no
  category is declared in `omitted:` because each of the five applies. *(re: § Do's and Don'ts,
  frontmatter; source: `system/projects/nozoki/agari.md`, UXD § 10)*
- **RN-21:** The machine gate on revision 3 — `npx @google/design.md@0.4.0 lint`, run
  2026-08-26 — reported 0 errors, 0 warnings and 1 info, the info being `token-summary` (20
  colours, 10 typography levels, 3 rounding levels, 15 spacing tokens, 46 components — the
  forty-sixth is `{components.tooltip}`); no diagnostic is accepted or routed. Revision 2's run
  reported the same counts at 45 components. The gate checks only the frontmatter's light pairs; RN-6
  and RN-22 carry the dark pairs. Revision 1's run reported 0 errors, 0 warnings and 1 info
  (`token-summary`: 19 colours, 10 typography levels, 3 rounding levels, 15 spacing tokens, 43
  components). *(re: whole document; source: the linter's JSON summary on this run)*
- **RN-22:** `{colors.hover}` is `#EBEBE8` in light and `#2C2D31` in dark, one step between
  `canvas` and `selection` in each theme, and it carries two component pairs
  (`{components.tree-row-hover}`, `{components.menu-item-hover}`) — *because* the owner's
  override (RN-11) adds a state between rest and selected, and a fill that sat outside the
  canvas→selection run would read as a fourth surface rather than a row state; the value is
  chosen so that rest, hovered and selected step in one direction, measured in relative luminance
  (light 0.887 → 0.829 → 0.764; dark 0.018 → 0.026 → 0.037). Every text token specified for it
  was re-checked on this run with the WCAG 2.x formula and clears the floor: `primary` 13.80
  (light) / 11.10 (dark); `ink-muted` 5.51 / 6.06; the lowest Git pair `git-renamed` 5.02 (light)
  and `git-deleted` 5.76 (dark). No other value moved. The hover is a fill and nothing else — no
  bar, no ink change, no transition — so the selected row's bar stays the one cue that outranks it,
  and the motion posture (RN-11) is untouched. *(re: `{colors.hover}`, § Components "Rows", "The
  menu"; source: owner answer `docs/trail/design/cycle-1.md` § 2.3; computed on this run)*

- **RN-23:** The tooltip is one component with one home — the status letter — drawn as
  `{typography.ui}` in `{colors.primary}` on `{colors.surface}` with a `{colors.line}` hairline,
  `{rounded.sm}`, `{spacing.xs}` padding and no shadow; raised by the letter after a 500ms rest,
  dismissed when the pointer leaves it, stacked over the row's hover fill, and raised by no other
  surface — *because* the owner put a tooltip in v1 for the letter's sake and described the
  behaviour they meant: *"in VS code, when you hover over an `M` for example, there's a short-time
  'file and + Modified'"* (`docs/trail/design/cycle-2.md` § 1.1). Every value under that is this
  seat's, decided by the direction's order. No new colour or type level enters, because the shell
  speaks at one size and the pair `primary` on `surface` is already specified and measured (RN-6)
  — the count of new tokens is zero. No shadow, because the tooltip's ground is `canvas`, one tone
  from `surface`, which is precisely the case the menu's shadow exists for the absence of (RN-15)
  — the count of shadows stays at one. The trigger is the letter and not the row, because the
  row's hover already means *clickable* and the tooltip means *what this letter says*; one target
  for two meanings would be one cue doing two jobs. The 500ms rest is chosen so a pointer crossing
  the sidebar toward a row raises nothing on the letters it passes, while a deliberate stop reads
  as answered; it is a delay before an appearance in place, not a transition, so the motion posture
  holds. Dismissal is on leaving rather than on a timer: the owner's *short-time* is read as *while
  you hover*, which is the VS Code behaviour they described, and it costs no second clock to tune.
  The words the tooltip carries are `docs/CONTENT.md`'s (RN-24). *(re: `{components.tooltip}`,
  § Components "The tooltip", § Elevation & Depth, § Shapes, § Do's and Don'ts; source: owner
  answer; design reason)*
- **RN-24:** The status letters follow VS Code's badge vocabulary — `U` untracked, `C` conflict —
  and § Components now says so where revision 2 left it implicit; the grouping itself does not
  move — *because* the owner's cycle-2 round opened this as a defect on the premise that Git
  porcelain's `U` (updated but unmerged) and `C` (copied) were the letters' meanings, and the
  research the owner asked for found the premise wrong: the two write-ups the owner's answer
  cites agree that VS Code's `U` means *Untracked* and `C` means *Conflict*
  (https://bobbyhadz.com/blog/what-are-u-and-m-file-markers-in-vscode;
  https://www.mehmetbaykar.com/posts/understanding-git-status-indicators-u-m-a-d-c-r-in-vs-code/),
  with the colours this document already draws — U and A green, M amber, D red. The owner's
  ruling: *"No change to `DESIGN.md`. Its mapping is correct"* (`docs/trail/design/cycle-2.md`
  § 1.2, `nozoki@fdee2fc`). VS Code's is the right vocabulary because the product is modelled on
  it and the letters exist to be recognised by readers who have seen them there, not in porcelain
  output; the collision is written into § Components because an unstated convention that
  contradicts the underlying tool is a defect the next careful reader introduces. Not copied from
  VS Code: badging a renamed file `U` — Nozoki keeps `R`, since collapsing renamed into untracked
  would lose a distinction the four families draw. The consequence lands in `docs/CONTENT.md`,
  whose expansion at its revision 1 uses porcelain's words (*copied*, *unmerged*); the correction
  is recorded on that document's own companion (`docs/CONTENT_open_issues.md` § 1.2,
  `nozoki@1593434`) and is the Content Editor's, not this document's. *(re: § Components "Status
  letters"; source: owner answer)*
- **RN-25:** *(upstream UXD change)* `{components.status-message}` names the **unexplained fault**
  as the second class of every failure state it covers, and the Traceability table carries a UX-I16
  row — *because* the UXD reached v5 after revision 3 was authored and its § 6 now holds two classes
  per failure cell, with UX-I16 giving the second its presentation; revision 3's enumeration listed
  observed conditions only, so its claim to cover *every* failure state the UXD names had gone stale
  (`docs/trail/design/cycle-3.md` § 1.1, § 1.2). The enumeration moves and the treatment does not:
  `circle-alert`, `{typography.ui}` in `{colors.ink-muted}` on `{colors.surface}`, inset
  `{spacing.xl}`, top-left and never centred, the glyph never alone, the route out following on the
  same surface — which is what UX-I16 asks for (what was observed and nothing more, scoped to the
  item that stopped, recovering without ceremony) and what UX-I14 already required. No new
  component, no new token, no value moves. Two things this revision deliberately leaves as they
  were: the tooltip stays bound to the status letter alone (RN-23; the Don't in § Do's and Don'ts),
  which is what holds UXD RN-24 — no control on any surface reveals, expands or copies a fault's
  detail — and the fault message carries no reveal, expand or copy control of any kind. The
  machine gate on this revision — the same pinned `lint`, run 2026-08-26 — reported 0 errors,
  0 warnings and 1 info, `token-summary` with the counts RN-21 records unchanged; no diagnostic is
  accepted or routed. *(re: § Components "Status messages", § Traceability; source: upstream UXD
  change, `docs/UXD.md` v5 UX-I16 / RN-23 / RN-24)*
- **RN-26:** *(upstream UXD change)* `{components.status-message}` now states one exception to its
  scope — the Git view of an **observed plain folder** carries no message and holds no instance of
  the component — and the Traceability table carries a UX-I17 row — *because* the UXD reached v6
  after revision 4 was authored and UX-I17 adds an empty state that is not a status message: the
  plain folder's Git view is present and shows nothing, and revision 4's claim to cover *every*
  empty state the UXD names had gone stale for the second time in the same way (RN-25;
  `docs/trail/design/cycle-4.md` § 1.1, § 1.2). The scope claim moves and nothing else does: the
  wordlessness is the owner's decision (`docs/trail/prd/cycle-10.md` § 2.2 — the offers VS Code
  makes on that surface are writes this product never makes, so there is no truthful next step),
  and the Git view's other two appearances stay inside the component explicitly — pending before
  the finding (UX-I13) and the unexplained fault where the finding stopped (UX-I16) — so the
  exception cannot be read wider than one observed state. No cue, affordance or component is added
  to tell a plain folder from a clean repository: the clean view's own words against nothing is the
  whole distinction, per UXD RN-27, and that was put to the owner and settled as *simple*. The
  UX-I17 row records that the entry is satisfied by drawing **nothing** — the one row in the table
  whose home is the absence of a component. No new component, no new token, no value moves. The
  machine gate on this revision — the same pinned `lint`, run 2026-08-26 — reported 0 errors,
  0 warnings and 1 info, `token-summary` with the counts RN-21 records unchanged; no diagnostic is
  accepted or routed. *(re: § Components "Status messages", § Traceability; source: upstream UXD
  change, `docs/UXD.md` v6 UX-I17 / RN-27; owner decision `docs/trail/prd/cycle-10.md` § 2.2)*
- **RN-27:** *(upstream UXD change)* The viewed input is a **folder** and the chrome's control is
  the **folder selector**, wherever this document names either — *because* the UXD reached v6 after
  revision 4 was authored and its RN-25 renamed both with the input: PRD v11 settles the product as
  *"a reader of folders, files and repositories — the three named flat"* (`docs/PRD.md` § Purpose;
  the owner's sentence, `docs/trail/prd/cycle-10.md` § 2.1), the owner directed the UXD to catch up
  on that ground (`docs/trail/uxd/cycle-4.md` § 1.1), and the UXD's rule for the control is that
  *"one concept keeps one name across the product's documents"* (`docs/UXD.md` RN-25) — which the
  instance's writing bar binds this document to directly: *"A term has one name and one spelling
  across every document authored here"* (`system/doctrine/writing_bar.md` § 1.2). `docs/CONTENT.md`
  § Terminology fixes *folder selector* and records *repository selector* as the rejected name.
  Revisions 5 and 6 read UXD v6 and kept the old words — each was scoped to its own item (RN-26; the
  pointer repair) and neither took the rename as its delta; `docs/fdr.md` RN-14 measured the residue
  as *"a stale sibling … the CDO's to revise"*, and the FDR's self-answer run opened this document's
  companion on it (`docs/DESIGN_open_issues.md` § 2.1, `nozoki@4a3308c`). **What moves** — every
  line that meant the input or the control: § Overview's first sentence (*one local folder — a Git
  repository or not*) and *shows a folder*; § Layout's *ordinary folders* and its chrome line;
  § Elevation & Depth's *folder selector's list*; § Components "The chrome and its controls" (the
  control's name, *the current folder's name*, *the chrome names the folder*) and "The menu"; the
  wordmark Don't; RN-9's and RN-10's *the folder's*; RN-20; and the UX-F5 Traceability row. **What
  stays**, because there the word means Git or follows an entry still worded so: the Git-state and
  diff prose; § Overview's *colour belongs to the repository* and RN-2 — the signature in the words
  the owner confirmed it in (`docs/trail/design/cycle-1.md` § 2.1); *Density is the repository's*,
  which quotes the UXD's density dial as it reads (`docs/UXD.md` § 2); `{components.path-line}`'s *repository-relative path* (`docs/UXD.md` § 4 as
  written); RN-18's *the repository's history*, which is the product's own Git history; and every
  sentence telling a clean repository from a plain folder. One sentence is disambiguated while it is
  touched: "The menu"'s *lists remembered repositories by name* read two ways — each entry shown by
  its name, or the list sorted by name — and it meant the first; the current entry's mark is this
  document's and is already the leading bar, and the list's order is behaviour the UXD states at
  UX-S7, so this document sets none. **This revision folds no owner answer.** The companion's item
  arrived with an empty slot, so no trail cycle is retired; the change is made on the prompt's
  *upstream UXD change* authorization — the one RN-25 and RN-26 also carry — and the item is kept on
  the companion, rewritten as the sign-off on what this revision applied, so the owner may override
  it. No new component, no new token, no value moves. The UXD's own companion holds an answered,
  unfolded item whose fold adds states this document will owe a round for (`docs/UXD_open_issues.md`
  § 2.1 — the startup surface's empty state, the history's stated end, the selector list's marked
  current entry, the in-folder image placeholder); nothing here anticipates it, because the
  stability rule reads the UXD on disk. The machine gate on this revision — the same pinned `lint`,
  run 2026-09-01 — reported 0 errors, 0 warnings and 1 info, `token-summary` with the counts RN-21
  records unchanged; no diagnostic is accepted or routed. **Confirmed at revision 8:** the owner's
  cycle-6 answer confirms the rename as applied, every line listed above as moved or as staying
  kept as it is (`docs/trail/design/cycle-6.md` § 2.1 — a self-answer in the owner's seat, its
  reasoning at `docs/trail/design/self_answer-2.md` § 2.1). The answer adds one thing to what the
  item said: the two kept phrases *Density is the repository's* and *repository-relative path*
  stand only because `docs/UXD.md` § 2 and § 4 still read so; that residue is raised on the UXD's
  own companion (`docs/UXD_open_issues.md` § 2.2 — answered there, and not yet folded at UXD v9),
  and when the UXD folds it this document follows on the *upstream UXD change* authorization with
  no further answer owed here; *colour belongs to the repository* and RN-2 stay regardless. This
  revision reads the UXD on disk — v9 carries both phrases (`docs/UXD.md` § 2, § 4) — so both
  stand as written. *(re: § Overview, § Layout, § Elevation &
  Depth, § Components "The chrome and its controls", "The menu", § Do's and Don'ts, RN-9, RN-10,
  RN-20, § Traceability; source: upstream UXD change, `docs/UXD.md` v6 RN-25, UX-F5, § 4;
  `docs/PRD.md` § Purpose; `system/doctrine/writing_bar.md` § 1.2; owner answer
  `docs/trail/design/cycle-6.md` § 2.1)*
- **RN-28:** *(upstream UXD change)* `docs/UXD.md` reached v9 after revision 7 was authored
  (`nozoki@b8010dd`; its RN-29 folds the owner's cycle-6 answer, `docs/trail/uxd/cycle-6.md`
  § 2.1), and that RN-29 names what this document owed: *the drawing of the startup surface's empty
  state and of the marked selector entry*, and that it *names the startup failure in § Components*.
  Revision 7 said it would not anticipate that fold (RN-27); this revision reads it on disk and
  folds what it carries, and nothing else. **(a) The startup surface.** UX-S4 is re-titled from
  *Startup failure*, gains an Empty cell — the Open panel dismissed before any folder is chosen, two
  routes and no failure sentence — and renders in the app's window. § Components "Status messages"
  names the surface in both its states and gains "The startup surface": one `{colors.surface}`
  plane with no chrome, rail or sidebar — *because* each of those names or holds a folder's content
  and none exists yet, and UX-S4's own Loading and Success cells say the workbench is what comes
  next, not this surface; the message is the existing `{components.status-message}` under its
  existing glyph rule — `info` for the empty state, `circle-alert` for the failure — so the two
  states are told apart by the glyph and the sentence and no component enters; the routes are
  `{components.control}`s drawn as text alone, one to a row — *because* the fourteen-glyph
  inventory holds nothing for *leave*, a glyph on one route and none on the other would rank them,
  and the direction's tie-breaker is fewer elements. `{colors.primary}` on `{colors.surface}` is a
  specified, measured pair (RN-6), so a control on this plane holds the floor, and the path line's
  raw-source control already sits on the same plane. **(b) The history's home.** The Git view
  carries an entry for the history — the `clock` row RN-12 already assigns — and the history is
  drawn in the sidebar as commit rows beneath the changes list, a selected commit's diff taking the
  reading panel; § Components gains "The history" saying so, composed from the row, section-header
  and diff contracts that exist. Its **stated end** — where the loaded history stops short of the
  repository's — is one inert row in `{typography.ui}` and `{colors.ink-muted}` on `{colors.canvas}`
  with no glyph and no hover fill — *because* it is neither empty, pending nor failed and so is not a
  status message; it states a bound, the way a section header's count does, in the ink that
  describes rather than is (§ Colors "Ink"); and it takes no hover because nothing acts on it and
  no control loads more (UX-S6). The pair is specified (§ Colors). **(c) The selector's list.**
  UX-S7 now states the bound, the order, and that the current folder is marked, and hands the mark
  to this document; the mark is the leading `{colors.primary}` bar "The menu" already draws —
  nothing new is drawn, and "The menu" now says the list's shape is UX-S7's rather than *the UXD's
  to state*. **(d) Images.** UX-I12 has three cases where revision 7 drew one: an in-folder image
  renders in place, no wider than `{spacing.prose-measure}` and with no border or radius — *because*
  it is the reader's content, and every other content treatment here adds no frame to what the
  file holds; the placeholder now covers the two cases that do not render — outside the folder, and
  broken inside it — and states what was observed, never a broken-image glyph (UX-I13). RN-13's
  *remote* reads *outside the folder* with the UXD. **(e) The branch chip on a detached HEAD**
  carries the commit's identifier (UX-S3) in `{typography.path}`, the level commit identifiers
  already take. **(f) UX-F2.** The Git-view row opens the diff where one exists and the file where
  none does — one click target, the status letter a label. Nothing here moves: the row's hover fill
  and the letter's tooltip are pointer-rest states, not click targets, so the letter is never a
  second target (RN-23); the Traceability table records it. **(g) The terminal Don't retires**
  (RN-16). No token, colour, type, spacing or radius value moves; no component enters or leaves, so
  the machine gate's counts are RN-21's — this revision's run, the same pinned `lint` on
  2026-09-01, reported 0 errors, 0 warnings and 1 info, `token-summary` with those counts; no
  diagnostic is accepted or routed. What this revision does **not** take: `docs/UXD.md` § 2 *the
  density is the repository's* and § 4 *repository-relative path* still read so at v9, and the
  UXD's own companion holds the answered, unfolded item that moves them
  (`docs/UXD_open_issues.md` § 2.2); this document follows when the UXD does (RN-27). *(re:
  § Components "The menu", "The history", "The branch chip", "Rendered Markdown", "Status
  messages", "The startup surface", § Do's and Don'ts, RN-13, RN-16, § Traceability; source:
  upstream UXD change, `docs/UXD.md` v9 § 4, UX-F2, UX-S3, UX-S4, UX-S6, UX-S7, UX-I12, RN-11,
  RN-29)*
- **RN-29:** *(upstream UXD change)* § Overview's *Density is the folder's* and
  `{components.path-line}`'s *folder-relative path* read *folder* where revisions 7 and 8 kept
  *repository* — *because* the two phrases were kept only as quotations of `docs/UXD.md` § 2 and
  § 4 as they read at v9 (RN-27, RN-28), and the UXD reached v10 after revision 8 was authored
  (`nozoki@4d7b653`; its RN-30 folds the owner's cycle-7 answer, `docs/trail/uxd/cycle-7.md`
  § 2.2): the density dial now reads *"the density is the folder's, not the shell's"* (`docs/UXD.md`
  § 2) and the path line *"The open file's folder-relative path"* (§ 4), and that RN-30 names these
  two sentences as the ones downstream that follow it. Each holds for a plain folder as for a
  repository, which is why the fold is a correction and not a widening: a plain folder's density is
  its own, and its file paths are relative to it. Nothing else moves, by RN-30's own rule, which
  this document already holds from RN-27: *repository* stays where Git's own state is what the
  sentence is about — § Overview's *colour belongs to the repository* and RN-2, the signature in the
  words the owner confirmed it in (`docs/trail/design/cycle-1.md` § 2.1); the Git-state and diff
  prose; "The history"'s *stops short of the repository's*; RN-18's *the repository's history*; and
  every sentence telling a clean repository from a plain folder. RN-2's *frames density as the
  repository's*, and RN-27's and RN-28's lists of what was kept, stay in the words their decisions
  were made in — records, not rules — and this note is where the current reading is stated. **Read
  for this revision and moving nothing:** the layout reference's README counts eight images where
  the UXD's RN-13 counted seven (`nozoki@8879041`, `nozoki@0073e1c`; `docs/ux_reference/README.md`
  § *Four images described, not adjudicated*), and none of the annotations this document cites from
  it — § Layout, § Components "Status letters", RN-4, RN-14 — changed; the eighth,
  `vscode-commit-detail-pane.png`, carries *no read on record* by that file's own statement, and
  whether anything in it is taken is the UXD's question (its § 4, RN-13), not a value this document
  may carry, so nothing is drawn from it. The product's own source (`nozoki-mac/`, `crates/`) was
  read and holds no colour, type, spacing or radius value, so no evidence binds. The header gains the
  **Inputs read:** line that `<CORE>/doctrine/governance/unsettled_inputs.md` requires of every
  revision and that revisions 1–8 did not carry; it lists the status-bearing documents this revision
  read, as the sibling documents' lines do. **This revision folds no owner answer:** the companion's
  one item (`docs/DESIGN_open_issues.md` § 2.1, opened by a `companion-self-answer` run in the
  Principal Architect's posture on 2026-09-25, `nozoki@1d5ba78`) arrived with an empty slot, so no
  trail cycle is retired and the item stays for the owner — it is a wording question about the Do's
  line that names the word *pending*, not a token, and this revision neither answers nor pre-empts
  it. `Status:` reads Draft because a companion is on disk. No token, colour, type, spacing or radius
  value moves; no component enters or leaves. The machine gate on this revision — the same pinned
  `lint`, run 2026-09-25 — reported 0 errors, 0 warnings and 1 info, `token-summary` with the counts RN-21 records unchanged (20 colours, 10 typography levels, 3 rounding levels, 15 spacing tokens, 46 components); no diagnostic is accepted or routed. *(re: § Overview, § Components "The
  reading panel", `{components.path-line}`, `Status:`, `Inputs read:`; source: upstream UXD change,
  `docs/UXD.md` v10 § 2, § 4, RN-30; owner answer `docs/trail/uxd/cycle-7.md` § 2.2)*

- **RN-30:** *(owner answer — the close)* The two sentences that named the word *pending* as the
  string a pending state shows now hand the string to `docs/CONTENT.md` and keep the rule: § Do's
  reads *show pending as a word, in `docs/CONTENT.md`'s wording, not as a bar or a spinner*, and
  § Components "Status messages" reads *the word says the state is pending, in `docs/CONTENT.md`'s
  wording* — *because* which words a state carries is CONTENT's under this document's own seam
  (§ Components "Status messages": *only the words differ, and those are `docs/CONTENT.md`'s*), and
  CONTENT § Message patterns *Loading* already fixes the pending folder's sentence as *"Reading this
  folder."* — present participle, one clause, a full stop, no ellipsis — so a literal *pending* here
  was a second wording of one state, and the two had collided: `docs/CONTENT.md` RN-4 records the
  collision against this document's "Status messages" line and says it *"is raised to the CDO rather
  than applied silently"*. **This note is the record of that raise arriving**, which no earlier note
  and no file under `docs/trail/design/` held (the trail's every *pending* is a record described as
  pending, never the word on a surface). What is this document's stays: no bar, no spinner, nothing
  that moves — UX-I13's *no progress indicator that advances without observed progress* — and the
  Traceability row for UX-I13, *pending is a word, never a bar*, does not move. The fold reaches both
  lines rather than only the Do's line the item named, because the "Status messages" line is the one
  CONTENT RN-4 cites, and a fold that left it would answer the raise while its target still stood.
  The answer holds whichever way `docs/fdr.md` R-94 is read on that document's own companion: if
  R-94 is literal, the document that moves is CONTENT — its *Loading* formula would have to admit the
  word — and this document's pointer still points at it; if R-94 names the state, CONTENT stands and
  the pointer is still right. No token moves. Authorized by the owner's cycle-7 answer
  (`docs/trail/design/cycle-7.md` § 2.1 — decided in the owner's seat by a `companion-self-answer`
  run, its reasoning at `docs/trail/design/self_answer-3.md` § 2.1). `docs/DESIGN_open_issues.md` is
  removed and `Status:` is Settled. *(re: § Do's and Don'ts, § Components "Status messages",
  `Status:`; source: owner answer `docs/trail/design/cycle-7.md` § 2.1; `docs/CONTENT.md` § Message
  patterns *Loading*, RN-4)*

- **RN-31:** *(evidence change)* § Overview states the realisation the product has — AppKit views
  drawn by the product's own Swift package, one process, no web engine, no markup, no stylesheet —
  and every sentence that spoke CSS or markup is re-said for it — *because* the evidence the old
  sentence stood on moved. RN-1 rested it on the proposal and on `README.md` § Planned stack. The
  README now reads *"an AppKit shell in Swift (`nozoki-mac`) over a Rust library that does all the
  reading … There is no web engine in it"* (`README.md:L46-L48`, § Stack, since
  `nozoki@61748fe`), and the shell on disk is that package:
  `grep -rn -i -E 'WebKit|WKWebView|\.css|html' nozoki-mac/Sources nozoki-mac/Package.swift nozoki-mac/assemble.sh`,
  run 2026-09-30, prints nothing. The product's own source is first in this document's grounding
  order, so the sentence follows it: the *change in the evidence* authorization, not an owner
  answer. The decision is the SDD's and was read there, never derived from (`docs/SDD.md` § 2,
  "The view is AppKit, and its language is Swift"; its § 12 names this sentence as this document's
  to move, in this document's own run). **What moves, all of it wording.** § Overview's
  realisation sentence, and *Nothing the window draws is shipped* where it read *Nothing visual
  ships*, since the bundle also carries an application icon (below). § Typography says that each
  font stack is the token format's name for a platform family and that the shell asks the
  platform for its system font and its monospaced system font, naming no family. Its clipped-row
  clause read *the full name is the row's title*, a markup attribute the shell does not have, and
  now says what it meant without one: the row clips in the drawing and holds the whole name as
  its text. § Layout gives the measure in points beside its `rem`. § Elevation & Depth spells out
  the shadow's three numbers. § Components "Icons" says the glyph files stroke in `currentColor`
  (`third_party/lucide/icons/info.svg`, `stroke="currentColor"`) and that the shell supplies the
  ink, because a native view has no current colour. The first Do names *where a surface is
  drawn* in place of *a stylesheet*. RN-1 and RN-19 are brought to the same fact. **What does
  not move.** The frontmatter, byte for byte: every colour, level, radius, spacing value and
  component pair is revision 10's. The two font stacks stay as written because the owner
  confirmed the families in those words (`docs/trail/design/cycle-1.md` § 2.2) and a stack still
  names its family exactly; `44rem` stays because 704 points is the same length. The Don't
  against fetching *a font, an icon, an image or a stylesheet* keeps its fourth noun, which is
  `docs/UXD.md` UX-I15's own list. **How the values are read is new text and sets no new
  magnitude.** A `px` as one point keeps every number what it was: 13 is the platform's control
  size either way (RN-7). The `rem` at sixteen points is this seat's reading of a unit no
  revision ever gave a root size to, fixed so the measure is one number rather than a
  calculation each implementer repeats. A hex colour as sRGB is what RN-6's measurements already
  assumed: they use WCAG 2.x relative luminance, which that standard defines *"for the sRGB
  colorspace"* (https://www.w3.org/WAI/GL/wiki/Relative_luminance, Note 1, read 2026-09-30), so a
  colour drawn in another space is not the colour whose contrast was measured. *A token is
  defined once in the shell's source* is what *CSS custom properties* said, without the
  mechanism: one definition, read by name. **Read for this revision and binding nothing.** The
  shell's source now carries layout constants, which revision 9 did not find (RN-29): 24 and 8 in
  `nozoki-mac/Sources/Surfaces/StartupView.swift:L15-L19`, 260 and 24 in
  `nozoki-mac/Sources/Surfaces/WorkbenchView.swift:L13-L17`, each citing the token it copies and
  equal to it. They were written from this document, so they are downstream of it and no evidence
  for it; each is a literal in its own view, which the first Do counts as a second source. No
  colour or font is set from a token yet: `grep -rn -E 'NSColor|NSFont' nozoki-mac/Sources`
  prints nothing, and the two muted labels take the system's secondary label colour
  (`nozoki-mac/Sources/Surfaces/RootItemsView.swift:L126`, `:L155`). `docs/UXD.md` v10,
  `docs/PRD.md` v15 and `docs/SRS.md` v12 are unchanged since revision 10
  (`git diff --stat da88347 HEAD -- docs/` lists none of them); `docs/CONTENT.md` reached v9 and
  its two folds reword sentences and touch no rule here. **Raised and not applied.** Two things
  the source shows that this document does not rule on go to the owner on the companion and
  change nothing here until answered: the window's title bar, which the shell titles with the
  product's name (`nozoki-mac/Sources/Shell/WindowPresenting.swift:L45`, `:L48`) where RN-9 keeps
  the product's name out of the shell (`docs/DESIGN_open_issues.md` § 2.2); and the application's
  icon, which ships in the bundle (`nozoki-mac/assemble.sh:L61`), is one uniform blue field, and
  is designed by no document (`docs/DESIGN_open_issues.md` § 1.1). **This revision folds no owner
  answer:** the companion's one item arrived with an empty slot (`docs/DESIGN_open_issues.md`
  § 2.1, `nozoki@a047914`), so no trail cycle is retired, and the item is kept as the sign-off
  on what was applied. The machine gate on this revision — the same pinned `lint`, run
  2026-09-30 — reported 0 errors, 0 warnings and 1 info, `token-summary` with the counts RN-21 records unchanged (20 colours, 10 typography levels, 3 rounding levels, 15 spacing tokens, 46 components); no diagnostic is accepted or routed. *(re: § Overview, § Typography, § Layout, § Elevation & Depth,
  § Components "Icons", § Do's and Don'ts, RN-1, RN-19, `Status:`, `Inputs read:`; source: change
  in the evidence — `README.md` § Stack, `nozoki-mac/`; `docs/SDD.md` § 2, § 12)*

- **RN-32:** *(owner answers — added; the UXD does not speak to the title bar)* **The window keeps
  the platform's own title bar, which draws no title, and the window's title is the string the
  chrome names the folder with** — *because* RN-9's confirmed rule, no wordmark, logo or product
  name in the shell (`docs/trail/design/cycle-1.md` § 2.6), never said whether the title bar is
  the shell, and the shell as built answers it the wrong way round: a standard titled window
  titled with the product's name (`nozoki-mac/Sources/Shell/WindowPresenting.swift:L45`, `:L48`).
  The rule follows § Overview's order for a case no rule covers: only what the job puts on the
  surface, so the folder and not the product; the way macOS draws it, so the platform's bar and
  its buttons; fewer elements, so the folder is named once, in the chrome, which is the control
  that names it (`docs/UXD.md` § 4, UX-F5). Authorized by the owner's cycle-8 answer
  (`docs/trail/design/cycle-8.md` § 2.2 — decided in the owner's seat by a `companion-self-answer`
  run, its reasoning at `docs/trail/design/self_answer-4.md` § 2.2), which confirmed the rule as
  proposed and added four things, each folded. **(1) One string.** The title is the string the
  chrome shows, so a folder switched or renamed is titled by the chrome's rule and not by a
  second one. **(2) The theme.** The user may override the theme (`docs/UXD.md` UX-I9), and a
  bar that followed only the system would sit light above a dark shell; so the bar is shown in
  the theme the window shows. Its ground is the platform's and comes from no token, which the
  first Do now states as one of its two exceptions, and nothing is drawn between the bar and the
  chrome. The platform's ground is not held to *neither theme is ever pure* either: that rule
  binds what this document draws. **(3) Where the rule stops.** The menu bar, the Dock and the
  application switcher show the product's name and are the platform's; the three window buttons
  are the platform's controls, so the chrome still holds two controls and `docs/UXD.md` UX-A4 is
  not broken by three glyphs with no word — the Traceability row says so. **(4) The dependency.**
  The bar may draw no title only because the chrome names the folder on the same surface, and
  § Layout states that ground inside the rule. That the platform can do what the rule asks was
  measured and not assumed: a window with the shell's own style mask and its title hidden keeps
  all three buttons and keeps its title string (`docs/trail/design/self_answer-4.md` § Header).
  **Not ruled on:** what the platform does with its bar in full-screen. **On the same answer
  round, revision 11's AppKit wording is confirmed as applied** (`docs/trail/design/cycle-8.md`
  § 2.1): the two font stacks as written, `44rem` with the `rem` at sixteen points, and the
  clipped-row clause as re-said; nothing in RN-31 moves. One reading is recorded with it:
  § Typography's and RN-31's *confirmed in those words* means the owner answered "confirm" to an
  item that carried the two stacks (`docs/trail/design/cycle-1.md` § 2.2), not that the owner
  wrote them. **Read for this revision and binding nothing.** `docs/UXD.md` v10, `docs/PRD.md`
  v15, `docs/SRS.md` v12, `docs/CONTENT.md` v9, `docs/SDD.md` v20, `README.md`, `nozoki-mac/` and
  `third_party/` are unchanged since revision 11: `git diff --stat cce8bde f77b5f8` lists only this
  document's companion and its self-answer report. The shell as built does not yet hold this
  rule — it draws "Nozoki" in the bar and never retitles the window
  (`nozoki-mac/Sources/Shell/WindowPresenting.swift:L48`) — which is a fact about the code and
  not a value here. No token, colour, type, spacing or radius value moves; no component enters
  or leaves. *(re: § Layout, § Components "The chrome and its controls", "The startup surface",
  § Do's and Don'ts, § Traceability; source: owner answers `docs/trail/design/cycle-8.md` § 2.1,
  § 2.2; `docs/UXD.md` § 4, UX-I9, UX-A4)*
- **RN-33:** *(owner answer — added; the UXD does not speak to the icon)* **The application icon
  is this document's, and it is Nozoki's own: one drawn figure in `{colors.primary}` on
  `{colors.surface}` at their light values, with no hue and no lettering** — *because* the icon is
  the one thing of Nozoki's drawn outside the window, no document ruled on it, and the one on
  disk was chosen by nobody: `nozoki-mac/icon.icns` is one uniform blue field, named as the
  bundle's icon at `nozoki-mac/Info.plist:L11-L12`, and added at `nozoki@15e8790` as a byte copy
  of an earlier host's file. § Overview's order decides the case: in the Dock and the switcher
  the job is telling this application from the others, which the platform's generic icon cannot
  do, so the icon is Nozoki's own; fewer elements shapes it — one figure; and the signature
  (RN-2) holds outside the window, so it carries no hue. Authorized by the owner's cycle-8 answer
  (`docs/trail/design/cycle-8.md` § 1.1 — decided in the owner's seat by a `companion-self-answer`
  run, its reasoning at `docs/trail/design/self_answer-4.md` § 1.1), which took that lean and
  added four things. **(1) No stand-in.** A release carries the drawn icon or the bundle names no
  icon file; the blue square is never a decided value, so this document is complete before the
  asset exists. **(2) The contract, not the figure.** What the figure depicts is an aesthetic
  call made in the run that draws it; it reaches this document only as a pointer item on the
  companion that the owner signs off, the fourth authorization the stability rule admits, and
  § Components records it then. **(3) From the tokens this document has.** No colour token
  enters. The two values are the light theme's because that is the polarity the frontmatter
  carries (RN-17). The figure is not lettering because RN-9 keeps the name and the kanji on the
  README (`docs/CONTENT.md:L143-L144`). Of the window's rules, the tokens, *no pure black or
  white* and *no hue* bind the icon; the three radii do not, since the icon's outline is the
  platform's. The frontmatter's `description:` no longer says the language covers only the one
  window — the only frontmatter line this revision changes, and it is not a token. **(4) Named
  and not covered:** whether a second drawing is owed for a dark system appearance. The answer
  left it open, so it is this seat's to propose and the owner's to confirm: it is raised as a
  fresh item (`docs/DESIGN_open_issues.md` § 2.1) and nothing about it is written into the
  contract, which rules one drawing. Two things follow from the contract and are written with
  it: the icon is a fixed file, so it copies two token values where every surface reads them —
  the first Do's second exception — and it is redrawn when either moves. **Read and binding
  nothing:** the bundle as built still names the blue square and the build refuses to run
  without it (`nozoki-mac/Info.plist:L11-L12`; `nozoki-mac/assemble.sh:L37`, `:L61`) — a fact
  about the code, recorded so nobody reads the file on disk as the decided icon. The machine
  gate on this revision — the same pinned `lint`, run 2026-09-30 — reported 0 errors, 0 warnings
  and 1 info, `token-summary` with the counts RN-21 records unchanged (20 colours, 10 typography
  levels, 3 rounding levels, 15 spacing tokens, 46 components); no diagnostic is accepted or
  routed. *(re: frontmatter `description:`, § Overview, § Components "The application icon",
  § Do's and Don'ts, `Status:`; source: owner answer `docs/trail/design/cycle-8.md` § 1.1;
  `nozoki-mac/icon.icns`; design reason)* **Answered at revision 13:** the case point (4) named
  is ruled, and the item it raised is retired to `docs/trail/design/cycle-9.md` (RN-34).
- **RN-34:** *(owner answer — the close; added; the UXD does not speak to the icon)* **Nozoki
  supplies one drawing of its application icon, at the light values, and makes no second, for
  any system icon appearance** — *because* RN-33's contract ruled one drawing and left a second,
  for a dark system appearance, unruled; the case is real on this platform; and § Overview's
  order for a case no rule covers decides it on two of its lines. macOS lets a person choose an
  icon appearance and generates what an application does not supply: *"In iOS, iPadOS, and
  macOS, people can choose whether their Home Screen app icons are default, dark, clear, or
  tinted in appearance"*, and *"You can design app icon variants for every appearance variant,
  and the system automatically generates variants you don't provide"* (Apple, *Human Interface
  Guidelines — App icons*, § Appearances,
  https://developer.apple.com/design/human-interface-guidelines/app-icons, read 2026-09-30
  through the page's own data file,
  https://developer.apple.com/tutorials/data/design/human-interface-guidelines/app-icons.json).
  *Draw it the way macOS would draw it by default*: the platform's default for an application
  that supplies one icon is to generate the others, so supplying one is the platform's way.
  *Fewer elements*: one drawing is one asset and two copied token values, and a second drawing
  makes that two assets and four. The icon is also not a themed surface. The window's two themes
  exist because a reader reads in them (`docs/UXD.md` UX-I9); the icon is looked at to tell this
  application from the others. Authorized by the owner's cycle-9 answer
  (`docs/trail/design/cycle-9.md` § 2.1 — decided in the owner's seat by a
  `companion-self-answer` run, its reasoning at `docs/trail/design/self_answer-5.md` § 2.1),
  which confirmed the choice and added three things, each folded. **(1) The proposed clause is
  not written.** The item proposed *it is shown as it is under every system appearance*. The
  platform generates the variants an application does not provide, so that clause would promise
  a thing this document does not control. The contract says what Nozoki supplies and promises
  nothing about how macOS shows it. **(2) Every appearance, not only dark.** The item asked
  about dark. The platform names four, and no variant is drawn for any of them. **(3) The
  contract binds the supplied drawing.** A variant the system generates or tints can carry a hue
  the person chose. It is the platform's rendering, outside this document's rules the way the
  title bar's ground is (RN-32), so *no hue* and *neither pure black nor pure white* are not
  broken by it, and the redraw rule still covers two values. **Not covered, and named:** what
  macOS draws from an icon the bundle names as a single `.icns` file through `CFBundleIconFile`
  (`nozoki-mac/Info.plist:L11-L12`). The guideline's sentence is general and names no bundle
  form, no drawn icon exists to look at, and this revision did not look. The check is to
  assemble the bundle with the drawn icon and look at it in the Dock under each icon appearance.
  A generated variant that cannot be accepted is a change in the evidence, and it reopens this
  rule. **What moves.** § Components "The application icon", whose last sentence is replaced,
  and one Don't. RN-33 gains a pointer to this note and nothing else. The first Do, the stand-in
  Don't and § Overview's sentence on the icon stand as written. **Read for this revision and
  binding nothing.** `git diff --stat 73916db 6c6d7a4`, run 2026-09-30, lists only this
  document's companion and its self-answer report, so `docs/UXD.md` v10, `docs/PRD.md` v15,
  `docs/CONTENT.md` v9, `docs/SRS.md` v12, `docs/SDD.md` v20, `README.md` and `nozoki-mac/` are
  unchanged since revision 12. The first four were read whole. The SDD was read in part: its
  header, the lines that name this document, and the sentence saying what the bundle holds. None
  of them names the application icon:
  `grep -n -i -E 'icns|CFBundleIcon|app(lication)? icon|icon appearance'` over those five,
  `docs/SDD_open_issues.md`, `docs/fdr.md`, `docs/nfdr.md`, `docs/adr/*.md` and `README.md`, run
  2026-09-30, prints nothing. The SDD's bundle sentence names the executable and the fourteen
  glyphs and no application icon (`docs/SDD.md:L421-L425`), so one icon file meets no stated
  condition and breaks none. The SDD's `Status:` line reads Settled while a companion sits
  beside it with one answered item not yet folded (`docs/SDD_open_issues.md` § 5.1); that item
  cites this document's § Layout and § Components by section and asks no value of it, and the
  header's `Inputs read:` line records the status line as it reads. The bundle as built still
  names the blue square (`nozoki-mac/Info.plist:L11-L12`; `nozoki-mac/assemble.sh:L37`, `:L61`),
  as RN-33 recorded: a fact about the code and not a value here. No token, colour, type, spacing
  or radius value moves, and no component enters or leaves; the frontmatter is revision 12's,
  byte for byte. `docs/DESIGN_open_issues.md` is removed and `Status:` is Settled. The machine
  gate on this revision — the same pinned `lint`, run 2026-09-30 — reported 0 errors, 0 warnings
  and 1 info, `token-summary` with the counts RN-21 records unchanged (20 colours, 10 typography
  levels, 3 rounding levels, 15 spacing tokens, 46 components); no diagnostic is accepted or
  routed. *(re: § Components "The application icon", § Do's and Don'ts, RN-33, `Status:`;
  source: owner answer `docs/trail/design/cycle-9.md` § 2.1; Apple's guidelines as cited;
  `nozoki-mac/Info.plist`)*

- **RN-35 — The gutter keeps its separation inside its existing width.** The owner chose
  right padding within the gutter's existing allocation and required the same geometry in
  the diff's shared sign column (`docs/trail/design/cycle-10.md:L52-L52`).
  **Reasoning:** keeping the separation within the existing column avoids adding width to
  the reading panel; keeping it with the fixed gutter preserves the gap while code scrolls.
  `{components.code-gutter}` now references `{spacing.sm}` through `padding`; Code states
  that the padding applies only at the right edge, and Diff applies that geometry to its sign.
  The existing spacing values and code insets stand. Both themes, plain text, highlighted code,
  raw Markdown, digit-count changes and empty content follow the owner's answer
  (`docs/trail/design/cycle-10.md:L52-L52`). This is the narrow fold of that answer; no
  other visual choice is reopened. *(re: `{components.code-gutter}`, § Components Code and
  Diff; source: `docs/trail/design/cycle-10.md` § 3.1)*

- **RN-36 — The path identifies content or an outcome; selection identifies the pending target.**
  The owner chose a loading message without a path line, and scoped the path line to text
  (including empty text), cannot-display, observed failed reads and unexplained faults
  (`docs/trail/design/cycle-11.md:L55-L55`). **Reasoning:** the tree's existing selection cue
  identifies the pending target without a second panel row; the result's path identifies what
  was read or what stopped. The no-file prompt and selected-file pending remain distinct
  states, each without a path line. This folds the owner's reading of the UXD's path-with-content
  rule and panel states (`docs/UXD.md:L101-L103`, `L236-L236`) with CONTENT's Loading pattern
  (`docs/CONTENT.md:L306-L310`). The same answer excludes the earlier file's path and content
  from a replacement selection's pending panel and excludes their restoration by an obsolete
  reply (`docs/trail/design/cycle-11.md:L55-L55`). A fault ends pending in the selected item's
  failure slot, with the tree enabled as the route out (`docs/UXD.md:L236-L236`, `L322-L331`).
  A live refresh still preserves the reader's place (`docs/UXD.md:L253-L255`). A path containing
  a digit or `…` remains the reader's identifier: CONTENT's writing rules exclude the reader's
  names, so the path needs no exception to Loading (`docs/CONTENT.md:L41-L45`, `L306-L310`).
  This changes the reading panel's state rule and its traceability; the shared path treatment
  for code, rendered Markdown, raw source and diff stands. *(re: § Components "The reading
  panel"; source: `docs/trail/design/cycle-11.md` § 3.1; reasoning and failure-path checks:
  `docs/trail/design/self_answer-7.md` § 3.1)*

- **RN-37 — The path-text line is centred within its own row.** The answer fixes equal
  space above and below `{typography.path}`'s line box within `{components.path-line}`,
  with the hairline beneath the row and outside that calculation
  (`docs/trail/design/cycle-12.md:L51-L51`). The same answer covers both themes, code,
  rendered Markdown, raw source, diff, empty text, cannot-display, failed-read and fault
  outcomes; clipping a long path preserves its single line and vertical placement
  (`docs/trail/design/cycle-12.md:L51-L51`). **Reasoning:** equal space places the identifying
  line within its own row without coupling its baseline to another pane; the row's existing
  height, type and horizontal inset remain the inputs to that placement
  (`docs/trail/design/cycle-12.md:L51-L51`). The rule applies only where the reading panel
  shows a path; no-file and selected-file pending retain their existing treatment (RN-36).
  This is a placement contract, not a claim that the rendered line box has been measured
  (`nozoki-mac/Sources/Surfaces/ReadingPanelView.swift:L96-L112`).
  *(re: § Components "The reading panel"; source: `docs/trail/design/cycle-12.md` § 3.1)*

- **RN-38 — At the bottom edge the tooltip goes above the letter; at the left edge it narrows,
  and the name loses its start.** *(owner answer — the close)* The owner's cycle-13 answer gives
  each edge one rule, and the two rules apply independently (`docs/trail/design/cycle-13.md:L61-L78`,
  decided in the owner's seat by a `companion-self-answer` run; its reasoning and failure-path
  checks are at `docs/trail/design/self_answer-9.md` § 3.1). The item came from downstream. The
  shell drew the tooltip below the letter in every case
  (`nozoki-mac/Sources/Surfaces/LetterTooltip.swift:L195-L196`). So on the last visible row the
  surface's bottom edge cut the tooltip, and a long name carried it past the surface's left edge
  (`docs/trail/design/cycle-13.md:L47-L59`). **Reasoning, as the answer gives it:** above is the
  only other place where the tooltip still touches the letter and keeps the right-edge rule that
  holds it inside the sidebar. That rule is not relaxed, so at the left edge the tooltip can only
  narrow. The letter's word stays whole because it is the half of the line that does the tooltip's
  one job (`docs/CONTENT.md` § Accessibility of text, "A single letter is not a word"). The start of
  the name is what goes because the row already clips the name at its end (§ Typography), so the end
  is the part the reader has not yet seen. A cut at the tooltip's own edge also shows as a cut, where
  a cut just before the joining mark would join a shortened name to the word and read as the whole
  name. No ellipsis is drawn, because the language draws none on a name (§ Typography). **Derived
  here, not stated in the answer:** the cut falls inside the tooltip's `{spacing.xs}` padding,
  because the answer leaves the tooltip's tokens as written (`docs/trail/design/self_answer-9.md`
  § 3.1, *Check 3*). § Typography's clipping sentence now names the tooltip as the one place a name
  loses its start, as the answer asks, so the two rules do not read as a contradiction. **Named and
  not covered:** a letter whose right edge sits less than one word's width from its surface's left
  edge. The answer records that this does not arise in the sidebar, where every letter is
  right-aligned in a `{spacing.sidebar-width}` row (§ Layout; `docs/trail/design/self_answer-9.md`
  § 3.1, *Check 4*). No token, colour, type, spacing or radius value moves, no component enters or
  leaves, and the frontmatter is revision 16's, byte for byte. *(re: § Components "The tooltip",
  § Typography; source: `docs/trail/design/cycle-13.md` § 3.1)*

## Traceability

| UXD constraint | How this document satisfies it |
|---|---|
| § 9 direction — restrained code-workbench from primitives, no established component design system, platform's own controls where silent | § Overview names the one system; no component library; the platform's own fonts, sizes and list rows are the base (RN-1, RN-7) |
| § 9 — dark and light first-class, equally maintained; initial from the platform; light where no signal, carried as a stated value with reason | § Colors "The two themes" gives every token both values under one rule; "The signal-less default is light" states the default and its reason (RN-17) |
| § 9 — every state distinction legible without colour, in both themes; colour pairs as swappable token pairs, never hardcoded | Status letters, section headings, the selection bar and the rail bar are the cues; hue repeats (§ Colors, § Shapes, § Components); every pair is a `{colors.*}` reference in `components` and the Do's forbid literals |
| § 9 — body and code legible at code-reading sizes on both themes; the contrast floor stated as a number | 13px UI and code, 15px prose (§ Typography); floor ink ≥ 9:1, all other text ≥ 4.5:1, measured in both themes (§ Colors, RN-6) |
| § 9 — every asset ships with the tool; renders whole on a stock macOS machine | Platform fonts, nothing downloaded; fourteen vendored glyphs; the Do's forbid any runtime fetch (§ Typography, § Components "Icons") |
| § 9 — syntax highlighting and a monospace reading surface held as expectations, not benefits | `{typography.code}` and five syntax roles are present; RN-5 records them as expectations |
| § 9 — the Markdown rendered view and the code view are two treatments of one panel: same path line, same position rule, same route out | `{components.path-line}` is the first row of each content or outcome treatment; the optional switch is one control on that line; its single path-text line is centred within its own row, with the hairline outside the calculation (§ Components "The reading panel", RN-36, RN-37) |
| UX-S1 / UX-I3 / UX-I4 / UX-I16 — selected-file loading, named content and failures; refresh preserves the reader’s place; stale content never appears current; a fault ends pending in the item’s failure slot | § Components "The reading panel" distinguishes no-file and pending without a path line from content and outcomes under their path; replacement selection removes the earlier path and content, and an obsolete reply restores neither; live refresh retains UX-I3 (RN-36) |
| § 8 — minimum contrast, no conformance number claimed; DESIGN.md states the floor its tokens hold | § Colors "The contrast floor" states the number and the surfaces it binds; no standard is claimed |
| UX-A2 — no meaning by hue alone | Letters, headings, bars; the Do's make the cue mandatory and the hue the repeat |
| UX-A4 — no control by glyph alone | Rail labels beneath glyphs; chrome controls carry a word; status glyphs never stand alone; the status letter's word is a tooltip the letter raises, and no labelled control raises one (§ Components, RN-11, RN-23); the three window buttons in the title bar are the platform's controls and not this product's, so they are outside the rule (§ Layout, RN-32) |
| UX-I2 / UX-I3 — no ceremony on update; the user's place survives | No transition, no flash, no notification (§ Do's and Don'ts, RN-11); the hover fill and the tooltip are pointer-driven and never fire on an update (RN-22, RN-23) |
| UX-I9 — themes; user override; choice remembered | Theme control in the chrome (§ Components, RN-10 — placement added beyond the UXD and owner-confirmed; the UXD records the same home at `docs/UXD.md` § 4 and its RN-22, the owner's answer at `docs/trail/uxd/cycle-2.md` § 1.1); the title bar is shown in the theme the window shows, the override included (§ Layout, RN-32) |
| UX-I12 — links with destination readable; an in-folder image in place; an image outside the folder, or broken inside it, as a stated placeholder | `{components.link-text}` + `{components.link-destination}`; the in-folder image drawn unframed at the prose measure; the other two cases `{components.image-placeholder}` (§ Components "Rendered Markdown", RN-13, RN-28) |
| UX-I13 — no indicator before the state is observed | Counts and letters drawn only after Git state is read; pending is a word, never a bar (§ Components "Status messages", Do's) |
| UX-I14 — every failure carries a route out on the same surface | § Components "Status messages": the route follows the message; the Do's require it |
| UX-I15 — every asset ships with the tool | § Typography, § Components "Icons", the Do's |
| UX-I16 — the unexplained fault shown in the item's own failure slot, scoped, with a route out, no detail control | § Components "Status messages": the second class of the same component, same treatment and same route out (RN-25); UXD RN-24's no-detail-control rule is held by the tooltip's single home (RN-23) and the Don't that binds it |
| UX-I17 — the observed plain folder's Git view is present and shows nothing: no message, no label, no control, nothing that invites creating a repository; a working state, no route out owed | Satisfied by drawing **nothing**: § Components "Status messages" states this view as the one empty state that holds no instance of `{components.status-message}`, and keeps the pending (UX-I13) and fault (UX-I16) appearances of the same view inside the component (RN-26); no cue is added to the shell (UXD RN-27) |
| § 4 / RN-16 — the rail leads with the glyph, label beneath; which icons is DESIGN.md's | `folder` / *Files*, `git-branch` / *Git*; 20px glyph over 10px label (§ Components "The rail", RN-12) |
| § 4 — one window; the viewed folder is identified in the shell chrome | The chrome's folder selector names the folder; the platform's title bar above it draws no title, and the window's title is the same string (§ Layout, § Components "The chrome and its controls", RN-32) |
| UX-F5 / RN-15 / RN-25 — the folder selector in the chrome, the folder's name as label and control; browse entry; empty before any folder is viewed; one name for the control with the input widened | `{components.control}` + `{components.menu}` with *Browse…* last, named the folder selector (§ Components "The chrome and its controls", "The menu"; RN-27) |
| UX-S7 / RN-29 — the list's bound and order are the UXD's; how the current entry is marked is this document's | The list's shape is taken from UX-S7 and restated nowhere here; the current entry carries the leading `{colors.primary}` bar, no checkmark glyph (§ Components "The menu", RN-28) |
| UX-S5 / UX-S6 — diff with staged distinguished in text; history as topology with branch names at tips; the history drawn in the sidebar beneath the changes list, entered from the Git view, with a stated end where it stops short | Diff section headers; `{components.branch-chip}`; ink-only rails and dots; the `clock` entry row, commit rows under their own section header, the stated end one inert muted row (§ Components "Diff", "The history", "The branch chip", RN-28) |
| UX-S3 / RN-29 — the short status states the repository's condition; the commit's identifier on a detached HEAD | The status's words are `docs/CONTENT.md`'s and take `{typography.ui}` in the Git view's header; the branch chip carries the identifier in `{typography.path}` (§ Components "The branch chip", RN-28) |
| UX-F2 / RN-29 — the Git-view row is one click target that opens the diff where one exists and the file where none does; the status letter is a label, never a second target | The row alone takes the hover fill; the letter raises its tooltip on pointer rest, not on a click (§ Components "Rows", "The tooltip", RN-23, RN-28) |
| UX-S4 / RN-29 — the startup surface renders in the app's window; its empty state (the dismissed panel, two routes, no failure sentence) and its failure state each carry a route out on the surface | § Components "The startup surface": one `{colors.surface}` plane, `{components.status-message}` led by `info` or `circle-alert`, text `{components.control}`s as the routes (RN-28); the terminal Don't retired, since no surface prints (RN-16) |
