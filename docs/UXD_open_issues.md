# UXD open issues — Nozoki 覗き

> Companion to `UXD.md`. The CDO authored the UXD non-interactively; this file holds
> what it could not settle from the inputs (the PRD, the project's Agari and its doctrine, the
> SRS when present, and any context the owner handed over) — and, when a design run has produced
> output for this product, the pointer to it. **Answer inline** — fill each **Answer** / **Confirm-or-override**
> slot — **commit this file**, then re-run `product-uxd`. It folds your answers into the UXD
> and drops the resolved items. When nothing is left open, `product-uxd` **deletes this file**:
> no file = the UXD is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CDO folds them in, it first copies this
> file whole to `docs/uxd_trail/` — so what you decided, and why, stays readable and citable
> for good.

> **This is a re-authoring, and four of the six items below were answered once before.** The
> earlier UXD and its trail were removed at `9017ae2`, and the station that opened this run
> records that the removed document binds nothing. So each taste call is drafted again with the
> same lean the earlier answer took, the earlier answer is cited as evidence (readable at
> `nozoki@1d5c553:docs/uxd_trail/`), and the call is yours again. Two items (§ 2.5, § 2.6) are new
> to this revision. The history topology is **not** here: your statement of its shape is on disk
> at `docs/srs_trail/cycle-3.md` § 2.1 and the UXD carries it as settled (UXD RN-14).

---

## 1. Open issues — experience questions with no answer yet

None this round — every call the PRD does not make carried a defensible lean, so each is under
§ 2 as a choice to confirm.

## 2. Choices to confirm — the CDO drafted a best-effort answer; confirm or override

### 2.1 The design direction — a restrained code-workbench built from primitives, no established component design system

- **Drafted into the UXD:** § 1 (Design Read) and § 9 (Design-System Direction): no established
  component design system; a restrained code-workbench aesthetic built from primitives — reading
  panel dominant, text-first navigation, minimal chrome, nothing decorative; the platform's own
  controls and appearance as the starting point where the UXD and `DESIGN.md` are silent. One
  system for the product. `DESIGN.md` is then authored from primitives against § 9's
  constraints.
- **Rationale:** the PRD's familiarity thesis names the layout — a conventional editor-style
  workbench, which no general-purpose component design system provides — and the character
  ("calm, truthful, still") rules out imported component aesthetics. The instance direction
  starts every product from its platform's own look and holds no house aesthetic
  (`system/experience/visual_direction.md` § Overview, line 2). The aesthetic lean is a taste
  call, so however confidently drafted it is yours. You confirmed the same lean before
  (`nozoki@1d5c553:docs/uxd_trail/cycle-1.md` § 2.1) — evidence, not authorization (UXD RN-8).
- **If overridden** (an established design system named instead): § 1's read and § 9's
  direction and constraints re-anchor to that system; `DESIGN.md` is authored from the named
  system's official package rather than from primitives; § 2's dial reasoning is re-checked
  against the system's idiom; UX-I15 still holds (every asset ships with the tool), so a system
  that loads fonts or icons from a remote origin at runtime is out; RN-8 records the override.
  The flows, screens and states (§§ 5–6) do not move.
- **Confirm or override:** confirm — no established component design system; built from primitives.
  The owner agrees with both grounds put to them: every asset must ship inside the tool (UX-I15), so a
  system that fetches fonts or icons at runtime would have to be audited and vendored anyway — the cost
  without the convenience; and the surface is one reading panel, one sidebar, one chrome strip and a
  two-entry mode switch, too small for a design system's payoff of consistency across many unfamiliar
  components to arrive.

### 2.2 Where the repository selector lives — the shell chrome, not the Git view header

- **Drafted into the UXD:** UX-F5 and § 4 (RN-15): the selector — the dropdown you named in
  `docs/ux_reference/README.md` § Owner directives 2, current repository's name as both label
  and control, remembered repositories plus a browse entry — lives in the **shell chrome**: the
  identity element (RN-2) becomes the control. The dropdown itself is your directive and is not
  in question; only its home is.
- **Rationale:** your own framing in that directive — a name in one place and a switch in
  another is two elements telling one truth — points at the chrome: what names the repository
  is what changes it, and the chrome is reachable from either sidebar mode, while the Git view
  header is unreachable with the sidebar in Files mode. Switching is a whole-shell act (it
  resets the arrival state), not a Git-scoped one. You confirmed this placement before
  (`nozoki@1d5c553:docs/uxd_trail/cycle-2.md` § 2.2) — evidence, not authorization.
- **If overridden** (the Git view header, as `vscode-repo-selector.png` shows): the selector
  moves into UX-S3's header, grouped with repository-scoped state; the chrome's identity element
  (§ 4, RN-2) stays display-only; UX-F5 gains a step — switching from Files mode means switching
  to Git first; UX-S7's route-out cell moves with it; RN-15 records the trade taken knowingly.
- **Confirm or override:** confirm — the selector lives in the shell chrome; the identity element
  becomes the control. The owner's word was "i agree", and nothing beyond it. The reachability
  argument put to them before they answered — that with the selector in the Git view header a reader
  in Files mode must switch to Git purely to switch repository — is the session's, recorded as what
  they were shown, not as something they said.

### 2.3 The Files/Git switch — a pair of labelled tabs at the top of the sidebar

- **Drafted into the UXD:** § 4 (RN-16): the sidebar's two modes are switched by a pair of
  labelled tabs at the top of the sidebar — text-first, exactly the two destinations that
  exist; not an icon rail.
- **Rationale:** the reference raises this and settles nothing (`docs/ux_reference/README.md`
  § One question the reference raises). VS Code's rail is built for many destinations and
  identifies them by icon alone; Nozoki's § 4 rule is text-first with icons secondary, and it
  has two destinations, ever — the Agari admits no third view. Labelled tabs say what each mode
  is in words, cost no chrome the shell does not already have, and keep the sidebar's full width
  for content. You confirmed this before (`nozoki@1d5c553:docs/uxd_trail/cycle-2.md` § 2.3) —
  evidence, not authorization.
- **If overridden** (a rail, or another control): § 4's presentation line and RN-16 reword; an
  icon rail needs a stated exception to § 4's text-first rule and to UX-A4 (no control by glyph
  alone), recorded rather than implied.
- **Confirm or override:** override — a VS Code-style icon rail down the left edge, not labelled tabs
  at the top of the sidebar. **Each of the two rail entries carries its icon with a small text label
  beneath it**, not an icon alone — so UX-A4 (no control by glyph alone) is satisfied and no exception
  to it is owed. § 4's presentation line and RN-16 reword to the labelled rail; § 4's text-first rule
  still needs a stated exception recorded explicitly, since the rail leads with the glyph.

### 2.4 The v1 accessibility posture is stated on the README, not on its first screen (UX-A3)

- **Drafted into the UXD:** UX-A3 — one plain sentence on the README, further down than its
  first screen, stating what UX-A1 holds: v1 is mouse-driven and makes no assistive-technology
  promise. No claim beyond the settled posture. Its wording is `docs/CONTENT.md`'s.
- **Rationale:** the posture you settled (`docs/prd_trail/cycle-5.md` § 2.1) otherwise lives in
  the PRD and the UXD, which an adopter never reads. A silent floor fails them quietly; a
  stated narrow floor is information they can act on before spending their first minute, and a
  claim the project can be held to. It adds a line to a surface the CPO owns — the README, whose
  first-screen content the PRD already fixes to four things — which is why it is routed rather
  than asserted, and why the draft keeps it off the first screen. You confirmed this with the
  same bound before (`nozoki@1d5c553:docs/uxd_trail/cycle-1.md` § 2.2) — evidence, not
  authorization.
- **If overridden** (keep the posture out of the README): UX-A3 drops from the UXD and RN-17
  records the decision; UX-A1 and UX-A2 stand untouched; the posture stays discoverable only in
  the product documents.
- **Confirm or override:** confirm — UX-A3 stands: one plain sentence on the README stating what
  UX-A1 holds. The owner's words: "agreed, keep it below the first screen" — so the placement bound
  is theirs and stated, not inherited from the draft. The reasons put to them beforehand (the sentence
  serves the adopter who can act on it before spending their first minute; a first-screen disclaimer
  would read as the product apologising for itself) are the session's, not their statement.

### 2.5 The initial theme follows the platform's appearance setting; with no setting to read, light

- **Drafted into the UXD:** UX-I9 and § 9 (RN-7): the initial theme follows macOS's own
  appearance setting; the user may override, and the choice is remembered in the tool's own
  state. The half not yet in the UXD, and the part that is yours: where no platform signal can
  be read, the hard default is **light**, with the reason recorded in `DESIGN.md`.
- **Rationale:** the adopter's environment outranks the product's aesthetic, and the operating
  system already carries their answer — the instance direction starts every surface from the
  platform's own look (`system/experience/visual_direction.md` § Overview, line 2), which is
  what makes the first half derivable. The signal-less default is not: it is a polarity choice
  with no PRD basis, and the lean to light rests on this seat's reading that dark-text-on-light
  is the more widely evidenced legibility default for reading text — held as reasoning, not a
  citation. On macOS a signal is always readable, so the case is rare; it is routed because a
  default nobody chose is the failure this document exists to prevent.
- **If overridden** (dark as the signal-less default, or always-follow-the-platform with no
  hard default): UX-I9 and § 9's first constraint reword; RN-7 records the choice; `DESIGN.md`
  carries the stated default.
- **Confirm or override:** confirm — **light** is the hard default where no platform appearance
  signal can be read; the initial theme otherwise follows macOS's setting, the user may override, and
  the choice is remembered. The stated default goes into `DESIGN.md` per the draft.

### 2.6 A link in rendered Markdown that does nothing is drawn as text with its destination readable, not as a control

- **Drafted into the UXD:** UX-I12 (RN-10): a link is displayed with its destination readable;
  it is a control only where activating it does something. An external link is never a control
  and never opens anything. A relative link is a control only in a release that opens relative
  links, and then opens the target file in the reading panel exactly as a tree selection does.
  A remote image that is not fetched is shown as a stated not-loaded placeholder where it would
  appear.
- **Rationale:** your settled calls are carried, not reopened: an external link is *"shown, the
  reader can see where it points, and the system opens no path off the machine"*
  (`docs/srs_trail/cycle-6.md` § 2.1, the rationale you confirmed), and a relative link opens
  its target only if it costs nothing (`docs/srs_trail/cycle-5.md` § 2.2). What this item adds
  is the presentation: the SRS trail's drafted wording was *"shown as a link and does nothing
  when activated"* (`docs/srs_trail/cycle-5.md` § 2.2, "Drafted into the SRS"), and a control
  drawn as a route and wired to nothing is the shape the instance fence names as not a route
  (`system/experience/visual_restrictions.md` § `failure-says-what-next`). Drawing the
  destination as readable text keeps every word of your call and removes the dead control. It is
  product-visible — what a reader sees where a link would be — so it is yours.
- **If overridden** (links drawn as links, inert when activated): UX-I12's link sentences
  reword to the SRS trail's drafted wording; RN-10 records that the inert control is accepted
  knowingly against the fence's shape; nothing else moves.
- **Confirm or override:** confirm — UX-I12 as drafted: a link is drawn with its destination
  readable, and is a control only where activating it does something; an external link is never a
  control; a relative link is a control only in a release that opens relative links; an unfetched
  remote image shows a stated not-loaded placeholder. The owner's word was "agree", and nothing
  beyond it. The argument put to them — that readable destination text gives the reader an address
  they can copy and judge, where an inert control promises a route the tool has decided not to take —
  is the session's, recorded as what they were shown.
