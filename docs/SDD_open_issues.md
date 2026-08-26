# SDD open issues — Nozoki 覗き

> Companion to `SDD.md`. Three seats — the CTO, the CPO and the CDO — authored the SDD
> non-interactively in one run; this file holds what that run could not settle from its inputs (the
> PRD, the SRS, the UXD, and any context or constraints).
>
> **Answer inline** — fill each **Answer** / **Confirm-or-override** / **Keep-or-recut** slot —
> **commit this file**, then re-run `product-sdd`. It folds your answers into the SDD and drops the
> resolved items. When nothing is left open, `product-sdd` **deletes this file**: no file = the SDD
> is done.
>
> Your answers are never thrown away. Each time the seats fold them in, they first copy this file
> whole to `docs/sdd_trail/` — so what you decided, and why, stays readable and citable for good.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a disagreement is not something one seat asked, it
> is something two seats answered differently, and the answer that settles it picks between them.

---

## 1. Open issues — questions with no answer yet

### 1.1 Will the release be Developer ID-signed and notarized — a paid Apple Developer Program membership — or shipped unsigned with a Gatekeeper step in the README?
- **Raised by:** CTO
- **Why it matters:** `SDD.md` § 4 C-R4 and § 11 R-2. On macOS Sequoia a stranger can no longer
  Control-click to open software that is not signed and notarized; they must go through System
  Settings › Privacy & Security (https://developer.apple.com/news/?id=saqachfa). Unsigned, the
  install path gains that step and the README's first screen must carry it (C-3, C-9); AC-10's
  five minutes still fit, but the first thing a stranger meets is a warning. Signed and notarized,
  the step disappears and the cost is the membership and a signing secret in CI. § 11 R-8 also
  turns on this: whether the sandbox is enforced under an ad-hoc signature is an Open Question in
  `SDD.md`, and an unsigned release may not be able to pass the sandbox gate. The answer moves
  C-R4's README wording and `pick-it-up-release`'s bar; nothing else.
- **Answer:**

### 1.2 In the Git view, what does a reader do to open a changed file's diff rather than the file itself?
- **Raised by:** CDO
- **Why it matters:** `docs/UXD.md` UX-F2 says opening a changed file from the Git view "behaves
  exactly as a tree selection" — it opens the file to read — and UX-F4 says that from the same
  view the reader "opens a changed file's **diff**". One row, two destinations, and the UXD names
  no control that tells them apart (`docs/DESIGN.md` § Components "Rows" draws a Git-view row
  with one click act). `SDD.md` `read-the-diff`'s observable bar is written to hold under any
  answer, but a seed cut from it cannot be closed until one exists. Three shapes fit the settled
  documents; the CDO's own lean is the first, because it adds no element to a row: **(a)** the
  row opens the diff once `read-the-diff` lands, and the file is read by clicking it in the tree —
  so the Git view's row changes meaning at S-7, which UX-F2 would then be revised to say; **(b)** a
  second click target on the row — the status letter opens the diff, the name opens the file —
  which gives the letter a second job beside the tooltip; **(c)** the diff opens from the reading
  panel's path line once a changed file is open, leaving the Git view's row as UX-F2 has it. The
  answer is folded into the UXD by its own run, and `SDD.md` then cites the revised entry.
- **Answer:**

### 1.3 Where is the history view drawn — in the sidebar, in the reading panel, or in place of one of them?
- **Raised by:** CDO
- **Why it matters:** `docs/UXD.md` § 4 places a diff "in the reading panel" and has commit history
  "reached from the Git view"; UX-S6 names the history view as a surface and says what it shows,
  and neither says where it is. `docs/DESIGN.md` § Components draws commit rows as
  `{components.tree-row}`s on `{colors.canvas}` — sidebar furniture — and the branch-set control
  as a floating menu, which reads as a sidebar placement, but that is this seat's inference, not a
  statement either document makes. `SDD.md` `read-the-history`'s observable bar holds either
  way; the shell layout a seed builds does not. The CDO's own lean is the sidebar: the history is
  Git state, a commit's diff already takes the reading panel, and a graph in the panel would leave
  the reader's diff nowhere to go. The answer is folded into the UXD by its own run.
- **Answer:**

## 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override

### 2.1 The SDD follows the SRS, not the PRD, on the Markdown raw-source switch
- **Raised by:** CPO
- **Drafted into the SDD:** No slice requires the raw-source switch or relative-link opening;
  `read-markdown` fences both as build-cost permissions the CTO records (`SDD.md` § 6 S-2, RN-3).
- **Rationale:** Your override at `docs/srs_trail/cycle-5.md` § 2.3 — "render is what i need", "add
  the toggle if it costs nothing" — is carried by `docs/SRS.md` FR-31 and RN-29, which record that
  `docs/PRD.md` § Core Features still says "the toggle follows" and that folding the override upstream
  is a PRD correction cycle. The SDD is downstream of both and follows the later, owner-confirmed
  statement; it does not edit the PRD.
- **If overridden:** If the PRD's line stands as the promise — the toggle ships in a later release —
  `read-markdown` gains a required second treatment of the reading panel and AC-22's switch clause
  becomes a bar rather than a conditional; nothing else moves.
- **Confirm or override:**

### 2.2 The runtime: Tauri 2 — a Rust host, the surfaces in the system WKWebView — as one sandboxed `.app`
- **Raised by:** CTO
- **Drafted into the SDD:** `SDD.md` § 2 (the shape and its runner-up), § 4 C-R1, C-R5 (macOS 14
  floor), RN-7. The bundle is `Nozoki.app`; the host is Rust over a `nozoki-core` library; the
  surfaces are HTML / CSS / TypeScript rendered by the OS WebView; no bundled browser engine.
- **Rationale:** C-3 and the SRS's RN-12 press toward a self-contained artifact with no
  prerequisite; the design language is expressed as web tokens and vendored SVG icons
  (`docs/UXD.md` § 9, `third_party/lucide/`); a Tauri host exposes only the commands it registers,
  which is the closed IPC list the shape rests on. Electron was rejected for the bundled engine it
  adds; native AppKit / SwiftUI is the runner-up and is the shape `SDD.md` § 2 names as winning if
  you override. **This call was made without opening `docs/DESIGN.md` or `docs/CONTENT.md`** —
  both exist in the repository and neither is in the run's input set; if `DESIGN.md` binds a
  rendering technology, say so here.
- **If overridden:** To native: § 2's fourth row becomes the taken one, § 3's `surfaces` and
  `markdown-renderer` are redrawn (attributed strings, no HTML, no CSP), seam 4 becomes in-process
  calls, C-R7 is dropped, TO-1 reverses; the slices, their order and the harness stand. To Electron:
  § 4 C-R1 names it, C-R6's allowlist grows by the engine, TO-4 changes; nothing else moves.
- **Confirm or override:**

### 2.3 The start mechanism: the repository is granted through the system Open panel at launch, and startup failure renders in the app's window
- **Raised by:** CTO
- **Drafted into the SDD:** `SDD.md` § 4 C-R3, RN-9, § 11 R-9. Launch Nozoki; the Open panel asks
  for the folder; that folder is the repository for the session (FR-2). Pointed at something that is
  not a repository, the window shows UX-S4 with a way to choose again and a way to leave. No path is
  typed and nothing is printed to a terminal.
- **Rationale:** Under the App Sandbox a folder is readable only when the user selected it in an
  Open dialog
  (https://developer.apple.com/documentation/bundleresources/entitlements/com.apple.security.files.user-selected.read-only);
  the sandbox is what makes the no-write promise the operating system's rather than the code's
  (§ 2 force 3). This also answers the UXD's open question on where UX-S4 renders. Whether a folder
  dropped on the Dock icon or opened with *Open With* is granted the same way is an Open Question in
  `SDD.md`, verified in `read-a-repository`.
- **If overridden:** If you want a typed path (`nozoki <path>` or a launch argument) as the start,
  the sandbox cannot grant it: C-R2's read-only entitlement goes, the OS wall goes with it, and the
  no-write promise rests on the harness and the code alone — § 2's first question answered "if the
  code is careful". UX-S4 may then render in a terminal and the terminal fences bind it.
- **Confirm or override:**

### 2.4 Images in rendered Markdown are not loaded in any release — remote or inside the repository — and show the not-loaded placeholder
- **Raised by:** CTO
- **Drafted into the SDD:** `SDD.md` § 3 `markdown-renderer`, RN-11, § 9 TO-6. `docs/UXD.md` UX-I12
  already draws the placeholder for a remote image; the SDD extends it to an image inside the
  repository.
- **Rationale:** The renderer holds no path to the repository — that is the shape's wall (§ 2
  force 3) — and loading a local image means handing it one. The SRS and UXD speak of remote images
  only (FR-32, UX-I12); a local image is a gap this run filled the conservative way.
- **If overridden:** `read-markdown` gains a read-only asset handler on the host scoped to the
  granted repository, C-R7's `img-src` widens to that handler, AC-23's fixture gains a local image,
  and the CDO's UX-I12 placeholder text narrows to remote images. `read-markdown`'s bar grows; no
  other slice moves.
- **Confirm or override:**

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

### 3.1 `read-markdown` is its own slice, not part of `read-a-repository`
- **Raised by:** CPO
- **The cut as drafted:** `read-a-repository` shows a Markdown file as plain text; `read-markdown`
  is the second slice and delivers the rendered view with nothing fetched and nothing executed.
- **The alternative cut:** One slice, `read-a-repository`, delivering the whole reading surface the
  PRD draws — floor highlighting, plain text, non-text state and rendered Markdown together.
- **What changes if it moves:** The first slice grows by the renderer decision (SRS FR-32, NFR-16,
  AC-23) and its proof of the read-only shape waits on it; one slice fewer in § 7, and the
  build-cost judgments on FR-31/FR-32 land in the first slice rather than the second.
- **Why it is yours to call:** Both cuts pass the four tests. The question is appetite: whether the
  first thing proved is the promise alone (as drafted) or the promise with the whole reading surface.
- **Keep or re-cut:**

### 3.2 `read-the-history` is one slice — topology and the branch-set choice together
- **Raised by:** CPO
- **The cut as drafted:** One slice delivers the history drawn as branches against a chosen set,
  with the default that asks nothing, per-commit fields, and per-commit diffs.
- **The alternative cut:** Two slices — the history against the default set (the current branch and
  what relates to it) with per-commit diffs first, then the branch-set choice as its own slice.
- **What changes if it moves:** A reader gets a usable history one slice earlier; the choosing
  control (UXD UX-F4, RN-14) lands later, and § 7 gains one `depends_on` edge.
- **Why it is yours to call:** The default already needs the topology drawn, so the CPO reads the
  split as a task inside a slice, not a decision; but the order you want value in — history sooner
  versus the whole owner-settled shape at once — is not written down anywhere.
- **Keep or re-cut:**

### 3.3 When `pick-it-up-release` lands — after the whole v1 cut, or as soon as reading works
- **Raised by:** CPO
- **The cut as drafted:** `pick-it-up-release` is a slice of its own whose value — a stranger installs
  by one path and reads a file of their own repository in five minutes — does not depend on
  `see-what-changed` or `watch-a-moving-tree` having landed; its README says what the release does
  and does not do, and the release is pre-1.0.0. Where it sits among S-1 – S-4 is left to § 7.
- **The alternative cut:** The first public release waits for the full v1 cut the PRD names
  (`docs/PRD.md` § Scope (In): "everything under Core Features"), so that the first thing a stranger
  meets is the product the PRD calls v1.
- **What changes if it moves:** The acquisition-path decision (SRS C-3, RN-12 — the pressure toward
  a self-contained artifact) is proved later, after three more slices are built on the runtime it
  constrains; nothing is public until then.
- **Why it is yours to call:** Appetite for a public partial versus a first impression that matches
  the PRD's v1; the four tests do not decide it, and the PRD's "v1" names a feature set, not a
  release timing.
- **Keep or re-cut:**

---

## 4. Disagreements — two seats hold different positions and neither yields

*(none yet)*
