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
- **Answer:** Unsigned. Nothing is paid for this app, and that holds for any app in this
  instance — no Apple Developer Program membership, now or later. The app is **not** going into
  the Mac App Store; the only channel is a download from GitHub. The README carries whatever
  Gatekeeper step macOS requires. Do not raise signing again.
  **The install mechanism itself is the CTO's to figure out** — there are plenty of ways to install
  an app on a Mac, and picking one is a technical call, not the owner's. The bounds it must hold:
  costs nothing, comes from GitHub, and stays the single simple path `docs/PRD.md` § Scope (In)
  requires.

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
- **Answer:** **(a)** — the row opens the **diff**. One click target on the row; the file itself is
  read by clicking it in the tree. UX-F2 is revised to say so.
  Answered by demonstration: the owner supplied two VS Code screenshots (2026-08-26 22:03 and
  22:06) of its Source Control view and asked that Nozoki behave the same way. In them, clicking a
  changed file row — in the working-tree `CHANGES` list and under a commit in the graph alike —
  opens a side-by-side diff in the editor (`PRD.md (07efc27) ↔ PRD.md (a85bc24)`), never the file.
  **The status letter stays a label, not a second click target** — `M`, `A` and `R` are visible at
  the right edge of the rows and are read, not clicked. That is the owner's stated reason for
  rejecting (b); (c) was not taken.

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
- **Answer:** **The sidebar** — the CDO's own lean, confirmed. The history is Git state and belongs
  with the other Git furniture; the reading panel stays free for the diff.
  Answered by the same two VS Code screenshots: the commit graph is drawn as rows in the sidebar
  below the changes list, a selected commit expands to show its changed files as rows of the same
  kind, and selecting one opens that commit's diff in the editor panel. The owner asked for that
  arrangement.

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
- **Confirm or override:** Confirm. The SDD follows the SRS: render is what is needed, and the
  raw-source switch and relative-link opening stay build-cost permissions the CTO may take or
  leave. The stale `docs/PRD.md` § Core Features line ("the toggle follows") is a PRD correction
  for its own run; it does not change this.

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
- **Confirm or override:** Confirm. Tauri 2 — a Rust host over `nozoki-core`, the surfaces in the
  system WKWebView, one sandboxed `Nozoki.app`, no bundled engine.
  **The `DESIGN.md` / `CONTENT.md` check the rationale asked for was run during this walk, and it
  supports the call rather than unsettling it.** `docs/DESIGN.md:330` realises the system "in plain
  CSS custom properties over the product's own markup on a macOS window", and RN-1
  (`docs/DESIGN.md:733-740`) states outright that the runtime — "a browser tab or a native window"
  — is the SDD's, while **every value the design language holds is a CSS value**. So DESIGN.md
  leaves the runtime open and binds the surface to CSS: a web-rendered surface satisfies it as
  written, and the native AppKit / SwiftUI runner-up would require re-authoring a document settled
  at v4 with no companion beside it. `docs/CONTENT.md` names no rendering technology at all.

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
- **Confirm or override:** Confirm. The repository is granted through the system Open panel, and
  startup failure renders in the app's window.
  **The owner first read this as contradicting their request to see several repositories; it does
  not, and the reason is worth keeping.** The sandbox grant is once **per repository**, not once
  per viewing: C-R2 adds `com.apple.security.files.bookmarks.app-scope` from
  `switch-the-repository` on, which is what makes a granted folder re-openable without asking
  again. So the panel is the door walked through once per repository — after that it is the
  chrome's remembered list (S-6, `SDD.md:924-948`), two clicks and no panel, with *Browse…* the way
  to add another. Several repositories **at once** stays permanently out
  (`docs/PRD.md:285-286`, owner-confirmed `prd_trail/cycle-1.md`); switching *which one* is S-6 and
  is in the cut.
  **One reconciliation for the CTO, not an owner question:** C-R3 says the host asks through the
  Open panel "at start", written before S-6's remembered list existed in the same document. Once
  S-6 lands, launch presumably restores the last-viewed repository rather than always presenting a
  panel. Reconcile C-R3's wording on the fold.

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
- **Override.** Local images — an image that lives inside the granted repository — **are loaded**
  and render in place. `read-markdown` gains a read-only asset handler on the host, scoped to the
  granted repository; C-R7's `img-src` widens to that handler; AC-23's fixture gains a local image.
  Remote images are unchanged and still not fetched — the no-network promise is untouched — so
  `docs/UXD.md` UX-I12's placeholder text narrows to remote images, which is folded by the UXD's
  own run. `read-markdown`'s bar grows; no other slice moves.

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
- **Keep or re-cut:** **Keep** — but taken as *either is acceptable*, not as a preference between
  them. The owner's words: *"bottom line, it can be either."*
  **The owner's standing appetite, for the seats to apply instead of asking:** smaller tasks rather
  than larger, **but not too small**.
  **And the reason this was not a decision worth their turn — carry it forward:** *"don't forget,
  the PPM will slice even more."* A slice is not a unit of work; the Principal PM draws one and cuts
  it into one or more 根回し Nemawashi seeds (`SDD.md` § 8 and its header). So the SDD's slice
  granularity is not the granularity anything is built at, and a keep-or-re-cut question of this
  shape asks the owner to settle something a later stage re-settles anyway.
  **Routing note for the next `product-sdd` run — the owner's own:** *"this is a question that I
  think should not come to me."* Cut-granularity calls between two options that both pass the four
  tests are the seats' to make on the standing appetite above. Park an item for the owner when the
  answer changes what the product **promises**, not when it changes how the work is divided.

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
- **Keep or re-cut:** **Keep**, on the owner's standing rule rather than a fresh decision — this
  item is the same class as § 3.1 and was **not put to the owner again**. Both cuts pass the four
  tests, neither changes what the product promises, and the Principal PM re-slices whatever the SDD
  draws (`SDD.md` § 8), so the choice does not survive to the build as stated.
  This item's own text reaches the same place from the other side: *"the CPO reads the split as a
  task inside a slice, not a decision."* Where a seat can already see that, it should decide.
  **Applied appetite:** smaller rather than larger, but not too small. Keeping one slice here is
  consistent with it, because the default set already requires the topology drawn — splitting the
  branch-set choice out would leave a second slice whose whole content is one control.
  See § 3.1 for the owner's routing rule in full: park an item for the owner when the answer changes
  what the product **promises**, not when it changes how the work is divided.

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
- **Keep or re-cut:** **Re-cut** — take the alternative. *"let's go with v1."* The first public
  release waits for the **full v1 cut** the PRD names, so the first thing a stranger meets is the
  product `docs/PRD.md` calls v1, not a partial. `pick-it-up-release` moves to after the v1 slices
  in § 7 rather than sitting among them.
  **The consequence the owner accepted, recorded so the SDD does not have to rediscover it:** the
  acquisition-path decision (SRS C-3, RN-12) is proved later, after the slices built on the runtime
  it constrains. That matters more than it did when this item was drafted, because § 1.1 has since
  been answered **unsigned** — and `SDD.md` § 11 R-8 makes the sandbox probe a **release gate**, a
  bundle failing it not being published, with enforcement under an ad-hoc signature still an Open
  Question.
  **A mitigation for the CTO, not a question for the owner:** publishing late does not require
  *verifying* late. The bundle, the entitlement list and R-8's probe (`codesign -d --entitlements`)
  can be proved on an unpublished artifact as early as the runtime exists, so the release gate is
  not first exercised at the moment the first release is due. How and where that check sits is the
  SDD's to place.
  **Owner-directed note — fix the stale part of this item when folding it.** *The cut as drafted*
  above describes the value as a stranger reading *"a file of their own **repository**"*. The input
  widened while this station was parked: `docs/PRD.md` v11 takes **a local folder, a Git repository
  or not**, and `docs/SRS.md` v8 FR-1 carries it. Read it as **folder** and correct the wording on
  the fold.
  **And it is not only this line.** This whole companion, and `SDD.md` run 1 itself, were written
  against the older definition set — PRD v9, SRS v7, UXD v5, DESIGN v4, CONTENT v3. All five have
  since moved (v11, v8, v6, v5, v4). So the fold owes a sweep, not a single correction. The one
  that is load-bearing rather than cosmetic: **`SDD.md` § 4 C-R3 still reads "Pointed at something
  that is not a repository, the window shows UX-S4", with a violation clause against any slice that
  does otherwise.** That is now backwards — `docs/UXD.md` v6 narrows UX-S4 and makes the plain
  folder a working state whose Git view shows nothing (UX-I17). `read-a-repository` is likewise a
  slice named and scoped around an input that widened. Correct against the current documents rather
  than against this companion's own prose, which is the older set's.

---

## 4. Disagreements — two seats hold different positions and neither yields

*(none yet)*
