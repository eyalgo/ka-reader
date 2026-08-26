---
version: alpha
name: Nozoki
description: The visual language of Nozoki's one window — the shell, the sidebar, the reading panel, and every state they show — in both themes
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
**Version:** 3 — the owner's cycle-2 answers folded (`docs/design_trail/cycle-2.md`): the no-tooltip Don't is lifted on the owner's v1 decision and a tooltip contract enters — one surface, the status letter, as `{components.tooltip}` drawn from existing tokens (RN-11, RN-23); the status letters' VS Code vocabulary is stated rather than left implicit, with the porcelain collision recorded (RN-24); and the UX-I9 traceability row and RN-10 are repointed at the settled UXD record. No colour, type, spacing or radius value moves; the companion is gone again. (v2: the owner's cycle-1 answers folded — `docs/design_trail/cycle-1.md`.)

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

Nozoki is a read-only viewer for one local Git repository, for a developer who must not disturb
the tree they are looking at — above all a tree that a coding agent is changing while they watch
(`docs/PRD.md` § Purpose, § Target Users). Its character is set upstream and this document only
dresses it: **calm, truthful, still** (`docs/PRD.md` § UX Notes "The character"; `docs/UXD.md`
§ 2 — variance 2, motion 2, density 6, typography 2).

**The one system is a restrained code-workbench built from primitives** — no established
component design system, no component library, no imported aesthetic (`docs/UXD.md` § 9,
owner-confirmed at `docs/uxd_trail/cycle-1.md` § 2.1). It is realised in plain CSS custom
properties over the product's own markup on a macOS window (`docs/SRS.md` C-11; `README.md`
§ Planned stack), and it starts from what a stock Mac already draws: the platform's own fonts, its
own text sizes, its own flat list rows. Nothing visual ships that the machine does not already
have, except fourteen vendored line icons (§ Components).

**What it should feel like.** A quiet instrument that shows a repository and adds nothing of its
own. The shell is achromatic — grey on grey, in either theme — and **colour belongs to the
repository, not to the tool**: the only hues on screen are the ones that report Git state and
syntax. When the tree is clean and no file is open, the window has no colour in it at all, and
that stillness is the design. Density is the repository's: rows are tight and code sits at
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
owner-confirmed at `docs/uxd_trail/cycle-1.md` § 2.5). This document carries that default as the
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
Menlo`). Nothing is downloaded and nothing is bundled, so every surface renders whole on a stock
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
with an ellipsis in the middle — the row clips at its end and the full name is the row's title;
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
  ordinary repositories.
- **The reading panel** takes every remaining pixel. It is the dominant surface at any window
  size the product allows; the window's minimum width is 720px (48 + 260 + 412 of code), below
  which the panel stops being dominant and the product stops being what the PRD says it is.
- **The chrome** is one strip across the top, `{spacing.chrome-height}` (36px), on
  `{colors.canvas}`, carrying the repository selector on the left and the theme control on the
  right, and nothing between them.

**Spacing rhythm is a 4px base**: `{spacing.xs}` 4, `{spacing.sm}` 8, `{spacing.md}` 12,
`{spacing.lg}` 16, `{spacing.xl}` 24. Rows are `{spacing.row}` (24px) tall — every row in the
product: tree rows, Git rows, menu items, section headers, commit rows, the path line. Tree
depth indents by `{spacing.indent}` (12px) per level. Code and the path line are inset
`{spacing.lg}` from the panel's left edge; rendered Markdown is inset `{spacing.xl}` and measured
at `{spacing.prose-measure}` (44rem) so a README does not run to the width of a wide window.

**Responsive commitments:** none beyond the minimum width. The product runs in one window on
one platform; it has no breakpoints and no mobile layout, and does not adapt its structure to
window size.

## Elevation & Depth

**Nothing in the shell casts a shadow.** Hierarchy is carried by three stepped surface tones —
`{colors.surface}` for content, `{colors.canvas}` one step back, `{colors.rail}` one step
further — and by `{colors.line}` hairlines (`{spacing.hairline}`, 1px) between the chrome and
the shell, the rail and the sidebar, the sidebar and the reading panel, and the path line and
the content beneath it. A surface is never elevated; it is set back or brought forward by tone.

One exception, and it is the only shadow in the product: a **floating menu** (the repository
selector's list, the history view's branch-set control) sits on `{colors.surface}` with a
`{colors.line}` hairline border and one shadow — `0 4px 12px` at 16% black in light, 48% black
in dark — because a menu that opens over content must read as *over*, and tone alone cannot
say that when the menu and the reading panel share a surface. Nothing else may use it.

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
`{components.control}`s: the **repository selector** on the left — the current repository's
name as both label and control (`docs/UXD.md` UX-F5, RN-15), a `chevron-down` glyph after the
name — and the **theme control** on the right — a `sun` or `moon` glyph (the one that names the
theme the user would switch *to*) with the word *Light* or *Dark* beside it. A control is text
with a glyph on `{colors.canvas}`; it has no border and no fill until it is open, when it takes
`{components.control-open}`. Both controls are the whole set: nothing else is ever placed in
the chrome. The chrome names the repository, not the product — there is no wordmark, no logo,
and no product name in the shell (RN-9).

**The menu.** `{components.menu}` is the floating list under an open control, on
`{colors.surface}` with the one shadow (§ Elevation & Depth). `{components.menu-item}` rows
are `{spacing.row}` tall; the current item carries a leading `{colors.primary}` bar like a
selected tree row, never a checkmark glyph; the item under the pointer is
`{components.menu-item-hover}`, since every menu item is clickable. The selector's menu lists remembered repositories
by name, and its last item is *Browse…*; on first run it holds only *Browse…*.

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
`{colors.line}` hairline and no shadow (§ Elevation & Depth); one line, never wrapped. It appears
after the pointer has rested on the letter for 500ms, and leaves the moment the pointer leaves the
letter or a refresh changes the row's state — appearing and leaving in place, with no transition.
It stacks with the row's hover fill, which is the row's and not the letter's: the row shows
`{colors.hover}` and the tooltip sits over it. No other surface raises a tooltip: the rail
entries, the chrome controls and every status glyph already carry their word beside them, and a
tooltip there would be a second surface for words the label already carries (RN-11, RN-23).

**The reading panel.** `{components.reading-panel}` is the content surface. Its first row is
always `{components.path-line}`: the open file's repository-relative path in `{typography.path}`
and `{colors.ink-muted}`, a hairline beneath it. The path line is the same in the code view, the
rendered Markdown view, the raw view and a diff (`docs/UXD.md` § 9 last constraint); where a
release ships the raw-source switch, it is one `{components.control}` at the path line's right
end, labelled *Rendered* or *Source* for the state it would switch to.

**Code.** `{components.code-surface}` is the code view: `{typography.code}` on
`{colors.surface}`, inset `{spacing.lg}`, with `{components.code-gutter}` line numbers in
`{colors.gutter}` right-aligned in a column `{spacing.xl}` wide plus the digits the file needs.
Syntax roles are `{components.code-keyword}`, `{components.code-string}`,
`{components.code-number}`, `{components.code-comment}`, `{components.code-name}`; everything
else is `{colors.primary}`. No current-line highlight, no bracket colouring, no minimap, no
indent guides — each is an element the reading panel would carry that the file does not.

**Diff.** A diff reuses `{components.code-surface}` with two line variants:
`{components.diff-line-added}` on `{colors.diff-added}` and `{components.diff-line-removed}` on
`{colors.diff-removed}`, each led by `{components.diff-sign-added}` / `{components.diff-sign-removed}`
— a `+` or `−` in `{colors.ink-muted}` in the gutter column — so the sign carries the meaning and
the tint repeats it. Diff text is `{colors.primary}` throughout: no syntax colour in a diff.
Staged and unstaged hunks are separated by a `{components.section-header}` (*Staged*,
*Unstaged*), never by hue.

**Rendered Markdown.** `{components.prose}` at `{spacing.prose-measure}`, with
`{components.prose-h1}`–`{components.prose-h3}` and `{components.prose-code}` for inline and
fenced code. A link is `{components.link-text}` — the link's own text, underlined with a 1px
`{colors.ink-muted}` underline — followed by `{components.link-destination}`: its destination in
`{typography.path}` and `{colors.ink-muted}`, in parentheses, on the same line. The destination
is always shown; the text is a control only in a release that opens relative links, and then
only for a relative link (`docs/UXD.md` UX-I12) — and even then it is drawn no differently, since
it looks the way it looks because of what it is, not because of what it does. A remote image is
`{components.image-placeholder}`: a bordered box on `{colors.canvas}` where the image would be,
holding the image's alt text and, beneath it, its source in `{typography.path}`, and stating
that remote content is not loaded.

**Status messages.** `{components.status-message}` is every empty, pending, and failure state
the UXD names (`docs/UXD.md` § 6): the empty reading panel, the empty tree, the clean Git view,
a cannot-display placeholder, a vanished file, an unreadable entry, a startup failure. It is
`{typography.ui}` in `{colors.ink-muted}` on `{colors.surface}`, inset `{spacing.xl}`,
left-aligned at the top of its surface — never centred in the void, because a centred message
is a watermark and the product has none. It leads with `info` for an empty or pending state and
`circle-alert` for a failure, and the glyph never stands alone: the sentence beside it is the
state. A pending state carries no spinner and no bar; the word says pending, and nothing moves.
A failure message is followed on the same surface by its route out — the tree beside it, the
selector, or a way back — and where the failure is the startup failure, the message names what
to change and the surface carries the way to leave.

**The branch chip.** `{components.branch-chip}` names a branch at its tip commit in the history
view and in the Git view's header: `{typography.path}` on `{colors.canvas}`, hairline border,
`{rounded.sm}`, with `git-branch` leading. Graph rails and commit dots in the history view are
`{colors.ink-muted}` lines and `{colors.primary}` dots at `{spacing.icon}` — no per-branch
colour; the chips name the branches, and colour would be a code the reader has to learn.

**Icons.** `{components.icon}` is 16px, `{components.rail-icon}` 20px, both drawn from the
fourteen Lucide glyphs vendored at `third_party/lucide/icons/` (ISC, `third_party/lucide/LICENSE`):
`chevron-right`, `chevron-down`, `folder`, `folder-open`, `file`, `file-code`, `git-branch`,
`git-commit-horizontal`, `git-merge`, `clock`, `info`, `circle-alert`, `sun`, `moon`. Stroke
`currentColor` at the set's own 2px, so a glyph is always the colour of the text beside it.
This set is the whole inventory: a surface that needs a fifteenth glyph vendors it with the
notice, and never draws it from an icon font or a remote origin. `git-commit-horizontal` marks
a commit row, `git-merge` a merge commit, `clock` the history entry in the Git view.

## Do's and Don'ts

- Do read every colour and size from a token; a literal hex or pixel value in a stylesheet is a
  second source and a defect.
- Do give every state distinction a cue that is not a hue — a letter, a word, a bar, a heading —
  and treat the hue as the repeat.
- Do draw every text token only on the surfaces § Colors specifies it for; a pair outside that
  specification is a contrast defect even when it passes.
- Do draw an indicator — a status letter, a count, a "nothing changed", a pending word — only
  after Nozoki has read the state it stands for, and show pending as the word *pending*, not as a
  bar or a spinner.
- Do leave every failure surface with an enabled route out on that same surface: the tree, the
  selector, or a way back to the state before.
- Do keep every asset inside the installed product: the two families are the platform's, the
  fourteen glyphs are vendored, and a surface renders whole with the network unavailable.
- Do keep the chrome to two controls and the rail to two entries.
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
- Don't print a colour or a control sequence from any surface that prints to a terminal when
  `NO_COLOR` is set or when the output is not a terminal, and don't clear or overdraw a printed
  failure before handing control back.
- Don't put a wordmark, a logo, or the product's name in the shell; the chrome names the
  repository.
- Don't design a keyboard model, a search field, a resize handle, or a second platform's
  controls; each is outside the product's done.

---

## DESIGN Review Notes

- **RN-1:** The one system is a workbench from primitives in plain CSS custom properties on
  macOS, with the platform's own look as the starting point — *because* the UXD's direction
  names exactly that (`docs/UXD.md` § 9, owner-confirmed `docs/uxd_trail/cycle-1.md` § 2.1), the
  proposal names plain CSS / CSS variables and the README repeats it (`docs/proposal.md`
  § Styling, `README.md` § Planned stack), the product is macOS-only (`docs/SRS.md` C-11), and the
  instance's direction starts every product from its platform's defaults. The runtime — a
  browser tab or a native window — is the SDD's; every value here is a CSS value and holds in
  either. *(re: § Overview; source: UXD § 9, `docs/proposal.md`, `README.md`)*
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
  (`docs/design_trail/cycle-1.md` § 2.1). *(re: § Colors, `{colors.selection}`,
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
  would be a further one on top, not the diff's only colour (`docs/design_trail/cycle-1.md`
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
  owner** at the two drafted numbers (`docs/design_trail/cycle-1.md` § 2.7). Revision 2 adds
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
  shipped (`docs/design_trail/cycle-1.md` § 2.2). *(re: `{typography.*}`; source: UXD § 2, § 9;
  `docs/SRS.md` C-11; `scripts/design-check.mjs`; owner answer)*
- **RN-8:** Widths — rail 48, sidebar 260, chrome 36, minimum window 720, rows 24, indent 12 —
  *because* the proposal's 240–280 sidebar is input and 260 is the midpoint that holds a
  five-level path at 13px (`docs/proposal.md` § UI Shape, carried as visual design the PRD
  explicitly leaves downstream, `docs/PRD.md` § Out of Scope); a 48px rail is the smallest square
  that holds a 20px glyph over a 10px label with the row rhythm's 4px margins; 24px rows are the
  platform's list row height at 13px text; and 720 is the width below which the reading panel
  stops dominating. Pane resizing is outside done, so the sidebar width is a value, not a range.
  **Every measurement confirmed by the owner** as drafted (`docs/design_trail/cycle-1.md` § 2.3).
  *(re: `{spacing.*}`; source: design reason; `docs/proposal.md`; UXD § 10; owner answer)*
- **RN-9:** No wordmark, logo or product name in the shell — *because* the one job is what is on
  the surface and the chrome's element is the repository's identity (`docs/UXD.md` § 4, RN-2), the
  instance carries no shared mark, and a product name in the chrome would be the one thing on
  screen that is Nozoki's rather than the repository's. The product's name and its kanji live on
  the README, which is the CPO's. **Confirmed by the owner** (`docs/design_trail/cycle-1.md`
  § 2.6). *(re: § Components "The chrome"; source: UXD § 4; design reason; owner answer)*
- **RN-10:** The theme control is in the chrome, right end, glyph plus word — *because* the UXD
  requires that the user may override the theme (UX-I9) and that every preference is reversible
  by the control that set it (UX-I7), but places the control nowhere; the chrome is the one
  surface reachable in every mode, and the rail and sidebar are the repository's. This is a
  structural placement the UXD does not make, so it went to the owner, who **confirmed it**
  knowing the confirmation carried a UXD amendment with it (`docs/design_trail/cycle-1.md`
  § 2.5). The UXD half was not this document's to write: the owner re-opened the UXD's companion
  with that one already-answered item (`nozoki@ee8abcf`) and `product-uxd` folded it — `docs/UXD.md`
  § 4 now records the chrome as the control's home, its RN-22 carries the basis, and the owner's
  answer is readable at `docs/uxd_trail/cycle-2.md` § 1.1 (`nozoki@f4bc928`). The two documents
  state one placement between them; revision 3 updates this note's tense and the Traceability row
  on the owner's cycle-2 answer (`docs/design_trail/cycle-2.md` § 1.3). The glyph names the theme the control switches *to*, so the control reads as an action
  rather than a status. *(re: § Components "The chrome"; source: UXD UX-I9, UX-I7; design reason;
  owner answer; **changed** — placement added beyond the UXD, confirmed)*
- **RN-11:** No focus ring and no transition — *because* the motion dial is 2 with "only what
  actually changed changes" (`docs/UXD.md` § 2, UX-I2) and the product has no keyboard model to
  focus (UX-I8); each absence is a count of elements removed, which is the tie-breaker the
  instance's direction hands a design run. Revision 1 drafted two further absences, and the owner
  has since overridden both; this note records each. **Hover** — *"hovering is something that
  developers use"* (`docs/design_trail/cycle-1.md` § 2.3): a hover state enters, scoped as the
  owner stated it to rows that are actually clickable, never to an inert row where a fill would
  promise an action that is not there (§ Components "Rows", RN-22). **Tooltip** — *"i think that
  tooltips should be included in v1"*, given while settling the status letters and recorded as a
  v1 decision rather than a one-off exception (`docs/design_trail/cycle-2.md` § 1.1; the ruling's
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
  (`docs/design_trail/cycle-1.md` § 2.5). The set is treated as a fence: a fifteenth glyph is
  vendored, never fetched. *(re: § Components "Icons", "The rail"; source: `third_party/lucide/`,
  `docs/proposal.md`, UXD RN-16; owner answer)*
- **RN-13:** Links in rendered Markdown are text plus a readable destination, and a remote image
  is a bordered placeholder with alt text and source — *because* the UXD settles the behaviour
  (UX-I12, owner-confirmed `docs/uxd_trail/cycle-1.md` § 2.6) and this document only says what it
  looks like: a muted underline rather than a link colour, since the shell has no link colour and
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
- **RN-16:** The terminal rule in § Do's and Don'ts — *because* where the startup failure renders
  is open until the SDD fixes the start mechanism (`docs/UXD.md` § Open Questions), and if any
  surface prints to a terminal it must go plain under `NO_COLOR` and when not a TTY, and leave
  the failure in view when control returns. The rule is written in the product's terms so it
  holds for whichever answer the SDD gives; if no surface ever prints, it binds nothing. *(re:
  § Do's and Don'ts; source: UXD § Open Questions)*
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
  information"* (`docs/design_trail/cycle-1.md` § 1.1). The earlier set is not folded, no
  pointer item is written for it, and the restore command `1d5c553` records is deliberately not
  used; its values stay history. *(re: whole document; source: `git log` of the product
  repository; owner answer)*
- **RN-19:** The SRS was read as a sibling and no collision was found: FR-20 (two themes), FR-21
  (own state outside the repository), FR-24 (no editing affordance), FR-29–FR-32 (plain text
  outside the floor, Markdown rendered, the optional switch, nothing fetched) and NFR-8 are each
  satisfied by a rule above without a value derived from any of them. C-3 leaves the runtime to
  the SDD; RN-1 records that every value here is runtime-independent. *(re: whole document;
  source: `docs/SRS.md`)*
- **RN-20:** The Agari was walked: diffs, history and the repository selector are inside done and
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
  menu"; source: owner answer `docs/design_trail/cycle-1.md` § 2.3; computed on this run)*

- **RN-23:** The tooltip is one component with one home — the status letter — drawn as
  `{typography.ui}` in `{colors.primary}` on `{colors.surface}` with a `{colors.line}` hairline,
  `{rounded.sm}`, `{spacing.xs}` padding and no shadow; raised by the letter after a 500ms rest,
  dismissed when the pointer leaves it, stacked over the row's hover fill, and raised by no other
  surface — *because* the owner put a tooltip in v1 for the letter's sake and described the
  behaviour they meant: *"in VS code, when you hover over an `M` for example, there's a short-time
  'file and + Modified'"* (`docs/design_trail/cycle-2.md` § 1.1). Every value under that is this
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
  ruling: *"No change to `DESIGN.md`. Its mapping is correct"* (`docs/design_trail/cycle-2.md`
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

## Traceability

| UXD constraint | How this document satisfies it |
|---|---|
| § 9 direction — restrained code-workbench from primitives, no established component design system, platform's own controls where silent | § Overview names the one system; no component library; the platform's own fonts, sizes and list rows are the base (RN-1, RN-7) |
| § 9 — dark and light first-class, equally maintained; initial from the platform; light where no signal, carried as a stated value with reason | § Colors "The two themes" gives every token both values under one rule; "The signal-less default is light" states the default and its reason (RN-17) |
| § 9 — every state distinction legible without colour, in both themes; colour pairs as swappable token pairs, never hardcoded | Status letters, section headings, the selection bar and the rail bar are the cues; hue repeats (§ Colors, § Shapes, § Components); every pair is a `{colors.*}` reference in `components` and the Do's forbid literals |
| § 9 — body and code legible at code-reading sizes on both themes; the contrast floor stated as a number | 13px UI and code, 15px prose (§ Typography); floor ink ≥ 9:1, all other text ≥ 4.5:1, measured in both themes (§ Colors, RN-6) |
| § 9 — every asset ships with the tool; renders whole on a stock macOS machine | Platform fonts, nothing downloaded; fourteen vendored glyphs; the Do's forbid any runtime fetch (§ Typography, § Components "Icons") |
| § 9 — syntax highlighting and a monospace reading surface held as expectations, not benefits | `{typography.code}` and five syntax roles are present; RN-5 records them as expectations |
| § 9 — the Markdown rendered view and the code view are two treatments of one panel: same path line, same position rule, same route out | `{components.path-line}` is the first row of every treatment; the optional switch is one control on that line (§ Components "The reading panel") |
| § 8 — minimum contrast, no conformance number claimed; DESIGN.md states the floor its tokens hold | § Colors "The contrast floor" states the number and the surfaces it binds; no standard is claimed |
| UX-A2 — no meaning by hue alone | Letters, headings, bars; the Do's make the cue mandatory and the hue the repeat |
| UX-A4 — no control by glyph alone | Rail labels beneath glyphs; chrome controls carry a word; status glyphs never stand alone; the status letter's word is a tooltip the letter raises, and no labelled control raises one (§ Components, RN-11, RN-23) |
| UX-I2 / UX-I3 — no ceremony on update; the user's place survives | No transition, no flash, no notification (§ Do's and Don'ts, RN-11); the hover fill and the tooltip are pointer-driven and never fire on an update (RN-22, RN-23) |
| UX-I9 — themes; user override; choice remembered | Theme control in the chrome (§ Components, RN-10 — placement added beyond the UXD and owner-confirmed; the UXD records the same home at `docs/UXD.md` § 4 and its RN-22, the owner's answer at `docs/uxd_trail/cycle-2.md` § 1.1) |
| UX-I12 — links with destination readable; remote images as stated placeholders | `{components.link-text}` + `{components.link-destination}`; `{components.image-placeholder}` (RN-13) |
| UX-I13 — no indicator before the state is observed | Counts and letters drawn only after Git state is read; pending is a word, never a bar (§ Components "Status messages", Do's) |
| UX-I14 — every failure carries a route out on the same surface | § Components "Status messages": the route follows the message; the Do's require it |
| UX-I15 — every asset ships with the tool | § Typography, § Components "Icons", the Do's |
| § 4 / RN-16 — the rail leads with the glyph, label beneath; which icons is DESIGN.md's | `folder` / *Files*, `git-branch` / *Git*; 20px glyph over 10px label (§ Components "The rail", RN-12) |
| UX-F5 / RN-15 — the selector in the chrome, the name as label and control; browse entry; empty on first run | `{components.control}` + `{components.menu}` with *Browse…* last (§ Components "The chrome", "The menu") |
| UX-S5 / UX-S6 — diff with staged distinguished in text; history as topology with branch names at tips | Diff section headers; `{components.branch-chip}`; ink-only rails and dots (§ Components "Diff", "The branch chip") |
| § Open Questions — a surface that may print to a terminal | The terminal Don't (RN-16) |
