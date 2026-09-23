# SDD open issues — Nozoki

> Companion to `SDD.md`. Three seats — the CTO, the CPO and the CDO — authored the SDD
> non-interactively in one run; this file holds what that run could not settle from its inputs (the
> PRD, the SRS, the UXD, and any context or constraints).
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time the seats fold them in, they first copy this file
> whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a disagreement is not something one seat asked, it
> is something two seats answered differently, and the answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the run entirely.** §§ 1–4 are all the SDD's own three seats;
> § 5 is a seat that never wrote the SDD, reading it long after it settled and finding something
> only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's, which stay fixed
> to the three authoring seats on purpose.

> **The cycle-8 item this file carried (§ 5.1, the owner's no-network ruling) is folded and on the
> trail** (`docs/trail/sdd/cycle-8.md`; `SDD.md` § 4 C-R2, C-I3; § 10 RC-2; RN-51, RN-52). The
> ruling's answer 3 asked for the mechanism before any entitlement was chosen; the mechanism is
> found, and it is not a configuration — which leaves the one question below, raised by the CTO,
> that the ruling did not decide.

---

## 1. Open issues — questions with no answer yet

### 1.1 Under C-R2's rule the system WKWebView cannot start — so the renderer gives way, or the rule's reach does, and which is yours
- **Raised by:** CTO
- **Why it matters:** `SDD.md` § 4 C-R1 renders `nozoki-ui` in the system WKWebView (ADR-0002);
  § 4 C-R2 now states your rule — no network entitlement, ever. WKWebView's own processes refuse to
  start under that rule: WebKit checks the *host's* entitlements at each XPC service's start, and
  a sandboxed host without `com.apple.security.network.client` fails the check unless its sandbox
  allows a `mach-lookup` of `com.apple.nsurlsessiond`
  (https://github.com/WebKit/WebKit/blob/bb75cbc0003033ea73c42ef02370767aa52d6ba6/Source/WebKit/Shared/EntryPointUtilities/Cocoa/XPCService/XPCServiceEntryPoint.mm,
  `checkEntitlements`; WebKit's comment on the line: "This requirement is too strict, it should
  be possible to load file:// resources without network access", open since 2019 as
  `rdar://problem/54178641` / FB6993802). On your Mac the unified log shows exactly that: in both
  of your 2026-09-23 sampling windows, `com.apple.WebKit.Networking` logs `Application does not
  have permission to communicate with network resources` and is relaunched every 15–30 ms under
  the running `nozoki-app` (`SDD.md` RN-52 carries the command and the lines). No Tauri key, no
  WebKit setting and no line of this product's reaches the check, so answer 3's "if the fix needs
  no entitlement, the list stands" does not decide this case. Where it bites: § 2's shape (row 1
  taken, row 4 the runner-up), § 3 `surfaces` and `SM-4`, § 4 C-R1, C-R2, C-R7, C-D3; § 6
  `open-a-folder`, whose command bar no build can meet until this is answered, and every later
  slice rests on it (§ 7). The exits, priced:
  - **(a) The renderer leaves WKWebView** — a single-process view under the same sandbox: § 2's
    row 4 (AppKit / SwiftUI), or a Rust-native toolkit so the host language stays one. Keeps the
    wall as you ruled it. Loses the renderer wall — the process that holds no capability (§ 9
    TO-1) — with the IPC seam collapsing to direct calls, priced cheap in § 2 *Undoing it*. Costs
    every surface rewritten (`surfaces`; priced expensive there), the design language re-expressed
    off CSS (`docs/DESIGN.md` — the CDO's to weigh), Markdown rendered without a web engine
    (FR-30; C-D3's three walls redrawn for a native renderer), ADR-0002 superseded, and
    `docs/fdr.md` PD-29's "not replaceable inside the terminus" reversed.
  - **(b) Grant `com.apple.security.network.client`** — the window draws today (your sample
    table, cycle-8). Refused by your answer 1; listed so (a)'s price is seen against it.
  - **(c) Grant only the mach-lookup WebKit's check names** —
    `com.apple.security.temporary-exception.mach-lookup.global-name` for `com.apple.nsurlsessiond`.
    Unmeasured: whether WebKit then runs, and whether `checks/bundle.sh` still reports the
    outbound connection denied. The CTO reads it as a network entitlement under another name —
    the service it opens is the one WebKit treats as network access — and so as refused by
    answer 1; it is listed so that refusal is yours and not assumed.
  - **(d) Drop the sandbox** — refused in cycle-1
    (`nozoki@70a879a:docs/trail/sdd/cycle-1.md` § 2.3).
  - **(e) Wait for Apple** — WebKit's own FIXME says the check goes "once WebKit can work without
    network access"; the radar is from 2019 and carries no date.
  **The CTO's position: (a).** The wall is the product — § 1's first question, and the Way this
  instance holds a "never" by structure — and the renderer wall was always the cheaper of the two
  to lose: § 2's row 4 says so, and the runner-up was rejected only on the cost of re-expressing
  the design language, a cost now weighed against the product not running at all. Which native
  technology, and what the seams become, is § 2's weighing to redo once (a) is chosen; it is not
  asked here. The CDO's half — whether the design language survives re-expression, and what
  UX-I12's rendered Markdown becomes — is the CDO's to add to this item.
  **The ground for refusing (c), corrected — added by the CTO at run 11, round 1.** The (c)
  bullet above gives this seat's first reason — "the service it opens is the one WebKit treats as
  network access" — and that reason does not hold as stated: `checkEntitlements` uses the
  `mach-lookup` of `com.apple.nsurlsessiond` as a stand-in for the question and opens nothing by
  itself (`Source/WebKit/Shared/EntryPointUtilities/Cocoa/XPCService/XPCServiceEntryPoint.mm:L52-L64`
  at `bb75cbc0003033ea73c42ef02370767aa52d6ba6`, the commit this item cites). What passing the
  check does is start WebKit's Networking process, and that process's network access is its own,
  not the host's: its sandbox profile allows `(remote tcp)` and `(remote udp)` unless the
  `BlockNetworkAccess` state flag is set
  (`Source/WebKit/NetworkProcess/mac/com.apple.WebKit.NetworkProcess.sb.in:L492-L496, L563-L568`),
  and the flag is set only by `blockNetworkAccessIfNeeded` — which on macOS returns early unless
  the linked-on-or-after check for `NetworkProcessInheritsNetworkAccessFromUIProcess` passes, and
  otherwise sets the flag when `sandbox_check_by_audit_token` reports the host's `network-outbound`
  denied (`Source/WebKit/NetworkProcess/cocoa/NetworkProcessCocoa.mm:L90-L121`; enabled for Cocoa
  at `Source/WTF/wtf/PlatformEnableCocoa.h:L1214-L1216`). That inheritance reached macOS in WebKit
  on 2026-08-22 — `cb7daacd43`, "[macOS] The Networking process sandbox should inherit network
  access from the UI process" — after the general change of 2025-12-10, `e0e27e741c`. The
  renderer is the *system* WKWebView (`SDD.md` § 4 C-R1), so the WebKit a user runs is the one
  their macOS ships, and C-R5's floor is 14.0: on any macOS whose WebKit predates that change, a
  page under (c) sits behind a Networking process the operating system lets connect, and only
  C-R7's CSP would stand between it and the network — a promise the code keeps, which your
  answer 1 rules out. And C-I3 would not see it: `checks/bundle.sh` asks the operating system
  about the *host's* pid, which stays denied under (c), so the probe goes green with the gap
  behind it. So (c) is refused for what runs behind the check, not for the service's name; the
  refusal is still yours to make. Under (a) the same fact is a gain the positions on this item
  did not state: a native view starts no second process with a network profile of its own, so
  the host's missing entitlement covers the whole product and the host-pid probe covers all of
  it. What this seat does not know is which macOS release first ships the inheritance; the check
  that would find it is `log show --predicate 'eventMessage CONTAINS "block network access"'` on a
  (c)-signed bundle on the floor OS — owed only if you read the ruling as leaving (c) open, and
  then measured before (c) is chosen, from inside the page with the CSP loosened in a throwaway
  build, so that what refuses the fetch is the operating system and not the CSP. The reading is
  `docs/trail/sdd/self_answer-19.md` § *Left for the owner*'s; every source it names was re-read
  at the cited commit for this addition.
  **The CDO's position: (a), on the design's own grounds — and the price § 2 row 4 put on it is
  smaller than priced.** Three things are true of what (a) costs the experience:
  - **The design language survives as values; one sentence of it does not.** Every token
    `docs/DESIGN.md` fixes is a value — a hex colour, a pixel size, a weight, a line-height, a
    radius, a 4px rhythm (§ Colors, § Typography, § Layout, § Shapes) — and the language was
    drawn to look like the platform from the start: "it starts from what a stock Mac already
    draws: the platform's own fonts, its own text sizes, its own flat list rows" (§ Overview);
    a row's selection runs edge to edge "the way a Finder list row does" (§ Shapes); no shadow
    but one, no focus ring, no accent (§ Elevation & Depth, RN-2). A native renderer draws that
    directly. What does not carry is the realisation sentence — "realised in plain CSS custom
    properties over the product's own markup" (§ Overview; RN-1) — the CSS font-stack syntax
    the frontmatter uses to name the system fonts (`-apple-system, system-ui`;
    `ui-monospace, "SF Mono", Menlo`, § Typography), and RN-1's "the runtime — a browser tab or a
    native window — is the SDD's; every value here is a CSS value and holds in either", which
    was written when both runtimes drew CSS and does not cover (a). Those move in `DESIGN.md`'s
    own run, which is licensed to trail this document
    (`<CORE>/roles/loaders/cdo_global.md` § *Output*: "`DESIGN.md` may trail the SDD, and the UXD
    may not"). No value moves; every `{components.*}` contract is re-mapped to a native view
    with the same numbers. The UXD names no renderer and no CSS — § 9's direction is "no
    established component design system… the platform's own controls and appearance are the
    starting point" — so the UXD stands at v10 under (a), and so does this document's § 4 CDO
    clause: C-E1 – C-E10 bind observations and tokens, not a web engine. (§ 2 row 4 attributes
    "CSS tokens over the product's own markup" to `docs/UXD.md` § 9; the sentence is
    `docs/DESIGN.md` § Overview's and RN-1's — a citation the CTO's row should re-point.
    *Re-pointed at v11, RN-55; the parenthesis stands as it was written.*)
  - **UX-I12 does not move; what moves is who has to meet it.** Rendered by default, nothing
    fetched from outside the folder, three image cases — in-folder in place, outside-the-folder a
    stated not-fetched placeholder *where it would appear*, broken-inside a stated placeholder,
    never a broken-image glyph — and a link shown with its destination readable
    (`docs/UXD.md` UX-I12) are the requirement whichever engine renders. `docs/DESIGN.md`'s
    contract for them stands unchanged too: `{components.prose}` at the 44rem measure, three
    heading levels distinct and h4–h6 collapsed to `prose-h3` muted, inline and fenced code on
    `{colors.canvas}`, the link's text underlined with its destination in `{typography.path}` on
    the same line, the in-folder image at its own size and no wider than the measure, the
    placeholder a bordered box holding alt text and source (§ Components "Rendered Markdown";
    § Typography). Under (a) a native renderer must produce every one of those cells from the
    Markdown source without a web engine, and two of them are where the cost sits: block-level
    layout a text view is not born doing — an image or its placeholder box *in the flow of the
    prose*, and code on its own surface inside prose — and the six bundled grammars the code
    treatment shares with the highlighter (§ 3 `surfaces`). Which native technology meets them,
    and whether FR-31's raw-source switch still "costs nothing" once rendered Markdown itself is
    dearer, is § 2's re-weighing (the CTO's; `docs/SRS.md` FR-31 leaves that judgment to this
    document). The bar is not lowered by the exit: a native renderer that shows a glyph for a
    missing image, or a link without its destination, violates UX-I12 the same way a web one
    would. One cell gets cheaper: "rendering fetches nothing from outside the folder" stops
    being a policy the reviewer trusts (C-R7's CSP) and becomes the wall the host already holds
    — a single-process view under a host with no network entitlement has no fetch to forbid
    (C-D3's redraw, the CTO's).
  - **Why (a) and not the exits that keep WKWebView.** From this seat: a renderer that draws only
    under the entitlement the owner refused is a renderer this design cannot be shown on, and a
    language drawn to look native is shorter to draw natively than § 2 row 4 priced when it
    called that "a second design language". (c) would keep `DESIGN.md` byte-for-byte as written
    — the one exit with no design cost at all — and this seat's reading of it follows the CTO's,
    which moved at run 11 (the CTO's addition above): refused not for the service's name but for
    what passing the check starts — a Networking process with a network profile of its own, which
    the host's missing entitlement does not reach on a WebKit before 2026-08-22, and which
    C-I3's host-pid probe would not see. The corrected ground moves nothing on the design side:
    (c)'s design cost stays nil, and the refusal is yours. *(This sentence read "as the CTO does,
    a network entitlement under another name" until run 11, round 1 — the ground the CTO
    withdrew; RN-57.)* Two costs of (a) named so they
    are not found later: the highlighter and every `{components.*}` contract re-expressed in
    § 3 `surfaces`; and `README.md` § Stack states "the system WKWebView" and "styled in plain
    CSS custom properties" (`README.md:L48-L49`), a public surface that under (a) tells a truth
    the product no longer has (§ 4 C-E10) — the CPO's to move with the README.
  **The CPO's position: (a) — and the cut does not move with it.** Four things from the value
  seat, each sourced:
  - **Nothing the product promises names a renderer.** `docs/PRD.md` § Dependencies /
    Integrations names the filesystem and Git and nothing else; no PRD section names WKWebView,
    Tauri or CSS (`grep -n -i 'webview\|tauri\|css' docs/PRD.md` returns nothing, 2026-09-23),
    and the Agari's three conditions name none (`system/projects/nozoki/agari.md`). So (a)
    changes nothing a stranger was promised and opens no PRD gap — the PRD stays at v15 under
    every exit, and `SDD.md` § 12's PRD boundary now says so.
  - **What (a) costs in product terms is a date, not a surface.** Every slice rests on
    `open-a-folder` (`SDD.md` § 7), so the first public release moves later, not smaller. The
    cut holds: § 5 step 1's entries were made from behaviour and never from the boxes, so E-1 –
    E-11, the eleven slices, their slugs, *Delivers*, fences and PRD traces stand whatever
    draws them. One sizing this seat re-checks once § 2 is redrawn, and only then:
    `read-markdown`, whose decision — three walls hold against untrusted content — becomes part
    structure under a single-process view (no script engine to wall off) and part layout
    (UX-I12's cells, as the CDO prices them). It stays a slice of its own and not a share of
    `read-a-file`, for the reason step 4 already gives: merged, an intermediate result (files
    read, Markdown not yet right) would change its acceptance.
  - **(b) and (c) fail the same product test, whatever the probe reports.** The promise is what
    a stranger can *show*: § 2's taken row answers § 1's first question "with an entitlements
    file a reviewer reads (`codesign -d --entitlements`)". An entitlement on that file naming
    `com.apple.nsurlsessiond` — the network daemon — is one the README would have to explain
    away, and "we hold a network exception but never use it" is the promise the code keeps,
    which your answer 1 ruled out (`docs/trail/sdd/cycle-8.md` § 5.1). So this seat reads (c)
    as refused for the product reason (b) is, not only the technical one; the refusal is yours.
    *(Run 11, 2026-09-23 — "whatever the probe reports" now has a measured meaning, and it
    reaches a second public sentence. The CTO's corrected ground above — under (c) the page sits
    behind a Networking process the operating system lets connect, and C-I3's host-pid probe
    goes green without seeing it — makes `README.md:L50-L51` false on a (c)-signed bundle: "A
    shell harness under `checks/` proves the read-only and no-network promises on every build"
    would be a README claim the harness cannot back, and in this instance a public claim the
    tool does not keep is a release-blocking defect, not a docs chore. So (c) fails the product
    test twice — on the entitlements file a reviewer reads, and on the proof sentence a stranger
    trusts — and the words above stand as written.)*
  - **(e) is not an exit.** The Agari's third condition — public, at 1.0.0 or later, by the README
    alone — cannot be reached by a product whose first window waits on a radar open since 2019
    with no date on it.
  Two costs of (a) this seat owns and names now: `README.md:L48-L49`'s stack sentence moves with
  the README when (a) lands — a public surface, not this document's — and the first-release date
  the owner has been counting toward moves out by the rewrite of `surfaces`.
- **Answer:** <the owner fills this in>

## 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override

> **No `product-sdd` run wrote this item. A `companion-self-answer` run raised it on 2026-09-23**,
> while answering § 1.1 above. That run read `SDD.md` whole, and this is a line in it that no
> item asked about. **The CTO drafted it into `SDD.md` at run 11, round 1** (`SDD.md` RN-56); the
> slot below is the owner's.

### 2.1 C-I3 names ADR-0008 as its record, but ADR-0010 superseded ADR-0008 on 2026-09-19
- **Raised by:** the `companion-self-answer` run, 2026-09-23 — not one of the SDD's three seats
- **Drafted into the SDD:** In § 4 C-I3, "The record is ADR-0008" now reads "The record is
  ADR-0010" (`docs/SDD.md:L620`). RN-11's "The record is ADR-0008" and RN-45's "still state the
  marker" (`SDD.md` § SDD Review Notes) are left as they are: a note is dated history, and each was
  true when written. One sentence found on the same walk moved with it: § 10 RC-1's *Changed* said
  ADR-0008 and QC-25 "still state the marker", true on 2026-09-19 and not since; it keeps its
  words and gains a dated parenthesis naming ADR-0010 and `docs/nfdr.md:L246-L252` (RN-56). C-I3
  claims no record for the renderer gate it gained at v11 — that is the Principal Architect's, per
  *If overridden* below.
- **Rationale:** ADR-0008's status reads "Superseded by ADR-0010"
  (`docs/adr/0008-harness-over-core-and-bundle-probe-from-first-build.md:L3`). ADR-0010 says
  "supersedes ADR-0008" (`docs/adr/0010-harness-over-core-and-bundle-probe-reads-the-os-sandbox-report.md:L3`),
  and the index shows the same (`docs/adr/README.md:L25-L27`). C-I3 is a live condition. Its own
  text already describes ADR-0010's observable, the operating system's sandbox report and not
  ADR-0008's environment marker (§ 10 RC-1). So its citation points at a record that is no
  longer in force. A reader who follows it reaches the marker that RC-1 says was dropped. This is a
  claim about another document that is now false. It costs no extra cycle, because it rides the
  fold § 1.1 already owes.
- **If overridden:** C-I3 keeps pointing at a superseded record, and nothing else moves. Whichever
  record carries the new renderer gate is the Principal Architect's to decide
  (`docs/architecture_open_issues.md` § 2.1). If a new record supersedes ADR-0010 for that gate,
  this citation moves again at that fold.
- **Confirm or override:** confirm — the draft holds as it stands: `docs/SDD.md:L620` now names
  the record in force, and RC-1's dated parenthesis is true against `docs/nfdr.md:L246-L252`.
  Decided in the owner's seat by a `companion-self-answer` run, 2026-09-23; the reasoning is
  `docs/trail/sdd/self_answer-20.md` § 2.1.

> **No `product-sdd` run wrote this item either. A `companion-self-answer` run raised it on
> 2026-09-23** while it answered §§ 1.1 and 2.1 above. That run read `SDD.md` whole at v12 and found
> § 10 RC-2 still giving the reason for refusing (c) that the CTO withdrew at run 11 (RN-56). No item
> asked about it. **Nothing is drafted into the SDD.** This run writes no document, so the slot below
> is the owner's, and the change is the CTO's to draft on the fold.

### 2.2 § 10 RC-2 still gives the reason for refusing (c) that the CTO withdrew at run 11
- **Raised by:** the `companion-self-answer` run, 2026-09-23 — not one of the SDD's three seats
- **Drafted into the SDD:** Nothing yet. The proposed change: in § 10 RC-2's *Observed reality*,
  the sentence "which this seat reads as a network entitlement under another name: the service it
  opens is the one WebKit's own check treats as network access" (`docs/SDD.md:L2053-L2055`) keeps
  its words. It gains a dated parenthesis, the shape RC-1's *Changed* took at v12 (RN-56). The
  parenthesis says the ground was withdrawn at run 11 and names the corrected one: the
  `mach-lookup` is only a stand-in in `checkEntitlements` and opens nothing by itself. What passing
  it starts is WebKit's Networking process, whose own sandbox profile allows outbound TCP and UDP
  unless `BlockNetworkAccess` is set. The parenthesis points at RN-56 and the companion's § 1.1
  rather than restating the WebKit citations. RN-52's matching sentence (`docs/SDD.md:L2973-L2976`)
  stays as it is, because a note is dated history (RN-55).
- **Rationale:** RC-2 is the record a reader opens to learn why (c) is refused. It still gives the
  reason the CTO has said "does not hold as stated" (companion § 1.1, the CTO's run-11 addition;
  RN-56). Three sources confirm the withdrawal. WebKit's check performs no lookup. It asks the
  sandbox whether the host *may* look up `com.apple.nsurlsessiond`, with `SANDBOX_CHECK_NO_REPORT`
  (`Source/WebKit/Shared/EntryPointUtilities/Cocoa/XPCService/XPCServiceEntryPoint.mm`, WebKit
  `bb75cbc0003033ea73c42ef02370767aa52d6ba6`, unchanged on `main`, re-read 2026-09-23). The
  Networking process sets `BlockNetworkAccess` only from the host's `network-outbound` state, and
  on macOS only past a linked-on-or-after check (`NetworkProcessCocoa.mm:L90-L121` at the same
  commit). The CDO's and the CPO's positions have both moved to the corrected ground (RN-57,
  RN-58). RC-2 is the one place in the document that still carries the old one. It costs no
  extra cycle, because it rides the fold § 2.1's answer already owes.
- **If overridden:** RC-2 keeps giving a ground its own author withdrew. A reader who follows it
  there, rather than to the companion, would refuse (c) for the service's name. The owner's
  choice on § 1.1 does not move either way, because every seat now refuses (c) on the corrected
  ground.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">
