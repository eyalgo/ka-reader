# Architecture open issues — Nozoki

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

> **No `product-architecture` run opened this companion. A `companion-self-answer` run opened it on
> 2026-09-23**, while answering `docs/SDD_open_issues.md` (its § 1.1, the renderer under C-R2's
> rule). Both records are Settled at NFDR v9 and had no companion on disk. Without one, a
> `product-architecture` re-run would read them as done and find nothing to act on. The SDD itself
> names this change as owed to the Principal Architect and routes it nowhere (`docs/SDD.md` § 12,
> the downstream boundary; § 10 RC-2, *Still unresolved*). The companion holds one § 2 item,
> **proposed by that run and not drafted into either record** — its slot is the next round's.

---

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 QC-25 and ADR-0003 state C-R2's entitlements as *exactly* a list; the SDD now binds a rule, and a renderer gate beside the wall probe
- **Lands in:** both — `nfdr.md` QC-25 and § 10's QC-25 row; `adr/0003-app-sandbox-wall-and-open-panel-grant.md`
  (by a superseding record — the log is append-only); and whichever record carries C-I3's new
  renderer gate, which is the Principal Architect's to decide.
- **Drafted into the records:** Nothing yet — this run writes no record. The proposed change:
  1. **QC-25's first half and ADR-0003 § Decision re-derived from `docs/SDD.md` § 4 C-R2 at v11**
     (`docs/SDD.md:L434-L460`). Today QC-25 says "The bundle carries exactly the entitlements
     `com.apple.security.app-sandbox`, `com.apple.security.files.user-selected.read-only` and — once
     the folder selector exists — `com.apple.security.files.bookmarks.app-scope`; no other"
     (`docs/nfdr.md:L243-L245`), and ADR-0003 says "with **exactly these entitlements**"
     (`docs/adr/0003-app-sandbox-wall-and-open-panel-grant.md:L19`). C-R2 now binds the owner's
     rule instead: no network entitlement ever, including an exception entitlement that reaches the
     network under another name; a read-only grant on the chosen folder; any other entitlement only
     with a record naming its need, and only where the probe still finds the process sandboxed with
     both denials (`docs/trail/sdd/cycle-8.md` § 5.1, answers 1–2). The v1 members are unchanged.
  2. **C-I3's renderer gate given an obligation.** C-I3 at v11 adds `checks/renderer.sh`: the
     shipped bundle launched as a user launches it, the main process observed inside `open_folder`
     within a bounded window, and a negative control with the renderer build removed that must go
     red (`docs/SDD.md:L598-L626`; the owner's answer 4, `docs/trail/sdd/cycle-8.md` § 5.1). No
     NFDR entry and no § 10 row carries it. QC-25's tail was last re-derived from C-I3 at v8
     (NFDR v9 header).
- **Rationale:** The NFDR is the enforcement store and is re-derived from SDD § 4 when the two
  disagree (`docs/SDD.md:L411-L418`). They disagree now: QC-25 fails any bundle carrying an
  entitlement outside its three, which C-R2 permits with a record. QC-25 is also silent on the one
  gate the owner added because a bundle passed every other one and drew an empty window
  (`docs/SDD.md` § 10 RC-2). This is a fact in a settled record that is now false, which is worth a
  cycle on its own. **Inputs:** `docs/SDD.md` is Draft at v11. It stays Draft only because its
  companion § 1.1 is open (which renderer gives way). C-R2's rule is the owner's ruling and holds
  under every answer to § 1.1. The renderer gate is written against the WKWebView renderer
  (`nozoki-ui/src/main.ts:L14-L19`), and its mechanism and control may move if § 1.1 takes the
  renderer out of WKWebView. Re-deriving now follows the house rule for a Draft input — derive and
  record, never halt. Waiting would leave QC-25 refusing what C-R2 permits for as long as § 1.1 stays
  open.
- **If overridden:** QC-25 and ADR-0003 keep *exactly*, and the SDD stays in disagreement with its
  enforcement store. A later entitlement that C-R2 allows with a record fails QC-25's check, and the
  renderer gate has no NFDR obligation until something else raises it. Nothing else moves.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">
