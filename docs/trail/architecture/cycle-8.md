# Architecture open issues — KA-Reader

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the SRS, the SDD
> and the FDR.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-architecture`. It folds your answers into the records and drops the resolved items.
> When nothing is left open, `product-architecture` **deletes this file**: no file = the records are
> done.
>
> Your answers are never thrown away. Each time the Principal Architect folds them in, it first copies
> this file whole to `docs/trail/architecture/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 is raised, not asked.** These records bind every later change, so the seats that live under
> them find gaps the authoring run could not. § 3 is where such a seat says so, against both records
> — an ADR's binding and an NFDR obligation reach the same file.

> **How this companion came to exist.** No `product-architecture` run opened it. A
> `companion-self-answer` run opened it on 2026-09-23 (`ka-reader@a9f1b8a`), while answering
> `docs/SDD_open_issues.md` § 1.1: both records were Settled at NFDR v9 with no companion on disk,
> and without one a re-run would have read them as done. It held one § 2 item, proposed and not
> drafted. **The first `product-architecture` run after it (NFDR v10, 2026-09-23) drafted that item
> into the records** — two records at Proposed, QC-25 re-derived, QC-62 added — and raised § 2.2 on
> what it deliberately did not do. Both slots are yours.

---

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 QC-25 and ADR-0003 state C-R2's entitlements as *exactly* a list; the SDD binds a rule, and a renderer gate beside the wall probe
- **Lands in:** both — `nfdr.md` QC-25, QC-62 and § 10; `adr/0011-app-sandbox-wall-under-a-rule-no-network-entitlement-ever.md`
  (superseding ADR-0003 — the log is append-only); `adr/0012-renderer-run-proved-on-the-shipped-bundle-beside-the-wall.md`.
- **Drafted into the records:**
  1. **ADR-0011, Proposed** — restates ADR-0003's decision whole with the owner's rule in place of
     *exactly* the list (`docs/trail/sdd/cycle-8.md` § 5.1, answers 1–2; `docs/SDD.md` § 4 C-R2 at
     v12): no network entitlement of any kind, the mach-lookup exception named as refused; the
     read-only grant; any other entitlement only with a record and only where the probe still finds
     the wall. It supersedes ADR-0003 **on acceptance**: ADR-0003's Status line, the index's row for
     it, and the six entries that cite it beside QC-25 (QC-2, QC-32, QC-33, QC-35, QC-49, QC-58, and
     § 2's third trust boundary) are untouched until your confirm turns it, because a record in
     force is cited until it is not.
  2. **ADR-0012, Proposed** — the renderer gate's own record: `checks/renderer.sh`, the launched
     main process observed inside `open_folder` within a bounded window, read from the operating
     system or the process and never from a marker the product writes, its renderer-removed control
     red, after `checks/bundle.sh` and never instead of it (`docs/SDD.md` § 4 C-I3 at v12; the
     owner's answer 4). Its own record and not a clause of ADR-0011, because the two have different
     lifecycles — the rule stands if the gate's mechanism is replaced, and the gate stands if a
     fourth entitlement is ever recorded — and not a superseding of ADR-0010, whose observable has
     not moved and which nothing reverses.
  3. **QC-25** — the obligation states C-R2's rule in place of the list; the tail states two halves:
     (1) `checks/bundle.sh`'s set equality against the set the script expects
     (`checks/bundle.sh:L127-L128`) and the sandbox probe as before, now with C-I3's v9 scoping of
     which lines print the bound (SDD RN-50); (2) the widening of the script's expected set reviewed
     as code in the same change against the rule — a network entitlement or an exception reaching
     the network under another name refused whatever record claims it, and every other key owed a
     record in `docs/adr/` — a class-2 half, argued in the tail.
  4. **QC-62** — the renderer gate as an obligation, in § 2 beside QC-25, with a § 10 row and
     `checks/renderer.sh` in § 9's layer-5 row; its mechanism marked as written against the
     WKWebView renderer and re-derived when the SDD carries the renderer your § 1.1 answer moves it
     to.
- **Rationale:** The NFDR is the enforcement store and is re-derived from SDD § 4 when the two
  disagree (`docs/SDD.md` § 4, opening note); they disagreed: QC-25 at v9 failed any bundle carrying
  an entitlement outside its three, which C-R2 permits with a record, and no entry carried the gate
  the owner added because a bundle passed every other one and drew an empty window (§ 10 RC-2).
  The rule is the owner's ruling and holds under every answer to the SDD companion's § 1.1 — which
  you have since answered, (a), the renderer leaves WKWebView (`ka-reader@5176475`); that answer is
  not yet folded into the SDD (C-R1 at v12 still names WKWebView), so the gate's mechanism is
  recorded as C-I3 states it today and marked as moving. **Inputs:** `docs/SDD.md` is Draft at
  v12; the house rule for a Draft input is derive and record, never halt
  (`<CORE>/doctrine/governance/unsettled_inputs.md`), and the NFDR's `Inputs read:` line says so.
- **If overridden:** the two Proposed records are revised or removed as you direct — nothing
  accepted was touched; QC-25 returns to *exactly* the list and the SDD stays in disagreement with
  its enforcement store, so a later entitlement C-R2 allows with a record fails QC-25's check; QC-62
  and its § 10 row go, and the renderer gate has no NFDR obligation until something else raises it.
  An override that keeps the drafts but moves the gate into ADR-0011, or into a record superseding
  ADR-0010, is one record's worth of rewriting at Proposed. Nothing else moves.
- **Confirm or override:** confirm, with one addition to QC-62. The two records and the two entries hold as drafted: ADR-0011 is the owner's cycle-8 rule, answers 1–2, restated whole. ADR-0012 and QC-62 are answer 4. QC-25's two halves are what "only with a record" requires. On acceptance, ADR-0003 is superseded and the seven sites that cite it move with it. **Addition:** QC-62's tail states that under the rule no bundle this product may ship reaches `open_folder` until the renderer leaves WKWebView (SDD § 10 RC-2). So the gate is red by construction until the replacement lands. That red is the gate working. It is never cleared by granting an entitlement or by skipping the script, and `checks/renderer.sh` lands with the replacement renderer or after it. Decided in the owner's seat by a `companion-self-answer` run, 2026-09-23; the reasoning is `docs/trail/architecture/self_answer-11.md` § 2.1.

### 2.2 ADR-0002 is not superseded, and QC-21 stands, on your SDD-companion answer alone — the record lands when the SDD carries the replacement renderer
- **Lands in:** `adr/` — a record superseding ADR-0002 (the system WKWebView); `nfdr.md` QC-21 (no
  swap invariant for the renderer technology).
- **Drafted into the records:** Nothing lands. Your answer on `docs/SDD_open_issues.md` § 1.1 —
  **(a), the renderer leaves WKWebView** (`ka-reader@5176475`; the file at `ka-reader@a1d8f2c`) — is an
  authorized decision that outranks every document, and it reverses ADR-0002's renderer half and
  `docs/fdr.md` PD-29's "not replaceable inside the terminus". This run writes no superseding
  record for it and leaves QC-21 as written, dated; NFDR RN-21 records the wait and why.
- **Rationale:** A record superseding ADR-0002 restates the runtime decision whole — the host, the
  renderer, the seams — with its alternatives weighed and its consequences priced, and the SDD has
  not yet decided what the renderer becomes: "which native technology to use, and what the seams
  become, is § 2's weighing to redo" is your own answer's last sentence, and § 4 C-R1 at v12 still
  renders in WKWebView. A record written now would carry a hole in its § Decision and an
  § Alternatives ruled out nobody has weighed, which the recording lens forbids (a decision not
  fully reconstructed is not filled in). QC-21 traces to PD-29 and ADR-0002, both still in force;
  it is re-derived when the FDR and the SDD move, and a delivery reader who meets it before then
  finds RN-21 beside it saying the owner has reopened the renderer. The `product-sdd` run your
  three answered SDD-companion items already owe is where the replacement is decided; this log
  follows it.
- **If overridden:** a record superseding ADR-0002 lands now at Proposed, recording (a) with the
  replacement stated as "the SDD's § 2 to weigh", the exits (b)–(e) as its alternatives from the
  SDD companion's § 1.1, and its consequences as the three seats priced them; it is superseded in
  its turn when the SDD lands the replacement — two records where one would do. QC-21 would then
  read that the renderer technology is being replaced once, on the owner's ruling, and is
  otherwise not replaceable inside the terminus. Nothing else moves.
- **Confirm or override:** confirm, with one addition. No record supersedes ADR-0002 until the SDD carries the replacement renderer, and QC-21 stands with RN-21 beside it. There is one more reason to wait: exit (a) on the SDD companion also costs the renderer wall and C-D3's three walls. So the superseding record may reach ADR-0001's and ADR-0006's renderer halves too, which only the SDD's § 2 re-weighing can say. **Addition:** QC-21 waits on PD-29, and the FDR had no companion to carry the change. It is now raised at `docs/fdr_open_issues.md` § 2.1 (`ka-reader@f5cddef`). Decided in the owner's seat by a `companion-self-answer` run, 2026-09-23; the reasoning is `docs/trail/architecture/self_answer-11.md` § 2.2.

> **No `product-architecture` run wrote § 2.3. A `companion-self-answer` run raised it on
> 2026-09-23** while answering `docs/SDD_open_issues.md` § 2.3. That run read `SDD.md` whole at v13
> and found § 10 RC-3 stating that the SDD "owes the decision log superseding records" and "the
> enforcement store a re-derivation of every entry written against the previous shape", and naming
> both as the Principal Architect's. No companion carried that. §§ 2.1 and 2.2 above are both
> answered, so the next fold would clear this file and leave the records reading done.

### 2.3 The SDD at v13 carries the replacement renderer (§ 10 RC-3), and four records and the entries written against the previous shape have not seen it
- **Lands in:** both. `adr/` gets records superseding ADR-0001 (the two-process shape), ADR-0002
  (Tauri, WKWebView, the view's language), ADR-0006 (the host sanitizer and the asset scheme) and
  ADR-0009 (the unit set), whether as four records or fewer is the Principal Architect's call.
  ADR-0012's mechanism, control and observable's name are re-derived. In `nfdr.md`, every entry
  that traces to those records or to the previous shape is re-derived: QC-21, QC-62, and the
  QC-23/QC-24 capability and CSP entries among them.
- **Drafted into the records:** Nothing. This item is proposed and not drafted. It was raised by a
  run that holds no posture on these records.
- **Rationale:** § 2.2's answer said "no record supersedes ADR-0002 until the SDD carries the
  replacement renderer". The SDD now carries it. `docs/SDD.md` § 2 takes the sandboxed
  single-process read pipeline (AppKit in Swift over `ka-reader-core`, reached through a C ABI, no web
  engine), and § 3 retires `ka-reader-app` and `ka-reader-ui` for `ka-reader-bridge` and `ka-reader-mac`. § 4
  C-R1, C-R7, C-I3 and C-D3 are re-derived. RC-3's *Changed* names the four records and the
  NFDR re-derivation as owed, and § 12's downstream boundary names the same departures (RN-60). Two
  answers already on this file now read against a moved input. § 2.1's addition says the renderer
  gate "lands with the replacement renderer or after it" and that QC-62's control is a
  "renderer-removed" build. C-I3 at v13 fixes the control as `checks/fixtures/idle-shell`, because
  "a single-process shell has no renderer build to remove". The NFDR is re-derived when § 4 and it
  disagree (`docs/SDD.md` § 4, opening note), and they now disagree. **Inputs:** `docs/SDD.md` is
  Draft at v13 while `docs/SDD_open_issues.md` § 2.3 folds. None of the RC-3 content depends on
  that item, which touches only C-R2's and C-I3's record lines. When to derive from a Draft input
  is `unsettled_inputs.md`'s and the Principal Architect's, not this item's.
- **If overridden:** the four records and the NFDR entries keep describing a Tauri host and a
  WKWebView renderer that the SDD no longer designs. A delivery reader who follows ADR-0002 or
  QC-21 builds the shape the owner's cycle-9 ruling retired. The SDD's RC-3 debt then has no
  channel, and the architecture records read Settled once this file clears.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">
