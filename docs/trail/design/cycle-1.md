# DESIGN open issues — KA-Reader

> Companion to `DESIGN.md`. The CDO authored the design language non-interactively; this file
> holds the calls it made and wants your sign-off on — each with the reason behind it, and what
> moves underneath it if you override — plus the few things it genuinely could not settle, and,
> when a design run has produced output for this product, the pointer to it.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-design`. It folds your answers into `DESIGN.md` and drops the resolved
> items. When nothing is left open, `product-design` **deletes this file**: no file = the
> design language is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CDO folds them in, it first copies this
> file whole to `docs/design_trail/` — so what you decided, and why, stays readable and citable
> for good.

---

## 1. Open issues

### 1.1 An earlier token set for KA-Reader exists in this repository's history — is it to be folded, or is this draft the baseline?

- **Why it matters:** every value in `DESIGN.md` — the palette, the type, the widths — was derived
  fresh on this run (`DESIGN.md` RN-18). A design reference with nine token files, twenty specimens
  and a wordmark treatment was added at `c4fb333` and removed at `1d5c553` ("the design reference
  comes out of the repo for the instance-pointing experiment"). A design-run output enters this
  document only through a pointer item you write here (§ 2, the 2.n pointer shape), and no pointer
  exists — so this run did not read it, and the two sets almost certainly disagree. If you want
  its values honoured, this draft's palette and scale move to match whatever it carries; if not,
  this draft is the baseline and the history stays history.
- **What was searched:** the working tree (no `docs/design_reference/`, no token file, no
  stylesheet); `git log --diff-filter=D` on the product repository, which is where the set and its
  removal were found. The only visual source on disk is `third_party/lucide/icons/` and
  `scripts/design-check.mjs`, both of which this draft binds to.
- **Answer:** **baseline: this draft.** The owner's words: "i prefer **not** to use the old
  information." The removed design reference (`c4fb333`, removed `1d5c553`) is not folded and no
  pointer item is written for it. Its values stay history; `DESIGN.md`'s fresh derivation off UXD v2
  stands as authored. Nothing needs restoring, and the restore command recorded in `1d5c553`
  (`git checkout ea5a495 -- docs/design_reference`) is deliberately not used.

## 2. Choices to confirm

### 2.1 The shell is achromatic; colour belongs to the repository — the signature, and the one aesthetic risk

- **Drafted into DESIGN.md:** § Overview and § Colors: three grey surfaces and grey ink in each
  theme, no accent colour anywhere in the shell; the only hues are the four Git-state families
  (`{colors.git-added}`, `{colors.git-modified}`, `{colors.git-deleted}`, `{colors.git-renamed}`)
  and the five syntax roles (`{colors.code-*}`), plus the two diff tints. Selection and the active
  rail entry are a grey fill plus a 2px ink bar on the left edge (§ Shapes), so the achromatic
  selected state stays unambiguous. RN-2, RN-3.
- **Grounds:** none in the product's source — a taste call, grounded in the PRD's character
  ("calm, truthful, still"; the product presents state and acts on nothing) and the UXD's framing
  that density is the repository's, not the shell's. The risk: a workbench with no accent can read
  as unstyled. If you override — a single accent hue for selection, controls and the active rail
  entry — the accent becomes a twentieth colour token with a dark value, `{colors.selection}`
  re-tunes around it, the left bar takes the accent, the Git hues are re-checked so none collides
  with it, and RN-2 records the override.
- **Confirm or override:** confirm — the shell stays achromatic; no accent hue is introduced.
  Colour remains the repository's alone: the four Git-state families, the five syntax roles and the
  two diff tints. Selection and the active rail entry keep the grey fill plus 2px ink bar. RN-2 and
  RN-3 stand as drafted. The owner said "confirm" and nothing more; the argument put to them —
  that an accent would be the one colour on screen meaning "the tool is talking about itself",
  competing with the only signal the product exists to deliver, and that the "reads as unstyled"
  risk is answerable with weight and spacing rather than hue — is the session's.

### 2.2 Type is the platform's own two families, nothing shipped — SF Pro via `system-ui`, SF Mono via `ui-monospace`

- **Drafted into DESIGN.md:** § Typography and every `{typography.*}` level: `-apple-system,
  system-ui` for the shell and prose, `ui-monospace, "SF Mono", Menlo` for paths and code; two
  weights (400/600, 500 on the rail label only); 13px UI and code, 15px prose. RN-7.
- **Grounds:** `docs/UXD.md` UX-I15 and § 9 (every asset ships with the tool or is already on the
  machine), the UXD's typography dial at 2, `docs/SRS.md` C-11 (macOS only, where both faces are
  stock). No product source names a face; `scripts/design-check.mjs` says fonts are self-hosted,
  which shipping none satisfies. If you override — a shipped face for code (a JetBrains Mono, an
  IBM Plex Mono) or for the shell — the family lands in the repository with its licence notice
  (SRS C-5), the `fontFamily` lines change, the sizes and line-heights are re-checked for that
  face's x-height, and RN-7 records it.
- **Confirm or override:** confirm — no typeface is shipped. The platform's own two families
  stand: `-apple-system, system-ui` for shell and prose, `ui-monospace, "SF Mono", Menlo` for paths
  and code, with the drafted weights and sizes. RN-7 stands as drafted. The owner said "confirm"
  and nothing more; the grounds put to them — that macOS-only (SRS C-11) makes "the platform's
  font" and "a good font" the same answer at zero bytes and no licence obligation, and that a
  signature face would pull against the achromatic call confirmed at § 2.1 — are the session's.

### 2.3 The density and motion posture — 24px rows, 13px text, a 260px sidebar, a 48px rail, and nothing that moves or highlights on hover

- **Drafted into DESIGN.md:** § Layout (`{spacing.row}` 24px, `{spacing.indent}` 12px,
  `{spacing.sidebar-width}` 260px, `{spacing.rail-width}` 48px, `{spacing.chrome-height}` 36px,
  minimum window 720px); § Do's and Don'ts (no transition, no hover state, no focus ring, no
  tooltip); § Components "Rows". RN-8, RN-11.
- **Grounds:** the UXD's dials (motion 2, density 6) and UX-I2 ("no ceremony"), UX-I8 (no keyboard
  model); the proposal's 240–280 sidebar as input (`docs/proposal.md` § UI Shape); macOS list
  conventions for row height and the absence of hover. The widths are chosen values. If you
  override any width, the dependent values move with it (a wider sidebar lowers the minimum
  window's panel share; a taller row re-spaces the rail entries); if you want a hover state, a
  `hover` colour token enters with a dark value and every text token is re-checked against it.
- **Confirm or override:** **partial override — the numbers confirm, the no-hover rule does not.**
  - **Confirmed as drafted:** every measurement — `{spacing.row}` 24px, `{spacing.indent}` 12px,
    `{spacing.sidebar-width}` 260px, `{spacing.rail-width}` 48px, `{spacing.chrome-height}` 36px,
    minimum window 720px — and 13px text.
  - **Overridden:** **a hover state is added, on clickable rows.** The owner's reason, in their
    words: "hovering is something that developers use." Scope as they stated it — rows that are
    actually clickable (the file tree's rows, and any other live row); not inert rows, where a
    hover highlight would promise an action that is not there. So § Do's and Don'ts loses "no hover
    state" and gains the scoped rule; a `hover` colour token enters with a dark value; every text
    token is re-checked against it; RN-11 records the override.
  - **Not spoken to, so unchanged:** no transition, no focus ring, no tooltip all stand as drafted.
    The owner overrode hover alone, and the other three are not read as covered by it.

### 2.4 Git state is four hue families for six status letters, and a diff carries no syntax colour

- **Drafted into DESIGN.md:** § Colors "Git state": A and U green, M amber, D and C red, R teal;
  the letter is the meaning and the hue repeats it. § Components "Diff": ink text on the two
  tints, `+`/`−` in the gutter, no syntax roles. RN-4.
- **Grounds:** `docs/UXD.md` UX-A2 and the reference's own lesson (`docs/ux_reference/README.md`
  § `vscode-git-view.png`, the status letter). The four-family grouping and the no-syntax-in-diff
  rule are this seat's. If you override — a hue per letter, or syntax colour inside diffs — two
  more Git tokens enter with dark values and are checked against `canvas` and `selection`, or the
  five code tokens are additionally checked against both diff tints (on this run `code-comment`
  on `diff-removed` measures 4.28:1 in light and would need a darker value).
- **Confirm or override:** confirm — **both calls as drafted.** Four hue families for the six
  status letters (A/U green, M amber, D/C red, R teal), and **no syntax colour inside a diff**: ink
  text on the two tints, `+`/`-` in the gutter. RN-4 stands.
  The owner's words: "so there is color in the diff and this is only an addition. then i confirm
  both." Their basis, stated so the fold cannot misread the confirm: a diff **already carries
  colour** — the two background tints that say added and removed — and syntax hues would be a
  further layer on top of that, not the diff's only colour. They confirmed on that understanding,
  so the tints stay and the syntax layer is not added. `code-comment` on `diff-removed` therefore
  needs no re-tuning (it measures 4.28:1 in light, below the floor, and is never rendered there).

### 2.5 The rail carries `folder` and `git-branch`, the fourteen vendored Lucide glyphs are the whole icon inventory, and the theme control sits at the chrome's right end

- **Drafted into DESIGN.md:** § Components "The rail", "Icons", "The chrome": `folder` over
  *Files*, `git-branch` over *Git*; the set at `third_party/lucide/icons/` is the inventory, a
  fifteenth glyph is vendored with its notice; the theme control is a `sun`/`moon` glyph plus the
  word *Light*/*Dark* at the right end of the chrome, naming the theme it switches *to*. RN-10,
  RN-12.
- **Grounds:** the glyph set is the product's own source (`third_party/lucide/`, committed at
  `c4fb333`; the proposal names Lucide). The assignment is this seat's. The theme control's
  placement is **structural** — the UXD requires an override control (UX-I9) but places none —
  so confirming it also asks that `docs/UXD.md` § 4 record the chrome as its home. If you
  override the placement (the sidebar's foot, a menu under the selector), § Components "The
  chrome" and RN-10 reword and the chrome drops to one control; if you override the rail pair,
  the two glyphs swap for others in the set or a vendored addition.
- **Confirm or override:** confirm — **all three**, in the owner's words "confirm all three".
  1. The rail pair: `folder` over *Files*, `git-branch` over *Git*.
  2. The fourteen vendored Lucide glyphs at `third_party/lucide/icons/` are the whole inventory; a
     fifteenth is vendored deliberately with its notice.
  3. The theme control sits at the chrome's right end — `sun`/`moon` plus the word *Light*/*Dark*,
     naming the theme it switches **to**. RN-10 and RN-12 stand.
  **This confirm carries the structural consequence the item names:** `docs/UXD.md` § 4 is to
  record the chrome as the home of the override control UX-I9 requires but does not place. The
  owner was told they were authorising that UXD amendment before answering. It fills a gap the UXD
  left open; it overturns no call the UXD made.

### 2.6 No wordmark, logo, or product name in the shell

- **Drafted into DESIGN.md:** § Components "The chrome" and the last-but-one Don't: the chrome
  names the repository, not the product; KA-Reader's name and its kanji live on the README. RN-9.
- **Grounds:** `docs/UXD.md` § 4 (the shell names what it is looking at) and the instance's
  direction that the one job is what is on the surface; the earlier design reference in history
  carried a wordmark treatment, which this draft does not read (§ 1.1). If you override — a small
  wordmark in the chrome — it enters as a vendored asset with a stated place (left of the
  selector), a size token, and the ink colour in both themes; RN-9 records it.
- **Confirm or override:** confirm — no wordmark, logo, or product name in the shell. The chrome
  names the repository; KA-Reader's name and its kanji stay on the README. RN-9 stands. The owner said
  "confirm" and nothing more; the argument put to them — that a wordmark beside the repository name
  reintroduces the doubling the UXD's § 2.2 call removed, and that a tool naming itself in its own
  chrome spends permanent screen space on what the user already knew — is the session's.

### 2.7 The contrast floor is two numbers — ink ≥ 9:1, every other text token ≥ 4.5:1 — against the surfaces each token is specified for

- **Drafted into DESIGN.md:** § Colors "The contrast floor, as a number", with the per-token
  surface specification that the numbers bind to, and RN-6's measured minima in both themes.
- **Grounds:** `docs/UXD.md` § 8 asks for the floor as a number and makes it the product's floor
  from the moment it is written; the values were measured on this run with the WCAG 2.x formula.
  This is a commitment the product will be held to, which is why it is here rather than only in
  the document. If you override — a single 7:1 across the board, or 4.5:1 for everything — RN-6
  and the § Colors sentence reword; the palette does not move unless the number goes up past
  what the values hold (9:1 for muted text would require re-tuning `{colors.ink-muted}` and
  `{colors.selection}` in both themes).
- **Confirm or override:** confirm — the floor stands at the two drafted numbers: ink >= 9:1, every
  other text token >= 4.5:1, each against the surfaces that token is specified for. RN-6's measured
  minima stand. The owner said "confirm" and nothing more; the argument put to them — that 4.5:1 is
  the WCAG AA floor for normal text and so is not really a choice, that 9:1 for primary ink is a
  cheap overshoot that buys legibility on poor displays and in bright rooms, and that these being
  measured rather than aspirational makes them checkable — is the session's.
